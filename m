Return-Path: <kvm+bounces-71809-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PelBY6qnmntWgQAu9opvQ
	(envelope-from <kvm+bounces-71809-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:53:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C689193C25
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 765C93045006
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B55306486;
	Wed, 25 Feb 2026 07:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h45s57/C"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011027.outbound.protection.outlook.com [52.101.62.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12D12FF170;
	Wed, 25 Feb 2026 07:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772005959; cv=fail; b=IaPOU1IhyFNssFcZsBBaJRwtcxMMwsDWnBUvZ7XJA3a7qqBUYa1VncWo9/oUupUACeTcj+ZtsPGrvHUHwFA2KHsHvc5GXRugujazfYw64RUXl7EaSnnZn+OfyaJb38fdUQEbBG8mdIBM0VwC93FC4mcB+NtKUuCKqEoP9WkgtyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772005959; c=relaxed/simple;
	bh=iNPWfAbvNi0sSWa3slLyqgZmhtP9fIJo2CWwKvarGC4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NP2GG9nTO1hwVTg/zSQcri4YjUXWsigWL4yuVLmyaV28S0/t8l16YBgIAloFrUUBnTM2Z+IRI2VnJiexRnGsPVyCS0HHb61pRlUB45DYvdaXS47TSp0OxYp+6dPnqx+e7NtCNoergwpRxAWwnZWJKMj7TR6z46Oj3U7EccweC5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h45s57/C; arc=fail smtp.client-ip=52.101.62.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S4+9O9iKrW6xB4kYsIP64D1wDNcDcIFKd3KbBt+hJtXq8Uandv3vLg9gT9nMsCENx1FYmACYrH6klbEoBoHSU77U5PZn84n/pDvS7NtSk4Ih/x//xYMKDEge/oLWjaW1nCX3FQXqxvW+vAWB54Asx/bYOASYfYFEQ5tLR/mqYv5bVBvhC5/oYETLIT2hack0a6QjlLXsC6R2K08Gy0Jby5r1dm2wCbLSLPuH4cgcx4+u9lRIX42JuRWA9OOH4sYkW3xZjCyj6jh6WCReXJX6t4pLaNDHkHic2FGPt03iOE5XWN9271Cyqc6y4RFwlxHs5cyvvn3m0/84338lo9WTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8uOaPMyzcf4fHALNlJb5qM9uxuSYoRNOmYbQ0BL2x0=;
 b=M4toLzySierkFHzrdLVL7Dl4CuyEEH74fNx0Ybxin2wfrYypdjaS+A1uF5s2lnl5/1UYFgcP2D02ZhMCNFCaNIuSxzhdO26wmPlWvHQg+62dWObUiSu8dQU3VtcKrnha8nCUPPmDX9le1vLKWYC6JYICMW4Q8qs3ZnAbMx4PJiAnantWjwZGVRhW/sk4gNqZLt45fw19CksskmPFMwddA5NoM7Iy2xxvod1pZ3i3qVYR7ozbOeG/h4KYZJKI1WIS4qvWxa//2IujyEA30IiodbDVtGeIeoollqaeDIlUUR705/56LJKKgTCO+nLCZiAo7p8K5fqi+5Uzsruq8gocaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8uOaPMyzcf4fHALNlJb5qM9uxuSYoRNOmYbQ0BL2x0=;
 b=h45s57/Cg8/+1k5x44FBuGl6FTaREzsdBnLCDZ0vlnUkeBhdjTtqi5LpctrLMy/RpIRpGrjPFsGo7ov+vjzxVIA3y4etZKvaHvS5T9cAFreSBxpNwr/PyLohmeh8O8UQuVE/Bc9JwU6vqGkqbTQDBdPwSh+t1Ip4YF33tk8kz5M=
Received: from BL0PR1501CA0013.namprd15.prod.outlook.com
 (2603:10b6:207:17::26) by DS7PR12MB6166.namprd12.prod.outlook.com
 (2603:10b6:8:99::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 07:52:32 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:207:17:cafe::c6) by BL0PR1501CA0013.outlook.office365.com
 (2603:10b6:207:17::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 07:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 07:52:31 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 25 Feb
 2026 01:52:23 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Steve Sistare <steven.sistare@oracle.com>, "Nicolin
 Chen" <nicolinc@nvidia.com>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>, <linux-coco@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>, Santosh Shukla <santosh.shukla@amd.com>, "Pratik
 R . Sampat" <prsampat@amd.com>, Ackerley Tng <ackerleytng@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Fuad Tabba <tabba@google.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Date: Wed, 25 Feb 2026 18:52:11 +1100
Message-ID: <20260225075211.3353194-1-aik@amd.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|DS7PR12MB6166:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a7f91a-71da-4a43-1515-08de7442d4c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JLPaNDMZYkzRYIGA0FeqorLKsDrRVoDCPbZcQ3FTovZVpUc/pV0ERfN9gBLX?=
 =?us-ascii?Q?xo5EOnGPciPBBC9hWV0QNiN8LvQxUVz810j3bBYE00y2X2BchHR+ArnDJd4W?=
 =?us-ascii?Q?P3TLSu5v2ZG8BNiudxq+F8+Qcc/53TixzTy2/EMt6kOgZZrMkVv15T4UG2GN?=
 =?us-ascii?Q?MZWJsZg62cWvXy1ZpcMeT++lbVWs3VAQhnd00cQrAQe1Zf2TPJai0VxJxHBr?=
 =?us-ascii?Q?LWCkPV6dvTcDeo02UvgYknM/sFD1+ykNc2ME8RQwE08irBy+03PKy/+X5xLw?=
 =?us-ascii?Q?nXDKx9lG/JQ+EVtA1XyjwJrJi2adibVSF+FK39+6XEW3wNvq/71Y+upoToQV?=
 =?us-ascii?Q?EchX8/knbzRIwQWmbAJB4bHsTOi2FSFLnFhI4yozAdRYK2cuyws3O0JpxJ4F?=
 =?us-ascii?Q?/LN8dqKZPJWvlj5ltyXH82+/JcBtSRK/g1SYSooSG7eQFdAPTNT66qhD3uEP?=
 =?us-ascii?Q?A/fqr/5kTB02hIPuh6PNGwjkqu/7go49b1MKxCmqKsH1d2P1zGPEOecg8jCC?=
 =?us-ascii?Q?+gF/gSqozwEPX8g9ENeRSePJzEUCJcWBCQUfnjw+8hYhpDFFHEcgTVbkiPnT?=
 =?us-ascii?Q?/cG7tW7meyPAumFlFqZ1qr9U+Qhf0kLbxr4L1pNOJLDPS/raakoHILsZAZMQ?=
 =?us-ascii?Q?OS4nmFxmOxJJAJIqg8Zb4+tvGJd06UXBvj/gCI6F4rlFbyKz6toS1+vAJlLR?=
 =?us-ascii?Q?SiL5OCS+OF/Fo6uCg/3BmXENjEdpXVnNrgJRwZFWZ0BIzy+KCWH2iKBZxXbc?=
 =?us-ascii?Q?0N1P0ZU591WWQ8cCysd9Q+1qDr1mFO5GYsxL0SNBg8VC5rh6cRzNyPnsYCFY?=
 =?us-ascii?Q?WcDRJdpW6g4wXF3Sz9jtJFg2tSnIgtJgv7e0ydMGiZENjZ+Ymx1sHqAV8TCl?=
 =?us-ascii?Q?DzGFUU+J5KIbVEdaER4KmQaQk25JYOPx9OQAB9sjC9j/fAEcz8ybU4x2P3lk?=
 =?us-ascii?Q?vSR97Bti0yukqkjrCu3F0ZZyni59nhGgfUABFm2WkaDk4i8ODwzxoQN66ZvF?=
 =?us-ascii?Q?7qUhh1z9YFwol/woRJUIaict4XGcLQJpWgknUQRU0vgk5tWmzBNk00pfAMF3?=
 =?us-ascii?Q?ZdJse20QmO4wOxIgSVrnKWClfTVr0q54hOetUIqVS3Fi6I1FalIhLziCkbHp?=
 =?us-ascii?Q?EA38DZykthjgxn/eKLTdm355YthxEIn26gau0sCq7fdK+O2hiHhJ08Dd6iq9?=
 =?us-ascii?Q?A32B1Cvfv3ev+wT6pQybgcH7Onb7zNJjdVOa32sInwh1fW6n7n/bQgkJHXzf?=
 =?us-ascii?Q?iFcnVaT/rBQbwOsp73hvwX/wnqQQKYdH2U/rJS+fLjE/IGlkNUXm/NRfTCqn?=
 =?us-ascii?Q?/fxAj36yJJeNoCY2dk5Jprs8aMEn7PuKya+pgLVuYntTzeq6xGbqgpEl3wna?=
 =?us-ascii?Q?hf4/mdFaGduUEO00j32ZFolym8c63wGd4poP8xJtMGq2IMb1NVrkD16/6dqs?=
 =?us-ascii?Q?idy2OUZjkskvj7Bt3n49SfVdhT31ifjC2W8I79BZ5XTKlkLhPD6k+gsjua/8?=
 =?us-ascii?Q?dPxGG1hk2pE5B+OiOWXQz8V4pdDU8e0S+b9PTd/j6a9P+k4kNVZAvAOE+xGG?=
 =?us-ascii?Q?wUK3PMaeBzqgpmmou0WCCW7nudtSTpS0gM/Osx3KzGXjqgoNzAouDVKnWD8Z?=
 =?us-ascii?Q?RiwaFz0wmOqKR/InqZxD9YhpA06mp58jLXmGp6SbUuHdJQOtylA8bv1ycCMz?=
 =?us-ascii?Q?W+tHoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rCEYdvds6LZ3vctCvc1fjPi7ZBKiMSqhOdmHRyJ/bmHZcJexnQ6ONIu5/Z/8Tv0xNrJxSp993k/a6vPK2kDRt7alMPMZSIf2NZ5axUCF+LpU28/n0XEHNi05QXjaOFl4f9W6mXvUpRpaakqFRviQzjUf7lzcpZpiZyhWvjdMuw/NarQSc36EqCF1s6Ms9HfL5xz8Yh4lbRxm/H3LLZcyfkNmmGHSLyjGLJtOlvwo9HU6g8b/O2qw/rVQJ4OyolFJ/XghQGBLbNgLSegMVXVhMUwAoGyPeteLr2SxJXz+/mnXwHmzq1IDiVis887MK18MITJAFdJHwYHWgz3nT9oaGiAOl6hH47p348GrRA46/z4g1XXrmzdfoAq5siYdTogyAd+HovzuKXCZcJaftCi98IJE6GNx28IBXjzOtt6oZXjOIa0dyxLhbZoc1VUBuAoz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 07:52:31.9362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a7f91a-71da-4a43-1515-08de7442d4c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6166
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71809-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 7C689193C25
X-Rspamd-Action: no action

CoCo VMs get their private memory allocated from guest_memfd
("gmemfd") which is a KVM facility similar to memfd.
The gmemfds does not allow mapping private memory to the userspace
so the IOMMU_IOAS_MAP ioctl does not work.

Use the existing IOMMU_IOAS_MAP_FILE ioctl to allow mapping from
fd + offset. Detect the gmemfd case in pfn_reader_user_pin().

For the new guest_memfd type, no additional reference is taken as
pinning is guaranteed by the KVM guest_memfd library.

There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
the assumption is that:
1) page stage change events will be handled by VMM which is going
to call IOMMUFD to remap pages;
2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
handle it.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

This is for Trusted IO == TEE-IO == PCIe TDISP, etc.

Previously posted here:
https://lore.kernel.org/r/20250218111017.491719-13-aik@amd.com
The main comment was "what is the lifetime of those folios()" and
GMEMFD + QEMU should take care of it.

And horrendous stuff like this is not really useful:
https://github.com/AMDESE/linux-kvm/commit/7d73fd2cccb8489b1

---
 include/linux/kvm_host.h      |  4 +
 drivers/iommu/iommufd/pages.c | 80 ++++++++++++++++++--
 virt/kvm/guest_memfd.c        | 36 +++++++++
 3 files changed, 113 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 995db7a7ba57..9369cf22b24e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2673,4 +2673,8 @@ unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn);
 int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes2 *attrs);
 
+bool kvm_is_gmemfd(struct file *file);
+struct folio *kvm_gmemfd_get_pfn(struct file *file, unsigned long index,
+				 unsigned long *pfn, int *max_order);
+
 #endif
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index dbe51ecb9a20..4c07e39e17d0 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -56,6 +56,9 @@
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/pagemap.h>
+#include <linux/memcontrol.h>
+#include <linux/kvm_host.h>
 
 #include "double_span.h"
 #include "io_pagetable.h"
@@ -660,7 +663,8 @@ static void batch_from_pages(struct pfn_batch *batch, struct page **pages,
 }
 
 static int batch_from_folios(struct pfn_batch *batch, struct folio ***folios_p,
-			     unsigned long *offset_p, unsigned long npages)
+			     unsigned long *offset_p, unsigned long npages,
+			     bool do_pin)
 {
 	int rc = 0;
 	struct folio **folios = *folios_p;
@@ -676,7 +680,7 @@ static int batch_from_folios(struct pfn_batch *batch, struct folio ***folios_p,
 
 		if (!batch_add_pfn_num(batch, pfn, nr, BATCH_CPU_MEMORY))
 			break;
-		if (nr > 1) {
+		if (nr > 1 && do_pin) {
 			rc = folio_add_pins(folio, nr - 1);
 			if (rc) {
 				batch_remove_pfn_num(batch, nr);
@@ -697,6 +701,7 @@ static int batch_from_folios(struct pfn_batch *batch, struct folio ***folios_p,
 static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
 			unsigned int first_page_off, size_t npages)
 {
+	bool do_unpin = !kvm_is_gmemfd(pages->file);
 	unsigned int cur = 0;
 
 	while (first_page_off) {
@@ -710,9 +715,12 @@ static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
 		size_t to_unpin = min_t(size_t, npages,
 					batch->npfns[cur] - first_page_off);
 
-		unpin_user_page_range_dirty_lock(
-			pfn_to_page(batch->pfns[cur] + first_page_off),
-			to_unpin, pages->writable);
+		/* Do nothing for guest_memfd */
+		if (do_unpin)
+			unpin_user_page_range_dirty_lock(
+				pfn_to_page(batch->pfns[cur] + first_page_off),
+				to_unpin, pages->writable);
+
 		iopt_pages_sub_npinned(pages, to_unpin);
 		cur++;
 		first_page_off = 0;
@@ -872,6 +880,57 @@ static long pin_memfd_pages(struct pfn_reader_user *user, unsigned long start,
 	return npages_out;
 }
 
+static long pin_guest_memfd_pages(struct pfn_reader_user *user, loff_t start, unsigned long npages)
+{
+	struct page **upages = user->upages;
+	unsigned long offset = 0;
+	loff_t uptr = start;
+	long rc = 0;
+
+	for (unsigned long i = 0; (uptr - start) < (npages << PAGE_SHIFT); ++i) {
+		unsigned long gfn = 0, pfn = 0;
+		int max_order = 0;
+		struct folio *folio;
+
+		folio = kvm_gmemfd_get_pfn(user->file, uptr >> PAGE_SHIFT, &pfn, &max_order);
+		if (IS_ERR(folio))
+			rc = PTR_ERR(folio);
+
+		if (rc == -EINVAL && i == 0) {
+			pr_err_once("Must be vfio mmio at gfn=%lx pfn=%lx, skipping\n", gfn, pfn);
+			return rc;
+		}
+
+		if (rc) {
+			pr_err("%s: %ld %ld %lx -> %lx\n", __func__,
+			       rc, i, (unsigned long) uptr, (unsigned long) pfn);
+			break;
+		}
+
+		if (i == 0)
+			offset = offset_in_folio(folio, start) >> PAGE_SHIFT;
+
+		user->ufolios[i] = folio;
+
+		if (upages) {
+			unsigned long np = (1UL << (max_order + PAGE_SHIFT)) - offset_in_folio(folio, uptr);
+
+			for (unsigned long j = 0; j < np; ++j)
+				*upages++ = folio_page(folio, offset + j);
+		}
+
+		uptr += (1UL << (max_order + PAGE_SHIFT)) - offset_in_folio(folio, uptr);
+	}
+
+	if (!rc) {
+		rc = npages;
+		user->ufolios_next = user->ufolios;
+		user->ufolios_offset = offset;
+	}
+
+	return rc;
+}
+
 static int pfn_reader_user_pin(struct pfn_reader_user *user,
 			       struct iopt_pages *pages,
 			       unsigned long start_index,
@@ -925,7 +984,13 @@ static int pfn_reader_user_pin(struct pfn_reader_user *user,
 
 	if (user->file) {
 		start = pages->start + (start_index * PAGE_SIZE);
-		rc = pin_memfd_pages(user, start, npages);
+		if (kvm_is_gmemfd(pages->file)) {
+			rc = pin_guest_memfd_pages(user, start, npages);
+		} else {
+			pr_err("UNEXP PINFD start=%lx sz=%lx file=%lx",
+				start, npages << PAGE_SHIFT, (ulong) pages->file);
+			rc = pin_memfd_pages(user, start, npages);
+		}
 	} else if (!remote_mm) {
 		uptr = (uintptr_t)(pages->uptr + start_index * PAGE_SIZE);
 		rc = pin_user_pages_fast(uptr, npages, user->gup_flags,
@@ -1221,7 +1286,8 @@ static int pfn_reader_fill_span(struct pfn_reader *pfns)
 				 npages);
 	else
 		rc = batch_from_folios(&pfns->batch, &user->ufolios_next,
-				       &user->ufolios_offset, npages);
+				       &user->ufolios_offset, npages,
+				       !kvm_is_gmemfd(pfns->pages->file));
 	return rc;
 }
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e4e21068cf2a..2a313888c21b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1794,3 +1794,39 @@ void kvm_gmem_exit(void)
 	rcu_barrier();
 	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
+
+bool kvm_is_gmemfd(struct file *file)
+{
+	if (!file)
+		return false;
+
+	if (file->f_op != &kvm_gmem_fops)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_is_gmemfd);
+
+struct folio *kvm_gmemfd_get_pfn(struct file *file, unsigned long index,
+				 unsigned long *pfn, int *max_order)
+{
+	struct inode *inode = file_inode(file);
+	struct folio *folio;
+
+	if (!inode || !kvm_is_gmemfd(file))
+		return NULL;
+
+	folio = kvm_gmem_get_folio(inode, index);
+	if (!folio)
+		return NULL;
+
+
+	*pfn = folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
+	*max_order = folio_order(folio);
+
+	folio_put(folio);
+	folio_unlock(folio);
+
+	return folio;
+}
+EXPORT_SYMBOL_GPL(kvm_gmemfd_get_pfn);
-- 
2.52.0


