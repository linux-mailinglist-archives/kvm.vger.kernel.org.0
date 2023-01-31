Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B103683979
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjAaWmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjAaWmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:42:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73C211EA1
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:42:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so143469pjd.2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Pn6XQJClPWD3A+imA49mX4oo2DJA54QHzWCHUbbrOY=;
        b=pWYBoe1SXQGeu4NRast6OyvA1VvHUBtkUN/Su0Lo4NubA5ppR7gC5zmdRjR6+9evyg
         kYU5Ere6A+ZnbOWtieH/AOYmakzva8O5CU9hlDfJs5ay988U7Cvj+zkT3FJXMPIfN70I
         J2Ypmx2i+a58klL7lngMRiwo3uN1B7ncasBRoyBBZMRY/VWBxpwfWZVjLl6Cv54oY3WD
         bOUvcPWzqMKU0lgSZuHf/TfRPvc1LgyR9lA9TR5ys85N9uoV+U95dUmuPvj18iq1JkwO
         j+aKJXVxSoE/rt6uzF/7R+82d6MUu5r3FcPP/JY8ZbGf16QbjICnHizwkHyBxRdEDY62
         +n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Pn6XQJClPWD3A+imA49mX4oo2DJA54QHzWCHUbbrOY=;
        b=idlHRTC0IgRmObz90sFaHa1GZoEBgmwcyA9WO67TwmNs5zkX5VCQO5RP34S4HVwCia
         iBl2EGdSyeRp8E7m9Tv0JNo3pCZ6pIDcMhxkpxZ4dc9lVo+2xPO1YXhSz0ipzz3FLoJG
         m7uin1uWi00BrAs3RFXVlqNXYxlxCiyamwM8lALdvz6dF2/2JLRgBlN33CS9mMKqemGG
         u9NJ43BNw8JEl+56/88rI5LFrPLFCMM8kPWZztF7Goh/dlXM7+KRKFne22bsxfq7AqoA
         /igJmw6bBB0aaOZDo+N5wRKE+mNf/U5xVWRfrkuM2xi3pVEfP5crjO+dhGP0PDPupI4s
         ueTQ==
X-Gm-Message-State: AO0yUKWTwcC8+Rnmlt3oX1iR/P8U2xs/7PCNIn24aMV/LBRGWc9FJQ8X
        wlDugasjn2QZ+orXpN+h3x/YGy5xg0RHGwTt32Q=
X-Google-Smtp-Source: AK7set/HJt9kh6Tv+h/4RgNVqbG69+AmpAhgM6Tu4U4eD8xeDFmauQycS4aFy/V8BdW62Fpe7VEhEg==
X-Received: by 2002:a17:90a:af94:b0:22c:952:ab22 with SMTP id w20-20020a17090aaf9400b0022c0952ab22mr72695pjq.1.1675204937955;
        Tue, 31 Jan 2023 14:42:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bt8-20020a17090af00800b00212e5fe09d7sm9173861pjb.10.2023.01.31.14.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:42:17 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:42:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH v2 09/11] KVM: SVM: Add VNMI bit definition
Message-ID: <Y9mZRU3nbz6ru2lS@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-10-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-10-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
> virtualize NMI and NMI_MASK, Those capability bits are part of
> VMCB::intr_ctrl -
> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
> 
> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
> will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
> handling NMI, After the guest handled the NMI, The processor will clear
> the V_NMI_MASK on the successful completion of IRET instruction Or if
> VMEXIT occurs while delivering the virtual NMI.
> 
> To enable the VNMI capability, Hypervisor need to program
> V_NMI_ENABLE bit 1.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index cb1ee53ad3b189..26d6f549ce2b46 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -203,6 +203,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define X2APIC_MODE_SHIFT 30
>  #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
>  
> +#define V_NMI_PENDING_SHIFT 11
> +#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
> +#define V_NMI_MASK_SHIFT 12
> +#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)

Argh, more KVM warts.  The existing INT_CTL defines all use "mask" in the name,
so looking at V_NMI_MASK in the context of other code reads "vNMI is pending",
not "vNMIs are blocked".

IMO, the existing _MASK terminology is the one that's wrong, but there's an absurd
amount of prior art in svm.h :-(

And the really annoying one is V_INTR_MASKING_MASK, which IIRC says "virtual INTR
masking is enabled", not "virtual INTRs are blocked".

So maybe call this V_NMI_BLOCKING_MASK?  And tack on _MASK too the others (even
though I agree it's ugly).

> +#define V_NMI_ENABLE_SHIFT 26
> +#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)

Hrm.  I think I would prefer to keep the defines ordered by bit position.  Knowing
that there's an enable bit isn't all that critical for understanding vNMI pending
and blocked.
