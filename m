Return-Path: <kvm+bounces-58188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8BCB8B318
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94CF07E497F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED6A27B339;
	Fri, 19 Sep 2025 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ciGBZHsM"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B3C21C194
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313839; cv=fail; b=Sv13k62/SR5xeZpEhiLeTGOOm9evp4E+Sa80A7HJlJtLN1MEVrt+6yu9WfMX4SJFqsKTfQcgnf1gT12Ei2AZl5wSNqFbqDSS+dvx+oWIlcTyua58tpbYoL3fJrwFA5C5WEdCnWNjcW8GEtzsNpUqNwtT41SGzVsucccuxCBroRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313839; c=relaxed/simple;
	bh=EuInNisxTJb/1pK2Lc8vW0b2ABac9RV6KT9fHdnItEo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j0bSoAH9r64ivF1Tdj7uA4lJJae5CCtwo8Zi15OEBne13dG/GQ5Cz+Xo5tRJAhyQ1p4o2Hhd6Ycbvzk8G26gjs25V3KMD1+D7uspgmQu8mhnOvf5z2BQsMjpuxCYSh3RjqhKH1gKiiGHIE3heN7itTntmEjrN59bx1VUprqsww8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ciGBZHsM; arc=fail smtp.client-ip=40.93.194.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZV8Gwgnxr1UpcbMwtL+3mF1KOEfJlJAfPb0ILnbIsyNgOTyS8TTznMlMR2gtpZxzCDJwAmpr5MF93QetZqag9mfUMS8lLCoB22BV7qCmQJPWcMk4U2Q+u3gn9vveJWv6JrHt8NtUYVqzAlqCQdMjorTs864hr6D2QLR7koxnPI2VO1e86zpGn8CmnlpWu1Ex9TRe/Bloi0b5asV98oGCHqO3cj/t/ePo5D3+Gkgc1jBORWh8SbqYoGI92t3y6bem9gOx0N38KRuVDMAogEPzjqeuWpQ4Q/Lw3v18mGEOGJSSOk/pZzazVE4lUhUEfjVK9luKxV6utcbBG6yZTvxyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy57GEVhFIJ2NyIQzo8jhsy6OF5zcrwGXubNDVCAbGI=;
 b=wF8YIsR0SxrfeP6PHErukwCwXbB84Ham9AXbOnQAEb3jxvqFJ9fTQK7pWMRc4u7hKZBT3VFT9yfphYaVw7UII1VM11ZYYwNvTof8NXLibbyVrzSXDy5QcqX6NbWF70VdWEYqGVAbJthv7l8BR0MHI6Rsmrg211TYDo3gF1pBL5ZFq1nH3DUH7JP/hQHbD9pjR0877NOrPSfEW4Vabm9EUkiQny15tdmhKNhjtk15TfWALKwls7qnPA0AQ3v47Jir7iJQA5Njaw6zkOQW7NRqSkg7pllv5nrwzEkxQGKPF8WP2ljyoMot8DPLO7Y+2a9ZZ90KjvLO+Gg3J1n+Rs8qJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy57GEVhFIJ2NyIQzo8jhsy6OF5zcrwGXubNDVCAbGI=;
 b=ciGBZHsMm0aHFVT79KYsKX/qyvqL/z7TIARgXk2TQeMrsT2EleFqURJSJjZPBNn1JTD+PV/1Xiv1Sv+sp76S7GTeo32GsTJEGPfb7ymnRVQyvBYVKhvRfvt8W4QziL0HIjrA7rRN1HvqZOd5NBiaww6J7vSePN9WtPgInekdpAs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYYPR12MB8962.namprd12.prod.outlook.com (2603:10b6:930:c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 20:30:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 20:30:34 +0000
Message-ID: <fb97d1e4-a651-4a41-ad84-9143d84d9143@amd.com>
Date: Fri, 19 Sep 2025 15:30:32 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] target/i386: SEV: Generalize handling of
 SVM_SEV_FEAT_SNP_ACTIVE
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <d7473c88d4f2cfefd9249eb414a28806494c4e5e.1758189463.git.naveen@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 xsFNBFaNZYkBEADxg5OW/ajpUG7zgnUQPsMqWPjeAxtu4YH3lCUjWWcbUgc2qDGAijsLTFv1
 kEbaJdblwYs28z3chM7QkfCGMSM29JWR1fSwPH18WyAA84YtxfPD8bfb1Exwo0CRw1RLRScn
 6aJhsZJFLKyVeaPO1eequEsFQurRhLyAfgaH9iazmOVZZmxsGiNRJkQv4YnM2rZYi+4vWnxN
 1ebHf4S1puN0xzQsULhG3rUyV2uIsqBFtlxZ8/r9MwOJ2mvyTXHzHdJBViOalZAUo7VFt3Fb
 aNkR5OR65eTL0ViQiRgFfPDBgkFCSlaxZvc7qSOcrhol160bK87qn0SbYLfplwiXZY/b/+ez
 0zBtIt+uhZJ38HnOLWdda/8kuLX3qhGL5aNz1AeqcE5TW4D8v9ndYeAXFhQI7kbOhr0ruUpA
 udREH98EmVJsADuq0RBcIEkojnme4wVDoFt1EG93YOnqMuif76YGEl3iv9tYcESEeLNruDN6
 LDbE8blkR3151tdg8IkgREJ+dK+q0p9UsGfdd+H7pni6Jjcxz8mjKCx6wAuzvArA0Ciq+Scg
 hfIgoiYQegZjh2vF2lCUzWWatXJoy7IzeAB5LDl/E9vz72cVD8CwQZoEx4PCsHslVpW6A/6U
 NRAz6ShU77jkoYoI4hoGC7qZcwy84mmJqRygFnb8dOjHI1KxqQARAQABzSZUb20gTGVuZGFj
 a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPsLBmQQTAQoAQwIbIwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmWDAegFCRKq1F8ACgkQ
 3v+a5E8wTVOG3xAAlLuT7f6oj+Wud8dbYCeZhEX6OLfyXpZgvFoxDu62OLGxwVGX3j5SMk0w
 IXiJRjde3pW+Rf1QWi/rbHoaIjbjmSGXvwGw3Gikj/FWb02cqTIOxSdqf7fYJGVzl2dfsAuj
 aW1Aqt61VhuKEoHzIj8hAanlwg2PW+MpB2iQ9F8Z6UShjx1PZ1rVsDAZ6JdJiG1G/UBJGHmV
 kS1G70ZqrqhA/HZ+nHgDoUXNqtZEBc9cZA9OGNWGuP9ao9b+bkyBqnn5Nj+n4jizT0gNMwVQ
 h5ZYwW/T6MjA9cchOEWXxYlcsaBstW7H7RZCjz4vlH4HgGRRIpmgz29Ezg78ffBj2q+eBe01
 7AuNwla7igb0mk2GdwbygunAH1lGA6CTPBlvt4JMBrtretK1a4guruUL9EiFV2xt6ls7/YXP
 3/LJl9iPk8eP44RlNHudPS9sp7BiqdrzkrG1CCMBE67mf1QWaRFTUDPiIIhrazpmEtEjFLqP
 r0P7OC7mH/yWQHvBc1S8n+WoiPjM/HPKRQ4qGX1T2IKW6VJ/f+cccDTzjsrIXTUdW5OSKvCG
 6p1EFFxSHqxTuk3CQ8TSzs0ShaSZnqO1LBU7bMMB1blHy9msrzx7QCLTw6zBfP+TpPANmfVJ
 mHJcT3FRPk+9MrnvCMYmlJ95/5EIuA1nlqezimrwCdc5Y5qGBbbOwU0EVo1liQEQAL7ybY01
 hvEg6pOh2G1Q+/ZWmyii8xhQ0sPjvEXWb5MWvIh7RxD9V5Zv144EtbIABtR0Tws7xDObe7bb
 r9nlSxZPur+JDsFmtywgkd778G0nDt3i7szqzcQPOcR03U7XPDTBJXDpNwVV+L8xvx5gsr2I
 bhiBQd9iX8kap5k3I6wfBSZm1ZgWGQb2mbiuqODPzfzNdKr/MCtxWEsWOAf/ClFcyr+c/Eh2
 +gXgC5Keh2ZIb/xO+1CrTC3Sg9l9Hs5DG3CplCbVKWmaL1y7mdCiSt2b/dXE0K1nJR9ZyRGO
 lfwZw1aFPHT+Ay5p6rZGzadvu7ypBoTwp62R1o456js7CyIg81O61ojiDXLUGxZN/BEYNDC9
 n9q1PyfMrD42LtvOP6ZRtBeSPEH5G/5pIt4FVit0Y4wTrpG7mjBM06kHd6V+pflB8GRxTq5M
 7mzLFjILUl9/BJjzYBzesspbeoT/G7e5JqbiLWXFYOeg6XJ/iOCMLdd9RL46JXYJsBZnjZD8
 Rn6KVO7pqs5J9K/nJDVyCdf8JnYD5Rq6OOmgP/zDnbSUSOZWrHQWQ8v3Ef665jpoXNq+Zyob
 pfbeihuWfBhprWUk0P/m+cnR2qeE4yXYl4qCcWAkRyGRu2zgIwXAOXCHTqy9TW10LGq1+04+
 LmJHwpAABSLtr7Jgh4erWXi9mFoRABEBAAHCwXwEGAEKACYCGwwWIQTdWKXnw4wULDeIG/Xe
 /5rkTzBNUwUCZYMCBQUJEqrUfAAKCRDe/5rkTzBNU7pAD/9MUrEGaaiZkyPSs/5Ax6PNmolD
 h0+Q8Sl4Hwve42Kjky2GYXTjxW8vP9pxtk+OAN5wrbktZb3HE61TyyniPQ5V37jto8mgdslC
 zZsMMm2WIm9hvNEvTk/GW+hEvKmgUS5J6z+R5mXOeP/vX8IJNpiWsc7X1NlJghFq3A6Qas49
 CT81ua7/EujW17odx5XPXyTfpPs+/dq/3eR3tJ06DNxnQfh7FdyveWWpxb/S2IhWRTI+eGVD
 ah54YVJcD6lUdyYB/D4Byu4HVrDtvVGUS1diRUOtDP2dBJybc7sZWaIXotfkUkZDzIM2m95K
 oczeBoBdOQtoHTJsFRqOfC9x4S+zd0hXklViBNQb97ZXoHtOyrGSiUCNXTHmG+4Rs7Oo0Dh1
 UUlukWFxh5vFKSjr4uVuYk7mcx80rAheB9sz7zRWyBfTqCinTrgqG6HndNa0oTcqNI9mDjJr
 NdQdtvYxECabwtPaShqnRIE7HhQPu8Xr9adirnDw1Wruafmyxnn5W3rhJy06etmP0pzL6frN
 y46PmDPicLjX/srgemvLtHoeVRplL9ATAkmQ7yxXc6wBSwf1BYs9gAiwXbU1vMod0AXXRBym
 0qhojoaSdRP5XTShfvOYdDozraaKx5Wx8X+oZvvjbbHhHGPL2seq97fp3nZ9h8TIQXRhO+aY
 vFkWitqCJg==
In-Reply-To: <d7473c88d4f2cfefd9249eb414a28806494c4e5e.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0075.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYYPR12MB8962:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0d16e8-23d2-4fc2-9344-08ddf7bb62ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2tub3IyVUNtSWh0ZUhXckwxakd1UUNQQ0NKdHJOYWo2WFR2bkpxdTE3RHM4?=
 =?utf-8?B?WUFYYkdiYlg2cmFaaTc0YjJnZThPSGxSOVI4MEJMNWNNVU1ESkExeWdWSERT?=
 =?utf-8?B?UkZPcWJTSVBkVTZ1THpqR2xEZi9hTHNPcSsvbzNDNGNUb2k1dkM5QnJyRzJN?=
 =?utf-8?B?anB2ckliK054STdYUzYrVEZJM1NJeXd1TTRlMXp5aHhTYm9LL2V1bjFPVHVY?=
 =?utf-8?B?T1c4anEvN2h3VGRxL3cwZEc4blZrbi9heGxycUpiaXNIQ3lFK1B0Qmw3akEw?=
 =?utf-8?B?UThKb0lZaFM3SnM5a0tKbTBXVnhJQUJQbkp2dmlFbFdsbjNZdzFvbWJGeDFU?=
 =?utf-8?B?UEIxakVXMjRYK0dvc08wRFVQRlNhOVBJbnlScm1vazBmTlY5ZjVVUktrOTBV?=
 =?utf-8?B?ckdsUE5wS2trUzNpd2k5STQwazA0SVlKQ1g4aUM2cmNHazFIR25zVHJIakRw?=
 =?utf-8?B?UE1ZeHA2MzVOOUpEREM1cVZSdDhhcnp1c0RzTHFjcmdwaEZ2Yzl1L05mZGY5?=
 =?utf-8?B?MjhZanFwYXp0eGtnTGkweTNUVjR4QU9LaThjdGhGMTJueG9TZUFQY3lNaUl6?=
 =?utf-8?B?ams1QlJLTmk3TUtYUDJWTXhmcko5TWtSc1ZRSU9xQTlsZ0pmSTZFUVlJMTND?=
 =?utf-8?B?eXp2ZS81dFBFZzhqdUhiL3FmVFZmS2hlMVY4Q05OZlQ4ZDJ1TE85YUZLVjZ5?=
 =?utf-8?B?ZXZpT3hlR2hlUzgrcFhFRWF4RGVPYkpvVDhCdnl5cjc1bHdiaVU1d1NXdkcy?=
 =?utf-8?B?NldCeTFqdW9iRjlzbjZIZDVOQTBUT3FDdi9ja1hVakd2dmt5b3c1QXNqWEFT?=
 =?utf-8?B?d3JON1RHa0llbXJPYWw3c1BnZ0VlakZFWkEyR1d2V2hQbGhzODB5My8zRzNP?=
 =?utf-8?B?YStnY0pqeHBXYk54YmZWWmFkODRtSTkyays4S1BYNEVFMU0yemVGRWhpRTBR?=
 =?utf-8?B?Yk55WXVaTEdBOXJ4ZmRKWlNCTnQ2K3RyYUswMU54Q0lrSUNvV1dRUlMyWUhm?=
 =?utf-8?B?VWNpUEErQzR2QnpaQnVHR1hlenFaaEVJeFFQSWpiYTBteFgwZGZtbno5dEh5?=
 =?utf-8?B?ZE41bXRvZHZRYUJEbE1GdTgyRjN3S1ZrRHJvaDY5djJudEdRVFRxR2RwSStK?=
 =?utf-8?B?a0pIcm5WUTgraVFSK092d0h4aWNEVk9tc0ltbFRFUmxlV0RVeVlHRWFIMWRC?=
 =?utf-8?B?RmVZbjFNY1hFM1dMTWJhT2xKZnZ5cng1OXV4VWN6UWZ6Uy84cWlDNlBwaUQ4?=
 =?utf-8?B?TEJQSXdQdll2S1ZYQUZGaUxmRmtIVkpkSmxmSWQ2b21jbTVNRTNXSEprL3RZ?=
 =?utf-8?B?SlM4T0E3ZlZ2OUxvUENNWG45ai9wY0ZsTnFZK3lnc0dBUXFOSHJBSDBKdEND?=
 =?utf-8?B?YnJDK3ltTjNLbXR6RU53aWo5U2lhU0IxajhZdmYzN0xxSXpsZGg2K2tzRzhX?=
 =?utf-8?B?UTc1cW4zUkRQZzNwcjYzbXVaaExKMHNKVGFZeDRhQi9ZU2MrdFJlNnJFcUVw?=
 =?utf-8?B?eVpsSmI2TW16MnAyQ1BHSTZTUlpKV1dMdFMvS0xNT0VZR29hNDVseVZZN1U2?=
 =?utf-8?B?Rk1UVEFsM3RlSUorWkxkMWw0OG5YUjQ5K2NuK0cveGY5cHNkOFV2Y1FabW1S?=
 =?utf-8?B?d1lsT1FBdjNqcFhvUlQvZFhVZmN3cnh4NzNzK0Z3akhrZUtYVWkxblhQYlpw?=
 =?utf-8?B?R3ZBa2dNRHRMS1VwMVRkamtQVmxJckkwd2JYSmN4amFyTVB4UHJDdS92ajQz?=
 =?utf-8?B?SkZ3STJXWDNweWxIbkQ0dkE4dUhMQ0FSWGQwOEZNTWEvQjRROU5YNi9MU29U?=
 =?utf-8?B?OTVJZllkSlB2dW1laHYvWkt0WVAyMnFzQmx5ME9FL3E3anNubnlaMXNmMFpB?=
 =?utf-8?B?T1FhQU04UDMyeFJyejUrTzNhN1F6RktrT3M4QWQwL3prMnJGelQ2VWFlMXBV?=
 =?utf-8?Q?Kqk7CTJNlzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGRjeGMwVGZ6dlhpMnovQXh1WTVjR2pVaUhQSFp6ZFBmREYyRTNSalA1SG83?=
 =?utf-8?B?ajZDVHdTU1J2dEpzaWIwOUFhd3ZWbzRUUVgydWN4bzgvaVFiMC9QVnFHRmJy?=
 =?utf-8?B?VWFBa0RMVTZ6ZzdyZVFtMEJwUXlzMDFjZ2RleStaeDRtcmNRMlJtZ0J3UzVm?=
 =?utf-8?B?dThXeGtyOTF1MGpQMlhFKzJpaWpPR3QwT3Q4UXZ1dHJka2xKQ0k1cmNsdmpF?=
 =?utf-8?B?TTJ0di96amN6ZzNSTWRaai94K054eC83K1RpTjJ6V2FNTmcrRWtpTTdQdVpx?=
 =?utf-8?B?ODBJbVh5Z0YwNGVvQ1hZTEkrY1I3REh5bGpyaklNQm1sT0NFYjlhTVVnYlRU?=
 =?utf-8?B?OEYxbG4xZUx0UWN5cGFvcDlidlNwTWZaMFdpWm9QTCtEWWFDWE5oWWpyTDVk?=
 =?utf-8?B?TWhpRlI1TElaajNhb0N3c2d4em5WREpkUm5kQ0dncHBxcCtibW95Rk1WL21G?=
 =?utf-8?B?Nkh0UGoyUVNaemZibjFHOTJDZDJ0d1Z4RlR0Tm04R0NzazF3b0lEWjRlajh1?=
 =?utf-8?B?TGdRNVdZb1JNUXJERTZPbmR4MU93RlczZm5sZDU3MlRrazVHekxZeW1DckRk?=
 =?utf-8?B?OXBjeGd6LzNmUGhHaFdWUjNWUEE2ai9kaW91YldTcEZyTVdQTGczUFVSanZN?=
 =?utf-8?B?Zm1JUXZwU2xNbVo1aFgzZzEyUCtZcFBmVWhCUjg4ejlSMUY2bE4xdUVSc1h4?=
 =?utf-8?B?UDlxMmFobHJCSlcvNEJmYlhaVUlydFBRRFpNUnY2VU1mUCtnRTFoNEhObG1v?=
 =?utf-8?B?MkF5QlRwcUdCSzl5NjBuWEtNK0I5bmZPN3MwN1Z5SWlDc2c5a3pOTit2L21k?=
 =?utf-8?B?ZEdBUU9FV3BBbVZyM0IrT3d4emIrbmkwRVRzdXR3MVpvRFBka1NxbE5nSGRa?=
 =?utf-8?B?cCtab3Z5OFNOSjcwcXlDN3dndVArM1pZK2tOYXdxVitZbnE1R01rMDN5a1l2?=
 =?utf-8?B?R1BxSGVKYjFLWWVFRjU4L20xMEsvYWpHQnNBRHFoUmJ0cVBWSHRqN3pqY2JF?=
 =?utf-8?B?VGU3NHlCNnZ1d3NJdnJOc3dzV05uV0cwZkxPUURLTHFxZ3Q2Wnh5a0cvYTFD?=
 =?utf-8?B?N2IwVm9tRVU4V3Z4aUJrTTNFT3VKazBlaE02MS9pbXRiVkFKRHJuYmNLbkVP?=
 =?utf-8?B?a0pVUHUzVHpKTlkxT0J2S2duVUNlUkFWMldNM1J5MmVPREx1T3NROW5IS2hJ?=
 =?utf-8?B?U0dwSjJXQTZkWGNMOUJTY1JEZ0tUOFNMSE5WbEZZRVErWGViZUJXUklHbVBh?=
 =?utf-8?B?eFowQWp3Sm9wdkVPYTNuSXZGSVBRRi9rTWFwdEIwclpKdEdpS1R1S1pOcTh1?=
 =?utf-8?B?Wm9RVnhGOXpEbTRYMGxHTTBZRE11VXhKOE41SnlVZXc1TXJLWFFrV21MRGYx?=
 =?utf-8?B?OUNpQytDK1lnTnI4NEp4eXN6Q1U3bk5nSlBNWHdhTXZFaG00anB3TlNXdTF5?=
 =?utf-8?B?S0RhdWk1VGJMZlpPR0RvV28rYThlKzFEZHJPTFptazJJOTNmT3dyUnU2MTJZ?=
 =?utf-8?B?VUhqN1RXeVAzQ293SWtQOVlBeXFGYXRMWWhrRFIybEw4eFhlcEhmNmNzcmJT?=
 =?utf-8?B?Q3d5K2M2ZFBpdDlsVFVHNnRPYmVLdzBzR3dHQzVhUmFxQWgwTERtdkhGRklh?=
 =?utf-8?B?L09jT0RZMGIxS1Q2ZjM4SCtDcmQvL0RvVyt3L0RDRGZseXU2Z1JDV0ZiTmVl?=
 =?utf-8?B?aUZ1WW1ZYzFsTTJWNXZpekJQYzA1MUdpajRkNkh1S01jQzN3L09XenAxWE5C?=
 =?utf-8?B?aG5LeTBZR2xjeEJFdnlIRkg4Vk12WWEzbWF0ZmVPOFpJYjZWanpSTERsV1pX?=
 =?utf-8?B?ZG42SU5pUC9nc1lPbUZiblpVaDFNck5FTnhLNXBXS0Y4QnhwaDcvMGMxT2VP?=
 =?utf-8?B?NHRoMFBUcjByYzd4UnhLWkNOVVFWN0JVWFhjTms3eGpZZjI1U0N3aHJ4UzFi?=
 =?utf-8?B?ZGhQbGxRRHpRN24wTkMxV3lvVkdDZXJCKzVVU013NC9BVlhubkNvMEtyQUZx?=
 =?utf-8?B?c3BiU0ZNTEhGY0hLQk9BRGxIUS9mc1JEL2FNZ3VucEVlUm1NWFVrM1RTRGFE?=
 =?utf-8?B?ZVNmNitIaHNvcWo0TmV1b0o2dDJwN2oyYUprcDhmR3pBcVJQRVNTZUh4Ly9B?=
 =?utf-8?Q?LZuGRrra5N77DDBSkDv+O9MXe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0d16e8-23d2-4fc2-9344-08ddf7bb62ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:30:34.5420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGe5QNjGasyr/3Ox3sFRVmldqz/nm43bjNT0cMeE3eguDxEDjUKpJ1zcltn5H2dEl1K3NOTWQUUhl/pgubMwgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8962

On 9/18/25 05:26, Naveen N Rao (AMD) wrote:
> Align with IGVM files providing sev features with

s/sev/SEV/

if you have to re-submit...

> SVM_SEV_FEAT_SNP_ACTIVE set by setting the same when creating a
> sev-snp-guest object.
> 
> Since KVM sets this feature itself, SVM_SEV_FEAT_SNP_ACTIVE is unset
> before KVM_SEV_INIT2 ioctl is invoked. Move that out of IGVM-specific
> section to common code.
> 
> While at it, convert the existing SVM_SEV_FEAT_SNP_ACTIVE definition to
> use the BIT() macro for consistency with upcoming feature flags.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.h |  2 +-
>  target/i386/sev.c | 24 +++++++++++++++++-------
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 9db1a802f6bb..102546b112d6 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -44,7 +44,7 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_SMT      0x10000
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
> -#define SVM_SEV_FEAT_SNP_ACTIVE 1
> +#define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1057b8ab2c60..2fb1268ed788 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -319,6 +319,15 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
>      sev_common->state = new_state;
>  }
>  
> +static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
> +{
> +    if (set) {
> +        sev_common->sev_features |= feature;
> +    } else {
> +        sev_common->sev_features &= ~feature;
> +    }
> +}
> +
>  static void
>  sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
>                      size_t max_size)
> @@ -1897,15 +1906,15 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>                  -1) {
>                  return -1;
>              }
> -            /*
> -             * KVM maintains a bitmask of allowed sev_features. This does not
> -             * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> -             * itself. Therefore we need to clear this flag.
> -             */
> -            args.vmsa_features = sev_common->sev_features &
> -                                 ~SVM_SEV_FEAT_SNP_ACTIVE;
>          }
>  
> +        /*
> +         * KVM maintains a bitmask of allowed sev_features. This does not
> +         * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> +         * itself. Therefore we need to clear this flag.
> +         */
> +        args.vmsa_features = sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE;
> +
>          ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
>          break;
>      }
> @@ -3127,6 +3136,7 @@ sev_snp_guest_instance_init(Object *obj)
>  
>      /* default init/start/finish params for kvm */
>      sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
> +    sev_set_feature(SEV_COMMON(sev_snp_guest), SVM_SEV_FEAT_SNP_ACTIVE, true);
>  }
>  
>  /* guest info specific to sev-snp */


