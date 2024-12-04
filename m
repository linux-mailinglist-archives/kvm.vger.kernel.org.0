Return-Path: <kvm+bounces-33096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2EF9E48A1
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB0C416A744
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD971202C51;
	Wed,  4 Dec 2024 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0FSubJpU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D1202C2C;
	Wed,  4 Dec 2024 23:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733354433; cv=fail; b=Nd8rg0IUdozWbeYEdIFyuTAWEzZCSxgDkGba3iGk4LAYK1gwr1BQh4sxI7F69/QOmmLupECOGzhXfvrY2zlxtHRf9qY+iBhGlJfdtKjNpW273QJHK5ZD7RvCPp0cWNAR8GFGAGWb7QmimXULeYsYBTg0JkFU/qcPdG3r6NMtXNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733354433; c=relaxed/simple;
	bh=fzrI1CcqcdZjq2+Y5uwWdKJMHEGHtCopdH3ACggw530=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BXTHFsvbvtlTVt5TYSoCg6J/GMoMcuzkO/7GKbJxlrIJq9T2FyOFp04jclR6tCYqjdgWWX6YQNc0VBwqlht3SuloHZtBSlMWE7HVUmRFzdhdF3JggNDqq9e9+JPRlA7+BrPBsDnz0Sas1xwQcXeZViUlzrkFTijRCIOYtMrjpkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0FSubJpU; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GxtGa0TxFuJv2wEYwMYZVbu9LZClhXCxsajZFy6fDhWP9rAIXkj3a3AUBs02AVYxAZHVAmh+kLpb1NN1jk5VX36yrrzBP6b3LdgLW+1mn73pltdIiKy6SwU5I65FSHnBzjv8Fo6CgBCQNG1Fm0A4ywsjOWNJhbgjsQe1wkcJ6IammWyh/83SUUlTpmJViQ6o5AsUaUVX0/KMXdCSx11VRjbsr1Llj3X7OYtWcM/stP0+W7Dl5CVlCkNPAr1/zlIfPJInodf/A40hWpsu8hzgjSCsaaDbquxDv+EbiOBgYvd5gYmV5aAGERnmUTHu2MvJ3Z+hzS5lrvH3EzDHiCRxqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EudeW9VZGaGmLkAamVTFLv3cfmCnAAVabxzS4nPepB8=;
 b=lQ0EyfFtnN7nyYEQqL9HZce98it7v7fQqc8p+qZAVZKPBvZRK2u1XZrLpVLBtJRKUM2NgF8wNJ+AxtG4MYX9Wbh8BfttintGbfN4sqcp0PD6P8GZ6Q1LdPU6mlG9MK0efrZQlYOrXDyS21EXRNyNDGAte1f2iiFurGkra1KrBSdpDejc80lEG+GLg9IP9VYXkP2rXgExjQn3SyLrD6Sa9BfpWAwSpYG7KXGDwJTQHCeXFgP2zqCU1n0xj/XrKQqrXFYeeEMK/8wD8PqgDNEdt19t2jNG1t8QaUvehFAjo54UpHCQxym9js9D+Xrc/6euUyuEUZnMZ8tEM25Amc+XTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EudeW9VZGaGmLkAamVTFLv3cfmCnAAVabxzS4nPepB8=;
 b=0FSubJpUcfz+AuBvDfs6vYam8+EMN8tkw7J5VJBNBYP5MF57AtPgI7cidUsRaJurGRUazQILzfrAWS2bxBZpk3ftxljA60xX5ZrRMM/SAKCqJE33BizVTk4r9MOD+udCbHihVG+j8tQcDZwQGsi4MK++5qPhV1py35fFWZQwGJU=
Received: from BN9PR03CA0589.namprd03.prod.outlook.com (2603:10b6:408:10d::24)
 by CY8PR12MB7682.namprd12.prod.outlook.com (2603:10b6:930:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 23:20:27 +0000
Received: from BN1PEPF00006001.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::b2) by BN9PR03CA0589.outlook.office365.com
 (2603:10b6:408:10d::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.19 via Frontend Transport; Wed,
 4 Dec 2024 23:20:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006001.mail.protection.outlook.com (10.167.243.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Wed, 4 Dec 2024 23:20:27 +0000
Received: from [10.23.193.138] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 4 Dec
 2024 17:20:26 -0600
Message-ID: <468c6bd8-75ba-4f2f-b300-998e5ec23c4e@amd.com>
Date: Wed, 4 Dec 2024 15:20:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SVM: Convert plain error code numbers to defines
To: Sean Christopherson <seanjc@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, KVM
	<kvm@vger.kernel.org>, Pavan Kumar Paluri <papaluri@amd.com>
References: <20241202214032.350109-1-huibo.wang@amd.com>
 <Z05MrWbtZQXOY2qk@google.com> <c09a99e8-913f-4a86-ba0b-c64d5cdcfb2e@amd.com>
 <Z0-nO-iyICRy_m5S@google.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <Z0-nO-iyICRy_m5S@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006001:EE_|CY8PR12MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b131386-9dc2-4bbc-5a18-08dd14ba3ce9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3FoWHM3NUdjcUphNnp5d05DUGpzbXNSQXl5ZTFJV2UzS1FNOFRqaDBzbVRQ?=
 =?utf-8?B?bEFJQmFwN3pibkxZMlRoVnV5SEdsUU85cUVWTGdXM0pvMi9sRDdjKzR4c3hC?=
 =?utf-8?B?K2E1VDlucVczRmFremREZlJkQ25kOENNbFVvQU5hZ3J1bHBBUWRxelVjZlJK?=
 =?utf-8?B?a3o4KzJ3RmFrREQwaHJXS0pkVFFMYnIvSWVBcTV3eUQ4TUEralV4L0JvTlFO?=
 =?utf-8?B?cnBSWVRRUWRsQ3RhRVBXUWhuZk1wMy83dmRlYTJrcytwb0U0UFRVdXNoZlYw?=
 =?utf-8?B?bVc4TWxmT0hkUFJWR3E5MURUNjdMbFZKWUE1eGxjMlpDVWI0dDU4V2hBdDBo?=
 =?utf-8?B?cVI2bW9BazJKemNqRUZ6K1g0K0RsY3oxMmNMeFFTYm5ZTmNQMHdvSWdrejBX?=
 =?utf-8?B?dGo1VWNQZk1ZWU1VS0ZvMit6Sjh5MVpqNDhsdHNWKzR3UUJoUnJGa1RNWEJX?=
 =?utf-8?B?aXBVWWdydUE1aFA4cEZRZ0pHaGx4WkQ5amZUK2R2a2g3QitYNTErTE5TRWdK?=
 =?utf-8?B?azBXeXQ4N0dPd3ZqMWxlV3VZWklITlVkTk4vY3E5YWZlWjA4dDNONWtFUkJh?=
 =?utf-8?B?cUdvd1B1NkVmRUU2ZlM5aEx0WDVuZVdBUFRWMUVUM0hqQmpBY3RBbW1FeXF4?=
 =?utf-8?B?bFVZTXcwK1JLdm9PalFtVGhXZXJhbDByUHUrZ3lpQWl6WVlQU2V3YkZjaXVs?=
 =?utf-8?B?SEsveU5PaXF1TGF6UnduL0Yyb0gwWGNOcmRqT1YyVTQ1VlZqSkM4SG1wSmU5?=
 =?utf-8?B?Q3g4ZG9sVDZwMy9PZEw4VFNCQmZHOGFtLzhuK3NyYWFXZlU1Nzd3SlE3SkdL?=
 =?utf-8?B?eE94WXZKSWJqdytDMks5RUtnWmlKMjBJandoVklTS0k3L2lJWUVoY2o5akZs?=
 =?utf-8?B?aXdoa2g1enBHOXlWRDg3MkN1bXQ5d05VSWgwQ1JKTGJ2RTFRY3JVODZ5K2tP?=
 =?utf-8?B?YTV2bGUvSnQvTjhSS2tiQktsTFBSYS84YmVwQjQ1cEY5NjV1MVkxc24xUnVF?=
 =?utf-8?B?T3BJazNKeGlTZFZ0MjZnZUFldk9jaVU1cnM5SnVjazRrY1dkWitoTFoxYTdU?=
 =?utf-8?B?YmNvY0QreXZ2WUIvSC9LUjhaUThDbTNPK3hXQmhaV1VhS2c0V1RQUzNGYmI2?=
 =?utf-8?B?SlV5ZmJLRXQzTVAzMEhuY1VJU3AwR3ZJRVFmMkN6K2NHc0ZmUDRHYVJFeFBW?=
 =?utf-8?B?VStWQVFZcDM2elRKQ2RkMG1uR3JYUWpiSTRTY1dhdVlXYUNvVm9na1FEdTg3?=
 =?utf-8?B?bkluRFQrNEtaMS8wNnFleWZpdDlWZDNoT1JkMmRLZ0gzbDFDb3RGYm9wQ3dN?=
 =?utf-8?B?a0oxZGpFaXlUT3dZMHR3STA4TWpWa296Z0doT3lsZHJucVVMUzNGaXh1V2Zj?=
 =?utf-8?B?dC9NZlVRNUQ0OUl1TEliVUxkOXF3RGprUk4vcnZ2SzFDREszM2hEb3Y5Umov?=
 =?utf-8?B?TjhYdktWakRJblpJK1E0UnZoenhGY3dBWXJXcm1uYVBPOHJYUWlaNDJUUDBK?=
 =?utf-8?B?dG93MmhlRTZ2ZTY0bjZJQnY2ZGNDZytYV0tXOFJlZXhxTWphbWRzSS8rU2g1?=
 =?utf-8?B?Zkhqdm1RamYxczVJYnZpcWRzTUlCVFcwdGhWdW5VWjRUNzlvRFJLWlpQamlx?=
 =?utf-8?B?dDVsajM4aXh3L2U2VzdRWFhtK3QyTnVCbXBsRVJPMldld0JteDBtVkxQekVG?=
 =?utf-8?B?M2ZUMHlRZkx5d3g5cmZvWlhoeG5CUHNabDZmZjg4ajRFU29ua1pnRHFSU0lr?=
 =?utf-8?B?Z2ZDY1RCWGloVzlxczVJa0szL3lJczdTU2UzVXcwSG1lWW5BMTEyc3dsdjJC?=
 =?utf-8?B?Y05FcGFOUzF2UitFckkzYnNDUnFLWHRLWjdDZlkrWUVFdmU1SWlLaEFMWWw1?=
 =?utf-8?B?bzA4ZHplRm8wTUdBU2E4VnJxOGZsVDBydXZVR1NjV3IxcFpIV3pCdWg4aXV0?=
 =?utf-8?Q?aqPxxrAB4r5o/KBF0A4hdo4quUSsiKR1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 23:20:27.4251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b131386-9dc2-4bbc-5a18-08dd14ba3ce9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006001.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7682

Hi Sean,

On 12/3/2024 4:50 PM, Sean Christopherson wrote:
> On Tue, Dec 03, 2024, Melody (Huibo) Wang wrote:
>> Hi Sean,
>>
>> On 12/2/2024 4:11 PM, Sean Christopherson wrote:
>>
>>>
>>> E.g. something like this?  Definitely feel free to suggest better names.
>>>
>>> static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
>>> 					       u64 response, u64 data)
>>> {
>>> 	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
>>> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
>>> }
>>>
>> If I make this function more generic where the exit info is set for both KVM
>> and the guest, then maybe I can write something like this:
> 
> I like the idea, but I actually think it's better to keep the guest and host code
> separate in the case, because the guest code should actually set a triple, e.g.
> 
> static __always_inline void sev_es_vmgexit_set_exit_info(struct ghcb *ghcb,
> 							 u64 exit_code,
> 							 u64 exit_info_1,
> 							 u64 exit_info_2)
> {
> 	ghcb_set_sw_exit_code(ghcb, exit_code);
> 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> }
> 
> I'm not totally opposed to sharing code, but I think it will be counter-productive
> in this specific case.  E.g. the guest version needs to be __always_inline so that
> it can be used in noinstr code.
> 
>> void ghcb_set_exit_info(struct ghcb *ghcb,
>>                       u64 info1, u64 info2)
>> {
>> 	ghcb_set_sw_exit_info_1(ghcb, info1);
>> 	ghcb_set_sw_exit_info_2(ghcb, info2);
>>
>> }
>> This way we can address every possible case that sets the exit info - not only KVM. 
>>
>> And I am not sure about the wrappers for each specific case because we will
>> have too many, too specific small functions, but if you want them I can add
>> them.
> 
> I count three.  We have far, far more wrappers VMX's is_exception_n(), and IMO
> those wrappers make the code significantly more readable.
Below is an untested yet conversion of the easy cases. I will take a look at converting the more complicated ones where not both exit info are set together, and see whether it looks more readable. 

Thanks,
Melody

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e7db7a5703b7..0ed6bbdf949e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3433,8 +3433,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
+	svm_vmgexit_bad_input(svm, reason);
 
 	/* Resume the guest to "return" the error code. */
 	return 1;
@@ -3577,8 +3576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -4124,8 +4122,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
 
@@ -4317,8 +4314,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
+	svm_vmgexit_success(svm, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
@@ -4367,8 +4363,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
@@ -4397,8 +4392,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58bce5f1ab0c..104e13d59c8a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2977,11 +2977,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
-				X86_TRAP_GP |
-				SVM_EVTINJ_TYPE_EXEPT |
-				SVM_EVTINJ_VALID);
+	svm_vmgexit_inject_exception(svm, X86_TRAP_GP);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..baff8237c5c9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -588,6 +588,30 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 		return false;
 }
 
+static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
+						u64 response, u64 data)
+{
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
+}
+
+static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8 vector)
+{
+	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;
+
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
+}
+
+static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suberror)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror);
+}
+
+static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_SUCCESS, data);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 


 


