Return-Path: <kvm+bounces-11388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D979D876AAE
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 19:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08C6C1C218A1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F2F59B44;
	Fri,  8 Mar 2024 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zuCx6Gfa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311AF58120;
	Fri,  8 Mar 2024 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709922140; cv=fail; b=m8n58JOB+9aSB0xJtljg8mcRJNGY6AooktjHaU/65UCpRgYNYrWq2gkwEa2m3/oRc9MxGZnhKZ7YJNvWNrVpbvgprftq4rcugStPda44tumn5OCTTnKcTPoaw1Paf0wyKqauvC/3raBe0NywBPo5kTIEdW+8RFhdDqoT3ExlBkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709922140; c=relaxed/simple;
	bh=YaHSQ5YQ/ARi8ioXwd9LdYCTYHiZVuOb/4lozHrmK4g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+NtguepK6aLTwL+8RA7WfrYzOZlyDkuSYY2hyW9UQEQeU3utkY+B3ZrsymppZkGloqCMWS1JX5A6sSvGbRVmzTRZ5ymPRmSvoF6s2DHAND76yjrwOSJf7gYa+XRQsOwzH5Qa5Crm0HfdBb+Uw4XNTgMOo7bArEIHxOEzT+rLAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zuCx6Gfa; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpfRwKdo0wfWlqk5OabAUIaHkEd1HyVyr8F4FoqbAuoXC9QzUs7klZlWih34PZdRpftDHBvonYMc1gF/Jn3sxa/V/OKMs3yTYK9JJRf2t5guGZyKjv2QDxaYx/jSeauxVvwowB+cJYBX59kG2TeBbHkInkaevAx7tPbv/GVGVU4HnwtozAmioQuwm0kg591bh+wpFuO8wxuFAahniUzIuRfLpjJNb0Xs+zKxr1FaArcaKT1k9/5N74kT9jqWdY+XkSAJjBntpA8KtkwbyEi2198aTsXpP+Ot9BEkKEWMoE9VWZREhrKNelsK+bw38I/Ta1Er1XsvFVIlHNmS/Pclnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKrDMsGDHkbHgb6uAR4rm4VrJc+EGJoYo5L5s8TSXsA=;
 b=nvG7TaZJ5T2zNcM1VsLBCUJ99RTsIQDkazmuTHjqfRsSP0drNIo23MlU5Z9KB6/9zo0RJqhXv1EgKLxFZx82lITZwPc/pNbAlntbVXtOQBYt7px1lN5KxkVpaxvvwlPE2f6pHaI04T27G1sHI+qdo4mB0+2uFxCwDq+JIyUwQnsxMOYZTmCSrMP+auxJDE82rgJnxajhd0XMgCiiglS9ieTNK5FXuhVv5CvEj3rWB19CqyOHkrrApxOCWLpUnhYLLnxiJAdgQYGH6sYLw2Zxx/YvFfaapngDuFdXSW4ldwauHHH+UYRKDrNJRda35YSd5Mo7y8baqOLHl0jDlmVqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKrDMsGDHkbHgb6uAR4rm4VrJc+EGJoYo5L5s8TSXsA=;
 b=zuCx6GfazAmwDRg1gHzplFG7zaxKxFymsAtxreZuMYvHKs8lGRXuoZU7s4+D/PEz4yUizsgC18Euz9KLVUHZK5yYZ2cCS8LYp+OX885Jqx2tDzYwrzKgcAqqZrROpTxrMdKfc0yiUpMDa0p09MYeTRV1EH3MEW5kpssQ8Z6wu78=
Received: from DS7PR06CA0001.namprd06.prod.outlook.com (2603:10b6:8:2a::12) by
 MN6PR12MB8515.namprd12.prod.outlook.com (2603:10b6:208:470::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Fri, 8 Mar
 2024 18:22:16 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:8:2a:cafe::7c) by DS7PR06CA0001.outlook.office365.com
 (2603:10b6:8:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27 via Frontend
 Transport; Fri, 8 Mar 2024 18:22:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7362.11 via Frontend Transport; Fri, 8 Mar 2024 18:22:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 8 Mar
 2024 12:22:14 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 1/2] vfio/pds: Make sure migration file isn't accessed after reset
Date: Fri, 8 Mar 2024 10:21:48 -0800
Message-ID: <20240308182149.22036-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240308182149.22036-1-brett.creeley@amd.com>
References: <20240308182149.22036-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|MN6PR12MB8515:EE_
X-MS-Office365-Filtering-Correlation-Id: dae053d7-9a53-4817-f8f1-08dc3f9caee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hhiQndMXMLy8UzPlXT6tifjfoC2c7Ac6DZCxXtPEP2hPszgYpQ3CeV3CA9sS+S5BC+9uzEdPLpCGq0Jr+80RjbS7SFAmf7b2Hw5hsuBU3g//ujzPNvhejYEj7iKIRltUZJkW9g5bd6TkQ3P+jHFXqz/jaYS5hAWivs9LN7Rpr1JAyut8p+OGNxikKetleMpwf8SRPEFIECa10GJdnrqp63JW6yCycyOx0RA2g/QZ4xOARf6QzZygbre1F63xfvloqIGPpChSrrlNq5XYhGNyYSmxOq3Ge9EXShpGRwtmwBtHqcEZsNyGRWNx/i5DzSJG+1ky7MqluZLEOqnwVS8GUhorRRNU/XFuHVxpu21+aIvF90iNrJEZYi4vw26HNFHDHWZbVtEwWV7/o0uqMKJhUH9ybr0LYORKKdRiXdud5J8Yr3He8p9cqy8waFO7T1BHmUl6TeihMgUbNYcXvkLO3aYL/5/Se/L+9m0jrQx59Nw0EQb6/S+xZV+Eoa5XCl5PDgOrxfJ8FYo+u9G/CjqXE13btptpDsCC9zaPSkIYmlGElcmI3br6t611M1wyghws1nQy6bWjoihxMiyYVR16zDt7xJymU8G1CbcNJLIQ0LWdQJ9X/rz8O80dmjwdOzbn1BI4ee1drJ9J3DR3nSJ6+PPONQtQhEYDHCf4vzthx3qoScTUExwRo0EC8MmqgRGnOEvaDvs2Rv4U/dwnLiWM6QzJsG3TRC/jS9Roey29I/jdCMs63InniJvdBhr06sry
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 18:22:16.0101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dae053d7-9a53-4817-f8f1-08dc3f9caee0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8515

It's possible the migration file is accessed after reset when it has
been cleaned up, especially when it's initiated by the device. This is
because the driver doesn't rip out the filep when cleaning up it only
frees the related page structures and sets its local struct
pds_vfio_lm_file pointer to NULL. This can cause a NULL pointer
dereference, which is shown in the example below during a restore after
a device initiated reset:

BUG: kernel NULL pointer dereference, address: 000000000000000c
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:pds_vfio_get_file_page+0x5d/0xf0 [pds_vfio_pci]
[...]
Call Trace:
 <TASK>
 pds_vfio_restore_write+0xf6/0x160 [pds_vfio_pci]
 vfs_write+0xc9/0x3f0
 ? __fget_light+0xc9/0x110
 ksys_write+0xb5/0xf0
 __x64_sys_write+0x1a/0x20
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...]

Add a disabled flag to the driver's struct pds_vfio_lm_file that gets
set during cleanup. Then make sure to check the flag when the migration
file is accessed via its file_operations. By default this flag will be
false as the memory for struct pds_vfio_lm_file is kzalloc'd, which means
the struct pds_vfio_lm_file is enabled and accessible. Also, since the
file_operations and driver's migration file cleanup happen under the
protection of the same pds_vfio_lm_file.lock, using this flag is thread
safe.

Fixes: 8512ed256334 ("vfio/pds: Always clear the save/restore FDs on reset")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/pds/lm.c | 13 +++++++++++++
 drivers/vfio/pci/pds/lm.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index 79fe2e66bb49..6b94cc0bf45b 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -92,8 +92,10 @@ static void pds_vfio_put_lm_file(struct pds_vfio_lm_file *lm_file)
 {
 	mutex_lock(&lm_file->lock);
 
+	lm_file->disabled = true;
 	lm_file->size = 0;
 	lm_file->alloc_size = 0;
+	lm_file->filep->f_pos = 0;
 
 	/* Free scatter list of file pages */
 	sg_free_table(&lm_file->sg_table);
@@ -183,6 +185,12 @@ static ssize_t pds_vfio_save_read(struct file *filp, char __user *buf,
 	pos = &filp->f_pos;
 
 	mutex_lock(&lm_file->lock);
+
+	if (lm_file->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (*pos > lm_file->size) {
 		done = -EINVAL;
 		goto out_unlock;
@@ -283,6 +291,11 @@ static ssize_t pds_vfio_restore_write(struct file *filp, const char __user *buf,
 
 	mutex_lock(&lm_file->lock);
 
+	if (lm_file->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
 	while (len) {
 		size_t page_offset;
 		struct page *page;
diff --git a/drivers/vfio/pci/pds/lm.h b/drivers/vfio/pci/pds/lm.h
index 13be893198b7..9511b1afc6a1 100644
--- a/drivers/vfio/pci/pds/lm.h
+++ b/drivers/vfio/pci/pds/lm.h
@@ -27,6 +27,7 @@ struct pds_vfio_lm_file {
 	struct scatterlist *last_offset_sg;	/* Iterator */
 	unsigned int sg_last_entry;
 	unsigned long last_offset;
+	bool disabled;
 };
 
 struct pds_vfio_pci_device;
-- 
2.17.1


