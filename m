Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945C7232D1
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfETLl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:41:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfETLl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:41:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id w8so14227183wrl.6
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fE+RFyZyDUMaLhpUHBd7W8JMDRw/RtTMk4wk4VaAuU8=;
        b=J+2hJd/wdntWa9z1FFEBsC7VDAP+wjCvlqb4FsCVn4t19DD5/0Rg0rv/mXnkJJR3nH
         2gnulLDmwtRmW/bm6RhEKccIiD87tBZ6tTELLtrZRyBPXmuDFBffXkBRhMK/FDOQZk8k
         WeFoRlcfs4uec5AAGDDlFjTADqiorml+rwSyD6Mv+pNY1bhBRGsgQtEhV4592iSfGfOw
         Supe4np3d9uLCkIyqCHIr1zSRl6bcWoE9CC3FVmw/aopppJU9mIWCl+a1jo1hRWWJO95
         cMPMWmOO8PWBhWwJpckmq6PK+UrXQQpZcy+K9Vthz+c5vbIs9IfvNXLrPdEBGXOl0V8K
         kwXQ==
X-Gm-Message-State: APjAAAVV+6r8z/uJGlw5NDHJCSYz9ab8h1PQHDjvT60MG+3UrGmOaZWA
        7+yZYrSs6d8eOCz98VnjTHbab7/Qs/Glvw==
X-Google-Smtp-Source: APXvYqyYQoknmXEgL6TPhActsY14UfsNRIHZOxsu1Wq1NvswtjnabDPg3J+gMjvgKyjf79tZM+7ZSg==
X-Received: by 2002:adf:f741:: with SMTP id z1mr45344362wrp.14.1558352485112;
        Mon, 20 May 2019 04:41:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id s3sm33334241wre.97.2019.05.20.04.41.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:41:24 -0700 (PDT)
Subject: Re: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
 <1558340289-6857-5-git-send-email-wanpengli@tencent.com>
 <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
 <CANRm+CyDpA-2j28soX9si5CX3vFadd4_BASFzt1f4FbNNNDzyw@mail.gmail.com>
 <bd60e5c2-e3c5-80fc-3a1d-c75809573945@redhat.com>
 <CANRm+CzFQy4UC9oGxFK8UVVhdtV_LGeF3JcNohpRcgspSqcxwg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <024a0c93-f8a3-abe0-85de-fa41babf06a0@redhat.com>
Date:   Mon, 20 May 2019 13:41:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CzFQy4UC9oGxFK8UVVhdtV_LGeF3JcNohpRcgspSqcxwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 13:36, Wanpeng Li wrote:
>> Hmm, yeah, that makes sense.  The location of the tracepoint is a bit
>> weird, but I guess we can add a comment in the code.
> Do you need me to post a new patchset? :)

No problem.  The final patch that I committed is this:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c12b090f4fad..f8615872ae64 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 }
 
 static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
-					      u64 guest_tsc, u64 tsc_deadline)
+					      s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
 
 	/* too early */
-	if (guest_tsc < tsc_deadline) {
-		ns = (tsc_deadline - guest_tsc) * 1000000ULL;
+	if (advance_expire_delta < 0) {
+		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns -= min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	} else {
 	/* too late */
-		ns = (guest_tsc - tsc_deadline) * 1000000ULL;
+		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns += min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	}
 
-	if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
 		timer_advance_ns = 0;
@@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
+	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
 	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
-		adjust_lapic_timer_advance(vcpu, guest_tsc, tsc_deadline);
+		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d6d049ba3045..3e72a255543d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -32,6 +32,7 @@ struct kvm_timer {
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
 	u32 timer_advance_ns;
+	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 	bool timer_advance_adjust_done;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7e57de50a3c..35631505421c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8008,6 +8008,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 
 	guest_exit_irqoff();
+	if (lapic_in_kernel(vcpu)) {
+		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
+		if (delta != S64_MIN) {
+			trace_kvm_wait_lapic_expire(vcpu->vcpu_id, delta);
+			vcpu->arch.apic->lapic_timer.advance_expire_delta = S64_MIN;
+		}
+	}
 
 	local_irq_enable();
 	preempt_enable();

so that KVM tracks whether wait_lapic_expire was called, and do not
invoke the tracepoint if not.

Thanks,

Paolo
