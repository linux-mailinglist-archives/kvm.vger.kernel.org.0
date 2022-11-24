Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E476637619
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKXKTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiKXKTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:19:23 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B95EC14A2E3
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:19:19 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBE0323A;
        Thu, 24 Nov 2022 02:19:25 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43B5F3F587;
        Thu, 24 Nov 2022 02:19:18 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:19:15 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 06/17] Use memfd for hugetlbfs when allocating
 guest ram
Message-ID: <Y39FIxcUhvdNGNfJ@monolith.localdoman>
References: <20221115111549.2784927-1-tabba@google.com>
 <20221115111549.2784927-7-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115111549.2784927-7-tabba@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Nov 15, 2022 at 11:15:38AM +0000, Fuad Tabba wrote:
> This removes the need of using a temporary file for the fd.

I'm confused by this. The man page for memfd_create says that it creates an
anonymous file that lives in RAM.

> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  util/util.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/util/util.c b/util/util.c
> index e6c0951..d6ceb5d 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -10,6 +10,14 @@
>  #include <sys/stat.h>
>  #include <sys/statfs.h>
>  
> +#ifndef MFD_HUGETLB
> +#define MFD_HUGETLB	0x0004U
> +#endif
> +
> +#ifndef MFD_HUGE_SHIFT
> +#define MFD_HUGE_SHIFT	26
> +#endif

Hm... on my machine these are defined in linux/memfd.h, maybe you are
missing the include?

> +
>  static void report(const char *prefix, const char *err, va_list params)
>  {
>  	char msg[1024];
> @@ -96,10 +104,12 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
>  
>  static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  {
> -	char mpath[PATH_MAX];
> +	const char *name = "kvmtool";
> +	unsigned int flags = 0;
>  	int fd;
>  	void *addr;
>  	u64 blk_size;
> +	int htsize;
>  
>  	blk_size = get_hugepage_blk_size(htlbfs_path);
>  	if (blk_size == 0 || blk_size > size) {
> @@ -107,13 +117,18 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  			(unsigned long long)blk_size, (unsigned long long)size);
>  	}
>  
> +	htsize = __builtin_ctzl(blk_size);
> +	if ((1ULL << htsize) != blk_size)
> +		die("Hugepage size must be a power of 2.\n");
> +
> +	flags |= MFD_HUGETLB;
> +	flags |= htsize << MFD_HUGE_SHIFT;

If I understand the intention correctly, this entire sequence can be
rewritten using is_power_of_two() from util.h:

	if (!is_power_of_two(blk_size))
		die("Hugepage size must be a power of 2");

	flags |= MFD_HUGETLB;
	flags |= blk_size << MFD_HUGE_SHIFT;

Also, die() automatically adds the newline at the end of the string.
That's unless you specifically wanted two newline characters at the end of
the message.

> +
>  	kvm->ram_pagesize = blk_size;
>  
> -	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
> -	fd = mkstemp(mpath);
> +	fd = memfd_create(name, flags);
>  	if (fd < 0)
> -		die("Can't open %s for hugetlbfs map\n", mpath);
> -	unlink(mpath);
> +		die("Can't memfd_create for hugetlbfs map\n");

die_perror("memfd_create")? That way you also print the error number and
the message associated with it. Same thing with the other die statements
here, replacing them with die_perror() looks like it would be helpful.

Thanks,
Alex

>  	if (ftruncate(fd, size) < 0)
>  		die("Can't ftruncate for mem mapping size %lld\n",
>  			(unsigned long long)size);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
