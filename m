Return-Path: <kvm+bounces-69404-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEapJ5Fdemm35QEAu9opvQ
	(envelope-from <kvm+bounces-69404-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:03:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F89A806F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B4D6304703E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C68372B53;
	Wed, 28 Jan 2026 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NavsWGUF"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F729E114;
	Wed, 28 Jan 2026 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627008; cv=fail; b=tPZH4e0HSNH77CU1zP6aOpF7a1vjesja6oh+ZZFlDlxiihIU3uwCQQ7cCpbOtYMxKUHuNsXb3f9uKOPYTRr8FYOR2VOls+QUg3Z1X9yPVxFvunkKCe+tg6/LlHm5xJD8R1mMfqPfm4sji8XrdZYcHuaOJEiwqwyI+RmUQhVdP1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627008; c=relaxed/simple;
	bh=QptluopCN2KzCE4H9rD8moecyt7xvUjyHwnQaVuOwMg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S9ouoxxcus4ZWfnhUu5RBZ1lSMEBWOG5lmoXD9+xSAPAS/YAW7YNDNMC2Ubqf3dyUrgJz+rcqYh0aiW6rxfOQKpz1Uaxpg8LHv4kHxkVhKjQXKQ2Szj2h2uIQHhqwhhiGe8ebBF8ie8JuSd4HonEPez1Sy22BWZ3CoJtYkgeODE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NavsWGUF; arc=fail smtp.client-ip=52.101.46.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5RSdI4TAZcBqGe+ROi7cJF+QdqwThT/vxzOGiYCIsxA+VXpTk7SQK5w3AvcDt0aBqTX7+7r0J5R2MISgZYbQKyDlii2c7G+5L+9Msr0IHjDRxG3nx4MZ9A36LoWHetlQVsVh9/IyeZGHk+/U82reCN/+wm+9LRbmgubZ4CE3J39oz3VnUTiPuZyEL/Cs8nbbJNmZJ9Jt/ucv+9W2/oPzLxI2yF0NLfG0VnpR46hGvF5aM/h5CcXwtFuSUE2+06txpBES+OrsefyXWmHGCCe0Bp/vEyyHynKdYCLR4XzEKLpNh+0vz/aiJ9nx/x+c+nIWfHQ7waPVeqvd8jwAV/tug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmoDrOWdmCm9X1jpiZaLiyFdRwPFq4R64VPuePWGXgE=;
 b=ZwQZGi4cheUxT1BbagBWsObPdOxH2JzBmh1TYQyvWgeFk9waY3DX4UugFTyQdwHJnA+pziEsorP03jmjnMDufoe5ZDOlf475ng14YP8JAuUGlJO2y8vkTdm70L2ij7tmSyrOn1AOWm5C1DnN/jCAZckyEgxpX0LEKMbnRkrbSN3TErb6iQLJaRUTSPCvZntsG7semkAVIMqKQy9lkp3tVVxDVT28RpOTLyNJBScLZOa31BK6rkdmBtk7VizOFHezJArkMWfnaYNTxaFeZOS5wXq9NbNm82GojFOKsgt+XJXGNcQYrfwXUoP2K7tj+22r7sVL75QYwXbM9E7Svhucyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmoDrOWdmCm9X1jpiZaLiyFdRwPFq4R64VPuePWGXgE=;
 b=NavsWGUFG3pmcmDkigzM2CXX10jq1a01IxRRjqEE7dtw4gVOqd7po7ui6Ra1OMYhtpAyVCXbwEcd5Yq9huZW+80zQEEe/zwKFw8EON6jkfshTUn0YxhtyvnUCOnB64GucW+uxZOlblTb3TtIlDGUOBVryXW6x2qvu6LLMK2uUus=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 19:03:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 19:03:14 +0000
Message-ID: <72838e83-bfb3-4ecb-bf3b-9f37c3116f29@amd.com>
Date: Wed, 28 Jan 2026 13:02:37 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
 <kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>,
 Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
 stable@kernel.org
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260126224205.1442196-2-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: aa0ee703-dfe1-4162-6b74-08de5e9fe336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUJoRmY3MWkwVkdxSGdKUktkZFV3cnJnMGNhczlYSVVYSG90S2NpZ1ova0dK?=
 =?utf-8?B?dlFZS3R2dGI5Ry8wVHlHSHl1Si9ZRytpcWNSRnMwanUycGNsVjBCSVFoUDQr?=
 =?utf-8?B?YXlKMldSajNlWDIydXFrenYrSGk3Z3ZoeGM3amdyUTlBb1pzbmdkcGVvUnZS?=
 =?utf-8?B?Yi9wdm9WMldPVnBNeEVILzNwc0g0QWlJMTVYVU9RWmhRUEd5NnJSbWJtSzJ5?=
 =?utf-8?B?RVZ5WkVzcHlJNjlseUtPc3I4SVdJbUE3YjEvalhaOXRDbm55ZGc0MEFQc21m?=
 =?utf-8?B?QkJQekF0MXdmM2VjVEh6UHdVWnNnYzIwVGpRWFZwa1pJQ284Ny95UWNpallE?=
 =?utf-8?B?WXZvbDFIcjlLRWZnT1M2VW5GS3p4eFZhL3hSbW5xYm93STBoUWx5L1FVT012?=
 =?utf-8?B?SEJrT1lRWHhjeGk1eWN1ZVBLdXI1RldiOU5GOU52UTh3eXVYdXhnSVF5dk1J?=
 =?utf-8?B?eE50SGUweWs3dkxaYXRuSml1bnRGWEFPRXJtSzc5VHBtK2tOVzlsRmRoZ21q?=
 =?utf-8?B?Ti9xWmxqbFNkT2VDUDBCZ3lIK3VId2pId2xZTnVWZ2tLZlNVR1U5blJBWTcx?=
 =?utf-8?B?NGNVNm02bXY3TjRQekJSMnV5Qm84Wkdrcm5OMlBHZWtQK2lxeXhlR3U4QjBB?=
 =?utf-8?B?VHo4V3hFM2dVaGUrWGhhbVArL2tFbThOQ0RhUERscU91V3RELzhqUk1NVkN0?=
 =?utf-8?B?bHh1Q2t0K3U2bm4wdXBXMmpNNHFiemx1U3pNY3hRTnJ2VlEvcllXcm5xR0Rp?=
 =?utf-8?B?S0NRZmJPYlJYNHQvZWFVa3Nja3p6UUJ5TVg4Y3A0ajQvcVliUnZpWWR4UXlG?=
 =?utf-8?B?UUdQaHlvOHhGZVowR3VFd1V3cE9QY09mM2NBdUw5ZjFqTWY5Wks4M0t1Z2Fq?=
 =?utf-8?B?L0k1N1Ivc1hTUkpJWU96NjBKY3prSW1BaFR6SWlLbW9xTkZBcm9GMUVMbmts?=
 =?utf-8?B?MW1oVnRnUVdFMDF3NkJlK1FDZEtpODA1eW1OM2FJWXFlOFFWTmVzb2lRajBC?=
 =?utf-8?B?dTNmSEh4dVF3OW1FV1R2ZUJxbXlHV2oya3JmbjNzaXhoYmxKTXFJWUl0RFJZ?=
 =?utf-8?B?eUtrTEY0QXoxVy9wRFpsK1k0YnpMcng2bE9pQitiRFJxbEs4LzdJM1VMV0FI?=
 =?utf-8?B?c2tNd2t6WFVpMU11dnA0b1pHTjRnZU9Wa1pNQzliV2JTZ2lFc0NGc200QUh6?=
 =?utf-8?B?V2djU003VkNOd001K2Y1V3NlUnVLekNqSUR2VUwxSmlXcjl0Zm1qMkVKNFZK?=
 =?utf-8?B?Q1RzZXFnUDRpdFZsYjh4V2VLUnJQSW9RdjBNR2p0cm5XVGRyd1QvOVJlQm92?=
 =?utf-8?B?LzE5VGdYeUVRak4xQ0dQUkFWZnVtSlJOTi8ycytMUCtjKzJ4MWJvQTV5Snls?=
 =?utf-8?B?TGk2OXQyZ0dpSjVCdTgzWDZTVFE4STNRSURhQkl2RWJzRmM0TEp6RFpmcFI5?=
 =?utf-8?B?T3dpbkE4WTcwbUJMdHQvNFYvWlVFV3lWbEpyQ1o2T3ZhVkdsZzVMOVY5YUFw?=
 =?utf-8?B?NFFRUXpmRjlZVElyZ0dhSlBEaWc4MGlFeTFjUlNONS9YT0RpUjRHMHRremIx?=
 =?utf-8?B?UGorTVdzSjdOOTBIQlY1V2dtSDcxcmFUNG10WTZiN0c5WTFyTjFNQ1BoR01Q?=
 =?utf-8?B?ek9ua0k3Y2J4cjdVVXVxMHR1blpNV0ZMQ1dlVlNZajRWZlBhTk9mYm9kNjVh?=
 =?utf-8?B?RUxYdldkV2VXc2NScjQvMUEwL3NwdXpnT3V4UU9keFBJQ01EejhPYkhuRFhi?=
 =?utf-8?B?Zzc0TjJtaE44R3pRRFZXbUZEV1ZuZE54dU1zZjY3c0dBT05Kb1NhRGEwTFZx?=
 =?utf-8?B?Rlg3c094TUF0QzdONDNvcVZKaXFzdHZpSEdjaStFcEFmNnhxQmdJOFIzTkQx?=
 =?utf-8?B?REVzVnJkd1BDNHpFblRIM0tFWFhIVHk1SEt1akhya25DeHpwV25xS3pGR1FF?=
 =?utf-8?B?RWo5eDBENUQ4VlAvc1FQQlRSb1ZBd3V1R2ZmQ083cGJSODBnbjVOR0Nsc01L?=
 =?utf-8?B?dHh5dEFZWE5KSHRUdW5xdDdUNDRYclpBUEp3OHQ3YzF4a3JZbCtYTjBVMzVG?=
 =?utf-8?B?WDBTOVVFWWoyYkg2Yms1Q0YxUkVZZTJRTWdqajVIRnF2cVArdFkvUklQWEZy?=
 =?utf-8?Q?QDZY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c29hNlhOL1VEQTFvOGQvL2JrcEhEaWtEbEhqVFhMZGN2WElUYXZEWkJpakVu?=
 =?utf-8?B?ZEw5N2k2RFBqWkZrVDA0ZVhvNkovaTNkSUU3NFQ4UDNwb21PVVRncUpwNkZC?=
 =?utf-8?B?Wm1Va3lVZ2ZET1Y2YVRJL2R3YnVFMzBBUnVHZ3hONDZVeHovWVdydE5XQ29O?=
 =?utf-8?B?WnpxVHVJMlplbEs1dUpmVVNKOFFJejFEQ2pNSDVqR3hHWml2Q0xZSldWcmhK?=
 =?utf-8?B?c1hzQW9qZmM1UVQxNElreDV6eTBsUnpLdlZpaFU1YWp3V2JLMG5aYjhpY2Z2?=
 =?utf-8?B?citOcTJTWXBHSW5EL0RmK1ZLUVRYVENldHZXcy9nUWRHQzg0eFJZT3JWUmt2?=
 =?utf-8?B?a24vR002UnpLTkJDSnRvVGV6RTJGS08wWkM0WG85NVROSktGZ25IT2ZNMzVv?=
 =?utf-8?B?Sms3OWpheEo3TzlDYk9IcS9rRDBrSjdYUTFnVlE5eUNIMGIrdXNaZmhYUVg2?=
 =?utf-8?B?SUxjL0NaYlZCYnlRVmRONHNFZ2thQ3FMcWVUeml1ZDJyM3pDNUtNSklldWZs?=
 =?utf-8?B?YVFGQnJ4VEJUQ1N3WGxYYStSVDVKSzV5M1JVbFI1dWFlVlU4aWZqSmxxOGJa?=
 =?utf-8?B?M2ZtWFNDREdsQlZYTGNZdWxtTklUeGpBeXJDZ0V6cDZ2T0FzaDF5ZDRqSmFt?=
 =?utf-8?B?UjNaTC96czVXNzFkTUx1NTlDL3BUb0dxV21jR1h0QjYwZzNKa0pvRnl3eldD?=
 =?utf-8?B?eEczUnFBNVlTN0Y1STAwK0R4NnpkS3RGOEk5TW9tLytuV3FKcDFkR2pNeFVq?=
 =?utf-8?B?eDQxVU0rK1VxRVRob2xIQVVpazErSUk3bm8zb0t4aURFeit6V0lEUDEyQVgr?=
 =?utf-8?B?WStsWTNKY25NdFhLbE01L3VhWjE0bDBGUjJMUDM4cmFMMzlaZDBqb05IMlU5?=
 =?utf-8?B?NndCckZjazE2dnBvM1Q2Y005M2R4MnMyZWdGd1VrTW91RlZYVkNLb2daeEk3?=
 =?utf-8?B?cnZHSGlYMm1RUDNNSCtBb1JodzRWTWx3NER4S1lUeVBEQzF6L2pKdEpKb2dh?=
 =?utf-8?B?VnV0NFIyK0I0dUM4eUJHTWU4VWwvbGhHVmNyVWdwcklOYkxHZG16bi9wU2Fy?=
 =?utf-8?B?QUlQVUwyTUthU2huMDAySUtRcDkvQzlHRnVFYldKVGUxMk53QXBHcU9xd3Vs?=
 =?utf-8?B?RU1RWGE2Nm5pR1VnMzRtRVhyM0VjVG5OS293enZETy9FTGVHVGhDSzN2TEcw?=
 =?utf-8?B?VklmNk1jWDk2UXpKSGR0S0tkQnpTMkVCdkhTYkZCY280M3RtR0IvSG1oU1lh?=
 =?utf-8?B?dlA0ZlFON1ZMdHJrKzk0eHUybklmNlFZMzd3UVhwMWROa3N0UUszZXVmZ2oz?=
 =?utf-8?B?TlZRaUUvVENOY3dIdTJkaE1RdGF0SldvVHAxZENtRzkxSW1ZSFhOQzErNVpQ?=
 =?utf-8?B?YUdiTGprTGVHVVMydWlualVPLzVNRk9NUENWaTVYcUFLbU5iSlZYNDRpQnd5?=
 =?utf-8?B?Sm56N2RxK2JBY2t6VlNyKzJLZEx4QXdPdmRXakhMMS9wT0JXVFFoekVSWUJB?=
 =?utf-8?B?SCtoUmFMK2VPVTcxc2JzY0VZNk1RdVBFdXNldUdwZ2ZadDg0RUszUGcveTFL?=
 =?utf-8?B?WmUvMXpZYnJ1cWVVYkZFMDJiY0JKd1c4cloyKzR6b0NmNnZNVjFZc1phdVFY?=
 =?utf-8?B?U2g1SzcxYU9SN05udGFEZHY1QTdMcnIrUnBtaXp1TTlwN1V5SEtKMHozdGhz?=
 =?utf-8?B?YjVPTUJVOEhLdGdHd3RNbGFMYmdEVjRwNTFDTjl5YW96UFRrQXdDYU1YdVll?=
 =?utf-8?B?UUFqUHFjczhNWXVWcXdPN0NvYmNZSnhIUmRRR0VlR2JHWW9WMTFINmY5eENj?=
 =?utf-8?B?SE02R3dyYnQzNTRXc2VRSE1UR3lrMXlmR3BCOTk1T2VCaTZkbkxKVTlFdFJq?=
 =?utf-8?B?RkIwSUJyTGJWN3k3Vzl4bTZ0YTVWQ1RpeEhJQ0tJOHFXN296aTFXckdpbDhN?=
 =?utf-8?B?Qll3ZUc3SkF4eDdUZi9STXRvZEZrZkxKMWFpRXVsNnVhVkFrSW9mdnRXbGUz?=
 =?utf-8?B?N0h3clRrRmRpK2wrVXdUejYxMVJrSmdObno2eExBaXAwTk1DbG03NlFDWG5Y?=
 =?utf-8?B?bkt4bTRNYk9kYTlETnFhcHFtMnB2ekNYdGVMZmtxUThDZEt2QTZnRUxvNGNL?=
 =?utf-8?B?TFRIY3pEcW1lOU0raDlDU2dsY00ySGt1SVdCR1h0R0t4NDJYZXFsSHIrVTAw?=
 =?utf-8?B?RXNRdkE2OXhtcnVjc3J0Y3RIQy9wd0ZBcWIyZmpqQU5kTGVQNmVOKzk3Nldj?=
 =?utf-8?B?OTBnaDNPajBtUDhrbXVrUkJXVXA2emwxbnVEVlArdkhzNnZKTWtaNUZlNGFt?=
 =?utf-8?Q?LJZY3MebtOgmSLZSwu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0ee703-dfe1-4162-6b74-08de5e9fe336
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 19:03:14.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yYInt5vJk5qUzDshvse094zVBIOCw1JmA3f+j6Okl002hY+ynScqReXFqMcGms7yJlvGWSsFH2/KBtioc3//Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69404-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid]
X-Rspamd-Queue-Id: 24F89A806F
X-Rspamd-Action: no action

On 1/26/26 16:42, Kim Phillips wrote:
> The SEV-SNP IBPB-on-Entry feature does not require a guest-side
> implementation. The feature was added in Zen5 h/w, after the first
> SNP Zen implementation, and thus was not accounted for when the
> initial set of SNP features were added to the kernel.
> 
> In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
> guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
> bit as a reserved bit, thereby masking guests from using the feature.
> 
> Unmask the bit, to allow guests to take advantage of the feature on
> hypervisor kernel versions that support it: Amend the SEV_STATUS MSR
> SNP_RESERVED_MASK to exclude bit 23 (IbpbOnEntry).
> 
> Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> CC: Borislav Petkov (AMD) <bp@alien8.de>
> CC: Michael Roth <michael.roth@amd.com>
> Cc: stable@kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

With the change to the subject line...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/boot/compressed/sev.c   | 1 +
>  arch/x86/coco/sev/core.c         | 1 +
>  arch/x86/include/asm/msr-index.h | 5 ++++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c8c1464b3a56..2b639703b8dd 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -188,6 +188,7 @@ bool sev_es_check_ghcb_fault(unsigned long address)
>  				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
>  				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
>  				 MSR_AMD64_SNP_SECURE_AVIC |		\
> +				 MSR_AMD64_SNP_RESERVED_BITS19_22 |	\
>  				 MSR_AMD64_SNP_RESERVED_MASK)
>  
>  #ifdef CONFIG_AMD_SECURE_AVIC
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 9ae3b11754e6..13f608117411 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -122,6 +122,7 @@ static const char * const sev_status_feat_names[] = {
>  	[MSR_AMD64_SNP_VMSA_REG_PROT_BIT]	= "VMSARegProt",
>  	[MSR_AMD64_SNP_SMT_PROT_BIT]		= "SMTProt",
>  	[MSR_AMD64_SNP_SECURE_AVIC_BIT]		= "SecureAVIC",
> +	[MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT]	= "IBPBOnEntry",
>  };
>  
>  /*
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 4d3566bb1a93..9016a6b00bc7 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -735,7 +735,10 @@
>  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
>  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
>  #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> -#define MSR_AMD64_SNP_RESV_BIT		19
> +#define MSR_AMD64_SNP_RESERVED_BITS19_22 GENMASK_ULL(22, 19)
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY	BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)
> +#define MSR_AMD64_SNP_RESV_BIT		24
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>  #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
>  #define MSR_AMD64_SAVIC_EN_BIT		0


