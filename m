Return-Path: <kvm+bounces-52011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E59AFF79F
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 05:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A94327B35B2
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE53284B56;
	Thu, 10 Jul 2025 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v8tkBPBf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDB7284670;
	Thu, 10 Jul 2025 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752118666; cv=fail; b=qd7p58euFcZuR/FL+Wgw1h60OUZtlVhjwVvuK+gmYUJGurH8FXSsgAM2WzrzhbBbAopCZmUdponI7tPO3fHlhGpiJVowv+9Z6VmJI0wgZSk+s3QrzZr8vM8wUi31yGJv+xsXaRR0YtM9o7wgziYks4hd/UD6MMYioNhMYrwqzgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752118666; c=relaxed/simple;
	bh=fROdV+f8pIRchKbFq0bzOhfthTUnnES5V4jd570XlWQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n6qCIvOX/79AgkO6d0Fu6UFGBS4a6N7GbIUcK98pjyhcL9XK/VhSsWrzRtb42NA19qaYQy78zmZBaLM7zYa/RqYfgl2TObKG6mEqXMkly/VqM+c67w/WQnbPmS4+u/KUYN6KS/AAdHpQz2awesNMyTa2Qj9AyKMgGXKO576NVOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v8tkBPBf; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/5m4ut6vuCx+9bzNfOVfbdcIV91DBWo8h2RbsYCDIw9H75DboP6EdSKznjxBKKBFc0wojHuvUCSTYmRuEBuP+ke8KQtcgoqp0Xa5nyoNzo/dPaEQ1QLihTqIjoiwuEfNe51/BiNrCtOA9pvIwttIPyBnhUT2pC1PMP1DWNUij5319WQqz3BlNMeSkgNYSJoF+hsyAR7qc/wbEjnyQu4xT21ey9g8cKYz2YVfcVfr9760dGY+ueG7TAv7I4TtQTkT+eU5BEDjd6z/IqwNCb2/WaJsVJXZ3ZmHP+DLxfrT2pc09BLmXMXQpSpyuhu66U4fca/CJv/bnaCodP1rPZ3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwi9X0RZayQ63gFepskQdaf2SirmApawgy0YWEA/pug=;
 b=NwbNiEYWI7SfKzW/bmJOBY1+ZoNCezVRZHuE8qW2GyjBHeg5J9CisX6mDJmKEE48zq34L8S+lLIFIJS5jAPuXa1wM8ITlgG0dXvc5yjbT8JTKgyvwW2q4nCuzXxoOd2tun93nwl7bMs4+J7JbGcUbqKJhd/A1osaeloVyM8OMeG/V4Vbye7um/RHzkk5spTLargjyisuLNuAwk+5fCC1nxe6CVx/VEoc+JmFrY747tJhODknI9M4vCGknHgPslZe2P2XSnfVjG5nvxDFlH8IYo4IdvRF7p9zphZW45F+vrXGgmTZM26JuCK/bySpmpst/3ilXjdMC0pGLrCbkj/T+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwi9X0RZayQ63gFepskQdaf2SirmApawgy0YWEA/pug=;
 b=v8tkBPBfNM1x/ey2Z8pDxTOLze+eFqTATsPDcvMwBGTxrcQ0ibN11SsvbXo+q94aDANk/TjmHw3pVCj97ufWYv5RJdaxlXh5fNvEFk8fDlGYHNJsZe+JI4a6PJi/QpfYH4W3AlDImSuqF5d6FiY8UmZjRyVe/M28UYmelLvtlUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA3PR12MB9177.namprd12.prod.outlook.com (2603:10b6:806:39d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.27; Thu, 10 Jul 2025 03:37:42 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 03:37:42 +0000
Message-ID: <c1baa9ee-baca-44ee-b777-fd0bfa177032@amd.com>
Date: Thu, 10 Jul 2025 09:07:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 04/35] KVM: x86: Rename VEC_POS/REG_POS macro
 usages
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
 nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, kai.huang@intel.com
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
 <aG54B8frrerb0pn4@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aG54B8frrerb0pn4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0177.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::32) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA3PR12MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b631446-92ae-48f7-6e6a-08ddbf63204f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mks1L2hUdzJXV29Eb2dVYWhZUzI0a3NlcUhaemowMGIvUXk5eUJQSytweEZV?=
 =?utf-8?B?empjNkZWakM3TWozRXFaMEZoVWhxVTluTjdmSzBTbVZZQmE2OEUxVWJxdU5s?=
 =?utf-8?B?ZmNiRWlTYnZFNEQ3c05vSTJIaFh4c3RGaHVGM3d2MFFrcDJnbzQvMFltY2s0?=
 =?utf-8?B?SE4xSGNKdk5WRTVJZ1B4R1czZ28raDE4MFN1YUduQUtQaVoyME1lZE4xajd4?=
 =?utf-8?B?d3ZmMHBwWU9KSVZGekY5cE9WaDFsUnlsSnR0TFlGVm04RmJ2WkhpZ09hV2VJ?=
 =?utf-8?B?Z3lJQ0c3M3lvSENpQlF5SG1PeVlsT21SU0xJdVpPdzkxamw5eW5CbWp0MG1K?=
 =?utf-8?B?Y1dyTSs2c0Z4Sk82b1hpM0hSTGw0MUNiTU1CTlhhTGF3MmtVUDR3RUxRdWVt?=
 =?utf-8?B?SCtiL0daQkc0UjE4dGUzNllkVnRQK1h2c0UxOVNKOHFUamk3MkE1WkFXU0Nt?=
 =?utf-8?B?dFF6cFh3TlhZOWxudlkwc2duUis3ekhmUEtQM29YRCtkQkZKUE4wYXNVZ0di?=
 =?utf-8?B?SWs3ZWRxcUVmUmtUQmRNV0tINTJoSU45YVQ4U3JYUG5NWUtENnNxcHdBVHIr?=
 =?utf-8?B?dXRTQk9tVXI3ZmthT3dYR3lrbVdOQXVQOWlTb2R3ZTRlZ3ZPTHAzZmlpNVN3?=
 =?utf-8?B?cCtWQ1lTTjQxRmszYVAyQm1jODFlZHc5OENoTTg0aTNRZGRicTFxMEhFKzdp?=
 =?utf-8?B?RVBTRW5nRWMzVGNkcGpWRW0wRGo2bVVzd3RiRXBiQUhDdHZocmpDbmgweWhQ?=
 =?utf-8?B?ZE5zTXNFUERTUmlxRlY2Wjcvbk1iZXdUbXZHNWlSV1lGd0JzRDN6K29sdFc4?=
 =?utf-8?B?ODE3ZUM3NWZucHhnRFJRUmJjRDhOa204UlFsWlAyWUI3R09VQkRLWEJNTXEz?=
 =?utf-8?B?Yzc1dWYyTzRiNmIwV2ZvK2NJcWVaS1lwZStQZHhUd1pCeU1VYURBa2lGQVF4?=
 =?utf-8?B?ZnU1ZTJVVEVMOEc0M3MrVTdadHhtMWthWjVoQzdIdXlOV2MrMCtpVnBRb3Na?=
 =?utf-8?B?cWp5ZlVuaHh3Y2N2S0JONVcyV2U2d2RTOHdOclZ1VzRoSWJ1Qk5nMmJreGZO?=
 =?utf-8?B?T3dqNnJCZkNlaVJVb2MxRUx1TVJDaUFMbXdYS1ZpNFhlN2pVYVUzK0FBNmpT?=
 =?utf-8?B?UUdkaHh5aDNPNitiaHJ2aVhWVnQ4OWFHNVk1ZVBJRjBnRnVFWG5yTWM5K3FX?=
 =?utf-8?B?VVAvMENMQnpObFhWUXdxd1RwUzdvM0VVWE52bzh2SVU4L2dwclBXamNVbW1u?=
 =?utf-8?B?WHNLeXkrQUZhUFJDcXhsUkwrallQQ2RlTHQrTk05bUxQOW9JZFB4NkdGN0VG?=
 =?utf-8?B?ZksxdE84NVlsMlVTaXQzRllKU1BMdFdUekIwS2FrMFlrVFlwblNPNmFDY09j?=
 =?utf-8?B?K0FwQTRDQ3oreVdXTDFnL0REeldNQ1ZYS3ZRNWJvWFhmOU5JekFKUWhOS3cx?=
 =?utf-8?B?RXg5UitVKzh1ZnhETVRBZWh3RGl2bW5LQUtkZStOb3RWUFphTTVNcy84MGxQ?=
 =?utf-8?B?RnZJYUR6VkJVRERtYUo3RisyWEhtMHlHd1gvSmJmR2ZEVkZWd1QxUTNVSUpj?=
 =?utf-8?B?MWMxRTl2QysyejFoYlhSYTNwYzhtRWtUb0RWV1RqazU2OUcyNVo3RzdYbllx?=
 =?utf-8?B?Q1B3ZzZDL2FmeFErNjU4aHh3MUJVTTNUeERaYUNRdXZNQ2h3d2RLOS92cEVh?=
 =?utf-8?B?dkZtUXU3blpDMXpVMkVGQk1GRStyTEpnbUxUMTJkRXozbG5CMnZjYmxIeXBo?=
 =?utf-8?B?Q2docXJ0Z3VrNU5IQXhBVFVQSnprdGdBU1dGcFovZkZDdTJGL1ptRjc0TmtU?=
 =?utf-8?B?TmJEcnBzNVJHOXFLb3VaOVRQZXZxV2J1N0ZBVjYyVVhYWWduaG1MTEdtS0tQ?=
 =?utf-8?B?SUlmczk4bDJRMjRiUnZZUWRsdkErV1R6UnM0S0ZOcGxYWUllc0ZLYjBZanRM?=
 =?utf-8?Q?B4uflw61h6I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVpaN1N3WU9vdkdGTDF6NVhFR2FZRkVPUjFmVDh4L3h1Q0t1SjRhNlZyR2RV?=
 =?utf-8?B?WXgxeVVCRnRVdWVIejdDVG93ZjdoNThtV3RWQVRWY3VFTlI1cTJER1FCTWtE?=
 =?utf-8?B?cENyRm5nVGx2UkZUbHBIbmJFYUxmSEdGZ28wZndJaXRGTDFySzhHNGc0M3Nn?=
 =?utf-8?B?T1ZzeTFSRExZNU96M2N5c0dYYXZWRG8weWdrbWRZdDA1cWVMY0JGRldYb1ZG?=
 =?utf-8?B?Z0RqbG5mWExYSjZLZDlheURoQlpEc2Zhb2lSWnZkZVpKTEY3KzF0Y24xMGYr?=
 =?utf-8?B?dmVMNHNVVUxlUDJmSUVzZEpJbkxtYXBZL1k0K3dTcVA3QkJ3OHpMT1Fud0sy?=
 =?utf-8?B?eEVVR0NxQWZOZDNpTi9Ieloyc3JRRCtkUHZ0VW95NWJoeWhWWVZjei8vbEhm?=
 =?utf-8?B?S2pwQVdyY2V1dFdvK3NXZDJ6N3hzQ1A1UWVyU2EyUlBJbEpRTmZRLzFWQmgv?=
 =?utf-8?B?Y29RS2VrRTdWZnYxTDlLVzhrTHB4QW9udFhvQ0ZqMEZKZEFpdWJqalBpK2Ev?=
 =?utf-8?B?K3VjMThoU2kwenNYVzJrTlBqWTdJU0JUS2d5bFlIZndmTU04NDFCMllWTkR0?=
 =?utf-8?B?UW5DMlk2SFowUEQ2cnBDYTR0RlJNcmVWQ3NMaG9HazZOQUxKWHlZYUI5Q1dE?=
 =?utf-8?B?OHFSdUNPS3BINVFPcEc2ZkJSaEQ0T2M4dm4yUVJ4MVZLY2k0cjdtblhyWXhU?=
 =?utf-8?B?RE1xakw5clN4c2RpOTREekZ2ZjNHNE1TUlVPT0tnUW1mN0UrSHBaYWhJa042?=
 =?utf-8?B?OEh0SVlONzJXQzZpZjZjdFV1N2dsaXB1VGhROWtIUjJDdnR5RENQbjRIRUNQ?=
 =?utf-8?B?S1lIbmgvNVduUWNEUmg3aHpRWksyelNGY0hldHdQSDcxWVFvTzJOeXk0bVVh?=
 =?utf-8?B?cHk5bEw0TWxGSEluSWIzYlNNNDh4ZXZ6dkQyVElocmVQQTVyOWNERC9YR1JZ?=
 =?utf-8?B?Q3VNaGdTWkRGMGZBOWM4ZjIzbUtjMEJOMkd3b0k1cHJ3aEVlSTYzUWM0YW9u?=
 =?utf-8?B?R0svNWxxNlg4QzdjK1cxdVpBY1lFZ3Y5UHhRdHVUU0xjMVpiYUNUdXp6R2pM?=
 =?utf-8?B?VmxhOWhqYzBWb2RKREovT0tMV1pIbmJDOFBHQS9CTnZ3WDRyR2xaWVlvbnVI?=
 =?utf-8?B?OVNmRkR0c2hIVmVOOWNFRUIzNEgvejhxbCtLWW0wZ1Z3dWlmV3V1WUdQZERR?=
 =?utf-8?B?WTRnYWc0V0Q5aG9HVldhYWN5dXQyMVNJMmptbi9JU0x5dlMwZmh4SDdNWmNy?=
 =?utf-8?B?clh3dWkxNXBtaGlla25sUk9xeGVDSWhkM0YzSmZ1UkpQUGE4MWdUNzZ2bWw5?=
 =?utf-8?B?b29qcDZ0Wm9EdmR3bFhsUHJnYTV5cHZUZDhreUl6WU4xWEc0eDNLTDRhTG1E?=
 =?utf-8?B?cHV3RHRTbXo4MzNVSFhWMXc1WGd3NlROb2I2b2doUmZJc2orZEhaaVQwVVNN?=
 =?utf-8?B?eXJLM2Rjek85MTN0WFFHMHhHVnJ0UlNwSFgrR3BMTjQwVVhyR2xKVjNkOGk1?=
 =?utf-8?B?SkYzRDhsdHdpeDZOMkNUK0RRMDNWL0VEaEh2YmxCMGxlQW5BSGF2cmRpMmVB?=
 =?utf-8?B?LytmMSt5QzFjb0JpMjEyZUZxZHlBNW5wdWdoZURQNEVEQ2JnVytqRWdWeW1R?=
 =?utf-8?B?TjZNaGo2Z25NNUF6Q0tJQkZnODVCbk5WOXVnckhkQWN2ejdwSmRvYlBLck9S?=
 =?utf-8?B?amJWNHVkaWhxZFYzTFAxbFNHY1l2N0o4NWtkMXNQUFVoS2NRdW5PbHJMWTdy?=
 =?utf-8?B?eHRScXFLQytXTmNrL1RRWENKSDZzdzdYZXJQQkl0SVhJZTYzbHYvTUNJYW8x?=
 =?utf-8?B?VGpIUTIzQjdrMWoyN3pweVo5Y2J6aG54K1ZoTzBFSklxWUlSOUVPUHcxUEtE?=
 =?utf-8?B?Y1VPYnZoZzVnWVpML21jR3ZGeWFkYTdUcVBialpxazRQN1dVY0ZTY09UWWtm?=
 =?utf-8?B?WDloWDNMR01SR1NZd2ZPNUJUSUxIWDhrekpqdGFxZkdpdlQ3d1lmTU1XL3RK?=
 =?utf-8?B?Qys2Wm82MVl4RWVYZGh1TUxScWo5RFVXTWlUMXRPdjVxMHBkM3p3Y3kyOGRX?=
 =?utf-8?B?L2UrdkxVOUM4M0w1aG9sNC9WeXRJSVNJS0Zldms1aFpNTTgrVjVWeEJXK3lR?=
 =?utf-8?Q?aIdN+Cbz+kGl0e4rSb0BV+fuu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b631446-92ae-48f7-6e6a-08ddbf63204f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 03:37:42.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARw+gIKR/jOfMaRXWxI/tNcbaFByFd8MtBTF79ukk9oArEemr0TMQiQoAGD3l8BFYXAa21iuvsAEw5ESJB0iBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9177



On 7/9/2025 7:39 PM, Sean Christopherson wrote:
> On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
>> @@ -736,12 +735,12 @@ EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
>>  
>>  static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
>>  {
>> -	return apic->regs + APIC_ISR + REG_POS(vec);
>> +	return apic->regs + APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(vec);
>>  }
>>  
>>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>>  {
>> -	if (__test_and_set_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
>> +	if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
>>  		return;
>>  
>>  	/*
>> @@ -784,7 +783,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>>  
>>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>>  {
>> -	if (!__test_and_clear_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
>> +	if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
>>  		return;
>>  
>>  	/*
> 
> Almost forgot.  I'd prefer to wrap these two, i.e.
> 
> 	if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
> 			       apic_vector_to_isr(vec, apic)))
> 		return;
> 
> and
> 
> 	if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
> 				  apic_vector_to_isr(vec, apic)))
> 		return;

Ok. I have updated it for next version here:

https://github.com/AMDESE/linux-kvm/commits/savic-guest-latest
commit 862ee49


- Neeraj


