Return-Path: <kvm+bounces-61393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 004F7C1AAE7
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1DA75A2631
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 13:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1FA3358C2;
	Wed, 29 Oct 2025 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MZZIt/Vf"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011047.outbound.protection.outlook.com [40.107.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407C223DCF
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761743922; cv=fail; b=A0Z1EClRlqK138e7llFs8kd4seMiO00fx73h6VJq0uLoTyf3T3IKylkDyjXkms4bALA0cO//hNLPDUXi+CF8JI32dYIwd/RbMYuIjvfmGGs2MD7QDW7joyPbJ1AWwzjf+vVBPL1S0//BzpRXPxN3eLpoED+cLIvGz7Ztlfe/clQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761743922; c=relaxed/simple;
	bh=Pf3DUR3sFynKgXGJ5G6ZR7thRnvYB/qcbe6D33OK56M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IRacGz5nFlpMmC8D1yXgU4O9UEPfhWtbFe9vt+UoF7Vsp2ohkqhjCS8woqa3BiiZxr9XapD9X2PCKNptNDtwUB5Fn/C+smokgokFXXIuXn329Rm+k7I/OE8u42LIujKwTo9lEsasjqvHznqqEf4jZV8F+iKUq2xIowRSp49gF+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MZZIt/Vf; arc=fail smtp.client-ip=40.107.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/fS3CklUsOvq6c473hP8yMdXil8HHa1g5To2+vu4XCJr3ECiq6PmTaci6RcdmZ4QHDcptIoJwh5CAuCvZLBI/0kcX1MMLyUZzxdWv9KIaVqWP4n7PwzTT6TypIBud8YqewrxG2nltsj2b7A5UDjPMMPBGMC8QA5gQL00LKejEXsbePqAPxNO8Pww5CJRjAEMiUQjEkgqsHd3CZ3r2JZcV9WEeRl1dbqxfN9rs+/q4DOMvyBnah6f1Tq5UAw+afa8I30qlfqmnzVj9jELiEsiyjMJjNEuEw5QnBRbRMcRz5HcRlRzjxY64WYqfrxfoxkpIGBSYBQZ355cUA59Zr/Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcSe5rigajDKSC9wUNJwY0nijKGNrO/mH7Y6FjwJ4QU=;
 b=DLsOeSG0hChHTk+2k5QZRpt1O4u/7kS9tcapVox78f8R9iDPfhVh0Zr6TZ1CJ8wbwdlRrfhjg9PH+c6egjd7/ET/wywKX7bngcmmHomqNununJJ7wd/yezvCV9c5AKWF/tIhyNv7f09EWAJ/kUahCNmv2k1Vb94t3/sRyumSxdlO8i5lLHyNykUkhZmNnsDoQa4Feg4739Cii9nC2fk7FJ2FaS5EvzIyd15daRNpV9D2E6zEWALGVW6IoWRjIiukJ6FfzYogbuMVfuXJbNuNB3+ZW8L1zzF4dk9IPQMNwRl7I8PkdK/ORGutUHnpQsoDCXwHyW1KljzRBaBbX9hRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcSe5rigajDKSC9wUNJwY0nijKGNrO/mH7Y6FjwJ4QU=;
 b=MZZIt/VfEENxFlh316pjImAHiJt7/blnQSX9Cx5mXcgbmD1pAI1hc8l2NI8zkCLGnRMpEMqLxwvncr5YMN5a1K/PGEi+5Pdaek0/Qo8PGqBn9CTTD6Gjeq4NJIHXt76YmGrCTZYoSMtzijZBSgpDzLmTqJ1EUtxeOdTC5lYunx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 13:18:38 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9253.013; Wed, 29 Oct 2025
 13:18:38 +0000
Message-ID: <6d230667-e37c-4b42-8f32-4beeb29d9086@amd.com>
Date: Wed, 29 Oct 2025 08:18:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Add module parameter to control SEV-SNP Secure
 TSC feature
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, santosh.shukla@amd.com
References: <20251029055753.5742-1-nikunj@amd.com>
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
In-Reply-To: <20251029055753.5742-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0080.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::17) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 554b50c0-a78c-4fa6-858b-08de16edabd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGFlVkZsVGJKV1hEdEEvaGdBdGdCTG84OUtPQWVNK3B2Z3NqV0dDK0t3TzY0?=
 =?utf-8?B?akxaQlB2TDU3YnJKNDlPY0JEdGk1YXhOUU9ab3l5QVFMYUhVczZZQjBEeVYy?=
 =?utf-8?B?Z2Fac2hlM2IwcFBmcTFEbEVjNkZFaGxRdnVXTzZHOHd0WmtlN0RZcWRCR3Zw?=
 =?utf-8?B?QzBaMk5Vd1djQytodDBQYng1bmtCUk9nK2xDY0tyclNQTC92NGR3ZDltRGZn?=
 =?utf-8?B?UFdsTmltZ1Z5dWVkWmtUQjdtSDEwamxrUVVQdFk1QklKT3V4VmpDbEtmS2c1?=
 =?utf-8?B?N3ZDVmRZTUxaMFlQOEdpT3B5VmppSVJUUmdSVFNSWUdxM2NRaHNmWGhDOG43?=
 =?utf-8?B?QzNMcTk0T21FWFFUemErU0tDYXRnNHlyeEo3YlBiU2tlekNFVjFFTisxZm1F?=
 =?utf-8?B?N0htN1I3OUpxWVc5aHc5ZXozQmtyNUZjZHBzYm5xaW9icUlsbTkzYzNndWti?=
 =?utf-8?B?R1p6K1NveWNrN2hvNjB0ZG5RdXJXVHloNUNlRjRjdVBBbFp1TlM2WEtOdXIw?=
 =?utf-8?B?SjgvN3BuRVY0WDhnMHl0ZXU1WHJRS3Y5ZFMvazl2cHJGS21KTUh1OGJkVjgw?=
 =?utf-8?B?T0k0UHRvR1JUYWsvN3ZraVViMjNvejVrSTBuWFRnS1hWa1dLb1R2ZjZIN21k?=
 =?utf-8?B?S29DSmYyaWJudHp3Rml0a0F0NWhta2RWYXZhMy9ORnhHM09jUThzVHMvUHQy?=
 =?utf-8?B?K2tCVW5oRE05dHNzdUJ2aDZQTURudGpEdERzOGFvbU0wY1dXOTdZZm9FVzlp?=
 =?utf-8?B?QlR4cytqejVaMFpjVXNmRnFiUVpMMzdpbEtmWURHZUdlSkZNNGpVRStpRktB?=
 =?utf-8?B?VlFmeE5kc1I1Mm90NkZoU1FoeHR5SUNHUjZnVGxOSEFDZXJvL0ZYWGFSVVpQ?=
 =?utf-8?B?Qi9PdXkxYTZJdUhHSjJQVDNieStLNXByVlNDd3dPbFREdXNtWW56WGhCNFdr?=
 =?utf-8?B?OENxVk1DR1hDd210SXUwWEY3djRZVDduL3FWaVB4b09LbTY1aDgyMFpBb3VW?=
 =?utf-8?B?aVJJTFFWaEo1cEw3V3ZIUGYyV0kvQkV4aVF1Y2ptWlZLYjNDc291Vk1ROWNX?=
 =?utf-8?B?Z2d4bnNZc0ZBaTc3US9LSmhsd3pvNjFpNnE3N08xYXlNUkVybis5WU9IQlEw?=
 =?utf-8?B?ZkhNcWowOFVNeUl3R1FtaHFhNGZCRkFvQzg3QWlqTGpRUkZiaW43N1JLSkw1?=
 =?utf-8?B?eVduQlRHaVV4V002dmJ1WHNsaGVqVFljOTJUM0dGWkdFRW16MitlTC9WRW9o?=
 =?utf-8?B?SXJOVVR3ZmJUdlJhV1Z3d1JEci9yZDRqNERIRTZLSDkzUEh0blNLY09DV1d1?=
 =?utf-8?B?VFhSblpXb013ZElUaTJiRmlqSHcwbFBpUklORGRtdGFMc1BNTUVwSUx3cTdy?=
 =?utf-8?B?TVZYSFRhZERtZGNiOTBYR29sTUFrSGY1NGtiMGVWSjY0YmFXdjZDK2VESTUy?=
 =?utf-8?B?OEtLT3J6bHV2VFhwUklkMXV1RnhKdlJzWHk1ZkxrR1piR3p5YkFsNjdObnU5?=
 =?utf-8?B?RVVNK1ZxUW9paVVvNWZyYllnZEpoQmNqRGZHNXUzNzlSRm4wbTNlUmNKNnV4?=
 =?utf-8?B?VXJpQkQ3TnQxb01ZdWVGZmErdWNYU2MvcVJFRXJxdjg0UUdxUzdpLzc2ZmlJ?=
 =?utf-8?B?STdMbFRsZVEybEpHQXl1SVhrNVZmS1NHNmZwT0tQVXJzRUxkWU03WUJkTjUv?=
 =?utf-8?B?SkdXMHdhdHh1cWZqTFhSb0U1YUhYYmd5L0J0MHVMVFdkK2s5ZGVsNFNjeGZa?=
 =?utf-8?B?ZisxYlNEbzdpaXlhcFptVFg3K254dzR0WlBVQUloeEdGbS9VTlk4UjBWcjJv?=
 =?utf-8?B?emFBNzl5MGRCRGZCSXFCS2NMR0Rwem82dFZSOU9VYkxIVjNaOHFnZGZvaUxl?=
 =?utf-8?B?dzNwc2FHVmdpMndEMTQ4NS9ka05KRTFFZ2RwNjlpcUlrNjlWaGJRajNoNDJa?=
 =?utf-8?Q?ctwFhNALLR7++5XRN3AynkWQgoLjL+Hg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmNQYU1wU2Q2eEpWTmUzM0NsWXRBWklSOWpLdjdodFdUU1lSRG5QbEJFK1Ft?=
 =?utf-8?B?M2MzMkpiZWM4RlY0dGIrS2JFaVAxd1JtdmVRbXZXdWxJeFlINzFVUjA0ajlp?=
 =?utf-8?B?K1Y1dTI4WW9qbGdYbHRuWGVtVmE5L2hTL3N3bXNucEFETVhMRUtiam1kVTh5?=
 =?utf-8?B?WWZCQllkeWZXSUd2Rmo3RFo4cWNzRG1XL2hoTUQ5S3FCcDBzdmJQanpQRm5a?=
 =?utf-8?B?YldZS3R5eW1Tdk1sSkhodGczR0lIYThPNjYwczFncFBBVmtCNHpQQXRBTnQ4?=
 =?utf-8?B?NTJBdEh0V0d4OEhGMUVKZDVYajRlUE9zS0JESHM0anpWSC9EeXJsM25lYThi?=
 =?utf-8?B?T0t2Ymhtb0ZrOWw5cTkrcUJUQkpqYWRpVzAvNHkrdWZPNkFEelJuUHZaeFFO?=
 =?utf-8?B?bmJ5S1Jzejc5NUV1TVVuWEJZYUNBVXRxelpWZFMwMXlHVElReFdIdy82K0Zk?=
 =?utf-8?B?L1NKOGw4MzFwcnN6aUUrZnBhUndHbjFTTEtkSy94R21tNUQvNmJUc1F1RmJn?=
 =?utf-8?B?ekIzSS9nbkQ3cEc0ZUQydEluNW55VDRaR0dwbkxMZmw4bU5YK3lUWGhKM2pI?=
 =?utf-8?B?V0R2VENzcVZaMlMzNVM5alloOENtYk1Uc3lGY1Zld0dqcjhsRktJM1NNQ3M3?=
 =?utf-8?B?MzVYWnRFcmdVZFVuTDdtazFvVURDY2xpWFgrY3RMVWwrVVNST2JvZW4vcCsr?=
 =?utf-8?B?OWtRNjd5WXdtVXRGSXUwakgrQklCMlZEV2J3ZXJTUkNaNW4wY2c5dUZ2aDdG?=
 =?utf-8?B?ci95OVBYd3dHS3MvalYrQVowdXlWVFEwMGN3ZnBFK1VETUM3RkJtbzRmZjBj?=
 =?utf-8?B?N0V1NHhyUEoyQkVOay9xRnBad2ZVSHQ5T2M5RGwvcnZNS0c5ajVJUWwyZEJP?=
 =?utf-8?B?djJ5MThoaWp2cHRxSFZVc1dNeDgxS3o5NXc1b1Nxby9tMUNEQVEzT3pOY2U1?=
 =?utf-8?B?L1VudVlCYnIxN3IzaDJmc1pIUnZQaWVzanI5R3JiTlJsdDRkSXFMc3BHRDBJ?=
 =?utf-8?B?N3psdjJ0K2dyTTJwSVpQYWVLUVlGdVJCYnhCVmhuaE1Oa3lzWEFacEo4WGFz?=
 =?utf-8?B?TGVwakFnc0pLU0I4bVA3WVBZV2JpTUZ0azVkbW5iYTZnVXJudndaYnR5K2sy?=
 =?utf-8?B?Wi9CaUxxRFNSVE1kRG90Z2gvbTR4Q3paUzJDemFxWkJqYkZ6RDBpYUlZVytY?=
 =?utf-8?B?M2hiRDBPeW5IOHUyZ0d5dXVSd2JjblBiK3pOQU1rYm11YWFnajNUQUlzS3g0?=
 =?utf-8?B?VlZhOFJ3VXlUM3pYZ3JJcGgxS0l6aGhWYS9ZeWZUUVZxbDVZRGdZdUFqakVU?=
 =?utf-8?B?WGs1d3ozTTNGTDF4UTBQODRCNXc0OXEwUXp5UmZJUHFSaWZFWTZSc3lKNGQ4?=
 =?utf-8?B?VitsWDJQSFAvaUhzdHMwMnJXdHlWMTZ4MnVBTUhmb0o0ckhZZklqOXVkT2Nk?=
 =?utf-8?B?ZURvcCtTcDZmcUpCYzlaWUMxQVJzTHJUY0JMNEUzbzN3Tm1mdk9PLzZRU1RJ?=
 =?utf-8?B?Q2U1RkdHUUt6RzR3eklLOW1GbTZQYXJwTDNVYVVoZjhiV1hhVmtCWS9oTDlB?=
 =?utf-8?B?R2FvWUFYdEFVZW9DelJVNC9vMVNNcFgzUndDVE1MNitUUitNTmErSTk5L1Zy?=
 =?utf-8?B?cXVNWFg1aWNMMnNJY2tGMGpkZEpkeDd2cWMwVDV6STNQR1lYbmM4VDc4NXp0?=
 =?utf-8?B?bUpaZlRSalNzTG50UFRhNWxYV1o5OVowSmY3TmxpcEJveFJFNHdzV2dhbUFO?=
 =?utf-8?B?Uk5SZTF5QjJCM1FzbDEydnNDQ0xVM1pHRTRYQUxtWWVRdHRLbGVHa1ZRYXRu?=
 =?utf-8?B?SUhab2NGMm1haURaRlN5UkI3TEJrUWdmMjJOcHBRR1Rrb1JuYzZnKzUyZjRH?=
 =?utf-8?B?YVNmTGFlMW1JN2xPdU1ZSDdvYVJVYmJPL3g1eDRndUdWN2dmbXExdytIMnFy?=
 =?utf-8?B?N0FxSG9FSUpOL0wyVVFvbEJMYm9kM09hMUw4bVJFR1FxdnBzck9iQ3BTME9z?=
 =?utf-8?B?OHJVbUw2SGdqMWJXUmsxaEVMUG1EV3prM3JkU2lINDZxUjQwSXpwS1dReHdK?=
 =?utf-8?B?RnF3blFxMGV0TFdLbG1xSVJTZEVyL2JReTFsOHA0TmpSMlJhVyszNW5HcjRU?=
 =?utf-8?Q?+8E/8oRD7r1Yt5KPA1isLtbkG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 554b50c0-a78c-4fa6-858b-08de16edabd4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 13:18:38.1365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D35Dxw7NuuRzUPK+TGW4PM/+I7ECi5g2TxJFNMfpmKdEU96lQlCjvaB3nNU/d0J/m6ZY8T00NjkwyYmokZaluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530

On 10/29/25 00:57, Nikunj A Dadhania wrote:
> Add a module parameter secure_tsc to allow control of the SEV-SNP Secure
> TSC feature at module load time, providing administrators with the ability
> to disable Secure TSC support even when the hardware and kernel support it.
> 
> Default the parameter to enabled (true) to maintain existing behavior when
> the feature is supported. Set the parameter to false if the feature cannot
> be enabled to reflect the actual state.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0835c664fbfd..1f359e31104f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -56,6 +56,11 @@ module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  /* enable/disable SEV-ES DebugSwap support */
>  static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
> +
> +/* enable/disable Secure TSC support */
> +static bool sev_snp_secure_tsc_enabled = true;
> +module_param_named(secure_tsc, sev_snp_secure_tsc_enabled, bool, 0444);
> +
>  static u64 sev_supported_vmsa_features;
>  
>  static unsigned int nr_ciphertext_hiding_asids;
> @@ -3147,8 +3152,11 @@ void __init sev_hardware_setup(void)
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  
> -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +	if (sev_snp_enabled && sev_snp_secure_tsc_enabled &&
> +	    tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> +	else
> +		sev_snp_secure_tsc_enabled = false;

Looks reasonable to me. My only nit is to rework this to look like the
debug_swap support, e.g.:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..4cf26ba637d2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3143,11 +3143,14 @@ void __init sev_hardware_setup(void)
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
 
+	if (!sev_snp_enabled || !tsc_khz || !cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_snp_secure_tsc_enabled = false;
+
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
-	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+	if (sev_snp_secure_tsc_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }

But I'll leave that decision up to the maintainers.

Thanks,
Tom

>  }
>  
>  void sev_hardware_unsetup(void)
> 
> base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac


