Return-Path: <kvm+bounces-60040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6AABDBB41
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EEF824F89C6
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B2823D7ED;
	Tue, 14 Oct 2025 22:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q7f8rdzB"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012031.outbound.protection.outlook.com [52.101.43.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78E205ABA;
	Tue, 14 Oct 2025 22:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760481939; cv=fail; b=AwgxZ7QxZml9v2AvuZjyW3Q3JfHYlFemkMyUyeu23QqGT/W+sq7AVrdKTqPqdazAIquMKRLp/e0krIQXhzjPtRTEIcuZfzMzC4HtnEW3bF+RBMbt2jE1Y0eFMOOSWIZyFgmu0pArC2TScwfR9C+IQmna1QsvRWrzBdssrfun2Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760481939; c=relaxed/simple;
	bh=ZiH/C+4gY/BEMfTS+PdKW7xBuAtEZMkS1jhDuSFvDOo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=evoYGE56iZx2FKI//tQCBPIWCvSizt4pqA4eXLTwi7GCsxc/uCJEfZrld0CjPeu6JIwUFqckmKMNLjKe6LNPv4WDgdPWEAqgex20WkIlxqXo8sTpIAH7qaiORd+yQU5OdRV3j095kdGbf9w73QOCvgXRM4w6iscu7GGbxrLpd2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q7f8rdzB; arc=fail smtp.client-ip=52.101.43.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxzAnrkepjShIMANgfg7/zkCtSjA4zWP1+KCNsN/dSl3Fep8BG8UiJu+DIonKznp0ljczpfCAfkBKyv0Vbf6nZOCxxu8PLoQbAzY24/1D6YlZjxCepV5YDRr8ww3RaRP9EDi1fNsL1ccw793QZXy8IIsL8OUp2aKpqBO/Df+4fPccppWUBtfQCVq2ZXA8LB8mJhZnS08o2Uv3wXQPiVPDZfTtUytj/QYXoIU/Svofk7f1N+Qw/o5AhS5kRUpnWxQkBEWV76X63qD3I8HQju1Qzq/k9mxZDju3twxEMyT8oIqmKAKF6hQ1Joxiij1cEppHjU/NZQV5sc9jkTV+Yz7HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zL1OSJLhFRj1T5dzH3Fiqbek2rhkC8388K4Eb95trME=;
 b=ypRrNNEI9R/m7ldJtAsu6brSgE26dmYfiNX6ufN1GQWn/txIEm9quv033Z/r2LaN1teVygWBK0yoPlgBUuDeB3XX0QV43M/G21fT/cJdb0cRTK9I8gcl22wd2Bp9DP+jtCCGiyJ4q9BAO5weC3gehjfeVOmxS+lOA+LQLqWxphdGzdHAB7mm5SBbmmhk33cN8HXgU3ef6LhYmK2BhPdYY70ud5adoA+QvZ2xlbFHF52zmzyWNqwRiIjbQOosjc/0zT2XYRKUjpPkrJopgTM6XOY9pAlD8kycH77dM0rDYrRllj6uiOfCKl257KA1DKc4pFYAhWbmbjziNxIe4UCf2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL1OSJLhFRj1T5dzH3Fiqbek2rhkC8388K4Eb95trME=;
 b=q7f8rdzBornbe3SKezch+CHh9zEbB2Ah+12XY6+Q/6RZqWa0QxgA2yC0hzzOjlOBytnjujZ6dJbRD3AB3hEwvewzTC1tTkItnDm0dRZLN+C2w8eWkzdDBH0OM2EggoV1BQlDKqWaywnap999748eBmxzarMEaLKnIe80i9p6Xnc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by BL3PR12MB6427.namprd12.prod.outlook.com
 (2603:10b6:208:3b6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 22:45:31 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 22:45:30 +0000
Message-ID: <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
Date: Tue, 14 Oct 2025 17:45:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
 tony.luck@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
 dave.hansen@linux.intel.com, bp@alien8.de
Cc: kas@kernel.org, rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
 <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::13) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|BL3PR12MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf4e20e-34fe-4580-d8e0-08de0b7360b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTNMK3g3STl5MjJsTnUzZDVkZ1RsUzVaVWpJczdTMG5kMUZhdWNDa0NmVHpo?=
 =?utf-8?B?djdMMnhzb2g4SWlPQVVSUnd0WHVPRXlQNm4xWlJ6aUVXcHNQRlNFYmFyalhu?=
 =?utf-8?B?WVhXUWQxQnM3VUxSMVdRRFZxdnpMUGNyRWxQWlk1NlZlM3NoUElES2IwbHNm?=
 =?utf-8?B?RWFKYlFVRlJ3TGJxUnYxNDAzMXJzajE3ajlidVh0SGp2VjNLMXBhdE5WNXEv?=
 =?utf-8?B?NHRDdTNmdnFCTGd4My9ZS1ZKeCtoQXNXbDFiRG81RHFtWjRJcGFzaUUxcnBG?=
 =?utf-8?B?bHZjb2JCWWFRSVlKZVZwOHB1L0ViaFppZXdWQm1Ed2g1UzVqU3BjTVU5WC80?=
 =?utf-8?B?VjBueUpUeHZsQk5BcHpjTnVycGU0d1VDYmlGcGpibE5kWnBIeVhMcExnYjIw?=
 =?utf-8?B?UHdZWExyOFltZTZyb3htUzF3azZvam83d3RVUVpFNURBNlFkbjFiSktqUGZx?=
 =?utf-8?B?cHREc3Zka3ZXWjQ0Wmt5Q29EemVBblU5bmREMCthS1NsMkIwdXdyL3l4RktE?=
 =?utf-8?B?Mi81T090K2paUXRXSnNVYytIUFBPMnFBRGhicDJ0RjBCQTFUVHpIM01PVW5j?=
 =?utf-8?B?NVFURFNxUnZaZEovcFJqTnZFdjZKZHY2ZHc3QzNNalVxSVNmQXEzQStWdmF6?=
 =?utf-8?B?YlAyT2RXanUrNERzb0RmZzJBMkpZRHZiTTNlKzFEU2VLeXBHWXpQZEZ2SlRr?=
 =?utf-8?B?YlF3V2Q5SHUrUFRjWVVnMEI2Vlk4UFQ4VlBpWURpdkNkWEpVbHVPN2tGYmZz?=
 =?utf-8?B?SVBMTXU3UitFelFOekxJYjZiT0FYMHBVR0krTHQrK01WYThWelZFNGlldUVa?=
 =?utf-8?B?dEJmeHc4SDBEQTNzMENDZExDL0k3dmZCQ3p1aXdHUFF5SHBpSCtSREVvekdI?=
 =?utf-8?B?Tmp1c0Jsemp6YVhVZlhoTmJuN0dIUFVjNlVrSjBMUjlEWmtnOExKMHdlNWpY?=
 =?utf-8?B?bG9Hc1F3bzlVZXVwcXVWSUh5Y0JIOC9DNTEvcm5JQ1hTNmNjNmdWZEZtNUtZ?=
 =?utf-8?B?S21vQ1daM3l1VndQblR4WDdkM1NqQlAxQlJ2aHliU3lpQ3pUWHU3T0RyUmtu?=
 =?utf-8?B?WXkrcVpOS3BTN2p0TDZQbnRmZkxMaUVjK1BKeC9yV2R6U0lQMU1BMUVTZFV0?=
 =?utf-8?B?a1BKbmFqWkY3QTNUbkdGL2VGanFvVFdqVUE2dmVQWTFVT3o0bzNqdm82bnV5?=
 =?utf-8?B?RFM5K21Ec1dSTTJoaGNjUHZQc200cGJDVmJIQmZXcGw3akZ2alExNHEwZ0Vx?=
 =?utf-8?B?SkhaRFlzN3hJb0ZyenlxbHZLdDgycW85djBGWXFuTUV6ZHBtNzNwYzVPUTU3?=
 =?utf-8?B?N3dRMVdYMXg1c2QrZ3lHNk9VYkpzdkt5Y2lVQ0dxWDJpUE1kUU05MUtvZG5D?=
 =?utf-8?B?bFYrbDJlR054Y0E2QVZYR2svbHhVT3ZnMXYxbFh0SmpPVlNmbUNwcWR3TXRt?=
 =?utf-8?B?VHRxS08wMFJlV1llak43d3ZaYkV5RUxtU2tCaFdiTzU3Y1VMZitGQ0tCWFJs?=
 =?utf-8?B?dUg5UzBjRDdpckEveEFZdDF5b2w3UVl4cVdvV2RGbmtBeGJ3V2JvSnRyNi9J?=
 =?utf-8?B?eFFhbWN2aGhtdEdGbHhKUVh4dkpIYmE1Vmt1RzZqYUtZekNaOVlydHNKamQr?=
 =?utf-8?B?TFUyaFRSWGFNd040ZkoxZ0dOY2RoRmJWV0tXeXAyVEI1Qm8zZjA3Vi9acG9z?=
 =?utf-8?B?OGF3WUc4WjNuTEJ3TW02TTNhbXBZMkZJQ3lXTk8wY3p3QVZyblNPdkhoUVpx?=
 =?utf-8?B?ZVFqcHJ6WUtvMWZKWURKMTVpSnE1R0JreFRwa2hHdUc3K1JBcDVMU05XK2I2?=
 =?utf-8?B?VmhLdHEyN3ZDTzVQSk1mWWUvSUFRR1hUUjkwci8ycG9UT1pyZHpsdTlsSFZZ?=
 =?utf-8?B?YmlTUSt0a3Y0RWVWQTNoc3IzMTFyNnhwdFZBY1pEam5Ed2daQjl3WTFMYm1z?=
 =?utf-8?Q?7QoEhsWKIq/TpsyZ6hV6ncGmVf+emW6H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2EzWmhUTnpoaWd3cjVZM0NkWTB0NW9UcDZxWVgvV3lQUEsxVVpBdlVsS2My?=
 =?utf-8?B?d2RRS0tBdjM3dmduZEVxOXJ4QXl3WDBndGwydUhnTmoySG1Edk9WMUF3Ykh3?=
 =?utf-8?B?bWhUWm1jNjlZdDhuaDR0RmxzRU9GbUF2bThVUytEV3pkTkxUc2VnZWl2c0lw?=
 =?utf-8?B?RVl2S0I0dC82b2ZtSklCTThvQkRqMEJWV2xwSWduNGR5Zy8rMytKRW9pWHNL?=
 =?utf-8?B?RWlEbk9JMnZ0M0VVY0xGc2VYZGlEZExobkV1SnorRkdYVHlrTlhSWFhBWUQ1?=
 =?utf-8?B?VkozNWcrU0ZlOVF1L0FycTBLOXhhbHlzWXVlYWw4bTFRU2twNkhZbm5PUmpS?=
 =?utf-8?B?RkYyWXNSeFpTSStob00wcGxJNWxzczN0WWdVOWJCcDdRanlyMUpreEVzZTZJ?=
 =?utf-8?B?M1hpZHNsMTVaMmJFT1c0eFBIWU8vK3F2Y3pZc2oyMXdocHA5YllaVTJFdFdY?=
 =?utf-8?B?Q1o0aFg5Q01OTFdCdlZ6QjlDUGsxOUVmakRDbkRxNitsc1lweGxFYXJZaUxs?=
 =?utf-8?B?WEpQZ1pYQUN2Ym03RkVuRkV3NDFtcEt4MFR0ZnQ3cmJOQzRFUkNkd0pUbUw3?=
 =?utf-8?B?a2NXdjNhcG1EaG5ZVFNHbG5KRHZkSVdWTFVoeUVtTUlsMkM3MHl2aVlFMVo5?=
 =?utf-8?B?ZlV0MVVJTklGMUFtbSswYWlLckx0OXVHbFVaaExrMWRSWnJWRmVSOWpabSt2?=
 =?utf-8?B?S3ZleUk3cExoTTgvQitmSGJYSVpMTnFCb3YwTzEvcWhDUXB2ZDVxN3dLcW9x?=
 =?utf-8?B?WHZmdlNpUzhuZzFiT1VRdVhrWEJLUHowZDdCbjhocVZPajRaN09wY1hud3NJ?=
 =?utf-8?B?LzJVN2h0OGZTaExBY0g2dWlLT050WkhsSzkxeXRMRWk5OTF3VFFXTFk5c1Qw?=
 =?utf-8?B?SVlrZytUMXFFOFFnSlhNazBYNzFkM1llMm5SZFJuVWJ2WWhxbGllTnVKcENm?=
 =?utf-8?B?K0dRUUFHMTc2cEFqdFZSemtOQ3prcXowVzVlQVIxeWNCSk9qYjByZTZzU005?=
 =?utf-8?B?ditlYmZVWjBMKzhtRGF3YzBoc2gwNk82cFdUNFd0TDZoRnNETTZvNUdselFa?=
 =?utf-8?B?MGJ1NHNCWmd0UThWZzlvdlFRWkl4MjEvWEFXbnN6K1lTQ3U3Z2R5d0RwdkJq?=
 =?utf-8?B?d1U3eElCaityaHJEczVMRUV0RzhDRjFKUXZtdE1hdDlYWm54YzRXOGExU29W?=
 =?utf-8?B?ODI3Lzg4cmtoeUttcHh6N0FIenVjK01oVnRQT2xyWFRhamRKUENxdG80b2do?=
 =?utf-8?B?dU02dkliQ2hiS0pHOXZNbDVuRUFjbUpWNHZSN3lkNFFNekxQdGJSeG1tRC9U?=
 =?utf-8?B?YkhxVzZjdDNsVVJTTVd1M0RXaVJ1bHorZ1B4cG9LTVZNSkpTNGZ6dW5ZZUIr?=
 =?utf-8?B?cXVTdStZajJST2gvdFZTVStyQTlFZE5wenR3anJ5ak9xdUFLemhrdnRSd2Ru?=
 =?utf-8?B?NU5ISDJoLzE5blFjalI0d3NNMVFUYVdEdkpvMGp2djIrQ2VqL1d4TzZuNG5j?=
 =?utf-8?B?S1Y3dDAzYVh2ZHk1N0txWjJJaHVnVDRyZ3NJdGV2QUxzZ0F1WDlYUmZyT1hx?=
 =?utf-8?B?RnRmSzhJbnJRNWhiekQ2ZHBlOUY2L3NZTVFYSHhVYWpsbzlBRUplcUVWQ2lE?=
 =?utf-8?B?QlBRb2lIWFBrOGNpL2phQU9KSGxEMlU3dE1HMG13NVBPUTF2bndnV05LQy9F?=
 =?utf-8?B?MmcvT2FzNmJNdE43SU1WUjRsV2liTGNsNU0vN0pXU0JVRnE4N3pvSHNCQk5P?=
 =?utf-8?B?ZXhKNHY5QzdSV1JCcERWWFJ4L1RodzczMGtxd29oNHdLT0VSaWtBL1FRcytK?=
 =?utf-8?B?UmozTDZTNUppWGVtNFNxOHBNeGJBN2Z0ektHYW5LMlBCYU9VaDcvTHV6Ylhx?=
 =?utf-8?B?VXU4c2drNFQ4OXlsL1lLbGZERUFTTFZsWWFoSy81UEZyU3FteG5VM0t3dVZH?=
 =?utf-8?B?alF6RXV0NWlZSjMvMXJZc25JdXU5Wk05bjB2ZXFoV2Vub0JzeXRnUEhaeGsr?=
 =?utf-8?B?amcrNUNEakZ4c3A3Q2JMYTdaUEdZNUFCaFkxVjdscXhQbHhpMExMdjhBaDIv?=
 =?utf-8?B?TnRoNkl0NW5LTDh5Yy9vLzhqd3V3dGVOTE9RZk9MVzg4cVVzOGdZcnFBc0or?=
 =?utf-8?Q?ztHg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf4e20e-34fe-4580-d8e0-08de0b7360b3
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 22:45:30.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXrGqYWrDQQRZEzeUiwKEqBtGwk3Kv07ZhKY9yYFHAtA9XNTeZYH1SNptjGabi44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6427

Hi Reinette,

On 10/14/2025 3:57 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 10/14/25 10:43 AM, Babu Moger wrote:
>> On 10/14/25 12:38, Babu Moger wrote:
>>> On 10/14/25 11:24, Reinette Chatre wrote:
>>>> On 10/7/25 7:38 PM, Reinette Chatre wrote:
>>>>> On 10/7/25 10:36 AM, Babu Moger wrote:
>>>>>> On 10/6/25 20:23, Reinette Chatre wrote:
>>>>>>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>>>>>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>>>>>>> On 9/30/25 1:26 PM, Babu Moger wrote:
> 
> ...
> 
>>>>>>>>> But wait ... I think there may be a bigger problem when considering systems
>>>>>>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>>>>>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>>>>>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>>>>>>>> to default mode and when user attempts to read an event file resctrl will
>>>>>>>>> attempt to read it via MSRs that are not supported.
>>>>>>>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>>>>>>>> to handle this case in show() while preventing user space from switching to
>>>>>>>>> "default" mode on write()?
>>>>>>>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>>>>>>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>>>>>>>> events are not created.
>>>>>>> By "right now" I assume you mean the current implementation? I think your statement
>>>>>>> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
>>>>>>> Current implementation will enable MBM events if ABMC is supported. When the
>>>>>>> first CPU of a domain comes online after that then resctrl will create the mon_data
>>>>>>> files. These files will remain if a user then switches to default mode and if
>>>>>>> the user then attempts to read one of these counters then I expect problems.
>>>>>> Yes. It will be a problem in the that case.
>>>>> Thinking about this more the issue is not about the mon_data files being created since
>>>>> they are only created if resctrl is mounted and resctrl_mon_resource_init() is run
>>>>> before creating the mountpoint. From what I can tell current MBM events supported by
>>>>> ABMC will be enabled at the time resctrl can be mounted so if X86_FEATURE_CQM_MBM_TOTAL
>>>>> and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I believe the
>>>>> mon_data files will be created.
>>>>>
>>>>> There is a problem with the actual domain creation during resctrl initialization
>>>>> where the MBM state data structures are created and depend on the events being
>>>>> enabled then.
>>>>> resctrl assumes that if an event is enabled then that event's associated
>>>>> rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states exist and if
>>>>> those data structures are created (or not created) during CPU online and MBM
>>>>> event comes online later then there will be invalid memory accesses.
>>>>>
>>>>> The conclusion is the same though ... the events need to be initialized during
>>>>> resctrl initialization as you note above.
>>>>>
>>>>>> I am not clear on using config option you mentioned above.
>>>>> This is more about what is accomplished by the config option than whether it is
>>>>> a config option that controls the flow. More below but I believe there may be
>>>>> scenarios where only mbm_event is supported and in that case I expect, even on AMD,
>>>>> it may be possible that there is no supported "default" mode and thus:
>>>>>    # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
>>>>>     [mbm_event]
>>>>>
>>>>>> What about using the check resctrl_is_mon_event_enabled() in
>>>>>>
>>>>>> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
>>>>>>
>>>>> Trying to think through how to support a system that can switch between default
>>>>> and mbm_event mode I see a couple of things to consider. This is as I am thinking
>>>>> through the flows without able to experiment. I think it may help if you could sanity
>>>>> check this with perhaps a few experiments to considering the flows yourself to see where
>>>>> I am missing things.
>>>>>
>>>>> When we are clear on the flows to support and how to interact with user space it will
>>>>> be easier to start exchanging code.
>>>>>
>>>>> a) MBM state data structures
>>>>>      As mentioned above, rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states
>>>>>      are created during CPU online based on MBM event enabled state. During runtime
>>>>>      an enabled MBM event is assumed to have state.
>>>>>      To me this implies that any possible MBM event should be enabled during early
>>>>>      initialization.
>>>>>      A consequence is that any possible MBM event will have its associated event file
>>>>>      created even if the active mode of the time cannot support it. (I do not think
>>>>>      we want to have event files come and go).
>>>>> b) Switching between modes.
>>>>>      From what I can tell switching mode is always allowed as long as system supports
>>>>>      assignable counters and that may not be correct. Consider a system that supports
>>>>>      ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or X86_FEATURE_CQM_MBM_LOCAL ...
>>>>>      should it be allowed to switch to "default" mode? At this time I believe this is allowed
>>>>>      yet this is an unusable state (as far as MBM goes) and I expect any attempt at reading
>>>>>      an event file will result in invalid MSR access?
>>>>>      Complexity increases if there is a mismatch in supported events, for example if mbm_event
>>>>>      mode supports total and local but default mode only supports one. Should it be allowed
>>>>>      to switch modes? If so, user can then still read from both files, the check whether assignable
>>>>>      counters is enabled will fail and resctrl will attempt to read both via the counter MSRs,
>>>>>      even an unsupported event (continued below).
>>>>> c) Read of event file
>>>>>      A user can read from event file any time even if active mode (default or mbm_event) does
>>>>>      not support it. If mbm_event mode is enabled then resctrl will attempt to use counters,
>>>>>      if default mode is enabled then resctrl will attempt to use MSRs.
>>>>>      This currently entirely depends on whether mbm_event mode is enabled or not.
>>>>>      Perhaps we should add checks here to prevent user from reading an event if the
>>>>>      active mode does not support it? Alternatively prevent user from switching to a mode
>>>>>      that cannot be supported.
>>>>>
>>>>> Look forward to how you view things and thoughts on how user may expect to interact with these
>>>>> features.
>>>
>>>
>>> Yea.  Taken note of all your points. Sorry for the Iate response. I was investigating on how to fix in a proper way.
>>>
>>>
>>>> I am concerned about this issue. The original changelog only mentions that events are enabled when
>>>> they should not be but it looks to me that there is a more serious issue if the user then attempts
>>>> to read from such an event. Have you tried the scenario when a user boots with the parameters
>>>> mentioned in changelog (rdt=!mbmtotal,!mbmlocal) and then attempts to read one of these events?
>>>> Reading from the event will attempt to access its architectural state but from what I can tell
>>>> that will not be allocated since the events are not enabled at the time of the allocation.
>>>
>>>
>>> Yes. I saw the issues. It fails to mount in my case with panic trace.
> 
> (Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
> mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
> that creates the MBM event files during mount and then does the initial read of RMID to determine the
> starting count?

It happens just before that (at mbm_cntr_get). We have not allocated 
d->cntr_cfg for the counters.
===================Panic trace =================================

349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  349.338187] #PF: supervisor read access in kernel mode
[  349.343914] #PF: error_code(0x0000) - not-present page
[  349.349644] PGD 10419f067 P4D 0
[  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
[  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted 
6.18.0-rc1+ #120 PREEMPT(voluntary)
[  349.367803] Hardware name: AMD Corporation PURICO/PURICO, BIOS 
RPUT1003E 12/11/2024
[  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
[  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 
8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 
1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
[  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
[  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 
0000000000000002
[  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 
0000000000000020
[  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 
0000000000000001
[  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: 
ff1f5d52517c1800
[  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: 
ffffffff9525b968
[  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000) 
knlGS:0000000000000000
[  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 
0000000000771ef0
[  349.471022] PKRU: 55555554
[  349.474033] Call Trace:
[  349.476755]  <TASK>
[  349.479091]  ? kernfs_add_one+0x114/0x170
[  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
[  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
[  349.493553]  rdt_get_tree+0x4be/0x770
[  349.497623]  vfs_get_tree+0x2e/0xf0
[  349.501508]  fc_mount+0x18/0x90
[  349.505007]  path_mount+0x360/0xc50
[  349.508884]  ? putname+0x68/0x80
[  349.512479]  __x64_sys_mount+0x124/0x150
[  349.516848]  x64_sys_call+0x2133/0x2190
[  349.521123]  do_syscall_64+0x74/0x970

==================================================================

> 
> 
>>>
>>>
>>>>
>>>> This needs to be fixed during this cycle. A week has passed since my previous message so I do not
>>>
>>>
>>> Yes. I understand your concern.
>>>
>>>
>>>> think that it will be possible to create a full featured solution that keeps X86_FEATURE_ABMC
>>>> and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL independent.
>>>
>>>
>>> Agree.
>>>
>>>
>>>>
>>>> What do you think of something like below that builds on your original change and additionally
>>>> enforces dependency between these features to support the resctrl assumptions? From what I understand
>>>> this is ok for current AMD hardware? A not-as-urgent follow-up can make these features independent
>>>> again?
>>>
>>>
>>> Yes. I tested it. Works fine.  It defaults to "default" mode if both the events(local and total) are disabled in kernel parameter. That is expected.
> 
> Thank you very much for considering it and trying it out. Could you please also check if it
> behaves sanely when just one of the MBM events is enabled? For example by just booting with
> "rdt=!mbmtotal" or "rdt=!mbmlocal". Only one event's file should be created while it should
> still be possible to switch between default and mbm_event mode, event reads from the event
> file working as expected in both modes.

Yes. Checked already. Going to check again running few more tests.

> 
> 
>>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>>> index c8945610d455..fd42fe7b2fdc 100644
>>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>>> @@ -452,7 +452,16 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>>>>            r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
>>>>        }
>>>>    -    if (rdt_cpu_has(X86_FEATURE_ABMC)) {
>>>> +    /*
>>>> +     * resctrl assumes a system that supports assignable counters can
>>>> +     * switch to "default" mode. Ensure that there is a "default" mode
>>>> +     * to switch to. This enforces a dependency between the independent
>>>> +     * X86_FEATURE_ABMC and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
>>>> +     * hardware features.
>>>> +     */
>>>> +    if (rdt_cpu_has(X86_FEATURE_ABMC) &&
>>>> +        (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) ||
>>>> +         rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))) {
>>>>            r->mon.mbm_cntr_assignable = true;
>>>>            cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
>>>>            r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
>>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>>> index 4076336fbba6..572a9925bd6c 100644
>>>> --- a/fs/resctrl/monitor.c
>>>> +++ b/fs/resctrl/monitor.c
>>>> @@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
>>>>            mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>>>          if (r->mon.mbm_cntr_assignable) {
>>>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>>> - resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>>>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>> - resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
>>>> -        mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
>>>> -        mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
>>>> -                                   (READS_TO_LOCAL_MEM |
>>>> -                                    READS_TO_LOCAL_S_MEM |
>>>> - NON_TEMP_WRITE_TO_LOCAL_MEM);
>>>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>>> +            mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
>>>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>> +            mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
>>>> +                                       (READS_TO_LOCAL_MEM |
>>>> +                                        READS_TO_LOCAL_S_MEM |
>>>> + NON_TEMP_WRITE_TO_LOCAL_MEM);
>>>>            r->mon.mbm_assign_on_mkdir = true;
>>>>            resctrl_file_fflags_init("num_mbm_cntrs",
>>>>                         RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>>>>
>>>>
>>>>
>>>>
>>
>> I can send the official patch if you are ok to go ahead with the patch.
> 
> I am ok to go ahead with this patch. Please do rewrite the subject and changelog to highlight the
> severity. I'd recommend that the changelog be something like:
> 
> 
> 	The following BUG/PANIC/splat(?) is encountered on mount of resctrl fs after booting
> 	a system that has X86_FEATURE_ABMC with the "rdt=!mbmtotal,!mbmlocal" kernel parameters:
> 
> 	<trimmed backtrace>
> 
> 	<problem description>
> 
> 	<description of fix that also mentions it adds dependency where there is none and why this
> 	 is ok (for now?)>
> 

Yes. Sure.


>>
>> Let me know if I can add Signoff from you or you can respond after it is reviewed.
> 
> You could add below tags or we can just do the usual review. Either works for me. Let me know if
> you would like more collaboration on the changelog.

Sure. Will send you the full change log first.

> 
> Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 

thanks
Babu

