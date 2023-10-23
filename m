Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435D07D3A23
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjJWO56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbjJWOoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:44:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B53213A;
        Mon, 23 Oct 2023 07:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR2krGR1g1GqFn4YnmyN+xs67Fk7UiGIJORrOP0IBu0Fux7r62fOyA4l2p3nx7+MVLowIL+il/lHEtL5jf4SGFg/gTpTGWtuggwW6vxiXtyZYgbctIzKl3aXpnLqMqIL9Nsmp+iVlZlSXsnZQLZ0CyxcGupa3bFhAnEe0EumkQ/PfaJY/CJEobPmqXzFiY8s7jVYOak8G3THHB4kZUj3lfDsy1CQUNROgJR0zwD1zXUlLa7/L8dN5HjaXBI0+2OEzN4+uqv+Moy0y2rWFv+/ebv5llLVAIO17gD4ciLsV3eE3RgoTOGjekX+tnUr9nXDMdxniWZ2mIej1ABp8RPyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxF8MfUgF+T+TpQxzNFAqTfAwK0J3gwFZmFwsN2i0H0=;
 b=jJUwC02Q0/sibHORI+Cu1VcAjTRGEBkGDQjkoLK0g4pVsKBoEnrQs07sTmeWAIHHYmaOMjLr/Cgh4vG1lg9hIsJbliASPE/q1yoRHY6OGe3lcWH6uwx4ApcnxFCVtZoaMQsymLLRW20jwPBymJEqVnyL2OKb+gZX420y09fwtdblqYvC8wkwMdcvmG1uLvpgv4ECj7ZKlHg0dxrURnBye1hUO3eBq7l6H37OcWLqyzzUxt2YwiySQzpI0al5kdX4U5VHUPTlytxFJLZRQN06WkTQNpjiriQYmBPxUtfjmlrdN9Tiam07UGdGaoZqOXgGcindprC0zMusEmRscfSEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxF8MfUgF+T+TpQxzNFAqTfAwK0J3gwFZmFwsN2i0H0=;
 b=g6kq/m1g9Lfho+OTcTBR7Z3YqJY6LpphaahMcb8cmOs6uhK4Le8zunFwHU77UKdEbz0XDqqs/DSCUPNwm/4Vk5eUXFOd4ieJhedJwgd/9UBQzmxhxQjq89L22I5jz7CCK2Z1v+QJg9+ythAjhWU7zFbQp5aijX6R08O2Uz5g6KyFIl4ZUUQ6R+ACuPqy1Lw4AJg3hiU1BeF8eAZG34DvVCRUmHG4LsSltasITiasidFB7aajnct8dmW4wCINkCHw43ZPWMeFITOheQLFPYfqvU03AcEKIw0yTttCZFSEhYahjZKLXjTg24yeH5cfksJd/mypu9erloILaMd0y6UGPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7409.namprd12.prod.outlook.com (2603:10b6:806:29c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Mon, 23 Oct
 2023 14:43:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 14:43:24 +0000
Date:   Mon, 23 Oct 2023 11:43:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        oushixiong <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Message-ID: <20231023144322.GY3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
 <20231023132305.GT3952@nvidia.com>
 <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
 <20231023141955.GX3952@nvidia.com>
 <35d65efa-e87b-4cc5-9c1a-e95dd6bf8edb@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d65efa-e87b-4cc5-9c1a-e95dd6bf8edb@app.fastmail.com>
X-ClientProxiedBy: DS7PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:8:57::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b8168da-135c-421f-7517-08dbd3d6691b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykEx0SlNXuNlliWR2Qc8XFPvZlt5pv3I2nWUy/mqZ1j3tNiaDrHrnj9NTMGOywybVLEJ14vx3fbCCgCClavwRDfUqc//7W71H2ASrdvvEThVgyuPuymO8vNS5og1+d4X2N7r7AyLbg4T5ZjPhTdIpkhg2evdsGUKP12Ut0vHx7KWyEycLxSvtuG8a5d+4NKW1l0nPtJHI8AsL/wuNTYYkTS9h1t1pr6eHsI+uItHoJEB+Wb2f4WUuEmLAgMKxkPUuItzNsSWxVWYgm9vU/NX1/d0zGIiNSK2HtMwC7Gy1hOO8RuNdVZGQmLMm2i/0Kwq9NDSU4o5krCWY1qUJMvzEt7KPTEuLpoSWlmChQi8LrAWWP6KBpmcDrbw+iux9v9w9NyUr54T43NRIH/5487Azg4FsEZ4eU5zT3JQ1c38MytcRumLEycATwY8l2ALlhRlkcf5gVkz2dxqxoAOGMt4uVivlD/EMxDgiWVEZnc0Svf/iBS1ETI/bfUmdf9UrfjzuhtRzSgdXzLM6TYA7CZ6KoUb/+VWUD13zVGM88YlqSNdyooeHAXi4V+Oq2UYCSJg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(136003)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(38100700002)(7416002)(4326008)(36756003)(86362001)(26005)(6506007)(6512007)(2906002)(1076003)(41300700001)(2616005)(8936002)(33656002)(5660300002)(6486002)(8676002)(66476007)(478600001)(316002)(54906003)(66556008)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ljIPR9ppvEipJk8q5A288qRlU9gFm9eZTcRGjtd4LY6YHVOEMUYjci0jhOcQ?=
 =?us-ascii?Q?WuVaoVxb0aMugQz36aol+GHFoc2ookSdfQpxbPu3IZAV79yERKnlOfNIhoLL?=
 =?us-ascii?Q?Xsd/9kFDiktSEdjS91lBFCFXVfMPaoB8Yy1acp/JzJiii/ciaJEoUJ7rP2/I?=
 =?us-ascii?Q?THh9JL1Gzzau/4FeXeImLMryvITQeDljGGTc0PSvTbPGty3TQ90wf0KQT5r3?=
 =?us-ascii?Q?451v6G+TM/b8S0B+1WQd2LVrHh+GsGdXXGprjMZ+3Ndyxdc4bwJaS40LRUhN?=
 =?us-ascii?Q?YNgHo1YIfk4TPQAg8YqEHpIbfG7sbL8hJB87OV//E7d5XX9RBVn9B7AzKzFE?=
 =?us-ascii?Q?/ncuaxdFc4vccHIJqh+ZY+5hcAfw/smQMvWv3SgvRnJjnXDrlRdlKv0Jr1rg?=
 =?us-ascii?Q?3ojcrjgO3ZrbnnwktDunhzOvPU3mwnS8e9bOYm02iTHgeW2pYPivZM8PqIRe?=
 =?us-ascii?Q?eARaFSfhGpHc6p7Ox2eFD96JaLa9DBTGNKq4vHJxKCwVLZWWjiQH1p0gz3V4?=
 =?us-ascii?Q?9DyjNbrXWw22xKJWKBXtRdNyAQl9wpFqu5k1QE4IdTRuNwNlsdIOxgLwJCtN?=
 =?us-ascii?Q?xjVFx/7ZAIP5irpO2Q6uasaS9jiv1Nh4vcYD18SvZvucZtF1q/eqQDK7nECm?=
 =?us-ascii?Q?WEMNGTw71nuxUPqNkcj4pqIYghvl3uwVT2n0Xs2LZMkHLoTJdpXALC08gue5?=
 =?us-ascii?Q?5igmZBYvVi/la6HoR62DOnh8/wq/F71SnOoCftWh/UY3xMjBSwsFiKhY+k9F?=
 =?us-ascii?Q?pVOBibSuMcWd7uPObZvCMG+FuUJudqnz1bxRIHRDFDX9H6h4APJ8HC143FjF?=
 =?us-ascii?Q?Nf+IFr48rT4XNumhZ9rIcXdQciosbPBxBqHj5MYY1aEAp34N0kMvF7hyAPUQ?=
 =?us-ascii?Q?dpLx/vsFw/gh0MmCep9r+x5PL0P2IrIoSwH5OvAu+ZqySOZOH1JReljS3aNc?=
 =?us-ascii?Q?WfFZYUpk7IYDadmwHIVPj42powrtskrbkvf/3WOilMn48wqdjifwpJwrj175?=
 =?us-ascii?Q?JHzd/zNnGNxzrxYOZGjqxvItGRrsV0t8KD6R1Uid5i2pnLuL7nkSVywvfwh8?=
 =?us-ascii?Q?vCcDQbY+JQO7GU83/SZHGXeG8UEeb1Q6LzKi7IYF6+Za2Muwi32lKOGdFb9Q?=
 =?us-ascii?Q?9dIBJmk5Xi8UsgoqbEhHVlRLV/5fFv2K8UPyv//erir2MCFvOvYw4noQwnBy?=
 =?us-ascii?Q?zJl28ssYR/vn2IjvmHMflyIVhGEenHrzd9p655AvGqlflX4wdPlcaFG3eH67?=
 =?us-ascii?Q?h5VP13GBug1bRRdga2+lfJVzPNZKD+KdcWGEi3wHmEKn8wBFuUh70DShRtXQ?=
 =?us-ascii?Q?RZpdGIP6s38ifa3sUfZIVdAy+6sN+RmzauSYZMLYung5wPBLjYC0otjNSw34?=
 =?us-ascii?Q?/XsPHttyUFbWjO2xmGshCkXMZHnqcjWnS4GjdoxyL7DwSqj8WpjIXQ17CqKd?=
 =?us-ascii?Q?IgX6+no+FW3E3nL20C5vJFOba6tCkAJxUIB6OPrsKF4Znu0PLk1vr41WX4UU?=
 =?us-ascii?Q?nIOriYaha6iY9guZtd+viQY432apJ3wkcemIuiEdUkKBRYXLNbor6KC4Nz6x?=
 =?us-ascii?Q?XhoXxoUjQCPM8cM9xmh/zP/pEc4Nj87ZJXmCea2o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8168da-135c-421f-7517-08dbd3d6691b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 14:43:24.4273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLC+pI8A1X/mhEOVJw8A2Bt+0UL2Vn3T598g56y5T+3Bt6JS6N2IqODIMJu+f106
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7409
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 04:35:15PM +0200, Arnd Bergmann wrote:
> >> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
> >> index 4a79704b164f7..2902b89a48f17 100644
> >> --- a/drivers/gpu/drm/nouveau/Kconfig
> >> +++ b/drivers/gpu/drm/nouveau/Kconfig
> >> @@ -4,7 +4,7 @@ config DRM_NOUVEAU
> >>  	depends on DRM && PCI && MMU
> >>  	depends on (ACPI_VIDEO && ACPI_WMI && MXM_WMI) || !(ACPI && X86)
> >>  	depends on BACKLIGHT_CLASS_DEVICE
> >> -	select IOMMU_API
> >> +	depends on IOMMU_API
> >>  	select FW_LOADER
> >>  	select DRM_DISPLAY_DP_HELPER
> >>  	select DRM_DISPLAY_HDMI_HELPER
> >
> > Like here, nouveau should still be compilable even if no iommu driver
> > was selected, and it should compile on arches without iommu drivers at
> > all.
> 
> Right, so with my draft patch, we can't build nouveau without
> having an IOMMU driver, which matches the original intention
> behind the Kconfig logic, while your suggestion would add the
> same dependency here but still allow it to be compile tested
> on target systems with no IOMMU. A minor downside of your
> approach is that you end up building drivers (without
> CONFIG_COMPILE_TEST) that currently exclude because we know
> they will never work.

I wonder how true that is, even nouveau only seems to have this for
some tegra specific situation. The driver broadly does work without an
iommu. (even weirder that already seems to have IS_ENABLED so I don't
know what this is for)

I'd prefer clarity over these kinds of optimizations..

Jason
