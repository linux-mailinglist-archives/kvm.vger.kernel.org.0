Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA25D621D66
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiKHUFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKHUFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:05:04 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEBE67F7B;
        Tue,  8 Nov 2022 12:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELG8tJxXlKb4e/8XVYNQH4+W8v3GciufUZm/8+0esZGpAkRWsNLq/3HLS+BGXBc2v3ny6d+cmZKkWqCtr5bSaE2Y2zDOM/FoF9XPWKmhQ9eRaSs4fwjP210TqvXYc/104xFJxTQoj7T/BmyBq27zga7uAVE5PLLXayydewKnu8NKbzzIxJqlyNzUTcBeHA52zSXVTyrt0MRTtOG2PDGwsLHpYlYFD1sqGfnhLmGOctcYEx6s8G2Oh74ymYm2Msm99PUJb7ji0xZlL6HabrY4mHu202Y+Da7q8fKRbVJCxqbS+f1kNyYrADkVUXKO9NkLo+liHoZKDVQjB96Lk/fKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0ZSdV/HpqvYxxAnW05x8GIEcxjGQbrR5qVsh0sb/P0=;
 b=L3zDRrCVLxdE4ylAT1dd8viODNgg+SeutXKxuCTagwg/OF1pMiqvYKiuNCfXsG7GpTrYZ4JF1197HfXytU0ZjJs7oQvOGRSOGPCct7Zxzo4VM3IMRMgqAbSPR5jciyfHTA7L4oLuFtusOTNMSE2SqBscNQ0eeWBKay4lQiXIDkw5Dg0UXOKPyNtsMUSppoyPVv78fiVh0aX0kvtRe27zxpnqazyaNTPx7ov6Sh6AQabzodGkpBK9a7fyP5boisuIrS+stQVyFME7z2nm1wD/Tf6Xgtenfssw4fAZextUp9lqtU+AU4efQaYaUSfXM98mjBjVpdk9LnB3VF5U2gAqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0ZSdV/HpqvYxxAnW05x8GIEcxjGQbrR5qVsh0sb/P0=;
 b=QwywKxe+NXmYsnp8hsA7R86gycK3i1fGcIEF4cfieFMfKSMWiq5c/MhK94TDvf4xrhU3gA9d79Hy/phvrg5PKBJHoNokDhTGLMjb82SrZEh/NwztBqcwT15Y7Dxmor5JpDbyzS0fZ7NDHEZdJ7/2033xZWD/bF2DD3zX/LEw3zEzQDOVDU9yQD62qmU5VfpelqCN1d3D0VsZuM+YYRLsLMfTfBPq2JJGVzlCXfJwZ9xOwQP7cXguJkgwzpxPcdBiOkpHqzHRYybDb1rvuD5T/pJ1Xx0F2Xy0J2sHxahaw+yTUCN4CnX8aX/WPnqcA5v3+esQk1F4PJw2foBKdp/RCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 8 Nov
 2022 20:05:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 20:05:00 +0000
Date:   Tue, 8 Nov 2022 16:04:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2q2a+uPUDlLuHXh@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
 <Y2pffsdWwnfjrTbv@nvidia.com>
 <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
 <Y2ppq9oeKZzk5F6h@nvidia.com>
 <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
 <f2f8b63c-ecc7-7413-7134-089d30ba8e7d@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2f8b63c-ecc7-7413-7134-089d30ba8e7d@linux.ibm.com>
X-ClientProxiedBy: BN9PR03CA0385.namprd03.prod.outlook.com
 (2603:10b6:408:f7::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: a41b6840-33a7-47fa-36c2-08dac1c48466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gamAvEgwJKyDIRXjxST6ZtfJyn+YGSfwFsuoJEPf7t5mjZFeY1x4wcbPTeO+in7UzsxNeQMjzTa9cd8EFxlY/aF86BueE2elEYH2oCBw+prtg0ghvWaNK2m8RUofsRRAfhOUdNgqREB+I0AM8CaEMaakFf/WC7PlTwAENnci7c6H6I0cqPYKg/5L+IXXFWo7qnPiYor0Zi/tLgh7Cs/YeqTamGFyS7bFXd6VrOKIAMqUnwqPRqGFw848tiCSwBizGr1QpCW2QWsHx/DOUWwd70ivinZJHeRA2yuqOiBxEn8xOMx/SvijegeyG2+8qHGDBJ/O+dzob4qvIfyh9wSiIjZJsjfIb6TJtJ3PO6SSjIWrAeaRgVblK4wbnsA0eiUbRndZjRn2xxI6I4imTzB+8tcE+S+ksWdq7tk/1iSS6kOgTDfkFARSKamR5PWYjvYS+3CTsYxQ5/UIw9t5CiVNBpfDN7I3RHVkbJRg8psru3FKFIjdTbqHgVCqqY650iXdGKz4zfNegW/cCr8SaAH9cMdyKND910Q8YAL1QVlDMqL00Zq+/XVcJtYHVjBTlT0z6/QzHi4lNtxy0mHGng2WthnZBz1qZTT1pbBeP4vlVMRxU3E2RfGI4VmqyzCJx22QQ4BPDOwk33ygEcQi8hoeGb/dqbQ5P9DaXEr1MWuozF3adUODiTBBYo5G1RxyRCIGs4Cb5Qb7IPTtqh3StKcYGChSWCuP9r3lS7idfzRjBPV9/4gqMEG0eLFSzxlOj8f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199015)(6916009)(6486002)(316002)(54906003)(66556008)(5660300002)(7416002)(41300700001)(4326008)(66476007)(8676002)(36756003)(8936002)(2616005)(6506007)(66946007)(38100700002)(107886003)(86362001)(478600001)(83380400001)(26005)(6512007)(186003)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7PP8KvrtiCV079BgH1r56KD/+odG4X63PhrG5YRU29xrfRTxFA/TzxwKeLYn?=
 =?us-ascii?Q?xxPyieRWwE0vOfQkd5qffPWq/kwJCcN6vNtiqAPvdPKY24Yx6bik684Sg+u1?=
 =?us-ascii?Q?BcgKobdbNbwBjDcxMMHGor9Klv1CYPZ0bu1Q46AyaDnzndrflMtYNtvujC1X?=
 =?us-ascii?Q?fxfmoQlQoOn/SbL5WJoe7HWbOEXLbv90pItjAnnQDOQ99yQd+HPDKSnHwMb+?=
 =?us-ascii?Q?tTcl2eyf8FFZfZhRTFZwcoqOxo1CnltvzmdioilTQOaGsmgFT/HrInQ3P0JY?=
 =?us-ascii?Q?psjMxD0ND2Fmbp5lmKzg+1D9zgYPFZeb5zGkUqOc09R6iufCHJuarfgJG1TP?=
 =?us-ascii?Q?fnYo8vHbLOP3OnU2WSquMqHAtVFoB58/xr8R5+DOly7mp24tKKmLVYUtgg1g?=
 =?us-ascii?Q?p+hxxitBfVq4OkHfRaIjonnXMzWfIOuHrQs84g1hdlXtsDHOY37Iw8iB1r9g?=
 =?us-ascii?Q?rvvg0v/7bmIa6qIi2hF6M/NIjBGEG2x6SDuzjFYgYZpJSaBtJmHhomF1PoDu?=
 =?us-ascii?Q?o+bm5JFmrXVF+20IyRK/0K0yshidS2sB2sIVA+gicUi8+CwYJuNeNobiSlbv?=
 =?us-ascii?Q?qa+h8VG2In7yAtB8IaeocODe2yGXGphwYNmuCS+vSERU50fFWRykF+QPDj9k?=
 =?us-ascii?Q?qJDfbu8RxfI9pkqhnfaTRd7t/7gD8+6m8RfQfUCrxUpuJqdvqIU3Z5mnEUWe?=
 =?us-ascii?Q?HH1rb/JOY/O5rehoHkHn8sABkA3EruEwlw1hu9qcx+T7XysDPL44zBoPvTuZ?=
 =?us-ascii?Q?NpowdUJW86SOJ0BhB5rBnkt/b22owLIAsxUrDuupJqLWztK0tE4pbR/OKtEW?=
 =?us-ascii?Q?4rW0nDFEXkTdVniyWXNj6d/M4p4mMMYHBmxeNCpGALxqtloo0idI2twHXi/0?=
 =?us-ascii?Q?kmoWbRGzaCAefVusKLI+G5Jjag8t4Vt8t6USrGJagPpQcqmIXdxxdyCT0ne4?=
 =?us-ascii?Q?cUOnsNMMErOU+wpTfosHH0XMyIIX6q+7AUH8Drpa2Qdx9DuSpeWlyPMJmGNy?=
 =?us-ascii?Q?IwGD6iYyjFxWM0qnyvaoeb3qI3fx9J37NHzLcJRjI4r0SBbL5ZtIiUB8yMEG?=
 =?us-ascii?Q?krzjvcqADmz4kIoWTx7aEAy8V8Dps57pcJr1vLNlSSiWs+YmqhAW+jnTw3ZJ?=
 =?us-ascii?Q?fA3JD+g0sofgj134dKaL7YIpLAwCS2cVLqEB8UlU1ni6vtDChX6RF+pcc7nq?=
 =?us-ascii?Q?7K+JhVNc7bnnfVLAM1YoVJ/BrET11SubBfVc/4doRn6Rihx8SPthCfZP8/DL?=
 =?us-ascii?Q?MgMWD7bLbjQhRgJBKlmTGkwjP7G/+CE1v1TMxIguRs9GvfFS0T+IRVqnOQSF?=
 =?us-ascii?Q?ePCAz+HG8ri1x6pJo/8MvilQNW6PJ5E0pjjuw+ScnmCa9kKA417o6rcMgUk5?=
 =?us-ascii?Q?Tu8MSCYUq+sPfHB4tE04HRUSDgbzEwq8GFS9oGXfoFS6bwYJCDWdeIplQp/P?=
 =?us-ascii?Q?9FXsQEN1reirMYqKKJ5NLMh9c12dHl5dCXr50cKPpCGKEoCqXD4hG3fDbHv9?=
 =?us-ascii?Q?dN+BTT6elnL0xprSnzB+w488vnLczo5aZS8TzxTGiCAd1P6eG2A1bd20uwDD?=
 =?us-ascii?Q?QsBdipmqRReqwZ49NW0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41b6840-33a7-47fa-36c2-08dac1c48466
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 20:05:00.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wykydf/fB6nf2yqgABnM2p0iSB/NysEBcoHazhIhrLe4wVcC/toExMqUGR40lkot
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 02:18:12PM -0500, Matthew Rosato wrote:

> Update on why -ap is failing -- I see vfio_pin_pages requests from
> vfio_ap_irq_enable that are failing on -EINVAL -- input is not
> page-aligned, just like what vfio-ccw was hitting.
> 
> I just tried a quick hack to force these to page-aligned requests
> and with that the vfio-ap tests I'm running start passing again.  So
> I think a proper fix in the iommufd code for this will also fix
> vfio-ap (we will test of course)

Right, so my first fix isn't the right thing. The APIs are mismatched
too much. The length gets all messed up in the process.

So how about this? (drop the prior attempt)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index d835a77aaf26d9..b590ca3c186396 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1906,8 +1906,13 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 
 		if (iova > ULONG_MAX)
 			return -EINVAL;
+		/*
+		 * VFIO ignores the sub page offset, npages is from the start of
+		 * a PAGE_SIZE chunk of IOVA.
+		 */
 		ret = iommufd_access_pin_pages(
-			device->iommufd_access, iova, npage * PAGE_SIZE, pages,
+			device->iommufd_access, ALIGN_DOWN(iova, PAGE_SIZE),
+			npage * PAGE_SIZE, pages,
 			(prot & IOMMU_WRITE) ? IOMMUFD_ACCESS_RW_WRITE : 0);
 		if (ret)
 			return ret;
@@ -1937,7 +1942,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
 	if (device->iommufd_access) {
 		if (WARN_ON(iova > ULONG_MAX))
 			return;
-		iommufd_access_unpin_pages(device->iommufd_access, iova,
+		iommufd_access_unpin_pages(device->iommufd_access,
+					   ALIGN_DOWN(iova, PAGE_SIZE),
 					   npage * PAGE_SIZE);
 		return;
 	}

Thanks,
Jason
