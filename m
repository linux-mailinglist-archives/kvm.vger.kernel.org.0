Return-Path: <kvm+bounces-33225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD649E77BE
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 18:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F1FA28384F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817B61FFC44;
	Fri,  6 Dec 2024 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HaWajSbG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089EC13BAE4
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733507891; cv=fail; b=R7Qr5/IHAjScW0oL7F6pV6n5rY9MCR5JlJCcJ2jKbS4vqWqKnpPmprbLLO2HH8qISDs7WXyH8m3g1jRcmNpccWyGdfRyDhLYoQazgECf0o7qhdmyTh3A1sj+YoYc3uU3IMQjmGvWHY2AX3Is+Q0Q8hkw9Q0AjCIdfWPX2GhwIs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733507891; c=relaxed/simple;
	bh=OOLsASGkO2DLWqmWMfiJcb2vHkceGsXO49yZP+49yWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gzThMRr4D/AVbzDwreXOMR35jJKLyOU93s2Y5dMZp1aCKqplEzQ67ptfPcIdcokNL9rs777vSZ/arYJ4J8pLS1RUPtGn4YecrdQzLHFjh1eQu1DrGjoI38ao7/lmb7AaCYNwJJNHZxysOjkOGVzsag510K++mzj1hAXbSHRK7Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HaWajSbG; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2+yl6gmGc/zgDfW8/EojgDo+lK3XumGmTZE9f+3xt+Zrx8y46wKct9cFodZLRyuX4X6VW6++aYY7tLAYFsdXGcDBYUIeXRXMf6YjkBrIQ9a6z/2bP7MDqXJXqxpZBjs4jWZgKZ/a5Ovut35IGgYkwULEkAmKK/dBsSm6AE5W95MTgwkRWksjBeN578uOtPU9xwM6FVEr7yaze03Q4cQMI4JgE0Z6ymtFWR3fyg4XVjm63sAr+t6vfRnOmDSI62qeiQuH5dZ8BWIH90QpHAHCD0v8lamayV8ffyZIT2Zw6nDCoriRZcfuU+m6XzqJDZCURvzrNrjr50VPjgjxC9unQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CTDNvRDPGe042ZcsWnQuzQH66aclX0FPvE6//j6uMc=;
 b=iqXsOnYMPIIGxdB0Yj6mGhW2KuTWITBQhZwumMlVrhUFR3IVVXMWLfRa11Ffw4tD6I0dkQGg0GA3MZUHHcXe9oo7YKNiL6w++SfZ8loXoTAlKD6+wKvUqG7It9sOx7Ba0JMIlmPzzUzcvjs7kc00QBqAl+rGye6CEx2AltSA0GXBfMYiI2u2v3JAAZrukMAc7Nmpnk0jEv05iN7yzIF2N0WzUtJGWXUrW3J0y/iZnUqN4e8XRGZbwpcR7Mo65GOC2qXXMbNch77HTiOI2WlAFuMqpmdD2L03h6icvTzxAyJAPywNLY2Jx6qQoZI3i4tlolK0Yiy7TcEWnl274CBdqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CTDNvRDPGe042ZcsWnQuzQH66aclX0FPvE6//j6uMc=;
 b=HaWajSbGi8p3zg+WObkI158d2W4619s1JI+23hoMCFFjsaAFhEHnN+61QrF4zHETVmGkfXijltyHqw+myxX2db24QPAdZyxrdBNI+2CjuN/PC8Y/eN4YAS5XU6J/4JmMAZ2E8vAmvJBDcKJBuOeGg68xPT0IizxiwAnaEMHnCE3zLqND57LZqoe7brxOk3LxxfFBg37toat2qCwAOpzR3E9yso4nQXidZpd85YwAibCOyXki1YJN5CmrAkB3SKTCPeZauF7pwyIIYcjRq+S1z1h7OZKKbHi+lVykPaxfKzo0mCBKlzGdQkCQZ6DAUUTW5Nnivm3Zc9YcrET91f1o1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.15; Fri, 6 Dec
 2024 17:58:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 17:58:05 +0000
Date: Fri, 6 Dec 2024 13:58:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Message-ID: <20241206175804.GQ1253388@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
X-ClientProxiedBy: BL1PR13CA0291.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 17bee8c2-4566-47bf-0819-08dd161f88c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L6TAFY9DBm4M4WVOiR6rPpTKTef6yhYFdE1Eh4FgxzZCKkjRFbA4kFz4twye?=
 =?us-ascii?Q?lJ00VuDGiMge8B6PaB00XN6dO/jJYBYgFwNHiapq0DkdOfuM8UWzL3MCXlHJ?=
 =?us-ascii?Q?cL7wb+MQWHjDSqzEXowZCWAIUX299Fud1eScbBUplTHY2b/xvVVFof567g9x?=
 =?us-ascii?Q?fSf4tt6c4m1cSTPwLFtkywltc+k9T2cS3qeqcaEZJC8oWP73j5QOSAH00PHN?=
 =?us-ascii?Q?bfKHNDLOBV5Kq/nq6jaWRJ9pcLMVaE/YIC7OFLuvu7nXbe4jdwj/ZXwHFJP7?=
 =?us-ascii?Q?JawXYZ3hTUjVYtLwOSgGSgQRh3AcYNzV+rdUw6sxNjcV3umf222HsW1b5JPq?=
 =?us-ascii?Q?B/3ZaN/4A6imdbPHlVKMwz4KoLQGLCLs4F+Th576t45BcONC3hL4TTH0cARS?=
 =?us-ascii?Q?dEZJ+5/aRc9c8rocy6wplxCW1WfJAY3tNJw4ttIqnBGPEMtyXdb/luptvl8m?=
 =?us-ascii?Q?u/FXSq53ZXV1UxRRqjEKNT3RZgwt7zELab2Sjx5en33QbjPaE5e9Iws0aRdf?=
 =?us-ascii?Q?6DPSWXZaZcCN3mXMLkDvjdmMDhBIyDQcC1UGHoSb3M8WguefA4Jw5r2Y8gP6?=
 =?us-ascii?Q?e86+NdA7Kfc2V+ZWgqkiTqyBWWHwP5rYShQhr4nyCy09VOXBM+NeJ+V5rdgR?=
 =?us-ascii?Q?ouort5bmcfXba/xKGxarapozmOf8HcgeQf8Vn6nTF8EQKAWHruYmFPL+wtbI?=
 =?us-ascii?Q?NW4HgrQHQwhCdMTu3K45llrxxZqJd/RqgsVeY1Ul5l95Z6iD51vqXapsQArk?=
 =?us-ascii?Q?jgMYmOZ7zUdxiF3SMRPorUPVFobV7Gr22GXzwb9AiGSODwexJ1rR+nBLa+UJ?=
 =?us-ascii?Q?5lixI3lglufCXivIRVUvcJGBr7UPX//BmQMBU1PpBR/48K3ed82pKY4ngve0?=
 =?us-ascii?Q?cwvd9yO9lCPcHMyHi+JfDgQPQOGkhwVUkmQn6HTI4Td6xmGKLKH9JnL3Af2Q?=
 =?us-ascii?Q?TCz18wdfEM4sKQ4O5Xpq8t3xsH/T4JjmZu1fQEvio/oTy2uoUb8il2nXnP9U?=
 =?us-ascii?Q?BX2rUQ/IlR9qCmus9PRWTA5kp53SD32fFvuSWErlz/vi2JYDS6RfBkmzsUou?=
 =?us-ascii?Q?wDZZj57g15LlE37cV07v6/KLrt24ucMHQIQguYmjt+BQDMfTNW9zJyHzIg14?=
 =?us-ascii?Q?+kueKA2SG+nJlYk7BZ/qYrWRPwV6bAmnavLVs8zHjk1Au27PT9aHDPChGYDS?=
 =?us-ascii?Q?yDc1OxG1Y0lAiJ59xv3He8ecGoUK4MubpprJfKA68GWIFZa/aHNW1kRYi6l4?=
 =?us-ascii?Q?qrrNVZzQvMmPLamUTweZWUW5Cs8AdmTII2vdIIeHrYb2W45LvxxKWsBdtrep?=
 =?us-ascii?Q?1uOZ+vdOWdEmW4756xtfn8EGVJuO0Mjei5rElyu2Il3Nog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DrqJqO4Y7PkhKdoLZ8IO831jNtvNb11egvs14UhR/M46ac2wF2/yYqR/oXtq?=
 =?us-ascii?Q?hKPKnC/VlbDwlldHHZSuEjJQT+GeWX2c9Qk7p5ZOfzk0bL8Ka4hq7pALOVtF?=
 =?us-ascii?Q?y9UuvVcHmIiwBx+t/5iO8bMAGwb1xdkvwTLZbnrQTVegmEUJHJK948AdfHXm?=
 =?us-ascii?Q?d6cgVZA5leq9eUxNoyU1lcV4a9kRD6mDkAn5xLKvH9bnO7GG9PVJc8Rk0hBN?=
 =?us-ascii?Q?WVWfmnMudvKl7CcoxwjFG3T6YlcYrB9btH24mSyRAEblw4rVSEEOClPO1dg/?=
 =?us-ascii?Q?MhLj4FyJAL+O5gB25HD5RXJrZC9O8yeRg/+Eb/6c7r5eaKr80nb1HtL6OXy3?=
 =?us-ascii?Q?zF+NoASXkDe3+kT/lAeWasnuuWCjcdLNEE/ydzCWSXE/KUpyXmzTE/uFSX+x?=
 =?us-ascii?Q?TAQozliZ9cKKdqv5LoeVMCeiHtPj0IyGuHkOkmNPSH6SX2OALWIPvg249fdC?=
 =?us-ascii?Q?eroJxGoq+UB1CdTTNErmDJ8laCVjfTLzWJfG4nuv14PszNtl7yy/0X4cDrCi?=
 =?us-ascii?Q?c/4Iz6YzFtWSAiS6c5QWDSXQIE9Tk5TnNbqT8hiryypvPQNNNW49NK3RA8uZ?=
 =?us-ascii?Q?fEmu+xYpICyrDI2DRmvnWixzq0UB9ISNG0cL2GrzU2RvXNbDppuyt6or+P7I?=
 =?us-ascii?Q?ZTjpHXmOPm4/VNbBPA0pnS9aMYWfN3OjW6A6iiqZk0v6Tl6cU1wKixU6vwUf?=
 =?us-ascii?Q?0SM7pF8XRH8JIC67Fw/nkCl6HRn3YOj4BgzkH9jIMnL4InWsRcDVBbIKbYOn?=
 =?us-ascii?Q?Jw6Ri2Fye+UaemlzckbX2AocUx8I54Dc1opUHJEwFOFrQONJfeiaNgBx2+Tb?=
 =?us-ascii?Q?Yr3Z7ragvRqXMGtKtCl1XFXV7kzYp+i1bHIUab5CrBxte21mw+u1DZ4PQgWJ?=
 =?us-ascii?Q?Y5Xh270J/6nJpWfncmk5o8414KtuFx2Fn15AFELldEPwGVC5gg8Sr97Ceqan?=
 =?us-ascii?Q?qjTQ0JUFCi2UysGljpiPAG5Vqku4XPL5qtreqo2Zog+NZGmb7UKZ/j2fhjqK?=
 =?us-ascii?Q?EXSX6e3EdE84NdvFE8wOcRdq0Os6Op/3yDyTFb20C9QVbBozB3eP+9RzM3pD?=
 =?us-ascii?Q?GzcOGAbp+a3rMKA4nq0KBwEPUqtxDrEBNumz0Rry9p9aSv4uWDiAF+N7fngB?=
 =?us-ascii?Q?Jqe+pMpl0T79EOBTLsrNxUsNjvoiRwR6GNqLd9raRvlSRzQaqamzLUli5kWA?=
 =?us-ascii?Q?Y7/RqijyDzF8VfqO4khrYx5Mp+FQftBNsgkXk9WLYQD0BPImOcheNgTOn/h6?=
 =?us-ascii?Q?xRpyVDl3KAhRzqaLPpeEMgEVITPNF0lbIw7P2aDIvDFSadUAXFIFecpp0HEe?=
 =?us-ascii?Q?klJcY49HUBSlpKGC7g0RM0uGHRz50/RuA3YLRVVgBGBzuf3krIoMTzL5t8mH?=
 =?us-ascii?Q?SGHoGVW9yOvjweic742add8FHDrzoAzDXegoUC9npAVvl4r4J2gXh2ns8JhP?=
 =?us-ascii?Q?oUwc4Sz6wBO3w2+oVOYuE8z3kzACvS64em6L69mSWj4FWopNhmCPNHp3hqGZ?=
 =?us-ascii?Q?+kNEOuYevuDCw32hzk09c2vgsuTrPEDlc1bAboqKE2dhfyTLnuslM4DVqm78?=
 =?us-ascii?Q?1endGAus21M2EzaOTn93mVcYnxniCPB4PA9DUS7f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bee8c2-4566-47bf-0819-08dd161f88c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 17:58:05.2413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNJ6dXwZJ+XRfqAkTweVVZVIokaL+HXmIhRNBOBYYWmU8SErVHwioVkcOMrRo51+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

On Fri, Dec 06, 2024 at 03:57:39PM +0800, Yi Liu wrote:
> Hi Jason, Vasant,
> 
> When cooking new version, I got three opens on enforcing using
> pasid-compatible domains to pasid-capable device in iommufd as suggested
> in [1].
> 
> - Concept problem when considering nested domain
>   IIUC. pasid-compatible domain means the domain can be attached to PASID.
>   e.g. AMD requires using V2 page table hence it can be configed to GCR3.
>   However, the nested domain uses both V1 and V2 page table, I don't think
>   it can be attached to PASID on AMD. So nested domain can not be
>   considered as pasid-compatible. 

Yes.

>   Based on this, this enforcement only
>   applies to paging-domains. If so, do we still need to enforce it in
>   iommufd? Will it simpler to let the AMD iommu driver to deal it?

I think driver should deal with it, Intel doesn't have that
limitation. I sent patches to fix that detection for AMD and ARM
already.

> - PASID-capable device v.s. PASID-enabled device
>   We keep saying PASID-capable, but system may not enable it. Would it
>   better enforce the pasid-compatible domain for PASID-enabled device?
>   Seems all iommu vendor will enable PASID if it's supported. But
>   conceptly, it is be more accurate if only do it when PASID is
>   enabled.

If we want to do more here we should put the core code in charge of
deciding of a device will be PASID enabled and the IOMMU driver only
indicates if it can be PASID supported.

>   For PCI devices, we can check if the pasid cap is enabled from device
>   config space. But for non-PCI PASID support (e.g. some ARM platform), I
>   don't know if there is any way to check the PASID enabled or not. Or, to
>   cover both, we need an iommu API to check PASID enabled or not?

Yes, some iommu API, I suggest a flag in the common iommu_device. We
already have max_pasids there, it may already be nearly enough.
 
> - Nest parent domain should never be pasid-compatible?

Up to the driver.

>   I think the AMD iommu uses the V1 page table format for the parent
>   domain. Hence parent domain should not be allocated with the
>   IOMMU_HWPT_ALLOC_PASID flag. Otherwise, it does not work. Should this
>   be enforced in iommufd?

Enforced in the driver.

iommufd should enforce that the domain was created with
IOMMU_HWPT_ALLOC_PASID before passing the HWPT to any pasid
attach/replace function.

Jason

