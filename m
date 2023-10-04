Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAC7B7EFD
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 14:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjJDMZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 08:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjJDMZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 08:25:32 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D197FA1;
        Wed,  4 Oct 2023 05:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfNZhZ4qjH89y6OVZZw61+p0nTpFZRpy8zH4ZsdF2evZVjz1oh0V7vO3Baqg5kH9MbLIduCIz1gludSTWjnq8VAzI2K+48sY4dtfhPE+LjJlQpjECOZErYJmPO7wWNkpZcnKPpS5dtkKgCCFtMREEcXjXpUySZnvjUbcbhuaizhupmbvzmeb975fE5sGtjb2W+MlNm5pv5m1s7q4v6xVH6dWjKnPkll01GHMGcTn1Fqq1RvtJp1LgcY1hRFGfJ6qJTJkYhniiK99S4ot0FdFBYouOp78sY09UguWld9g8RHk81DcwSme6uxCCgV8RWe8HCwW3xZaVQ4X72GJ9MhWnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/VHP/0kEQTKzAKfBxJAw+JgctJ1gJGEwnpSoMa6QUs=;
 b=iNaxBM30HKsAwHUXXHWkCRQvcXvEi4Zir419eAGgFAx+i6jwJXVdRiU82l3ntazHqRSb7oWSJCUuhx2SnjbKe4F7n+Pmq3bxYKDTucf4BWhsKUbqGJeThWtpIjKzQw+EsYtrFCsgjHc8J08CuIT3zhQRYR3iAus/gFwzlRi+H+4b99rULzBTWVVXKH2DCqN0cLwtA9f00p2R7sTYoG9Skgd7HKfqtZqsZnpRlON4TvHyKq+hvohFh+SPNMR7eVbdSZBan0zzBEOA1TiSGGEC0nqnjnXRDKbDxQ2mb9JI4YOB1YxOxSi8UvJN89bbA8YbN+p1h22sCnk+51PMZT4LBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/VHP/0kEQTKzAKfBxJAw+JgctJ1gJGEwnpSoMa6QUs=;
 b=spf3MJ8WDbrRmuO2r1hcSL05DSul9LHtu6cUf+9Rs3ZXZhip9ljsBBhs8CUaBDAUHgfTSqF20Ebnfh0078qF8Qi1umXxDwwwREoeezmdniE9bDjNUkY6zWzgxgg73pAdj0OKjMHGrThL6H6vF6PIlfCmJCZOCW3RK+bgp38gC156Tom6JcsE1izTp9nQnvRl2HwwCFtZ/ogy5j4jWsIRe5EYN2hykMGZdSQCqqduDn5tCcuvfgREmGwAuKiGcYXX4jIwU4Ok60l4QOwVRXtEVkIlsPKX/kyeFANURpZndsyD+rvwzc/Rq3ajw9JkK4p+mYTWBtmYqbEJKe/j5yROKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5785.namprd12.prod.outlook.com (2603:10b6:208:374::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 12:25:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6838.030; Wed, 4 Oct 2023
 12:25:26 +0000
Date:   Wed, 4 Oct 2023 09:25:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yahui Cao <yahui.cao@intel.com>, intel-wired-lan@lists.osuosl.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
        kevin.tian@intel.com, madhu.chittim@intel.com,
        sridhar.samudrala@intel.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH iwl-next v3 13/13] vfio/ice: Implement vfio_pci driver
 for E800 devices
Message-ID: <20231004122523.GG682044@nvidia.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
 <20230918062546.40419-14-yahui.cao@intel.com>
 <20231003160421.54c57ceb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003160421.54c57ceb.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: df1e161c-1b75-4a0e-ec42-08dbc4d4fd51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+MCxbcKyiaWdF1FXiT1Y06EnksHpVwMWBbjZECiLGUfLz6gtYBOC86EZNSi6BChcJbf0p4EQ4o4vAbRd8TkY90pp2e9UzxsDw1uK67HrmhyolWTMVUsBw4lzUFuYKrwJIpHJE1vhoizCL6RytfMoKDPzo0sIRWb6o8FNgRypGdslNCAZhP4lmBwqyhESMKVhPFXbYKX0qCgoMYHW8vGevFeaejKwOnas0g3Gq6QNaIkeNP0AVKUlzcq2ylUNWEd9rKtKEjFhfygWs+e8XddeQ5uIZFwxP9ICdGGiopK7XViw3d8gDazKeA3BN4+ilSN2FJGpWxSFHIQYbWw1iKuAw0bZckV+UqefKqcwUor3Z2Kg5zVbgh0pzSlb85GiGWliR28o5/TSFymCKlSL/NG8N1ebXcm6YVcttfGqEfkKjwMsgDrrRcMIMd7KdwB8ed2/kKbjEUwy3SR9D5dQFOrIQSxxUJuojVPE+jDtjv37HVVhzY5TA1/21awdOs1jc4fh+JlNwpym1RpoFVDIejJc5ExdLltUq1E9FkEjGWu2xcrbhNPDwN7rf1c/tFV5RTUhBU2doOWaBuf4YVo+IwVMQefeSFI/+9e0KnUFPrJj8iC0ApxXf2Wbpa2l6iEhaDU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(346002)(376002)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(7416002)(2906002)(4744005)(5660300002)(4326008)(8936002)(8676002)(41300700001)(26005)(66946007)(1076003)(66476007)(6512007)(66556008)(6916009)(2616005)(316002)(6486002)(6506007)(478600001)(6666004)(86362001)(36756003)(83380400001)(33656002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5PfKe07IA86JHNxuxBWgthGUhFxLHHHQbRzAGbS0QiO19gkMyZgGn7InN78g?=
 =?us-ascii?Q?vEADuUZFvXjmSU9Vv2ujtrB7JXBxgjoBYQh2TcWxNh5V/i6XyJBUvdnc5FeE?=
 =?us-ascii?Q?ceFh5+4+AkYOsOggOYFbjtbocXpPJwbFYAit7ay4IKFtlrw6U9Ad4YfDBzA4?=
 =?us-ascii?Q?7dag95cinRh1NrE1k3+pOa6ZBcmabgigu/LkmqFv5oiwk7dBYEexjf22/NMm?=
 =?us-ascii?Q?vGkKYfZQGaxj/k1pZ28Y+0XS5eykC5F4rfNehnaNv1OB2o5KWXAhmudJ3Tgn?=
 =?us-ascii?Q?nWkq/NWuuE2VD8VX+ZQv/QXSF5gOSmwmtbZDswwkEiJGS5Fa60phileqXusz?=
 =?us-ascii?Q?hY3Pj5w1yDdZ05C6xio8aUZAlHWAOL4kUyhGeuzA57nTJKUddyDDPKNUFb41?=
 =?us-ascii?Q?va5DAOcilaRWEf7lIHO1DrfJa1Dn4Vs45mmeGupyYFcnqIZ95kef+5WFmbUc?=
 =?us-ascii?Q?T0XhUOEAJ+IgDcHFc7P7QClQhThC7WEw7t6oGzeuE2skvC2nt19fFPHLOCpN?=
 =?us-ascii?Q?A94SeGzIj4JGKjx0hzBCWFbzihMYvYD1akq9KYAPDMKhjmP5fbqzJCF3czzV?=
 =?us-ascii?Q?wobHeSBDftXSTB/wpLur/5f6bPSXGFQhgFE35xiJQkH4AFTqDnZ6bsrqtzOT?=
 =?us-ascii?Q?zI5Mojb+5o/9ckr7gIlmrO+NTN3+XIjOV41lbhOEwBIBoxN7+pkhLUzBYOvX?=
 =?us-ascii?Q?Sqx88/T7MLOH+zDsu435mKWVRO10zfHmxGcm4fQUJoB/i+Rr7se7C9oBcIys?=
 =?us-ascii?Q?ljvqbuGB3gEhA+tMW2OUC1bQY2Y9c6Rve14CpWtV9TpMPwfF4B8lrDfpdRVU?=
 =?us-ascii?Q?sliwZUsH6FRtuO0w7b1R/ZMBTYkGu7KUOsvSvXO2Jk6bOBZclhd83Uu09CsE?=
 =?us-ascii?Q?xKVDvodiwzRAL6jkMBYdwnjcmEuOuyOCIKWipQWn2KX26Qzsn2VI0opXktsy?=
 =?us-ascii?Q?NHazpDOdknU5w1Xg6qcGZeJuQuVOzdGWIhlOvg46zyexmlPV0vrpqwGRG76N?=
 =?us-ascii?Q?ev85r0QlMzF41dXuzXukKEQJmIKgJEfOTsAFyfqt0xRKSSx8g6tBFrZ0KaGS?=
 =?us-ascii?Q?AYFZt1xlpMLGy702ePXNKU03yuZHzTJDqQ+qJDqDW/cwoBfyXJ8eYOu9Mf9h?=
 =?us-ascii?Q?udtTH07IKgNsvaGfz+n5ZFER0I49yXNAQThtIQ7mlLA1X0EtqWDRb19sWjZN?=
 =?us-ascii?Q?yqaQDmJOvumPpacoIkLhVPI0RweCV6QquZb43aFkA82NdXUsDH3abb0n/lU/?=
 =?us-ascii?Q?GtLidyxMMAgYPLpn305uQ096KaOZ/iLASHrPHYIyS1lKGKXZxKVdU7dIpHyK?=
 =?us-ascii?Q?zIEWUeLcieIdqKFqYUdmpNNEaR8cUXFXWTpXuYnY5nBwINkoZOxcF76p2HC7?=
 =?us-ascii?Q?AjmHeD4CAgiDkE79IO5qFq8aqagO+9saw0nuY58kPOP1HgulWs0mIHy64sZv?=
 =?us-ascii?Q?jSXOgSL/fNrFyXGeFN0pjwPC7hVziJUzSCXomsNIbWqKpooFIqDtbvu2e+e/?=
 =?us-ascii?Q?3dnpaWfYBmfhDs5iAqc1Rxhhba8gOBl579DaZwPDOW/TLBgDGKT44HonvQCd?=
 =?us-ascii?Q?W4E99MId9iXZ6rrrRGpZH5Uo/XGFOg13becJCtMw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1e161c-1b75-4a0e-ec42-08dbc4d4fd51
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 12:25:26.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RkIdXKVftgZwwTdHxDnRSAjNb9YDbjI9itvY4UVyC8yml8a5VIjS+gWoXlJK7gi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5785
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 04:04:21PM -0600, Alex Williamson wrote:

> > +/**
> > + * ice_vfio_pci_load_state - VFIO device state reloading
> > + * @ice_vdev: pointer to ice vfio pci core device structure
> > + *
> > + * Load device state and restore it. This function is called when the VFIO uAPI
> > + * consumer wants to load the device state info from VFIO migration region and
> > + * restore them into the device. This function should make sure all the device
> > + * state info is loaded and restored successfully. As a result, return value is
> > + * mandatory to be checked.
> > + *
> > + * Return 0 for success, negative value for failure.
> > + */
> 
> Kudos on the kernel-doc comments throughout, nice!
> 
> This appears to be a substantial improvement from the comments I see
> on v2, I'm curious where Kevin and Jason stand on this now.  Thanks,

It is on my todo list, but I haven't been able to look

Did the fundamental issue with operating the VF from the VFIO driver
get fully fixed?

Jason
