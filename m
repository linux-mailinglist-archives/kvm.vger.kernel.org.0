Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A9679C86
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjAXOu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjAXOuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:50:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5474B182
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:50:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwSAQEq48YcztmYgqjYf61RiPpZIMI1I3w+knhDXNLw8t9X7WiVH6VGcik8OzhML46Lm4pWipVOq5+Iu4CI8mG/I3vXLesHxtE6Wy4fOspU1miK5hFNW8AFgzFIY33REG9pvCxjUboQC04I1MQotE9s7MGJtoCyNNeuhB4LEMAevY9RInUE0bZKFpOva27WS+JLPUflOUoLp9HSOdk9WOmUzMn7QqzJasDVgSSRW7Zkdx4ADtZyDW2DEHntG7P2KtLYevaFWu3JsG8zPc62NXTYH+EVoskWTN1A4QXrp84X2OBx+JCYjgsStj/o9u47QmvMktfkVAordr7TojZLA9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aj52pQ/FTDBYTCd9ghfw6HdVCVAuMxtlVeUjBbevBg=;
 b=J3gFb7z5x1qmmr4uRG0yKQ17UzyVsdgL44ZOYHjpdCEIsZfP9N9HosDR/XeqsQ6Ocx6ZfK04qBZdcoZ53PrGp2mdVYINPzYRS1hcc/b8uxAgwkCM8DIpcOLuPHG2vjJo/KY5z57SRxghdiP5sJd88mGeC0fgtYz8R94vAh3asEBgyrRNxDqj1l2xcM7Ix3HC7URAJ2Uxxcilg3YWhvbL4xZkMzVajF/rpc4ldCgD30B+bJgR4nnv8QDFN9xb4V8Ir6l6SQJ45fItXhjLVs0j9vDm3WOJeywD+oHSgU7vQjiqlcW7DuqqBiIOxE0tTNySg+bgAcszlfiiVDAZVvMrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aj52pQ/FTDBYTCd9ghfw6HdVCVAuMxtlVeUjBbevBg=;
 b=dJzCgLH+5B8awpJXZLRWyYkxOJ7LFUcoxNNRixKB6dRpq9NfFctk5NmgMnOMwQFkMtG/V8TJ407bhYKSjh9Y7ItTar4m4Fa7sNwCVsoqXwfC0Hngmcaj8Paj67x+QfxhgoXS5vBCibDRZCI4BO9HsFxUDRUqRvEnJrbp55YvbOQxhsMjREVu9QQIVjNM20oBNp920TXpR5bNkrubPm0p3AKx1l1hOA6Z+sNwboJuhR/9CUQwQIUETOKpaKabIYu8LDe3EaLsE2+kS0ot7iEbYknG9opavyA1uoc26pBRZjHOqyN6tvspjBbKqvvO62BYofnUSwxNg3imcsOIxv9+PA==
Received: from MW4PR04CA0349.namprd04.prod.outlook.com (2603:10b6:303:8a::24)
 by PH7PR12MB6883.namprd12.prod.outlook.com (2603:10b6:510:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:50:50 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::38) by MW4PR04CA0349.outlook.office365.com
 (2603:10b6:303:8a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:50:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:50:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:29 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:50:26 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>
Subject: [PATCH vfio 3/3] vfio/mlx5: Improve the target side flow to reduce downtime
Date:   Tue, 24 Jan 2023 16:49:55 +0200
Message-ID: <20230124144955.139901-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230124144955.139901-1-yishaih@nvidia.com>
References: <20230124144955.139901-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|PH7PR12MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 6116b63e-f687-4946-27fb-08dafe1a626c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: njBZKroY8iaN+GAol5WLUrU4aoj6B0gZwSkP0WFcX04TV9iPYtZc4k15UkyOVhJWj/4qop9EUGAQFtlQNa5FwG+BNOlePK8mzAB/J81J44/cfHqeaoOogA4y2PN2j8QKQgH7lcb0SoUh8+/hwuSEbWxEMm4BmGYeB3ZrX8lU/HO1txlijnuWQnUYuR++h0QBC3nhZGeFIk8on4s30uCd6OterH+FWh1TyjPqUC+PschL7fc/tSUrcV0jrdmsBfJvZTvQXlT/iAKJOOVJhblLlu9SADP7czwqBEbgJHYph/ztei7QnqZUA93pZ0WJ374WnII8H1hXxPRlw3sU/SuP0+IPRJg548fc1E89sHwDvNTC9BLTDUyyRWwTjh1EZOG+erHGYZjYflgMz0XF1GqFLuW4PQTHwBymHX/vcLmu+6FuH3JzL/vBkfOBQsrVDxdaW5FZdxl4Mvrq5ttKG1I5T0OG2edfTyFPTtGZq656/S0p6LeZNgFQMaUoaa1IdRQdsI4g+Q3mV+xgmLew130yW1Xe+nKiWctTm53ZyPpySp6zv6eCHwZPk0iAiulWOuTjyAnTWnsIlXHqbz/CazLOXJXPfxvokFR7awG0poaZpdLTJAMQ4B5M/TOU/EAtxIYq9JsHzVBfL/kRhn2EDJmo1IPfoyZ1nyC75SlEf6KBfwk=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(36840700001)(46966006)(426003)(47076005)(336012)(1076003)(83380400001)(40480700001)(86362001)(36860700001)(82310400005)(7636003)(356005)(36756003)(82740400003)(2616005)(4326008)(8676002)(70206006)(5660300002)(2906002)(8936002)(41300700001)(6666004)(107886003)(70586007)(478600001)(186003)(26005)(6636002)(54906003)(7696005)(110136005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:50:49.8644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6116b63e-f687-4946-27fb-08dafe1a626c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6883
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve the target side flow to reduce downtime as of below.

- Support reading an optional record which includes the expected
  stop_copy size.
- Once the source sends this record data, which expects to be sent as
  part of the pre_copy flow, prepare the data buffers that may be large
  enough to hold the final stop_copy data.

The above reduces the migration downtime as the relevant stuff that is
needed to load the image data is prepared ahead as part of pre_copy.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.h  |   6 +-
 drivers/vfio/pci/mlx5/main.c | 111 +++++++++++++++++++++++++++++++----
 2 files changed, 105 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 8f1bef580028..aec4c69dd6c1 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -27,6 +27,8 @@ enum mlx5_vf_migf_state {
 enum mlx5_vf_load_state {
 	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
 	MLX5_VF_LOAD_STATE_READ_HEADER,
+	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
+	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
 	MLX5_VF_LOAD_STATE_PREP_IMAGE,
 	MLX5_VF_LOAD_STATE_READ_IMAGE,
 	MLX5_VF_LOAD_STATE_LOAD_IMAGE,
@@ -59,7 +61,6 @@ struct mlx5_vhca_data_buffer {
 	loff_t start_pos;
 	u64 length;
 	u64 allocated_length;
-	u64 header_image_size;
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
@@ -89,6 +90,9 @@ struct mlx5_vf_migration_file {
 	enum mlx5_vf_load_state load_state;
 	u32 pdn;
 	loff_t max_pos;
+	u64 record_size;
+	u32 record_tag;
+	u64 stop_copy_prep_size;
 	u64 pre_copy_initial_bytes;
 	struct mlx5_vhca_data_buffer *buf;
 	struct mlx5_vhca_data_buffer *buf_header;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 6856e7b97533..e897537a9e8a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -703,6 +703,56 @@ mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
 	return 0;
 }
 
+static int
+mlx5vf_resume_read_header_data(struct mlx5_vf_migration_file *migf,
+			       struct mlx5_vhca_data_buffer *vhca_buf,
+			       const char __user **buf, size_t *len,
+			       loff_t *pos, ssize_t *done)
+{
+	size_t copy_len, to_copy;
+	size_t required_data;
+	u8 *to_buff;
+	int ret;
+
+	required_data = migf->record_size - vhca_buf->length;
+	to_copy = min_t(size_t, *len, required_data);
+	copy_len = to_copy;
+	while (to_copy) {
+		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, &to_copy, pos,
+						    done);
+		if (ret)
+			return ret;
+	}
+
+	*len -= copy_len;
+	if (vhca_buf->length == migf->record_size) {
+		switch (migf->record_tag) {
+		case MLX5_MIGF_HEADER_TAG_STOP_COPY_SIZE:
+		{
+			struct page *page;
+
+			page = mlx5vf_get_migration_page(vhca_buf, 0);
+			if (!page)
+				return -EINVAL;
+			to_buff = kmap_local_page(page);
+			migf->stop_copy_prep_size = min_t(u64,
+				le64_to_cpup((__le64 *)to_buff), MAX_LOAD_SIZE);
+			kunmap_local(to_buff);
+			break;
+		}
+		default:
+			/* Optional tag */
+			break;
+		}
+
+		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
+		migf->max_pos += migf->record_size;
+		vhca_buf->length = 0;
+	}
+
+	return 0;
+}
+
 static int
 mlx5vf_resume_read_header(struct mlx5_vf_migration_file *migf,
 			  struct mlx5_vhca_data_buffer *vhca_buf,
@@ -733,23 +783,38 @@ mlx5vf_resume_read_header(struct mlx5_vf_migration_file *migf,
 	*len -= copy_len;
 	vhca_buf->length += copy_len;
 	if (vhca_buf->length == sizeof(struct mlx5_vf_migration_header)) {
-		u64 flags;
+		u64 record_size;
+		u32 flags;
 
-		vhca_buf->header_image_size = le64_to_cpup((__le64 *)to_buff);
-		if (vhca_buf->header_image_size > MAX_LOAD_SIZE) {
+		record_size = le64_to_cpup((__le64 *)to_buff);
+		if (record_size > MAX_LOAD_SIZE) {
 			ret = -ENOMEM;
 			goto end;
 		}
 
-		flags = le64_to_cpup((__le64 *)(to_buff +
+		migf->record_size = record_size;
+		flags = le32_to_cpup((__le32 *)(to_buff +
 			    offsetof(struct mlx5_vf_migration_header, flags)));
-		if (flags) {
-			ret = -EOPNOTSUPP;
-			goto end;
+		migf->record_tag = le32_to_cpup((__le32 *)(to_buff +
+			    offsetof(struct mlx5_vf_migration_header, tag)));
+		switch (migf->record_tag) {
+		case MLX5_MIGF_HEADER_TAG_FW_DATA:
+			migf->load_state = MLX5_VF_LOAD_STATE_PREP_IMAGE;
+			break;
+		case MLX5_MIGF_HEADER_TAG_STOP_COPY_SIZE:
+			migf->load_state = MLX5_VF_LOAD_STATE_PREP_HEADER_DATA;
+			break;
+		default:
+			if (!(flags & MLX5_MIGF_HEADER_FLAGS_TAG_OPTIONAL)) {
+				ret = -EOPNOTSUPP;
+				goto end;
+			}
+			/* We may read and skip this optional record data */
+			migf->load_state = MLX5_VF_LOAD_STATE_PREP_HEADER_DATA;
 		}
 
-		migf->load_state = MLX5_VF_LOAD_STATE_PREP_IMAGE;
 		migf->max_pos += vhca_buf->length;
+		vhca_buf->length = 0;
 		*has_work = true;
 	}
 end:
@@ -793,9 +858,34 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 			if (ret)
 				goto out_unlock;
 			break;
+		case MLX5_VF_LOAD_STATE_PREP_HEADER_DATA:
+			if (vhca_buf_header->allocated_length < migf->record_size) {
+				mlx5vf_free_data_buffer(vhca_buf_header);
+
+				migf->buf_header = mlx5vf_alloc_data_buffer(migf,
+						migf->record_size, DMA_NONE);
+				if (IS_ERR(migf->buf_header)) {
+					ret = PTR_ERR(migf->buf_header);
+					migf->buf_header = NULL;
+					goto out_unlock;
+				}
+
+				vhca_buf_header = migf->buf_header;
+			}
+
+			vhca_buf_header->start_pos = migf->max_pos;
+			migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER_DATA;
+			break;
+		case MLX5_VF_LOAD_STATE_READ_HEADER_DATA:
+			ret = mlx5vf_resume_read_header_data(migf, vhca_buf_header,
+							&buf, &len, pos, &done);
+			if (ret)
+				goto out_unlock;
+			break;
 		case MLX5_VF_LOAD_STATE_PREP_IMAGE:
 		{
-			u64 size = vhca_buf_header->header_image_size;
+			u64 size = max(migf->record_size,
+				       migf->stop_copy_prep_size);
 
 			if (vhca_buf->allocated_length < size) {
 				mlx5vf_free_data_buffer(vhca_buf);
@@ -824,7 +914,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 			break;
 		case MLX5_VF_LOAD_STATE_READ_IMAGE:
 			ret = mlx5vf_resume_read_image(migf, vhca_buf,
-						vhca_buf_header->header_image_size,
+						migf->record_size,
 						&buf, &len, pos, &done, &has_work);
 			if (ret)
 				goto out_unlock;
@@ -837,7 +927,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 
 			/* prep header buf for next image */
 			vhca_buf_header->length = 0;
-			vhca_buf_header->header_image_size = 0;
 			/* prep data buf for next image */
 			vhca_buf->length = 0;
 
-- 
2.18.1

