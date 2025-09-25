Return-Path: <kvm+bounces-58762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B386B9FBBA
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97D9166E49
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28922BE048;
	Thu, 25 Sep 2025 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UaqshKjD"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B342BDC01;
	Thu, 25 Sep 2025 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758808494; cv=fail; b=KZ58nhcWZApPdMvoahCWRBT2EmdwupldluSktIVJyP6Thkx6s5bx3TngOz2tQwBux702wpNOpXluXzpFuOQUlIvlwmMzD27y7wDYpTiJU90L4TtlugoeSF408jH9kIB+7fMoxV5lxbwsc1hO6dtsxieUkNIsNDbrDlrWxOamCfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758808494; c=relaxed/simple;
	bh=L+Kg0JxkDGd/cncrP0cCSMDIv9ys4LxLJqTygW+P6RM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t0eaguka6AcJYb6sn7gHn1r6bpZZIhBRLSdObxwsBNXoYpUWtqyZwV6myNq6Lud6tvkhGk8HzVQLhr0ZpllcKm3mND5/QcPjgQVZY+lhghFoHQFVmZulqwuUnWGZXZ9BiKrI5nbGfIUuguvgqguUIDfMiKL7EUwUwnPSyKCR2ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UaqshKjD; arc=fail smtp.client-ip=52.101.46.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1pJSA1d+8x3dWlG1DsNAvlE5hG4rEXQdbVPowf0s+DqWrhhS7IREkR+kD5i7zImQfQtTNj9e86E2cXj7PDG0PSt1nxJ/plF8Q5z695SnFHDUwDcDIhu8p5pdX/9bVeQCOUOG6mcuwO1rUf7fyftmdVg/hW1mmBzf8wa6yTD3u/zmIuasl7UaugVHhQ9Yfa4E+zbC6dOCoKQprNqrzNqWiIRPQLgIrPmdIzhcyEeCpaBLo3KLe+dZd39hWBu1ieiIMgc75/LSh5XCgGeK9Z7FKHSCUjY/L91JodrdIHllpbG0bBr7YKpjKNcMmRVl3rHGekStPnhINttEVbay++8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JPqItJ9LVO1ZNT24Fo4GT84qoiHq2q5I8AoVZPHS6Y=;
 b=A1KxUEQLWV8FWq03LAsoAjKDV7kzam9UbWAulhm2tOX8PoGQuqQqaIoyjBMSjwIYpkCl3ApxMsCH1mvaePUxk5Y1bLj8QJqk+LiKIIs+d/CECfZKfK24Jj4L/jlxhxM5JiFICIcIXYjqfCtl0dZXVF7/hNpkNKmpBUgO2ahx84FDfA3W6nPXmwjkrHL8eAZrKg+BOU6qqZZjlprNh8o3Fk6ELQp5IhSupbfYAnIYEPptp1cy4rBbIJcUODaG8E08ZqPZ3zCmVCy/p8SLp41Jiz2vYmkaznaN8HOAo45w5JEDeRdPEHihOecxt+Lml6v44fbaOghq4vEp6+/KVQpS+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JPqItJ9LVO1ZNT24Fo4GT84qoiHq2q5I8AoVZPHS6Y=;
 b=UaqshKjDCndVHaLuwplowM+nd5K2V/mQqy0UFEyIoPlC9ov53lXe6tNIYTCx4NBpnc9v/LdpfkmKQNYy5g5A5q2yHQsYrbA321SRoVHrIIOPuFWsqhPbVReHpcIn3MY3Wvl6QFWPHRYNoQcMFxS69FDxD/UjjTSJ2sVod1LPIYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6449.namprd12.prod.outlook.com (2603:10b6:208:3b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Thu, 25 Sep
 2025 13:54:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 13:54:49 +0000
Message-ID: <93d32f0e-5c66-44bc-83af-cb3e7bd40fc1@amd.com>
Date: Thu, 25 Sep 2025 08:54:46 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/17] KVM: SVM: Do not intercept
 SECURE_AVIC_CONTROL MSR for SAVIC guests
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-6-Neeraj.Upadhyay@amd.com>
 <82e85267-460e-39d5-98aa-427dd31cfadc@amd.com>
 <7fb62597-1197-486c-bceb-0563b7a1f5a0@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <7fb62597-1197-486c-bceb-0563b7a1f5a0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0045.namprd04.prod.outlook.com
 (2603:10b6:806:120::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: 485b9619-1376-4891-3319-08ddfc3b17c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVJydnJYZ1NhUk5vbjUrSnF1Z3I0b1NqbUNNYlR3WDFyT3lOM2JkSzNoMzhT?=
 =?utf-8?B?aEhuLzE4Mitmb1FQSzZUdURRQmcwVzJMZHl3dmxxVEZBVExRaUpsL0FFdHBn?=
 =?utf-8?B?RVZ5Wmx2bVdXNEpycXRhbTE5MmsySm1FbEF6QXRQeTBtZ3BIUjh5M05rcFJk?=
 =?utf-8?B?MGFoaklhYnR6VVBuQWlJcDJDTVEyN1VubWt1eVN2VFlJaTQzU1JORE9PUzlL?=
 =?utf-8?B?NUx0SXl6SFU2d3BqbXUwVFlFejZLbDdhRFVvYlRBbUtNVHRGMk01dU8raVp5?=
 =?utf-8?B?a01yOWoxaWk5ZDQwT2I1ck0xeVVOL3NHbEo0TGJ2MytSMElHbzBpZUpMd1ZG?=
 =?utf-8?B?U29ydE9Rei8zbzlJd2JsbzluZTRqQU5GVGtLMnRka2dlZmNpVndrenArMk5p?=
 =?utf-8?B?cThvdHZrRlBaYk9pOXY0ZFZrSkx3RGw1MlVOeW45eHlseXVLNTI4c2o5ZXJr?=
 =?utf-8?B?dnIrejFaZ1d4WWZiMkdadENSWCtNTU41QUpzdnhtdXVDMFJTQXBYV01wL2Jt?=
 =?utf-8?B?eWo3UnViMUZ6OTNZb3pvZ3lpaVhNbXJVYlplOVlIU3dibEMzS2piL2tnd09F?=
 =?utf-8?B?amtLMzkrV3hzV1lOVmFKQmRhQTd3SzhMM2kzV3B6YTd1YmNtZ0MrOFZtbWNQ?=
 =?utf-8?B?NTRDSE1YNm1uKzJ1T05DcEhiVG1ZQ0luVXVVZE9jOW9TNlEwbzdKMXZmUkF2?=
 =?utf-8?B?WVNXUVJrdk4ySTZ1SmtHYi9Mdzh0c0NHSFVBSWNNTkZKNUt0dFB0RmdGR21x?=
 =?utf-8?B?VG4xRjR1YUZUNmhMekJkdXNSOHI5Z21WYlVYZ0NXUjRjQnVpNit3SWg4eS91?=
 =?utf-8?B?Mmt0eG43NmZrd3hWc3FiMUtVUHEwMHFPZTZ3cVlkOXcrV1hmdkwrc2lOUGpP?=
 =?utf-8?B?bEczT0FHeWoyajc4bDhzM0lSV1cvbWFJYmZ2bXFhOXQxM0s2cFJyWTZROC9s?=
 =?utf-8?B?b1hnVTU1TnJ5NWg0Q1VmWWcrZmU4T1pQYjg0YklRbVpNSXkxckx2MFFhRnJ2?=
 =?utf-8?B?Q0pBVnhrZXppb3l2SjRtOURXUEhLSUcxYmJmR21XSXJIUkd1QUg0UzUwVEhz?=
 =?utf-8?B?V0hyLy9EL0lWazJNUmt6c1BuTFJRSUk5THNud2o1VHNDRW1WeU5oNXVDVUhL?=
 =?utf-8?B?VDh1ak9qeWxFNm92dS84ZE1NQ1ltazd4cTVrYStYczhoaXpzejdjOFpITjJ5?=
 =?utf-8?B?Vy83RS9kWDB6MmdSTGI2WGhqY1lVeVpRNXZVN0hMeW9jaGkwb29WNVUyTENP?=
 =?utf-8?B?L0svczMyRGo1K3pTMVh5SUFnWE1obXdtN2M1L3QvaWttVWJybUhJeVFGVnRp?=
 =?utf-8?B?c3JIVFVvN01XUU4xcTNGSi9vOXpVMS9KczNNVmM4YjFxM1dXUEVzV0RSNSsy?=
 =?utf-8?B?cDNvemgzbzQ1SHJWaTFRZjA3MExVZDVJYjQrTURCV2tBSWVYZTc4MW5JRkpx?=
 =?utf-8?B?UEl4cjZ6MFpKaWlMYjRzZ3ppeGc2UVplOFVTbmF3Q0V3ZXJaZTc4cGlSZDRo?=
 =?utf-8?B?am55MXJqMW1QanlJTzArNVMvaFlQalc4RVlLYmtONHJsZER1TnFIYjRYUGEw?=
 =?utf-8?B?U1Y5VC9aOHlPNTZHd29tLzFTR3ZnUTZqNnhTNWR5T0hJYVh5TUEyMmpMcm9z?=
 =?utf-8?B?eXVuanBlYkNBcGUrY2JtclF2cmJYeFNoYk1TM2dOZ2lZUW1rcnhmb0doRXAw?=
 =?utf-8?B?dkZMK2NZb0JtYnpjS3hEV3hwT1JhZmFxK3dvSHhUdVcvdU5OWkRjWXdyT2VE?=
 =?utf-8?B?Vk11SUpTZ3lxeDNHVDlZeEZCemI3aTdtWk93RjhVdFY1UERCcTA2VjF4NTBX?=
 =?utf-8?B?SUtTcTNGSlJGNDB1NFl4UWhVNFNlaHhtc2ZiYmNHSnUyL25rUVBJS2JQZEt1?=
 =?utf-8?B?VXZFd0w0RzFXL085VEhURTZUZi85UUxuY29TeENjOFhPYlJ3WHJId2tuUml5?=
 =?utf-8?Q?HXphR/OdqM0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjZzdkFJaFBRd0dhZVUzM0FCZjZWV1QxbHRwT1NNZ3Q3clAyUnA3ZzhMWEw3?=
 =?utf-8?B?N1pPTXg4TkFNVjkxTi84dGVGa1d6QUIwRUlsclgyM3cxbHZCazJLRTNuVm5J?=
 =?utf-8?B?K3NGMjJwQ01HRm4rYk9yTDVSWkFCOWhaUVpLTHNGVng3L2dnOUxKVEdLTWd3?=
 =?utf-8?B?OSs2ZGlZUk81STZOYWFURVVTNE4vZWNkVms3RVN0QzBPS0p1Nzhhb3FxbHc2?=
 =?utf-8?B?WEhRWnliNFNtYlB5TStQbnJ2aHYrRTZJbVRpRE1pMnBCWEN5Z0I5c3lGVmt6?=
 =?utf-8?B?Q1cwNDdXUSs3VDZMUkM4WHRjQWNNYml6M24yTlREQ3dGRzlSbkpiNEtCSEJX?=
 =?utf-8?B?VUhkOXpkVFVoK2tHR0s0L1NGVmN3SnVjMVBTc3hLa2xza0k4TEdnUU51OUxw?=
 =?utf-8?B?ZDk0OHhPTnZocTZ5QzFTZHJjd3BYRndicWFPTEViaXo5T2FZb0hlZjNrOVI1?=
 =?utf-8?B?d2V1VzRoZjJvc01qRGRxZnZrTTRZbFk3MW9RRGtXd3M2bFhoc0R3ZkxjWWRr?=
 =?utf-8?B?RU9TSys3MHArTTZLZityN2pPVmIvNFE3ZC9kMyttdmt1bmYrK3pLdGRoLzho?=
 =?utf-8?B?d05QSkhQUW1TRjdEUE5XZkljd0gvc0VYNHpKWnlyS1Q0c2U2UDB0WUc3N0NB?=
 =?utf-8?B?bmRpc01FWk1hQ0RHNStqVnRhaGQweDZjYksxT2lpd3VDWTB1R1UyVzN3TERW?=
 =?utf-8?B?N09tUzRJaXdQeVZXYmhMdXJ6cDRkNGZVOHh3UHQ4eFpHa3ZaZkxseFFOS1Vh?=
 =?utf-8?B?bWFQQmdCSVdlMS9Sd3FONUw3Z0VEWjJaN3F5bGFFblBDYjM0Y2NYZ1FBTExJ?=
 =?utf-8?B?Y3dnZUpicGM4TjMwVzlWRFVyRHE5M1Q1ZkI3QXdXMDNzZGhoWFcvK2NjTFJJ?=
 =?utf-8?B?TUdSbUFnMWU3c3ZOQzZRdEhUNVNhUzRxZmRQRmVkbXh5N1VVQkxrLzFPWGx0?=
 =?utf-8?B?cHpQamdPanBtWk5pWExQbEUzTzFPLzZQemMyQ0VCVWtyS0d2ZzNyRUkzaU1I?=
 =?utf-8?B?YTJlWUNmekVlbTlHQWpmNURLYk5TZTF2d3ZaaVp3TFFTbkd0NVFzempqSWFj?=
 =?utf-8?B?Tk9SaURzYml4eHBuUU1IU29ZZFN0eGFHNDV0aFcyT2VsWmFKVlk2TTAzVDBI?=
 =?utf-8?B?L0RrY1BMSmh5Sk1NaHdFQTdZVFo1TCtkc2dmcnpTRU5NRVdRdmptSklBUmJY?=
 =?utf-8?B?a2ZYLzVZL1laRGphcXFoTDl4K1FwNjhsVStGVWYrNHNsYzFRMjNxdjYvbmZX?=
 =?utf-8?B?U2wySytDMkV1cnRzL3VORkNMUnlHME9tZ3FjWUxKeVM3KzdiSTl5R0NtRWV3?=
 =?utf-8?B?aDRjUHhUWktMc2RkK3VKK1E1QmNoR1dQTUtQVnYvVjV1d3FMaFVhc2laN1NI?=
 =?utf-8?B?NHR6cTlvVndjZXdaQkdFV0djRUZHY1lweTl3cCs2ODQvckwwbnVITTZQSXZB?=
 =?utf-8?B?bkVjd1VZdVJOZHpmakxrSnd4c3gzT1dnNDNvL20wTlV1Yk1MVWZwK3NzbkQx?=
 =?utf-8?B?dXhaY0lZK1hwNm44b3g2Qy9zTk5HalczMTJzYTBjenpQd2FSblpYek1uUklT?=
 =?utf-8?B?RnVSRUpoL2NmakVGY2p1dUJLRlNBUDR6bTVsQUFNdy9wdlF0alhqU05pVnds?=
 =?utf-8?B?QWk4S2FqcVo5WlN5UVlUUi9sRFgwWVFTdEtPbmpXQXdjK28vS2xXaXVWa2Ny?=
 =?utf-8?B?aXBBT2JEd2xGSm9uRUxra1dJNzRCMGExSUcvdjlsbHVVTVJRYUp6Zyt1bG5u?=
 =?utf-8?B?RWlyemNFcXFZWXB1TTc3MUpjYnN0Wkk2b05Fd0dqTGNZNW91bExlM3g4Q0kz?=
 =?utf-8?B?Vi9XRWxFaE1kSm1jMGVZZGdNaktjMkJsT2JXZHFCN0ljak1ZcHVySm9oZ1d1?=
 =?utf-8?B?c0l2Rit6d0t0R3h5TGtvTVhrN0M4TUNmTDdNNnR0QWhWcy9xVS91aU1uQjU4?=
 =?utf-8?B?YXREL0dtUGtLeDJncGx0MGR5cDhwOTZaTUgyRHV1VzM0SlZLem9lcEs1RFVC?=
 =?utf-8?B?MFU5aVk1SERJczYzYlE2TjVsWllXNnl5ZHZ2SEFZSmJjUnVuckRISFZ2eDQ5?=
 =?utf-8?B?Z3UyV0tXQ3NBNVR5d0p0N1BCNzh3aVB5dHJrbWdLNktsMzZCdXRZVVp5Wi90?=
 =?utf-8?Q?f4AMsDafa9kr7Nbi+nM9empwM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485b9619-1376-4891-3319-08ddfc3b17c2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 13:54:49.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MslyB8zMcA+CrNLBDE+2/elvR6iibAYekWTx078DT03HZIpwY7kvRyQgwtA0a1hLEt3+0K3d/sIGJWDj/Jakg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6449

On 9/25/25 00:16, Upadhyay, Neeraj wrote:
> 
> 
> On 9/23/2025 7:25 PM, Tom Lendacky wrote:
>> On 9/23/25 00:03, Neeraj Upadhyay wrote:
>>> Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
>>> enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
>>> guest APIC backing page and bitfields to control enablement of Secure
>>> AVIC and whether the guest allows NMIs to be injected by the hypervisor.
>>> This MSR is populated by the guest and can be read by the guest to get
>>> the GPA of the APIC backing page. The MSR can only be accessed in Secure
>>> AVIC mode; accessing it when not in Secure AVIC mode results in #GP. So,
>>> KVM should not intercept it.
>>
>> The reason KVM should not intercept the MSR access is that the guest
>> would not be able to actually set the MSR if it is intercepted.
>>
> 
> Yes, something like below looks ok?
> 
> Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
> enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
> guest APIC backing page and bitfields to control enablement of Secure
> AVIC and whether the guest allows NMIs to be injected by the hypervisor.
> This MSR is populated by the guest and can be read by the guest to get
> the GPA of the APIC backing page. This MSR is only accessible by the
> guest when the Secure AVIC feature is active; any other access attempt
> will result in a #GP fault. So, KVM should not intercept access to this
> MSR, as doing so prevents the guest from successfully reading/writing its
> configuration and enabling the feature.

It's probably more info than is really needed. Just saying something like
the following should be enough (feel free to improve on this):

Disable interception of the SECURE_AVIC_CONTROL MSR for Secure AVIC
enabled guests. The SECURE_AVIC_CONTROL MSR is used by the guest to
configure and enable Secure AVIC. In order for the guest to be able to
successfully do this, the MSR access must not be intercepted.

Thanks,
Tom


> 
> 
> 
> - Neeraj
> 


