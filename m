Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1D355CB1
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhDFUHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:07:39 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:34721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347149AbhDFUHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:07:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCacJ3EOr3mWx4gAbghnB54UO6rBcF5/ghuqV734/wV958X9F+32Zitr9G/jTU3h5vFYbpdEKWbE/mec8iq+Sqj/BFjtwImQrfF1zPQPWNKTUzqk5ZGsoSsafWZ69+JiCw7q9me8/EBmGftJ58ZoqKn9UROpddEFz3nB716i96+m/kTgLViLAl1tz9dXBl9cSBNiWsGetIBdJ6VZXxRTu9xRIbvm7P9DU0yvDEd6LpdsAB23JhiNTNyYvEcM+lHGXjf7+rpkh+ViNLkuRJgP5+K0oFp8YnGtpgFPw7nbN3HB/pCJqC9DhiAWAYAA613y9huvy7/36PHPtOovcEqC9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAph3M+4Huf7UqPA+3JHi9cZqLg6Aofx1WeYrRL74vU=;
 b=A17EC3OTH87LAxfbobTklF6fOOj+1brtAFTgeG5SGw0sCMMzBXFx/8xTZ4/n0AE5wo28QkaPglkY7S6RTDkGJJq2o+5ubdx3aJxXPzHr19T8qpYdCzY9K+66uoPdlDAMEn6IwI7P+tqVBdyZgqp62OZm5pAXBmTPZkeE7RHevvNCw6/LwvvSxIR76MMJSnGpzRjiZaH/fYvOxBwMajIL6Diz8XzMG5BHRRThbKqR43IItVlw4WCCQi07hmeF9M01n7KlppLsqjajYpEMpJm8GNSUM/vdBgKmbDt4M1fx819hZAlyWwkLSIGslVOTc0XhoWKMtWCwNn2vYMz/ZrC/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAph3M+4Huf7UqPA+3JHi9cZqLg6Aofx1WeYrRL74vU=;
 b=CDcifajT82/81Nsw1M1xYsKCGLmVF8kZRveXBMUVUXfYcnWrRbKCP2VfYRIF5JFUIJXpqfIQQEuZY7B4aNeSE6ic56EKLRwv7SHSwPnKG162i/V/lypHqE3u/tmOrxqFKU/JAneOHreL7ebmuCVoSPpQ1YlgePeiPpLhR1va9hgBLzIl85Cbe/CxzTeWgvmgbzU8pLtH7e7RceIgHZYpWnouDS1OqSVSa7uiQnuSWqAA58p+xPsbwZHFx6naRt+TVJ0YbOHlpH356Rgx+zohL/mW8j/nn8ZV/SNDvlwMekddvPu7ek1LvgGdeAENgFCiXMZyVE3VobouQdjdVMle5Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 20:07:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 20:07:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 07/18] vfio/mdev: Add missing reference counting to mdev_type
Date:   Tue,  6 Apr 2021 16:40:30 -0300
Message-Id: <7-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:208:e8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 20:07:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXG-48; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2ac6d8-94e6-4bae-5b94-08d8f9379847
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1883DFBED271033848F1C360C2769@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sy1sWkitdUw6fLA3pyX9Bj29wANS0itwE9pgdh22EDVoAOZTOfx6qWTBlSGIaRG8CEVHG54t0/OhT0PpRCVbh66Jb8mpYDiTwnuTm0Ts54lLx1zeFa4vPnH/wYGh+Qe1PpmyNM+KQcQr4Ul/1arSAti/yjzchLkkogl5v2vpw8Nj4To7Yrggn+HALcLUhbyj0r1eQARlRxof6ecOfcZ5KurHtY5aejRD5KMzivLq1/fa2OGbh4v3iKgF9SUtyn1UIzV67x5uLJmwMi+rdND4oUkFDg3QM3eK+/NjDm0OvZg/pt4XiJ7gkZEI8NYCzsHGYsveNvpK0MDmqtIh3KIEE1GgJBT8ikfzKn1GxfmsljysjaS4/6zuiVym+og42K6VqIDwe05lgNREPO2SNl5AiAnIHj+pJbMmP5eKKgtj01JT78fg01zE0kcNlpnv/kdiDig3GLLVJCewRFPp1neXDqn03v1g2ZQVj/vUZs76IeBfhfaFkt7q4Wq5RXt/xPO4KsRdX4ZikVEB4q1dElDb5bKVbaPYu8U8/tMttpGd1nz8yios1v8TNnNfjiykKNUYK6isCPimhwQXgbq4Oy37gQwoSa858pDb7op37b5g+kIQfaoen8vWKDoaQbl7AebILTxoHsUHopmk2Zt/1ccm5NITFx4IEg0uxrVGLgw1OUPs//0SQ1sM9Ah2UzOVOaFb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(6666004)(6636002)(38100700001)(186003)(86362001)(8676002)(8936002)(2906002)(2616005)(316002)(54906003)(478600001)(110136005)(9746002)(83380400001)(26005)(66556008)(5660300002)(66946007)(107886003)(9786002)(4326008)(36756003)(426003)(66476007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pcIq32IA53fpdHdyTe2tRLvFoqwjnYBTFqBpaX3nZmqNu1pog5RkoWkZiRfT?=
 =?us-ascii?Q?NsLIyzI484Jt0flTfhjJXsB7kl7+C8rNqLaWU+hdaCavigQr/V785pU/iUiA?=
 =?us-ascii?Q?/L3YtSrTz8AK69KpOO5JSenvkL0axaHulGRxwGSupP2mmEFH38tVQseFw2eA?=
 =?us-ascii?Q?b2Hi/1asJtAa29+ktA1oFO95E0Zn9xzd17W1c/Y+v11xLD1aoO+0Y6WpfOl0?=
 =?us-ascii?Q?pd0WjFqoi7houDIqeFugJW7z7NyzKKvT9fnHUP51q6TpYM3mjojG2sL+yQDN?=
 =?us-ascii?Q?Qhsf3E3l1JTSp1ktVF+TPL+KuwA5AszVxmq8Sf+sH5BRn8HG4nWXruU9xxZR?=
 =?us-ascii?Q?OayOxd38VHYu5hk/vHraPgaiTt7XMQIUrMEC3BZHJAizXXIbJyfbfqfRO7ao?=
 =?us-ascii?Q?iUMaEPZl0BrayiZp1oOieHP/Q6ilZ3NNIuRfYldfUUX3t98W0Fi7bmsWfz8s?=
 =?us-ascii?Q?nP3TPbOCp4jm0Nde0dUWiJ7K6TPZieb7em5edpr1wJ8vDaYL3hLkyrO17Diy?=
 =?us-ascii?Q?K+gjvo4kIpe5dHE44graJLz+sEC1/OnwdyNVPl+4M7WL9N7zy4bhCuSRDlEo?=
 =?us-ascii?Q?xFvnqNCkqMOciiSpH0l7YarTturVhHEIbBTfuEhSk5uc6n3d2Jr5nwTyeojX?=
 =?us-ascii?Q?eEB1q32GM+PdifHAy23s8ehHHm3Jn2OYEEIpNuDmx4rQgWZOmBrS3s8XuMv7?=
 =?us-ascii?Q?g2FFfFEvNMVd1xAlIrNnb4jw0MKo8DNjaCRUKA1c2NcF+lpA2CnWgB199SlZ?=
 =?us-ascii?Q?/3PlYMpPFv01L5IW1DA77H8oNMljpd3vi5TvgzK+ehgK1N0JnaJqntsip7Oe?=
 =?us-ascii?Q?3PxlZ8MTZtEY8PzCac3n9uiKbwRa33T6rU2iScHcR994VQ9HmOxaRzP5cG7/?=
 =?us-ascii?Q?vamuwZeaFkXGyxWhoRYg68Hey000c6Xa78XM3MHX2+6+An7Xa2Sk9kTeYg4Y?=
 =?us-ascii?Q?25TWPQ4iTcVwjyX0ZcLWqAvRsqbqfRy2SetmOSIzpX6oYmh/obulxfopn4K1?=
 =?us-ascii?Q?hs4BxSRtd12SDw4gLK2iWfkmji5cuwwQMoCu2Z7xeixWm8br21aaZPWX4Q5E?=
 =?us-ascii?Q?oKsWFKByxM/0zdLuwXEE8z3FGlyGWoz7LCFfn5eZaqSs7A/yxszE22l9SJ+n?=
 =?us-ascii?Q?i+AetCEXDuIDY0LIvvFIYloQLQZgoqoYWXJIWi8zuaBCq2hp39p21FI0Fv0I?=
 =?us-ascii?Q?hsqXEGO6cngcfLF7XpRr/j+C8+94vyPW+ha2Hve4HK+EpEmrwZy94T39M9xa?=
 =?us-ascii?Q?7PWMRTiDFPFezZYR4Mll0VKmrT4niRfW1/0O9kNq0lVPg+Gh8fDfkP8ZRDtc?=
 =?us-ascii?Q?5E3MC1CnvtcJI4XHKAwR8J3UCUWejm+B2YUeRk7/dnIT8w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2ac6d8-94e6-4bae-5b94-08d8f9379847
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:25.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vxq7viQAr8ga0skf863SzRB53ts2b9Kb3qDjBJku50RgIfK6GfwqeqRK/pRqBnef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
but doesn't hold the kref. The lifetime of the parent becomes implicit
because parent_remove_sysfs_files() is supposed to remove all the access
before the parent can be freed, but this is very hard to reason about.

Make it obviously correct by adding the missing get.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index bcfe48d56e8a9e..8c169d12ba7dbb 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -81,6 +81,8 @@ static void mdev_type_release(struct kobject *kobj)
 	struct mdev_type *type = to_mdev_type(kobj);
 
 	pr_debug("Releasing group %s\n", kobj->name);
+	/* Pairs with the get in add_mdev_supported_type() */
+	mdev_put_parent(type->parent);
 	kfree(type);
 }
 
@@ -106,6 +108,8 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 
 	type->kobj.kset = parent->mdev_types_kset;
 	type->parent = parent;
+	/* Pairs with the put in mdev_type_release() */
+	mdev_get_parent(parent);
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
-- 
2.31.1

