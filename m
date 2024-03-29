Return-Path: <kvm+bounces-13234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 853AF8934EA
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAEE01F240A3
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D9E14F9EA;
	Sun, 31 Mar 2024 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3OpGT4EG"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7316B16D4F3;
	Sun, 31 Mar 2024 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903590; cv=fail; b=FpHIJ3AWpQLv8Xz3mWZhlsyGTmPAIRSkAIE6Wo3mI6RSNe2qAPtpmpqqa6PgnqcaypyayCHQdz49Cnd4qoTk565++GzI6gnpTewwC82PbJ9kMbdGRBJGlvZkBhQRVa5jM/rAWlV1Ex3A0VHmFAsr3aI2C14Ks0gXqJ03H4MHMgA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903590; c=relaxed/simple;
	bh=FtqcMRESQOXZ15kk0JbrI24sWAYIXYfVVlGvbk+Tjr4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7xtZwWoaQdFw5q/bx4wePCPI+7wGo65nZg464Wvva3hi+wPdv7/TujezZNy7+CW7T6X+tXmDKrFSt6JhF/4n1KtYxohVA3vEv5u1o7h6rLjtQOY151v/h8x0lYJAPhw81FkpBTdBdadOqp02CFyu+uBj3NIhp8u1fnCeN5/LGA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3OpGT4EG reason="signature verification failed"; arc=fail smtp.client-ip=40.107.220.40; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 510B3208E7;
	Sun, 31 Mar 2024 18:46:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYKmc34kWTbR; Sun, 31 Mar 2024 18:46:21 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 3F8CD208E6;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 3F8CD208E6
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 4E05B80005A;
	Sun, 31 Mar 2024 18:40:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:25 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:44 +0000
X-sender: <linux-kernel+bounces-125514-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=DwA1AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA8MUJLbkECUOS0gjaDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGwAAgAABQBYABcASgAAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZXJzLE9VPU1pZ3JhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoA6kmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAWQAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExvdw==
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 32641
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-kernel+bounces-125514-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com D51C3200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3OpGT4EG"
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.40
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753638; cv=fail; b=CgT3fu8Kh/rfuq3RaJgcmKeE4gl7xX0VeW3V7nlqCZuv+WwFell2+RIwEdY2vDGb+5d1uKMk5n6YeEOqngyaka40E/cB98WOFJ+iJforLhzxMsxOAVZ1b7LRCNxprk7eWFGa7pLcF8XM2A/m+bzfhxUXFV6LLqJdYfRN8vXOkEw=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753638; c=relaxed/simple;
	bh=iO2iFV0D4Z3b8js9r4NsAySgcAByp//a+Wxx+cgicic=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dvJOucIkPBmFVLHO/85qrYnL4fNrIIrVq65ZGymJc4wmqldGv+YWyHuo+4jMAuW+WKhjLgiKTrtrbamLhoiUbigOq/EInQA/iw3M9WOX7UY6e8VS/8yywTd4b6Ai8j0LyL+gDxLvzKOZjZwxPJ5bQWK7pGBwaR4f+X24fw7k8Q8=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3OpGT4EG; arc=fail smtp.client-ip=40.107.220.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6vPn01wWitfm0OyBggnox6k/C7nJumwhBhojwRn/hCFHvRuUW+aUNSrDZnkFhy7ShpnRM8EHj/PTvnGThXDX7foumt3wJBz372plnsZzQiR0GJTKyxfuPtD19iu0pagjqN0yEg8h5qGNqvg+H/zEx/6+3l9jm+5ZVHiRYgQEj84c+PDUx5SSLuHzvoGSkg8dHVSz72dAujsR5+ixgIyTlge7K1etr0MpaQY5GNGd//l4fWmhaxP0HT2wieg7K84JGw0/CoRnsdxPXk4hV6CX95kA4fmcjZW/6bHoFMFrU1CAPLhIreVl+XozY0Z5ubDav86Ly7OnmbQMn/uqDw2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+jARY3LyCLvz/TtnABCSlbVvSce/wUnD7GAV92FEJo=;
 b=P1eC4RkpzXGsPO5hcLzZLDG4QbyU/jwxA2Booh1DxLBS9U+NtcHeJPQFYVoEqDmGDyjzUuMTSIds1O7qEX0cBVgPTBVuCikK0ihEBcRYypDyfZMWtDAGICi3FU3YeiabmgJqPRppgbXOoVzT5fZlPJ5HNz0rKVIl4xsFhS0mjTt4B95cQTvfdTmawLzje49caztOhkAx+cnPUBgbMe8vxZr8TqQsqyt0h0LHRQkT70oGAoIW+AX0PI/HxIIs/IdiCO8EBbJqQu49zlDWYt7e8+72FXoHsMIej/IR7E5Ok8wrUWbKVXJa5fPaeDIrp8qTvSxgake1f7elDlJGywvxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+jARY3LyCLvz/TtnABCSlbVvSce/wUnD7GAV92FEJo=;
 b=3OpGT4EGhPXNQFf3stZynRyM5E6TNZK3/oDGAjcNVPOd09orf/XxKjdbkKrtGLqlGDNQHxoEGllYlQpNzks8irzrzxu4JPu0Hpcx3QeRR+jXGxG5maLbPQ9rAMVeZzyc/wvBJil5QKn6qUEPlqsD+6lG8QLfESyOW8G3xlj0pC0=
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
Subject: [PATCH v12 29/29] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Fri, 29 Mar 2024 17:58:35 -0500
Message-ID: <20240329225835.400662-30-michael.roth@amd.com>
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
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a569d29-705e-4060-04c6-08dc5044e613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbSsOQJRgVjd70hqFRHL9lECQmnrDOE63vUgqZVCCO+J9PT8Y2d6pOC/oZ6vSn7UXBbbo6dacvUsK7gDWOuvE6R64UTCrhEybQ1qy0pCklyy934AzNEsEX/pV0nWq50tmyTe9bXRgrtqgQyR1ZL8aMUUvaMhu/hGyoI1XgtWBacj3k5pQ/yvfITfadCKsWEqX0e5rNRzauSogv0B3GLifpgl/uecFaFSw2/JVmEsEdAvLIwXLwsDVRoE92m3W1l86UiB2w2swCOkrJIH/jStIVEcMxJp0dkhm7/yk9Yjnx1e1/lZm8Zhf21qCZyAzsNz3+BQ4TKKts4WJs4wVoqqUaLODjqEFllyTQZMTPY72vRva4e1qd34VGqdizyxk71u3H302SFdXQ2IJW1SStZW5pcz7dJR82Vioa7hdY0zL1gbd+HpU2vk/+rs5c9qgBZkmO2YQLCoPOYdgxuRlKkUuga0zMWlAq1pm27qH8cmrPYHtFLdtLZSxwAC9ShD3yjNL1j14eNFGPqr3WcPvG9awmaDFj5bUOkoG1b3foRgf3wTlDpbvCWlqrzk+SwcAZCuNy2I+7WHip3Zi7uEM+ySvvDNjKx6nGXvidVH3R+Df5dI6S8l1fZPVLUwAI7VM58IwuWyrIfy4JjyJfbh3qGqlykEZzIWJ5gvxVagIbX5DKzB2dy0BWIjsrh117hV+lU7RCc3aGRdBQr05ipPTZFyqXcukaZ76Uv2wO7sf6QoEdnoSMo4e4BrRV1ryCEqTm/h
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:06:42.6990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a569d29-705e-4060-04c6-08dc5044e613
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

Version 2 of GHCB specification added support for the SNP Extended Guest
Request Message NAE event. This event serves a nearly identical purpose
to the previously-added SNP_GUEST_REQUEST event, but allows for
additional certificate data to be supplied via an additional
guest-supplied buffer to be used mainly for verifying the signature of
an attestation report as returned by firmware.

This certificate data is supplied by userspace, so unlike with
SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
forwarded to userspace via a KVM_EXIT_VMGEXIT exit type, and then the
firmware request is made only afterward.

Implement handling for these events.

Since there is a potential for race conditions where the
userspace-supplied certificate data may be out-of-sync relative to the
reported TCB or VLEK that firmware will use when signing attestation
reports, make use of the synchronization mechanisms wired up to the
SNP_{PAUSE,RESUME}_ATTESTATION SEV device ioctls such that the guest
will be told to retry the request while attestation has been paused due
to an update being underway on the system.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 26 ++++++++++++
 arch/x86/include/asm/sev.h     |  4 ++
 arch/x86/kvm/svm/sev.c         | 75 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |  3 ++
 arch/x86/virt/svm/sev.c        | 21 ++++++++++
 include/uapi/linux/kvm.h       |  6 +++
 6 files changed, 135 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85099198a10f..6cf186ed8f66 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7066,6 +7066,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
 		#define KVM_USER_VMGEXIT_PSC		2
+		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7079,6 +7080,11 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 					__u64 shared_gpa;
 					__u64 ret;
 				} psc;
+				struct {
+					__u64 data_gpa;
+					__u64 data_npages;
+					__u32 ret;
+				} ext_guest_req;
 			};
 		};
 
@@ -7108,6 +7114,26 @@ private/shared state. Userspace will return a value in 'ret' that is in
 agreement with the GHCB-defined return values that the guest will expect
 in the SW_EXITINFO2 field of the GHCB in response to these requests.
 
+For the KVM_USER_VMGEXIT_EXT_GUEST_REQ type, the ext_guest_req union type
+is used. The kernel will supply in 'data_gpa' the value the guest supplies
+via the RAX field of the GHCB when issued extended guest requests.
+'data_npages' will similarly contain the value the guest supplies in RBX
+denoting the number of shared pages available to write the certificate
+data into.
+
+  - If the supplied number of pages is sufficient, userspace should write
+    the certificate data blob (in the format defined by the GHCB spec) in
+    the address indicated by 'data_gpa' and set 'ret' to 0.
+
+  - If the number of pages supplied is not sufficient, userspace must write
+    the required number of pages in 'data_npages' and then set 'ret' to 1.
+
+  - If userspace is temporarily unable to handle the request, 'ret' should
+    be set to 2 to inform the guest to retry later.
+
+  - If some other error occurred, userspace should set 'ret' to a non-zero
+    value that is distinct from the specific return values mentioned above.
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 975e92005438..0e092c8c5614 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -274,6 +274,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
 int snp_pause_attestation(u64 *transaction_id);
 void snp_resume_attestation(u64 *transaction_id);
+u64 snp_transaction_get_id(void);
+bool snp_transaction_is_stale(u64 transaction_id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -289,6 +291,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline int snp_pause_attestation(u64 *transaction_id) { return 0; }
 static inline void snp_resume_attestation(u64 *transaction_id) {}
+static inline u64 snp_transaction_get_id(void) { return 0; }
+static inline bool snp_transaction_is_stale(u64 transaction_id) { return false; }
 #endif
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f56f04553e81..1da45e23ee14 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3225,6 +3225,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3725,6 +3726,77 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
 }
 
+static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret;
+
+	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
+	if (vmm_ret) {
+		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] =
+				vcpu->run->vmgexit.ext_guest_req.data_npages;
+		goto abort_request;
+	}
+
+	control = &svm->vmcb->control;
+
+	if (!__snp_handle_guest_req(kvm, control->exit_info_1, control->exit_info_2,
+				    &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	/*
+	 * Give errors related to stale transactions precedence to provide more
+	 * potential options for servicing firmware while guests are running.
+	 */
+	if (snp_transaction_is_stale(svm->snp_transaction_id))
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long data_npages;
+	sev_ret_code fw_err;
+	gpa_t data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto abort_request;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
+		goto abort_request;
+
+	svm->snp_transaction_id = snp_transaction_get_id();
+	if (snp_transaction_is_stale(svm->snp_transaction_id)) {
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+		goto abort_request;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_EXT_GUEST_REQ;
+	vcpu->run->vmgexit.ext_guest_req.data_gpa = data_gpa;
+	vcpu->run->vmgexit.ext_guest_req.data_npages = data_npages;
+	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
+
+	return 0; /* forward request to userspace */
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3989,6 +4061,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		ret = snp_begin_ext_guest_req(vcpu);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 746f819a6de4..7af6d0e9de17 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -303,6 +303,9 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	/* Transaction ID associated with SNP config updates */
+	u64 snp_transaction_id;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 09d62870306b..30638d10a1b9 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -611,3 +611,24 @@ void snp_resume_attestation(u64 *transaction_id)
 	mutex_unlock(&snp_pause_attestation_lock);
 }
 EXPORT_SYMBOL_GPL(snp_resume_attestation);
+
+u64 snp_transaction_get_id(void)
+{
+	return snp_transaction_id;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_get_id);
+
+bool snp_transaction_is_stale(u64 transaction_id)
+{
+	bool stale;
+
+	mutex_lock(&snp_pause_attestation_lock);
+
+	stale = (snp_attestation_paused ||
+		 transaction_id != snp_transaction_id);
+
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return stale;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_is_stale);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e33c48bfbd67..585de3a2591e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -138,6 +138,7 @@ struct kvm_xen_exit {
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
 #define KVM_USER_VMGEXIT_PSC		2
+#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -151,6 +152,11 @@ struct kvm_user_vmgexit {
 			__u64 shared_gpa;
 			__u64 ret;
 		} psc;
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+			__u32 ret;
+		} ext_guest_req;
 	};
 };
 
-- 
2.25.1


X-sender: <kvm+bounces-13135-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoAH0qmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 22426
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:07:40 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Sat, 30 Mar 2024 00:07:40 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id B2E462032C
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:07:40 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=-2.85 tagged_above=-999 required=2.1
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.099, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=0.249, MAILING_LIST_MULTI=-1,
	RCVD_IN_DNSWL_NONE=-0.0001, SPF_HELO_NONE=0.001, SPF_PASS=-0.001]
	autolearn=ham autolearn_force=no
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=pass (1024-bit key) header.d=amd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9MAqm0fZAoXN for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 00:07:38 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.48.161; helo=sy.mirrors.kernel.org; envelope-from=kvm+bounces-13135-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com C88DD200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3OpGT4EG"
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id C88DD200BB
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34E01B21928
	for <martin.weber@secunet.com>; Fri, 29 Mar 2024 23:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60C413E6DD;
	Fri, 29 Mar 2024 23:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3OpGT4EG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBDF29D03;
	Fri, 29 Mar 2024 23:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.40
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753638; cv=fail; b=CgT3fu8Kh/rfuq3RaJgcmKeE4gl7xX0VeW3V7nlqCZuv+WwFell2+RIwEdY2vDGb+5d1uKMk5n6YeEOqngyaka40E/cB98WOFJ+iJforLhzxMsxOAVZ1b7LRCNxprk7eWFGa7pLcF8XM2A/m+bzfhxUXFV6LLqJdYfRN8vXOkEw=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753638; c=relaxed/simple;
	bh=iO2iFV0D4Z3b8js9r4NsAySgcAByp//a+Wxx+cgicic=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dvJOucIkPBmFVLHO/85qrYnL4fNrIIrVq65ZGymJc4wmqldGv+YWyHuo+4jMAuW+WKhjLgiKTrtrbamLhoiUbigOq/EInQA/iw3M9WOX7UY6e8VS/8yywTd4b6Ai8j0LyL+gDxLvzKOZjZwxPJ5bQWK7pGBwaR4f+X24fw7k8Q8=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3OpGT4EG; arc=fail smtp.client-ip=40.107.220.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6vPn01wWitfm0OyBggnox6k/C7nJumwhBhojwRn/hCFHvRuUW+aUNSrDZnkFhy7ShpnRM8EHj/PTvnGThXDX7foumt3wJBz372plnsZzQiR0GJTKyxfuPtD19iu0pagjqN0yEg8h5qGNqvg+H/zEx/6+3l9jm+5ZVHiRYgQEj84c+PDUx5SSLuHzvoGSkg8dHVSz72dAujsR5+ixgIyTlge7K1etr0MpaQY5GNGd//l4fWmhaxP0HT2wieg7K84JGw0/CoRnsdxPXk4hV6CX95kA4fmcjZW/6bHoFMFrU1CAPLhIreVl+XozY0Z5ubDav86Ly7OnmbQMn/uqDw2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+jARY3LyCLvz/TtnABCSlbVvSce/wUnD7GAV92FEJo=;
 b=P1eC4RkpzXGsPO5hcLzZLDG4QbyU/jwxA2Booh1DxLBS9U+NtcHeJPQFYVoEqDmGDyjzUuMTSIds1O7qEX0cBVgPTBVuCikK0ihEBcRYypDyfZMWtDAGICi3FU3YeiabmgJqPRppgbXOoVzT5fZlPJ5HNz0rKVIl4xsFhS0mjTt4B95cQTvfdTmawLzje49caztOhkAx+cnPUBgbMe8vxZr8TqQsqyt0h0LHRQkT70oGAoIW+AX0PI/HxIIs/IdiCO8EBbJqQu49zlDWYt7e8+72FXoHsMIej/IR7E5Ok8wrUWbKVXJa5fPaeDIrp8qTvSxgake1f7elDlJGywvxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+jARY3LyCLvz/TtnABCSlbVvSce/wUnD7GAV92FEJo=;
 b=3OpGT4EGhPXNQFf3stZynRyM5E6TNZK3/oDGAjcNVPOd09orf/XxKjdbkKrtGLqlGDNQHxoEGllYlQpNzks8irzrzxu4JPu0Hpcx3QeRR+jXGxG5maLbPQ9rAMVeZzyc/wvBJil5QKn6qUEPlqsD+6lG8QLfESyOW8G3xlj0pC0=
Received: from DS7PR05CA0103.namprd05.prod.outlook.com (2603:10b6:8:56::18) by
 LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.41; Fri, 29 Mar 2024 23:06:43 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::da) by DS7PR05CA0103.outlook.office365.com
 (2603:10b6:8:56::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.17 via Frontend
 Transport; Fri, 29 Mar 2024 23:06:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:06:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:06:41 -0500
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
Subject: [PATCH v12 29/29] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Fri, 29 Mar 2024 17:58:35 -0500
Message-ID: <20240329225835.400662-30-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a569d29-705e-4060-04c6-08dc5044e613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbSsOQJRgVjd70hqFRHL9lECQmnrDOE63vUgqZVCCO+J9PT8Y2d6pOC/oZ6vSn7UXBbbo6dacvUsK7gDWOuvE6R64UTCrhEybQ1qy0pCklyy934AzNEsEX/pV0nWq50tmyTe9bXRgrtqgQyR1ZL8aMUUvaMhu/hGyoI1XgtWBacj3k5pQ/yvfITfadCKsWEqX0e5rNRzauSogv0B3GLifpgl/uecFaFSw2/JVmEsEdAvLIwXLwsDVRoE92m3W1l86UiB2w2swCOkrJIH/jStIVEcMxJp0dkhm7/yk9Yjnx1e1/lZm8Zhf21qCZyAzsNz3+BQ4TKKts4WJs4wVoqqUaLODjqEFllyTQZMTPY72vRva4e1qd34VGqdizyxk71u3H302SFdXQ2IJW1SStZW5pcz7dJR82Vioa7hdY0zL1gbd+HpU2vk/+rs5c9qgBZkmO2YQLCoPOYdgxuRlKkUuga0zMWlAq1pm27qH8cmrPYHtFLdtLZSxwAC9ShD3yjNL1j14eNFGPqr3WcPvG9awmaDFj5bUOkoG1b3foRgf3wTlDpbvCWlqrzk+SwcAZCuNy2I+7WHip3Zi7uEM+ySvvDNjKx6nGXvidVH3R+Df5dI6S8l1fZPVLUwAI7VM58IwuWyrIfy4JjyJfbh3qGqlykEZzIWJ5gvxVagIbX5DKzB2dy0BWIjsrh117hV+lU7RCc3aGRdBQr05ipPTZFyqXcukaZ76Uv2wO7sf6QoEdnoSMo4e4BrRV1ryCEqTm/h
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:06:42.6990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a569d29-705e-4060-04c6-08dc5044e613
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728
Return-Path: kvm+bounces-13135-martin.weber=secunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:07:40.7672
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 070575c8-7445-4145-0f13-08dc504508a4
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.secunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=cas-essen-02.secunet.de:TOTAL-FE=0.009|SMR=0.008(SMRPI=0.005(SMRPI-FrontendProxyAgent=0.005));2024-03-29T23:07:40.776Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 21879
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=Low
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

Version 2 of GHCB specification added support for the SNP Extended Guest
Request Message NAE event. This event serves a nearly identical purpose
to the previously-added SNP_GUEST_REQUEST event, but allows for
additional certificate data to be supplied via an additional
guest-supplied buffer to be used mainly for verifying the signature of
an attestation report as returned by firmware.

This certificate data is supplied by userspace, so unlike with
SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
forwarded to userspace via a KVM_EXIT_VMGEXIT exit type, and then the
firmware request is made only afterward.

Implement handling for these events.

Since there is a potential for race conditions where the
userspace-supplied certificate data may be out-of-sync relative to the
reported TCB or VLEK that firmware will use when signing attestation
reports, make use of the synchronization mechanisms wired up to the
SNP_{PAUSE,RESUME}_ATTESTATION SEV device ioctls such that the guest
will be told to retry the request while attestation has been paused due
to an update being underway on the system.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 26 ++++++++++++
 arch/x86/include/asm/sev.h     |  4 ++
 arch/x86/kvm/svm/sev.c         | 75 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |  3 ++
 arch/x86/virt/svm/sev.c        | 21 ++++++++++
 include/uapi/linux/kvm.h       |  6 +++
 6 files changed, 135 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85099198a10f..6cf186ed8f66 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7066,6 +7066,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
 		#define KVM_USER_VMGEXIT_PSC		2
+		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7079,6 +7080,11 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 					__u64 shared_gpa;
 					__u64 ret;
 				} psc;
+				struct {
+					__u64 data_gpa;
+					__u64 data_npages;
+					__u32 ret;
+				} ext_guest_req;
 			};
 		};
 
@@ -7108,6 +7114,26 @@ private/shared state. Userspace will return a value in 'ret' that is in
 agreement with the GHCB-defined return values that the guest will expect
 in the SW_EXITINFO2 field of the GHCB in response to these requests.
 
+For the KVM_USER_VMGEXIT_EXT_GUEST_REQ type, the ext_guest_req union type
+is used. The kernel will supply in 'data_gpa' the value the guest supplies
+via the RAX field of the GHCB when issued extended guest requests.
+'data_npages' will similarly contain the value the guest supplies in RBX
+denoting the number of shared pages available to write the certificate
+data into.
+
+  - If the supplied number of pages is sufficient, userspace should write
+    the certificate data blob (in the format defined by the GHCB spec) in
+    the address indicated by 'data_gpa' and set 'ret' to 0.
+
+  - If the number of pages supplied is not sufficient, userspace must write
+    the required number of pages in 'data_npages' and then set 'ret' to 1.
+
+  - If userspace is temporarily unable to handle the request, 'ret' should
+    be set to 2 to inform the guest to retry later.
+
+  - If some other error occurred, userspace should set 'ret' to a non-zero
+    value that is distinct from the specific return values mentioned above.
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 975e92005438..0e092c8c5614 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -274,6 +274,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
 int snp_pause_attestation(u64 *transaction_id);
 void snp_resume_attestation(u64 *transaction_id);
+u64 snp_transaction_get_id(void);
+bool snp_transaction_is_stale(u64 transaction_id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -289,6 +291,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline int snp_pause_attestation(u64 *transaction_id) { return 0; }
 static inline void snp_resume_attestation(u64 *transaction_id) {}
+static inline u64 snp_transaction_get_id(void) { return 0; }
+static inline bool snp_transaction_is_stale(u64 transaction_id) { return false; }
 #endif
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f56f04553e81..1da45e23ee14 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3225,6 +3225,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3725,6 +3726,77 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
 }
 
+static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret;
+
+	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
+	if (vmm_ret) {
+		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] =
+				vcpu->run->vmgexit.ext_guest_req.data_npages;
+		goto abort_request;
+	}
+
+	control = &svm->vmcb->control;
+
+	if (!__snp_handle_guest_req(kvm, control->exit_info_1, control->exit_info_2,
+				    &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	/*
+	 * Give errors related to stale transactions precedence to provide more
+	 * potential options for servicing firmware while guests are running.
+	 */
+	if (snp_transaction_is_stale(svm->snp_transaction_id))
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long data_npages;
+	sev_ret_code fw_err;
+	gpa_t data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto abort_request;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
+		goto abort_request;
+
+	svm->snp_transaction_id = snp_transaction_get_id();
+	if (snp_transaction_is_stale(svm->snp_transaction_id)) {
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+		goto abort_request;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_EXT_GUEST_REQ;
+	vcpu->run->vmgexit.ext_guest_req.data_gpa = data_gpa;
+	vcpu->run->vmgexit.ext_guest_req.data_npages = data_npages;
+	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
+
+	return 0; /* forward request to userspace */
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3989,6 +4061,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		ret = snp_begin_ext_guest_req(vcpu);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 746f819a6de4..7af6d0e9de17 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -303,6 +303,9 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	/* Transaction ID associated with SNP config updates */
+	u64 snp_transaction_id;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 09d62870306b..30638d10a1b9 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -611,3 +611,24 @@ void snp_resume_attestation(u64 *transaction_id)
 	mutex_unlock(&snp_pause_attestation_lock);
 }
 EXPORT_SYMBOL_GPL(snp_resume_attestation);
+
+u64 snp_transaction_get_id(void)
+{
+	return snp_transaction_id;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_get_id);
+
+bool snp_transaction_is_stale(u64 transaction_id)
+{
+	bool stale;
+
+	mutex_lock(&snp_pause_attestation_lock);
+
+	stale = (snp_attestation_paused ||
+		 transaction_id != snp_transaction_id);
+
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return stale;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_is_stale);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e33c48bfbd67..585de3a2591e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -138,6 +138,7 @@ struct kvm_xen_exit {
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
 #define KVM_USER_VMGEXIT_PSC		2
+#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -151,6 +152,11 @@ struct kvm_user_vmgexit {
 			__u64 shared_gpa;
 			__u64 ret;
 		} psc;
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+			__u32 ret;
+		} ext_guest_req;
 	};
 };
 
-- 
2.25.1




