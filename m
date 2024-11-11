Return-Path: <kvm+bounces-31407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2551E9C38D1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF3DE28207D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143CB156872;
	Mon, 11 Nov 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zf/ZvLBv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7941BC4E;
	Mon, 11 Nov 2024 07:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731308603; cv=fail; b=K4klCJT7G9GyVWRh+m8jBmHaiwch4UQGz5W/fKbGA+m0R/h1w8jwDAB8vGe5cImT8qRsImljNsvWyVVPJESze4ChiZARS1TRCgcQ5A90q/07zC9jKK6JeZuHgD6thnLk1m10wkYM7le1ND5S+N2g7aKPV611qVI0It9b4jMsFC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731308603; c=relaxed/simple;
	bh=Ni8GBeUlCFzeqje60Ac+fm2/2twILclOBF6BQb74lXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XWRrhHyGWvz6zQIsoDIgckFyZ4nLHhw5F8bczDzLLTktSParnBfFZSNhcAMBZWJQSbL8eTMnrqX3+4okCFeTAgPZVg3UOqRLqRZ9ZHr5y8R9rq86TJn5l2AHiJY6XGzZpOK6D+WukbOqlp6X241HRFMZSazPSP2te0jPTovL7TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zf/ZvLBv; arc=fail smtp.client-ip=40.107.102.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JM/0SCJdpGX3EEysOyPUDgsEtp0nG3yCKka+n3oKCljpSbVqGCyFZgmE2LsKMBtpBDtNvsK5rY3Ib3d5WJ+m3Yietpy3GTFFokgR/O0dzx82FovTqyRfJge4lYR5HyrdCZwOS7kX2+rTRSihBC8Z89fMKoiy/r4iB7fv8L6bjaLPfZeimKR9AwoDOta9E5IGfTaFktataJTmg8AzuGtY8y2GurCLFBmlnPLhBS4CMR9RTQ6+mN/TW1xRObrLG220NQuZCevNCUwyDOFcFjwsAs/+Fg1LbA4AYlsMMPNCO0QGLDMB6QlLyGya8RWDr3kJYV3B5/OXfE231mBp4+7ujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5cqK0oqVyL00SocNpOxPMzpHcYv2yoPITHwL0AD9SA=;
 b=LBG8CKqQivox42XeTgkXj2lYOpXvzSzHdnHf1aKFWRRw3Yx737rQFGLSgTqlT+mZf4aKrrQMQwEQ+iXHoGAJJHAG1aL5aXh9F5Bf/SYd+9xGnj/5MReXb1V4tiHJPZoFEtVNfhIWbQ2snm6eI4DPmfdOBBl7M2EbOMWYBnGMj72Vr6yLAyudkPdad2HIlv76Az7NfE8zK9pUdlfqLGqiYdKDWs074Sb5L2SKjEVLgyUvFUy2oCsGciEpyNQS6i8XuH3ldN1I0XhOOsVd+nLyqhqsDB6X7Ao0d555r+KdJwhpezBe9RXH9qlXFaVR+YWhn0hea0Y8Dut+ki8lNIvB1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5cqK0oqVyL00SocNpOxPMzpHcYv2yoPITHwL0AD9SA=;
 b=Zf/ZvLBvkC+PB6GPUtFamfQVwmqtK4+cp4mxrWTngfBzcH5eBCe91C58BlvXYK8p9ZOYPbedxG4n7/5YtycURvxrW/MAYyNbpqiZ9/+HQLlQ0cuN7tW0K7bNJJ0wK6QY4ZNuiiMO5uNTjhfU4B0sqIpwMRQxPirT594LyPvzzmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB9467.namprd12.prod.outlook.com (2603:10b6:208:594::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.27; Mon, 11 Nov 2024 07:03:16 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 07:03:16 +0000
Message-ID: <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
Date: Mon, 11 Nov 2024 12:33:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB9467:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d65800c-ed89-4dc0-d44f-08dd021eea40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGhVU2dsenMrTzZYMVNUZlF6N1l4dFl3bEhNUUVjZmJXcTJVRUVBYVhnSzkv?=
 =?utf-8?B?N01lWThRb1pwRkd3K0VxdUIxVERjU3FZcXpoWXVBYlpoZWZoNnZNVGgrc2tC?=
 =?utf-8?B?N3N3aHA3aUpnTHk1dUtqN0lyc0I2bXZpR1g5ckxiUGZUb0x0Y0ozcURpSVZZ?=
 =?utf-8?B?c1NiNlJpbHIxTHdmSjZGWWMrYzVTbXpxSk1lVUhvM1NadkVWWWhKcThiUmlt?=
 =?utf-8?B?QjdLMFV3QlE3TlRsOW5MSE1ic1NLL0JtK2lZMHlDZkYxeFozYVdTQTJUVnlo?=
 =?utf-8?B?M1lwQXdiZThZZmkxMHU4dGI4a1l2OEZycGk5TmdNSHVlaHZFb1MyMEJ3RU42?=
 =?utf-8?B?Mm5iemV4L28zajJQZHlPdEVuUW9tU2kySVUxT3k1WVVUYVR2YkFkT1UwNjk5?=
 =?utf-8?B?dllwUHN0dXViSGkvSTdybzZOVUtmNllJWmdxeWk2VWp5cDNLd20vSngxcHIr?=
 =?utf-8?B?SEZ6amh2ZitwZUdueStUSHRhYy9ZTnlyZjA3TnZKa3czaVR3VEJ0L0pMaGNE?=
 =?utf-8?B?OVJRRnRlR3BlYXMycG9rUFFicTVLTlQ4SmxaaWpoeWpmeDdYZHEwMFkraTZF?=
 =?utf-8?B?ZG1OWnBZTTJwZ1JwRXNlcGt2T1dRSE5wRkxJbUZadmNkYUMxQjZjRmRKc0to?=
 =?utf-8?B?bXZUbDlOencyU2ozeTJuSmliaE5VZXB5Q203K0Z6SnVEU2pZbTg5VmcwNS9N?=
 =?utf-8?B?UjZ4YSsxNFhOdnRJblhLRmJ2eU1JRlhkRUtacXlYTmlWcUUrNkxUTjE2OS9m?=
 =?utf-8?B?cXR2VHpmcUxIRU9rcG5KUFd3MStaTHZoczFmQTVjaHZDbFRwdkRyMlZCWTlD?=
 =?utf-8?B?c1V3UStOSjRuMGsrbHhmdWd3N2lwdzFLNHQydnNoSFAxR0xnWlI2MlI4dXNN?=
 =?utf-8?B?L01oYW4vbGhrL0hSeFpNNkNGd05TTTVvUVNmMlR0cG1BZERRVWtNZ3owZVZn?=
 =?utf-8?B?ZzBUbVVZRnBUZDU4R1U0VE5tZHIxZmhRY0YvK0tjakJZeXErK0dzRVdhcm9X?=
 =?utf-8?B?eGdVOEorNHA1ZUtFbkhSc1BmL09TQTFHVE11TWxtS3NOL2RhVytNb0U4aDNV?=
 =?utf-8?B?R01ydURoQXNEVFRFOHVxQUF5SGlORmE0NUpaZjU2aWZkKzhKbjFnMXVXN0lJ?=
 =?utf-8?B?dGV2bkpja2JjckxNbG5GR3dNckJoYWhiYXNHSEVFNHBaRDRMMWJYaUJUQmQ4?=
 =?utf-8?B?Y3IrWlRMZTFsTzhPdTFVUmZVSWEyOEgwTUxUSXYrWE91TXlVYmJsZkpzdC95?=
 =?utf-8?B?Q3dTeGdra2J3N3plYjdkdGxlSlFEbUVXaVZmTFIyRjAybXBwcVRFNmE2L2l2?=
 =?utf-8?B?cll3WC83TElLWVhTemNVVERtZlJhZ0tWWWZ1RlR2Nk1pcFRQMjFyMUtqcEhq?=
 =?utf-8?B?VEtVQnRKeHQvYUVRdmo3aUZ6L1NHcHJ5K2dYdlhLcXBnMGtVTklPZ2ErZmRM?=
 =?utf-8?B?TlpmT0JlckZVaUU5R1dqTnkwb1ZPOFBwS1BETTh6WnB1Y1I0SEdJNG53U3Er?=
 =?utf-8?B?NjVtaTRzRDNBR1JVYVZveXBXOW1xNWZvZnY1bDI2dW5iQVNQNFhxaU9Ddlox?=
 =?utf-8?B?T2xZRjZqc0ZZUU4wZkZNcGNra2RSaVUzS2lDZmxGUm1zWTlxeWp5dW1rN2Nv?=
 =?utf-8?B?bDRYUnFRQXhyWjFpQTU5d0dyM2dyOUo4UkVyZVFTZTljeXcwY0t6aDN5TmxN?=
 =?utf-8?B?ZWRoNUJxNWJXelpaSUhxTTd2eXI3RjVEeWJSVGVoTjZTOWFZMzRCMmlYN2cw?=
 =?utf-8?Q?gDIAh7XxBzrVYTt3qYN5kc4G95k10F52Z+h3rAq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjRkMjFaN3UvTE1tZ24rRnk1ZzlDSlJYa1lLTE5EZGxZeU5nd1pCdE1weGsy?=
 =?utf-8?B?cnRvYW5Sa01FVFUrRXVJMWhJZERhQ25odzFMb1EwY3FxemQ1R2RKNDdUMDJa?=
 =?utf-8?B?Ny8yTlV1TFU4ajltY1Y4UTNzMXZUdnZqclRjMkk4a2RQajM4aFd4dXVRcWlk?=
 =?utf-8?B?bXNKdGErbzJ3SjJaNDhyK2UzK3FyVWd5dWJLbGl3WCt2bU9jd3VKbVNGQnBa?=
 =?utf-8?B?RUltbmkvMlA2TTBBOXQvV1VTUDg3NkQwenhJNEt0ejdqT0xZeTQ5VUJtUjZk?=
 =?utf-8?B?bTdNdHJ2ZW5vajRuTUY5Q2xJWnVVYnlwUXYxVis4bC9FcGQrVzBFS0poR3l0?=
 =?utf-8?B?RVdUM1Q4Uk56c2kyc2xNT1VqZldZdDFGRFZuNlVUZXJOVzZrSjZFWkx3NjFJ?=
 =?utf-8?B?bHArZEVWdEs3QWdkb05Zc2lsRDRmS0owdGduOEF2QUtQWDZoNWowWW9ydzN3?=
 =?utf-8?B?cVQ4YUFMdXdEMjBNY0ZiQVVQSUg5blpGemVvRkt6cDc0V3hZZ1laZUxmQ2py?=
 =?utf-8?B?MUVheG1KSUtjOFBOWjNLb1VzSXNjNE9BTDZBeGxRY3hNTi9ERjZJK2J0ZXBk?=
 =?utf-8?B?TkJCQkJCK2JuY1RBL3Q4elB5eFRrWnlzSW5wR2taN0JmeTR5d201QTVMZ0dn?=
 =?utf-8?B?VUpEM0w2Q1JIWUd4T0dUVmdpS2E0YVU3dkcydUtwZzBHdDQ1MVVYZjZYWFk1?=
 =?utf-8?B?Z2FEYnVDUG9sQStqTzZkNGcyYW1qdm1hMXRWc0p6cFBUTW9WRkM2NFJMUENm?=
 =?utf-8?B?TC9LUkQ3VWpPc2p3WE5uZGE4Vk40MFBMcEVTSEZjV1laSENTZ05Wbk1nS3Qy?=
 =?utf-8?B?amV0NW52ZFpYQ3UwU08yUEZqVHZrZ3BkV1NiaTlyKzlhejRUNHhnYS9xMU1Q?=
 =?utf-8?B?b1VtbUZNTG9yTmVyT3hicm01emlQZ0FjSUp2MWVrY1JqTGNzeGVZNENxWEZy?=
 =?utf-8?B?bzZPcUxJVDl4Q2VzOXJtN3F4M2RrZVVMTkJ6L0R1TnVJRTZyYmEwRm42cFVI?=
 =?utf-8?B?dWl4WWJmVDF3Uzl2dWNCc1h1Y1Q1VmkrVG9JL0ROMGVvWlFsTjUwSWxUdzll?=
 =?utf-8?B?cEFXeWpETnJmRFVVVVo4RHBMYkhHQUdKdnNBZnBKSlI2UHpmRW9lMnNmVzdZ?=
 =?utf-8?B?NnRGYzgxTCt2WWJ5Z1hmdnFlTlJHU0dzK2xFdFNiZGlVdnM1SWFhbEl3ZnJu?=
 =?utf-8?B?WUV2SnZJM2k3R3UyYTIxWGp2WlRBOEZGNnd5eEhQditpMzVITUxuTVhHTVdR?=
 =?utf-8?B?akdXQW1XOFZTcmFBeVg3WUNaOWlsMVE5aFZwYURSd1VSOUp4ekpEZU5mTkpk?=
 =?utf-8?B?TjZNcUJtaFhOQXBqTzdhL3k1bzFYTEZ4MkVBNjlJL3d2amtCN25kS2N6N1V2?=
 =?utf-8?B?V1VtaEN4Vm9yYmZMcWxKSzBqSTY4MGFjTDdDZkM1SmdTOVAvTHlxRjJhUU81?=
 =?utf-8?B?T2tlUElvT01GaXhvNlYrc0FpeUhGbHpnZE5mV2EzeENMWlk2QW9FZ3JtdDY2?=
 =?utf-8?B?UHFBcVlIdXdPNnc0cmFXK3ZXclRuZzJtbjQyR0ZTWHRVT3VXK2lRTGo3Skwy?=
 =?utf-8?B?Y0VGbzUxY1ZnQ3NkcWVJa0krdGlwMUFvTFBoTUNXcTJPTjRBOFgxTkNRVGxX?=
 =?utf-8?B?UjhXbStoQ0JNTEVGd2ZSYzA2Qm5kQUsrRFNuUU5uVkpNVUg3SEw2L05FUUhN?=
 =?utf-8?B?RUx0Rytjc2ViM0grdytoMjhtWWlMWExsbUorTjd2Nmo4aENrQ1NlTTIrSEx0?=
 =?utf-8?B?bUtVY1hPVGtsMFhsNFlPVkRhOG16aHBTTFlYd2ZEZFVHWmNjTGFNQXU5OXRN?=
 =?utf-8?B?cTlnaG9QVDhLVC9aWmRKNVM1eDlaVlo0SkdSNWx2WWw3OTVRaENlRmRDUnFp?=
 =?utf-8?B?bVZ4c1ZvSzhjRExhVUtlZmtmakZaYnNPc2VsKzFvVXdNdGlRUXRLY3FCS2VQ?=
 =?utf-8?B?SkJCWlJWNmpvN0xFSHlFOFovMGJQMGNJM2lodjNEeFF1UVpiNXNjaXhORGwx?=
 =?utf-8?B?Zm1kRXkrUUdDUkVUUTE4emRHRjExclEyQW55Q2ZvS1pLeGx6NmhDcnZJNTIx?=
 =?utf-8?B?RTVRNHBhUWFzcHZYWTlpRE1CLzJTRUV6cjZ4UXNmSVg3dS9hZ09oam96ZVVw?=
 =?utf-8?Q?tBF+M/YN4f6Q307NNqS/m696o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d65800c-ed89-4dc0-d44f-08dd021eea40
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 07:03:16.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSLJfVvbrnAJf67xq254xsLrW1e7HOFDoCzGhNpQqQVXQTp0QWvgHPZ9pKSRcAuMAIOoNOkMwj3jiHcgH9p0zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9467



On 11/1/2024 9:30 PM, Borislav Petkov wrote:
> On Mon, Oct 28, 2024 at 11:04:21AM +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
>> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
>> used cannot be altered by the hypervisor once the guest is launched.
>>
>> Secure TSC-enabled guests need to query TSC information from the AMD
>> Security Processor. This communication channel is encrypted between the AMD
>> Security Processor and the guest, with the hypervisor acting merely as a
>> conduit to deliver the guest messages to the AMD Security Processor. Each
>> message is protected with AEAD (AES-256 GCM).
> 
> Zap all that text below or shorten it to the bits only which explain why
> something is done the way it is.

Sure, I will update.

> 
>> Use a minimal AES GCM library
>> to encrypt and decrypt SNP guest messages for communication with the PSP.
>>
>> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
>> Processor and initialize snp_tsc_scale and snp_tsc_offset. During secondary
>> CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
>> GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
>> respectively.
>>
>> Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
>> that can be used by the guest to query whether the Secure TSC feature is
>> active.
>>
>> Since handle_guest_request() is common routine used by both the SEV guest
>> driver and Secure TSC code, move it to the SEV header file.
> 
> ...
> 
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index c96b742789c5..88cae62382c2 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -98,6 +98,10 @@ static u64 secrets_pa __ro_after_init;
>>  
>>  static struct snp_msg_desc *snp_mdesc;
>>  
>> +/* Secure TSC values read using TSC_INFO SNP Guest request */
>> +static u64 snp_tsc_scale __ro_after_init;
>> +static u64 snp_tsc_offset __ro_after_init;
> 
> I don't understand the point of this: this is supposed to be per VMSA so
> everytime you create a guest, that guest is supposed to query the PSP. What
> are those for?
> 
> Or are those the guest's TSC values which you're supposed to replicate across
> the APs?

Yes, that is correct. The BP makes the SNP guest requests and initializes 
both the values. These are later used by APs to initialize the VMSA fields
(TSC_SCALE and TSC_OFFSET).

> If so, put that info in the comment above it - it is much more important than
> what you have there now.

Make sense, I will update the comment.

> 
>>  /* #VC handler runtime per-CPU data */
>>  struct sev_es_runtime_data {
>>  	struct ghcb ghcb_page;
>> @@ -1148,6 +1152,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>>  	vmsa->vmpl		= snp_vmpl;
>>  	vmsa->sev_features	= sev_status >> 2;
>>  
>> +	/* Set Secure TSC parameters */
> 
> That's obvious. Why are you setting them, is more important.

Sure will update.

> 
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
>> +		vmsa->tsc_scale = snp_tsc_scale;
>> +		vmsa->tsc_offset = snp_tsc_offset;
>> +	}
>> +
>>  	/* Switch the page over to a VMSA page now that it is initialized */
>>  	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
>>  	if (ret) {
>> @@ -2942,3 +2952,83 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
>> +
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +	static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];
> 
> You're allocating stuff below dynamically. Why is this buffer allocated on the
> stack?
> 
>> +	struct snp_guest_request_ioctl rio;
>> +	struct snp_tsc_info_resp tsc_resp;
> 
> Ditto.

Ok, will allocate dynamically.

>>> +	struct snp_tsc_info_req *tsc_req;
>> +	struct snp_msg_desc *mdesc;
>> +	struct snp_guest_req req;
>> +	int rc;
>> +
>> +	/*
>> +	 * The intermediate response buffer is used while decrypting the
>> +	 * response payload. Make sure that it has enough space to cover the
>> +	 * authtag.
>> +	 */
> 
> Yes, this is how you do comments - you comment stuff which is non-obvious.
> 
>> +	BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
>> +
>> +	mdesc = snp_msg_alloc();
>> +	if (IS_ERR_OR_NULL(mdesc))
>> +		return -ENOMEM;
>> +
>> +	rc = snp_msg_init(mdesc, snp_vmpl);
>> +	if (rc)
>> +		return rc;
>> +
>> +	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
>> +	if (!tsc_req)
>> +		return -ENOMEM;
> 
> You return here and you leak mdesc. Where are those mdesc things even freed?
> I see snp_msg_alloc() but not a "free" counterpart...

Right, will add snp_msg_free().

> 
>> +	memset(&req, 0, sizeof(req));
>> +	memset(&rio, 0, sizeof(rio));
>> +	memset(buf, 0, sizeof(buf));
>> +
>> +	req.msg_version = MSG_HDR_VER;
>> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
>> +	req.vmpck_id = snp_vmpl;
>> +	req.req_buf = tsc_req;
>> +	req.req_sz = sizeof(*tsc_req);
>> +	req.resp_buf = buf;
>> +	req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
>> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +	rc = snp_send_guest_request(mdesc, &req, &rio);
>> +	if (rc)
>> +		goto err_req;
>> +
>> +	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
>> +	pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",
> 
> Prefix all hex values with "0x" so that it is unambiguous.

Sure.

> 
>> +		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
>> +		 tsc_resp.tsc_factor);
>> +
> 
> 	if (!tsc_resp.status)
> 
>> +	if (tsc_resp.status == 0) {
>> +		snp_tsc_scale = tsc_resp.tsc_scale;
>> +		snp_tsc_offset = tsc_resp.tsc_offset;
>> +	} else {
>> +		pr_err("Failed to get TSC info, response status %x\n", tsc_resp.status);
> 
> 								Ox
> 
>> +		rc = -EIO;
>> +	}
>> +
>> +err_req:
>> +	/* The response buffer contains the sensitive data, explicitly clear it. */
> 
> s/the //

Sure.

> 
>> +	memzero_explicit(buf, sizeof(buf));
>> +	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
>> +
>> +	return rc;
>> +}
>> +
>> +void __init snp_secure_tsc_prepare(void)
>> +{
>> +	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +		return;
>> +
>> +	if (snp_get_tsc_info()) {
>> +		pr_alert("Unable to retrieve Secure TSC info from ASP\n");
>> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
>> +	}
>> +
>> +	pr_debug("SecureTSC enabled");
>> +}
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 0a120d85d7bb..996ca27f0b72 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -94,6 +94,10 @@ void __init mem_encrypt_init(void)
>>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>>  	swiotlb_update_mem_attributes();
>>  
>> +	/* Initialize SNP Secure TSC */
> 
> Useless comment.
> 
>> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>> +		snp_secure_tsc_prepare();
> 
> Why don't you call this one in the same if-condition in
> mem_encrypt_setup_arch() ?

kmalloc() does not work at this stage. Moreover, mem_encrypt_setup_arch() does not have
CC_ATTR_GUEST_SEV_SNP check.

Regards
Nikunj

