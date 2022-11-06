Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8684761E503
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiKFRr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKFRrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6536441
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iO1cqfEPvT4OVmbQuFvdxmx15ZvUmlKEEVGdTVAHkrL7a0HtwsDGY8ozMXtkZqUDO3iFfaNJb9ZCCU+PR0bZdhFYkdiP3ytCu+rcbHG2nmiwfi7n9BiUqEPtJg+CaaoNhLm1US81QDTJA3mzOMTEcq3JHtn7yLP0hXnhWZX6FJOYQXGb5TruWLbcyC3plx+pqxP0TvvoCU9kqGwwaAuAKFF0vZyicRL4oDIOgzqNUIjmB7HgUKwc9Tihqtx8zJV8eJ+S3U1WI+8qwNyHXHTIkZkPsgZSPXqOz88Mseo5Srd5B8xqtwCHe4xPYs2Y1O/ktyLbHeN3uyUIFKlbEWzOsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wn+CAXVEh+49LP4O9QRcHF/PKj2/uSGJRMg/oed3FYI=;
 b=VOoJDlXAkK6D17g56DPc4yn2iSNsyWowZMNyzNnUgkNFvWJ0pp4hOPub1BRjkED/euwEGttnOnQFBt9v5LEoRO+fv9c0Q7KYCbgonIT1NGm4kCaIuC48nRt9frgU2oGc2vL9RhUdgDEdVhoh8Xg9pXzFgVXKSxqtj9lnoTHahN4Cp9pyfTaxBgUq3yahFliQRnttproJrFZpFSj61neMrjhbFIpHsZjeUuyeLaI9pkLmBAiUxzERtym10uXWqrjQ2CSk8wUhZbSbxHKyazp/MotK+DzD+mUlRQxLLmKXXGLcZzsYNfrIB3AJm1kvHg3iiIFye95V57Xa5iwwhbXzBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn+CAXVEh+49LP4O9QRcHF/PKj2/uSGJRMg/oed3FYI=;
 b=jrvdgFf2wNiJCs7fhJSfRLDaiNMO8PXi+ER6CoVKeujAOmgS5VsdOPRtO45PwPnoU66RtNqx6h9C/LZF5S7mm6cRe/pFqeK36vA3E9CkNh+MwDr+YTn3A3wkWfIS9FZAG9lWt1KdLRaLA8nROnF4cZPRn3+R/IR9WhBXY1dat4w/4/PRV/J/viHjUBNXrfU6K5gGOQD75r+5jDorUZkA7gdEWFT1W+rLtMYyUfmTUhkhsgUaWhHUjO9Bo2+EAphvPmfZrSUAcWNsia+lRoXBbwB0wIS97i9PWQcMzYWvfYlk77AAF2DLCCdjw9trogVUOjVaexEY7zeNgioTDNCkMA==
Received: from BN0PR03CA0007.namprd03.prod.outlook.com (2603:10b6:408:e6::12)
 by DS7PR12MB5816.namprd12.prod.outlook.com (2603:10b6:8:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:20 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::79) by BN0PR03CA0007.outlook.office365.com
 (2603:10b6:408:e6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:19 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:16 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 04/13] vfio: Extend the device migration protocol with PRE_COPY
Date:   Sun, 6 Nov 2022 19:46:21 +0200
Message-ID: <20221106174630.25909-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT057:EE_|DS7PR12MB5816:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d114f7b-5a6a-4173-567e-08dac01ef41b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnsZKAZ6Q8Mn7nNh5/0taEoeSQUPQNQu4UqBaqGSzl/euhK0gXPKgPN/DVZznmTrOQ0igZLL9jC4xeBqFx47bnbTCQjlU33D8Z/T9rqYP8/6bb6/DGxgAVo2tU5KyVrinrVKOPJlcLqm66TpYadS6P168aFl41F8bL3vidsuEZVmB+8OJJLulqdShcSkbRzefQugCbwYO49IkK4nP4rgFZWjWzAIKeq4Og4fCBoC8iZmCYq5xdhbp1tBaY9SEU8PjIw5N4520H8vsWAh46Q5vqiHVKFWfGOFgDTpL10jCWRXaCTO7nW7U2zTh2MbxIrjH6c+1GQWXXZynxROMDjG617PxSfmySETGcF0u0q/FG3UXeanrp5NQTcIGAQuyD2poOgyQjs6iI+fjCLGjMbu/a28dATa39Ru0AX6QgGy/2s9ditPekKBTGj88TiXf7Vxkf/dtp9s+1N9Xm17jQQRujBvz7XI+/pMTf36Qwp3TiIB9fuIT3dqerWpWCE+5UlAOS3B+U4Jg6dmctjIMwe9JTUsY6USr1iCwtUNQHmZoXDgGHUumwPHChQqklzVByG/XnuwGui17gEe7kgWoAQvp7O23RHKlommx/ieNhlesPV08+0g74qh7g+JX7MTtZ5ctR5tZynQutR5zUAYsW8QRWGdzRrqYJB7+nBcYyeJL0jMQiWaxJvFYHWcfcKep8zZJNKOwlt8knEsO7j6YbXketg+3fc04+T0yZZWADp948BCe2yvi7WS+H5VKAeGy7UYIYyz4UxtU27H2wIS2WCPKg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(478600001)(30864003)(8936002)(5660300002)(36756003)(2906002)(316002)(6636002)(54906003)(110136005)(41300700001)(70586007)(70206006)(8676002)(4326008)(7636003)(83380400001)(356005)(36860700001)(82740400003)(7696005)(6666004)(86362001)(186003)(40460700003)(336012)(47076005)(426003)(1076003)(26005)(2616005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:20.0987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d114f7b-5a6a-4173-567e-08dac01ef41b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5816
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The optional PRE_COPY states open the saving data transfer FD before
reaching STOP_COPY and allows the device to dirty track internal state
changes with the general idea to reduce the volume of data transferred
in the STOP_COPY stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

Only if the device also supports RUNNING_P2P can it support PRE_COPY_P2P,
which halts P2P transfers while continuing the saving FD.

PRE_COPY, with P2P support, requires the driver to implement 7 new arcs
and exists as an optional FSM branch between RUNNING and STOP_COPY:
    RUNNING -> PRE_COPY -> PRE_COPY_P2P -> STOP_COPY

A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to
query the progress of the precopy operation in the driver with the idea it
will judge to move to STOP_COPY at least once the initial data set is
transferred, and possibly after the dirty size has shrunk appropriately.

This ioctl is valid only in PRE_COPY states and kernel driver should
return -EINVAL from any other migration state.

Compared to the v1 clarification, STOP_COPY -> PRE_COPY is blocked
and to be defined in future.
We also split the pending_bytes report into the initial and sustaining
values, e.g.: initial_bytes and dirty_bytes.
initial_bytes: Amount of initial mandatory precopy data.
dirty_bytes: device state changes relative to data previously retrieved.
These fields are not required to have any bearing to STOP_COPY phase.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio_main.c  |  74 ++++++++++++++++++++++-
 include/uapi/linux/vfio.h | 122 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 190 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index b118e7b1bc59..c58a795510f9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1056,7 +1056,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm)
 {
-	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_PRE_COPY_P2P + 1 };
 	/*
 	 * The coding in this table requires the driver to implement the
 	 * following FSM arcs:
@@ -1071,30 +1071,65 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 	 *         RUNNING_P2P -> RUNNING
 	 *         RUNNING_P2P -> STOP
 	 *         STOP -> RUNNING_P2P
-	 * Without P2P the driver must implement:
+	 *
+	 * If precopy is supported then the driver must support these additional
+	 * FSM arcs:
+	 *         RUNNING -> PRE_COPY
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> STOP_COPY
+	 * However, if precopy and P2P are supported together then the driver
+	 * must support these additional arcs beyond the P2P arcs above:
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> PRE_COPY_P2P
+	 *         PRE_COPY_P2P -> PRE_COPY
+	 *         PRE_COPY_P2P -> RUNNING_P2P
+	 *         PRE_COPY_P2P -> STOP_COPY
+	 *         RUNNING -> PRE_COPY
+	 *         RUNNING_P2P -> PRE_COPY_P2P
+	 *
+	 * Without P2P and precopy the driver must implement:
 	 *         RUNNING -> STOP
 	 *         STOP -> RUNNING
 	 *
 	 * The coding will step through multiple states for some combination
 	 * transitions; if all optional features are supported, this means the
 	 * following ones:
+	 *         PRE_COPY -> PRE_COPY_P2P -> STOP_COPY
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP -> RESUMING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> RUNNING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RESUMING -> STOP -> RUNNING_P2P
+	 *         RESUMING -> STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
+	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RESUMING -> STOP -> STOP_COPY
+	 *         RUNNING -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RUNNING -> RUNNING_P2P -> STOP
 	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
+	 *         RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING_P2P -> STOP -> STOP_COPY
+	 *         STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         STOP -> RUNNING_P2P -> RUNNING
+	 *         STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         STOP_COPY -> STOP -> RESUMING
 	 *         STOP_COPY -> STOP -> RUNNING_P2P
 	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
+	 *
+	 *  The following transitions are blocked:
+	 *         STOP_COPY -> PRE_COPY
+	 *         STOP_COPY -> PRE_COPY_P2P
 	 */
 	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1103,14 +1138,38 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
+		[VFIO_DEVICE_STATE_PRE_COPY] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
 		[VFIO_DEVICE_STATE_STOP_COPY] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1119,6 +1178,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RESUMING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1127,6 +1188,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1135,6 +1198,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_ERROR] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
@@ -1145,6 +1210,11 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 	static const unsigned int state_flags_table[VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY] =
+			VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_MIGRATION_STOP_COPY |
+						   VFIO_MIGRATION_P2P |
+						   VFIO_MIGRATION_PRE_COPY,
 		[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RESUMING] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] =
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 3e45dbaf190e..fca8e1b7e619 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -819,12 +819,20 @@ struct vfio_device_feature {
  * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
  * is supported in addition to the STOP_COPY states.
  *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY means that
+ * PRE_COPY is supported in addition to the STOP_COPY states.
+ *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY
+ * means that RUNNING_P2P, PRE_COPY and PRE_COPY_P2P are supported
+ * in addition to the STOP_COPY states.
+ *
  * Other combinations of flags have behavior to be defined in the future.
  */
 struct vfio_device_feature_migration {
 	__aligned_u64 flags;
 #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
 #define VFIO_MIGRATION_P2P		(1 << 1)
+#define VFIO_MIGRATION_PRE_COPY		(1 << 2)
 };
 #define VFIO_DEVICE_FEATURE_MIGRATION 1
 
@@ -875,8 +883,13 @@ struct vfio_device_feature_mig_state {
  *  RESUMING - The device is stopped and is loading a new internal state
  *  ERROR - The device has failed and must be reset
  *
- * And 1 optional state to support VFIO_MIGRATION_P2P:
+ * And optional states to support VFIO_MIGRATION_P2P:
  *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
+ * And VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY - The device is running normally but tracking internal state
+ *             changes
+ * And VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY_P2P - PRE_COPY, except the device cannot do peer to peer DMA
  *
  * The FSM takes actions on the arcs between FSM states. The driver implements
  * the following behavior for the FSM arcs:
@@ -908,20 +921,48 @@ struct vfio_device_feature_mig_state {
  *
  *   To abort a RESUMING session the device must be reset.
  *
+ * PRE_COPY -> RUNNING
  * RUNNING_P2P -> RUNNING
  *   While in RUNNING the device is fully operational, the device may generate
  *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
  *   and the device may advance its internal state.
  *
+ *   The PRE_COPY arc will terminate a data transfer session.
+ *
+ * PRE_COPY_P2P -> RUNNING_P2P
  * RUNNING -> RUNNING_P2P
  * STOP -> RUNNING_P2P
  *   While in RUNNING_P2P the device is partially running in the P2P quiescent
  *   state defined below.
  *
+ *   The PRE_COPY_P2P arc will terminate a data transfer session.
+ *
+ * RUNNING -> PRE_COPY
+ * RUNNING_P2P -> PRE_COPY_P2P
  * STOP -> STOP_COPY
- *   This arc begin the process of saving the device state and will return a
- *   new data_fd.
+ *   PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of states
+ *   which share a data transfer session. Moving between these states alters
+ *   what is streamed in session, but does not terminate or otherwise affect
+ *   the associated fd.
+ *
+ *   These arcs begin the process of saving the device state and will return a
+ *   new data_fd. The migration driver may perform actions such as enabling
+ *   dirty logging of device state when entering PRE_COPY or PER_COPY_P2P.
  *
+ *   Each arc does not change the device operation, the device remains
+ *   RUNNING, P2P quiesced or in STOP. The STOP_COPY state is described below
+ *   in PRE_COPY_P2P -> STOP_COPY.
+ *
+ * PRE_COPY -> PRE_COPY_P2P
+ *   Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
+ *   However, while in the PRE_COPY_P2P state, the device is partially running
+ *   in the P2P quiescent state defined below, like RUNNING_P2P.
+ *
+ * PRE_COPY_P2P -> PRE_COPY
+ *   This arc allows returning the device to a full RUNNING behavior while
+ *   continuing all the behaviors of PRE_COPY.
+ *
+ * PRE_COPY_P2P -> STOP_COPY
  *   While in the STOP_COPY state the device has the same behavior as STOP
  *   with the addition that the data transfers session continues to stream the
  *   migration state. End of stream on the FD indicates the entire device
@@ -939,6 +980,13 @@ struct vfio_device_feature_mig_state {
  *   device state for this arc if required to prepare the device to receive the
  *   migration data.
  *
+ * STOP_COPY -> PRE_COPY
+ * STOP_COPY -> PRE_COPY_P2P
+ *   These arcs are not permitted and return error if requested. Future
+ *   revisions of this API may define behaviors for these arcs, in this case
+ *   support will be discoverable by a new flag in
+ *   VFIO_DEVICE_FEATURE_MIGRATION.
+ *
  * any -> ERROR
  *   ERROR cannot be specified as a device state, however any transition request
  *   can be failed with an errno return and may then move the device_state into
@@ -950,7 +998,7 @@ struct vfio_device_feature_mig_state {
  * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
  * state for the device for the purposes of managing multiple devices within a
  * user context where peer-to-peer DMA between devices may be active. The
- * RUNNING_P2P states must prevent the device from initiating
+ * RUNNING_P2P and PRE_COPY_P2P states must prevent the device from initiating
  * any new P2P DMA transactions. If the device can identify P2P transactions
  * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
  * driver must complete any such outstanding operations prior to completing the
@@ -963,6 +1011,8 @@ struct vfio_device_feature_mig_state {
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
  *   - Select the shortest path.
+ *   - The path cannot have saving group states as interior arcs, only
+ *     starting/end states.
  * Refer to vfio_mig_get_next_state() for the result of the algorithm.
  *
  * The automatic transit through the FSM arcs that make up the combination
@@ -976,6 +1026,9 @@ struct vfio_device_feature_mig_state {
  * support them. The user can discover if these states are supported by using
  * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
  * avoid knowing about these optional states if the kernel driver supports them.
+ *
+ * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for PRE_COPY
+ * is not present.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -984,8 +1037,69 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
+	VFIO_DEVICE_STATE_PRE_COPY = 6,
+	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
+};
+
+/**
+ * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
+ *
+ * This ioctl is used on the migration data FD in the precopy phase of the
+ * migration data transfer. It returns an estimate of the current data sizes
+ * remaining to be transferred. It allows the user to judge when it is
+ * appropriate to leave PRE_COPY for STOP_COPY.
+ *
+ * This ioctl is valid only in PRE_COPY states and kernel driver should
+ * return -EINVAL from any other migration state.
+ *
+ * The vfio_precopy_info data structure returned by this ioctl provides
+ * estimates of data available from the device during the PRE_COPY states.
+ * This estimate is split into two categories, initial_bytes and
+ * dirty_bytes.
+ *
+ * The initial_bytes field indicates the amount of initial mandatory precopy
+ * data available from the device. This field should have a non-zero initial
+ * value and decrease as migration data is read from the device.
+ * It is a must to leave PRE_COPY for STOP_COPY only after this field reach
+ * zero.
+ *
+ * The dirty_bytes field tracks device state changes relative to data
+ * previously retrieved.  This field starts at zero and may increase as
+ * the internal device state is modified or decrease as that modified
+ * state is read from the device.
+ *
+ * Userspace may use the combination of these fields to estimate the
+ * potential data size available during the PRE_COPY phases, as well as
+ * trends relative to the rate the device is dirtying its internal
+ * state, but these fields are not required to have any bearing relative
+ * to the data size available during the STOP_COPY phase.
+ *
+ * Drivers have a lot of flexibility in when and what they transfer during the
+ * PRE_COPY phase, and how they report this from VFIO_MIG_GET_PRECOPY_INFO.
+ *
+ * During pre-copy the migration data FD has a temporary "end of stream" that is
+ * reached when both initial_bytes and dirty_byte are zero. For instance, this
+ * may indicate that the device is idle and not currently dirtying any internal
+ * state. When read() is done on this temporary end of stream the kernel driver
+ * should return ENOMSG from read(). Userspace can wait for more data (which may
+ * never come) by using poll.
+ *
+ * Once in STOP_COPY the migration data FD has a permanent end of stream
+ * signaled in the usual way by read() always returning 0 and poll always
+ * returning readable. ENOMSG may not be returned in STOP_COPY. Support
+ * for this ioctl is optional.
+ *
+ * Return: 0 on success, -1 and errno set on failure.
+ */
+struct vfio_precopy_info {
+	__u32 argsz;
+	__u32 flags;
+	__aligned_u64 initial_bytes;
+	__aligned_u64 dirty_bytes;
 };
 
+#define VFIO_MIG_GET_PRECOPY_INFO _IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /*
  * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
  * state with the platform-based power management.  Device use of lower power
-- 
2.18.1

