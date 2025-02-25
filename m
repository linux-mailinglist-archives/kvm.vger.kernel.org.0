Return-Path: <kvm+bounces-39070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C784A43177
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D306C17BC94
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915FC4C8E;
	Tue, 25 Feb 2025 00:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QIhlVCHw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267392F29;
	Tue, 25 Feb 2025 00:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441631; cv=fail; b=UL5IcbWXeL3U1lIcEDQRATULZZjZj5JIlvLyj99oXRp99f7aSW9g3bNKsjESr1Q/eQ1R0Y/D01J/BGGsy6s4/JD56Vkd1TZbfvqb0RoAQDQZtPaNhBo+duO8BjlLyCSNamY4zjK5stSm7++NXgFBt4rkfEnRqhMOj3qozVgrZHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441631; c=relaxed/simple;
	bh=MlDLAME1l5GwH27Y5mQnn2ORJTTdeH+vi1DNmJ5gMHc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bf9koR5v30fC6UD7ZA5IaIH7i9oV81vyliQ8Cn/GvxFOBHvfViJdN01qfGkJb8J+DiKv9Q+Hk2il+THWky3CQuNKUc6U7ayOFJnw280Fl1Car3UDkiogOkRViReP50VBCYUQU7kv4lT8JzoU1Jf5G3TbVFafCQYfh2j8OdcaC/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QIhlVCHw; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2rqzkGFIKaTyj6ksfi4b0PP/6BzOmLGrDIxuLBPt2aJxiFSEuSxns7E+3U0aqU3AhmAKukgNIUoOzjnOola42ucjNkyTeIv1Jx/QFLWr7zKJym8452oPknCJc2niCpHpvs1UWvY9OIsAmzom9VXX8/z37glvo+oDZLiZ18qKmKj7VdSDZ0LC8dsfQltHIDuN/l8cGo6eAJI77sONF3g5+Nd2L5CbK6IiGvlR8jTBzZ+6n2UPcHGGNELuB7ZlKFareUYn4AkEpGZiw78poWijoDLIbgRTlxMPTN3VmYNyO+bbRJD76bmp8zCbQW2gDGs0Fq2tnq6DkvSNH2oQjFBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSGfqPnIKBHZkfvoaCTNUwTZhGcmJV0hA6y4dxMEUKI=;
 b=n8Gh6FrREG4XDk9xeQCh7d9VlDTGew3n+RNmKzOsG/F/p1A4M6ODR72Woe2a1zmiP5kB6hAEGpSSpiGiV6X9vPGzBcoWpNsJYHXJoxyww7cgD+ZWWIqSzxXomTKthMJxkbNdpBWZ4l0EpHnamCPTwME3fIPl29bJUaiR5ABvM0rBy9TPIyvsG4ro0MKAB5h7Aw2emhmQ/StI67hWGOCOQL5HdHwPePjGBUB3jvcQtODeIMrn9GMSoi3CjVMXk6SjMz+jS09icwkZ7SFq5D+PgTUmpPUQKOlwFiHZgoIkz6qynQdAyykAZU43oQw0rZs8zrFr+m0M0QSBBiU/n0Kr2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSGfqPnIKBHZkfvoaCTNUwTZhGcmJV0hA6y4dxMEUKI=;
 b=QIhlVCHwGhJS/OjKr1EZiS3BPygsmkSQkq8eJGEBTlgmySmfgdfn4p2W5rHT5rayHKrhLkgv68xBzSQTt0NZ4rw3nHEmV70Dw3O9iEDaGL9oxXKfQIDTda/Z8l+6iDVLQEOkqoBA1zZsAX7ZX5V/CCssJebjfwrY5I52Iy1sKvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB8775.namprd12.prod.outlook.com (2603:10b6:510:28e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 00:00:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 00:00:23 +0000
Message-ID: <aefcb575-b049-8a9f-b2f0-32333af00e07@amd.com>
Date: Mon, 24 Feb 2025 18:00:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 10/10] KVM: SVM: Invalidate "next" SNP VMSA GPA even on
 failure
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-11-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:806:121::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB8775:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f22efbb-27a6-4de0-7997-08dd552f66af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTdTU2JJTnB1SFRFOThFdXVSazgwY1FqemdIdHRySDZNMlFJUkprc2U2b0FK?=
 =?utf-8?B?WGtOZmNmaHEvOCs0eW5kWjR5UWxpZnBUUC8xT25CbXY3aUY2cnJjM3BYbTNO?=
 =?utf-8?B?VjRyT2preUkvMnIxWk8xOFdIV0YvajZHaTFrbDV3RFdDOStPMGtvY0oyTDRp?=
 =?utf-8?B?aG11enVTTlVYNFFLbUxGaG1za0Q0VmRsb1N1UEZkZTltbmwyUjQvZ3c3aFVX?=
 =?utf-8?B?QjJVeDEvK2RKQW42WkxycjNnYXZqQmFtRHNaeDFaazNQeDVjWVZRcEN2Y3JL?=
 =?utf-8?B?S28yT2dCOTFXL1p2YThXY05HYVU5UTJDMWVyUCtWVUZiOStPYTZSdHY0c0Fp?=
 =?utf-8?B?clFRVnAxb0VtYVBTMndUYktwRm1TUXk3enVTU3lKSTVYdXAvUXNacUljRHpj?=
 =?utf-8?B?djQzRDJSTkNUMHFFZFZPbkVuY3B2WE9mdnhxZitJc2Vmb0FVZW9UZEpEUGp5?=
 =?utf-8?B?bnVXVGxTcERGcDBqbGdMWHI4T250UDZhSyt6RGdPd29nd0UxYVZuRTNmQURI?=
 =?utf-8?B?V1JuQ29nYmFxMjRLYXJJNloxZlM0dmQxSG12QUhkUXNpOTZZSUJaeU11TTQz?=
 =?utf-8?B?aFhtZG1WQ2dHQzNIcUs4d1BMY3RXR3ozekJteGRBUUZNMWNkVkhZOERsajRo?=
 =?utf-8?B?WlJXNEhLTkVxbDBEdTU4YWV3UVkwTlJCVGZ4VXB6aXQ0dDJTM0MxbFNrR1h0?=
 =?utf-8?B?Tm5tSFFrRjZTbnhML3V5WnRrRzVqMTZSUUl6ZFkyTXNCL2d0SDZDcUdTMXVI?=
 =?utf-8?B?eFpsVVhOQkZ5TkxOZEZ0YUlmZmdhVmpVd1JHUk04RXFhQmV4amxZd0xpWjZr?=
 =?utf-8?B?N0JwK0E2akxaOFBNbXhpb1pOY3k1YjZPNm8xSjBtZ2JwNEV2ckU2SVM4ODl0?=
 =?utf-8?B?ZlRiVDNhTDF6VG5yeXJQTEU2VXExRUhyU2RyRmkwQ0lPUm9NQk15bTVyOXNV?=
 =?utf-8?B?VzA0b1p5Ny9oTFhKQU5LdTVIcnVoQjIxdTZyQkZCZ2Nla1hxVlJFSUlKYkFH?=
 =?utf-8?B?NGQ3TjR6UzVFaCtPelhqOXA3cFNrYnRjY1dIbG5pRk5tMGF4dnZLR2orenls?=
 =?utf-8?B?b2FSTmlOcFYzMTlGMnlNMXVvUWVha0dpR2RTSzI0SWZGLzJJOExSTFlOUDNz?=
 =?utf-8?B?ZEhPQ2RNZlJSWkROZTh4ZmhzK1ZDeG45cmdnV3NSY0ZNdGV6MlFFZkFWS1pj?=
 =?utf-8?B?WGE0emt1NTVpdEtGTVk5TTh6ZDhhQzFYazRtbko1WlR6Z3VoWTFJRCtSTS9R?=
 =?utf-8?B?YytIUnpVU29BRWRjMUFYeDFmNldiSzhvQUk1b1ZFM28zbU8rVjhuUXpSMmhR?=
 =?utf-8?B?dlUwS0EyY3FBMTdoK1NGNE5CWHhQd25NRlZpS2s4RFY5djJLRXpSVWN6SE5M?=
 =?utf-8?B?MytzSHFJTk1nRWgrSTJCZGI0MjdIelppai9zanZnRnhSWTUvN0ZGaUR5Tnll?=
 =?utf-8?B?L1UxL3VoczRwNjBOZlROM2RLQUF0UmVTYS9hRUwrdHB3T2pVODllTzYxaXZs?=
 =?utf-8?B?OE84N2pub2RYaTN0dDN4RkxVWTRLQ20rYUErNG1JM2hZOWNrdnc2UHhsSFpU?=
 =?utf-8?B?aDZXQ2NabnBybXRvMnRPcUE1bUIvRFoxckVtN2wxMUczMHZQUU0vWlZqblFv?=
 =?utf-8?B?cEJST2E4b2M5MS9nVHU3T1RGMDVaRzhsVUNiSCtCZDk1UGJCa0lsVlZrTExt?=
 =?utf-8?B?SWVDUENTeFFtZkVQSVlRVnNZdURkdlZGS3RqN0UyVytERzkrQVVBeHY3MGZl?=
 =?utf-8?B?ZmpVbTQ2Ukh6aVJ5VDhLWnNMeGEvUVJleENpZ2Z0WHpYR002QlcwbGZOeWVU?=
 =?utf-8?B?aTlJM1VOR01lem1WS1dzWEtwK3ZPbW5uUEJLamVkTTZadWt0bXpzbTBMM2M3?=
 =?utf-8?Q?gt0TUOuZ/SZ3z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0JxV1g5Wkw4U2tYdytaR1EycFUxbTcybWVhUG05cURqSGgzRnVPcGJoZy9X?=
 =?utf-8?B?YXhZL2orc0o1MjN6NS9Lb0hIL0h5TUhUdDNJZEE1bnBlQUFnamtGcjRTMVVC?=
 =?utf-8?B?Z04xZGEwTE9tVHJ0NnF0Z2tTWEsxQWlRRkRCZnlDUnB5ZEIreXpCa0FoYWlx?=
 =?utf-8?B?VER0WGNHc2hXemhlQisvbjEzaURqbTNCVVVpSXJGN0JqQ20xVWFHcWV3UVha?=
 =?utf-8?B?UDR5ckw1b3VZclVNeEEvSEJ0OTdqZkluNHNWYWhpSzBqbEI2WWZKb0xBUHlo?=
 =?utf-8?B?K2FZaWJTUko5bzNvNU5qSkJRZmlISFdIVzJKVkhKL0NGcnNzeTRQTTkrRkt5?=
 =?utf-8?B?RnJQSml5ZFFhK3hqUGlXdDE0K1JIOTNFQUNjVGw0dTJpOGIreEYyRUhvS0pM?=
 =?utf-8?B?UnNKbS9vWW9nb2FYR1dSQmUwUW8rUlAyTkg0cnl1dmRpMVpuUlVtY3IrN3N2?=
 =?utf-8?B?c1FEcDZaTVFtRUx3WEhJUnRLOUI4QytLZFl4L3g2RnBPL1ptWUQyWG9vNm1E?=
 =?utf-8?B?Y2ZFeWN6TS9oQ0RLL2tDcmlRcTNZckUzcU81SkVkY3F2SEpyYWJYeHRuWWdF?=
 =?utf-8?B?VUlKM1Y1M2IyWCt4V1ZZMlhTbGFiTlhUZ1Exc2ZhWkNKdEUrWmE3KzY1UHVM?=
 =?utf-8?B?c29wUEZZVkR2dW56VE9tdkVQOFlIQXF1aFdoU0NUdDVSWTZwQThmQkpTK24x?=
 =?utf-8?B?QmdVaEk0ckp1YTBoME5ONXJjVUFDdkVrL0VERzdtam5XcUswRy95WE9XLzdm?=
 =?utf-8?B?NU5BU294bi8yTFRwa2RDdC9rWFBNei9tYXEyd0F2QmlUS2pVSHVqSUdLcUNu?=
 =?utf-8?B?V01EWkNRYzBsd0VUTWh0bXBtT2lpZ3lkQjZwcUwvQjBCWXNURTdiVzBiWkpv?=
 =?utf-8?B?V29QVmUzZmE3ZzNvVldDMnExQWdhcFh2b21Hai9tNUhtSi8yc0lsbWJKcWdE?=
 =?utf-8?B?THRCUzRDbXNSVzR6bzdJcUI3elBTWGw5RG81cktqNlBoZVJZL25mbFQ0SWxQ?=
 =?utf-8?B?ckttUlUvQ3FiVTBWRm41YjdodzIydGxtR0dtcEx3bDkrOFhHOUt4a1BRM2Fm?=
 =?utf-8?B?Z0xhellmNG9YaG5JSTA4SkRxTnJqakxaUVc3Q0wzelFyV05rY2gzNlE5eGdh?=
 =?utf-8?B?SFVjUnFoTlNpTEdsaEFoT2FHZlM0ZDJQa2VBZzJsSVBrT1lQUUpzM0daeUMv?=
 =?utf-8?B?aG1LLzVwVmxseWV0cFQzMExDTDhNY01VY2diOXZDTXQxQmdNbi92M21mRTBr?=
 =?utf-8?B?cW1FMjlrQm1qK3JQTXlQVThCREZNaUtQc1JxUFpUV3RyaW41THpTOUplT3g3?=
 =?utf-8?B?cm9IZ2VyaURzVjRYVDlTc1lXczJjMkJBUFhZclh6cWNtM0dKOGtFenVzTkxY?=
 =?utf-8?B?SUNlS0Z0aEZwdEJ1VHpsMnUwTEFjUHJxdDRlYTFmQTZ0S0dUbzFyb1E1V3lZ?=
 =?utf-8?B?bWxGdDlEYWhUNTNtelRQYXlCcHFra2FoRjhuQ2RETjVXdE1zVlZqcFdjWS9Y?=
 =?utf-8?B?eldNZlgzM043dXpFZ2xYVnBrbGsyMkNRTDhOZDJ3bThGM0Y2QVRuQ0c0OVN1?=
 =?utf-8?B?Y0p6QjNwdmU0WTNtMXNtWHBxeDJCeFgwSm5OdFlLanVaNFNlbUdlSGg4MjlK?=
 =?utf-8?B?NnAxL0dqajJqNDViM0M3bUJPb1FlSHZ0QW4zUloxZThHS1lTbmRkQzNpYTBu?=
 =?utf-8?B?aEhPU2E3ekhvMFpUWkhMWXhZUnowNFRoalZTbThYSTEwelRuSkFzYXlUWHpX?=
 =?utf-8?B?K3pzL1pJaEV4blNyekR1bFFTZDRuaTZEY3kweHZTcVkrYkNXQjFod1o1SXJF?=
 =?utf-8?B?Y0xvRFRXYVZtSUtqS1pTOENGWDF3eUdGdXVYL1VvQVBMRmhuZnNpNzc1S3lL?=
 =?utf-8?B?blBqNlozQ2xmUmpGOVhUQU14Yk5xTjRKL0dPV0p2ckNreC9jNUVEd0hHdm5Y?=
 =?utf-8?B?emR5L3pDMVNFTEV5WHd4a0NZOU0rbW9BWW5ZZHYzOGVTR2VLdzFYN0Z3Ukp1?=
 =?utf-8?B?ckErTml0STBCK2NiQWJKQjJLZU5YSjhZakZoSTVidWpyUmRVZzlMK242T1lo?=
 =?utf-8?B?Vy9Sd3pMQkU4RVF3cHFCN1lBditxOE5NRnI4SnI5NTVyaWcxSk43dFprT0FV?=
 =?utf-8?Q?UekDO0+JOcwA6/H3WWLUZOJgC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f22efbb-27a6-4de0-7997-08dd552f66af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:00:23.3296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7hddoqhlqHz7lHCu+fh40d7uMNLT7/npB9UsWVuU8DH5sxS5Ne1Ep1DXEYvzTPI6sny0ZSWxvsni8WcnKJ82w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8775

On 2/18/25 19:27, Sean Christopherson wrote:
> When processing an SNP AP Creation event, invalidate the "next" VMSA GPA
> even if acquiring the page/pfn for the new VMSA fails.  In practice, the
> next GPA will never be used regardless of whether or not its invalidated,
> as the entire flow is guarded by snp_ap_waiting_for_reset, and said guard
> and snp_vmsa_gpa are always written as a pair.  But that's really hard to
> see in the code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 15c324b61b24..7345cac6f93a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3877,6 +3877,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
> +	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
>  
>  	slot = gfn_to_memslot(vcpu->kvm, gfn);
>  	if (!slot)
> @@ -3906,8 +3907,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  	/* Mark the vCPU as runnable */
>  	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
>  
> -	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> -
>  	/*
>  	 * gmem pages aren't currently migratable, but if this ever changes
>  	 * then care should be taken to ensure svm->sev_es.vmsa is pinned

