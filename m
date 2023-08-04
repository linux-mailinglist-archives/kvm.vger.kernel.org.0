Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF082770770
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 20:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjHDSDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjHDSDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 14:03:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B98122;
        Fri,  4 Aug 2023 11:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNHAt/wVSXnqpPwZI6IGT8BsRp+UFuHrzBRG2QXKwJdPyKFAqw3a/W+fjsKTMmiz3nUbBfvKi3RRsUep/Aad/XUp1WKxG2YI8FkR15KD9NO1bN0b4BqcpTvO47HlVFvK6njIIbqb59aPkbtz5kRj2qT4O+WyZHhE7V+FJYHhJ5sdNvxKERyZq7cjnFJcRi5pLTgBb/KQUfz/d94Q2HRJV6TZfpBAjxSAsQ1dCBM7GsthD/FT4qMwAPMzcfV3lP/INpatzgPIy5CeLHuleRPev1VzuGcMc2uBueJoVFax0DMAGUiR68I6Cc2+de+EtHq6y/dgUYdfoVI5FQEj6qq3sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvAdJYW8lrXWPRjKgtZ2/E93aGgZU1Uco0vntaa/fWk=;
 b=oV0INUz/Qb/fUyU3J3jykr1OEkvi/pv1xqaJh5anKf2M5/VhhV5+suB801l40yfW12ASfxd2QtG2MnOsvkR9UHcm8RCL42HrKMXeavu0Y9cHn5XhfdLcm1lHb11ldRjuz/xg9dXu4evEfbsRYnknK3XdfSEpzD5geYsPBTVoEEZrFoBDFdS4nrfvcVxCBwR1//2T7c0MO0VJ9jHz4ekg3JGOtucY0o1YQWq7wokVet8wXyO8N7aO47Iee0zrj3PtLFGsBVfDLIDh30vFdhb3aRLZO46Znwstv+/qGcjY5SaEvbQ9+wAYLCTYBwqANozgYDxR/n4MWxVJDmMHoCaKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvAdJYW8lrXWPRjKgtZ2/E93aGgZU1Uco0vntaa/fWk=;
 b=r93ptoDVSWOSi55G+sp6Fc5AOuaH2IlkIL/dLNUlsKHMNk5R2ACtYvDytXGOD7j0YGMzr4YcD7op3l5HxWMxUzT72qUq1PFiCJNvpIWtNTusR1n/EuEKiluPGFPCyflV9DnbeRRXfuURsYfWScnpIfteoMfIX5Nys9+ICw7cIx6p3RWMIVJXqx7LnS3egEpieKKX2l3+modDmYoNx7UAE05vQuLR8bbwHmuMSjIpux6amZ687NWutv9uJhAjiB0hP9js/yXtsu9IPHyeg0sUvNvacGLzT1UOHUwa9AcF0lGrj5Wth26h524P4H3/t68nFTs/rsG8fAiTXEh2PJY1TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7657.namprd12.prod.outlook.com (2603:10b6:930:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 18:03:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 18:03:33 +0000
Date:   Fri, 4 Aug 2023 15:03:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, simon.horman@corigine.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Message-ID: <ZM09c8IG+ba+fdts@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-7-brett.creeley@amd.com>
 <ZM0y9H0UbHHW8qJV@nvidia.com>
 <73aa389d-7ef6-5563-0109-a4d6750756df@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73aa389d-7ef6-5563-0109-a4d6750756df@amd.com>
X-ClientProxiedBy: BLAPR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:335::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: 25221940-7b5c-4f66-5b81-08db95151db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCtPdJ1imODq+/N+GSOVDNUnb7wzvFblPFONnGlY3h3azHj1Ji3swaudTOXp4edGaheNzVoL8AnUO9/asbaZ+0ILM9Z1mlzc6zr+MZvpq4+Ha3uatOJiiEmj6S8zm1XIK2MJihf0QxG7TQvqKt6nZlNu5J+P8GH9Yto73UHtQbC/w8IzpbprQU5TIZfG8JSRXt1hlTnO3Fz6yR0F27bWh3VfEPrKTiQRcsP0NFY73HewkmcK3lZaa6HjvktiOEs/HOVaBevfKfR9to3Ermx6Hp2AuZImgy5cuUXfKGym352mpkSvf30A7pK5cMnHGLzRF6uztNr5ijIRwa5Y2KJF0E6prze8xwbuE5x6zcnvR25C4T67vpVKl5sgqArVB+1aLl5ueIlgaWPW8kgProCXij5HOQLStLge3cHZGvkIap6vEXt95HdC+4cF4KkejNw0frzGdg3hNt6+oAR7pXXSSLJ1uMAV/b0UN6WLE9y1yRnvx1OcBZB10PAbjlyI3NWDJlhdcR+sHUx6HvuaPk1IEjOC39ejassX+R/YoRV1wxT8zaIZWjhpO/KHvvajYZXd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(1800799003)(186006)(451199021)(2906002)(36756003)(2616005)(53546011)(83380400001)(26005)(6506007)(86362001)(66556008)(6916009)(66476007)(66946007)(4326008)(38100700002)(41300700001)(316002)(6486002)(6512007)(478600001)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKXQmZH92bsd39DPxUYeRlAOu49YHCaZEUhlwtbMdjh+Fz+aoitUzUbAm9UC?=
 =?us-ascii?Q?GwNYQhHawVn0nxMtZR653liFpBagat3q/3TGI8dHft6nn/IqVm3xqCpiVK34?=
 =?us-ascii?Q?A5wg2vwTA9ya1/oqv6TO9WzppyA2CFI6ISJCJOBUSUy7cVo59mFEEdo3ac2X?=
 =?us-ascii?Q?ufN0KYBkWMl4HiHobRhn7apbbBsHLezt3zvAbOKq4SHtjLw0hMJ0LrFY5we2?=
 =?us-ascii?Q?JM6vcPxlNWPh4iWVr6XB58fHChwDFPEAisxtGkA8wj9qjbfWBCmYGdDrR/i9?=
 =?us-ascii?Q?/h4mx1EUrS1W/nYpMlfAw3EfShZLFTQPs2wM6+CdC7XJT1P86NHvR6UOGVYb?=
 =?us-ascii?Q?qhG9hpuHS+WLGpQdIn7eM3jOjfTMdusG5iPAIBlSs74zFsLJPmabk+RDFwgo?=
 =?us-ascii?Q?dmjRCJ1XkCqt9tTr2tE4FePDipuJ9aYIYVP3ujuXpYB9vuhNRy+wmECIdDIb?=
 =?us-ascii?Q?HvJ0koLb4K00uKdlsKtZ3vHDURv3DzJ6ZAk2D7v5vU6BUZxK+C0zD6nENKII?=
 =?us-ascii?Q?zeHVSQ7z8W670pl1KFg1eq7ZvM+DkViqrMyup7aafczUvKbvxPX4L+wYYjHp?=
 =?us-ascii?Q?7rzDXUa6HMVlGkF85uFYKbOmHPBxFYWpZxbmbWX53nLBMiEM6CD/Xgm8PK2f?=
 =?us-ascii?Q?bYqwa/dXhYFKuCXUAVLvYkVMql6jYdHvtS0GgTRjwe6VrIVTg6Vz9e7/Ah6q?=
 =?us-ascii?Q?oxfM3Rv/pJ4CrrCtZaIbbeQKA0LRSPaJDntIOF4zG6QE2AC+tOrEOHppm7B+?=
 =?us-ascii?Q?tkxWo9ow9Pui2PQ3poG1sHtB46Nv6CbGqUbW7pIk2wWMc74acE0W+iYuheuA?=
 =?us-ascii?Q?KA92Xrv13IGDrwHhMrhgZ9PBzVDQsDctvLcY7sOqF/0XWAqMXWnVzR8cJ4DL?=
 =?us-ascii?Q?iNP55aOkeoCDZWqb0Kakw1cLuglXiStAxMEUiYJHVcBtHR5qiQbWkdGBPi+s?=
 =?us-ascii?Q?UCWKfyBQ/Asig73iMxoMEq915jdS6HIsyrBaC7DkSHMyUXtLwGaNf/wumiPz?=
 =?us-ascii?Q?OKjMl26yqQjKK6qfW8vxHqKY9QRNJNoa838CuOrCFprxktuTFNlraBxtGg8M?=
 =?us-ascii?Q?C8ToGPwuyXYXqSpnqUyDVx2wm+pzLxopgXaybVLItaAnlIQ/xcyRP7McfMUS?=
 =?us-ascii?Q?m47gdZKGJCMIm4tnsQCB7DE1LVbb48UI7CFU612Hfu1JYa9ceBDl+PT/j4Lf?=
 =?us-ascii?Q?cZbc8VpkoWZefaoIB73KTuZvHqnkLU5u7uOnxDDH+eKxeASvwkwAvY1p/8BG?=
 =?us-ascii?Q?wKPh+wz/igEaHbqS2wEam9Xj71zQrRUOeNfiuEq36o95htvwkuRH1+F/Ptjb?=
 =?us-ascii?Q?MFmph8hkaJelxNl2iPFkaB7oZEegqMqde15j/HaWz2bBo8UBsqoKvr51imgm?=
 =?us-ascii?Q?sg5tCQjh3P20OO126aKfQO5t7o9HGiBKX8xYWAhudH2jETXzoNCeABtEa6P+?=
 =?us-ascii?Q?+fUUcxEwUfLOrxxX97Cr/geT3rN9z+zsA3+XvdbERnCnqGU5ElQvLRH8n6wU?=
 =?us-ascii?Q?n7rOvfod/UM/W+n2jFEbJLdzJ+OVIG9nBR989oZ3DAjs5jeLhPpYyPxLMSbj?=
 =?us-ascii?Q?OAqHokj4v7gQxiFEA2kInAnEEbZnSK7vZHudlci+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25221940-7b5c-4f66-5b81-08db95151db1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 18:03:32.9626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAuHRgajwTh5qgY+DVh2ZaKgKYbCGNJc3sYmCgqVqcR4ROBtMz7CotigPQME3Lyk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7657
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 10:34:18AM -0700, Brett Creeley wrote:
> 
> 
> On 8/4/2023 10:18 AM, Jason Gunthorpe wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Tue, Jul 25, 2023 at 02:40:24PM -0700, Brett Creeley wrote:
> > > It's possible that the device firmware crashes and is able to recover
> > > due to some configuration and/or other issue. If a live migration
> > > is in progress while the firmware crashes, the live migration will
> > > fail. However, the VF PCI device should still be functional post
> > > crash recovery and subsequent migrations should go through as
> > > expected.
> > > 
> > > When the pds_core device notices that firmware crashes it sends an
> > > event to all its client drivers. When the pds_vfio driver receives
> > > this event while migration is in progress it will request a deferred
> > > reset on the next migration state transition. This state transition
> > > will report failure as well as any subsequent state transition
> > > requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
> > > VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
> > > reset is done, the migration state will be reset to
> > > VFIO_DEVICE_STATE_RUNNING and migration can be performed.
> > 
> > Have you actually tested this? Does the qemu side respond properly if
> > this happens during a migration?
> > 
> > Jason
> 
> Yes, this has actually been tested. It's not necessary clean as far as the
> log messages go because the driver may still be getting requests (i.e. dirty
> log requests), but the noise should be okay because this is a very rare
> event.
> 
> QEMU does respond properly and in the manner I mentioned above.

But what actually happens?

QEMU aborts the migration and FLRs the device and then the VM has a
totally trashed PCI function?

Can the VM recover from this?

Jason
