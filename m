Return-Path: <kvm+bounces-28414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9C2998356
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5E25B263B8
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76241BE86F;
	Thu, 10 Oct 2024 10:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VMVYulQZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FADA1A00ED;
	Thu, 10 Oct 2024 10:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728555319; cv=fail; b=ekajj4FmOyjS4PkZTnWjdnbj+DlT6VpqOSuIsVOlGFdbEIR6J0f186WjG77/fuzBOB78u8E+E9CdtW9VE8vwnBW4fGVohzLXtF2CMvV8sBV707U4FURB8oNeFjlKktkClLUILk+PDvXHqkEUbYCVU+NfQ/EzEBpfswTgffP9Pms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728555319; c=relaxed/simple;
	bh=6mh4c9LUp+ixFQviEG4QA5WpYpP5h6n/mZHh+/WF2BQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IBELe0jM5nHOP9RIitQmg8J5YRkcgtP9A/SE1i0EM/PnfZJaa1T36laMfMvnURCD5P+CQ56RkCswuWIbl+AntDhtB1m1w+Ca+4soF/CeZklekQ3icjF9xT75wH5Z/sznrj2Co1hcSW126wrkfliRbtca8xh7OciUjrV6uYHJUsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VMVYulQZ; arc=fail smtp.client-ip=40.107.92.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpYBlyx075cz78xFl2qFaIRKvDJXrGjWJR+HgW8Y+rJuIMx8oNhiE8tvNM5K9YiSp8mpyYIGbQCrqZlwGp0Q5qaLOG0pAXNPEV/5Q67aWdP0dE+lnKlT0AVD40igUSFfEGBZvygOycktfvsFEdZ2jEh0PqoIn7TbQU9LDhrHkwKHEYd3pwNgARfx1Y9TRnLfCQ5DBOAuHk7OVFF99TQdQ2hdRBBy97qbF3Uyoexp4T0ZZnVQrZtj5FPhqybK48xyecGy45XzPGlLuAqVQ9nK//KZ1Cxu2UF6VCk13AciBsrxZJCY6pJgZtGk2VdpWK4mLgC+2X7e8pfE2o+WhGIzpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di6tYAWHWNG3MRdjjh+o3z/+nZQPzh8H4aauvEmVnzo=;
 b=anV5EnscaMTXfMCqJaky9xIby4m8p76QGCe1cvzyebBAd3L1sniFw5306kf2NOvWDXDVbZfEEIi+qGF458yLUURvhnaZT+lhSl0mhS7J3dWCCyqzH9SMnpfQ9KadsxUaIiHEzAOyQCHwBggPPfqNNhYIx1i0y9wtrnu1Dwvg1p15KZklRI8UmtfLHJSuxNouKQH2US2c0M6/e5xiMaiMMstsc+G2i0HTWwwp9aRnkEQZRRiF6ON9TLbXqEMYB8U85y+ZpcoIsW6KfZVjDWov3IMItUt74we+gaA8LfA9sKzHTzz63YAvZ5mZX4ZZ5M+r5u+80RU4XPToh/m1/mGsxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di6tYAWHWNG3MRdjjh+o3z/+nZQPzh8H4aauvEmVnzo=;
 b=VMVYulQZ5WCWEDoprBQw0mceFimoUoQAG6hpfC9EibaO/gV10Q/562egKOwiHTOOTjn+pY/44zy9vTnvv8LuVP6lQ+TipdHyEbMq5mDiVMfQ3d797Oh+nuhhpu6EXXb79+Y6/vYsN6HzAx5cgGH92WRYqhLhTyYvwztHXa1IIAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6763.namprd12.prod.outlook.com (2603:10b6:510:1ad::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Thu, 10 Oct 2024 10:14:55 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8026.020; Thu, 10 Oct 2024
 10:14:55 +0000
Message-ID: <86d7579b-af67-4766-d3ae-851606d0b517@amd.com>
Date: Thu, 10 Oct 2024 15:44:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 16/19] x86/kvmclock: Use clock source callback to
 update kvm sched clock
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-17-nikunj@amd.com> <ZwaoPJYN-FuSWRxc@google.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZwaoPJYN-FuSWRxc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0123.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b16fc4b-b9b6-4f2d-5e18-08dce9146350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yyt4U0NsVjJoT0FaeEdGRVJ3TmtjaUhDWHQ2TzI3MTU2aW0zSTdEd2czdkpD?=
 =?utf-8?B?dEE5K3Fvd00zZzljQ1VPd2oyQ1RlSmtUcit2U1BldUdXRFNRNS9TaWJSQkMw?=
 =?utf-8?B?WS9WNmlCdzRaU2dvcW5xOWlxVG5DWS81WTg4bytCRHNjemxLVFdta2ZDSnY1?=
 =?utf-8?B?MkpPUldmbkJNWGE1Q1E3VXgvTlJZdC9Hc3psTVN5NEhwMEVxN092T2VkRDZO?=
 =?utf-8?B?aEMrZ0FRdW00bzZBbng1N0pDZFR5djFWOGQ4NnVhQ0QvUmx3dnVDdmt6TEhZ?=
 =?utf-8?B?eGVXSzFFMHdSdDBvb3M0L1E0Tk9xejVYTEhEU2o1alJ2TjAwOHhpdzlsWkR1?=
 =?utf-8?B?aklrWVRvclRzUnFTeFBKR08vUXlBT0g5MExWL1RQbUIwK2ljTTBHQjByNTdK?=
 =?utf-8?B?OVpBL2ZXcXVRWFZHdmdkTmdkdTdNN3Y1Smd6S3dIdFdER0tHelRpU1MrQ0Vt?=
 =?utf-8?B?Znh0b1hnTHplaGhMQlFja3V2V0dGQXY3VGZTSWpWZURxaDJscmtOSlBLRTV5?=
 =?utf-8?B?akxEbTRTeHN0bHA5dDVxMzdOT1Brd01NYk1adTFSTWZXMnp2ZlZNaHc5TXlX?=
 =?utf-8?B?d3pTQjJPbGhKdE5FUTBxOVd2VGozV1ZIaWtjTWxOc1IwcEF6ckx6SjhqZG11?=
 =?utf-8?B?NEQrZjB2V05NeWozeDNtRmkvazNMM28xKzk5dnl4djNuYWdNcFhJRmdFUy92?=
 =?utf-8?B?OXBTVjRHSDVPTEdJY0JYUm5hZUlhVU5sRi85dkJObHlOYkk3QTJtS0Y3SG45?=
 =?utf-8?B?dTBDZnRSQ2h0c0JodndkemIxOXBwMHpobUxub3l1M2l5aCtVbkF0Nys0eXZl?=
 =?utf-8?B?TTVHWC9pK0ZmZ09VZ1RwbDExaTNGTUg3ZlZuRTF3NTcrZnJ2eGJlQzlMTmwx?=
 =?utf-8?B?L1J2VnVuUm50ZEZkRjl4TU5uM0VEaUJoY0NHK2wybWZvZDV0NEZOb21mQmtH?=
 =?utf-8?B?cFNuZG14RDJmalhSODFCcXV3UHdnTFoyMkx3dnpZTk9MdndpSFN5V2VIVmUw?=
 =?utf-8?B?REdtNFRmY253R0hSYVNKa2VsclBqbkMzakUzc283UEpWQUdZTUNzQmdnMXFv?=
 =?utf-8?B?ZUg0Ky9XWHhYR1kvOGgzeWozN1RHZVdXb3BnSk1tUjU3Q1pQc2x5U3hLZS85?=
 =?utf-8?B?bjZDSTZhaWxzMS9jL1Y1N0VKMTloNVZESHpDUnVoV2lPVE9nd1JqbWxpdDh3?=
 =?utf-8?B?STZxR3UwN1NtZXdNQURnTlk1ZUYwZ3RpTEo0SUNQWkllKzdOczQxZjZIY2JK?=
 =?utf-8?B?eHI1RENHNDNLemJ0aUlVdER5MFkzRGlROUMzUWU1SlJ6dzRDTnA1YzUzaEdh?=
 =?utf-8?B?WkRIVVAyZ3VOeTlvREgvNkZKRFM0aDlXckVrdXdDSVQvZ1NLaWprL1dlRysy?=
 =?utf-8?B?K3JuSFJNdmthU0IwMU8wTzBSM2w1eFdkKzQzR2tJQmJaK1NvMlFYSnFrY1la?=
 =?utf-8?B?Yk05WVdtU25NR0hxRFpxdGF0MFovdFpISkpiY24vZHJJSWN4UzRyV0RNYWc4?=
 =?utf-8?B?SnNKOUlFQWdmbEtuemgyc09OalFGZ1Yvckt4RXpZVkVLTWFTZjJ6TVJ5RnAx?=
 =?utf-8?B?S3p2OU5QMENjRWtvN3FnekpMRXg0SlQwQjVNMW03KzQ4QWdEa1dVREVONEtr?=
 =?utf-8?B?L2h4MFBQYnYyRHRjMUQ0QW5ncThTQ2xqWW9XblBxZWdOM0lqbjVnU25FTUFh?=
 =?utf-8?B?M3d6VWhSd250S1U5cVJnRmtEMFFWdHIyaFpuYmhreVYrTWY5ZWhTemt3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVBRNHdmSTdsbXJaZ3JQUVc0TUVQOWEwWU9NckxyaC9DK0xYS1JoZXVLVXE0?=
 =?utf-8?B?TUp2RnNiQ2lrMUt4elU4LzJMOXdCUGltOExXR0ZxQURMK1JoeEtXOTFDU092?=
 =?utf-8?B?RnE4ZWFQTUNCbmtzMGpSL1RZdFFnVUE1bVBHbHNqWkx6QzRtMDA3ZnY2dXJH?=
 =?utf-8?B?bmhwTnpyUXFxS21sd0FwWG9jRkdFOXF5Zm9hNmpueWgxbGNPb2hwblYrdC9v?=
 =?utf-8?B?MFoyQjV3M0RyRTcwQjduc1crZVNjTGlBb3dHVlhidkFQZ3lYZVd4Z2Ntc2FJ?=
 =?utf-8?B?K245Ukk1Sk4yZGtZVlpXK1V4MzNpSjN4NEdEQ3RMdEkyT2FWTSt1TVBRdXdq?=
 =?utf-8?B?aFJTSVVTRDByMlJuTDExbXcrcFFLdDNxMzRuSG5kTnZBUUlMY29LTHVodFEr?=
 =?utf-8?B?eFZRL1l1K2JrSnUrOTFIVklZRFRWVkdtU0RkQ2h2a0xUT3JUbGFyUzBLa2RD?=
 =?utf-8?B?cDJYa0QyanhuU01ybEQyQS9yaDM5cWtaeGptWXUxK25ML09RdFZkZWpCNkl5?=
 =?utf-8?B?VEU1dTV1VjdrWWxZQ29EbjZQblgvRU1XWGgwNHhZeVAvZVZVcVdsVU1WSFA3?=
 =?utf-8?B?eDFUWlkxZUZ6SHlMOUhmUE1ZMnFLOWpQaVJmNHR3aTArckYwUW1PVGxQOFZX?=
 =?utf-8?B?NU0yMWdRdnBIVlIwWkFyb1pwcnFmcFdNdXU3QkhrMjZ4bHJTN2FudlkvQ1p2?=
 =?utf-8?B?OHZzYXBadkNFSmFrenQyRGJZcDVJajltU2tNdkFGdWgxeHlDR0JHeWkxM2lo?=
 =?utf-8?B?V0pxKy9oOW4vNHBTeTJCdDk5cFZaWUlLdGtEcDFSZzQ4RTgvOUtHdlNtUXRu?=
 =?utf-8?B?S2QxZDlyMklvTHdPdEFDVzAxSTJYalZOR01zMnMyNWY5c2NQcmR6TGhVU05w?=
 =?utf-8?B?ZTh6bTVBUnJTYVZlNWZRSys5VjdDb1RHejBabVUwZXcyYnBaQmpOanhpWlU3?=
 =?utf-8?B?ZVBiV09nWmt3b1BBeldNTjNrWnZlMTJwRXF1dyttaVdwbHNHVzI3T1ROTEhn?=
 =?utf-8?B?QXdqQkVqNERHMGZVRVc0RzV0dnJ4ZnBmOUZiQTI2Y2VMMEhoUWpSdjk3SXI4?=
 =?utf-8?B?Y0JBT3RsajFvV3VrSzhFbkNqWTZBZmVIajkzeW0xdkd3bFFUZENJU2g5WHMr?=
 =?utf-8?B?aVQ5S21HUXdDR0lLYzhPRXZ4RUxNVFZ1QTVSaWVGd3p6QkN5dWFQMlhIckFB?=
 =?utf-8?B?R0NTdGJ1SEZkNzAzSE1sbXoxaGtMTDlOYjM4NmxaMVdVMlJRdHFNRUtyVm5I?=
 =?utf-8?B?dko0Q3hhMlRrbUNOek9PZFllNFplQ2xqYUxUZGlITHVOS0pqWUsvQ09VMHpL?=
 =?utf-8?B?aFFwRnVHbzhBOGNlekhXNTZ0bWJKRE14aEg5QzlUb1pHUTBQVndkYTVzb2Zs?=
 =?utf-8?B?SndnRTdFRW1SVTRXbjU2UlEyYW1SOHF2Rnk3RlpabTBsQm5ET0lLK3pIQkZQ?=
 =?utf-8?B?ZFY0SEtRdzFONTNjdktrZDZpRjFzYlM2dzBmb28wamNud0dGc0FtcVk3VW4w?=
 =?utf-8?B?WkJ0MXd2ZXgrbzdDS2VGVzVDdEhsMUZLUFlOeXovTWdETGlwTC91NWpGZVZx?=
 =?utf-8?B?STVaOFRoZlVMRUNpRUsvU1hENkVQQ3E4YTFneXMvWFVCa1BKTXhuT0t0QmZM?=
 =?utf-8?B?dmdWRnh6NnNMTmdjSFhtd0Z0T0NoZTkxUUp5QkZ3WUl3NW5CbkVyZlJWTWJq?=
 =?utf-8?B?OUpyNXZzY3UxbU1nSTN4UVZDOW5RN3FQN0IrQ0ZoZWVaZGFXVDBqZTVHOEk1?=
 =?utf-8?B?Ujk2bW82UTB3USt3RVp3L1hRZFFlang3TzhIekNEa0JENVFoT1NyMDV1ejJT?=
 =?utf-8?B?elNRdjkwSFdtYjIvVDBueG9QempBcXpLZnZ5YzZvVG5tOW1oYmU5OHJvUXQ3?=
 =?utf-8?B?Q1JFRXJLL2hjYlhaaEVJZnpXSWE0Rmpqc2s5UDNQaG5IZTZ5WVFJRFlORmNk?=
 =?utf-8?B?RS9OZzV5Rzd1ai9XR0pNL1d4UW9QaktSalU5dTkrNkhYdVF0M1N0ck54a2NJ?=
 =?utf-8?B?ZklEUXh5NGFhTVR1OXlvN3ordGFJTDJSTlNRTG50WW1HYkd3UmV0V1ZRdWsw?=
 =?utf-8?B?azFyU0NJbjNaTlRDZ2FKRXVGTUFjVS9vWlUxbGh6dTEvKzlRTlp4azZpL1pr?=
 =?utf-8?Q?C2sUj5gjQPDw1yrnzQyMbyjYD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b16fc4b-b9b6-4f2d-5e18-08dce9146350
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 10:14:55.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEOcWcUA/RCHyFbVhEIYkYjZada11HZAWAf8yetiSt+T0gg9Dj8Ea+tnSkQlFWmFjHDCjTKP+UoNdmDOvf79yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6763



On 10/9/2024 9:28 PM, Sean Christopherson wrote:
> On Wed, Oct 09, 2024, Nikunj A Dadhania wrote:
>> Although the kernel switches over to stable TSC clocksource instead of
>> kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
>> This is due to kvm_sched_clock_init() updating the pv_sched_clock()
>> unconditionally.
> 
> All PV clocks are affected by this, no?

There are two things that we are trying to associate with a registered PV 
clocksource and a PV sched_clock override provided by that PV. Looking at 
the code of various x86 PVs

a) HyperV does not override the sched clock when the TSC_INVARIANT feature is set.
   It implements something similar to calling kvm_sched_clock_init() only when
   tsc is not stable [1]

b) VMWare: Exports a reliable TSC to the guest. Does not register a clocksource.
   Overrides the pv_sched_clock with its own version that is using rdtsc().

c) Xen: Overrides the pv_sched_clock. The xen registers its own clocksource. It
   has same problem like KVM, pv_sched_clock is not switched back to native_sched_clock()

Effectively, KVM, Xen and HyperV(when TSC invariant is not available) can be handled
in the manner similar to this patch by registering a callback to override/restore the
pv_sched_clock when the corresponding clocksource is chosen as the default clocksource.

However, since VMWare only wants to override the pv_sched_clock without registering a
PV clocksource, I will need to give some more thought to it as there is no callback
available in this case.

> This seems like something that should
> be handled in common code, which is the point I was trying to make in v11.

Let me think about it if this can be handled in common clocksource code. 
We will also need to look at how other archs are using this.

> 
>> Use the clock source enable/disable callbacks to initialize
>> kvm_sched_clock_init() and update the pv_sched_clock().
>>
>> As the clock selection happens in the stop machine context, schedule
>> delayed work to update the static_call()
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kernel/kvmclock.c | 34 +++++++++++++++++++++++++++++-----
>>  1 file changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5b2c15214a6b..5cd3717e103b 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -21,6 +21,7 @@
>>  #include <asm/hypervisor.h>
>>  #include <asm/x86_init.h>
>>  #include <asm/kvmclock.h>
>> +#include <asm/timer.h>
>>  
>>  static int kvmclock __initdata = 1;
>>  static int kvmclock_vsyscall __initdata = 1;
>> @@ -148,12 +149,39 @@ bool kvm_check_and_clear_guest_paused(void)
>>  	return ret;
>>  }
>>  
>> +static u64 (*old_pv_sched_clock)(void);
>> +
>> +static void enable_kvm_sc_work(struct work_struct *work)
>> +{
>> +	u8 flags;
>> +
>> +	old_pv_sched_clock = static_call_query(pv_sched_clock);
>> +	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
>> +	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
>> +}
>> +
>> +static DECLARE_DELAYED_WORK(enable_kvm_sc, enable_kvm_sc_work);
>> +
>> +static void disable_kvm_sc_work(struct work_struct *work)
>> +{
>> +	if (old_pv_sched_clock)
> 
> This feels like it should be a WARN condition, as IIUC, pv_sched_clock() should
> never be null.  And it _looks_ wrong too, as it means kvm_clock will remain the
> sched clock if there was no old clock, which should be impossible.

Makes sense, I will add a WARN_ON to catch this condition.

> 
>> +		paravirt_set_sched_clock(old_pv_sched_clock);

Regards
Nikunj

1. https://lore.kernel.org/lkml/ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com/

