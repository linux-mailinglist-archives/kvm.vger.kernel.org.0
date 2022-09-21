Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C05BF250
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiIUAmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiIUAmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D88E4BD32
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0iejjcZAnhFebzSu4cLZlYvcqiIqAB6GqkyjtnhJVquPhlLdeuPk+g5UIDzwTAroawn+27S49fWyEJmms9GeluPq29PdYSCLa+8gjebtzCoKkFKQK8rij4FUkIlGMi9u7MVhKGQVtsn5DLWSKEuuHySgn8UzgingGORlifvsnHdIz0sTdN+Qjd7LhSq82yfalNQhh23h3dL7oDTpOduXkveH/xI95UTaYwoow53VRLGqToIb/iMjUKlJN7OmwsCMcZLLpLB0kpU/bG6xLPTJvxvEoeyuy3MU4ReQONZpEO11fNwgMb9+0muqMQCMnZOIxrC1dAUaaiDkCYrKAeDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Pd/Ab7dAFxx35Aq1eee5VZAAS7wfylAAWA/bi9GzKU=;
 b=OXbvOyLFqoyDTfHfhq00y65rVQvFhKE8FZbprMrWTxpjH59sPONdHyIXEr3GLLqI9hsgaMZ+fE23PdPDQ3J/cqG4DZR0RVep1e/FE2k60W5A9lMt88+Fgn2EM1Dw4R5P++ctTw+J4w66xhvTDUt10mZsnGtm5mSmJkMNBX4bKe1LISm+9wmqc7GY8upVySROkIctwUVqKeKeFewRCCxlaKsYowBNV3HAxFWTaVYEB1I9UkX2SXbcL1xnmQf6Q2ORaRbxg2vhMrpqptPK/tcr9svdya5mVuz0suSlh+EByxr85rQd5v+9A4H5Bo6M7MtgCH6QtFEUTpTgJYUCt7vTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Pd/Ab7dAFxx35Aq1eee5VZAAS7wfylAAWA/bi9GzKU=;
 b=oW6WaTdPF00pfEqUgGJrkB0sazX9+OlUInF4l6tslu9W/Q2uETJt/NvAHivrxgiotvmmnvGal0Q++YZxUT66YESdSzISBqmTT6xEiaGscK1G+HhBbxnVsqe8T+OnVr1qAy975T3tF3MzOy+4u651yEQwLi4D/DOjskEqHkggTu34XzltRcAASuf3Y8OrhoJPrYncnKC6Kt6dSKgqTbCwvSKb/BPi2xAH+RGtFzBFfEx1iL4rX3sj1yg786YZ1QBLT1rPb/VsJon/RauaNeMxMbLY2OC+ppLt9BK3BmHifGd30rOg4POOqwmeG652ZM+WS8OYpHmEgaBmk4qZQ+fH3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 00:42:40 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 6/8] vfio: Rename vfio_ioctl_check_extension()
Date:   Tue, 20 Sep 2022 21:42:34 -0300
Message-Id: <6-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:208:a8::45) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|CH0PR12MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b9fb05-4780-4311-215e-08da9b6a2e96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHxSc4u4w5gr7m+uMwSVXvjbsJxx0cM+vNUtrQhD2Sji4Pxfw2TfpAhzqnx8f+2YDF0QPYiD6cBkkhITjz4Q01usmhJIvBmsD/GjnOGP0VJr6gq/KTHk4oyB53WuC1HricBI5vqSX/cW0sUpbLIa4Ql9tLQTrELCtL32+tahVRwxNewwEQr6iXgqRRIujG49BhYhqyo4AjYf8HZxrS2gpFc28k2gZKJ8R2KbJWdl3k0RrI79HtV5Cib0ZIHshRACb0e2oQ27iRG7PUIh5pEAKEFBvSkug7ePxDG92ts41kv6eNoLXS4fRphgjf4PkOo9BviAmKHUUEtztUL1CyaDGSM0OLZt37l73SZxD3ec43zkY3wHI+TzjCWI5LkvGzOk3CnnWjyCG5CnLFX/yiOXwnQ5ksSYyBLC+czV+v5ZajUpKeBiVz8VQP+WF0K2NnyWg6GE+m+ZuXHNr2+QhNcVdfoiZEUWFS25zBvilNsPqMIp+NBGYJ3qdEVMOh2IS8Qjr8YDrxu66u69vF4f1w+ft6oRpdisG2KN0F1YgidN2rjA3qog8KJuIY6evaYHyE5fiKiQoIDree7h+XQfTWvZuI/cYAHz2KuO5XCTG8T6uEre/xA8mp048OhiC672L+3qjUZVdrwQL46Hk+lXKKDWqwQfQXmN2d6NOr4u52+NLH/mIVgnzaAyaXMla6N4vJNUKkJyTzDcXAX22ge9xshnXIKCEM4fG2dPTen3w+iLyWqfO1IGiArd4hA+/nkc2xN7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(6666004)(478600001)(6486002)(41300700001)(8936002)(86362001)(5660300002)(316002)(8676002)(110136005)(66556008)(66476007)(4326008)(66946007)(38100700002)(2616005)(186003)(6506007)(6512007)(26005)(83380400001)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nM47qoUZMcPhbwd+PhygMngk2U17AUvhML9WCGjcAQZWEM+yqzN4G6uUEOZK?=
 =?us-ascii?Q?ro+Pu29GZcYH0tlv153XVMkn8mY3o/T/5S3Cc+sxyH0utkCyNnnG13Wgur0O?=
 =?us-ascii?Q?/GYdMyVqMdC4TfhVjiGQFLMXdAQY8qeysgPc76ciSVrK652jMzdWzQXOTggv?=
 =?us-ascii?Q?kGSPQZgmldO+rjWVMq2yCF1dM40RgawvhVTcmODcESxaeGM8TUPfyJLRafVg?=
 =?us-ascii?Q?3aYXBDFYco1Zn/ODyt/1/QzT0Py3dO08XMC4j3jU7rqBqZcp0RQKh7LfnMRQ?=
 =?us-ascii?Q?FsFRHk3AZ6BzQFXhEjDE9U94RQPJqDXhMnJ8XQuLHaHFPBpf0P+BQNXpDhxA?=
 =?us-ascii?Q?/VGEnQyXlKdsgrBC2/Ejt+80aHusBVVCklAxCrx4Bpt8tBp4sSY3OnEP9bJL?=
 =?us-ascii?Q?z8cOF1huSaCdpJuiH7JsXNL1JuEgA9kzuQBf3/VNfXYBA3tQlUsbAUCg6UZK?=
 =?us-ascii?Q?B1JYg0VCNyHauq8jh+SEgke0OSzmwTPME0wg7G2quEOSG/Lk2MA1wzpDRJWX?=
 =?us-ascii?Q?dmUgSpROW/YvOXfr/Yug5taaqXLrOeFQ8Wrt61gDkwTCZBY0QuGwAxDr5hpy?=
 =?us-ascii?Q?iYD4jM2c4R+HWRbCj4KB0cqVslD02kZsJnYbC3DyvgaiAk5Zf7f669YWRQyw?=
 =?us-ascii?Q?u0rpmMJh4G3Os+TkaT+dpuBu2/tou639q551QXThUNeeTXVM3UFsuLTNAMMp?=
 =?us-ascii?Q?M2UHAoP0aWKj3wr+o77rTouQfpQ//9SvnTgWBqMeGUaMaW+Vfurx9h/QnETm?=
 =?us-ascii?Q?eEVmu1RiupguNir5C9qDiAQXn7idP7vp/rffaMbrw1VAU6jQYDoZXjum1T9u?=
 =?us-ascii?Q?P+YSBlgTBCcxaKAPTg7Yb2/vuOIk/NfvD/MhrJuidMyof9aRAj9PT98GMwFv?=
 =?us-ascii?Q?TN0GwaRF1/I3xbyPw+ml7Mus5xSM2CSV+l5FSqH8ztAW9h0SY5gZs955bI3m?=
 =?us-ascii?Q?92lsai+HqLNHU462jGLSGqRqXBXlgRTy87rldLQICk4pLeFpwo0tc+6VjEoY?=
 =?us-ascii?Q?/XHvhexCt5cC9I4X2A6lJOHQYMFaOorgn3MxqNxQ67+3dQ2aoGruWl3bbS5Y?=
 =?us-ascii?Q?SoQ3En6Pqs32yvqLgHijqTxTM1WQLUP21wiL2sufizAtqyZ5k4bVaG+qlC0h?=
 =?us-ascii?Q?bJDi/1KwR++k1kHI5fA7iR1k/Osegg86ioWQeETDJvN3y7Yc8gsN6bu7PsKc?=
 =?us-ascii?Q?EcAP8WFGKiDxOkEfdreufwJsz45l0cuzOzL2rtsOmCyH4BTZHDaL8ZBME6SJ?=
 =?us-ascii?Q?6guFk1yEDxBblNqn4CvgNnqYpepRumJ271pH72qZPpZkteo6I6/vctOhV8Uw?=
 =?us-ascii?Q?6fyIQhbiApvwYMRCrQahMyQLNz7GXIUUFhT0vMWa3a6SgguaGkxqyUoZIdth?=
 =?us-ascii?Q?TZjpWSyYED4HfOHhjpc05YTPT5G/BCdoWffa/Kn9igxMqkc2x3ZDtdMn1ogH?=
 =?us-ascii?Q?1wC7ANV6DhsHbQ8hkhAhus9uwaYS+/oAFYU4rwBqpnvYIEnBWafp4Au6U2zC?=
 =?us-ascii?Q?Pyv4s5Xuyx17eWyLiWDCf0/m9fIoJoBWKEuqPkDR+SHB6EuD18CcQdpDksbU?=
 =?us-ascii?Q?2UfsWYbvHHxqF5fcALBDup2MtvIJNhUAbA8JQllC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b9fb05-4780-4311-215e-08da9b6a2e96
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Spqe7we85WWa1Aey1s8gmPzQLC91ELkR/4EFrMuCQCFkm9ymBUayoLkqxe9fNhQF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_container_ioctl_check_extension().

A following patch will turn this into a non-static function, make it clear
it is related to the container.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 33ed1a14be04e3..3a412a2562bbee 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -703,8 +703,9 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO base fd, /dev/vfio/vfio
  */
-static long vfio_ioctl_check_extension(struct vfio_container *container,
-				       unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
@@ -861,7 +862,7 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = VFIO_API_VERSION;
 		break;
 	case VFIO_CHECK_EXTENSION:
-		ret = vfio_ioctl_check_extension(container, arg);
+		ret = vfio_container_ioctl_check_extension(container, arg);
 		break;
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
@@ -1817,8 +1818,8 @@ bool vfio_file_enforced_coherent(struct file *file)
 
 	down_read(&group->group_rwsem);
 	if (group->container) {
-		ret = vfio_ioctl_check_extension(group->container,
-						 VFIO_DMA_CC_IOMMU);
+		ret = vfio_container_ioctl_check_extension(group->container,
+							   VFIO_DMA_CC_IOMMU);
 	} else {
 		/*
 		 * Since the coherency state is determined only once a container
-- 
2.37.3

