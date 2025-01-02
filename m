Return-Path: <kvm+bounces-34486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3759FFA95
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 128F4162CC7
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51A61B414D;
	Thu,  2 Jan 2025 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zei2mZkC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA71B0F11;
	Thu,  2 Jan 2025 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829147; cv=fail; b=JnyWqO9xk1NboBqyPqErBFQzfhOQw2q+E6Ow9ndWHmcaxgxtvjHohdpY9uuhgdC44CefnZOa9GHLidEzVqqToAh3QjEGSc1cS+4/F5Jk3EA/EH4Zk7iGl+VslB3ohmgCEyq8azm3kAmMt8nSv9dv5Eap67rSSQ8EacOyFwPr7kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829147; c=relaxed/simple;
	bh=OBiqttp7cR8o3jv0QEI7OK3ZmxtiIREBU2pV9s3j/e0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n0FYoC/+7g3X4n8jqFrxyLfOSNeEGQkJqPtoWh0C1aeZyR+is1XLgRiTKMZ6C8hQWg1TBPds1abwNUgTfod0mlgEHuYgrM/NOh1RE6Bsp3HPSWcLu5o1RdRA5xFfdjxvIutDNQz21qcSEfodAieFX7y5WA+pD5ixDXEX+fZAijg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zei2mZkC; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nqdkLcP141+qRiWXaLU01RoJ1chzjtz9G/FqoyPYPiX89AKGQpb23y+LNa4kxlE+mC2Wdopw27VDV0ML0xCtONHVN9uHGeMOJUdx5I2x1Cg6FzZ73bZCkta0C2EMs88Us4iLCfBvEBbTGU0N7VpPYLgqJM4Wqpw+HuWmNzF+2j6WwRCP3umktWnLlbQbDHgAgs0Svpj8ETLUPI4H/UL2BrgxBoFs6Y/jhMnuwqUGMvkv9vjFQ6UqGXY9CLffEzdRBxyqNkRmVXQqy+4TIZbqJTrT1E44rod4V4n4BViZpaau9YiOsr0AfB0rKGoV3km404uQeiHlude52j1t7SUsRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Zksr9apMTRpUIdH9Yf5kfvDL4ckaru7hDZxn1RNIA0=;
 b=sSppjxM4uGn/97KBFnMaMlya/zalBNPtBUvPoQqCuf4IwEIxBN+qAHTlJCOfaMaXmSC+e1XwCHAY27py69uT+V68cp8eBOHthkInWf0OQ6RJxkMtHfeVL9Ey4DTIuJBToQO7yyiHNrRIgByObI05lkEdZQFCl2b17IvGS8WfI9u16dDVBs2z3iKuZPrCIAq5wpWlqegY8PtbTdafG7mcX7SQz8BzduH0BOSQ8Fqq2JBpdDqs4u2JiVM7SqaHqScQCoHFJpTU46/LYyzNicIxwBLRLhTWi18Ew5WOSuNwcqZg9QokoB800BRThG5HaiW0WxqcgD7H1BFZ9JaCxvYEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zksr9apMTRpUIdH9Yf5kfvDL4ckaru7hDZxn1RNIA0=;
 b=Zei2mZkCXb7zFhyjgU6zQ98Gsc1ffRLuTJX/DOGHxZ0OqfzM/FESAfmYFge6gleXRY/tI7sCNxvBiJYf2aY/I0feDRi0cokTZplJ8QwDP9k7SQpFzPsWbMMsDJY80F10JcfrIeIP8na6Jv5IiLrIhkiUKhfDzL1sNRWoCzJ6yKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Thu, 2 Jan
 2025 14:45:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 14:45:38 +0000
Message-ID: <b9c71735-96e5-aa4f-4d13-ca6c50c2f625@amd.com>
Date: Thu, 2 Jan 2025 08:45:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Content-Language: en-US
To: "Nikunj A. Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
 <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
 <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>
 <20250102090734.GBZ3ZXVqpo0OgEwbrQ@fat_crate.local>
 <fe09ff1d-4a9b-4307-92c0-767cd3974152@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <fe09ff1d-4a9b-4307-92c0-767cd3974152@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:806:f2::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ea48bba-ce3e-4493-0294-08dd2b3c1fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0pRV2F0SHlBYm9uYWwrMmwwN1hrY2cvbU1DMkVnM2xxSGRhZSs1QTlIZDVY?=
 =?utf-8?B?U0hKT1BsREJBcUxKWFI5TjF1TDRkMjd2b3AwMzA4aGdhdGdySnlZTGozZ1Q4?=
 =?utf-8?B?VS93Q0NRYitBSEdnelppU0paYm1PNDFRTHA3L01pOW16QjV1dDBpdTl3YVAv?=
 =?utf-8?B?RFMvMWJ3TXNtSVJGMm4wUk1UaFJTZ2FPTDdyVUkzdVB5eVRacUQ4RVBaMGpv?=
 =?utf-8?B?MFFtdHloVEVNcG1wMzhuYTl1U0UxOUpLM2FQTzFLSEc2cDRHamRjYUpZcTF4?=
 =?utf-8?B?Qkpxak93MkJ6amxKTTUzL3h3dHR2VGFiVEE2NC9OSEc0TUJWYVdkVzZKejZN?=
 =?utf-8?B?ZWczYUpOYnduR1NtbW1sbnhRTHNmc1lrc3VlWFZJOGtwVVM5RlpTWmFRVlUv?=
 =?utf-8?B?cjhnWTJQV0ozdWlhc3ZjMzI3OTU1Rmdid2FsYXdKeUliWXpqYzQxcU1DZ3E2?=
 =?utf-8?B?YjFCRFJUQ05PVUgvQWZ1emdhYjdhTDMzcWt1NEdZekxkbE84MTdSNFNoTmVH?=
 =?utf-8?B?SDErRjhiU3YrVWhReVUzV3l1a3VJUlRZTnVTQ2piSUFNdnovblBhQVZNSTFk?=
 =?utf-8?B?SkdMYU1XZWxZZnFKcGZUbDhweTVxbHkwUkdxS0E0NTBuQjZNS2hiSkttaE9s?=
 =?utf-8?B?bTYyeC9uTnVlN3RxWW1FTVZmUmxXZitVdEU5QjlzYmd5cTRzS2JLc0JnUHRv?=
 =?utf-8?B?TjBTRUo1bW84QTZsMjB5RFBDTkxWSnlnRVlZWWxHMGF1VXhvUHVmUlFOTnZD?=
 =?utf-8?B?MWZYNGx4MUV5ckxrcEhMQ1V4OUQwR0pqaE01SFBQckJpQUdDQjRwTFJiV3dJ?=
 =?utf-8?B?TmFubWRkaEw4UG0zMnNOaURrd1lvMDZnRG1xcjh1alVCV1IveDNzOEhqejJZ?=
 =?utf-8?B?RDNWb2lWS2s0MFdWWDN3cUh2cWVsYVNPMUNJVGN5TXlnQmZQSTc0anYyRHZR?=
 =?utf-8?B?QW9nc1d1UWFORi92TDdZL0M2Qi9EZU5TVTl5dFdCdmlkL0ZIK09EbXZEYnhF?=
 =?utf-8?B?ei9ZSmhiQm01RkxVM2YxOElzb2FFSlh6SEZyZXdlaGhLT2xCbElEU3h3MmNh?=
 =?utf-8?B?V0VNbzY3R204RGdyVUZrdE1JRnZXSnRvaFF4eVRmOVplWlNrSkdmUzJxOFZH?=
 =?utf-8?B?VTN0bU1NSWdYNG95WUw5ZnZSYkU2QVJDZTNBb1NIeUIrZkVQUCtXNmZxb2Nw?=
 =?utf-8?B?elpzbzJGSUpuY0pScjMvTHNYMndFS2d6MWxjY1FOVkFhaVpMazFYQzRDSHcz?=
 =?utf-8?B?a3JRdUhXUEdFR0s4SXBCaUZMQWtYVjNLM1BpejV5R2ExWWxVYkw1Yy9PRmJw?=
 =?utf-8?B?eWhlblQramRMOHpMRGdiQWxVVCtqRW0wZzZHZndlRUtwaXFXV0hRdWR2WlNn?=
 =?utf-8?B?OVRQWE02QzNoQkNtaGxpSzltbVBPTDlUUzZ1TDdtMUliakk3c2JNVjZXMlFa?=
 =?utf-8?B?cmt1ZlRBS2hXSXlibEljZUZ6UmpFYjRialBnVCtYYVVUMDlPbitBUjhIVFhj?=
 =?utf-8?B?dXgwai9rT0RMUFFRc0M1RXBOM0lGV05ualkxZ2Fma2ZPZG5FOFhvVXBRUUl2?=
 =?utf-8?B?bE1NM1NXSDRqZXptR2dEaUdkNVRMSS9OajF1Skh4T0xEaWRobVVhYm9SZTNw?=
 =?utf-8?B?Um5MUFFnc1phaTJMM000cGE1VWNhMXRNNkdoL1BOS2svL0hHSFF2alVaVXd6?=
 =?utf-8?B?Qk1Zb0dVUHhpTWRhcUZhYmNQcld6UVJVVVBZbjZwQldCcGlMRWViSlRNV0g3?=
 =?utf-8?B?czd2T1dxR0lJUG4zRkNKMXFxV20vQWRkdTFoZk9OQnVDaXJsTE12UmhMOWh1?=
 =?utf-8?B?WHJIYkJ5SFNPSjkwRVp4QXdGeGI1QVZDNll6QTB4d2w1NFBiS1RvOVdnR05x?=
 =?utf-8?Q?tNgWj7c0CduR/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1BXQzY1TXBweWhzcEtKdC95NTM5TVQ1RGhlQi81ZnJzTEVFZlFiZ0JNZEVm?=
 =?utf-8?B?enliR1NGZzZsRG5yS2gzMnhwaTZjV2VJeG9DVC9ncUpaTG9kUERydnZKQ1ZK?=
 =?utf-8?B?SWtZQ3Fjc3ZGUjV1MnU3UjBLM3Irdm1GR1lRdS9yeTFHMld5RzVWaEpzNElV?=
 =?utf-8?B?TnNRTERkN3E3YVRWVm9tbVVzS0pNY3N0QmJVcVdDV0NtbHlwK3o3RUpvTk9Y?=
 =?utf-8?B?Mk1SaU1iK0t4NEFIUG5DN3BTQk94STZJZEdkWDlKc1lsMERrU1FxQ1hmVHg5?=
 =?utf-8?B?dnFzQVRlYklnRndsT0pucktSTnhrYnlGcXYwWndZY0lLR0FjSFdLNWRPcWRm?=
 =?utf-8?B?dzJmQm9hWG9MU21rdkVjeEhBemVKUStqWkhZRmg0UExpc2t1OXZUN0grRWdI?=
 =?utf-8?B?NFhYa0NrTUMyUW9WR0NSR2hkbEY4ZjJUVkkwMDZtRTRmL2dDVE5ZZjdxWFdV?=
 =?utf-8?B?dUNWNk14bGlHZSs0T0NrNGxoN1NyU3NrZy8rbGdIZnd1VFAyNmNxbjc1UFlj?=
 =?utf-8?B?aVJOQ09EMGJmb25WSWdCakdJcmQ5Q3BhcVpORmpUM3hQbEtpQmZDOWppVlNa?=
 =?utf-8?B?MlZxYWQzcDgraFVHcEVNZ0xBK1BNTG9oTFVVS21VK1hMcW5FTUxQaHY1WXFz?=
 =?utf-8?B?aUFKaVdnUjU4UzM4VDFjWWlhK25xOE5NamdiajFYUzFka2Zkay9KdExreUhQ?=
 =?utf-8?B?MDl5dkpVaU1tWnhSYWlldkpHQUNXMDhzeHZMNmtWY1JsNm9GUDQ1cTlmZ2JH?=
 =?utf-8?B?ZUEvcU5IeHdDYTZRd08wTnRVSkVVRFQyeFRUQ1piZWFtOUlneUNXNktYQVZ2?=
 =?utf-8?B?K0xlTVJUMG50aFIzdEZId1lIRTUyYXdUaE5rc0IvRzlUcFpzdm1HdFZLb1ZC?=
 =?utf-8?B?SjVZcUVwK0MwK2xHaHR3ZElxSzRGa1FtOENWUXZqbnVoeFZDKzlGTTVDUG42?=
 =?utf-8?B?TS9qSWNua0drN3lsbEQxc1Jwc0RodEFHeWFyMUdRN3JQMXgrUkZRT2hleGJ0?=
 =?utf-8?B?Nm9iclRqSWx3TWhzbVZrdDJ4TVJkUzJ3R1RuMk9YVS9jeHJvWlJBTEttUVd3?=
 =?utf-8?B?UHN2ODZMcEIyRzFqcFdzQUhsdjhzUUxreEVicmhhcFFwRkJjMGZTeHhaUUdT?=
 =?utf-8?B?TWpCZmZtb0R0RWlvRGNoUjJNWFE2dHlPTE5mU00wMXdOdmtjYXJPSVJoZHVM?=
 =?utf-8?B?WlNzRWtRcFVHOHVWVnhkV1RQbHU2Znl5S1ZYUFNHNkIxVUIyR21sNS9UNGI5?=
 =?utf-8?B?S1laWTdPNFp3SXF3NHBmQWM1Q3pWdnVWbGYzOXlSaE91YXYraEYra1c2NEtw?=
 =?utf-8?B?dGJlLzRDZkw4cHE2U1Y1cHhsSllQN2cveWJMVkZhSW8wT0daMFNVODViRllE?=
 =?utf-8?B?MGM0bmlmS3A2ODFUWSsraDlCTDVPeU8rMkxlMkl2NkxsOWozbU5sVmtDdXZJ?=
 =?utf-8?B?dXRZcmNhSFhBZzBpajdXVit3QTJYS2hMRXVROWkvYzUwS21aeVpKRHF0OWM3?=
 =?utf-8?B?eDhBZURNU0psUE1jWE85UmVMbDNLU21XamMrYmRuMzEzMTNLQWdhaE5FWmVD?=
 =?utf-8?B?Rkkxd0twMXdyM204anpsaGNlVjZGU2xYc2JxMWdObWN0alNPYmRnaFkwRXhj?=
 =?utf-8?B?VHdoamFtaXJGTzRYVzBCd0VpenRlVmpTM1cxZFJKVS9veklwM3FqTGhxaktr?=
 =?utf-8?B?NmdQWDA2YkhtUDdsN1BYcml0SUJQRXFNVjFZWGFNWjRUU0VSVy9sWnI4YmJX?=
 =?utf-8?B?djZEQmdJdW5BYWpwTWl4d085aHJIRHQ0QXY3QlY1TzFTdWovVkVQeHdkNnAx?=
 =?utf-8?B?dkZJc0VCNmZSc3ErQ3JveHlLL09ZSTRlL0NYT040RFg4UmdXTVR2KzJFdk5S?=
 =?utf-8?B?NGJuT09DMmZpU0lPc2NJR1dUamxvemF0d2NEQjFVNW03dExwMkVqZjRjUzYz?=
 =?utf-8?B?N09ra0pVd2MxZVJVdlkrU2RUazB4L1R5bHluQkI3Mm9NK2NEVGZ1U0RxWlZB?=
 =?utf-8?B?VS9RdkMwR2VjSWwwNWd0RFl0UklVREVzOVg4eEhTQ0VDTmZoeitxRmxkamJG?=
 =?utf-8?B?Zm8zT0tDQUFSRXM0M3phZXRZNFVicmNTMFhmTHFmTERYNmdEUFNIbW5VWkw1?=
 =?utf-8?Q?Zno9UXPwlq44jBEsafYBjx9v1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea48bba-ce3e-4493-0294-08dd2b3c1fab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 14:45:38.7193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyQxfS39acUhFiU2bcIVm5yKgh7JkcudKPsh+jxGXa0eDcsbbKW8r5TKQGfTYoUoa4zZ8Y213w+qTyBkEl3Dmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7272

On 1/2/25 03:30, Nikunj A. Dadhania wrote:
> On 1/2/2025 2:37 PM, Borislav Petkov wrote:
>> On Thu, Jan 02, 2025 at 10:33:26AM +0530, Nikunj A. Dadhania wrote:
> 
>> As in: I will handle the TSC MSRs for STSC guests and the other flow for
>> non-STSC guests should remain. For now.
>>
>> And make that goddamn explicit.
>>
>> One possible way to do that is this:
> 
> I agree, if renaming helps to make it explicit, this is perfect. Thanks.
> 
>>
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 6235286a0eda..61100532c259 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1439,7 +1439,7 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
>>   * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>>   *         value, use the value returned by RDTSC.
>>   */
>> -static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
>> +static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
>>  {
>>  	u64 tsc;
>>  
>> @@ -1477,7 +1477,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	case MSR_IA32_TSC:
>>  	case MSR_AMD64_GUEST_TSC_FREQ:
>>  		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> -			return __vc_handle_msr_tsc(regs, write);
>> +			return __vc_handle_secure_tsc_msrs(regs, write);
>> +		else
>> +			break;

There's a return as part of the if, so no reason for the else. Just put
the break in the normal place and it reads much clearer.

Thanks,
Tom

>>  	default:
>>  		break;
>>  	}
>> ---
> 
> Regards,
> Nikunj

