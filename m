Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E48C7D3933
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjJWOUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjJWOUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:20:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FAD68;
        Mon, 23 Oct 2023 07:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRzVQLoP3JTFDaF/c1K4X3o+7jNY6Ub3iz8XMh8GQXbSq/etFaqZSMeGmH6UTzaZa7CqR6Kvz4fNuMM8TRLT5UlZ6XbkslaWGJP1P0cbLd7rmEcJg/m4FAkEPjKids7bUxvivu4Ax6FknsYB23IRE9web/lyvu6yQRd/fPn549aGcSdtqR8O+10H4+13sJFENNChF6KFXf6McYAZ9jSshqouv4Yj/Oce9+Nk83g96gwLWdCUl9gVtV+XeFUjHgSk9uY6Ju/3DwlYqGkrlDNqXUHBPRl+z+d2GMtfNHmg4stgMytJzKz/6EWUQpRyt99mYWXSjQbeJH7vhfW1gXqHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUQhp7ekTwlQf7IvSEV5BoubNMx5BW3mlpHV6hSg2P4=;
 b=k2I8heACHpN2xGO4YMj+DMFumnrjYe1n4tPAX50iSEC5uafSg7CAG+TyND791qlPaAZcn9K0+FZA2trEuWQEbNArr+u/UEbR5G2yOCKBZ4plx4lKlI/j5kQlhoPT5rxC0pEk4BD+Gvw4eLFjtdfk56M6T3l6J43eyFmZ55dDyJmvgjZAn70JfsFH/M97wz8V2JR0BMjL6nQQAx7y0shdB7955ofX0/lQ+Y8v2fL8ez8YWjuMXw8PlJ4dbfYvliOCkibdoofQrEnEINwx3Fc8uu1/RwyUofskOTzHS9sCi3JJsJHmdGG00LO15USn4myDTyvZt5DiUPne/D7IOkTdOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUQhp7ekTwlQf7IvSEV5BoubNMx5BW3mlpHV6hSg2P4=;
 b=RM31XIIIdyeQHhe2yUxgi71EZGME0oXa78FLlXClDWjnpoHLx9z/YMrEua8zQOkua9x4ki4xph94aFGm0N9X/+aUT9NlIk4MA7BKlhpUdWVr1bfEvmnwZ6iE6S9L5P/vdCUBP0vgUegDy/27YfuTigzB6c7XamCRJ1hqGqET7x7qG44/yCtrunW1WJhjva6X4ho92cXsw3cmz0DocM017twmYpkbk86+xaJZz+jpGnRQGze6B5b929Exg1+7XEc8Ltk4zFCzgAUuzlNuN6NG0oXpiKC/CG3ld5OXiomWV7ZgxMYLj1LvNlcPLxJZoxjXv2bfm1oenh1hu5Swo+AIjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5664.namprd12.prod.outlook.com (2603:10b6:a03:42b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 23 Oct
 2023 14:19:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 14:19:56 +0000
Date:   Mon, 23 Oct 2023 11:19:55 -0300
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
Message-ID: <20231023141955.GX3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
 <20231023132305.GT3952@nvidia.com>
 <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d7cb04d-9e79-43b9-9dd2-7d7803c93f4f@app.fastmail.com>
X-ClientProxiedBy: DS7PR06CA0032.namprd06.prod.outlook.com
 (2603:10b6:8:54::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f5e89b-ac08-4455-8742-08dbd3d3222c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0lHPBnacf0sUoevSyY9GiATp+jMW94PpiOAIBWanVqSjG/VzRNyVlorn2Kyd9CcCd7XD3XmXVs14F2KtBo/SZJ+QMI+MX3GUv11WJ3rd1c7LM9md8CCIQPAc8BozfUiNnHdJAwMr+HUZu3ee6Zxz4WUumux5F1mvJ9Yw9cKxKau32ce5w7XWaycS4lfGSPNghgoD5JkvpCvMjuKIo5bhkJ8j4QQc0mify9tZCCyGjNAUoB2l6nQiSbL6uK7cfbYmRQMCqxQdFxSCbv5J9KTjH1s4NXX7oYdTaxQeWXCl+PGamDTudgGr5s3LknHHrLARuIz2AedXBz35IevgOAee7lp/ylGbZI9h8ppqsDf9yIgRhNSzTMI9CedDyq+fQ464f0TT8mnEe5VyCCfBaUF5Be8ojc0t/K52uACDewHPv/B8UnAascaLNI/CnHKTOZYF5WCo9GBy4pBNC60MHLq1nxPjDFXdCvByqAXNmVK4MM5kqAc7qSqG0AUwjrpqtMTvNUoE+ka9c/MEhGectUJhYCYFiX9BC4o9bPid3j9zt7bZ/R2Md73w3x+i5h1VLEN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(8676002)(38100700002)(478600001)(6486002)(6506007)(26005)(6512007)(6916009)(66946007)(1076003)(66476007)(83380400001)(2616005)(66556008)(54906003)(316002)(41300700001)(5660300002)(4326008)(8936002)(7416002)(2906002)(33656002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O24cT2d9UadfnenE0UNIdg8Dl4G3vaGbkhSZYi5dnah/RYSB5Z4hidXdJfxm?=
 =?us-ascii?Q?lgbXlsVoLOd1mPtNRnXwcBNLRhUln1RUe+TbV3YMm4+Jy2kYeH0Xg7Tm6854?=
 =?us-ascii?Q?KvjmP8Mj5GxzmX7ELDaz1S+3v5p2BKLpO9VTj//afQUZ8e1Z+kBIMkTtwrxC?=
 =?us-ascii?Q?3meP2tk8EBoss0lNisyKX9dUnSP6P1ABQoFiIBYC2A1n2jxdbzZmK6cxuQp0?=
 =?us-ascii?Q?09VzPTtDXCeOf7V80ku0w/z4RLCcCKPtqZAnh8RQH7PuklikRBUrt6RtkOTX?=
 =?us-ascii?Q?iLMB/IoJHHtp/+WwWkPQM8swEU/2vMvSJT+rD9cWjqiLA3WiUIPOQOwvnqa8?=
 =?us-ascii?Q?6pQYdqejQmWVg36SszZSFBSB3O7YCT5EWXINPm5qE7H5HO3IstSo2bYscme8?=
 =?us-ascii?Q?lZo3ycLtv52nbzMQ/cdTYBa22/5ILOg2pQcfRlbNjOIUp5aPRD09PcH0eDsB?=
 =?us-ascii?Q?SEpLRIwbq3cPUEEon2ojFkB3Eu8yeXemmTnTCBUMmfveRKP8TxY/i8lUtece?=
 =?us-ascii?Q?S/GZ0B6pUtmGLjZ151RKJjPnwz+H0mYoDRqiZqJHWG+onwro89yc1y10ppEt?=
 =?us-ascii?Q?z72cmDfizFZokKjkv4SUUmGPD5B+GDitByMCYbNdPWempCOVzD2pA4Pn5D7Y?=
 =?us-ascii?Q?Br4L8hUfCfVT9O14sqvSAI4sJCOJpbfkY3uptGn6NqpXywu9qqRn277QI+lY?=
 =?us-ascii?Q?swzzoBnjJkfG8CkPtMaN/OprRiKJzrhVxODVNo1O8xTp7LX5S6vB9Sx/K90J?=
 =?us-ascii?Q?7fpj1wslKzW31c2zCG2nqS+6vuzpNLIpm2gTS5lEVeaMn5h8BKw8C6lijhQ0?=
 =?us-ascii?Q?tJvnjlJltQKSSYJq0yxyEStfxy08u9S3f6Eh9glu4BcycidMpuOBMZAWNrvr?=
 =?us-ascii?Q?vRercok2841qdwb+zQ7cMzxUZK9Cs2GamsI9BMi+sHIJVr2Zp2QtNISzy1yR?=
 =?us-ascii?Q?pX5Z9I+8COZQ2JbCDQGZho5O0I1ruBeA0O4LauA1WSCp28jk+14k24UNawrb?=
 =?us-ascii?Q?iwPA4izTa0/DWZEw+2niBAbO09eUbozAh6lCKfnezy/d8iIt7CE15rHH1/eR?=
 =?us-ascii?Q?VtF4I0MihAiinYTyZLUWQgzK4hI21QrMUdVQlRNW/0NsaINO6I3PBNM7LiOz?=
 =?us-ascii?Q?YlOg2orL/LNRm3ytA2E+eKKjDhg6uMbuv05mEiwvG6THmeNns9amW/Mh5R+x?=
 =?us-ascii?Q?tYuwuxOZhvMZimJMdhRcZ/IJNsN7ii1/O6l4Z+W+wrBjsRedA1S6q3w/HyvF?=
 =?us-ascii?Q?1KPHUjpaNqehXbyvNA5TH3Urug66tjoSmPhMz8tEECBq2FxlFLKUrETVdIhX?=
 =?us-ascii?Q?2yDid71VYGgdcCi155wJmjocVr5MNqQnsurKMP1CYU/vqU5B45O/vlEvlcru?=
 =?us-ascii?Q?pwkBxsk2VTHQuW0qpZOYY7xvEbqsWzQYI/MHLle1iL7ifuU8M1hYgPXuhZ+F?=
 =?us-ascii?Q?bfsobhVfAJoVobWE/dtz2g7sLpJvAMeJbVBhJdwiCdWvxoo3U8Zt7QaZhh3P?=
 =?us-ascii?Q?gYSYyC3vxxmWMtNR/8feh42P+xxXqyENT15eDFnBDqrgXepI1kgqwen2svHd?=
 =?us-ascii?Q?Eklk5Du62izUfo9fJOJ4K/PuA+egiCmtdSsdVk/b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f5e89b-ac08-4455-8742-08dbd3d3222c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 14:19:56.9353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtcNr79pcmS+Okz3xnQ6LUEXkOU4GT7/afaXtfdHQMM/+VmrcA1Lv5rKUzPZsbhU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5664
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 04:02:11PM +0200, Arnd Bergmann wrote:
> On Mon, Oct 23, 2023, at 15:23, Jason Gunthorpe wrote:
> > On Mon, Oct 23, 2023 at 02:55:13PM +0200, Arnd Bergmann wrote:
> >> On Mon, Oct 23, 2023, at 14:37, Joao Martins wrote:
> >> 
> >> Are there any useful configurations with IOMMU_API but
> >> not IOMMU_SUPPORT though? My first approach was actually
> >
> > IOMMU_SUPPORT is just the menu option in kconfig, it doesn't actually
> > do anything functional as far as I can tell
> >
> > But you can have IOMMU_API turned on without IOMMU_SUPPORT still on
> > power
> >
> > I think the right thing is to combine IOMMU_SUPPORT and IOMMU_API into
> > the same thing.
> 
> I've had a closer look now and I think the way it is currently
> designed to be used makes some sense: IOMMU implementations almost
> universally depend on both a CPU architecture and CONFIG_IOMMU_SUPPORT,
> but select IOMMU_API. So if you enable IOMMU_SUPPORT on an
> architecture that has no IOMMU implementations, none of the drivers
> are visible and nothing happens. Similarly, almost all drivers
> using the IOMMU interface depend on IOMMU_API, so they can only
> be built if at least one IOMMU driver is configured.

Maybe, but I don't think we need such micro-optimization.

If someone selects 'enable IOMMU support' and doesn't turn on any
drivers then they should still get the core API. That is how a lot of
the kconfig stuff typically works in the kernel.

Similarly, if they don't select 'enable IOMMU support' then they
definitely shouldn't quitely get the core API turned on!

> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
> index 4a79704b164f7..2902b89a48f17 100644
> --- a/drivers/gpu/drm/nouveau/Kconfig
> +++ b/drivers/gpu/drm/nouveau/Kconfig
> @@ -4,7 +4,7 @@ config DRM_NOUVEAU
>  	depends on DRM && PCI && MMU
>  	depends on (ACPI_VIDEO && ACPI_WMI && MXM_WMI) || !(ACPI && X86)
>  	depends on BACKLIGHT_CLASS_DEVICE
> -	select IOMMU_API
> +	depends on IOMMU_API
>  	select FW_LOADER
>  	select DRM_DISPLAY_DP_HELPER
>  	select DRM_DISPLAY_HDMI_HELPER

Like here, nouveau should still be compilable even if no iommu driver
was selected, and it should compile on arches without iommu drivers at
all.

Jason
