Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DB44B2C12
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352320AbiBKRuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:50:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352312AbiBKRuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:50:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 672F8CD5
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644601820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Hn1xDQoeiLpTSIhM8/h1rThLCr1DJa0iuo/gm7gs9Jo=;
        b=ANWfXIrUdSd+Bx7iMEHdR9ZhOl/VbF3mxijdH75XxDCdLArBsrt3yDV336sB5+TaJc7k5o
        TbYn+2p+yr6Ziabh7tDMv/ndk5coHY0OWpaSxwXj1nH8x2goBb4Os6SgO3SZVv8ZJvdYLE
        4SIpptQqZdiXUinSukXs3qqPoj2FNDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-X4GKVnc3P7iC5l6lSzo39A-1; Fri, 11 Feb 2022 12:50:19 -0500
X-MC-Unique: X4GKVnc3P7iC5l6lSzo39A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64B6746860
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 17:50:18 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF55070D45;
        Fri, 11 Feb 2022 17:49:59 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8F6DC418853D; Fri, 11 Feb 2022 14:49:37 -0300 (-03)
Date:   Fri, 11 Feb 2022 14:49:37 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>
Subject: [PATCH] KVM: x86: fix hardlockup due to LAPIC hrtimer period drift
Message-ID: <YgahsSubOgFtyorl@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A hard lockup has been observed with long running KVM guests that
use periodic timers:

UPTIME: 723 days, 17:47:41

PID: 514319  TASK: ffff99ed8d709070  CPU: 62  COMMAND: "CPU 0/KVM"
 #0 [ffff9a663fb08980] machine_kexec at ffffffff84065b24
 #1 [ffff9a663fb089e0] __crash_kexec at ffffffff84122342
 #2 [ffff9a663fb08ab0] panic at ffffffff84774972
 #3 [ffff9a663fb08b30] nmi_panic at ffffffff8409b6af
 #4 [ffff9a663fb08b40] watchdog_overflow_callback at ffffffff8414eb81
 #5 [ffff9a663fb08b58] __perf_event_overflow at ffffffff841a8277
 #6 [ffff9a663fb08b90] perf_event_overflow at ffffffff841b1a14
 #7 [ffff9a663fb08ba0] handle_pmi_common at ffffffff8400ac70
 #8 [ffff9a663fb08de0] intel_pmu_handle_irq at ffffffff8400af4f
 #9 [ffff9a663fb08e38] perf_event_nmi_handler at ffffffff84784031
#10 [ffff9a663fb08e58] nmi_handle at ffffffff8478593c
#11 [ffff9a663fb08eb0] do_nmi at ffffffff84785b5d
#12 [ffff9a663fb08ef0] end_repeat_nmi at ffffffff84784d9c
    [exception RIP: rb_erase+849]
    RIP: ffffffff84389a91  RSP: ffff9a663fb03ec8  RFLAGS: 00000046
    RAX: ffff9a663fb15f40  RBX: ffff9a8e3daa5610  RCX: 0000000000000000
    RDX: ffff9a663fb15f40  RSI: ffff9a663fb159b0  RDI: ffff9a8e3daa5610
    RBP: ffff9a663fb03ec8   R8: 0000000000000000   R9: 0000000000000000
    R10: 00000000000000e0  R11: 0000000000000000  R12: ffff9a663fb159b0
    R13: ffff9a663fb15960  R14: 0000000000000000  R15: ffff9a663fb15a98
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <NMI exception stack> ---
#13 [ffff9a663fb03ec8] rb_erase at ffffffff84389a91
#14 [ffff9a663fb03ed0] timerqueue_del at ffffffff8438bfe4
#15 [ffff9a663fb03ef0] __remove_hrtimer at ffffffff840ca08f
#16 [ffff9a663fb03f20] __hrtimer_run_queues at ffffffff840ca5c5
#17 [ffff9a663fb03f78] hrtimer_interrupt at ffffffff840cab4f
#18 [ffff9a663fb03fc0] local_apic_timer_interrupt at ffffffff8405c60b
#19 [ffff9a663fb03fd8] smp_apic_timer_interrupt at ffffffff847929d3
#20 [ffff9a663fb03ff0] apic_timer_interrupt at ffffffff8478eefa

apic_timer_fn rearms itself sufficient times to cause the 
hardlockup detector to trigger.

The problem comes from how the hrtimer expiration time is advanced, 
which does not match how the interrupts at separated in time:

Timer interrupt handlers get to execute a few microseconds after
their deadline, while the exact period is added to the hrtimer
expiration time. With large uptimes, this causes the hrtimer 
expiration time to become much smaller than the actual
timer interrupt base:


phys time		0		    P		        2P		    3P	...

			|		    | 			|		    |
			| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |


timer_int                 0.1		       P+0.2 	              P+0.3

hrtimer_exp		  P		       2P		      3P		


At timer_int at point 0.1:      hrtimer_exp = hrtimer_exp + period = P
At timer_int at point P+0.2:    hrtimer_exp = hrtimer_exp + period = 2P
At timer_int at point P+0.3:    hrtimer_exp = hrtimer_exp + period = 3P

To confirm, printing the deltas of timer interrupt and timer
expiration:


      timer_int  hrtimer_exp

      1.0e6      1.00006e6
      1.00009e6  1.00006e6
      1.00002e6  1.00006e6
      1.0001e6   1.00006e6
      1.00013e6  1.00006e6
      1.0005e6   1.00006e6
      1.01135e6  1.00006e6
 991227.0        1.00006e6
      1.00046e6  1.00006e6
      1.00388e6  1.00006e6
      1.01399e6  1.00006e6
...

To fix this, for the hrtimer expire value, force a minimum of "now - period".

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index baca9fa37a91..52ba848d6828 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2442,8 +2442,19 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	apic_timer_expired(apic, true);
 
 	if (lapic_is_periodic(apic)) {
+		ktime_t now, expires, leftlimit;
+
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+
+               /* Advance timer if its far behind */
+		now = ktime_get();
+		expires = hrtimer_get_expires(&ktimer->timer);
+		leftlimit = ktime_sub_ns(now, ktimer->period);
+
+		if (ktimer->period > 0 && ktime_before(expires, leftlimit))
+			hrtimer_set_expires(&ktimer->timer, leftlimit);
+
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;

