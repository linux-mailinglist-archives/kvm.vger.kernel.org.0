Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5207D7098B4
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjESNtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjESNte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:49:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BACBC
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:49:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Twk2UaI/qxLWwXmI+HZBTuOgt/wN+vryWIbY+7VJFH/Vsk5K5OzDR/G/n8ZcTU6bYKSB/LoIQuNFKmqXpscrqr8UQiG1R/3Ku0lRotq/TD9lfvPibxcQHaxbBR7gOmT8ejzhcX4hLzarx0fXXtNGH5qXk1cXDNKj2GSen9TtXKU6JdfLELG1DnykIesdzp88HjQUQl3OcvnhW9HNpj5TcJSMzMub0Fuv/InikW1GTZmB9pxmnYXKQBkW3obp6Se4BcglR24G1YXf+GMc5s6Rt2BYLoEVUFSNU6jYVqq31rLsEVo3O6JMNsizFU771qWmg6Bp+sDMhvLpLzD0b69XlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yE7PCkTVRZpP+NZSzgsP0TLJ/650CMMMTZuxUJCRmo=;
 b=N3s3drPRtKwjNdLvguHPfcD+6N4vvIGZ+fRVCfO2PVpZQr7RucPfumqP+MkasFMX4Nsnrflwb05blxEP++1NhIxjA0aA30sEiY3pk+fZHcAK51pujQ1HLPcoEWCNewS8XbPPtJQCFqKVXzF+FH+0R7DqEBnN3pEpKVliH3PscR8YY83jRQ0p0KVdcY0VcwNuOsrdGBlDl09T9IAE4gOxYEyKCySAcNgM8wpoEcyzH/mcAt7CkWj1Vlr/71zMke86w5gXEwYcQs0wk5hQRVcCQmdEoEy5n4JNuAQazeFrcMr0SUqrmFvKFDFqXrKNSNDvTvrte2sNBnKJ5zr0eaRYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yE7PCkTVRZpP+NZSzgsP0TLJ/650CMMMTZuxUJCRmo=;
 b=mOWBfHouYUPJumEsBYm3jqYdXoFQomMD4GtNM79UmcLpF4M44Ad0Hd3QrcL7igz0kryiJTAOMi9pXo6yZ6pV2HSz3y6CXVugo//b5619Z4Fy9LedxGL5MR4gbpY+24rHwE/wXOpCFnI4E5t4n6l8PBe5xAjl3gYASLm0uOggdJ0QvIZ1BOkCSqjiD4nYq8yBUHMd778AK6DbJFsSZiyomOwvQ1dS9F+rgnjfgDHyqyEtSaDQcdP6WCaXT5g154sqqhX6RngP2TesZhbsZTrYyHWykxzvqCl/qmUC4dLM2toUlwBUJilrxgZl6Qvhar/TPKDH26dZ2EiX+P6dJdHYag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4279.namprd12.prod.outlook.com (2603:10b6:610:af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:49:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:49:30 +0000
Date:   Fri, 19 May 2023 10:49:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 09/24] iommufd: Add IOMMU_HWPT_SET_DIRTY
Message-ID: <ZGd+aNMNyd9ZXF2L@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-10-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-10-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0d652a-1a43-44ab-b976-08db586fdead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWQ646mTBw7eTept9TTzpGjvrvQhLOKZ38k3bITCm5YR9oj07TBhLhhlB3uKbe1USI+E5x34RSkZ5yVMF4cd2UUF3AFih4teEHNKQGHfdoteCEsJwFhXhEbcAJJpdTsKZJ5HIAaYNpnCH/8BXuel+bxvi077VPg8Uy5BRq2ozFMQav2ZAT545I/saINaSinxyWmWk9QwrOF261jcUXmm7whF0yeRs4Uu5zOUguVlGUzhs42aQu/bREw4VQTUHuN/O7VBo8lR4m40D9G8T90mAHK4DnNPfozikXgn18RNHVjaDBqV5QRN8dqXTZZjml5FRBOjRWwZ9TNlfUaEJUUuRFy1htRfy2dtW1Shmn4IYOfKB3a7EpGwV4cRuGcPKiQofNVaDDD1ZaaWrrQs3+9Zs4eZpDPOd7/r6kQ7T2bGFAgxyPmCxqOHTVKkFETFxfG7MhVzgggxlsbDejno1i4nxTyUBOBFKHHFCFYsseiPEyRblbKuzbzjXDYJ0m7V58z1swnSv9g/N95JBpixMNB3AgYW6R9rncqsCv/BsRVzRpuleOkisJ0eFOaU+SUIJitcl9KMTJ41Vrp8ClPvb1rQOXagjBL5P+h0XctvvMBVYPkOEzBnckDh5r6iMjZ6AlYGpLOBKzOjKvi2TSQyBpnjRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199021)(83380400001)(36756003)(6916009)(7416002)(5660300002)(8936002)(8676002)(41300700001)(4326008)(66476007)(38100700002)(66556008)(66946007)(86362001)(316002)(6506007)(26005)(6512007)(2906002)(186003)(6486002)(478600001)(2616005)(54906003)(14143004)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sp3UQ7VNHLOvJsuoeevtza0LLolH7v5qPSet/bzaHBBnveClXR3211fOzV2m?=
 =?us-ascii?Q?EfsSdLIbXBmV6M1w2DacGSSywUV3LPgVa6l12SLdjlpGbJW8XrpZNYPPOq7F?=
 =?us-ascii?Q?iQFNEVY2LVhP6STPBP6v0ZboJRBfhDTcA8TUExgnOGFd4pzfwwdzebvCeC9f?=
 =?us-ascii?Q?/TIGIYomNQtJL3b6f0gtEhWevB65JOhFTpbJoqYNpUXWKWQUs/koavFvAuVX?=
 =?us-ascii?Q?yY6PJ4+k31Gv10WOEg8WvO4coVGp6BUbQVW4R/jggM30FYa9SN/g9s+sSs2f?=
 =?us-ascii?Q?flKOIuSV6tsPiaBRiUDdU4hPk+fFRhgOkGLBfADpRd74GWYBd+JZjZANKUxU?=
 =?us-ascii?Q?Cm4+kNQHzMBUPiVtvvmkl3VFRCfvROHRgi8cAcICJArjDOzCBpkQq/44Urlk?=
 =?us-ascii?Q?TmJqWsogfmiOSMIKQ1Oj39P62rdDCA0SVJWjurLvKG1Zgt7mVTGYbZ5kjsvQ?=
 =?us-ascii?Q?/eOrh6iwHOz3Zb9xaS2/T02A2GU8nxwWeve91LN+9nedJBQXCP5R+uPC7yJe?=
 =?us-ascii?Q?1+N/2IJzNrPeJ3mLfTvcMjt0VWD7bybIDCO7XObVKfAQDDinKmd/A1b4ctvK?=
 =?us-ascii?Q?g4twgM/1DTQ69mh2r2/axGI7h3yAOWg2ZwrR951IKknJc9lUFjOj5J/d5H8f?=
 =?us-ascii?Q?V/WTmpAh1H6yv/WD1Tf5e/xhHR1Zn6K9eyl9lQNUVe62a5sC1G38bsCwgrcm?=
 =?us-ascii?Q?TDDsRQSBcTMMiECU2ixNHLNpnMTFhsextvvXQihMSgXLfCSTMgiEeXRijyit?=
 =?us-ascii?Q?ht95e8VazfMlKZOVrE/8axWdj23lnoOkPGLml7TTkHharblAjo7StM6W5/5n?=
 =?us-ascii?Q?brJKXD4QJe2iRlvf2PfSfvW37CjubXB5oOT/VDN4BqednxxgbaajCpuR+1Qd?=
 =?us-ascii?Q?iEjWFwie/y2L3FtUtKDyhG9MXitkZrn/UfLzSGfcsgxSkjsshF8+fR5QI523?=
 =?us-ascii?Q?mtP7OKtYTq1aY5PATcOok+lKXOh+32HOFrV7Jdk5L0JJtQ8oAi3wSIGK3C9X?=
 =?us-ascii?Q?bsAX85/OrGoKpO7aIyxnqXlwhKfhNerrtuUzWRsVMYfvqvSZZub0fETNFAu3?=
 =?us-ascii?Q?bdTgZJuoN7fLjK52AMrDaLbW09mcvscU2GPNFD7ImJ0rd5ck4eZ43lOlm9op?=
 =?us-ascii?Q?vesdeJc8cZ2uQIUGAwCyh8CNQhJ5k0Uf0CEVGk2mfXV61NCekmySr5S4ynDx?=
 =?us-ascii?Q?4DYdeAbiO42nUO/zy7SVEvrjMDV6D0NfhlzgntDeVD6s0UbR3wmdewgAydlS?=
 =?us-ascii?Q?pwF+F6lQw+qnUsogHz+HH5AAu5fDpgz3Si7aMISYuuWQne/WIw40WLL/6yX1?=
 =?us-ascii?Q?8RS2hA05olPRgCe7dEToRBu8rzWvQOHoEPv8e8THZYIYW/byVg8n9niHABiX?=
 =?us-ascii?Q?X+KP7ba2CmwGC/8A3+nYZEsb0dccgo2l6C7H0UDylf6w9Ns+gqKVqWys1Xw6?=
 =?us-ascii?Q?i351qCPMMFKO7jdLqeRpBmyKHnl4hSklIsjT4hkMk0DPHfXweDR+ssckr0ub?=
 =?us-ascii?Q?koapWyIjqplGkXFSlM+kpYZrhx8kC/4zVPqr4mS4MN1/MuMCAY15Z3n2KoFv?=
 =?us-ascii?Q?ud+893ZZOX1dDYpHxFUo2XHcluQ7GuJxhEXqVH2l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0d652a-1a43-44ab-b976-08db586fdead
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:49:30.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNOmZ9oxs92Jv6RM2YYRhve4QJ2nqwBCqhYcx8Of4ETAcalh6eOvEqdmRK/E42ur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4279
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

On Thu, May 18, 2023 at 09:46:35PM +0100, Joao Martins wrote:
> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain, bool enable)
> +{
> +	const struct iommu_domain_ops *ops = domain->ops;
> +	struct iommu_dirty_bitmap dirty;
> +	struct iommu_iotlb_gather gather;
> +	struct iopt_area *area;
> +	int ret = 0;
> +
> +	if (!ops->set_dirty_tracking)
> +		return -EOPNOTSUPP;
> +
> +	iommu_dirty_bitmap_init(&dirty, NULL, &gather);
> +
> +	down_write(&iopt->iova_rwsem);
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX);
> +	     area && enable;

That's a goofy way to write this.. put this in a function and don't
call it if enable is not set.

Why is this down_write() ?

You can see that this locking already prevents racing dirty read with
domain unmap.

This domain cannot be removed from the iopt eg through
iopt_table_remove_domain() because this is holding the object
reference on the hwpt

The area cannot be unmapped because this is holding the
&iopt->iova_rwsem

There is no other way to call unmap..

You do have to check that area->pages != NULL though

Jason
