Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B7C645C7A
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 15:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiLGO0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 09:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLGOZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 09:25:58 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAEC05E9D8
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 06:25:49 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56C3B23A;
        Wed,  7 Dec 2022 06:25:56 -0800 (PST)
Received: from [10.57.7.204] (unknown [10.57.7.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 468AB3F73D;
        Wed,  7 Dec 2022 06:25:48 -0800 (PST)
Message-ID: <94872199-2466-756b-df4a-bbf699e40a0b@arm.com>
Date:   Wed, 7 Dec 2022 14:25:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH kvmtool v1 25/32] Allocate guest memory as restricted
 if needed
To:     Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org
References: <20221202174417.1310826-1-tabba@google.com>
 <20221202174417.1310826-26-tabba@google.com>
Content-Language: en-GB
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20221202174417.1310826-26-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 17:44, Fuad Tabba wrote:
> If specified by the option and supported by KVM, allocate guest
> memory as restricted with the new system call.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arm/aarch64/pvtime.c |  2 +-
>  hw/vesa.c            |  2 +-
>  include/kvm/util.h   |  2 +-
>  util/util.c          | 12 ++++++++----
>  4 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> index a452938..8247c52 100644
> --- a/arm/aarch64/pvtime.c
> +++ b/arm/aarch64/pvtime.c
> @@ -16,7 +16,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
>  	int mem_fd;
>  	int ret = 0;
>  
> -	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
> +	mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0);
>  	if (mem_fd < 0)
>  		return -errno;
>  
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 3233794..6c5287a 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -90,7 +90,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	if (r < 0)
>  		goto unregister_ioport;
>  
> -	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
> +	mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0, 0);
>  	if (mem_fd < 0) {
>  		r = -errno;
>  		goto unregister_device;
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index 79275ed..5a98d4a 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -139,7 +139,7 @@ static inline int pow2_size(unsigned long x)
>  }
>  
>  struct kvm;
> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 hugepage_size);
>  void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
>  				   u64 size, u64 align);
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> diff --git a/util/util.c b/util/util.c
> index 107f34d..13b3e82 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -17,7 +17,7 @@
>  __SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
>  #endif
>  
> -static inline int memfd_restricted(unsigned int flags)
> +static int memfd_restricted(unsigned int flags)
>  {
>  	return syscall(__NR_memfd_restricted, flags);
>  }
> @@ -106,7 +106,7 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
>  	return sfs.f_bsize;
>  }
>  
> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 blk_size)
>  {
>  	const char *name = "kvmtool";
>  	unsigned int flags = 0;
> @@ -120,7 +120,11 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
>  		flags |= blk_size << MFD_HUGE_SHIFT;
>  	}
>  
> -	fd = memfd_create(name, flags);
> +	if (kvm->cfg.restricted_mem)
> +		fd = memfd_restricted(flags);
> +	else
> +		fd = memfd_create(name, flags);
> +
>  	if (fd < 0)
>  		die_perror("Can't memfd_create for memory map");
>  
> @@ -167,7 +171,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
>  	if (addr_map == MAP_FAILED)
>  		return MAP_FAILED;
>  
> -	fd = memfd_alloc(size, hugetlbfs_path, blk_size);
> +	fd = memfd_alloc(kvm, size, hugetlbfs_path, blk_size);
>  	if (fd < 0)
>  		return MAP_FAILED;
>  
Extra context:
> 	/* Map the allocated memory in the fd to the specified alignment. */
> 	addr_align = (void *)ALIGN((u64)addr_map, align_sz);
> 	if (mmap(addr_align, size, PROT_RW, MAP_SHARED | MAP_FIXED, fd, 0) ==
> 	    MAP_FAILED) {
> 		close(fd);
> 		return MAP_FAILED;
> 	}

So I don't understand how this works. My understanding is that
memfd_restricted() returns a file descriptor that cannot be mapped in
user space. So surely this mmap() will always fail (when
kvm->cfg.restricted_mem)?

What am I missing?

Thanks,

Steve

