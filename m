Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45D47D3C01
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbjJWQQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjJWQQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:16:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF026110
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:16:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TB9UyoMKPahkuPpFjCOC1GiyAATeI1MSiQVdG6R5kUi5gSmdIUbWQSXTHngjNCBRKgDoJ/LvvyZQyaDIVk3Hq1eiWQQEKfpuBDi6hXwm2eQYck3DgnDnclr8KhFtjxtagZmZJ4ZtisTUgrppG8jaaPdtAD/pmCFF/dqWX0dz7NuXb293KNcpbKWgVUGEOhfU6CrOed3i/Ua+e9D9SDwsi1vAhz6EXyF+Vevk7AUuWmCUwd9RqjUFhT1H5SAoO233owoFX2/l+SCCkjICKRFM2JGljQc0p7GaYDfz98TUxxwVsjm1AD4n9HHGDc4W3tTllG3JRRNJvWBqSH1AqJKBsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECfC0JGTpmM32pfuDPZU0ZW8uQT+jTKiJATARK2dFb8=;
 b=blXYmf5rn0ZmHvoKgpBkcWyWBlZvP9+TGExmsWNmFxn/k30o4XIx4jbeHj/2wcRl3GbkzOAs3PHXC5EicUVGJ04NNJNzpNCv3yAhAsAAxRoQcZmScXAx1xdhPRQTFeQBXZQTryu1zO22BCVD4d9CNl89MD2fCo4LubE91+fhW7aUPVkQUq11e6u0RASjvUrv+uAo9fXMAFJaChYuPeV4xTFXZVYMUgJ4+e8PuNdqJeAUGub7ydbpjEPLSueTBLr4p4CDDnCPx9Ui0PnfXR8VRhNSDjzF81ZpfglqyrqRTZXcu+3e/b4pOzPoZ3M5+SzTiHDKfvjk639Ftw0nSvTpnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECfC0JGTpmM32pfuDPZU0ZW8uQT+jTKiJATARK2dFb8=;
 b=iF8uzb+CER0ttQM0W+u+RjrCWI917fRWTnbf5soogt5bvD/BlUB0nDK+UCN7809zjtqcQfcS5RbjPxYpbuT1i+JTLdtvBq0Fe5wXqBeTpEAslqbWZv188Jr3Fci3SIDId1mzuUAW9XQX28kGOO17m2OERtrPieWMQTHhEw1MCOJIZoYT5q/sedBjJx7fAjvuohEJ5rgixQNz9a+Q8G8Wlr+alDPSn3P15OLgdPZ5MtKqvpstwxyWm2BniesZaIGCNTQeFtNjFG1B1L9KABT0p/qNdoUY50fSPNCnOtccOip8HKj3LBpJTQsvZ1w/h+nUFTP1nxKXpf8Auz9O8yXS8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 16:16:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 16:16:29 +0000
Date:   Mon, 23 Oct 2023 13:16:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <20231023161627.GA3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
 <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
X-ClientProxiedBy: SA9P223CA0014.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: ebffe729-c8ca-47d6-6b47-08dbd3e3699e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YL2FcWwMUMDmoXfHEzymIkZ+3XOLr6XUPV/6DLY3eJBxuufN7130eUQhbB+p3mwe+1zqlC4py5ofGOwXiriZb6o1hDNJu43uMyJyEdVypL8B5W40fKdIU02OsqgxpRk/PEj05n6Rv8jNfjkByRp2OUQ7Qdlf3n4kdfG2vVdLk5PqQ9dD/Ad3feXksYc7ATbbsPQ45U2qE+9TdTyysndSX00wM1NaBkIuG3xrkqCfAtE5wzESndpAxZED0VR8KN5Q1jSWjtUQb6pY7+U4aUt5eyhQGGsjYqHXytdTtH9ogN+JvVr4A3IGs/oKWN2WUaDeEGu3tgGv2rc5biFuNqQMKC4kx/9Za/d0MfTk5JRArHG7iqRXPk0kZdnuBmRgLPJRiGel68ejl5iPTmxL44mjncKeloDKyMeLItQZ9fzJSH82K3vVZhOENIQq3eLbiVIAFSbzmEuPI2w/Dxg/2978uzFcl8lIEfpJzZfgLtJYvS96H7cxecuor8eLyHnVRkBvIdBchQ9fYFDn68dAfmeQNU3DvPJogJk/eRgx83ST3yEd7aSnnRFSGOfHrDjCjcLixghiTmDwmmIvIgYPJtcy/5U/r+MpU29LYIys3xsHcWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(346002)(366004)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(7416002)(2906002)(36756003)(4326008)(8936002)(8676002)(53546011)(38100700002)(1076003)(2616005)(26005)(33656002)(6506007)(6916009)(316002)(478600001)(6512007)(6486002)(5660300002)(86362001)(41300700001)(54906003)(66946007)(66556008)(66476007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7YF/zmWUZfBggoVh+a5mev51JX5YmVU+z2pTlwLdsbA8m6Dogeth+7Bx0KlQ?=
 =?us-ascii?Q?hkAGD3SgdzA3ruREUDjp8Vzn61ThKqfT6ESqDyybO1ct2B2wqZi+jMSoO/r8?=
 =?us-ascii?Q?lhr6zvTNDtAIU+R6WyBzs0rair4Illj+T7Gm+fV2jh4/2A0C6RjSlGiksL99?=
 =?us-ascii?Q?+nNVyYMDRQC1+hhGgsE29Ju3R9IGJHiPi/A0Z4VzcApDl6rws6NkbOYJvREO?=
 =?us-ascii?Q?JxiWCePjDGNL1DlLsWjZzlQQ23dv8D0HJ/qSimEHLijsO34EEFkXbhZ83bLQ?=
 =?us-ascii?Q?h1xf3+sRC5NNZau2+eGS+xBAiofcd1cdQZOKQe8qdrgTv133O7lnqQRrB755?=
 =?us-ascii?Q?hWhTdGXVOr/8ee0XHBYunAr97eHdcyi6f/Tb9hhF+GpA368880SbTzczrL3P?=
 =?us-ascii?Q?xzv0XI71XkV/ErkMqlHPTnr9t5ARoJCYqNY2/2dI/7oaMq4beqGXiKy3aE8k?=
 =?us-ascii?Q?XpkO9aqkIxTHkrvw5wKWiO6lsJnXBgGXMQbbPnRU/rZchfStJdQ/5PpySD/2?=
 =?us-ascii?Q?On09R+SA4rlCHxS+483hvKJ82cNY6Yf5iPpzuKC0Wz2nHAI+BqB3C4GkI8/u?=
 =?us-ascii?Q?bZT6ysdnCgmC7Oo/4bWA5psf3vyTze2UwP4/oTMT0UHaNmSd/nsDybnnbcdZ?=
 =?us-ascii?Q?pDvgF2L0DqFHPLGqtoCYGkT8e601tjBeHoU9+yF/npLIMA7LKcS/HTXWYg6V?=
 =?us-ascii?Q?acn6+a3iAOo99MtGR9PHLXIOEUFyVQ6T2Km4gMlF1Ng/RPo01XMGT1XtjItt?=
 =?us-ascii?Q?pEYyJYDdf+1wQ1OyqeAVnFP84HulWppf8CeKLpdPgjCb/Z19virRzj0X0nqt?=
 =?us-ascii?Q?NXsFm7PGrO1z5SI+cJOjgpTiRKPWNQLSXqfDbLpVe9YS4hRO/0pyY1qOHIKl?=
 =?us-ascii?Q?TGaA5+46Vg108xPA2043jSc/Go1T1bcESfr1kFMrGKacHH33JzuZCeenveb/?=
 =?us-ascii?Q?pCF1Q/fwjJ6Wa55LvVYz5exAM/hj2lOHmbHBH0TmlW/LrwhHfz0f9LEMO5L1?=
 =?us-ascii?Q?R8Bm+YeUJ1r8ihY+jzKrX4L1xXi0SuNWKaARVsn+JxSVgCEqhvT/YbXO72uA?=
 =?us-ascii?Q?+mN0bjBtSLn502vM9jrhmvxiLxzKaM5AXpCkCE4p4F2y4tCLYSBvLa7UAClF?=
 =?us-ascii?Q?G5wFxr7ePR1IPh+rxtV34c54M3KJ8dk4hj/RSh0NhEH3cdM3LBX+mIBgwpjp?=
 =?us-ascii?Q?vToxMVaCVbGbPxt4vABd49hXxqnG5ADEGf2OVuApfYS7o2X22uxvbuNXBhHo?=
 =?us-ascii?Q?yzwXWKV403vxU3MvvuVyR5Jv/mcCnCQKVeB+7LNohHkTF52n5GsRxhLvy35f?=
 =?us-ascii?Q?kBBTRh3domr7b854E+I6gxUhUFB67ovSFkhdNMbdoknaISP4coquvwfDtWV8?=
 =?us-ascii?Q?S4itmoMwchdGj2TFhE7gfcS2GGSeT9oQoabAxTW9m3dybn9s//982TMwqnMm?=
 =?us-ascii?Q?KMrTq61S7UXuNlTxMek9fg3p16TF4TwwpwoyrUU+mCBmB/JhEBpST59xbmmV?=
 =?us-ascii?Q?kmI9zhbZBRqKXHE/X+gD6jobZT/GizJVQiXeI7wVcosCsVJhq0kpApQtxmdy?=
 =?us-ascii?Q?lwE5gvbiBccBP2Rzqg7VoptwoMwHC030mQyWjSah?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebffe729-c8ca-47d6-6b47-08dbd3e3699e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 16:16:28.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrv5E0GLPT5gMu8Cn9IJBxdwnteKYG1XdOq1AcHYYbBTiAv6FRX2DwiAzFG9JNJ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 04:56:01PM +0100, Joao Martins wrote:
> On 23/10/2023 13:41, Arnd Bergmann wrote:
> > On Mon, Oct 23, 2023, at 14:10, Jason Gunthorpe wrote:
> >> On Mon, Oct 23, 2023 at 10:28:13AM +0100, Joao Martins wrote:
> >>>> so it's probably
> >>>> best to add a range check plus type cast, rather than an
> >>>> expensive div_u64() here.
> >>>
> >>> OK
> >>
> >> Just keep it simple, we don't need to optimize for 32 bit. div_u64
> >> will make the compiler happy.
> > 
> > Fair enough. FWIW, I tried adding just the range check to see
> > if that would make the compiler turn it into a 32-bit division,
> > but that didn't work.
> > 
> > Some type of range check might still be good to have for
> > unrelated reasons.
> 
> I can reproduce the arm32 build problem and I'm applying this diff below to this
> patch to fix it. It essentially moves all the checks to
> iommufd_check_iova_range(), including range-check and adding div_u64.
> 
> Additionally, perhaps should also move the iommufd_check_iova_range() invocation
> via io_pagetable.c code rather than hw-pagetable code? It seems to make more
> sense as there's nothing hw-pagetable specific that needs to be in here.

Don't you need the IOAS though?

Write it like this:

int iommufd_check_iova_range(struct iommufd_ioas *ioas,
			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
{
	size_t iommu_pgsize = ioas->iopt.iova_alignment;
	u64 last_iova;

	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
		return -EOVERFLOW;

	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
		return -EOVERFLOW;

	if ((bitmap->iova & (iommu_pgsize - 1)) ||
	    ((last_iova + 1) & (iommu_pgsize - 1)))
		return -EINVAL;
	return 0;
}

And if 0 should really be rejected then check iova == last_iova

Jason
