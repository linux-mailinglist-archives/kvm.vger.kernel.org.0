Return-Path: <kvm+bounces-27777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C08D698C040
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BB90B270B3
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 14:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE73A1C8FA5;
	Tue,  1 Oct 2024 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WeQBabG8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE601C7B9D;
	Tue,  1 Oct 2024 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727793402; cv=fail; b=mratXMVE/Fafrz7ok4MDM4FlLBIvH6gHkv/XjhE88MFI/a2THhOZiHj5PWT7lAh8xmznX3J1aC3UewV4hYDMbNGpxM+UbaqBw81/mIKiAeu/+r/OWaRrCooSqUVNNDyBzoI3AJ2vdt3AEuHcSyyzF1tPEg7oqE8X48WbOGSDktg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727793402; c=relaxed/simple;
	bh=2Jg888bQllE43TaERp5NUsaiZIGEw4Wn3IC6lAcmQAg=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CqD3SVexYIkt17OC6aY9RZ4jEhOpNTI3S1WU2HgRlAKuDEEOcT8tZ4J3T+6TFO7tCo8wQPrlWBonTuHNDAxgw4pLh+rQZvDA0xtgkoZwWtS1smnhh3nNNdl1J+QllSnfofyV8FjtD7UPQdE+rz1+bWXFlb0tsJOnrMPMjKnMfz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WeQBabG8; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tw62ADEqTZ3ORLFhotfi5IfRYiaOuXWmrmcWMm6Nq2KZU96VkUlKJN3u9RuKmYB9zWLVd2PRUQxd9EqDcUD01gydJQxX4r7Q/lZt7vR2TsORmqCp+p8dONAEHijtd39x5Hn60qw23FEOpavRWK9AfPG9QfpRA8+yMHfFGUYbIxuCgP3NSpZ9Rq8wW/E3wXdiVfJgCrir3pi9C2iviXWqNmnfmVje0kM7JVtYEpItbfVGAQNSYNJbfHPRJzcO1TpYTckbaBVUg9i3xQO05TN4gKmICvWIiPnRHGnMkVbhg1AkzZC6dtGy7rPUfx/t5wmQ1IV78dLCQVcqj+5/fP23Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL5Ve+KHtBfOuo1VQHpknlaN7MH/xlAMqLYJ17Pw2mE=;
 b=LKoOid1DvIR5kvsKlCSNFOtdxmZr8e4MLeR7LS5z1BzqWiLek5h/h2w87dJegkLwJXXji6SIKe/W7APO/z01K187i9ETrmXpoABi5+KoHSntX0PVNv5TWuaGKgh0MBzwMI2nAY9IHl4xtJRyWcCjPBHMIkhO6JILcZcpcduyd8kDo0Ianct4zoRmmXx1kahjghTwMtyB8CjYJlbw4F9vfFN79H2nXrhqyq8x52CUId/XWcTe6HOm14chZ+zdTXdvavpQ7NqcPM2K6KimlPeJlCKLNkuYev6NnwbkujSVeWazSus9cxHJXF91/TKQoAk5dkyjqqstwEjExVMDOtdKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hL5Ve+KHtBfOuo1VQHpknlaN7MH/xlAMqLYJ17Pw2mE=;
 b=WeQBabG8BzCRGPUXk4hfzGKTr1/K0H9CmS0mlPoY+xnm1LBc7LC9eZpOJyN04FtoFtbwob1TOSLPL0mXlrXQ0VMcYQhQ8VLWIlB0Nu3aoAWMGb/oni4bv8sEkVyG1ZjMpcdvarBT0+dsLR6WXaWD64LLYtvrRtynK2RsVPbJsHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY5PR12MB6647.namprd12.prod.outlook.com (2603:10b6:930:40::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.16; Tue, 1 Oct 2024 14:36:38 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8026.014; Tue, 1 Oct 2024
 14:36:37 +0000
Message-ID: <a2733ac2-2a44-49da-18b4-ea905b439840@amd.com>
Date: Tue, 1 Oct 2024 20:06:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 peterz@infradead.org, gautham.shenoy@amd.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com> <Zu0iiMoLJprb4nUP@google.com>
 <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
 <ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com> <ZvQHpbNauYTBgU6M@google.com>
 <64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com> <87setgzvn5.ffs@tglx>
 <156dc1ab-1239-0508-1161-ab0cd13d35b1@amd.com>
In-Reply-To: <156dc1ab-1239-0508-1161-ab0cd13d35b1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0186.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY5PR12MB6647:EE_
X-MS-Office365-Filtering-Correlation-Id: 32e0e457-ec08-4e87-98e2-08dce22674c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OE9idHk0MG1WdzZmSWFhOUtxQjNoL0lnVk9QcVZ0SWk5a0NBNXJybjNNamJi?=
 =?utf-8?B?VlYzZTVKckEvekRyVXZWZ25hbzZGa2g3T2tQc2wrazRVc2RSQVRMbklTNkx3?=
 =?utf-8?B?cDMrVW5FMmliZ0N5c2F6enBMcUZBTU5MVE9zc0lWSGQydGxqWk1YSkl4Tkt5?=
 =?utf-8?B?bWFnckxQYjZ1TUZRcFZRSk5PU3FzNVV1ZUd4TzMrcitGK0JsanYrRXl5YzZW?=
 =?utf-8?B?S085Yk9PZ2hvSEM0Zm9TVW9JU1VmdUlTUkFtNzBFMkhJMWZISHgwWUdYb0xi?=
 =?utf-8?B?c3dtSnJjRUR0d1ZyR3lZajduSTg3VEZCampPVFZCQmhCRXB5S05DRmhGTWdr?=
 =?utf-8?B?bWgrSlJTKzlYY1RxNHlBTzhONzFOUHk1US9JVytrVktkNHRxR0s5Vm40QjFU?=
 =?utf-8?B?anV6djF4R1ZpcXorWHk0NGxmRXMzeWJwVVlCdUgyOWpvZDhidmZxUjNsNUdT?=
 =?utf-8?B?WisxM2NVMW1tTmcrR0FGbkNvbmJzL25WYzZPTEJ1b0xqbjhydUxoSUZidGFK?=
 =?utf-8?B?ZWR0cC91WitSSWFOc1F3cG9zWWZtN2VkRHJ6cVlGalBqNzJjVzVhenZIM3F5?=
 =?utf-8?B?dFNwZlo0aisxSUdSUHRvTGxhYUJ5MUowb2tkSVl0TkR1R0lIRTZwRDRRK0lp?=
 =?utf-8?B?bzZnRUlwOFZqellISTRVQWoyd044K3F1RWE4RXAzZlQ4MmlpcHNGeE5DRnVY?=
 =?utf-8?B?Mi9TZGRSS3pZNGI2MDJlV1BKSStleWR2b0lCeldLVis1Y1YwVUpxV3QrTnVl?=
 =?utf-8?B?aWMrM0ZkSkNSWmtHRTNyNmR5aFNlSmc5OXQzQ1B2eUJjL29xQ05WT2xWdnJJ?=
 =?utf-8?B?Y29vNGxQOVNGNnUvWmVTcW9oQjMycE43WUJVa29uSnoyT1J0RjQ5VnNyNnc2?=
 =?utf-8?B?TXJRdWk3ejU0UmxOVXorQTFzYWxYY3oxZENsOUFjTkdMMFVQSVAwWG1tOEEw?=
 =?utf-8?B?R1JWZnFaLzhtRk56cXRZV2djM0NCaWFucW5PYUFJS2dmQjBPL0JmWWJOcVpF?=
 =?utf-8?B?M0NtQlc0UmNVay9TYmNJcnlyNEErMEJCR1BZRDh0aXErMitqV2FCSHlkWjlK?=
 =?utf-8?B?VStQWjMvSlZzeUpZWVJCc3RTSUVjWlBkQ1dqbGx1dEtySVFwbS9yd3g4TFk4?=
 =?utf-8?B?QlJBOEJjK0FVcklMVHpkNm1SRkFITVBjNVVZTFd5OExVTW5WOU1TKzE2djBJ?=
 =?utf-8?B?aStWckxsdGh3L08rNkhVSEhIQnFmd2RuNG02MXhZaXBuZ01tZlY4RXo4SExQ?=
 =?utf-8?B?NGdmMEdqSm0rZWMyNkwyUEp1MEhOaTM3QzlxY25uTEQ3MzhzNFQzdGN1cjZv?=
 =?utf-8?B?S0Raazd0M0hBWUFqLzc4M1p6N0NlNmQ2WHNsN1NQN1NyS0dxb0licGhLajVt?=
 =?utf-8?B?aUhGTzBnVjNlS21HMUdxVEZXdElaYlhBL25FbVFsT3diRk9rRlh0WWdrUlZM?=
 =?utf-8?B?R0NmYVFWKzFPZ1Vjb3JWRDkxYjM5c3dSWC9iYm1ZWGdvUEphbmFkaHRxRVdS?=
 =?utf-8?B?NkhuU3dkUTFVN3RqMGlxS05QL2FzakMrSGVXalRYYXdySkpwc1hUTFFTb1hI?=
 =?utf-8?B?Zm5WeXdlZXN3M0ZGT1FJOTBEdVdqSU1iWCsrNklENDlqQkx6TmZDS1ZPb09o?=
 =?utf-8?B?NnhmM3pLWTJ5bkdONHRmeStpdW5oaE5RdkFOamdQNElVaU1VeURKUmw0VW5p?=
 =?utf-8?B?cWJyRmV1WTZIZFJaUktWbHZiSWkzZnZVeEh3WFo5bzk3NVRBZXZzWjRFbTQ3?=
 =?utf-8?B?dFkxbjAxOWVGZjNGdW5GSVlEcHgySHI2aEJHRHoyVVp3ZGFWaVY4bSs5czZG?=
 =?utf-8?B?SWFYTE5aOTNDYmFPSEdEdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXRxeDRoa2VhQkZ1MDI3Z2pUcFdPQnNHL1RLWld3aERLalZib21aTnZ6eThZ?=
 =?utf-8?B?eHkxS0RTNVJIRERMNXZQZ0RZYWptbkd5dXNjMytESllNSDFaQnVOZjBCOFVL?=
 =?utf-8?B?ZjhYajVLdWJLNXVqVU93SFY1clZjckl3Rko4Mng1dGdmTW91S1Y2ZFZZVGw1?=
 =?utf-8?B?WFAwZUUreGVXVU5XZFphMUNUakp3VURRaHQ0NzFpcFVIRTNVeVArS0dldU54?=
 =?utf-8?B?cjFQV2dYZnFtVjY0ZGFIaHJKTHNRN2FRUTMvRFNvY0RRYVR2MGJxKzE0OUlS?=
 =?utf-8?B?ck9iQXJIeEFrM2dGMmhtWkxtZ3Jqb0tZS044OUdXcVorOU9QZFJhbVNiL0hh?=
 =?utf-8?B?ZG5yOWVQVlRLNlNZN3VpSjBrWG82enBsbzZ6L0VicmUreG05RjRrdkx2ektM?=
 =?utf-8?B?eEFlNXVTUFQ3TnZLQVU4dTRPT1hhUjczYkRRUmxwQ2p0bmJUeGVJbXVSenB0?=
 =?utf-8?B?WnBPK3B0cGVES1BrVjI5TUUybFJhTCtvd3pLYmNXM3Q2bWRKdXAyYjB4SXZR?=
 =?utf-8?B?VXVsdmk4cmpzTERnRkluN245RXRFeE5Hbm9HeUF0MXMzVE8yNmNWcnZNVEh0?=
 =?utf-8?B?eWFweis3cnN1U2tSeHB5eis0OEdZdjRKT1BQakxGQmRhL2hGN2FEbUxKcVhw?=
 =?utf-8?B?c1VPN04zZU9oL1E4bGxLU3Vhd2h1RnFwL2tUSkVOWFdCdTdSRUFvaHY2cW5M?=
 =?utf-8?B?WE5hbkJIdzdtQ0locTlMUUgwb3FGblRERDBHUW1mbm9EOS90KzQwYmtxRkJi?=
 =?utf-8?B?VFFWc2dXRDZzdStFS0gwdGMvN2lidzAxOEpNdGRUQnE0eFpQcHowNmwvc2o5?=
 =?utf-8?B?TzRLZU9CZjh1NzVwMDdjWjZWejdZeHcvWm9SMWJZblBJbkYycTVLTDhabWdG?=
 =?utf-8?B?NFZhVHhPajgvNGZ3MXFsQjViREd5NU5OcDFSblJjeVJ0amtrZ0tCSUtpNE5C?=
 =?utf-8?B?M1JTd044M1h5SVhFb1MyV0o4TFZlcUgzOC9pQnR4VDNwcStnY3c2cnpHOXNU?=
 =?utf-8?B?aXIzN0lPRFg5OXJIazA2MUdyMkdtMzc0NnRtRDE0cGlxeUFIZEpVTGttQnBP?=
 =?utf-8?B?Wm4yZzUrTGdMbVlmUXN2UmhIdm9zcGJGaFRHR3lzWGZUZUFoR2wvN2ttdTUz?=
 =?utf-8?B?cnErNjdNdVVxcndTRkh4djU5YVAxa1IzS2QvOHNjM2x0UEloTjF0UjdYRlZJ?=
 =?utf-8?B?SzY5ZVZHdHFXTmV3aDZTWkFIbHVlZzhLTmVJd2xMdkFYY3JVc0ZmZTZDazli?=
 =?utf-8?B?dWVMVFlLRnBXaUZoUHptRnUrSU1Oa1htVEZ1VGpkQS9DVEdaeDJsbnp2VzZC?=
 =?utf-8?B?M0VDMllkUm1DcWJnVlRXcXZJZGtZQTVidThjVEpvR2RFUGxzdTB1YU1DOTJ1?=
 =?utf-8?B?cTEwZmRXR1NQL1V1VFNPUUY0c2tWbm5kb2c1ZTZxSzc5L0VVRVRNNWtsUmxR?=
 =?utf-8?B?VEVaY1FTR0p5LzRtRk8vKzE5WnVPR21HbGY1aDNCeUZvbHVkUVdFd00wbHVl?=
 =?utf-8?B?RGhCdm9SR3F5QVBqSVp3S3BJbFlQUHlhZWdCODErVWRmdlBVeXhuemdTQnVB?=
 =?utf-8?B?U1h6a285Qjl4YkRDeGNLa0ZNQjVXZmwvSWdwU0MyTGx5cXp1V1JXdlhSbjlH?=
 =?utf-8?B?a0l3VmNSWFU4YjNTOVQvaEJjZTBpRTV6dmk1TTY3cFZjTVdsdXowZ2RNTjJi?=
 =?utf-8?B?ZFVRenU2a0JaaEdrTC9xK2lvS0NJTy9uQXZFblFjQW5BN2tYQ0xHTTExMElG?=
 =?utf-8?B?RTR1LzJTWFNCdEtqcDZFdVk1V2dUejRKU0xzMnFJSkpJK3lSWllSaENTa1cv?=
 =?utf-8?B?SEhjVFJXcFVSUDRxb2RRc3FoTUdNNElqbENFMUdOeEtKYXdFT2QxU3E5TWNi?=
 =?utf-8?B?NUY1Q0t5QUZRLzFRZXpxaXRDbC9adlpMTTY1VHc3ODRjOS9LelQzSnZHTjZG?=
 =?utf-8?B?MC9nZDJHdzJNWXdBVTduTVdYMGV5TlhCcisrUU12OS9Hd3VGdTlJRGlaV3dm?=
 =?utf-8?B?REFQZ1pJVldZR29BL0tkaUlWQzhZcjYyaDN6MTYySmZYblZ0ZWRMZUVBMzFW?=
 =?utf-8?B?N1ZrRDRhSUpVUXlCdk9UcmtWY2JacWVYU1BvTTZmWUUrOVAzNk45STZZdnBV?=
 =?utf-8?Q?1plffD5gwv/BWInB2pX/9QTnq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e0e457-ec08-4e87-98e2-08dce22674c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 14:36:37.9119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rf59Ar75GGz+E7gG1WuYqR5ZyfdWQlyjkCIcUMvM8/rfN5N4EG0f96S0v3AGRPh7t3NywGdBKCd5cHHyVrfGNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6647



On 10/1/2024 9:56 AM, Nikunj A. Dadhania wrote:
 
 
> Also I realized that, for the guests, instead of rdtsc(), we should be 
> calling rdtsc_ordered() to make sure that time moves forward even when
> vCPUs are migrated.

The above is with reference to native_sched_clock() being used for VM
instead of kvm_sched_clock_read() when using TSC.

Regards
Nikunj

