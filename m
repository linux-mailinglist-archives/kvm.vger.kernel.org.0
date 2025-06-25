Return-Path: <kvm+bounces-50601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 183F7AE743F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BF3D7A799E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0C115DBC1;
	Wed, 25 Jun 2025 01:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="njTWnWPw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E51528E0F;
	Wed, 25 Jun 2025 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814480; cv=fail; b=fhySvfNl67B1ArSJDFMTCwmKKl9HcH76QaKzBdfePdxbDrTHzOuNFKy46H7Zwu9evH4Gl8OROkIup02G8wa55kBBArMBEIE3L2J6ZGBacr5oAXztMq1FEgT8kbEg2pyFjDgZQhFLODoBlAu/U02xrwfCUtVTFk0PtyirZWJltC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814480; c=relaxed/simple;
	bh=ZOlSD9YsrdjoceKZnwW7LhIRusb6//n0tPbQLrsWOVo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ummCL9JInyFVKoXLDRfM1MYsfmr6yLfvID+UwL+bpzdw2S/nqD3y8mnuELAZzfGUwhMz8sbtZO1/SWiFI71Az783rnbxaOfu3PWwiMqP+GBOeMsBCvhORJNkcVk6aZOFVtV2bQ5hyN7EOJKLnGnGWFjca1ff+a14+d0N0YTY7u4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=njTWnWPw; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CqeWzS6Yg8k0pUxUZ6CBqbGu4ZsbVIm2gd/utTmqPS4s6fw9AoxvaSrTu28NuAMqdZFwPTqiKcSZ4KRCHT6vMttLKCbKhbL+GSJC8gOKNVQG/mxOCiJYpaozF0h7kRdqa/pqCXzYPD7c3FbtNMkqMhqrM1EHW4eMkePzjWmK5vtLtx6eHEpvPIPQWKnVFnuVrSnr/1aEetk0LeZqfef1PB+PgcQYOSuXNm5ymLKOf89FM5cYBV7hcIQgcDjQWYy+9oh+G7WVr8rKqM71Myx/tjX/6F8i4I8KpQSyVKx5CmYfcKXEBq1OJyhMahqvxmoOvzzXRQu3vKxOntq5Z0cQpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GtiQIaX9SwCwGKFNgeM2USS7tBx40Mv7xGaLJZbD4I=;
 b=eME9yREJS4A+durgr4fRNtXqB3Mny7V4jnqtQ4iB1V8hP7To7z8Dj0SbL92bKO9k9Wb7D16+2CRiemPunVe99txHNQBDjL+TBOT1Dq4JUyiKpiPPGZDVAglFElIucluPMXclo5l6JVmwLdfqO4X5bozVFPjZiqQBtKHvMNJguPXLL2uF0o0oLMtdLiL+0SmT1XaD9D13qyYfkWlfPEmPCnj8KjhINLHHmk5L1kmkS6tJhG5SgwpdmGVROXokZ9k4Gfjlrc21xrFSGPBRl1P9M96eK2Ak5A/dzdMwVkhfFYsIfOC/lLh1J19fI/baafSBtkOY0vBBbuyJABBPutH3nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GtiQIaX9SwCwGKFNgeM2USS7tBx40Mv7xGaLJZbD4I=;
 b=njTWnWPwzxbHhRX6i05g0FT9un8v50BWF/ID4HZQ0M1QqeFx07hJSsVBluKs1dNRL7Abf9KnBLLVXAyfaFvz4+wKo4yVllw+Q12O958/aUbyc/k5SxAgCmpBKyMv4txBr49sqO67qW/9/7lIGwjNKb3ipq9tT4rZcjDdxXSRMZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MW4PR12MB7287.namprd12.prod.outlook.com (2603:10b6:303:22c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Wed, 25 Jun 2025 01:21:15 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 01:21:15 +0000
Message-ID: <24675ed2-e3ae-4473-9d8e-acd378da220c@amd.com>
Date: Wed, 25 Jun 2025 06:51:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 03/37] x86/apic: KVM: Deduplicate APIC vector =>
 register+bit math
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-4-Neeraj.Upadhyay@amd.com>
 <20250623114910.GGaFk_NqzGmR81fG8f@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250623114910.GGaFk_NqzGmR81fG8f@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:4:188::18) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MW4PR12MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ac7a55-a6c8-47aa-aaea-08ddb3869424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnYwdjBlVFhIWlNEZ0h5UCs2Tkk2SjNvTlpZb3JuMFV6NWdpV3ZlWlZjSGli?=
 =?utf-8?B?cHVLcXdISndnVmFXM2YxTGtWd1U3K2NJaVh2RGJvNjBBcm9penNrR29tSUhB?=
 =?utf-8?B?YXdsQ2xIcUl4YTRDM1JMdCtxZ2poZFhSb1Z3M1plUENEdW15M0IrRGozSkdE?=
 =?utf-8?B?dEMwdzRoTDdMOFlQWlA1cXlHUXVZYis0bUc4amhSUXB2bklCMUtzVWZ3NXd1?=
 =?utf-8?B?Yjhqcmd3bWJ5b3I5ZEcxWHRHQ3JXdzJWQUFVdDJjckR0L3JQenhzZlVSV3Nt?=
 =?utf-8?B?MUV4Sk5ZaUJKSmFkV2l6ckFxbnVWSFhUU3pCSENveUFwZGFPNTk0SnBKU2Jw?=
 =?utf-8?B?VHQzZ0l2RndrQkF1ZlhPeXVWaHZOaHNOdVVuRlpHWDVHU2ZsN0FWdTZYa0Nk?=
 =?utf-8?B?VmZudWhuUXhtTDVCL2J3aXd6ZFQzU09kanJ3YVljRC92ODQzZlEvK1ppNmJB?=
 =?utf-8?B?N0hjM1pUQWxyZ3h1RE5CdEFrK0Rjb295RGUraEd0ZmV3QStCQWZCVXRHRzFt?=
 =?utf-8?B?RnpuTkhpK3JBQXhLVG9LcmlZSVJ5dW4zVzRVRC9FZE9iSTNBRit3TTdCM3Nj?=
 =?utf-8?B?Z2VsN09PMXBHZkpVYndzTGJEc2VIbnovb1AvQWprMW0vNlpLUXRZME50YVRU?=
 =?utf-8?B?S3MyMDFtdkRYQkI1TzE5aHp0MmtyVDVUYmFLcGtiZWp3ZkcvWFhtOUp2RXRZ?=
 =?utf-8?B?WGVjYXBSOFpiTkRDa25CVjcwRnY5N1h5ejB0cHZ1N29EZzBYMFBFa01vUUx6?=
 =?utf-8?B?UmhBYjdib1Y3NWhUbFc5aFcvSXRlRjhxcHp6Rkk2S3A2aHhIdE8wWTZVMWRN?=
 =?utf-8?B?UFh5R1FFeUx1Zlk0bDJRR2Z4V2czOWJzRGFHNGZXaDMzRml5Y1ZuL0lzck9i?=
 =?utf-8?B?U3NNZG5UaUk1bmthbDdzUUZRc2d2Ulk1K1F2NGwxR2JZSjNVTEZ6L0NscTJ3?=
 =?utf-8?B?UU1kY09pZ3JjdGcxM3gvRVY5VEpKTXJYajJwY0h3KzhUaVZ2eWtObWhVczFm?=
 =?utf-8?B?SlZZNU8xZmRmcXJhbXBvMWVIRFlJY3FNNWRzdWlYbnh3ZTdMZVNRN3JmRzdZ?=
 =?utf-8?B?R1MrbDJRdFhXaXp5Qyt6c0FoUzNneXBwb2s2a2MvTTc3dzV5SXVxM09EVVc2?=
 =?utf-8?B?QkJJY1MwVGtyWnJoYS9kbnlOY1JzaEpad3c1UnFJMkxHaVBLeEMrY3h0M0NT?=
 =?utf-8?B?b2FnQkxacG1HWUg1OHVmWG40ZjNicm9aejZKc0lXMzRsazQrSTNHZ0dNMDZm?=
 =?utf-8?B?YXYwMUFnVUphTzdtSTlaRUhsOEE3TzJCSXZwTUlRWUpBVUlwczhxTG5mUUc2?=
 =?utf-8?B?byttZUZKMm5QNzl5RlZRT3JwV2pRUnQwMXpHZDBaejBqTnl2OFJuRUt3VTJC?=
 =?utf-8?B?a0pUaTRLbzZrR20rUkU1aHZZZU9TVWErS1FQWWJKQTFSQU9nYTYzTzgyaHJQ?=
 =?utf-8?B?Q3IxdmF3eDRkTk1ZVVYySjJ2T1kxcUVNWGFOMjdXZ1VPMDhKTnNRMk9VWTRu?=
 =?utf-8?B?T0wxdldSdGpaNlVZZmNXc2J6QzI5STFWMS9oVk5sOFJhS2lLb1pOV21oRVFE?=
 =?utf-8?B?ZWgxL0MrakpZWVJsOXIvV3lXMERSekE3SGE0R0d0M3FyQUNFUkZ0RUtNdHl3?=
 =?utf-8?B?RFA4aU9CYUl3M1pJeTBUNVlvOUd6MDhPRVhUUUg3ajM3ZkVNNFdGRFZZWkRm?=
 =?utf-8?B?MUN1dDdHT1UzMGY1djRoalJDd1l2SHE3bnRaaUJFWWhyZmlxckhteVlOOWF1?=
 =?utf-8?B?SzlJejZuYzVoVnd5T09YVXdlVWowaktrUVZIcUc5QXBEaXBEek1jOUpWYWlR?=
 =?utf-8?B?RWpUOWlTL0R3OTdycUtUMlpSOEZXS1F0QnNGdjhveVBhTmxzU3VYUGxkL0Q0?=
 =?utf-8?B?Y1JqeXg4NExMZmI2MGxTVlA1T1p1VlpvNWgvVDN2VHNCcUorRm1YaHR0YUVa?=
 =?utf-8?Q?YZ6CnPx5uQM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTEyTWk0czMyT1l2Z0wwMmZXQnNrdVVMSGhxMUxNZ2NrVEd5czFKaHlhL29p?=
 =?utf-8?B?Yk9wUm1PeVdBWEtEUzFRRU9xajQxTXhieEpCL3l3Q2FrMHJMMDFGL2FNc01z?=
 =?utf-8?B?VnZyYkZVZ3g1aVFGU2dlVnQ5Z1lUR2JVVnRlT2xxd2ZnMkorajk2QjUwOHRH?=
 =?utf-8?B?VW1VOVB6WndlRjErWFR1NEZNRU1TWk5XK0JmREFPYWxObFR6L2RJMjlCRk9h?=
 =?utf-8?B?UUgrREZyNGZ5ejU4SXpVK0szaytsSnp2b2s2eGJYdXBVbndiVDJOeXA4dHFS?=
 =?utf-8?B?S3kvY0dNRlZDVURUc0NveUxad0l3SUduRWI4ZUM0MTYxRmZHQTVSS2hJOTBt?=
 =?utf-8?B?MlV5K3VWWnFaZmZ1SXppakwxL2RUNDQrVWpWVFM3emtrcklScjJhNWhMVkxn?=
 =?utf-8?B?bVJmWWw0R0s3cHNhWUNMQ1hGTkRQaytpdG96SlByeENQaXllZnRGZTJSSlJ6?=
 =?utf-8?B?Q1l2elJDRlE4dExOalZuVUlKNEVuTUthYjNrS3JMUTE4SmZwYVc0cG1rOFEw?=
 =?utf-8?B?V2FBZWtISTRmVnFTUzIxZGY3eXBwZkNIWWVSRHFGbUdESjh0bEpSbDAvRUVr?=
 =?utf-8?B?UVFLdjhGZ1V1U3ZZS3c1Qk1sZUJsVkpVTHJRZDdsYVNneW9OWnRhVXQxQXFr?=
 =?utf-8?B?YUdEU0hnZllXYXhOSXZWaFdrSVRMZ2o2bThrRGVyT2xRQUxpMUQrcTRCV1lP?=
 =?utf-8?B?eGVEdHpteXNmbTNDSmhmOW5hOXRmL3Q2emdqRlFiN1ZQQW1JcGZpbm12RFJr?=
 =?utf-8?B?aVhBVDlNTUVLdVRCOGpVK0l4RHprT1R0N3RPakZQWWhoU1BqT0h1QmxnWkNs?=
 =?utf-8?B?RGZicWd0NW5qOGw0dlJSR0VBWVFuZjdtdWN2VTVydXpjMUg3d0dYKzIzWCsy?=
 =?utf-8?B?R2lWTjhRbUhycjYvNXpVcnN2aU1TdmlyeWhBWUFFTWplcWtTdXVubHZLTjg3?=
 =?utf-8?B?MVk3TGpibzFaUXJ1ckc2Rm5Wb3NGQ2YySVNXWHBaNi9nMzhONkF0OTEveUIv?=
 =?utf-8?B?bmUvYWo0Kzlrd3VJWGJGTWgyeUpzN0IxMGZlR3N6V042UndXNTdzaXhRODAv?=
 =?utf-8?B?WkIvaS8xT21qS3FVYzZrNmd1QkpSTjhGbWJPVHBKS1FGWWF4Z1JEbDVtV09s?=
 =?utf-8?B?ZnpGUE0vQzJIOHpZaE05RDE3Wm1yMFB6b1ptNkx1Z0VhSVJkdWRuSVlJejQv?=
 =?utf-8?B?WGU4M0JSRHdUUE9GMU9ld0xZa0t0Z3NvdFZZbEp6bDVsVExzdnBlRC9Pd1BL?=
 =?utf-8?B?YUl0Y0FxdVRvV3VJaWg2Tm1qOTFNOEZCek5JTTM5a1ZYNWovMldWd1Z3amg1?=
 =?utf-8?B?M1FMak8yUnptbGNnQklYVDIvNCtEWEdhWXU4VE14ZStQem5kU0NmT3Ntd2VP?=
 =?utf-8?B?YWRROFZnMmd6Rk0wN25tYTdyMS9EWDZVQjVjbDZFR1B0UGgwcGpjczF3Tjhs?=
 =?utf-8?B?TWJ6c2dPRTRTbjh1cWp3cjIzcE5LRkpTWS8ySWFXY1FSaks5MENHOXZLUHJy?=
 =?utf-8?B?M3VXM3NHZnluNXZEZlZDMTVtb2k1U2RzTXIwNW1PbmRVUmk1eFdkU3ovaDNk?=
 =?utf-8?B?bjJ0aXM0U2tzNkI0dXVRTkVnY0taWmxlTUM5Q0ZmSDlYQXpybVI0US9TcmZP?=
 =?utf-8?B?SXEvMklhSnpqY0VTamc4TEN1cjYyb1B5TG82bDFwOHZiVnQyc0J5STlZdVpm?=
 =?utf-8?B?SW1RZ04xMk9raTIvbHdqclQ0bkt3Uko2V0RCc3NFR0hCWnNmWitMK1lzOTU1?=
 =?utf-8?B?OGNYRzBkVXZLTTJtdHpwWG95aUZjMDVRa0VocDdMNTdTOVBPWHJpbXlhTUtu?=
 =?utf-8?B?U3JacStzaWVtOTJlWWd4MUlURHpubUV5RmN0L1grR2NjK290VS81Rm50aEtI?=
 =?utf-8?B?dExlRm1TQkRtc3llaXNFV3lZVlRoT2R3TEkyTjQxMTA1aVlFYXB4VWppVmRK?=
 =?utf-8?B?K05JTEU5dzd6MDRlMTlNcXR5bG5pQXYxUVVpRnlrd1EvcU1qbWltWXNLTnJl?=
 =?utf-8?B?b0pmTitmU0s0VFlDSExpdEZVYkt0TUxYV0ZjWEJiR3V2T3RCUG5HdWJlMFNl?=
 =?utf-8?B?azgybWh1SWFRN0dwR0szZHJVU0o3RksxejNvU3ZudVNRajhnbmxrSDArSklK?=
 =?utf-8?Q?Y5QUHRoVJvX1rBk6cztF0+pdR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ac7a55-a6c8-47aa-aaea-08ddb3869424
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:21:15.0220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzVdtvW+zNbIWYDUcB7gN0jNcqq7r9PxP7bURhy2B7be0PRfKkZJKbKk8mQwTsho+G5SUWHG8g6Y8txFo54aiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7287



On 6/23/2025 5:19 PM, Borislav Petkov wrote:
> On Tue, Jun 10, 2025 at 11:23:50PM +0530, Neeraj Upadhyay wrote:
>> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
>> index 23d86c9750b9..c84d4e86fe4e 100644
>> --- a/arch/x86/include/asm/apic.h
>> +++ b/arch/x86/include/asm/apic.h
>> @@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
>>  
>>  extern void apic_ack_irq(struct irq_data *data);
>>  
>> +#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
>> +#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
> 
> Dunno - I'd probably shorten those macro names:
> 
> APIC_VEC_TO_BITNUM()
> APIC_VEC_TO_REGOFF()
> 
> because this way of shortening those words is very common and is still very
> readable, even if not fully written out...
> 

Sounds good to me. Will change this in next version (will also wait for Sean's
comment on this).

> LGTM regardless.
> 

Thanks!

- Neeraj

> Thx.
> 


