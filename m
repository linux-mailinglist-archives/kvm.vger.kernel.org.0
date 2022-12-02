Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10906408F2
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 16:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiLBPHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 10:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbiLBPHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 10:07:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D9937F82
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 07:07:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkX9GOQ8C0Mh+yqocimq2RVheTcP4oUBctmvtkuNIXFxQkKELLaOT9+MDl5dLdZAtW2wPLW9Ng7OsyVYChjhxMzWRLe3Wlm6s2UCU2qVsK6vsQzesdRp1/i05zbCaKXWnPMBeuQXFFgE/I5sWFb7JzD+Wi4Fqush28q+cAEzqX9qexwCFztvvU83tLsKvXeo7Xmkp0kACtxtFlW5ENDtTAfnZV9bRO6vVdLWa0GI5cgXZLOOOlmsq5U9fa/cGTXqtSvaB3psDcjMx35jSwmEE0fpPCg5Q49QndDkqxCO9bO7Lj2g3l0iUarXYWmxV3O1VOrNip1Qt8VXE5MPw007JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7EAqlEWzruPDKcfRp1xoJ/LDBfax9DoR0trWgoCqJg=;
 b=jh/Nd0Ta8z4B2PvR1kP/mstcv7jNJFYTTUU6FNsLMzKfEjX+KUNqKxXdZTPuQb6Vfv+2VbqFAjAbqglcpAWbOSBWwvbFBVSRtMxyij3hysKQuoU1YklUYLGjR9wtXpN1a+EM2Zq3T/voxcEb22IeTNUI7Hk6hZFIMfFBQm/nChiyWhCh730bgt4szVMPG7n+9IY3caUdcRjxEC8bBboZl/ikcx50DqqeaTf9enYkCCkK94WPABk5Yy5SDyBCd9pvfuw4G8reP+KeoKlc5uSfaYgWqCpLNdMvYZgeQp++JZHJ6VlAtQgf/oxepyb4R6jNYBEe5pGO4NTGiz3eLwmXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7EAqlEWzruPDKcfRp1xoJ/LDBfax9DoR0trWgoCqJg=;
 b=fshodNUHeOdATFnR5DIKfFJvR0Yt9wV6zP3hh/NL06nQcjEu1aOZldR5fit8CdzgQyb2MFmwErfl1lsrnXReqRA7F3trzhnYR9H9hEuZUgO/SM74mHoDGpNG1KpGUevqOSnpDoVBeEgN3/yP2k7IdTXh88LBciYrLItFvwKx96qDLEIfukSj9W5smJmYF6DgokjvF2Ow2NOe6BYjmXNSyqFDU6PBkV83W68h+dIt/vhbXr9pV0UswRp41vRayBsLoV2emW8jkuFNfI+Szyp/Up3fgZx2+6F+O42d0xMHA3ztISnXNJVCSq9V0jUSDozTFK/YQBQ2O06Qw9hukxgjpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4891.namprd12.prod.outlook.com (2603:10b6:610:36::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 15:07:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 15:07:28 +0000
Date:   Fri, 2 Dec 2022 11:07:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH 07/10] vfio: Refactor vfio_device open and close
Message-ID: <Y4oUrX23H3ocanuR@nvidia.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-8-yi.l.liu@intel.com>
 <BN9PR11MB5276C2D8E5AD051D0DF0F29A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
 <23a0105d-b108-056d-7b4a-1235d5bb8049@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a0105d-b108-056d-7b4a-1235d5bb8049@intel.com>
X-ClientProxiedBy: BL1PR13CA0373.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4891:EE_
X-MS-Office365-Filtering-Correlation-Id: 68bc058e-2f21-44e1-5f95-08dad476ec83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+fpXIbCDOwuSNCVD+vZJGg1lESkY+ncTDcSGJpzlzMaCGvYjLhDRYR1QwAnxDAcwQbzn603Jas8b/60lsNC/CKPb2MimiIbee5lkUJiwyJZdrUCAIfepDjRzBt65thaO0JcTR+6QrS5CRuUCKELHeLHodrEi6tHU1xXBFaGjF4opjDNepcBtzfsIiKJc3NJ5xM2iIkI4vg6LKdXfdUbFXV48EP7ojrpexMVdW51CshVFMBs02BjTC//ycUL79jATXJ1kMhbUS71kHax1Uh7d3DefczRJFiPmn7yndRuFtrlqUZD233uEQZkSlGHrmvoAXRPlBHol1KDYCYh9mPXsnH/pnLnflAPhaSbaTQof9QieQEGpxqXz0gy8l8pr1o7H4Kv8Gyyn7zK0gSJxNNV08but8FGAxWPZR2YEFY9/TEwVCS9alyJzeK9+BKdbp3AgAL5DvyFcm9L1gFTF9JVJFl0XvPvnhFRl7nr6V+ZVdu2JfIuAtMazSLVnvTwWim9jOrDdHc9GSVOVmpvroHucNEFt5RUsw08dHsHjwTL6EWTxMwO7wZY6XIGc2/aR9lJfwlZYDIQdRpR/ySsjhp05klKSNCfpn4De2cRwy0VEfcUipArROANVLubEG+hqKHjAXqHAxyaMuH3qjjXey7duLzREy524sxtkp25cupQJuJUAhj7CfAAZmhMalV8GI8qDE7lMTsPMY6nMGFcCid63A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199015)(2906002)(83380400001)(2616005)(41300700001)(5660300002)(8936002)(36756003)(38100700002)(86362001)(316002)(186003)(6512007)(54906003)(26005)(478600001)(6916009)(6506007)(6666004)(53546011)(6486002)(966005)(66946007)(4326008)(66556008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ui+KgJq6JjyL/RlrnBRl7DYrASIirY1+793tsD/VUrTQB3SEOpf10Qp4Wyyf?=
 =?us-ascii?Q?HOWuN9NIKai/ItjTK6t9Z6w2rRwkLjBbwTXnjqvRcw6z8QJHGPPJCmwPMQip?=
 =?us-ascii?Q?dT0D077aG5KlwSCbRDmGQ8xnWx+lkbUfbH7DgjxWPkKtK5OLiRGB++OGs+eD?=
 =?us-ascii?Q?57mTUYLdYun9be0bXWjFiiVGG1HJfI4qXh6TYYgh9wCvHUpMeCAB5vBvoGGp?=
 =?us-ascii?Q?2zToL7JV/UexYFO1b0sKXfKl5/jiL6Q5PPWCrm5fUKIjL5kKXFEb7S48QUiJ?=
 =?us-ascii?Q?I0qU0N+do69xxkG893GuAduLDNpCn6cfWTOKSi/eF1hOfy8GVAARLAPQ7chE?=
 =?us-ascii?Q?t7P69YuaHuImDWJL0sycqrNapKDJW4RIDBanzBZDdOa1NoVKldRKKJ2EXLrr?=
 =?us-ascii?Q?fNwd1hUmIVJUljF1u/3K1kbaklhQLHVskpga6wvAaM1A2rge9QIIZCC/sZsI?=
 =?us-ascii?Q?scyEwJh0oGyPPnbjBe1UMz7sRNja87yTgtE8t/iIR3ppdzTn+nFaTdtYHHfU?=
 =?us-ascii?Q?BPU5q26BX5y8PE01hP5r9d/87UrLzmgThzzhX17MHPpOTqZk19ONE5yBOxTY?=
 =?us-ascii?Q?S8IQqVmr32ErOzdbFNOpqn/j5wheJ/We3K8lt4gXr5aJnKTICRBP/J6Z7vKu?=
 =?us-ascii?Q?LjnwwiXn/94WCW6sqd/MFnEbWFgrlAGsH6N7e5nKDjMgf42OxVufcjoQemXE?=
 =?us-ascii?Q?nZ/e+getKM31OIxRLCpQXSY207W8cU4wgG2Ajq9CMt5AQJjhIyR6pZAj20ZL?=
 =?us-ascii?Q?fdFw2SXTAa6BRHrNYqdITkKi5sKlC3ykYg6EMgfgRRS+UsgYwUsLv5Mzd4vk?=
 =?us-ascii?Q?yyC1IUCi1FumVW11p5B3k3lqdgWdaCxcui1V/purQX+UF+Kk9TNzrhFzEUvR?=
 =?us-ascii?Q?b0E7mMq+R7xdws6UMYekkuMrLBfr/seGbWctvgOOw1RIDE2w43+g1L/MY9Gk?=
 =?us-ascii?Q?jFivJRwLTzS24FMbXXalGArw+3Voyegz0ja/JGWwOHk+Pyyv0i0uiBXvgNXC?=
 =?us-ascii?Q?HXnXiKVZUBklvR0SuooZcHCW0rqWfse6NfuLQiw/JYUObAvo4B8Mjr7ET8vt?=
 =?us-ascii?Q?7czUSQKJdL3xZ0X6Bp5pGO0ONeOfCFCerkutxCZxMorNdiaPyJRg8HE0cNLe?=
 =?us-ascii?Q?GBavIXVDB3SU/HBDiQH95d+/70L/rx9IurjqlH+rm8YHxGmOjV/m0bINFlIZ?=
 =?us-ascii?Q?du47BnriIm4QA4n48/PsooiL56d/tlXFo5tD8A/hdk0o8Fx4EQx6EjCe/4Ir?=
 =?us-ascii?Q?YANWNr3jIohOvwrVCeyR/lieyrz39qDo86y03vdvzwHw6ODqlfinTFRqaeT3?=
 =?us-ascii?Q?wnn87Xe5gpahDJ+Db1spWAUdSEnjw1QrPskHZdXWpcWk+bbnDZpqoezOnUI8?=
 =?us-ascii?Q?a0O55S3iEPUTfS61T1TPwtH5lv9bEbIcTIa3ClK2GGGi0Jzu8P5IQ9jAKweW?=
 =?us-ascii?Q?21TrrbQozaGQczaIWPJO0RT8XR52RQXBG+cZ/qScCE6qPlBs3u0Mv8EWUh8a?=
 =?us-ascii?Q?H1QQSuAmvGxPcXXDFJwoH5KEqpX1K2X4AamtOxSsmALn7a6LDqG4oHIwxOHm?=
 =?us-ascii?Q?4Da8E7a5MoYomjrA/P4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bc058e-2f21-44e1-5f95-08dad476ec83
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 15:07:27.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPDwI9nhTrD0vQIhITT/id4oJuIUxs+mdOfnoiLlzfin+YE2wvQ7naCZz11M/22c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4891
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022 at 02:37:18PM +0800, Yi Liu wrote:
> On 2022/12/2 14:15, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Thursday, December 1, 2022 10:56 PM
> > > 
> > > This refactor makes the vfio_device_open() to accept device, iommufd_ctx
> > > pointer and kvm pointer. These parameters are generic items in today's
> > > group path and furute device cdev path. Caller of vfio_device_open() should
> > > take care the necessary protections. e.g. the current group path need to
> > > hold the group_lock to ensure the iommufd_ctx and kvm pointer are valid.
> > > 
> > > This refactor also wraps the group spefcific codes in the device open and
> > > close paths to be paired helpers like:
> > > 
> > > - vfio_device_group_open/close(): call vfio_device_open/close()
> > > - vfio_device_group_use/unuse_iommu(): call iommufd or container
> > > use/unuse
> > 
> > this pair is container specific. iommufd vs. container is selected
> > in vfio_device_first_open().
> 
> got it.
> 
> > > @@ -765,77 +796,56 @@ static int vfio_device_first_open(struct vfio_device
> > > *device)
> > >   	if (!try_module_get(device->dev->driver->owner))
> > >   		return -ENODEV;
> > > 
> > > -	/*
> > > -	 * Here we pass the KVM pointer with the group under the lock.  If
> > > the
> > > -	 * device driver will use it, it must obtain a reference and release it
> > > -	 * during close_device.
> > > -	 */
> > > -	mutex_lock(&device->group->group_lock);
> > > -	if (!vfio_group_has_iommu(device->group)) {
> > > -		ret = -EINVAL;
> > > +	if (iommufd)
> > > +		ret = vfio_iommufd_bind(device, iommufd);
> > 
> > This probably should be renamed to vfio_device_iommufd_bind().
> 
> I'd like to see if Jason wants to modify it or not as it is
> introduced in vfio compat series.
> 
> https://lore.kernel.org/kvm/6-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/

Ah, it is a bit late, if we want to change it please make a patch

> > 
> > > +	else
> > > +		ret = vfio_device_group_use_iommu(device);
> > 
> > what about vfio_device_container_bind()?
> 
> maybe use_iommu seems suit more. bind is more likely a kind of
> associating something with something. but this helper is more kind
> of using the container. so I chose use_iommu. But I see the value
> of using bind, it would make the two branches aligned.

I prefer use iommu, "bind" is so vauge

Jason
