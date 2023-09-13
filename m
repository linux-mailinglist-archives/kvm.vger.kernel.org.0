Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3224079F08E
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjIMRqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjIMRqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:46:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658E519AD
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:46:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d814105dc2cso101020276.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694627172; x=1695231972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ocbK288Al1DpwUeolIoLVHrflqgxdyru7h8mWey0wo=;
        b=bRX+fw1+7a8iLbidTBYkBFr230SoMZaQINwo5EkmKFYmLyz9FO0777ON+9CDsoGgrP
         RaIqSQ2eWPwWpntXBcu+yu6b6IDeZBcDQy76lEtrZOqoVYHIByG2RM18r0FkRlb0CsP1
         t6uY/IL3he/h3anC+mQ/mBRJcfSJsFqXYbnGzHhnz8T+kFeBxbbqw8iTj/2EpoULBWSi
         8rnbNQVjIejAYZNqTB4vhu9dmBzMVho3SkfEyZv0DYFIkFn6dxjx806hFB+K9XeNTHJy
         a0gEN8EwkaivFPpkJcw+0ZzIxaXZM18f4G9XxABHYxy84fFWU7whDgIWALFZwAQfyMl/
         LOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694627172; x=1695231972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ocbK288Al1DpwUeolIoLVHrflqgxdyru7h8mWey0wo=;
        b=C0imMusiuELh9Xe2Wjmdd2nhUPjW18PFJ45Eu4xNIwwRGuzHDczN3fEsopUw934rgm
         xYknl3EG0W1CPvNs94rnWcBp1OQOFGD1L38KNbaQIE7McLFvkDg6U/O9TmiFQ7lwilt3
         2JIAMVaW6DurWtF53lpFetuiX8If6X6BExFym5G4jsQRb1aHyb1jGyv7+21lzNb1PinG
         AWGlVHLF2/HhkmmQTwFNb659AbrNZ5U/mNpx6zo7ETfASyuFaoEPuaubAoVNmXg0qY2+
         M2nlTJXZr8v/CaGbhC/L1BOhN+YZF63M0z4VPeizrISyyWXjue6HP6m/4MrqTHYTrVA3
         CxEg==
X-Gm-Message-State: AOJu0YwoP77q8ImRjf183niLlEBKmLr+jwaa45/yS+2e8GNy6c5KcoJE
        yQ9v+0DLYAL445neN1y0Z9QA10f90YE=
X-Google-Smtp-Source: AGHT+IEL/dshnjsgmjdfGSman4r0qxwjXyMs+hXHniVftyWUrPYv6azBgo0B81bsYJN3JcUy4Fmp/3PNp8E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1102:b0:d0b:d8cd:e661 with SMTP id
 o2-20020a056902110200b00d0bd8cde661mr95997ybu.12.1694627172692; Wed, 13 Sep
 2023 10:46:12 -0700 (PDT)
Date:   Wed, 13 Sep 2023 10:46:11 -0700
In-Reply-To: <852b6fa117bf3767a99353d908bc566a5dd9c61a.1694599703.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1694599703.git.isaku.yamahata@intel.com> <852b6fa117bf3767a99353d908bc566a5dd9c61a.1694599703.git.isaku.yamahata@intel.com>
Message-ID: <ZQH1YzB5YaeCwHii@google.com>
Subject: Re: [RFC PATCH 4/6] KVM: guest_memfd: Implemnet bmap inode operation
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To inject memory failure, physical address of the page is needed.
> Implement bmap() method to convert the file offset into physical address.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/Kconfig     |  4 ++++
>  virt/kvm/guest_mem.c | 28 ++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 624df45baff0..eb008f0e7cc3 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -115,3 +115,7 @@ config KVM_GENERIC_PRIVATE_MEM
>  
>  config HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR
>  	bool
> +
> +config KVM_GENERIC_PRIVATE_MEM_BMAP
> +	depends on KVM_GENERIC_PRIVATE_MEM
> +	bool
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index 3678287d7c9d..90dfdfab1f8c 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -355,12 +355,40 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
>  	return MF_DELAYED;
>  }
>  
> +#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_BMAP
> +static sector_t kvm_gmem_bmap(struct address_space *mapping, sector_t block)
> +{
> +	struct folio *folio;
> +	sector_t pfn = 0;
> +
> +	filemap_invalidate_lock_shared(mapping);
> +
> +	if (block << PAGE_SHIFT > i_size_read(mapping->host))
> +		goto out;
> +
> +	folio = filemap_get_folio(mapping, block);
> +	if (IS_ERR_OR_NULL(folio))
> +		goto out;
> +
> +	pfn = folio_pfn(folio) + (block - folio->index);
> +	folio_put(folio);
> +
> +out:
> +	filemap_invalidate_unlock_shared(mapping);
> +	return pfn;

IIUC, hijacking bmap() is a gigantic hack to propagate a host pfn to userspace
without adding a new ioctl() or syscall.  If we want to support target injection,
I would much, much rather add a KVM ioctl(), e.g. to let userspace inject errors
for a gfn.  Returning a pfn for something that AFAICT has nothing to do with pfns
is gross, e.g. the whole "0 is the error code" thing is technically wrong because
'0' is a perfectly valid pfn.

My vote is to drop this and not extend the injection information for the initial
merge, i.e. rely on point testing to verify kvm_gmem_error_page(), and defer adding
uAPI to let selftests inject errors.

> +
> +}
> +#endif
> +
>  static const struct address_space_operations kvm_gmem_aops = {
>  	.dirty_folio = noop_dirty_folio,
>  #ifdef CONFIG_MIGRATION
>  	.migrate_folio	= kvm_gmem_migrate_folio,
>  #endif
>  	.error_remove_page = kvm_gmem_error_page,
> +#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_BMAP
> +	.bmap = kvm_gmem_bmap,
> +#endif
>  };
>  
>  static int  kvm_gmem_getattr(struct mnt_idmap *idmap,
> -- 
> 2.25.1
> 
