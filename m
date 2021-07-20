Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB423D04D5
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 00:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGTWLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 18:11:20 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:10081
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231523AbhGTWKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 18:10:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYmvT1EikJFBV1FlQt+mvo4B9pXptJLC8FWNheMBUXQfOiL/sPaEFda+0Svv3v2noJHjb5J1pLl4BrB3M0OmVgPGR3oM41sZ0O+kKEMwkWpZvU/5TfXSn1YK3WjoT5nAqcIB24i77tZi7HiFTMFYAMvdsDhOxQH3eA3LSwdiVbFWpaCPm70K52uUuLCJlXcPNF+dByDWYlSrZnuV50q4VrJzaeS23E1rSDRY7h9Jg9eY90OKnBOwleZvCo8HSP1TuMiOMvQarimjDtd18oXQJqdp7rijRxv1j2uEaatuFKeDopwCPy9Uu/h+RWFoAleWH5q3KcyjZA5XQEXPNqlkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Y43CBBrOQy0Rafp8quAjlXWPkOSylwRBYkXzsr0sZY=;
 b=OEIOmhtrPYoKf+w9bINKu4LI/QDAUtxTMwY7K9kvpHtR9urniKjbA5WIlB/iyZ2+hWpMWfhbrcjARk7PFB1/E6/cCiec/rRxi4+pyN/U6EkkgXl7rNjSvL8CYGptcvlILgBOmNFMvSIOoJJl01bkW+qecZYjfRu60LLNh352d+6JbJmJgJumggu77JSvOL0nuNm3dcCv23IFi8PwZTlmwPbEWfF3m9yBEVoVbpXB2rItY34KhyM74Z/v3XNNjs8LBnNZRsG8oMI/nW1IidzZBLDz6kOtj8Eck2+WezIKBz8anpyVxIPrS+wI95ic1Ot3DliT6jv4SR/PiOEkiub7DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Y43CBBrOQy0Rafp8quAjlXWPkOSylwRBYkXzsr0sZY=;
 b=Cfi6jSGlhj8KNiQluaEjGGFPuaAv0p5XGgwJ3jOna385HeO2SlQzz6A5JXwJjexjEplMS6D2jwIF/oPgpTsbsdgdk9MnZfJo+1etfxirlFSbBhay5u35P7ESQCxVrxuQIia1jCuOYu2cgny0h016BuCzCOb6+vQ/A14jQ0gNuZ0fZGNrP05goDip9ru8454RIjjsAz80l9W3IuTF/xBPaphAGsrwKhr007KluwtJhDRiZB5yxWBazbhz0Eiv6eJUYtZrAgXMWIMABZYivbZVXoDca4VcI7NMW4eLppypi7JYRMXsBgyvuI6sOnq7aiPmWb9ly5Xe7MeykNFd+s1P3w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 22:51:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 22:51:31 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v2] vfio_pci_core: Make vfio_pci_regops->rw() return ssize_t
Date:   Tue, 20 Jul 2021 19:51:30 -0300
Message-Id: <0-v2-459be47fb870+c0-vfio_rw_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:208:2be::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0194.namprd13.prod.outlook.com (2603:10b6:208:2be::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.8 via Frontend Transport; Tue, 20 Jul 2021 22:51:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m5yaI-005Fz1-Id; Tue, 20 Jul 2021 19:51:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ffc1dab-8447-4f69-e363-08d94bd0eac1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51437E32530A920278DAE5C2C2E29@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkOP5KdxfXlFt0hoXsRAVQqp+RX4uHelFVtMiq/LSN1smPqYBtfpqamddMRMvfTlRERyGGmoYVlrQ9hqGYQQ622SfSqSrGffqrXCQiOt2oiGhZvCnR1M9tudSUFcPrco/PngVFeMUw6B7gF7AjxNB0YKWz4/7COwm2chS3efnEggRRdjtVNss778qtWGdqfqJ8uCZqkBXtfFWha3q6/axIppbEsjqaocwXVkHkueOgT59W2A1XMOIjwvuiQQvIWps+LbPEACzLp/qbUYtrWoHw0Ko+NyRcvx3hB3XqHyrvTdf58pfQqPKjjHIq4rhpRSkaxCED0j9do/9o1m7sdJo51AbfGvbp7PM5GElDBr+BvrlU3x9vPguWM2hCPzSZU4p9xIMB0e9P+Ef/RmnO9x4hl8uqh2KjAe5TJ1O73cLXXq26XVboRp3FDQM3ZCnXMrZ84GHdbQL3GV8q6af/BpkDe++eoDYtOP71NJIhWPjhnc84jXYPGUCC1SZAZfuHs++gDjQYEnzPTcxJjPOTR8m46pNigo4eh3J2jm0517jCo+DsTLKNzg7I8ZiF9+ZS//ZIfuyMQVwCEn8dx5+fjsIPAa5bAqEg0vc1mbU8ah2BK/0RpWCI1w6JBFubIqzO0RRFBIXxAebeBFRVJLT1UKdVaiXMpQ8tDj28GjcsAp78/F7O9MnoZWbOFdG6oChCRH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(9746002)(26005)(107886003)(66946007)(66556008)(86362001)(9786002)(2906002)(4326008)(478600001)(186003)(54906003)(316002)(8676002)(66476007)(36756003)(5660300002)(2616005)(426003)(83380400001)(38100700002)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhPPqZnohWcxWckBJqDaKN+keJPKKVtA74c8v1RVJpMX04Xqgr8fqwfc6X8p?=
 =?us-ascii?Q?Npl0jZNRjuXMOLyLRuBGYoHb+E1dLmWe3Qhk+k21tKOp6Cw3ghR+EqDc8hd9?=
 =?us-ascii?Q?LVmpteTY63rUTuUrqFTEHb6Ir8gOzte9x5orzE0W+EkBiYjDCrUgfMX754Nn?=
 =?us-ascii?Q?0rlbogiCYYrkQX5LYbInB0jMYbeLuvo5CIMLKvbJYb0JS7CNFV0C8lQ56g8n?=
 =?us-ascii?Q?8V6EUJem0Zhgv9c0uoGDPJwLYwSQ057cDr9yLDvs3im+GD8G/4lWyPvAPc73?=
 =?us-ascii?Q?cniOKqoTgUQciqpmQgjDePhabd9gAth94OW3WJ4uv4cvWgiGgs+8tod7Z2Zf?=
 =?us-ascii?Q?cxlAy/kRHTJIsl+B1NMkOYpKUhbNSCPsSEphYSezy224Dhdqocz9WlcpimuE?=
 =?us-ascii?Q?2+9VLhCFn1gHrTtZLOeZwHzbeGr8P3NJZhB2pTTSMFswfo0DBz0KVomNpx/E?=
 =?us-ascii?Q?MPA+IjP6Wk70eZ2GruU954+SqWrUSjDfi+MBOx/eaW5Zx0hHAfVBghePDOE/?=
 =?us-ascii?Q?DfXuqxgF7nekaMGG8Nud2HwKW8iuCL+NaWHe8QXNhT22RbaqeuYX2IAS5kgH?=
 =?us-ascii?Q?gYe2oBjq8VF5pYrCpLpY3ZKNU4AxD+29RVU63W4CkKDA6nOCQQcoM7lUDUwQ?=
 =?us-ascii?Q?YcHe8rMG397tad6n+jU3y6Cjr3fA4COE4z4QXtVddRwuuOvJjfB58nqRHaCG?=
 =?us-ascii?Q?lQQrN4NEcm3kHGJ5aRKUlA8LgIhPe+qahtolYMr7Ur3Wedz0t3jDoHgdlYoo?=
 =?us-ascii?Q?+GXMhaxuYBiLv+HzzyLvRzw0E2lO4Tv4EU+2KXkqgePuhnV4MOLiGmr8uuga?=
 =?us-ascii?Q?i2p+DeWMv9jjOqN4ym/pjDvSNrf+oDV/d0a2wJz1WuUMaYUqe34EpWWpH9l9?=
 =?us-ascii?Q?SBaBh57INr+x/+TIjGL7iYOpUtVeXdd7y1oGOi53wQFmTJdrVNqE8dWMtzcP?=
 =?us-ascii?Q?wc8v/FdtV52Khx+2aoSb/wg6CJwP+bG8yV/28gZqcqEancHfdJbRG+C3yD3O?=
 =?us-ascii?Q?4pY+YtjWjN+a5ebBDkX2LjZwHm/X0JxUxHHmnTpq0l7+JQyt3P95jsTfBUlv?=
 =?us-ascii?Q?aRSTxsha7H6tYsadQxPb5TS55JJYQdEYT26ZXGi8JG1M4mkSxsMKluSeu1Wa?=
 =?us-ascii?Q?2Ejn8RRhm12uqzYoqh3c18rDa8QrWXq8bmddJ71IF8zna/4pWy941xiKEO0G?=
 =?us-ascii?Q?NVqtxYr405MfqG8MfMc57l3JQgirhr1MyzQ0gs5PGwX0948Tgi12hhT+h95o?=
 =?us-ascii?Q?RkH4in2SvwI2llZPU7ui9+IkpEnDjWU/i3uWFgGGp3c3JhvdWCgk5bguhADF?=
 =?us-ascii?Q?Kia59B0nXCEz5oGyGZ688FqX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ffc1dab-8447-4f69-e363-08d94bd0eac1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 22:51:31.4636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EzKrWoBqhPIDQftMvF+d9vAfyht3reGUMpNBrFkINddNaWXLEsnqyk6kmU2OpKjw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

The only implementation of this in IGD returns a -ERRNO which is
implicitly cast through a size_t and then casted again and returned as a
ssize_t in vfio_pci_rw().

Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
consistent.

Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
 drivers/vfio/pci/vfio_pci_private.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

v2:
- Diff fixed to be against v5.14-rc1, woops

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 228df565e9bc40..aa0a29fd276285 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,8 +25,8 @@
 #define OPREGION_RVDS		0x3c2
 #define OPREGION_VERSION	0x16
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+static ssize_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	void *base = vdev->region[i].data;
@@ -160,9 +160,9 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
-				  char __user *buf, size_t count, loff_t *ppos,
-				  bool iswrite)
+static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+				   char __user *buf, size_t count, loff_t *ppos,
+				   bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	struct pci_dev *pdev = vdev->region[i].data;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5a36272cecbf94..bbc56c857ef081 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -56,7 +56,7 @@ struct vfio_pci_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+	ssize_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
 	void	(*release)(struct vfio_pci_device *vdev,
 			   struct vfio_pci_region *region);
-- 
2.32.0

