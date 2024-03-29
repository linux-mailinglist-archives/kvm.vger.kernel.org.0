Return-Path: <kvm+bounces-13217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 362CD893405
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59D7C1C22FE5
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A44C157A7D;
	Sun, 31 Mar 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YaejfdVx"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED0156C56
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903220; cv=fail; b=EGytpKoQNfVAKZao+V9hBzyc3tNC/j4KeoyJbWssfed1CX+2SybokXcq9tj08Yu9hLbfi4F5yKH3hKoVRpgrFjIRr20XWiCZ272+T2bTS8nHX2kSpREUvp6G7C7kTFcmN9gkBHCfqevVX3IhO63xo1/rjIvIndaUeq45tDrl8WA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903220; c=relaxed/simple;
	bh=pxJWsUH0LYl+HBVjpNCC1IBh/lredb2muB4U900OwK0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HpcfBjreCZUxGnLT+Ml1F+BHbnVT1kgpKM5Tak8kSmEi6eIaUN5C8eVsfpVrJcO+b1j9E4UAkkOb6DqmorS1dMjqr4AYNzegSsUorhewHjROuK1yHtQomVYzBTeaFbYFl7ThOldc5QDkow2eUOCPjMwnN0qQv+St+5oKB9T2uzE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YaejfdVx; arc=fail smtp.client-ip=40.107.243.46; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 53951208C7;
	Sun, 31 Mar 2024 18:40:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dI7FWGsGyYor; Sun, 31 Mar 2024 18:40:14 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 48D7F208C8;
	Sun, 31 Mar 2024 18:40:10 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 48D7F208C8
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 3A21A800050;
	Sun, 31 Mar 2024 18:40:10 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:10 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:17 +0000
X-sender: <kvm+bounces-13108-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAfEemlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAcAAAAMyKAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 18029
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13108-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 07FA6200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YaejfdVx"
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747798; cv=fail; b=sUq4TDWAeVqR4bmNMBSA8tozQ25gva53JChyDj2NLG2LdaB5nK8wGqbZXZqekg+cDpaVHlSjaBxNqLXtMX7LUa/re4g4eKZ+WoP+cLw1yaRzxFaW7Xn7h5ZvrUbqVta3zxMova3hmPCnWQmWUGnGCy0lkvObuc6CHNDgT7IyaJc=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747798; c=relaxed/simple;
	bh=pxJWsUH0LYl+HBVjpNCC1IBh/lredb2muB4U900OwK0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9yAf1fnLjdStkK58n3DpnV+J3lMUekMaWQ6fYE2hsgISJBvHTBmWM8bDE4vl5UWRb912mudM0jEl4I9QQFkub8eC7xkIgOmo5yLotyMau+9xVvazXvljP2BGPivLfsgm9yasP2Q4BA3aK2yQIVgy3xVqX6adPIWekKOabUHTTI=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YaejfdVx; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqmCYWU4/RlXJ8RYU2eaV2JyNbSLqQhLSUSNcqPzXvhmKgLKaTaYsONsp8sQOd3S0m852q/oj7/09WVD/VIshPed7taEZ1hDweJcCpSN8dqPTIgl2BRrApL6Fp46FC2lpjiPrXfnXoxioxPWADxOtwTOUogr/5Ldzti3KpXxIbMV4ahK02j+2NqHViVwsGy6rzns/QucCiPtf/hJ3mO86s6nEssItXKebmMIRKubHNp4EQgavoc9sHYne/M8/e9zgMY9P5BZOLY7mCFR4vgsScQe+FtKXlke3tZbxMwrgcdJoQmFROvKSAsrW5ojVuZM6MNp5WaNM/r/vRGllApCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugJ9I0m9t7jZi5D7ZCKz+s5HBr61uhs2MgrhZhxvsMk=;
 b=oAqdDUm9R/2tRsNmyGbPpPT6N5JaaQNY/RAFc/8UJNCJ3trlX4NvP7JEAQ5d5dnXitaqsNtE77DAA5LTrqQMLmOKPPOaToz9q5pcgdoV09eV0eP6xug0Mqztnx4GGjujVuHISpOdIRwsMoKc2QJYG3B6LzRuzl1i8KP0xMEsedMRUVMDQj+/4kfM4tnnkFr4tB0tannJHlgbw26fMuHJDMv9v+r3As4R3ffDaHLS0i1EePHwSQ4/flxUBAJSSuMexXNbDPKwbhgw4LJL1nMLudICRmlmjE7+0CrPCJKHShZ3uhiFIJVrxhxzDAd/jP1kESwUicM9vxCsaTOhaddH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugJ9I0m9t7jZi5D7ZCKz+s5HBr61uhs2MgrhZhxvsMk=;
 b=YaejfdVxDpCZKRZKcPstCocOnPuWu13gJvC9R6CP1LpjZd4FygrTYjPdIn893XSzVD3FRq79AOJcfhVisLWzco7OR8PrSpylfLJkzU6ozXjHbf2VL4nRSx2Icrw4IEiKtS/jRoBBj5pUfT7hsHBESPjaihbLNMr4paeVwAUQEWI=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH gmem 3/6] KVM: x86: Pass private/shared fault indicator to gmem_validate_fault
Date: Fri, 29 Mar 2024 16:24:41 -0500
Message-ID: <20240329212444.395559-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
Precedence: bulk
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: 1856f6a1-b056-423f-dcb4-08dc50376021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: te47BAQwhc1soyCg0Hoh00aBleZuLAv9dbZGyFvPjcnnsH/rTLjWom5OPMxCyIpXReEl9MTr7dc76qpMsuIZBvRqEDM+xoYjGphZ09BCRg/iqtaXOJIRqTvI/LXCHUvPnQU8B6oPeSOIBu1dNpcgi9nrI/J3Q3lR14HnvavpKnUqTfwvA6seajAYzzbXqOf0GahOI5ik4QGXN7asIJV9yOjHfZpN80rFshgrzp6ooqOimc9NFutfUdzjmfSyQw17DotcMI++6rbmpNSqRiafDcsfo4KL7zaPjR5AAJhnyiSrJkDUsBhz7I+Ptq2Awhn1jUKUUQyBWoPE/8Cmy3ungIRVKc4wjjlJlmBvRV9HIJ2TXcVpZQ0wFl2gtIlQ8NLCA4equ37Ct4RQkUvktOl+msZ7hBONw5y/iRO3ZJQUDWZbUQSQQgWp27nWw9s9Wh0bCstFxLfx2FVIY5M6y7WpVrimJ+jsLvkzTGGEdONp5TnQKAby3n3CyKQIEqrdJzFBoLVaU44/dBXDtbvGWBmksfaCQ/B/EcSxggmlM3n3VTlIQhOp9jqVpuq4obFz8gifQLPQF0s5OXANY0pFKNeKmJdd55YDWfFNDOCdSTAWotlZ8hHs+WKU8QAlU5lEd0a6UYPkoNqsCxS8y8goXixMOftD8jDOhxyc4L3EW7eYEqZTf3H9GyEzbV7eZ6TcOpmwC8Ecd2nJotHKcepFExamZw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:29:54.4773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1856f6a1-b056-423f-dcb4-08dc50376021
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

TDX has use for a similar interface, but in that case it needs an
indication of whether or not the fault was private. Go ahead and plumb
that information through.

Link: https://lore.kernel.org/lkml/35bc4582-8a03-413b-be0e-4cc419715772@linux.intel.com/
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16fff18ef2e5..90dc0ae9311a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1815,7 +1815,8 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+				   u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d7ee18fe524..0049d49aa913 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4340,7 +4340,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
 	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
-						     fault->gfn, &fault->max_level);
+						     fault->gfn, fault->is_private,
+						     &fault->max_level);
 	if (r) {
 		kvm_release_pfn_clean(fault->pfn);
 		return r;
-- 
2.25.1



