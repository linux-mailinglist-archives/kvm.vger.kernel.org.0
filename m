Return-Path: <kvm+bounces-13207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B89589336C
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D23528455B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E53E14901F;
	Sun, 31 Mar 2024 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2/X0W5nB"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9156E146A8D;
	Sun, 31 Mar 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902743; cv=fail; b=er3todG/lxAaJ8JQubjY7AfgMG0s4nkYgFu0tb3/ja1LgNkQ13P2hVoaO6apbCH4bTBArrAhqwQnnh5yxIY/2HZ+ZuRcZ2CkNVsQcaSf+BoZD2J+z/G+oiaSt5h/HUr+MhFIOzwlV4+QuRdcfoJSp3hM9j5the4+kfdVDrPSb1k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902743; c=relaxed/simple;
	bh=gt6j4x7GufaKcf22shv/JTw36NpUYGVF/kFVAphruJE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUVhsj/EN9J7d8rbK0Vn0YHB5BGOXLZxVdWGyAkyBQOkbOBPo6JZdRlYGt2iBbqy7DE9wOo8On0WAfKcfzKi7mSJjM8XBieVnFn9MPa9bE3i6UtJsS0eI9ZvQ/WTQkHRimzIiF5F7Zj22fDqgBWHGWGKTsAtbtqMbnZOaLUL2As=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/X0W5nB reason="signature verification failed"; arc=fail smtp.client-ip=40.107.237.50; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 4399F207C6;
	Sun, 31 Mar 2024 18:32:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1ConbLyp-ddG; Sun, 31 Mar 2024 18:32:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 0620F207D8;
	Sun, 31 Mar 2024 18:32:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 0620F207D8
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id E28BF800050;
	Sun, 31 Mar 2024 18:26:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:26:30 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:36 +0000
X-sender: <kvm+bounces-13136-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAEJTp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBBAAAAjYoAAAUABAAUIAEAAAAYAAAAbWFydGluLndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 31772
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13136-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com AB76620754
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753651; cv=fail; b=bf2jjCnhfXgVAh7Q/vA+TDx++V8aXhhvWMk42IW5HCrtGoHL8rug4Se8kCeg80THGFe5gLYZoTMiZBDzo0UPw0m1VmU4F75xpU4Op95o18NaTDpab6l9/ExmwdSlo5pcHI3hyyX/nzUUqVyZ+ggzpj8vbHcp8bJ9WgrEsLcsI+s=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753651; c=relaxed/simple;
	bh=AuY2NMnF/F0eKaAZp9hi/QFwQoIZNLKhY4i1/5N3D9s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHcLqA1zJJJw1emEI6Mt5T6jfWTlJK9ybjmsnXwEFNUYEC70cTAKaqpsKvMqqk00m++zDptjHzoR2oJ99t/HvPvowJIq2V8y8RYa6k+Ud1ji9Pwv+QY5k9adJ2A+GGT07KHI6Gm2g6T8KM7oYaTAlBKl+q4g0vsa4lKSKCTbYBE=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/X0W5nB; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8RyJEt/gLT+Q3ntE+VTap3fAuWeh0NusiwR8TjW9b5LKQpD0e5iXZTC2PjyhwF6NHQH5PgtiaLGczcledBExFT2vBw/BXWj/9Dc6skUj1Zf9BuCWXMqJXnCv92Sj2RAaj/DHi2CbZRloCM88HF4osOkw0lD+qidmEYFqMZyjlXE8gulAp5FQLuKrk0MPhXsf6pAV9h/29/ZAGnMh0tHw6p4D9nkBDiwMQmyq0+HJd4U/fRw2RPucWJD9USgMgmcFY6VEpGBX98Q86v2R3LohXaUiDHagz1RaV3FKN8ITDyL1neYoxhZDz5ED9Fe7E5SHBn5E/PGig8+2ge6XYFagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=;
 b=KSxusj4xyHoqDKiHZ3XSJVVpROATGNSMyeu4tPRhqpSV5joO8dnTQyfhaywwop+AlfwRLP98z8ReRm6BYKp5uvOUtdfDMpIY2hw6N5FcewbiTcqIgOb6iYkYEk96MF+uT/6/WvVPAOoWIQiNVyuMZCukydE1RSA6rxg8GJIBCh7C7DSsaXlLixAKF4brgYQ78zw5zbKj5X6W1hWq7v91OaPGob06PN8FxZulC4+L4v1XMZRxYBVKyYe2aQz6FdEZbOv6Uoq98i7PfYbZPqaU7Bcxm39QZC5Y/NkYZT3LdI4rhQenigbWTzqnnPVOCpejj5mjfqwK1BcPKXSRmwNCKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=;
 b=2/X0W5nBoIQgjPbXpzId5s79hkITJn4qEsCseoAaWqcXrrOC8u7BAqa7BlB12MS2MFzs2IQWh6ZvKCUqVljnldha36u3xKoNXDtRdTFhpgWqpldjTTWo0+5punzN0zonCHtehR9jGW/7BNddBXIEU86anrjLUTtar714Kubvn6Q=
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
Subject: [PATCH v12 03/29] [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()
Date: Fri, 29 Mar 2024 17:58:09 -0500
Message-ID: <20240329225835.400662-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|BY5PR12MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7d57fe-8506-46bc-df93-08dc5044ff0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cxx5VtOLnKMFgtSO/4Wzq/K44byZ3gsNedFkAhUlTQdg7uoHF1mDoAWqN9Lq6q18OCw05/wnFfUjWEGS1PQyIQYsIULWCQU9m0N7R48F14iU95iVtSh5pS+N0oSISCyGJcVv0qQCCsiEJ/zR1ktHTH15ttTkHWd42a+mgjcW0fiByNMuhaWyORvfePFPs2Ur17gmZOfUTAi053KJ0VPMm5gbizMLN98+IrAwICpwm26vVKAdXZ85Um+YStUR+GnQCuONHP6Mfmfmtu8tsoVV41VAviL/JLM5kuQcAI9yE4XLhD2iHjLVmyHS2SwcwiOEkxMbCykkHNFRF2c0GHNhLGIXZ6+jX7hPpGQopaAE/eNMnd3PM0UEhNw3z3z16pq4DZtKlVRiKswy1cCMyAoSB+wuXwZGuSm0MEHBjWcG7LyFzFP2ZL+gN9e1dN1c2vzg56xEL1lHud3XAfsgKGdZOCG8F7Ccv4jub4Rc6ryuv7DAuToeF9dfDWmfw54Sif1UaHuS19WaO/GbLq+3PY7WlwhL8S0lV1lbStm7Ti/KVTjFdOljrPL00KXRjEBuz40MRSu6yjD8BP6l4mOeqPT+4SYsiNe6d0W312YPuThmbgOM8jUJUel1WHP5fvJ2dzXmke3lnLw+VhGS77DrCjVyc6c9Lk4C2NnwNOD0AncvFHVCq448mue4TSALjPmzPqmAeUpDhbuDWWB7jkMxNYqyvS3bxhm0h9NbU7qB6W2Bz1k+2J7kYICtPwlzJGld1GOW
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:24.6058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7d57fe-8506-46bc-df93-08dc5044ff0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The host SNP worthiness can determined later, after alternatives have
been patched, in snp_rmptable_init() depending on cmdline options like
iommu=3Dpt which is incompatible with SNP, for example.

Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
have a special flag for that control.

Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.

Move kdump_sev_callback() to its rightfull place, while at it.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h         |  4 ++--
 arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
 arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
 arch/x86/kernel/sev.c              | 10 --------
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
 drivers/crypto/ccp/sev-dev.c       |  2 +-
 drivers/iommu/amd/init.c           |  4 +++-
 8 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9477b4053bce..780182cda3ab 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -228,7 +228,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp_r=
eq_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
-void kdump_sev_callback(void);
 void sev_show_status(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
@@ -258,7 +257,6 @@ static inline int snp_issue_guest_request(u64 exit_code=
, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) {=
 }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
-static inline void kdump_sev_callback(void) { }
 static inline void sev_show_status(void) { }
 #endif
=20
@@ -270,6 +268,7 @@ int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool=
 immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
+void kdump_sev_callback(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)=
 { return -ENODEV; }
@@ -282,6 +281,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, en=
um pg_level level, u32 as
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -=
ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void kdump_sev_callback(void) { }
 #endif
=20
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6d8677e80ddb..9bf17c9c29da 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -345,6 +345,28 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
=20
+static void bsp_determine_snp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+	cc_vendor =3D CC_VENDOR_AMD;
+
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and is defined by the
+		 * per-processor PPR. Restrict SNP support on the known CPU models
+		 * for which the RMP table entry format is currently defined for.
+		 */
+		if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
+		    c->x86 >=3D 0x19 && snp_probe_rmptable_info()) {
+			cc_platform_set(CC_ATTR_HOST_SEV_SNP);
+		} else {
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+			cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+		}
+	}
+#endif
+}
+
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
@@ -452,21 +474,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
=20
-	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
-		/*
-		 * RMP table entry format is not architectural and it can vary by proces=
sor
-		 * and is defined by the per-processor PPR. Restrict SNP support on the
-		 * known CPU model and family for which the RMP table entry format is
-		 * currently defined for.
-		 */
-		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN5))
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-		else if (!snp_probe_rmptable_info())
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-	}
-
+	bsp_determine_snp(c);
 	return;
=20
 warn:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/=
generic.c
index 422a4ddc2ab7..7b29ebda024f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,7 +108,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >=3D 0x0f)))
 		return;
=20
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
=20
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b59b09c2f284..1e1a3c3bd1e8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2287,16 +2287,6 @@ static int __init snp_init_platform_device(void)
 }
 device_initcall(snp_init_platform_device);
=20
-void kdump_sev_callback(void)
-{
-	/*
-	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
-	 * safely do SNP_SHUTDOWN on the local CPU.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		wbinvd();
-}
-
 void sev_show_status(void)
 {
 	int i;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d30bd30d4f7a..7b872f97a452 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3279,7 +3279,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcp=
u)
 	unsigned long pfn;
 	struct page *p;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
=20
 	/*
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cffe1157a90a..ab0e8448bb6e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -77,7 +77,7 @@ static int __mfd_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -98,7 +98,7 @@ static int __snp_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -174,11 +174,11 @@ static int __init snp_rmptable_init(void)
 	u64 rmptable_size;
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	if (!amd_iommu_snp_en)
-		return 0;
+		goto nosnp;
=20
 	if (!probed_rmp_size)
 		goto nosnp;
@@ -225,7 +225,7 @@ static int __init snp_rmptable_init(void)
 	return 0;
=20
 nosnp:
-	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 	return -ENOSYS;
 }
=20
@@ -246,7 +246,7 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, =
int *level)
 {
 	struct rmpentry *large_entry, *entry;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return ERR_PTR(-ENODEV);
=20
 	entry =3D get_rmpentry(pfn);
@@ -363,7 +363,7 @@ int psmash(u64 pfn)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	if (!pfn_valid(pfn))
@@ -472,7 +472,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret, level;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	level =3D RMP_TO_PG_LEVEL(state->pagesize);
@@ -558,3 +558,13 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
 EXPORT_SYMBOL_GPL(snp_leak_pages);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		wbinvd();
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f44efbb89c34..2102377f727b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1090,7 +1090,7 @@ static int __sev_snp_init_locked(int *error)
 	void *arg =3D &data;
 	int cmd, rc =3D 0;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	sev =3D psp->sev_data;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e7a44929f0da..33228c1c8980 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3228,7 +3228,7 @@ static bool __init detect_ivrs(void)
 static void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 	/*
 	 * The SNP support requires that IOMMU must be enabled, and is
@@ -3236,12 +3236,14 @@ static void iommu_snp_enable(void)
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
 		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP canno=
t be supported.\n");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
 	amd_iommu_snp_en =3D check_feature(FEATURE_SNP);
 	if (!amd_iommu_snp_en) {
 		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n")=
;
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
--=20
2.25.1


X-sender: <linux-kernel+bounces-125515-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAEJTp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBCAAAAjYoAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 31863
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:08:06 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:08:06 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 342C0207E4
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:08:06 +0100 (CET)
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
	with ESMTP id pC7s6ytjgtZQ for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:08:05 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125515-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 9D87220754
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 9D87220754
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B742846B6
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7A313E6BE;
	Fri, 29 Mar 2024 23:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"2/X0W5nB"
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12=
on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9439D13E6B9;
	Fri, 29 Mar 2024 23:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.237.50
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753651; cv=3Dfail; b=3Dbf2jjCnhfXgVAh7Q/vA+TDx++V8aXhhvWMk42IW5HCr=
tGoHL8rug4Se8kCeg80THGFe5gLYZoTMiZBDzo0UPw0m1VmU4F75xpU4Op95o18NaTDpab6l9/E=
xmwdSlo5pcHI3hyyX/nzUUqVyZ+ggzpj8vbHcp8bJ9WgrEsLcsI+s=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753651; c=3Drelaxed/simple;
	bh=3DAuY2NMnF/F0eKaAZp9hi/QFwQoIZNLKhY4i1/5N3D9s=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DCHcLqA1zJJJw1emEI6Mt5T6jfWTlJK9ybjmsnXwEFN=
UYEC70cTAKaqpsKvMqqk00m++zDptjHzoR2oJ99t/HvPvowJIq2V8y8RYa6k+Ud1ji9Pwv+QY5k=
9adJ2A+GGT07KHI6Gm2g6T8KM7oYaTAlBKl+q4g0vsa4lKSKCTbYBE=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3D2/X0W5nB; arc=3Dfail smtp.client-ip=3D40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DB8RyJEt/gLT+Q3ntE+VTap3fAuWeh0NusiwR8TjW9b5LKQpD0e5iXZTC2PjyhwF6NHQH5P=
gtiaLGczcledBExFT2vBw/BXWj/9Dc6skUj1Zf9BuCWXMqJXnCv92Sj2RAaj/DHi2CbZRloCM88=
HF4osOkw0lD+qidmEYFqMZyjlXE8gulAp5FQLuKrk0MPhXsf6pAV9h/29/ZAGnMh0tHw6p4D9nk=
BDiwMQmyq0+HJd4U/fRw2RPucWJD9USgMgmcFY6VEpGBX98Q86v2R3LohXaUiDHagz1RaV3FKN8=
ITDyL1neYoxhZDz5ED9Fe7E5SHBn5E/PGig8+2ge6XYFagw=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DtaVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=3D;
 b=3DKSxusj4xyHoqDKiHZ3XSJVVpROATGNSMyeu4tPRhqpSV5joO8dnTQyfhaywwop+AlfwRLP=
98z8ReRm6BYKp5uvOUtdfDMpIY2hw6N5FcewbiTcqIgOb6iYkYEk96MF+uT/6/WvVPAOoWIQiNV=
yuMZCukydE1RSA6rxg8GJIBCh7C7DSsaXlLixAKF4brgYQ78zw5zbKj5X6W1hWq7v91OaPGob06=
PN8FxZulC4+L4v1XMZRxYBVKyYe2aQz6FdEZbOv6Uoq98i7PfYbZPqaU7Bcxm39QZC5Y/NkYZT3=
LdI4rhQenigbWTzqnnPVOCpejj5mjfqwK1BcPKXSRmwNCKA=3D=3D
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
 bh=3DtaVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=3D;
 b=3D2/X0W5nBoIQgjPbXpzId5s79hkITJn4qEsCseoAaWqcXrrOC8u7BAqa7BlB12MS2MFzs2I=
QWh6ZvKCUqVljnldha36u3xKoNXDtRdTFhpgWqpldjTTWo0+5punzN0zonCHtehR9jGW/7BNddB=
XIEU86anrjLUTtar714Kubvn6Q=3D
Received: from DM6PR11CA0030.namprd11.prod.outlook.com (2603:10b6:5:190::43=
)
 by BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:07:25 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:190:cafe::57) by DM6PR11CA0030.outlook.office365.com
 (2603:10b6:5:190::43) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:07:24 +0000
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
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:07:23 -0500
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
Subject: [PATCH v12 03/29] [TEMP] x86/CPU/AMD: Track SNP host status with c=
c_platform_*()
Date: Fri, 29 Mar 2024 17:58:09 -0500
Message-ID: <20240329225835.400662-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|BY5PR12MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7d57fe-8506-46bc-df93-08dc5044ff=
0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cxx5VtOLnKMFgtSO/4Wzq/K44byZ3gsNedFkAhUl=
TQdg7uoHF1mDoAWqN9Lq6q18OCw05/wnFfUjWEGS1PQyIQYsIULWCQU9m0N7R48F14iU95iVtSh=
5pS+N0oSISCyGJcVv0qQCCsiEJ/zR1ktHTH15ttTkHWd42a+mgjcW0fiByNMuhaWyORvfePFPs2=
Ur17gmZOfUTAi053KJ0VPMm5gbizMLN98+IrAwICpwm26vVKAdXZ85Um+YStUR+GnQCuONHP6Mf=
mfmtu8tsoVV41VAviL/JLM5kuQcAI9yE4XLhD2iHjLVmyHS2SwcwiOEkxMbCykkHNFRF2c0GHNh=
LGIXZ6+jX7hPpGQopaAE/eNMnd3PM0UEhNw3z3z16pq4DZtKlVRiKswy1cCMyAoSB+wuXwZGuSm=
0MEHBjWcG7LyFzFP2ZL+gN9e1dN1c2vzg56xEL1lHud3XAfsgKGdZOCG8F7Ccv4jub4Rc6ryuv7=
DAuToeF9dfDWmfw54Sif1UaHuS19WaO/GbLq+3PY7WlwhL8S0lV1lbStm7Ti/KVTjFdOljrPL00=
KXRjEBuz40MRSu6yjD8BP6l4mOeqPT+4SYsiNe6d0W312YPuThmbgOM8jUJUel1WHP5fvJ2dzXm=
ke3lnLw+VhGS77DrCjVyc6c9Lk4C2NnwNOD0AncvFHVCq448mue4TSALjPmzPqmAeUpDhbuDWWB=
7jkMxNYqyvS3bxhm0h9NbU7qB6W2Bz1k+2J7kYICtPwlzJGld1GOW
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:24.6058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7d57fe-8506-46bc-df93-08dc5=
044ff0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017091.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
Return-Path: linux-kernel+bounces-125515-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:08:06.2338
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: c21458c2-4e02-4c25-f16f-08dc=
504517d1
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.438|SMR=3D0.331(SMRDE=3D0.035|SMRC=3D0.29=
5(SMRCL=3D0.103|X-SMRCR=3D0.294))|CAT=3D0.107(CATOS=3D0.014
 (CATSM=3D0.013(CATSM-Malware
 Agent=3D0.013))|CATRESL=3D0.041(CATRESLP2R=3D0.019)|CATORES=3D0.050
 (CATRS=3D0.049(CATRS-Transport Rule Agent=3D0.001|CATRS-Index Routing
 Agent=3D0.048)));2024-03-29T23:08:06.675Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 21732
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.026|SMR=3D0.026(SMRPI=3D0.022(SMRPI-FrontendProxyAgent=3D0.022))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAeYRAAAPAAADH4sIAAAAAAAEAOVaCXPb=
RpYGb4m6HDszzj
 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
 liS2m+SJP70CiHfxCGR033Mkx9Sbc3K2DP0JeifYpgWBTmWqabyRWs
 wH0K1JisQG+3MBQD23+KJg5kY43OChqljbnkcjfGQy4AquR77rVPz3
 wllCgwwc//DcmCZQE6QQAAAQrKAjw/eG1sIHZlcnNpb249IjEuMCIg
 ZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2
 lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAgICA8
 RW1haWwgU3RhcnRJbmRleD0iMzEiPg0KICAgICAgPEVtYWlsU3RyaW
 5nPmJwQGFsaWVuOC5kZTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFp
 bD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iNTc5IiBQb3NpdGlvbj
 0iU2lnbmF0dXJlIj4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVs
 LnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD
 4NCiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEMnQc8P3htbCB2ZXJz
 aW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxDb250YWN0U2
 V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPENv
 bnRhY3RzPg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjUxMiI+DQ
 ogICAgICA8UGVyc29uIFN0YXJ0SW5kZXg9IjUxMiI+DQogICAgICAg
 IDxQZXJzb25TdHJpbmc+Qm9yaXNsYXYgUGV0a292PC9QZXJzb25TdH
 Jpbmc+DQogICAgICA8L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQog
 ICAgICAgIDxFbWFpbCBTdGFydEluZGV4PSI1MzUiPg0KICAgICAgIC
 AgIDxFbWFpbFN0cmluZz5icEBhbGllbjguZGU8L0VtYWlsU3RyaW5n
 Pg0KICAgICAgICA8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogIC
 AgICA8Q29udGFjdFN0cmluZz5Cb3Jpc2xhdiBQZXRrb3YgKEFNRCkg
 Jmx0O2JwQGFsaWVuOC5kZTwvQ29udGFjdFN0cmluZz4NCiAgICA8L0
 NvbnRhY3Q+DQogICAgPENvbnRhY3QgU3RhcnRJbmRleD0iNTY1IiBQ
 b3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAgIDxQZXJzb24gU3Rhcn
 RJbmRleD0iNTY1IiBQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAg
 ICAgPFBlcnNvblN0cmluZz5NaWNoYWVsIFJvdGg8L1BlcnNvblN0cm
 luZz4NCiAgICAgIDwvUGVyc29uPg0KICAgICAgPEVtYWlscz4NCiAg
 ICAgICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjU3OSIgUG9zaXRpb249Il
 NpZ25hdHVyZSI+DQogICAgICAgICAgPEVtYWlsU3RyaW5nPm1pY2hh
 ZWwucm90aEBhbWQuY29tPC9FbWFpbFN0cmluZz4NCiAgICAgICAgPC
 9FbWFpbD4NCiAgICAgIDwvRW1haWxzPg0KICAgICAgPENvbnRhY3RT
 dHJpbmc+TWljaGFlbCBSb3RoICZsdDttaWNoYWVsLnJvdGhAYW1kLm
 NvbTwvQ29udGFjdFN0cmluZz4NCiAgICA8L0NvbnRhY3Q+DQogIDwv
 Q29udGFjdHM+DQo8L0NvbnRhY3RTZXQ+AQ7PAVJldHJpZXZlck9wZX
 JhdG9yLDEwLDA7UmV0cmlldmVyT3BlcmF0b3IsMTEsMTtQb3N0RG9j
 UGFyc2VyT3BlcmF0b3IsMTAsMDtQb3N0RG9jUGFyc2VyT3BlcmF0b3
 IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3Is
 MTAsNjtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3IsMT
 EsMDtUcmFuc3BvcnRXcml0ZXJQcm9kdWNlciwyMCwyOQ=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 6067
X-MS-Exchange-Forest-EmailMessageHash: D6AED475
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The host SNP worthiness can determined later, after alternatives have
been patched, in snp_rmptable_init() depending on cmdline options like
iommu=3Dpt which is incompatible with SNP, for example.

Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
have a special flag for that control.

Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.

Move kdump_sev_callback() to its rightfull place, while at it.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h         |  4 ++--
 arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
 arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
 arch/x86/kernel/sev.c              | 10 --------
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
 drivers/crypto/ccp/sev-dev.c       |  2 +-
 drivers/iommu/amd/init.c           |  4 +++-
 8 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9477b4053bce..780182cda3ab 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -228,7 +228,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp_r=
eq_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
-void kdump_sev_callback(void);
 void sev_show_status(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
@@ -258,7 +257,6 @@ static inline int snp_issue_guest_request(u64 exit_code=
, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) {=
 }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
-static inline void kdump_sev_callback(void) { }
 static inline void sev_show_status(void) { }
 #endif
=20
@@ -270,6 +268,7 @@ int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool=
 immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
+void kdump_sev_callback(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)=
 { return -ENODEV; }
@@ -282,6 +281,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, en=
um pg_level level, u32 as
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -=
ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void kdump_sev_callback(void) { }
 #endif
=20
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6d8677e80ddb..9bf17c9c29da 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -345,6 +345,28 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
=20
+static void bsp_determine_snp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+	cc_vendor =3D CC_VENDOR_AMD;
+
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and is defined by the
+		 * per-processor PPR. Restrict SNP support on the known CPU models
+		 * for which the RMP table entry format is currently defined for.
+		 */
+		if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
+		    c->x86 >=3D 0x19 && snp_probe_rmptable_info()) {
+			cc_platform_set(CC_ATTR_HOST_SEV_SNP);
+		} else {
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+			cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+		}
+	}
+#endif
+}
+
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
@@ -452,21 +474,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
=20
-	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
-		/*
-		 * RMP table entry format is not architectural and it can vary by proces=
sor
-		 * and is defined by the per-processor PPR. Restrict SNP support on the
-		 * known CPU model and family for which the RMP table entry format is
-		 * currently defined for.
-		 */
-		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN5))
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-		else if (!snp_probe_rmptable_info())
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-	}
-
+	bsp_determine_snp(c);
 	return;
=20
 warn:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/=
generic.c
index 422a4ddc2ab7..7b29ebda024f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,7 +108,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >=3D 0x0f)))
 		return;
=20
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
=20
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b59b09c2f284..1e1a3c3bd1e8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2287,16 +2287,6 @@ static int __init snp_init_platform_device(void)
 }
 device_initcall(snp_init_platform_device);
=20
-void kdump_sev_callback(void)
-{
-	/*
-	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
-	 * safely do SNP_SHUTDOWN on the local CPU.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		wbinvd();
-}
-
 void sev_show_status(void)
 {
 	int i;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d30bd30d4f7a..7b872f97a452 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3279,7 +3279,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcp=
u)
 	unsigned long pfn;
 	struct page *p;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
=20
 	/*
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cffe1157a90a..ab0e8448bb6e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -77,7 +77,7 @@ static int __mfd_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -98,7 +98,7 @@ static int __snp_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -174,11 +174,11 @@ static int __init snp_rmptable_init(void)
 	u64 rmptable_size;
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	if (!amd_iommu_snp_en)
-		return 0;
+		goto nosnp;
=20
 	if (!probed_rmp_size)
 		goto nosnp;
@@ -225,7 +225,7 @@ static int __init snp_rmptable_init(void)
 	return 0;
=20
 nosnp:
-	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 	return -ENOSYS;
 }
=20
@@ -246,7 +246,7 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, =
int *level)
 {
 	struct rmpentry *large_entry, *entry;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return ERR_PTR(-ENODEV);
=20
 	entry =3D get_rmpentry(pfn);
@@ -363,7 +363,7 @@ int psmash(u64 pfn)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	if (!pfn_valid(pfn))
@@ -472,7 +472,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret, level;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	level =3D RMP_TO_PG_LEVEL(state->pagesize);
@@ -558,3 +558,13 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
 EXPORT_SYMBOL_GPL(snp_leak_pages);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		wbinvd();
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f44efbb89c34..2102377f727b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1090,7 +1090,7 @@ static int __sev_snp_init_locked(int *error)
 	void *arg =3D &data;
 	int cmd, rc =3D 0;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	sev =3D psp->sev_data;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e7a44929f0da..33228c1c8980 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3228,7 +3228,7 @@ static bool __init detect_ivrs(void)
 static void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 	/*
 	 * The SNP support requires that IOMMU must be enabled, and is
@@ -3236,12 +3236,14 @@ static void iommu_snp_enable(void)
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
 		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP canno=
t be supported.\n");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
 	amd_iommu_snp_en =3D check_feature(FEATURE_SNP);
 	if (!amd_iommu_snp_en) {
 		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n")=
;
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
--=20
2.25.1



