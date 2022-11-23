Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766F06365F7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbiKWQkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiKWQkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:40:06 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 842FCB9632
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:40:05 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1E7F1FB;
        Wed, 23 Nov 2022 08:40:11 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BE493F73B;
        Wed, 23 Nov 2022 08:40:04 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:40:01 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 03/17] Rename parameter in
 mmap_anon_or_hugetlbfs()
Message-ID: <Y35M4W46JjeU88e/@monolith.localdoman>
References: <20221115111549.2784927-1-tabba@google.com>
 <20221115111549.2784927-4-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115111549.2784927-4-tabba@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Nov 15, 2022 at 11:15:35AM +0000, Fuad Tabba wrote:
> For consistency with other similar functions in the same file and
> for brevity.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/kvm/util.h | 2 +-
>  util/util.c        | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index b0c3684..61a205b 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -140,6 +140,6 @@ static inline int pow2_size(unsigned long x)
>  }
>  
>  struct kvm;
> -void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> +void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>  
>  #endif /* KVM__UTIL_H */
> diff --git a/util/util.c b/util/util.c
> index 093bd3b..22b64b6 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -118,14 +118,14 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  }
>  
>  /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
> -void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
> +void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)

All the functions that deal with hugetlbfs have "hugetlbfs" in the name,
and the kvm_config field is called hugetlbfs_path. Wouldn't it make more
sense to rename the htlbfs_path parameter to hugetlbs_path instead of the
other way around?

Thanks,
Alex

>  {
> -	if (hugetlbfs_path)
> +	if (htlbfs_path)
>  		/*
>  		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
>  		 * if the user specifies a hugetlbfs path.
>  		 */
> -		return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
> +		return mmap_hugetlbfs(kvm, htlbfs_path, size);
>  	else {
>  		kvm->ram_pagesize = getpagesize();
>  		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
