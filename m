Return-Path: <kvm+bounces-13235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B2F8934EC
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D50A1C23C66
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B30316EBE2;
	Sun, 31 Mar 2024 16:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pOjtEGW9"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9316D9A8;
	Sun, 31 Mar 2024 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903591; cv=fail; b=aRsMRrW0ZgjPaeYyNZ/XyorJtBlADA7fWUw1IipBpVGtaGrjHH/GTaBo5BMvQJ22qdAkkelb8r8SnNBnZZCnlElajOj1r9SmJsNH19qE3DA5Bw/2yBHWSrE5oL/jSG98DwZp2IDqrIG/xYKYOy+dEhu9zBeSyMG7mrBaSBjRtws=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903591; c=relaxed/simple;
	bh=1ZHsZG64hzacc9Ll4hnqx5HXSMxQAdObwdvHqsZFWqg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sivnz5rnSjRP+dHdNTgAhdm8dDyu1sPDRekewrqG9jPvd0UzPbV2UeZxGmovJ+ZuuUU1kR4T0+C6W7IVUfEc/iJIjSV1CtWJh+qpE0/PdZien7+mCRH4W6udX1y8Nr3QOEfbGGkcTTJbtZueXFmWcGpnryLfR/L/oJIGIhBwmxg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pOjtEGW9 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.70; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id E5025208E9;
	Sun, 31 Mar 2024 18:46:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qph6b1DvxZIH; Sun, 31 Mar 2024 18:46:23 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 49ACB208EC;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 49ACB208EC
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id F0D5A800055;
	Sun, 31 Mar 2024 18:40:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:19 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13117-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAm0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAHQAAAM6KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 22574
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=kvm+bounces-13117-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 855FC2087B
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753252; cv=fail; b=oTpN7PdEJ9jIspUxNioBOlLLcF6gzrnuC0L3riJfQ7nUsfL4QNoVwunMUVlptSptvbxOMApLqS1pt6A/PWO77bUtjZyw0SqEolJ5GWpiCdeoIjaHkOb2wgeWhODtGXom/3gq0/BFOh6FkrPXF6QE1Snmo+esqmXIauMuk9WfdOQ=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753252; c=relaxed/simple;
	bh=fRe47pl494d1OFWUZ11O/mVIdyx956Cti3mXx9SL/40=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJ5MMh8ioZKt/FZdKKyadx+msJsHY1CbQZ69izVUheIZzyChYuYpN+gUfLsILTypUuw2rDOGjty1IqOOdSpAWl3H3QNK8L3iR92pe//SOCvmnep9LHTTAcHFT1GorYPXzLJ2eoA4lJ1wtgzPb3w1MVAltEhI58Upuri1QXroDdc=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pOjtEGW9; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltxPzb4gC8CpZoT0mToE4xswkcDhnQWLRxkZQkARKc6uO6rmCINkuYyaHObH51zPODE6Z1l0EukNTsFrrMVoW5Do+xc8i+lunElm1VdacrzICPqGYcwAgeCcxwfwFQuqYFcVUQjiAJ4qiaWX/AA5y+d9Y3SD4Tf17CejubNk0nGjeJFwonDL3lKGmCWEpUTxr8AfsNCPrSGlhmltm7BmuOR8kDAsjuKvMh/+9FMn6YxlL3m+lMEWtJL5TjVjc/Vk+ywbDcGVBql2LkoWGlrxSDK5YkoAnDWSdjJEiSjnDCIvZJCJeu2H1obfRwuzvnN/EOXb0kEOel7QCK6HB49NzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=;
 b=VMvhUTOQ2LFjZX5tQQ8jO627Se68WfKdj/PFQkVTb0p/JwxY6l514Q0ULuZuwZdWGfP+HP3z5VeDVFNFCqQGQeN8Aux7FdM0HQ8e1D2E9jkDB1dDs4DBcuSvHBBF90v4T/03uBrlgLy4VQZVWDWKpF1A2dcvht6vdALp9auGeGuxJ20lj/k1j3h4tbZ0lFqIkz/aWCyqVKNr+99GkZlqKvhtPSWkui8xKWwm1VJEN0zUiPKrQXOwlM0dQZvyKiahDLhWL3oZIQ7CAj9P6YScaO9+Zz0q9vaMzABl4coqFP6QXEWwwCLYUBGELAv3nSD9ExQIS08r0az/8KlgoA0DZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=;
 b=pOjtEGW90KAdqaBSD5vBLGAQDENX/PrdSKwWhEu+ods4hZ40tPbULyRx3ml71Sy2QQdT0vKnFhxAiW9udjyUENct/EDHy9p9RYZeal7/Vc4iHnE1N2zsnhIagISLZXeUP6dj1+TxZ6YcY7zyz2/lDn7OBKmv0FVypT1UzsV57R0=
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
Subject: [PATCH v12 13/29] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Fri, 29 Mar 2024 17:58:19 -0500
Message-ID: <20240329225835.400662-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|PH7PR12MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: 194a5219-e203-4dc0-b9e3-08dc504411c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ycs7cffaR+L9MfxAEOyBdEsWMPoXz9kmxbblwgpKWIilVPU7CGtAhPCyq1vt/9c4Pd/M/CC3EGDTq01sbgh4akhO5kIDSzJ6lny7KwFac/rCZevlLfcjIrumooRLBXFxmkOs/40oJvYvIIQ+LFK9yCXkeoQtwHsqf3PKMHJxv6fpgKjfUdpssOnScs6mjla8PwVpEVosIFGCdI7r1JZNyDvxX3SlyZyZLg4lYCN1xPdCXnSnHSF5dhumiKgzMUKwhevLOUoaAOWcX24kbCt6uL9kGu91FeCP3JV1D6CLAM7VLU3QskfmYBJybMgNLkIdhEa2iyclFU1s3qkGzYiH4HBYXnUdKebcyOAefz/AaviBlwFihFlpiYJO+6ao3zMOLY+lA+R6lrVkVjDBhvcqaeXEFffySLIhLdnVJna2ldU5Ox2DCyxNCAxBd5yoo4iDi4WzrXbLPAAnxfj4eFn1STHmiaDhFLwA9qalQVIPpV5U7Q15uVg1ZFFtzvs3xqXFmT6RFiUISksUGAOocSFR0Q8clWMzffjF0cZCeb5/JX6aSZ5bYl7Q5FYjVUKbxN4RxMk2pyAJwMGTTyD7O8px+dG5ClEKYCBBKpfo9SMdBIqFEq7pRBrMc1zGTnaV/Y/r19BJ33Jq6oa+k5PaS3Jh1yrLnA+URxns4jBeuAqnCB7Y809tig4W4S8VIsy31b/VlspO1R/ttaAwuDFLYaYPS15DAB0I9ETJzF4kk8ttuHFPc/jgDXvpOGy8ZdM3L1Vq
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:46.4555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 194a5219-e203-4dc0-b9e3-08dc504411c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9224
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
=20
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d6c030091c2..b882f72a940a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3474,6 +3474,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn =3D get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa =3D gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3537,6 +3557,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
=20
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa=
)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n"=
, ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret =3D sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a3c190642c57..bb04d63012b4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -208,6 +208,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
=20
 struct vcpu_svm {
@@ -361,6 +363,11 @@ static __always_inline bool sev_snp_guest(struct kvm *=
kvm)
 #endif
 }
=20
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa =3D=3D val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean =3D 0;
--=20
2.25.1


X-sender: <linux-crypto+bounces-3091-steffen.klassert=3Dsecunet.com@vger.ke=
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
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAHgAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 23213
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:01:18 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:01:18 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 7B7E22032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:01:18 +0100 (CET)
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
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XOxpnGT-o5h4 for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:01:15 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.48.161; helo=3Dsy.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3091-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com A6462200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"pOjtEGW9"
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id A6462200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BF7FB214ED
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D0613E410;
	Fri, 29 Mar 2024 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"pOjtEGW9"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10=
on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8D13E048;
	Fri, 29 Mar 2024 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.93.70
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753252; cv=3Dfail; b=3DoTpN7PdEJ9jIspUxNioBOlLLcF6gzrnuC0L3riJfQ7n=
UsfL4QNoVwunMUVlptSptvbxOMApLqS1pt6A/PWO77bUtjZyw0SqEolJ5GWpiCdeoIjaHkOb2wg=
eWhODtGXom/3gq0/BFOh6FkrPXF6QE1Snmo+esqmXIauMuk9WfdOQ=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753252; c=3Drelaxed/simple;
	bh=3DfRe47pl494d1OFWUZ11O/mVIdyx956Cti3mXx9SL/40=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DdJ5MMh8ioZKt/FZdKKyadx+msJsHY1CbQZ69izVUhe=
IZzyChYuYpN+gUfLsILTypUuw2rDOGjty1IqOOdSpAWl3H3QNK8L3iR92pe//SOCvmnep9LHTTA=
cHFT1GorYPXzLJ2eoA4lJ1wtgzPb3w1MVAltEhI58Upuri1QXroDdc=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DpOjtEGW9; arc=3Dfail smtp.client-ip=3D40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DltxPzb4gC8CpZoT0mToE4xswkcDhnQWLRxkZQkARKc6uO6rmCINkuYyaHObH51zPODE6Z1=
l0EukNTsFrrMVoW5Do+xc8i+lunElm1VdacrzICPqGYcwAgeCcxwfwFQuqYFcVUQjiAJ4qiaWX/=
AA5y+d9Y3SD4Tf17CejubNk0nGjeJFwonDL3lKGmCWEpUTxr8AfsNCPrSGlhmltm7BmuOR8kDAs=
juKvMh/+9FMn6YxlL3m+lMEWtJL5TjVjc/Vk+ywbDcGVBql2LkoWGlrxSDK5YkoAnDWSdjJEiSj=
nDCIvZJCJeu2H1obfRwuzvnN/EOXb0kEOel7QCK6HB49NzQ=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3D/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=3D;
 b=3DVMvhUTOQ2LFjZX5tQQ8jO627Se68WfKdj/PFQkVTb0p/JwxY6l514Q0ULuZuwZdWGfP+HP=
3z5VeDVFNFCqQGQeN8Aux7FdM0HQ8e1D2E9jkDB1dDs4DBcuSvHBBF90v4T/03uBrlgLy4VQZVW=
DWKpF1A2dcvht6vdALp9auGeGuxJ20lj/k1j3h4tbZ0lFqIkz/aWCyqVKNr+99GkZlqKvhtPSWk=
ui8xKWwm1VJEN0zUiPKrQXOwlM0dQZvyKiahDLhWL3oZIQ7CAj9P6YScaO9+Zz0q9vaMzABl4co=
qFP6QXEWwwCLYUBGELAv3nSD9ExQIS08r0az/8KlgoA0DZQ=3D=3D
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
 bh=3D/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=3D;
 b=3DpOjtEGW90KAdqaBSD5vBLGAQDENX/PrdSKwWhEu+ods4hZ40tPbULyRx3ml71Sy2QQdT0v=
KnFhxAiW9udjyUENct/EDHy9p9RYZeal7/Vc4iHnE1N2zsnhIagISLZXeUP6dj1+TxZ6YcY7zyz=
2/lDn7OBKmv0FVypT1UzsV57R0=3D
Received: from SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::=
19)
 by PH7PR12MB9224.namprd12.prod.outlook.com (2603:10b6:510:2e7::8) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 =
Mar
 2024 23:00:46 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::88) by SJ0PR03CA0014.outlook.office365.com
 (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:00:45 -0500
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
Subject: [PATCH v12 13/29] KVM: SEV: Add support to handle GHCB GPA registe=
r VMGEXIT
Date: Fri, 29 Mar 2024 17:58:19 -0500
Message-ID: <20240329225835.400662-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|PH7PR12MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: 194a5219-e203-4dc0-b9e3-08dc504411=
c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ycs7cffaR+L9MfxAEOyBdEsWMPoXz9kmxbblwgpK=
WIilVPU7CGtAhPCyq1vt/9c4Pd/M/CC3EGDTq01sbgh4akhO5kIDSzJ6lny7KwFac/rCZevlLfc=
jIrumooRLBXFxmkOs/40oJvYvIIQ+LFK9yCXkeoQtwHsqf3PKMHJxv6fpgKjfUdpssOnScs6mjl=
a8PwVpEVosIFGCdI7r1JZNyDvxX3SlyZyZLg4lYCN1xPdCXnSnHSF5dhumiKgzMUKwhevLOUoaA=
OWcX24kbCt6uL9kGu91FeCP3JV1D6CLAM7VLU3QskfmYBJybMgNLkIdhEa2iyclFU1s3qkGzYiH=
4HBYXnUdKebcyOAefz/AaviBlwFihFlpiYJO+6ao3zMOLY+lA+R6lrVkVjDBhvcqaeXEFffySLI=
hLdnVJna2ldU5Ox2DCyxNCAxBd5yoo4iDi4WzrXbLPAAnxfj4eFn1STHmiaDhFLwA9qalQVIPpV=
5U7Q15uVg1ZFFtzvs3xqXFmT6RFiUISksUGAOocSFR0Q8clWMzffjF0cZCeb5/JX6aSZ5bYl7Q5=
FYjVUKbxN4RxMk2pyAJwMGTTyD7O8px+dG5ClEKYCBBKpfo9SMdBIqFEq7pRBrMc1zGTnaV/Y/r=
19BJ33Jq6oa+k5PaS3Jh1yrLnA+URxns4jBeuAqnCB7Y809tig4W4S8VIsy31b/VlspO1R/ttaA=
wuDFLYaYPS15DAB0I9ETJzF4kk8ttuHFPc/jgDXvpOGy8ZdM3L1Vq
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:46.4555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 194a5219-e203-4dc0-b9e3-08dc5=
04411c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDE.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9224
Return-Path: linux-crypto+bounces-3091-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:01:18.5360
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: a3d8c1eb-4e9d-4367-e514-08dc=
504424cf
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33466.838|SMR=3D0.128(SMRDE=3D0.004|SMRC=3D0.=
123(SMRCL=3D0.104|X-SMRCR=3D0.123))|CAT=3D0.061(CATRESL=3D0.024
 (CATRESLP2R=3D0.004)|CATORES=3D0.034(CATRS=3D0.034(CATRS-Index Routing
 Agent=3D0.033)))|QDM=3D11396.107
 |SMSC=3D0.015|SMS=3D2.770(SMSMBXD-INC=3D2.764)|QDM=3D21134.642|SMSC=3D0.52=
9(X-SMSDR=3D0.013)|SMS=3D5.654
 (SMSMBXD-INC=3D5.162)|QDM=3D921.790|PSC=3D0.023|CAT=3D0.013(CATRESL=3D0.01=
2(CATRESLP2R=3D0.008
 ))|QDM=3D5.350|CAT=3D0.007(CATRESL=3D0.006(CATRESLP2R=3D0.004));2024-03-30=
T08:19:05.386Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 15811
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.011|SMR=3D0.004(SMRPI=3D0.002(SMRPI-FrontendProxyAgent=3D0.002))=
|SMS=3D0.006
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAawIAAAPAAADH4sIAAAAAAAEAM1XeW/b=
RhYf6rZi2c3ppP
 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
 /XV9l9OS6wVUlwJ5a+lZDxfjytlLUHM+mLbKWSFhemLEKTT1hUclnG
 skpOpkmOw7DIhH5HCZX5LQQ2F6hU0+weENyceo2LsHs7yB1VaxlWbg
 UEUAsZZAnp17LsmwxxxbOWLDke5Nxc4sqzWWZr15QTsbC8yMJ4Bu/T
 +0EasZSgIm7Y1pxh32IAFUgWBkoGjc69nCwiWCTib+eFJ8m/ruN3Iy
 5cw/G/SMcji+h1Di0EeGRzWCaAh+VFKJIQuhVAiMocwEOq2WoWvcil
 /WM2J+3JYwvIxILDbqXRcjkOO8XdsA0BLyAzE8up7CNrKTKgNA1LNk
 DvUhixoOOEWw8y6BecOQVqTGC5FJ6X7YmaCJRYJqBfo3bznczdGgkE
 e6hkVsmXe1RNuT+tqDPQu2U3UVLTsTxFg2zS0XozTV7c8P1akelepi
 kkKD69JYkDoK5MjwKlOK/RP0aU/CpLAaXfjiO5oJiAJZD6lZBgJinx
 00a6ectnTKidfDou6nbkCkGLEJnb/q1GKZC18p2icz6N4/8ADIO3n9
 kZAAABAtwCPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRm
 LTE2Ij8+DQo8VGFza1NldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1
 ZlcnNpb24+DQogIDxUYXNrcz4NCiAgICA8VGFzayBTdGFydEluZGV4
 PSIzMjYiPg0KICAgICAgPFRhc2tTdHJpbmc+T24gVk1FWElULCB2ZX
 JpZnkgdGhhdCB0aGUgR0hDQiBHUEEgbWF0Y2hlcyB3aXRoIHRoZSBy
 ZWdpc3RlcmVkIHZhbHVlLjwvVGFza1N0cmluZz4NCiAgICAgIDxBc3
 NpZ25lZXM+DQogICAgICAgIDxFbWFpbFVzZXIgSWQ9Imt2bUB2Z2Vy
 Lmtlcm5lbC5vcmciIC8+DQogICAgICA8L0Fzc2lnbmVlcz4NCiAgIC
 A8L1Rhc2s+DQogIDwvVGFza3M+DQo8L1Rhc2tTZXQ+AQrDAzw/eG1s
 IHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYW
 lsU2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAg
 PEVtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMjEiPg0KIC
 AgICAgPEVtYWlsU3RyaW5nPmJyaWplc2guc2luZ2hAYW1kLmNvbTwv
 RW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwgU3
 RhcnRJbmRleD0iNTMzIiBQb3NpdGlvbj0iT3RoZXIiPg0KICAgICAg
 PEVtYWlsU3RyaW5nPmFzaGlzaC5rYWxyYUBhbWQuY29tPC9FbWFpbF
 N0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxFbWFpbCBTdGFydElu
 ZGV4PSI1ODUiIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW1haW
 xTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3RyaW5n
 Pg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxzPg0KPC9FbWFpbFNldD
 4BDOIEPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2
 Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1
 ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgICA8Q29udGFjdCBTdGFy
 dEluZGV4PSI2Ij4NCiAgICAgIDxQZXJzb24gU3RhcnRJbmRleD0iNi
 I+DQogICAgICAgIDxQZXJzb25TdHJpbmc+QnJpamVzaCBTaW5naDwv
 UGVyc29uU3RyaW5nPg0KICAgICAgPC9QZXJzb24+DQogICAgICA8Qn
 VzaW5lc3MgU3RhcnRJbmRleD0iNTEiPg0KICAgICAgICA8QnVzaW5l
 c3NTdHJpbmc+U05QPC9CdXNpbmVzc1N0cmluZz4NCiAgICAgIDwvQn
 VzaW5lc3M+DQogICAgICA8RW1haWxzPg0KICAgICAgICA8RW1haWwg
 U3RhcnRJbmRleD0iMjEiPg0KICAgICAgICAgIDxFbWFpbFN0cmluZz
 5icmlqZXNoLnNpbmdoQGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAg
 ICAgICA8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogICAgICA8Q2
 9udGFjdFN0cmluZz5CcmlqZXNoIFNpbmdoICZsdDticmlqZXNoLnNp
 bmdoQGFtZC5jb20mZ3Q7DQoNClNFVi1TTlA8L0NvbnRhY3RTdHJpbm
 c+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRhY3RzPg0KPC9Db250
 YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvciwxMCwyO1JldHJpZX
 Zlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEw
 LDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcm
 Vha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDI7UG9zdFdvcmRCcmVh
 a2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdG VyUHJvZHVjZXIsMjAsM=
TI=3D
X-MS-Exchange-Forest-IndexAgent: 1 3863
X-MS-Exchange-Forest-EmailMessageHash: 2FF00194
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:93/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
=20
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d6c030091c2..b882f72a940a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3474,6 +3474,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn =3D get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa =3D gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3537,6 +3557,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
=20
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa=
)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n"=
, ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret =3D sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a3c190642c57..bb04d63012b4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -208,6 +208,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
=20
 struct vcpu_svm {
@@ -361,6 +363,11 @@ static __always_inline bool sev_snp_guest(struct kvm *=
kvm)
 #endif
 }
=20
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa =3D=3D val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean =3D 0;
--=20
2.25.1




