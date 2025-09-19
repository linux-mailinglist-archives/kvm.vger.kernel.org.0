Return-Path: <kvm+bounces-58222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72739B8B709
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A8031C23D2E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D3E2C0F66;
	Fri, 19 Sep 2025 22:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P4Fu0WcC"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF886342
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319587; cv=fail; b=QZh8jL8cwJPcX4UxdT3Bius3sZc9Ri8R6cqFjtzcDKusfGSvbBe93KtzmYJb33zGXQpIlTohmWY3ui2V4i0bKmieKnPh1hITH+Ywv3aRiY4WNEDq+8RjNKhWslIEqjQo4YsAmLuFHRlZBaCh5iE9m/qnzsQDXoLKxOr3pSvFMgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319587; c=relaxed/simple;
	bh=ToJpVpr0F9h/gdus1AYHEPUPu8k6mek7BVbWIWHrvuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YKFmyyBUxbit5yMx+3XvhcdXWr849Xxq9SceN/fI+vgIsNk/3mEExorZZOjISutyWG/Y/4/jMXJeCYA4Q+GqP5ORvaKbWxGDTeeyL7Y/lfLLBxN1AnYmQo+uVhwcItCmFsWGz3KvSSEmZCO+iQjpkFGQsb/qoa9P/gsbE39rIlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P4Fu0WcC; arc=fail smtp.client-ip=40.93.195.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCRQLSqmmqrQQtedBvWWUaFOfXnzj+b7XNuGs6G/otW+JNs35rU0iK85ZINoLpxzZH2Ka3cHhArUq0/aoTzKRLl2PeqYY5jRpcK3VkZtx8rbBLQ1o1OLaodJVrxcQR3ZyFlg2nGCuJ9h2uRSLKJSLpQ12WCMau+4QlCBGZgY25oOSwWpa1EVsOhQLsro0HBtorYVJ0/VYIMqUEx4Zmb80nBGmt+IXtAAf0gXKc/u8czWNKi+O9G+GQeeMcXRL1hz7VeoqDbGcavdXeDrk7HZVKxHsxmXlU04CUqnTtz0LW2pG14VsZlQLArYKGFlafHXR85M3qwrIJfbjT1RM9xiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1dZufFgS2eaZnpieP2mfzZkBHxdC9BhJNxRrIyeK1E=;
 b=Vbqb/iaNuq3cHwkHv2wPCciBY8FmHuOtJAD7WV8kpQPdu1ac9EVfx3eoy/ygw4K+GFIeHLfWYwJvecOA4J9Iewpoa/yKIKSMVF/H4XzxREuY3VfBkiORvXvPDfY45bspZjDKLE6/f8L6W7Dj16Pq6xcZ6aCPht/N7Cs4b9bX3A6pCB8kkMEP/uvet3wTZmrGn6JzzQpGIWnQ6Hoyx/Tl2b/BnWg0GncIhVTldNQvlHYIr2mYc7qH8kAlaW1pssVtbXYPQuH2AAVQgdjlxNCxBSwtsMndG6TdEAlJhZLHTvpTpzEWKWYDgkouCzrnGyJ+gPiN+Ng+3vq+8CEw78+TDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1dZufFgS2eaZnpieP2mfzZkBHxdC9BhJNxRrIyeK1E=;
 b=P4Fu0WcCS1tXcKfsAHencG9SdU1VpdzWfy4EsuYsl9pce1hfyij9lqRSIzu81b2X7AAAsL/VI2Ezbhol/4lTzSshLXBcVU4IBy85Z9T++FMh6NgcFUgV5YjsfDGuvSj768MAmm3uySr7ODPNSbT3QwZ+XM2/3uMrXVzeX1Cc7VM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Fri, 19 Sep
 2025 22:06:22 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 22:06:22 +0000
Message-ID: <412fce46-e143-4b71-b5ac-24f4f5ae230f@amd.com>
Date: Fri, 19 Sep 2025 17:06:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <6a9b3e02d1a1eb903bd3e7c9596dfe00029de01e.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <6a9b3e02d1a1eb903bd3e7c9596dfe00029de01e.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:805:66::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4268:EE_
X-MS-Office365-Filtering-Correlation-Id: b87ca45f-e95d-4b7c-7848-08ddf7c8c483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3phak90UldJUTRYczdXaEx2Wml4WlZoQnZHcnhiM3RNTjBkSTVsRitqWmVD?=
 =?utf-8?B?RzV1SnhWOG4xZ2xGUXFqdks4eXNXaUFObFdyclRnS2czdkt3ZStCc29zcnRx?=
 =?utf-8?B?NlBJREJOckJsdGNCTmdoNXdvSWhiWlRjQVdWRWxjRUlOUHRwQWp4S2hwTEIw?=
 =?utf-8?B?MzRNMkM5ZWdscURoaGxQVlFPa0VpQnJaU2o1WExDcjNWQlVYQlBLL0JPclNw?=
 =?utf-8?B?OG1YZXgvODdqM0NSTjlvUTl5Mnl2cmNBY290bG01T1pya3BMMmdXSnA3TGZu?=
 =?utf-8?B?VnhGWCtUc3BXL0IvVTFzMFBCb2YvQXFkZGhiTTUvZm91b09oaTR4S1pmK0c2?=
 =?utf-8?B?SEJ0REs3eXUreVh5bXVJcGpBQzFjZFZNeVRuZFhVWHB3dThtZWl2bTg4M1c3?=
 =?utf-8?B?YTRYVU03L3p3aXRoa1MveTdUTEx4Nnp6ek9MSGYxNk5qcVk3bUptSTR5aVRB?=
 =?utf-8?B?T1k0K0hjWGxROURlbGJ0Q3RXUXFwZEQ3bStxU2FLb2x5OTQzK2hrRkJhV0E5?=
 =?utf-8?B?K2cyNkVJQUhWank0Uy9CSVlGdG9HU2s2eGtwcmZkU21MZWhoL0NBT2VGU3ZM?=
 =?utf-8?B?d3lkc2ZRS1dVV2dvRE1EWTh2U3kwRWZzc3dUc25sdXJpa3RSc2xqY2dCdU5N?=
 =?utf-8?B?NVA3SDl6cWxrSGlGM2YzY2hMZjNHZk5PSFJGd2krZHYyWEFyMzU2YTdyT3VZ?=
 =?utf-8?B?bmgyKzBTeEVGRDgyZUNrVHdpTGJjQ3EzSUpMTGdnUUZULzBZNkd4Q2lqY2xT?=
 =?utf-8?B?QjBmLzV6d3lLeDV3eWNoZjFhL29XZmk5b24wc2haTnl0clJSREtra1U4c2tT?=
 =?utf-8?B?YlJvL3JwMDdyc2hSMUdpU0xuYTl2SjNUQ25OVkJBaXZoREtKYmVuZS83TlVw?=
 =?utf-8?B?QThOOFZsS3RZVWp2R0lENEhHT1JGRnUxTEM3a29ERitMbTVhSk45MEJsREZp?=
 =?utf-8?B?WEdBekJONC9Taklkay9RWTRLRy9YR3Z3TWFLRGlYTGhudUJJQU9CeG9HZ3dm?=
 =?utf-8?B?dzU4N1pkNWpFTnhyazlxN2wrcjhZQy9XL2liVjByTCswYmxmUTdyanhiQWt3?=
 =?utf-8?B?elNlcXpHbk9QUnFERVVxU1Z6amN0ekUvcXpIQ3lKbnl1SWJTbEhPM0dOb1Qz?=
 =?utf-8?B?RFZWVTNmNXY0WXBNZFJSckNzMHdWVGpTb25Md3VpZEthTTgzUUdhbTIyYzJQ?=
 =?utf-8?B?NXlZejBIbEZlWGZuaXh2WlRDcUhrRDRzUnZGZ3ZXSzFCTnVkaU4yRVhaODBi?=
 =?utf-8?B?ak1HcjdDVTYxbkdNakREZVRUdTN4RmdvUTltSHZ1dFdqZENCVnFiYm1jM2tB?=
 =?utf-8?B?RXYyT0FJa1pKaXd5SHhUMnp0a3Jad2llZ2tweW12c25BSnNOYmVYQlpjdWh4?=
 =?utf-8?B?SnNuVE1RK3JQeG9QeE8vdlBVOGMwT1BFR3FBbVZ3T2dnVHlNbmNsTU5ZZVpF?=
 =?utf-8?B?Z0NDVGtxOTZ6VUZmZlI0V0VUYTNVbW0wNFVtOWs4UGRCUFZIcjA4Y0ZON1VY?=
 =?utf-8?B?QTJHK294R0dtY0FJaG54MnZoWkpqbkg3YUlyTS9neE9vTE9pNVQ5WlVVV2R5?=
 =?utf-8?B?RlllSjMyaGtTRmNvUmFlOXI1N3Q1U3ZJWGZFMEYrbjBKM0xjNDVxR2cyTUE2?=
 =?utf-8?B?eURQNkJNaVppOTdPUzVwNVl4c2d3Y2Uyb3gyK05kU3k3RjQ3NjZGMFJNamtH?=
 =?utf-8?B?RGVRUUpKSEY1Rk1RaFR4QTUrUHJBRlVpL0lWaHBvU3hDS01qd0ZETVhuMDJi?=
 =?utf-8?B?U2wxSUFQREF2TzVpcjhqc2w4bDJIa0ZVdjE1TEZPcjhSZGNFd3ZoZ0ZGRWRE?=
 =?utf-8?B?dThjbzJCdXlLajdGbWpSWUZlT2d1Y09sNTVBU3JFci9XYzgvTG43UDA5eVFy?=
 =?utf-8?B?UHJmbkxleFhrRzNGRWFPUlMxS3ZUK1VENWNqRjVPanhhK2E4cFNrVEY0TjJH?=
 =?utf-8?Q?qP6FTQufdig=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U29kQlRNUU40R09QbTFLUmRLamJDeS9VWG8rOGJteDI2SVlkL2RJcFpZYlE2?=
 =?utf-8?B?Z1c3dlMvb1VLcUFLUVc3d3lOa29oWGlZTWtCVTVvVFF1MW56L0VCZ2thMUFT?=
 =?utf-8?B?UmR0THVLYU5zZGErdFF5TDV4TWVROGNRQlJ2TitYYzFXcjQ1N2RSYjhEVnNC?=
 =?utf-8?B?RHEwbzFuTlduZnBtRXo0TkxnbGRkUUNQdTltYzdWR2hwb24weTlJQm1aMkgx?=
 =?utf-8?B?eEJqNEJNc3I4Ri9USWp1TkNQeE9LL3dEY2NYT210WWhkbVRLQjFpN1Q4V2dE?=
 =?utf-8?B?T0xDbC9EaWdtdytoMlBmTjdqbFpKMTFja1BSdlJrdlI2TGhUOG1rME9POFMx?=
 =?utf-8?B?U3pqMDdXQ2FPN2QrNnR6K09EVzA3dkk1Ui8vaTZuVUUwTERXakg3c3RpMDN1?=
 =?utf-8?B?TGhCaHVIbGFNcXZZRXl1L1h3ZkVBQjhYVExXNHV3UDFRZFNtTGU5SllzSUEr?=
 =?utf-8?B?cG1GMkt6WUNJUHRzaWlDbUN3QTBzZ2tHbnVxLzBsVjNCQzBaYWJYaXh3WjZJ?=
 =?utf-8?B?OGtXSENjUEJlK1JDRGo3SHg4RWoxVEY5VXh6U1MxdVgvT1ovayt1b3BZRDBu?=
 =?utf-8?B?cDNJeGNOVks0VStUZkk4b1N4MllucElOV2JTbFlYamhrT3hwanR1Z21rZDlz?=
 =?utf-8?B?TW9FVTRHcjdQTVc3MWhXM2VjQUM5V05weHRSWEFrT0pQOXlCcUFsbDJ6MzFB?=
 =?utf-8?B?SEQ1Qi9mOUhkSk04OGN1VVJCYi9KMkc3aWxtK3dNaVVha0lSbjdZdkR1Ynpw?=
 =?utf-8?B?K3cvREh0cmpIQmVyQjNqcHFueGZxSGRUY0M3YVREVFNQVWJONmNOR3JRd0pT?=
 =?utf-8?B?NGVYYzh3RmtXcmhpMGpyUkM1cmFaWDRXNkxNWDdXUVFnNlQ2aHlnRmwvRisz?=
 =?utf-8?B?bG9sRDA5QTBMUmxkbk5DZ3poYmdSTXdXbkZNYW5hTFcvOGRic3kvdncvakZH?=
 =?utf-8?B?dzAwcDJVaFo5NVI3ZjI5dGxIRGIwaFlJSmg1YnFRaFF0V0hpOEJOVlR3eFJu?=
 =?utf-8?B?amN2d2hmYkphMndaUGdkQTBJMXZ5NDhNZ1lVZTFwR3FLWDVWZklTZUJuZjdr?=
 =?utf-8?B?cS9lbUpxOWFOUHZxT2lDMWVjb1A4eGV5SG5lc0dJSUxUMTZuZmVvUzZUZVlD?=
 =?utf-8?B?SWI5aDhzVndKbTdoSlB0aFdNZUx6RlVsVnNVMXp6U2g4WFJjZExLTGQ4TGhS?=
 =?utf-8?B?Sm1aOU10VmN3TjVpTENEak1iR1Bqc0wxYTAyMGxuWlZENTM4eG1rZzFhNFdK?=
 =?utf-8?B?V05EWlZ4RW1EK0VCaXB0VEUrQTEzL0phOXFUcmZpQUJlb01RUXE1bkFWZ1Ry?=
 =?utf-8?B?STAvaVpyMDNRRDdlQWUxQVl1TlJGZmxnaytEZVBDa25aOTE5ckxnT3ZQYzY2?=
 =?utf-8?B?OElzNVBFNlhWSHJ1dUhWbU9sdklNL2M1bXhuanJxY3Y2TjF0SFFnME5FL1Zl?=
 =?utf-8?B?ZDloRzRUT1Rsa1NmcGs5a1psSWpIRS9rbi8rNVpicElyejNVbG5lYzE0K1RN?=
 =?utf-8?B?cHZxWE9PTzdJUHcwVXMwc2NId1RaRk9PbEk5eFVNcXkzNWxsUXo3S1c0SGV5?=
 =?utf-8?B?S0VqSFZaV0l6SzNSdEpKWmFYR1dUOHo4akk5SnBHTmRQLzd6M3N3ZnRnYksx?=
 =?utf-8?B?Y29PRFFaTVVQZXJZM25jamxQNExlM2VxMS9DdTYrZzkrWlpnZmJxcm50VERy?=
 =?utf-8?B?dDgyblhQWXQ4Nmp6b0YxTnB6UFFEQk96WEFWTzB2TkJpSjRjM1c1Q04rUmQ0?=
 =?utf-8?B?RVcvUDQvWUhTQzZ3a0NTSzIxdWJ0eGZ6VWtjNDBac2dPQk95YTBVM0pManJG?=
 =?utf-8?B?ZDJKT0RjbmY2b0ZlTmtWZUx2bEF5OFZON2ZiWnE0eGdCbnFEZWtDdFI4Wk5R?=
 =?utf-8?B?dFRsOUU2eTY5UjZ5RWRUZWlXQ0JvL0h4MUdJNjY1WGVIemVrdmIvdTcveFVk?=
 =?utf-8?B?dGN2b3FYNFA4aGtBdlg2Y3huT3dKY013OHZQVEZZa09jd21iYUlINDgyYmJq?=
 =?utf-8?B?NDZMa2VjbGNJWjgyZlU0Zm0vUHlqVlNBbCt5NWVZcEE3VlMxdlRPV0U4dVRo?=
 =?utf-8?B?UnZTWWJBeTZ4Nm83M3VlWDhjbmg3eGVWSWhMaFg5bHJEcno2amRyYVFDcXhY?=
 =?utf-8?Q?C5h0O0Ou6BDGW73RvdcseBZOy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87ca45f-e95d-4b7c-7848-08ddf7c8c483
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 22:06:22.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pieaIAj5wEA+CaIFfdTPCDjy+XAbBFaZX1+1nTjMGuMPMJMN3OTzxHUNzqunj6Yoy6c7NQv2qgb7bGKX3aC6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4268

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Add support for configuring the TSC frequency when Secure TSC is enabled
> in SEV-SNP guests through a new "tsc-frequency" property on SEV-SNP
> guest objects, similar to the vCPU-specific property used by regular
> guests and TDX. A new property is needed since SEV-SNP guests require
> the TSC frequency to be specified during early SNP_LAUNCH_START command
> before any vCPUs are created.
> 
> The user-provided TSC frequency is set through KVM_SET_TSC_KHZ before
> issuing KVM_SEV_SNP_LAUNCH_START.

A sample command line like in the previous patches would be consistent.

> 
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

It would be nice to have a follow-up patch that cleans up
check_sev_features() so that there aren't a bunch of checks with "if
(sev_snp_enabled() ...". Having all the SNP related checks under one "if"
block might be cleaner as more SNP only features get added. Just a thought.

> ---
>  target/i386/sev.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  qapi/qom.json     |  6 +++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 679bedb63c3a..ef54265f4e46 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -178,6 +178,7 @@ struct SevSnpGuestState {
>      char *id_auth_base64;
>      uint8_t *id_auth;
>      char *host_data;
> +    uint32_t tsc_khz;
>  
>      struct kvm_sev_snp_launch_start kvm_start_conf;
>      struct kvm_sev_snp_launch_finish kvm_finish_conf;
> @@ -536,6 +537,13 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
>                     __func__, sev_features, sev_common->supported_sev_features);
>          return -1;
>      }
> +    if (sev_snp_enabled() && SEV_SNP_GUEST(sev_common)->tsc_khz &&
> +        !(sev_features & SVM_SEV_FEAT_SECURE_TSC)) {
> +        error_setg(errp,
> +                   "%s: TSC frequency can only be set if Secure TSC is enabled",
> +                   __func__);
> +        return -1;
> +    }
>      return 0;
>  }
>  
> @@ -1085,6 +1093,18 @@ sev_snp_launch_start(SevCommonState *sev_common)
>              return 1;
>      }
>  
> +    if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC)) {
> +        rc = -EINVAL;
> +        if (kvm_check_extension(kvm_state, KVM_CAP_VM_TSC_CONTROL)) {
> +            rc = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, sev_snp_guest->tsc_khz);
> +        }
> +        if (rc < 0) {
> +            error_report("%s: Unable to set Secure TSC frequency to %u kHz ret=%d",
> +                         __func__, sev_snp_guest->tsc_khz, rc);
> +            return 1;
> +        }

It looks like KVM_CAP_VM_TSC_CONTROL is required for Secure TSC. Should
this cap check be part of check_sev_features() then, rather than waiting
until launch start?

And does KVM_SET_TSC_KHZ have to be called if "tsc-frequency" wasn't set?

Thanks,
Tom

> +    }
> +
>      rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
>                     start, &fw_error);
>      if (rc < 0) {
> @@ -3127,6 +3147,28 @@ static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
>      sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
>  }
>  
> +static void
> +sev_snp_guest_get_tsc_frequency(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    uint32_t value = SEV_SNP_GUEST(obj)->tsc_khz * 1000;
> +
> +    visit_type_uint32(v, name, &value, errp);
> +}
> +
> +static void
> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    uint32_t value;
> +
> +    if (!visit_type_uint32(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
> +}
> +
>  static void
>  sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -3165,6 +3207,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>      object_class_property_add_bool(oc, "secure-tsc",
>                                    sev_snp_guest_get_secure_tsc,
>                                    sev_snp_guest_set_secure_tsc);
> +    object_class_property_add(oc, "tsc-frequency", "uint32",
> +                              sev_snp_guest_get_tsc_frequency,
> +                              sev_snp_guest_set_tsc_frequency, NULL, NULL);
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 52c23e85e349..c01ae70dd43d 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1103,6 +1103,9 @@
>  # @secure-tsc: enable Secure TSC
>  #     (default: false) (since 10.2)
>  #
> +# @tsc-frequency: set secure TSC frequency.  Only valid if Secure TSC
> +#     is enabled (default: zero) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1115,7 +1118,8 @@
>              '*author-key-enabled': 'bool',
>              '*host-data': 'str',
>              '*vcek-disabled': 'bool',
> -            '*secure-tsc': 'bool' } }
> +            '*secure-tsc': 'bool',
> +            '*tsc-frequency': 'uint32' } }
>  
>  ##
>  # @TdxGuestProperties:


