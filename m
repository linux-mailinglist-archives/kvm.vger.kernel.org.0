Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CF5709053
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjESHX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 03:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjESHXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 03:23:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FED109;
        Fri, 19 May 2023 00:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684481034; x=1716017034;
  h=from:to:cc:subject:date:message-id;
  bh=+qJJtos13heGRt9cQEvKtBbo1R9ZeJIEF8B5TXfKWnw=;
  b=BDl4W2RPIEn+lY2IZKH3o2IPgXk/DFdg0yWBe8dR98C0D/iMve8AAa9u
   yEQjQ5dk8BhCBvB7vnmzTbpD8dsAQLITOApq8CJUrd0XjholN5J1zNIcM
   5BmOcan3egKrdhG49zg8Vmea04CG/ypFYvMgIaYEikxuofsC6Njc6iLYS
   lQ2wirBWhfyRA2cNyoj9OmLqwxqnYEZqQZIrWyBmwjCPsjfQji/BJckO0
   T/0KwH0c4m+86JDIfQa/M7NLn6Awd1c/xcAKEya4bK0OBkg0mDcPYKOqK
   MsTeR0Fh8YsMfuyx9/ZcqeiVjW2gDpfgAkWDeEd4TSD/uygDWqVjTXq0r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="349819458"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="349819458"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 00:23:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="772201167"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="772201167"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 00:23:52 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
        Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] vfio/type1: check pfn valid before converting to struct page
Date:   Fri, 19 May 2023 14:58:43 +0800
Message-Id: <20230519065843.10653-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check physical PFN is valid before converting the PFN to a struct page
pointer to be returned to caller of vfio_pin_pages().

vfio_pin_pages() pins user pages with contiguous IOVA.
If the IOVA of a user page to be pinned belongs to vma of vm_flags
VM_PFNMAP, pin_user_pages_remote() will return -EFAULT without returning
struct page address for this PFN. This is because usually this kind of PFN
(e.g. MMIO PFN) has no valid struct page address associated.
Upon this error, vaddr_get_pfns() will obtain the physical PFN directly.

While previously vfio_pin_pages() returns to caller PFN arrays directly,
after commit
34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
PFNs will be converted to "struct page *" unconditionally and therefore
the returned "struct page *" array may contain invalid struct page
addresses.

Given current in-tree users of vfio_pin_pages() only expect "struct page *
returned, check PFN validity and return -EINVAL to let the caller be
aware of IOVAs to be pinned containing PFN not able to be returned in
"struct page *" array. So that, the caller will not consume the returned
pointer (e.g. test PageReserved()) and avoid error like "supervisor read
access in kernel mode".

Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

---
v2: update commit message to explain background/problem clearly. (Sean)
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 493c31de0edb..0620dbe5cca0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -860,6 +860,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		if (ret)
 			goto pin_unwind;
 
+		if (!pfn_valid(phys_pfn)) {
+			ret = -EINVAL;
+			goto pin_unwind;
+		}
+
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)

base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
-- 
2.17.1

