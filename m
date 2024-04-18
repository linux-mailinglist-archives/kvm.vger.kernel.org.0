Return-Path: <kvm+bounces-15153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 643568AA357
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87C6F1C22E0E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830BA194C9E;
	Thu, 18 Apr 2024 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RsnOAaYG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585BE17BB31;
	Thu, 18 Apr 2024 19:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469640; cv=fail; b=C2/ohCG1czBxN600i4L0ZgCgYRpMxb3+wmqaOmVOkikCr7XVsrnvGjpJuTLAYBfHgxCVbgAcW0Jbci0Mzc/5XuSVrhaS9eT6vTYYzMm9Gm1AGC3aNOT2vRHz7TOA+AZ0z0nHpCjUvWM9WpL43KgWpjKemMePY3uh5+Xy2JlGUw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469640; c=relaxed/simple;
	bh=XUVMi5qquOtsySljlLUR0Hj67raeDpa0u44zaIzmzZc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qODMNDqoLbF9FpjyNXBjD7AJZ5FwxZkz8AgYPdx7Chum8g9gFOxO6VWGn22+81D6yj2OjRw9zjaIFXAgbtFqG93AGgHfHiG+oumhqIrX9yMmYupwcpe/odERSE/Gv1yI3lLrLa0DAkmtvrlNFA6ytphA7kDgoUwdYvVSvppvCYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RsnOAaYG; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8DMoESL7lG54guWjNPgl/t6RpxVbpPbH1cyjBT5eLfPUufcvmlKYzBL1LA84oMFtkRomF9WkHBRPK9AqbCFn7g9cAdAjaxWZMn/YhQICuWJZrOALK8khT/eYSQ0KHd+c4APWmsElLfgO9Me5h39ZP/5PAhzpTZhXQGRJLuZWRcfkxDqmeS8TAwhMIhHYUUeR84F996uBqgF+uJTOSOQT9AH01AJlK5DIGNJy4dONBSmiRmBNqoR6fYRj2/k8irEInujqqfPchoGl9T6ZuFoITE8WPe5zAxxWii6Ts9zN5QwSxhUpps0tvPsjUBcd/gt9R4xHRiqhtye2sk5dnIbPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sP0j7CgSEycNQ9rKRi6PZbBr7samEL54FEHOW51Nf1c=;
 b=KBnfW2RrQULaYPeSTKaONCJl4bCXdwhTtCOeVGC886g8P8EbM7mE47VmaOTDJWkx+PJG1Gq5Bwuz3koOl+gC28m9lNFgsM1Zfv3Rki3Q/HeQ1af33IgynAWUsUH4t8g+BSUYn5+ZBkGhlpAVNVE7oW8Qv2gfUoPDDRmnzaG9SgzrZdp6wc2tnPKH+1mBB93AmExrvdbvwQIL/eARPJIQPaVwKP0hQuVeIuBuZvhc+wVSemKFQYorsImCMAXwzvOxNOM8Cg+LKAHtXknlVgzSif7BSl1vXw3Mca4NMm1hta07uEby0966IgAHXxs+dCfzhAtNkO/2aJLZhdt2vPucKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sP0j7CgSEycNQ9rKRi6PZbBr7samEL54FEHOW51Nf1c=;
 b=RsnOAaYGgiHRCEIp2HuaihFHivj7RPtSObuDRKVu6XAK/Eyt6zMIttA9ENrReyG+lCGlV1NoRv02y1bTqTyc2emGbm7fu8OvV1b92kNY5U4ta/lOwGzK9yBPZsPn3uoiWYIeg6yJY4fJoyxQYn9d1M2da/M4s9Sfoo1TunG+ewo=
Received: from PH7PR17CA0038.namprd17.prod.outlook.com (2603:10b6:510:323::17)
 by SJ2PR12MB9238.namprd12.prod.outlook.com (2603:10b6:a03:55d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 19:47:11 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::3) by PH7PR17CA0038.outlook.office365.com
 (2603:10b6:510:323::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.27 via Frontend
 Transport; Thu, 18 Apr 2024 19:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:47:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:47:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 21/26] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Thu, 18 Apr 2024 14:41:28 -0500
Message-ID: <20240418194133.1452059-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|SJ2PR12MB9238:EE_
X-MS-Office365-Filtering-Correlation-Id: f06bddd6-996f-451a-6a08-08dc5fe0565b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VkWmjpv+jUDPWk7ngZIrgpcynRGPHazvM6y2mADcZYpZYHkW3hKWYn1GzMKtRl2SnwJcVR8PalgJTsgwf+C+MCnDEbSwIm7SE6RhdAyqxbAUX9Ig5oWfj1YxnUXVxop5/mfQP6fJQ+HoM0DHiOtPv3pNmpmYb+bCOWp0ku5vVuv+wRPWad+uZhVoZO65Duk4CkE924ZmyuXkznz9osZ0nsZ/eIGreXYkARSpsV4mmYVM6j6yOxZbaZyBlF50gLY/dfaPdaQeRT2EYmdLZdXwYdYvUY0VFsAWMRm8av2JVLbY2oELuxI1u9FoaRIpbwg1W8ujfsuicGeMY5SwiK7LToJvb5JlE8+Z2Smieh1SSMZw5C4luQNUUgpp3ateT3Qu3yuBkdfwrKnEMzMmorQVVQSWrhMdCJ3K8pRaeZrlx4Rz1NQTXhJGsXW0bzOdNZs3cpJOd6oiF/HmvRoKVG0vRleY+V/Rfpdy5aYd0px6EqWTiSu7mCTQIsIBN03S402VsM984BBa1zcZGURbTCylYga/cuARUHWf54Jo8p5H0bXonkca2Sa8jGCP1Ji4daUVvKFuu4QK87r75/WC4xibzmBTy/PU/f5EyY9rLMvsR+aOdeEqU7HeR6H+QwlSPfYOlg8pXTWpgdAr5NAnB2OdCODtUNv47nVtbEnbXB0a4eEi5mERrgAZrER5z0L2sBKSl5K7WxT4GUiorl7Did3IW5YZwUFjqbPHsIzszIif8axLau/dYbKC1BM7dkrx24X3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(376005)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:47:10.5287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f06bddd6-996f-451a-6a08-08dc5fe0565b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9238

From: Ashish Kalra <ashish.kalra@amd.com>

With SNP/guest_memfd, private/encrypted memory should not be mappable,
and MMU notifications for HVA-mapped memory will only be relevant to
unencrypted guest memory. Therefore, the rationale behind issuing a
wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
for SNP guests and can be ignored.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
[mdr: Add some clarifications in commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3fabd1ee718f..03bfb7b9732d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3033,7 +3033,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
-	if (!sev_guest(kvm))
+	/*
+	 * With SNP+gmem, private/encrypted memory should be
+	 * unreachable via the hva-based mmu notifiers. Additionally,
+	 * for shared->private translations, H/W coherency will ensure
+	 * first guest access to the page would clear out any existing
+	 * dirty copies of that cacheline.
+	 */
+	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
 	wbinvd_on_all_cpus();
-- 
2.25.1


