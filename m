Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B497CE1AC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjJRPuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbjJRPuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:50:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0A8118
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HY/XceWjyEpxL1lYkPq40SVnEGq7btXwDM07uQSrgtpShNiYtZb8a7CTrfPkdWVwNoHFCiEbuFpNtmof0i55Wf4xvc2ngcGT0Now3Qe79j9akhgZCo5wN9ofCwV/BdWGS3h3ltDTVskMrMArYvIEisYonOJs5+/sgDbEnHcCx8TghLO90CCsepUEmZErANAL5AkaNFHwZIU1x+6w6q11wLn+77AoJ3WWXCL87i2hXcBQeKP9fy8PZitJ/btkQCI1SiXpwvgRIemomQd8ABAY6RnxYsxkR0UKxMhfC8pXPl3BL2aPSxiP1bIBrHWgQ8+sj4VcBktzT84gDZEVHjFH/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQvXDqSggifB/QfTZe5ZzikIfKGQLhjMNziTRJQPYEM=;
 b=c8e+vt9S+dLr8ZWWvRqdYRLXV/MlvQ1U20kKXdfA0mcS+T0wfaocJtZgjFep5qPSdfdh+4WljOCOZ6gUmxSRFjRLlL87atGPk46ViLZlbVQawLW1RVlYLkgJ5bFjcGlBYKEUi2IeYyKtFWsHLB4RHddkWpKtwuJgIM4NL/CL+0CkitVAiinVWodmbnhhgTI28a9yCiAyewCTK2ZWwFPeQuSssLp/JvMZSdd03TDQRchmTgIasp+3lSKDmcrRDwSyu2xbSlHMEV8T7IS0xrckcw0fvH0DYn4rQ6OcP3WLH42gvIVWvhoPuvIvqvTLhambnF8PjWxa+YzC+5tKzg/0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQvXDqSggifB/QfTZe5ZzikIfKGQLhjMNziTRJQPYEM=;
 b=aKklFF5ds4D59ClYIyIG+gLcNHbuxxd9tnkjSS5IsqT3Hj0/JpZbdL1CVzeUNvAxO7ReTz/it9TJpYEl47fqmkyXdukyrS1kCXv/Fxr5Hza5EgHoHDsf6IzHs44/szv9qQ0EuPb6yDTs47n0v51G8I7YL96Af6al+9NRk3vFBZBftH4sR1rc/K/uIFIeq8mOijIJbFM/uJtnl3KRvxgO8l4qrvCLPeDcLJEI085II3xO4jMAWsdou7cyrrwyedfUE0qy/y8ERXBRHHtgkARH8iqxp1n+QieIp5Yg+Wp3RHTxCYndzLQbb0g9kSv5QlRrD5KAR2dG90ugHrwBYeuxXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 15:50:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 15:50:15 +0000
Date:   Wed, 18 Oct 2023 12:50:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Message-ID: <20231018155012.GX3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: ea68d12a-62c6-4256-f874-08dbcff1eb97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSbT/MlbV35cp1qbSQ+ER8MxCRs15sdIGI2EH4bI/HNqw8pVYQ108ZjBJvHtouoGOwtdOgm1E5T4z1IrBN5cRNzFTYd82xYOim8Xwxk/S6o6ExIQun6QwNaMl09okcB7L66A3rY25DyLsys34Gzuk2APWCcK4bUyIAztBY9B5e6o4caibRqVI3zbH9aqrn0VsCbZrYQ+xQW2YEShiZUP4ZTtO0rSxdiZbBiIOW7xaA3Uo32ZrDPZc+KbEPuPAtifAZp6433BC1Sr8KCqIIExIOhkP4V++15/299F1dtsxovyPv/LtvZwlWavV8nRjh8RRTPusIoctLhZbBxwqWFXY/vsXCn68MmLKIcqxPbVmmMreJ7eBJ3HrM0y5VuGWrzZ2x4zc/eac0MDs8DMK1UrwHB4Rsxksl13Cyny8hUK1QStaBaAKjK+dx0B4QUFQBOJr0BnenpVB+7/l3vZodQOoU51tXpfi0c4UjSz264zxMK0Gt4q2u0GB2eD1cX7zHXGJ/gssuOrijmPC/T1BUyIHYwIqHxOwnAiPgV/CZkRu8wsuMxYogKQiwTx0I0+VgHN/DEdviShu1dZwxmF77gyLf2eX4+Q9l+WAMTj4uak/HA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(136003)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(36756003)(33656002)(7416002)(5660300002)(2906002)(86362001)(6666004)(2616005)(6506007)(6512007)(38100700002)(6486002)(478600001)(1076003)(26005)(41300700001)(66946007)(4326008)(8676002)(8936002)(66476007)(316002)(66556008)(54906003)(6916009)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+HFv+bNIQQGOCGAaiJD9BgVqyphewE+Wv80pEN2ozvFu9se4uFC4/q89Butm?=
 =?us-ascii?Q?EhuvpI/WeIbnirhId3uh1k4r3ZJp+UKOdGYXxRB9xeeL7+GDuvV0kSGPnU+I?=
 =?us-ascii?Q?Os+aFj360qO0WcCHWLgcGEacv4G8GDM4iGPtBPCiHnhFfhIlVrZ/FXHfQum4?=
 =?us-ascii?Q?95tLUPheEYz7T+gB80SjRcPuYidzfPudSTruQJo4Mat/IKaIMDJrKvjCswWv?=
 =?us-ascii?Q?lJsn9/qZhQUNewPYlxeyk1cEVJS+YpYhG8KsmAdnZ6tbrHuhV6dxXdAfeJKl?=
 =?us-ascii?Q?I5hR6pdfFhX+sxlvJx81BMflH49+Del2s2E7MwFXznIe61rJtJCB3FZhFMAP?=
 =?us-ascii?Q?ipzg8wlG+L2SXZD7JgyCQBtptzdhC67F3jJA9TXbdwoCVAFtma3U01E4FQmH?=
 =?us-ascii?Q?9X/eVEhtyzaP8XuxXy9yQtjJnlou2MxlsDN84y3r53nJjV9mUWGXWYrbWtm2?=
 =?us-ascii?Q?RaMo6EXXIRnVzrg/Wq33kYI8PTpzOQJOqhKGiLPJ942EGiuXaXnnFUZI5Dsr?=
 =?us-ascii?Q?VsuSoUKkcrqi02bqtsK1ZYmx38R29HXNAMLNwHwqfVJMT5kbhcxJFm4GD7nV?=
 =?us-ascii?Q?4alHZBXnQ80+8wXmwPpKw8Oq8XltakARBBXk1RPcrRtxrEum+Q0LBtxN3J27?=
 =?us-ascii?Q?kSFlX+aPMPB420faJNofj+VHkk4Qrs+mPMlc2WJ/aezc1M8QVmeFAnkrXuf0?=
 =?us-ascii?Q?ekn3VOpI1G9WFitOKNGprYgQHgU/NHyH/vI9m043j/kqqSizwdKawweDUfSW?=
 =?us-ascii?Q?KjCTQFdtv8qG4wOADhzhl05M4mrrSaLfnvDFKpQ/l2eBqGxLA1iEs0ycaUlU?=
 =?us-ascii?Q?7xDSY4ljyd6v/e25leIrfbv8C6ssoS/elPc30+6m7bkPsey4055HpIPIgVGd?=
 =?us-ascii?Q?6W0CZiGG/a61ABGhskQdt4FLrOgV54SXDgm0J5Pl67gy1nUHOc1qrftoCW9t?=
 =?us-ascii?Q?IBrMyp3PkXhWOQZeF4VmrgRimm80nhMtBqMO8AUOmBApYWCIefNkHoUYsso3?=
 =?us-ascii?Q?XKB30eIiHGJGXjtCXPwVwUjfCgtG9i/J6NxTinM2cyrWzoIdmmLkhlpmFDhW?=
 =?us-ascii?Q?Dm0IkwVkplU1LJ8IHbTgSezcaPj7kLg/TU+cczcOQBkTTiFSDaBcFHNpfqlq?=
 =?us-ascii?Q?sjRnzNrDXC9k3l89r8iXgVsLvrnaqsfoxumX0N9NjwxKlfN4RFa4iKaf8aEM?=
 =?us-ascii?Q?ooxAidbrm2vWwGPE/Mt9dOKOeNptU8xpA+bIxP7TA0Teops4Rre3oU07d0gz?=
 =?us-ascii?Q?7ggPhgpaM5zHbs72DhZaJwXpQtPq4jEOHwinLS74DuhweprmXxe5Mig0O0IW?=
 =?us-ascii?Q?5bi0NvURh6Mf9IvgnaBqyxbH8lNcmhNpB/yVWMYPz466nddfRS8K3Bw7q3/v?=
 =?us-ascii?Q?TvZQq1uUfzHBjkUiMJIXmwWJwpeY9VkCECNklyHtIIWh6wEau75GFruHzFqa?=
 =?us-ascii?Q?nxUrMgQvcrrG0fHuBNXpvwAuOdG/cZ+ozOmwrgSg9PZpfMAIx7d/iBOOGtys?=
 =?us-ascii?Q?YqzabuwxUg/XmUoSLay4H5go9T+mq2kdsBP4ygVP6S1V88207Qn0qNER/J6C?=
 =?us-ascii?Q?Jafl9ebHK/zQ36H7i8x5TOmqNppPZol3a4KSZc7V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea68d12a-62c6-4256-f874-08dbcff1eb97
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 15:50:15.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bdiw/abvQH/3nyhSTZCf8ZxqAdGd3UexcmO8Qi1QC6OvfN5gdc2dCXrbtVsw49yH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 08:04:07PM +0700, Suthikulpanit, Suravee wrote:

> > It appears that the check_feature() is logically equivalent to
> > check_feature_on_all_iommus(); where this check is per-device/per-iommu check to
> > support potentially nature of different IOMMUs with different features. Being
> > per-IOMMU would allow you to have firmware to not advertise certain IOMMU
> > features on some devices while still supporting for others. I understand this is
> > not a thing in x86, but the UAPI supports it. Having said that, you still want
> > me to switch to check_feature() ?
> 
> So far, AMD does not have system w/ multiple IOMMUs, which have different
> EFR/EFR2. However, the AMD IOMMU spec does not enforce EFR/EFR2 of all IOMMU
> instances to be the same. There are certain features, which require
> consistent support across all IOMMUs. That's why we introduced the
> system-wide amd_iommu_efr / amd_iommu_efr2 to simpify feature checking logic
> in the driver.

I've argued this seems like a shortcut. The general design of the
iommu subsystem has everything be per-iommu and the only cross
instance sharing should be with the domain.

I understood AMD had some global things where it needed to interact
with the other arch code that had to be global.

However, at least for domain centric features this is how things
should be coded in drivers - store the data in the domain and reject
attach to incompatible iommus. Try to minimize the use of globals.

> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain
> *dom,
>  		return 0;
> 
>  	dev_data->defer_attach = false;
> +	if (dom->dirty_ops && iommu &&
> +	    !(iommu->features & FEATURE_HDSUP))
> +		return -EINVAL;
> 
> which means dev_A and dev_B cannot be in the same VFIO domain.

Which is correct, the HW cannot support dirty tracking.

The VMM world can handle this, it knows that the domain is
incompatible so it can choose to use another way to do dirty tracking
and associate a non-dirty tracking domain to this device. Or decide to
give up.

Other platforms will require this code anyhow as they don't have the
guarentee of uniformity.

Jason
