Return-Path: <kvm+bounces-72500-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLfKFpd4pmnxQAAAu9opvQ
	(envelope-from <kvm+bounces-72500-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 06:58:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C42611E95EF
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 06:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4852D30B6D5A
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 05:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E377235504D;
	Tue,  3 Mar 2026 05:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zd2Onk3c"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013044.outbound.protection.outlook.com [40.93.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE53128CF;
	Tue,  3 Mar 2026 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772517395; cv=fail; b=gH4fua3RFaWRta4vep/2nf95z84rPGA6TfNTVVqmt3DoBczVs7IIpCwWd+tNLy/nMn0s1Gx6sy/Mu86/btnqAvKTwZKrkJrEwPeQaPbmVeSMfqRbfZnPRk/mwDrLwHJpUYoBfnhmf34ECEDjNwqtFf0w9lEYHWUa5+tV/AHp7NM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772517395; c=relaxed/simple;
	bh=P+cueaHNdJ9Fv0TiMLn+Al6VTGwFwyeMJCVsq5usS7o=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rj3GB/EcGxLCwRFYCstvS4hu1r69zV5bjqSgbbDYxuFwQva5rpvoiQVtQop+EZ15/LvZg9dEtK3poptgV0tLH1w4c+NgKyNrj6YJ33umk7ljHcwuCXkcNMz45egDk/Q9GKh6cLs5FoJWqHisxuexcBi2cIyTKJjcyxdap1Z/gnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zd2Onk3c; arc=fail smtp.client-ip=40.93.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUW2E92djHrUjnICnx6npQc/R8SHAxos/terHk2QrzYacyP1sSkNvduxx+8I+jG3nD7IMOc3DgkbrJTt70JPsbl1Lq7+iYBMnPnByYRxIMMynhTYcLhcuLW1J9kTI87FbE1WhE5lEIEV6OVQNCOdqJ3Dz437T7GLsC07Hovru/Kmr2CORj4YkEOZS9n+cG8RHRm4DyyUBHIGWTwpPStUrp4jYLbyuGy601j3vv7L/4/aBRm0HnL03rTyxBY3bNY5O0P93fThqKY1YDYW24LJuOrfnxpCVwzlme7dyKTo5CaNt/Zl/StAYxa3UbccSw8Giibr96XYtBHcyBYqbV0GyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8SwI+etXmOsXFVfevdv320UYC88Ne135YZPJUsGFe8=;
 b=YY/xAqC8Y0O44HSEHxz03h7cCkufC4KV4JA7QPA0FSHsj5y1MVdj912O0mjjK6lXjU2NfxV0Mt911kUCEeoA57of+0kPB1wUxL4TgVhpQNTUs9diTEhDYXg3PXg5jddN6erl3oQ0qQIDOqt/9zrqpz47TjcKxYwrwCSnEomVsQaB/hkO2lB0iNvmMqE98juE4zG5ptOPKfFJ0JOg8Yce4Nq4SZNN8dymaRGZcZ3xyQWSD9ka9yMgLi3JynSnzCGyhUdoA0tdsePCrNnMioKqyKnblu06OSEiB+b6/1+aU7ugoxCCj+hmNdHxC0KBnGlCCDZGGugdq31aQ3CNYiJS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8SwI+etXmOsXFVfevdv320UYC88Ne135YZPJUsGFe8=;
 b=zd2Onk3cqt1H3GAK2TP69QiJDu3VuYBJX6PrVrvl0b+X2VHJBE4H+syqkrk3KhswRTCDNdUabD9KK68w/oemfJh5oOY8OywzB0A7ONd3yCL4N59q7IwXfNGG43gtoMPwi/5PIca+4WHu6oBflywsAXFyh8VAFAXaEDHRRZwXL+M=
Received: from DM6PR07CA0120.namprd07.prod.outlook.com (2603:10b6:5:330::10)
 by DM4PR12MB5817.namprd12.prod.outlook.com (2603:10b6:8:60::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 05:56:28 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::8) by DM6PR07CA0120.outlook.office365.com
 (2603:10b6:5:330::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 05:56:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 05:56:28 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 23:56:27 -0600
Received: from amd.com (10.180.168.240) by satlexmb08.amd.com (10.181.42.217)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 2 Mar 2026 23:56:21 -0600
Date: Tue, 3 Mar 2026 05:56:15 +0000
From: Ankit Soni <Ankit.Soni@amd.com>
To: Samiullah Khawaja <skhawaja@google.com>
CC: David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, YiFei Zhu
	<zhuyifei@google.com>, Robin Murphy <robin.murphy@arm.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan
	<shuah@kernel.org>, <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Adithya
 Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, Leon
 Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, Pratyush Yadav
	<pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, David
 Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin
 Sharma <vipinsh@google.com>
Subject: Re: [PATCH 11/14] iommufd-lu: Persist iommu hardware pagetables for
 live update
Message-ID: <srgagoecgejftgvvqstjiwazi6blsljqyae3v5dlyj7nlv5lii@rjigll2eosuj>
References: <20260203220948.2176157-1-skhawaja@google.com>
 <20260203220948.2176157-12-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260203220948.2176157-12-skhawaja@google.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|DM4PR12MB5817:EE_
X-MS-Office365-Filtering-Correlation-Id: 277bf52d-f91f-4c13-a90b-08de78e99ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	bqGjA3hse0838WnFy+g4MvXAB9gAfpNjFssaqPM/bpDXoFgd3WL++Oc/iZokDrwRkYa0x4XES/ZH991HFVVcKdKPXi21x5yMketM+K+L/3sSp2hpRAU8SrTXh08uxVlsLiNSMofqx0n6MdL2Aeyo8khQBU8njrWw7IOzjXPb9979xZ3o7sdt/Fa3pzSoWxzSg4vLLghisXNnW92+z8g5XcKNGaBITu+XbGNE67b4SBI1khvu024S2rrU89oKQ98nY8pF5Y4dWfLx+LTEAtjxLgQF1DN6lvObryEOP8jWJsSHpRTGCi92Zw+/vkdKcMHR+2mgvRRYO/tv11p6VGD3E6pn42UsbSM3WCOaPl09pc+qj6ILqfXnX6EzAxB+o+G6VLGYIMTObTYGYCCUVXkIdXrlkHxDQl9Q+YLI7OYKkH3JiPznzOZQJehZG5qQ3JPkIlcLFp2yGG+GBB8T7hmNVMDa5qukaxXPeReWBovbxcV6+XgW3ljJi1UCt4fRXUAfgeQEzxIIYi7Kfb+my07YiHrOTn75Qo5JOmGlUjlFvkFLmpOhJl5C6nK4CmGUrLkJ2kC/9+kHGVqzqh+o/ltYafBBCU5NA04V1xLVOAqecmucJPxL1dfUf7Je5qPKes1QxI8gFgBn10QQVwrKoPKmg3Ct7AUSw8FcBvOl2AGN2tIf8ZkPHAJaQo+48rO43zfv8TPAKMRMtlfEIskU0e8R/qrvfCd2ZT6HAaS8r7FRBKsz+0kDFZ6pU26pWeqr/m3zzb3Jf6TEfVnRH18ayAt+ikXQAiU1N14h4zET7+54ZxrSo2OjSFUxUebtdR60m0Rbi9Juxcye6c0n8yqi5NN8qg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XRG0MPLgMC6OyPJDnV5ZFXC8a1Z72onuGrYpcKLtuZ6C/3/jmPsyBJKys1/9RHJFw/+Fq4QZQGY+eMaCDtY5nQOfx8yNbOnDalEcxuAKCM340uV82kuhGUAmH/pMmKuh0hezOs+qDs97J7vSl4EVrBT/q++5S01CTd+LigAwtl9S2+ZidAV+m0YFSao4HRqOpfz4MkGzn2F1qZacbajlY1mAtXAhcMM/2N9yUXk8DZpnpiL9V+bkJAu+U1ncfa1eY40NVgcycrQEOcoW4j627x8E67ANqkDBe+UKHp4aH3KfIAQPT/PeUEbSGC55v7lqUZ8s0wTtL2gigR8nRBh5CuPMsd7ZS93cLvmUHYFhLzGB+vhmg9Qbscd4i58P/ZbenhQ8SMaocanybiHj/K3SSiGvwusaXwzoOWB6bOvAvp3h5VloXRIIeQcLrvE8dHvt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 05:56:28.6001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 277bf52d-f91f-4c13-a90b-08de78e99ccc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5817
X-Rspamd-Queue-Id: C42611E95EF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72500-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ankit.Soni@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

Hi,

On Tue, Feb 03, 2026 at 10:09:45PM +0000, Samiullah Khawaja wrote:
> From: YiFei Zhu <zhuyifei@google.com>
> 
> The caller is expected to mark each HWPT to be preserved with an ioctl
> call, with a token that will be used in restore. At preserve time, each
> HWPT's domain is then called with iommu_domain_preserve to preserve the
> iommu domain.
> 
> The HWPTs containing dma mappings backed by unpreserved memory should
> not be preserved. During preservation check if the mappings contained in
> the HWPT being preserved are only file based and all the files are
> preserved.
> 
> The memfd file preservation check is not enough when preserving iommufd.
> The memfd might have shrunk between the mapping and memfd preservation.
> This means that if it shrunk some pages that are right now pinned due to
> iommu mappings are not preserved with the memfd. Only allow iommufd
> preservation when all the iopt_pages are file backed and the memory file
> was seal sealed during mapping. This guarantees that all the pages that
> were backing memfd when it was mapped are preserved.
> 
> Once HWPT is preserved the iopt associated with the HWPT is made
> immutable. Since the map and unmap ioctls operates directly on iopt,
> which contains an array of domains, while each hwpt contains only one
> domain. The logic then becomes that mapping and unmapping is prohibited
> if any of the domains in an iopt belongs to a preserved hwpt. However,
> tracing to the hwpt through the domain is a lot more tedious than
> tracing through the ioas, so if an hwpt is preserved, hwpt->ioas->iopt
> is made immutable.
> 
> When undoing this (making the iopts mutable again), there's never
> a need to make some iopts mutable and some kept immutable, since
> the undo only happen on unpreserve and error path of preserve.
> Simply iterate all the ioas and clear the immutability flag on all
> their iopts.
> 
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  drivers/iommu/iommufd/io_pagetable.c    |  17 ++
>  drivers/iommu/iommufd/io_pagetable.h    |   1 +
>  drivers/iommu/iommufd/iommufd_private.h |  25 ++
>  drivers/iommu/iommufd/liveupdate.c      | 300 ++++++++++++++++++++++++
>  drivers/iommu/iommufd/main.c            |  14 +-
>  drivers/iommu/iommufd/pages.c           |   8 +
>  include/linux/kho/abi/iommufd.h         |  39 +++
>  7 files changed, 403 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/kho/abi/iommufd.h
> 
> +
> +static int iommufd_save_hwpts(struct iommufd_ctx *ictx,
> +			      struct iommufd_lu *iommufd_lu,
> +			      struct liveupdate_session *session)
> +{
> +	struct iommufd_hwpt_paging *hwpt, **hwpts = NULL;
> +	struct iommu_domain_ser *domain_ser;
> +	struct iommufd_hwpt_lu *hwpt_lu;
> +	struct iommufd_object *obj;
> +	unsigned int nr_hwpts = 0;
> +	unsigned long index;
> +	unsigned int i;
> +	int rc = 0;
> +
> +	if (iommufd_lu) {
> +		hwpts = kcalloc(iommufd_lu->nr_hwpts, sizeof(*hwpts),
> +				GFP_KERNEL);
> +		if (!hwpts)
> +			return -ENOMEM;
> +	}
> +
> +	xa_lock(&ictx->objects);
> +	xa_for_each(&ictx->objects, index, obj) {
> +		if (obj->type != IOMMUFD_OBJ_HWPT_PAGING)
> +			continue;
> +
> +		hwpt = container_of(obj, struct iommufd_hwpt_paging, common.obj);
> +		if (!hwpt->lu_preserve)
> +			continue;
> +
> +		if (hwpt->ioas) {
> +			/*
> +			 * Obtain exclusive access to the IOAS and IOPT while we
> +			 * set immutability
> +			 */
> +			mutex_lock(&hwpt->ioas->mutex);
> +			down_write(&hwpt->ioas->iopt.domains_rwsem);
> +			down_write(&hwpt->ioas->iopt.iova_rwsem);

Taking mutex/rwsem under spin-lock is not a good idea.

> +
> +			hwpt->ioas->iopt.lu_map_immutable = true;
> +
> +			up_write(&hwpt->ioas->iopt.iova_rwsem);
> +			up_write(&hwpt->ioas->iopt.domains_rwsem);
> +			mutex_unlock(&hwpt->ioas->mutex);
> +		}
> +
> +		if (!hwpt->common.domain) {
> +			rc = -EINVAL;
> +			xa_unlock(&ictx->objects);
> +			goto out;
> +		}
> +
> +		if (!iommufd_lu) {
> +			rc = check_iopt_pages_preserved(session, hwpt);
> +			if (rc) {
> +				xa_unlock(&ictx->objects);
> +				goto out;
> +			}
> +		} else if (iommufd_lu) {

Redundant else_if().

-Ankit

> +			hwpts[nr_hwpts] = hwpt;
> +			hwpt_lu = &iommufd_lu->hwpts[nr_hwpts];
> +
> +			hwpt_lu->token = hwpt->lu_token;
> +			hwpt_lu->reclaimed = false;
> +		}
> +
> +		nr_hwpts++;
> +	}
> +	xa_unlock(&ictx->objects);
> +

