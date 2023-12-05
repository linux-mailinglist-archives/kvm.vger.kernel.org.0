Return-Path: <kvm+bounces-3609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B9D805ADA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 990DC1F21AA7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AD9692A6;
	Tue,  5 Dec 2023 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GTcSSQQA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E990188;
	Tue,  5 Dec 2023 09:10:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnw5QojfcIfX4R7raAEQ8Lfsd7Uw/rGOtBnq6KDR+ug00vgDXTCmt9ZEID5w1Sat2OB6xDZt3gKKFLiOcgxZPqEyqapmYTyj8srY4pbIas8WJowgrej0HnYIT1wTCKqhwqih6vbDVBe+XRiByM9TvJlM8AYFrfojtg8MVvwLBBc6hlfcdbgyKV4uhoD1htbdAx6qvukuqYJ6ZzTzXiVbpk3Ps1JxrOjikf072jRXxb0co1xq9RPyq/Ku4ygpW3iCeSSLcxMJr/EfzjEZpAk3J1eoIXbB/HYjI6nYH5VL4YC9JoyHNn5gNQTVngjcIQ+flCfXS+1KhuGe+Ndu4Nkx6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fYrkYfgqtrOKkcqLWqn2HuGT0/MXKBkZ5OhKdmWV+Y=;
 b=UO557Bm3Xj/Gbg537GUZvjF5d4gDGSLp4Vck5CG6xLhg5yFWqEZEh8Jslq/vp0ntKCxa89UzMRIpbRlq3VGmyPyb6impVXAXyU5EzJChaImoF3p2ErEUv7VBRreHxyjroyogLIIATN8Pm/4l7JhpC/1qTOTgYVeZ82WmLA3HpqRGWcQxw+QlNxwsguVbskeuiANwP2WcTNmQaFbhLlZ0rgvhiMTUd9DiIdc9LeNdAmZKDm/YktKosdd5R94hZntCotMDvlnBUU+xoNugbe0LG1RIwyx3lagr+CZJDLGM+pjGaLJPdN2mZ3KuLqOUwhaDn72VhGbA62tf2e1KcMlDzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fYrkYfgqtrOKkcqLWqn2HuGT0/MXKBkZ5OhKdmWV+Y=;
 b=GTcSSQQAkbmcEr47x2a+9/v1c4gTAfwUiDEUADTdweAQxDkYiTBoaTja1vrgPaA8xcSKppGII6gYriD9OUWnB2TeaEbpgKHn14mNZQ6fTS6xXbOGrahY3+kdUMiPn0hqMfYHr8TJTAUzO3gVB5wlZqVoICS9ii7zLLM4cRxiycWPZbLO4fQXJ6R8fAn0ICUx88twXb0qMjieRllKFkCfOWCRoy+qQf0Yfner6/6Hs1IkFTt7OnLrRHMwWk2ATWriEGmOYSuLxi47BfotqU0kQCztRw16BShQrIC9dUeiWd4w+YfM03m1pCpf+nk2pjrBtIe7pQiMQ/mhll2VX2YeBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7286.namprd12.prod.outlook.com (2603:10b6:303:22f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:10:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 17:10:25 +0000
Date: Tue, 5 Dec 2023 13:10:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231205171024.GH2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW81mT4WqKqtLnid@lpieralisi>
 <20231205144417.GE2692119@nvidia.com>
 <ZW9OtrUa_fPA0_Ns@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW9OtrUa_fPA0_Ns@arm.com>
X-ClientProxiedBy: BL1PR13CA0322.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: 7596ba29-f654-4a3c-c878-08dbf5b512ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ms+yVcO1EgWF0pDZbPUiTiZfojhwuI5jSF255qUvL42Tqe5EWNzHhm1uYztZ+24oC5fCkYbX2B3U0eiFMJxPrEgCSPkLFzbEB6A+VQ3rJI54VqogkzGzBPtST3qB3UsYbAEUhLjffqzSnDuLBYljvgZDdRQ8nKkb/hMAPYBlRodz3GxsDv15kJ4nqQCOP0K9R6PdctD/7YzDk6PbWW/nqtwcVg1BhWaBtMe0zaN4L5y4hFSU4rYemwlI+nAn8dXy3Md/0eTQwfPUER6vz7QRtn++gl6+Xws66VShlm5GWj6bey76thCA0OsWSQ5GtUJhks+RkXfCL7casmFHpaVtTVZhmFKazbFrPOGGqiGCE9XMe7tKs+EmjwaAbD3ag8veybT9cDHjcBSvPGBfNpMhG95ulXQIBQ14F3N2mkCHCyi08aSbaeDmhIAshoW5/WYf2ScmuC/osEN5JMppnZ8446g8rf0ADvskYa7Z1SYVIUnz8r6G8kvK/YsRGtKhBsG2aTLyB8gyMl+TbaonfMnmnhjFKAVJludp/aswHLujGTWo6QVbmvGcVU10AVbu7n3v4JWrNSewPzQDX/Qv3ZgynTLR4q3wwsqPRY6oAbb48jA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(346002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(2906002)(5660300002)(7416002)(36756003)(33656002)(86362001)(41300700001)(6506007)(478600001)(966005)(6486002)(6512007)(38100700002)(83380400001)(26005)(1076003)(2616005)(8676002)(4326008)(6916009)(8936002)(66946007)(66556008)(66476007)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jzd4bGJuGshU8IvY0HrtoljGc2QoebCTiDfkcHofytqPkuRv8ZqwJ+WmtEzU?=
 =?us-ascii?Q?iB4znFA/Px1WGCVrWUgMvoZthWWCn9A40PYN9PAERDL+jKQX/huJkXJtgEdW?=
 =?us-ascii?Q?jDKGq6cJDQKMg05WWl5wRNhvWE7c+vocG1LxQam3tpYTbNWyLt9pPMHk1Rw6?=
 =?us-ascii?Q?FMYFsLZqr3IOVKVLHJpVWRhnVM3hLX1hmLB9Id4gZRSheScN6LOFL7htcjRv?=
 =?us-ascii?Q?sYSlT4pwWjSuYVzsuk0FZ9zpKI11QnyvMwslf7+PNxAJ9MyAisjlG+NLY3XQ?=
 =?us-ascii?Q?n5xvFLDA+ydEPbmdtWR61OrQLJgYSjRgM66L333bV3NBg++7gjtxqRukfiNm?=
 =?us-ascii?Q?DN1dnPiXOe2/n1hteUoFyJWEnoCVUHA3AKnH21bmQchTlkxKZ2p/MP1AFLWj?=
 =?us-ascii?Q?0NOBlRNDf156tRJvQ9PB3dt9JiHsbr+5Ev0Guv2T/+Vpx8ep+Q6SlQH6dObL?=
 =?us-ascii?Q?/hzeCg1eFDb8N5FLcmj4b91FR59T53vXyQqdvAQwJqnQr+iH/GKoQUMei4cf?=
 =?us-ascii?Q?YQNivYAFF3h1dV+Gpkh8IQNHuNy1dQiuebIqYwydwB1puP/OX4Dk26xTHlwN?=
 =?us-ascii?Q?hkww+JJLgVSdXFadtVYh9QhAvT/z7xYPbm750eAOJ3U6K0l+j3LBkUE+ierD?=
 =?us-ascii?Q?2sDsiW91IziUKq3hE5i0reLney5q6rYTcC15Vbl6K1KtIluz5SgZ2AvOF3hm?=
 =?us-ascii?Q?UnbnFCkPiQfLgolg77V/oa2P0tL2luvnqe6wnewQUY/UY6kof1EpHoY1KOk2?=
 =?us-ascii?Q?BfVnvc3s7teuxxpoFS00CCiMnbE0PidB4mc2uDPK7Mcec7mOwT7d4FwOJhYT?=
 =?us-ascii?Q?cnRwxPMcpT2zJkR04PpCH+mseOfrbdTz636gh+fLH367Z8S2j914e4mrMvDI?=
 =?us-ascii?Q?maIaXH33A7rXZCR5xqx4Iqbc5i2lbSRMvWjHxsSYpAgaeJOXjWgWRpi1MJWv?=
 =?us-ascii?Q?braRTPkUDx4ehJBsH6uVu0l2w6Wj10Ds0BQzri/GR7HGE7uOzbJp33seqvzE?=
 =?us-ascii?Q?3YWOktNF1ApOQkb0KNdFb80l4nMVEI0wqnRg13i9eGCPnBpQKdZZrc2J9uBV?=
 =?us-ascii?Q?3EtdKVNVSVCyGAMDRd1dZXt/EpT9Nn0CY9tc3ZVZpVS/eWUUJFjwPPEARp9D?=
 =?us-ascii?Q?T1riRI2wn+lCUBeepVvw9fJ1ywQk8i9+jR1Bb1DkD6lQNJCdj9gLIsDoI0Sn?=
 =?us-ascii?Q?j/TS+Aks3OKUxpjYuybuMufKT21ruUz2Pg+K7ov/WzJd6HDahSfp5xtyLZx2?=
 =?us-ascii?Q?IePoks+f2fA7mNPyCC/AmZwA81P1dQCwAVuEZMAIJOKjLgdDsuwuBWnAeFG1?=
 =?us-ascii?Q?cWNyj2mf1NfTCZm7CNGzh0AK2xNV5jn0U/YnzUpHA9smX95b7vvtztFOe+xW?=
 =?us-ascii?Q?luVDWVru5GHNXygX6nTR50HSOCer0OTL2Q2q6LV2T1Di1mMBvhwB5s76UASJ?=
 =?us-ascii?Q?E/82bhRHRIcATbxk01U4HS9Di33jFK6RKVGEiEWntaeQKq6LBojuAoGJeu2f?=
 =?us-ascii?Q?jiAbwuCAIuN2NuMEQaL1gVMMtABvzs6Cuar3Vgvl9jTzdpHHvQEv1LIbyRtO?=
 =?us-ascii?Q?6mkBJf0UEyQmG4iz4vFI3B0DJbxWXSF3XdU0MnzM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7596ba29-f654-4a3c-c878-08dbf5b512ba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:10:25.6759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdCBCxa6RbQfuECbb+OYKgRHc1im79+jH/Ogn3KaGF4+YHRfc9EUSzO91koZq8QO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7286

On Tue, Dec 05, 2023 at 04:24:22PM +0000, Catalin Marinas wrote:
> On Tue, Dec 05, 2023 at 10:44:17AM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 05, 2023 at 03:37:13PM +0100, Lorenzo Pieralisi wrote:
> > > On Tue, Dec 05, 2023 at 09:05:17AM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > > > > > - Will had unanswered questions in another part of the thread:
> > > > > > 
> > > > > >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > > > > > 
> > > > > >   Can someone please help concluding it?
> > > > > 
> > > > > Is this about reclaiming the device? I think we concluded that we can't
> > > > > generalise this beyond PCIe, though not sure there was any formal
> > > > > statement to that thread. The other point Will had was around stating
> > > > > in the commit message why we only relax this to Normal NC. I haven't
> > > > > checked the commit message yet, it needs careful reading ;).
> > > > 
> > > > Not quite, we said reclaiming is VFIO's problem and if VFIO can't
> > > > reliably reclaim a device it shouldn't create it in the first place.
> > > 
> > > I think that as far as device reclaiming was concerned the question
> > > posed was related to memory attributes of transactions for guest
> > > mappings and the related grouping/ordering with device reset MMIO
> > > transactions - it was not (or wasn't only) about error containment.
> > 
> > Yes. It is VFIO that issues the reset, it is VFIO that must provide
> > the ordering under the assumption that NORMAL_NC was used.
> 
> And does it? Because VFIO so far only assumes Device-nGnRnE. Do we need
> to address this first before attempting to change KVM? Sorry, just
> questions, trying to clear the roadblocks.

There is no way to know. It is SOC specific what would be needed.

Could people have implemented their platform devices with a multi-path
bus architecture for the reset? Yes, definately. In fact, I've built
things like that. Low speed stuff like reset gets its own low speed
bus.

If that was done will NORMAL_NC vs DEVICE_nGnRnE make a difference?
I'm not sure. It depends a lot on how the SOC was designed and how
transactions flow on the high speed side. Posting writes, like PCIe
does, would destroy any practical ordering difference between the two
memory types. If the writes are not posted then the barriers in the
TLBI sequence should order it.

Fortunately, if some SOC has this issue we know how to solve it - you
must do flushing reads on all the multi-path interconnect segments to
serialize everything around the reset.

Regardless, getting this wrong is not a functional issue, it causes a
subtle time sensitive security race with VFIO close() that would be
hard to actually hit, and would already require privilege to open a
VFIO device to exploit. IOW, we don't care.

Jason

