Return-Path: <kvm+bounces-14039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB7E89E5E7
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25F452824A3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B45158DB1;
	Tue,  9 Apr 2024 23:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="akWmIXDK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4C5156C6D
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704156; cv=fail; b=m0UFs6pYHd1ZQkPp5q7YJIq9KKGArU9hGLuZsSoU+7zsE4aO6zk4B00+sYozJazdtaUxYoQvo2nWtiN3gAxXia5mPuGo6APl9blp7HptZYZheA8kETjKMQIcSo0Hxhq5QZcKMaTTyhB4o2hE6B65rY8kY6R8tfNdod34k1euAlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704156; c=relaxed/simple;
	bh=9YVkf1MxtzIzxOT78UrItSf9FRL1PdOzJOYSiexEvrE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpNkeiAad9TO3HgZN0SxiUsnxk6BPQv8QawpcLmwuqc4hqKNbyKq5iu4amRb1LULXTWkMmCT7eK06ajN1fJSc5fz4X2gPPDA3mW7BaJU/DMSqyxlHMbbVHFVIEBS85e4L/Veprl3DgeUFnlc7j2hZpfIHR2PrpZjg8n5p8I14M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=akWmIXDK; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIgmliFierrXCk/3rYnRtwyVsBLBOC+2KvOHQkWqFpim2J1jn32hMC9w+bi+a0jKmSNLZGPy+Qm456hj27zGAcdpKgdT78iUT/b9R/B9agz+viz4fODGJAPsPHUNaAugwEgfS53HvjxnsiVyre6HUnchgmePcxKPGtajcg/XSbk7ckpdJOr6NKNz1DhxcbK4wiXxgefXdfrmFYJrUKtWUQORtldH6IiDBeIzuUqNXnPorD+s9PBqV6IE6GWxievADHomRCyPvDvB5tIcCHJs0mJDrdhfSsvq+zQe2IPu9ARvXQ8tq4HFggLE/MfmSXv+FOcaroOffyREIjSuhHNcuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ty2IOTc9gTBaJQ7l7S7OWQpXxYtZfDrbKLLcPhLIR9E=;
 b=V0p6c3bwkD+UY6JJAwjuM3PL59U/HNJNb3x8+XGRTL/SreOvCylpt//sQTIlgrQVwhv7B+EtEzs0fUNI7XDdu/9subMUq/SAuC/OZDBXPmOUWck4nZtkLUZsabd+8ZeSKEb/MsEXc3xZzhfBh6s3d2xKCSoZqXTW2+e0ZLyDcxSXbF947JBH05OgYeCrw1uccQdNC9XM/FEweAEFQo3ci24QzYA4acqP/iR8irP5/Ltp/hZ6RTVM/pQ1Fybug188MYfpCiHDW1CVjh+lZUmrPiszONNhzP8T7vBpo2VTmLEpUJ9WQETvDifkik6xevL9+9mixV5+mEMPlbUxhQ3gOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty2IOTc9gTBaJQ7l7S7OWQpXxYtZfDrbKLLcPhLIR9E=;
 b=akWmIXDKB4iGeRmfsUTia/N0GXivqVQzBAM2iShjQn5SqEiGOxAl3sEne66NX8/fJMt1gKupMENOEYy75+iRVS0SwjkaNIGjxsL1kbST5XfWNEDjw6o/gHAXFRl1DUd5ERXCOeeA/hEYuLIQX4NkrOxvh18XCGSWUOkzDMxhe/Y=
Received: from BY5PR04CA0017.namprd04.prod.outlook.com (2603:10b6:a03:1d0::27)
 by MN2PR12MB4126.namprd12.prod.outlook.com (2603:10b6:208:199::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 23:09:11 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::48) by BY5PR04CA0017.outlook.office365.com
 (2603:10b6:a03:1d0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.36 via Frontend
 Transport; Tue, 9 Apr 2024 23:09:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 9 Apr 2024 23:09:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 9 Apr
 2024 18:09:09 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Larry Dewey
	<Larry.Dewey@amd.com>, Roy Hopkins <roy.hopkins@suse.com>
Subject: [PATCH v1 3/3] hw/i386/sev: Use legacy SEV VM types for older machine types
Date: Tue, 9 Apr 2024 18:07:43 -0500
Message-ID: <20240409230743.962513-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240409230743.962513-1-michael.roth@amd.com>
References: <20240409230743.962513-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|MN2PR12MB4126:EE_
X-MS-Office365-Filtering-Correlation-Id: db23a42b-9102-435f-b690-08dc58ea10bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pCasw7mFDxCdsRUopNe8I/j6uQtshA832J7THi2sWAHTmc4Sbqc/U4lX78/5CTrvLzsIfrgLCeCuuidpYJ6xwyhzgpgccwUuIJvTVIpwnFLHrFmudSFhwKMGZ/3pYUwd854/CvAAqLXTL96PSD/AFfLmIjSzaWS7yhAspupAYN1zmcN9RWClfVFEztkpRIZsBgkpvyD4MGjUf/ihzjR0eP1XPfx7GQd4dYp7dLsugMll7M8EJPXTvY/JUl/a6I0ATAEABLUl85oPRAIha3U5nsDbbln4ZPP3pgrGw7w2n7eYloSlPEMiUeVk4CHZDp7PZ6hx4D5QqEqXEXfckvZEOdCgMl+93YHzHqYmUpjE90P/yLGdF1ugChRa2OZwOuco3d50VpczoPAnSbpKv/GOzYGxwfmRIDovfTNADH4omIMeqWRRBDc+fCry6b9TEyCW3ELJZgHCPnnA0MyGJefQpiUpcBaxtPvIXK+at/rXlLz8WaRmOsvYvltT8MzoW0mQQelyncN9+aUrJCDhD6tuSU8e0nYXUWY/NzsdI/gCDymiZldkWjrdivEACtDGOG2mwyjvUVJoE40l+aAup0Pctauq/jpCpfuqPrJblb10DnWyxakp4dTKtGaVg11qGD6hLZfQ4yJgQHerKzZ1u8TL3Vj77KYyHYJpRaeOmJCy/SIOVmPJaxw8N/IeLfA/Y7hZcWI7l86YCf0iQMPvHjBiCQXAS8eCxi6px8o6IqefnX5ddz46446cnd55uoW2zz4X
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:09:10.5265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db23a42b-9102-435f-b690-08dc58ea10bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4126

Newer 9.1 machine types will default to using the KVM_SEV_INIT2 API for
creating SEV/SEV-ES going forward. However, this API results in guest
measurement changes which are generally not expected for users of these
older guest types and can cause disruption if they switch to a newer
QEMU/kernel version. Avoid this by continuing to use the older
KVM_SEV_INIT/KVM_SEV_ES_INIT APIs for older machine types.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/i386/pc.c         | 5 +++++
 hw/i386/pc_piix.c    | 1 +
 hw/i386/pc_q35.c     | 1 +
 include/hw/i386/pc.h | 3 +++
 target/i386/sev.c    | 1 +
 5 files changed, 11 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index e80f02bef4..96bf90c17e 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -78,6 +78,11 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
 
+GlobalProperty pc_compat_9_0[] = {
+    { "sev-guest", "legacy-vm-type", "true" },
+};
+const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
+
 GlobalProperty pc_compat_8_2[] = {};
 const size_t pc_compat_8_2_len = G_N_ELEMENTS(pc_compat_8_2);
 
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 069414a1ac..0b7a9debab 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -528,6 +528,7 @@ static void pc_i440fx_9_0_machine_options(MachineClass *m)
     pc_i440fx_machine_options(m);
     m->alias = NULL;
     m->is_default = false;
+    compat_props_add(m->compat_props, pc_compat_9_0, pc_compat_9_0_len);
 }
 
 DEFINE_I440FX_MACHINE(v9_0, "pc-i440fx-9.0", NULL,
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 77d7f700a8..acb55fc787 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -380,6 +380,7 @@ static void pc_q35_9_0_machine_options(MachineClass *m)
 {
     pc_q35_machine_options(m);
     m->alias = NULL;
+    compat_props_add(m->compat_props, pc_compat_9_0, pc_compat_9_0_len);
 }
 
 DEFINE_Q35_MACHINE(v9_0, "pc-q35-9.0", NULL,
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index fb1d4106e5..e52290916c 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -199,6 +199,9 @@ void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size);
 /* sgx.c */
 void pc_machine_init_sgx_epc(PCMachineState *pcms);
 
+extern GlobalProperty pc_compat_9_0[];
+extern const size_t pc_compat_9_0_len;
+
 extern GlobalProperty pc_compat_8_2[];
 extern const size_t pc_compat_8_2_len;
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index f4ee317cb0..d30b68c11e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1417,6 +1417,7 @@ sev_guest_instance_init(Object *obj)
     object_property_add_uint32_ptr(obj, "reduced-phys-bits",
                                    &sev->reduced_phys_bits,
                                    OBJ_PROP_FLAG_READWRITE);
+    object_apply_compat_props(obj);
 }
 
 /* sev guest info */
-- 
2.25.1


