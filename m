Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16D57C0DF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiGTXbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiGTXbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:31:10 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA2A3335F
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:31:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id z3so243630plb.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HjcYfXSwGDgx9H9HIz5Gsyz7CrPNvTy75qGP8iwgc2Q=;
        b=I4TX5TO7XfCcbqjSoei8YUODsY/MTgnPgFrGAPiYHRuVkz+w8huk/a6R6O7fS/VITd
         rd4apW1kmB/Svr5bPlV6j8NzIbfBFrDfIwdnoEpWEL7WyhU6LkOj7nJs8unG+38CXd8r
         yKGolUC7Stvd9c636cGMeEDjVnPSmDuo9o/b1xuNUB5CSd4XrQ0VMDvR4CvhSp7/nyFv
         JcCKQgej7FyuIBnv11dN7p81mx+9dpKgbh/yi74yFwMBCLdP+AocWP9FApkiRbQCL+qV
         MZggYDGVSI5JT/a860Vd+n3SF1UTWO3VEqFyNB9Cq0qTsZzTpwM5V1rqaJfk0J0PjgXc
         vlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HjcYfXSwGDgx9H9HIz5Gsyz7CrPNvTy75qGP8iwgc2Q=;
        b=nj3FtE1vUBUvuBGX1Gk5KrusxgeCk36Fl8O7aCtUHJs/lVNQ6fbuHjI7apgQFJPApZ
         dG3XDNrs/hZkekOCehcOYAqP7nNfT8Vxj7/RqfosigkfHEo/ap4rW7mF3E7EOmVlawTD
         EK65IDQPXSNQwQe9AcNYMiRCIswuqjooASO+nRv97hnEeze+/O//cboJGUCcmrPvXo+5
         2R77MKGZQsV4LXQVS29JD7UoZj+A8SNjosmRj97kgtqKNOqhBu1Z0bMxjhuWMq75Wdwq
         ZPZb29S7guCn3wQvDOrkGKV1fmtHwWAUdHtR2ltNIkgC5e0Z11CJPTgX5ICeBjmVULUK
         AS5Q==
X-Gm-Message-State: AJIora8Si1wxgwFE74YSdJgv7bMoM6PO27SBMp1s/o3FHNNTfpMgTQ/3
        9PT36kGfWgkI81C7f4wiQhXYow==
X-Google-Smtp-Source: AGRyM1tuOi2+snv5HFVQviVfc9gcj3dQ8RI4TCxUhZaDmk0Z3b7WCoXNOSPLqC7bmfz2JJSi/a5DUw==
X-Received: by 2002:a17:90b:4b87:b0:1f0:60da:4a81 with SMTP id lr7-20020a17090b4b8700b001f060da4a81mr8406145pjb.30.1658359868935;
        Wed, 20 Jul 2022 16:31:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e81100b00166304d081bsm130836plg.24.2022.07.20.16.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:31:07 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:31:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [RFC PATCH v2 1/3] KVM: x86: Protect the unused bits in the MSR
 filtering / exiting flags
Message-ID: <YtiQN4LB7a6tE4UD@google.com>
References: <20220719234950.3612318-1-aaronlewis@google.com>
 <20220719234950.3612318-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719234950.3612318-2-aaronlewis@google.com>
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

On Tue, Jul 19, 2022, Aaron Lewis wrote:
> The flags used in KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
> have no protection for their unused bits.  Without protection, future
> development for these features will be difficult.  Add the protection
> needed to make it possible to extend these features in the future.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/x86.c              | 6 ++++++
>  include/uapi/linux/kvm.h        | 3 +++
>  3 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index ee3896416c68..63691a4c62d0 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -224,6 +224,7 @@ struct kvm_msr_filter_range {
>  struct kvm_msr_filter {
>  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)

Well this is silly.  Can we wrap this with

#ifdef __KERNEL__
#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
#endif

so that we don't try to use it in the kernel?  E.g. I can see someone doing

	if (filter.flags & KVM_MSR_FILTER_DEFAULT_ALLOW)
		<allow the MSR>

and getting really confused when that doesn't work.

Or if we're feeling lucky, just remove it entirely as userspace doing

	filter.flags &= KVM_MSR_FILTER_DEFAULT_ALLOW;

is going to make someone sad someday.

>  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
> +#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
>  	__u32 flags;
>  	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
>  };
