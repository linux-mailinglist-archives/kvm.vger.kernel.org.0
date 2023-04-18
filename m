Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE86E6522
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjDRM5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjDRM5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:57:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5090216DCB;
        Tue, 18 Apr 2023 05:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elXFmWFPTJp7EL3VovKS6aX46vgRuiS8JG7pCaGwQ+pEYzvIxpGXBBkaUElDeOAEMc8HhTFfkBRBIANWJ2BfT+kCa/j57Uc5TzlYDV/SXyQuPVBd6f6cOJ8962qRnYA+gYqPU8/uRpbYI01xHnDvPXZ0UcZTHa0jCr/zfNwDeEQZ1ymDRQDzB51gzbbvPCLurg2a81YbIyBMRaQxJQE39ABuqWXUJD8P6hZVUV5INtt8kduhA5tEIATDRCJ6RzWFI0TTjTvlHVXwXQkUG5Jnt7ZOvi87NP8m/6a88fO/b6qfWhOaj1EfTeDpe5Hp6TDrounaPRXoOfJgVX6c/5V0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDcAyBswlzmzvBE2x4gij3yIiXbzoBoD938gox3JbFs=;
 b=U03AOLzupXS5m0g54qwYmyNLmQNGyWmtfz5QJjNDveMAYibKYmM5N+bjxtImzyEzNriiEa7dnOiAIe00S95F87WOSgvM2V6cPGS2RIQ4fGqe3JgxyQ2Jq8kY42l4NCqfYZrPZkNebqFmyNSo1W71x04s1NWlto/sBKjpiCBuKu9peouvJkVSS2h+Q3k3rsVqcGcf4ilNbFJQNqGAofSRpi7+VOLbiOfVjpOGNjd18tjRQjRx6/LRXxMdZ8opryNbWqf1MQZEPgvZ8ZkqcYCuGnkSQNzV8w59e0bFYqoIqUoc/gapvJwizCvp+lSQOC+CflJE+1j2NBEcWmIfV9O6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDcAyBswlzmzvBE2x4gij3yIiXbzoBoD938gox3JbFs=;
 b=JuR+OdggN6RTfrXJEj04y+pMZeKvHfW2Tx3+G36OJZLM01+6J6oyqbwMqL15IhCkZnl2pY47te7KHgIMSvadQg19NBgAlDcb02mNM311fnBcpY7+ObNHEvZx+Oq+yp9TJL1eMg6HTmo1C5aUlCpaoZ5QfK2mp3QK4oPqhHf+lhwts4iIZJz9kjNHrZGXHlP94r3MnMwaaYmXXBf+5qGLz396iSrKiKxmh8eS1M7WsJTLxsoY4y4pZtMXM5xdFB9NDqx0hKZZtiFQAKHyBCmesNzc+rIqeE3H54CPBbo22xXTbGFMllZLNe/s1sm1Ja6zKEW4oC5/Tun1e49Wtgd6pQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 12:57:34 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:57:34 +0000
Date:   Tue, 18 Apr 2023 09:57:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZD6TvA+9oI0v4vC2@nvidia.com>
References: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
 <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230417130140.1b68082e.alex.williamson@redhat.com>
 <ZD2erN3nKbnyqei9@nvidia.com>
 <20230417140642.650fc165.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417140642.650fc165.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:c0::24) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DM4PR12MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec7acb7-30d8-4c7e-7e95-08db400c7a45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGAwFyV+0DeJrRKALZEaBW18UI7fp2W829hJfCI6MGcS+0Ullda4zJ14ABJ+EL/HluDS7gt5Hs/LlrHTnwE2stZ/PR9DBxn+lQwXJAaSqW9TbniA04ogEp64GdU67JnhhC/64cVJviulQ38F4JsYa58ba9019YWTPpuf4l6o9nDoX+yKDgPRS3B6og3CyF1hMniy4Jc9K9lqb07Ortj4Kh5i4Kk4GA6aBY9bSD7lbyZmBkakfqe8BMp0gxEvz7yejUKwEGysJbYyuDKOMXQ3Lz3pU+1V6kEI0la7+7yKZ2uk0/7jv/lmovHlWf2uanQ/pd+0x7YeDAAxoFeQQ+SLEJl0ZUqSchwaAvIpee+gWcZdNjZJl1OBa1HZ3ayMuMhgio5q4RR236KhV08d4Vr3aUHJQnpRSBadc9LVTZozuUppVCh7sXOTq9C2iKJDXM4kfRkALjnI7b6rtSgBr+lKOZiYTgyRnFeO32evW509g/cAKcMAaM1GFmk8CqBkEvZUEbdrqwqWj9BqoY6PjUyp0TSMOM0xyvN0WrtOyZB/n+E0EmTfzs4ymt/5nS66+gypbDpwgUDtzaW07qxDfrpx4Yo6yJvBgQuyYfCIB/GIB+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(5660300002)(6486002)(6916009)(66556008)(66476007)(2906002)(66946007)(4326008)(36756003)(7416002)(86362001)(8936002)(41300700001)(38100700002)(478600001)(316002)(8676002)(54906003)(6512007)(26005)(6506007)(2616005)(186003)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d7e0gvZTzinM0hYUBboJbuLNRLqyycR77+Ymob6HmkZ+MDirQiC/10EG5Qtk?=
 =?us-ascii?Q?6DLFb++w6zsID4ItDvBhurpP6HTKYe90r73j6cQoAg4V41nvOOl5lAFw3VHH?=
 =?us-ascii?Q?JfJY3BC7lCO7IPXhqbv0AJegOCwn56SNw5jdyLb4SwLA9g7k/V65jo9jI1Xs?=
 =?us-ascii?Q?XKjwanZOtLypkrZBRYsfCLhPffmXVZJ2RqnLY5dt+RuuoldZZwJp9seSby0Y?=
 =?us-ascii?Q?Wi2yyn1cj6zYsCRhyjg20W3wphWUIDT3UfOM0yYrMx9gdGBTORoYCllZwksQ?=
 =?us-ascii?Q?4NgC8edydBJib9kxAWZX6MXmWKnkNWf7E4J8vF76SQPfZ0heGYw63ZyS9jT6?=
 =?us-ascii?Q?KPwd6O3np1F/j9mqh/Xecu0o6mPjZ7WUxUjTEbbD2cDLNggjgnaLVU7Y/ue5?=
 =?us-ascii?Q?6enfn4DX6ColuwMdLRUJ9uXpn0WOK/wHyyrzJurntlCk41d6wKm0csgwk0D2?=
 =?us-ascii?Q?XH3HZLRu1KEBhoMCm9UKtbVnQu5V5zI0DeaNy7Ly/rUqhWkUnSjyxe7WbKHT?=
 =?us-ascii?Q?gdjtbRSsJ/sqr7ILz2Kf68ffrQF175HFFMaVuaq/NfiN5CJli2H9mi0yxjZy?=
 =?us-ascii?Q?EF6wr+BY9RYHAW12+G2Ovm7p39UG0ClHd/mHr3x67dO/0ecQ5qMFX+tbSkQh?=
 =?us-ascii?Q?GIMtjzKyEqeMLr/Pw9UIcXLujkz53Ohk5pm7GPIcU+6/cvUp3Tf672m4l2gl?=
 =?us-ascii?Q?MbeVFpkKE5lOzRMzn6NlUam8IAQrknUfSdgSfQN+fsLK+fvgpuWglsKDk4an?=
 =?us-ascii?Q?RseTRKTuvVpp0NFIv6SRK55yKwykgJu3sZvfFFAj3Pt1ePCa93qVB0cCURK7?=
 =?us-ascii?Q?MBiSfCM6Di7hGF4gnqr48SpBbfBBSVsNioDkOT1cyuRX3LsnsiPZa+dsHVWJ?=
 =?us-ascii?Q?ZsdNkQEzmTC5NlT+sq5Bqg8UM9WaZQ+qWHc0XuV5u3jyc/UBKKSiCfXkMoWm?=
 =?us-ascii?Q?iu5Hza/6Wcrh3711SAPm9V90kMJHuy0k6c9sUYsyExZ52cS7TJOsdwCSHdTG?=
 =?us-ascii?Q?n8MfoWF2JmF+RJwrldZ94/zGj3zWih0lvHnkmhP43p6p09v+YNJ2t24aFNPs?=
 =?us-ascii?Q?j5XtRH8wRWZY1GK2bizoRYFLz5X74C8pma4x8U/r7yQNMpVxu3migPGq3oDj?=
 =?us-ascii?Q?oHKHILIVVxYC3HiuM6Km/9cOpcPfxWkNFt2TgPitM3LLuCJxA+vcRFvm8vKu?=
 =?us-ascii?Q?cZbtaNuAh1vV4StJeWRVQsHOq1+U4huqrYeeVdY+AHEZwof5a82oJEQfzWUW?=
 =?us-ascii?Q?jvmvzMbW1qAgDFjkz3OPUgRe1MNAq9y3Jsoa4cim4s2Lxd7bvXCM1Q+betRs?=
 =?us-ascii?Q?X0KITEj9d8PEWkzMIiH6C8PlJNWeESDEk7UY4IDSwz8fRNsaB3v4lJ+V6sSE?=
 =?us-ascii?Q?Elli7T+aW79DRfq7Tu12L7NYvHd2LmpJ1t2Luv4+q0jMx8ZHwfAJlyKHWzDV?=
 =?us-ascii?Q?Mel/k+0hTi+wR8uf3ysl9+pVTmSyrcuHngnLmYSVwLkk17EeVGoKSD4SX6Hf?=
 =?us-ascii?Q?EqBYhbrHDmusTHkmuO4FPXGPzKuq/SBCytHnMp8a/wxF+kKRSm41+SZvZK5v?=
 =?us-ascii?Q?PXcHKNkJkLhPj5DuEnRrxrNKPit5DCCXp1Px+cs4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec7acb7-30d8-4c7e-7e95-08db400c7a45
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:57:34.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCgomJZtSwqbFEGkUxoUeDHcKTfMUzQ4MvXKOkmwqcwwVdyL0NQBjTgEfo3d7WBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 02:06:42PM -0600, Alex Williamson wrote:
> On Mon, 17 Apr 2023 16:31:56 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> > > Yes, it's not trivial, but Jason is now proposing that we consider
> > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> > > this means that regardless of which device calls INFO, there's only one
> > > answer (assuming same set of devices opened, all cdev, all within same
> > > iommufd_ctx).  Based on what I explained about my understanding of INFO2
> > > and Jason agreed to, I think the output would be:
> > > 
> > > flags: NOT_RESETABLE | DEV_ID
> > > {
> > >   { valid devA-id,  devA-BDF },
> > >   { valid devC-id,  devC-BDF },
> > >   { valid devD-id,  devD-BDF },
> > >   { invalid dev-id, devE-BDF },
> > > }
> > > 
> > > Here devB gets dropped because the kernel understands that devB is
> > > unopened, affected, and owned.  It's therefore not a blocker for
> > > hot-reset.  
> > 
> > I don't think we want to drop anything because it makes the API
> > ill suited for the debugging purpose.
> > 
> > devb should be returned with an invalid dev_id if I understand your
> > example. Maybe it should return with -1 as the dev_id instead of 0, to
> > make the debugging a bit better.
> > 
> > Userspace should look at only NOT_RESETTABLE to determine if it
> > proceeds or not, and it should use the valid dev_id list to iterate
> > over the devices it has open to do the config stuff.
> 
> If an affected device is owned, not opened, and not interfering with
> the reset, what is it adding to the API to report it for debugging
> purposes?

It lets it print the entire group of devices, this is the only way
something can learn the actual list of all BDFs affected.

dev_id can just return 0, we don't need a complex bitmap. Userspace
looks at the flag, if !NOT_RESETABLE then it ignores dev_id=0.

Jason
