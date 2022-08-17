Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773F45973C1
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbiHQQHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiHQQHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144ED357DE
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2L+miPDxfX/G1wft4+A8kXhHFQ4FAWUC6eOmGicfWtE4KnhaOEgdFbqNYE8t3cvlwKfQS394Dd6llLK22zWx75wQmQbufm06lvAJxu2sIiqoQ+kdavb9cY6JA+Es0hTODwlUNamzQYyvLIOHExzd9Pj6zdwyqlE0Kjhu/N0QBemz0QkDxNa/lUkuRhzN9hBm5ZttGkBFUv+DHvkj3d67zPuhTiadRL+x7epeIzhdEO2HU7/K+OCWTW6Q0C++cP94cUGHhmBgWdpfU4VO78S60bJD3cbjvuwtwaCv6zCAnTKzsZDKZaPRGhVvam7HynDhrpVj+w+Y4OmQrtZjf5zBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXNHSXwGJ9vXMUNwclsV5xD0CV75iEB+98LrYYpIriA=;
 b=fr3m1/gygMxM85q9XoutJN42ae53JPqLfH25xM8tYww7NSn1goS3h3XbktocWXQ+oKcVrU6AUbNasj9u/fHTwU7VEkySyZ4gIADB1JM/o4DP1rKG4C33reE5djk3FFmMtxYLhT+XuPFLemRz0LEMOSKKJTjduyb2s/WvcXGNSnnySj3FicEzoEFvT4keKOl3BdgTlXkub7kIkMsdmI4MYEna0qomlg9s7NLt4QHAvi9roWZ58+xkrwHVMikCoxPIqW82Stt1IWMHX2fhQa42qyAB7bZclL8OLBmSoAd9WutoeawnqMa5twQw/wqM1Na6KZHg8+GO/xCK5U95RqZkjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXNHSXwGJ9vXMUNwclsV5xD0CV75iEB+98LrYYpIriA=;
 b=rXUteIti4cCZgr8gJBTcXgzNW5JrhrbizugunvszI65WjjumW3anVU9lyHmfLkeTWWo6aeOa8inbyESeEfQAwgS7d/SONi9DyYfw3CkeFF4wSNszBluECVLgb10C0viph18w5GDkgbCakXMGNxSsP7VOM+IwNz8xF05Cl60vSU5rNvcid4MvecmIMu48+lVsXpEFuMLUSzbdmjGJI9mBNhuFSeVz9zNZl/W/0xaSB7NSL4vxsS9EZg1etHNAc4iWNWdWwcOEJWVvi/JXclSxADBfHaExcNO/m0somCTNmqKLLB7mOEt/9IIhdkNtB26yPwUhZ4HIBRD987qOZkcAIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:28 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 5/8] vfio: Fold VFIO_GROUP_GET_DEVICE_FD into vfio_group_get_device_fd()
Date:   Wed, 17 Aug 2022 13:07:22 -0300
Message-Id: <5-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4de333df-8e2f-438f-8843-08da806a9419
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAB71O9sKJtPtBUaKUIk1THhwuCavlAq4jzFdjPLDEZYf41cY5MQEi5XbBmHRLJPpbZlSvzgJIZnj47aE6W04pTvlatvDABP5B3fReqS6YpquNJGO9qFRanTYfvZT13tkujyRZmsKMrb8Ii4z78uxlxrC1dH4NIgS6+Kpxjd2Ngtqw9DR7Uur+mOkLqYNSpqPy/gp0CTWNyuoYrgoXm8iRK9TbtitH/J6Tifl2xRixQ52MP1CQcd6EsC2kUKaeINeC6TAS+eZtJaqekGB5ZMin/Kl3MTGwsnB1PnfTlNZwQfkxPovJq7ZNhipT/YZR8OLJD0xVgyiGvxtEfgB1xyDogERUhJpdR5qjlhbDDoGjouB4jH++qdDKiErNYoD+9e0MylzyOAaMzNJ4AsyopHYJR2Tj9++TsPMgV6H3uKxYaV+NfmhG/XGqBans8ZEyPzV1c34U1tJAspZoQha79l96Okywb2aqei+uEBGYlFFRY5xAEU4MfWbRITTp/M1Wdi5MCt7buWqi7VJ41PqpErm47LlIY1V500n/H5ZnRTKPWYPYLTyjKqbhNGq5PrpsxtVru+KOh0TSpMTcQ2lf3zainy3+hW6dIygXkXwn06sp953rnB64EF1Jfd8k5y2Vj6GSh3sHleDhYh6RpidTcTI47BHUkLuO1BO2szwYG4gBT1RRJdxmEJ1Xy06oD/jZ7SOLtnF/rAG0hYZ6D2xw0SaQVhWtKddO1L4puAC3AVIHw0H6cQGp8xYK/ASjiBH9dZ9rE0jFHJHbsRVYrZ0WTpEkU8eMzLdJZBSwBHkuqUHzI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pag0ESmnPRebXbFnUiBS6S0JVb3P0DGn9WV/cizinrDa/RWL44HBIc/B34rl?=
 =?us-ascii?Q?IUQOCFF2aQGekpbKCwZ3CaH99k+Gp5KrbWdB71CPfOtprGdrSl81KswnlJYv?=
 =?us-ascii?Q?+XB/6g/ea7rwRtJYgU5LTaFXPC9cnDDUD0sHDz8cCITzZC5xItbk83IM+POF?=
 =?us-ascii?Q?oYUfGru7gINY+FfG5nqmMZFNoXD0Hc1o1Wi1FcpNVNKI9Ro7Nevha5Xs+cdW?=
 =?us-ascii?Q?YWcjkBb3BV+AeOO6reSO5mHTzUR8DuOzYzmrbJIrhdvz4Pf+i34pX62ucFQo?=
 =?us-ascii?Q?Vn351whfThKqUM4+mXJQuZPoZVyBSptzkkfgq8TD/Flcbi/NGbOes7RmbX33?=
 =?us-ascii?Q?EWXcFdmu3h3ZkQJbNubS7GnmolZyu+mje6wqi+7NemzsTX65f8lDAuwdmu6R?=
 =?us-ascii?Q?zt9zeWjBLojP8CjE6o7t2S5iv4Z2NY24t1iUC+qYh1sEylvKQOLDqi1b1Nw+?=
 =?us-ascii?Q?4LRp6r2HVbEzeDDUy62suO7Xh0SpL1e/9Jr4g7AznQgQi+RFUZ0NdfwxFquK?=
 =?us-ascii?Q?PPtm8CHskR1fyeaFZluLxFbb71ne/Dl0w3EK0O380sKuToY015E1+vx12ukA?=
 =?us-ascii?Q?rcHvuZYQla4mfJy4YdfPWNNIh/w2UmJxfRmdKvMSIzGCvyNN+6RDYapLWmIK?=
 =?us-ascii?Q?kI+prH9kXBp5ZC4oqyZXjrFpWyhciO53uIJ5EDzSsqNzt1femOaDeplAkSig?=
 =?us-ascii?Q?hvNq+F0z1/7hOKilb4o2fDQYazVX7EuZv8XzMmHCkVGwrwvtNbv4x79A8uvh?=
 =?us-ascii?Q?LegFjGWDvZXWFea3O/7c04/njsAAVkWnDZr3f/TDNtRrWdr5M1TCjcn0PTo1?=
 =?us-ascii?Q?8rbL+41XNyufwiHBQLS0H7ue9VnAKG6vmoKVEOS7wkZXu8b//FEJ3cBZ0oHa?=
 =?us-ascii?Q?T0MNHe9yWd/q62jPOhx11td3JP2h4LHVkVxXcV0L5rQhGdIlP01ycPAOmaTF?=
 =?us-ascii?Q?KL7hKyBGi/AwgwD9oXEnglfd3aWUOV2XuBtOxPEjY8NTXz1XxZ9SD4ybrnC2?=
 =?us-ascii?Q?1+zIqoEjuc7kZDZSzpR90zPGeLNYYDeYUWp7RH15mqdaPzda/NRhN2ucDm0T?=
 =?us-ascii?Q?eJR9gRRjrsffWUjNtN2uMePiJ328583HizcjounjYcwPOY2N/vNuCG655fPj?=
 =?us-ascii?Q?MCWjE9V2iua69lx9tUX44Djvmj8zU8NhfdJrShLtJpknz/RxL6Bla/wwZX3o?=
 =?us-ascii?Q?G751pjM3O65WeYu+vKkqNFlgs8wmMP3RKGydGNTs/lMMcXVEI6wLSjqKslzJ?=
 =?us-ascii?Q?2bInCxiqOX+wWRWdx0dws/yFqCTCly+8lCL+BoxSxdHOUtsVVtdfSWq6RLUp?=
 =?us-ascii?Q?fR/6uDBSNMP2BNuUDaJ8WizEcRpCoVwtuNS/GAUPitthwWYRU0Zk2h343TFc?=
 =?us-ascii?Q?Vj4k8aHx5rzuRnkvk/fKEF0/CQDnVuKWbl5dsKkRmXqes3y3+TtbWrd+78O8?=
 =?us-ascii?Q?FV2p8/pbOTnd3zMCn5dl4i/3s1INlgoISQpF/sew3AWH8ZUZ99sBSgXv7WnR?=
 =?us-ascii?Q?3DzjJ1BHaeQ/tcPTxhfEnXJeTTKQ7CwdIA/AmbgTAfgoCpTAQD/WEzb42rWf?=
 =?us-ascii?Q?QNXALAw2XAAn7uRe9B2t3qnAwUuK/PrnGd0c+lav?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de333df-8e2f-438f-8843-08da806a9419
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:26.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KD18SGh6FZ9ZixILgG5P2JHtx7g0Nzhp/wLJRWDYr+R0q/mz+m93yBC5IOYSl8Ks
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No reason to split it up like this, just have one function to process the
ioctl.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97a2..3afef45b8d1a26 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1178,14 +1178,21 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	return ERR_PTR(ret);
 }
 
-static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
+static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
+					  char __user *arg)
 {
 	struct vfio_device *device;
 	struct file *filep;
+	char *buf;
 	int fdno;
 	int ret;
 
+	buf = strndup_user(arg, PAGE_SIZE);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
 	device = vfio_device_get_from_name(group, buf);
+	kfree(buf);
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
@@ -1215,9 +1222,12 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 				      unsigned int cmd, unsigned long arg)
 {
 	struct vfio_group *group = filep->private_data;
+	void __user *uarg = (void __user *)arg;
 	long ret = -ENOTTY;
 
 	switch (cmd) {
+	case VFIO_GROUP_GET_DEVICE_FD:
+		return vfio_group_ioctl_get_device_fd(group, uarg);
 	case VFIO_GROUP_GET_STATUS:
 	{
 		struct vfio_group_status status;
@@ -1267,18 +1277,6 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		ret = vfio_group_unset_container(group);
 		up_write(&group->group_rwsem);
 		break;
-	case VFIO_GROUP_GET_DEVICE_FD:
-	{
-		char *buf;
-
-		buf = strndup_user((const char __user *)arg, PAGE_SIZE);
-		if (IS_ERR(buf))
-			return PTR_ERR(buf);
-
-		ret = vfio_group_get_device_fd(group, buf);
-		kfree(buf);
-		break;
-	}
 	}
 
 	return ret;
-- 
2.37.2

