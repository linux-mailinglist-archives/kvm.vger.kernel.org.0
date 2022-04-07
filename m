Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9864F8753
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346963AbiDGSuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346956AbiDGSuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:50:00 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF3133663
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:47:59 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 32so3593318pgl.4
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2OeHEZDx64EG8oP0xt3lvxv4lipweyChyS0IcTq6KnI=;
        b=RXi8AjBxjh6VVtl9LSNNrBkDo2V5rtsQX9fbYvncg96tdARjL8rbloMFzh2CYhbirF
         o8CXs1dCnDL/xC27cvDXwWoOAntnZtgL7dlz7wSpJ4cU2Bfh//d2tzJpSkcxBVc9y/9R
         xf0WFhO8motAdyNOcYiTBF1BJsTwTrQDvSmkyax6jl73/y5E/FAsWBzy4FYR1foI5p1/
         VM/Ub831ejGzfxc65yZ7+6FvPhupwwwOM15xRWf6qfJGchIMeFQ1Uzl017Mpj5UVCivI
         MRONizHwQAMJCgkK71Z9pS2NrwGkdGIy0J4eV/Ok64Oul31qdIkLAdQcb5WPZlGoFJe/
         20Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OeHEZDx64EG8oP0xt3lvxv4lipweyChyS0IcTq6KnI=;
        b=xdzdNaxuQM5ZsQ1iHPo9D/jkVDgAaobMyzOUG00WH481bIP+8UbihdlB4bwUHXHJAD
         CyM22UeMEYSsdhaoSDbSXFIPbshend80owyTViHOcPxF0dz1+i5NXUAVofLqXUxhXAC/
         CV0LNyF4IdV+CbHV8RQVnuWV3Yl8kaXsLE+S95qufPpAc2mUKe3yvNSjfrZwsMeO4FxA
         W6LXg85WmC+zE63YBMS7J3oBxv/V6j213tyW99+CCoO2l9UweWrrnp6dqtJ4jY9z2NoE
         OxxKGwNsL1uVpyn98RGZm8Po3nQvUalJ1I9tUpTJT5ZrvWb4b7dM0t3RvjLPCWzcn5D7
         DbNg==
X-Gm-Message-State: AOAM530RbgdRH5Yhj1g2A1toO4svOLGZ3+vwY71qCAgjLEI4rfZhtmoQ
        L8wlqO3QDNOyPaY0uidkhZ5T+w==
X-Google-Smtp-Source: ABdhPJz599fEIYbjkY/5HRqf5EtFxU5iWR3SXbcCPa8oI0rzDn415HElhVzRla/90uLDGV8DelsX0g==
X-Received: by 2002:aa7:8d54:0:b0:4e0:bd6:cfb9 with SMTP id s20-20020aa78d54000000b004e00bd6cfb9mr15578775pfe.60.1649357278600;
        Thu, 07 Apr 2022 11:47:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9-20020a056a000c8900b004fb37ecc6bbsm24428974pfv.65.2022.04.07.11.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 11:47:57 -0700 (PDT)
Date:   Thu, 7 Apr 2022 18:47:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 16/31] KVM: nVMX: hyper-v: Direct TLB flush
Message-ID: <Yk8x2rF/UkuXY/X2@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-17-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-17-vkuznets@redhat.com>
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

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> Enable Direct TLB flush feature on nVMX when:
> - Enlightened VMCS is in use.
> - Direct TLB flush flag is enabled in eVMCS.
> - Direct TLB flush is enabled in partition assist page.

Yeah, KVM definitely needs a different name for "Direct TLB flush".  I don't have
any good ideas offhand, but honestly anything is better than "Direct".

> Perform synthetic vmexit to L1 after processing TLB flush call upon
> request (HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 8862692a4c5d..ab0949c22d2d 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -65,6 +65,8 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
> +#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031

LOL, I guess I have to appreciate the cleverness.  Bit 28 is cleared for all
exits except when using an SMI transfer monitor, and then it's set only if MTF
is pending.

  The remainder of the field (bits 31:28 and bits 26:16) is cleared to 0 (certain
  SMM VM exits may set some of these bits; see Section 31.15.2.3).

  If the SMM VM exit occurred in VMX non-root operation and an MTF VM exit was
  pending, bit 28 of the exit-reason field is set; otherwise, it is cleared.

So despite all appearances, Microsoft didn't actually steal a bit from Intel,
they're just abusing a bit that (a) will never be set so long as the VMM doesn't
use parallel SMM and (b) architecturally can't be set in conjuction with many
exit reasons (everything that's _not_ some form of SMI).

Can you add a comment note to document this?

/*
 * Note, Hyper-V isn't actually stealing bit 28 from Intel, just abusing it by
 * pairing it with architecturally impossible exit reasons.  Bit 28 is set only
 * on SMI exits to a SMI tranfer monitor (STM) and if and only if a MTF VM-Exit
 * is pending.  I.e. it will never be set by hardware for non-SMI exits (there
 * are only three), nor will it ever be set unless the VMM is an STM.
 */

>  struct evmcs_field {
>  	u16 offset;
>  	u16 clean_field;
> @@ -244,6 +246,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version);
>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
> +bool nested_evmcs_direct_flush_enabled(struct kvm_vcpu *vcpu);
