Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C309D435338
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhJTSzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:55:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42550 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhJTSzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 14:55:06 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KIVkgC025798;
        Wed, 20 Oct 2021 18:52:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=LiE9WJoftzY3Rn6Hlp/Im0DVv0DI2FTmT5imqp7DQyQ=;
 b=SCcnCfmHJIPEcuR8kAUBefoSAB5spoNBTMWzu1OBfn4QIV6CNTNzGQxLiiyf4ildo8Q8
 nRE0R0maeF2egvXDZqO9Ngg+Jupvp+q10UyfSL/3DBSzBl8dwXORQi/v2L724CVR2WFx
 nFDlqRb3PX33B9Tm5gWWp5fLXq5yhEIK1SCCdH8PZyZjIqt3HGbKcgVNFfQ0E1I/p+c7
 UzcH1Cpll/6TeOf3W6IhRfaR2aUiyvpXz6uw1+Jv1mnq0p+8JvVTnJ1ijuzaIormmgqp
 pm4o5CWZLc4iEaiy0XhUOTSoLPON1cEQgeIE2nQRhtOItfnlYM9tvRvgScpthX7uHJY6 SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm0418-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 18:52:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KIpb3F052811;
        Wed, 20 Oct 2021 18:52:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3bqkv0hh8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 18:52:42 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19KIqfwq059818;
        Wed, 20 Oct 2021 18:52:41 GMT
Received: from monad.us.oracle.com (dhcp-10-159-132-124.vpn.oracle.com [10.159.132.124])
        by userp3030.oracle.com with ESMTP id 3bqkv0hh7s-1;
        Wed, 20 Oct 2021 18:52:41 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>,
        alex.williamson@redhat.com
Subject: [PATCH v2 13/14] vfio_iommu_type1: specify FOLL_HINT_BULK to pin_user_pages()
Date:   Wed, 20 Oct 2021 11:52:07 -0700
Message-Id: <20211020185207.18509-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: kyJVys3aFUyKJefJejJSe5ZCKu_C4bvd
X-Proofpoint-ORIG-GUID: kyJVys3aFUyKJefJejJSe5ZCKu_C4bvd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify FOLL_HINT_BULK to pin_user_pages() so it is aware that
this pin is part of a larger region being pinned, so it can
optimize based on that expectation.

Cc: alex.williamson@redhat.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0e9217687f5c..0d45b0c6464d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -557,6 +557,9 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	if (prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
+	/* Tell gup that this iterations is part of larger set of pins. */
+	flags |= FOLL_HINT_BULK;
+
 	mmap_read_lock(mm);
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL, NULL);
-- 
2.29.2

