Return-Path: <kvm+bounces-43252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3537FA8882B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B5A71899889
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E25E27F742;
	Mon, 14 Apr 2025 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OjujXcwE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C486927B51A;
	Mon, 14 Apr 2025 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744647103; cv=fail; b=SXleaz+FIm24R+cpFBvXdrm39o3JvFh/Lqr5BrLAxPnldJZA0Fm1Q/0HiDzxB9ADGPm9qtpqHh7gy2h+hO7+oBCFkwMGaqkUoaYFS2joei02zk3iBaIwUp3UdVtQNfYs4brX934KY7Mfi3sJoqEFd72t7Ggq6J2Wpkrj1dShhKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744647103; c=relaxed/simple;
	bh=mb7PteltdVqRy0kSu10XgKYIc6AaeLde+hPe+OdT6ko=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hRb2Bkvf3fYTAerU/MdiCq3HG1+ygCBath9d3VzadYQ3Io9K7kIcCrB4z9uNt1GoA1ZH830asFSmlry50zyxx7nCK99nP+LPBWLtkpRycfbsZXfNQnQrpa3Vs3BQDxOLtH3HvdYCPbT/6gTtS7mGv34OxR2QNVLdJdmejXE64Oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OjujXcwE; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RapcnlM1HCbcQ9yEene03Bl3eHxln/qOjC63U8pFFuVy8lRFewpAbYbVC7gGh7oFvl2Iy3rpM3kZZ/Ezpe+XqE35dPpXXOiN8Eg31fgsinmOTAYYs5ITYegnrJ7F5b07YKKkVSVxVLgxapBXdyMuWYhbjuwQp3ryjMntCEGcVSNtdlQM9+PIMXXGIcO01uPKQEidvogfSNJj7LdWMVP5zhCIecezPLVM8CLQBDakinEfmHbgT221vynwYFtm0ihXUl4M0kkoxlTNE9OWhvRDd/kY14i5INOgux6g6pDM+S9agR4N6UA3K/T7IGZ/q1e6Q/eedersYnXreakNgFIM8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqdybxygNwRUx3JCK8wUYhrI/U38Zv9PRpxBbjLgTxk=;
 b=Mq0eG39Ms7zqHtJUGy1f/IJKYH8lChg3WaDoGvWz8Ir3xpmftSsDBgvoqTMcNEBG3ghzq4WF8gl9/oQvlRyY3XEJfuMSEGHEZf+p8VGY5oTRwfpHi2XDOeIH6ZKu0CD2jSM9Dm2BR+F4AsYrptdHbepFhBFn7oiadVTIojiBkH8xFsvwiQ5gkGN3YBttAxN4KU8cb2vUJR4q3ExjAlPeu+EFe+4z53EphQQD1Hv2jLbkR5G/jhEBhD6m/xrRflDvxJvt4NwVtHS7Atjc5oYLIvOpTlNzEBumB+tdu9LtKJOUeDG375zom8NUKs03YG6RjC9PdBbdvrW7JMJBEQVi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqdybxygNwRUx3JCK8wUYhrI/U38Zv9PRpxBbjLgTxk=;
 b=OjujXcwEiKXNPUum8YzSQr8fowt1RwrqcXI11H8mssXwbTArr5PdLKNstmwXsXZKuvnsQFOT7cwe4u9fLP7IfIaXGugJSsLp7KmePucgxWonRf+TkTXulJhxWFviY28YrhvhaWpWifQRFIz+Tjo67CAtbjEF08fXlODZiItxZqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Mon, 14 Apr
 2025 16:11:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 16:11:38 +0000
Message-ID: <fb5acbc5-3a16-b29e-0496-3977177ed8de@amd.com>
Date: Mon, 14 Apr 2025 11:11:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
 <a06ed3bf-b8ac-15b7-4d46-306c48b897ca@amd.com> <Z_hQxXtLaB_OTJFh@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Z_hQxXtLaB_OTJFh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0038.namprd13.prod.outlook.com
 (2603:10b6:806:22::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fb2c9be-0bc3-4a2f-f422-08dd7b6f095d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTNtV2xkUVdhdmRLa25zVCtNblNQY1hUdCtTRmc1SjBkQUNGMW5XYmtXOElW?=
 =?utf-8?B?NHdCL0FxeTQ5Tm9ENEZDUHRJeEswdHMxeW1yL2t5WUlndmduZ2t1TS9HMVpw?=
 =?utf-8?B?dmRQWDY5TzJsdWdKQ1BuWHpmTzgwOGJhelVaUHZyWmVCdS82bHdQV09naXdy?=
 =?utf-8?B?M0lOZlFieU5uYVZjcHVrekJKSmN2aVFNbitDRXArTElpSmM0RG5zcXhsUHRO?=
 =?utf-8?B?ckJaQ3V5STNKaFBNdEpvdVNVbzhES0hHQzVFNWptVzI1Mlc4eGk4TmMxR1NI?=
 =?utf-8?B?cWtGQWdtWXNjcjNLUnplRlR5WHNTMzR3QVZrTTZ1MlF0Qm80SXg1ZmRWQllW?=
 =?utf-8?B?clJaaS82bmY3cW94V3BrUC9FYWNKVGloemxaUjh5YjZXRlh1U1RaZnpxVjRr?=
 =?utf-8?B?bnIxeDVxQTVSVWVLL1hiUnp3RExidUp3cVhNL1R5TTRScEM5UnhNVHVuQVpx?=
 =?utf-8?B?NkdPVXZIaU5mVEt5U3E4aWpJakhWTm9ZN21VYVhYNGhwQm56VS8vM0t1Q216?=
 =?utf-8?B?YXBjUUdjSUFlWThIaVh1VnlxcTJBeE1tM2ZmMDE4TnhLN0ZsVVpKaUFQeGxK?=
 =?utf-8?B?SDZRaWVxajVKYTY5bE5vb2lXWFU4RnMycThPQlMwYW8yVStiT0pYZTVQQjIy?=
 =?utf-8?B?Q1NtWTBDa0JHbUhja2lERUtKRk9aSnk4Q2JJSFpwOUFDbVBldkk3WEY2c0xE?=
 =?utf-8?B?UjZSMDNab1ZPakVXam9KNC80YmtuRHZucEhycGdNQ2ZjUFN5QmsxUzVrVjNh?=
 =?utf-8?B?WjMweUIxOGpqM2p6TFhCckJPWkd5SWhGUTdsbG5xYUxXdkpvTXlEV1VoTFRE?=
 =?utf-8?B?elRqUUJrRzdGSVN4cTZIdzd2c0ZyblRMWHo2RjNjTWpLNnh6YmtJMi91OUpS?=
 =?utf-8?B?dklCZFJZQkNlUCtkaC9tK3gvc0VNT2pZL0pGUzR5amNsOGdINVdOL2R1WHVP?=
 =?utf-8?B?OUp1aS9DNys4WnRwYVhmcHBLMjUxei95bFNvNHpZVkhzNU5STTRBbFBDdVZM?=
 =?utf-8?B?YnpyRWx3L0ZFek9EV1RyeWExczNHWDM5NWxROXJYcVBCTjhBb0NGQXUzajVn?=
 =?utf-8?B?Q21vMlhIVzBLMDhwYVQ5bnF3WDhjc2pCL2lSaWprbHc1bHVPeWRIUGtMSkhJ?=
 =?utf-8?B?eTlmWlY2YlZWeFF4MDBKWHJhT0lJSjJpT0xHWERoK2ViaFdqY2RHTmhWSHhh?=
 =?utf-8?B?Z3ZDRHlUQmVqcmV2aDJweGE1OGorZ1BqZGczNm90OXQrV3lLU0FydlNMMGQ4?=
 =?utf-8?B?V2pEcDJURUUycE43eXNwZXBXZU9IVDF2UlRwT1djN3ZJb3NmNE9KRUVtVTlt?=
 =?utf-8?B?alNmOHMzcXMydDNMSDNBV3BGWGJIaHVudWVOUVMzRzdiWllFcFg0VFZPaUsx?=
 =?utf-8?B?cU5HcGM3MnBMU0x0ZFczeFFOTnovb29TUDR3cmJQc0szR28zNFdxZ2hvWXZW?=
 =?utf-8?B?azFZdkpuSDExL2tnamFTTjgwcS8wUWpvU3FNclBnbWU0Yk0wTDdHVDlXd2dp?=
 =?utf-8?B?OVF0bGp6ZXZvaVl4SlMwL3hmbktKNVBUSmlURlBmS3hDSVlTMHdKcnRscFlZ?=
 =?utf-8?B?bE13S2lqd2pTaHg3MFNmckpZSCtGTC9reFJkQWZNQ1NRYThFV2gzbytSeVA1?=
 =?utf-8?B?dnRaYk9IbDVvVXh4QUE3a3FwRG1YbkxXbW8wRHc0OVZ6ZUFoRWluM1NtcnRT?=
 =?utf-8?B?S0ZmUDJTUTFXWHNqaVpKcVE4SEN2ZXVPUk01aUF0YzVpdDBrSkp4RUdPWGhw?=
 =?utf-8?B?czdobEhjSjh1TFJqNEZpckZTTUlrY244OS8zb2dodkk3b1pCbUJDcE5YMENl?=
 =?utf-8?B?MFlNVC9JLzhvaC9DNG8wZkpFODNiYVRUSEFtZHNqUHhRb3o3NzZHVEpHMUlT?=
 =?utf-8?B?VEFNdzZBMzdXVGF2RklNK1JhZE1NSklxS2xURGNUQnF0d3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enRLN0tmb0ZzR1lJOVU5OWdvZ2htd2dRcCtzY1M5cVBXMzcvcU92NERJMmRZ?=
 =?utf-8?B?bG16Mll4Z1JBWU1hd3V1V0xvOTV6UzZPTFh0L0dTZSt5S3VLbEhTZUx1NG82?=
 =?utf-8?B?QVlOR2IxVGJCajhwZmxVVGp0NkE5K0xzaFdvSGVFNXpqTGxadGNHQWVUcmVo?=
 =?utf-8?B?Y3VmQ2ZQbnlXR095M2lBVFRzYVMvTnZZVEQxYlNvVmtENkcybEVXQzFMbXhy?=
 =?utf-8?B?OUZSMHFsRnhKaSsrWVpCVGx3NjBGbUhJUGVVd1dKc0Jka2Vsa2hmMjlYcnFJ?=
 =?utf-8?B?eWhhdFdseHZWRHJmdW1FZVFYUDVGLzhaZElWd0tPa2dkOVlrYy9qT2tWWitj?=
 =?utf-8?B?TnVvSjdzQzh6TTlkemNCYUgvZG5PSnlKbDd0QUdsYUNZeU5idjZvdTZmWEQ5?=
 =?utf-8?B?MUFnT0tGRXRNWXBLQzhxZmljd3JUM2g3Vi9LN1AyS1VMaWxteHRtdlByc0Fx?=
 =?utf-8?B?VmYzcVZnbVBOVWJORFBPUFNRRHdNYmprdDM5ZHlQcjRKdmJhOVhYVTZWTTNs?=
 =?utf-8?B?NGJQeHVvNWl0dkpueDlsS0V5YitVTHVsQUh0UWdleFZCM3ZHeG1Wbk02ZEMy?=
 =?utf-8?B?eFNya24xRnhiL0s3clJNS3plS1FjVlJlRGxZZTN1VXJkNGtMYUdKSmJqZmJL?=
 =?utf-8?B?TDZXNVkwYW1sNUtTSldFaituMUxiMS9Md2xsTmttdHdCUVdSU3ZqVmZ3Sy9C?=
 =?utf-8?B?bm9Pc0diZzZzY3NwTTlXWFhseUdRV01GVG42STUwWVU1U2I2WDhrTy9jTlRv?=
 =?utf-8?B?OWZtam9XN0M1TXBjNVB4bkVkWWYrM3RTL0c1dkJXT2F0VVQzdVFNM3RXQTFH?=
 =?utf-8?B?dHoyTnY0Uk1OQlRMUTN1R0FDTkVkOXhWUjFPbnhadXFBZUxQaE9zVi9QK01i?=
 =?utf-8?B?RTJIcFJxUEJPeGNuZTBVUXpqWUlLRk52QWtoQ3Z0MlppUXdid0g0VHRsODNq?=
 =?utf-8?B?ZDZsWHZPVGJaaXdQem42S3RUaHE2SjVZcVlnalhnMnVvcWdHclBIT21pYmJ3?=
 =?utf-8?B?bzlVTmc5SzJhTXZCOVBWbVNheVg0aXZjQStBWThKZ3JsWnAwd0NxL3UrVVBo?=
 =?utf-8?B?QnRnZjQ0VlEvc2UvNFhVR0NYeUJhV1NMVDJxT2k1a2NqZ2hQV2haM3VDWXZQ?=
 =?utf-8?B?UnFhK2NyMzFzZTZOd2ZSOUJZekxJZDQraHVEOXR3ZmNBcFRIbjB4cHFjRm1k?=
 =?utf-8?B?SlBWNjVhbG9UU2szNUpDOWZvZjRjeUNENS9aNTgrMm05eFkyTEFYdmRoV01R?=
 =?utf-8?B?MGpZTzgxVmREMkNZbWxsT0JrM081Rjc2TTNLNTJldkg2eE9oWHdGbFZJZFZp?=
 =?utf-8?B?MGN2azJzZ2UrKyt2RkhlWFI0TXR6MTgrNDZGeXlPaGhJY1BXempFNjl2d3ZY?=
 =?utf-8?B?SXlRZzh3UEFGemNKeWNOeUpHenBLNFVYTUlQOVpuNnNRNlYwZHdsMUVZVGQv?=
 =?utf-8?B?UjROUndiRzJ1VWlTUm5jZEYrSHZVNVBmcGNLcEVqQUd1dnVBWWhwZkR3M2lP?=
 =?utf-8?B?ZlZLakxTVC9HZ2hyZmVDMHgwaTZXMk1lSk9zVDV3M2gvbjFiVmM3MzRNTUo0?=
 =?utf-8?B?bEdEcUVnWFVHb3U5WG9YYUN1UW5ndWtkOEcySHNWWVovUnZaOFhPd3o2dEY0?=
 =?utf-8?B?Wk1LQUI3RGhLNnl5OU5kU1JCZEM1ckdJRmcybUsvSUxZVUhUMlBhTmgyWVNw?=
 =?utf-8?B?SmQyUXdiUEhRWHpSQU5Db25pOWhNcUQxeXIwQkIraGk2Sy9rc3RYRXdKcEp1?=
 =?utf-8?B?cDZwcTN3WU5XK1B5V2docHBFaFlRYzRRNlVxcW14cm44R2RMRDlIRWN4b1hp?=
 =?utf-8?B?MENReXVHa0lQVUZuWmpBemg1QWtrRCtOd2l3WVM1NWNwZE9lcWM5QzdHRzdX?=
 =?utf-8?B?T3I1dkhHQTJzSllyWGgydHdlU3Q4OGNjYWpSdkswS2o5emtpbzE0d1M4Znpu?=
 =?utf-8?B?U0dxUmdqVTVtSGFZOFZ1WkovOGdjaTFKWmdobzZ4SDlXcTVYelBLZWpmTXcv?=
 =?utf-8?B?OExqMitrNGlVQTlqSjMvRHlOazFVdVJvdFNZZmlqMWlyQTA3REt0dEFDbENT?=
 =?utf-8?B?K1BnN2tJRWtYcVRURlA2ajJrejFwaFlWMFd2ZWM1OXl6aGd1WVFVd0RVeEtj?=
 =?utf-8?Q?0zz00vmVa3uHO/Cj3QflfR9oc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb2c9be-0bc3-4a2f-f422-08dd7b6f095d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 16:11:38.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJlomYOckCV5nZ9cJSvGdOPGzyQpnZEUwgE5y4WPwcDI8yBBFtbGyDTDq2Fdle0ykyFJmq3yCBou4OvlLjDnyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746

On 4/10/25 18:14, Sean Christopherson wrote:
> On Mon, Mar 24, 2025, Tom Lendacky wrote:
>> On 3/20/25 08:26, Tom Lendacky wrote:
>>> An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
>>> policy allows debugging. Update the dump_vmcb() routine to output
>>> some of the SEV VMSA contents if possible. This can be useful for
>>> debug purposes.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/kvm/svm/svm.c | 13 ++++++
>>>  arch/x86/kvm/svm/svm.h | 11 +++++
>>>  3 files changed, 122 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 661108d65ee7..6e3f5042d9ce 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>
>>> +
>>> +	if (sev_snp_guest(vcpu->kvm)) {
>>> +		struct sev_data_snp_dbg dbg = {0};
>>> +
>>> +		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
>>> +		if (!vmsa)
>>> +			return NULL;
>>> +
>>> +		dbg.gctx_paddr = __psp_pa(sev->snp_context);
>>> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
>>> +		dbg.dst_addr = __psp_pa(vmsa);
>>> +
>>> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
>>
>> This can also be sev_do_cmd() where the file descriptor isn't checked.
>> Since it isn't really a user initiated call, that might be desirable since
>> this could also be useful for debugging during guest destruction (when the
>> file descriptor has already been closed) for VMSAs that haven't exited
>> with an INVALID exit code.
>>
>> Just an FYI, I can change this call and the one below to sev_do_cmd() if
>> agreed upon.
> 
> Works for me.  Want to provide a delta patch?  I can fixup when applying.

Will do.

Thanks,
Tom

