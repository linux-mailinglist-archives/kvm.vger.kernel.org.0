Return-Path: <kvm+bounces-3373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F48780384D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF0C1B20B95
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847852C18A;
	Mon,  4 Dec 2023 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CkgDSAMA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AF8C4;
	Mon,  4 Dec 2023 07:09:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzcPnskcVphFkGeRpuCMd3cnn/t0kPr2FZNzfngF2tG/fF/cPvfRnWa4xuoLpN8jhetYW0DF7zgqd26EYwV23HE73339R02EJsVNjUtPJPnnAfpWJLDZceIm3PIY7Oh0myHarSJ12xf9l7MBpOHGm9IxR9cfLIeNRqabsCHYA6w1bh3LrKJyRJT4b6Or2zvYLReIVeWknV1mO/gt17Tqx10fs6eooora7BiIYuabWlV0wvz7fbBAxvcR6PtEdYziA2IzBPC3d7rFWaDetIYIcx7zpNJfTa/ODDdlVH1Yjt10FMyKBTVg3lDcCL5nNwTkbvOiRI60eAONZylMUIBQtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kkx7dY3ao0ggtpIoSiw8Y0KyYHpsjg4wsCyoQDBLAU8=;
 b=bq2iPmchZD6gyri0FlAHCI3GibNg9G6POgOymfgpPMl6jtPH0sqFNnVsH4bMoNlObcuirTLmYNNEDUOHYhy46kgGkdsckhl9L0jMcg2HmqdRXAUMg0O/rbSHDQrw3wvMybO0pstI4dNXOVfNbAEzknju0fmmR2oDfvm01aL5IX386JbSwIm1LHPwXje0b4/groAufXHdvAdZlXmf17dcrMmeUXGv1y32JM1zyOGzPSEjEW3FBnsJDOxOTxKmHXN+rcdDWSqk17ZW0D1XCrN80vsH5uxcTdiIheTSulJRMSuEjyPd9PnY1LQfk4fQylmVFpOABFrcpbCfke8JgIwt0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kkx7dY3ao0ggtpIoSiw8Y0KyYHpsjg4wsCyoQDBLAU8=;
 b=CkgDSAMA8utbJ1oP1kkVe4k5I640sjika/WU7I3Ix/haPjhIBBLjavqd/irAKOLDxDsBMP1RyjqQKV+RE5W+lCngiaWf2vjNFS1iUnnR3KFGrvf7DvfnGTipuxjbjtQ/YxothphVC/hJ33pJor6x0KU987F3qGSD4M+Zy9ldzDK7vlCNNU8KBQSyLtoj1ghI7zuLNV+XkDagYHt0s5nUSL6fiMUkweTkVoVU9Oq54+Cpd9WpElV+j62QBMe242axAQX1gktiuvL8v0XzQsSPWUt7V7Pnpfg6Jp77ITOqZW1aE8yh0yrPqFVugcHvF2Da0RABFMGfG+YgI09Ozwpgig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7113.namprd12.prod.outlook.com (2603:10b6:510:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 15:09:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 15:09:01 +0000
Date: Mon, 4 Dec 2023 11:09:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 10/42] iommu: Add new iommu op to create domains
 managed by KVM
Message-ID: <20231204150900.GE1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092007.14026-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202092007.14026-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d57da0-c71e-46b6-57b3-08dbf4daf24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a8R2aDURN+rCYQ7TrRiPo2yyqqeD+9gRnKx+qB60sy62M9z1MQu+04PQ8jq4436GlkAvOGv7gTHH83RWGbrRqv/6wl52XwbXQej58ee98IDa/GYyrV/d4oU8IrKFKMoLPjKvJCAtJyKH2atpEAwUPniGOm/nbrssRP3iANNpS6di6Jqs86JsSFY68vmdxsarCoYXH+0D5ZnaSeMqnRMK+xbLAJOU5HDwC5jOTNNYVDafZeQnwcNF3Z4kOjYFjnVyt5XvgDpW+N/scWheUKEKNx6wjmaLpjUHT6n+U0K8+FyHwa3sjHWUotzxHTKxUh+FqKqFI9hxD3QzQXMhBEQS1hPC87x0jMgP2tQ3RFcuk/+2zAOxdvZoE+QAuq5dnAgW7s4KYD5kgqxCMg/sbEjtDY8mZ0zMGlR24+SV3vIborrxYL5m4efDYy/ZfSW5KCFbm4b84MwbuKOfOywkjxJzD3Rs/5VAz3SazrkUx0VZFvR87Hlhg1ji+/Cf0IUkJQ8AoCLGzaR1frdWfXSuN97jMI6oCLAwrdwV9UcKOniufFXTdKBt/+Dw0DuMxFmPWuT6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(38100700002)(33656002)(5660300002)(2906002)(7416002)(83380400001)(6512007)(26005)(6506007)(1076003)(2616005)(478600001)(6486002)(36756003)(41300700001)(66946007)(66556008)(6916009)(4326008)(316002)(8936002)(66476007)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SU5sVgN8hDMvuVhkLnqqkXcHGzCSZ4/ECqiZbbMto5re8TAHv3OAZ8IeXO5/?=
 =?us-ascii?Q?LEfSR7qDwbhwbC4HyCqw25+1xSV9457EEL2kWbKaVPcO8cYmyt7PSMRzPXKd?=
 =?us-ascii?Q?7Oxo6mrY5+FdwH0CHgzsJqdnqZEeryeXKnt51R+eGDpFNbtssJR2yxKppOH6?=
 =?us-ascii?Q?9UFxR5by7Z0uwqkkZylR0pLI8PWX+B+KI3MLQ29y2FsPS5V9Txle4xQtQKqy?=
 =?us-ascii?Q?T3VwGwAsMnyoA5c6MclRzv2TfbZRVeEtc8OmVg0MmXzLbyAUVpIA1K5iAjFy?=
 =?us-ascii?Q?MjQs2MbwSdY9ctvOy/zlf6dkATt5nm+vYU4BtL8qAHfdEE32SWWMVt2nO990?=
 =?us-ascii?Q?nmsjb2QWJSZ5915fFp5l8IetP0qZyEimtUXrD/JI/2l92jlOJFRi8O1XApbx?=
 =?us-ascii?Q?LoXRPGwdmp0+xm/OUsFlcQYoayswDXGHmtlrBDEK9/vqJ1iXmrrE6zOdMSCw?=
 =?us-ascii?Q?C2wJk1GR30/khfsvF77+hLyuuRR38j50Nbw2FMdrUgJCyE69H3IT9wTG+CDJ?=
 =?us-ascii?Q?1tk/hNuikHNPSc2WQWRDFY0VBASc3kBsGy30kiAmcCTzsA7KSNF2U/feKT7p?=
 =?us-ascii?Q?UAzy19APQPpiVAd3LkyPaOvc37ecLzkiOATWYf2yDh8kne3C3GWLwwomzokq?=
 =?us-ascii?Q?bad27Kl7ezMjQ6uhy2OcLyAzTgAY8cUK4WQNIhvP/MXgQFjcbJcRSo59wXgJ?=
 =?us-ascii?Q?YrrqZ/H8kUPeNnWNUCAT5fSjVQ+8yyNXYjL9wCRNZ884YGh+hTHVeuQfdhrV?=
 =?us-ascii?Q?KQ6y9AhoGgOYUrsZhtablF+GQMrd3Ws9JpKmoJ28tDcMgh7cV7NsjLixm95W?=
 =?us-ascii?Q?9cdhprvc017V2dPx60L653Hr00aPgHBFGMPGZ+tcfwdd3UIyjIttLJQSDw9q?=
 =?us-ascii?Q?/24f0t0FihNrQ252Kmk9uTayvXjb57b0wpRyfM4a7AuPTYigOoxSCbyWDdv6?=
 =?us-ascii?Q?mVt2HiGy0v2XA4w3iXvx+0rS//JP6V4J3ElJPtuGI6y8Tldw5AcEmkEso4sM?=
 =?us-ascii?Q?ZraKsh/vDL5MbMUiI6TwSk4dPlm71IiIQxxto0fS6HUTTlW8aQekOfoVK7Xo?=
 =?us-ascii?Q?BposisvP2kjzl/mfhsTmpIPavAeT8lAWsZv99VTMj5wPs5DPnjKvW0SuNj9v?=
 =?us-ascii?Q?H32i+znJVO/+r2judGh11/kiCliQpqi+xeZ+flYb74jbizCX1pdgID8x2rqs?=
 =?us-ascii?Q?qTQeTyiqXd2P3/56sR3Knj+iiOAk8aeNFy2EwqNfe9BOyuBszb4uu6Mv57Oz?=
 =?us-ascii?Q?GqVK72CV87EF/2548xiro5Cj0hS3Eu3VAnEDZHrs9+tjVo491mDacYehNhNu?=
 =?us-ascii?Q?v1vKVWw1UvYo70TFo4KpZsxOvfDQHJWiiU1WGw+OVc5Rme+ghinAQ6Pbm+d2?=
 =?us-ascii?Q?0X5btTMckFljm+QkpFP9Zh9myDGfPKY9E+M9IE8b1hIIrWuKIJYlkv82Ln/I?=
 =?us-ascii?Q?9y8bhN8+gCZTLGr1ATKsnlyw3Gr1TnL5yGWMWrt2RcE9GHerJyg/u6r3VtVl?=
 =?us-ascii?Q?/3cCrzPbG8roggqWazFoH9QDjl9xrK6BuKihmRIe/9btE3n7nehy/5+bhDAl?=
 =?us-ascii?Q?5lrRn8kQIB9CrOmVtFowiBuuDTq9ohn9LTEtPJtc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d57da0-c71e-46b6-57b3-08dbf4daf24d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 15:09:00.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJ9CN7tmalOwHjNn8XN6JLzDKVGTzDbIPRFZ4KMWayJyUcEhQfycK1WDsLKqK9fd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7113

On Sat, Dec 02, 2023 at 05:20:07PM +0800, Yan Zhao wrote:
> @@ -522,6 +522,13 @@ __iommu_copy_struct_from_user_array(void *dst_data,
>   * @domain_alloc_paging: Allocate an iommu_domain that can be used for
>   *                       UNMANAGED, DMA, and DMA_FQ domain types.
>   * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
> + * @domain_alloc_kvm: Allocate an iommu domain with type IOMMU_DOMAIN_KVM.
> + *                    It's called by IOMMUFD and must fully initialize the new
> + *                    domain before return.
> + *                    The @data is of type "const void *" whose format is defined
> + *                    in kvm arch specific header "asm/kvm_exported_tdp.h".
> + *                    Unpon success, domain of type IOMMU_DOMAIN_KVM is returned.
> + *                    Upon failure, ERR_PTR is returned.
>   * @probe_device: Add device to iommu driver handling
>   * @release_device: Remove device from iommu driver handling
>   * @probe_finalize: Do final setup work after the device is added to an IOMMU
> @@ -564,6 +571,8 @@ struct iommu_ops {
>  	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
>  	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
>  						 struct mm_struct *mm);
> +	struct iommu_domain *(*domain_alloc_kvm)(struct device *dev, u32 flags,
> +						 const void *data);

This should pass in some kvm related struct here, it should not be
buried in data

Jason

