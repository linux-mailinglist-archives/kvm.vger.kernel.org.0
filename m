Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5879B078
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbjIKUuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjIKJkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED38F102
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAz3L/NECJunXFESWcUHLMYLZxZqwApJZqlnPDmv65zPi4q/FRsZNe6dBEym0Dm4324N3tTWdGL6UaGfU6/Fp+qobWFR+JF1R7gnzbefxGm3hFZbT5ssJISCmcgoK8EIOMqrrPXRStbx4myGa3pcyfiklq0YYp6V8TMJG65i/CHmo5y/jDH8+lPmkDmDsa3YOI9x06IsaBrWSCzPI9eGTNlvKIKqTf9x2Y0Tk0Ob1udOOeJOm4D2PfOGY7DiZunbiuFE/zZ4jSgORUrZCTHIZ2RJQs6QHz4jjo/wlGyFkIZjDCJ028lnjKns5JM3VSZi/WClArCW/lU7td/YjBKE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKWO3lw76jRsrAqf/QgOO4wyRQwRgv9xYumYAJMdNW4=;
 b=mlebxUV5XUvceH0Y7eX7Dcq6qFf7QzlQbm26SR9q0K8hUV1KWE6h2XOnlwbak5UpxrjW7QDwCWwO9bJVeOtEOtZ/S2rNxAspX1pizXSR9jhXolrFlYrLsvNFMcnv30Upeo4hoZadntm0/YJd1Lx9kaYPJ39Ee/HctLd88y8hQYnkSVLKZYBI6F1dOyF6o+Lwm2wD42/FhLOYpGiU596kvFdsPyZ6n+kxiUvw3vUWygnGbvkrsm8URDSqU0XEev4jdFWXdOqmryxVKPNEVRHJrEvwk+LQUT6Cq1Zh4rGYFouC9X1/oduhz4A1SLlTa+f2p3gevsOHhMIJNSayOYem2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKWO3lw76jRsrAqf/QgOO4wyRQwRgv9xYumYAJMdNW4=;
 b=o6t4ygJUdSGLRFMo8NEcuxtqtIqHCWcPWE/lO5eNu+hoJBDk5rXp9Doucld31pADZtumxRyCKtBUWmmmHmONvfZry15D/bVaRdNpaGSs474g4d8eXr8KQTy++S/8cWgRapaxPPuvJ2diMwp6FmN3y5tBa3SXE9LI8S676Xw8uSIXAk7uIo+g8vILUOxvd3SoYLQ3x+phI7ym3pe5akAa4gHzvWXqyI+besr0Rp/wtsQiQDchPg9VuUYhZiFc3GTH0GDrd1g6KECdGZ1SPN+g82Mi1K2TH02gh+q+atvPVF0zQUls7I78/4VxUMPWZQyBVm63US/zTuLAlU3Bq0bAng==
Received: from CY8PR11CA0027.namprd11.prod.outlook.com (2603:10b6:930:4a::20)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Mon, 11 Sep
 2023 09:40:12 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::5d) by CY8PR11CA0027.outlook.office365.com
 (2603:10b6:930:4a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:40:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:40:03 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:40:03 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:40:01 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 8/9] vfio/mlx5: Add support for READING in chunk mode
Date:   Mon, 11 Sep 2023 12:38:55 +0300
Message-ID: <20230911093856.81910-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: a40bc0b4-e881-4db6-ea8d-08dbb2ab1849
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahh3EZwQpmiQPFiIhoXFbZnxdBns6uc2Luep5g5TBji0l2V/zqEp3u0kHPHt2qhL0fxomq+FTCa2pKB6DS0J8XXrxMNrUDf3GTOfDij4cH1YSbAWPocZ7Gj8jlTXJBNs4WJfBTz0xkOiIiJOJ5CeW7wGXEnrH/4SgRgxWNowGdPaDZOYM/LoFOdOCMPT7+g6YG6amCQtnEI1nX6MdxSL/whxekoeAnq2Yqf4kT5tje1juugJDmyuCYn1xvXJeptgNuJ4h8tfHsXbASAeMS2cw2KQ1jX9uS/XE9SYb7/eoZcs2jvnWwjlYbIk6XYxX4jm9ywCHDUIOceH1Xj8YS8+7Vcuo2SJ8rX9S+i2kE1xi+TdpCWIeGTnrx4PL8cA1PicUhNoeXa7Ua2bqOiXy5dKMjs99IPEi6npRgERxurrtVAMGe7SmV8cgOUycmv7jmQdTlumMQ5/ahGybjh8pwflT6+wITDFY5nHqYftju40/f7I5VKtWZ/g1l6Z5aBhNaPG+zVW/a3Pj6r8VesVX/WXkNwKavIGLh6zprot6drvSStwwAJqbTMBYENlPxG5GVGDZB4xBfkTmvp6KqhCs+kH4D6De1vH+8B6N3hePVNqhRxN4ZmDbHa2K7T1h6SKAuzkTfCWMdkTbUqkW0R1Aquw1czMla7r2cRFErJmDyqKzYLyjJZvVQiEK4/7R/KCG0OuYrc1HtVazStUrA3NVw8DjB93mxI71x7yE+f4WR/2H0nTO/WJsXq0/xroGroo5buK
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39850400004)(136003)(82310400011)(451199024)(1800799009)(186009)(40470700004)(36840700001)(46966006)(7696005)(6666004)(478600001)(83380400001)(40460700003)(1076003)(107886003)(26005)(2616005)(426003)(336012)(2906002)(70586007)(54906003)(6636002)(70206006)(316002)(110136005)(41300700001)(5660300002)(4326008)(8676002)(8936002)(40480700001)(47076005)(36860700001)(36756003)(86362001)(82740400003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:11.8143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a40bc0b4-e881-4db6-ea8d-08dbb2ab1849
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for READING in chunk mode.

In case the last SAVE command recognized that there was still some image
to be read, however, there was no available chunk to use for, this task
was delayed for the reader till one chunk will be consumed and becomes
available.

In the above case, a work will be executed to read in the background the
next image from the device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 43 +++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index c80caf55499f..b6ac66c5008d 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -160,6 +160,41 @@ mlx5vf_get_data_buff_from_pos(struct mlx5_vf_migration_file *migf, loff_t pos,
 	return found ? buf : NULL;
 }
 
+static void mlx5vf_buf_read_done(struct mlx5_vhca_data_buffer *vhca_buf)
+{
+	struct mlx5_vf_migration_file *migf = vhca_buf->migf;
+
+	if (vhca_buf->stop_copy_chunk_num) {
+		bool is_header = vhca_buf->dma_dir == DMA_NONE;
+		u8 chunk_num = vhca_buf->stop_copy_chunk_num;
+		size_t next_required_umem_size = 0;
+
+		if (is_header)
+			migf->buf_header[chunk_num - 1] = vhca_buf;
+		else
+			migf->buf[chunk_num - 1] = vhca_buf;
+
+		spin_lock_irq(&migf->list_lock);
+		list_del_init(&vhca_buf->buf_elm);
+		if (!is_header) {
+			next_required_umem_size =
+				migf->next_required_umem_size;
+			migf->next_required_umem_size = 0;
+			migf->num_ready_chunks--;
+		}
+		spin_unlock_irq(&migf->list_lock);
+		if (next_required_umem_size)
+			mlx5vf_mig_file_set_save_work(migf, chunk_num,
+						      next_required_umem_size);
+		return;
+	}
+
+	spin_lock_irq(&migf->list_lock);
+	list_del_init(&vhca_buf->buf_elm);
+	list_add_tail(&vhca_buf->buf_elm, &vhca_buf->migf->avail_list);
+	spin_unlock_irq(&migf->list_lock);
+}
+
 static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
 			       char __user **buf, size_t *len, loff_t *pos)
 {
@@ -195,12 +230,8 @@ static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
 		copy_len -= page_len;
 	}
 
-	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
-		spin_lock_irq(&vhca_buf->migf->list_lock);
-		list_del_init(&vhca_buf->buf_elm);
-		list_add_tail(&vhca_buf->buf_elm, &vhca_buf->migf->avail_list);
-		spin_unlock_irq(&vhca_buf->migf->list_lock);
-	}
+	if (*pos >= vhca_buf->start_pos + vhca_buf->length)
+		mlx5vf_buf_read_done(vhca_buf);
 
 	return done;
 }
-- 
2.18.1

