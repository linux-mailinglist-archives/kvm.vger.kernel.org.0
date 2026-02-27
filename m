Return-Path: <kvm+bounces-72125-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKaXI2oboWlhqQQAu9opvQ
	(envelope-from <kvm+bounces-72125-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 05:19:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B66841B299F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 05:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DB61D308AB0D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 04:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4801345CDC;
	Fri, 27 Feb 2026 04:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JDz8DCni"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010042.outbound.protection.outlook.com [52.101.61.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA183469F8;
	Fri, 27 Feb 2026 04:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772165656; cv=fail; b=QlDqexr+RZJ7vMpv9FQMioKTPNAqDS/yIdP8ES5K4JUKb0hFTOBPWp/GJrp63HEgx5Aib9XG/W8K+uOXKXn8lFZhNXE5dr72o9gApiPoLuYJj8/D49Cb6sgLDlLKP3pHG4a+AWDC36AXcex+bteDFFUBba2lgPxYgQigWH2bVT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772165656; c=relaxed/simple;
	bh=tDoAB68EBQbhuU41GUu+1zzR88zN89bMhl3yp1lF3fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=P5gYwGj7PaHx2NxZUHMFcBEiut52QU6rwGV3URpV6xXtgS21ur3dXsxjk+RJB+5dVWKQGp9g3OPDTtDiAEXxt+0q8FSKvsNVM6TGjErf1HdvmI9Mjy765Ko8YnTALqWdt1WbrsQxpnj+k5c1B8qOstXiDmLMBAhnYs+kQkX7aNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JDz8DCni; arc=fail smtp.client-ip=52.101.61.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEOvDTKbtAjFzYTB4KmOwggvhG3NmO1URoTslj+mpKPgqTUGNtgc2R20MaLdqayxdraRCy0qQm37QgMPf9zAfGPzuQfzLHVSX+YtDJe8pufTzjBay4EwOtz2uqhtG2uuCtD8SnMcPUdrlwKFkEV1pC+yRQVkYLUfZxic6pP63H+WesrKGIL8SpRU/YYIEYp94kA3/0iXIoWHLoaynBJvWhQvGmELkUc+hNohzQsjev1UJxjEjW0G1SeHAPFnS1oI3h8e//5frDKV0sXipQVPthGqqEXoGKg8ksnWTcHO636+6SKzRr6YfyrbE5iumw9+PbTO/n04p1JONUD75H28LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDBe+L9TzGy8B+jvoOOZ/J/mP3w1hNcKJhSv0jtO118=;
 b=sfKMG3m3r/V8xxU/fEyox6/NF4QAgbccJCS6fL4rKMndO1kItmIMNvanIyPu//bYtXi06JYxMnPqQ56XdkH2RfPp/JBfYwVAK3xxaw/j1IeMUOZ4aFGNl3Or15BkLCNGJzkrbi8LoLhUMkXe7ckzMu7icINBOOBvoehzf9nIc0k+5zgQPh+HJcMrdFkEqkxyandT6iV1KrZPDMK2AO3REnsM77v+KCUC4nkWgwxoCLeGDA0h+6qdAmItD/yi4lSPwXvevhepjEoUyyi1imr9rui3sh66DPijPnIh+csiLGEI3q1g4Db5C+wqdmzgWAAZwE1Xr9cLG571aekZ8xKLiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDBe+L9TzGy8B+jvoOOZ/J/mP3w1hNcKJhSv0jtO118=;
 b=JDz8DCnisp7zAdPf9Q9vTLup93VY60AVHkQx0twtAIQJPqwdXr+kCKneeAJ97GAmcA+JgBq+2psU8Ev3SbY8sQsMftTIvDwu0J0LM7KCOERiU5PAtoC37Y+0dJslw7/v+cb0KLAYWFYJ/b9OkAfegvm+ydIrt3GsJBgjPA740b0=
Received: from IA4P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::8)
 by DM4PR12MB6061.namprd12.prod.outlook.com (2603:10b6:8:b3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.14; Fri, 27 Feb 2026 04:14:12 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:558:cafe::76) by IA4P220CA0004.outlook.office365.com
 (2603:10b6:208:558::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.27 via Frontend Transport; Fri,
 27 Feb 2026 04:14:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Fri, 27 Feb 2026 04:14:12 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 26 Feb
 2026 22:14:11 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 26 Feb
 2026 22:14:11 -0600
Received: from [10.136.42.234] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 26 Feb 2026 22:14:07 -0600
Message-ID: <8565cb7f-61d7-4fc7-a7fc-0e593263d052@amd.com>
Date: Fri, 27 Feb 2026 09:44:05 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/fred: Fix early boot failures on SEV-ES/SNP
 guests
To: Tom Lendacky <thomas.lendacky@amd.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <sohil.mehta@intel.com>, <jon.grimm@amd.com>
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-3-nikunj@amd.com>
 <c92d46a3-48a9-48ba-bc65-4eb0df290dcd@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <c92d46a3-48a9-48ba-bc65-4eb0df290dcd@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|DM4PR12MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e908ae-e3e2-42ee-0ed6-08de75b6a97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	mDyuc2+9BRv23ySzouf5MjHpyXLnvEE6pdhOPqLmjkepDRYQowwSjM0gEtQx+Me1uY942OKjDo792I8QG28iZ+vm5R37JvfrW2/s9WtrJx28lBuDyuXwusUdpycEjFQcFiOkYpsa2Xp7mMkh3gFPbQO06vpJSb0lSl6tgC2lVKDX1NbKzynNyBUareuZl4QTlHF8V+fG/d1iHOTYMXpN+LdONbar47kpUrdStJXKcEWSadJnJLjqbG2L/TO5mGJqhmYEMZrkIo+eG1KzPFdUsAQvtyh7Zlv4+DKu5I7hPeAivWKULf5+CrabTwBZmbYCUCJeEt4hgalJDIQwWNWQTypo8viFbDoLePDZPtCgTZ1Aa0T5Akjvyz7lDPIZceUmfmMOUWlJcuCJACoFEfaWhtUROGxhhAeGLoDu+YkaiWqQlMT12aipyfjzj6MhtQrbiQtBlt5aPb64L6ZgypZSU3D4TgfNSaFCN92WgbZB8AUW3MbTVtKHEoTIEL/7FQfcqNZxTgQDSS3UqJe0jE7svA6/KhlfYLy3/TLjATFCaQymm2NWuGl50lGiYke3nHrcRW/2rjOPcsfIcyubqZ3+BXLdsyHtOKrxHgTgr2G++R0lWhJTWH7c165dt/o4tQXyu+DQnYtPYOUPKDBfhONke2167B/CpL8UkAAEPXZG78ST12SVcaEUY/IOPQ/TBiEQ4BsG2c+K6IqMZUMuMRMtnQcFcnlsJ9eaolix0moCKUU9vCbS0FW1oc1uuiUSFKDteghisF4Ox2Ljw1aH5w3MB3bmOsft2lfxp2ny7M7u2yl/W0UPaDpO/R57jFDzFefLmfZgIzYp3fPel41ry9AEkw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/CZ8Vct29ZksNSeGwO/0etTp+0SWWP6cMvFOOX3/v+busCGz2ijPbzaYpZNiJyp8mChLIm6Y2HfKTBm25+U1d1mMDEVLtarUL6L4/bYkvzVthQ+cR+oMpF+2cQfOvAjHGymiPozvFW3z/s7t+2S2/z3V8XSl5DzNSMnHK3DQi4/7AC+TC9Olqt4wTMqpVah1bMiv/ZcD9fFKu304E/G4WfqQeCoYeA5h5Fh2ctkpxTFtKrWa7MGmXvC90hi4wj8SDI2bxwVuGiUY94NcYeS23yyvmOmQviY4ISC5FlQ6WKdl+4Cg8VgK4KSvFKtBHeyRRXjKpqoKu61GqiONIs6llyyLIc1pNrnMzrR35odVn6fyhiq3ixfp9fiIHidB7ufKIMbS+d9mxFieHom/UjJv5Dv1jb1QhNoerFJiSJKAeT1i5WYJniI0Yo/y/CB4i/Y+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 04:14:12.0656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e908ae-e3e2-42ee-0ed6-08de75b6a97b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6061
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72125-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: B66841B299F
X-Rspamd-Action: no action



On 2/26/2026 7:44 PM, Tom Lendacky wrote:
> On 2/26/26 03:23, Nikunj A Dadhania wrote:
>> FRED-enabled SEV-ES and SNP guests fail to boot due to the following issues
>> in the early boot sequence:
>>
>> * FRED does not have a #VC exception handler in the dispatch logic
>>
>> * Early FRED #VC exceptions attempt to use uninitialized per-CPU GHCBs
>>   instead of boot_ghcb
>>
>> Add X86_TRAP_VC case to fred_hwexc() with a new exc_vmm_communication()
>> function that provides the unified entry point FRED requires, dispatching
>> to existing user/kernel handlers based on privilege level. The function is
>> already declared via DECLARE_IDTENTRY_VC().
>>
>> Fix early GHCB access by falling back to boot_ghcb in
>> __sev_{get,put}_ghcb() when per-CPU GHCBs are not yet initialized.
>>
>> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
>> Cc: stable@vger.kernel.org # 6.9+
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thank you!

> Looking at the code, I think there are a couple of call sights that can
> be simplified now. Can you verify that? Then as a follow-on patch,
> replace the checks in arch/x86/coco/sev/core.c to just call
> __sev_{get,put}_ghcb() now (svsm_perform_call_protocol() and
> __set_pages_state())?

Sure, will send a follow-on patch.

Regards,
Nikunj


