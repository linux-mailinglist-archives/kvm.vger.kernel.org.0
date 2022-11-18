Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5B962F589
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiKRNHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 08:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbiKRNHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 08:07:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5287978186
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 05:07:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQvgY4SeeUIcAdBSDf+jiZKqSumPQEgVQtiomOr6KqwuoN623k+QXsC0cv5Y6wBsFskrQnI0repGS2uGg0q2b7iRArbM6UrvPqxPPo69MJPzkmGcTSEoidHtQLlKoIw7EPfWTsdjziHQhtO2d5wOdkja0wXVmgcYd083yBTYey9pycTz0PPpxVepG7d43Pi9GOrXkFArPUyjspm2Gs0JWInJu/hizpzHhdqfxTwEVHBe1FNtPxxit00Sq6rzrWE3CmW5KckrsGD+TyeqBOiH2r854qXOfEBIoluu3nryunzpqlIfDPeerM18A19UWvWo4gimk/abqGR+2uYh9LGjSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlbVOb4LwoYbckR3eQPE0o/XbByq9XLhd6QVOcynSJU=;
 b=JMMpFq6WxRgODlThF9aU3Cr5HjGf86Tdknqx5OkKjYfqu+QdJ4iWxI4ojnOJZgCJWKF9VmMpX86kXT2xsrE5/UpPAUJP5bOaKev20izERv3CN+sYRBQfbVexinfcTwCAvb77RhQ+CRPpslE/qkjADrdYNTGZ0ZP7ewywU4N9q6mws3hS2/w+vFBQQ/WimkmVk0GaT/1uAXRWOGyQRRxgHBdRn9GofchnXqZTQksTlPjCO4MAutRDBhRfUxT4UWzGm/Xq/Rf5omZOk4PVoP4XmrBg4pAGkxqiWSPOAH/+O7AuJsGP2IxXYJMu5k719axe183ArIEX253GTedrRo3toA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlbVOb4LwoYbckR3eQPE0o/XbByq9XLhd6QVOcynSJU=;
 b=L5WdFWPi+V9pm0HA8O2uKgJ3KMy/dt6sCsI3QdZmNR9EkfPXEb5KGnK13vLQSxFhFPYguhw/bHyqT/gNHApq8T80mGSwgd62UrW5sTwuA+fBAeywxtYy9/vrmRva0i23hILUmoIfgyID0hiaS76cSQikEKILTS7+k8u4coNkixD3WPyVa0BlfibfEVTiKYeomdR6L9mft8U5c4MbaOn08QzHgvzBis5d5p/iRXzU+XeJUtNQcBm+R4Wc6cB48fIstazDJ2wLY/U2idnBxjk2iIcey2Czgc4UH95EYmkjrOB9Uf8BBCmXS/7wjoWGjXFjfRuriKXGm9cui8bZxjG1pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5098.namprd12.prod.outlook.com (2603:10b6:408:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 13:07:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Fri, 18 Nov 2022
 13:07:12 +0000
Date:   Fri, 18 Nov 2022 09:07:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 11/11] iommufd: Allow iommufd to supply /dev/vfio/vfio
Message-ID: <Y3eDfwamDjhIDmZ7@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <11-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117133417.2636e23a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117133417.2636e23a.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:208:329::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5098:EE_
X-MS-Office365-Filtering-Correlation-Id: 78982f02-5198-41a2-e4eb-08dac965ceed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCIwldGf49hSrJJe36pTEni/Js+J+lX5uSMmNrahqTm3qcVh/OinqgKMhiDD3CAcdywi+XVvbEg+WeXhJOUz6Dgz0YLXrJDnunSxRgX609x/qv2amMQZjNfvncujTIX5TmHT1CVr0C+scq16HmVgNU6tKdedWpSgC/ecKYAjskVX90xqF5yxm6y76vmXS33FjylVmcxMaJMlqP6+6mhID7cTttipJxX0j5kEsMsrBf4OpptjFj6ajEnjcopGUHoIgKgN1pIZKnvhGlzBo4wvfj8S/5VKH/PEdOrgkaJQxeGQSI+ulinQEn+3mfExYzOJIDsESOHMfqOrb/YpJmiPnlUn5cX2RIAbXzA4P1pv8ES+85rAFQNCTeS4QBZfWC0qeFlHJuD/oesuCmP3J9R9pq5PcZiW8J4we+94EDgyvY3bDIWwzMzMIK+s0QCA/OSJtTn0384Hwqhx5Qew36GTPBv+uXBcS9Z+tDRCMxzJh+U36JMMt7I7P2IPlZhCGgcPR2mrHidAqcxHSKgwnb5tfgY+fxfP2zzWMNRBfo5gB+NTmlO2cgdHxKtDaWD5R77z9RL8bfKbUOS1AGOMZu7wYcnXM8lEJNGngoC06hN+TopCgpi0VL3mG6N5VOXukKP0Bf5SprGhS0XYqusqC0xbgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199015)(478600001)(6486002)(26005)(4326008)(66556008)(8936002)(36756003)(66946007)(66476007)(8676002)(6512007)(5660300002)(186003)(7416002)(54906003)(6506007)(6916009)(316002)(2616005)(2906002)(86362001)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SAdTxMKLQa+uGJsi3quB4qMMd+mZSNCxCuwc3/8TFWjXWBiVbZO/sa5C6gtC?=
 =?us-ascii?Q?7DrE1xgNJkNJARzyWhA79Kf9kdyZsNIoIb+pNkkqYjGos1XmoZzzCguzjw7v?=
 =?us-ascii?Q?Vtgfmrv0ClwF1uoHTXQnJhL9oko4jXPJvYUJKKzb8ceL3770cD6EEqX0+5kp?=
 =?us-ascii?Q?MJ4Hu0K2aZ3Kuc1TDj4vAwcnApebFyqmAshIz9ssgnzWtnGKMa/4prLx1W2A?=
 =?us-ascii?Q?S4M3oFRu/uLMg3B+FHNrSkYn3tNL2xWMZsO7lcHrTgazJgNiDHpesI8EdNCL?=
 =?us-ascii?Q?Z473ZD6gR7/ZXXWSoViJf4dR7/Ko3POqqpbduzuHozsfw14P5aDWbpDc+LKm?=
 =?us-ascii?Q?4nNc1AUMrO6k81ca2KAzEsbj9OvTGpJXPSVw51udY0VAop7ajgmwphrjAlwS?=
 =?us-ascii?Q?7YDEHuTl/MQ0pLPffxi4pGSJihTvQI7ZX42PxvIGz38kXG177P5zKvZGrWLj?=
 =?us-ascii?Q?6ToSNJL0rO+I+pgvFwdIIsegfiivTnJFE7PFiVm4t+WWPe5snuAsfFV3MbJd?=
 =?us-ascii?Q?0mOdC3R5UX2RO+/i5YnFdDjuFGwpAbmn5nwBl24fLeh2dJpROxrr7N5uw+Ia?=
 =?us-ascii?Q?0wE6yp65bmhbiHXPXAakaxIoqEru5ZuwRGb1us0AWpwdKgBOsv/r24XVUgmn?=
 =?us-ascii?Q?oLVmpL21s/J9fuokjXOSC5TOYWaLuBDu1DFT+VXKPTIZPKMuf3Wg3UTtv3Cv?=
 =?us-ascii?Q?7/Mvmxb6lIxWxdRA85nV2V4S15nWqNdVrkDU3rEfOe9hE6h/3xaslOmkvyyy?=
 =?us-ascii?Q?YmMkztt0Z1WQmC4rKeG9YSvV+YoDP71NBFSTQctpvMwcP8pwrNF41i2bb0mF?=
 =?us-ascii?Q?hUPGgJ98ASk+SEoX+KVCtVGHyptNGwKxAxAe9jnZviFD/N5p5EzeJg0LXKPa?=
 =?us-ascii?Q?vRjsT4RMoDXq2Dl2CmFOobQbS2C1Y0a244rMB37lpBMFMlO7WkpTkqLpx0uj?=
 =?us-ascii?Q?KCUoLOKy+R2zVtvfeB/Bp6Fh6ryXWyDQZ5uv79fUxy3KR/JsqLj+iYFT46yG?=
 =?us-ascii?Q?uvUfokGfqvXVGFRu0chdAi/hGuEPNBraKexTZgbCj0XPJWQ8UrvkiFpiVRnE?=
 =?us-ascii?Q?uFe/nd88WqP63sgXsaO/r53aIfh0pN3eY/frxqYq9dxZiwYPvIf4olwRU0ce?=
 =?us-ascii?Q?4mBenkmDUbf8t/QAn0UvGSg97oVua9vf4Cl/XnufvE88jS42QHAEohEA3BoF?=
 =?us-ascii?Q?YFzmHSyNJPJjVkFjnaCtSDgI4Se+SZB7XoJJ8oJkFp+JLyEdYt8lcCBDmJQs?=
 =?us-ascii?Q?DwEduPbq+OHncpjlbTg0q11FrUKYUOIcAEnLOJ2ID1K9I1kRTeimWkg8lwqb?=
 =?us-ascii?Q?HOkBJJnSUWdYXNdGTGaxEDsmas7I3MvoIQmtvi9ZeVMSQd6wN8bOXVrUyDpG?=
 =?us-ascii?Q?MqYk9UE+8cu/58GQjs3wI6pQDHQPD02GmndBL3EnfCB8AYyY6aXeBt3h/NpU?=
 =?us-ascii?Q?NFVLiEyZREAGB1fhHb7GXif3m+j0JvrblRfseDx96DHa0/EDpdBiKbgKCM1+?=
 =?us-ascii?Q?nSLI2dMggAal4tkui4F8EF3O9+D+Q6l29oUsKaC2sUO7ThwgwY4zjZFdHXWs?=
 =?us-ascii?Q?PlZeih3I+QdRt5yqjys=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78982f02-5198-41a2-e4eb-08dac965ceed
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 13:07:12.8329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OR9LFKRaiYgF+5WDgnDurP9xgwX+iYmsJii9fgwOxn4xHqlW0Ku2orjQVmtM+Rj2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5098
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 01:34:17PM -0700, Alex Williamson wrote:
> > +config IOMMUFD_VFIO_CONTAINER
> > +	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > +	depends on VFIO && !VFIO_CONTAINER
> > +	default VFIO && !VFIO_CONTAINER
> > +	help
> > +	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> > +	  IOMMUFD providing compatibility emulation to give the same ioctls.
> > +	  It provides an option to build a kernel with legacy VFIO components
> > +	  removed.
> > +
> > +	  Unless testing IOMMUFD say N here.
> > +
> 
> "Unless testing..." alone is a bit more subtle that I thought we were
> discussing.  I was expecting something more like:
> 
>   IOMMUFD VFIO container emulation is known to lack certain features of
>   the native VFIO container, such as no-IOMMU support, peer-to-peer DMA
>   mapping, PPC IOMMU support, as well as other potentially undiscovered
>   gaps.  This option is currently intended for the purpose of testing
>   IOMMUFD with unmodified userspace supporting VFIO and making use of
>   the Type1 VFIO IOMMU backend.  General purpose enabling of this
>   option is currently discouraged.
> 
>   Unless testing IOMMUFD, say N here.

Done, thanks

Jason
