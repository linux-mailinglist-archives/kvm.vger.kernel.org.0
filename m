Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AFC575783
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 00:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbiGNWTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbiGNWTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 18:19:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688541FCD6
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:19:09 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso4370014pjj.5
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7S4OyX7jxNdZTtoluQBkHlYCbrXzOUsDcIYAnp8PkF8=;
        b=JReXxHF9LvhmSk2uaPFYgL3Ww3vjdrL4PGgqPE+0h57H2+lKyjyt5WL76+aX9dxMEV
         kTMoRmYy2Sx5sPAFilA+S7K7eriDH+/7+fFL55XBsnQUGbjhbxZ1+4IAknzHLYmzsaBE
         SouITTBB1Q/rRXkv4hAbz0f+9Fx37O74MK8wbaVv0DiwBjOzH7IDd2Ckn6odw67zk88W
         bMeHnF3hF2tI1OFHC/1K2eUUNMZLg5q+Ez38uYzntjFYCYqseSLQTyrP/pxaI5ZUZtdN
         eVUM34q/pjo52FsVtlZjiAbiynBjfN5DZq3qoMFpXJ74X0Yzc3CheHmCEOMZirDeZO+L
         TPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7S4OyX7jxNdZTtoluQBkHlYCbrXzOUsDcIYAnp8PkF8=;
        b=P9L38hyOUYqNcHU2XM8VyIzeUO10rFKTQ55i1BE4uuW+YRfBQB7mbx4jNUjZgycs+p
         PW2AfBlzl/srMerNtWTW23J2rB+10RBmPmWHzWoOuPVLP13ofliXChvjM3cr95anOdQd
         L217+uDfOfuE+U5xiBvk3K7dvRjmGE0pGJu4PtO+I9p16mvknFtwmx1yYwx1QNd3XXSQ
         tzdyN252U/50W452K1iccH4OfVxWN46OnKaZrqdWfyqWHc+XnEO3OtxM/Ww+Vxuf/T7H
         zJyn3z6+GGFhP9GIo2IGvIzJdVVDrGDbhbyxdwlWXpdnoUvdEnpflV/VYzU8pYrwCdYT
         SwjQ==
X-Gm-Message-State: AJIora93qFj+dIKqMRxNZhLawFuX8G0rD8UKu+0dKhF1M9xE7jSHFhQ5
        vp9SaqKBCQWAMRaMPk7nu71eVQ==
X-Google-Smtp-Source: AGRyM1vqvzFPgF5HqMszLzMiggefbwmwiMWWdiL8g8famC5eLaGfINNS2DTJU0PYsXmJICCZW2quiQ==
X-Received: by 2002:a17:90b:33c9:b0:1f0:35be:3038 with SMTP id lk9-20020a17090b33c900b001f035be3038mr17929217pjb.61.1657837148782;
        Thu, 14 Jul 2022 15:19:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f62-20020a623841000000b005252680aa30sm2247225pfa.3.2022.07.14.15.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 15:19:08 -0700 (PDT)
Date:   Thu, 14 Jul 2022 22:19:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 03/12] KVM: X86/MMU: Split a part of kvm_unsync_page() as
 kvm_mmu_page_mark_unsync()
Message-ID: <YtCWWV0RGKcZvW+C@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-4-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Make it as the opposite function of kvm_mmu_page_clear_unsync().
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c20981dfc4fd..cc0207e26f6e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2529,12 +2529,16 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
>  	return r;
>  }
>  
> -static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +static void kvm_mmu_page_mark_unsync(struct kvm *kvm, struct kvm_mmu_page *sp)

The existing code is anything but consistent, but I think I prefer the pattern:

	kvm_mmu_<action>_<target>_<flag>

I.e. kvm_mmu_mark_page_unsync() + kvm_mmu_unmark_page_unsync() to yield:

	kvm_mmu_mark_page_unsync(kvm, sp);
	kvm_mmu_mark_parents_unsync(sp);

so that at least this code will be consistent with itself.

>  {
>  	trace_kvm_mmu_unsync_page(sp);
>  	++kvm->stat.mmu_unsync;
>  	sp->unsync = 1;
> +}
>  
> +static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)

Rather than keep kvm_unsync_page(), what about just open coding the calls in
mmu_try_to_unsync_pages()?  I can't imagine we'll ever have a second caller.

There won't be a direct pair to kvm_sync_page(), but that's not necessarily a bad
thing since they are really direct opposites anyway.

> +{
> +	kvm_mmu_page_mark_unsync(kvm, sp);
>  	kvm_mmu_mark_parents_unsync(sp);
>  }
>  
> -- 
> 2.19.1.6.gb485710b
> 
