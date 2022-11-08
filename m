Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8669C621D10
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 20:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKHTfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 14:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKHTfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 14:35:03 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC59657CF;
        Tue,  8 Nov 2022 11:35:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQDXImWKtSotk8kmi8//qUMdpoF4iqB0WSPMJEKLkhKacVvYKSaxhwSB9A77KiwogukIUH8lOJjIfrgB8cohjveaOAcnSeIeE/ypu7a5+NPAaRQSima2f8Hk7zdSdHDRFUqsIjuRt0i0eQY/9WWhC7Iqwe9FVlusYCAPWqRVPkBnQK/fFxyRPFEJ9smKp9K2IbsGVBfaBDHHlQ6cYGYElFN80j2Mlcoyypb7D/mdkSsdyIoMaHm46X2TLIdxxlzOeOH/QXIC84UwrJs36wzcj0psOASaQs2qspOm9zAc/WwydAUVJUy3Jija/AeZs5iTuYUtYDFK7RE3cIpVg4cVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IV7F3Jm71h0HvJxD8Ez36/jroD1b2muPwcjJFWBApEk=;
 b=Tj4USb1fC6WV9YI4sMS3X5r8pGYLWMC+j9OtEwPtgYobl0FIr2uTmkxdGIcpst+LrDAd6GZlBV/b+vmKNZWWm6lZHQ4Q5YxJFekwfpOivvzlku5RpauXjN0KwDvWEWiw0AJeiSqigh98yuXXAov0jjj2zGXJ1LzNyKy96eyZKB5ivELQQtRSfPgvr+zp9M8gVwJLIfEfOj7GBD1Z3lByd3VtWCZF7WkO7GdmZixD5DW0bGn3IymKomD9cBBDVOOvb4I2sAW6GbkKKoYcJv2MwE39ge0iDQ5PTnJ/p0LOZ6XLZS4uOoZ0wzYTt0H62ytyJJEAJid8GUGpTva/WR2VWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IV7F3Jm71h0HvJxD8Ez36/jroD1b2muPwcjJFWBApEk=;
 b=U2pIRmxjqLzke7DX3nVJGNLi6r9srCALO55af/DHELHrhh439Me68AV52nBbwCPVGkUUjiNrq8AMhKs7cau+fwUXQ/C1NxEAgC8mVOC64lmDE98eh162x3xCaml5irkjGd069XJVSaA6wZGZkZvDEhkaOunoFLyYNQ6qdY+QmbhzXVPpI9xG22S/ldOUdticru8htPJurhTAsSyPk6Pr9+j7rF8/5VS9Uj6MjUI6w5f7FjaguteV1Gt0MO4/zAAr/15Xv4kMLadShmHqWr9RTKEEFlN0HNJu5o/N4hw2UpPV4g27Q6WduVII6AGetsEatpj6gLxx0/jUzd2OdCc17g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 19:34:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 19:34:58 +0000
Date:   Tue, 8 Nov 2022 15:34:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2qvYJRsv+mO8FSM@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
 <Y2pffsdWwnfjrTbv@nvidia.com>
 <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
 <Y2ppq9oeKZzk5F6h@nvidia.com>
 <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
Content-Type: multipart/mixed; boundary="rAWCOESWRn5hSldd"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:208:32f::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 055cfc07-d4f2-4caf-60a2-08dac1c051cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gmKoi3JRSFhrkX9ljzvLlRPhlstr4sk0ld2O5se2MHYg3RsEwT7KZ2VmalfFbfEMHdjO64s5UsN82j50qwCIN3/QM4owpzzyRBnIel7ORMwrigovhJNkTtU/X8H0gIdIyHtXB2YGqgm7FOxjMliia+pOPOZNGHwDdemE+LbBQM2I2qCbh4q6sc4qySZ9SnQtdeFybSRx3tbyrpWdMOLMQ/XBtEsqtYgMGyFQtRVUcbK9tbNGUb/uEIV3ekJN2148RWKkwbfRN2bbdIQqPcZ2Dou1NAe34wCZMWldgPT9JL6souz7S/hQRaB1fia0iF7i+bbMP6PQe4gSUI0l2FSfDZJaL+A2wJwmo2TtdBgI3rPKD3jG7FS5r/9zzsYxKX2zviBg5Tbcb3VXuV9iywNeonzNniIartX72dZYIr/u4J6vPy/G1j6b+vsRsfHh81zBGvBJn7Pa2drtxD+ZTIr+NU8hMxx+BJQlzyE8cCFYwtG0OAAxG822GKSOEWEKX+yA2Vq34N4GhiDWm/u1jav2oAGEMNLwbZmiRcq0QAysI/+SEOyTgGHr5Md008y0ue8yxTKccWp8ocdYshDIchIzUz3LDn9STiaVBln0thHgs5rY34kGhnLDTbvsUt4/3PMhomz7giFZuHc5E5GP6dc/2oYqrhfFWAEcXUMxLgP/rnbYvmBdNIC6R7bTay5iG3RM/NN3VO+8U+MkVPEd5GkODTNHfCamuCejbh11g9F2/U0l1M/PuvkSr2p+bMrjMF4zYCyaSOMzIeJBivnaVw9s1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(6486002)(6506007)(33964004)(107886003)(2906002)(478600001)(44144004)(38100700002)(36756003)(66556008)(6512007)(86362001)(26005)(83380400001)(2616005)(186003)(66946007)(66476007)(54906003)(6916009)(8676002)(41300700001)(4326008)(316002)(235185007)(7416002)(8936002)(5660300002)(67856001)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjJIbGpYVDk4V25vcDU5Y2xmbnhQWERraHg1SkhJOFRTVEpZVWV0bThnaW1S?=
 =?utf-8?B?dXFYNVhhTzd6VlRnYnVJNGE4ZCtLK1lzakUvdktDdnowa25haXJjdE5Od3Ft?=
 =?utf-8?B?WS9LV29IOUNSam0vdmxnT0ZYS0ptSmFBWXhScDhFcFQyd0JjRDcwQ1JSV0RB?=
 =?utf-8?B?RVZEY0IzSDJIdTNWK3VkcTdPNTRzMmNJVjFUQ1VlY2l2Z24wSlovNlRwRWF4?=
 =?utf-8?B?ZkRMNjIvVHVnK3Jjb25QYVowTWRRWVNHZElvMENReUdlYUFaRkZlK3cxUkpn?=
 =?utf-8?B?dSsxdytjRk5MZFI1Vm95d1Q1a1Z4WEV6YnVtd1BraW5YWk9iaWZETkxaUktj?=
 =?utf-8?B?Q2JmSk9GMGpqY3Rmd0lmazc4dUp1TU96WVRsdWtQZDRMSmExSjRwSFE0OWZP?=
 =?utf-8?B?a1I5UDRySHJZL0JKQ0NlTXVYaTdiWHF1M3hWd3dEcmMxeHBaNDNlQXBrUThE?=
 =?utf-8?B?VTIrRU9sbzlra2R1RE9sMVA0NkRCaFZxcDhJOFBSZlZWbS8wSDlVUW04TUlU?=
 =?utf-8?B?OVBMcmtHbExwS0gyTWZYMVoxWXlFU29ndjh1KzU2L3dpNVR5aE1sOUJGQmpR?=
 =?utf-8?B?Yzc2SW5rZzh6cmhUZjg0VmJJVkxoMDc0LzFEUXVhUmZLWGp0RUpHN0hXd1kr?=
 =?utf-8?B?WnJudmkwV3dzMzBDUkN3UTZHVzBLNWkzM2pMbjdjMWVSRk9wM0llRFBBa2Fa?=
 =?utf-8?B?KzQrWjN0a0dDMzhrOU11NTI0TVkxMUV2eG91OWtPMS9pUktMQWovdVVYOXdk?=
 =?utf-8?B?cEhXNnB3KytFblpxTjhIS01LWmEvY3I0WGdKZDVCV2VPZm0zV05vODUxVWZm?=
 =?utf-8?B?SWJadFdCcTBtQ1l2Q1NZdmpBeUIyS0NqbDRnekZzMlJaMDgyK244dVFIa0p3?=
 =?utf-8?B?OU13WHJISTlhSlZwRXdpYlNXYTRSVFRJdU81UmFrWXFJWmdiVzVNRWRKcmFv?=
 =?utf-8?B?b2ZEcDZDdjhWdDdHNTZWNzB2Y1NMemhpK3JHV0Z1cmZZZlUvOTE2MmJZUEw0?=
 =?utf-8?B?Qk1LQy9IZWlBQU1tQXhQWFBpWVRxWVloUGhncEE2Ui9ZMWEwV1dpbmQ2aXlw?=
 =?utf-8?B?SHdKa3Jnc0xsb0xoR3VDZzZLMnBETEdwWjc3Q1NmdGVlT0hkQkV3dU8wWklk?=
 =?utf-8?B?SWZONUlQaWpnek9MOFV1c01ERkR0Y0x5dTMrQjFnL1BhaDNkVWZTTXZZenEx?=
 =?utf-8?B?MWt2RGRMUnBXMk0xdnNZVVh4anVlNnk5Ymo1cFNnZEZ2M080QjRTbDVnb2lZ?=
 =?utf-8?B?dGpUcUt6emVTNGdneXJ6U3hWTnJEYmcrTS8xblpKZk1meU1YVzI5SlFYZ256?=
 =?utf-8?B?dXVITEY5NUFYc1JNV1pIVklQUEtKQ1loSGhWdEx4aU9IQzRQRklOa2tYY0F1?=
 =?utf-8?B?NXlVN1RlSVd2V0FBS1g5SGg1MkY2ZzJhV3Y1dlRTdUhqSFc5eXlRMGhUWkJh?=
 =?utf-8?B?V3NvaWZUcnRnVW41WDNWWFF3UUhJWlFYSGpUY3RJVzdBYUtXeDltNURqRFVh?=
 =?utf-8?B?blVFNmpxMjZiMUdPbHMxU3Vacnl3U0oxdUdQa1o4OHFBc3QyQ1l1RDNPU2JH?=
 =?utf-8?B?cGkyK0hhdTQyaUJMTXdMSTA2TkdIdFlyOGFjR1NFU1A4ckVPTmdNZ01hS2da?=
 =?utf-8?B?ZU94UUlaY2VyWk9mTmlsV29LSTVtU21HRXJnaUNOdG5oTUJzdCtkdFNqZkJ6?=
 =?utf-8?B?V2tQcG0zWWdJRnpkbG83VnFyajNnLyt4VHY3NFRxaVpuSUptSkQvR0lNcjlM?=
 =?utf-8?B?Sml4MEV0QjhGZXc3OUdQaWdadnAxNVRjbHFnSCtKYk4wdThBeEZxSlJKbVBo?=
 =?utf-8?B?WUFocm41a0xxUWlhSHIyTWxjM3liV0ptSHRhdVpNMHRPTkYxSURPTGtWRFg4?=
 =?utf-8?B?NE81WHVwUlF3UUw4c1ppdml1WXFqQjAxZkZKak0vT2tzRWd3NXpWNkRCRnFU?=
 =?utf-8?B?MHhGemhRb3JHVjZ6OVZGMVJiWnhVaG1lZEk2WjhoSDdkTDJjT2xOY2tjL2FP?=
 =?utf-8?B?ak9lWWVVVDhreEt6MW1IWVd6T2xxVzNjdFZNVHoxSHZJdFlPSjdZUmFEdC9t?=
 =?utf-8?B?a0Y1T1BMNkZ5b3ExNGZFbDg5c3JnSmVKNUJnRmZqV0xRQWxkU3RUVDVvMjhV?=
 =?utf-8?Q?0b0o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055cfc07-d4f2-4caf-60a2-08dac1c051cc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 19:34:57.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kT58qYUZsaiyFPxt2lFP225Z6HWmwwFJgVticsG86//nMjjhNamohUBSuc+Oz2zk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--rAWCOESWRn5hSldd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 08, 2022 at 10:29:33AM -0500, Eric Farman wrote:
> On Tue, 2022-11-08 at 10:37 -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 08, 2022 at 09:19:17AM -0500, Eric Farman wrote:
> > > On Tue, 2022-11-08 at 09:54 -0400, Jason Gunthorpe wrote:
> > > > On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato wrote:
> > > > 
> > > > > FWIW, vfio-pci via s390 is working fine so far, though I'll put
> > > > > it
> > > > > through more paces over the next few weeks and report if I find
> > > > > anything.
> > > > 
> > > > OK great
> > > > 
> > > > > As far as mdev drivers...  
> > > > > 
> > > > > -ccw: Sounds like Eric is already aware there is an issue and
> > > > > is
> > > > > investigating (I see errors as well).
> > > 
> > > I -think- the problem for -ccw is that the new vfio_pin_pages
> > > requires
> > > the input addresses to be page-aligned, and while most of ours are,
> > > the
> > > first one in any given transaction may not be. We never bothered to
> > > mask off the addresses since it was handled for us, and we needed
> > > to
> > > keep the offsets anyway.
> > > 
> > > By happenstance, I had some code that would do the masking
> > > ourselves
> > > (for an unrelated reason); I'll see if I can get that fit on top
> > > and if
> > > it helps matters. After coffee.
> > 
> > Oh, yes, that makes alot of sense.
> > 
> > Ah, if that is how VFIO worked we could match it like below:
> 
> That's a start. The pin appears to have worked, but the unpin fails at
> the bottom of iommufd_access_unpin_pages:
> 
> WARN_ON(!iopt_area_contig_done(&iter));

This seems like a different bug, probably a ccw driver bug. The
WARN_ON is designed to detect cases where the driver is unpinning an
IOVA range that is not exactly what it pinned. The pin side already
does this validation, so if it fails it means pin/unpin did not have
identical iova ranges. Some debugging prints should confirm this.

I looked at CCW and came up with the following two things, can you
look at them and finish them off? It will probably help.

Thanks,
Jason

--rAWCOESWRn5hSldd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-vfio-ccw-Convert-to-use-vfio_dma_rw.patch"

From b6884847ece19733065fa246c3bbea63cec474c3 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@nvidia.com>
Date: Tue, 8 Nov 2022 15:21:04 -0400
Subject: [PATCH 1/2] vfio/ccw: Convert to use vfio_dma_rw()

Do not open code a slow version of vfio_dma_rw() as copy_from_iova().
The core code provides this function now, just call it directly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 57 ++++------------------------------
 1 file changed, 6 insertions(+), 51 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 7b02e97f4b2914..f5f6eff005b99f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -228,51 +228,6 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
 	}
 }
 
-/*
- * Within the domain (@mdev), copy @n bytes from a guest physical
- * address (@iova) to a host physical address (@to).
- */
-static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
-			   unsigned long n)
-{
-	struct page_array pa = {0};
-	int i, ret;
-	unsigned long l, m;
-
-	ret = page_array_alloc(&pa, iova, n);
-	if (ret < 0)
-		return ret;
-
-	ret = page_array_pin(&pa, vdev);
-	if (ret < 0) {
-		page_array_unpin_free(&pa, vdev);
-		return ret;
-	}
-
-	l = n;
-	for (i = 0; i < pa.pa_nr; i++) {
-		void *from = kmap_local_page(pa.pa_page[i]);
-
-		m = PAGE_SIZE;
-		if (i == 0) {
-			from += iova & (PAGE_SIZE - 1);
-			m -= iova & (PAGE_SIZE - 1);
-		}
-
-		m = min(l, m);
-		memcpy(to + (n - l), from, m);
-		kunmap_local(from);
-
-		l -= m;
-		if (l == 0)
-			break;
-	}
-
-	page_array_unpin_free(&pa, vdev);
-
-	return l;
-}
-
 /*
  * Helpers to operate ccwchain.
  */
@@ -471,10 +426,10 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	int len, ret;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
-	len = copy_from_iova(vdev, cp->guest_cp, cda,
-			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
-	if (len)
-		return len;
+	ret = vfio_dma_rw(vdev, cda, cp->guest_cp,
+			  CWCHAIN_LEN_MAX * sizeof(struct ccw1));
+	if (ret)
+		return ret;
 
 	/* Convert any Format-0 CCWs to Format-1 */
 	if (!cp->orb.cmd.fmt)
@@ -572,7 +527,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ccw_is_idal(ccw)) {
 		/* Read first IDAW to see if it's 4K-aligned or not. */
 		/* All subsequent IDAws will be 4K-aligned. */
-		ret = copy_from_iova(vdev, &iova, ccw->cda, sizeof(iova));
+		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova));
 		if (ret)
 			return ret;
 	} else {
@@ -601,7 +556,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 
 	if (ccw_is_idal(ccw)) {
 		/* Copy guest IDAL into host IDAL */
-		ret = copy_from_iova(vdev, idaws, ccw->cda, idal_len);
+		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len);
 		if (ret)
 			goto out_unpin;
 
-- 
2.38.1


--rAWCOESWRn5hSldd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-vfio-ccw-Fix-error-unwinding-around-page_array_unpin.patch"

From 7cd2cccf37db91d18da9d041826f0460a56fc95c Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@nvidia.com>
Date: Tue, 8 Nov 2022 15:31:08 -0400
Subject: [PATCH 2/2] vfio/ccw: Fix error unwinding around
 page_array_unpin_free()

We should only call page_array_unpin() if page_array_pin() has succeeded.
If page_array_pin() fails then it undoes all its changes internally.

Split free and unpin into two functions and only call unpin in the one case
where everything has succeeded.

Add missing pa_nr = idaw_nr assignment

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index f5f6eff005b99f..4eab1b2fb32dd2 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -164,9 +164,8 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 }
 
 /* Unpin the pages before releasing the memory. */
-static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
+static void page_array_free(struct page_array *pa)
 {
-	page_array_unpin(pa, vdev, pa->pa_nr);
 	kfree(pa->pa_iova);
 }
 
@@ -558,7 +557,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		/* Copy guest IDAL into host IDAL */
 		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len);
 		if (ret)
-			goto out_unpin;
+			goto out_free_pa;
 
 		/*
 		 * Copy guest IDAWs into page_array, in case the memory they
@@ -566,6 +565,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		 */
 		for (i = 0; i < idaw_nr; i++)
 			pa->pa_iova[i] = idaws[i];
+		pa->pa_nr = idaw_nr;
 	} else {
 		/*
 		 * No action is required here; the iova addresses in page_array
@@ -577,7 +577,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ccw_does_data_transfer(ccw)) {
 		ret = page_array_pin(pa, vdev);
 		if (ret < 0)
-			goto out_unpin;
+			goto out_free_pa;
 	} else {
 		pa->pa_nr = 0;
 	}
@@ -590,8 +590,8 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 
 	return 0;
 
-out_unpin:
-	page_array_unpin_free(pa, vdev);
+out_free_pa:
+	page_array_free(pa);
 out_free_idaws:
 	kfree(idaws);
 out_init:
@@ -697,7 +697,8 @@ void cp_free(struct channel_program *cp)
 	cp->initialized = false;
 	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++) {
-			page_array_unpin_free(chain->ch_pa + i, vdev);
+			page_array_unpin(pa, vdev, pa->pa_nr);
+			page_array_free(chain->ch_pa + i);
 			ccwchain_cda_free(chain, i);
 		}
 		ccwchain_free(chain);
-- 
2.38.1


--rAWCOESWRn5hSldd--
