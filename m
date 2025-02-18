Return-Path: <kvm+bounces-38408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FB9A396D1
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39BAC188344A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED67922F3AB;
	Tue, 18 Feb 2025 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VHXYu4Ls"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92122DF91
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870377; cv=fail; b=u2FosFtzmHXLdfFhalwjpjCm2c/33fr2pmpbaut/LqgYNYeDWArdU1ak1DIp31UcIdmNBPnEq4wT8J77cDcQMHfWWyOSIXPzlhftRuamIg47AchAhn9K2f7ah006dMaWGcUETC3rl+qG4K8IE6R2RtRiNqA0r547M7J2Sq0kvRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870377; c=relaxed/simple;
	bh=yMztp/upBYNXRXSpWiMLP4YYINncyq02wVZ1oy6PHJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aILPt2UXbmHXppI6P1EUIjI/huB0gweIxW/Pce89rh/5a2/t2Yqy+m3QUaDxl+sy5kBncXS/gvIRdMZsgm18mCNy3aL2Z5v/KHTdZZFow5/kU91BLI6mnmvf0+g+m/xdSRdc39vviuJH/8kIl14n64HHx7VuVN69pvtSjMFgGiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VHXYu4Ls; arc=fail smtp.client-ip=40.107.96.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ejx8WleFOV9InBjKPDxzIqUr0uD9qxhX8OUBdnkJp7CHVHIMolxKFE7rdSfbewAP1UvdYKM6x/YyBPsn18ZmqqasI7nQtIvn8IHf7nM3o7FCkfftBO3aHuYOVpsdngGlx9kafjTuSxGyWnwKgNqFsyMtk+kDm5SpgYewGqwCNdL9Mna4W2k7CZco2vnahX7JgzxTtS+Bm0635ztM8EBgyLsyVKXQE4S+nOa76wi4loxru+hhT47k0QFYnzczvf48JT1pHYZMPFXy52NoY6XPGn14hoP2HLuqy3YHHjjKMvhA6FG4j3KNp3gPi7mi5Xj7cxzwQTvwrrSLwz33dOSoYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWRlxQFkA8iOu5MDN7WpjqZ+piDVI5ghNrfY8L3BlyQ=;
 b=nomK/VKSNWhrR6UY8CRgXqn+2dTmCc6K5Ca6JMzb132dSRMBeM8ocM2zkhOMBeVY1iKxTCaqZ7qkP6s3TwmFRBeRfZJSe+uwdl0U+SQ8uMM9ArbSDn3IEYR777rtnXUxba5j7tlqGUsfcAnwfoxoC+G6fnN5BbV41PoY3h04uskKlkIHIkKoGeyOAYh46+ogWecwA3OqmCqAJG6cnKaIdYckdmh6bjhunsqDanLEs4rQyFlhguD0D3hcd+DhLRHw4cGgJASGldZclYwhkme2was2w82UBOl5LYdh6OGdp5FZGR/fB95b5gZA4Q7/f+uyzTFXmiYXI42Z8jjWKjWm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWRlxQFkA8iOu5MDN7WpjqZ+piDVI5ghNrfY8L3BlyQ=;
 b=VHXYu4LsUvLnQ7EZRwA3McrB/50g+TJgOBZorswUBUg/ynATZCfjp6mRMZ+JFfymWoBoagwT7pa52DfZEHOX1Ej8HsPUFdsJPQucQpiyFeofMgS+AyfLfacBk0bkwxkuwlgWakxXcvfNGs6yvW5eskCBy9PG7muo0TYxDZMe0q0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Tue, 18 Feb
 2025 09:19:33 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Tue, 18 Feb 2025
 09:19:33 +0000
Message-ID: <9a8fe1a7-528d-466a-a72d-89ceb88f47fb@amd.com>
Date: Tue, 18 Feb 2025 20:19:29 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 4/6] memory-attribute-manager: Introduce a callback to
 notify the shared/private state change
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-5-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250217081833.21568-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0034.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20b::24) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a2032b2-8bb8-49be-2cfc-08dd4ffd5ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjdUOFZ6bE5pZ1JXbmJWL0s4UGxjNEdyU0J0ckErSVlUczdwaWc0TGZXWXFL?=
 =?utf-8?B?ZFF1bUhqenVVRk9rdjVNMFNuQnh0WVJBZjhIZzZCdXd3YWRkMmxDVHl3TGhN?=
 =?utf-8?B?U2lWaHcxSkNJZHVyYnRHR1NDTXJ3amdjYitLeWV6WFovRGdEanQyYlJSRzVQ?=
 =?utf-8?B?ZlVmRk8xZ3g5TkpFZGwrbFYwN2s1VGg3cHZrMUxtMlhFb3R4eHRzdG5MNXBo?=
 =?utf-8?B?WDRna1ZhNGdORUV0RDZ0MmEzSUZnVjJSVXQvZTNTczkyOFN2aStYZGtZblhP?=
 =?utf-8?B?SUR1ayt6WUpRWStqN1lmeHZRMjN4WUZEMGUvWHpIZjVoNFR2ZFB4OStOU09K?=
 =?utf-8?B?NHdnbGkvb3gzTXZFY2RmSmdDbCtZbnlFNWhJY05LODhmK0tuTnFXbUNQRElP?=
 =?utf-8?B?RGJydTZNdFFMWnByUGcvWnRlM1JaWmVjL085eER5S2pnQTNyUmFWczl3S1Fy?=
 =?utf-8?B?SWlYczdlL3U1Q0lWS0FnNTJDZDZtUU9XVGVHK3ZsOENxQ2tSZ3RXQXZpQlBy?=
 =?utf-8?B?S1N3YXdRYTJza3A2NlhJNVZWeXJaejExOC82YUZrOXMyWjYzZXJVQ3hBdXJj?=
 =?utf-8?B?N0laSzQ0QmpveWxNaEozRGI1S3B3UHVVdjRRS2ZVMGJOZmVvT1NzN0NxOUhD?=
 =?utf-8?B?Kzh1T3VqcG5NSXUxUHRsdWtveVRNUWVkNHBwN1dFNFR1NVV6Mzg1Z21SRHMw?=
 =?utf-8?B?RXdPb1dqdVkxV1k3N1ByQ3RHT1BPa3lOa0lLN2d2WXA2eVlSVlcvdTdoSjl6?=
 =?utf-8?B?M0N3RlFXVENLU0NGUG5HM0lDbWFKbDRrWlRaQytZSTFEem5QZ2VNMnA3WjJ1?=
 =?utf-8?B?cXhHU25aYUJWYnNsRDNydVJxbXBSTUwvQVpvY0JyZ2NNVFJTWml2REwyQmNt?=
 =?utf-8?B?STMvajVzNVR3bzJuVEpLQzY5cUpCMkcyMXhob212TjZkcEtqV2k2aWhNakxJ?=
 =?utf-8?B?TzFiRkM0a0pDcnhZbEh2QlNxZXA3d055Q3VPT0tHOUFTOTFUVS8wd2Y2RWll?=
 =?utf-8?B?ODdvaE0xTW1oeFRFdTNqZkNEaWtYd0xBVVZKRnlBdnlLeFVMUEIrSHlxVTVM?=
 =?utf-8?B?NnVsUXA4TUZnOFZSQjVYd0dYcGpBY0oxMk13TmJUSGpLMUFvWGxvREt1WHVR?=
 =?utf-8?B?aFpoaVNCbkdCc29WNVhqcENCUEFYdmZxMFROSjlSQkFKRlhlckhocHBOQ1hz?=
 =?utf-8?B?TUdORHBMY3haeWdjdXR6K1RxSmtoTzl6RUtYTHNUdTBTVXFXL2lHeTEvSFJK?=
 =?utf-8?B?RnpCbE9iaHcwa2UyUFAyWU45bE5OS09nN3JseFBTTDVmUVI3RzhCWi9IcFpj?=
 =?utf-8?B?K084T0poeStTT3lrbFQ3bjRwdzRhamNRTG1hT0pjcWJXS29QcWxnMTNYNFZj?=
 =?utf-8?B?bW9QaGJFelhpem1oMlpIT0JpODVjRnBneWM0akVUVml3TjBMME44eHVrWjly?=
 =?utf-8?B?b1JqOXMwbVdjTEpJd2RMNm1kRFhXQVhSUk5aZTFrcXBtUk5PWE5vWDh4cGx1?=
 =?utf-8?B?RjJqTnF3OFpxbTR1dUZtKzU1QytOb1BGRnBkL2x0MWQzSmlVL0dGYzdzK21r?=
 =?utf-8?B?UnZzdE5LRW9qTW1zQkpxMEMvOEs4eG10S0dmeitYdTIrenBmK256RTdzSDF1?=
 =?utf-8?B?MDdlQ1ZHL0hGMUQvdThOcjUwZkNSUndlTEZhT1hvbGVQaTlmSDFyRElGbHIv?=
 =?utf-8?B?bjQyKzZ5Y3FteUsvYjltSjVBcWg2QmFJVjB1Mm5TWjd2L3hIS0ZUNDZBRDZi?=
 =?utf-8?B?UEdFa2JDQTFMaUhCR3dXcEF4cDdtT1RGM3BjbHFxNW1ZQ2YxbUszSVVVTElm?=
 =?utf-8?B?eWNrVEZVeUg4eUw0NTZNalduUWpHMkgxQ3FMbDRnRWdpNm5hREw2UlJOSGxR?=
 =?utf-8?Q?QGfO9azC9D3+U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TjBtck5ZeUZhWXppY25meTdibkJGNnZVc1cyVUJpMko0OEJPM2RubXdrSnUr?=
 =?utf-8?B?QllQdzJ5UUhNNjZyeXFkUWFjWXBKQkxiM2tMNXBPc2ZGOTFIUFZoWEtEaC9F?=
 =?utf-8?B?eUlrQTgrVU5DeGlaRFNkVTZObDBscFZKUXZLWGxySjV4OEt3VTdJY1BJRHF1?=
 =?utf-8?B?U3BDeisvS2puS0J3LzR6bE9mSWlKM0NJVzV5a1dJMUllNWlrdzRIYVpkM2ta?=
 =?utf-8?B?T0JZeHZKNVJzcWYvNDljNnFWTnNwMEdoWUtRdjZxdWlDeUVVNENBdzBFVnV2?=
 =?utf-8?B?MFNNU29pT1ZkUWMxL3c4bkZIZW5TN3M3V1E1K2NZdVl4akVTMXFibDFiVmN0?=
 =?utf-8?B?S1U5QW1pd3R3aWEwQ1ZYS2NPNVJZeGxHY2ZDTityKzBpdFB3R2pmMnVGUEta?=
 =?utf-8?B?NU91TlRDRStWVk9uNVRSZllTS1Z6YUtvRGhYUUpCbFpXZ0dNQ1o0cG8xZHQw?=
 =?utf-8?B?WlkwV1RjRkFkN21lU3NPcDJWZnd5UEg4T0xkdWNNZU1NTzZYYkRmTW42b0xJ?=
 =?utf-8?B?RmwxOTBQczZYbkZDNGpNRkZMOHVISUFBNjhHS1ZQUGVkbmh2dXBkeE1waFRp?=
 =?utf-8?B?ejYwSUJoRTdDck9LTzdxdzhRYlY5MEl1aExmZGtSTFBFbVBJQk1XQ0cvcHZn?=
 =?utf-8?B?YkZaNmhQZDJFTHJnWk4rQVdPL1dPNDNzWUJaam9ENWVoTnpRRVkxMVU2bmZw?=
 =?utf-8?B?QUk2MlpQdS9qOXgrU2crNzdGdmdIbFRMMDcrL0QyaFpKdDRiUGNONEUvbmlR?=
 =?utf-8?B?QnZmV2JNSFlNRHhJS3A4V0VEczZBa0t4WHZXWXRBa2k2ajg4dEpKb3FxWm1R?=
 =?utf-8?B?cjFZaDNCKy8wQllaaWVySXJQam1kUU5yaHlEQVdWRlVDcHZJOEJpWDdnRCtO?=
 =?utf-8?B?dWVVcndYMVN6bUZSeU1CTFdZdEZ4SHExMzZFaEVtU0hsQmVUSEI5dXd1S05V?=
 =?utf-8?B?blVWczIzYkxnYTJEVFA2SDBDZ0llYVJnWlh3Z2IwYjVZMEdCTy81MWI0U3lR?=
 =?utf-8?B?c01Wd29WUEtBc3ZhR3d5V25IU2c4Y29TaERLTTY1a1BLaElRRE91MklVM0do?=
 =?utf-8?B?OXcyRHYrOTI2bzc3WVFseFY4NUZGZGY0Q1oyNC8rSGNGalpreGRlUzYrSmNN?=
 =?utf-8?B?LzYwOGhubFlvS2VtWk1TVDRWclE1NFQrb2Z0MGVSOHBqNU5DZ2tNVmtoRjdl?=
 =?utf-8?B?UjBjTUM1K1JCcGVYd0tTanJUNEduUHRWSFg1QVJjV2F3bkRqTlNaYjhUZHZK?=
 =?utf-8?B?SUU3YlFFTHdudFlRelR3MVZ3TTQ5SkVkeDVVN0Z0c0ZkYmlpY0w5WUlHVC9M?=
 =?utf-8?B?cDN5a1NLSXdJYVJiaVlKR3lYRXoxZWx1OVEvaU4zeldoRFRGME11QzB0NDE4?=
 =?utf-8?B?bE4rTHp6aXZjZzFzWnpHbzNKYlMyNWFQTDhGLzRlL01OK08yR2x3UE4xWW44?=
 =?utf-8?B?d1lJQXBGWHc1SDZuR1htNDI2QzNwRDRxT1NwNFdXRGc5V1l3M2YvaFBNMlRQ?=
 =?utf-8?B?Qi91R2dqYWpjZkYrQ3lubWZQSEdEOE9Qb1VWeGsybm40VFB0eWVaNjN5Sk1H?=
 =?utf-8?B?cDRDczM2MHlweE1XVmtGWFQ1VVZ4QlZjYUZVYXFJOEZrYXVyK2JOOUdyYzFr?=
 =?utf-8?B?QTZ0Z3libGp2S21KZ3J2RXlDN21Db2NoVi9MbFRvQTNLcElEenlVQTVUbm9H?=
 =?utf-8?B?dWNUZWl5cWtPZUN0cDkycDhXQnljZHdEdGtuTVVMeGdhSzBqM0Vadjl1TkFN?=
 =?utf-8?B?UDlHdWxsQVVid1RCbVdZVEZsVngxcXN2WUNxRkVpZFpPNWY3bFVudlNya05L?=
 =?utf-8?B?eWNqRU1NeGdQOHJWdjY5dWE1RklxbmV0N0RRK0V6QXErWUhaV3N0QVI0Wkdq?=
 =?utf-8?B?TVl6YzQybzZEYm9SVmZnRzF5eFQ1RkNXbUFTU2NFRnpDN2UwOHgvTi9rd21N?=
 =?utf-8?B?RmdHSm9MR2pXSGpiNDNhOXVodzY1YU9qTk80LzZpMUJQWUw1RDRnS0xKQll4?=
 =?utf-8?B?VWMvVXdLeXFpNmlTd2ZmaVFpcUxJZmhJNm1PazJXWk1qRG0wSE1mdTczNXFp?=
 =?utf-8?B?MEZEbU1SRHdJMFduOVJhV3BWdzlnbEdlTEs2NUVvdlJvd0VTY0xDOG5HT1hh?=
 =?utf-8?Q?47UzwKjxYkiTmIKdx6WGzBvqq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2032b2-8bb8-49be-2cfc-08dd4ffd5ad5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:19:32.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94r5yasCFpxyvpkwV2gveO+1zQOiApH7nGZkyIa8hDa+5LoEwD6czP/0RTo5P2KeIdLKHYtplhaUAM+oMUq4VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115



On 17/2/25 19:18, Chenyi Qiang wrote:
> Introduce a new state_change() callback in MemoryAttributeManagerClass to
> efficiently notify all registered RamDiscardListeners, including VFIO
> listeners about the memory conversion events in guest_memfd. The
> existing VFIO listener can dynamically DMA map/unmap the shared pages
> based on conversion types:
> - For conversions from shared to private, the VFIO system ensures the
>    discarding of shared mapping from the IOMMU.
> - For conversions from private to shared, it triggers the population of
>    the shared mapping into the IOMMU.
> 
> Additionally, there could be some special conversion requests:
> - When a conversion request is made for a page already in the desired
>    state, the helper simply returns success.
> - For requests involving a range partially in the desired state, only
>    the necessary segments are converted, ensuring the entire range
>    complies with the request efficiently.
> - In scenarios where a conversion request is declined by other systems,
>    such as a failure from VFIO during notify_populate(), the helper will
>    roll back the request, maintaining consistency.
> 
> Opportunistically introduce a helper to trigger the state_change()
> callback of the class.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v2:
>      - Do the alignment changes due to the rename to MemoryAttributeManager
>      - Move the state_change() helper definition in this patch.
> ---
>   include/system/memory-attribute-manager.h |  20 +++
>   system/memory-attribute-manager.c         | 148 ++++++++++++++++++++++
>   2 files changed, 168 insertions(+)
> 
> diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
> index 72adc0028e..c3dab4e47b 100644
> --- a/include/system/memory-attribute-manager.h
> +++ b/include/system/memory-attribute-manager.h
> @@ -34,8 +34,28 @@ struct MemoryAttributeManager {
>   
>   struct MemoryAttributeManagerClass {
>       ObjectClass parent_class;
> +
> +    int (*state_change)(MemoryAttributeManager *mgr, uint64_t offset, uint64_t size,
> +                        bool shared_to_private);
>   };
>   
> +static inline int memory_attribute_manager_state_change(MemoryAttributeManager *mgr, uint64_t offset,
> +                                                        uint64_t size, bool shared_to_private)
> +{
> +    MemoryAttributeManagerClass *klass;
> +
> +    if (mgr == NULL) {
> +        return 0;
> +    }
> +
> +    klass = MEMORY_ATTRIBUTE_MANAGER_GET_CLASS(mgr);
> +    if (klass->state_change) {
> +        return klass->state_change(mgr, offset, size, shared_to_private);
> +    }
> +
> +    return 0;


nit: MemoryAttributeManagerClass without this only callback defined 
should produce some error imho. Or assert.

> +}
> +
>   int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
>   void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>   
> diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
> index ed97e43dd0..17c70cf677 100644
> --- a/system/memory-attribute-manager.c
> +++ b/system/memory-attribute-manager.c
> @@ -241,6 +241,151 @@ static void memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
>                                                   memory_attribute_rdm_replay_discarded_cb);
>   }
>   
> +static bool memory_attribute_is_valid_range(MemoryAttributeManager *mgr,
> +                                            uint64_t offset, uint64_t size)
> +{
> +    MemoryRegion *mr = mgr->mr;
> +
> +    g_assert(mr);
> +
> +    uint64_t region_size = memory_region_size(mr);
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +
> +    if (!QEMU_IS_ALIGNED(offset, block_size)) {
> +        return false;
> +    }
> +    if (offset + size < offset || !size) {
> +        return false;
> +    }
> +    if (offset >= region_size || offset + size > region_size) {
> +        return false;
> +    }
> +    return true;
> +}
> +
> +static void memory_attribute_notify_discard(MemoryAttributeManager *mgr,
> +                                            uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +
> +    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +
> +        memory_attribute_for_each_populated_section(mgr, &tmp, rdl,
> +                                                    memory_attribute_notify_discard_cb);
> +    }
> +}
> +
> +static int memory_attribute_notify_populate(MemoryAttributeManager *mgr,
> +                                            uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl, *rdl2;
> +    int ret = 0;
> +
> +    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +
> +        ret = memory_attribute_for_each_discarded_section(mgr, &tmp, rdl,
> +                                                          memory_attribute_notify_populate_cb);
> +        if (ret) {
> +            break;
> +        }
> +    }
> +
> +    if (ret) {
> +        /* Notify all already-notified listeners. */
> +        QLIST_FOREACH(rdl2, &mgr->rdl_list, next) {
> +            MemoryRegionSection tmp = *rdl2->section;
> +
> +            if (rdl2 == rdl) {
> +                break;
> +            }
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +                continue;
> +            }
> +
> +            memory_attribute_for_each_discarded_section(mgr, &tmp, rdl2,
> +                                                        memory_attribute_notify_discard_cb);
> +        }
> +    }
> +    return ret;
> +}
> +
> +static bool memory_attribute_is_range_populated(MemoryAttributeManager *mgr,
> +                                                uint64_t offset, uint64_t size)
> +{
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    /* We fake a shorter bitmap to avoid searching too far. */
> +    found_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +static bool memory_attribute_is_range_discarded(MemoryAttributeManager *mgr,
> +                                                uint64_t offset, uint64_t size)
> +{
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    /* We fake a shorter bitmap to avoid searching too far. */

Weird comment imho, why is it a "fake"? You check if all pages within 
[offset, offset+size) are discarded. You do not want to search beyond 
the end of this range anyway, right?

> +    found_bit = find_next_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +static int memory_attribute_state_change(MemoryAttributeManager *mgr, uint64_t offset,
> +                                         uint64_t size, bool shared_to_private)

Elsewhere it is just "to_private".

> +{
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret = 0;
> +
> +    if (!memory_attribute_is_valid_range(mgr, offset, size)) {
> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
> +                     __func__, offset, size);
> +        return -1;
> +    }
> +
> +    if ((shared_to_private && memory_attribute_is_range_discarded(mgr, offset, size)) ||
> +        (!shared_to_private && memory_attribute_is_range_populated(mgr, offset, size))) {
> +        return 0;
> +    }
> +
> +    if (shared_to_private) {
> +        memory_attribute_notify_discard(mgr, offset, size);
> +    } else {
> +        ret = memory_attribute_notify_populate(mgr, offset, size);
> +    }
> +
> +    if (!ret) {
> +        unsigned long first_bit = offset / block_size;
> +        unsigned long nbits = size / block_size;
> +
> +        g_assert((first_bit + nbits) <= mgr->bitmap_size);
> +
> +        if (shared_to_private) {
> +            bitmap_clear(mgr->shared_bitmap, first_bit, nbits);
> +        } else {
> +            bitmap_set(mgr->shared_bitmap, first_bit, nbits);
> +        }
> +
> +        return 0;

Do not need this return. Thanks,

> +    }
> +
> +    return ret;
> +}
> +
>   int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
>   {
>       uint64_t bitmap_size;
> @@ -281,8 +426,11 @@ static void memory_attribute_manager_finalize(Object *obj)
>   
>   static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
>   {
> +    MemoryAttributeManagerClass *mamc = MEMORY_ATTRIBUTE_MANAGER_CLASS(oc);
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>   
> +    mamc->state_change = memory_attribute_state_change;
> +
>       rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
>       rdmc->register_listener = memory_attribute_rdm_register_listener;
>       rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;

-- 
Alexey


