Return-Path: <kvm+bounces-57332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE52BB5379B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B0553ACB80
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5CC34A322;
	Thu, 11 Sep 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L0onfnAH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C631E11F;
	Thu, 11 Sep 2025 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757604245; cv=fail; b=UeDhhqaN+m6jFnZz3bo7RH1nSOE5Wh2bYDBXlGlga5P3hpAQv0Pxgv2UwO4Gl0iRO7AMTTS0kEuL1HLwRziqHaUaixhtRkIXbUZoCYnnvbIgruq3Ple0FfCzhoZ2cJGzAKBSgKcrTXa/Dp/8uyZyiOEtpXaIJ1jAuEPcGH4mqSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757604245; c=relaxed/simple;
	bh=s3Tq9111sXfbH5Ma/iRc4qkolrH5uuf11xdIyFTZT4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NXlp/W6bE/sjLEBNs6l2mp52bNQZw5xHD+N5lWK4cq+sRAEbnG/S6LRfCkLQyJ4uBWZ4CKXG/M8pYA3LxNHlTkuJm3UXJ63qXYctwmqqVjgNcxFgfvfAg79Ale3pk/M35UAES/mdSfhTj+x1CuAu012qqiRn5uPaXiB3BdsHrvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L0onfnAH; arc=fail smtp.client-ip=40.107.100.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKK/3NecmWEV+838oJ6ApcREx8+1APoKW1HlNHImAHQf2Xdx8N/pOg9HoaENnPvlnO+IcMB3aIvHrb7R9TqEAhch3g9uR9n4EbdVlM55oPMqVM48y4Wg9SJo5+SdrRCYZkj+RbYF5ZdY+v9piAv8K1b3HtKzkXnefSUgZI+THsEiI23qjL21Y/6W41GDQD+yfnuIdsfXggTbkuy0MhdlSyA8YGX/RykU8J7t65A6f0kH37nU4f/WDJkUT7TtIY05NjlRcCVh8eKcPx9dTAMqM/RhOYvbD633jLH2wKXK64SSYmpbI8QUC3t2TSVmXAzNi8Nc30rVE4sI80yDNEvfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8rosJSfBb/dkHwaNlGNbH9cFqyzK6WlUs9Mzy8VCro=;
 b=zCt5ZUi+8gnvmR/a8ZxjkdgMb9z7ZOhAyjyqP57LpSdSXgZ3gxxi0tVUVP7Qy8NhVxwZyjYtRichX1EYRH8FX6j1zCrkxDNhJjpI3h+ja/WwFkAdBCQM39yQ2RoVTz0DQNRN2v2opx0BEDg5c26SBdPAHOqmOYatqKvGaL5wAdva96/BotdHLlUFotphoxR5v66h8mIE9nXI01rfXecf9wtE285REOV8XyVRIMxt4pT7JK+ykyzkLXiyprCdMVFITj/cRo+vfQNwLs2mIM2s+m2GXRmTXU6PK2Gdryvy041i14SYrO6yGgBP0bM+vnV7AGIXFfIAQvQfhNp3jH6URg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8rosJSfBb/dkHwaNlGNbH9cFqyzK6WlUs9Mzy8VCro=;
 b=L0onfnAHqt81A9eiAN19xGziAXim1fhTlGLxYmexp7kS8484j9e7NWnwl8Cc/SvZOCD1EEnj42elid9yst/q5BoRh3TqdgnutjcBiixtnq0e92DAeLh2x3L8htcoVao26Mpk8/yNYxUmCZaMQ4sfYV1ClTlC3WRQKPJlSmA4JSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 15:23:59 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 15:23:59 +0000
Date: Thu, 11 Sep 2025 10:23:46 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, chao.gao@intel.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	tglx@linutronix.de, thomas.lendacky@amd.com
Subject: Re: [PATCH v4 4/5] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
Message-ID: <aMLpgkRihOn4tZPK@AUSJOHALLEN.amd.com>
References: <20250908201750.98824-1-john.allen@amd.com>
 <20250908201750.98824-5-john.allen@amd.com>
 <aMHsjTjog6SqPRpD@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMHsjTjog6SqPRpD@google.com>
X-ClientProxiedBy: BYAPR01CA0060.prod.exchangelabs.com (2603:10b6:a03:94::37)
 To BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: dbefe08d-2227-468f-959d-08ddf1473af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmR5SXIxRzVlZkxBNmU2SUd1bFlsMTE0N0FkUlo3b3BkRVJTM3lxUUMrYWFE?=
 =?utf-8?B?dXdCTENrZDhmTjRVVTVJVnpidzdDUkFDVndaSGdLa2djWWljMWhZaXR1YTY4?=
 =?utf-8?B?U0c4aE93UmxtbGVEeGo1Wis2L2RtcnFwOWJ2NEZWdFJOMjN3RmNSelpwd2xW?=
 =?utf-8?B?aEF0OHIzYkYyTC96Q3lTWXZXc1R2d3ZpUldSbHdVYUc0cGQxMERMdGxKWmlK?=
 =?utf-8?B?QzUwWmFtM1NYMjN5aEtudldoZW9WNG5pVTc2WFNaWnZKZHdqY0R6eStHUHhW?=
 =?utf-8?B?T2o3UDJKZERoVThmU2FOVndBdWdsK3lPVWYyczFWTlNjbTdMbTlvQVBSTkdu?=
 =?utf-8?B?UlU3eno3c2k4VGFsUjYxTmhMUFlIMUdFdVY2REtyTW5Wd3NQRk54RitsWG5s?=
 =?utf-8?B?c3ZRNXc4YUtHYUNQK2RHN0ZMa3NBcVN2L2tlcEdCbmVnTUNBazZUcmRxOEFS?=
 =?utf-8?B?NDljZWRSYzhaN3RxZHluekpScXNLdGo4Q1VUd3Z1Mnl2Y2Z5L1NrMlFOelBJ?=
 =?utf-8?B?ZVl1cWRzR2lJK0QwTkFqT253TnR0NzhQMVJDdEJDblZ5Njd2anlSQlgzdDVP?=
 =?utf-8?B?eWVDYWJ1RFcxSHplcFJqbWtpdWRpeUVYTUtNZzJIYVBGc3V6R0pSZk0wWTly?=
 =?utf-8?B?SkFvMXFtSVRyK2lPUDB4bGttSGcxcCtQWlQxdjYyM1RIL3JSTnJ5S2RYbW9W?=
 =?utf-8?B?S25wVmlwTCt6QkU0eVpucyswNnpVeWt3R25MQXFybHFvUjYyTkxWYzA3ZlVG?=
 =?utf-8?B?b2tKK1JVcEFRWnlsRWJTK3RFZG55NUhNUmt3L2s3ekpnRXV4bTMwRG5vQklG?=
 =?utf-8?B?RWV6Q0pwZUFoR2F4VDB3ZFZWZHQxUDVJOE50bFlNNWF0cnY5TkV6MW9HRkRk?=
 =?utf-8?B?ZjE5OVhWTnBRbTNRY0JKTlRmSHJCcTJ0bVdVZitaTVc4MkVXRkhnL1BTR1Fq?=
 =?utf-8?B?VStBZUd5cS9Lc0NLVFVwOTJtSjZaMDBwV1Z2b1JJYi9OaGVuQURCRWd3bm5j?=
 =?utf-8?B?MGF5b283eFMyOWc5NEpGQnloWjdnbUs2WlNyVUZadkhSL1psVUdWVWNSbHl1?=
 =?utf-8?B?QWZIL1J6eW1kVWdsWVJUOFo1TWtpWjVSTnFpaEN6a0NGSTRhQTlrV1J2K0tL?=
 =?utf-8?B?S1NJK2RtOTdBU0lWZEs0Z01iQmVVb2hVS3pjSXJMTllRQjArNDh1K21Femky?=
 =?utf-8?B?cjNzZU5Rc0phTm02MExzbldmMlRRVjJ5dlRHekROM3kzVnM4czd4dkc1NFpk?=
 =?utf-8?B?VzhpWGZxZjZZc2tkdkpBOFBrZm5mL3YvcmV4QjVsOTVRU3NnVmVzTXcrV2c3?=
 =?utf-8?B?SFUvak14eEJKMHU0eFI3REZHaG5QcFZFSDl6MXF2bkdXeGVZelhJUkNBUkZi?=
 =?utf-8?B?SmtQeHA2UTBHeGlHT0c1OFd3aG1YY1Z3dXJvK0dQREkwZURiVW40MmhNSHA4?=
 =?utf-8?B?K3lVVHFpQ3E1YTUvT2VrRk5RR1Q5SXhwdW5aR3djZUxVWGFsWVNiWVp1TU1r?=
 =?utf-8?B?Rno4OEkvOFEzUVgva2ZpSENpL0k1UFlyVW9uSnJHeFJyVndCSjBPS0V5Qlkz?=
 =?utf-8?B?LzRYcmtGUHVndzZYN0E3ZGFhejc3ditsSk5TYVVQOGhtbXZPcHZqYWlEam1E?=
 =?utf-8?B?cFBWWEJqTHRyUkJ5bHBJdVkxY1NONHcyenp0OEw4QUtvd2JYcEhjM1U0Y2ZP?=
 =?utf-8?B?N2phQjYrZlZXVnNZeUhaZDhZOWxHMm9wOG9jaWpZQzRmemp3ZE1ucGgxTURh?=
 =?utf-8?B?MHNKamgrUjdiRHVkcUJVR3dSYkQ4bjd3eTY2ZWw4SCswelpRbkNrdkVUVTVR?=
 =?utf-8?B?TTNXc09RcStyaHM0L1U5dVN4YjNscWtKSWxPRFJ1TVBlV2JDZ0t2RVRxMTlL?=
 =?utf-8?B?dlZjWTNWZjFyaFk3bGYzSXo1RzEvUFQ5VFlvOHM5eHFwRVU3SGNhcHQvUExm?=
 =?utf-8?Q?jUejg/Lw1sk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmppejZ3Q29LWWpQejdBUFFqdjVFNGdWNEVoazh6RXpLUXZ2QjBSR0MyZTNE?=
 =?utf-8?B?R0s0SzJRT2MzRHhaOE8rYjlDemJyQm1LU3NZM0svM3NzZVhyV2NFeFpLbzJD?=
 =?utf-8?B?aEtrTDFjZWltM0hjb2xQUUMyd3R4aDRObGtOOGhVOVJObGNZZy9XRTBQZlV2?=
 =?utf-8?B?ZjV6OThoTVVJVUlJbmZLWnArRGJZeDBIWWdRQ0tiK0didnhYUUtua0FJc2Yy?=
 =?utf-8?B?bFRuMVJ5VUdQSXdnQnJreEdiaDJmWkJRU0hBVkNCc3hIK2pVVnJ6Q2hJYzFH?=
 =?utf-8?B?eUNHLzhCZWgzd3o2T0ZIZTI0KzRkVmZjZzVRaExSd2ducHBBOUVPaXVxWkFT?=
 =?utf-8?B?L0VJTkJ5QjB5VlVZMzdWU2JRQlloTXFFZWZUQUdjWmFmWlduclVxVlF0alUv?=
 =?utf-8?B?QVJzSmx0K0JualZkYnY0WFVjMWw4UTZSYjVEZzZIUTdHZzkvWTFBaWNNY3Zk?=
 =?utf-8?B?V0RpaXlpYmpLTUZqaEVZaG9ER1JvWFJOYnBES0lQcmZpaW8rVlZLZ0FGSVo3?=
 =?utf-8?B?eDJZWEJ2NEZ4cEZSRXVoVW9Dck5xQ2FVdGZDSkZQdVowNndBd29FQitTQkxz?=
 =?utf-8?B?Q2VKbEpPZTRTaGZVQlNGTlN3QkdKczZRSjE1Zk1hUzFFR05ycUJQdmpDWUVG?=
 =?utf-8?B?QWg3NEw3OU5renU1MVp1dm1KcnY0MzZvWjlrWHJ5L0lweHFadk8zU3JGZGt3?=
 =?utf-8?B?aExZc0hmdkFhTDNqTVJ0cTA5enFEK1Y2SUVTSUJpS1pWa3BoSC9LMUdray9X?=
 =?utf-8?B?R3AwNnBqTVYvMVBlNUQvNDBvck1xNzE3RGpTNWdRalJhUEZQNTAyVWoxOTdq?=
 =?utf-8?B?VHA1eEZpQ1BBcC80dGVEZGtUVGNpbDhFek94MGlobFhEdHBPcWxCTkhuRXdB?=
 =?utf-8?B?enVFMlYwSnhuYUJ2dXg3NGRZc1dIa0xPZXl1ckV1aXRaSWFWVGhXbUhqTVJS?=
 =?utf-8?B?Q3NOSVEwbEJEMk1LaGVuYW5XaGM4RWppYXlxQlFNbzVuaERVMVA0UWlzdFZP?=
 =?utf-8?B?QVh4NnBRdlIrQVI2UzE5OVlxdTBBNEtlUjhIdnVYN2dWMDVYRmpKcnNPWG14?=
 =?utf-8?B?d2NSakc3RmhuZ0pkS0dWdHh3Qkt1a1dhVTlCcDRKbnpJR1Q4YXQ3bVVsSzJt?=
 =?utf-8?B?L29QYXk0dk5FV1I4dnR3UFRNUk0xdHZjVDQycGw2V2ZQazNoMU1hOTNPQ1NP?=
 =?utf-8?B?T1cweGF3MGxKVUFyaW9jcDBIbk9MOFNwek0rWUpIdmdvcE1nUGxXUmdlZm5J?=
 =?utf-8?B?RHFyWkwzMkVmcHRZaFpGSGo3UUd3ZjdnWmRaYXRSenZzZ2hlSmY0dUNTSFV3?=
 =?utf-8?B?SXY5QlJmQTYxT0IxZkNMYmp4WW83NFpEMkhUcHRiS1BtRWh1TmtQVnhQdndB?=
 =?utf-8?B?OE5MN2dacHd6RmFoUlhvRXlZeFV2dUhvMXpWcmtwRDUzcVUrVWwvb2piamdT?=
 =?utf-8?B?NjMwUmFsdEFHNmRSYkdxcDI2b0Z5SjNOZUpXTm16bDRLNnhTUEtEb2FmODQv?=
 =?utf-8?B?dExzUEUzM1RXS1ZJWkh2UnlLWENHR1EyWWhJU3VTSGRseERuQUttWFVCWTIr?=
 =?utf-8?B?azlYanNxQXlnZHdpY0JJazE0NWRzbU1yMm1TeFlIRFFMNUlnbkZ2dEIrVHh5?=
 =?utf-8?B?NFZWMDRuY0lxZEF5eHFaSGxORlhVTG9JaXV3dCs3Q01Ob1BXTTJzeWJ1UWRx?=
 =?utf-8?B?NHVUSjh6RGhOMm5TY3ZCc1pQWndGeXhHejVma0hjemhHcU0zRHI4dzA2V3ZL?=
 =?utf-8?B?S2ttMEdhaXRNakRTRjIwSkZYakNrdllqNllIMUFpcVF2MVVGaWNmOHVtM0FP?=
 =?utf-8?B?Z1ZkdWxnNnR4SmdDZU02bXNINzhDLzUwUDljU3FhbTZibmJvMlZaek1oNDk5?=
 =?utf-8?B?V3haR2crNGJaK1NNdll3UmhxN3hlQjZ5ZWptTytLYWxqVU5ocnNSKzdPWUI2?=
 =?utf-8?B?REM4ZEZlcXNWMnQzelZUNlcvUE4rQkl3dzg3bjBJeW8xK3VlSlZmeGZJMXlI?=
 =?utf-8?B?dXlWMnNyVlp0UWNoU09nZDFMK3VVQ0REd0Vlakx6Y2FyQlRxOWp4TnZVOFp1?=
 =?utf-8?B?UkQ2ZStsY083bVBmdDRMUlEvM1JPOGJ6aWlUczVRcFQ3Ry9GVVIrVkdBT3A5?=
 =?utf-8?Q?zNGOgE762YIJ2eojG21K+jCo9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbefe08d-2227-468f-959d-08ddf1473af7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 15:23:59.2608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2wqJ42xht1szy5dCWEcawYXi/bSoSq+d3ZzcUGIVDdFqCocAY2eF2cbYMbWGME63LywsFNEQ99ODFlMukFOVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016

On Wed, Sep 10, 2025 at 02:24:29PM -0700, Sean Christopherson wrote:
> On Mon, Sep 08, 2025, John Allen wrote:
> > When a guest issues a cpuid instruction for Fn0000000D_x0B_{x00,x01}, KVM will
> > be intercepting the CPUID instruction and will need to access the guest
> > MSR_IA32_XSS value. For SEV-ES, the XSS value is encrypted and needs to be
> > included in the GHCB to be visible to the hypervisor.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> > v2:
> >   - Omit passing through XSS as this has already been properly
> >     implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
> >     accesses to MSR_IA32_XSS for SEV-ES guests")
> > v3:
> >   - Move guest kernel GHCB_ACCESSORS definition to new series.
> 
> Except that broke _this_ series.
> 
> arch/x86/kvm/svm/sev.c: In function ‘sev_es_sync_from_ghcb’:
> arch/x86/kvm/svm/sev.c:3293:39: error: implicit declaration of function ‘ghcb_get_xss’;
>                                        did you mean ‘ghcb_get_rsi’? [-Wimplicit-function-declaration]
>  3293 |                 vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
>       |                                       ^~~~~~~~~~~~
>       |                                       ghcb_get_rsi
>   AR      drivers/base/built-in.a
>   AR      drivers/built-in.a

Apologies, that series should be considered a prerequisite for this
series. I pulled the guest kernel patch into a separate series since it
doesn't depend on the main series and we ideally would want it to be
pulled in ASAP rather than wait on the rest of the series since it
enables linux guests running on non-KVM hypervisors.

Thanks,
John

