Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60968714F00
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 19:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjE2Rpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 13:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjE2Rpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 13:45:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E9AB;
        Mon, 29 May 2023 10:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyAD4335XRxFCxR4cxwNw9PtpBir077/cw9rspsigd4B9OeB0KIeTJoJN6m8B4ZqeCzxkzuG5FHCznjL5qxR/tWJrY3orGUnudXE04alAW1KgFrJ4kluqtUDMOxXWLKJFN2XXUUfP/jt6Lja8xKTiuZy1KZhKX2+h+Rp1VeoBp9UOirdGuvht2rFzGXlbZgAvFqQkfMv0uLrluDdVmD7pi6rxQR/aA3LLHZ3wxxsz08XSMYxiQ6IS3/ZrG1kit5BCifaCtXd8D1znllXBq/LKU6cZnLta9rXyG5onjge2zg3uH6zEm+nuHCSl4f4XW/t+OegBRVlQrVup5ohuASNhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mx+GRtdLGBOgJQwerBXpp7S2EQLbom6uJ80ncGy19P8=;
 b=g8GJmkQdl2pvaU85D7Xf34Zb9yNwAFWhZAivDjvvclKaqggvs+wqWW//ekvqxEOEwdN4+RFl7M3u2nEPlVSRSPB335KbZLNfszA4nrylaBGyy6iiYMNIwPv6LgEJN7xpCAH1Achx+9fg8+VXl8LuuYH9AwERJSkBzUgo6qQXRI3kIQyzmqysitV2ox+oe+vsnPmgS/E0yTPevppDv/kno1BuvyVGY/YCkmywq5LEgJatO389KUGxJTdENluGoPsF7LQCi0JO8YpPoZg48p+gl/WRbyRTnupU7eT4uLV4rj1wH0vm3/FL9G5cQgqlz4t4KYZQYBe5gBq4k45QilvqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mx+GRtdLGBOgJQwerBXpp7S2EQLbom6uJ80ncGy19P8=;
 b=ecknAYaWfI2U9JuC+08rmHF/fKa9uh1OmzIL83gcPMW348VM/Kv+oywgE0PPaCIljbUScP/Im40IEVSqjFxloO63WXpmeeGMaaO3Q+bNmeenFQ3LmEXBa6K1D/4TgK0QvCTTUMqr1fvaNsmKsvERnEvSyVEqYauzA8NW2hxpHrGnXx6Ity80ry/UKxJqd62XKOrY10lXVwnRgSK3iOaSNgd158Gvfc0ofvU3esVwmvYCbIzg6cFtb/097y9S/5Sa27nH6KWG3nOzkAY6hm23VFkIOOiOKuaIcARfWpkQBUoJWBLl7L99cO+c0ydbit3vh5Seo+yWiXvpcpxRFrb2ZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 17:45:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Mon, 29 May 2023
 17:45:47 +0000
Date:   Mon, 29 May 2023 14:38:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com
Subject: Re: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZHTjEgXPHhTKtT4N@nvidia.com>
References: <20230509040734.24392-1-ankita@nvidia.com>
 <20230516150914.26ae99c3.alex.williamson@redhat.com>
 <ZGQfszAGGKhCp20q@nvidia.com>
 <20230525092123.2a41c1e4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525092123.2a41c1e4.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: b71727da-8c44-44c2-beb7-08db606c8888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bX8LxlEHSrI15ejjNA0j6faJP8Umcd4z1O0Fmpe94rgGb8zHE4olOJ4NsnamXuhbNx05kNfnF0XBr/Pa5xg7NwQ7MjMw7zznduFeoQt6nsdKrjiiyxYhWEvnCA19kYV/kFrQ55M+Khj0xUdqjeAmhJioi/cdxyG5G3/rXzPSGWBAev1TaMz0bImNqMxpKo40Uf5BXmv6/lgrS45gA67LkYiQlmXzKFKodTsBxWhqC2gdcppib+Q3aLqdahraA2RNjL1mrNwAupY8xD+Ov2TKl098UYgaVUGirRBMVQ5+TM2C/DGjz7MgtGZDdI+xXz0hRAFqg1KC1arOySP55Ij9KTnPHUTxwc3LuexP2Hwpd+mA0cl0sZQubeOPIFVbK6PV/YNBQi5wsN11/xVDNBDgECXcoqIehZ323RgzsLqaalBqDXmszfXArPUkF1Xl2Qo6rf/FoDcfKsa5UaSY0KLguRHFzimbtKItOaLjFp3UbeEU4yLxpC6VB/Uh60hZ7FfsGFRo5yUoAtk5VoWxO8Eb+tzSJSHs9hoB5yZqBYmF9LNfwEwy23GsMXHeZ8CdWX3y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(41300700001)(6486002)(86362001)(6916009)(4326008)(316002)(6666004)(66556008)(66476007)(36756003)(66946007)(5660300002)(186003)(6512007)(2616005)(6506007)(26005)(478600001)(2906002)(38100700002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UUVdbWNIlZfU/TZGlsFc1zRLZKjIaZrrsrdyS7XdQ2sTN/UVm8NZKyFrK8Oz?=
 =?us-ascii?Q?rnP+Gijuwwdr6KrcD5/Jnnz8DZdZvexSlqZRjd50LbIKfgbV4qa69GKfAaSq?=
 =?us-ascii?Q?YM6ebv+SYLKlRzhX3GGKcoESdzsH194eF7XLycRqSbLvPrVsa6gzmLzZuc6r?=
 =?us-ascii?Q?ceKK9bn3YEnDdUH44PSiVEv8RjJPbYOiHv9c951iOK7ELkM6Vur2yhxUHyr4?=
 =?us-ascii?Q?avB9Jv5zF0c3K5JN9MaAQyU2yoq9JzEaFGH6TeINsTA7+qZ8iPXJWNmMjJft?=
 =?us-ascii?Q?QGfH2fTNsr3DvMy294Ft1vvGIqZHf1aWuDzNR7g/7oVF/7QqzBfwIlOAvSky?=
 =?us-ascii?Q?HB9Ghic2u9riz3ZwtvDV04syywJahAOhU7cbSjj5xi0lwCNq1I2VexJkcx4+?=
 =?us-ascii?Q?djddiqzXCp4RJTOf3FU9olHoOB79xpLRIaSt6Q6b7eD4Uwns29yRZ95CUaqv?=
 =?us-ascii?Q?yLcHizAwypzgCu9iVK6WNXLaNubbm3P9KKT2/3WB8b26Uxs/B+FjQXZb2pB0?=
 =?us-ascii?Q?NflQJYrt7WWkX1pn64TKV68rXVifhPt/rgFgb+iGd92ANdulmfrh05FUqYxi?=
 =?us-ascii?Q?0DBWnbt8QHW2I4bT+ZevO7RAT2h06PYtujjKP3LUisqhTOaYFVK0TomlOGk4?=
 =?us-ascii?Q?QXr12sKuwM0rylDw/6ptiFk4Izh0m7Jrpgo3vRTiGoxaP66kTvCMtBlHieaw?=
 =?us-ascii?Q?aePf+PHbVDxcEpJcYWEe9JJB4Cap5D4sW4t9ug7kJPfpNa9SvTdwFCPzPHs5?=
 =?us-ascii?Q?+7/83aZtN0g7E6Uy9p02VboyW0leBsR7OVajmKT8J425+sSDpN4v7qc/Bf0t?=
 =?us-ascii?Q?pd0LmYpRgcnTvMEJPHthr1+YcIxxJOFsWrcS5sPt6tKgBhpi7mooW8uUztJR?=
 =?us-ascii?Q?L2YSDLj+aJzidgCwig40O+LOqub8k2XjShWpCCj9SV7sNztoe1Rm9NL1GKuc?=
 =?us-ascii?Q?z5btSusm5/VV1lNNkRd/KY0l0McoEqsjOU03e3mXcNuZ7Oy4uXOHmEYp9mVn?=
 =?us-ascii?Q?/4HgsRLXYIY7aDiIgVt3rXLyd/CKvt+o+0xDGeW2FFL8q0PL96HneIhlJu0B?=
 =?us-ascii?Q?aAXXayUS1Xmr3MFw0vYPWqIzo68Xo09mVd05EKjvAbMSt81tLbsr8t+7o2dV?=
 =?us-ascii?Q?VtG8ODQSGPhtBBPzKnZoXKFl0aCItsS5i8kPsmnUR9d64Gu2oHoq3/M7sH7N?=
 =?us-ascii?Q?VmrOzYMlsLUDcpkngBJSi6YFHlO/4U5XB3EBDeJUFEtGDbIEHzmJhjgCb8pN?=
 =?us-ascii?Q?d8C2uxTazmspeyDsmLXnJXG5wzCqKtVdOes4PH0wPWLgYvZmwAeFI1BkwLNi?=
 =?us-ascii?Q?gDw/vMBgJ3jjvh1R5e9/g4E1wBtDtnJXUppMZqXYnZpM9vg/XBNoAQkpKvFq?=
 =?us-ascii?Q?Ad1/bI+Nj1VPpzuIc58TF3Z1bJ3zlD8AEGLE5f1ppgptLcyxoZhd+5aRQLIc?=
 =?us-ascii?Q?RupVUTG2P7jmpo14Qjy8mKSGvdNEWCtTjEf6nM96aF2R4+TwKydFr25VN4Fy?=
 =?us-ascii?Q?HFpLzda3hriqUjj6YUOjdjHtez6TRkmVH6L6MDz0l3cBGd+ViTWV6ej3h5jz?=
 =?us-ascii?Q?lxUnWL4rNofKIJIy3vjRwCz4fbbP9WT/RnVLpVgJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71727da-8c44-44c2-beb7-08db606c8888
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:45:46.9458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0J0tl6rV4CHPHeYZu8Ch9SjOBxIJ+Qs6RJtSx+Gw3ErYliV8j5OVnp1mYZRjdbA7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 09:21:23AM -0600, Alex Williamson wrote:
> On Tue, 16 May 2023 21:28:35 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, May 16, 2023 at 03:09:14PM -0600, Alex Williamson wrote:
> > 
> > > > +# SPDX-License-Identifier: GPL-2.0-only
> > > > +config NVGPU_VFIO_PCI
> > > > +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> > > > +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > > > +	select VFIO_PCI_CORE  
> > > 
> > > I think this should be a 'depends on' as well, that's what we have for
> > > the other vfio-pci variant drivers.  
> > 
> > It should be removed completely, AFAICT:
> > 
> > config VFIO_PCI
> >         tristate "Generic VFIO support for any PCI device"
> >         select VFIO_PCI_CORE
> > 
> > Ensures it is turned on
> > 
> > if VFIO_PCI
> > source "drivers/vfio/pci/mlx5/Kconfig"
> > endif
> 
> The source command actually comes after the VFIO_PCI endif, the mlx5
> Kconfig is sourced if PCI && MMU.

Ah, I forgot we made the VFIO_PCI_CORE a hidden menu choice, so yeah,
it should be select everywhere and we can't use the IF trick.

> In fact I think it's the current variant drivers that are incorrect to
> make use of 'depends on', this makes those variant drivers implicitly
> depend on VFIO_PCI

Yes

Jason
