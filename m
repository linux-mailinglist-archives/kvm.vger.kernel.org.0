Return-Path: <kvm+bounces-3399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBAE803D01
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07C48B20AC0
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC0C2F871;
	Mon,  4 Dec 2023 18:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zjo9P/G+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362D7CA;
	Mon,  4 Dec 2023 10:29:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OI7C01GIil0K+kPe0HVm8YMl05dWf1cQtBcb5pbD8hWMvhrsHXJlSG7gxjN6ena89uWVovmaJfTAynCO2QwI+fhcBjIYgMbweUUwDHhBx64mFNqx2Kkl0+8/AyzmFiC3qPz0BOJHI2Ce+tQ4Ria3b0morkhtKIUNyA06QIiMxecXBETX+ByXI4MWcaTYwuSW7gj7YFlJudArKnODnFTbEpq3m6TE0NRejyLv1ZAMgnWlU4WAcNgIOP+i3U9Luh0SDbhTplURf6mA7t0U5w66pqcbqW0ILt5bld/gA/RXp7esJCXDR2WXq9lslzoxUAS1EQyvFftRxRv+CMOX6zHiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWoj+9+ONXt07rg4xxiLNstyB8SGeskGu4jfefGtOSU=;
 b=QNuw835XbwRIz/9iF+GFkWwJ6ADlJvkgqWSP/fDC+Cv24HlXj6Nb5cva95veRuu2aYgnpoCIH2yygPN0ZeCOb6GvkrirFuDy+tQet03SaAyz8tOtU/sF6jkKTvxkFB3752F7zgcOdI9ZqglocuhA05+uQgT5BprwAaVuwlwU99v3UjnPIc9Wo63ZC7m+sO2pSE1JRKDMF6tq4BdZjbui5Xg+0Na+fdilRxpTuvNX1cfRPmVySKQnZxqmZls88LRfOKTrIGBl+9IIxyuyiZ3JycxWZoLQdBVwz8DwAj2IzrOZcX9+7iL2uJ50RX690bxthbSrdIJr1Q2Meipq5oYWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWoj+9+ONXt07rg4xxiLNstyB8SGeskGu4jfefGtOSU=;
 b=Zjo9P/G+YcQqWnnZpXdx+hcJKR6WnXKSHfbtqen4ofWuHWYqL4dsVx4DIjLmVGTVyrWFd1plSLwx51orsQppr5jSR0p8tN2SxUQkOOisHr4SXQgXGGIQWgBdWz706N1u8WkrislDTzK1cy6KUeUtJt9p58UZ1l9miPxwPDdbkb2r310dhHl5g1IbFi+pjWu5J5c2qbMmHeid2KusjppdnFipo8Vc51z5R2N0H1zi9r+zBsA47xgx35ZU16NMbSoe0GetRRn1hQ47aBMhk9fRiQ1KcyOm8fEwQD6iiOWpnl8yz/Ev24B0UzdZ0rlslxH7Z1nFkS5lDMlSGdhiuUScCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 18:29:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 18:29:29 +0000
Date: Mon, 4 Dec 2023 14:29:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 12/42] iommufd: Introduce allocation data info and
 flag for KVM managed HWPT
Message-ID: <20231204182928.GL1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092113.14141-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202092113.14141-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 4999aedc-1ad9-4e8b-020d-08dbf4f6f3f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SelSkJW0VkUXtSE94eqj9JfcmjNu8URznZf2xWe2VT3vtxP7YAttKsxtCf/dXG5iFgR/XhlrGudE+RYC3IVcTTjcruYgmxaIV5CT4fzU0AYfC2mMmIDzUOwiKEC+RPLPcdt0oUhrUXmMXalX6JXBw0RdAEKh+RmeRA5FiVB59IK+fCY6PdDs5GfmlbQ1GTiekJH8dX/K1RWCxUnmQD/EHPqfNXie4QdhtuCBlbE890LXaBG48ay9QqCtDJL6UAGkSOCrU/ZAna1RVUPFXMOQyr1ofRdV2HDUEFGTKoM/mhhGtLHvIVPuQVKbdsI+a4n+mcdLoky6eTiXZDl8cwrBlVQKKi+Hp/JnUgsK8VYOiHfeHB4cicomdvzBelbXAYpxu+R5Bwxh2CqI+bN78WmsN5Np3V5tATW8arnUXKMb8TiJPX0Ree2dJEBHY8t93UsMdGaTuKSNshGb3tVOP/WNu/GRBjIsllQ8pONrSVkDAAyagv49Af7XJtuJQ0UNmCQFKheMMXx8SFytFNEgDPyRDxwidb8INmLVJmCdzVz5urJxwCit4yE0bPuikB+8LUWs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(366004)(376002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6916009)(66556008)(8936002)(316002)(66476007)(86362001)(8676002)(4326008)(6486002)(478600001)(66946007)(41300700001)(36756003)(4744005)(2906002)(5660300002)(7416002)(33656002)(26005)(2616005)(1076003)(6506007)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EuvlWEih/bP9HMj4Cm1IzfPcmZVe7E6vnOS12CM0OnAqpNPMcZ3RXnMyqU3K?=
 =?us-ascii?Q?o6ZJJwkEkhQAKTSlW1DJ0cP/jI+5rb9oEYBGYJKInfdI9w2+Q9iF8/vIWZCW?=
 =?us-ascii?Q?8hOgfAe1AU6o/0e9Yr0kkFLmz476L3EPT2qh+urSvWyBECsWpMI/wWI1gStX?=
 =?us-ascii?Q?Kej2unlSbzNZ7nfCP+t8yxOcpv8/kH4LIZM9QRUlvNtYAZACJXcRrCaxs9UR?=
 =?us-ascii?Q?ziUlQGxj8OsjuiAW2BeRfvALIO7dvNtYnF4a5Ju3MLONW+CWYhRvjQ9qOrVY?=
 =?us-ascii?Q?0iYWDL0SwRhe1uAt9qTjezdMZ9N7Aoqa3EcS28WYlE8UyyNn2HtZa1Mj4xxH?=
 =?us-ascii?Q?DPvNABJZRoYmrvcOG3L+o8+afPVuYO2AxiYtfbjl3MOtafpDg15QjWyCbBiK?=
 =?us-ascii?Q?T5u+tmPKT9zcVZAlm6qAjrqDfttT0OnQqC5UhU9r3VmV9/B/fkDPMH2up2pw?=
 =?us-ascii?Q?MeDK+eweQivPYjDDDA8DuEUE6q6m0PT3HyJx/QyDunDRjsw/90adFUA6wJ7F?=
 =?us-ascii?Q?oymH7PpqARw+JoaTund7mKqFhONYotHD76CaI9jIV4GdLBbGGN0wtZX2sgCr?=
 =?us-ascii?Q?RH68U8i90QmMcZpOhHhfQjPPhIdTCQn6AiVOcHNH7pqC1F5JaPGRAShrEVZk?=
 =?us-ascii?Q?V2Vi/Kkc/z43vfLmWlnnO3z6xF16+HbRnQnCBT6b+OOq0pZLn7cC0mdCqAjD?=
 =?us-ascii?Q?D6K5t3MYkkLjFOzTpaFcLYO63YkXUTLpu9BEJgCT5x0WU6bSDahtduTdIEhD?=
 =?us-ascii?Q?pNPIVj+TVIHNzN+b10aX/LwzzCx9nPTsSqvLvJnBWQLhOt2WxLLI74YbHGrs?=
 =?us-ascii?Q?2EW1OBuJUHm/OXFNk4Tnv1sZZyRtYkBNC51fNkhLS/7sWw0+8W8n+BOlTCg0?=
 =?us-ascii?Q?Wly9F+5S77BSEN9R47xLPW2BeMbYiArsT43jYnTDpIZl3m5HOlnTU5k5TYoQ?=
 =?us-ascii?Q?8rw7W3rCD1WInCoixeO3/rCiDuSgY0bhNpB8RLdhdcw0uejA0+M+xBzEBDG2?=
 =?us-ascii?Q?WvF7Vkzlqt/qZiF0pivZmzzSZGlQGGf762/Fs3TpHKsb2Ef7jWy0oXLWg2ME?=
 =?us-ascii?Q?9acR+guIwXQCNby8Qarsa+lFtGZJ5uVdfcBgSQ2gofuqbBs8L0B+Hg/v8Wpy?=
 =?us-ascii?Q?srt6yuIcZqNJzsXK/TgQoYwrDsApPNnjOAR0DecR6cezJmCgmOfjkGrodyLY?=
 =?us-ascii?Q?fAhcE1yPXZWZ9axgTio0UcblKK9Wq2mhjmC6YF4hodMBUlH4O7EWo5Iijsv1?=
 =?us-ascii?Q?Ilymy4a11/7lGencvvI5OcoARFAWjiiAxD34j5JAu2YcsufXYpxTPDEhk2He?=
 =?us-ascii?Q?dwZuZFP3qePvwLb0vDt7vfMtlRWn+w4tkJ4N+jlK+rrT4fty11g5PhbTtFpx?=
 =?us-ascii?Q?Qazfb3nw2mnmXAYXRrYAtLMRjjGvsVUcxuLIH1UBax4wG5MOINAyLUYHgYK6?=
 =?us-ascii?Q?rAgmJeJKKbYHfkZLbLIIO2MFEAoMXTD7QDSCA7fYzQUg1qaLDO+QzhhtNa5F?=
 =?us-ascii?Q?AOy3w/0djkzOGRHXT3aKtl29XLHTnjNGMdO0yWsqta5kPYsMXb1TCpA4nPTL?=
 =?us-ascii?Q?9ho8oUO5YfttHIGriobJ56OFSQuiYTlg0DpPtSP0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4999aedc-1ad9-4e8b-020d-08dbf4f6f3f8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 18:29:29.6392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4f0TNdN/QT4tOOho5IQfwBIkemQRAKuU0cB/oyWX5iXq9EtHvTE5rFSn10Qg1hdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489

On Sat, Dec 02, 2023 at 05:21:13PM +0800, Yan Zhao wrote:

> @@ -413,11 +422,13 @@ struct iommu_hwpt_arm_smmuv3 {
>   * @IOMMU_HWPT_DATA_NONE: no data
>   * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
>   * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
> + * @IOMMU_HWPT_DATA_KVM: KVM managed stage-2 page table
>   */
>  enum iommu_hwpt_data_type {
>  	IOMMU_HWPT_DATA_NONE,
>  	IOMMU_HWPT_DATA_VTD_S1,
>  	IOMMU_HWPT_DATA_ARM_SMMUV3,
> +	IOMMU_HWPT_DATA_KVM,
>  };

Definately no, the HWPT_DATA is for the *driver* - it should not be
"kvm".

Add the kvm fd to the main structure

Jason

