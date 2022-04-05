Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED404F5516
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445062AbiDFF2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586353AbiDFABY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:01:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7858AAC90D
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:27:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z16so774528pfh.3
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/F9FcwctkCW+3E2y6H+mYNn9o98TaWKZ4egRhw2n8U4=;
        b=CJBcRD2/eIRg2nJUKgCWXkp/3dt4Jks9/MQLAjuBfjmshUl+09vz9rWZTtwOURZaTY
         TD8tFA4l6SCkHkvYEiWTZMaC3YUS68yWhWMjKvJdgmrjq7mkDrSxmeMePZUQAtb+bQ2l
         cst0pG/3Mx9DEERt9Ia+Ey5cRCjFUZQeNMTU3aVOvHkKJcCODwPuQEqHliscG7BJDJsT
         OXkJunvXAzqhk5OMmOU2IDLahBZgQt82hMiwgMjegFBB2LNtfG05qEr+egbGYMZS6VR1
         +meQgCSGnIWCTCzqpLqbUTuAyD8J/DNCQV+/JRcnNh/wMSzdN6cB+JAs/XEHH8pB1fxr
         LZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/F9FcwctkCW+3E2y6H+mYNn9o98TaWKZ4egRhw2n8U4=;
        b=E7barQLHFZDjmzfVZqXGlBmWD23Nh9ceXxhdxacwpZR4JpAWEPdh8a2VYaNtKDXNSp
         BfTVoLwEc+kDBNEnc1/D10oUlTjssHOh1gbYuhN/tah8tJXstxBOk9Qru5hpZZlNfRKH
         HjmVGmS5jXO3F4ZHhH6RMmzI+JVADP36i/cGsGyLRzjYhuVN5LQiS9P2knnTx322/ncc
         uYxfecumq3IFZ8XLXk1Hyr7m6LvUVQLVyvEcdXKeCLWetDxlRAkgFulvHLnqJyXxl6Fw
         JlCfzBLsbjl96V5fAYeoi0Acm1zFQt2DugwINCd93v79tWPdXgZ5UPZS77phY7A+0Moi
         swdQ==
X-Gm-Message-State: AOAM532N31IgDXGOfOI4FESXeS35h19GkQCRpe7ZmtbOZ9RIisPcQJCI
        oFUa2APBGdBU4Alpb4zVXxoBbQ==
X-Google-Smtp-Source: ABdhPJxs9PH/uSAK+InP3KJdR6deavJYk0JCPXue0V3tWnYHg1tWuqMoOVV8w1miTG2AF29WKVFerg==
X-Received: by 2002:a05:6a02:204:b0:399:1c4:3f45 with SMTP id bh4-20020a056a02020400b0039901c43f45mr4525831pgb.246.1649197659736;
        Tue, 05 Apr 2022 15:27:39 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00229000b004fabe756ba6sm18332940pfe.54.2022.04.05.15.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:27:38 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:27:35 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 04/11] KVM: selftests: Add memslot parameter to
 elf_load
Message-ID: <YkzCV00n9KyZf5gs@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-5-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:14AM -0700, Ben Gardon wrote:
> Currently elf_load loads code into memslot 0. Add a parameter to allow
> loading code into any memslot. This will be useful for backing code
> pages with huge pages in future commits.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util_base.h  |  5 +++++
>  tools/testing/selftests/kvm/lib/elf.c              | 13 +++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 14 ++++++++++----
>  3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 78c4407f36b4..72163ba2f878 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -122,7 +122,10 @@ uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
>  int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
>  		       size_t len);
>  
> +void kvm_vm_elf_load_memslot(struct kvm_vm *vm, const char *filename,
> +			     uint32_t memslot);
>  void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
> +
>  int kvm_memfd_alloc(size_t size, bool hugepages);
>  
>  void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
> @@ -169,6 +172,8 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> +vm_vaddr_t vm_vaddr_alloc_memslot(struct kvm_vm *vm, size_t sz,
> +				  vm_vaddr_t vaddr_min, uint32_t memslot);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
>  vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 13e8e3dcf984..899418e65f60 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -97,6 +97,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>   *
>   * Input Args:
>   *   filename - Path to ELF file
> + *   memslot - the memslot into which the elf should be loaded
>   *
>   * Output Args: None
>   *
> @@ -111,7 +112,8 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>   * by the image and it needs to have sufficient available physical pages, to
>   * back the virtual pages used to load the image.
>   */
> -void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
> +void kvm_vm_elf_load_memslot(struct kvm_vm *vm, const char *filename,
> +			     uint32_t memslot)

Feedback I've gotten in the past for kernel code and selftests is to
just use double-underscores (i.e. __kvm_vm_elf_load()) for situations
like this, rather than trying to encode the extra parameters in the
function name.

>  {
>  	off_t offset, offset_rv;
>  	Elf64_Ehdr hdr;
> @@ -162,7 +164,9 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>  		seg_vend |= vm->page_size - 1;
>  		size_t seg_size = seg_vend - seg_vstart + 1;
>  
> -		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
> +		vm_vaddr_t vaddr = vm_vaddr_alloc_memslot(vm, seg_size,
> +							  seg_vstart,
> +							  memslot);
>  		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
>  			"virtual memory for segment at requested min addr,\n"
>  			"  segment idx: %u\n"
> @@ -191,3 +195,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>  		}
>  	}
>  }
> +
> +void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
> +{
> +	kvm_vm_elf_load_memslot(vm, filename, 0);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9c4574381daa..09742a787546 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1336,8 +1336,7 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>   *   vm - Virtual Machine
>   *   sz - Size in bytes
>   *   vaddr_min - Minimum starting virtual address
> - *   data_memslot - Memory region slot for data pages
> - *   pgd_memslot - Memory region slot for new virtual translation tables
> + *   memslot - Memory region slot for data pages
>   *
>   * Output Args: None
>   *
> @@ -1350,13 +1349,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>   * a unique set of pages, with the minimum real allocation being at least
>   * a page.
>   */
> -vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
> +vm_vaddr_t vm_vaddr_alloc_memslot(struct kvm_vm *vm, size_t sz,
> +				  vm_vaddr_t vaddr_min, uint32_t memslot)

Same feedback here; use __vm_vaddr_alloc().

>  {
>  	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
>  
>  	virt_pgd_alloc(vm);
>  	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
> -					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
> +					      KVM_UTIL_MIN_PFN * vm->page_size,
> +					      memslot);
>  
>  	/*
>  	 * Find an unused range of virtual page addresses of at least
> @@ -1377,6 +1378,11 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
>  	return vaddr_start;
>  }
>  
> +vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
> +{
> +	return vm_vaddr_alloc_memslot(vm, sz, vaddr_min, 0);
> +}
> +
>  /*
>   * VM Virtual Address Allocate Pages
>   *
> -- 
> 2.35.1.1021.g381101b075-goog
> 
