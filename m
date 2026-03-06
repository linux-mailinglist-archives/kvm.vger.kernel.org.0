Return-Path: <kvm+bounces-73083-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oN2JG1D0qmkjZAEAu9opvQ
	(envelope-from <kvm+bounces-73083-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:35:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D93223E99
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 263D2305CA0D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF92285C91;
	Fri,  6 Mar 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q6otoaFH"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C3E280308;
	Fri,  6 Mar 2026 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811238; cv=fail; b=lDs4hRQJib4kOcGmE2iSUfMZ6w8HWjnieryTKXv7raZ+A7y9RWgwukv1wHFrQj+VTQbA9kPPjR73AVoJSScHYgkbr4EjjSTMuQaxG3FH48CdswRBkdhVq+zBAx2iK0ab9UOLsXlxkWY+Oi/ag3c4GcsEiMibng6urOdV7aiugGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811238; c=relaxed/simple;
	bh=Z6y2nc/9sbe+m3zFAYCNHsLDlRTL4/H39hN/8/1EvUE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwmNsyNrEHZcRaol7c2sexKgPTfUcISwvqD38WZTCdPuUblQyE0/WeSY48FdWUaiqgC37RGOCjc1cE9rnhW1McKyEADHw9ahp/EhwFL/Yz2/jRB5MKcdgvoYzRUZZ0Kk7NOwJ0oY/629vaX65x73utc8a022g1p6QSjiGUCOLrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q6otoaFH; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuaQL4FA/GdGlf6NJ/apJJ5xcSZPn5VnZZ3a9GDVVef2Lxw+eyyRQ5ZDDSY5PAUR8a3NDLmrlTTMTa+Ufactb11uhAk9sKpbFk3forjh5K4Rt0YsQLcKHH32W8Fdv7zgblpJiGwk6PPdQxlZTiFeeYexl+KWIvf/sv018AmdOsxlc5bRTdDjwfdgkln22njFc0ie/GDYryDfu8wy16DZeZj/dl5++R10JmRVLfSeB+/AN7Ys+kGDkakANGqJdkta9GDPFcypyIMLMscfFcL8Wt//ZZb0RVXj5JAzmeb4lQgEWCMNOuEPvQsqrC/dCKfpjymYGZgKlGwIuubAj3uXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7uM/7OfQfpjtgjYqDbU15P9C+pVH15sWvYy6rFHCYXg=;
 b=rXyaLv4JkdvNQdkBJIwteePM6vDMj0nQjv9EydVtuf0b+TvtWZC0qATKnmtyjfbDSypT6vZdC4cHLufq6T48neLaS0TAqqkiT5x9tk9gRJ2h32oLs0IfvyJakSqCZlP8aq+6+1PkF4w194DAccwDP+M4espZlGxXFO7/RoUtJgSeLm40VQA65wB7jmYs3xJEzGwbirAzfPw3S+wnEgLFUl9HEuT+4CwsGADJnBVAqG9T7QwRVNV2kQQO8bcFJj+NtArD2Uywc4W9ArGUvtHvxfAuYAY5xF/nz93jJwXm8KhqphemNYmCPvJ0BVw5WmzQGvtEh2ej+LTXKPj49ZYr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uM/7OfQfpjtgjYqDbU15P9C+pVH15sWvYy6rFHCYXg=;
 b=Q6otoaFHgrzxfGfGbUN0iGVHKDIoTDyLLf/38ZYJ/wIUXG6DxrfvGcjbR6INKE04RGmqU4lEnuaDpKQ+pQxExT6xpbLeweuS4wFc5znECXk4H2gV0I/qZnV7q0gTgEHEYAcL/VxkDwD+vr9OWNln9oKM8WwHNktKhOa3/JO5AiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Fri, 6 Mar
 2026 15:33:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 15:33:43 +0000
Message-ID: <e4d7d189-0322-4f04-ac66-d4f7a1a38796@amd.com>
Date: Fri, 6 Mar 2026 09:33:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] x86/sev: add support for enabling RMPOPT
To: Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
 <20260306151849.GJaarwWSaWnnRh9ffB@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260306151849.GJaarwWSaWnnRh9ffB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:806:f3::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b67e61-3eba-4889-9668-08de7b95c015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	o8ZCZDur8JtlOfW2VF79LK2tHphKQAS43jchrdiJa3/2XECehSiSnxicChtmzo6HOjAkHd6q/f1DNfUL/2lqmbPKUPc8duFveNrWEiIDvmOs4wjuL4vnQVd8SRT2thIOEJlD8XRjWj4in1RC6aC0mvn2EexOmCkIebDhLvjKuNVFvdIohfnkrpO/NzZD3kkI/RsE505mJV1VhrmP77t+fsmhW7lVOSDQa/Uc35cOYh/cJzX5AgI+5uDsITCXaFhGE/ldEdA5NLG9PB8Jn3aoKQQTCis9NcaB+WxD94eD+5ARC32dGVXMrGRaaDi1YSkHRj5NbT2vtQ81Q4gZkrGggm5VKy4dJ1kRZSF2ANvbnnEvThbVn+av2CJmtIbogvvXfC6R8hiPL9CFVu826Me79k+G7rIfa+nDuFysYhUJcYGc+JBqzRVyVt21ORZOQKYC2aJffSaRoywVXadGDZPknr+GVN1wuaOqoKQEmhKBUzoSF14Ez4ehBr3WvXac4YCnoxHB0Lp06d77khTuOKcLo9/xaUgkvIFqf1WEC/r+0rz26PmgT3f6rlnkAUubLOhWKflZUisJEtNfxq7SH++ZjHNoJFOyclJjBiyLdx6CueqT7NSNS8yeFRVmgQdb4poWGT/39R9fQOk0OU2vjhlpDpUy/DiWn0ULchvHEPbHdV5ktNvzw0lTjHz6vQkZC+d5FhlFKZbwUeDo/U3IlvWiCdq6JUSypOBYPORkI8pkG/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHJqOU9ab2JleWJYQ1pvVVJ2ZWZVK1pEKzNHZ2RPWDZVSFhqNzlWckVkTHJ4?=
 =?utf-8?B?ZVJlaHhkNkVmZ0tyZWgzeVIwSWh5UXlUSkFKUmVJaTBTOFBkMDZ0YlRLZjNH?=
 =?utf-8?B?N25jTTlCM2xad1lZeHFVUGhCNXFjMTBwb2FDOUR0NTlWVFpJU2FoOE90aTdn?=
 =?utf-8?B?b2RDaG01MFNoRWhGSGdwOXJOMG53TERob3YxeDdERE1tcHVxaC9CT1l1UllN?=
 =?utf-8?B?dDhCV0lvUG5aRmlWbnhlNUZ3UGlueVZSYXhxWnorU1ptcFJGQ2FmeVpwN2pP?=
 =?utf-8?B?U1VYVVM5SE5JWTFlMDl3Qk5LSE1KbjZYdlZNa0ZWaU1va0JxZmoyNkF6VjEw?=
 =?utf-8?B?WXNEUG9tQ25iSjd3ckdSa3hCTENzc081dk0zS2lRSFRNbDlCQ2ZnSHkyMm13?=
 =?utf-8?B?UWlaWDhjNHRYV3A0UHAvODZrZytOdWJNYllUL1lrU3VQTDlUWjY3aExXZjRW?=
 =?utf-8?B?dXhweDBwbGZXR2pGb1dZeFdpWmNKSmFVWUZudUh4Zm9kZlo1VGhTblpncEtt?=
 =?utf-8?B?bGZBOHVpaTV2R3pVdmFmd3ltM2RObTVYK2x1S3VOaHBvR3Z4b3dZMjdoL2ZR?=
 =?utf-8?B?OVFIU0hDWlJTS0xwL3BjZUpBM1h3aVpzWXNBRVdzMzlMUmpCd3R0MlRhZ3BU?=
 =?utf-8?B?WFFkZ2xJNEZRakh2TnRYSGVLTXU5dGVpUWg0aXRlSmRKZGxVb1B0T1M3eTZW?=
 =?utf-8?B?OUc1TGt6WnlwdklhNFVWTHU0VU9FTGxHdEg5Q2llWUdCZlZpc1drSjFuWklz?=
 =?utf-8?B?ZXgrWGJua1dlZEtvYVVwYTZrZFZJZ3VYdEtBRmdHd2FzY0FoU0hSWUlsT2oz?=
 =?utf-8?B?ZDBJTEZBK2xRSmJDVisyN2FKQUlsdlNvdnN3MkhpeVFydE5seXkyZU9XdWU3?=
 =?utf-8?B?c08rRElXMUdnZ1VoRVlpMUpNT0ZDd0k2TTFpeGJzL0U4MG1TNGFINnZKM2Zi?=
 =?utf-8?B?V2RGTkRyWEdSaTIxZk0xSkNnZG5PN1VROStJU210aXV4WDNrTkJqY3lTVXZn?=
 =?utf-8?B?bXFENFJwMnViSm9UYVN1emZLQUdycWlNOXJya2hMY0dFWjZVeHZjSTdZV1BT?=
 =?utf-8?B?QnhWUGhhT3JzMVV1Q0E2ZW9BRDNXZ1NTdXpxSm5BdXpZcmpGZWtNZXBjcGhm?=
 =?utf-8?B?TE9TcHRieU50YTI5Z054ZnVQK1dENGFqeWlvb2JSQmFmQjZlYmRETmRxS0VZ?=
 =?utf-8?B?SUdVZDlRU1ZhRnhua3lBdGZZdDhjM1lNekRWOXZiQ3hxQ3d4Zi9sYytIVmFY?=
 =?utf-8?B?K3dnRm5SN0ZuS0h0K0cwZDhBVWp2VFdGL0lRc2RnekhzTUpQeVMvb0kxVTl6?=
 =?utf-8?B?YVRKT3Jiam50MCt3aEJaT3o0TzdlL2NEVm4zM1hubzFOSFdsOVhlSkpyUmk3?=
 =?utf-8?B?TDBlUTJqSzFrMTdQVTMrcjdxRS9JME5ibVQxUi9RMWVWZ1ordGZSNGpDdTJL?=
 =?utf-8?B?OWlxTjh0QUNSek5lQTBMS25neWh2THZpMUZvMHFoa3prU2J5QXFBTHlvVzdp?=
 =?utf-8?B?Y2NNNk8rTDBYWGJieGRLTmt0a1pKTThBK1hZMEoxTDBKVnk1akNwKzc1dlEv?=
 =?utf-8?B?QUk2L1ZWdk9oSGZJTU5YN1hpT1Rwd1V3Sm5zQzErWllGZ0Y4RHM5aURGeGJs?=
 =?utf-8?B?cXQwRDUzRnFubWZMQld3RWRUd1MwNS8xVzFUeUdwbGlraW9VTG85RU1QeGc1?=
 =?utf-8?B?NnVQdVdSZTAwYlp4T0ptaWhQVzlRVlJmUHI5bVM1ZDFKbHVpbW5OWENKTWdL?=
 =?utf-8?B?cjRXblZJUllNU2tybFhva0N6L3V4TEV1M2g3U3FVRzhtRGtRSjRoRElPOERO?=
 =?utf-8?B?UFBwcEhLYStScjlXNmVabFJ2VGh4TktGM1g2Zm9nUUg2cENOL21zTnRkNUhS?=
 =?utf-8?B?R3Z6MWpLdHVXR1E2amVreGsyVE01aTUvc0w3NjE3MnVBOGZjNGt3aHNXU0hj?=
 =?utf-8?B?bE9uRTFVSlNpeG9RL3ArUUJReXhlMi8vQWN6VlFISlFYMUdTWW1qT3Z4eEhY?=
 =?utf-8?B?RTZDTjM4VVZBZXY1SXloUzlueitIODVFTVJzTFNiZVR5RXpvNWQzYVFCMUkw?=
 =?utf-8?B?UTVRTkNSNnFOT2Z5dHJpSnY5VHFReHZmZ2picTd6djlTRldXWUJRbHlDZzJY?=
 =?utf-8?B?dGcyaHo4S2pWYkp6Y3VzR0tsNEhjTzIzeWppVXUxNmFhNlpNa2FzVXRrVVoz?=
 =?utf-8?B?SGVjdjJGTGF3K215SnVybWIyVjkxTkdwbkJIN3MxRGJNRytvVGRWWVRPUyto?=
 =?utf-8?B?QjRGV2tPVytoVnlGNG1oUlJMbW5WQ1AxdWlEZmFhc2NWYndoMStQZ0FncS9T?=
 =?utf-8?Q?84dg8UxikGcoPu+nq4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b67e61-3eba-4889-9668-08de7b95c015
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 15:33:43.8429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1x1PpcaXf8+0y6lJ80d98V7gvRP9kM7JzVMFAkEqCjcag3cZIoxxJ8AufnaxPO98Zr7LDt6gXbaNx/Tgxnvkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186
X-Rspamd-Queue-Id: E4D93223E99
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73083-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.949];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/6/26 09:18, Borislav Petkov wrote:
> On Mon, Mar 02, 2026 at 09:35:55PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The new RMPOPT instruction sets bits in a per-CPU RMPOPT table, which
>> indicates whether specific 1GB physical memory regions contain SEV-SNP
> 
> "... which indicate... "
> 
>> guest memory.
>>
>> Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
>> RMP optimizations.
>>
>> Initialize the per-CPU RMPOPT table base to the starting physical
>> address. This enables RMP optimization for up to 2 TB of system RAM on
>> all CPUs.
> 
> ...
> 
>> +static void __configure_rmpopt(void *val)
>> +{
>> +	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
>> +
>> +	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +}
>> +
>> +static __init void configure_and_enable_rmpopt(void)
> 
> If the sub-helper is called __configure_rmpopt() then this should be called
> "configure_rmpopt", without the prepended underscores.
> 
>> +	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
>> +		pr_debug("RMPOPT not supported on this platform\n");
>> +		return;
>> +	}
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> +		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
>> +		return;
>> +	}
> 
> Zap this one - snp_rmptable_init() already checked it.
> 
> Also, zap those pr_debugs - you have that information elsewhere already.
> 
>> +
>> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
> 
> You can't test this one - you need to test the result of
> setup_segmented_rmptable() and whether it did set up the segmented RMP
> properly. Only then you can continue here.

If the segmented RMP setup fails, then CC_ATTR_HOST_SEV_SNP gets cleared,
so it looks like the above check needs to remain then.

Thanks,
Tom

> 
>> +		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
> 
> This looks like pr_notice() to me.
> 
>> +		return;
>> +	}
> 


