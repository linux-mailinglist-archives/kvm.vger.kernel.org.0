Return-Path: <kvm+bounces-69833-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGH/Jxl6gGne8gIAu9opvQ
	(envelope-from <kvm+bounces-69833-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:19:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1693ACAC6A
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A3D73036EA5
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816F9356A12;
	Mon,  2 Feb 2026 10:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="PthSBN6B"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020108.outbound.protection.outlook.com [52.101.193.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527D12D47EF;
	Mon,  2 Feb 2026 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770027125; cv=fail; b=UVYWKsi/82jG10w1g186P+y6Li7qOvMri68Sc+wMXhP9Q3Xo0eRUwivp0aDC1xQg2Ye7RmUy5B1vgK/8C/5bSStPmSKIaU7dWI1rouBdJcbld1dbhrojyD0lSk9t4hyHrt0lSFHXfZito8GDj2STnA/PAiXZzKgqoJpkK/apjSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770027125; c=relaxed/simple;
	bh=ZsVMvA9BJdMjDlyXg7YghLm8i1nijU+IWaVbSr7sd7k=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=Wsbgvj0sJaxhiPr586jfARt1bGAPmouBXGQHBGQSn2OjpWxD0TiV/08scCHoxaWXTulCZO58e8yMmG3dlw9847ZCV6PY27Ijxi9g4aGwvaUp9n3tOWQZ00ttOGdRNVoYp22w9Ng9M9ik/DWhqQQ23dfDDh6CGmeQHaVFbkckJCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=PthSBN6B; arc=fail smtp.client-ip=52.101.193.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tq6Rg4iNeta9Iv1pJPPX571voF01bF/9U/s78KTOyZ1mqg+B3wxkWe1qc5nh3jDyLI/bk2gIn+s8lke27cZkazQt64Euu3ah6ByzZ6IjCJ2/DwARtg7SSOCF357phjC6N5QTWopWeQN9Q+L3WXVJ0Y4LMb1QKdSmC4Ibf1KzEmtYyU7zrYDlt5x3kSf4iZ1EnrwGPgIkV/J1RnicWZBqneJ0X0s6w3ODfireYQPT/b3JhdSSr6WrE4Zmn7c+G/Q8rxwZ8QGaK6XEXF6zNPLaE0FDUD5OfJvLtprV9xBFDxRrk4BGRLu95cNcD6zT+0bZ6VvCXk3dTrlD5uLpB6PZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rE7F58LM0K82wFpMyxA3bpPySfk7NOMj1GUfT1WEEmk=;
 b=faeMiRjRWRSJxh+W9EjfPOffCMNWJ3vYrpxO3fMBQz5ltMECOIGKz5M9IU4EmwO1mtXuZRLDI4sCiRodZacxmoSrwNdQ0If9mBnK3BHgOS2KpF6luzUTXcMgUvnrwfBdn1MoEJUzwoVyBwQG74djvCifOsgqoGVhyvWIJUY7NN1jigb8k0o5JUco0Qk88bDk4flzue0sMDeqKVQuTuzaKlgREssuOM7u6JdNGbWCO29AgTggDho4l7wgUyexq/mQYGEdOskWMz/dsVJ7ZiMzXYSdphX0svAVN+Sa9jzjlaJZu5Mw8wyEkBrtgqySkQDF43heWxRnC76kmgG7ngxtYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE7F58LM0K82wFpMyxA3bpPySfk7NOMj1GUfT1WEEmk=;
 b=PthSBN6BXS0AYe2QEkCtlhhumysFd5ILh340nBnNZxGg6jOENeOhJIPyC4LJ5fbm+TPOvE2W+MUGqZ0iWhFrUoEn0AtgqoJ3qnKAG5i93+xyznfZs3dVwslRAa1m/59iLVJ4euSE9xNGvZQa4n7irJUn6kIBn8mkSoE/mGebp+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by MW4PR11MB6666.namprd11.prod.outlook.com (2603:10b6:303:1eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 10:12:01 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%4]) with mapi id 15.20.9564.010; Mon, 2 Feb 2026
 10:12:01 +0000
Message-ID: <7d97d576-eb94-4167-ac4c-128490b27612@fortanix.com>
Date: Mon, 2 Feb 2026 11:11:59 +0100
User-Agent: Mozilla Thunderbird
From: Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH RESEND] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::12) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|MW4PR11MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1aac67-ebe4-4b67-c367-08de62438191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzJxZkpVK010RGFqdHJuMjNVdHcwT0x2emtjZXN1aWRieFJ4Z3pJb3hDU1p3?=
 =?utf-8?B?Yk45S21obG0wbFdwZ0owcC9lVUUxMHdpVXJUSE1oNXB6cFVER2NINlZkNGpF?=
 =?utf-8?B?cUlBaWhKU2lCZ3ZSZ1pIMUhEbXRTT2hJNGg2S1Yxb1p3Nk1CV1ErTlY5b3Fn?=
 =?utf-8?B?S2pEc1pGL2g0ZEtCd1h4QnJUa0tWVXNpUkUvZXhQd1dTc3BDZHNwU3Q3YjNa?=
 =?utf-8?B?UU1FRDJmSXlqQlRzRGJFMUZxR1RFR3IvWnE5N2htVkRhZlRsUWpJSEdtb3d5?=
 =?utf-8?B?Z0Q5U2I1bGpxenk0OVVrUzh6Ly9uNEtLa0EzNjRrNWpQbmp6OG5oRGxuOXNv?=
 =?utf-8?B?Vm0yY1kvdE5kTENBOVo1eldPOWFGUU5rZnRtVWNSTks4MnhjcG1GSm0vNzRC?=
 =?utf-8?B?bFh2bjU4YTFNQVpxdXMvY2NvNURKOWRDeG1iS3ZlNmFSUGkyOVJKcUJ3WXgy?=
 =?utf-8?B?L1NzU1d3Mk5wWW5RVmpuS2VIeFRSNW1JMnBpRHlLL1pJbGc4WUJ2eExrem5x?=
 =?utf-8?B?S3hieXZHL2VYSnA0ZXVCREl0WERVNmF6bFJabXRCbFJYcUxqZFcyT1lzQ3pn?=
 =?utf-8?B?ZmVlZDB0ZFB2S0RQYmRpSUkxVXB2WlFsVitKQUg1SHRMaU5MVG94ZUV1ZVI4?=
 =?utf-8?B?bndPaWdXbkhubnNRS1NGaWFlSzFzZUx5YXVIdE5GQmlaR1AzSkFORzcrUjBH?=
 =?utf-8?B?eUtFU25vNjI4TzVyMHlRTURrMzkvZHUvbFZ4aGdXcHpkZG9KUlJzTkVQT0d0?=
 =?utf-8?B?Nmd2NzFESi9SYTc4NVloUHRzTGFZT1E5VE5yT3BKRS9lMS95cUIvQkVLcHNh?=
 =?utf-8?B?ME1JNm5zL0VpZUNoMTlSRjg2Wm1xRmMvRVN1SUxURjJkZ2c2S3prWmJON2ph?=
 =?utf-8?B?K0F5WExxYjR4OVpaTVdOb2ZvSXdpUUc3Z0xWWHNnVTQ1aUNvczFDVTRxK3NU?=
 =?utf-8?B?a0JvS0h3ZzFEbERoM3dJSlJYdzVEdGxIVWNOOExFUFRrQlhsSmFDd0NTNHJX?=
 =?utf-8?B?cC9DUE5jRWdkMzFQbnpod01BbEtzdldXcUxiSy9Xc3NtN0cwczFsaUVpY2JZ?=
 =?utf-8?B?Mkh3VDkwVEw0bUlRVmFPaHd6RE5HZjFUaGVFdFc4cXJMOUNWdjR1dUZKVXE4?=
 =?utf-8?B?TGtZS1NNclNkQnFnZ0J2WU9BSHovYWxEb3ZMTFFTYmkxR3dUUmhUZmdrOGpq?=
 =?utf-8?B?Z21IODhaNlJwRmJrTVVpZEV6aUUwOXh1N0ZhejdXRVdkVVpQb2RGMzdaSEhW?=
 =?utf-8?B?dVlCNFJKVU5LeThMcGZSSHViN21wekM0VEc3dnNrb0hIdVJlbkF1cGJhYUdW?=
 =?utf-8?B?aC8va09FSVVTQTAvUXVNUXVremZZL3NiYldJdGtaby93ZWpweTdudGJwYTFj?=
 =?utf-8?B?dGRQNVh4M01zcG5nWktjY2hUVGVZdkFPakQyM1NGYlJNRnpLdkdiMnluYTBi?=
 =?utf-8?B?TGVVS3BUbEJLYmFXbXpubkNTRStQWC9NTERmbWx0UE9pMnEvczRLSTVoc3VH?=
 =?utf-8?B?aDlqS2xtLzRjZkVwZVd0VkRPT3FKWFU1T1hIS3l5cmZaVmxHMDVzdmh1ZE1F?=
 =?utf-8?B?a1RLejlPa2hkdklGTGM5U0t3azJlOElaQlYwYXNjNngrMkxJTjhKVmFLeXY5?=
 =?utf-8?B?YVBzSGdaQ3JaUWoxZjJMZWhVOEFSWG1VL0R1QWx3NWhTb2ZOdXVCcWZRbzA4?=
 =?utf-8?B?SmZpWWVScG0zWFBZa1kyTlozMEhxa09mRkVZbGZ5ZXU1eHZMZHhySHdLMFpO?=
 =?utf-8?B?UWlxdit5YkJGQTZsc0hHY0RpejNIMlpnZlZVa3ZZNTJGMkdTY2wrOURNaGRX?=
 =?utf-8?B?ODRIaytZYkRMWEp2MmM1ZDBsQmVxWnlKRXNZbkNpS2ljb3NLTFlKNmlLMWVs?=
 =?utf-8?B?TjRGOWhzbU9DQjFoQUpxdDVrZ2U5YXQvUEpNWSs2N0ZVbks5UzVHeUtLQnVU?=
 =?utf-8?B?WU9SNzJFbTRLV1ljT1NSUWkvQnQyaE9wdnFQOHo4Sm82SXNxWDdKNUVwbURY?=
 =?utf-8?B?dHY5QjFNWm9jWHF1UklkbkNNNTdNVW5Tall2K3dvL2llcWs3d29iWSs0SEYy?=
 =?utf-8?B?ZWFLUW51NmFCd3JKS2VvTWtoSzhGM3Z3OTJjNCtDaU91dGttbnZ0UXVJS2V0?=
 =?utf-8?B?dllYdDNHVG91eGV3a3o4MnRxRTlTZGJHY2xEWnRUdGxYYXR1UmxURHVyeWhL?=
 =?utf-8?B?bFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk16c0R0Q3pPT09nYkNNeHc3MDlzZFVNVzJ1OTRJNDhsa3dOY3JBOC9udWFB?=
 =?utf-8?B?OWs4UEFzcHpuclZtMHZTRVZtSzN5c0FnQTFXekwxSDVaZlhRZSt4NGxIYkJk?=
 =?utf-8?B?Mitzb2EyWjcxUERKNHBSclRGVnRScmh5M3ZRZDJIdEpreU5nUS9wMGF3RGVV?=
 =?utf-8?B?cmNMNktpam9BOUdnMkdWWUFWaTNIZW93SHF3RVZ0MExhRnUrQktOYlpLakdH?=
 =?utf-8?B?dDQyWTdicGU3RDl2SUU3TEhTa1orQ290eUhXTUZ1enB4ZTBIbzgvaVJaZmIr?=
 =?utf-8?B?ekIyVzRtaXVZUFl5YVNiZ2FVcFhzd3dURDhvc3F1OEpxeEd2Q082RlNURXJI?=
 =?utf-8?B?eFVJemVLdEhZblhsWG1lblY4a2tUeFNkdS90bUdUdEwzS1FHaU9pWmNSSVhx?=
 =?utf-8?B?YUc2YWs4TFkzczBveWt4NCtDc1RudDBwT0ZsbTZKRXBHM0s0bU9vc0FXREpJ?=
 =?utf-8?B?REY1OGIvdHJZNDFvQ2RDSVIzd05nckwvUDNkblZVKzhOVEMyTVNORTJQZHFJ?=
 =?utf-8?B?cUxYczNEZGdaUGVHYk4wUUVQSkxpOHhYUkdMd1A3d3dSN0tDS0h6OCtOL3Q0?=
 =?utf-8?B?QkdCOUREOEtqZXplc1JTL0t1N3lzQXArQnhWQzF3aThLYXIzeDhlKzZQYjRj?=
 =?utf-8?B?TXY3RjdqbE1STDQ2VFhpMGdob05veUVKMjNmZ0FBa3NxbmJGWmZFNDJ2NXMz?=
 =?utf-8?B?ZjRzVHpyNE1KK3FhYzFQMHR4M1VTamdFUG1Lc2lvU3d3ZWx5TDJZbE96SnhP?=
 =?utf-8?B?U3ZZanNDcktqckYvdnVLazd0SmJBbGtKdStMR0x5QU5tQnhJQnJ6T05RUGwr?=
 =?utf-8?B?YWdhTjlSc1hOZkdwQmt6czJPWlo2ZmN1Z2p0Y1R0QTZQKzduS3FtVVllakUy?=
 =?utf-8?B?WkxEdEk2Mm1jQ2RhenY3TlFmbXJ1TDdFYjhOcjlseEpLaUhMZk9jK0orb2lu?=
 =?utf-8?B?SDZUejlwMmRlQzNzWUZmOWhnNHgyVjVqWW9kUGN6b0V5NVdFSDZLZ2MvNmIy?=
 =?utf-8?B?NkgrWFppYW16OFM1U0h6a29UbDBqL083citmd1ZXWU9sRXRic3BhM2hiQStv?=
 =?utf-8?B?ZFFTL3k2WHk1MEMzSmF5cnNLY0J6aVVUUEVyL0dqalZWNjVHWm53aWt4UVlI?=
 =?utf-8?B?c3ZGMlpUSWpNSjZTajJvOVhtaWx3emdDczNnS2FPdHVSZ3JJNmIzanFQWWwz?=
 =?utf-8?B?ZFVwaGE3eHQrMldvMVdmbytBTVBJT0NySFpwWGtKOFhsb0VENnlxOGpsbTZ4?=
 =?utf-8?B?YmZTNW15WTZOSm56VzNwc290ZDRpR2FlRzFoRFBXMGtQWThpWVF6MlR4dXAv?=
 =?utf-8?B?R3RwdHcweGgwTHg5U1U0UDBCWjk3S1F1MkcyQ3drY0cydkphall4ZU1rWUMy?=
 =?utf-8?B?Qk1EUFdGTmtvVVpBUXpUNGRjMEFGL0l0T1phQk1ZNGVjYm55Y2tyeVZrblNt?=
 =?utf-8?B?QWwyVmd0TVlwVHZIOHY2a09HWjBQVVk1WFFzWDZacW5HSVo1NnZSRU5TbC9F?=
 =?utf-8?B?VjFoMTh2NHZyUDY2WVptZEhXRW0rcU9CbExYMjBFbWEvK3ZoTFVzNllIclFs?=
 =?utf-8?B?ZDF3d0pHZXZCSkNXTE9pc2VuWHQreTVKRk41QWR1RHFhUEdTYVhzdGlnU0pY?=
 =?utf-8?B?VVIvZHFzUzJGVitIS2lCazhtRjNuTXNmblQyZC9GZHd6M3Uyem1BZVAwM3k4?=
 =?utf-8?B?T2hLNmpuRUpmNmZxMThmUGlxd1U4WTVSeTQ3TllaM0Jmd2l1Q1ZIVExLWnVs?=
 =?utf-8?B?MmVVb2xPOVpVWjBYbUFYSDY0WTdqZDh3aFNDSTRqQ1ozRWdMaGhlalp1OFQv?=
 =?utf-8?B?aWl6bFgrS21SQjl1VGFrM3JkWkJFazhVRlB0V2JGaGF6SVhuNys5a0xXQ0RD?=
 =?utf-8?B?V3N6cWd4cFc1SzNCUUdUOHdsOTRrQ1p4dDRjb0R2RHBxdm8vckxKYVlycUh1?=
 =?utf-8?B?L1F0bnNBajc5NUIxdGx2dHRJQXdaRmltdW9RMFFQbjlnQ0gvQ0tVTnhlUzlV?=
 =?utf-8?B?M0FoS1hVT2tRUEhmL0dTbS8xbC9oL0Nhd3o1azQ4b0RJVU9hWHd5cGp0SndJ?=
 =?utf-8?B?ckwralZJMDdPVHNLeTRHR2l5Y1Z2QmE2WHZnQ0kyMTMyVU52QjcrUXZ6aWYr?=
 =?utf-8?B?MVlNcDJ0M3dSUzJHRHVyQTRHbTM0YThjcWgvS2NielNtMkUxdmlLSEI4ayts?=
 =?utf-8?B?RGpsUHhNQVRYeTB5cTBsb25WWi9CZDRWWWdHVERod2F0dDBtNEpPajZwWE5r?=
 =?utf-8?B?bXdNRjlBQkxkYjF5MmZCTkpVbmg3OU9tM1Fsclo4QjRUMVMwSW1Jem1HVDdk?=
 =?utf-8?B?RjBlYjhwT0MrS0RHQnRuMHhMYVJyY2xOb2FWMmpNUTZwYThxeDJLZz09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1aac67-ebe4-4b67-c367-08de62438191
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 10:12:01.2784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPQOoQRnIQ40ZtsgGnJCmD3kh8gz/UmWJls7SWnHPKeUKHgAwIY0gsDEIvYk1k3HMdStbhQj7nGLHs09fPc3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6666
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[fortanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[fortanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69833-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[fortanix.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jethro@fortanix.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1693ACAC6A
X-Rspamd-Action: no action

Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in a
kernel page fault due to RMP violation. Track SNP launch state and exit early.

vCPUs created after SNP_LAUNCH_FINISH won't have a guest VMSA automatically
created during SNP_LAUNCH_FINISH by converting the kernel-allocated VMSA. Don't
allocate a VMSA page, so that the vCPU is in a state similar to what it would
be after SNP AP destroy. This ensures pre_sev_run() prevents the vCPU from
running even if userspace makes the vCPU runnable.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..cdaca10b8773 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2205,6 +2205,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_snp_guest(kvm))
 		return -ENOTTY;
 
+	if (sev->snp_finished)
+		return -EINVAL;
+
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
@@ -2369,7 +2372,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	void __user *src;
 	int ret = 0;
 
-	if (!sev_snp_guest(kvm) || !sev->snp_context)
+	if (!sev_snp_guest(kvm) || !sev->snp_context || sev->snp_finished)
 		return -EINVAL;
 
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
@@ -2502,7 +2505,7 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_snp_guest(kvm))
 		return -ENOTTY;
 
-	if (!sev->snp_context)
+	if (!sev->snp_context || sev->snp_finished)
 		return -EINVAL;
 
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
@@ -2548,13 +2551,15 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data->gctx_paddr = __psp_pa(sev->snp_context);
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
 
-	/*
-	 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private pages
-	 * can be given to the guest simply by marking the RMP entry as private.
-	 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY.
-	 */
-	if (!ret)
+	if (!ret) {
+		sev->snp_finished = true;
+		/*
+		 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private pages
+		 * can be given to the guest simply by marking the RMP entry as private.
+		 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY.
+		 */
 		kvm->arch.pre_fault_allowed = true;
+	}
 
 	kfree(id_auth);
 
@@ -3253,6 +3258,9 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
+	if (!svm->sev_es.vmsa)
+		goto skip_vmsa_free;
+
 	/*
 	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
 	 * a guest-owned page. Transition the page to hypervisor state before
@@ -4653,6 +4661,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
 
 int sev_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct page *vmsa_page;
 
@@ -4661,15 +4670,17 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!sev_es_guest(vcpu->kvm))
 		return 0;
 
-	/*
-	 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
-	 * contain the encrypted register state of the guest.
-	 */
-	vmsa_page = snp_safe_alloc_page();
-	if (!vmsa_page)
-		return -ENOMEM;
+	if (!sev->snp_finished) {
+		/*
+		 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
+		 * contain the encrypted register state of the guest.
+		 */
+		vmsa_page = snp_safe_alloc_page();
+		if (!vmsa_page)
+			return -ENOMEM;
 
-	svm->sev_es.vmsa = page_address(vmsa_page);
+		svm->sev_es.vmsa = page_address(vmsa_page);
+	}
 
 	vcpu->arch.guest_tsc_protected = snp_is_secure_tsc_enabled(vcpu->kvm);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..59c328c13b2a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,7 @@ struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
 	bool need_init;		/* waiting for SEV_INIT2 */
+	bool snp_finished;	/* SNP guest measurement has been finalized */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
-- 
2.43.0


