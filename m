Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5A5A32CC
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiHZXyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiHZXyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:54:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6367CE5889
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:54:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q9so2711123pgq.6
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qNGeyiuY8r7ztH91OpIrJNH+/KtS0f71JNguh2gRmqA=;
        b=XZnQz5LQik3/pTIIY9LPGSWmcPDS9bzOnthgjm6YEPa02g5Cnao/HpXKqGLIPtG7ux
         /akYXM5VD/yHbg+iCNi21G2M4wGF3p9CJTl5Ow5uEbSTCQohIOgCrjVpmzt6tYtlYDNZ
         NthIeeyzF8kb3dsY61xtOnzpvxHqGf84w4fnDtbglx1HA9GHJBV1pdNwaIpNcbX37N2h
         5CSWN6JstIGNuuEWlGDRvf86OEMbV3HU+3weg/Ap/VL6MThiObXNFhB1qZCUCzJbCkUJ
         HJnUXSrrOWo+oE3FpbFyAhWi+Ubpeb8YuO4LPXs/4iV5iyc3lEbwemqavPhoZqiaAcb7
         pBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qNGeyiuY8r7ztH91OpIrJNH+/KtS0f71JNguh2gRmqA=;
        b=WYmGUT+cHTB/wla16n2Z2xuDuTfTMGw9BDXhij9vTQm/IDF/9LzQDbGHXG6ON/Cfkd
         oMjAyKTULpN5LYlExQ3rgnzqF+HELW9tJxWIgCSPb7vS0yKI7B+YFaB6/xB43V2gIShs
         y61l2wCy4rYsYowsG6Z0/Og8uYboV8zfaaxmnHhwpjhhW3iP0nF190PepdF8bBFF0UR6
         HToSf6kGBeNTy6101pg9okq++LPwZoRvt3zZqJ9qfScLyf+12+8fI5EPjOFJmUcsxki1
         nbyqIu6/gWKJaUaKHTuFzwljnaFE964LyS9mauXyzt9gp25Co/236aXTj7fnP+rJPXKs
         3UCQ==
X-Gm-Message-State: ACgBeo0ELI7xT8/7m3p3BXdtdAr70PqknS8juMWlKKZhhB3TCPQNDD/U
        Vuh4x41R56j5Chihj8Ij/bL6dw==
X-Google-Smtp-Source: AA6agR4HP+8Flsz5K8TAlJMGzNcDEpfoo++t9gru7Trv/E2ygSpdpkQRj+tD+dfMdOoJInd8SVLong==
X-Received: by 2002:a63:4d0e:0:b0:412:1877:9820 with SMTP id a14-20020a634d0e000000b0041218779820mr5116481pgb.177.1661558048820;
        Fri, 26 Aug 2022 16:54:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p125-20020a62d083000000b00537e40747b0sm477953pfg.42.2022.08.26.16.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 16:54:08 -0700 (PDT)
Date:   Fri, 26 Aug 2022 23:54:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 2/3] KVM: x86: Report CPUID.7.1 support on CPUs with
 CPUID.7 indices > 1
Message-ID: <YwldHBEo+7rg0sF3@google.com>
References: <20220826210019.1211302-1-jmattson@google.com>
 <20220826210019.1211302-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826210019.1211302-2-jmattson@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022, Jim Mattson wrote:
> Previously, KVM reported support for CPUID.(EAX=7,ECX=1) only if the
> maximum leaf 7 index on the host was exactly 1. A recent microcode
> patch for Ice Lake raised the maximum leaf 7 index from 0 to 2,
> skipping right over 1. Though that patch left CPUID.(EAX=7,ECX=1)
> filled with zeros on Ice Lake, it nonetheless exposed this bug.
> 
> Report CPUID.(EAX=7,ECX=1) support if the maximum leaf 7 index on the
> host is at least 1.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Fixes: bcf600ca8d21 ("KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 07be45c5bb93..64cdabb3cb2c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -886,7 +886,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		cpuid_entry_override(entry, CPUID_7_EDX);
>  
>  		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
> -		if (entry->eax == 1) {
> +		if (entry->eax >= 1) {

But as the comment says, above this is:

		entry->eax = min(entry->eax, 1u);

		...

		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
		if (entry->eax == 1) {

What am I missing?
