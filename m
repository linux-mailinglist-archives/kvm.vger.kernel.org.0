Return-Path: <kvm+bounces-13195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6FA893285
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B02728093C
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346C9146A9C;
	Sun, 31 Mar 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zeCqVAyj"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A2145331;
	Sun, 31 Mar 2024 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711901244; cv=fail; b=my7oznP2rKFcj01A9ikkXbl98W50pJLDz+PqVnTEt2y7RON5c9nFHGALU7VujUP7Nwh/Z+oru4G9yNjfEU8QOgO2tNbgM5Pe5S5hgknKCLvVgHxh9nGYlr+Y0b+/mFgCuH28rgplaNolfGwWlt5qTpbDxARbcW8c5NR/sdNdntw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711901244; c=relaxed/simple;
	bh=TB9p+NcW0b3LH/HYr+A5vBDYGAAM9iac/lVRPBzTtSo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RT6Ygy2vZqqIpALdzsBEe81I5WXaFWt49fxZZpyw425iEaPc3sf8uCsZdQzjQWHdbPQau9C3abJvfEnb+htBWiV51kNsPnAh0CIczCNXx3Rkv/ZjApWxctcbwlDxZQatUC7S4Zn6OlxmZNF0xxZgmx8JT+cv2L+2nMC3l0m6gxw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zeCqVAyj reason="signature verification failed"; arc=fail smtp.client-ip=40.107.100.70; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 44B6D208C3;
	Sun, 31 Mar 2024 18:07:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HhmDJ9tHBpt7; Sun, 31 Mar 2024 18:07:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F2C38208CE;
	Sun, 31 Mar 2024 18:07:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F2C38208CE
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 57829800051;
	Sun, 31 Mar 2024 18:02:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:02:13 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 15:52:41 +0000
X-sender: <linux-crypto+bounces-3105-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKADgAAADNigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 24900
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3105-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 422DB200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zeCqVAyj"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.70
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753544; cv=fail; b=BlqqvbGwutAw8URHIgMH30kvA5QpTzs/EidijFPe0fjFy5pMt6gU3Of58WmRgtLC5HdAFWEnpY91icLlr7eYlVXCT6T10fN7aOeDR+taYs5wJQZoRJMsxCRbI3XvUrIl79N5OhELjsPxchrIPeXAKecY7/mL+08bVpQeDnTw0Tg=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753544; c=relaxed/simple;
	bh=WgjSuePq/wBpCSmmzUyRKNJcA65Zw60gyFDJt37grOw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tadVHjYp3xUeM32EvMaNxfyZwQQAKHmOqhQQ1XMBg9kHp+gJAurvOy+zAHBwq9zTbGuP/KUoD7IDeUX0jGzYICO/4kQRtEwkvcoBPNOkgirp3exZt3Mu9Ku4Nua7UCArN/3crAiO/9CE+CnJguzPNZzA3jmWHwQHpZ5TSvlUC9c=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zeCqVAyj; arc=fail smtp.client-ip=40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTdfnSa1VhLOPKJevSaKvpUEM+ibK4JR/D4A9skjpRANTv9ZzuAloP8//3oASD3IdNwrh+OSRxi+9Iwq7hxH6bm72GCC8DmsKuP2rDNCei5s/4ioa7Mt0Rgv1Y/9zANhJ5bTNBTPlIJK6vKpaQdARBJ53qfdQwGiJ48PzqDufYciLrHxwSuTMItPHCXugbz1V3S9i0NMupUEJi2oKI/eevatNkz7jMPkOWb7myAeNRT+nOWgFlh4B1G5PybIF2KIVcmpb5vavCiFv2nXckLeBWe3CjlMqZJgIR/2tMwEHDDQjFAfKr1bkg0JIiZoKD5UYARcmLysUNDUnBW6ZIkQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=;
 b=Tm4mgAX85xml0c02ymLsi9tk5C41IzMLRHOGWwLnQtBjp1JDzL/nwJeVbnGSnlpvk1POZGeLGRF7uiH/vidV2sDKC96d1S85+P55F8F6RGYjLbU4K7b/V5SjUD5EXMBtRAVnjp0PDyxJrRMJyeAM6BYi8RyT7/DfjMT8G35q9tTlJjCWFv6owwahTlfvcX2HoILzjyrKqGAeDieGHKbYsmZOPTPErMVnPAJ8B7I8++OtLIDDvWXeDmrmLRbHlIemWx0QFJKcVf8k3aQiK3tidiyMuCzDuSs0Ua3O7Upae61Gh50WMtQDWQCbIiKYt0jiqt4Exm8sSBJz6uwIWduLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=;
 b=zeCqVAyjfRxDQher1AZ5EaOKxM5xY4BftFJ208BZWqiiAjXdof/d4iUhbP36IlOA01+A1BhxmrUQU0P14395af+BJG1LpGQu/iQfEYn8iwN6tfjzVCRINDzlsxLRvhiEfBgRdVKJmno9WURcApRABBx4LkwYntw5GkcQBk5RGlA=
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
	<brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v12 26/29] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 29 Mar 2024 17:58:32 -0500
Message-ID: <20240329225835.400662-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|DS7PR12MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: 29793531-e2ca-491c-1a60-08dc5044c08d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFSuaKTvRQfOtdiiZggI/1E9juK+oJc2TRSGXFVjNQH6K1wlm9lAuRi2AABfWovQilmwMVXe1l6T4YxvGuuFifLSCpmtPQOHKjm6x+FajgbzHsEgtMX93cx5A0nttMe/qTI13yLMvcscLwhbPBIdodHYHhzKupmGusDKEUfIkuXqgoS46ONELQ8DpRVI7AvlT51VRqxW6w6SmGYUURqbArpcwis5lJT+cTvGNv8CqPtGPlIy7qfPPfuhv1nCIO9qPPfvEGlgl/Ec+LypJxBtqOEfg2pBgc02cbfF15t+YO5/ue5hwWk2QeyLY/PtzpC6Bue+8ZYMaLgW7iEG237ohWzAvDkoO5JuB0YjPr9df90ZKqzIesdCLnSdeqdDO9BO09jMyX5hg+vOmQmDRLp5MGJZ0CLEXxryinRjW60G57b7aoliHs448u+dW9OMhumg4geX6Ys+dNVlqiUHttX7q1i79Zld8UWIVQxAemTDG5c93reIn0O1bo2r+FTQzyNA60sU19YLtjGrE2CeHrS8UBmvPCHb+dNs/bwEdkpHaysGHJoMSSvphTWHY/GTjqyl61EyVKEXMAdKGOoJEKagRrWl4eg4UKhIYmIVTQyAvx7i9Y2qCbTYlvo+hUPDKlFswU7rnoRM5q0SJo084BAULraS65dFTt/wwZaFs/sG/Pn1sk4sqy3xCY8HS+L4Ka6jAqFvX2LdWGEJVaix3MvIE7CGKTb/0UI+9e3423/5muTUjwuXnqr/9ldh5/UD03xC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:05:39.7301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29793531-e2ca-491c-1a60-08dc5044c08d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8346
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made are opaque to the
hypervisor, which only serves as a proxy for the guest requests and
firmware responses.

Implement handling for these events.

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c         | 83 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 658116537f3f..f56f04553e81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
=20
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3223,6 +3224,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3646,6 +3648,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
=20
+static bool snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest=
_request *data,
+				gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t req_pfn, resp_pfn;
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
+		return false;
+
+	req_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return false;
+
+	resp_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return false;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return false;
+
+	data->gctx_paddr =3D __psp_pa(sev->snp_context);
+	data->req_paddr =3D __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr =3D __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return true;
+}
+
+static bool snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
+{
+	u64 pfn =3D __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+
+	if (snp_page_reclaim(pfn))
+		return false;
+
+	if (rmp_make_shared(pfn, PG_LEVEL_4K))
+		return false;
+
+	return true;
+}
+
+static bool __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t r=
esp_gpa,
+				   sev_ret_code *fw_err)
+{
+	struct sev_data_snp_guest_request data =3D {0};
+	struct kvm_sev_info *sev;
+	bool ret =3D true;
+
+	if (!sev_snp_guest(kvm))
+		return false;
+
+	sev =3D &to_kvm_svm(kvm)->sev_info;
+
+	if (!snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa))
+		return false;
+
+	if (sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err))
+		ret =3D false;
+
+	if (!snp_cleanup_guest_buf(&data))
+		ret =3D false;
+
+	return ret;
+}
+
+static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_=
t resp_gpa)
+{
+	struct kvm_vcpu *vcpu =3D &svm->vcpu;
+	struct kvm *kvm =3D vcpu->kvm;
+	sev_ret_code fw_err =3D 0;
+	int vmm_ret =3D 0;
+
+	if (!__snp_handle_guest_req(kvm, req_gpa, resp_gpa, &fw_err))
+		vmm_ret =3D SNP_GUEST_VMM_ERR_GENERIC;
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err))=
;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control =3D &svm->vmcb->control;
@@ -3906,6 +3985,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->system_event.ndata =3D 1;
 		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.=
h
index 154a87a1eca9..7bd78e258569 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -89,8 +89,17 @@ struct snp_ext_report_req {
 #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
 #define SNP_GUEST_VMM_ERR_SHIFT		32
 #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
+#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
+#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
+					 SNP_GUEST_FW_ERR(fw_err))
=20
+/*
+ * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but de=
fine
+ * a GENERIC error code such that it won't ever conflict with GHCB-defined
+ * errors if any get added in the future.
+ */
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)
=20
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
--=20
2.25.1


X-sender: <kvm+bounces-13131-martin.weber=3Dsecunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=3Drfc822;martin.weber@secunet.=
com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7f=
W2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNS=
ZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAU=
AEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWU=
RJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAA=
LMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0=
cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3Vwcyx=
DTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cm=
F0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ie=
C1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxS=
ZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFg=
AFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYX=
Rpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc=
3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5U=
cmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQA=
jAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0=
LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAA=
FAAUAAgABBQBiAAoAOQAAAM2KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 24756
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-01.secunet.de (10.53.40.197) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 30 Mar 2024 00:06:10 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:06:10 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id D1805202BD
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:06:10 +0100 (CET)
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
	with ESMTP id oAJd4B0w3R4K for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 00:06:10 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dkvm+bounce=
s-13131-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber=
@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 03E3A200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"zeCqVAyj"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 03E3A200BB
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F61B1C212A9
	for <martin.weber@secunet.com>; Fri, 29 Mar 2024 23:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1806913F012;
	Fri, 29 Mar 2024 23:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"zeCqVAyj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04=
on2070.outbound.protection.outlook.com [40.107.100.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E9C13E6B9;
	Fri, 29 Mar 2024 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.100.70
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753544; cv=3Dfail; b=3DBlqqvbGwutAw8URHIgMH30kvA5QpTzs/EidijFPe0fj=
Fy5pMt6gU3Of58WmRgtLC5HdAFWEnpY91icLlr7eYlVXCT6T10fN7aOeDR+taYs5wJQZoRJMsxC=
RbI3XvUrIl79N5OhELjsPxchrIPeXAKecY7/mL+08bVpQeDnTw0Tg=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753544; c=3Drelaxed/simple;
	bh=3DWgjSuePq/wBpCSmmzUyRKNJcA65Zw60gyFDJt37grOw=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DtadVHjYp3xUeM32EvMaNxfyZwQQAKHmOqhQQ1XMBg9=
kHp+gJAurvOy+zAHBwq9zTbGuP/KUoD7IDeUX0jGzYICO/4kQRtEwkvcoBPNOkgirp3exZt3Mu9=
Ku4Nua7UCArN/3crAiO/9CE+CnJguzPNZzA3jmWHwQHpZ5TSvlUC9c=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DzeCqVAyj; arc=3Dfail smtp.client-ip=3D40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DLTdfnSa1VhLOPKJevSaKvpUEM+ibK4JR/D4A9skjpRANTv9ZzuAloP8//3oASD3IdNwrh+=
OSRxi+9Iwq7hxH6bm72GCC8DmsKuP2rDNCei5s/4ioa7Mt0Rgv1Y/9zANhJ5bTNBTPlIJK6vKpa=
QdARBJ53qfdQwGiJ48PzqDufYciLrHxwSuTMItPHCXugbz1V3S9i0NMupUEJi2oKI/eevatNkz7=
jMPkOWb7myAeNRT+nOWgFlh4B1G5PybIF2KIVcmpb5vavCiFv2nXckLeBWe3CjlMqZJgIR/2tMw=
EHDDQjFAfKr1bkg0JIiZoKD5UYARcmLysUNDUnBW6ZIkQcA=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DnBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=3D;
 b=3DTm4mgAX85xml0c02ymLsi9tk5C41IzMLRHOGWwLnQtBjp1JDzL/nwJeVbnGSnlpvk1POZG=
eLGRF7uiH/vidV2sDKC96d1S85+P55F8F6RGYjLbU4K7b/V5SjUD5EXMBtRAVnjp0PDyxJrRMJy=
eAM6BYi8RyT7/DfjMT8G35q9tTlJjCWFv6owwahTlfvcX2HoILzjyrKqGAeDieGHKbYsmZOPTPE=
rMVnPAJ8B7I8++OtLIDDvWXeDmrmLRbHlIemWx0QFJKcVf8k3aQiK3tidiyMuCzDuSs0Ua3O7Up=
ae61Gh50WMtQDWQCbIiKYt0jiqt4Exm8sSBJz6uwIWduLZQ=3D=3D
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
 bh=3DnBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=3D;
 b=3DzeCqVAyjfRxDQher1AZ5EaOKxM5xY4BftFJ208BZWqiiAjXdof/d4iUhbP36IlOA01+A1B=
hxmrUQU0P14395af+BJG1LpGQu/iQfEYn8iwN6tfjzVCRINDzlsxLRvhiEfBgRdVKJmno9WURcA=
pRABBx4LkwYntw5GkcQBk5RGlA=3D
Received: from DS0PR17CA0021.namprd17.prod.outlook.com (2603:10b6:8:191::16=
)
 by DS7PR12MB8346.namprd12.prod.outlook.com (2603:10b6:8:e5::13) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 =
Mar
 2024 23:05:39 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::70) by DS0PR17CA0021.outlook.office365.com
 (2603:10b6:8:191::16) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:05:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:05:39 -0500
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
	<brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v12 26/29] KVM: SEV: Provide support for SNP_GUEST_REQUEST =
NAE event
Date: Fri, 29 Mar 2024 17:58:32 -0500
Message-ID: <20240329225835.400662-27-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|DS7PR12MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: 29793531-e2ca-491c-1a60-08dc5044c0=
8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFSuaKTvRQfOtdiiZggI/1E9juK+oJc2TRSGXFVj=
NQH6K1wlm9lAuRi2AABfWovQilmwMVXe1l6T4YxvGuuFifLSCpmtPQOHKjm6x+FajgbzHsEgtMX=
93cx5A0nttMe/qTI13yLMvcscLwhbPBIdodHYHhzKupmGusDKEUfIkuXqgoS46ONELQ8DpRVI7A=
vlT51VRqxW6w6SmGYUURqbArpcwis5lJT+cTvGNv8CqPtGPlIy7qfPPfuhv1nCIO9qPPfvEGlgl=
/Ec+LypJxBtqOEfg2pBgc02cbfF15t+YO5/ue5hwWk2QeyLY/PtzpC6Bue+8ZYMaLgW7iEG237o=
hWzAvDkoO5JuB0YjPr9df90ZKqzIesdCLnSdeqdDO9BO09jMyX5hg+vOmQmDRLp5MGJZ0CLEXxr=
yinRjW60G57b7aoliHs448u+dW9OMhumg4geX6Ys+dNVlqiUHttX7q1i79Zld8UWIVQxAemTDG5=
c93reIn0O1bo2r+FTQzyNA60sU19YLtjGrE2CeHrS8UBmvPCHb+dNs/bwEdkpHaysGHJoMSSvph=
TWHY/GTjqyl61EyVKEXMAdKGOoJEKagRrWl4eg4UKhIYmIVTQyAvx7i9Y2qCbTYlvo+hUPDKlFs=
wU7rnoRM5q0SJo084BAULraS65dFTt/wwZaFs/sG/Pn1sk4sqy3xCY8HS+L4Ka6jAqFvX2LdWGE=
JVaix3MvIE7CGKTb/0UI+9e3423/5muTUjwuXnqr/9ldh5/UD03xC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(82310400014)(7416005)(376005)(1800799015);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:05:39.7301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29793531-e2ca-491c-1a60-08dc5=
044c08d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017091.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8346
Return-Path: kvm+bounces-13131-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:06:10.8900
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: e82b8a82-3a8d-482a-ba73-08dc=
5044d311
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-01.secunet.de:TOTAL-HUB=3D0.189|SMR=3D0.131(SMRDE=3D0.002|SMRC=3D0.128(=
SMRCL=3D0.101|X-SMRCR=3D0.128))|CAT=3D0.057(CATRESL=3D0.024
 (CATRESLP2R=3D0.004)|CATORES=3D0.030(CATRS=3D0.029(CATRS-Index Routing
 Agent=3D0.028)));2024-03-29T23:06:11.116Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 17547
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D8.027|SMR=3D0.008(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.027
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-01
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAeoMAAAPAAADH4sIAAAAAAAEAKVYCVPj=
VhKWfGEMHuaeTK
 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
 6jDLQImd7x1Un4hYqQS6FrcukzKqsncguqK/GeJg2ObgXPQyiTDEKR
 zccwpKUXXJrUcpM0yZMiTS4JaRmS/5DgjVzghUZFPUV7MyLJs6FTOU
 r1EiSwCk0gI3o1mTGFuYEMIrHV4iQxxHyZEHuxbFPYpJEh21NKkpkw
 VZ7JzBSpkpIhT0hdIZIZFVpJik26n4Blhug8FSMolOecJzJJzT8nLQ
 XZPMPsvUOWzsZTFLQUEMbHaU5BdPhJWh5JbCphPGIeZ0hFWR4uoUfj
 k19siVcfiSqMFMIQOGUhXzj1cug0L8V8eZFFsU8yycBhgfAlgutBGN
 ynw0jGOsZd8BTQkWvgRZEUzciIFDhcMfTywk7RUaejLBWUmcxIfLne
 YXBi/sbq/WWEEjj+LId9OM+LJYd7eaFluMCCoBeG4JWKpPyHYVv4C5
 nEh5yR7vqY3z7idY1BmSIo4NAsj2vaXOxjKXYYyRcEXb6A0E3QWcaz
 8WmCLp3KT9BhQfY8h+Nj9ExJxDort0xFyGRHKM9kXJ6GMr8gmVM4ZX
 0Wnr855a+wl4jFYQkiasMUIOTDESJl9qApIo2eMkiksU2k09PGiegA
 pVjIfjLJKc/kJEzZ+2ACHSmKXaJLi70vYrmXV5/FxT6KLUH/o99Cco
 tS4swPYxrhTpWFHDND2DY+aQsJpZJhJSE/bIC8NvmXTzXCU9kSC3Qd
 As4HbP6lGbXAN1KVQWZCapXlQB49TZCER9z4L4ZKtSgPQTGBPI+t5t
 RyfGm4xssygpN5dfIlDZDhQ4SqTvFAU7CyeP0/WzVSo40lAAABCq8E
 PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij8+DQ
 o8RW1haWxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9u
 Pg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydEluZGV4PSIyMS
 I+DQogICAgICA8RW1haWxTdHJpbmc+YnJpamVzaC5zaW5naEBhbWQu
 Y29tPC9FbWFpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxFbW
 FpbCBTdGFydEluZGV4PSI3MDEiIFBvc2l0aW9uPSJPdGhlciI+DQog
 ICAgICA8RW1haWxTdHJpbmc+YWlrQGFtZC5jb208L0VtYWlsU3RyaW
 5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9
 Ijg0OSIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cm
 luZz5hc2hpc2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgPC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTA0NC
 IgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5t
 aWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC
 9FbWFpbD4NCiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEOzwFSZXRy
 aWV2ZXJPcGVyYXRvciwxMCwwO1JldHJpZXZlck9wZXJhdG9yLDExLD
 E7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY0
 9wZXJhdG9yLDEwLDM7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09w
 ZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMT Q=3D
X-MS-Exchange-Forest-IndexAgent: 1 4091
X-MS-Exchange-Forest-EmailMessageHash: E4020154
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made are opaque to the
hypervisor, which only serves as a proxy for the guest requests and
firmware responses.

Implement handling for these events.

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c         | 83 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 658116537f3f..f56f04553e81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
=20
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3223,6 +3224,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3646,6 +3648,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
=20
+static bool snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest=
_request *data,
+				gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t req_pfn, resp_pfn;
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
+		return false;
+
+	req_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return false;
+
+	resp_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return false;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return false;
+
+	data->gctx_paddr =3D __psp_pa(sev->snp_context);
+	data->req_paddr =3D __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr =3D __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return true;
+}
+
+static bool snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
+{
+	u64 pfn =3D __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+
+	if (snp_page_reclaim(pfn))
+		return false;
+
+	if (rmp_make_shared(pfn, PG_LEVEL_4K))
+		return false;
+
+	return true;
+}
+
+static bool __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t r=
esp_gpa,
+				   sev_ret_code *fw_err)
+{
+	struct sev_data_snp_guest_request data =3D {0};
+	struct kvm_sev_info *sev;
+	bool ret =3D true;
+
+	if (!sev_snp_guest(kvm))
+		return false;
+
+	sev =3D &to_kvm_svm(kvm)->sev_info;
+
+	if (!snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa))
+		return false;
+
+	if (sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err))
+		ret =3D false;
+
+	if (!snp_cleanup_guest_buf(&data))
+		ret =3D false;
+
+	return ret;
+}
+
+static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_=
t resp_gpa)
+{
+	struct kvm_vcpu *vcpu =3D &svm->vcpu;
+	struct kvm *kvm =3D vcpu->kvm;
+	sev_ret_code fw_err =3D 0;
+	int vmm_ret =3D 0;
+
+	if (!__snp_handle_guest_req(kvm, req_gpa, resp_gpa, &fw_err))
+		vmm_ret =3D SNP_GUEST_VMM_ERR_GENERIC;
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err))=
;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control =3D &svm->vmcb->control;
@@ -3906,6 +3985,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->system_event.ndata =3D 1;
 		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		ret =3D 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.=
h
index 154a87a1eca9..7bd78e258569 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -89,8 +89,17 @@ struct snp_ext_report_req {
 #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
 #define SNP_GUEST_VMM_ERR_SHIFT		32
 #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
+#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
+#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
+					 SNP_GUEST_FW_ERR(fw_err))
=20
+/*
+ * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but de=
fine
+ * a GENERIC error code such that it won't ever conflict with GHCB-defined
+ * errors if any get added in the future.
+ */
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)
=20
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
--=20
2.25.1




