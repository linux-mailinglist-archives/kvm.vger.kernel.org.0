Return-Path: <kvm+bounces-33118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0FD9E5073
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949E318825A0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377B31D5AA8;
	Thu,  5 Dec 2024 09:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k2POt1nS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0551D517E;
	Thu,  5 Dec 2024 09:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733389210; cv=fail; b=dd0lzeEGI6qp8FYnwfdo0VPV9VrrNMN7VMOW5BbU07PwB/3yeWwDPklwP22Br4JiL8wgcI2y2+mZj4vEbZ1qQ/AJDrgb4/KMCewYI7hlDsNEriofw5FlWrr94KE/HdC/tSlytuq9PDAd8N7AE0I+XL0dJYcMmonod8RBjJp3sCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733389210; c=relaxed/simple;
	bh=KegCdmqNoIevGYb0Yd0Z3NBXPAinr09XNO6cCNx8me8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=md3rq8ccZv4DCPE05GqZ1ELFRVSr6we/WkEPgXkR6EGPq49d2jg3drTv5FOdsy7yNzIUiw8XHxCcJhysibkfai8XRCBMqAj7kCyaZG9pCNYOrYtDSvOGUCb4Hd6SpLqY67OdFy6IHh1DWjGc5WXP+d7AZ2+4o0QnDD3yGfLwaN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k2POt1nS; arc=fail smtp.client-ip=40.107.95.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVO8fZyskr5rwCB4erCnU1Ry0CajKCbzWv17GtGBgsxbqMOMbGS7g+4wcvTAuQ0xo/lqXi+Pbxqdo1Ev0ATko6C09rpiiIuUI2i7lheoqnfdCboZ/YHWaP5T0+hzH9RhN9arKTtQ5o4fn9+bot2WfeHoQpsM1h6LQYvDtt3wvknGKBYQvmQzFFMQMBh+0W/26nXRKg8XyF5r6pud5d7Umr31YmPwa55ooVnCRn8vBnugpYH3F1Ro4zDOFbl0ZQoasS3hY1nsbg1Q1IhXuHt+M9HhmAzDCKkoOkGtYcy2pjYJQsrkZZnVTRPDfgQSPjQOxPSOEX2mEAD8JrGhVYvKnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocy5l4zE5CcqK6ZQFIZcIabnjgDMEiiVm7d1vN+h9Z0=;
 b=HJkfdgCaJnDpQhWdusfRgm7JcbcGKEnLf28UVwzBiMtaqaL26QrWb5pXYEtewlH2mB2PKnwoczdQgn1fLP98rPRcWHfFc2F9dGvw5Pqjh5aHJqmWPLX8Fs46WXr+Z3xoP21If3kS3LClZdUG4w9pikm9/GU51nLJbrqe+VbE6fP8OTFc4Keb3QWicbpgZsBmeMfb1qSw6JLGuKYkND81jixZIJonb9oFUpiou/PYCKJw7w8A8trjIGrJQGQ8m2W3G71F2Brsx3jRp0ido3IPl6GOQLQGnoZ76RVRdud1D0kRoZ9mt/Qk41JYOKXjo9Z2g4huTq7D+RhP3K5FHY73JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocy5l4zE5CcqK6ZQFIZcIabnjgDMEiiVm7d1vN+h9Z0=;
 b=k2POt1nSnG2xPNgO+zy0QXHGAJIYWvFz3k3JXhqxtqRf+G3NDTsI0jDCrpru3tKKSvwCQQhk3GWo/K+13OUn/njcGnSssI2UfFtWWRHXzLy/BaAYrHl2gZnxIOV18V1JXiAZ6uH24evvzeoElE03EAC8HxyRYbujddg2uENp5Ls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Thu, 5 Dec
 2024 09:00:05 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 09:00:05 +0000
Message-ID: <465c927c-88f0-45fc-9178-4c6981f82fd9@amd.com>
Date: Thu, 5 Dec 2024 14:29:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF
 MSRs
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Huang Rui <ray.huang@amd.com>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 Jim Mattson <jmattson@google.com>
References: <20241121185315.3416855-1-mizhang@google.com>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0115.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::14) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: f45ffa72-6891-47a3-037c-08dd150b35aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXdBalFJekJUejJVV2dRZEpneUtlQ2RsenI1TEIzdFFHUmxBQ0dPbTg3YkVI?=
 =?utf-8?B?VW5aa3NhTEZyMHpvcG1IZEw1anBJSEVIcTJ2SHJyV3FzbXpiS043WFNEdk9o?=
 =?utf-8?B?dzlncnZkNktvRHdPK3ZUQnBwbWdLQmc4KzhJV0dUSWp5Z1lSSnEwV1ZoUUtK?=
 =?utf-8?B?T1VOVFBlWTJiOGU4ZEpqM0lSaUVtS0s5Vm1rTHNndlZKSzJ2K256UHVCbFBW?=
 =?utf-8?B?SFQ0bWlOOUhQSExpek1HbzUxZEtxZXp4YWdNc3hhNVRCdC8rR1d5bmVETERs?=
 =?utf-8?B?NnlmOExnU0VJRnRaOW5ZeGJxeUVFaUtjZm5mYktFL3F3VGpyOE9qTXJ3d00r?=
 =?utf-8?B?d0R1ZW9vcG1SZkpORkF5Z1A2L252aThpVzZ2czY3S2VpZjJaS1VFazlnbmw2?=
 =?utf-8?B?MXErcU82Qkt4Y204OVRJZzkvc0pkZmx5OW5USzIrb0VFZmJaWFExOW1YVkZh?=
 =?utf-8?B?UXRKL1dtVURpSUdMbGNBbkRjamRUVWpVdDMzZ2xBRmhOdjJ6d0p4N2RQRzZJ?=
 =?utf-8?B?T0N0bGZKN2hzbGV4ZW4xcHNxck9lSVhkc1B0Zm1WbHJwVVcxaHZZNFZOa1ZH?=
 =?utf-8?B?bloyYlI4MnF3cFFRWVV2SW44cHJvQzljdVV6Z0ZDaEpDbkYrc0RwV0lIVlJw?=
 =?utf-8?B?NUxsT3FvUjZ5QW9aTWRwNyt5Rytzbjd4bStBRmVFc3dCbW81NkhZZWpKaUdo?=
 =?utf-8?B?MS9veGtCWVRHRE5BNmNTUWJRbEMzb2tKWHhlVzdKb2IrZU1ORk02VDRVdGtS?=
 =?utf-8?B?UDg1VWluZ1UyY1A4SkNVbkE2aFJVUExUS2RGT1o1VWNON2k0d1FlajR6TndP?=
 =?utf-8?B?OFJ5cVIvNkJ4dlZmS2tWZDR4YUlHZlJwZmdNV1JTM1FmR1hKS2NmZ0hkcE9w?=
 =?utf-8?B?ZkZuaVljU2hkZUh0TTBPWGdGUURjUXZKQTRFUEVVSTJ6cGVIQmR3VDcyREhw?=
 =?utf-8?B?eFFRbnVTbzlHSTU5djVwNXZCaGNPbzR4RDc3S3dnZW5OcGFublpMTHo2NTVY?=
 =?utf-8?B?ckNYaHo1NjVadk84VmtGUEMzR1VISDI0aDB0a1VsNUhUaDZLMUFhNHRDODBD?=
 =?utf-8?B?VGVQMVNwbW1Zc0VNYndtYjM5eWg3bjRoZXU1b3l2SkR1bmNJaHYzRmxmeS9r?=
 =?utf-8?B?a1ZTSU12QnYzWm43UWJRMmdNMVJYeitQbWpwb2FwRXQvTndZMTg2dWdxRVhR?=
 =?utf-8?B?TDZyOGx0RGY0WUZySmU3MFJ0N0NYUlJlYXNGcGU2bGNlM2trTXhNTnpzYWNo?=
 =?utf-8?B?dW4xSXRiSlN5R3YzbDJUTVVVVFJIV1F6ZW5UVjRLUTlMMkhrQ0VnSGo5R0pJ?=
 =?utf-8?B?Ym9OVTdVYllWSDd0SEg2QWJieGRGekNDbDFKeUo4dGZDUks5NGcrRUluT0dE?=
 =?utf-8?B?TUVhT2tZU0FkQ3QvTWdRd1RRV0xwYVlkOVZWMW5idVNKaVIzQlkzSkJVTnEv?=
 =?utf-8?B?US9rR1pwcGwvOW1PV0RaU2lvTTRQSnM1T3FtVGtVdE45N2FvQUQ0VW9ZUmYy?=
 =?utf-8?B?YlZ3ak5vYXpZVmVYcTl0UUxEQVlWOGN4UnVqUVhyRjkrWk82MzgwVEdmdktw?=
 =?utf-8?B?enJEalltNlpYd1NYenlqb1R5TGdvTGpUWFpKTGlMdzhLNHJtamFFd0dsS3J6?=
 =?utf-8?B?N0J5SnFSdXdxOStqa21TNVkydnQ2dm11S1I1eTlEZjEzQ1JnL0xjTzdQSGNI?=
 =?utf-8?B?WjViWEtqWnRZcmtkV3ZUV2QvbHJIOWlrMWdDSzJ4NTBnYnV0eEI0UXByOXlz?=
 =?utf-8?B?cU9GZ1I4K2ZOTG0wWjQ4c0p2ZklPQlE2ZUMzcy9ERnBwYVJXY3JzVDZrL01h?=
 =?utf-8?B?Qm4xdWIzN0Y2dklDWDJTRGhXa2t6V01oUm1xYWJ4NFVpK3Y5L3doWUF1NmRZ?=
 =?utf-8?B?Nnp1YnRjWnZoNGV0RE9BY1gwbDh3TWRjMVY5UGZUU1FCenc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Snd2dFhOcXhQRHd5TFpsSDVpUmYzRGVPNVB3d2R3TnBYUWtma05vdTRvQmUy?=
 =?utf-8?B?aHQrc05nVklGRXhXY3ZoQUo2a0VieU4yQ3pRTlJmbHMycWk2dG1kNUoyd0ZR?=
 =?utf-8?B?cVNQaXdFVG95a21tZWhrbDRhZjU4ZTQrZGpTTDRmSzJ1TXlFNzFGajNyTGZj?=
 =?utf-8?B?VHdJdXFkNTZ5YzJZTzA5U09VeUtlOFBHOVFwMzBsYTJyODNuSC9sTGNEb3Uz?=
 =?utf-8?B?dnpqWXFWUUhSRkFjeTlwdjZTK2g5QjF4L1U1eWE0L1BGMG1heVN5RzRlV0VC?=
 =?utf-8?B?Ukg1RXp4QWJkZHZnS3dNamFHajFoM2kvRWp0TERMMURiNmpTY1hhSVJ3VjMv?=
 =?utf-8?B?VVBReTl4OE1jWFJlWnBxQXZ6ZnBWc0ZuWmlyd3pjU0ZWUnpRODBWcXZ2NWY1?=
 =?utf-8?B?UEN1Zk5oRC9WTWY3NENMN2E2RUhDaVAraTVLT2diS0xyOUFyL040OEVNT0tV?=
 =?utf-8?B?K292R2c3dEJlSHJRdU1WSFlFZnMvMVNSZW4vL25tWWZlWFl5VngvUzYremY2?=
 =?utf-8?B?b3BTUFFXMXQ2YitKWklhTVduZHpKN0dQaTVVVGZBRkdZc2lXeVk5bEw0NEU4?=
 =?utf-8?B?QyswZTl0dUxRNnNqaWs5disrVTZMTnhaVnYvb0cxYXVDeUo3Y0oxNkFMQVdE?=
 =?utf-8?B?R3kzRi9VUTYrR3Q4QW1aejU0SVlpdGVsNUx2eFJzRmxPMS9Nc292Z3pkTDdo?=
 =?utf-8?B?NnVDMERISmVMQ1BwNzhTb1IzWHVVcU9ZRFhUOVppeUpHK1hTeUpuSk1xeTJK?=
 =?utf-8?B?dEdPZkJsZGxZOHBycmVtR1pBV2R3TGZtQ2xnMXJmajlEc3k4dVNWQ21Saytv?=
 =?utf-8?B?d0RJTW1TYm90Q1ZUTU9vdzF3a29tL1JUVVVDcGRYaFBmU3o3bEpKZkFscDVQ?=
 =?utf-8?B?MDNDNytQUFJOZWtQb0hJYWp2cnViK2xzMHJCL0diTUNPMUdtNWJUL083QWJB?=
 =?utf-8?B?L0hZUUVQbXRoQ3Fabi81OVczVVVIdHhqdldFdjhzL01LWWlEY2lYQmE5WjRJ?=
 =?utf-8?B?Zmh2MlVnOEtTVHFVZnFFSmVRbDM3eFRPNElHam13dHpCaUpMM0RCU2R5NHQy?=
 =?utf-8?B?ZTMzaGVtR2Q1eVl2NXZsOGdOb1NwT3p6eHZ6RE9EMEhidlliWHJHb2QvcVZm?=
 =?utf-8?B?OGR5YjdobjdYM0hWb0pCUFJPbUhBZFhTdy9adG1YdmxoV3A4OC9YamhNRnl5?=
 =?utf-8?B?S0VmTWpBaUt3b3ljNVNBd3crWjNhRTVmYzBOeGxHT08vcDc3allYQ3BNUXVy?=
 =?utf-8?B?Nml3LzE3OG5PSm5XOS9COTVGaXA2OUlDUlgxcnRuV2FhelQyWW5DVzlaM0hN?=
 =?utf-8?B?UEw2ei93OEdNYW1DOTR1Q01EWkU2K08zajNMZlZkeFlEK1FKSDJOQ3UvY1ZM?=
 =?utf-8?B?ekg2NlQwWElyYmxYYXFKTU1XTnVpblFTVlREVHViOWp2L0NxWjh3MzJOLzg3?=
 =?utf-8?B?c0lmZXkzZXplbXVJWis5QmpQK2VHbjBRb2psaVhvQ0RSb0lmNWc3KzZkWWZZ?=
 =?utf-8?B?K1dMSFhYd3BFRUMzSHlQYkVLbVljQ0ordkZaZnRYSVp6SEhzekd0MnJCZFhL?=
 =?utf-8?B?ZllxYncyby9MMFpCRkdpNDh3ZlBUSjJPNUR0dFpZSnBSbmZML2dFaXdnL0ZM?=
 =?utf-8?B?RktiZFhiSkZwbE81WllQb0R2K3FHYnZuSHhTRU80aVBDVGRyRFlOSHUvT2t3?=
 =?utf-8?B?Zk1QajMxaFptM1NmeW1YZlJBZTdaUEdIM0tGd0tFUUdnVUlJN3E5QlNxeldF?=
 =?utf-8?B?TTMrc3hqbVZQRHdjK3VtOTFUTTFiZnljTkx6ZDFua3ZDajRySWQybjNiY05R?=
 =?utf-8?B?VkFEN1ZCZVVCVzBaUG9oVk8wM0hQY3dUZEVxSk9BRWdkRHY0RXQ5OTRQT3pi?=
 =?utf-8?B?bmNobUhrV2FBd3l6dnNtUkxFck1reFJ0UzdUS2JrL1RoZE8vdElCT0dpRE9v?=
 =?utf-8?B?MW43dTNkOW9MZWlaQm9JSU1PMjlhOGVBcitDT2U4WUYzSlFDb0dVaXJLWDhm?=
 =?utf-8?B?NW1wazlaUmJaZnQ4MjcwMzJrbHlHaXJLZE8xeFk4SEN1MDRTOS9sZXFOZy9R?=
 =?utf-8?B?NnYrcFV6RWY1WGZreFNhbXB0T2tNSWxIWnVnU2lXTFZSZjRQTnloN0VXWkpW?=
 =?utf-8?Q?zusJca3DYGx8sJ1kB9YRCzMnr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45ffa72-6891-47a3-037c-08dd150b35aa
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 09:00:04.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE+V0QZSgJGP0w4mzd9NUliOgVxdsSF6EqDrRhyNE+7iK7Xo9Nol17r5pxAx7vRbS2WhPbCau8jO5zj8YqwnZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

On 11/22/2024 12:22 AM, Mingwei Zhang wrote:
> Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
> (250 Hz by default) to measure their effective CPU frequency. To avoid
> the overhead of intercepting these frequent MSR reads, allow the guest
> to read them directly by loading guest values into the hardware MSRs.
> 
> These MSRs are continuously running counters whose values must be
> carefully tracked during all vCPU state transitions:
> - Guest IA32_APERF advances only during guest execution
> - Guest IA32_MPERF advances at the TSC frequency whenever the vCPU is
>   in C0 state, even when not actively running

Any particular reason to treat APERF and MPERF differently?

AFAIU, APERF and MPERF architecturally will count when the CPU is in C0 state.
MPERF counting at constant frequency and the APERF counting at a variable
frequency. Shouldn't we treat APERF and MPERF equal and keep on counting in C0
state and even when "not actively running" ?

Can you clarify what do you mean by "not actively running"?

Regards
Nikunj


