Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CDF56A85E
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiGGQiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiGGQhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:37:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C771C564DA
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:37:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y9so6252328pff.12
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 09:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X4ZyDiG49m0gnXusM/3dJ8XamBzjgE2+uil3Jq1hmaM=;
        b=E49ZDCU676w+NcIsmk9E+mGQXW5bd97e4i4BXXPm4oNU/aLtXV8kdNULp4X9AedxTQ
         VucxtgaBbhw9x6MrrQvMpIYHUk6qdm9q05sGeZzSyIfGpHNFeDZCpKWqkMStzd2sJ467
         NKAFg1EfJHYtSm3kYr8+ukxMnVAPC/sjQ58j6HLDSiuHgHgfUtv2/amHrI3MUAApgyXm
         4ozd+IQPs5wcoAb/3Cid0jeoSL1vKU7rlHqsVs/cnIviQfkOpVKYuYCMWOn/V/CXvHDa
         xACQqg/P0s2cXSuXxvfdjtZpbDy+TQVQ6ZnEHFOLoXMm6TA5vU6DOLDlrqFrn4u4UuNF
         upqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X4ZyDiG49m0gnXusM/3dJ8XamBzjgE2+uil3Jq1hmaM=;
        b=BVewZovyJlzvnoyusH4vqDLukdKHLvb8qhLfanBp3HAVRaXx+BuXsGFZTeiU8d+EJQ
         3PMTP2QDTGdIufIvbSinWvV4uLTVYtC0TZMbHGAHr+kZKUexS45lNcfoYx1+6VZ2Se9c
         mhfhQqs6n6Sl2JKeZ58G6lrgO/s9fC5GCIZALXFIOlhbT/go63mIAEDQuZiJJxuywpZw
         FWz8jJuG+gcFmijatcfSm2gnCmy9XDMTSuOLn3FetkPQfuE6Bne9vHYtWaxKMCiCbYhe
         +N9ebwloMgUhcubukeZjevojpB6YdkZlZaQKjspdNcAHVLRrTYCsnEMaX2YMwcSzTqOA
         OV2Q==
X-Gm-Message-State: AJIora985QFQSADV6s7zHkiIy+Bxu/JQxwCe+RNEUxhUgw8RjcuoeXnq
        e/Yy8dj6ROkcpkUDZPXTvj26zQ==
X-Google-Smtp-Source: AGRyM1uFgEAF/n3ZL8SgaHP0it5sEiGezafpwXHFouNd511hUumx1la2tvv7rjI5pniBlsKFFDXt+Q==
X-Received: by 2002:a63:4558:0:b0:411:442a:b740 with SMTP id u24-20020a634558000000b00411442ab740mr39047805pgk.540.1657211843101;
        Thu, 07 Jul 2022 09:37:23 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b001690d398401sm28412267plb.88.2022.07.07.09.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 09:37:22 -0700 (PDT)
Date:   Thu, 7 Jul 2022 16:37:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wang Guangju <wangguangju@baidu.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        wanpengli@tencent.com, bp@alien8.de, joro@8bytes.org,
        suravee.suthikulpanit@amd.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chukaiping <chukaiping@baidu.com>
Subject: Re: [PATCH] KVM: x86: Add EOI_INDUCED exit handlers for Hyper-V
 SynIC vectors
Message-ID: <YscLvipHbNx+Wy9y@google.com>
References: <20220707122854.87-1-wangguangju@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707122854.87-1-wangguangju@baidu.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This isn't adding a handler so much as it's signaling EOI for SynIC vectors. Maybe?

  KVM: x86: Send EOI to SynIC vectors on accelerated EOI-induced VM-Exits

On Thu, Jul 07, 2022, Wang Guangju wrote:
> From: chukaiping <chukaiping@baidu.com>
> 
> When EOI virtualization is performed on VMX,
> kvm_apic_set_eoi_accelerated() is called upon
> EXIT_REASON_EOI_INDUCED but unlike its non-accelerated
> apic_set_eoi() sibling, Hyper-V SINT vectors are
> left unhandled.

Wrap changelogs closer to ~75 chars.

> This patch fix it, and add a new helper function to
> handle both IOAPIC and Hyper-V SINT vectors.

Avoid "this patch" and simply state what change is being made.  E.g.


  Send EOI to Hyper-V SINT vectors when handling acclerated EOI-induced
  VM-Exits.  KVM Hyper-V needs to handle the SINT EOI irrespective of
  whether the EOI is acclerated or not.

Fixes: 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")

and probably Cc: stable@vger.kernel.org?

> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: wangguangju <wangguangju@baidu.com>
> ---
>  arch/x86/kvm/lapic.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f03facc..e046afe 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1269,6 +1269,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
>  	kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
>  }
>  
> +static inline void apic_set_eoi_vector(struct kvm_lapic *apic, int vector)
> +{
> +	if (to_hv_vcpu(apic->vcpu) &&
> +	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
> +		kvm_hv_synic_send_eoi(apic->vcpu, vector);
> +
> +	kvm_ioapic_send_eoi(apic, vector);
> +	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
> +}

Rather than add a third helper, what about renaming kvm_apic_set_eoi_accelerated()
and having the non-accelerated helper call the "acclerated" version?  That will
document the delta between the non-accelerated patch and the accelerated path.
The only hiccup is tracing, but that's easy to resolve (or we could just not trace
if there's no valid vector to EOI), e.g.


/*
 * Send EOI for a valid vector.  The caller, or hardware when this is invoked
 * after an accelerated EOI VM-Exit, is responsible for updating the vISR and
 * vPPR.
 */
void kvm_apic_set_eoi(struct kvm_lapic *apic, int vector)
{
	trace_kvm_eoi(apic, vector);

	if (to_hv_vcpu(apic->vcpu) &&
	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
		kvm_hv_synic_send_eoi(apic->vcpu, vector);

	kvm_ioapic_send_eoi(apic, vector);
	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
}
EXPORT_SYMBOL_GPL(kvm_apic_set_eoi);

static int apic_set_eoi(struct kvm_lapic *apic)
{
	int vector = apic_find_highest_isr(apic);

	/*
	 * Not every write EOI will has corresponding ISR,
	 * one example is when Kernel check timer on setup_IO_APIC
	 */
	if (vector == -1) {
		trace_kvm_eoi(apic, vector);   <---- maybe just drop this?
		return vector;
	}

	apic_clear_isr(vector, apic);
	apic_update_ppr(apic);

	kvm_apic_set_eoi(apic, vector);

	return vector;
}
