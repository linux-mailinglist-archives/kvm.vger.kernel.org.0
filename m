Return-Path: <kvm+bounces-13198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D74389329B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D11A728252C
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1013F145FF0;
	Sun, 31 Mar 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tIqmA0po"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6072714534E;
	Sun, 31 Mar 2024 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711901480; cv=fail; b=QM0Rk2/SlS8Z4/CRdVgxmcXqz03hnuKuGXQ6339KRdP1difX0Q1pixhSekOrl2IfeWGRBQqy375horLEshva86LaRkPV0Q4jSbMK+8He/yD5RTsNJXT0eixixBrTpPDoPtG+CLI2Id3FHe43u+JLgWwAWDJ6WrTjlXsEbz+FxCY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711901480; c=relaxed/simple;
	bh=3UCi3fnrNU2K+yDpbt4ldzvoGw1nSxCEmPIbOXjzKOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCSrs/5wZvQX3II8oT4sGmbvtnk9xY5PIw6NjH6Vs85wC0q+v7riSHMjJJGA+k2uLXcn4PMgCZyf9U/svP0dDYg2xKCoipFs7X1rShJt7KG/zpf/DAgA3SJatbWe1vwT6vX219TlRZ5LIx4vEHOdkrjLRBT9j20x+TQW4geWtz4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tIqmA0po reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.40; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 045E0208A3;
	Sun, 31 Mar 2024 18:11:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id obBfEuAfVdni; Sun, 31 Mar 2024 18:11:12 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2E809208D0;
	Sun, 31 Mar 2024 18:11:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2E809208D0
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 7F7D0800053;
	Sun, 31 Mar 2024 18:02:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:02:13 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 15:52:41 +0000
X-sender: <linux-crypto+bounces-3108-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKAEIAAADNigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 21158
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3108-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 8102A200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tIqmA0po"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753628; cv=fail; b=NAyU4Ql1nzqh8Ta+6+4fkuH3r8iuNk9YQFSF2A6/gisj9px5BkNYKlBn4AgIMyWt1I567ugxqpkl3AYixa0QaggzXoehxx6L6ncHvn8I7Ez2tFYoL9vZNbZ6wk3Abq1m4Yl3ARVXTYgiBOs5wDFCDMLeLe6eG2QE/wdDDqys51o=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753628; c=relaxed/simple;
	bh=/LyX0lMdUIy7Re5uMF7sJFrGKLk94ez+2D00SwZmmSM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4Ct+4Fh5CFHklVz8ec/KI+Vy8l6gy8sMrsA8G0VSc6BXV51aSZvcce5TO0VWpkgWRO6L20qOjtIvW71UBRjh/dpKSwVxN3thY6iXTtS2sn6wbWKOTbs/7n5LW4tFODW5ZD6LyYgDgXpsXkY2D4E35ysdtbX5m/Gl5n/SGm3LLc=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tIqmA0po; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndNy51RAtRmNI8klSsRuUDkZ+QOIkz6PU7RicglEDrpSyeD334tm0h8TSmMzsqeKS6iJHpCYyPb/2bgRTgXwHuE5nHOCRWpYsQEUf9FfnAoZgq/FS6Ag1+n/PW1+XMjGrd3hTaQEMzt4f+mR1+LDDkpXF6HZbdDWTZG2jzrQfcx3peXwGhSzI8Mp7fmiZjGo3auxlW9277c3ZxbV6l/RzlDC8dI1+yGUojFlO4mTFp9PJnkeSg2YDsVKIVAYEAoYZXTUzSuLTkJJqQLWjodWuLBih6ic/HZU09yGVYj2AxSh3I65W1AeCVMVbbEa8KbrhsCIUknM1mpNPA/gEPz2Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=gMrC496qK2lsX87+6Bzyto2bAcxON65hdXqTeSYWXiTb9dMrUdvT2nBXXHCO9PSCV8BRKATgr3QFZL2DbJrjIrQrsltBxeFF71VRItM5A+TTH4AicOLngecTmO8rH7zlYENBB2oVx3wSKnvuU6N30ye3Cjzdcs1BVE9Zy9sB4Ul91SoyuDz+mggYy57PkPNmCmlx2d166CZHTTZJJJYqBcsHxO085W4pD2XSkVkLV72jqVcUQau02SVCvvx1k9v76Lrx1CsfhE62bu8cgJJLFXucZdWOwY5ft5+iXGnW/Bwt1HJdv9FcbPLjhvfQZ/2KhAPqUXvJYyvL0lc5vYMNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=tIqmA0poLlOQSgC8NQymU+wMavstViScDkmLWx+nPuwEKSNoq8248LCA6B4ywz4GfDsUL/JVBQork/uEDWaaxIugEnRZyot0VUV/YkV9/1sII8p7qKebIp15+bvVlPGAntwT+ov4j9ElzGeCZbgxsHd/5BERvoXJ+Xjp3NdTnpU=
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 02/29] [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
Date: Fri, 29 Mar 2024 17:58:08 -0500
Message-ID: <20240329225835.400662-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ffad58-535d-4024-6cb1-08dc5044f290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GqJcz06FWXScvO9q8UIen2Z5TIMPCwU7rdZJGHj+mAWkK5UWm4PnDKCmYgyV6KpeW5mNlwQEgzWXz89aRhNwVa9wB2gRYvrLIgGWw4N6Vr4jp4dfl8VwdC0ycC93sxY2xW+fe4jdeZgPhu/SB4QLT2sV1ndIpuyq40tUT/o0P/0nz3TFNAeu7DWQtwO9KM1gGCLv2c2YWaG2I28urqVBAEPs/Lh7IB9KQK2t3Q81bePUBE3DM6N5Un4Q9wYfgoHPRTlgN+Bh9FkttL47rOMJ/EVcgsz+MQmLB8WK66RMLcIwfu/vtN5y6nLduBqBfhorBcp6zuEs+PTOhNcN+CFyqBClZmAJ8QdSuOlmTWjymD3lzO1y3oa0U/+yLlDAcMsYKIUpx+5WQ5j4/lAZVO0q6s8IPE/Dc+d60WxY1YU28uCX49WJM5XsQDmNxH0XrGqxIGyQZ0OZG+XWbADxRLmF7wtKjB1K4TnGmFbGxlv/VDZqHCcq+fnJCBe64OkMcnbvkErwcuRbZnRIpyyoGQaZNbaa+GScMLvc2hjsnKH9ehVr+YXspEX9UHlliDBQHx99aXyp2F7q/0rnaYKqbHpMo4ZK26eAjrPsaaPwox+sjWJqIifSdzkr/G99zUVnLEkfYHuelBcZ+UO++2QpNKzeTssudbif+5NjNuyXxfRTfOYllVrmGeB2cLdGZT0KfYdernQqt8vm5t2THsWM9CWDi2o4SF+TnOkjV3wIec1H3DVG759Esk29a322K114Jm/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:03.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ffad58-535d-4024-6cb1-08dc5044f290
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add functionality to set and/or clear different attributes of the
machine as a confidential computing platform. Add the first one too:
whether the machine is running as a host for SEV-SNP guests.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/cc_platform.h | 12 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d07be9d05cd0..8c3fae23d3c6 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,11 @@
 enum cc_vendor cc_vendor __ro_after_init =3D CC_VENDOR_NONE;
 u64 cc_mask __ro_after_init;
=20
+static struct cc_attr_flags {
+	__u64 host_sev_snp	: 1,
+	      __resv		: 63;
+} cc_flags;
+
 static bool noinstr intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -89,6 +94,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr=
)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
=20
+	case CC_ATTR_HOST_SEV_SNP:
+		return cc_flags.host_sev_snp;
+
 	default:
 		return false;
 	}
@@ -148,3 +156,47 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+static void amd_cc_platform_clear(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_clear(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_clear(attr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void amd_cc_platform_set(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 1;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_set(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_set(attr);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd1c12f..60693a145894 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,14 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
+	 *
+	 * The host kernel is running with the necessary features
+	 * enabled to run SEV-SNP guests.
+	 */
+	CC_ATTR_HOST_SEV_SNP,
 };
=20
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
@@ -107,10 +115,14 @@ enum cc_attr {
  * * FALSE - Specified Confidential Computing attribute is not active
  */
 bool cc_platform_has(enum cc_attr attr);
+void cc_platform_set(enum cc_attr attr);
+void cc_platform_clear(enum cc_attr attr);
=20
 #else	/* !CONFIG_ARCH_HAS_CC_PLATFORM */
=20
 static inline bool cc_platform_has(enum cc_attr attr) { return false; }
+static inline void cc_platform_set(enum cc_attr attr) { }
+static inline void cc_platform_clear(enum cc_attr attr) { }
=20
 #endif	/* CONFIG_ARCH_HAS_CC_PLATFORM */
=20
--=20
2.25.1


X-sender: <kvm+bounces-13134-martin.weber=3Dsecunet.com@vger.kernel.org>
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
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0=
LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAA=
FAAUAAgABBQBiAAoAQwAAAM2KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 20972
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-01.secunet.de (10.53.40.197) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 30 Mar 2024 00:07:18 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:07:18 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 99E64207E4
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:07:18 +0100 (CET)
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
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rhf5LjiMR-HQ for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 00:07:17 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13134-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 0364420754
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 0364420754
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C4A72845E3
	for <martin.weber@secunet.com>; Fri, 29 Mar 2024 23:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A6013E3F1;
	Fri, 29 Mar 2024 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"tIqmA0po"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8751513BAD2;
	Fri, 29 Mar 2024 23:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.40
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753628; cv=3Dfail; b=3DNAyU4Ql1nzqh8Ta+6+4fkuH3r8iuNk9YQFSF2A6/gis=
j9px5BkNYKlBn4AgIMyWt1I567ugxqpkl3AYixa0QaggzXoehxx6L6ncHvn8I7Ez2tFYoL9vZNb=
Z6wk3Abq1m4Yl3ARVXTYgiBOs5wDFCDMLeLe6eG2QE/wdDDqys51o=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753628; c=3Drelaxed/simple;
	bh=3D/LyX0lMdUIy7Re5uMF7sJFrGKLk94ez+2D00SwZmmSM=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DP4Ct+4Fh5CFHklVz8ec/KI+Vy8l6gy8sMrsA8G0VSc=
6BXV51aSZvcce5TO0VWpkgWRO6L20qOjtIvW71UBRjh/dpKSwVxN3thY6iXTtS2sn6wbWKOTbs/=
7n5LW4tFODW5ZD6LyYgDgXpsXkY2D4E35ysdtbX5m/Gl5n/SGm3LLc=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DtIqmA0po; arc=3Dfail smtp.client-ip=3D40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DndNy51RAtRmNI8klSsRuUDkZ+QOIkz6PU7RicglEDrpSyeD334tm0h8TSmMzsqeKS6iJHp=
CYyPb/2bgRTgXwHuE5nHOCRWpYsQEUf9FfnAoZgq/FS6Ag1+n/PW1+XMjGrd3hTaQEMzt4f+mR1=
+LDDkpXF6HZbdDWTZG2jzrQfcx3peXwGhSzI8Mp7fmiZjGo3auxlW9277c3ZxbV6l/RzlDC8dI1=
+yGUojFlO4mTFp9PJnkeSg2YDsVKIVAYEAoYZXTUzSuLTkJJqQLWjodWuLBih6ic/HZU09yGVYj=
2AxSh3I65W1AeCVMVbbEa8KbrhsCIUknM1mpNPA/gEPz2Ag=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DpvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=3D;
 b=3DgMrC496qK2lsX87+6Bzyto2bAcxON65hdXqTeSYWXiTb9dMrUdvT2nBXXHCO9PSCV8BRKA=
Tgr3QFZL2DbJrjIrQrsltBxeFF71VRItM5A+TTH4AicOLngecTmO8rH7zlYENBB2oVx3wSKnvuU=
6N30ye3Cjzdcs1BVE9Zy9sB4Ul91SoyuDz+mggYy57PkPNmCmlx2d166CZHTTZJJJYqBcsHxO08=
5W4pD2XSkVkLV72jqVcUQau02SVCvvx1k9v76Lrx1CsfhE62bu8cgJJLFXucZdWOwY5ft5+iXGn=
W/Bwt1HJdv9FcbPLjhvfQZ/2KhAPqUXvJYyvL0lc5vYMNWA=3D=3D
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
 bh=3DpvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=3D;
 b=3DtIqmA0poLlOQSgC8NQymU+wMavstViScDkmLWx+nPuwEKSNoq8248LCA6B4ywz4GfDsUL/=
JVBQork/uEDWaaxIugEnRZyot0VUV/YkV9/1sII8p7qKebIp15+bvVlPGAntwT+ov4j9ElzGeCZ=
bgxsHd/5BERvoXJ+Xjp3NdTnpU=3D
Received: from DM6PR01CA0007.prod.exchangelabs.com (2603:10b6:5:296::12) by
 CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with Micros=
oft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA=
384) id
 15.20.7409.41; Fri, 29 Mar 2024 23:07:03 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::1c) by DM6PR01CA0007.outlook.office365.com
 (2603:10b6:5:296::12) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:07:02 -0500
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
Subject: [PATCH v12 02/29] [TEMP] x86/cc: Add cc_platform_set/_clear() help=
ers
Date: Fri, 29 Mar 2024 17:58:08 -0500
Message-ID: <20240329225835.400662-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ffad58-535d-4024-6cb1-08dc5044f2=
90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GqJcz06FWXScvO9q8UIen2Z5TIMPCwU7rdZJGHj=
+mAWkK5UWm4PnDKCmYgyV6KpeW5mNlwQEgzWXz89aRhNwVa9wB2gRYvrLIgGWw4N6Vr4jp4dfl8=
VwdC0ycC93sxY2xW+fe4jdeZgPhu/SB4QLT2sV1ndIpuyq40tUT/o0P/0nz3TFNAeu7DWQtwO9K=
M1gGCLv2c2YWaG2I28urqVBAEPs/Lh7IB9KQK2t3Q81bePUBE3DM6N5Un4Q9wYfgoHPRTlgN+Bh=
9FkttL47rOMJ/EVcgsz+MQmLB8WK66RMLcIwfu/vtN5y6nLduBqBfhorBcp6zuEs+PTOhNcN+CF=
yqBClZmAJ8QdSuOlmTWjymD3lzO1y3oa0U/+yLlDAcMsYKIUpx+5WQ5j4/lAZVO0q6s8IPE/Dc+=
d60WxY1YU28uCX49WJM5XsQDmNxH0XrGqxIGyQZ0OZG+XWbADxRLmF7wtKjB1K4TnGmFbGxlv/V=
DZqHCcq+fnJCBe64OkMcnbvkErwcuRbZnRIpyyoGQaZNbaa+GScMLvc2hjsnKH9ehVr+YXspEX9=
UHlliDBQHx99aXyp2F7q/0rnaYKqbHpMo4ZK26eAjrPsaaPwox+sjWJqIifSdzkr/G99zUVnLEk=
fYHuelBcZ+UO++2QpNKzeTssudbif+5NjNuyXxfRTfOYllVrmGeB2cLdGZT0KfYdernQqt8vm5t=
2THsWM9CWDi2o4SF+TnOkjV3wIec1H3DVG759Esk29a322K114Jm/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(7416005)(82310400014)(1800799015)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:03.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ffad58-535d-4024-6cb1-08dc5=
044f290
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
Return-Path: kvm+bounces-13134-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:07:18.6549
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 544ea24c-7a6c-485b-d3a8-08dc=
5044fb75
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-01.secunet.de:TOTAL-HUB=3D0.394|SMR=3D0.320(SMRDE=3D0.003|SMRC=3D0.316(=
SMRCL=3D0.102|X-SMRCR=3D0.316))|CAT=3D0.073(CATOS=3D0.001
 |CATRESL=3D0.027(CATRESLP2R=3D0.005)|CATORES=3D0.042(CATRS=3D0.042(CATRS-T=
ransport
 Rule Agent=3D0.001 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.040)));2024-03-29T23:07:19.052Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 14879
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D6.000|SMR=3D0.006(SMRPI=3D0.003(SMRPI-FrontendProxyAgent=3D0.003))
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-01
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAe8GAAAPAAADH4sIAAAAAAAEAMVXbVPb=
RhA+2ZJtjAWhkD
 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
 YtMTYiPz4NCjxFbWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8
 L1ZlcnNpb24+DQogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0YXJ0SW
 5kZXg9IjMxIj4NCiAgICAgIDxFbWFpbFN0cmluZz5icEBhbGllbjgu
 ZGU8L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYW
 lsIFN0YXJ0SW5kZXg9IjMzMSIgUG9zaXRpb249IlNpZ25hdHVyZSI+
 DQogICAgICA8RW1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb2
 08L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxz
 Pg0KPC9FbWFpbFNldD4BDJ0HPD94bWwgdmVyc2lvbj0iMS4wIiBlbm
 NvZGluZz0idXRmLTE2Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNp
 b24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgIC
 A8Q29udGFjdCBTdGFydEluZGV4PSIyNjQiPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIyNjQiPg0KICAgICAgICA8UGVyc29uU3RyaW
 5nPkJvcmlzbGF2IFBldGtvdjwvUGVyc29uU3RyaW5nPg0KICAgICAg
 PC9QZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAgICA8RW1haW
 wgU3RhcnRJbmRleD0iMjg3Ij4NCiAgICAgICAgICA8RW1haWxTdHJp
 bmc+YnBAYWxpZW44LmRlPC9FbWFpbFN0cmluZz4NCiAgICAgICAgPC
 9FbWFpbD4NCiAgICAgIDwvRW1haWxzPg0KICAgICAgPENvbnRhY3RT
 dHJpbmc+Qm9yaXNsYXYgUGV0a292IChBTUQpICZsdDticEBhbGllbj
 guZGU8L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICAg
 IDxDb250YWN0IFN0YXJ0SW5kZXg9IjMxNyIgUG9zaXRpb249IlNpZ2
 5hdHVyZSI+DQogICAgICA8UGVyc29uIFN0YXJ0SW5kZXg9IjMxNyIg
 UG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICAgIDxQZXJzb25TdH
 Jpbmc+TWljaGFlbCBSb3RoPC9QZXJzb25TdHJpbmc+DQogICAgICA8
 L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbC
 BTdGFydEluZGV4PSIzMzEiIFBvc2l0aW9uPSJTaWduYXR1cmUiPg0K
 ICAgICAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLm
 NvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haWw+DQogICAg
 ICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5nPk1pY2hhZW
 wgUm90aCAmbHQ7bWljaGFlbC5yb3RoQGFtZC5jb208L0NvbnRhY3RT
 dHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRhY3RzPg0KPC
 9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvciwxMCwxO1Jl
 dHJpZXZlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNlck9wZXJhdG
 9yLDEwLDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7UG9zdFdv
 cmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDE7UG9zdFdvcm
 RCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJhbnNwb3J0
 V3JpdGVyUHJvZHVjZXIsMjAsMjI=3D
X-MS-Exchange-Forest-IndexAgent: 1 3260
X-MS-Exchange-Forest-EmailMessageHash: 8CD23995
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add functionality to set and/or clear different attributes of the
machine as a confidential computing platform. Add the first one too:
whether the machine is running as a host for SEV-SNP guests.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/cc_platform.h | 12 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d07be9d05cd0..8c3fae23d3c6 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,11 @@
 enum cc_vendor cc_vendor __ro_after_init =3D CC_VENDOR_NONE;
 u64 cc_mask __ro_after_init;
=20
+static struct cc_attr_flags {
+	__u64 host_sev_snp	: 1,
+	      __resv		: 63;
+} cc_flags;
+
 static bool noinstr intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -89,6 +94,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr=
)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
=20
+	case CC_ATTR_HOST_SEV_SNP:
+		return cc_flags.host_sev_snp;
+
 	default:
 		return false;
 	}
@@ -148,3 +156,47 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+static void amd_cc_platform_clear(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_clear(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_clear(attr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void amd_cc_platform_set(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 1;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_set(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_set(attr);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd1c12f..60693a145894 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,14 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
+	 *
+	 * The host kernel is running with the necessary features
+	 * enabled to run SEV-SNP guests.
+	 */
+	CC_ATTR_HOST_SEV_SNP,
 };
=20
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
@@ -107,10 +115,14 @@ enum cc_attr {
  * * FALSE - Specified Confidential Computing attribute is not active
  */
 bool cc_platform_has(enum cc_attr attr);
+void cc_platform_set(enum cc_attr attr);
+void cc_platform_clear(enum cc_attr attr);
=20
 #else	/* !CONFIG_ARCH_HAS_CC_PLATFORM */
=20
 static inline bool cc_platform_has(enum cc_attr attr) { return false; }
+static inline void cc_platform_set(enum cc_attr attr) { }
+static inline void cc_platform_clear(enum cc_attr attr) { }
=20
 #endif	/* CONFIG_ARCH_HAS_CC_PLATFORM */
=20
--=20
2.25.1


X-sender: <linux-kernel+bounces-125513-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAPDFCS25B=
AlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURh=
dGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAw=
AAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbi=
xPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwA=
AAAAABQAFAAIAAQUAYgAKAEQAAADNigAABQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 20997
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-01.secunet.de (10.53.40.197) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 30 Mar 2024 00:07:28 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:07:28 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 6B8D9207E4
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:07:28 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=3D-2.85 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQjBiIKHILZN for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:07:27 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125513-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D027120754
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id D027120754
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EAEF1F23987
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3634913E6D0;
	Fri, 29 Mar 2024 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"tIqmA0po"
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8751513BAD2;
	Fri, 29 Mar 2024 23:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.40
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753628; cv=3Dfail; b=3DNAyU4Ql1nzqh8Ta+6+4fkuH3r8iuNk9YQFSF2A6/gis=
j9px5BkNYKlBn4AgIMyWt1I567ugxqpkl3AYixa0QaggzXoehxx6L6ncHvn8I7Ez2tFYoL9vZNb=
Z6wk3Abq1m4Yl3ARVXTYgiBOs5wDFCDMLeLe6eG2QE/wdDDqys51o=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753628; c=3Drelaxed/simple;
	bh=3D/LyX0lMdUIy7Re5uMF7sJFrGKLk94ez+2D00SwZmmSM=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DP4Ct+4Fh5CFHklVz8ec/KI+Vy8l6gy8sMrsA8G0VSc=
6BXV51aSZvcce5TO0VWpkgWRO6L20qOjtIvW71UBRjh/dpKSwVxN3thY6iXTtS2sn6wbWKOTbs/=
7n5LW4tFODW5ZD6LyYgDgXpsXkY2D4E35ysdtbX5m/Gl5n/SGm3LLc=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DtIqmA0po; arc=3Dfail smtp.client-ip=3D40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DndNy51RAtRmNI8klSsRuUDkZ+QOIkz6PU7RicglEDrpSyeD334tm0h8TSmMzsqeKS6iJHp=
CYyPb/2bgRTgXwHuE5nHOCRWpYsQEUf9FfnAoZgq/FS6Ag1+n/PW1+XMjGrd3hTaQEMzt4f+mR1=
+LDDkpXF6HZbdDWTZG2jzrQfcx3peXwGhSzI8Mp7fmiZjGo3auxlW9277c3ZxbV6l/RzlDC8dI1=
+yGUojFlO4mTFp9PJnkeSg2YDsVKIVAYEAoYZXTUzSuLTkJJqQLWjodWuLBih6ic/HZU09yGVYj=
2AxSh3I65W1AeCVMVbbEa8KbrhsCIUknM1mpNPA/gEPz2Ag=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DpvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=3D;
 b=3DgMrC496qK2lsX87+6Bzyto2bAcxON65hdXqTeSYWXiTb9dMrUdvT2nBXXHCO9PSCV8BRKA=
Tgr3QFZL2DbJrjIrQrsltBxeFF71VRItM5A+TTH4AicOLngecTmO8rH7zlYENBB2oVx3wSKnvuU=
6N30ye3Cjzdcs1BVE9Zy9sB4Ul91SoyuDz+mggYy57PkPNmCmlx2d166CZHTTZJJJYqBcsHxO08=
5W4pD2XSkVkLV72jqVcUQau02SVCvvx1k9v76Lrx1CsfhE62bu8cgJJLFXucZdWOwY5ft5+iXGn=
W/Bwt1HJdv9FcbPLjhvfQZ/2KhAPqUXvJYyvL0lc5vYMNWA=3D=3D
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
 bh=3DpvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=3D;
 b=3DtIqmA0poLlOQSgC8NQymU+wMavstViScDkmLWx+nPuwEKSNoq8248LCA6B4ywz4GfDsUL/=
JVBQork/uEDWaaxIugEnRZyot0VUV/YkV9/1sII8p7qKebIp15+bvVlPGAntwT+ov4j9ElzGeCZ=
bgxsHd/5BERvoXJ+Xjp3NdTnpU=3D
Received: from DM6PR01CA0007.prod.exchangelabs.com (2603:10b6:5:296::12) by
 CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with Micros=
oft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA=
384) id
 15.20.7409.41; Fri, 29 Mar 2024 23:07:03 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::1c) by DM6PR01CA0007.outlook.office365.com
 (2603:10b6:5:296::12) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:07:02 -0500
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
Subject: [PATCH v12 02/29] [TEMP] x86/cc: Add cc_platform_set/_clear() help=
ers
Date: Fri, 29 Mar 2024 17:58:08 -0500
Message-ID: <20240329225835.400662-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ffad58-535d-4024-6cb1-08dc5044f2=
90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GqJcz06FWXScvO9q8UIen2Z5TIMPCwU7rdZJGHj=
+mAWkK5UWm4PnDKCmYgyV6KpeW5mNlwQEgzWXz89aRhNwVa9wB2gRYvrLIgGWw4N6Vr4jp4dfl8=
VwdC0ycC93sxY2xW+fe4jdeZgPhu/SB4QLT2sV1ndIpuyq40tUT/o0P/0nz3TFNAeu7DWQtwO9K=
M1gGCLv2c2YWaG2I28urqVBAEPs/Lh7IB9KQK2t3Q81bePUBE3DM6N5Un4Q9wYfgoHPRTlgN+Bh=
9FkttL47rOMJ/EVcgsz+MQmLB8WK66RMLcIwfu/vtN5y6nLduBqBfhorBcp6zuEs+PTOhNcN+CF=
yqBClZmAJ8QdSuOlmTWjymD3lzO1y3oa0U/+yLlDAcMsYKIUpx+5WQ5j4/lAZVO0q6s8IPE/Dc+=
d60WxY1YU28uCX49WJM5XsQDmNxH0XrGqxIGyQZ0OZG+XWbADxRLmF7wtKjB1K4TnGmFbGxlv/V=
DZqHCcq+fnJCBe64OkMcnbvkErwcuRbZnRIpyyoGQaZNbaa+GScMLvc2hjsnKH9ehVr+YXspEX9=
UHlliDBQHx99aXyp2F7q/0rnaYKqbHpMo4ZK26eAjrPsaaPwox+sjWJqIifSdzkr/G99zUVnLEk=
fYHuelBcZ+UO++2QpNKzeTssudbif+5NjNuyXxfRTfOYllVrmGeB2cLdGZT0KfYdernQqt8vm5t=
2THsWM9CWDi2o4SF+TnOkjV3wIec1H3DVG759Esk29a322K114Jm/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(7416005)(82310400014)(1800799015)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:03.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ffad58-535d-4024-6cb1-08dc5=
044f290
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
Return-Path: linux-kernel+bounces-125513-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:07:28.4654
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 5afd3314-ec38-46c5-ccbe-08dc=
5045014e
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-01.secunet.de:TOTAL-HUB=3D0.211|SMR=3D0.129(SMRDE=3D0.003|SMRC=3D0.126(=
SMRCL=3D0.102|X-SMRCR=3D0.126))|CAT=3D0.080(CATRESL=3D0.024
 (CATRESLP2R=3D0.004)|CATORES=3D0.051(CATRS=3D0.051(CATRS-Index Routing
 Agent=3D0.050))|CATORT=3D0.001 (CATRT=3D0.001));2024-03-29T23:07:28.682Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 14942
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D9.000|SMR=3D0.009(SMRPI=3D0.006(SMRPI-FrontendProxyAgent=3D0.006))
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-01
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAe8GAAAPAAADH4sIAAAAAAAEAMVXbVPb=
RhA+2ZJtjAWhkD
 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
 YtMTYiPz4NCjxFbWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8
 L1ZlcnNpb24+DQogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0YXJ0SW
 5kZXg9IjMxIj4NCiAgICAgIDxFbWFpbFN0cmluZz5icEBhbGllbjgu
 ZGU8L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYW
 lsIFN0YXJ0SW5kZXg9IjMzMSIgUG9zaXRpb249IlNpZ25hdHVyZSI+
 DQogICAgICA8RW1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb2
 08L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxz
 Pg0KPC9FbWFpbFNldD4BDJ0HPD94bWwgdmVyc2lvbj0iMS4wIiBlbm
 NvZGluZz0idXRmLTE2Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNp
 b24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgIC
 A8Q29udGFjdCBTdGFydEluZGV4PSIyNjQiPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIyNjQiPg0KICAgICAgICA8UGVyc29uU3RyaW
 5nPkJvcmlzbGF2IFBldGtvdjwvUGVyc29uU3RyaW5nPg0KICAgICAg
 PC9QZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAgICA8RW1haW
 wgU3RhcnRJbmRleD0iMjg3Ij4NCiAgICAgICAgICA8RW1haWxTdHJp
 bmc+YnBAYWxpZW44LmRlPC9FbWFpbFN0cmluZz4NCiAgICAgICAgPC
 9FbWFpbD4NCiAgICAgIDwvRW1haWxzPg0KICAgICAgPENvbnRhY3RT
 dHJpbmc+Qm9yaXNsYXYgUGV0a292IChBTUQpICZsdDticEBhbGllbj
 guZGU8L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICAg
 IDxDb250YWN0IFN0YXJ0SW5kZXg9IjMxNyIgUG9zaXRpb249IlNpZ2
 5hdHVyZSI+DQogICAgICA8UGVyc29uIFN0YXJ0SW5kZXg9IjMxNyIg
 UG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICAgIDxQZXJzb25TdH
 Jpbmc+TWljaGFlbCBSb3RoPC9QZXJzb25TdHJpbmc+DQogICAgICA8
 L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbC
 BTdGFydEluZGV4PSIzMzEiIFBvc2l0aW9uPSJTaWduYXR1cmUiPg0K
 ICAgICAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLm
 NvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haWw+DQogICAg
 ICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5nPk1pY2hhZW
 wgUm90aCAmbHQ7bWljaGFlbC5yb3RoQGFtZC5jb208L0NvbnRhY3RT
 dHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRhY3RzPg0KPC
 9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvciwxMCwxO1Jl
 dHJpZXZlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNlck9wZXJhdG
 9yLDEwLDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7UG9zdFdv
 cmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDM7UG9zdFdvcm
 RCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJhbnNwb3J0
 V3JpdGVyUHJvZHVjZXIsMjAsMzM=3D
X-MS-Exchange-Forest-IndexAgent: 1 3260
X-MS-Exchange-Forest-EmailMessageHash: 8CD23995
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add functionality to set and/or clear different attributes of the
machine as a confidential computing platform. Add the first one too:
whether the machine is running as a host for SEV-SNP guests.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/cc_platform.h | 12 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d07be9d05cd0..8c3fae23d3c6 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,11 @@
 enum cc_vendor cc_vendor __ro_after_init =3D CC_VENDOR_NONE;
 u64 cc_mask __ro_after_init;
=20
+static struct cc_attr_flags {
+	__u64 host_sev_snp	: 1,
+	      __resv		: 63;
+} cc_flags;
+
 static bool noinstr intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -89,6 +94,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr=
)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
=20
+	case CC_ATTR_HOST_SEV_SNP:
+		return cc_flags.host_sev_snp;
+
 	default:
 		return false;
 	}
@@ -148,3 +156,47 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+static void amd_cc_platform_clear(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_clear(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_clear(attr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void amd_cc_platform_set(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 1;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_set(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_set(attr);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd1c12f..60693a145894 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,14 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
+	 *
+	 * The host kernel is running with the necessary features
+	 * enabled to run SEV-SNP guests.
+	 */
+	CC_ATTR_HOST_SEV_SNP,
 };
=20
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
@@ -107,10 +115,14 @@ enum cc_attr {
  * * FALSE - Specified Confidential Computing attribute is not active
  */
 bool cc_platform_has(enum cc_attr attr);
+void cc_platform_set(enum cc_attr attr);
+void cc_platform_clear(enum cc_attr attr);
=20
 #else	/* !CONFIG_ARCH_HAS_CC_PLATFORM */
=20
 static inline bool cc_platform_has(enum cc_attr attr) { return false; }
+static inline void cc_platform_set(enum cc_attr attr) { }
+static inline void cc_platform_clear(enum cc_attr attr) { }
=20
 #endif	/* CONFIG_ARCH_HAS_CC_PLATFORM */
=20
--=20
2.25.1



