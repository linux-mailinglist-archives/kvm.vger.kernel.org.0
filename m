Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0173E756
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjFZSON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjFZSN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:13:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608D10D5;
        Mon, 26 Jun 2023 11:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP/OoKpc7Foo2N7IkRxmj12h+Jj2SdW0kGXtETtYvU1KqB1pNUheAXyS4LVdsk9fB/OfcsvD1vRYpxHy4HClNLEwlQYBep9aBncaJbDykZvXocF4bHpFrMPqR7KcSvcRQdD9AGRHdGRpU0wCEdrFWHJBqvFAwH6xO333HN0MXUG/qwhE47uMh/JtR8n4iRgL8pecNDoUFNKGK4j3jONcChWFXqnq3iQ0cs24L2b5MuvDl6ZwNiMdHjpssDDSNaZlsdJ43AurNC0btVVXz05tq5OwVMCkd8acMPJ+AwK2vEdbq9paSC+NNSCRfAfJSF+TIQJcF4n4/O5gK38f+SmHHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1YF1Y3EaC/qkf53jDmmjppTEtv5IAXnoNvwHj0TZIQ=;
 b=aUW5G+C6lik1y5xv1vHp8y5ekXoHTRPWs0NaJ13Tr28pEZFWZNdw3A/oMpK6QZO6uTpMoYQj4xTb4El8pG+RMLw2hRyPmG/MWbno3TLEEYNKgx0ezs77CVWOUFEQ7cfivQnmnKk6asxqMuYNxWYXAkUjgr7Am2qpkKkNjZbYr27bfANmEgD32H2wrY/TM4XazdmrmgMgOtr//zaj8EyB+/6qBHmc4IkOJoL35g9LWreIaJ9GzKViKgNUtzjctrcaJ2QTL6QmSnoqA7dECuzKRIFnQDvaDw1gx1Z6k0q7z1nuhM4FejDMedSqm2RK1lK7XuCqbQaA8up1eXrJy3evEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1YF1Y3EaC/qkf53jDmmjppTEtv5IAXnoNvwHj0TZIQ=;
 b=ER5gHLDf+qPbWqWl/mJiI2IXH5Me0h5zRKOvRsYJyol0ngVzLa+4tJVnrrSOmn2XgKSY8RvsMVu9zQRjNFfNvImCgy531tlnjaEByEGgHtmnCvC3qOhrdVCpALnv9wv7phwZbJg2EayCxBKgcUivhoeVkz3SNzdb2lv5HvQdMWo/MJAnL+MAuUrGuXPb5HhwyBDlK9AI/X6eMW1Co8CyBN/hhRYf+4q6BDCx/cOt0mAFqhMCu7+vx30puSInqSsJ1+oLI802uWhDmRSMtikaLcpEmaTRUzkunJf+Solm/q821gac5/77uwVp+ufm5XMTqSaaJIjYA4HHyd6Y7YuMAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7247.namprd12.prod.outlook.com (2603:10b6:806:2bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 18:13:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 18:13:54 +0000
Date:   Mon, 26 Jun 2023 15:13:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZJnVYczb9M/wugO8@nvidia.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJGcCF2hBGERGUBZ@nvidia.com>
 <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJL6wHiXHc1eBj/R@nvidia.com>
 <BN9PR11MB52762ECFCA869B97BDD2AA9D8C26A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762ECFCA869B97BDD2AA9D8C26A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL6PEPF00016410.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e7cf20-0b2b-4087-d10c-08db76711a37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i847hOns2AeZ2O9p1LUV+mkyYidZUPtuTne15P3kpLbGbEvXaupXbhYQhD3aKSwidH0e9MJ/XKg5fVv0HfrNAwfhbzskfL03rIqY601RYZ2OQQBDUQ3XI67McQq5mSwmluFc8e6MAbJTa4gHqx4W5Fjse0TXTmOJSvancOt2KNeZIfnXWjuLLlB3AOGtbTnBVRZ/yq+UAFaLOqHxFAfGdr5Xo8i6MIeNXhEw0Aa6pS0sOhbFigGA24SzBwT3NygLTeBmt2aa1Ie4kevaPOe5+4SaMuadYHqwyV5CqOk4rpLrbgBGNNcOdj2Ip923TyueeGSHssbRn6XhP/n2RAuqFHLK+k0WK8fbnGk0TJOlFA0xMLW0N0hRm3J9vlArvp5yorAD0bhQUIKgcHkj+LErvc2Lq/o+qVfW/q5caumT8ihvzedaSpu42+YbGcY2vdaf8MwTSYcrIzBVq/m+clSK13Cz/527moRjQAr2oDP+vIWXFxDWoY2WCWE4EsNcKDWjy7q7GTYSWBsNLzV/gIvCi//vNEc2R71cODLxgcFWawW08fStomMs4fHfCa6nD11F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(26005)(36756003)(66946007)(6486002)(478600001)(54906003)(2616005)(83380400001)(6512007)(2906002)(6506007)(186003)(5660300002)(316002)(38100700002)(8936002)(66556008)(8676002)(6916009)(4326008)(41300700001)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kPM6rzV7VC+qgkMZ1xtZTkcvhUwnfjuxlpSHROgljjmQH8qUdGo1CzEU0kKX?=
 =?us-ascii?Q?DFHWTBA3gOElMg7CLqbtlYR7FyqOn8x8BaorszNoGK/pVnO8Aiy58o+UW1wU?=
 =?us-ascii?Q?UoQ7aXXhqviCFd6uBVxOXqRt3LJ9t1fuTuTttgEo220WLmnTymeJ40QbjCby?=
 =?us-ascii?Q?SRaDT6U7Dp+pqULWNZfeLCQjfraXW+OCx24TXk/ue6PYR82I839Oz98sVMv8?=
 =?us-ascii?Q?pH0W16LmnDAQuUpASaTxjA4QvA7/ffrvN3GAcrsJ9AYoAZbRTMxr3mqSbeOm?=
 =?us-ascii?Q?+4z0mMAuMYMiTvk6Iw9fSyTqSGJtKdwikh7C5MV/2SBmjhBrEcOPCdGvq6UE?=
 =?us-ascii?Q?Irr7vwcSgHZETtDLdQPkkAbM1fZGfFf/EZfCu0K4A+x++wnRVJsU2SYpPQkq?=
 =?us-ascii?Q?j1oneynoT+4WSyCzgUTdxx0kTc79YqrjkdzHa16QsHDt46TdEuc1qRSEDbp0?=
 =?us-ascii?Q?wxw3a+C07TdFrPptnTdqvq8PTCl/aLDak12DiqCMWSTj9HAJdkitZ99udZeB?=
 =?us-ascii?Q?gnxry2LRs5r8mS4baVgKSKKOR0t9OXFW7fJ3L/MWxb1Cw7Yo+mL24a1wLq3a?=
 =?us-ascii?Q?S5M4N36VYRn9aDMhjNHNhNAVxB0Rts2qft+rKBOQpiVjLnRi1GTh5bSBQXy5?=
 =?us-ascii?Q?ugoGNbLaVL+8ycgqxRCR4n9IFoagzMr0BXqpsNHbbdQcSYmeiZkAlMFKMFRI?=
 =?us-ascii?Q?+QhmL3SDYxkLf067PlY1irn9uXsPo9qra3JDNf6ZL5GL5LBkgiTdY1QQJxmq?=
 =?us-ascii?Q?UQt0z8DD3U4sIECK1xJAi1FhYpJeIyBfpG/gov/BMq2oUtA+vJCcqIrus5qY?=
 =?us-ascii?Q?t61Lqkh5tMVyJuZEL/xshaNw4incpHcT7SckbIVBW5F4QXzSWFMFFpV1n0xb?=
 =?us-ascii?Q?OpjQdv535d0gVakG5t9gFqjfQZwGnQL/mfORQJNkEVKO8qfV4TsCcbiUa4EI?=
 =?us-ascii?Q?dgNjZoHYfYRZRbxWtWZG6TysRx3A1BL6rF9Jc+z+lwKc49cgggjGXqZa/OKt?=
 =?us-ascii?Q?5/BGXgtg72309WUDcYI2U2dCxEQ93xpPOCLGFJ8UCDs1GJoV9+VwV0NPlFJC?=
 =?us-ascii?Q?urmurcsBUBzDvQtAYRSR9D1bOY2yEYJKc3j9UhtDnoGpXZgx/yulIg0NHr7b?=
 =?us-ascii?Q?nDG9wjNpGkeLmUQXyfyDUPxI5qdPJPAlDNW5jM55PE98lEmN6JAYbAdkvSsu?=
 =?us-ascii?Q?K95EpfbdE8z0I9mLlOU0Q2OrflyfCkC1UUvhdjrVzUq19gUzCTqZg5byY2QL?=
 =?us-ascii?Q?GLE95wJpDJyp7J4UzGwy800dTC9IgHRkY1Z90mQ2Oy9xd1G4l6n1AERcYnGo?=
 =?us-ascii?Q?BIRHmYyaIxHX589acdazbAa9NlVDVkWXJMsAWMddZy0vR2QcPCBRlGdsrFjC?=
 =?us-ascii?Q?8BuB44njWNXIvjLQGBXcO9YzCw1s4vuM7L6lFnUkD7VFMKRn2ymlZEzymvih?=
 =?us-ascii?Q?KzoB1piDfpgz7+QlFzE9cEDAHvwu6cRdW170vFLArURIICSIN0x0DTG7TWmX?=
 =?us-ascii?Q?vFkPiGnCrhds0WoBjAPQcKoi8EXGNvvEQUmEq2Dj+wVkxILnb+PaKXIHRONw?=
 =?us-ascii?Q?SeNOybI/taWm1Hp4uLaDkN4zYDpGO7rlBB8sRZ3d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e7cf20-0b2b-4087-d10c-08db76711a37
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 18:13:54.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n68FfvaySkBYrB8S+ni3PC5RHPtpy1+vuD5MM1wPSfG4K6JEEyswyM1wiCjj40t6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7247
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 07:31:31AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 21, 2023 9:27 PM
> > 
> > On Wed, Jun 21, 2023 at 06:49:12AM +0000, Tian, Kevin wrote:
> > 
> > > What is the criteria for 'reasonable'? How does CSPs judge that such
> > > device can guarantee a *reliable* reasonable window so live migration
> > > can be enabled in the production environment?
> > 
> > The CSP needs to work with the device vendor to understand how it fits
> > into their system, I don't see how we can externalize this kind of
> > detail in a general way.
> > 
> > > I'm afraid that we are hiding a non-deterministic factor in current protocol.
> > 
> > Yes
> > 
> > > But still I don't think it's a good situation where the user has ZERO
> > > knowledge about the non-negligible time in the stopping path...
> > 
> > In any sane device design this will be a small period of time. These
> > timeouts should be to protect against a device that has gone wild.
> > 
> 
> Any example how 'small' it will be (e.g. <1ms)?

Not personally..

> Should we define a *reasonable* threshold in VFIO community which
> any new variant driver should provide information to judge against?

Ah, I think we are just too new to get into such details. I think we
need some real world experience to see if this is really an issue.

> The reason why I keep discussing it is that IMHO achieving negligible
> stop time is a very challenging task for many accelerators. e.g. IDXD
> can be stopped only after completing all the pending requests. While
> it allows software to configure the max pending work size (and a
> reasonable setting could meet both migration SLA and performance
> SLA) the worst-case draining latency could be in 10's milliseconds which
> cannot be ignored by the VMM.

Well, what would you report here if you had the opportunity to report
something? Some big number? Then what?

> Or do you think it's still better left to CSP working with the device vendor
> even in this case, given the worst-case latency could be affected by
> many factors hence not something which a kernel driver can accurately
> estimate?

This is my fear, that it is so complicated that reducing it to any
sort of cross-vendor data is not feasible. At least I'd like to see
someone experiment with what information would be useful to qemu
before we add kernel ABI..

Jason
