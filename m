Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490494E5839
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbiCWSRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiCWSRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:17:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC16F888F1
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqCz2LpriytQF+GDiHlz3quxOwYp+q+xbe3g2jDXPyoUUHaDN9gkI4dpoOTpmwe9y2arAJ75I381UtRL9L9+G+PyTULuYe4JaJwOB+894NTFr2k4YHQONSkUOMzkUncqyamK0upQ6UrOvRGZhacThyvCb0x62OH8coZoN9JkqK7aY8arIgkgLoag1Dv+olXcTL2LlWonRt1/9CDUB6Uqd/e//tCAA8KjT9HngrfMJfV1GkEa+ofgTx0QE5XucX1hWH2FgZDeeT91cAiIeU9PPNOJv500P70WoBXzfZUK+Qnv1UjtpzVybPVyzKSE2EAgzrdLousKLrGq5LvEcAKA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAbTyAK4bFmsEfitaZGgsufwkOi5TWa7aRoOsqkmeec=;
 b=VANCsE7SeR/uecITa7tBiGm0LQ0aNFtJjDYgew8/HY+QZ+JV/k5XRmT10nyEvuiirOAapckTjZp5Y99olKw0rCUaSefcqLOvdAGc+BVh0OHXMHDuDZoSX8pHFfSKx5x4Nncpl7wIu8EmnjWKy6/jkcJfKCzrPr062GRtXp7CU7UoL3j3U0qhKia9y3U8aZGoDchlkWQcpCIPp8zg72eAXme/MikbO240JVL89pU0Fxmc+JJNFkPV6Yah/UGSkseZMCB9ceR4r+jAu4k+hT51JnSrBKfUIE3bNjQc2gIN/awJVwL6uRRQBbHUAYw2bnw0KccUUjNrVqjNJw6iJxit1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAbTyAK4bFmsEfitaZGgsufwkOi5TWa7aRoOsqkmeec=;
 b=eNafa2sC3ETgg0oR0p/4WMXvHvumnlHq5jYGoV4BUA6UqDgE0+1NdQvApMddxoSuoryzUVYIBJSTaQrHSN7qWUK1lHwxasq38zqRDReP63MLSiof+dZCzInJO4ocP8qbERqXqbz1UMXJaU+WDHn3TlW/SIzwsb0RNavBClCLnriw5OhASDs94h1gpdlPUlZZfovLbhW0PvrCbqZF9/GFGjo17GvTzBvW9wr6wYUiC5tA+/62MiQ9GY62hW6A+kFL2/0Zxi8SVdbDSmN1asuOHR0kdKznaL26mu3HGmJJ9E8t9T9Dcq1maI7vteJYdvmJKrmOn9Jfs7OvfBZuP4EcHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 18:15:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 18:15:34 +0000
Date:   Wed, 23 Mar 2022 15:15:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
Message-ID: <20220323181532.GA1184709@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220322161544.54fd459d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322161544.54fd459d.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:208:23c::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dac09e89-bcaf-4280-1bb0-08da0cf91f43
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751C32AFF63098EE41AE27AC2189@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGlJrktEAwondipdencEt+cCZ3mxuUFEFMdqclHXxVe7gGozizt0VHXux+QhJyYcZrnSEsuG3tTqlZNbawu4qTMJQSSnOO0zk6hTMZ+r13Ob6daL/fhqj3uvBh24mFonutHjpX21/DkCYue9NAX5m+wgdHpHKaD25ns7ff5Ug8TBezN/BINOlayWRp40ME6/QYBnMieQldC/SD6lgi7C+p6boRLRQ2XBFlB9WWT0/vl26Ja/lYGm0D2+bzo7xQHetrrN2qm3EOX4t3WHRkdN28kTCzl3bawUHlc/Ci7qkSzDHBnIlnRy7gtZCPBiQREzfdECGOThrw2DoA+3mJMucrLUooPYoV/O7m3EdrOp6YunVBJMj0jZThurIrXGA+dIRFnHFdgArq/uq0sGjtN/sv2EpHvEjuxFsx74wjJnEuhy+aFDHbfU8K8DmLBxD3xbTIi4CWj+agRcjSEoHN9AiTf+r4gYIivn5UNUZSwirH5ldlCRl2sQU+wpjFeqKB4JtiU9tKkD8N8Ji8pbKjSH1kU2cDf778p05zhSs+usCMj+RE2H/jbntsycF1kEfHTmp02f96FWY6mGCRZb0LvUzVTofm6NdIN6azQLCTlvFpcQ8cS63iLsn0FmDYuvOUr3am1PUExa3r/Lg/4+IxtULg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(33656002)(1076003)(508600001)(2616005)(38100700002)(36756003)(83380400001)(6486002)(7416002)(8936002)(86362001)(2906002)(316002)(5660300002)(66556008)(6916009)(66946007)(66476007)(54906003)(8676002)(4326008)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3997PJeZZcGGX8anUpkPE7StlG2XsnHOk9vMiK+G1hQNrgPYaiuOnMszbHMR?=
 =?us-ascii?Q?TI93NBA/OZNVhucVdFa31anuME3kiD7ecIbOgwNM/HGWNbeGSeZ3EZ8pjDZs?=
 =?us-ascii?Q?WzoK8gt4TIjZgKJGCPcKPW2E6ZzUl215KMEfigVYtL871OOtxIbjRn10Q8Us?=
 =?us-ascii?Q?pbZ5FvcTXo5Yw4vlyOWImbnNRoS0c60h84UmCI1cu6gjsLqpyE73xIEmxVeM?=
 =?us-ascii?Q?goxhBn5wkWytdt9xjv3+m6zePQpL3RRFuvz7dD52RKmJTKey9e8MjmhF67QD?=
 =?us-ascii?Q?Len1hQKr4zmL51tDZwxJz85mpxZygfEtmzQ1d/Pkqn0yUsMLXADhwiQus/Fc?=
 =?us-ascii?Q?tEYnu+jeq0bprq5NNwNBOGd7gWYUIg/WYfmf+94vARe8BS0jromCDSmJSdFu?=
 =?us-ascii?Q?Gq/I8TsLQbytlyyw4+dOYWM+I35E3TYInpL85O18XsYsLXq2Dy+OiDMqNpPQ?=
 =?us-ascii?Q?6jZvn/bJ1ALYPKLVGg9CNoraQnAzeYzgrsrZJMlXIgMacvdEHkamykzxOPr+?=
 =?us-ascii?Q?Wrx7QyKlJGfZ+7Df4SaLOfOJXLE8GgVo5Vx8nduQTTaLeARdBIU2X9cbQD5j?=
 =?us-ascii?Q?wJO6E08W2W9dFAR87FWb9xP4cSg4+J1emT1bZajXFD66QMQS3feO9VZ+SHRB?=
 =?us-ascii?Q?Z+G76Edc1M1qcoyhT4u+5jPMv/ZLD1AsHo3p5tNzLbaTe6b6aMpjS7BfiFM1?=
 =?us-ascii?Q?ctzeIx98GRBzvEY5znXkPoKZVYQfvGo3DMKVs3d7yfBlthjTH6rG0yr52b/r?=
 =?us-ascii?Q?eLJR/OeiEG9C/tQBWb+zIhgdjg6Pdt6moea1+ZOC0i/PUw7PwSZJmtuu7KL3?=
 =?us-ascii?Q?q+MTLs4yXMgAwXimAvtTD2aFy2nDpAcKb7ntV0KI/ykEHBalXsM0ogqLoBmg?=
 =?us-ascii?Q?FxfYnUqEFkcp5S8/HKpNAQKiNKSpmJM8KxWjfd/9Iqgzxu4ki1qw4QiO/Jmt?=
 =?us-ascii?Q?HA86YYDvefI4c2dOth49ikBzWsIgNmPqXXIhvV8GuMu2Th48eb1aM60TeFXj?=
 =?us-ascii?Q?riPu2yooLJGpWl7UBNYaelLQrGQ97SaMwt+KV3bUwcDcGWp1QsdmS+K4gm7u?=
 =?us-ascii?Q?B4/6ug/mZuu0i+56lyKzpbBvZqUOE2kmLbHKR8FwuTNbTTq/vJryK2z8pV35?=
 =?us-ascii?Q?edq7Hy7Qi8okXRUWqccRnPTknCZ1QnmydsX7LtctxPkmY+o+JqDqdAoEpxee?=
 =?us-ascii?Q?ZCrYNvm8ta1ZrHw6vdi9HoDUfA0kdtHt4sUCLKi64Tw29jF6ZZ5k3BqyIAkQ?=
 =?us-ascii?Q?o1fPJCwF6OQ6jqiJN4vcIKc+PmMjNbQnczojE5UY7m59kj60oIL0vlHUVmp8?=
 =?us-ascii?Q?tbcDtssqYxqr8DPE8StIA6SB3yLX9jIqwxXmsCa97BuMmvcp050wTJu4prvj?=
 =?us-ascii?Q?JlfOs598asmPkHcdyTPvs8Pkpyj4Y+TYQmYHE0aQlbaGkshu158OJtkV0PUR?=
 =?us-ascii?Q?PsIaoXOObfoaG90pZ7yAF+7kKG/JXwtB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac09e89-bcaf-4280-1bb0-08da0cf91f43
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 18:15:33.9883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2C5nYWckvbw6DSmWwFGAKNJfU02xGln+nEbpMHou3iWDs1KDTpez/Sngo2EyfcZY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 04:15:44PM -0600, Alex Williamson wrote:

> > +static struct iopt_area *
> > +iopt_alloc_area(struct io_pagetable *iopt, struct iopt_pages *pages,
> > +		unsigned long iova, unsigned long start_byte,
> > +		unsigned long length, int iommu_prot, unsigned int flags)
> > +{
> > +	struct iopt_area *area;
> > +	int rc;
> > +
> > +	area = kzalloc(sizeof(*area), GFP_KERNEL);
> > +	if (!area)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	area->iopt = iopt;
> > +	area->iommu_prot = iommu_prot;
> > +	area->page_offset = start_byte % PAGE_SIZE;
> > +	area->pages_node.start = start_byte / PAGE_SIZE;
> > +	if (check_add_overflow(start_byte, length - 1, &area->pages_node.last))
> > +		return ERR_PTR(-EOVERFLOW);
> > +	area->pages_node.last = area->pages_node.last / PAGE_SIZE;
> > +	if (WARN_ON(area->pages_node.last >= pages->npages))
> > +		return ERR_PTR(-EOVERFLOW);
> 
> @area leaked in the above two error cases.

Yes, thanks

> > +int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
> > +		      unsigned long length, struct page **out_pages, bool write)
> > +{
> > +	unsigned long cur_iova = iova;
> > +	unsigned long last_iova;
> > +	struct iopt_area *area;
> > +	int rc;
> > +
> > +	if (!length)
> > +		return -EINVAL;
> > +	if (check_add_overflow(iova, length - 1, &last_iova))
> > +		return -EOVERFLOW;
> > +
> > +	down_read(&iopt->iova_rwsem);
> > +	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
> > +	     area = iopt_area_iter_next(area, iova, last_iova)) {
> > +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> > +		unsigned long last_index;
> > +		unsigned long index;
> > +
> > +		/* Need contiguous areas in the access */
> > +		if (iopt_area_iova(area) < cur_iova || !area->pages) {
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Should this be (cur_iova != iova && iopt_area_iova(area) < cur_iova)?

Oh good eye

That is a typo < should be >:

		if (iopt_area_iova(area) > cur_iova || !area->pages) {

There are three boundary conditions here to worry about
 - interval trees return any nodes that intersect the queried range
   so the first found node can start after iova

 - There can be a gap in the intervals

 - The final area can end short of last_iova

The last one is botched too and needs this:
        for ... { ...
	}
+	if (cur_iova != last_iova)
+		goto out_remove;

The test suite isn't covering the boundary cases here yet, I added a
FIXME for this for now.

Thanks,
Jason
