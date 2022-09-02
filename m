Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54815AB916
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiIBT7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiIBT7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0644125E91
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnusR1uoRgQA5hztzpxVce/88gtQ7ZThDbO6dCkSw4+KYLJgwZOfQ2Txbea4ynSI/wrN9cztp4gzpTb943E8b9deu2ZgmfdLb514kkJgPaXDorQGCl9T4jPMcXr5kGrU5jFznufTironIaRmS5rLW6JB7q9w5/O5HeJ5p8qk0i6Yp0Dx7l1UE5K2t2lSczv75+HNOQUE3pLJ0FfFqGp58PtNqVh7iYR2jygau4XKGur9/Yb57iwIsGbAxGEs+QS+I5LYXDa5xy3XekBt+wUpy6H4JFis/DMDSCac31YTQIR5oz883ha7yD59VQrcHaXnak0U45yhFRUASM85youX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2jLwn+7rEU8tiClRJcGmwadJZq48cIKyOAXj2tP0BA=;
 b=kB45rb7p6AE2ijrpd6ZIEHuwa9OX9U5frYtmOhIpcaNy7P3BJtL/E5WliOXzOaaLLAgL3Ue4AtQLU2nN/XFoKq0i/5pIZ2RLxK3asAbQKqDi7Ct4jlZB+8Xt/ZlGBx+DxCNZxJ70uayA26/8pI69mi87n7pkQhEIya65CwbAhbK48IiWQYkF5rI7nqTh048T2eHLqvrS4n5ivu1Ix7V4+FVOOaI6RTCk+CuFYZryKA7/GikfHDpzn7fq5FpLhN+N+woEwJbMfr3h1QbbxiKdsGX518ySy+RBthgV6zRelQ6/w/+bf2N082UzQH5ndDwktOyvrogdgaEaThYFxIIMFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2jLwn+7rEU8tiClRJcGmwadJZq48cIKyOAXj2tP0BA=;
 b=MY4fJRiacEjZsAa60dCR4fi4WuEn2WJ8kKQo0+A+fbjPJywhiArRnS5Isxl4VRKvn0NEMkNPmtZMxdEmB5NF6KTpTxK/F/MgKYLHmIaKEAn7XLiILG9s8YEZ3+lpQh+DWFXQBIj99TrWiOdj3CZS7dgsQJC+COw63ehQeWlZMfNwVPCAyMDd0P8RzTGE8pLlZwlZzJuJogA4BCi4S+5SsjSTh492O+HtsV9mrD2Eek8uauqJHLx3QYL6XXVNg6Qwb2r0n6g/IQQauIaL1TebqZb3iNkG6e7t9sc1T06psBBqhgfYovxT4jmupVPRLxQ6bqIJfnOdFpmg63Ws87+1Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6883.namprd12.prod.outlook.com (2603:10b6:510:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
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
Subject: [PATCH RFC v2 11/13] iommufd: Add kAPI toward external drivers for kernel access
Date:   Fri,  2 Sep 2022 16:59:27 -0300
Message-Id: <11-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43925f14-e625-4347-36d8-08da8d1da67b
X-MS-TrafficTypeDiagnostic: PH7PR12MB6883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JTkUOZ+cYaB23sYu5zBxGs6Rp3D9U9ZHIyFvYErAFSJZR8XyjYywJWWAoXBphXnwEmrHNvvw8i2TaUgRJTBZ6y2kI2Iatj3CBCAlTPavtMqBFeXIBTDhqRlxYI1GDHn1JjKN/Av2BhynOtRC/NYJtKfdQi3uX0It/eRgnNH0qXu4iKjPWU9UBooOCcn164XRjJ2SSHVyEZSbMtv8BIMEOKnny5JMvAcVmh8hV09mnDnF2xN/Q41bKqFBTMOumB2uxBpPUGWdHHJXlgW8wvH6vpST57d9IS+ejj75Pe/ulVH9eXnCbPA0ZtUJja8R09JNzqnhZS+P1xQw0LwbaaNoYXPQoKjOhSmoyHMRhedVZBiAdsbOXVMwQ9N+GNo4HzvKQblaPQ0gaPoP8qMHCDYTpDxcvoMIYwhQMHcDJTvZvlZhyEeUWPZ9WDISb/5wQvLOoDKHa8VS8D5JAYz2lFqFNy8vIGdOUNI7nVWKKdgbZ8hJbkm6xrq8uLqU8cwZkN0r/9KoC2LntX0BZM1UX8Vru7gH8etCOa3rvqogj1iC+fzAWcqmnq9kFluNH4YBfd5swQc9mIsP+mEdnVuQnYig4ry77iMWi1L0f2VmoedcFshkqqUFpfAIqTkEOb8tAFTJlovJaZJ89c76YJWFtFUe3XAdZLIsIJWTgkb9MFtZDv4wl6r34XkmdyZL58JEWGQijATCvHHgjpqUABvozPW8YjGfQMKwiaz43OhzygwOf0yCIWXaCtAhVkqKdtv5uv/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(6666004)(4326008)(30864003)(66946007)(66476007)(66556008)(316002)(7416002)(54906003)(6506007)(26005)(478600001)(109986005)(6512007)(41300700001)(6486002)(38100700002)(86362001)(8676002)(186003)(2616005)(2906002)(5660300002)(8936002)(36756003)(83380400001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/82g7aFkUzQ4xK/0xL69fkxdxMwFVlK4VpUETGXXRW71WlvAblYiz1sq97te?=
 =?us-ascii?Q?rLnMqfII6tDOYC6qfJhWI3NFophzQNPFGdydmrm8miNhpF2JeVYGTrWRLPQQ?=
 =?us-ascii?Q?96CT/JFQGQUgQDvAPVyzq2nfzBnYk+nBBpnNiuzWWS21cD5RLh8BOQmBnKp8?=
 =?us-ascii?Q?AvZPeUlBeKbVMIRWUKQknGud+O0jwhE1C2hRQu3TbM7jHK0teaJd+BScpPzb?=
 =?us-ascii?Q?RRdRXdygbImt20FjUPTpyDTXcv4AWTsXc5dRLHuq5RB2PBhBPlQtG9lrSkQO?=
 =?us-ascii?Q?kO4OjwqVBUJnwSrA2Kiy8D80oueoL4YBd0qniNOat+ZXgij3XhEeI3v7e5xm?=
 =?us-ascii?Q?722cOkzOptnJZ0PvNNjMe8r+Dx6onZMdbqvBwofnMNQsE8DsRaJlbYrmi2E8?=
 =?us-ascii?Q?uVtJlNKzns9zu6lkiFVevUiyVdpipsJ9Qs7QA5L0NYaW8p4O3rHgKThSj6+P?=
 =?us-ascii?Q?AneYwvapxD0DiwTNefhgRep/oUuN4eeil8h3A952fF/HW0+CGr72zVazKq61?=
 =?us-ascii?Q?VYNB4kIYtGX36W9XjchHwfggj3obEq+HFXVTaRLFKK+XBucoMrosQcfHxYJm?=
 =?us-ascii?Q?yu/anE65nKwD1cMl+50j+PBV5sM95x5x1qr6c3pIl+VeT74a17wjdJXUWwpF?=
 =?us-ascii?Q?rBWO9Exq0Y4z4t+VGlhi/EQ2x4QH/BkDOojYiey+oKdoH1zqdcM5JIfm+fwg?=
 =?us-ascii?Q?vDHCNT49MbP8l9cLx4JqU+zWOInZYFrNENnC0b72+YUErM0aApVd9MPp1tLo?=
 =?us-ascii?Q?Jrur5fY6she9ybDaWPIr+pkC2mqEEB0YPk5zAHzqOAJ4ILYMoWTjFhAVJ8fQ?=
 =?us-ascii?Q?FJAwtQBbHEHg/sXSE3x6SO4rqr846Z9nwzKEnUVDq5deoGs6rY6U8moCis2I?=
 =?us-ascii?Q?ncIFLHUYo8et23I1hN46lRU6/WC7wVYbnz6ZLD31fZaVkvByJMS/aUnN2NKF?=
 =?us-ascii?Q?c+fxesbHs4BxOPoFQ0+u7UC8QQYniX1fpE5Zd2rL06rJsFc78vMzuvTD5can?=
 =?us-ascii?Q?xglKT4ZZkJdZyFZMUm45ObvoaLsxqqAgLB8J8bsTBjGj4KE3DbvOXPLRFNjk?=
 =?us-ascii?Q?USceBuMkUbIcPTK2SAqJM4GakK3VZoScQDSsUMgPceSv+7Z6OfsUwnvjKAi2?=
 =?us-ascii?Q?5qxknUUOxjSM+/cEjMsvA60/f39hG874kQhZ+CmqJ5acP8VGTNykUDSbm9QC?=
 =?us-ascii?Q?rfJDPI/drQ5buxvRyazHkT3SHbwQ1GDn13QiUJCzad7fKkugTkEc3pcrEF46?=
 =?us-ascii?Q?+0ogwtUpsvnbI2il1jT9D4bGFFDai/SFCRRq88kqiYxTp+hx0QB2afF696iY?=
 =?us-ascii?Q?fGQwvu11dG6B2/0adjNVaSwNEJG4KseKkLVlp9LQ07LzHXh5prHLq8o2FxdK?=
 =?us-ascii?Q?ff/ls0o4fWJyybqQGrjUds2+sInRKYkq6ZgGFGq0GntoRZj8y6uK6n0h1l42?=
 =?us-ascii?Q?PPDdp+WzWtUdPTqG9MdwLa83rgB+igO5PmS7BjCUJgou5xmwDcUKc4EL9PUO?=
 =?us-ascii?Q?ripCM9pmBt27CQzcvaiUESD9wE6wJnhElW/4fdnES7iOTWrYCLGSh1ElTJ6O?=
 =?us-ascii?Q?vNh469hN4rZEufdkCwhWEdFTHERQglqTRLTIUqz2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43925f14-e625-4347-36d8-08da8d1da67b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:31.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSSIyKmNqiXz5KfyPingANPaMdHGZ57osb1/du99OxQcWHys3ZMvH0zr4slHb8HE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6883
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel access is the mode that VFIO "mdevs" use. In this case there is no
struct device and no IOMMU connection. iommufd acts as a record keeper for
accesses and returns the actual struct pages back to the caller to use
however they need. eg with kmap or the DMA API.

Each caller must create a struct iommufd_access with
iommufd_access_create(), similar to how iommufd_device_bind() works. Using
this struct the caller can access blocks of IOVA using
iommufd_access_pin_pages() or iommufd_access_rw().

Callers must provide a callback that immediately unpins any IOVA being
used within a range. This happens if userspace unmaps the IOVA under the
pin.

The implementation forwards the access requests directly the identical
iopt infrastructure that manages the iopt_pages_user.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c          | 123 ++++++++++++++++++++++++
 drivers/iommu/iommufd/io_pagetable.c    |   7 +-
 drivers/iommu/iommufd/ioas.c            |   2 +
 drivers/iommu/iommufd/iommufd_private.h |   5 +
 drivers/iommu/iommufd/main.c            |   3 +
 include/linux/iommufd.h                 |  40 ++++++++
 6 files changed, 178 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 23b101db846f40..d34bdbcb84a40d 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -394,3 +394,126 @@ void iommufd_device_detach(struct iommufd_device *idev)
 	refcount_dec(&idev->obj.users);
 }
 EXPORT_SYMBOL_GPL(iommufd_device_detach);
+
+struct iommufd_access_priv {
+	struct iommufd_object obj;
+	struct iommufd_access pub;
+	struct iommufd_ctx *ictx;
+	struct iommufd_ioas *ioas;
+	const struct iommufd_access_ops *ops;
+	void *data;
+	u32 ioas_access_list_id;
+};
+
+void iommufd_access_destroy_object(struct iommufd_object *obj)
+{
+	struct iommufd_access_priv *access =
+		container_of(obj, struct iommufd_access_priv, obj);
+
+	WARN_ON(xa_erase(&access->ioas->access_list,
+			 access->ioas_access_list_id) != access);
+	iommufd_ctx_put(access->ictx);
+	refcount_dec(&access->ioas->obj.users);
+}
+
+struct iommufd_access *
+iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+		      const struct iommufd_access_ops *ops, void *data)
+{
+	struct iommufd_access_priv *access;
+	struct iommufd_object *obj;
+	int rc;
+
+	/*
+	 * FIXME: should this be an object? It is much like a device but I can't
+	 * forsee a use for it right now. On the other hand it costs almost
+	 * nothing to do, so may as well..
+	 */
+	access = iommufd_object_alloc(ictx, access, IOMMUFD_OBJ_ACCESS);
+	if (IS_ERR(access))
+		return &access->pub;
+
+	obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(obj)) {
+		rc = PTR_ERR(obj);
+		goto out_abort;
+	}
+	access->ioas = container_of(obj, struct iommufd_ioas, obj);
+	iommufd_put_object_keep_user(obj);
+
+	rc = xa_alloc(&access->ioas->access_list, &access->ioas_access_list_id,
+		      access, xa_limit_16b, GFP_KERNEL_ACCOUNT);
+	if (rc)
+		goto out_put_ioas;
+
+	/* The calling driver is a user until iommufd_access_destroy() */
+	refcount_inc(&access->obj.users);
+	access->ictx = ictx;
+	access->data = data;
+	access->pub.iopt = &access->ioas->iopt;
+	iommufd_ctx_get(ictx);
+	iommufd_object_finalize(ictx, &access->obj);
+	return &access->pub;
+out_put_ioas:
+	refcount_dec(&access->ioas->obj.users);
+out_abort:
+	iommufd_object_abort(ictx, &access->obj);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_GPL(iommufd_access_create);
+
+void iommufd_access_destroy(struct iommufd_access *access_pub)
+{
+	struct iommufd_access_priv *access =
+		container_of(access_pub, struct iommufd_access_priv, pub);
+	bool was_destroyed;
+
+	was_destroyed = iommufd_object_destroy_user(access->ictx, &access->obj);
+	WARN_ON(!was_destroyed);
+}
+EXPORT_SYMBOL_GPL(iommufd_access_destroy);
+
+/**
+ * iommufd_access_notify_unmap - Notify users of an iopt to stop using it
+ * @iopt - iopt to work on
+ * @iova - Starting iova in the iopt
+ * @length - Number of bytes
+ *
+ * After this function returns there should be no users attached to the pages
+ * linked to this iopt that intersect with iova,length. Anyone that has attached
+ * a user through iopt_access_pages() needs to detatch it through
+ * iommufd_access_unpin_pages() before this function returns.
+ *
+ * The unmap callback may not call or wait for a iommufd_access_destroy() to
+ * complete. Once iommufd_access_destroy() returns no ops are running and no
+ * future ops will be called.
+ */
+void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
+				 unsigned long length)
+{
+	struct iommufd_ioas *ioas =
+		container_of(iopt, struct iommufd_ioas, iopt);
+	struct iommufd_access_priv *access;
+	unsigned long index;
+
+	xa_lock(&ioas->access_list);
+	xa_for_each(&ioas->access_list, index, access) {
+		if (!iommufd_lock_obj(&access->obj))
+			continue;
+		xa_unlock(&ioas->access_list);
+
+		access->ops->unmap(access->data, iova, length);
+
+		iommufd_put_object(&access->obj);
+		xa_lock(&ioas->access_list);
+	}
+	xa_unlock(&ioas->access_list);
+}
+
+int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t len, bool write)
+{
+	/* FIXME implement me */
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(iommufd_access_rw);
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 7434bc8b393bbd..dfc7362b78c6fb 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -349,6 +349,7 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 	 * is NULL. This prevents domain attach/detatch from running
 	 * concurrently with cleaning up the area.
 	 */
+again:
 	down_read(&iopt->domains_rwsem);
 	down_write(&iopt->iova_rwsem);
 	while ((area = iopt_area_iter_first(iopt, start, end))) {
@@ -377,8 +378,10 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 			area->prevent_users = true;
 			up_write(&iopt->iova_rwsem);
 			up_read(&iopt->domains_rwsem);
-			/* Later patch calls back to drivers to unmap */
-			return -EBUSY;
+			iommufd_access_notify_unmap(iopt, area_first,
+						    iopt_area_length(area));
+			WARN_ON(READ_ONCE(area->num_users));
+			goto again;
 		}
 
 		pages = area->pages;
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 42b9a04188a116..7222af13551828 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -17,6 +17,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj)
 	rc = iopt_unmap_all(&ioas->iopt, NULL);
 	WARN_ON(rc && rc != -ENOENT);
 	iopt_destroy_table(&ioas->iopt);
+	WARN_ON(!xa_empty(&ioas->access_list));
 	mutex_destroy(&ioas->mutex);
 }
 
@@ -35,6 +36,7 @@ struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
 
 	INIT_LIST_HEAD(&ioas->hwpt_list);
 	mutex_init(&ioas->mutex);
+	xa_init_flags(&ioas->access_list, XA_FLAGS_ALLOC);
 	return ioas;
 
 out_abort:
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 0ede92b0aa32b4..540b36c0befa5e 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -52,6 +52,8 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
+void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
+				 unsigned long length);
 int iopt_table_add_domain(struct io_pagetable *iopt,
 			  struct iommu_domain *domain);
 void iopt_table_remove_domain(struct io_pagetable *iopt,
@@ -95,6 +97,7 @@ enum iommufd_object_type {
 	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
+	IOMMUFD_OBJ_ACCESS,
 };
 
 /* Base struct for all objects with a userspace ID handle. */
@@ -185,6 +188,7 @@ struct iommufd_ioas {
 	struct io_pagetable iopt;
 	struct mutex mutex;
 	struct list_head hwpt_list;
+	struct xarray access_list;
 };
 
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
@@ -231,4 +235,5 @@ void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 
 void iommufd_device_destroy(struct iommufd_object *obj);
 
+void iommufd_access_destroy_object(struct iommufd_object *obj);
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index b09dbfc8009dc2..ed64b84b3b9337 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -327,6 +327,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_GPL(iommufd_ctx_put);
 
 static struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_ACCESS] = {
+		.destroy = iommufd_access_destroy_object,
+	},
 	[IOMMUFD_OBJ_DEVICE] = {
 		.destroy = iommufd_device_destroy,
 	},
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 477c3ea098f637..c072e400f3e645 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -13,10 +13,15 @@
 
 struct page;
 struct iommufd_device;
+struct iommufd_access;
 struct iommufd_ctx;
 struct io_pagetable;
 struct file;
 
+struct iommufd_access {
+	struct io_pagetable *iopt;
+};
+
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
@@ -29,17 +34,46 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
 			  unsigned int flags);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+struct iommufd_access_ops {
+	void (*unmap)(void *data, unsigned long iova, unsigned long length);
+};
+
+struct iommufd_access *
+iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+		      const struct iommufd_access_ops *ops, void *data);
+void iommufd_access_destroy(struct iommufd_access *access);
 int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
 		      unsigned long length, struct page **out_pages,
 		      bool write);
 void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
 			 unsigned long length);
 
+static inline int iommufd_access_pin_pages(struct iommufd_access *access,
+					   unsigned long iova,
+					   unsigned long length,
+					   struct page **out_pages, bool write)
+{
+	if (!IS_ENABLED(CONFIG_IOMMUFD))
+		return -EOPNOTSUPP;
+	return iopt_access_pages(access->iopt, iova, length, out_pages, write);
+}
+
+static inline void iommufd_access_unpin_pages(struct iommufd_access *access,
+					      unsigned long iova,
+					      unsigned long length)
+{
+	if (IS_ENABLED(CONFIG_IOMMUFD))
+		iopt_unaccess_pages(access->iopt, iova, length);
+}
+
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
+
+int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t len, bool write);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -49,5 +83,11 @@ static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
 {
 }
+
+static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t len, bool write)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IOMMUFD */
 #endif
-- 
2.37.3

