Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AFB5AEF83
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 17:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiIFPzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 11:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiIFPzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 11:55:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1088C8D3DA
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 08:13:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so6062605pjm.1
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 08:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4qWRg0pj2vBJoOh7qGaSZ5h4bkObiV59g0dITseF1n0=;
        b=KH7IZDJD7Y8b3uEKowAoMS8Pgvs4QXX0NKTxI9TaaUhs7uVP5Bj5TamunKFEA0TQ4O
         5mPwZMYKSdGrKlbbUz70Uk3uZpfTZXnpEnNSlQQgnLHw4gT08k8BSzbIkTUzpMQQRqUx
         RB3/4s1o4qCU5xSRHgxYCc6BVLwv6ImjNlMYrq8szmymAduxvRh8dQzEpmd91TKEfhQ2
         G3ynoaj1HRj7InuUUrWBwvxp1fOMxB83X2B2cLjEX0V0YqO+yms9w/E+HN/cniSQQ+4O
         hSXwFMGurgNR8aDcQeoUFFFTojFcRHLuQ4QEDQvkYx/UBetpqDbACf1iTwKB6iOFWbfV
         YdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4qWRg0pj2vBJoOh7qGaSZ5h4bkObiV59g0dITseF1n0=;
        b=DMSu8lPiryUYIRNqxtZj2yYHlZHKaF8nH8QWk0GG1hewwHgAdO4075F7LFD+JbccdG
         qm2aq4TwHfMVmAOnJRK+BtvAh/E1EotozD3WTU0c+YHNP3VZ9ZXI6ls8Bf384KMOC5q1
         ZA3GFadZtvgeOH1zmMr9sWCzz+pnKzJqmePYzyl1Sq1LwoiKyx596M6C9/8/YAE87dET
         uRMmBygW1GqIQkkGjfPQHbHphkA2wutwgB7b9QQu1lNyYZaZpvL++RgL5Vyvvwkoi39C
         iKVGp6iED6evwUWjARVEX+RW3u4kFWr+/WkCP7r6FLN0vAOAUeQC1cgZzeTKOu4HuH8g
         LT3w==
X-Gm-Message-State: ACgBeo0KY4Qt1ZN+TPpD3X1rFNLeuI8jTL5JgOEf8ZWd8hwbLlkBThxL
        cM6FBrLocMNzP47kGiR4O68MrC8aT0jVXA==
X-Google-Smtp-Source: AA6agR6olQ2PMxoDYdSDVBVtrzpxzp/U6DDWqd82S3Z03OAgq6QfbVrOAcQZG7VjcS4//eIPfGIAjg==
X-Received: by 2002:a17:902:b194:b0:176:d229:83bd with SMTP id s20-20020a170902b19400b00176d22983bdmr3241229plr.174.1662477196446;
        Tue, 06 Sep 2022 08:13:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090ab38700b001f1acb6c3ebsm8847767pjr.34.2022.09.06.08.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 08:13:15 -0700 (PDT)
Date:   Tue, 6 Sep 2022 15:13:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, joao.m.martins@oracle.com
Subject: Re: [PATCH 1/1] KVM: x86: Allow emulation of EOI writes with AVIC
 enabled
Message-ID: <YxdjiNsWBPOoX2w1@google.com>
References: <20220903200557.1719-1-alejandro.j.jimenez@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220903200557.1719-1-alejandro.j.jimenez@oracle.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022, Alejandro Jimenez wrote:
> According to section 15.29.9.2 - AVIC Access to un-accelerated vAPIC register
> of the AMD APM [1]:
> 
> "A guest access to an APIC register that is not accelerated by AVIC results in
> a #VMEXIT with the exit code of AVIC_NOACCEL. This fault is also generated if
> an EOI is attempted when the highest priority in-service interrupt is set for
> level-triggered mode."
> 
> This is also stated in Table 15-22 - Guest vAPIC Register Access Behavior,
> confirming that AVIC hardware traps on EOI writes for level triggered
> interrupts, and leading to the following call stack:
> 
> avic_unaccelerated_access_interception()
> -> avic_unaccel_trap_write()
>   -> kvm_apic_write_nodecode()
>     -> kvm_lapic_msr_read()
>       -> kvm_lapic_reg_read()
> 
> In kvm_lapic_reg_read(), the APIC_EOI offset (0xb0) is not allowed as valid, so
> the error returned triggers the assertion introduced by 'commit 70c8327c11c6
> ("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")'
> and kills the VM.
> 
> Add APIC_EOI offset to the valid mask in kvm_lapic_reg_read() to allow the
> emulation of EOI behavior for level triggered interrupts.
> 
> [1] https://www.amd.com/system/files/TechDocs/24593.pdf
> 
> Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Cc: stable@vger.kernel.org
> ---
> 
> I am unsure as to the proper commit to use for the Fixes: tag. Technically the
> issue was introduced by the initial SVM AVIC commits in 2016, since they failed
> to add the EOI offset to the valid mask.
> 
> To be safe, I used the commit that introduces the valid mask, but that is
> somewhat misleading since at the time AVIC was not available, and I believe that
> Intel posted interrupts implementation does not require access to EOI offset in
> this code.
> 
> Please correct Fixes: tag if necessary.
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989a1cf0..61041fecfa89 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1452,6 +1452,7 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  		APIC_REG_MASK(APIC_LVR) |
>  		APIC_REG_MASK(APIC_TASKPRI) |
>  		APIC_REG_MASK(APIC_PROCPRI) |
> +		APIC_REG_MASK(APIC_EOI) |

EOI is write-only for x2APIC, reads are supposed to #GP.  So unfortunately, simply
adding it to the set of allowed registers won't work.

EOI is also write-only for xAPIC on Intel, but apparently AMD allows reads.

I'm leaning towards this as a fix.  The only reason KVM uses kvm_lapic_msr_read()
is to play nice with the 64-bit ICR in x2APIC.  I don't love that the x2APIC details
bleed further into kvm_apic_write_nodecode(), but odds are good that if there's ever
another 64-bit register, it'll need to be special cased here anyways, same as ICR. 

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 Sep 2022 07:52:41 -0700
Subject: [PATCH] KVM: x86: Blindly get current x2APIC reg value on "nodecode
 write" traps

When emulating a x2APIC write in response to an APICv/AVIC trap, get the
the written value from the vAPIC page without checking that reads are
allowed for the target register.  AVIC can generate trap-like VM-Exits on
writes to EOI, and so KVM needs to get the written value from the backing
page without running afoul of EOI's write-only behavior.

Alternatively, EOI could be special cased to always write '0', e.g. so
that the sanity check could be preserved, but x2APIC on AMD is actually
supposed to disallow non-zero writes (not emulated by KVM), and the
sanity check was a byproduct of how the KVM code was written, i.e. wasn't
added to guard against anything in particular.

Fixes: 70c8327c11c6 ("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")
Fixes: 1bd9dfec9fd4 ("KVM: x86: Do not block APIC write for non ICR registers")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4cebbdd3431b..76a19bf1eb55 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2349,23 +2349,18 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;
 
-	if (apic_x2apic_mode(apic)) {
-		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
-			return;
-	} else {
-		val = kvm_lapic_get_reg(apic, offset);
-	}
-
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
 	 * to get the upper half from ICR2.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
+		val = kvm_lapic_get_reg64(apic, APIC_ICR);
 		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
 		trace_kvm_apic_write(APIC_ICR, val);
 	} else {
 		/* TODO: optimize to just emulate side effect w/o one more write */
+		val = kvm_lapic_get_reg(apic, offset);
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}
 }

base-commit: 476d5fb78ea6438941559af4814a2795849cb8f0
-- 

