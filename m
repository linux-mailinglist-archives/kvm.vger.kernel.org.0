Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E412D7CC407
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbjJQNKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjJQNKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:10:08 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41620F1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:10:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIsVdKkeun4QPL2FdxYz0v2/mooe67g7Id2qf+aUZAVy6WK4POZQslpR4mwLlg/uVw0evoIAGsP9pkONnn+YxnNJSw7uqvpfa8jredhslbSVAaCluX7LXwYl+e4fjEThOxOJzkTN13LS/9kba08MccoRnoEK04KXnUko58QL72THHR0QZ58djIa5zaCT2I2pxUD8D6l5irGpO3MN/fk2dWspbNTO3UKqVJD3B8ohiZT9Ffu9Gu3/dqPAD99Egt+SaAfLUVs9BCW3K7XLpbkMeVZ+/BmvCK8O6aUTejE/Ju/knNGuEVmZbZN6/gPqgLyz/mIr1NQVIY0wThjua4FiSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98UrxT/gMbdXbhaiun5WxQuv62RoiBXzd+gswcju6qk=;
 b=lOrnzNTUHnkksfDRT5pm+GdI5Tr+UYG9sBfi2iWP/n7G/P2Aax9dL/WvRIqtmErsqcTUOaBlMRJujaJpxMpnlaetg0hFTYBLqAdnvxN98X7TbIjoK8aqYpOERffNAGsQw2xMt4B2MBAHPBPnH31m5dHw25PwxJxzmq6mP+b0K1TzrYLbb36i4L7mSeBxFPKUP72gOzKVyQle5V0DDPyPMRIu5fGzAqg55Gi+RWw9+/D3ZDLNdMgEmyKrw48J5EiG+dAKfeGQtXw4A3X1WpyHbjf9UCPSCfljiS09ewWVQ+9QjKKvv5uazvXACEJPmxT+gvRwSe6X6Ma2E6coko74fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98UrxT/gMbdXbhaiun5WxQuv62RoiBXzd+gswcju6qk=;
 b=a+O77Deh/0X0OnpOoZb6b1ZJ/qLuA+7gUx0BKfF4ZFoSUXdu6L1j0vXdmYSnl6lrWoCyfsPxNRN2PrHzdvvHbo+VmmhEWTokQM4LfAoNxIS5UFbUppuPjrxb0TQH2YmJC041kq68P4eaCCmufbB5ElfUY7Yn8aBaS3ZF79519K50ya/a5GDxBFVmCqiPMVaYgYxy8NZTCgpWZv2uW0ry+ySXkpuLL/vVf5k9tTx7FSScd/EaVdJ0LnB6EYKSOH9z0iO4Q0tBF3PlCV4O1t0qP9RVa+9gyBQScZrO72cLCwWukqWL0PHMLvI8eHq42krp14n/I5ELTjNpQ14T9hyCYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8542.namprd12.prod.outlook.com (2603:10b6:208:477::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:10:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 13:10:04 +0000
Date:   Tue, 17 Oct 2023 10:10:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Message-ID: <20231017131003.GZ3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
X-ClientProxiedBy: BL1PR13CA0361.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce7b923-25da-4342-3e83-08dbcf1260e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkLTxcw9hzhXOo0sO1R38Jip+taSN+oTwhG1AQGo2H0BnhFg0P1uRDj3M99e6TuOZPVvm4NeGg+P2VcPEZsdzXVlxm0X2aOJyjSEkxbk9xsBdF9SmadqvKi7BiRS1wsYmIO4DMUatFj+lnTLrbL9fu8K9Jgt3peOxf5KflWi6fRn5alaURMHg7mf8AoAe1DfmpgF9+YgNsJ4AM3/NF2nqLZzjfbvClamd+YZ6UYraodXNug+HMgJAyzq/NiH1MJx2cvlciuWz6e7iOxtknS8K7+XNjo1o//Ic+C5Y1luyNIxkLCUQQpZLykYuSxUw6PD0q4db/8pxAJpfmKDzRvQTw5rXuhi1f5uyhkMTwslJ3C6bHayuVhkEvuzH9I1XxT1mGbows135Sy34snWBL9dV2XbUSfKf6GNjtxIrrwh784rxIeRHKrKBgDNu8+nCXycn9ID32bPGvtQIJsFHfqPiw0FEBbBwAYxQX35qYlm0VT6pYEVPll5fv2kVkggA1yD4ZZy+yn5ajDGtrSeZ9XkFUXG5B8CCQ0vR42qHu/+nV+NgaPWaQcmcIY3nAmOyk4V7CeFcuVDplJH8KGo7lCQVDrC5xJXGXM4oon0pDEBz9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6486002)(54906003)(1076003)(66476007)(316002)(6916009)(2616005)(478600001)(66946007)(66556008)(33656002)(6506007)(26005)(2906002)(7416002)(53546011)(8936002)(8676002)(4326008)(5660300002)(41300700001)(6512007)(86362001)(36756003)(38100700002)(83380400001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UFXSBeRJ5hkMimQ4ZGhD84h8AUZTRnlWRnxx74PHgwc8JjR7iyMsT2BmOes6?=
 =?us-ascii?Q?+aZ8Ne8DER8monZNE++5DL+2s7YE4oDFPZGPmRGdAiFXC5zVKXLZYGSCMr4W?=
 =?us-ascii?Q?npONS3/m1pNW+JvEM/QwrNAEHmVGzkLCNB+RjNbXwCaySAK24qVu3SLLobHm?=
 =?us-ascii?Q?DuxmuIt7MmsqacrLlcPe4VjkckwNFiRQ6SNKgBRd3J1clqCOdr3+kdcLyAvJ?=
 =?us-ascii?Q?I4sIDvnhrbKoDf0c40G4KqedV6MIPcaOnjC+QdmBwTPe5E03eDlbejuRMrvN?=
 =?us-ascii?Q?HbHF9DOfvz+QGtDzfrbnQv1oW/J8clxSh80TvejMGJUqH7cyCoQOa6UV6dGL?=
 =?us-ascii?Q?END7CFPX2mKeUtRIBRE2yWSdVhaS1GjTjNw1peG6kY6N79TX0tda/rw4H+G3?=
 =?us-ascii?Q?NzRDAK+XPqwyd3BSjRwL1+MIxccDlPAqZOTOfprgObUpzJMxZxg8TlS+JxuG?=
 =?us-ascii?Q?1XpGU5Kyvrizd+PTDe/PHkW3wepEShcjYK067qrCnEbOSgYdNohuK3pO/wrX?=
 =?us-ascii?Q?BWT+5RZN6s8C4BOv9aEoTek9lcGnfPWk3u2mhsGx5zhInGRhdTPSL+HNYf4I?=
 =?us-ascii?Q?hKygD+mPvHGuPo3sjoGyymhUyzye1G7jjWd8J0mzHTOYH2XUkvAS3pvA3b46?=
 =?us-ascii?Q?8TcEgbabUxImenJgdSogpG5NXtYTvIpbfCs/hFcmyyisesZI9lkwTLSwepa1?=
 =?us-ascii?Q?o8EB5KuYSbjy8D+btU4jwX/QFvBQeek0SscYcJLe7GwGyyKDiWt2bKa2dqp8?=
 =?us-ascii?Q?9G/F0J4tmT35Ylw8t8h+H5zIZePKhFH6HOSp8Yn1zU+cxPcqfjZ8/qUkhxu8?=
 =?us-ascii?Q?/79uwWve2yIVV9dNA7j0kiHVY1ivr6rQ6qxFqkglMP4juZ/uexoZbypOPNVh?=
 =?us-ascii?Q?E24ZS6hTERxM0/qQgJhjAQ/sHzUu6iIR9dg0Ah69Mk91U+Io8YgB0Jt9TOeU?=
 =?us-ascii?Q?+/CtmpV/udSWc0LNqPiXCvZiaAOeEa9qbwXWzg0Xr8u/rfwCo1Fn9ID21o16?=
 =?us-ascii?Q?YSgfnUwc1m2OKLu5K+LoVZxCtB5J+bTllD8DFg7Y6HCX5WZPV8jhvKFzWrpj?=
 =?us-ascii?Q?cOyiY9rb8QSBuAFAjGGsf+XHadcQbJvwjXEszTMfJBdffxwnRcbmzuoTUyuP?=
 =?us-ascii?Q?OW8T+FRZ/avRbGWUmfNNaQKBMOBuIDYhUghpps4foR1btamdv9NaHe8rAoC2?=
 =?us-ascii?Q?G1egh4I3bKaUyqyorAivMG/Nr4mMlm6UQBxbz0pD4QOq3TfkWmg4eRCjZl6O?=
 =?us-ascii?Q?hgq+egovFwlUePP+8Kw5xP18dhuwxESlQRENQuBIP4tDOlJ27XfL2x1cWdun?=
 =?us-ascii?Q?ky0HO1H+gChg04U5VhBxexwk0rnO6TjH5QmU6NiPIv29UJoejW9SzsuFA1Bl?=
 =?us-ascii?Q?lsDCiphlpRkueKMHKwqUHX4JoZ9bPHVuqfchBuGXrt9FDGPBgJ5pW9eLfnVd?=
 =?us-ascii?Q?6RFVrbQydaGCZpCihWerdKWLfpeGfaEnhNlg3h/+HMtrUTahzvipSFfwbAQ+?=
 =?us-ascii?Q?Ck/rgU1JnlEiwn+L38zd+ClXXz7U3+UMXnClQi2bKLPPIXzriWwOhnMUHYvo?=
 =?us-ascii?Q?la8fNdHMlpNeEfRtmb9JyOc/R/n0nTfJjgzFVSm8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce7b923-25da-4342-3e83-08dbcf1260e4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:10:04.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLklXIGrqhGpRYhmQaVlqO4dpTCgNhHgxQSzM5/uTegfhwjaqnwiBrpGfRhxJcaU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8542
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 12:22:34PM +0100, Joao Martins wrote:
> On 17/10/2023 03:08, Baolu Lu wrote:
> > On 10/17/23 12:00 AM, Joao Martins wrote:
> >>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
> >>>> need to understand it and check its member anyway.
> >>>>
> >>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
> >>> already makes those checks in case there's no iova_bitmap to set bits to.
> >>>
> >> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
> >> essentially not record anything in the iova bitmap and just clear the dirty bits
> >> from the IOPTEs, all when dirty tracking is technically disabled. This is done
> >> internally only when starting dirty tracking, and thus to ensure that we cleanup
> >> all dirty bits before we enable dirty tracking to have a consistent snapshot as
> >> opposed to inheriting dirties from the past.
> > 
> > It's okay since it serves a functional purpose. Can you please add some
> > comments around the code to explain the rationale.
> > 
> 
> I added this comment below:
> 
> +       /*
> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> +        * have occured when we stopped dirty tracking. This ensures that we
> +        * never inherit dirtied bits from a previous cycle.
> +        */
> 
> Also fixed an issue where I could theoretically clear the bit with
> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:

How does all this work, does this leak into the uapi? Why would we
want to not clear the dirty bits upon enable/disable if dirty
tracking? I can understand that the driver needs help from the caller
due to the externalized locking, but do we leak this into the userspace?

Jason
