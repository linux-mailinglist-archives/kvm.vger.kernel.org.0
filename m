Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008DB2320B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbfETLOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:14:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32930 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732320AbfETLOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:14:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id c66so14038424wme.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWCVpEwgEl13jlizY1Sq4nwHrdlazSZiPdOyvsUmZyY=;
        b=CW9WNZK1pzkFdkrnvVOTWooVpg6ty3/72hcFTIaV5RhAG0z0+B3R1HLHHRDry9TbGe
         6A04iFg2DDWS8ZxUtBdpw0yb11YqxkXBCI69b6W2qaoBhDN565nrSoxKAjdwzv4wn6C9
         pYmFJXf/JIkOeLheCvpZW3MWLrNqc9IUOWOz/UKMQEPteCpw/2D2zh9YUX2pvLK3fxB/
         /RwGG8ShYlP5iNmMU88Foqt6awdrEf3o8vCXtqG39HeZD00kSUXZRZo6FLNkr+PuQrXF
         i4sum8UcC3RJxus6xFgG3YnnRBPI8+C2drLw3m9Ga5X4HM0OZrxpzMrHHqnXql/nQLje
         tqDA==
X-Gm-Message-State: APjAAAXhLbc86g2GYNWoSQhMd1+XIauXjuVoag/FUUNsw3DlbdL8k+1W
        3jTcb8DlBrR7hudOaLvbAltSNQ==
X-Google-Smtp-Source: APXvYqwbEfcXwrWx2BYL0ZEdavUTAIvqOqcJd9ZpoYtjg0loUgtA9pWqZbnA1cjMxTUVbBD3x3LL9g==
X-Received: by 2002:a1c:a80b:: with SMTP id r11mr22775538wme.77.1558350870463;
        Mon, 20 May 2019 04:14:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id z21sm4111391wmf.25.2019.05.20.04.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:14:29 -0700 (PDT)
Subject: Re: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
 <1558340289-6857-5-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
Date:   Mon, 20 May 2019 13:14:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558340289-6857-5-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 10:18, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> wait_lapic_expire() call was moved above guest_enter_irqoff() because of 
> its tracepoint, which violated the RCU extended quiescent state invoked 
> by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint 
> below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta before 
> VM-Enter, but trace it after VM-Exit. This can help us to move 
> wait_lapic_expire() just before vmentry in the later patch.
> 
> [1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
> [2] https://patchwork.kernel.org/patch/7821111/

This is a bit confusing, since the delta is printed after the 
corresponding vmexit but the wait is done before the vmentry.  I think 
we can drop the tracepoint:

------------- 8< ----------------
From ae148d98d49b96b5222e2c78ac1b1e13cc526d71 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 May 2019 13:10:01 +0200
Subject: [PATCH] KVM: lapic: replace wait_lapic_expire tracepoint with
 restart_apic_timer

wait_lapic_expire() call was moved above guest_enter_irqoff() because of
its tracepoint, which violated the RCU extended quiescent state invoked
by guest_enter_irqoff()[1][2].

We would like to move wait_lapic_expire() just before vmentry, which would
place wait_lapic_expire() again inside the extended quiescent state.  Drop
the tracepoint, but add instead another one that can be useful and where
we can check the status of the adaptive tuning procedure.

[1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
[2] https://patchwork.kernel.org/patch/7821111/

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

---
 arch/x86/kvm/lapic.c |  4 +++-
 arch/x86/kvm/trace.h | 15 +++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c12b090f4fad..8f05c1d0b486 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1545,7 +1545,6 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
 
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
@@ -1763,6 +1762,9 @@ static void start_sw_timer(struct kvm_lapic *apic)
 
 static void restart_apic_timer(struct kvm_lapic *apic)
 {
+	trace_kvm_restart_apic_timer(apic->vcpu->vcpu_id,
+				     apic->lapic_timer.timer_advance_ns);
+
 	preempt_disable();
 
 	if (!apic_lvtt_period(apic) && atomic_read(&apic->lapic_timer.pending))
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d47a2631d1f..f6e000038f3f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -953,24 +953,23 @@
 		  __entry->flags)
 );
 
-TRACE_EVENT(kvm_wait_lapic_expire,
-	TP_PROTO(unsigned int vcpu_id, s64 delta),
-	TP_ARGS(vcpu_id, delta),
+TRACE_EVENT(kvm_restart_apic_timer,
+	TP_PROTO(unsigned int vcpu_id, u32 advance),
+	TP_ARGS(vcpu_id, advance),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
-		__field(	s64,		delta		)
+		__field(	u32,		advance		)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id	   = vcpu_id;
-		__entry->delta             = delta;
+		__entry->advance           = advance;
 	),
 
-	TP_printk("vcpu %u: delta %lld (%s)",
+	TP_printk("vcpu %u: advance %u",
 		  __entry->vcpu_id,
-		  __entry->delta,
-		  __entry->delta < 0 ? "early" : "late")
+		  __entry->advance)
 );
 
 TRACE_EVENT(kvm_enter_smm,
