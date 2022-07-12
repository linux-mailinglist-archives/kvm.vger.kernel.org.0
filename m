Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76257259B
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiGLT2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 15:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiGLT1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 15:27:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DC0BA15E
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 12:04:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so12740350pjo.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 12:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YWGv2k9yuFt3AP6MsL8a/IqZ/XziYs7UbpcSAKtrLiE=;
        b=Fsxp6O0FRMeMVQgNOvnAAr89jc0DaJqSSlrg79HUbsZ52e8nQC7ePBFwhxUsaibYfn
         f/XWli2tSuBtGj0UmqymQrRan8Mg5rHUXCVNOIT0XfecCGfL0A2qB2srgrAlcYcNszJl
         lWroLwTJS2Bp9X0AztYJ+YrrhaOVSDhWZGzpgY3sBK2Hj+4Wfi6hnh0nl1totQY7q8Nl
         Z5ezIoU2trgfmI2HEpF0h0JhDTZ/RziffwRiIAd7cHOXzCbm918phf22NH1RxL99GGrk
         alrScZuYxkBLBB3Wnpl7EXOQTz2pybjG8g2j0cme/n1Mv4svhZSoNOfzIBjLE++Oj5hP
         3kPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YWGv2k9yuFt3AP6MsL8a/IqZ/XziYs7UbpcSAKtrLiE=;
        b=FnhAxkDzTymdBAplSJCzVywpGamEGVqoT0pnGbkiV/k3nVuSzh1EnKNrfkUK/3mQzT
         NihFqQ8tuWgieNk4YRgniEQpSAdXZkR2DvlbCaooXEIUTLaZvhUR8CeUzcqvFGb0GzJk
         sDcdBaJ0yiNexwRwmw4Hj/lLPhbQ4hdaBxPkr5PIc53nl4rDB9te+Ti1Hl0/zVBpq+Sl
         2UxBKWaH0/33Zb5gia2g3brYF7EwvxwrjfaFcfjkA9yXoryaCYMP0FeYMderscoooNfY
         Tuk6CRnSmsODtneXjRS0hqC+3OgZdUiYkniSGqZUDRVbfYm/pxtdO3Kub6FYNTpiB742
         j2zg==
X-Gm-Message-State: AJIora/WtpK13vqSBHN8+cNKzDDTFvcIg6fhaGWMvlPPA1vfFkLwrgSk
        rjjVlR4e5AK2BeB3c2CpT5UHbA==
X-Google-Smtp-Source: AGRyM1vzPwCJcX7MjMWqG7WpQw7JrPmtpWny9BPIy5K+qIr/IzqGvh/D9E/pwdURuknLjypGAdwL+g==
X-Received: by 2002:a17:902:cecb:b0:16c:40a8:88ff with SMTP id d11-20020a170902cecb00b0016c40a888ffmr14088810plg.33.1657652644709;
        Tue, 12 Jul 2022 12:04:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902684d00b0016bcc35000asm7173381pln.302.2022.07.12.12.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:04:04 -0700 (PDT)
Date:   Tue, 12 Jul 2022 19:04:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com
Subject: Re: [PATCH] KVM: LAPIC: Fix a spelling mistake in comments
Message-ID: <Ys3FodyfOxaT+NZU@google.com>
References: <20220701065558.9073-1-jiaming@nfschina.com>
 <Ys3Ex9GaoWAbNqF0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys3Ex9GaoWAbNqF0@google.com>
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

On Tue, Jul 12, 2022, Sean Christopherson wrote:
> On Fri, Jul 01, 2022, Zhang Jiaming wrote:
> ---
>  arch/x86/kvm/lapic.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 48740a235dee..ef5417d3ce95 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -830,13 +830,16 @@ static bool kvm_apic_match_physical_addr(struct kvm_lapic *apic, u32 mda)
>  		return mda == kvm_x2apic_id(apic);
> 
>  	/*
> -	 * Hotplug hack: Make LAPIC in xAPIC mode also accept interrupts as if
> -	 * it were in x2APIC mode.  Hotplugged VCPUs start in xAPIC mode and
> -	 * this allows unique addressing of VCPUs with APIC ID over 0xff.
> -	 * The 0xff condition is needed because writable xAPIC ID.

Doh, this won't apply on kvm/queue, I unintentionally generated this as a delta
on top of your patch.  I'll remedy that before testing and officially posting.

> +	 * Hotplug hack: Accept interrupts for vCPUs in xAPIC mode as if they
> +	 * were in x2APIC mode if the target APIC ID can't be encoded as an
> +	 * xAPIC ID.  This allows unique addressing of hotplugged vCPUs (which
> +	 * start in xAPIC mode) with an APIC ID that is unaddressable in xAPIC
> +	 * mode.  Match the x2APIC ID if and only if the target APIC ID can't
> +	 * be encoded in xAPIC to avoid spurious matches against a vCPU that
> +	 * changed its (addressable) xAPIC ID (which is writable).
>  	 */
> -	if (kvm_x2apic_id(apic) > 0xff && mda == kvm_x2apic_id(apic))
> -		return true;
> +	if (mda > 0xff)
> +		return mda == kvm_x2apic_id(apic);
> 
>  	return mda == kvm_xapic_id(apic);
>  }
> 
> base-commit: ba0d159dd8844469d4e4defff4985a7b80f956e9
> --
> 
