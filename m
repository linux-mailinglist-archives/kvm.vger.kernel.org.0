Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C32557E2B
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiFWOty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFWOtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:49:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C38146669
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:49:51 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 9so1074180pgd.7
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+qSsChT75v3dvhRAkXYqSV2TfsP5NCarupm2V9Kqui0=;
        b=Yz5N2ry9uNEF1gaCrCZKOslUu3DOdurMNWT1q6KWoCmT2NDA4a+LtMpMgwsnVfK7zZ
         RsRoEVr//JBe44DK1MPKhvSYbDQEx/uQDDfuM1g7Fd/GXkj2UvofhpAgxVqE6XuVFjei
         RcT6g1GMZMEu+84zRGCPZTX491w5ladQzU+KEdRiqOwVWr85a5ka7cpCuMBsW+SyES8p
         owJ5Gu1oonI/fBRiqhh7dfwfdguVM1ck5qAZBPl7Q3xcxrjQB0vZjt0qFDZWR34kQOjl
         fcxmI1ChSM01swtv8XSTLbvCTm1tyxxteXF6A4GjAvQYNaZesY9YQzaluqk8xoHdg5+g
         JdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+qSsChT75v3dvhRAkXYqSV2TfsP5NCarupm2V9Kqui0=;
        b=Ui5POHYH8rxqBN6tO/V0XN3O6XS4Hp6IgYI3ds9WBCep5yQcAZY1tCiiMeuF2MO6pa
         uKDpG/SX5uNhzIkFYqq9S79cxPuzqGshF1LCWaLXn9UcbUZHxeWIw5Tet4SWyzsRCux9
         +iwjiborCfc3N0BA5dqqHTCQAiK0MSBugqAlKRvmQSbhtUh0k0bEEBktWQ/CO/Sj2N7D
         /I/Yfl0wWIIlQbi6R7viT3UxD1K8HvqLrlG5Tvhb90Yi5goQqrjgDfmgkAxptqnrcoRu
         bDUu+/HK5oOJLPFRSPRcRmd8YEmhlOOJDFQ2EeJH95BGYAvxaXIpFasCGidkhFvmTyBT
         pWEw==
X-Gm-Message-State: AJIora90rceHZsEP9b5UBCiiowoA3HUlcPBxIa9ACQ8hD+KMx9J5rDuS
        MQx3KfQJwcGzls/8eQ56I3Y9hg==
X-Google-Smtp-Source: AGRyM1u61EzUEh+JRGUbY08AnREjTd6Ub3VvJ0Hteh1fCeq4G/TENL2UDjYm4NKsqKEpJH2VZPMPPg==
X-Received: by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id u34-20020a056a0009a200b00505974f9fd6mr40733440pfg.12.1655995790918;
        Thu, 23 Jun 2022 07:49:50 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090ad35600b001ec8d191db4sm2003335pjx.17.2022.06.23.07.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:49:50 -0700 (PDT)
Date:   Thu, 23 Jun 2022 14:49:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <YrR9i3yHzh5ftOxB@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622213656.81546-3-peterx@redhat.com>
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

On Wed, Jun 22, 2022, Peter Xu wrote:
> Merge two boolean parameters into a bitmask flag called kvm_gtp_flag_t for
> __gfn_to_pfn_memslot().  This cleans the parameter lists, and also prepare
> for new boolean to be added to __gfn_to_pfn_memslot().

...

> @@ -3999,8 +4000,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	}
>  
>  	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
> -					  fault->write, &fault->map_writable,
> +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags,
> +					  &async, &fault->map_writable,
>  					  &fault->hva);
>  	if (!async)
>  		return RET_PF_CONTINUE; /* *pfn has correct page already */
> @@ -4016,9 +4017,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  	}
>  
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags, NULL,
> +					  &fault->map_writable, &fault->hva);
>  	return RET_PF_CONTINUE;
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c20f2d55840c..b646b6fcaec6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1146,8 +1146,15 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		      bool *writable);
>  kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
> +
> +/* gfn_to_pfn (gtp) flags */
> +typedef unsigned int __bitwise kvm_gtp_flag_t;
> +
> +#define  KVM_GTP_WRITE          ((__force kvm_gtp_flag_t) BIT(0))
> +#define  KVM_GTP_ATOMIC         ((__force kvm_gtp_flag_t) BIT(1))
> +
>  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> -			       bool atomic, bool *async, bool write_fault,
> +			       kvm_gtp_flag_t gtp_flags, bool *async,
>  			       bool *writable, hva_t *hva);

I completely agree the list of booleans is a mess, but I don't love the result of
adding @flags.  I wonder if we can do something similar to x86's struct kvm_page_fault
and add an internal struct to pass params.  And then add e.g. gfn_to_pfn_interruptible()
to wrap that logic.

I suspect we could also clean up the @async behavior at the same time, as its
interaction with FOLL_NOWAIT is confusing.
