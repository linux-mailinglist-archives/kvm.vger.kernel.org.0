Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA6E522131
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiEJQbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbiEJQbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 12:31:40 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A38E6D850
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 09:27:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id iq10so16341329pjb.0
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 09:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TfyQ8rd/ifrFtLR+waM5D238nm+9pLY5UxeloRmvRYA=;
        b=JAxKGdOfLCJthR84IwJJIAqVVhFlZDrf8jQbPIgbLEh5Rqm218Jq3TQXleOZtE4UwS
         4HKavY0Xl9AJwgsGp6PmErZb0ydVokS9SPrLOxLNlfqPzmnMj2TKba/aHgSrtoautZh1
         hXmaWH5mfirZ1c0F/7FpVe9bJZLjkay5o8h66qddf4mPvTscCT/rXBiSqJKCT7G4FjVG
         L7sVevSU+hpvLZyjtOWEeHHGY07WPrOknSLXl5+fhkEkCmzwYXYNVfEqYLxrKoVUmHLR
         ruucKBkJv36oUDAGCz3jCd2eAHJlxauTnaGX46hS8MIK9a1CGy6O+IIQSq2yMLilKblY
         RVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TfyQ8rd/ifrFtLR+waM5D238nm+9pLY5UxeloRmvRYA=;
        b=ktevoPHGKKFnkdAUnIcEqQVt0wO9a44eow9WWcL2foYn2lcY0F+ohs5f5zJofl5x6T
         mB6PvuMsvyZh4lTbItRtv4x4SHW03BUJ4Eu634Npe+3n1aqF9mSBvK6lzEV0a4EuqaLg
         4Zv5aq2Q2c439jUHdTXOfse8Man+IoiiKWkppWTyJchCxOq1i2wPhWjeqN8NqBYkshg/
         6hrdgvp1+eWm3wPkhyF83fcjtsVjsmQYcX0XnR9FrGmlwVlSXikcV3O+boU81A6aClt4
         QAP5A0LUGs/0NBiHt6Eud4vPQklTheYe+FQnqBp4QtIYRUjgKoha1UK2ZW8sTVxZRyJS
         lWhQ==
X-Gm-Message-State: AOAM5337N0M6nqydJZEnvW6DAXdTJN9h/uKuNW8LA6+AAiO6luwiShwj
        9kRsilIAp7RfRui1sDVkTMDP6Q==
X-Google-Smtp-Source: ABdhPJzPVpP6j/JteVuLXbzmUYmevxlTiKLmm5V3xJuvhRcWWn6EqfCDZVZUvMGEXUAXxtqP8PkQng==
X-Received: by 2002:a17:902:bb02:b0:15e:d294:8d0f with SMTP id im2-20020a170902bb0200b0015ed2948d0fmr21684334plb.35.1652200062599;
        Tue, 10 May 2022 09:27:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902e80700b0015e8d4eb2d0sm2299720plg.282.2022.05.10.09.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 09:27:41 -0700 (PDT)
Date:   Tue, 10 May 2022 16:27:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2] KVM: VMX: Print VM-instruction error when it may be
 helpful
Message-ID: <YnqSecml2/Ooc0E/@google.com>
References: <20220508040233.931710-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508040233.931710-1-jmattson@google.com>
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

On Sat, May 07, 2022, Jim Mattson wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Include the value of the "VM-instruction error" field from the current
> VMCS (if any) in the error message for VMCLEAR and VMPTRLD, since each
> of these instructions may result in more than one VM-instruction
> error. Previously, this field was only reported for VMWRITE errors.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> [Rebased and refactored code; dropped the error number for INVVPID and
> INVEPT; reworded commit message.]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d58b763df855..a25da991da07 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -392,12 +392,14 @@ noinline void vmwrite_error(unsigned long field, unsigned long value)
>  
>  noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
>  {
> -	vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
> +	vmx_insn_failed("kvm: vmclear failed: %p/%llx err=%d\n",

I highly doubt it will ever matter, but arguably this should be %u, not %d.

> +			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
>  }
>  
>  noinline void vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
>  {
> -	vmx_insn_failed("kvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
> +	vmx_insn_failed("kvm: vmptrld failed: %p/%llx err=%d\n",
> +			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
>  }
>  
>  noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
> -- 
> 2.36.0.512.ge40c2bad7a-goog
> 
