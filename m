Return-Path: <kvm+bounces-3372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B71880384B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 507251F211AB
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EEFE2C186;
	Mon,  4 Dec 2023 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LEj59YeX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B556BDF;
	Mon,  4 Dec 2023 07:08:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2b3cGLN7VhWERzUOZenqeqx6J3WU+c/HMmsxUB/E/OeON65fzi9vuduJP774md/pimPCLWtKO9rL76rxK0IeUlsfCiz24jj0Wbv3fZPeDPh7m1bB97JsW44GeoxA7BUEWBOWP+HGymEDKUho7JCkvbm8+Vs3K9KbrvLsyN/zwdKOF00Wb7x7PzHbDRzh6kvoEHjaiG6cyqTuEWt0U3KVs+qUuIjw6qZ+GSrVJPOOg69WbHf8J6xlBwtSHYmYqGt+OKO1GD8SsZFyLqNeaxANAZZMmTaBlsE8njS8p7jj0mbBqeVnNYWrMtFIQn7SkSG0D2IH/lEBuzW/oKs0uAy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GO9MSlUAfTfUr+qtjpEKWDJR2otQ+zmEx5p6H1iQCiw=;
 b=PNGSxUCvGkvHlPltEC1N+lpsEIvinHJ6Mdma4UTjLT/Q2SFf6ThH4Smg7Ls4ORO5s9k1Wpba4SmELCq8WMRIA63eYhI9PioLoaFSknRqB1WA3Moz4fUdwGofat+dzf4l6TfMDwihXX/c6gIXmXX2pwe/bfh0lsfrWY4HH9jzRno94ax5RqJd3s9KfNFW5ji6t2BxntGVJ2xhVSTVPRJMBb5oe59plEJGzeOrHrzay0CnZD29Et+9+qls2HSzvNvBp0bbxC16lBQz2dz23B5bZ95Whfllvsus2UkKBytpQGFyNuS5rP8AjZ7WSYNHE6PKRtbWhPm2FVoWXctisMTN4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GO9MSlUAfTfUr+qtjpEKWDJR2otQ+zmEx5p6H1iQCiw=;
 b=LEj59YeXdrD4FWkPEgi2IvAsPSE6bUZ43GL8g/7Ns/QHWB465IzDmmz8rVEve+ZmsrE6TNxbsdymoHb1BXmE3QZeux694a4/6ao+d1khxB1hrGVOtUF1pcun2u9om18EnqY4+jDvHmkor2upPsSEuNQYsduxotby+v3Y8eqNIGOC9/u0L7CrlhA4BGWjzpmm4EIDscbNjGA5M7+oeHPtaqf9KL6D9GxjRAZsJ4fU7/ndCJdKoRfLnAYyYnvFa816CsmdL7F/kSNjtVrWNdpLcz2S5e+HaLet4szE93mDhY8qaKHPJgs9cr5+DkbdlJUi0N70hOfUQM7nBnfRCBJmOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 15:08:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 15:08:01 +0000
Date: Mon, 4 Dec 2023 11:08:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <20231204150800.GD1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1PR13CA0306.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f40d9c6-b43f-4399-fd22-08dbf4dacec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GcFgmNSZqeZ+NN6TSgqd+s2Rr1DKwMlWFgTzCABV1l8s2UdfYYc4odCpE1AcoGeYb1ea12n0Za5fkBUpLLw9YMrNUKEfTYTasGs5xqq3TGdd9Fmg+UmceCMV2x3crgjPukMRRUxdjJqeUkRGl2tm/fTIqV1ZswFok4Iq7xMy1x9XGIkKthz7xKL1lTH144CUpYJPaGiJaQDPyMu0GSmqLwJGvxD7tctW4UFu1MVekIPeaQIJT9tJFiQWf9hIJksKPOKQi15dIQvlUyDRsKW1OQmR4p9B8yTGRtwwIRQH7j7nmI/EFoBFWd1R8sqEirk4tYHnF3NWsUB/9T/mT9aUUE5fNr8Kf7h+pHol+oKUwX11LVq/krU5jMEgoplc2Bbh1Nbg/Mv5WfsWH5Og+qxtxK+MzB+4pJvAsRIM5FfbvaXshfyCRfSRfMlZTsuY0wp6waFOBvvIClbCg4jgjjKUeV+5f8OlFUUYYMJHKHn54oE5tOuOnA5/+JR5Nydnsz+UsuHELxGs1w/9RlFadRQUI4JwUaZjoZi6EqDo5CDIwrrsFy0pHiAtEsDZ3MmBXqiJzpwbP3qSxThr1+iAo6M+oDfwznKYgw+E6ARumN33tLk0uxvpKuiqFa9zix5OmcvP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(396003)(136003)(230922051799003)(230273577357003)(230173577357003)(64100799003)(1800799012)(186009)(451199024)(1076003)(2616005)(4326008)(8936002)(8676002)(6512007)(6506007)(83380400001)(26005)(6486002)(478600001)(66476007)(66946007)(66556008)(316002)(6916009)(33656002)(2906002)(41300700001)(36756003)(38100700002)(86362001)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YhDo7g9kPL2EPN9p30ot7jr5gvhjuYsrKogU7ux26Yx92M5iqT8PlPpeX5qJ?=
 =?us-ascii?Q?OMQAyPSTCk2yNVV4MSxJlB1Cy1CksLnnfquHYW61Rko3SVclbuoztKeuSN3i?=
 =?us-ascii?Q?YCB7Ejc+rS++Fudg4mgAR+YZyUCoRSIgusuRKNKVlazdP+QrMXqJ5r+IjWsx?=
 =?us-ascii?Q?p5GvzonyQXVQ7molnKnQbJhs014LMT0AACxpM+yVK97krbM8SMopxz3O1o3E?=
 =?us-ascii?Q?fmHA8cuyvp8d1/IK2HJpdb82JUtz2iKw7jXQMFoReu60wos33rgxYBTBIGBl?=
 =?us-ascii?Q?SHPjm9ZpujokDNwNtSd0JDA+40aWNtgkHqvWr+AMuwkOEbk+0DcFIc9DpCcJ?=
 =?us-ascii?Q?R+DqCD/Bi97tEFMQFPxTFfT6mKMgbz338Goq0xaEiOvHZEw0AvKo9MhxJt3a?=
 =?us-ascii?Q?XyX0fNdMLFA8IPSJZw040TViH9yCxglNv6OkO4Kz8mapJvV7YAehwZYG8pYr?=
 =?us-ascii?Q?AHQmTkbMbR4y9SkHbwjKQUCYfChrTucUju+6i3ceNaXNb0fyfNuZvWeR8oCT?=
 =?us-ascii?Q?2UxMb4vwgglKCceKYRmbc6Z0XHPhQRhqmLs+R+3m+gfzxHrh2OrpUdpOiqhk?=
 =?us-ascii?Q?/T2kYSsUz56hoZTP3sdQqEaLHS9E2wH03a/ne78EbYDuFNhk0t4OgKIsUZnj?=
 =?us-ascii?Q?DSVK6dJ+yF8xzo9mmgwfV5QkzB44R8TG+NJvXGeM0oV0xWc4WdyxEtQ3/Y3a?=
 =?us-ascii?Q?0Zh/ZRcJOWCngR7H0hCJ4w7IMDSuk+BuSPr4cxx0eSU9bpCis8BIaSoLHUcP?=
 =?us-ascii?Q?rcZN3WaqxzlJBzEYP85TmW4G2DPrs7uhd+2dB3NijDkCUTwDtuAgqBX0Rpeq?=
 =?us-ascii?Q?91veIDnr7oGTePixjia7crwLo+OndlOISQH01kpkP8KjfgfevPdKk5EMx9FL?=
 =?us-ascii?Q?p/2L5OFdqbouLEXo6C4k2VT0EE1EWQHu/TZAPe98J0AsTDJvDHK798IL4GdB?=
 =?us-ascii?Q?egFD5WgL6rFKncuhvaECzg/nXLLM8VTWKMRJVbawUjQaxbLCQydlMJnYUUR6?=
 =?us-ascii?Q?Hs8WWTXQ4rTEzD3vIQRBJj03UsaaNu7wxBLHSbTPi12lBXWx1XPjHKdHXsX8?=
 =?us-ascii?Q?orh+QeYwoH7JpNWnBqiw0bBcZIyjKVpzg/1GNm8YECEdsD02FWWcCwV+JzDO?=
 =?us-ascii?Q?+wp0x8nwIbgMUI3JlVEKC9/tWRwj3RMInKeS21os9/sDEKZAJDXnW5g7EsZY?=
 =?us-ascii?Q?v7YZhQCtT53Z7syl3S9j9wgerXPdYYl0cRR7cazW1xkm41dlmdTFiAruLbo1?=
 =?us-ascii?Q?hHEJAZg7Qg6YAak+FKgnBqLXyLvDvHzdUpqyJbScbEh+l8p6vsM2T8JHSKBH?=
 =?us-ascii?Q?Th6RIMgriZaPa/XICU/qMRnW0omnR1MMQOwJMsuFprJq9aKr78GfI9mX4Xpg?=
 =?us-ascii?Q?usX/C+GtBd9ofIF5f/NwVkxuWel4e34rYewW8k6hjbmTEhhcrNP+JPqsumOk?=
 =?us-ascii?Q?W6s2fuIa4w1h7kNsao82E2AXlxnA6jZ1FxRcpQrrNLn1533crxh92W17MH2L?=
 =?us-ascii?Q?ofFv/O+Z2lOZWUG9axmXFE1UNEfDVk8ckD+AzEq5oO8V+COlm+DWy5jj9hj9?=
 =?us-ascii?Q?XQ9/BfnM5+YayZr3/wJDtzy1Wz+7VjX8WO2t6EVe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f40d9c6-b43f-4399-fd22-08dbf4dacec7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 15:08:01.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0cN8zLQQeAX0OLfS9CbfEjtp09fOqXO6RV/0LyX3JeZEmMBPoo9YrxvP5BENLo3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4517

On Sat, Dec 02, 2023 at 05:12:11PM +0800, Yan Zhao wrote:
> In this series, term "exported" is used in place of "shared" to avoid
> confusion with terminology "shared EPT" in TDX.
> 
> The framework contains 3 main objects:
> 
> "KVM TDP FD" object - The interface of KVM to export TDP page tables.
>                       With this object, KVM allows external components to
>                       access a TDP page table exported by KVM.

I don't know much about the internals of kvm, but why have this extra
user visible piece? Isn't there only one "TDP" per kvm fd? Why not
just use the KVM FD as a handle for the TDP?

> "IOMMUFD KVM HWPT" object - A proxy connecting KVM TDP FD to IOMMU driver.
>                             This HWPT has no IOAS associated.
> 
> "KVM domain" in IOMMU driver - Stage 2 domain in IOMMU driver whose paging
>                                structures are managed by KVM.
>                                Its hardware TLB invalidation requests are
>                                notified from KVM via IOMMUFD KVM HWPT
>                                object.

This seems broadly the right direction

> - About device which partially supports IOPF
> 
>   Many devices claiming PCIe PRS capability actually only tolerate IOPF in
>   certain paths (e.g. DMA paths for SVM applications, but not for non-SVM
>   applications or driver data such as ring descriptors). But the PRS
>   capability doesn't include a bit to tell whether a device 100% tolerates
>   IOPF in all DMA paths.

The lack of tolerance for truely DMA pinned guest memory is a
significant problem for any real deployment, IMHO. I am aware of no
device that can handle PRI on every single DMA path. :(

>   A simple way is to track an allowed list of devices which are known 100%
>   IOPF-friendly in VFIO. Another option is to extend PCIe spec to allow
>   device reporting whether it fully or partially supports IOPF in the PRS
>   capability.

I think we need something like this.

> - How to map MSI page on arm platform demands discussions.

Yes, the recurring problem :(

Probably the same approach as nesting would work for a hack - map the
ITS page into the fixed reserved slot and tell the guest not to touch
it and to identity map it.

Jason

