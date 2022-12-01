Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8E63F44D
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiLAPk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiLAPju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:39:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EB4AA8F0
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0FwtdAB7Vi+vUlV5VXY7oOkGsiANIHKxjGJQ+4ReNkOzf4DjXoWf4h7bE11q3NOi+uOspyqDwCKYtV4EltDEhx6veVYw25dHeETmXQ9g11jI2bv8iuJYzadcBhQTVQMwqgypb0+aeLI1WjfNGwAU3iwSj64Q42fBYIUX9N7iaUFJsgoZOUeGCmR396R31r6q+2MZ4AnPOdeordKRgK8UXHVJfO6sgQogek6/H03Q3RpCOCbnt/9gWApFhj+bCR+Qp2Gs27OpfFXTt16oO+HZCIAuUm5UX/fUatAL3xpgh3hZ0sfj+CONQVU3Lo+F6FRQhF6h8cgFiSwwbTT83sidA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVj5ojgndr0FlH/z6Uvq1a79leow0rf+pgxyOBhidoQ=;
 b=IAm6fxvZ30klGc3KrrCqC5bSvN9pfAidsbyKLiXiT3+EwyFwxTzM4rYlSuOb1gfRRn+tCS+KODRV8bkGLvIi9VETycOnXnfrMrYJb69HeKWNROpplxPh+zDJxHQBFUfDZSRae6zbN68yww/PjJd/1FJoG03HMfUy3OVccgXDIn1+WzWcbe2h+pQXfksE7aEb5IYmWsq/ryNEp6oFISIn74QEWQGfNf6CBOEUNVzqnx82RQ51HpY4Of2MiLE08h9ZF4W9K2GTB2GomFWMNYPpeveUsVPYWoQ47Y0HHLSOefEBuWJadwFjmNHcPn8ohVtz6f0/vMZYWpPs2VEqRZh17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVj5ojgndr0FlH/z6Uvq1a79leow0rf+pgxyOBhidoQ=;
 b=ZJGDsFxrtqGHiLssIABWIunb6BgdwMq0uT23gheOJ6AgSp86yyPgvsXTnC83dvn1Hdw0zBiCqeegyHyB89zSLgk9kmU5neyfrFv31qoglCH4yaVOWyzGApe1bEOjTaSa2wYVGQI7B4HfjHknojYzyfXwBjytpIF1iCb3dSLVrUTSCV7dt3exA0urirGLrz1DKOjtugulzLKOUNJroE/w1hBXzE8MmOjYKxGpW9UgwotEiPBxq6wsSd6BWzGm6F7BXBJ6yhS1RSSpBaQfBte5rewp96rapDLC3txiK9njKCxeqmhKen0QZRTo3UYarunwIG5dJTYjA1YnV2h/ZmuaLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7362.namprd12.prod.outlook.com (2603:10b6:930:52::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 15:39:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 15:39:11 +0000
Date:   Thu, 1 Dec 2022 11:39:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <Y4jKnBT7ZOkTG9O6@nvidia.com>
References: <5-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
 <87ilivw3lk.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilivw3lk.fsf@redhat.com>
X-ClientProxiedBy: BYAPR08CA0071.namprd08.prod.outlook.com
 (2603:10b6:a03:117::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 6320698a-00af-4dad-5ec8-08dad3b23139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFvD23eQHA43jF56ZiOYI3+Z2GEbrIDWItYCfM2Q0Myaw1mgk4a1cnhGHpRlinElgNy3t5rhQ0aicxFnVn3FIT3CQxZ61w+WkV23WAJDCx/Jh03BFgMBfdOD3vVHgBxIAjufrLXI6PEjwnv9PUbmPmkOEC7DNPC6g2E9AVtoYNnMiOJEDtCo8IZ+z8EZB0JVFBOOxcE5haO0hLEfLJZZMwkHbSvAt7QWYSEP1pOiONFjFAh+i3qK9KfxBi+HGsk0G7tlGnDkICThAeQx94LoJw0KId/VOlBuMGOuAyaMd82xlHsmah9t4LpDKnc4doImHBmP20a6ubH/qKuUjzQF9OEHHZ1dntr0WRoLCUgdscmf56dHWT/NK+ab0sRWyT34ZZjcLhN2iIG9qnPZQaLOKPwX0Odbusf+id1mg51pHP9z8ewFB2vEDgLVGKGN0taxzFqIz4F9N//PhTf6GU1y8v97p2NrgDW6Gl3jqzfsgkhdxKu6E/vleMCdzcBayFLYY4OQfnznHaru8XSfQehc/W0xFPTyWBIcrt8wNqbNhdkwkOjydQrlUOe3jXmLs4sgfme+dQqpELaXtqNwuuehGlrnGprlMAZUX0Oy2K9zVbPbyBZUWnB0i+MeSKSwdJMsZW71y3sVNDIM3eEgZ/hHiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199015)(86362001)(36756003)(6916009)(54906003)(6486002)(316002)(478600001)(2906002)(4744005)(8676002)(66556008)(66476007)(4326008)(66946007)(8936002)(41300700001)(5660300002)(38100700002)(26005)(6512007)(6666004)(6506007)(2616005)(186003)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xiESJ0RGJFD0GpDWbF3KUv6x1os9zlqUCIvVayRNykGe7DcJs4/4vuRjug9k?=
 =?us-ascii?Q?A+Zz93AEyXjb9DO6hvLCdbiHaRqX6W47gOjPe4K6N7pBXAml0HveWvTYllnr?=
 =?us-ascii?Q?lZ9makLu34gviUqD8M8QV0qbohG3mtD5uxFplFhrtZeRHGUqerM47C/ay+O+?=
 =?us-ascii?Q?D3vUD7EDV243l7BgHVjPqXhqyy6uVcIqL1IMPWNSbTcy5t8sj2w7HYk/3u7p?=
 =?us-ascii?Q?ItjPebx/12v2Lzi3cnXoHnXtiuW7DXVLm2GrLbrb01kvtMRIzkuovNnsc8fw?=
 =?us-ascii?Q?/v2+eLq+BqrPI1wGVajJMNQCzqUxY179qDGMFMbxczyxYIvFMnklhSr+/VdC?=
 =?us-ascii?Q?XcLPi/k/Hbu9T83EGB/JwIsT+selMo+/nJQDrvMUSgGDHogTy5T0ibv9aM0y?=
 =?us-ascii?Q?5xR7+TTf7X0UV6qhoHoaHKIzYYjuax3+y9U6qhwLMQbb4rVpeUkNmOa0ijga?=
 =?us-ascii?Q?783VTpxYNpGDH6p7lPO5WKhWx7cbwThw0piMXQ3sRHMgjW9cRYxk+iL8l0Y0?=
 =?us-ascii?Q?5ycdWbwESZOI1UWSAdb2HounBzbi4XLg3XzMSM7h6fk6aDgvpJMf6fvMUGto?=
 =?us-ascii?Q?6K9rT5abx2HB+Ny9iOWKEy14Rz+ZI3jT7E/KDJDlWye4zhQYgVLaewRBv9KW?=
 =?us-ascii?Q?gLvnXuYIkOniLi9Ws3DcmJt0avrZsvs5QsKciA4GDmPSuXIGmAjD1+XiZxXy?=
 =?us-ascii?Q?xgdjP02+HFrWz/GYeklR2yDEagkC+54ddeMzGj+xoeOJJ1zr9HhZWNT0ppCW?=
 =?us-ascii?Q?/d009vQtQ21BVvLTFrDFn70jMhyurcIafpsTk/JBkPOQUSV9fMry8wXRMfHb?=
 =?us-ascii?Q?kx1GSxIo/cupxXK77/ndeTDS28K9Vs2eDafQYIQqY15A6CaB2jtYr+lnI0q1?=
 =?us-ascii?Q?VYFrD+eFP1aFOeHI3y6G6RgBK6ZorLEIE73dha/AeASZaKLJYbJzvHTX3lVf?=
 =?us-ascii?Q?/0D/6ljY1z4+gPoHCc2AzRpWKqLV2/LscC2p1MiNvoCYhtak+Th5X1jMA0RK?=
 =?us-ascii?Q?L1Gum2QB3WywvH6cEj9+QpCS/iGGef0yAoDpjY9pOPQYlhUFn1Y5jyN6xvBo?=
 =?us-ascii?Q?F4+D+6GvwrSe4s6oO9J5tMbdaiRoQrRNHWV5P+am3tNpMkXPNU83wQdvyKpp?=
 =?us-ascii?Q?rjx6hSDqWbsb2GCWRLa+xVuNsjiqEJ6M6hcwSirUvk/+2M8gUXvwOKz1GNVe?=
 =?us-ascii?Q?NwCdAOOekjk6Is4gnIqsT9T6kWu10D9Ow2sZSLcfHmAqGmGH5dpmek76Frg+?=
 =?us-ascii?Q?Bd4V2cfX6gtu+89l3rTB57TK11oDPMXaNEfO+SRfjtccT2LJnGmX7MgW+Vrx?=
 =?us-ascii?Q?RUiOInW6a6sT6ciIIbsH5hTgp4CBqpyzT5w7KytaXv/vDBSC+8mcRH/e7ZmN?=
 =?us-ascii?Q?y8XYhvP94S0mIhkcwSTw5tNmc/mTQih4kSF1kMquBzC9GKwnRNcDMO8ZDSIo?=
 =?us-ascii?Q?XELuqFdJrv+kA6GQxdY+K2L3oibbKXVPxtuk6bM0YzmWyk+mf8dCKsXjGP8i?=
 =?us-ascii?Q?Pp/ZBIXMt5n8yfqZren/Hja+kVhrL4jE1iAFt1EVuBqVTNmlKCWl9460n7SD?=
 =?us-ascii?Q?W3BKiNKXA2hczKJFXZg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6320698a-00af-4dad-5ec8-08dad3b23139
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:39:11.1404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agnZ0pD7G1KZQkGWPcn27YVVoGfoh5UY49jQOtuVo0bwoT/TkSlGCcAlecjF+npv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7362
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 04:22:47PM +0100, Cornelia Huck wrote:
> On Tue, Nov 29 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This is only 1.8k, putting it in its own module is not really
> > necessary. The kconfig infrastructure is still there to completely remove
> > it for systems that are trying for small footprint.
> >
> > Put it in the main vfio.ko module now that kbuild can support multiple .c
> > files.
> 
> The biggest difference is that we now always have the vfio-irqfd-cleanup
> wq once the vfio module has been loaded, even if pci or platform have
> not been loaded. I guess that only affects a minority of setups (s390x
> without pci?), and probably doesn't really matter.

Modern wq's are just a little bit of memory, it isn't a big deal

Thanks,
Jason
