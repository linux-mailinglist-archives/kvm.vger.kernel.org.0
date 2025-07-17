Return-Path: <kvm+bounces-52705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BBAB08572
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AD904A0781
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0337F21885A;
	Thu, 17 Jul 2025 06:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lETYgikQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910E020ADEE;
	Thu, 17 Jul 2025 06:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752735108; cv=fail; b=OhYV65yC6YffADROkKBesfOZndD92yQuz1gMTndh1Pr0YutYNeR5TRTfi79V1SO8ca2wc0mrCw0yH5hyHJHmk/gcCtspYMEIOTcjXnt2eowxEW9Vs+rgkTa85uR5TZv81D0FV2a36nvvqpd8gFmU+kFEFqpMV+xNMq/Vc8/LHfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752735108; c=relaxed/simple;
	bh=ZRBGz0VNfNBHkd6eEpzl7C/i25qktQtHMRosIiZfQHY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qHBX49yDLUusTI8IVmgBpX0AN4UPsGWrQWZ4BbGZ+J3yOY1Gru9y/qjEuAgh5sGhtg0i9fp/jT6NgavvLsig35XK1pYplSm9xJBB+nlPlQAZEK6mOooDkb/CRveG7/pNr6PIl6k0M/vxbATXaKBf/+1ve65SssCUm63CtvnBh78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lETYgikQ; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTZHRHGG9T8UK/UczlrYFJ9ni4WvJ3ByJ9ayma2+kwNOPoFPRlR0wk33VYYyjlzocwhaTSeC37Fjv+11A5zxsSnuCcWnUPz5aH/uB/cEYQz/6OOAlCltXqbFcSz1uYUIKVlpQOuYNiepD7CaZvkqneqCO89dRBRHl0+OnqJeugjS7785XCp84Q+S9oEe3Qk3cUWihKcTKw5uGy3XMbDBRpoPy3eDK96fp7KL80or7D5s0NTF8b/iMkgfiNN0/ha6yWHT8c1ikXNObNR0KSvyv9ZG8+2bMjkQo0aABmgSUd24EN23CFTgV+IGuO8fluw6FkkMLoumDKbv1dez21OR+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2JZPaKmkc5tDMert7J7o5RK+YUMDX3Nex5b3StHjrk=;
 b=xSegUenucOuRLHEptp0/8bJa1yDtK4GOA1eML0dvZImYV+4H5OUeESMxQdkuGhnm7ckrzO3ljEluWEbAUOg6ZSUypBUaocSIl+KIwSGfltCc0bLO3OVsHE3W1wIJc0LZNovM5DUN5jCPtxuDfLApuwFk6EEUoGuuaWKpbYnqis8m6rOc8LnxeEcFFidLUcyQ26VfI+Q667sVZjT/5bvyfBO1A5AQozS2Tc0i4dPA9hFVfArH/AQg2TmbYV20z5wo4qNVPXZdoPGbsh4+L1aXNMPhJZkt1U0kCNR44nCO4YOwrETANaUpfJPE+cCyZnR+Nm+0LIswFcaBHF+5/8J1Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2JZPaKmkc5tDMert7J7o5RK+YUMDX3Nex5b3StHjrk=;
 b=lETYgikQBOo61GjnroISkFcJj6arA9k00NDLemD7PTcGwyY8gKNW3bX0+UdEO89R7Jywz1Q+V8JPVB0mCCWJ4DNh9wdJ8qemAhZt9G0x9x60vVJQYalBxFx2KHBFrXz430+rlUhbfSBJmjvL8nQ4X4skaDEIy9StJ7G9O/sI3Dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB8062.namprd12.prod.outlook.com (2603:10b6:a03:4c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Thu, 17 Jul
 2025 06:51:41 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Thu, 17 Jul 2025
 06:51:41 +0000
Message-ID: <d0f5fec8-5b37-4a83-ab4e-cd5528bf4057@amd.com>
Date: Thu, 17 Jul 2025 01:51:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
 <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
 <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
 <40cc4c41-c16a-40b1-a2c2-591f29216b94@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <40cc4c41-c16a-40b1-a2c2-591f29216b94@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0129.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::9) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: 622f5a91-c452-41cb-ef55-08ddc4fe6236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGwrcmQ5U1k4YlNoOElEcHY4WjZCVkRWM0JWWXE1SUk2OXB1dXlHdEZRZmJU?=
 =?utf-8?B?VjNUQ0RndEdhQUdDQTllTVl5U3dzSDFPZi95bVN0ZjE0U0lidzJvQlNWWTNQ?=
 =?utf-8?B?bHp0NEJjSWsvQW9FMXhyWjl1QU1raWNjTTROTEZWOXFkc0hkM3BlUzV6b213?=
 =?utf-8?B?OFNRMW5MeXVTQThTd2p0T0hTUXNheFhMMy9QT3ZOTElzRzc0RmJSbS94WEcv?=
 =?utf-8?B?RWQxTTN1MlhZU3I3UnFtdEN4dFBGa2M2cTlCeVF3Qlh3VmpVMlY1eEwveGg3?=
 =?utf-8?B?eU9ndXJOYVBVZm42dWcra3YvMUl1VW1FcnBSaCsrVnpHeG0rVDJjMG1ZQkE0?=
 =?utf-8?B?dDVwNkt4MUZLVytFRGRZY2c1azFZU3AyUGg4TEN2eW1weEljTmR6aUg1d0I3?=
 =?utf-8?B?bEllRGVEYW9DRG5kdzdudzJCYnlEdUw1czRnSE5TMUd6MnNEN1JtaXJ6RExl?=
 =?utf-8?B?dmFHODFyN3dtcGJwZWl0QnZkL2Vmc21rMkIwMkttUG9Bd0FhTkYzUnlzbjVz?=
 =?utf-8?B?eFN3TDF6dG9KRGdsb1FvdXU0ZE1WZXNOVk9Ed3ZwazZjdUZEOFZSeDFaK1hF?=
 =?utf-8?B?L1VLUFRaSVNqYzE2alVlditwZG81ajlNN2VLL282NEI0enRVVWx6YitKcjVv?=
 =?utf-8?B?bS92enBTenExbDd0Zk1GM050L1ZvdXBWMmdIRmZDL1oyQzhtangyNk1NcGhO?=
 =?utf-8?B?UWhURy8vSnVhWlRnZ0YrZFc5alFXc3Rib24xVFVjV291bFlwbVp0cEVPOXJE?=
 =?utf-8?B?d2N2TnBMcTVPNmVvQ28zRDVVT3M2aHJMWG9XeGtJSXhUTXRwdGNQaXNSL2Fv?=
 =?utf-8?B?bDZEbjRUb05CelFyVnREelBWWUJLSUdSZ3BmOGc1b0tyVmQ0RGYvVmVib0Fo?=
 =?utf-8?B?bHdWU1psK0VRQVZvKzg4K0l5RkNQNXhuN3JJSlk0TXQvOWt3WFRzWFZDd2dB?=
 =?utf-8?B?NFN3a3lybjYvRHphSWRhUnIxVWM1UzExMFNyN1htWmNQOFloQ0pqQi9GdmEy?=
 =?utf-8?B?Z2QvdFIwMlZpT0FLSDNwTWFQWHMyVWp6OXI4QVdrUG83SVpNaVpYeHlldUoz?=
 =?utf-8?B?YmQvZ0NaM0VQb3RlaVVVcUhpbzNCcXhRSjdVZ3FNbU1MQTUzYXdXc0VtbW41?=
 =?utf-8?B?YXlTeDJWMkxUbEdNS3BOazZWRmxkNTNtV0Frb3dzSUZXdFZGUXFjZFZueTVV?=
 =?utf-8?B?aDlGL2J3M2ZsZHh5M2lWNWpPRDI1UjlPZStNWVJLZTVLb01TMkJXQjlvVC9E?=
 =?utf-8?B?NEdJQittTEZyOTZhVGpuQ0grbWdZbERvMXN2eXdsdEJXL0xYSWVVYW5VamFF?=
 =?utf-8?B?MnFYQXpsK0Y1YW9uS0lKZG9OZnRlMnViVGIxY3lweDVYVE1DcVJvb2JPT0E2?=
 =?utf-8?B?SDJmSHpCVyt3MjZHbjlQVE5ySUJ3aVVLU3RHZiszM0VwcXZVRUlFZWVuTW9p?=
 =?utf-8?B?T3dGa3NURjhWUzJrcjVNZUlROXFhRkRscnhBMSt1cWdTWitmT25yaVFQU0s2?=
 =?utf-8?B?RjhicjNTQzJNQmpXNW5UdkpKTG5lZmIxSUYzOVZoYVVuc242ZFlXdGtONmhQ?=
 =?utf-8?B?RkVBb1dMNTFUOG1jK1NCZDBwNnFKeGFKSGUwMzdPdkQxdVo5U1BmdDhRWXlS?=
 =?utf-8?B?UmY0dmUvcXlQL2lTUktJTml1YTRyeVlSMGJRdnVLcmdRRkU0TExsaWplQzdP?=
 =?utf-8?B?eVFiS1lPUHFEcmdIdGRYdFlPQkFTVGFsZUdheTlLUkU0VlBzbTc0a244MlhI?=
 =?utf-8?B?bFRJY1JSK0FEZG1LS0FkSEVDR2YyQVdlNVMxQ2ZFL2hnVUI3bWtlN3VZU2Ex?=
 =?utf-8?B?L0p1TjhzdkV3bXFvdVYrb3FGU0cvZGR3M0pCb0ZjVXhPYlBJTEtvVkl5V1d3?=
 =?utf-8?B?UUUyeExzYlFpM0M0dzlteFZCMllnUjNFZGhDYU0yRTZOSDJQaXlFS0FCcXNH?=
 =?utf-8?Q?VAqAu1EBnBk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2cwTkg4MFprR1IrYm1vWVBCdVN1VlM4VGs4S09zL2tNV1l6M241RGZZMUhG?=
 =?utf-8?B?Q2FwVTJMd0F4STFVdXhadVJ5b2hVNWxqbis5NUFaVm9hbmJsQ1Zsdkoya1VN?=
 =?utf-8?B?cGk1ZzJNWG43czRJYmtXZUZUb2hiUERKL3ZzZXhtNVQ0WnJoWkpna0luS0k5?=
 =?utf-8?B?cDM2RWFIem1EVGhMMFhKM3NQR3lTdlhIMmVsdkxwNVkyU1JKM3JDQkQxZ0F5?=
 =?utf-8?B?b0JIWmNLZnJjS3ZGVmZIYzlabE1vcmFDQU9WMDdrV3dXeHhhek9RT080QTN3?=
 =?utf-8?B?UFdVOUZGUWhHNVJ5TllEVnc3alU5dGN4Yzc5YnlMeUxjNkNyTXgzRWRzbzE2?=
 =?utf-8?B?cWJGeXNHcUk4UGhVZFdiY3ZMRUdBWE56QlN6VWVEdG9XcER2UW9wYW8xay84?=
 =?utf-8?B?M2d1L25NOW0wb25OTFhiYlVCWCsvb2ZSY0t1ck84VjlmbXZTS3pVSVFvTlky?=
 =?utf-8?B?U1Y1MWZEWURvT2llR2R4SkxyVEE5Tm1YeVhoNUtqZlcydC9MbnBLd2QvU0FW?=
 =?utf-8?B?ei9KMzR5elV5YitBUnU3Q1ZCb0UwQWh2Z2VlWitCTzB6cmJtUUxvMUVOSWRW?=
 =?utf-8?B?T3Y0VTB6ajFLUmhxTVlQS3RGT0lUYmFTeVNUMGdWelN2RTVzMzRhNGhHa1RK?=
 =?utf-8?B?cE9LSUFMSm4vcFRpK0ppTnQrdGt4akxBTzZqOVBxQXE3THJlUkhKS1dKQ0la?=
 =?utf-8?B?aWoxUVh2MmVKZ3BlSU5YQ3ZOVWJnTzh2ai9pOHpXN3hBd1NqT1VuVEhySU9L?=
 =?utf-8?B?QzMxUEMyWmZSaEpuK3cvVVlJSnk4QSt0Vml4K0xER3J6TDJackdVdlpocWZl?=
 =?utf-8?B?NVo0Um9qMFhmSTh3a2NiazFDZzF1QnRLd0hWNy9rVVdxRW1PdVVzNUJNTFB5?=
 =?utf-8?B?Q3VtNlB4YjZhSlhsK1Nid3ZmeG1hTlNtdU9xS3dDNHo3ZGV5cDFKUnR3RnBo?=
 =?utf-8?B?SUI1ZysrbExORkh5RUtwZ20zM0Q5ZkZFT3AyVC9UMFJ4U3hJZUN3cVdibjcv?=
 =?utf-8?B?SjlPNTMxZVdSZ1MwVG0yVzVPVHZWRlA1ck9EbnFhN1BHT3pNM1ZxbUlkWjBv?=
 =?utf-8?B?UjRLeWU5Nm1MM1pWZ2M3akw2czhtRXM0NG5uVFNiTUpsc3cxZkNneVQ5Umts?=
 =?utf-8?B?L2pRVE95UGdoQitFNXdXekhOZXFBRFJoMEdxVVhzR0V1UHA4MUdxQnd4RXpL?=
 =?utf-8?B?YmhaUU9JdlcwTURJVFdPOEpMOCt1KzA2R2NGWlZTTG5NYzNYdWVrRTZVMlFZ?=
 =?utf-8?B?UkVFZE9XNDVUR3d3K09qWGlpYVZBSDlrRmhrZFp6ZFAwWWR1NjIxWm9wdDlo?=
 =?utf-8?B?VG1hR1J1QWJXdkZIUGg4cjBZYmxSRTRmSDYzRWxyTTVVSG1NY3dDc2drOHhS?=
 =?utf-8?B?eER2SnEzNzJKU29Cd3hYUkU5cU1yVkE2SUlGN0dic3hTWEkwWVFJRzlSVXBp?=
 =?utf-8?B?M25UNzNVNFpUNFZCMy9GemNVREFvendIbU1wVVZod3lxQ0pzWVIwVWxFbnB2?=
 =?utf-8?B?ZmhIWXlIYWZSNm4xc0xYTS85d1FSMEYxZHlUSWJoM1RTcTVnTFA1N2gwVFRQ?=
 =?utf-8?B?bmhnSWY0T3lrckhPUXdreU1tVkxVMU9JcUFDWnhYdVRBckI0QUVnMG5DUzhE?=
 =?utf-8?B?cHJUdlZTUVN3MmUvSzg1dkY5ejJzdUxjNmU4eXlpWmhNTE5YR0FNTmdmb2xF?=
 =?utf-8?B?UStqQUVBNWdQMnk4VmxaeXZjN2k2ZFA2RHNxSHkyWFpsMTRUWHJoNFd6QTJM?=
 =?utf-8?B?U3g2c1BsZFBpMFFOS2prM3MxelZ3aUF5Z3BHK2JobzNScXR5blAweUI1VWNP?=
 =?utf-8?B?R05rUXJsMWo2c0UyYUpyMFNaSTFtcUwvYU85MHdBalBjTWV0RHhNV3hGc2s0?=
 =?utf-8?B?Rk5sL3lrajZOV1BtQjVyVjBkTHRoNU5pVTQ0bDFldTRJWDZ4TmFiR2tYOExs?=
 =?utf-8?B?VDU1dU4wNGJLeXVnUy9DTHYrQkZWT0xIT2ZJNlZoODdWb1dXOSszZ1N1Y0RD?=
 =?utf-8?B?L2NzdFZTVnU4SmJMZFVXdXJNZDhtSHpXMnVhTC9rS0FBcHY4cytjSDgzazVs?=
 =?utf-8?B?cGlzN2xQelJLMUFIOFJpQTFoendua251TldkSGwvZ1ZHdm1IWjdycXNpVjVa?=
 =?utf-8?Q?maI+PHBKXKaLvl7jVp0vKPXEt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622f5a91-c452-41cb-ef55-08ddc4fe6236
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 06:51:40.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKxMKUx+81HwkL5IzConQ4C+o+cn7qnfsXUlu7VMFIBlWvSUgEzhDVyKLUkwfsATHG/WkNTT44gMUVhBfzem2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8062

Hello Vasant and Sairaj,

On 7/17/2025 1:05 AM, Vasant Hegde wrote:
> Ashish,
> 
> On 7/17/2025 3:37 AM, Kalra, Ashish wrote:
>> Hello Vasant,
>>
>> On 7/16/2025 4:42 AM, Vasant Hegde wrote:
>>>
>>>
>>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> After a panic if SNP is enabled in the previous kernel then the kdump
>>>> kernel boots with IOMMU SNP enforcement still enabled.
>>>>
>>>> IOMMU device table register is locked and exclusive to the previous
>>>> kernel. Attempts to copy old device table from the previous kernel
>>>> fails in kdump kernel as hardware ignores writes to the locked device
>>>> table base address register as per AMD IOMMU spec Section 2.12.2.1.
>>>>
>>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>>> through Interrupt-remapped IO-APIC".
>>>>
>>>> Reuse device table instead of copying device table in case of kdump
>>>> boot and remove all copying device table code.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
>>>>  1 file changed, 28 insertions(+), 69 deletions(-)
>>>>
>>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>>> index 32295f26be1b..18bd869a82d9 100644
>>>> --- a/drivers/iommu/amd/init.c
>>>> +++ b/drivers/iommu/amd/init.c
>>>> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>>>>  
>>>>  	BUG_ON(iommu->mmio_base == NULL);
>>>>  
>>>> +	if (is_kdump_kernel())
>>>
>>> This is fine.. but its becoming too many places with kdump check! I don't know
>>> what is the better way here.
>>> Is it worth to keep it like this -OR- add say iommu ops that way during init we
>>> check is_kdump_kernel() and adjust the ops ?
>>>
>>> @Joerg, any preference?
>>>
>>>
> 
> .../...
> 
>>>>  			break;
>>>>  		}
>>>> @@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
>>>>   * This function finally enables all IOMMUs found in the system after
>>>>   * they have been initialized.
>>>>   *
>>>> - * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
>>>> - * the old content of device table entries. Not this case or copy failed,
>>>> + * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
>>>> + * the old content of device table entries. Not this case or reuse failed,
>>>>   * just continue as normal kernel does.
>>>>   */
>>>>  static void early_enable_iommus(void)
>>>> @@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
>>>>  	struct amd_iommu *iommu;
>>>>  	struct amd_iommu_pci_seg *pci_seg;
>>>>  
>>>> -	if (!copy_device_table()) {
>>>> +	if (!reuse_device_table()) {
>>>
>>> Hmmm. What happens if SNP enabled and reuse_device_table() couldn't setup
>>> previous DTE?
>>> In non-SNP case it works fine as we can rebuild new DTE. But in SNP case we
>>> should fail the kdump right?
>>>
>>
>> Which will happen automatically, if we can't setup previous DTE for SNP case
>> then IOMMU commands will time-out and subsequenly cause a panic as IRQ remapping
>> won't be setup.
> 
> But what is the point is proceeding when we know its going to fail? I think its
> better to fail here so that at least we know where/why it failed.
> 

Yes that makes sense.

As Sairaj suggested, we can add a BUG_ON() if reuse_device_table() fails in case
of SNP enabled.

Thanks,
Ashish


