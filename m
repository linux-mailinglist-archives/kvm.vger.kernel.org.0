Return-Path: <kvm+bounces-33388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFA19EA8D3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92172282DB1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3D322CBD5;
	Tue, 10 Dec 2024 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s933QQw8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DBB14A0AA;
	Tue, 10 Dec 2024 06:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733812726; cv=fail; b=K8kM6I+J0rCowj6SKgdIfOHpPzNqTeO2zlmx0g0maAl38j33qhLXbChnG/cv4PWy0+lPbtLJVtDzCv9ysMYp422IEz2QMODcWaBHEPNQomU+huqnRWzt98shMRm2AEpJTgtiDwqInFKsXADL6VYC/qxxcCV9OXJlz6tuf9s7hBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733812726; c=relaxed/simple;
	bh=P3jQWj9kV+866EfTkrzMq7rC7j8MxqrGeLvC/dArijk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M5UusMOkXZD8LWeEdsN9+h/e8yIrpcVx3obJ0BXi/4dCzxVo1lmae47gl3UUgHZMnVTZ3hDLQWykdeRuebdhd5ErXJCQt8tv62CrkdZ75dph19ZiqIG4YJQqwJlQ4G9ebbJxhhfGWr66txJFWol+kynaQCzKrF7ntbycUS1YyXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s933QQw8; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh1V4lxcxuuUGETRkUcw5sEZE9vxjOEdA02gvgAXN8U/S9YyeUg+1B21y2nZ/kfKX2U3FSSJjkD2EevImwWeFAzrtGzCMSrhxlye9uqwxyPyWChCnjzBfYU4rWdfVa6HgltAkHsJ0/nHuDoXQMY9KsWPryh2T59hkleflaCOkoUQvC0Q/1aIokBH2ISJZ8dDa95LtK4klHRJEJjqVkuSdXEZj/NmriJn3xAMMdP2pizWmb5TeJNuS57Uet4b208Alhblw1PUf19zlsMUjkxHNzCsHGWMdJd7agPn8BhPqIEQeEWEyzRhrH5VTMiKKapbiRq1Od7kKH9ZuNupf7qlhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9WkdGSJkz6Uu7811wo9icaBgJ2WqXde+le4ICSOrNg=;
 b=Qxf5UK5h+i3hWOsKUuLqoolTgMEghIVKY42sGkfb0DGKscRLfx+OwspULAbOG4+ws2QdO5igNst01bYJmD7Fm8HK5eixT7UM8whOT13KRnhcIIwuw/nv9CFQUSHohbwaSr7rKJOs3BBvkakqlj2Vq4EnjNCXCV/F+HnuFStlAxc5e8JCcyfGRy7ZyggDSM6SBpq5Rp8re4Jg+7uViB8Ps0mohJaLeQDGkWzJ+mQjFYOQgsgMjIXofoxHOGvX6D8ARw0wxl2Fi43g13N5WwQn1n/LMQpc3jpIc+n5u/MgCqKMnAMQhSrgsbAgaLJIv9yxzEkXR/9Cv9JOm2f8AkVfuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9WkdGSJkz6Uu7811wo9icaBgJ2WqXde+le4ICSOrNg=;
 b=s933QQw8oSfRz4DQ6dhM7btYLIjcMuke4K4qRflnm//hfkpVZPopkpJbGB1YaY4SsLD9fJJCuM9R4krmpkmJ3AD7y7zrHFXEOZi3905XAxmYzhwotNWmEb4O99rhvjs15uVAkCBMP4vimxgEc8x3V0H1+YOK5188wfvbjAI4pow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Tue, 10 Dec 2024 06:38:41 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 06:38:41 +0000
Message-ID: <cc2ab6ca-3c65-4171-9401-d480fd65f932@amd.com>
Date: Tue, 10 Dec 2024 12:08:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
 <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
 <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
 <f0b27aab-2adb-444c-97d3-07e69c4c48a7@amd.com>
 <20241209153814.GEZ1cO5uw_lp0fg8Bg@fat_crate.local>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241209153814.GEZ1cO5uw_lp0fg8Bg@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a4c537-0d91-4582-4e87-08dd18e54957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1BFbnE0T0NieTN0eWREUFAxaFJOMjJnMUdDRUFyUnN2allRZFpIU1YzMCt0?=
 =?utf-8?B?UGZNS2ZocWh1T1I2dlBCQURkdzJFS0FXc1hjVEVpaDJoaWREdC9YU2lqaWdL?=
 =?utf-8?B?WFRqcHRUeVdoRVdSeCtVZlZpTjFHZmxwSUVBRW5UTjMxWUxGbjhPWnpHYUY2?=
 =?utf-8?B?T0ZadUk2U1JVODJUd2dMV2F4RllHV1pHWjd2QnJleE9IUVJuc3FZZWNEbWxl?=
 =?utf-8?B?cXJUUXhCMmhIQ1BYQnVMdFIxeTJJS3NQbjBzd2ZMa2s0Kzd3a2pJWVcrMkZq?=
 =?utf-8?B?RW5FL3k2VmVTYnhvTW5hUXRVZUp1emhONDQ4RnBGR0JrdndHcVJGamI4ODlj?=
 =?utf-8?B?MWFxaXJGVEtPSkROZEpKWHFMZmt5eVhjQ1F0TklrSnc0b3BPd00wUVY4K1lZ?=
 =?utf-8?B?c3dMdmVWL2FGL1NVM05nQU9BREY2QTJzSlg4a2RyL1R6di9zejcwQzBSbnJO?=
 =?utf-8?B?a285Q0JNdWs3RFdBOGk3TnJEbTlEamQwWDBLUFlBRm9tbG9Db05xdjl2RTNl?=
 =?utf-8?B?TldOaDQ0eGRnbjZ2V2Jjc2JyZVBJdFM3UGc0emVHLzhxTEZnVHF6Q09lL0Zt?=
 =?utf-8?B?d0VxR1piTkRNUVNLZnk5Q1F3L0VtZE1kRUhkaHhUblh6NXdDQjNwWFA2SW1L?=
 =?utf-8?B?N1BTMVNlUGJBend1WW1Yb2gwTVVUT3ZKOHFZVUVkZnhLU2tsbTFlenF3dFBU?=
 =?utf-8?B?eE1LcGcyd1JmUW9iS2ZIK2lwR29PZElYNksxZU1oWGRGY1lBYUU2aGgxV2pm?=
 =?utf-8?B?WHA4a0JhY1NJZGNNTi9tQ1pacmZRL2VTcjdjMVBmQzg4dUYzR3Q0M3BFTDZJ?=
 =?utf-8?B?M3NhT1lQMTg5YXRUU25oVDFyZWQxRWxVM2M1TzdKeTF0M3Jnd3JkUHp6TEZ3?=
 =?utf-8?B?RHpTT1RWeFlqV1o5eGVXKzV3WUQvLzVJWUpwbzVYRWVBK3NyYzZ6Q0JpN2p1?=
 =?utf-8?B?OUc2aGorYXl1Smd0RUhpNDlzQktzVjAyRHZ4SWpJeXZLazh1VGZMaG1mcW1V?=
 =?utf-8?B?SktwVmlCaGk4T09vQzhveFhvcDFseWJ5WC8yM3F4MHk2UmMxSExSR0NRTDhr?=
 =?utf-8?B?Q0UzTFZZYkFMcS9xNzhlTUVJQjJMSWsyQS83YzlOMTdjQms1cC9CZ0tHYVpI?=
 =?utf-8?B?cE1GcWNQNUd3MEhvTFhHZVMwWDc3MjhCYzBpR1ltekE2emwxVjdpUE93QlM0?=
 =?utf-8?B?NmV0QmxlbkNHUi9wWXk4Z3RXcnF3VjVyTTAvVzNlZkI5a3E1LzVQVDZLOG9x?=
 =?utf-8?B?U0VhVkEvQStTU2VXYXYxN0lRcmJtVlZaMldrVU9CTjNRMXhXRVUrK3Bjc01R?=
 =?utf-8?B?T3EzVy8xMlpxaTNmSmpUSWE4WUhzYmRqdit2d3d4bEpBTUEvYlVzelVySm1W?=
 =?utf-8?B?V1NKT3V0M002b2xTUFM1T25XS1lKeElITXpENGk3K204dHAzYmpNQ2IyV0Rj?=
 =?utf-8?B?MWlVUmJKMkNzNGxnYWxpMXpDZlBPZHF5N3FkcWx5UEVhTjJhZkR2cWc2YkV1?=
 =?utf-8?B?Y292S3RaYlRmbjNITkRJWGhMZjNRZFFsRU5LYXFwY0hFNlI2clQwVzdZMzFI?=
 =?utf-8?B?T0JWMWc1WkthaGZEY1pyd0VMSW5MeUxXK2Y4SlRBY2xYdmhSd2ljMEdXTm5v?=
 =?utf-8?B?OHdNZkFGSDBoanBybjBWR0cvS25sQzVyRHVTbTdqamhHZG1JR2lMTDJkY3di?=
 =?utf-8?B?K3dKVzJuWVFscGtQZFVKcG1GeC9KbDdrMzJsL3BtR1QrLzVoY1dWMU9KZkI1?=
 =?utf-8?B?NHhoMldwWlprR01DSlZIVkJmcTZzSEdPV1N5OTVwNjQydWN2bFZQSzdVZzRZ?=
 =?utf-8?B?N2NZSjZ5ZWUwa2NCWkhLQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmhHaHJDRkVycU9GK2lFSkF5bFVRQUxEOWpPTzY5Uzg0NHZlL0grNEJsZlVF?=
 =?utf-8?B?eVJKeHJTSk9WendoaE5rYXU2Z0FxUUhnaFZqZjBwR3pJUTVvMk8zU09iYno4?=
 =?utf-8?B?R05uci9hK0VMUHk3d29rM0o4THcvVVpNbldSRHNiUk5tSmg0SWVKQ1Axa2VM?=
 =?utf-8?B?Wm1DOElRZFBycS9MRWpGUUZQWFJuSXl0TzlkWWhub01Lb2xTcW8xSmcycU84?=
 =?utf-8?B?M1k1U2ljUzdRVmlpSU1UdTUwbmRtcmVwNkdocG52amp2cTlncEM5RldOK0dx?=
 =?utf-8?B?RVo1eXNwamJjTDdQOWRHcGFoSjFJTkZQS1JuNm96KzAwV0dmVGFDMjRXTnBD?=
 =?utf-8?B?YWkxdndVNmJlN0pJTVV0RUtSNllhcW1UY0ZWOTU5djdNMVpZZUhGZlRXenk4?=
 =?utf-8?B?NWVNL1AraTdic1FaemxmSDhDTVNnaHowTlFRcEtwUXpidE1qUUtXQVNuaDNq?=
 =?utf-8?B?Y3NUVEh0ZlhlMTZBMWw3Tk41czZMRmprNUVoSmxFVTluNSswTUJxOVQ0eFdn?=
 =?utf-8?B?OGRhZ2V3SnloZWlzRHIvUTNQeFA0ZVRETEx5VGlYVUhFZW92ZVNSNVJ3Q09U?=
 =?utf-8?B?ZExZdzVoSDBKRENiT3JzV1lNamF2TEVHYUhZRG41RnpqbnlXb1FkYVRDTDdq?=
 =?utf-8?B?ZHQ4YzUzdGF5VHkzZ1JreGphakZCZGVvYnNUUE9sSmZiaStsM2tLRVVEYXdh?=
 =?utf-8?B?dmxBZ0RDVHIzZnYzemRBUjQrRHB0OFUwODJzT2tMOTRRakJIYm1FbDJ6eVZW?=
 =?utf-8?B?NTY2blpQWG1kMnF1NDgwWUh5THkzUDJjeGRTUmxWNW5Ca2NHamgrWjQ5L3Fm?=
 =?utf-8?B?QzRTMEJldHZDREhWM3BVOVlTbSt6V2VPRFhLYUhaQzF6N2tRT0VNVWVvWkRW?=
 =?utf-8?B?QVhlK0Z4UzltckJiczhwY0g5b0N4bE5xc0VLbjVGZXAvWTJtVDlWbHhUdXMv?=
 =?utf-8?B?dUtSQ3R0aGhPbGQ1N041alVIMXpJTzlRYktTZFpCY3RuOGwzL1lxL1pYeTEv?=
 =?utf-8?B?eVRKWWtmMmxFTWFUS2VTODhvUUtQNUVTdUNVdFpBNG0rWWFScHp4V2R3VkZ6?=
 =?utf-8?B?NTAwaHYxNSsvcmQyTEgxZWxrVVdCR1VmTEhTdWZjaXoyWHFTMTlCVjFBUThC?=
 =?utf-8?B?WTFmU2NEcHZpSnpENWpOYXl2RkpmZWYxdHR4bVhiMUVIREc2Z3lQTk1WQU5m?=
 =?utf-8?B?U3BQRXpHZzJZMWFEU3IwL1BqSHVkQ1pEV1lKQUtCWE5rek01MkFxenJpeCtm?=
 =?utf-8?B?cUNqWVdWcW5oYXp1RlhpSmJtY0lUZnJxY3lXazAyMnhzSzdVT0RsODErbUMv?=
 =?utf-8?B?M1NrcXc2N3htQmFFRFphMnRaNG9yblNUbVFyYWhhSHcrYjBGcGhETXRPT0pz?=
 =?utf-8?B?RHJsN25sdU9iOHZFZE03TS95Q3BMNmFiam8rZjBJN1lFalNqelpjUkQzWmJ2?=
 =?utf-8?B?YWRrVkYrd2YxUmlJMGpPZFlTNFhYYVlHdHZiTFhlQWJZYVl4NWUxaFY5NkFm?=
 =?utf-8?B?SFQ3RzZFa3pzYzkrREJVRTBmRmdkYXAydDVVTmpYZ0o3UlBKN1d0RzJiOTJV?=
 =?utf-8?B?cUtHOW43eE9PTG52K1VKNnZaK2RkUWlJV1ZIR0x5VGpIRzUyZHlYVEpsdjI1?=
 =?utf-8?B?cHgvT0V4aWlmWjFrZjBROFJvdVErK2x0V0tlbjNmSUt1VEthUGkyb29mZDZr?=
 =?utf-8?B?YTJ5cUxkNlFidXVFUkxoYmZsNVpyb01PMGJaU0pUZnFHWnpIWnhkWjlsODNa?=
 =?utf-8?B?cVNGWmJxcU4wYU5EN0xZQVdkNkl4aDBSV09tckRKN1NuQTB5TlowY2dGTStJ?=
 =?utf-8?B?K3J1eTA0WERLV0NZWVU5d090NzM5SG9hVWkrQTg3SFlNZDhGQlNiOUNWRzVl?=
 =?utf-8?B?Yno2SFFJYnl1cS85VXE3b01yTGpOK1hGU2F1cXNaSE5lVGppbGI2dFNHUlhN?=
 =?utf-8?B?WFdJZnVKcTFXMjh0bTFQNGF4cmkwS3BWNTV5V0tTMEU2WXBLTStsQ0ZuMGIy?=
 =?utf-8?B?NHZPeUVnMEtXYzVTTXRGbUxCRlRaUmhNS2d1UEx3Wnk5WnNEZ01hejhRYmds?=
 =?utf-8?B?ZTZWNlJKcG4vcTBSOWdNWlZtWUZIRGZrWlVacTYyYjhLZzArTUZVSXErNEJV?=
 =?utf-8?Q?S4uiAFhmJ67gLreGxwQk5Si2H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a4c537-0d91-4582-4e87-08dd18e54957
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 06:38:41.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +S2kt0sxakhWGbBXkl8fjNkd0RrXS/W6OIqGnGelnJxiihDd01fQPydRJgyZSNTdPu4ZAcrHOSZDtoX6zMKbpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635

On 12/9/2024 9:08 PM, Borislav Petkov wrote:
> On Mon, Dec 09, 2024 at 11:46:44AM +0530, Nikunj A. Dadhania wrote:
>> That leaves us with only one site: snp_init_crypto(), should I fold this
>> change in current patch ?
> 
> Nah, a pre-patch pls.
> 
> Along with an explanation summing up our discussion in the commit message.
> This patch is already doing enough.

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Thu, 5 Dec 2024 12:00:56 +0530
Subject: [PATCH] virt: sev-guest: Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL

Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL in the sev-guest driver code.
GFP_KERNEL_ACCOUNT is typically used for accounting untrusted userspace
allocations. After auditing the sev-guest code, the following changes are
necessary:

  * snp_init_crypto(): Use GFP_KERNEL as this is a trusted device probe
    path.

Retain GFP_KERNEL_ACCOUNT in the following cases for robustness and
specific path requirements:

  * alloc_shared_pages(): Although all allocations are limited, retain
    GFP_KERNEL_ACCOUNT for future robustness.

  * get_report() and get_ext_report(): These functions are on the unlocked
    ioctl path and should continue using GFP_KERNEL_ACCOUNT.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c
b/drivers/virt/coco/sev-guest/sev-guest.c
index 62328d0b2cb6..250ce92d816b 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -141,7 +141,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t
keylen)
 {
 	struct aesgcm_ctx *ctx;

-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return NULL;

-- 
2.34.1


