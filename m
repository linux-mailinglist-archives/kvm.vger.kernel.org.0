Return-Path: <kvm+bounces-13224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E869F8934CD
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9982428653E
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3130414D44A;
	Sun, 31 Mar 2024 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tsg2jqS4"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F68214C582;
	Sun, 31 Mar 2024 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903581; cv=fail; b=TVncqbv4D5rcaFOCiFhi8BQiubi1BwfQlmrBqwLutOKDVwkyB2GxgIn0hfoZCLhR7Ey5LgwCNOQMmHr5ONpZyrT8yDPvhpt7vuQM2HrGLDQhlfgB/4ouHYUgK3ZeLkrw1Lk8/jX9+diXYHlrWvpBdxPzJ1Gh66+FFyTpMTqrTcc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903581; c=relaxed/simple;
	bh=hJdGqsnuQVJsE1Betrq0SQukXK/a1Bmz9kWuq/EHvzo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pI7ydPhvgaKee6uk1ktgvFHEbaiLKrLYNPonVgbSBRKPlm6M/xSRaN/qSAVwPiTbLnn8XD2P/HjCjzvbJw258/HCdMen+mag9Z56RfXMJLrDSpNXHgEQdV1P/rkbyt8VZXg/UM0ECFha+K4Ro4jAFLCcCQgn+M0WLGGcTmn/v2k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tsg2jqS4 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.41; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id BA440208EA;
	Sun, 31 Mar 2024 18:46:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dOFXehE1P0Jf; Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 1344F2083F;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 1344F2083F
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id B29FC800057;
	Sun, 31 Mar 2024 18:40:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:20 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:43 +0000
X-sender: <kvm+bounces-13123-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q291bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGIACgAvAAAAzooAAAUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 40449
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=kvm+bounces-13123-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 890D62087D
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753381; cv=fail; b=ASgCoc4pmkz2vBzguIaJLZZVNBJMtLdJT8A1j5Gp2plNuevF713OSNn7k7u/Xh/j5x7jv9jH1DiJ3uwERThruOXukCQucQ9R8C6BHTb7FcGVSyi9jobpRzt1p3sMEWB7AWrsDnGzohE/u8V1LOrYE2kekbT8zRBwOVdw8bs5eGM=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753381; c=relaxed/simple;
	bh=KHHF/vBYV5yB+doCUDT2LqJVpn4wXbjwTAFdd/Tr7hw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+ChY87+uuO2tjKr3OWfY++p39GWLb5XEFU/ybYb8lwg0vZ9LskG3nCjTUkEAp1ui1xTIQAbcvc+gIipheM8dIptkLBE257HhTf038ApMGog29pcErKE7IM4gsVOb0kvRSpB0ymOIbwnQfmKj4CH8Z5mmMeOnuq69gMbm001NzU=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tsg2jqS4; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLYVJ2rjiBRdW+iXdllNqIZgZPbKY5JUZuXz84I0MYkGHI2+isS0se4oi/xUVAb7WCpukPlEZ4EnA/TAf/47O5YwigfjX4z64qW0n65Liq7pSTRVQbZIg6hQDzMtF5tAemszDQ9S54y77SMSCrbFO0vgBz/6K8M9xwc2D3JNhOwb1vfNLhsWvLaDKUBNwSndlN7au8+Ihklcg0z97qJpnWdvu2IkGMHsNfwxMYkX01MV0m/RciFc31h98MB/qP7LwW8yrDdBe8bgE1tqE6GfC1TjmwKVJQ6vSnqXRv9sTL0qQZa1HjoTdPMAWEWJX2El0kVFYa/Y94IWHm1Ro9ZmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYDUOsZ8oSqdDjPaR5Xc/ME9UC8/Zi2qVp0/kTJliSw=;
 b=JZR18khJWPFbqxfvnhDfSz6vzkLIVM7g+WZGEqcJXuCxovLzBVdk2SVcaEonPSC5OIgWVMSRDRTbWA1quhM5G1ZajXm5cBNlvHTLl8EiqNwjn9MefAshE6md3MR6r9r7EOfPcnn3R8XMJkwBu6c6RDoTcNKIBW07GaJ2LDup6PZSeTpFSz9nc7MxpyZf2UUtgMfj/sKbCcHkMh+66FhpJMXwTo3PBqJPKBKw8ZGizPykZT7zyqdMnXDuAfx0JXEfqvu5mQ8O4c87jxmoOywcragCJynnAOQnF/Oh99uwkrFNFpZ3JZubcu3uOGkPJAlTBu1TX3SSyBS0+fjfurKuPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYDUOsZ8oSqdDjPaR5Xc/ME9UC8/Zi2qVp0/kTJliSw=;
 b=tsg2jqS42wTV0w9yTC7xM2MdaeE+6YTCo02pkCeadOlCLdUzOWEv9Cdbny0qli+q9EOFf18R1n+DFSolN88DcIl+p17LPAZCmBMVf83MvzKXZRO89mIaSyNP3VQhPVpOuMmISAhQyrR+6eCZtW27hj4N8M0imnZzJJTqoJlBzo0=
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
Subject: [PATCH v12 19/29] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date: Fri, 29 Mar 2024 17:58:25 -0500
Message-ID: <20240329225835.400662-20-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|PH0PR12MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 551edada-c896-4c34-cb0b-08dc50445cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjuWmA2FmMrZm/Lj19E04lIhHLtbd7tQjfPwsVQo3kXbjdq069bgIoUjxkhgx8Aog4T4A3SqnXW08ioGCt1IlNphfNVzzruiUNNzLQ2rfJL4u7yg38WZSlbesKmiUQF9+h3hAMV3iEaGIMxQLMiF8/pLqaxrl2T3bnXGI1CY0ZQvFM4cb+jZsMMExqzSFSd2yrWlrsz2v7jxs5jn5GlS3RkBz46l3THP9KVizrwjINvqJ+b7q+DryORFCc74jHbXHwevPI9WRn7c2UINnUyX3Tixqx+JC3wZ53Mu2LAnGHcXCDjY2972TsOFRQ4w2Oopu/P7sFSNb82qrAEqvRiK0UgOzYkkclLrdqjoXVXXHse0DMPB7APNjMriX0HkXip3reXUbUs9eYjYKpvLIXvvDBsrodbz+GFat/Lg2ri8HqMnsu1hyGo++bXUr4Srgtv8wS9ymx6EGwKP0SXqxqrwf8sFmyAfI9ZDuoaQkiTL6hra+gLdWzsb+PrYu/GYSlTGCEKCVH9tQ+j5mGyLi48LciiqqIKfQ8gm1SAmZ5uXUVi6sLHDrFfw4Grx8QBURmbKlNX74pmxPa2UEx31cXvdta3+9GihVK3kWW9p18Tfo7ExRMJ+SbP7H7GTGs+FyDi1abkfQ0Bq0woD+mX7w/e9zlIg2s2lsNjktlMkFmns3T+H6j1u+oetS3cP19luVMG3RojbB2cOx7+b47V+AEvF5odxwKPDE6HJK3hneESmFVGYoHX92nA1oPxul0vafabD
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:52.1344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 551edada-c896-4c34-cb0b-08dc50445cac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8032
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to alter the register state of the APs on their own. This allows
the guest a way of simulating INIT-SIPI.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID. The GPA is saved in the svm struct of the
  target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to the vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID the next time an INIT is performed. The GPA is
  saved in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared
  from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
  added to vCPU and then the vCPU is kicked.

The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
as a result of the event or as a result of an INIT. If a new VMSA is to
be installed, the VMSA guest page is set as the VMSA in the vCPU VMCB
and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new VMSA is not
to be installed, the VMSA is cleared in the vCPU VMCB and the vCPU state
is set to KVM_MP_STATE_HALTED to prevent it from being run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add handling for gmem, move MP_STATE_UNINITIALIZED -> RUNNABLE
 transition to target vCPU side rather than setting vcpu->arch.mp_state
 remotely]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/svm.h      |   6 +
 arch/x86/kvm/svm/sev.c          | 217 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  11 +-
 arch/x86/kvm/svm/svm.h          |   8 ++
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 252 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 49b294a8d917..0fdacacd6e8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -121,6 +121,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
=20
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 544a43c1cf11..f0dea3750ca9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -286,8 +286,14 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_=
MAX_INDEX_MASK) =3D=3D X2AVIC_
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
=20
 #define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
=20
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ce1c727bad23..7dfbf12b454b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,7 @@
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
=20
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
=20
 /* enable/disable SEV support */
 static bool sev_enabled =3D true;
@@ -3203,6 +3203,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *=
svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (lower_32_bits(control->exit_info_1) !=3D SVM_VMGEXIT_AP_DESTROY)
+			if (!kvm_ghcb_rax_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3443,6 +3448,195 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1; /* resume guest */
 }
=20
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted =3D false;
+	vcpu->arch.mp_state =3D KVM_MP_STATE_HALTED;
+
+	/* Clear use of the VMSA */
+	svm->sev_es.vmsa_pa =3D INVALID_PAGE;
+	svm->vmcb->control.vmsa_pa =3D INVALID_PAGE;
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		gfn_t gfn =3D gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+		struct kvm_memory_slot *slot;
+		kvm_pfn_t pfn;
+
+		slot =3D gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+			return -EINVAL;
+
+		/*
+		 * The new VMSA will be private memory guest memory, so
+		 * retrieve the PFN from the gmem backend.
+		 */
+		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+			return -EINVAL;
+
+		/* Use the new VMSA */
+		svm->sev_es.vmsa_pa =3D pfn_to_hpa(pfn);
+		svm->vmcb->control.vmsa_pa =3D svm->sev_es.vmsa_pa;
+
+		/* Mark the vCPU as runnable */
+		vcpu->arch.pv.pv_unhalted =3D false;
+		vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
+
+		svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+
+		/*
+		 * gmem pages aren't currently migratable, but if this ever
+		 * changes then care should be taken to ensure
+		 * svm->sev_es.vmsa_pa is pinned through some other means.
+		 */
+		kvm_release_pfn_clean(pfn);
+	}
+
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	return 0;
+}
+
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+	int ret;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_create)
+		goto unlock;
+
+	svm->sev_es.snp_ap_create =3D false;
+
+	ret =3D __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+
+unlock:
+	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+}
+
+static int sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+	struct kvm_vcpu *vcpu =3D &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	bool kick;
+	int ret;
+
+	request =3D lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id =3D upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
+			    apic_id);
+		return -EINVAL;
+	}
+
+	ret =3D 0;
+
+	target_svm =3D to_svm(target_vcpu);
+
+	/*
+	 * The target vCPU is valid, so the vCPU will be kicked unless the
+	 * request is for CREATE_ON_INIT. For any errors at this stage, the
+	 * kick will place the vCPU in an non-runnable state.
+	 */
+	kick =3D true;
+
+	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	target_svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+	target_svm->sev_es.snp_ap_create =3D true;
+
+	/* Interrupt injection mode shouldn't change for AP creation */
+	if (request < SVM_VMGEXIT_AP_DESTROY) {
+		u64 sev_features;
+
+		sev_features =3D vcpu->arch.regs[VCPU_REGS_RAX];
+		sev_features ^=3D sev->vmsa_features;
+
+		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest=
\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX]);
+			ret =3D -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		kick =3D false;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\=
n",
+				    svm->vmcb->control.exit_info_2);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Malicious guest can RMPADJUST a large page into VMSA which
+		 * will hit the SNP erratum where the CPU will incorrectly signal
+		 * an RMP violation #PF if a hugepage collides with the RMP entry
+		 * of VMSA page, reject the AP CREATE request if VMSA address from
+		 * guest is 2M aligned.
+		 */
+		if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
+			vcpu_unimpl(vcpu,
+				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M =
aligned\n",
+				    svm->vmcb->control.exit_info_2);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		target_svm->sev_es.snp_vmsa_gpa =3D svm->vmcb->control.exit_info_2;
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest=
\n",
+			    request);
+		ret =3D -EINVAL;
+		break;
+	}
+
+out:
+	if (kick) {
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+
+		if (target_vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZED)
+			kvm_make_request(KVM_REQ_UNBLOCK, target_vcpu);
+
+		kvm_vcpu_kick(target_vcpu);
+	}
+
+	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control =3D &svm->vmcb->control;
@@ -3686,6 +3880,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.psc.shared_gpa =3D svm->sev_es.sw_scratch;
 		vcpu->arch.complete_userspace_io =3D snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		ret =3D sev_snp_ap_creation(svm);
+		if (ret) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
@@ -3852,6 +4055,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
=20
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_sa=
ve_area *hostsa)
@@ -3963,6 +4168,16 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vc=
pu)
 	return p;
 }
=20
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu) &&
+	    vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZED)
+		vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
+}
+
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
)
 {
 	struct kvm_memory_slot *slot;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e036a8927717..a895d3f07cb8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1398,6 +1398,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, boo=
l init_event)
 	svm->spec_ctrl =3D 0;
 	svm->virt_spec_ctrl =3D 0;
=20
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
=20
 	if (!init_event)
@@ -4937,6 +4940,12 @@ static void *svm_alloc_apic_backing_page(struct kvm_=
vcpu *vcpu)
 	return page_address(page);
 }
=20
+static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	sev_vcpu_unblocking(vcpu);
+	avic_vcpu_unblocking(vcpu);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata =3D {
 	.name =3D KBUILD_MODNAME,
=20
@@ -4959,7 +4968,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =3D =
{
 	.vcpu_load =3D svm_vcpu_load,
 	.vcpu_put =3D svm_vcpu_put,
 	.vcpu_blocking =3D avic_vcpu_blocking,
-	.vcpu_unblocking =3D avic_vcpu_unblocking,
+	.vcpu_unblocking =3D svm_vcpu_unblocking,
=20
 	.update_exception_bitmap =3D svm_update_exception_bitmap,
 	.get_msr_feature =3D svm_get_msr_feature,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8cce3315b46c..0cdcd0759fe0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -211,6 +211,10 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
=20
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA=
. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
=20
 struct vcpu_svm {
@@ -724,6 +728,8 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
);
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -738,6 +744,8 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd)=
 { return 0; }
 static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, =
u64 error_code) {}
+static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcp=
u) {}
=20
 #endif
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f85735b6235d..617c38656757 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10943,6 +10943,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
=20
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state !=3D KVM_MP_STATE_RUNNABLE) {
+				r =3D 1;
+				goto out;
+			}
+		}
 	}
=20
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -13150,6 +13158,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_v=
cpu *vcpu)
 	if (kvm_test_request(KVM_REQ_PMI, vcpu))
 		return true;
=20
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
--=20
2.25.1


X-sender: <linux-kernel+bounces-125499-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAMQAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 40815
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:03:27 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:03:27 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id CD9122032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:27 +0100 (CET)
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
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VyZR681U1qTQ for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:03:26 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125499-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 7E62A200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"tsg2jqS4"
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 7E62A200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C69C228254E
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B81C13E880;
	Fri, 29 Mar 2024 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"tsg2jqS4"
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B658F24B21;
	Fri, 29 Mar 2024 23:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753381; cv=3Dfail; b=3DASgCoc4pmkz2vBzguIaJLZZVNBJMtLdJT8A1j5Gp2pl=
NuevF713OSNn7k7u/Xh/j5x7jv9jH1DiJ3uwERThruOXukCQucQ9R8C6BHTb7FcGVSyi9jobpRz=
t1p3sMEWB7AWrsDnGzohE/u8V1LOrYE2kekbT8zRBwOVdw8bs5eGM=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753381; c=3Drelaxed/simple;
	bh=3DKHHF/vBYV5yB+doCUDT2LqJVpn4wXbjwTAFdd/Tr7hw=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DV+ChY87+uuO2tjKr3OWfY++p39GWLb5XEFU/ybYb8l=
wg0vZ9LskG3nCjTUkEAp1ui1xTIQAbcvc+gIipheM8dIptkLBE257HhTf038ApMGog29pcErKE7=
IM4gsVOb0kvRSpB0ymOIbwnQfmKj4CH8Z5mmMeOnuq69gMbm001NzU=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dtsg2jqS4; arc=3Dfail smtp.client-ip=3D40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DlLYVJ2rjiBRdW+iXdllNqIZgZPbKY5JUZuXz84I0MYkGHI2+isS0se4oi/xUVAb7WCpukP=
lEZ4EnA/TAf/47O5YwigfjX4z64qW0n65Liq7pSTRVQbZIg6hQDzMtF5tAemszDQ9S54y77SMSC=
rbFO0vgBz/6K8M9xwc2D3JNhOwb1vfNLhsWvLaDKUBNwSndlN7au8+Ihklcg0z97qJpnWdvu2Ik=
GMHsNfwxMYkX01MV0m/RciFc31h98MB/qP7LwW8yrDdBe8bgE1tqE6GfC1TjmwKVJQ6vSnqXRv9=
sTL0qQZa1HjoTdPMAWEWJX2El0kVFYa/Y94IWHm1Ro9ZmSg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DhYDUOsZ8oSqdDjPaR5Xc/ME9UC8/Zi2qVp0/kTJliSw=3D;
 b=3DJZR18khJWPFbqxfvnhDfSz6vzkLIVM7g+WZGEqcJXuCxovLzBVdk2SVcaEonPSC5OIgWVM=
SRDRTbWA1quhM5G1ZajXm5cBNlvHTLl8EiqNwjn9MefAshE6md3MR6r9r7EOfPcnn3R8XMJkwBu=
6c6RDoTcNKIBW07GaJ2LDup6PZSeTpFSz9nc7MxpyZf2UUtgMfj/sKbCcHkMh+66FhpJMXwTo3P=
BqJPKBKw8ZGizPykZT7zyqdMnXDuAfx0JXEfqvu5mQ8O4c87jxmoOywcragCJynnAOQnF/Oh99u=
wkrFNFpZ3JZubcu3uOGkPJAlTBu1TX3SSyBS0+fjfurKuPw=3D=3D
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
 bh=3DhYDUOsZ8oSqdDjPaR5Xc/ME9UC8/Zi2qVp0/kTJliSw=3D;
 b=3Dtsg2jqS42wTV0w9yTC7xM2MdaeE+6YTCo02pkCeadOlCLdUzOWEv9Cdbny0qli+q9EOFf1=
8R1n+DFSolN88DcIl+p17LPAZCmBMVf83MvzKXZRO89mIaSyNP3VQhPVpOuMmISAhQyrR+6eCZt=
W27hj4N8M0imnZzJJTqoJlBzo0=3D
Received: from SJ0PR03CA0153.namprd03.prod.outlook.com (2603:10b6:a03:338::=
8)
 by PH0PR12MB8032.namprd12.prod.outlook.com (2603:10b6:510:26f::15) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.42; Fri, 29 =
Mar
 2024 23:02:52 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::d5) by SJ0PR03CA0153.outlook.office365.com
 (2603:10b6:a03:338::8) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:02:52 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:02:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:02:51 -0500
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
Subject: [PATCH v12 19/29] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date: Fri, 29 Mar 2024 17:58:25 -0500
Message-ID: <20240329225835.400662-20-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|PH0PR12MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 551edada-c896-4c34-cb0b-08dc50445c=
ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjuWmA2FmMrZm/Lj19E04lIhHLtbd7tQjfPwsVQo=
3kXbjdq069bgIoUjxkhgx8Aog4T4A3SqnXW08ioGCt1IlNphfNVzzruiUNNzLQ2rfJL4u7yg38W=
ZSlbesKmiUQF9+h3hAMV3iEaGIMxQLMiF8/pLqaxrl2T3bnXGI1CY0ZQvFM4cb+jZsMMExqzSFS=
d2yrWlrsz2v7jxs5jn5GlS3RkBz46l3THP9KVizrwjINvqJ+b7q+DryORFCc74jHbXHwevPI9WR=
n7c2UINnUyX3Tixqx+JC3wZ53Mu2LAnGHcXCDjY2972TsOFRQ4w2Oopu/P7sFSNb82qrAEqvRiK=
0UgOzYkkclLrdqjoXVXXHse0DMPB7APNjMriX0HkXip3reXUbUs9eYjYKpvLIXvvDBsrodbz+GF=
at/Lg2ri8HqMnsu1hyGo++bXUr4Srgtv8wS9ymx6EGwKP0SXqxqrwf8sFmyAfI9ZDuoaQkiTL6h=
ra+gLdWzsb+PrYu/GYSlTGCEKCVH9tQ+j5mGyLi48LciiqqIKfQ8gm1SAmZ5uXUVi6sLHDrFfw4=
Grx8QBURmbKlNX74pmxPa2UEx31cXvdta3+9GihVK3kWW9p18Tfo7ExRMJ+SbP7H7GTGs+FyDi1=
abkfQ0Bq0woD+mX7w/e9zlIg2s2lsNjktlMkFmns3T+H6j1u+oetS3cP19luVMG3RojbB2cOx7+=
b47V+AEvF5odxwKPDE6HJK3hneESmFVGYoHX92nA1oPxul0vafabD
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:52.1344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 551edada-c896-4c34-cb0b-08dc5=
0445cac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE2.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8032
Return-Path: linux-kernel+bounces-125499-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:03:27.8753
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: af780292-29d4-4036-a8a6-08dc=
504471e7
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33337.492|SMR=3D0.139(SMRDE=3D0.005|SMRC=3D0.=
133(SMRCL=3D0.103|X-SMRCR=3D0.133))|CAT=3D0.095(CATRESL=3D0.028
 (CATRESLP2R=3D0.025)|CATORES=3D0.063(CATRS=3D0.062(CATRS-Index Routing
 Agent=3D0.061))|CATORT=3D0.001
 (CATRT=3D0.001))|UNK=3D0.001|QDM=3D12182.769|SMSC=3D0.625(X-SMSDR=3D0.012)=
|SMS=3D5.877(SMSMBXD-INC=3D5.382
 )|UNK=3D0.001|QDM=3D20832.499|SMSC=3D0.010|SMS=3D1.288(SMSMBXD-INC=3D1.278=
)|QDM=3D309.051|PSC=3D0.026
 |CAT=3D0.008(CATRESL=3D0.006(CATRESLP2R=3D0.001))|QDM=3D5.350|UNK=3D0.001|=
CAT=3D0.005(CATRESL=3D0.004
 (CATRESLP2R=3D0.002));2024-03-30T08:19:05.383Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 26856
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.016|SMR=3D0.010(SMRPI=3D0.007(SMRPI-FrontendProxyAgent=3D0.007))=
|SMS=3D0.006
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AASAdAAAPAAADH4sIAAAAAAAEANU7aXcT=
x5aStdmyjTEQIO
 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
 OTuBajzCtBdFMinXZjeBigoqAbAyUdUPhaXFkVGr84MHTRdEhxPuEG
 yXpW7uZ0U1oFzFse4QLLdNI93xnMmv5UCzMzUtpnJsvckeNJ9W+crS
 Zqu9UqNzyIptN8ZBadDaNbUisPhlMvqaoTqaS3nBhETKzeuxV4CUR5
 W7WdTyPsrD49hLyeMeOIfC0RUl0fVquxOjWsUKBNOJJJF53iZ71AzS
 FBEGKfswNdJOKwAxXKgcZk4wxW7WR0mggZ8MUwnCBH/EB3PYSAmGJM
 vN5Z87/LUXk68C1tuTS8kIoK6IDbNbbR2WGa6KKoMzemBEZ3LsOhhT
 LjYHXvEoTFycIPHnyDB99TckI+6w5vlvlIufDtGB0WJNTZKDZG53kX
 dKwZw+f/AyxJRVqWZQAAAQq9BDw/eG1sIHZlcnNpb249IjEuMCIgZW
 5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2lv
 bj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAgICA8RW
 1haWwgU3RhcnRJbmRleD0iMjAiPg0KICAgICAgPEVtYWlsU3RyaW5n
 PnRob21hcy5sZW5kYWNreUBhbWQuY29tPC9FbWFpbFN0cmluZz4NCi
 AgICA8L0VtYWlsPg0KICAgIDxFbWFpbCBTdGFydEluZGV4PSIxNTgw
 IiBQb3NpdGlvbj0iT3RoZXIiPg0KICAgICAgPEVtYWlsU3RyaW5nPm
 JyaWplc2guc2luZ2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAg
 PC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTYzMyIgUG
 9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5hc2hp
 c2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbW
 FpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTg0MCIgUG9zaXRp
 b249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLn
 JvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4N
 CiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEL2wE8P3htbCB2ZXJzaW
 9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxVcmxTZXQ+DQog
 IDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9uPg0KICA8VXJscz4NCi
 AgICA8VXJsIFN0YXJ0SW5kZXg9IjE3ODQiIFBvc2l0aW9uPSJPdGhl
 ciIgVHlwZT0iVXJsIj4NCiAgICAgIDxVcmxTdHJpbmc+YXJjaC5tcD
 wvVXJsU3RyaW5nPg0KICAgIDwvVXJsPg0KICA8L1VybHM+DQo8L1Vy
 bFNldD4BDtABUmV0cmlldmVyT3BlcmF0b3IsMTAsMTtSZXRyaWV2ZX
 JPcGVyYXRvciwxMSw0O1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMCwx
 O1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYW
 tlckRpYWdub3N0aWNPcGVyYXRvciwxMCwxMTtQb3N0V29yZEJyZWFr
 ZXJEaWFnbm9zdGljT3BlcmF0b3IsMTEsMDtUcmFuc3BvcnRXcml0ZX JQcm9kdWNlciwyMCwyO=
Q=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 8479
X-MS-Exchange-Forest-EmailMessageHash: F69556A6
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:91/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to alter the register state of the APs on their own. This allows
the guest a way of simulating INIT-SIPI.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID. The GPA is saved in the svm struct of the
  target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to the vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID the next time an INIT is performed. The GPA is
  saved in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared
  from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
  added to vCPU and then the vCPU is kicked.

The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
as a result of the event or as a result of an INIT. If a new VMSA is to
be installed, the VMSA guest page is set as the VMSA in the vCPU VMCB
and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new VMSA is not
to be installed, the VMSA is cleared in the vCPU VMCB and the vCPU state
is set to KVM_MP_STATE_HALTED to prevent it from being run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add handling for gmem, move MP_STATE_UNINITIALIZED -> RUNNABLE
 transition to target vCPU side rather than setting vcpu->arch.mp_state
 remotely]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/svm.h      |   6 +
 arch/x86/kvm/svm/sev.c          | 217 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  11 +-
 arch/x86/kvm/svm/svm.h          |   8 ++
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 252 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 49b294a8d917..0fdacacd6e8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -121,6 +121,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
=20
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 544a43c1cf11..f0dea3750ca9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -286,8 +286,14 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_=
MAX_INDEX_MASK) =3D=3D X2AVIC_
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
=20
 #define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
=20
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ce1c727bad23..7dfbf12b454b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,7 @@
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
=20
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
=20
 /* enable/disable SEV support */
 static bool sev_enabled =3D true;
@@ -3203,6 +3203,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *=
svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (lower_32_bits(control->exit_info_1) !=3D SVM_VMGEXIT_AP_DESTROY)
+			if (!kvm_ghcb_rax_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3443,6 +3448,195 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1; /* resume guest */
 }
=20
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted =3D false;
+	vcpu->arch.mp_state =3D KVM_MP_STATE_HALTED;
+
+	/* Clear use of the VMSA */
+	svm->sev_es.vmsa_pa =3D INVALID_PAGE;
+	svm->vmcb->control.vmsa_pa =3D INVALID_PAGE;
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		gfn_t gfn =3D gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+		struct kvm_memory_slot *slot;
+		kvm_pfn_t pfn;
+
+		slot =3D gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+			return -EINVAL;
+
+		/*
+		 * The new VMSA will be private memory guest memory, so
+		 * retrieve the PFN from the gmem backend.
+		 */
+		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+			return -EINVAL;
+
+		/* Use the new VMSA */
+		svm->sev_es.vmsa_pa =3D pfn_to_hpa(pfn);
+		svm->vmcb->control.vmsa_pa =3D svm->sev_es.vmsa_pa;
+
+		/* Mark the vCPU as runnable */
+		vcpu->arch.pv.pv_unhalted =3D false;
+		vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
+
+		svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+
+		/*
+		 * gmem pages aren't currently migratable, but if this ever
+		 * changes then care should be taken to ensure
+		 * svm->sev_es.vmsa_pa is pinned through some other means.
+		 */
+		kvm_release_pfn_clean(pfn);
+	}
+
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	return 0;
+}
+
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+	int ret;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_create)
+		goto unlock;
+
+	svm->sev_es.snp_ap_create =3D false;
+
+	ret =3D __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+
+unlock:
+	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+}
+
+static int sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+	struct kvm_vcpu *vcpu =3D &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	bool kick;
+	int ret;
+
+	request =3D lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id =3D upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
+			    apic_id);
+		return -EINVAL;
+	}
+
+	ret =3D 0;
+
+	target_svm =3D to_svm(target_vcpu);
+
+	/*
+	 * The target vCPU is valid, so the vCPU will be kicked unless the
+	 * request is for CREATE_ON_INIT. For any errors at this stage, the
+	 * kick will place the vCPU in an non-runnable state.
+	 */
+	kick =3D true;
+
+	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	target_svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+	target_svm->sev_es.snp_ap_create =3D true;
+
+	/* Interrupt injection mode shouldn't change for AP creation */
+	if (request < SVM_VMGEXIT_AP_DESTROY) {
+		u64 sev_features;
+
+		sev_features =3D vcpu->arch.regs[VCPU_REGS_RAX];
+		sev_features ^=3D sev->vmsa_features;
+
+		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest=
\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX]);
+			ret =3D -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		kick =3D false;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\=
n",
+				    svm->vmcb->control.exit_info_2);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Malicious guest can RMPADJUST a large page into VMSA which
+		 * will hit the SNP erratum where the CPU will incorrectly signal
+		 * an RMP violation #PF if a hugepage collides with the RMP entry
+		 * of VMSA page, reject the AP CREATE request if VMSA address from
+		 * guest is 2M aligned.
+		 */
+		if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
+			vcpu_unimpl(vcpu,
+				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M =
aligned\n",
+				    svm->vmcb->control.exit_info_2);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		target_svm->sev_es.snp_vmsa_gpa =3D svm->vmcb->control.exit_info_2;
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest=
\n",
+			    request);
+		ret =3D -EINVAL;
+		break;
+	}
+
+out:
+	if (kick) {
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+
+		if (target_vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZED)
+			kvm_make_request(KVM_REQ_UNBLOCK, target_vcpu);
+
+		kvm_vcpu_kick(target_vcpu);
+	}
+
+	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control =3D &svm->vmcb->control;
@@ -3686,6 +3880,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.psc.shared_gpa =3D svm->sev_es.sw_scratch;
 		vcpu->arch.complete_userspace_io =3D snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		ret =3D sev_snp_ap_creation(svm);
+		if (ret) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
@@ -3852,6 +4055,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
=20
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_sa=
ve_area *hostsa)
@@ -3963,6 +4168,16 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vc=
pu)
 	return p;
 }
=20
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu) &&
+	    vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZED)
+		vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
+}
+
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
)
 {
 	struct kvm_memory_slot *slot;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e036a8927717..a895d3f07cb8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1398,6 +1398,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, boo=
l init_event)
 	svm->spec_ctrl =3D 0;
 	svm->virt_spec_ctrl =3D 0;
=20
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
=20
 	if (!init_event)
@@ -4937,6 +4940,12 @@ static void *svm_alloc_apic_backing_page(struct kvm_=
vcpu *vcpu)
 	return page_address(page);
 }
=20
+static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	sev_vcpu_unblocking(vcpu);
+	avic_vcpu_unblocking(vcpu);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata =3D {
 	.name =3D KBUILD_MODNAME,
=20
@@ -4959,7 +4968,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =3D =
{
 	.vcpu_load =3D svm_vcpu_load,
 	.vcpu_put =3D svm_vcpu_put,
 	.vcpu_blocking =3D avic_vcpu_blocking,
-	.vcpu_unblocking =3D avic_vcpu_unblocking,
+	.vcpu_unblocking =3D svm_vcpu_unblocking,
=20
 	.update_exception_bitmap =3D svm_update_exception_bitmap,
 	.get_msr_feature =3D svm_get_msr_feature,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8cce3315b46c..0cdcd0759fe0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -211,6 +211,10 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
=20
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA=
. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
=20
 struct vcpu_svm {
@@ -724,6 +728,8 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
);
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -738,6 +744,8 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd)=
 { return 0; }
 static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, =
u64 error_code) {}
+static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcp=
u) {}
=20
 #endif
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f85735b6235d..617c38656757 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10943,6 +10943,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
=20
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state !=3D KVM_MP_STATE_RUNNABLE) {
+				r =3D 1;
+				goto out;
+			}
+		}
 	}
=20
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -13150,6 +13158,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_v=
cpu *vcpu)
 	if (kvm_test_request(KVM_REQ_PMI, vcpu))
 		return true;
=20
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
--=20
2.25.1



