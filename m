Return-Path: <kvm+bounces-25519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E809661DB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C16C3B2AC2C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8821E199FC0;
	Fri, 30 Aug 2024 12:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G3JFkbU5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3575614A0B6;
	Fri, 30 Aug 2024 12:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021423; cv=fail; b=ZFWkYs0RHs07BLrR1P9tCQFKW99vdDx4CHsoE5OhJDdvv53BuWx595AM0NTxhOfB8uAORNtduY0XPAO4Aay1K8yFGVBXh7fFsFQkRw6tf3/pYCZ37yoi9F75HSfU9IPu6J7kO/1E4NClwKyRCuFuzUkgdFfMsm4ozsxBUKZzRRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021423; c=relaxed/simple;
	bh=bgFOxfkLz2osJqmAK+wPO8fCNVMbZnv4twWf413Wau0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vdem+8lpyRQr1eTZiMP26aXuYL3NFcn1R/jXT/hdV5yiwZmOHMaqOO7gyTB8tGnx0WJ0cPOxloRvNsbMb3Shyd1y2dHXQwQbzXZQ0d486jIJVItX1Yb6CljI6OxKuF+aZuC3wVI/pHas4rFgnYl6boeTxx66wk8pkVhfu2r3/WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G3JFkbU5; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ar3yUeHuZmaSZ9PSfw+rw9Y2ZrBIBMH6aSdNIdmDdshmitLQDiCWDPxnDoXGP6zorXh+9POK+CFYaOeXK7PyUmAQsneNMqwn6yd9/WdDEUbmcgmJ70hFNlsvJe9qTV4HYml4s90HMXVtTttlDEBThpDQdy/csMAMfvRnqLBFY10SukX97l3CECaHpO4lSbP7hR5FMz3jPjDpJOkroec3hqQu41doqjmDKg/r1DlgYUihwmpU1L6EHsBlnlZUqmkD4eKbJ6RZVq1CdylPGAnKbhR6HzSKdEUn1xuVj7d88/H8Hg6csqwsGdjD5ZVWdrAQ6gg2gceTyRjex1+36jKzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmmiDq7Ez5iYFB2mp+jE9Ha+Vx/mszjc+aw4ozHW5Uw=;
 b=u7wj+2hH5j1J8i1l8OlD5x+f3F8q+Txf8XyKZHcIbU6uxNAyVK41i0rTmLdY3y6MvD1jhuC2yYJvzN+bmjVnvnl4xTomIqo2FgvYPCcrYkRAxiwxLo0Ys2p/xZTM9/09IZkVd4wkBpEvNtOQOE0+mdo8qidknST3/Iu8kdFSb7M+EUdDWTR1Im5BLYarf+oMFRL6CoMFJs1he7F0Lx3eFeGl5jYibSXoRRClJwx7NR+O3mRWfwDEloVENJWwL0uSgf2DGpIMSWj5flk0nYflLO3u4S/OTJ//K1hTfFsQLCVX+U9BcNmr5G7+0ZOXUQ94tCreDk9N2xutJ4wooTU/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmmiDq7Ez5iYFB2mp+jE9Ha+Vx/mszjc+aw4ozHW5Uw=;
 b=G3JFkbU5GlCdnlCo4lpz3/PL5x31o0TD4rEtn54eVe4zFp3myC36KbtBFCCPdcEUYZw6I/AHco5Hhdw/iJ+j/FaB0bWqRxTOXI7nCQSFxLhkYxEapGylqa/Z048URHhPK33PRlKZP85mjKgwIio7Q/eJz4FkGa48+vFc06SY2DvDtDXMmRW2RRJeic8YQubdRvIljXxdlCnGYk9PYtZcB+XxLQedvDQX5cajgorAmA/0LfsM6ZOmDMHJrBJe18s4ppgeVrEhb+M9NFMxOG+f4AL4tepTrd8lRd+v8D8if6JADXwLZLPKbkPswUDRwgPwgU6RwkRkV3+HifIP+j9UUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ1PR12MB6194.namprd12.prod.outlook.com (2603:10b6:a03:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 12:36:58 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 12:36:58 +0000
Date: Fri, 30 Aug 2024 09:36:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240830123658.GO3773488@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: IA1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ1PR12MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 38e5ea3f-aa3b-4bc1-d875-08dcc8f070a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z+GzEtdrSHibc3yeoxhiyZ/5qJDaRSUCUjcHkernRiI499OJDa065ssZTywO?=
 =?us-ascii?Q?5n+Mvm9sYerkVCB181XoHEtMFpOURNeQ1WVHDSSWq8+ndap12/Hxbzik6fCR?=
 =?us-ascii?Q?35vgW8zNPbcCzEgJTIkVEoq/1PMqmXM/r8m/jEMnOfG8nO8zfr3N3RNDcnBv?=
 =?us-ascii?Q?ZmcEB8OIyZA6vYkY0AGWFGOKy9AXPifCvOofPeFE9oUMf+SivXH2O5DktQKN?=
 =?us-ascii?Q?fx/k4iomvXr+TyJyHmhtmZgXgtnYxhIbKtkjaYPI8tuIWxGCAoJklFG9vh/t?=
 =?us-ascii?Q?LdVeD21pfLiFrI9P8Ya+5A5QfLJlep50uSdxgU/XTRVZq34biDGLoZZUGKRC?=
 =?us-ascii?Q?Nzac1eQ9iNx9PNvCJSS4yzqx6en0nHiOvkrENEADnqaFcwRFvj2/YVTOYJPd?=
 =?us-ascii?Q?rDy5q04rWbBqmmNOsM3J0kU5bs8OFSVYv6xHcDUGP3Ht96QdoRcKi0UsuMwF?=
 =?us-ascii?Q?c+TgDKVAMWLRn/plm1ozhDoGqWxZtQ6c8GoDdperlU0EGJLFAOVKwpzfLcZZ?=
 =?us-ascii?Q?8/MtdSJ0xXfLhe8B7MusPqiOjxo4SptZVipMu517KpsC2r6HI3LlGIVH65fU?=
 =?us-ascii?Q?3/ELaskdmbsqK+RfFgM7dkEviFXcIQY2YX4NkLBHwGUKR2sSJ3LkfoL1YueE?=
 =?us-ascii?Q?VIUurxZA3SHqPbEK9J6v01CYnDjXHcCPhtvMkd+Wvus66SCB+uvJkPLJ6qoA?=
 =?us-ascii?Q?29PuPwePapfo4tcnIVuZHeA2sOWrTOta/T3nRv8IjOAlOv4AaQpjzi5s+JQo?=
 =?us-ascii?Q?dYLUob1WDcF/nc+XGwXO8lYM3yCN5vLJtU9jt37k/FnAFlkfW7YbLrwNqH2E?=
 =?us-ascii?Q?iGIYdPWDpslT3VFnbguk/27I9xoXRsFpZLbL2Ot0tiKzCShYPnwQU9rrPW8T?=
 =?us-ascii?Q?siyeItHbsd3blA8O0DBLRMtDvt/o/XtWFUsEOmtDKVclj9f6BSMKrANOXUlW?=
 =?us-ascii?Q?wAt16wZ/3nNCpPzidSMjDfx1eWgfgFtWSPJJ0BDFSbpTrDwFip1YSLIHSbfE?=
 =?us-ascii?Q?lYvMDOJBJctr9EZD9iXKVqBOwhayBYDZS1xhSFwWvVP8Y/g+pY6QSZYTpfWz?=
 =?us-ascii?Q?ff1ZtRnH+g/euRkGDJRulkN6iA6SXwHF50+ZqgJNi62g2K/LmOhRdh2KxT6U?=
 =?us-ascii?Q?S/rgHVCx7n+YYfbTPnYg+51lSQ42oZZyCoH4MndP96UUuLyIXguh8nkMYcR8?=
 =?us-ascii?Q?vJyCHiVEoHbeWSBONrekehFyOs2fLfsb29ZX2Lrvw20AUecIkmQTSpYIbPvJ?=
 =?us-ascii?Q?ASIUwe/oYn5pR4p8tsUzaGAk/Odq848H4BkInizropaV286sUsuccAiQWzLJ?=
 =?us-ascii?Q?5+pi5dfD2f2QC9V/cq+/hyDpkLDHB59yjFq0IRI002sl9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?di5edH2COgAWReCO8OuLyxWyP9zQhZMpRdroF3HQEohDdiutrdzwtVZsArZ1?=
 =?us-ascii?Q?zQ8/+20KkVeT9bzT5A38Xx7rVnU6LFFHaWSgFoIbZBmrMeFH/N7iUywyzuMj?=
 =?us-ascii?Q?mgJEuEzDgUk4x896MYIbxbxEOpfE995u74bPHJRY5L8FeBDQ5yIKQtQZ2pZO?=
 =?us-ascii?Q?AIMFhy/cpcDDLlAbXE+kzzKxyDJEd5o0mMACGuKLnGwY5i95EbZ7Yh8DfJI4?=
 =?us-ascii?Q?Rww7fyDFAqnMCQaqYsN6rfJKYxfWxz0jnncHSeyMLNqjJhLmQ7XdwFQJa6/u?=
 =?us-ascii?Q?aWhsoRwZ662cmmGPd8IeOAEorwFEUn4iap2d5aaZUTEdy0u+nps7XZA5gj8o?=
 =?us-ascii?Q?tKfEaVfu0Lefe7sSAcACX6VmgYmbkopiZplSmlpgSvkCUkmSK4OISiHGjz5n?=
 =?us-ascii?Q?0vevIHrpTNJZ1K3FRLuEq63giANNkRrsm0ZPg/jRQzaPbMPqdihu/cXw8yy6?=
 =?us-ascii?Q?WvqmFgopULnFqoLqgPo3jxcBZY0R6VFReOEq4vMf6XLl9nZ4PQNaewHV1E8g?=
 =?us-ascii?Q?7nwPMhpgVJX/aRvpK4p52+KU4lxXVQwYjPU/dfwWK8eVz4xolSiuuRQJbBeq?=
 =?us-ascii?Q?BI02AC+gv0mScAcQPrd3OufCqdknX0526Hn00907U2/vS6M5JD9Kq3RI4FNF?=
 =?us-ascii?Q?sdYV3AwsbmMa3njRWDc6Xy9sAhutTh95xNDCFSrnNmrnQyNSoqLFzkuibT6P?=
 =?us-ascii?Q?RHE28LPyb8j9j9FXRHUQk6SI7idnI6I1fApxehxc5I8oItTYi3fJOgqZZCt7?=
 =?us-ascii?Q?zpNIQwa0YvtjkJ2MMaOBnlNkq9UmgaEg8fZzEuJBszrQtEr2Gh/srOslRb+M?=
 =?us-ascii?Q?7UoQ5CkX1O6eZ45clfgFKhKcjtVc3oAT6PekC6eTl+T9mzyTQlacVauZBvLZ?=
 =?us-ascii?Q?hgO4VjGtg/60nNS8xFxbMPxHAq0D0o7t2GS0ZWnxe5Nn7Xuzjr+vH/tYJjk0?=
 =?us-ascii?Q?Vw+4Bcdhwk87c3l1rX5q9Zb3yL+S5R8/FmkCN9/1Gvy9kYMqrB+iTK0SnWfV?=
 =?us-ascii?Q?MSBRtPssqWg5wiZS50sgYS5msd0h9O7hlld6hrs/n8pXnn13qq1u46sa1QAV?=
 =?us-ascii?Q?6GwR/dO1zhQ+DX6dYnyKdFoTXE0fpKXenm/Lr3gg2n5pj20+yYs74yYuubfp?=
 =?us-ascii?Q?S4Kh6ZnYY27ytrPF5FTY+08aGkntwZD8TH4t4pnHe2sw4mbb5AA8TZiPF1L7?=
 =?us-ascii?Q?ButOckxOTdviz6cAjCNWX91fPNsMqmhmd3Ti7EZaxJ+4AdKNOOkNOtQ29i52?=
 =?us-ascii?Q?rjjvtcfdm20+AvHlQuf5kmuFXofgsMENEEIe5AceRUOF0EQSaMlk13kDAWr9?=
 =?us-ascii?Q?+iLrIE1Njrylvu4ayzJAgdb6x6nz2mH17tfgIwRp4y/WHXPL7SqhYiTmvKC4?=
 =?us-ascii?Q?bBWj57TxqJuFd0+E+5WXU9T9wVbaide34KYGFITp2cxY+lGQg6sPs7QkQUev?=
 =?us-ascii?Q?ocb6lJ+y/sUhLqgC1CgpcJaru4vTQg0Z/c4zYWLI9aAU4MGgMyygYpfg2F13?=
 =?us-ascii?Q?HNjtlG77ia/dNSFh8UM+KhH4U50aF47hzP2RGz30s1CHGbAped5EeRWiFY5D?=
 =?us-ascii?Q?YXnyfROO4xOvhAwdLlj5aJwLO26+vtdV5FTGh0jX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e5ea3f-aa3b-4bc1-d875-08dcc8f070a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 12:36:58.8185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32XEZd6ZoiK/fNKkxnHHnQTwhyxldPz9tYaFddBX79+VGNKdhwBJN4raPgsm71DO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6194

On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:

> > If that is true for the confidential compute, I don't know.
> 
> For Intel TDX TEE-IO, there may be a different story.
> 
> Architechturely the secure IOMMU page table has to share with KVM secure
> stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
> ensures the SEPT operations good for secure IOMMU, so there is no much
> trick to play for SEPT.

Yes, I think ARM will do the same as well.

From a uAPI perspective we need some way to create a secure vPCI
function linked to a KVM and some IOMMUs will implicitly get a
translation from the secure world and some IOMMUs will need to manage
it in untrusted hypervisor memory.

Jason

