Return-Path: <kvm+bounces-13227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F7E8934D5
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 672AEB2386A
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BAD14F114;
	Sun, 31 Mar 2024 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NL8k2ZOj"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8914814D2BA;
	Sun, 31 Mar 2024 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903584; cv=fail; b=DksprwQOdwjGfdGr6ifJerUZKeCF83LtWAtXqPCKzIfeYCDqA/nPZpIiQNNAVxFnoIRKkaaZ4VYoKGBfhO73wtj0RTLJ5p57E+6XGBYzroKniWFamIRSijp1SOwTuM/bJ3IcqOrBP5G9YtdDNIRxlUiX4i6o7KEIt3rO+wmWgxU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903584; c=relaxed/simple;
	bh=nUT/f1Cp7ckwyC0QlvTwgt4NjJ/r8jtuZg+G0aTw1+Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BM9ruZUGXY6JxR/2H36hD79TvJVnIKkuqUFH5uhY2cyoAf7GgzXVXMX/zJI3u13upuwigplglFMOhdHahbF7N5Ik3uABYc9Zkhg/tP8f7urX2osD/jp9/L1YLfOD2GuYz/mjTFOSiJsPhcj2SUC//p5tLCwAdpkRxPP6zvvelEM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NL8k2ZOj reason="signature verification failed"; arc=fail smtp.client-ip=40.107.220.70; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 1E405208DE;
	Sun, 31 Mar 2024 18:46:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MWQljU0CMnve; Sun, 31 Mar 2024 18:46:16 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2002920851;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2002920851
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 2E32D80005D;
	Sun, 31 Mar 2024 18:40:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:29 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13141-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoALEqmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q291bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGIACgBoAAAAzooAAAUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 20502
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13141-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 7A98D20885
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753753; cv=fail; b=kR13X/WMVNzPClFF2E7tkBuctYgqkIkEGowlcxk9RTDxWbcJgQMttFueBbGt8TOLErTSgQDwsKCiUBD+Avkze0lp+vf9e5IBTvmaonHFCRNU3yRIzx/beiQWscO/1opt/sbsw7w2ImvERq4+OI04ov7Y0mYJKyAE8RjzPPcztL0=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753753; c=relaxed/simple;
	bh=aLomTrf9SIDzLw2oNU94EpYWwTJyeQCX+3O0wOuvZrw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bx5Pfr6ifQtre0jbNL7J7tzooYFXiHtHEYdR1A/ZOC9wcpAO0FfcMHcRUo4OcVfcctoPVyxSfC9dr365lTg438Dh2Yjl0BMrDJ+UugSP/LXYA6uf+nwW7MAJ9x0H6M5QOeh2mPqmQaO8l1/tMoTkHHknk23T+kx9v32XYC5CwA4=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NL8k2ZOj; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nbwxo/Sfivyq+9sO+Uznd9brSOnWNxXcV/DSzxeV3OCOxzLguphA5mwUjBAt2UrCmoORo1BqNrDMnuYfh/MF1YixNeTiqS4uLKx+xeDuYf7lWzutLEp5+iXTVJ3PerO0wgktFP4rPpyPwRq4gvlNZHNcwz/Qiuna5sB6SWGz30Munst0AcJQu2DRXSuGQdzJ5CSoF3CE8TOjA7fdjFqH+SOSdFBlw/jFQy1KSaRtmZNg2Vvccku9pEzqwEy2hqiRsRUBXtDpVjIGR8gAqdN7h1g+1brJ+nSJIlvMB78FEZJF6Db37MZTNzHKrzFdoUhlKfCMGIEP3EGjVx70d4fYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=;
 b=UHd+vtr6Xq17u2zj0F+54568WxjxUu7bhRq5mCiVqAsx6/8foTga+tjl6FB37Rk/gCadl8Hyu3HP6KOe5fSfj5Y+Fg39dRBHjAz+LkDwE/p7b9QgXpJOKeTbOwmgaP7p/JpmTwY1Nqoiz8gkuc38f/vi8oJOVG+10WRQIaySFA775ht8Qo/2pgPMBfyZJY213GN4vdR/iR5qCsjJdOun2gO1Zg+xAcSIliyIGrzVMp8zwNQm8m5/DpER15R9pLXzvIXFcDLLxdpW5T229/GQy6Io+7wtv/LRR8ybIPK8gX47e9g6ZPahsIgMHaTNBamhxCWajKIL9jB5YDunqwETdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=;
 b=NL8k2ZOjyllNv+BOhVsE+g+IY9SqGG/lRFiTHc46v7vYp9YB1ZOFvfFW11KaMWRZiaDNeCtZP14EUp1sh69rwCeBGAG4rBmL3K9cyXTXacg+KZVRTaGkGnXJhEbk7k13iM3BRcde4JuhCfSqIQ/S4H99TNgMKSadIOFKe8MQhRA=
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
Subject: [PATCH v12 08/29] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date: Fri, 29 Mar 2024 17:58:14 -0500
Message-ID: <20240329225835.400662-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d39520-d208-4b29-8abb-08dc50453d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPJJMbGne+4Z7fo2ps/HjPCqG7bRgNidjM1ZY+1yitblxsXSb7RLE90onCSoEFFNkqjOFmuL0DAFztxDlmYQO7LS43j1B48JN4+zzmFjlGxNq9LMfh9nLkkAhsjxBnumc9RHFUScsxJ5flbRuNHvptWFgmjWLGHblCsrQ5ws44oFgH6W/IjvWf5A4ndelWHVsCITNwvX6X8Kd3hN/rGI1lOgyybomh2O9voSPI/RHL7EHdPkGa+pQvh8yN/Vg/lvCiZi+GuOn4IX+kP+Jge4s+pD2YyTc4hLE7og5UCEKhTo2P8jlLMSjitfIudLg0RlJEifdIO8fNepV/TyXcZfkARMjpO+iE33F39IQ0gjqMWKoeYD2ZmylzVo9OwFOVy2yGlcld/c7tNynBIYOZ/L97PWpgNBdt+Fm6bF1FN2xz7RatfW8/n6BHecKsgV/jPiO8RK2SbHSWdk16YwT3fsy1IOF2f0Z7ZYZAhd1nWvTqvuM5dlljvuPNLjqQQOdJerpwVL4SiBnzvUcGkcuFrKYQRMbuZk6qM2GnzZuhNhX5Mu7pHHf2Tkt4fAdxTaV54HvFmZHbqDdahOzL1aeCLTwZR0oIVO2P7q6ApKbDWAWnN4h6xD51MxqDqfYDv7Zn2PhatmT4TadKNLuLizp8WwHtrjagUpkCF8R3PvGtCuquyvZ2/qwwem+SQDEAlUGOjsE57NiBsL3HIgAz+SF8/ah1bngLS3OL1m+xagVdtqbBkC+XsgalTf2abReXgYnKlh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:09:09.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d39520-d208-4b29-8abb-08dc50453d6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7f5faa0d4d4f..1e65f5634ad3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,9 +33,11 @@
 #include "cpuid.h"
 #include "trace.h"
=20
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
=20
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled =3D true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2692,6 +2694,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -2952,6 +2955,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3076,6 +3085,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret =3D 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1


X-sender: <linux-crypto+bounces-3115-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DDwA1AAAATWljcm9zb2Z0LkV4Y2hhb=
mdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA=
8MUJLbkECUOS0gjaDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGw=
AAgAABQBYABcASgAAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZX=
JzLE9VPU1pZ3JhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoALEqmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAZwAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 20811
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:09:47 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:09:47 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 6A13C208A3
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:47 +0100 (CET)
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
	with ESMTP id cXZH-uO4Iu2A for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:09:43 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3115-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 9851B20754
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 9851B20754
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32BB01F21685
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FCD13E40E;
	Fri, 29 Mar 2024 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"NL8k2ZOj"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11=
on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB113D248;
	Fri, 29 Mar 2024 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.220.70
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753753; cv=3Dfail; b=3DkR13X/WMVNzPClFF2E7tkBuctYgqkIkEGowlcxk9RTD=
xWbcJgQMttFueBbGt8TOLErTSgQDwsKCiUBD+Avkze0lp+vf9e5IBTvmaonHFCRNU3yRIzx/bei=
QWscO/1opt/sbsw7w2ImvERq4+OI04ov7Y0mYJKyAE8RjzPPcztL0=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753753; c=3Drelaxed/simple;
	bh=3DaLomTrf9SIDzLw2oNU94EpYWwTJyeQCX+3O0wOuvZrw=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3Dbx5Pfr6ifQtre0jbNL7J7tzooYFXiHtHEYdR1A/ZOC=
9wcpAO0FfcMHcRUo4OcVfcctoPVyxSfC9dr365lTg438Dh2Yjl0BMrDJ+UugSP/LXYA6uf+nwW7=
MAJ9x0H6M5QOeh2mPqmQaO8l1/tMoTkHHknk23T+kx9v32XYC5CwA4=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DNL8k2ZOj; arc=3Dfail smtp.client-ip=3D40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DNbwxo/Sfivyq+9sO+Uznd9brSOnWNxXcV/DSzxeV3OCOxzLguphA5mwUjBAt2UrCmoORo1=
BqNrDMnuYfh/MF1YixNeTiqS4uLKx+xeDuYf7lWzutLEp5+iXTVJ3PerO0wgktFP4rPpyPwRq4g=
vlNZHNcwz/Qiuna5sB6SWGz30Munst0AcJQu2DRXSuGQdzJ5CSoF3CE8TOjA7fdjFqH+SOSdFBl=
w/jFQy1KSaRtmZNg2Vvccku9pEzqwEy2hqiRsRUBXtDpVjIGR8gAqdN7h1g+1brJ+nSJIlvMB78=
FEZJF6Db37MZTNzHKrzFdoUhlKfCMGIEP3EGjVx70d4fYTA=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DJyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=3D;
 b=3DUHd+vtr6Xq17u2zj0F+54568WxjxUu7bhRq5mCiVqAsx6/8foTga+tjl6FB37Rk/gCadl8=
Hyu3HP6KOe5fSfj5Y+Fg39dRBHjAz+LkDwE/p7b9QgXpJOKeTbOwmgaP7p/JpmTwY1Nqoiz8gku=
c38f/vi8oJOVG+10WRQIaySFA775ht8Qo/2pgPMBfyZJY213GN4vdR/iR5qCsjJdOun2gO1Zg+x=
AcSIliyIGrzVMp8zwNQm8m5/DpER15R9pLXzvIXFcDLLxdpW5T229/GQy6Io+7wtv/LRR8ybIPK=
8gX47e9g6ZPahsIgMHaTNBamhxCWajKIL9jB5YDunqwETdA=3D=3D
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
 bh=3DJyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=3D;
 b=3DNL8k2ZOjyllNv+BOhVsE+g+IY9SqGG/lRFiTHc46v7vYp9YB1ZOFvfFW11KaMWRZiaDNeC=
tZP14EUp1sh69rwCeBGAG4rBmL3K9cyXTXacg+KZVRTaGkGnXJhEbk7k13iM3BRcde4JuhCfSqI=
Q/S4H99TNgMKSadIOFKe8MQhRA=3D
Received: from DS7PR05CA0081.namprd05.prod.outlook.com (2603:10b6:8:57::6) =
by
 SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with Micros=
oft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA=
384) id
 15.20.7409.40; Fri, 29 Mar 2024 23:09:09 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:8:57:cafe::63) by DS7PR05CA0081.outlook.office365.com
 (2603:10b6:8:57::6) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.17 via Front=
end
 Transport; Fri, 29 Mar 2024 23:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:09:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:09:08 -0500
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
Subject: [PATCH v12 08/29] KVM: SEV: Add GHCB handling for Hypervisor Featu=
re Support requests
Date: Fri, 29 Mar 2024 17:58:14 -0500
Message-ID: <20240329225835.400662-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d39520-d208-4b29-8abb-08dc50453d=
6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPJJMbGne+4Z7fo2ps/HjPCqG7bRgNidjM1ZY+1y=
itblxsXSb7RLE90onCSoEFFNkqjOFmuL0DAFztxDlmYQO7LS43j1B48JN4+zzmFjlGxNq9LMfh9=
nLkkAhsjxBnumc9RHFUScsxJ5flbRuNHvptWFgmjWLGHblCsrQ5ws44oFgH6W/IjvWf5A4ndelW=
HVsCITNwvX6X8Kd3hN/rGI1lOgyybomh2O9voSPI/RHL7EHdPkGa+pQvh8yN/Vg/lvCiZi+GuOn=
4IX+kP+Jge4s+pD2YyTc4hLE7og5UCEKhTo2P8jlLMSjitfIudLg0RlJEifdIO8fNepV/TyXcZf=
kARMjpO+iE33F39IQ0gjqMWKoeYD2ZmylzVo9OwFOVy2yGlcld/c7tNynBIYOZ/L97PWpgNBdt+=
Fm6bF1FN2xz7RatfW8/n6BHecKsgV/jPiO8RK2SbHSWdk16YwT3fsy1IOF2f0Z7ZYZAhd1nWvTq=
vuM5dlljvuPNLjqQQOdJerpwVL4SiBnzvUcGkcuFrKYQRMbuZk6qM2GnzZuhNhX5Mu7pHHf2Tkt=
4fAdxTaV54HvFmZHbqDdahOzL1aeCLTwZR0oIVO2P7q6ApKbDWAWnN4h6xD51MxqDqfYDv7Zn2P=
hatmT4TadKNLuLizp8WwHtrjagUpkCF8R3PvGtCuquyvZ2/qwwem+SQDEAlUGOjsE57NiBsL3HI=
gAz+SF8/ah1bngLS3OL1m+xagVdtqbBkC+XsgalTf2abReXgYnKlh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:09:09.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d39520-d208-4b29-8abb-08dc5=
0453d6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017095.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978
Return-Path: linux-crypto+bounces-3115-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:09:47.4556
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: be074336-b920-45be-dce4-08dc=
50455426
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D32957.839|SMR=3D0.134(SMRDE=3D0.004|SMRC=3D0.=
129(SMRCL=3D0.104|X-SMRCR=3D0.129))|CAT=3D0.056(CATRESL=3D0.026
 (CATRESLP2R=3D0.004)|CATORES=3D0.028(CATRS=3D0.027(CATRS-Index Routing
 Agent=3D0.026)))|QDM=3D14254.126
 |SMSC=3D0.604(X-SMSDR=3D0.027)|SMS=3D5.888(SMSMBXD-INC=3D5.338)|UNK=3D0.00=
1|QDM=3D18691.859|UNK=3D0.008
 |CAT=3D0.007(CATRESL=3D0.005(CATRESLP2R=3D0.003))|QDM=3D5.389|UNK=3D0.004|=
CAT=3D0.011(CATRESL=3D0.010
 (CATRESLP2R=3D0.008));2024-03-30T08:19:05.323Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 14673
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.028|SMR=3D0.026(SMRPI=3D0.024(SMRPI-FrontendProxyAgent=3D0.024))=
|SMS=3D0.002
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAREHAAAPAAADH4sIAAAAAAAEAJVWDXPa=
RhA9GSQwNrGbpn
 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
 MDPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij8+
 DQo8RW1haWxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW
 9uPg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydEluZGV4PSIy
 MSI+DQogICAgICA8RW1haWxTdHJpbmc+YnJpamVzaC5zaW5naEBhbW
 QuY29tPC9FbWFpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxF
 bWFpbCBTdGFydEluZGV4PSIzNTMiIFBvc2l0aW9uPSJPdGhlciI+DQ
 ogICAgICA8RW1haWxTdHJpbmc+YXNoaXNoLmthbHJhQGFtZC5jb208
 L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIF
 N0YXJ0SW5kZXg9IjQwNSIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAg
 IDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haW
 xTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgPC9FbWFpbHM+DQo8L0Vt
 YWlsU2V0PgEM8AM8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPS
 J1dGYtMTYiPz4NCjxDb250YWN0U2V0Pg0KICA8VmVyc2lvbj4xNS4w
 LjAuMDwvVmVyc2lvbj4NCiAgPENvbnRhY3RzPg0KICAgIDxDb250YW
 N0IFN0YXJ0SW5kZXg9IjYiPg0KICAgICAgPFBlcnNvbiBTdGFydElu
 ZGV4PSI2Ij4NCiAgICAgICAgPFBlcnNvblN0cmluZz5CcmlqZXNoIF
 NpbmdoPC9QZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCiAg
 ICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4PS
 IyMSI+DQogICAgICAgICAgPEVtYWlsU3RyaW5nPmJyaWplc2guc2lu
 Z2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haW
 w+DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5n
 PkJyaWplc2ggU2luZ2ggJmx0O2JyaWplc2guc2luZ2hAYW1kLmNvbT
 wvQ29udGFjdFN0cmluZz4NCiAgICA8L0NvbnRhY3Q+DQogIDwvQ29u
 dGFjdHM+DQo8L0NvbnRhY3RTZXQ+AQ7PAVJldHJpZXZlck9wZXJhdG
 9yLDEwLDE7UmV0cmlldmVyT3BlcmF0b3IsMTEsMTtQb3N0RG9jUGFy
 c2VyT3BlcmF0b3IsMTAsMDtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMT
 EsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTAs
 MjtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTEsMD
 tUcmFuc3BvcnRXcml0ZXJQcm9kdWNlciwyMCwxMg=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 2986
X-MS-Exchange-Forest-EmailMessageHash: CCFFC75B
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:17/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7f5faa0d4d4f..1e65f5634ad3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,9 +33,11 @@
 #include "cpuid.h"
 #include "trace.h"
=20
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
=20
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled =3D true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2692,6 +2694,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -2952,6 +2955,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3076,6 +3085,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret =3D 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1


X-sender: <linux-kernel+bounces-125522-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
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
X-ExtendedProps: BQBjAAoALEqmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAaQAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 20967
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:09:58 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:09:58 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id BCBC82032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:58 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7CkFeF-s7pGb for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:09:57 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125522-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 40C82200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"NL8k2ZOj"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 40C82200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E6F1C21084
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C82313FD71;
	Fri, 29 Mar 2024 23:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"NL8k2ZOj"
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11=
on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB113D248;
	Fri, 29 Mar 2024 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.220.70
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753753; cv=3Dfail; b=3DkR13X/WMVNzPClFF2E7tkBuctYgqkIkEGowlcxk9RTD=
xWbcJgQMttFueBbGt8TOLErTSgQDwsKCiUBD+Avkze0lp+vf9e5IBTvmaonHFCRNU3yRIzx/bei=
QWscO/1opt/sbsw7w2ImvERq4+OI04ov7Y0mYJKyAE8RjzPPcztL0=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753753; c=3Drelaxed/simple;
	bh=3DaLomTrf9SIDzLw2oNU94EpYWwTJyeQCX+3O0wOuvZrw=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3Dbx5Pfr6ifQtre0jbNL7J7tzooYFXiHtHEYdR1A/ZOC=
9wcpAO0FfcMHcRUo4OcVfcctoPVyxSfC9dr365lTg438Dh2Yjl0BMrDJ+UugSP/LXYA6uf+nwW7=
MAJ9x0H6M5QOeh2mPqmQaO8l1/tMoTkHHknk23T+kx9v32XYC5CwA4=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DNL8k2ZOj; arc=3Dfail smtp.client-ip=3D40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DNbwxo/Sfivyq+9sO+Uznd9brSOnWNxXcV/DSzxeV3OCOxzLguphA5mwUjBAt2UrCmoORo1=
BqNrDMnuYfh/MF1YixNeTiqS4uLKx+xeDuYf7lWzutLEp5+iXTVJ3PerO0wgktFP4rPpyPwRq4g=
vlNZHNcwz/Qiuna5sB6SWGz30Munst0AcJQu2DRXSuGQdzJ5CSoF3CE8TOjA7fdjFqH+SOSdFBl=
w/jFQy1KSaRtmZNg2Vvccku9pEzqwEy2hqiRsRUBXtDpVjIGR8gAqdN7h1g+1brJ+nSJIlvMB78=
FEZJF6Db37MZTNzHKrzFdoUhlKfCMGIEP3EGjVx70d4fYTA=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DJyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=3D;
 b=3DUHd+vtr6Xq17u2zj0F+54568WxjxUu7bhRq5mCiVqAsx6/8foTga+tjl6FB37Rk/gCadl8=
Hyu3HP6KOe5fSfj5Y+Fg39dRBHjAz+LkDwE/p7b9QgXpJOKeTbOwmgaP7p/JpmTwY1Nqoiz8gku=
c38f/vi8oJOVG+10WRQIaySFA775ht8Qo/2pgPMBfyZJY213GN4vdR/iR5qCsjJdOun2gO1Zg+x=
AcSIliyIGrzVMp8zwNQm8m5/DpER15R9pLXzvIXFcDLLxdpW5T229/GQy6Io+7wtv/LRR8ybIPK=
8gX47e9g6ZPahsIgMHaTNBamhxCWajKIL9jB5YDunqwETdA=3D=3D
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
 bh=3DJyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=3D;
 b=3DNL8k2ZOjyllNv+BOhVsE+g+IY9SqGG/lRFiTHc46v7vYp9YB1ZOFvfFW11KaMWRZiaDNeC=
tZP14EUp1sh69rwCeBGAG4rBmL3K9cyXTXacg+KZVRTaGkGnXJhEbk7k13iM3BRcde4JuhCfSqI=
Q/S4H99TNgMKSadIOFKe8MQhRA=3D
Received: from DS7PR05CA0081.namprd05.prod.outlook.com (2603:10b6:8:57::6) =
by
 SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with Micros=
oft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA=
384) id
 15.20.7409.40; Fri, 29 Mar 2024 23:09:09 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:8:57:cafe::63) by DS7PR05CA0081.outlook.office365.com
 (2603:10b6:8:57::6) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.17 via Front=
end
 Transport; Fri, 29 Mar 2024 23:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:09:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:09:08 -0500
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
Subject: [PATCH v12 08/29] KVM: SEV: Add GHCB handling for Hypervisor Featu=
re Support requests
Date: Fri, 29 Mar 2024 17:58:14 -0500
Message-ID: <20240329225835.400662-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d39520-d208-4b29-8abb-08dc50453d=
6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPJJMbGne+4Z7fo2ps/HjPCqG7bRgNidjM1ZY+1y=
itblxsXSb7RLE90onCSoEFFNkqjOFmuL0DAFztxDlmYQO7LS43j1B48JN4+zzmFjlGxNq9LMfh9=
nLkkAhsjxBnumc9RHFUScsxJ5flbRuNHvptWFgmjWLGHblCsrQ5ws44oFgH6W/IjvWf5A4ndelW=
HVsCITNwvX6X8Kd3hN/rGI1lOgyybomh2O9voSPI/RHL7EHdPkGa+pQvh8yN/Vg/lvCiZi+GuOn=
4IX+kP+Jge4s+pD2YyTc4hLE7og5UCEKhTo2P8jlLMSjitfIudLg0RlJEifdIO8fNepV/TyXcZf=
kARMjpO+iE33F39IQ0gjqMWKoeYD2ZmylzVo9OwFOVy2yGlcld/c7tNynBIYOZ/L97PWpgNBdt+=
Fm6bF1FN2xz7RatfW8/n6BHecKsgV/jPiO8RK2SbHSWdk16YwT3fsy1IOF2f0Z7ZYZAhd1nWvTq=
vuM5dlljvuPNLjqQQOdJerpwVL4SiBnzvUcGkcuFrKYQRMbuZk6qM2GnzZuhNhX5Mu7pHHf2Tkt=
4fAdxTaV54HvFmZHbqDdahOzL1aeCLTwZR0oIVO2P7q6ApKbDWAWnN4h6xD51MxqDqfYDv7Zn2P=
hatmT4TadKNLuLizp8WwHtrjagUpkCF8R3PvGtCuquyvZ2/qwwem+SQDEAlUGOjsE57NiBsL3HI=
gAz+SF8/ah1bngLS3OL1m+xagVdtqbBkC+XsgalTf2abReXgYnKlh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:09:09.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d39520-d208-4b29-8abb-08dc5=
0453d6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017095.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978
Return-Path: linux-kernel+bounces-125522-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:09:58.8447
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 4bfd1f17-8b2c-43a3-0021-08dc=
50455af1
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D32946.495|SMR=3D0.133(SMRDE=3D0.004|SMRC=3D0.=
128(SMRCL=3D0.102|X-SMRCR=3D0.126))|CAT=3D0.062(CATOS=3D0.001
 |CATRESL=3D0.028(CATRESLP2R=3D0.005)|CATORES=3D0.029(CATRS=3D0.029(CATRS-T=
ransport
 Rule Agent=3D0.001 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.027))|CATORT=3D0.001(CATRT=3D0.001))|UNK=3D0.001
 |QDM=3D14242.901|SMSC=3D0.451|SMS=3D5.884(SMSMBXD-INC=3D5.333)|UNK=3D0.001=
|QDM=3D18691.862|UNK=3D0.006
 |CAT=3D0.011(CATRESL=3D0.010(CATRESLP2R=3D0.007))|QDM=3D5.399|CAT=3D0.033(=
CATRESL=3D0.031(CATRESLP2R=3D0.028
 ));2024-03-30T08:19:05.352Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 14755
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.011|SMR=3D0.009(SMRPI=3D0.006(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.002
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAREHAAAPAAADH4sIAAAAAAAEAJVWDXPa=
RhA9GSQwNrGbpn
 HSTqc3TtMBmy9hwF+JJ06DYzcGU8BMZpqORqDDqEESlQRxpum/6Q/t
 3h0yAoTtaDzibu/d3t7btyv/9/TEtowD/NrW/yJODzd086qHX7T5NO
 PQ6SvV0DIdyziKx+KxFrEd3TJxHltd7PYIfnv662vsDEhH7+od1aVr
 uunaljbsEA2r2ojYru4Qg5gu3dIlqju0iROPuT3VxapNsDMcDCzbBX
 T7M3N5+nlA7JHuWHaGHlm1PmEGfteqeGAHj+4OJIXbQ2NAF+MxQ73W
 jaHhO2xgW67VsfqeJ3ZWQ78yiZa2ut10+/O9aZnZdez0dNj0Tu3bKn
 6hslnmI50t3lPROz2V9HHdcuEgg88yEKL/nHQ6HY8BZ51e9nqvlNXN
 Tn+okazqGFmHjNIAMuAePfwFAy3b237sxxFgRgyX6WDf8wXLJcBOPf
 SUPO7qfeJgCMS8IloKy7uQWIdm0zKdxHYSLFgjfULniXSSsqfp3S5O
 p690SGz27jDbd2PiMd3UyDXOyfmS3N3NFQuqlskU1b18oaRpxZ18F8
 u5XKlQYOTc59R4DC54v6NfvcJpOSengB/6s4fBQEwQ0cDpKNYA/wM0
 Zbe48CaaxSdc4rhO/h4Sx83WiTMAygjeysKGZxrp6iaXq1Jp1JXTln
 LSVOrl3/1Zwbnr3F7uNnijNguX4WoL4LWLxpR3Ob8YWzluvPNj35ar
 1KRcnp8ninIK55K3h6W0js8ToyQOej7A1vEzJu6N6qp/lHYO5PyfwE
 /gprmtiURiWCok6SG/TIVX2gFR5pNJfHREfxcJcroW2gsWPOntdotd
 Vc1pBa3QzWRkUip2i6Ud0OHOIunNuJnR28wqFdnOTmofb8NblkFjlN
 6xKPFmZzDUtUxvc8ro2mqHMCOcPZWKVrneOLuoQhLfe6kGYmaTPY/K
 MxQORp1Vp3zNeuOpb1zWahf1ZvkNlYzPXK0BnhcKMdV2n2Q13aG/uF
 Fuee2Yl4bjQtuGhFjQlIEdheM1/BK79pAcAsKAz0qfKAPVVg3FVA2i
 JQCY8qNTbD/ItFAoJA85v/nSfp5WMfwWUru0jMdHwZeK73WUkdrXNd
 Ulysi4Ite6m3Dg0I6LR5ABBfKFt+CVnIiwo0JFN1oVpVV5W35/1lSO
 a8rpeVM5v7ioHdwO++2yUlOax6/Py7cBL6s3lCrlVrnaBPD2IjAlu3
 zcvIQC9Pn0nrZN1I+HEztkTx323QAkAB34qL7kKSzX68pZFer5bByC
 x+d+kfO5Xyym5HwAofDR0Po3XCqGYyve9/YuYhc/N83mrHpywfpU6u
 u3QStMHi6maIrh+R7ty4H3OMRVrnqdNrtkW3edBNwnFVgaqfndt4Q7
 acepgH6ePPy6UKab9NdFMuE7mMxZV7N6myazWa5XGJfsAzrzQGMfi1
 CB26S8ccfSaAMYt8vcbonKbye3V+Qtc4HuPKlBy1Wo3PAWfQdozSYu
 aF6+RRfe/N97F+EsKSwxNEPOJ4UVhW52LSVPU5Q+4k0oQzHB0mE0zz
 udBH6vHNzVX2Zvz2p0aOrGoJ+g4zvqbXPM+wEempN/tMmI/u+fxpNL
 yy+fP+v3r1M+U56bPpibKfo9jcfymXwxI9OUx2MIhZEUQVERRSIC+o
 4OpBAKh1A0IkQFhAS0tIRCYAkjMY4exNAKvMESRTGwgH0ZxTgghtY4
 DN5RtBy0fY2tinAc7KIYtCoJKI4iAFhC4aAwJD9AQhEAgOURHQQAwA
 O9DgVEeSQhtMoHsESnAooxP4IgsvAiHmz8JwhrSwgtCY958CL1tkwt
 KBQT1rgxSi9CT4RxsHNwsHApBD5X0YNVIS4hJKHVxcjIwiVBCkPi+B
 WEpckYiRQvgFtggyYI8gV74Q9iho0Q8UPmEK7D8rIuomVu/9ZnD/vs
 U3hhnVEhBW6BcFcgTiHMCAyzeMbIjSmkyKh7HuXECiHmMwvCgPhnnL
 B3lAHEGc4nKfOx7TMu5NmHiQQYBdAVCvH4hSU+ZgGAXJfBp0DrhQ+i
 /HbrTNIhSvh9LDFueYRETsgySFRAD7wpKBYAPOMRFJe4RCktMGUOaV
 Ko/lkJ3Cwth8eqWBERUCnx+CdjJEqMwBBNR5iVMNxoHF6UFWYIPeBn
 bTDJeZW7xo1PPSNMRbTOjT8y4wpavbHc7I2iH8AYQd9LNDb02FOyGB
 Thja54hD8xnXMSop4UvSATN7IMU1UkYfqNNw2hDR7JnNQfhyhs3KB4
 I5rOQmZO0tKck41AJ9O7ktPhSYvC8xmfwECi1Q3XFyWaULjv6iKWOE
 UPPYooaZScMD2LRsjT/UhEP8xnxF+MLAzeN5ZCk74xvriPGezzOZ/3
 J2EasMiE+jPokBmj3Oj5D3Oipi1Qa8v8drwP0PH/NWsYEDYTAAABCs
 MDPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij8+
 DQo8RW1haWxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW
 9uPg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydEluZGV4PSIy
 MSI+DQogICAgICA8RW1haWxTdHJpbmc+YnJpamVzaC5zaW5naEBhbW
 QuY29tPC9FbWFpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxF
 bWFpbCBTdGFydEluZGV4PSIzNTMiIFBvc2l0aW9uPSJPdGhlciI+DQ
 ogICAgICA8RW1haWxTdHJpbmc+YXNoaXNoLmthbHJhQGFtZC5jb208
 L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIF
 N0YXJ0SW5kZXg9IjQwNSIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAg
 IDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haW
 xTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgPC9FbWFpbHM+DQo8L0Vt
 YWlsU2V0PgEM8AM8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPS
 J1dGYtMTYiPz4NCjxDb250YWN0U2V0Pg0KICA8VmVyc2lvbj4xNS4w
 LjAuMDwvVmVyc2lvbj4NCiAgPENvbnRhY3RzPg0KICAgIDxDb250YW
 N0IFN0YXJ0SW5kZXg9IjYiPg0KICAgICAgPFBlcnNvbiBTdGFydElu
 ZGV4PSI2Ij4NCiAgICAgICAgPFBlcnNvblN0cmluZz5CcmlqZXNoIF
 NpbmdoPC9QZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCiAg
 ICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4PS
 IyMSI+DQogICAgICAgICAgPEVtYWlsU3RyaW5nPmJyaWplc2guc2lu
 Z2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haW
 w+DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5n
 PkJyaWplc2ggU2luZ2ggJmx0O2JyaWplc2guc2luZ2hAYW1kLmNvbT
 wvQ29udGFjdFN0cmluZz4NCiAgICA8L0NvbnRhY3Q+DQogIDwvQ29u
 dGFjdHM+DQo8L0NvbnRhY3RTZXQ+AQ7PAVJldHJpZXZlck9wZXJhdG
 9yLDEwLDE7UmV0cmlldmVyT3BlcmF0b3IsMTEsMTtQb3N0RG9jUGFy
 c2VyT3BlcmF0b3IsMTAsMTtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMT
 EsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTAs
 MTtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMTEsMD
 tUcmFuc3BvcnRXcml0ZXJQcm9kdWNlciwyMCwxMA=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 2986
X-MS-Exchange-Forest-EmailMessageHash: CCFFC75B
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:22/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7f5faa0d4d4f..1e65f5634ad3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,9 +33,11 @@
 #include "cpuid.h"
 #include "trace.h"
=20
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
=20
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled =3D true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2692,6 +2694,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -2952,6 +2955,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3076,6 +3085,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret =3D 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1



