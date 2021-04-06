Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1B355C67
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244952AbhDFTlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:05 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242678AbhDFTk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbuYIMwnWonqZR4dLf1NO5VNFUr7W2KU/mpEUC+o2IA9BN7OiDI56IIcrje3u3+W1kfTq8KpGLgQ4S+jdVXd17AT+MKARRgn+Gwnr2XN4snI/VJib6i3MWliDbA6GU5saBqqaX2Nads8hZkIW69t9iuBYaMpoplNjC4cyCnxFJrvT1gM7Ew0Ra3KfwwlES1NVCX/SANgKZmi5cNEEvrwn2ngydzSM5DOPMEGOYpqwu6pyBfvMI2qp0pnDmFG0mDilUvfztNYdi4IlnKMkaYgLpbP8YbUxQdm7YSWeivtoys85TUzQEJT0L2RiPfqqqcvBdI0wz4mJ4in3PVgyF36eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJY1v+XlYCTjZlIiEJ2Xtq8V6wPAp2Rn19LM+ZDbatI=;
 b=S/hf9s08XT6szQpZbR7uUSuEIbMH1WzgSvLTAYAGM+xflRHcBnP2Eloz1DJ8qJ+F0NT2DND20uUUCpP4J4dt97tnqOj8r0RYx3uaZBBwwNidorbwzRQpZ5Fn9pDt2teGkXxcQlDGUV/D2QV7E9r9Pbu2cofIvOVNqqJ6K2xgcZvQBXlTXDlYsXeBn2zW2MvbZujjcoLEk47L4RTdTvc3MQ9bq/4bkqSfgS/3/ZExdYKCBFlHXvuSkLkh9BcroSIXrxnNbDKs5jJAl/H8eObAMah//PuTUGHZOZth9wirJdd+ZybpJqiufC5UV4chVWRMw+CzHrN4C5zJLlB/8OC87A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJY1v+XlYCTjZlIiEJ2Xtq8V6wPAp2Rn19LM+ZDbatI=;
 b=K9adWXW97cmN+MmQA5XgUJxYYZ0KhLrQ8lDrL30XPO1rqiE98t7BW5AubYB9BuYtGGBHelBsYm435gzYknFqO1TJh1NHBrR6vppA6xeyWZz/ds1FfJGK+f2FzE0oJzr8JxcMBob7GkCcDSoIvkwOYFV9JfJeN19grKevIB6UL4y9tVxj9DwlejnhoF+Ek6UZPQ+ui8znzvEegJ5zbXFL2OEWHxu6GFieloOAsQJRGbBD2/VNvJu05tacevNmp/wWXTViK+o10B/zcXvFr+ajNRGwGiNI5b1X3d2GU/ZkuWtN+oN98BlwtAeDxXcPbYNv5fvaKHdWAIQtmQwI8vrSQQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 12/18] vfio/mtty: Use mdev_get_type_group_id()
Date:   Tue,  6 Apr 2021 16:40:35 -0300
Message-Id: <12-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0281.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0281.namprd13.prod.outlook.com (2603:10b6:208:2bc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 19:40:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXa-9c; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40da97d6-73e7-491c-784b-08d8f933df20
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42351EBA2B444C8482D457E0C2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjhntGBWS6Qz6N0xmWV/hZwzt91i/sB6UGWSOupSnVW90XsyYLg9kZZfhbFFeZDhRwFwXq5sMuUh+M/FwM1fy78GxUXw+LE9r5JRoyedKUJI6VNHH1EBslIMKjmaW58WGAPbvISrHyjVdBKSFhiowRNe0xoWnvBgRy0gcTVHSZS808ikMEN263Rd/VcW1aSUOvKtPqQ/17Ob/UzvqkfGFPCgX/x5pYmsE4+EUgX0SW6CIYaDyZF4T5SPyP/ev+jCv7SVEXgTDf6wexmpHhy3b1D6Ih6rNGojZrTTEdevlQtXqzb31Wv+zZP7q5Rl4yGg3kVPajuJZvluYlBaft0auRkHWOxvbAYMG2L5fY5WE6idzgNdWlk/8B6rJwsW3PibJLJt0konRyicUGoh95hCzv/obu67t2gfwmKzVe9ShfRod+Tkp7AlM0+UQL2IqHMS+n/V3kuFWS1eVJbN6Vi1p5rCUagx5swkXuRhJuoMSQ7AUOOG6TqC1KuPwtwvxVP9CjR55b77Cc10+68dSWi8XwH2zd7gc0Va+YxiAwKxL8rYz4hCo+mX8l66eeVZj3O03Ncw56MdfE30TI0D2U1boEVxFj3FhWER6u1ABf758zhEQzQoovI5XpA2SyT/fu0R/XYB5bIHb4GCjCFajhbpP7u4WuREfvzTX6cDE9KRU+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(37006003)(4326008)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nSoEqHs4F2Eui2AxD+QNFLwfKFF54IXxYyYGoESJnMA5FQMCZtRKYWBU3XqT?=
 =?us-ascii?Q?/WXFGTR3tFUMVY3BO86uQZ3l8ePT9cwMToTSFXWsTP4nJIJCMj4qADhrx1x0?=
 =?us-ascii?Q?ag8i1Zovj14iQfroQDJN7BkM2xrvSJ/SXy89ijURcHPG1NBLwGLiSXs2bMDm?=
 =?us-ascii?Q?UGM1W5U1A8bltJw7E5jj7+gYyyxlOSUXo+0ais/J9m2uZJZbdePs6+6JhKrK?=
 =?us-ascii?Q?8h2CAMp2SvGETE0unxyDNXU/IdIi9jr0TeOskVhXQqRk0eC72rUUYo7rjkx9?=
 =?us-ascii?Q?gTBzjcKzsm27pWhc1Z2pcDGfk8jgdEUj7I1OTwiBzjvGlaELdqDZisLJzVuL?=
 =?us-ascii?Q?GgeFPOQs0zwGF4hKyNA3k8ZRnEy0UPyc0j8Ds7vB079npT/jkEu+uT7uNRc9?=
 =?us-ascii?Q?BsP27z88uAyxnf5ELL24vATBXptWGsm72bkX+orwcFnAbmnZBrX/WaSTXki0?=
 =?us-ascii?Q?V46PVCsae2R3Q116z5Csx2LiqBxr8pa7YuPAjfz2Nubn1lSB/VWiDEgUqFmo?=
 =?us-ascii?Q?HNVbQMN/ZK/kQMRZse8lS5X0/HUVJUJcAvOweuBi2eCi5Kk2l4JonUIdyOVU?=
 =?us-ascii?Q?HUdaT1SOaFC0cgmJ5x8RmzUn5M7p43xQylrI30jkpzhXy4q8EnIPUSDP1d1e?=
 =?us-ascii?Q?qP39m+uOdjPgH6rJtPLrxt/ByKvHEmbJLygNV9dP3D9ChQP3ugpLgepMt7Al?=
 =?us-ascii?Q?lLAUq+51bB0qAVTVJPqSVDXkkGDFImFe1VLHo4eGs/l6ZJLS4pfxNKwpvXwb?=
 =?us-ascii?Q?3LELzEC4+QbAMKmS4ut24SWod8Dw0YFiQ4x9gv2Gtft2RVPQOaZH83wpP8w0?=
 =?us-ascii?Q?hGww0UUTdghIhghVOlY7uSu1txZG97loto9xR3gszxnW3a3MkzYfyOwwBcy2?=
 =?us-ascii?Q?QIrVNkLv0wD+nqDzDktSc52ECd2QRhtjwh9TSztDrUtZ5jDZLumw76fqaWJv?=
 =?us-ascii?Q?nD8rdO9jI8pNA8hQhFIdzs10O8cEXM1KV1+eyCewmTF6GftlpXeNcRYXF75g?=
 =?us-ascii?Q?kLPeoV0QsWeI40nGxQP61/DCBwWvLQl3AkrgAly+b5azAl9kmmoMKu0zAbhi?=
 =?us-ascii?Q?q+2IXDTlT1LUXT34OBYWakbIXtXiky+0m6fXoMm0zTqs6FWLS6Gqs0x1N90T?=
 =?us-ascii?Q?8xDcZD9XCUU8weVYJD8NJWYY2f8+a9vIRd+3lJC7UNUDVQp5IC9tV8oKExBk?=
 =?us-ascii?Q?4z09tyH4OpOvnxCnjeFwMLd6LjPz0AxKSyIG1NxbKRJvevOavbBeeuT4oHA+?=
 =?us-ascii?Q?SLELpcwSr9QfgRdpMQGJj36cjR+q9e6pLACsan8lXtf9ftwmEBcYC2ZHe6DY?=
 =?us-ascii?Q?G94uEJ1fFMX7VBgtYdNiYaIR+RcjfmCvPQjs969JEpw8iA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40da97d6-73e7-491c-784b-08d8f933df20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:46.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGyNkm7+7HrB7hnp6p6FHwsckWaGeX/7ug44IV3LrPIZkxL5clW6YhNsIsSX1YHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The type_group_id directly gives the single or dual port index, no
need for string searching.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 50 ++++++----------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ce84a300a4dafd..191a587a8d5ab1 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -711,23 +711,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
-	char name[MTTY_STRING_LEN];
-	int nr_ports = 0, i;
-
-	if (!mdev)
-		return -EINVAL;
-
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			dev_driver_string(mdev_parent_dev(mdev)), i + 1);
-		if (!strcmp(kobj->name, name)) {
-			nr_ports = i + 1;
-			break;
-		}
-	}
-
-	if (!nr_ports)
-		return -EINVAL;
+	int nr_ports = mdev_get_type_group_id(mdev) + 1;
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
@@ -1311,18 +1295,11 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t
 name_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	char name[MTTY_STRING_LEN];
-	int i;
-	const char *name_str[2] = {"Single port serial", "Dual port serial"};
+	static const char *name_str[2] = { "Single port serial",
+					   "Dual port serial" };
 
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			 dev_driver_string(dev), i + 1);
-		if (!strcmp(kobj->name, name))
-			return sprintf(buf, "%s\n", name_str[i]);
-	}
-
-	return -EINVAL;
+	return sysfs_emit(buf, "%s\n",
+			  name_str[mtype_get_type_group_id(kobj)]);
 }
 
 static MDEV_TYPE_ATTR_RO(name);
@@ -1330,22 +1307,9 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	char name[MTTY_STRING_LEN];
-	int i;
 	struct mdev_state *mds;
-	int ports = 0, used = 0;
-
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			 dev_driver_string(dev), i + 1);
-		if (!strcmp(kobj->name, name)) {
-			ports = i + 1;
-			break;
-		}
-	}
-
-	if (!ports)
-		return -EINVAL;
+	unsigned int ports = mtype_get_type_group_id(kobj) + 1;
+	int used = 0;
 
 	list_for_each_entry(mds, &mdev_devices_list, next)
 		used += mds->nr_ports;
-- 
2.31.1

