Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40A6644D8E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 21:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLFUxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 15:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLFUxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 15:53:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8871D2AE2A
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 12:53:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJaj+WGI9MpQ5YRe1lmlEbw5RoBf800vsC7QPzdYnMKhdR19VO8jNlfWSADo2tMe+KgUBQ38L7wXOa0zEnSRUr5XkXV8106gjhgONsK24Eh6HUp3AIbF1mRWrznyZMrkF2PuRBUWJ1eUFA3jS87qYZTmEltsE5BzQ6aw19zjbyEbkhAwAj1vP+oXoRXL3ZGxDO7/YnC1D/iLUD3eyCmR65D/xuKmEKTqY09l6oKENECccm8aq8OKkNPf0Cb41axKpOrkZR3NmCVXq5iAOW+EW9jzZjhrAAF0RR8jqyNRzHzFDdH2Pk+tP/Yq0L/4k507GDAtlX/gqIxrrjDlkzA3VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bza58puVL7K3BBlvsTf2/37EoaRjGqHvqqVSyjNma9M=;
 b=NE4tR+FVVneqkjgk4I6cd3czvV85KyLUVH7fkQofz1F1lbZbgQKMahCFKJSKQo4l4A4FF7SjorMTL7utrnT4eWNnuCxS4gTVTqgf6fUQY3oQUqe2ujjXr/tMvbFjpcEDTuHlNV128ZCbDyJK14C+48yyGUsAPM0P6wRRMLGFz7v7eq2Hm30w950TZdhG5STZmv+HGxikFFzic5ekm77ok5h2p3FnUVvEPtcfX+SUOIGT0oFMII1csnF5NigA4Q+IXJ/TG8RDH4gNmqgJrgHYb4D9Q/i3mAA1PqeVB9SnbzZuvEUlkbkcP/lICJK7i2L9vlICzX+qUcTNe90pcHwsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bza58puVL7K3BBlvsTf2/37EoaRjGqHvqqVSyjNma9M=;
 b=BxCCaUp1c3C4sCY5p/pw/DHS+v0KI39J6by7ywPpy1QkFKXGaMynBm16PT3t5DpbzhPSo3BxC0Nzii3TzPYeG8iJUMtvPdqW3ngVkMOfNycaZkYU0JTAWlBiSfu+78urusd0h1eI1Jx5QI7Jqwy1+iZ+OyTdSoKzIghVKcIsd3L/gbVB8/ykiif9l0VR1WkVuQycN7NxME4fLFyohpbu0yyIytK4sLrZlcVzBI0HV+xHTntreFxh5Gr0drcjnrkRwqMeY9jEMkC1sexC8QwX6rfNGXjtvVRtoBQHjUAqH/v942RbIKQAo5ApCrz2iERIKd6TzCD4/0bEHOQf0Cu74g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 20:53:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 20:53:20 +0000
Date:   Tue, 6 Dec 2022 16:53:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 08/19] iommufd: PFN handling for iopt_pages
Message-ID: <Y4+rvjyNbc9IrRqB@nvidia.com>
References: <8-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <7403f46e-90ff-9761-0b92-8dc8c163ebf8@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7403f46e-90ff-9761-0b92-8dc8c163ebf8@linux.intel.com>
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5a9a65-1b33-471d-784e-08dad7cbe807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vfRH/9oa/DYAERzly9ZujFYW8pzzYgteiQ+aZTjS+TjFGjoxl4UkHeFKeQDxHxxLQ0heCgGEDDm7AkKjclz0jEpn6wXX1lJOvgKHNUrVdfApoxnbgseb1mkPjdGQIkJc7Ix2AuJTRfq8ag5I9dglu0U7BlPGA0hNQE0iX8Bsg6o6JcdV8DMVmAf0FKIYHcPMU2DNFgCs32GpKwRde2iNflVXO0+QYqZ1B7lG+fhIPjE2SJy9M3wupuZqCHApAy/hMVkEc+xQvsPMsLcAw4cNfSd/eBonMfgniUtAki+Atzexr9rnLImiiLsppEALT7CiJ8P29AKlZUd1oM3Tbl/TE/7DR0xZrTmn1cnqvXEmy0YPT0UA6KZvlc9UduGwvGC8S0x69lgLvXyHVCXJQSJhLG+qhlwBj2aSoEfcKaATZtmM60Wm4vrkBOAmre5VQpxMH9VeWnd/9Qttk0lkKLA04v/Sn7qEun6Fdl7Qe6e5Q5Wu9YEykouTUF1JMIMhvZoZ2qwtu0ZPjNjiJCI2H4t5ZPNRQ7hsmRKFld1Kg5oWxiueIbmxxQAGT5bYUjw8hw9RZ0ozW+moLHSPp8F3ZBMs1e9dOTuEyGwbksEoMpFF/GZiWMgGOwuAdNKxH9BhQa/UQtHCHW3aGAvK3mcm01Hba0TELGlv1k7mhcDD7g4fr1CIO6GkT9Auo0MdoV7r0oAm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(5660300002)(6486002)(478600001)(36756003)(86362001)(2616005)(186003)(26005)(6506007)(6512007)(7416002)(8936002)(41300700001)(38100700002)(2906002)(316002)(54906003)(6916009)(66476007)(66556008)(4326008)(8676002)(66946007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tWbFVXmFi/OPfozhVSGIWvtLPcy3iKVxHBnZiFoiNClJBioOV9F/YmitgKdX?=
 =?us-ascii?Q?UbB+Heq+2iagmvt7IGya3xeyBHBczRHYVLJSSVss8zKYpJvkd5UWrbvPM+r2?=
 =?us-ascii?Q?XQa8KUhXIpyib0+MfZPVPM256QUag2Yj2WzjuKa2YQ0+n8OzV9l35cSlMFYd?=
 =?us-ascii?Q?Go9Xj1FbicEr3BbJYNNrajbjRg93kBdWvAJib6Dvu9N8wYUbiVYARUE0pI9v?=
 =?us-ascii?Q?m2sL9HPxqUNSja1Ua5TouLNPVecmECIdCS7wYLW37JNPs2mtCKaYY76I5Cgv?=
 =?us-ascii?Q?LuOU7fyTjoGrSx16XKNNq4v5HBzrEV0hgcOIYpE+otzrtjPUMEME2Z032vHP?=
 =?us-ascii?Q?PGN6TD9jYG71Utwqqm13uguhe933rK8koT8ku+QTokXmilmjiXjrYqD0cVc7?=
 =?us-ascii?Q?JtbvF0p4iKCBuhOHz4vIExCjG92d1TJR3U9ohWBZcNqj09LA3uxkNrGP5uLW?=
 =?us-ascii?Q?c5RDigX5kRtj1HmdBw1JRRIvvoq+KsnE7SOOPLREHWN6FrdE5TAOe0E3K9IV?=
 =?us-ascii?Q?Gl3VLL2M59egyKm255CRw6ueIbvGcZkQ9YrmT86sqf8lMipMPgRUp0yWayvM?=
 =?us-ascii?Q?uKQKAASxAXcfRB/cIhu+dSvUywBlGPtVd45VlhzC2kC3mjnSByZvh+FhOusa?=
 =?us-ascii?Q?RkRZjDbxVgj5uKgbHchKCxQRjcFoT8X7ArYIt82XBbIrGLxuSLbwyI2+PZ5/?=
 =?us-ascii?Q?cKmw0KXafupoeavNYU+FKqsSt5BCK+U+IdQCRdxNLAOJkSa+nRpKCnZK3rW6?=
 =?us-ascii?Q?W5ZHohSq4WrJwJYNtEux15qgrG6VWZzOX/UJTjrrSAb5UaU7rAaGX6/5Tw9g?=
 =?us-ascii?Q?G0MtK31Jcb9eaCkEM2Sz1schRjtdnaN+GXU6Vz/SjrY9sc8cFKivxi54/t40?=
 =?us-ascii?Q?THDbi3egcngtfJRzF5HtaWik9Mp2Fv0zZgi4FzlqXzIH93wSaSNiyGEsQi6R?=
 =?us-ascii?Q?78/Gzx8Ow5hwkHau/DxHHUpr5rigoNuPwj5wmvwbyEGnxtg/xxeDm5Ek/sDZ?=
 =?us-ascii?Q?EREwfvb/kLb83N9c35Jvp8u9umqdA0kwr7dydRC4U6xz3/8oWO050dQAVPZa?=
 =?us-ascii?Q?mR5r9GR+UqdDku4anvutf//dsGbxD4/DG0torJ3JcxHDobQyeafxOUgD4VSI?=
 =?us-ascii?Q?s6iBjfzlZHNIbE/1/YPjUd9C24IK757bXFHZiTWTqCGneduwoUXNePtZXinM?=
 =?us-ascii?Q?Hsml698e9ttl3vnna/bDeDZ3JycF9LlbQJS3ptqhYikso8p0wKuKg0JgzLTe?=
 =?us-ascii?Q?NP2/tz+wrCoSJ4M7zdD58wFBGDEnTaa32OHI484mNdg2Y8BHXLF4tW1Wpgts?=
 =?us-ascii?Q?eS3UBPqBxFiK2Z+NC9MDxDGUqwZYg8BiWyAjJDE6S1S/PD/vIorPlNqibEvz?=
 =?us-ascii?Q?0WMn/QSRh3ozvITeQ/qXDaV5Lsp9bk345DHFYw/EGFhswGMGM8lwEonAka5O?=
 =?us-ascii?Q?gSZrUQilQbZIyC4Ii3ZlpsAqUPnajH2sb6w7NTSBy0GhzvYLWpuCh0XXrF+p?=
 =?us-ascii?Q?3+So4pv4oLH0+3ApmvT1swb5GUKCt+ksTPQcZdPOvjinLjOhu+pEJdfn5p4C?=
 =?us-ascii?Q?m0mfuioSGpBnG5XXvVo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5a9a65-1b33-471d-784e-08dad7cbe807
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 20:53:19.8745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wC69Lo1ldFEh+0MWJunyjE0Rpy5zNHberT+jaNlVBbtUb9nhqhKlPb+fz5/65jKV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 11:58:41PM +0800, Binbin Wu wrote:

> > +/*
> > + * Carry means we carry a portion of the final hugepage over to the front of the
> > + * batch
> > + */
> > +static void batch_clear_carry(struct pfn_batch *batch, unsigned int keep_pfns)
> > +{
> > +	if (!keep_pfns)
> > +		return batch_clear(batch);
> > +
> > +	batch->total_pfns = keep_pfns;
> > +	batch->npfns[0] = keep_pfns;
> > +	batch->pfns[0] = batch->pfns[batch->end - 1] +
> > +			 (batch->npfns[batch->end - 1] - keep_pfns);
> 
> The range of the skip_pfns is checked in batch_skip_carry, should keep_pfns
> also be checked in this function?

No, in this case the caller is not allowed to incorrectly set keep_pfns.

At best we could do an assertion:

	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
		WARN_ON(!batch->end ||
			batch->npfns[batch->end - 1] < keep_pfns);
 
> > +	batch->end = 0;
> > +}
> > +
> > +static void batch_skip_carry(struct pfn_batch *batch, unsigned int skip_pfns)
> > +{
> > +	if (!batch->total_pfns)
> > +		return;
> > +	skip_pfns = min(batch->total_pfns, skip_pfns);
> 
> Should use batch->npfns[0] instead of batch->total_pfns?

They are the same thing, a later patch adds an assertion to make that clear:

	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
		WARN_ON(batch->total_pfns != batch->npfns[0]);

> > +static void batch_destroy(struct pfn_batch *batch, void *backup)
> > +{
> > +	if (batch->pfns != backup)
> > +		kfree(batch->pfns);
> > +}
> > +
> > +/* true if the pfn could be added, false otherwise */
> 
> It is not accurate to use "could be" here because returning ture means the
> pfn has been added.

I would consider this good english, though I can see why it is not
clear.

/* true if the pfn was added, false otherwise */

> > +static void batch_from_domain(struct pfn_batch *batch,
> > +			      struct iommu_domain *domain,
> > +			      struct iopt_area *area, unsigned long start_index,
> > +			      unsigned long last_index)
> > +{
> > +	unsigned int page_offset = 0;
> > +	unsigned long iova;
> > +	phys_addr_t phys;
> > +
> > +	iova = iopt_area_index_to_iova(area, start_index);
> > +	if (start_index == iopt_area_index(area))
> > +		page_offset = area->page_offset;
> > +	while (start_index <= last_index) {
> > +		/*
> > +		 * This is pretty slow, it would be nice to get the page size
> > +		 * back from the driver, or have the driver directly fill the
> > +		 * batch.
> > +		 */
> > +		phys = iommu_iova_to_phys(domain, iova) - page_offset;
> 
> seems no need to handle the page_offset, since PHYS_PFN(phys) is used in
> batch_add_pfn below?

This is correct.. However, the code was written so that we don't ever
truncate any set low bits on PHYS_PFN, which is perhaps overkill.

Given that we already must calculate page_offset I think we may as
well leave it for clarity.

> > +static void batch_from_domain_continue(struct pfn_batch *batch,
> > +				       struct iommu_domain *domain,
> > +				       struct iopt_area *area,
> > +				       unsigned long start_index,
> > +				       unsigned long last_index)
> > +{
> > +	unsigned int array_size = batch->array_size;
> > +
> > +	batch->array_size = batch->end;
> > +	batch_from_domain(batch, domain, area, start_index, last_index);
> > +	batch->array_size = array_size;
> > +}
> > +
> 
> BTW, this is a quite big patch, maybe break into smaller ones?

Too late, it is already applied

I will put the comment fixes in a new commit.

Jason
