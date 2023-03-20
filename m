Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5784D6C1A0D
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjCTPns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbjCTPnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:43:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2C02FCD6;
        Mon, 20 Mar 2023 08:34:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDfBXCI3/aNthKd4rn2O/Y+DQJ+9gNfvTHSLDmDH4TBwe7/qF/LjB2/iiCAG8r9gZ2fEAy9W9supPQWTNMt/mZ1cXf/OzgzOQd90D2BNQ3myXb3eVFZ4Z+f1rXVgavkp0tMIAHx6w3+T8anDKlpv1turklRP4rBk10V2GvZzbGUV6Rjq9w+N5JsXyYFtWGvt0ZhGu79UvTGI0Th3lhlsEcgihSPvCA+e0E9LtRl9EwDaMDikoGwLu15IltK7YC6SViAeolY1B/NX+rCCGRxz9v8bp3nBixMTPLhwD1tvphkJzsRQD4QOKX0DhZGW1W/OO9QDr6F6L3ANZ09p0UOCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alCN9Bn5AC/s4wbfOAVKflQ/4D81fbAbEKUguJtFQKA=;
 b=Mtl3VFbKuNrsoZDXDpOSynfH2hu2dBJEYLRjRntOxH34MTJyz6636J8dLgbFBXcA+e+lBrUb6sMbFriwe2K68QfzXWkJM+78EDejvo7vywkgDeP/Izkk40yPnXpms0XupIvy4aewcvNcPSBf5+HkTzhSUB4PZW3rVxpoVXXhGgpwPO4j7RQH1fG4F7SVjiTP6kN7MysJjgj8IEVcEE9LlL7ss29TDf7Exhwf7wcvYkaMTtQQ7urPIkgw+6pwcKdteKSZXL7NoJtvMqBsOS6Z1BmUpwo6RlUU65R17da7UMSGIeWvRok7us9jVbrgKuRod42J9Uza1KnONjZ1DmYZAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alCN9Bn5AC/s4wbfOAVKflQ/4D81fbAbEKUguJtFQKA=;
 b=hnzyl5MsEsYm5LPqGcQg3J2a3y0hfeVogoQfxFz6Ns5bTy1NNtYOTYAioJFy09Y+n6FZofEzL6ErkMSvvDVi1Pzazl4EPNIv1+2NATod3zu11Tf59nTl5QTewlzMymdxDnh5CYZBvjDlJNuMOAVXOxVarcwKgWyQ0E3jYcwUPf5m6+8z9uz32tIJ3W2ktipxYbIHEPqsdlm1x34GnMq0VJ/bptwPaT7Q20iW3KaI5L8ctl/gywGuCgvRjly2Ti2s762m/wHY7rYnFZfr/OiJejym/6PfFIITCOcZMIhlSYbFuQyiYRy3M0WyDWN/G4uMBU2kQNY5Fvzk/D7wZZtB3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB8438.namprd12.prod.outlook.com (2603:10b6:806:2f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 15:33:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 15:33:51 +0000
Date:   Mon, 20 Mar 2023 12:33:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBh83sKr9NxKM1UE@nvidia.com>
References: <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <ZBhygasrWFAiaXIl@nvidia.com>
 <8129c297-5af0-f057-4dff-79840ef8e060@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8129c297-5af0-f057-4dff-79840ef8e060@intel.com>
X-ClientProxiedBy: MN2PR01CA0017.prod.exchangelabs.com (2603:10b6:208:10c::30)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 98890839-0e5d-494f-1190-08db29588199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEwyM1FHI75B7VA0tVUWDfQvBNHKUmMeccaqJjjiMRc7Z4E+huM9nhL/3/EADnyT3rDth8/HjZjgZe9y/PiiPwnKkXwbWualL7NaNmhsyBCg0axPkEXmOjcvBJzwtPHKYg7LVs+eXas79p/BCPwrWmHEzmBXXwETw6DbQ2dXgKpJMg+GUciDMgT6j/XbAUgol2zwP+8ApGyqGnur7INE+8GijPxWMFP9TC7ulzUAIk0/z4n84EZouuBMEA6WAqapBLpdd/dhkjJPHciDy00fmKPsWRAvMCK/Y6+i+x4ahEgtBOFdbnveyB3l+rg69tlBocs2A69ylWnVSinwr/GMDJmf86uhEYw7FwEAzcVeIDQOyodpR5mAEdZ1CXlsJ/cVdpwaE017NOe/BFREiJh9WPFfTuQmywmrKkwlEj1JlUKPpjEI2PhnOCx/eD3GfTnDYgj+bRbufjeDVbMncX4YLW4TqmhhC+1nbD3/2N27qBlFWhcEXsk1bpGJy8CF6PoJ9berN1f86LScU1OVrb6PH0NfM/LlGB1dJ+yw+nVxK5kMvr1kpg1quAwguQvujqo+GNMrZZbwu8C534Mo0TBgTnx9yYWPaMZUQNSCyvjXxePYy/FZ4QmKbmh4JZldH8f+Lu4ptr/vodUUqURVrlHa+CMJaRv0jh3GDrC96nCvJj14y90oeAqruN2nt5RAsGDYeKjVbbcJCcW2qLuwWcMc7xz9EYA2vw3Z7uVSOxWEDyE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199018)(86362001)(2616005)(26005)(6512007)(6506007)(53546011)(38100700002)(7416002)(966005)(6486002)(2906002)(36756003)(5660300002)(8936002)(41300700001)(83380400001)(478600001)(186003)(54906003)(6916009)(66476007)(316002)(66946007)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+xeSPncjo8ajUFkCRxsV2M4VaBZmrRgTlQWjn9OmMHHxJWn6F3zF6+w2rwpP?=
 =?us-ascii?Q?AnwxnEKN92Oeliq9gwuXGy19gDFZUeRUZwdDFAnAhq7ouBpS+CHdg76Bi7ar?=
 =?us-ascii?Q?SePkrNWkIpIy0FnghZsFu5xrM5bBZYSPniLWCxfbGfr22E/ptyCBDcfDG5sh?=
 =?us-ascii?Q?72jpNmAo8AiA0GkybU7Rg8rFCQjCmoibCeTM6vmNSxzskmNfRP3kxYIreDbk?=
 =?us-ascii?Q?mScXbI8OHONP9SRHWoKs5C5Cbh6gaBfkA6owgo1wQG4LmXenlJQNXO7It2Cz?=
 =?us-ascii?Q?4g8KS5i5FwIf0SuPEiY+ADecXCAociEIB5Q/+OFRlvr59B35PqVL/bT/8VzP?=
 =?us-ascii?Q?ToekxygM0HONdeQwWOEmRnBCgzrXQpIWqj40EJkMrkdtkjiIpkcA2YIauJHC?=
 =?us-ascii?Q?tr6fkm9IWtwdk9D6Xvu1h7MuO1+jUtlEKYGWTC4ML2uVP4JEBaJiPF6l28A+?=
 =?us-ascii?Q?EUYqkoV3wkejvkN9nexkLEBvBP0kAYI5YPvpTOKZqabNFdmAtfL25eL3RNa+?=
 =?us-ascii?Q?vlGeBtuxHDMSCZ1VdB8eN2DhJYmnu9SeB0+MDjX0lcuWVD1ydfaPQBjT7MM3?=
 =?us-ascii?Q?YqCuatyDAnAyB1Yh6h/o335vW0VYTOA5UplnG1aSu717umOknQbeolFmjPpC?=
 =?us-ascii?Q?nZm1pXeF6JOSFYeCjdXk22PnvJd/+P4p4Cy5uaY4PczDDmB6whK4ZoDyj6+1?=
 =?us-ascii?Q?17LgDgOhU5EnLHGzTPeVmuuA+Z7RCUhsRFmDRW2qAshUp5RfQuGqlv4+PnzB?=
 =?us-ascii?Q?eQt3r0ZapyGDq69Lcywev6kcZEJUlQt8/W5jVtt7IdtZb/PpMxWwBT7jXU7q?=
 =?us-ascii?Q?Bzu5wnHN0r6U1yoA1TsrfumvYggwr2asVObxCGHBPplNhGAw+AVUlbULEbqV?=
 =?us-ascii?Q?nhon0pofiQ09BhtR1QaJPAw9vFSJKXPcxfbw6FHZY7LvLftPbS2t8wDxi8Su?=
 =?us-ascii?Q?lDwav7Ba9LVVzE2cWn+iNUm3kCxulFXiR6IcVhgR+Mw/l8shyB6w7YcxEOPr?=
 =?us-ascii?Q?p/I3ep9rfVBFnvUZWqEp0P1v1ESGvI98t6xElQU3ez0avCkB/ciZr+ddA2ea?=
 =?us-ascii?Q?LTD+PwRx1+dXt5wvFKwhLBbNgHQAcpKZRbaVRzkj7TftD5XpgjrrMfxFA9p2?=
 =?us-ascii?Q?FTczVNCrxD2T1pJAljzkhpYTMmR0jL4CfNcrJnc3qtWj9epOMXk7N7RuPYlB?=
 =?us-ascii?Q?Yf0AHMcq/vVExWgIXVyt/dsG40mtxgTfuDtLRwJGJJe6ElDKXAqnUFjgzeH6?=
 =?us-ascii?Q?mG47BtTtFTkkKKts3KN+y0wXRuYKOxxEeYOgLcl26KHdEenls5fRzLyECGu5?=
 =?us-ascii?Q?QZtA1EPHK2qDOFOqrydq0D2yypZqYchUcyA6cnd+4kgASEMeU0GzSHZeyaKq?=
 =?us-ascii?Q?/qA6AkCnpwuUv6LEGgU/79cNIomEHqMYsayt0UBr2dLII4ZajEFPDWu2/GdR?=
 =?us-ascii?Q?24YLiuOWBYG7/Ykw2KcDjfzLMxJzMy6yzP0xbf31b/AUXNqGT+BG8U+scKz6?=
 =?us-ascii?Q?oF0Ot5gAEltHdZz++lH6a3ibr3TnRO255Y+BsQHG+wPVu4+YSAzjiumxprmK?=
 =?us-ascii?Q?VRM6cEVM7sgiwKFJuDe+vBijxDtBM/rWboB18IQE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98890839-0e5d-494f-1190-08db29588199
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 15:33:51.3709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABd6XxWsbqi4R7wTuYamQ8+hnHbgdo5OYXM3TEqSz/XaeFgYZV1g2Kw6ziG7u8Sw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 11:11:51PM +0800, Yi Liu wrote:
> 
> 
> On 2023/3/20 22:49, Jason Gunthorpe wrote:
> > On Wed, Mar 15, 2023 at 02:03:09AM -0700, Nicolin Chen wrote:
> > > Hi,
> > > 
> > > On Wed, Mar 15, 2023 at 06:50:53AM +0000, Tian, Kevin wrote:
> > > 
> > > > > So, this preparatory series will add a pair of simple attach()
> > > > > and detach() APIs. Then the cdev series will add the locking
> > > > > and the ioas_unpin stuff as a rework of the detach() API.
> > > 
> > > > > I think they can be something mingled... the sample code that
> > > > > I sent previously could take care of those conditions. But, I
> > > > > am also thinking a bit that maybe attach() does not need the
> > > > > locking? I can do a separate replace() function in this case.
> > > > > 
> > > > 
> > > > w/o locking then you need smp_store_release() and its pair.
> > > > 
> > > > anyway it's not in perf critical path. Keeping lock for attach
> > > > is simpler and safe.
> > > 
> > > OK. Basically I followed what Jason suggested by having three
> > > APIs and combined Kevin's inputs about the difference between
> > > the attach/replace(). I also updated the replace changes, and
> > > rebased all nesting (infrastructure, VT-d and SMMU):
> > > https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03142023
> > > 
> > > The major three changes for those APIs:
> > > [1] This adds iommufd_access_attach() in this series:
> > >      "iommufd: Create access in vfio_iommufd_emulated_bind()"
> > >      https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dcca5ceaeb40e22b5
> > > [2] This adds iommufd_access_detach() in the cdev series:
> > >      "iommufd/device: Add iommufd_access_detach() API"
> > >      https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a097e2c9d9e26af4
> > > [3] This adds iommufd_access_replace() in the replace series:
> > >      "iommufd: Add iommufd_access_replace() API"
> > >      https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9bc2bf319b7654a8
> > > 
> > > Please check if they look okay, so that Yi can integrate them
> > > accordingly to the emulated/cdev series.
> > 
> > I don't understand why this is being put in front of the cdev series?
> 
> because we want to make emulated devices have iommufd_access in the
> bind, then it can return iommufd_access->obj.id to userspace when
> adding cdev.

Ah OK

Jason
