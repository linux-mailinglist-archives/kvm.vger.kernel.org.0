Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8A938B92C
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 23:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhETVtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 17:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhETVtN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 17:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621547270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XC8hTTPMnhJA7WoqcGgeVhcdrCpAnq7g7eLCDPc50o8=;
        b=Lpbr1y8VkKtGX4o6kvfhak6zYUvJOnHeX7iviyjsH8zxCvFDBcop+BUINSJL2LU2jKi9b9
        urpT7k1ewjzdr83S05Z055pNN3IQNZEZXMVSaLD2a2VsulaVS5PGy4QXR/whvjdh+rfgLR
        x6HZKxV1WO0YfgkepzlGCIKujPVxpyU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-ZvsfezEsOVOtJJAekF6jwg-1; Thu, 20 May 2021 17:47:48 -0400
X-MC-Unique: ZvsfezEsOVOtJJAekF6jwg-1
Received: by mail-qv1-f70.google.com with SMTP id bc3-20020ad456830000b02901f47dbd7ef6so4487119qvb.6
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 14:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XC8hTTPMnhJA7WoqcGgeVhcdrCpAnq7g7eLCDPc50o8=;
        b=plxUuAExrFzBPWePlYreGe4F6HkmcS//KZpqxkMggrUSt9VTmvQ/ka5vf8Fb5CinUZ
         9svL0NmKxNbh8jZWYdeGW8kMsU31gmYXMRH20ze1QTrbVC3f5xbctV4ilmQ2L5tdQkz8
         feiJo46SvPHc8UP3eOQTE6RtmG2ubjDXvMqc9SDqr++/30xI1LcPZ6RM96wkfRp6UWSZ
         +V3+wLGfL0K38OgEvW9UWAacvlhChYaJF1nyWFa6z0488N8HNLd+d21VX+Klmh6EK4SR
         +ma3g8KEVz7vF1VPMid8xRg2PnAIkzarddaaB/2l1eLNQoCQoTNVzr/AJBL3qHiI4qxQ
         BbEA==
X-Gm-Message-State: AOAM5339m+ol7c5fW2bXITGCkyUSUBEfa/8z6ciOVOwqWKFO59remPkN
        idGLVzE9fCmCwBN2wXq1cDuG5o3tL8O2mpM3fWiQmIJZClgE2P6bKzYafgTFHghllBVrvX53KE2
        ow8oomqJ8x/hC
X-Received: by 2002:a05:622a:164d:: with SMTP id y13mr7301966qtj.375.1621547268239;
        Thu, 20 May 2021 14:47:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU6KMp3v91B7x/r5MrQsSpt9F0xVg6ZTTOowq6G6Fz6sfjOmn1ALHhmUeCyiWhe8ab7nmxgA==
X-Received: by 2002:a05:622a:164d:: with SMTP id y13mr7301934qtj.375.1621547267912;
        Thu, 20 May 2021 14:47:47 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id b17sm3192261qka.94.2021.05.20.14.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 14:47:47 -0700 (PDT)
Date:   Thu, 20 May 2021 17:47:45 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
Message-ID: <YKbZAT/cE5SobbGX@t490s>
References: <20210520212654.712276-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210520212654.712276-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 09:26:54PM +0000, David Matlack wrote:
> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> which causes the upper 32-bits of the max_gfn to get truncated.
> 
> Nobody noticed until now likely because vm_get_max_gfn() is only used
> as a mechanism to create a memslot in an unused region of the guest
> physical address space (the top), and the top of the 32-bit physical
> address space was always good enough.

s/top/bottom/?

Looks right.. thanks for fixing it!

> 
> This fix reveals a bug in memslot_modification_stress_test which was
> trying to create a dummy memslot past the end of guest physical memory.
> Fix that by moving the dummy memslot lower.

Would it be better to split the different fixes?

> 
> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
>  .../testing/selftests/kvm/lib/perf_test_util.c |  2 +-
>  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
>  4 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 84982eb02b29..5d9b35d09251 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -303,7 +303,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>  
>  unsigned int vm_get_page_size(struct kvm_vm *vm);
>  unsigned int vm_get_page_shift(struct kvm_vm *vm);
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm);
>  int vm_get_fd(struct kvm_vm *vm);
>  
>  unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1af1009254c4..aeffbb1e7c7d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2058,7 +2058,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
>  	return vm->page_shift;
>  }
>  
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm)
>  {
>  	return vm->max_gfn;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 81490b9b4e32..ed4424ed26d6 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -80,7 +80,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  	 */
>  	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
>  		    "Requested more guest memory than address space allows.\n"
> -		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> +		    "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",

If to fix it, maybe start to use PRIu64 (and include inttypes.h)?

Thanks,

-- 
Peter Xu

