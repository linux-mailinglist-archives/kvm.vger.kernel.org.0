Return-Path: <kvm+bounces-13226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 122288934D0
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27AB91C23E16
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA6316D316;
	Sun, 31 Mar 2024 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q9r7dIZC"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E2816D4CE;
	Sun, 31 Mar 2024 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903583; cv=fail; b=Oz4l/AD2b2l9TjmU1Evo9WnTZd6Gzno1ZcdrpZhn6VtX6a+RogukkqdimTZHPCnh4RxLi3NTiEbATnTxF+p+xwl+Grdx2h/ZsqwtZ/68DLXaSvNQjiwTIUSxoWeuz3xT/wfmicl5Bq3rYZBOljwyP9XuIu+Xtbx1nMO5wlgbi/I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903583; c=relaxed/simple;
	bh=szS4npT6jtaCxmPKhqq/c0JnOD82MDpgeVFEycWV5YM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQPyjx7MooQ42olmWmKEH9biDUO4Ji+vgOXNcQMHVUqNAwV5+MwumnQmBL2MHNYx0tg8Fk1he+Hln9r4gkkU9owflYY6xE31Y6tVStiYHJ005i2UF2+9WNDczuhjoRZi9xvuB7wg2Kx5wxPE3te+NImSHgVwi9VbaS0HuIrEvOY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q9r7dIZC reason="signature verification failed"; arc=fail smtp.client-ip=40.107.212.79; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 4C3C82084A;
	Sun, 31 Mar 2024 18:46:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oMhpr9twxCJU; Sun, 31 Mar 2024 18:46:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 21B15208DE;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 21B15208DE
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 7EB8280004E;
	Sun, 31 Mar 2024 18:40:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:15 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:17 +0000
X-sender: <kvm+bounces-13112-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q291bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGIACgB5AAAAzYoAAAUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 26372
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=kvm+bounces-13112-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 43159208AC
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753153; cv=fail; b=BYbUnnfXmxEtv1PkrIHV+7kzVO0y3a1Ye+F4TRsm29EL0omYnNLvNDSQwPMrK6Z80fnDzyU2l8EfE3Fm6gpXmT0qiFAbN87V7eOZwJzuqVAJ70gFqLeQEMXZ56g8tSRZScOkyyPbWGrEyHg/1rRmBrm3pQuOvLWGoHZ3WptkQF8=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753153; c=relaxed/simple;
	bh=32N0Xx4fpPiGgE4gdCbkfdfNikRkU8p14GCc9880qic=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6h1fEpizL+9h9BpHNiFVub3+3P5w3JD0lfdk8PZptPGziwiP5AnrmvxqeGRjE4W5Le1zkKGCVue4EUqS+y04Y+rXUZSUK9J9lyDqkdMCJHY1wU1Byy/7PBF40xIkza8bvGO9bcWbA8C/FJ2d55TKdQO+/guAX1pBzwbXtegNUk=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q9r7dIZC; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CA9+EpoNiZ9ayMmuF+uTwSeBjPBlCFrkeWODbOoFlUQYPDABUEHwtqo28a8PW/imB4XHrnE6Mt7E6/eCJocLwL2ciZisEmC7AJ22GL9xbPbPArTsRqEhdNCCbYLP8qWdMy7FpFKDiSu99P3EtkWJOVuZR6wJ1zXPkVsxJAHxQ1NZ77Qa85K/ObPQ8AXhBmWwf+YD98Gd+ZIg+6gXsRxooicVQa7Y3DkW94F4Dp2asJhZho3IOy1uRIKUanolI+9CLEqcJE1wd8Pj9ElUfYP1G1okbc8A1YOlkTe5b9ULGwMufalRk2pkDIBD7XR36PUU/mnLms1Qwwj+VM+0nGkajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=;
 b=XUVPXyEnaWzdYWoJNkvqerhl6Svq2T8m2knayzG2+AeIbpHftkICKGYxj3BhyGshE2fO6TH9GpjHVrVPkK/+CpJ64AIdKw86jsY6ZbM8HQwf8klvQ5RxPozzGqx8MCi//iIwzzm3KPNqhj3Ww+jF4+8AE9bU9otOpkMOebIPanjg1MidwxVrLnfjkq7hfRkk/I+aj940z2p1XCAH17I0WNoHu8EhR4AyoCVtX/44RDF24bsnopzDbUsoOPAjhJ/fk/qtp+XVd5ANyraXcDOdxzpXNzWDFF6h5vNh9oBEnYh/p27lBZGuXOhT4rZfFcCDSYu2vULKOAr2b0ovUb+ebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=;
 b=q9r7dIZCmGAMsb5Qf5qevjsO+u2qguOTQwgvMMQeTMWFxL30f5651Ih1rIv4M6gqyWlZAEDGO0VJA6/trmWh7JWA1JQmddseBxmacNU4bozvpuXx54+2xHpPUF3BfBuyIDYp3RuPMt3lUtS6+dQfKoYUuLkX31Den1QT9hFH4FA=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 09/29] KVM: SEV: Add initial SEV-SNP support
Date: Fri, 29 Mar 2024 17:58:15 -0500
Message-ID: <20240329225835.400662-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsYawN22RK6vpJl8VU3uLdBNz2wKwfigLe9u15MYJjT0NXQV3Yzjn6a1OjYj4LPzeDO8cf52t0bld23f73IhgDjhPepqbc7IwHTzPhZ/pO0fb1Dc4F6dPKSdnsPrwbyyhJI21uoEBXlb9DpAIEIBOyVjZmH+wtq/OnN34HGIHNnAASx0iEdmOS44o1oEugf+lFgXmiA6AQWu+IikoKRj2YItSH3Txq0G7BC/TRGiWq2KqdmgFh+n5Hsot5lhcjxEP+iWzkso8UiBcRHFE8Sju6gjTCdVv1uIDSSjI3OvUAubuGZeTloeeL4ALMLAdXglcVDTAeML83k7xVUpdU2UJQx0wb/97jBfBau1zhrRC78B3NehLm2mU8sjwnExhuP/MfHsbmuX5VvLn2CPH9T81lSMjdxVYlZI/ytN2lzlTQ6vcxI+8hSPG9PpG923elprnKSAI7fsLuCaIOF+SPmZqnI+RcAfIX4fms89ZDSC6lffhLHDFAraZ3I86fN9ZemKTUgctwPvboQCfEG3mDxYzLPPQYhchCxYb1wWaG8jFR5sFSVsrE7JQ/SDBGTYpRHKn9KLxD3rVWSX7nTCof7mJAPHXd2W0DPkpcx9TiDMdcZ4+2WH9Ez1YUqwMRjAYVmxwirJl9RK3NI4in6GXQmovhcw4JB7RQikwOS3iiudBKTtfKGD6mR80tiSkJb9G8Bw9pvoQHQlT6bQl8BXfRTgx5cMzVuv0ny3ytgj4cr3PKrxvNDbOm6IUcK3cMc8E9Ls
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:01.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d334
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..544a43c1cf11 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_M=
AX_INDEX_MASK) =3D=3D X2AVIC_
=20
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
=20
-#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
=20
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 51b13080ed4b..725b75cfe9ff 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -868,5 +868,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
=20
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1e65f5634ad3..3d9771163562 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled =3D true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
=20
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled =3D true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm=
_sev_cmd *argp,
 	sev->es_active =3D es_active;
 	sev->vmsa_features =3D data->vmsa_features;
=20
+	if (vm_type =3D=3D KVM_X86_SNP_VM)
+		sev->vmsa_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret =3D sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_=
sev_cmd *argp)
 		return -EINVAL;
=20
 	if (kvm->arch.vm_type !=3D KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type !=3D KVM_X86_SNP_VM)
 		return -EINVAL;
=20
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2297,11 +2304,16 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SEV_ES_VM);
 	}
+	if (sev_snp_enabled) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
+		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SNP_VM);
+	}
 }
=20
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported =3D false;
 	bool sev_es_supported =3D false;
 	bool sev_supported =3D false;
=20
@@ -2382,6 +2394,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count =3D min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))=
;
 	sev_es_supported =3D true;
+	sev_snp_supported =3D sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV=
_SNP);
=20
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2394,9 +2407,15 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
=20
 	sev_enabled =3D sev_supported;
 	sev_es_enabled =3D sev_es_supported;
+	sev_snp_enabled =3D sev_snp_supported;
+
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled =3D false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..2c162f6a1d78 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4890,7 +4890,8 @@ static int svm_vm_init(struct kvm *kvm)
=20
 	if (type !=3D KVM_X86_DEFAULT_VM &&
 	    type !=3D KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state =3D (type =3D=3D KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =3D
+			(type =3D=3D KVM_X86_SEV_ES_VM || type =3D=3D KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init =3D true;
 	}
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 157eb3f65269..4a01a81dd9b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *k=
vm)
 #endif
 }
=20
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean =3D 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64eda7949f09..f85735b6235d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12603,7 +12603,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
=20
 	kvm->arch.vm_type =3D type;
 	kvm->arch.has_private_mem =3D
-		(type =3D=3D KVM_X86_SW_PROTECTED_VM);
+		(type =3D=3D KVM_X86_SW_PROTECTED_VM || type =3D=3D KVM_X86_SNP_VM);
=20
 	ret =3D kvm_page_track_init(kvm);
 	if (ret)
--=20
2.25.1


X-sender: <linux-crypto+bounces-3086-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com; X-ExtendedProps=3DDwA1AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9y=
dC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA8MUJLbkECUOS0gj=
aDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAG=
IAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IR=
jIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACh=
eZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJ=
hdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ0=
49c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngt=
ZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmV=
jaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGwAAgAABQBYABcASg=
AAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZXJzLE9VPU1pZ3Jhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNl=
U3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGN=
oYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW=
5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAeAAAAM2KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 26564
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Fri, 29 Mar 2024 23:59:24 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Fri, 29 Mar 2024 23:59:24 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id E4791208B4
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:24 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=3D-2.85 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QnZlk_tCllH0 for <steffen.klassert@secunet.com>;
	Fri, 29 Mar 2024 23:59:20 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3086-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 7F82D2087B
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 7F82D2087B
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED7B51F23BD2
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 22:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE14613CFAE;
	Fri, 29 Mar 2024 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"q9r7dIZC"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02=
on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DAD13EFEE;
	Fri, 29 Mar 2024 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.212.79
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753153; cv=3Dfail; b=3DBYbUnnfXmxEtv1PkrIHV+7kzVO0y3a1Ye+F4TRsm29E=
L0omYnNLvNDSQwPMrK6Z80fnDzyU2l8EfE3Fm6gpXmT0qiFAbN87V7eOZwJzuqVAJ70gFqLeQEM=
XZ56g8tSRZScOkyyPbWGrEyHg/1rRmBrm3pQuOvLWGoHZ3WptkQF8=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753153; c=3Drelaxed/simple;
	bh=3D32N0Xx4fpPiGgE4gdCbkfdfNikRkU8p14GCc9880qic=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DX6h1fEpizL+9h9BpHNiFVub3+3P5w3JD0lfdk8PZpt=
PGziwiP5AnrmvxqeGRjE4W5Le1zkKGCVue4EUqS+y04Y+rXUZSUK9J9lyDqkdMCJHY1wU1Byy/7=
PBF40xIkza8bvGO9bcWbA8C/FJ2d55TKdQO+/guAX1pBzwbXtegNUk=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dq9r7dIZC; arc=3Dfail smtp.client-ip=3D40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DCA9+EpoNiZ9ayMmuF+uTwSeBjPBlCFrkeWODbOoFlUQYPDABUEHwtqo28a8PW/imB4XHrn=
E6Mt7E6/eCJocLwL2ciZisEmC7AJ22GL9xbPbPArTsRqEhdNCCbYLP8qWdMy7FpFKDiSu99P3Et=
kWJOVuZR6wJ1zXPkVsxJAHxQ1NZ77Qa85K/ObPQ8AXhBmWwf+YD98Gd+ZIg+6gXsRxooicVQa7Y=
3DkW94F4Dp2asJhZho3IOy1uRIKUanolI+9CLEqcJE1wd8Pj9ElUfYP1G1okbc8A1YOlkTe5b9U=
LGwMufalRk2pkDIBD7XR36PUU/mnLms1Qwwj+VM+0nGkajg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3D85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=3D;
 b=3DXUVPXyEnaWzdYWoJNkvqerhl6Svq2T8m2knayzG2+AeIbpHftkICKGYxj3BhyGshE2fO6T=
H9GpjHVrVPkK/+CpJ64AIdKw86jsY6ZbM8HQwf8klvQ5RxPozzGqx8MCi//iIwzzm3KPNqhj3Ww=
+jF4+8AE9bU9otOpkMOebIPanjg1MidwxVrLnfjkq7hfRkk/I+aj940z2p1XCAH17I0WNoHu8Eh=
R4AyoCVtX/44RDF24bsnopzDbUsoOPAjhJ/fk/qtp+XVd5ANyraXcDOdxzpXNzWDFF6h5vNh9oB=
EnYh/p27lBZGuXOhT4rZfFcCDSYu2vULKOAr2b0ovUb+ebg=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3D85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=3D;
 b=3Dq9r7dIZCmGAMsb5Qf5qevjsO+u2qguOTQwgvMMQeTMWFxL30f5651Ih1rIv4M6gqyWlZAE=
DGO0VJA6/trmWh7JWA1JQmddseBxmacNU4bozvpuXx54+2xHpPUF3BfBuyIDYp3RuPMt3lUtS6+=
dQfKoYUuLkX31Den1QT9hFH4FA=3D
Received: from DS7PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:3bb::19=
)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 22:59:07 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::79) by DS7PR03CA0074.outlook.office365.com
 (2603:10b6:5:3bb::19) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 22:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsof=
t
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 17:59:00 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 09/29] KVM: SEV: Add initial SEV-SNP support
Date: Fri, 29 Mar 2024 17:58:15 -0500
Message-ID: <20240329225835.400662-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d3=
34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsYawN22RK6vpJl8VU3uLdBNz2wKwfigLe9u15MY=
JjT0NXQV3Yzjn6a1OjYj4LPzeDO8cf52t0bld23f73IhgDjhPepqbc7IwHTzPhZ/pO0fb1Dc4F6=
dPKSdnsPrwbyyhJI21uoEBXlb9DpAIEIBOyVjZmH+wtq/OnN34HGIHNnAASx0iEdmOS44o1oEug=
f+lFgXmiA6AQWu+IikoKRj2YItSH3Txq0G7BC/TRGiWq2KqdmgFh+n5Hsot5lhcjxEP+iWzkso8=
UiBcRHFE8Sju6gjTCdVv1uIDSSjI3OvUAubuGZeTloeeL4ALMLAdXglcVDTAeML83k7xVUpdU2U=
JQx0wb/97jBfBau1zhrRC78B3NehLm2mU8sjwnExhuP/MfHsbmuX5VvLn2CPH9T81lSMjdxVYlZ=
I/ytN2lzlTQ6vcxI+8hSPG9PpG923elprnKSAI7fsLuCaIOF+SPmZqnI+RcAfIX4fms89ZDSC6l=
ffhLHDFAraZ3I86fN9ZemKTUgctwPvboQCfEG3mDxYzLPPQYhchCxYb1wWaG8jFR5sFSVsrE7JQ=
/SDBGTYpRHKn9KLxD3rVWSX7nTCof7mJAPHXd2W0DPkpcx9TiDMdcZ4+2WH9Ez1YUqwMRjAYVmx=
wirJl9RK3NI4in6GXQmovhcw4JB7RQikwOS3iiudBKTtfKGD6mR80tiSkJb9G8Bw9pvoQHQlT6b=
Ql8BXfRTgx5cMzVuv0ny3ytgj4cr3PKrxvNDbOm6IUcK3cMc8E9Ls
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:01.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a450cd9-fdcd-4e47-ed16-08dc5=
043d334
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861
Return-Path: linux-crypto+bounces-3086-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 22:59:24.9586
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: eddbe8a6-9ce3-4b49-8303-08dc=
5043e11d
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33580.402|SMR=3D0.327(SMRDE=3D0.005|SMRC=3D0.=
321(SMRCL=3D0.104|X-SMRCR=3D0.321))|CAT=3D0.070(CATOS=3D0.001
 |CATRESL=3D0.032(CATRESLP2R=3D0.009)|CATORES=3D0.034(CATRS=3D0.033(CATRS-I=
ndex
 Routing Agent=3D0.032
 ))|CATORT=3D0.001(CATRT=3D0.001))|UNK=3D0.001|QDM=3D10280.358|SMSC=3D0.594=
(X-SMSDR=3D0.020)|SMS=3D5.978
 (SMSMBXD-INC=3D5.461)|QDM=3D20522.747|SMSC=3D0.486(X-SMSDR=3D0.011)|SMS=3D=
5.643(SMSMBXD-INC=3D5.142
 )|QDM=3D2759.061|PSC=3D0.010|CAT=3D0.007(CATRESL=3D0.005(CATRESLP2R=3D0.00=
2))|QDM=3D5.364|CAT=3D0.009
 (CATRESL=3D0.007(CATRESLP2R=3D0.003));2024-03-30T08:19:05.378Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 18350
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.017|SMR=3D0.007(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.010
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAW8OAAAPAAADH4sIAAAAAAAEAL1Ze3Pb=
xhEH+BQpUlJkx0
 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
 Xb1zCFge2WIK4kO6FupNgNK+22gqlY/KPgX4t8FHbAHDndlE8sx97N
 a8c9/tI83fg5gjUZiaFTO8s7HD8IC5LMKtI3sYEdR4xG5g7H/8bydp
 B2+xneWssJfoLj+H8Gwi1LSisAAAEK1QM8P3htbCB2ZXJzaW9uPSIx
 LjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxFbWFpbFNldD4NCiAgPF
 ZlcnNpb24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxFbWFpbHM+DQog
 ICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjU0MCIgUG9zaXRpb249Ik90aG
 VyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5icmlqZXNoLnNpbmdoQGFt
 ZC5jb208L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPE
 VtYWlsIFN0YXJ0SW5kZXg9IjU5MyIgUG9zaXRpb249Ik90aGVyIj4N
 CiAgICAgIDxFbWFpbFN0cmluZz5hc2hpc2gua2FscmFAYW1kLmNvbT
 wvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwg
 U3RhcnRJbmRleD0iNzE0IiBQb3NpdGlvbj0iT3RoZXIiPg0KICAgIC
 AgPEVtYWlsU3RyaW5nPm1pY2hhZWwucm90aEBhbWQuY29tPC9FbWFp
 bFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwvRW
 1haWxTZXQ+AQ7PAVJldHJpZXZlck9wZXJhdG9yLDEwLDE7UmV0cmll
 dmVyT3BlcmF0b3IsMTEsMjtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMT
 AsMDtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMTEsMDtQb3N0V29yZEJy
 ZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTAsNDtQb3N0V29yZEJyZW
 FrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTEsMDtUcmFuc3BvcnRXcml0
 ZXJQcm9kdWNlciwyMCwxNA=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 4390
X-MS-Exchange-Forest-EmailMessageHash: 1CBD1271
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:84/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..544a43c1cf11 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_M=
AX_INDEX_MASK) =3D=3D X2AVIC_
=20
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
=20
-#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
=20
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 51b13080ed4b..725b75cfe9ff 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -868,5 +868,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
=20
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1e65f5634ad3..3d9771163562 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled =3D true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
=20
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled =3D true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm=
_sev_cmd *argp,
 	sev->es_active =3D es_active;
 	sev->vmsa_features =3D data->vmsa_features;
=20
+	if (vm_type =3D=3D KVM_X86_SNP_VM)
+		sev->vmsa_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret =3D sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_=
sev_cmd *argp)
 		return -EINVAL;
=20
 	if (kvm->arch.vm_type !=3D KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type !=3D KVM_X86_SNP_VM)
 		return -EINVAL;
=20
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2297,11 +2304,16 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SEV_ES_VM);
 	}
+	if (sev_snp_enabled) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
+		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SNP_VM);
+	}
 }
=20
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported =3D false;
 	bool sev_es_supported =3D false;
 	bool sev_supported =3D false;
=20
@@ -2382,6 +2394,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count =3D min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))=
;
 	sev_es_supported =3D true;
+	sev_snp_supported =3D sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV=
_SNP);
=20
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2394,9 +2407,15 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
=20
 	sev_enabled =3D sev_supported;
 	sev_es_enabled =3D sev_es_supported;
+	sev_snp_enabled =3D sev_snp_supported;
+
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled =3D false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..2c162f6a1d78 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4890,7 +4890,8 @@ static int svm_vm_init(struct kvm *kvm)
=20
 	if (type !=3D KVM_X86_DEFAULT_VM &&
 	    type !=3D KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state =3D (type =3D=3D KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =3D
+			(type =3D=3D KVM_X86_SEV_ES_VM || type =3D=3D KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init =3D true;
 	}
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 157eb3f65269..4a01a81dd9b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *k=
vm)
 #endif
 }
=20
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean =3D 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64eda7949f09..f85735b6235d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12603,7 +12603,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
=20
 	kvm->arch.vm_type =3D type;
 	kvm->arch.has_private_mem =3D
-		(type =3D=3D KVM_X86_SW_PROTECTED_VM);
+		(type =3D=3D KVM_X86_SW_PROTECTED_VM || type =3D=3D KVM_X86_SNP_VM);
=20
 	ret =3D kvm_page_track_init(kvm);
 	if (ret)
--=20
2.25.1


X-sender: <linux-kernel+bounces-125486-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoAk0mmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbm=
dlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAA=
AAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1h=
aWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 18857
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Fri, 29 Mar 2024 23:59:35 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Fri, 29 Mar 2024 23:59:35 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id D2F4D208AC
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:35 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l7qOXSrzZ9yR for <steffen.klassert@secunet.com>;
	Fri, 29 Mar 2024 23:59:35 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125486-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D4D7B2087B
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id D4D7B2087B
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95E5728327E
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 22:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7214D13E6AD;
	Fri, 29 Mar 2024 22:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"q9r7dIZC"
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02=
on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DAD13EFEE;
	Fri, 29 Mar 2024 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.212.79
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753153; cv=3Dfail; b=3DBYbUnnfXmxEtv1PkrIHV+7kzVO0y3a1Ye+F4TRsm29E=
L0omYnNLvNDSQwPMrK6Z80fnDzyU2l8EfE3Fm6gpXmT0qiFAbN87V7eOZwJzuqVAJ70gFqLeQEM=
XZ56g8tSRZScOkyyPbWGrEyHg/1rRmBrm3pQuOvLWGoHZ3WptkQF8=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753153; c=3Drelaxed/simple;
	bh=3D32N0Xx4fpPiGgE4gdCbkfdfNikRkU8p14GCc9880qic=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DX6h1fEpizL+9h9BpHNiFVub3+3P5w3JD0lfdk8PZpt=
PGziwiP5AnrmvxqeGRjE4W5Le1zkKGCVue4EUqS+y04Y+rXUZSUK9J9lyDqkdMCJHY1wU1Byy/7=
PBF40xIkza8bvGO9bcWbA8C/FJ2d55TKdQO+/guAX1pBzwbXtegNUk=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dq9r7dIZC; arc=3Dfail smtp.client-ip=3D40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DCA9+EpoNiZ9ayMmuF+uTwSeBjPBlCFrkeWODbOoFlUQYPDABUEHwtqo28a8PW/imB4XHrn=
E6Mt7E6/eCJocLwL2ciZisEmC7AJ22GL9xbPbPArTsRqEhdNCCbYLP8qWdMy7FpFKDiSu99P3Et=
kWJOVuZR6wJ1zXPkVsxJAHxQ1NZ77Qa85K/ObPQ8AXhBmWwf+YD98Gd+ZIg+6gXsRxooicVQa7Y=
3DkW94F4Dp2asJhZho3IOy1uRIKUanolI+9CLEqcJE1wd8Pj9ElUfYP1G1okbc8A1YOlkTe5b9U=
LGwMufalRk2pkDIBD7XR36PUU/mnLms1Qwwj+VM+0nGkajg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3D85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=3D;
 b=3DXUVPXyEnaWzdYWoJNkvqerhl6Svq2T8m2knayzG2+AeIbpHftkICKGYxj3BhyGshE2fO6T=
H9GpjHVrVPkK/+CpJ64AIdKw86jsY6ZbM8HQwf8klvQ5RxPozzGqx8MCi//iIwzzm3KPNqhj3Ww=
+jF4+8AE9bU9otOpkMOebIPanjg1MidwxVrLnfjkq7hfRkk/I+aj940z2p1XCAH17I0WNoHu8Eh=
R4AyoCVtX/44RDF24bsnopzDbUsoOPAjhJ/fk/qtp+XVd5ANyraXcDOdxzpXNzWDFF6h5vNh9oB=
EnYh/p27lBZGuXOhT4rZfFcCDSYu2vULKOAr2b0ovUb+ebg=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3D85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=3D;
 b=3Dq9r7dIZCmGAMsb5Qf5qevjsO+u2qguOTQwgvMMQeTMWFxL30f5651Ih1rIv4M6gqyWlZAE=
DGO0VJA6/trmWh7JWA1JQmddseBxmacNU4bozvpuXx54+2xHpPUF3BfBuyIDYp3RuPMt3lUtS6+=
dQfKoYUuLkX31Den1QT9hFH4FA=3D
Received: from DS7PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:3bb::19=
)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 22:59:07 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::79) by DS7PR03CA0074.outlook.office365.com
 (2603:10b6:5:3bb::19) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 22:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsof=
t
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 17:59:00 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 09/29] KVM: SEV: Add initial SEV-SNP support
Date: Fri, 29 Mar 2024 17:58:15 -0500
Message-ID: <20240329225835.400662-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d3=
34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsYawN22RK6vpJl8VU3uLdBNz2wKwfigLe9u15MY=
JjT0NXQV3Yzjn6a1OjYj4LPzeDO8cf52t0bld23f73IhgDjhPepqbc7IwHTzPhZ/pO0fb1Dc4F6=
dPKSdnsPrwbyyhJI21uoEBXlb9DpAIEIBOyVjZmH+wtq/OnN34HGIHNnAASx0iEdmOS44o1oEug=
f+lFgXmiA6AQWu+IikoKRj2YItSH3Txq0G7BC/TRGiWq2KqdmgFh+n5Hsot5lhcjxEP+iWzkso8=
UiBcRHFE8Sju6gjTCdVv1uIDSSjI3OvUAubuGZeTloeeL4ALMLAdXglcVDTAeML83k7xVUpdU2U=
JQx0wb/97jBfBau1zhrRC78B3NehLm2mU8sjwnExhuP/MfHsbmuX5VvLn2CPH9T81lSMjdxVYlZ=
I/ytN2lzlTQ6vcxI+8hSPG9PpG923elprnKSAI7fsLuCaIOF+SPmZqnI+RcAfIX4fms89ZDSC6l=
ffhLHDFAraZ3I86fN9ZemKTUgctwPvboQCfEG3mDxYzLPPQYhchCxYb1wWaG8jFR5sFSVsrE7JQ=
/SDBGTYpRHKn9KLxD3rVWSX7nTCof7mJAPHXd2W0DPkpcx9TiDMdcZ4+2WH9Ez1YUqwMRjAYVmx=
wirJl9RK3NI4in6GXQmovhcw4JB7RQikwOS3iiudBKTtfKGD6mR80tiSkJb9G8Bw9pvoQHQlT6b=
Ql8BXfRTgx5cMzVuv0ny3ytgj4cr3PKrxvNDbOm6IUcK3cMc8E9Ls
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:01.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a450cd9-fdcd-4e47-ed16-08dc5=
043d334
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861
Return-Path: linux-kernel+bounces-125486-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 22:59:35.8868
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: d8a1fa16-8869-482d-0488-08dc=
5043e7a1
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dcas-es=
sen-02.secunet.de:TOTAL-FE=3D0.008|SMR=3D0.008(SMRPI=3D0.005(SMRPI-Frontend=
ProxyAgent=3D0.005));2024-03-29T22:59:35.895Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 18312
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..544a43c1cf11 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_M=
AX_INDEX_MASK) =3D=3D X2AVIC_
=20
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
=20
-#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
=20
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 51b13080ed4b..725b75cfe9ff 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -868,5 +868,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
=20
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1e65f5634ad3..3d9771163562 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled =3D true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
=20
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled =3D true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm=
_sev_cmd *argp,
 	sev->es_active =3D es_active;
 	sev->vmsa_features =3D data->vmsa_features;
=20
+	if (vm_type =3D=3D KVM_X86_SNP_VM)
+		sev->vmsa_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret =3D sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_=
sev_cmd *argp)
 		return -EINVAL;
=20
 	if (kvm->arch.vm_type !=3D KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type !=3D KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type !=3D KVM_X86_SNP_VM)
 		return -EINVAL;
=20
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2297,11 +2304,16 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SEV_ES_VM);
 	}
+	if (sev_snp_enabled) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
+		kvm_caps.supported_vm_types |=3D BIT(KVM_X86_SNP_VM);
+	}
 }
=20
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported =3D false;
 	bool sev_es_supported =3D false;
 	bool sev_supported =3D false;
=20
@@ -2382,6 +2394,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count =3D min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))=
;
 	sev_es_supported =3D true;
+	sev_snp_supported =3D sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV=
_SNP);
=20
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2394,9 +2407,15 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
=20
 	sev_enabled =3D sev_supported;
 	sev_es_enabled =3D sev_es_supported;
+	sev_snp_enabled =3D sev_snp_supported;
+
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled =3D false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..2c162f6a1d78 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4890,7 +4890,8 @@ static int svm_vm_init(struct kvm *kvm)
=20
 	if (type !=3D KVM_X86_DEFAULT_VM &&
 	    type !=3D KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state =3D (type =3D=3D KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =3D
+			(type =3D=3D KVM_X86_SEV_ES_VM || type =3D=3D KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init =3D true;
 	}
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 157eb3f65269..4a01a81dd9b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *k=
vm)
 #endif
 }
=20
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean =3D 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64eda7949f09..f85735b6235d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12603,7 +12603,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
=20
 	kvm->arch.vm_type =3D type;
 	kvm->arch.has_private_mem =3D
-		(type =3D=3D KVM_X86_SW_PROTECTED_VM);
+		(type =3D=3D KVM_X86_SW_PROTECTED_VM || type =3D=3D KVM_X86_SNP_VM);
=20
 	ret =3D kvm_page_track_init(kvm);
 	if (ret)
--=20
2.25.1



