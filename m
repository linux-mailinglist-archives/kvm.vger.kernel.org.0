Return-Path: <kvm+bounces-7051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6306183D37F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAA02B24359
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD988BE5B;
	Fri, 26 Jan 2024 04:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UnTD0ec+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7406A6AD6;
	Fri, 26 Jan 2024 04:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244032; cv=fail; b=c3XI2Gf509BjeyaiBthFaCuofi2GLHPm6hkhO+ohp/v78OtHAig/su1+DBEyAwlOTEJn8ZqND0sgt0KPhLua2c6MrC8V4/kyFJ6nbeROoBblM2DSN4Xzs5sBfi+5XDiK9+R7SGKMqedfZaxO8J+wmPEEMu1A00jTiEEt8QeF66g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244032; c=relaxed/simple;
	bh=kUA3x6YCqyzcVC3O6doY3zntXDSczh3Rc0wLLtMb2fc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uq+Jvs4kWqGaTZCUyersG/MHwjI5XJaaDWkinNEpOEyjpXX8y1V/+qTGBJXcrxPDYla5YqEkENsKjxKvWeVSvkbdN1f+y007miH8m2DmWVM/jjLXFcroVstPvPEhaZ7Erc8HOAzQ/ewzIOq55HtEDJvIbq1ZsaGhjsZAtdx1KkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UnTD0ec+; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBqmHv6Evhm163A2xVGw51jnDKJk7oBcDZaIQl9U5YSYmuYfTF9L0O0wsxOuRA/IzhIWk3EbRbLoUWnJZazz79AaOvr94maFNm1IpHLz7u8PCfYieG0+hzIqXUvSJLU2o5FS3GYE4++RlWM1wWM3pNr0+ycomj/n3DDc+sMEpHJVsNlcS3EI2jBDqAzLbqZn1gD03H4WX9GlVJPCI+GVwnhANfxcV0dlL28pNCD9FWJiq+2U284vfQbNXmEjf8g8j7kL9mE+65BoIg/HcmnYRIehljjzlgKSyd3Do9c1VcOrdJekgdMcWYi4lGwrYmbT5HWGHaOqhJuhT2yQaXffcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9Q0YgQlJrDtGCtegnCZIrYCnCzwv6QRWqtQLd+3r9M=;
 b=Z4EfU93VeA/O/Xi05eRTU98/IJ8dtcrDGNaG+E/vcMULC0SQbX6mPej5mDseJ/dckNH8rl1wn7dtBlMv4RYeeMyFUs8+QVanPfZpUWf4PMLS9pqq/lsgHDDDd+OPmBNYmeDyzCh5DeRBU5cqDkq9284MQEbX2K8hHBDrfEvy10LklQWGAC+/hGCxC9eGDAu2Mp+vekT6WwRZmJT0NPnLwGzBCklnLgki8TGdZFBbPjE9q4hPJ2iwM+a7wLZPLM2OrvTy1JMPxVlIK29dOOxgbk62Rsqga6TcnshE/4C43eszTAzZoPlS7OS2M9X9OsA5wI1NH1HtxuNYjOsP7odbaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9Q0YgQlJrDtGCtegnCZIrYCnCzwv6QRWqtQLd+3r9M=;
 b=UnTD0ec+zrLSbweX3i1tEktgdOf7oPNPtl8fOyr3q13qqxe+k/ovVGTEMfI2HdMnU+pD7RjE2xcHqSigzGXvd4BjeTQMwOBkpR0oKcHzw9TMvOCbf52We7+9/MuvqTBVzqxiJ6PxshXelpv113QFDBZLQ2jvFsHDXd6n8YhcTmg=
Received: from PH8PR07CA0033.namprd07.prod.outlook.com (2603:10b6:510:2cf::20)
 by DM4PR12MB5277.namprd12.prod.outlook.com (2603:10b6:5:390::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:40:26 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:2cf:cafe::8a) by PH8PR07CA0033.outlook.office365.com
 (2603:10b6:510:2cf::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:40:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:40:23 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 09/25] x86/fault: Dump RMP table information when RMP page faults occur
Date: Thu, 25 Jan 2024 22:11:09 -0600
Message-ID: <20240126041126.1927228-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DM4PR12MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: 63cd7b46-ef6d-4ba9-bb9e-08dc1e28ea4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5Nx1Cy9Ebf2u7ipr6PQVd3Hk4Vt9DgDqJ4l5zQAD7nViLYOd2ejLcTdz7T5HDw0WDjG7DGBvqPavv8CqB/VO5Hd2CAo24i3v8GIecOkcpRj3GTeprjV5l47B31OPaHzpRmiaS63vG9DF93icgPpYC/6Z8UOfiwgkCfthfrOQZ3y8f1P1xAVHggKQr/h8KXXxNXTcQCWL/cI9KD7SDFMkZjGh1+GV8041TVPC20RsPNGaSLS2yh1lFSp4XxexqFztWKgi0XefwUvRlI9YNoBfFCwvjzz5b9edIeXZytYcX0tM07FwVkp33r9b1DxDEAOa0rMjsFmb7nKhKtBn8h4HhE1N0nAJjYiAo61DZ2GL9zFMP6VxW6xYvWfVN/xVlvTlHSR7dNodWfZSGrKPSr9856jSVu+GtwPKXmESlZapTEdfzDOM8x49mTjfUhT4Jmw+p00ugezzMIPbFEnLJzf9Xc7T3ccMxFE4CRWxTbYeWt0W8ABJQhY2ddVGs0ymQ7celxIwCjLd477zftipvHs8vdledlYJ1fwcbKhqywqhzSmSIjT5TYov6mTr8HA9mALbAMLUSc6pUTYQVMpYnPxIroNM3wsT+l4QLexnqfTDlIrsmmpgmqsEzaOz9D06QHMTUxAAJRU4EVEYRlfsVV5R3Y3jmMwPokBvmfQuwYkEf7CQFO4ZXZ3LC4WdrA2du3wP9p6JSjJUKtruli2Sn0hzLcIAmdL3oJ9MkVNzHYMtX2f88uqbl66JoBnCKYl6+wYCPWX9lOKakRMWpAZq4KVduA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(1800799012)(451199024)(82310400011)(64100799003)(186009)(40470700004)(36840700001)(46966006)(36756003)(426003)(1076003)(26005)(16526019)(2616005)(6666004)(336012)(5660300002)(7406005)(7416002)(47076005)(2906002)(44832011)(8676002)(316002)(41300700001)(478600001)(6916009)(54906003)(70206006)(36860700001)(8936002)(70586007)(4326008)(82740400003)(86362001)(81166007)(356005)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:40:25.7630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cd7b46-ef6d-4ba9-bb9e-08dc1e28ea4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5277

RMP faults on kernel addresses are fatal and should never happen in
practice. They indicate a bug in the host kernel somewhere. Userspace
RMP faults shouldn't occur either, since even for VMs the memory used
for private pages is handled by guest_memfd and by design is not
mappable by userspace.

Dump RMP table information about the PFN corresponding to the faulting
HVA to help diagnose any issues of this sort when show_fault_oops() is
triggered by an RMP fault.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8805e2e20df6..859adcd123c9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev.h>			/* snp_dump_hva_rmpentry()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -580,6 +581,9 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		snp_dump_hva_rmpentry(address);
 }
 
 static noinline void
-- 
2.25.1


