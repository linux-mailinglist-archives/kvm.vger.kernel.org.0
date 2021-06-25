Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861643B4712
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFYP62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:58:28 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:23817
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229738AbhFYP61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 11:58:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioO9kwu559z8IJ/tmFv7G7B30MabXeq4ZdypDpjEsFySYjrsBCRheiXTpUV61ayWIBjPXEgH60X+YozAI8f0xEhD+QoFFsh0NnVWT1OQstuAZEGI4WTWFSEC11Hwki/on9FEp/Jo4ZsfU6//zOXvYEvy/Lrsipl2wKHmQATGnCFlr3JFBkbuMXBbjdDFUioPFpUY4ZdYDzrcVccosL0DXK5sF8Ixb+MVbgVXxC3UDSg3ma6v/8gnlV9aL3DuP8lexioNPDVLBgsMOAhaRPp8FA4ExeR3SzNGkhN5ZTRu+3vlog6o3RBaITNUEoL5xrav6Eh+Dsl7tKci/jLtuvTvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuhY4+w/fEvLlZPmsEG04J8yryrcgTrM0Vnpd4OA9ws=;
 b=iIKrGmphqtdQ0/KjR7dNl3sqLkS4F2F6/qtZkrOSOGA3/hnOcS8tiS0QbvgWO+1QPJ7pLmgI4IN6L9yvWdf5s8NkrEsd2k/zGjCf8NxjHoDGNkVs7F9BQbaf13aEqFiV+bskWtnnm2VIn5hTCkb/n6Hprk8/7f15ONd/1tXL6T4lgqfGkE7FW+D7b4DJRQAp9jnA/1qwsxMx4NRxqQi0DMD7C2HjdNR5LvMZsDaYEzqY2ZsuUwoDn3ADZGKfCHn7ZTmNP5UJHgWBQ9tUOomipYs7RtjqnGfOLQDgz2dvEpiE1+fvI4vQKxDgH+bRKCAYLc87fM8LTPnpPnE/QhG3Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuhY4+w/fEvLlZPmsEG04J8yryrcgTrM0Vnpd4OA9ws=;
 b=SK9ngy4sUK/XDNYWSXVuVASl/s3jCjsD0aL35scIOinTBYhnSgG9QJ3LjP9/YG7qFzFgY4YQj1BCGPvqYC0QOeGEFZ+Mkvi4JbHJhliXGRH0dbndtdd9wMmuVvwWqvqKVjHnUXP4U9ZoigHmBmHV0WghxEz0afZo33ALh7Ook+cwDoTaMZv4wsdu0vmRquEQM/UFCrEtHb+eehYGs1yjaedCYnGDur00V4pTiW//QWAD2LRXGol8Tiv5qZC28uL+fTlAVfQZ/PbLiCcfUBtqUGND23M5sHrf3fRW1sS0PFHncjeWt5MHXRMVAdfbEJ36H2ze67JtQwy4M/RzeIRC+w==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Fri, 25 Jun
 2021 15:56:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 15:56:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] vfio/mtty: Delete mdev_devices_list
Date:   Fri, 25 Jun 2021 12:56:04 -0300
Message-Id: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0093.namprd03.prod.outlook.com (2603:10b6:208:32a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.21 via Frontend Transport; Fri, 25 Jun 2021 15:56:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lwoBY-00CkSu-Cw; Fri, 25 Jun 2021 12:56:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0572398b-ac58-493d-99c4-08d937f1bd7f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB528706E1AA9533B28D055F22C2069@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MoK4Q74WK1T3n5L9ICaLDxfuZDEXFifVuPToa6JU267LA5ixE6vR1ltIDL2v0Ex3XJOpaiSIkybUIjHRtvim/hBLAyylLRobShkFBsv/s7NwfoCmWwberj7Wv4Wro9NEadfLwvQy1a2n30L4tCYhFDSS7SgG+QilkkbNNjpuKOyDVAFmsg0JbyXb0iNZde8Q5rtgibi+5uR2In6/A423AIWCkqGfS+j4sLgffGLgpqbHIceL2teC0N55dFGmGEeZyg1SI1XFScSmNPWlPnJ1xElza26IYeU2OYZ14DTf9yx0kGA0j/i4vN3eXCmkZks0ND96OPNo/ITZkuCMWKZspHVEVuV9qvpDKNMn6ZcG7VW2k4CYuQkOqGlwl5y/te6q757wZ8eOJyR3h9Z0/fQilbHhFCR2J8IWyWRCyZ1MyzpBAIttFh7AFnPM2JCv3W6imepZ/PAnJPIqw7jIF3caK0r0sQoqw6IozlitLVQPokTEHzOxSj7rjCWFAiyk51YMT26grZfCl5hTSS/o9rAYP4u6j+pHOSmJbo13z8v13xzaWlPQFF+/O5+aTQH7sXkaNjmzdnPMyrFKv+WgZxj+GESTrPA9+F8fto6XTRMs6l86n4uPY7IuMHOnBKQ3VahLffqMt/ZvNYLnqngdPOCaDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(8676002)(26005)(5660300002)(2906002)(186003)(66476007)(66556008)(426003)(38100700002)(86362001)(36756003)(6916009)(8936002)(2616005)(83380400001)(66946007)(316002)(9786002)(4326008)(9746002)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wiI17njn830Obo9AT07PUIlkPXca9KGYzvjkxZD2LnWg/5c1F9XTD4pCJo1M?=
 =?us-ascii?Q?u9MDWaT7Ct8xp4RIDKFjqTMaOSe67GWtsIkkESHUqGpBT3U9wwTuYZRr3ZRx?=
 =?us-ascii?Q?3v/TJIAVrMfiqU5YjIirXVR4KTm4ojBd2HSIbVzMEMBb05T072175J1D7uBk?=
 =?us-ascii?Q?7FNj5AvnDCkSa+1uXe0+qRrlmCpU1WHDcG4YDPGnJuP52dZOEoeQB/MO9K2j?=
 =?us-ascii?Q?ZgNcMgeCwkCzmhFTD4RwNRb8ivo38Rx08emLFrcISUVXsof+SdWrVpLxXuaQ?=
 =?us-ascii?Q?KMmn2KD5J5FftqY+dAZznjw+2xly8yEX+dJ0HSiXCjkUnYZpFfNycaLf+lmu?=
 =?us-ascii?Q?g2jAVLk00d29ufV2+SjPkLD7LFEsE1MY970pasv0V3JAqi3BxOMJXRxIykeA?=
 =?us-ascii?Q?Z8Yf6346+Q/2r2aCt20D4DFsYbYBf7vd4OLP1HgYHf92+RXtHX8bu47++p5L?=
 =?us-ascii?Q?FUgPfRcLtbXaVuRIl/oegHKHt1UGrNpLtKBHi+dgMOzbdPVZqPWOvFS3PARb?=
 =?us-ascii?Q?cEkjwGDntQVqwT0hqAZHxHBms1gywJXQLd1j/x3nV4YY3hMk4mIX8ds0lEHY?=
 =?us-ascii?Q?3Lg3YCFYnprFhojUdVocfVbQyAtEyvXD+gWfCONIicpsY9Fhzxouuul+lgG1?=
 =?us-ascii?Q?rI/o9kbIphV26w/+lZvEeqzxj9s6deCgaAAAZcHxevoIr6mUkpg5oQbgKs2A?=
 =?us-ascii?Q?6H89fsN7Lt7jbM968kkitU36uu5roIzoA6nQaXBg5DzuwockDeQ6yRZCJgul?=
 =?us-ascii?Q?xZHtpWnMRgtd/9LxaieSbIj48t/jdLOjTHMF0zb31VI4vWApyYkxUAoW4IOL?=
 =?us-ascii?Q?OylwEIQWf9s1edG1RyT9hfAxy81I3w5f6deh4W0qGIxjRO9IJSz0sicwWKBF?=
 =?us-ascii?Q?BaUPfD4Y03ot8KTHT6L7+Em8iaJoYJ5fe+OaleqLLdHq8jpOlPLrxw77FHd2?=
 =?us-ascii?Q?PqkTmjlUjKU0uuTwYIM6N7EjivKj5jeZRJunn3tnF3Nr/OMR+3dV3PHMUcxr?=
 =?us-ascii?Q?OWWhBBf8RhNYyVtCHCM6QOeHt8yGpR2N8MEEzByfGF327twlgdNunLLr7ZyN?=
 =?us-ascii?Q?7aZ0vRbwD25crAN9x/+kUXBrmtf81WGLcHZgFUn6JCpF0ZsIFT1s/W9GWOou?=
 =?us-ascii?Q?jkoC3Inq+WBMXmbz+aKmuK27LGjYIlgAyt5k+xeBu5ZzH6NN4NVczy/XCz25?=
 =?us-ascii?Q?pR41Z3gfZZ/ApeOE+Gg1HbYlT+CY/MhDF/Ahei6J1K+InFmFfbyoqZ68s5Nq?=
 =?us-ascii?Q?T0zfqXXHuuwrPtUMCfRju9ZZTzbJUdZSHo1V122wBZq59tuNmS4OmTDP/OoX?=
 =?us-ascii?Q?u2LzIrjau9XnXhWKCByWSh60?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0572398b-ac58-493d-99c4-08d937f1bd7f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 15:56:05.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0CO1LEwIQI+uWF5KHWG5bJbiTWHZ/Z6sJB19IkPCtagfvWhZSAJrVqUQ4X6KC+K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dan points out that an error case left things on this list. It is also
missing locking in available_instances_show().

Further study shows the list isn't needed at all, just store the total
ports in use in an atomic and delete the whole thing.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 09177ac91921 ("vfio/mtty: Convert to use vfio_register_group_dev()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index faf9b8e8873a5b..ffbaf07a17eaee 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -144,8 +144,7 @@ struct mdev_state {
 	int nr_ports;
 };
 
-static struct mutex mdev_list_lock;
-static struct list_head mdev_devices_list;
+static atomic_t mdev_used_ports;
 
 static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
@@ -733,15 +732,13 @@ static int mtty_probe(struct mdev_device *mdev)
 
 	mtty_create_config_space(mdev_state);
 
-	mutex_lock(&mdev_list_lock);
-	list_add(&mdev_state->next, &mdev_devices_list);
-	mutex_unlock(&mdev_list_lock);
-
 	ret = vfio_register_group_dev(&mdev_state->vdev);
 	if (ret) {
 		kfree(mdev_state);
 		return ret;
 	}
+	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
+
 	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
@@ -750,10 +747,8 @@ static void mtty_remove(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
+	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
 	vfio_unregister_group_dev(&mdev_state->vdev);
-	mutex_lock(&mdev_list_lock);
-	list_del(&mdev_state->next);
-	mutex_unlock(&mdev_list_lock);
 
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
@@ -1274,14 +1269,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	struct mdev_state *mds;
 	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
-	int used = 0;
 
-	list_for_each_entry(mds, &mdev_devices_list, next)
-		used += mds->nr_ports;
-
-	return sprintf(buf, "%d\n", (MAX_MTTYS - used)/ports);
+	return sprintf(buf, "%d\n",
+		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);
@@ -1395,9 +1386,6 @@ static int __init mtty_dev_init(void)
 	ret = mdev_register_device(&mtty_dev.dev, &mdev_fops);
 	if (ret)
 		goto err_device;
-
-	mutex_init(&mdev_list_lock);
-	INIT_LIST_HEAD(&mdev_devices_list);
 	return 0;
 
 err_device:
-- 
2.32.0

