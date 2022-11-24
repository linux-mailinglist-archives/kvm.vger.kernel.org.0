Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9604F637702
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKXLBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiKXLBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:01:34 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8760397348
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:01:32 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFB6123A;
        Thu, 24 Nov 2022 03:01:38 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55C9D3F587;
        Thu, 24 Nov 2022 03:01:31 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:01:28 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
Message-ID: <Y39PCG0ZRHf/2d5E@monolith.localdoman>
References: <20221115111549.2784927-1-tabba@google.com>
 <20221115111549.2784927-9-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115111549.2784927-9-tabba@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Nov 15, 2022 at 11:15:40AM +0000, Fuad Tabba wrote:
> Allocate all guest ram backed by memfd/ftruncate instead of
> anonymous mmap. This will make it easier to use kvm with fd-based
> kvm guest memory proposals [*]. It also would make it easier to
> use ipc memory sharing should that be needed in the future.

Today, there are two memory allocation paths:

- One using hugetlbfs when --hugetlbfs is specified on the command line, which
  creates a file.

- One using mmap, when --hugetlbfs is not specified.

How would support in kvmtool for the secret memfd look like? I assume there
would need to be some kind of command line parameter to kvmtool to instruct it
to use the secret memfd, right? What I'm trying to figure out is why is
necessary to make everything a memfd file instead of adding a third memory
allocation path just for that particular usecase (or merging the hugetlbfs path
if they are similar enough). Right now, the anonymous memory path is a
mmap(MAP_ANONYMOUS) call, simple and straightforward, and I would like some more
convincing that this change is needed.

Regarding IPC memory sharing, is mmap'ing an memfd file enough to enable
that? If more work is needed for it, then wouldn't it make more sense to do
all the changes at once? This change might look sensible right now, but it
might turn out that it was the wrong way to go about it when someone
actually starts implementing memory sharing.

Thanks,
Alex

> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> [*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.intel.com/
> ---
>  include/kvm/kvm.h  |  1 +
>  include/kvm/util.h |  3 +++
>  kvm.c              |  4 ++++
>  util/util.c        | 33 ++++++++++++++++++++-------------
>  4 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 3872dc6..d0d519b 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -87,6 +87,7 @@ struct kvm {
>  	struct kvm_config	cfg;
>  	int			sys_fd;		/* For system ioctls(), i.e. /dev/kvm */
>  	int			vm_fd;		/* For VM ioctls() */
> +	int			ram_fd;		/* For guest memory. */
>  	timer_t			timerid;	/* Posix timer for interrupts */
>  
>  	int			nrcpus;		/* Number of cpus to run */
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index 61a205b..369603b 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x)
>  }
>  
>  struct kvm;
> +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> +void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *htlbfs_path,
> +				   u64 size, u64 align);
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>  
>  #endif /* KVM__UTIL_H */
> diff --git a/kvm.c b/kvm.c
> index 78bc0d8..ed29d68 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
>  	mutex_init(&kvm->mem_banks_lock);
>  	kvm->sys_fd = -1;
>  	kvm->vm_fd = -1;
> +	kvm->ram_fd = -1;
>  
>  #ifdef KVM_BRLOCK_DEBUG
>  	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
> @@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
>  
>  	kvm__arch_delete_ram(kvm);
>  
> +	if (kvm->ram_fd >= 0)
> +		close(kvm->ram_fd);
> +
>  	list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list) {
>  		list_del(&bank->list);
>  		free(bank);
> diff --git a/util/util.c b/util/util.c
> index d3483d8..278bcc2 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
>  	return sfs.f_bsize;
>  }
>  
> -static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size, u64 blk_size)
> +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
>  {
>  	const char *name = "kvmtool";
>  	unsigned int flags = 0;
>  	int fd;
> -	void *addr;
> -	int htsize = __builtin_ctzl(blk_size);
>  
> -	if ((1ULL << htsize) != blk_size)
> -		die("Hugepage size must be a power of 2.\n");
> +	if (hugetlb) {
> +		int htsize = __builtin_ctzl(blk_size);
>  
> -	flags |= MFD_HUGETLB;
> -	flags |= htsize << MFD_HUGE_SHIFT;
> +		if ((1ULL << htsize) != blk_size)
> +			die("Hugepage size must be a power of 2.\n");
> +
> +		flags |= MFD_HUGETLB;
> +		flags |= htsize << MFD_HUGE_SHIFT;
> +	}
>  
>  	fd = memfd_create(name, flags);
>  	if (fd < 0)
> -		die("Can't memfd_create for hugetlbfs map\n");
> +		die("Can't memfd_create for memory map\n");
> +
>  	if (ftruncate(fd, size) < 0)
>  		die("Can't ftruncate for mem mapping size %lld\n",
>  			(unsigned long long)size);
> -	addr = mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
> -	close(fd);
>  
> -	return addr;
> +	return fd;
>  }
>  
>  /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  {
>  	u64 blk_size = 0;
> +	int fd;
>  
>  	/*
>  	 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
> @@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  		}
>  
>  		kvm->ram_pagesize = blk_size;
> -		return mmap_hugetlbfs(kvm, htlbfs_path, size, blk_size);
>  	} else {
>  		kvm->ram_pagesize = getpagesize();
> -		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>  	}
> +
> +	fd = memfd_alloc(size, htlbfs_path, blk_size);
> +	if (fd < 0)
> +		return MAP_FAILED;
> +
> +	kvm->ram_fd = fd;
> +	return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0);
>  }
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
