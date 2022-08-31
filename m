Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454A55A813E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 17:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiHaP25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiHaP2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 11:28:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1B1D7D2B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 08:28:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzCXuBfytKGOGRX1CfrFXrr2/14v5TOMwpWweUN7sUIEDTNekFYiUrDTywwKfJs11dlUNGxNYGBeTUDqaP/ErSEnAHUQ3PbzgxDsKcO5A0G4rd2luKiIbezh6VByaO2vzkuVDAJ/cSpydG6SKPiQj9CBuUefklYwIlFHGceLdNDyQhYyZOlLEmY58RAJPvyxpGUELEhLTIFI55zehYMGV3aOwIVXyOglsfwjX48AiDQ6HTZgPoM1PrZZCTb6InBx0AnJ5YDYyGiqvQ0EwvqQTez+7xibyzXHbuUdFszfP+TQAS3lMiPlu7YifV+ikFV689rpGhv/Tc4/o6XFvXvtLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WOMSUmZSBuHaHjMHFayTE7az382HqmhInRWxyVH++M=;
 b=kngh8+++5/iISgzU94HgXFRVWYWx1zNRe9yO/kdQN3BgJkAeppDXIfhEFdoMVv2pCKPw2VvDsH+SLsKWwHm5ory6V298+bCj8V9uZBEGuVrWhSXY0SPuK+npfp8U9bVxqoMh5T/rpc446PJxPBbeQ0fy20G/sVoXbWqpPHnMT4wmnZeQVsA0Y9LBFanxtJ7b6OV3VOvP3lsQ5+ABGrOg4R+681uaYXJV9aPNvhPQUlpNLPlp0EMi2QxaeGstphiV7BMhVrzR1JJUvYi/KDSkPIk2fVJ1tmt9o1oxAWoxFehc6sZ71GuPGBftb9K0pg9yw8hAq3tmyse7lgfNuXeJ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WOMSUmZSBuHaHjMHFayTE7az382HqmhInRWxyVH++M=;
 b=RyvC8EgKSs6utQJObgnclY9oipY+o8Wahb7zmMQY7u6KC/1fk656Olpqf2JiF1uMZiRgOz8M72JXFbVq3T3pe/tWSfpfDwRxVfmetrkU67/H/e2dZYVYBqzh/Y1+58lDhrT3kL3a/0cfQ3wK3hBHlCnKiYaEDUc6b1HWJ0ERfkaRzOIqwWTPnABIZ62U/QOGaBXr7CIAl4dF2ocRO1PCf4SEGn8BCwK3K/xAQaCSaiiURDETVE0bGV3WOD3h/6KDxoJNJPuJ63flt4AU1M+fgzd7hmKRX6BYr6PADZEHGYNTwKWm/2uGsokHnp+mu81XTsW0JTQ0lX2FURq0IC+uTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by IA1PR12MB6385.namprd12.prod.outlook.com (2603:10b6:208:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 15:28:53 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 15:28:53 +0000
Date:   Wed, 31 Aug 2022 12:28:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Message-ID: <Yw9+M7qWo8aLMpb6@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <4-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB5276255A50937E1D2C3590B88C789@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276255A50937E1D2C3590B88C789@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:208:134::18) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a7fc523-01f4-4549-ebd2-08da8b6582b8
X-MS-TrafficTypeDiagnostic: IA1PR12MB6385:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZQmXqYCrKHBDPiSJBl3s8xsxy/yBryAkM9KABK3ok565b6LjT1omHC0EufHcDUQzxzoEjk+hG84OfvGqGVaP+ltvQ3qQM44LhnKIGvqnQnVNzylVhMoa4xmjBTwzJ2qqtaimwpZENHx01yYJGe5Dy03Dw1cHF0O+qBwoQ+Mj5F4PMQR7DEu9/sgvWe2fxyDJ6eirLlu9UwZS9TELCJMvfVKbooGMXNKySDs4cIWoMbz0Z9P2lahBDGnWm++RsCJFQ2yrvmBuT+H+cm0Xo4AVtqqTStaXWD0VUAJhliuHOb5BpaBib+SaAkUAc7a+7FqZntIr8FF0wPn/dNAqDTct81OUgcxM7Qd2cFb91Orsdj37KTXAQqBqgU0edF5XX6VaMqedeBgubAVyysHrCzU0nxP2T8idNBBF7Nhd3rwuJz8FIlAJad3iJ26LCZSwvoBDEOndJQ1wrv2zKcdXNDIUf9JqMsb8jiD9ysYzcTuCaOQL+2JUNHdLgDQNS+JOFXkGOeZu302ggjsT7ka5QqT8b/Vnbu86BrXOUIB2DYX+Bpggfe/A8G4Kh8p0FJuP/ao4OoK8ddRgTYI1zEOzN2H92/tYXqFprQK9wD6U1oBqVfdHRp2VFvZc2t6UJAHR6OxyiUU3fx3yTIwdYQziQszBNh8O+0zjGkLHcC7jKs3P4DHwdSIPi6fXZyadwvzj0Jeox+lISwGOZcLFz/jbYG7ZODdUbwXOGzRjg6JUYLHaLFjS0TLQjHwTNfYJ9a01wpi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(2616005)(186003)(6512007)(26005)(6506007)(36756003)(2906002)(41300700001)(478600001)(6486002)(8936002)(66946007)(4326008)(66476007)(8676002)(66556008)(5660300002)(54906003)(6916009)(86362001)(316002)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtI94esvHVPikeyGFtXOvFnEsxym4Wo3/5qb+iSee4d+X5TC1JBZQBkns7TR?=
 =?us-ascii?Q?/kNc364JqIw3A95cB+3nWsAqv7IaktFWc6N4Mn/0E5RuenmoIgnFNB4GMKTy?=
 =?us-ascii?Q?Km8lyBhIpl6Hadz44uY7dko4E7TZAM8isY3wEf3nqSRS/4Dmu08rd4E7L2cV?=
 =?us-ascii?Q?H2B6vfyIU/QZD/l83zbtPZZBKmPTb5kS/K5MLTXwzZanhdEyxX2SOvkFoXOo?=
 =?us-ascii?Q?1uCvInm6Z1jsqoUcKTGXL+U27hah3CcX2JZqVnOaMcybGWMR5cuQGoCKuT9i?=
 =?us-ascii?Q?70+D8ThkObPV7fLNg03LX5iS/kefhRi7BgtCjX4u9UUEqP1FFQIk49yqE+7C?=
 =?us-ascii?Q?YuuADMC/KDWPvtmYuIDogaCTZ9t63ne0MuaO4waYvHqSe5utgypoPXJaWM+6?=
 =?us-ascii?Q?uRTqR2p9AYz2vh7Avbzx8Wyb2aGqLSzl9vXmzaPE4ouo+qyouTqjGYjCGCgg?=
 =?us-ascii?Q?vRyE/3wvNNU69cDYnU1oYyWZSROSt5EY2okRlfwWExdO1iNJQYo8FPXPV1CB?=
 =?us-ascii?Q?s1+XBk0MS4k67M07RamFOG98ZNL4T/mccAt7GmA5nEX/fzckF+TYPA2Xr/ug?=
 =?us-ascii?Q?hG9064SGi1by5hTm3S9ULD6U4vPsJfiA3rxB2amfVU5zTg2dUWU+GeZUghMP?=
 =?us-ascii?Q?llJN4Lcob7rCmpHuIfbi0QoNyo1riMuLfNXOYH1XWhYxTGZQ0l5D/oHHlWWI?=
 =?us-ascii?Q?WMNAi2zvC7tHE0LyWQnbsqw7foAxMtDJcsB3DsKD5NGnC0mdf2nsW7ZAa/Wy?=
 =?us-ascii?Q?1mChDEzLnMob2/1WZvplNVbj2G8zOVl87UPhAPVuKzAVFPOtfvZg2uI/l/Dk?=
 =?us-ascii?Q?wgT3uAe6aBiS8V8RSl+Pfotfz2PCnp7tbXZvZSrpdqmdI8Un4BNHHpSHtOpB?=
 =?us-ascii?Q?BxP2ePa1rZBgQgGK1/WsCaqXptJKn7QRZTZe71/kmh/qMdgHi6SZrwSSvrhN?=
 =?us-ascii?Q?71swJzDVNZddNTamWbcUmJdtgCaD7lHrEu1NNEtdVXLsykmvzLe7SMAfe842?=
 =?us-ascii?Q?N+JP0RXzo53BuNUm59SG5vZ3DH5cr6pmiAHk7dI1mbzZMKWZlaAni0rVYJ3o?=
 =?us-ascii?Q?eOWOYJVRTCX1exZdzvCZcZqdxfn+au2mR7jeP8vx8zDtr8WcRkejp0Bi1wyg?=
 =?us-ascii?Q?RwXvOtaVTFMc1YkRgQqYSoIOG0oISNOkKVWLqEzD9IU2g5xN/WRONaBk3c56?=
 =?us-ascii?Q?Btl1z2cVAiuyUiXBOU5UhrLSG5Iac8TgwsPEwNJJzdLOBkvvH94gebWspfSn?=
 =?us-ascii?Q?fPqolXYPCm38glTOYYVCQ5OFaTyW1ubmSrJEs9TOX+vE7WZz9pegOckylh0D?=
 =?us-ascii?Q?t8U3ZjePwq/MmcnHexOCd4LA5WSRm2gY3nLuyB4RnqOGLCDuJIf7ThY3Qrr7?=
 =?us-ascii?Q?AMcYA4BdThNKs8ITAonSdLD1O+fuPZN9/6kEIWnTUJaiU1xtlIT30q7G89hU?=
 =?us-ascii?Q?dS+h0HcWx954/BOeXo5RQr1+EyMfaXR0y+LbgjAZeVVMz18fm5Ra5gk4eZPp?=
 =?us-ascii?Q?Jo5hyqBTKQ8Hyj5N1kJ/ycN4anhtyZvRBPopGtiIy1ZvVRFS6fVsFJrWfMOO?=
 =?us-ascii?Q?8OgZfxF+7WJJBfRVlOov9nq3GAVfsi9/rLyZie2i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7fc523-01f4-4549-ebd2-08da8b6582b8
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 15:28:52.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YYq0DfsTVMUnBYosp1MtY1SHg9VpJzLUzSxIZayXDpjMGBe2m087F0TbGV9CtJQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6385
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 08:48:55AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 31, 2022 9:02 AM
> >  #ifdef CONFIG_VFIO_NOIOMMU
> > -static bool noiommu __read_mostly;
> > +static bool vfio_noiommu __read_mostly;
> >  module_param_named(enable_unsafe_noiommu_mode,
> > -		   noiommu, bool, S_IRUGO | S_IWUSR);
> > +		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
> >  MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE,
> > no-IOMMU mode.  This mode provides no device isolation, no DMA
> > translation, no host kernel protection, cannot be used for device assignment
> > to virtual machines, requires RAWIO permissions, and will taint the kernel.  If
> > you do not know what this is for, step away. (default: false)");
> > +#else
> > +enum { vfio_noiommu = false };
> >  #endif
> 
> what is the benefit of enum here?

It means we don't have to use #ifdef to protect references to
vfio_noiommu. Do mean enum vs #define? I prefer generally prefer enums
as they behave more like a variable.

Jason
