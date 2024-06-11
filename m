Return-Path: <kvm+bounces-19320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFDF903BED
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A36131C20B36
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7B117C7D6;
	Tue, 11 Jun 2024 12:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UT1AHbf7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7217B17BB05;
	Tue, 11 Jun 2024 12:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718109019; cv=none; b=rYI9yysQDbfcGwJYa42WPEeJ6TP3vKaLDHwVEmfuV2vHffNP+Dqnh8LtWW7NUekwIqU5XEI+S73hMMQq11F38fNBYlwIxSWLCzJBH3VlaR4crCDIwID970V18BP1wAcdY+l6PLfycvpGdQvSfWZ17JGymyBq5JtDF7LMcLL0Mgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718109019; c=relaxed/simple;
	bh=US6PgPuYBkBHBzzJOfK04Hwg/abY8CZ7Jk3Z2bpKCqs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHrhdNVsKz7Lx2QEf/gYN/qXdx/ipNFM8thTOz/wcwGkXpJw99qVE7T2R8etDaDC5DPiZDUjqnr3wtK1N6XkxeLT9rZiTw7bm7OVKf2qE4KKjhwZ9wD9sIqQcYv2TbRvwPVMry2KEHJQKcVdBadkU2+IPus3zQ7aZr5g1AZrjY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UT1AHbf7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BCSoOa018291;
	Tue, 11 Jun 2024 12:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	yBhQkttHnEyL5cv2acTqp19DVPXSx5tGvkMc8RzjqEA=; b=UT1AHbf7LWYJ82oo
	f6TM3TZJwA7n20SY0EGyWMykHm1HsDHL0LJ+SLjB6R/isr0NqS+xksiNY1BaupXb
	zpUjOYzDQXWQFW3ZAKY1L8p1Z+BK1pb9YHvlKQia/iucsZKjhva67QXNRbTgdXzK
	fQV7ygibOTZOv305Au+zbGAliVsPYRziXHmTwxXKGS810hp/3yuXhoAt53ubvrrQ
	+e459nMiyl68vsg6LrmeFLwCyKxLwGREYfkgA6HQ4SAnGW9wBgbkd++KXd2l8B8l
	lJTrqg5JWJbplN0yeQIpGoxFKsDd66ljkSY2KUTQl2+s5axV063K9S3/Ms/pHfnK
	3botNA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yppm5803e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:30:01 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BCU03b021448;
	Tue, 11 Jun 2024 12:30:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yppm58039-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:30:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BAVGwf003881;
	Tue, 11 Jun 2024 12:29:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mpnqxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BCTr8b42860956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 12:29:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FB1220043;
	Tue, 11 Jun 2024 12:29:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B313120040;
	Tue, 11 Jun 2024 12:29:49 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 12:29:49 +0000 (GMT)
Subject: [PATCH v3 4/6] vfio/spapr: Always clear TCEs before unsetting the
 window
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org,
        msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com,
        jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Tue, 11 Jun 2024 12:29:49 +0000
Message-ID: <171810898575.1721.15950827403027920977.stgit@linux.ibm.com>
In-Reply-To: <171810893836.1721.2640631616827396553.stgit@linux.ibm.com>
References: <171810893836.1721.2640631616827396553.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wWlU7DV3msBlrLUY25Uj_ejiwLpwdfWq
X-Proofpoint-ORIG-GUID: Wp7MKac585PYWk1Mu5n6DUWOiBM4CCXr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=837 bulkscore=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406110092

The PAPR expects the TCE table to have no entries at the time of
unset window(i.e. remove-pe). The TCE clear right now is done
before freeing the iommu table. On pSeries, the unset window
makes those entries inaccessible to the OS and the H_PUT/GET calls
fail on them with H_CONSTRAINED.

On PowerNV, this has no side effect as the TCE clear can be done
before the DMA window removal as well.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index a94ec6225d31..5f9e7e477078 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -364,7 +364,6 @@ static void tce_iommu_release(void *iommu_data)
 		if (!tbl)
 			continue;
 
-		tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
 		tce_iommu_free_table(container, tbl);
 	}
 
@@ -720,6 +719,8 @@ static long tce_iommu_remove_window(struct tce_container *container,
 
 	BUG_ON(!tbl->it_size);
 
+	tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
+
 	/* Detach groups from IOMMUs */
 	list_for_each_entry(tcegrp, &container->group_list, next) {
 		table_group = iommu_group_get_iommudata(tcegrp->grp);
@@ -738,7 +739,6 @@ static long tce_iommu_remove_window(struct tce_container *container,
 	}
 
 	/* Free table */
-	tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
 	tce_iommu_free_table(container, tbl);
 	container->tables[num] = NULL;
 
@@ -1197,9 +1197,14 @@ static void tce_iommu_release_ownership(struct tce_container *container,
 		return;
 	}
 
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
-		if (container->tables[i])
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		if (container->tables[i]) {
+			tce_iommu_clear(container, container->tables[i],
+					container->tables[i]->it_offset,
+					container->tables[i]->it_size);
 			table_group->ops->unset_window(table_group, i);
+		}
+	}
 }
 
 static long tce_iommu_take_ownership(struct tce_container *container,



