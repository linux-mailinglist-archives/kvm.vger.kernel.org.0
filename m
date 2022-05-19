Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6AB52CAB4
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiESEII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiESEIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:08:06 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DC7AFB1B
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:08:05 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i5so2909660ilv.0
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nj5KQVd1OJhKMBpI3dKx9i9Ki3E8QExPEDMYs5rR530=;
        b=lIuNT0ZnKxDSdc8oh2ofVYr3MkW4rvDsYQ2WDauejIdhLe7yO/d8AaIqtn4aRLZhLT
         RnqEJnJ5s9Bq8QaMofige9b1LT6saZbZ+xWQIY1jwq2axFrj6ZYB3r+N//+PSCXAmVg2
         uzsxOEnpHwB/0eqwa9+5hlH1Hmbn1M1r8ZDmU7Awf7omJOn7Fjjcs7m+pwHGAn2xWOSX
         UlQPK9+Nuus4orOH/ICQG0W8SRRTowAprKCHu9QnNACI49grXur0wwC/l5N7l3hy2K6P
         VTBtMAR6NPs5Njsir7jgMQPMJLDN/6Vt2DxgDBMu6wvkBiUu58PBP6e/l2Y9CrhmQsFf
         mhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nj5KQVd1OJhKMBpI3dKx9i9Ki3E8QExPEDMYs5rR530=;
        b=BhH+/w6Xx9Z7FBe4dDpO9NjwFt87vHGuZ6MFLERTvnfvklPGqZK39wI7yfwVe5b7fj
         JXPDAWPuXPxJ2C62JqXa21VlsCy2PkrG/HLM0UPBCy0Ve3QuqybfBO558DKeahhv4RvL
         T/64ap2FUqenVEgfn8J8qZZZbM87TOR7xeFp6FmLWkCAfcS3iiFjjEeRjw7ZmWuSeXRH
         VI6T8h0PSV7oJPi6im5Od8mSEe030sWJju9WH+0Pl/ljy/FtznnMBztEccxNcK45SfgV
         +lMVzXWAsDfbT4f5hCRVtpo2xkpwzecuwkGDs9NAPeiMhQeIV/jfOMS3ZD54bw+5INRs
         NsSg==
X-Gm-Message-State: AOAM533N/BWeoH7NQ9dOB7pHnPzYxfjM7lZrwlKEECXplIZ3TpETBtkz
        wfO4rTTr+cASHptxmALUyodhdw==
X-Google-Smtp-Source: ABdhPJzIGKt84nooOm9oNb8M4+11sa6pQyYAJzvAey2phxzjoWvC1jbMONVKJmqypKPkNRwqm5VM7A==
X-Received: by 2002:a05:6e02:216a:b0:2d1:3b03:e77b with SMTP id s10-20020a056e02216a00b002d13b03e77bmr1675875ilv.148.1652933284839;
        Wed, 18 May 2022 21:08:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id l7-20020a023907000000b0032e0851ea0fsm382180jaa.10.2022.05.18.21.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 21:08:04 -0700 (PDT)
Date:   Thu, 19 May 2022 04:08:00 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 06/13] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <YoXCoGyg8Gje+FB5@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-7-ricarkol@google.com>
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

On Thu, Apr 07, 2022 at 05:41:13PM -0700, Ricardo Koller wrote:
> Add a library function to get the backing source FD of a memslot.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 3a69b35e37cc..c8dce12a9a52 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 268ad3d75fe2..a0a9cd575fac 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  	return &region->region;
>  }
>  
> +/*
> + * KVM Userspace Memory Get Backing Source FD
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - KVM memory slot ID
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> + *
> + * Returns the backing source fd of a memslot, so tests can use it to punch
> + * holes, or to setup permissions.
> + */
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> +{
> +	struct userspace_mem_region *region;
> +
> +	region = memslot2region(vm, memslot);
> +	return region->fd;
> +}
> +
>  /*
>   * VCPU Find
>   *
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
