Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA681B859E
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 12:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgDYKYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 06:24:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41567 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYKYe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 06:24:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587810273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiiGjxMSfR/3HcuLZdv0rh/BGKXUkSP2JfWB96AlEV4=;
        b=a2tIUsThwWFw0rZMldVXpgsPzgXDGunM1+dHF4kkccaABijYovhkOccigkMS/Z/w7bdB3L
        GCakqIQMbXtnlGGuHkxUFTo8agdIukJbP2wcwX88C8Pgt+R38SM/57ewXFmziin5rLkOr1
        suHoIomyeQzstcmUh+0yKcbKnM16rAc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-C4DGlTI-MAasUuKSFw9AOQ-1; Sat, 25 Apr 2020 06:24:29 -0400
X-MC-Unique: C4DGlTI-MAasUuKSFw9AOQ-1
Received: by mail-wr1-f69.google.com with SMTP id d17so6457281wrr.17
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 03:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AiiGjxMSfR/3HcuLZdv0rh/BGKXUkSP2JfWB96AlEV4=;
        b=nGTqGn034W9/qfEHQ61XJ6NKh3CEpx9k0IvamJ1UHCgcYfdXC/LhTsVytNg7U0dvlc
         rZr+nZYRCeBmkhGLR5CvwHLvZknrYRfLgeNc9R8Rkbh9OOle+6R/zy6XnIwhVPyWrt8L
         5RuaGIC97aa57KBZVlvrQS56mq4q1Tlum/qcO/3lVFib/8Lk/0fCWK8ZeCLrCEWJwzja
         akc4bZfrx6ed3Ewi+OQ0INa2fBpGNpE6EBLK/k47/o+RX4gGIEy/hCm1wvufkEazokZm
         8/NgXdvg2oOwPnTdfSyl4gp8DbfIAE+yzWuX2e8AnvKxIJcGGoVJJ3MV6bmQPTwFlo8L
         G0Tg==
X-Gm-Message-State: AGi0PubJmzfvGsnAcLm72ury3Iu0hWCqFlApw+rDHjHMANvY3HdvPaVb
        HmB0qXNR4XyNHitTJlMYj6aCNAX6QzPSA0TG4dxnDKy4cSxPIKYNcL5l+0uPo9WJYNLc1Pp8Cup
        cdsPRIyOJaFIs
X-Received: by 2002:a5d:5745:: with SMTP id q5mr17541300wrw.351.1587810268502;
        Sat, 25 Apr 2020 03:24:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypJCsnbfHqFriQbI24TXuIAXrqXN8iqz6uh+Ag2xVYIfCBS/H8oNA4RK58IzO9hfko5vLHJ96Q==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr17541287wrw.351.1587810268284;
        Sat, 25 Apr 2020 03:24:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id t17sm11580360wro.2.2020.04.25.03.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 03:24:27 -0700 (PDT)
Subject: Re: [PATCH 5/5] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
Cc:     peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200424054837.5138-1-dave@stgolabs.net>
 <20200424054837.5138-6-dave@stgolabs.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
Date:   Sat, 25 Apr 2020 12:24:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424054837.5138-6-dave@stgolabs.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm squashing this in to keep the changes compared to the current code minimal,
and queuing the series.

Thanks,

Paolo

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index bbefa2a7f950..feca3118b17f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -230,10 +230,10 @@ static bool kvmppc_ipi_thread(int cpu)
 static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 {
 	int cpu;
-	struct rcuwait *wait;
+	struct rcuwait *waitp;
 
-	wait = kvm_arch_vcpu_get_wait(vcpu);
-	if (rcuwait_wake_up(wait))
+	waitp = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(waitp))
 		++vcpu->stat.halt_wakeup;
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
@@ -3814,7 +3814,10 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 		}
 	}
 
+	prepare_to_rcuwait(&vc->wait);
+	set_current_state(TASK_INTERRUPTIBLE);
 	if (kvmppc_vcore_check_block(vc)) {
+		finish_rcuwait(&vc->wait);
 		do_sleep = 0;
 		/* If we polled, count this as a successful poll */
 		if (vc->halt_poll_ns)
@@ -3827,8 +3830,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	vc->vcore_state = VCORE_SLEEPING;
 	trace_kvmppc_vcore_blocked(vc, 0);
 	spin_unlock(&vc->lock);
-	rcuwait_wait_event(&vc->wait,
-			   kvmppc_vcore_check_block(vc), TASK_INTERRUPTIBLE);
+	schedule();
+	finish_rcuwait(&vc->wait);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
 	trace_kvmppc_vcore_blocked(vc, 1);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c2d18c12d87..c671de51a753 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2737,10 +2737,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-	struct rcuwait *wait;
+	struct rcuwait *waitp;
 
-	wait = kvm_arch_vcpu_get_wait(vcpu);
-	if (rcuwait_wake_up(wait)) {
+	waitp = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(waitp)) {
 		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.halt_wakeup;
 		return true;

