Return-Path: <kvm+bounces-3374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C7E803853
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFB6F281209
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1B12C190;
	Mon,  4 Dec 2023 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RQOBz0ev"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D02B2;
	Mon,  4 Dec 2023 07:09:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyQxsBnXMKiLzELL8iPbSeiGQ6JGLeI/H4LhQE1U2Oj1OPaIgtnlh8qpXXHYUcrJcfStyveA9s1jIW1X+TidQ9KiCJX9zBd3qOAxhy/3CeBIhvumslm2bgG16OuzJPE6pf5luPOHH8rLCngRqOpFZldQwmT5aLPFvY6jtD0NdCB6ueNg60RFSNVhJRjVi1z+pGb3ibnWTaSC8L3QENX8AxdXgufxEiN80by8b1GflTrgLGTEX7fmjmecry6PjeSpWWe2TPomhYrYuPULjiGWzw8jUYrY79YvZRB8n7tHCrsNvYbceglGtMqkODCxMP2YMhaAvoj5W61vOgdUEa7Z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nxac5h4CRgVuVmgAxO2EgTP8skxMtasLUbyOZ6SDHbA=;
 b=Hszx30Quip6RnxzJlMCTcbU1L3lFPg+BYwrxrOgRp3n5rwlE+lMDu8eH9oimmG+t9jqmp039K3FcYEEpGUv9KJqxpTMoUKXPHoN3CApmZg1/RXoXPtxPiK5YUbSTuhGwoQ7OAcq4MqRFKfp5zYr6/4uI19eq+WXpXkueLGmr1BfPE8GbzL2OgH773R4GvoyKASUBQckqazCpR7T2qAFGRoM0rvmYWIr07DzN86hOQeiIvaQusdqksR6V/CkmMepIXBzhdoQdmRmAXZzXA0oX1NDwclSaBIWUc5mp5tWwNf4IZk/x3GVqTirST9VPIPvO9VTIr3JPBccZEy46tmqb9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxac5h4CRgVuVmgAxO2EgTP8skxMtasLUbyOZ6SDHbA=;
 b=RQOBz0ev79+cHcb4QbGBFKEb+JSn/kExjOYzpexrn0TUSu/B5R+Ct6R0iaAEWyYXLVqpR7kN6oCnOuWtX1cG9nDpoLU9JVAR+U7YzW7FihodF3D4hW53QjVFcXoipyLFTNIG3IXLKlRsnREhlY47VO37kP7k2CduZYPcg2auY3hJrHlwVr1zGpRS6JA9DCE6ecMvkOAEwaMKyNw7O2NH8lsK9TeHIFFDbZIvRkgiTGEKci/FaCZ4UrTOxl9QEbc0Wt6xzozg2oE4kJpqtHJIWaoJe2k+N16Fm+iwp5mKPqBBcjXEQZWuj2VH71lj8cNI0tY7PrmTcRpPQSLai4KWlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7113.namprd12.prod.outlook.com (2603:10b6:510:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 15:09:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 15:09:46 +0000
Date: Mon, 4 Dec 2023 11:09:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 11/42] iommu: Add new domain op cache_invalidate_kvm
Message-ID: <20231204150945.GF1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092041.14084-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202092041.14084-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MN2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:208:23e::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de207a8-7848-438c-24da-08dbf4db0d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7D3+Mtd2VawevYtxgfNoCL6tAIwenzwTh0t/RS72BNKBBuVk4iTznhi0/dY7srEP2eRX5CM21GgtonZDSejHluLwWoOAmtEn0owCYygffBNNBqhLUbao5y3fAEEBbM736p0pAYL6NCq7rukYJdeY0SGeI0RZNbuOGN0jAFnth/l75DP01pHFgWH9fb2eTwKUDejDEVKIw4xhxuXEZBc2LGr+K0VzmhoQEbH72E9K3MoTrHjqjYJlIteI3zN8CajQ9ubfrbNi7LfaOqZQ50DavUQc1c9LX7JSdbLETWy1fw22QwaHeOvCrdCRjZtjLL0RXuPHhBaS2NSKAz0zKryd06MmkkQQaPykTC0iBEz5yCnTml8hzIsENyo9k5fgRFMIW9gADuqR+fWcOdz5vZw/W28mzlzUNx9jtecoDrFgmIyN4MQHuPI5NGQeC8F+ydh6uge5fmmd6qHG8PnaVxIjlYkLwp3mTvo6RpJ1avNSLVfYHO6wjuuoNVMzYeksHHaGJdyEAuD0ywJnokLZP4CwhXLCbP2/VT5DrQu+ZTW+cN0t6Iv0HRbfx841oHz80LmW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(38100700002)(33656002)(4744005)(5660300002)(2906002)(7416002)(83380400001)(6512007)(26005)(6506007)(1076003)(2616005)(478600001)(6486002)(36756003)(41300700001)(66946007)(66556008)(6916009)(4326008)(316002)(8936002)(66476007)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4MRwM/DtMtWT0c4vh7pNitcXu7Pdl9JnIJl7e6Dl047h0WCc5JEeSqe0PaxF?=
 =?us-ascii?Q?jGrG04IeomlNA/UEDTczlKHKPiqEyhYjuF0lrrJAucaQ9vGyC5Tovv4WzZR4?=
 =?us-ascii?Q?sGpDa2VjD9H4tWMPJI9bTBrmrxrbDkzwagxcggrq3II3m6CrxH/QwUsyA1JN?=
 =?us-ascii?Q?zkZHNySyHo5BC7ws6hUuId5ONJELAdpdcJkyylFuruYB7kRRzM6LOffy+6/5?=
 =?us-ascii?Q?fdz9RmWUnCC/9Me6/R2RkUjwe5ONyeIC/t5VPP8iq4DbmAK9TobnW1mj0sB5?=
 =?us-ascii?Q?mGRB+NDEe9VTXajvw26XwUNFjllVh7M/RHGwYjafspNZGriej9qbWhFdZu96?=
 =?us-ascii?Q?boYj+i50cNdl4rsDn1LqoX5a1GVrwI7pQydzJKorIv2Dx0HmJVGSNOwbh4zt?=
 =?us-ascii?Q?8XkDYtNidDYkoZuVe0cYJXrxU2zO5AvcFr/f880V6H6QEOJutXcIWGdJv5K2?=
 =?us-ascii?Q?fwbsRp9hJR3Dc0gdTIRWO0Hgai7RrUdh4eWlzhOhWnlKbhdJePLk2+xIaokL?=
 =?us-ascii?Q?grDZk8+S9oFUZ3KO5vNsusqkhi69gHJmSbpP7DORA7p9MEUOURSB6rHqGfPL?=
 =?us-ascii?Q?RDaUV7T7W7FDDQzQMf5ZtIANBoKQoAUOO8ZE4QEDWHMWc8cTpl4odLdfeL/L?=
 =?us-ascii?Q?6311/umVA2qx8CwgSB+1jq0a/sAo/ddBtVawVNFmFgQAnvZfpvoTjwFuURtq?=
 =?us-ascii?Q?diyQmW8HgdMY+Z+sTvfbkOtxbHYa/OLh4VZUO0T8rZY6Q/70lY3ViNbdIr6X?=
 =?us-ascii?Q?uqsTJMJZdOrcdzsz/LYYoYSigtprtj0Ky9EmaXuAKKowo/nCT3zZwjW7oRRL?=
 =?us-ascii?Q?6FU0Pql3xi/w7v0hGVA+v8V6McKaxSsEu2kLH6ORqwRXP7a2YocPGpdpJjuI?=
 =?us-ascii?Q?W+2jfjjlRp+/DhXP2jCvpkufO5StAImLpcY3AJ0uCw8+q5KbVyzbe5cY3KCR?=
 =?us-ascii?Q?IbyeLbbC2a3zep90IUMuysgyvATakF7QVt0aM8sbFNt9ZnPn59GA9nbby/Ms?=
 =?us-ascii?Q?RByXhOAjtbZZHQM5whZluyQa6VgYr0/AtXCNxE5WnGFujR9pVxtoAscEHC7a?=
 =?us-ascii?Q?fFS42Xsz8lHm3IMoMdkwBMgor7se+MQdD2e/iYBAZH79CC3d3sP5nOIHpHdI?=
 =?us-ascii?Q?65vb8yEGmO6ptA8pKaPAVt+vmoMBWfmdlsXJZb/3cDkkTVaGPi/jfQ+Dpe/r?=
 =?us-ascii?Q?SlJs7xuMAhoL06tDx/b8t2AR6PDcCKq3pO0j+CaeA87hgbIL3TCounmuzRM/?=
 =?us-ascii?Q?cl3BrrFQ/zQsfQqlZALhYT3TK51rfagFsqUPfyJDJNnWQfSzBzE1icVis5Mm?=
 =?us-ascii?Q?VdWgfBj1bTC7h+n7LnVzmZMIW+ce7mq7a/8POjmSpy7tgOYRZ79rYf5D+tWh?=
 =?us-ascii?Q?6SVXHbMXcblF8CPlsePdHAjFEf7lGNU3u4BqZzHcGSa51MJU7SJ4LL3o/dkX?=
 =?us-ascii?Q?gs6MIQn7Kh1e2PuADWUseSVBwtgxLA1ro4MTVxKZb0pVbnDg/+5lN8jNfQqZ?=
 =?us-ascii?Q?Un+espzRQ533p7xnVrU4YhoxaMqCqB2Oid07IH01lkBN/2Xqormi917inyyR?=
 =?us-ascii?Q?F9uazMRjDwsW3DZr5DvpNOpdB3qqubFelPI1cQln?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de207a8-7848-438c-24da-08dbf4db0d6c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 15:09:46.4544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8ttZteJsigb0HdONx/WStg/sR9Sx556zA/z6s/iTDPCLf51ZbWOdE3umsF0PYR2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7113

On Sat, Dec 02, 2023 at 05:20:41PM +0800, Yan Zhao wrote:
> On KVM invalidates mappings that are shared to IOMMU stage 2 paging
> structures, IOMMU driver needs to invalidate hardware TLBs accordingly.
> 
> The new op cache_invalidate_kvm is called from IOMMUFD to invalidate
> hardware TLBs upon receiving invalidation notifications from KVM.

Why?

SVA hooks the invalidation directly to the mm, shouldn't KVM also hook
the invalidation directly from the kvm? Why do we need to call a chain
of function pointers? iommufd isn't adding any value in the chain
here.

Jason

