Return-Path: <kvm+bounces-37537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4069AA2B4C2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 23:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E71E17A453F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 22:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DD9246335;
	Thu,  6 Feb 2025 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YEO6WnO1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2431A239077;
	Thu,  6 Feb 2025 22:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879434; cv=fail; b=iboGw7mdwvRSL9jDKRT3lDnUUSZEzdxeF4UlLtZC0uRaQEIubbaUSV02St457MC51AgKPgaVivCUw02yjA3CLVd+GJRpmu3q457V7hkp652o9MW1NuiLueB20rX0ePrDQ/tfvMZCNSGkhKcdz+iuoTGcoRojmMq1AmbGV5a7T4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879434; c=relaxed/simple;
	bh=4sILhf1ZUaGb5gakbrNTlRV7k1LhmA8AxPUfCb14Xqs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qsxwURMha5XBXsioM9kudIr9isRpkzPdaO+bzTRlPgps+cxqhLatWPq90dExmqpMRfIby9UHr0pjS2nJjAPdbO0YywfgEHulkN72Mj86//HX5JCT/Wo4K0sm2uLMY8JhyC8Cif7LYtXZBGxwVPqBGF7vuWen4aadw41D/NCO9AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YEO6WnO1; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpATtOYu1z9MjxWRQYWK63Xn4nNAl0c0w9xL/yD33ODxNFNtZdjI/LEDwWdvyv83YrXZTEsqLVKrSxnorY24QimKPPVMYhq/e2XeAk9KA3SWsaqT1A/fjI0zNGYPatPJJCnV8KE3AleWinRTV4o+123FIsXss7IPvepZTqhn+vxOcmoYkY16ontxmx9sBqTkKHv+IasMco28M/Ow3ZONPzNS/kuTMk05ReL62vN1ecKYzSZ4MDmQl9QcBQTA57j1s/FI7xZCfA5wcHTN/zEHKB72k03ZFWjpi6+fgDiKyjX1v3SyJfRV04FP138R9Eb6e0E3eNj44rYMKoFDiDAK7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzgLWe5PkOFPTflIxfdpPUieZMzqA8aj25df75uWYQw=;
 b=AppHP4cSoKk5MbI/UQUVZpC22Cd9jSQtgJII/9Ag7w6rZBYpJYB/jHUhSCaQT2iZzJbNbpsY4RsaAn0czxCkY4iXMngv50c4deVJ8jDx8D/KaIzBXIbVLPJJHq0WyTsko0FEitjg9osPDeCTGITv0HTytW5moLaNQWVsenZZN/mZq4lScQr4ydBRNn8FaEQYNqgKQny5G43cp7Xnkeye8cYEx2D2vCniRFqEZ4Hp7Qg5ykVgKI6r1TiNmz+0RVEvzR3VZ9vaIm5FFFflRJ5bNCrANCPTeAsGb2K1ctkdfJVtjcheE+Qzqf5TPsmr1wvgFnzICa0/HwssxB2+fjZQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzgLWe5PkOFPTflIxfdpPUieZMzqA8aj25df75uWYQw=;
 b=YEO6WnO1LxSeU0Eh3bZC2AOQR9cYBzBRzSlPmD95fTkMbcJlP9s3iCHox6TeR5iZvJt9I1OF9MAPijoOBAQjbPmpUyhh+EpSGQ8w+fkUAx2qQ+n20QBQqjKb25aMb93X8qYWq6jCPQOXBj6HcVSfpPQohD/Ue29kCtfvDhia8AY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 22:03:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.012; Thu, 6 Feb 2025
 22:03:50 +0000
Message-ID: <5fb9fa5e-5769-3ad8-32d8-e4a045f041a1@amd.com>
Date: Thu, 6 Feb 2025 16:03:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v7 1/3] KVM: x86: Add a wbinvd helper
Content-Language: en-US
To: Zheyun Shen <szy0127@sjtu.edu.cn>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, kevinloughlin@google.com,
 mingo@redhat.com, bp@alien8.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
 <20250128015345.7929-2-szy0127@sjtu.edu.cn>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250128015345.7929-2-szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0036.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 24122119-9eb3-4f7d-b2da-08dd46fa22df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cCs5S0hOeHZ2ZUJzd3FpU0RiWWRQTmtPNTltYUNacVVSODloRU5JSkRxRGlz?=
 =?utf-8?B?MzlObTkvcGF0WUttLy9lQkFyRGpyUm1YL1RiUFR5MERndFEzdEFHckdNY3oz?=
 =?utf-8?B?bGtiRGFhOEVJd3IweHVNYUhIaWowME9LMEY4RWxlaHFEbmdvSkZZYnJwdVBF?=
 =?utf-8?B?dXE4YXZ1QUk2YkM0SjVRSUViSlZocUlUOWpBTDJwelZVVUI0NkZSOUhVTk1a?=
 =?utf-8?B?cFRMb3pVK0VjSEIwdmVxTHp2akM3OHkyYlZrSGJMQTlrNTV5SXZqak9PWW1G?=
 =?utf-8?B?N05peUpDSG04bkFYQXRlSld4QTRoUENXVTU5OC9WMkE5TUhZWk1xRjNpQXFI?=
 =?utf-8?B?L21yMG83NEh1VFA4bnF1UzQ5K3RLSXhzTlRydHhRbWVmRHBZMVp0M09nNity?=
 =?utf-8?B?cStEK3JnWWhJa3F1NDZ5RjBrTkx2UE03emdpakJCRTRmU0s4eHM4RlExc1ZL?=
 =?utf-8?B?TWsvMUdOSmc2dDhzOHdCd3EzNEdwRDZNMzlnelBmTHQ4Ylowbjl4UVJVNnRq?=
 =?utf-8?B?YmlPUG5DajZISC9ZeXlsd01pZ3VvbmxuMVc5anFrV2RjYWZhbS9JWGgvbGRw?=
 =?utf-8?B?eWxxbDJ3eHE0eE5rWXBycWhYejVtZjVEUWM4cW10MGhlVnZWQmFCZDBobTM2?=
 =?utf-8?B?T3NUbUhldzA2eUVrS3FzYk1HdlJVTmlqYXBkUW5IcFZOM1QvaXFIZ1VwdnBB?=
 =?utf-8?B?ZU90bE9mcWdOQllNKytLRnkwNEJYMEZoaGpXZCtqWEJtOC9pcTdvSVc4d3Bz?=
 =?utf-8?B?VHF4Ly9TazExRDBQZVVHbnF3czNqMXdYeUVaZTNuektsQkxpZlVFY2Nudlc5?=
 =?utf-8?B?TEREUzBXR3lYbXk2aTE1eHdXclZpRUhNT0FRTmQ1R1pqSnowYjVpRnVPYmhv?=
 =?utf-8?B?eHZVeW5OaW5JN2Q0cXZvRTNZeGUrS094aUJ5LzF2NTBaeG5vamk2RDA5SWNU?=
 =?utf-8?B?UjNsWjJPeU5IcGJjVXBKaHhlcnExWllMQW8zZ2ZlaWdzSG5TSU5zRXc2V1ZB?=
 =?utf-8?B?N3JXVytZUTdRSkJxMTlvVjBXOWtFS2pXTjJDUXhsdUgwOU1ObTdnR1MwRGhM?=
 =?utf-8?B?OE9BdW8xZGdXL2hRTW03eVNkaUxYYnhIN3VKMUVZbk9JMU9MdDVyOWQ5QlpJ?=
 =?utf-8?B?S05oc09Tbmt2QzQ3YkVwaTh4YVNVa0xUMit1VHh1cko1YzVoaWwzZWxlUWJJ?=
 =?utf-8?B?dDBWVEdUVGJCeEg2L08xaGZpUTJScUwreVIwcmlNY1pXd2hFYndQUTlodllm?=
 =?utf-8?B?cHR5SnZkci9UQ1AzVzFIMlg3ejY5MTVjNFRyRWdWSm9BSDlDNGZ1NW9zRTJC?=
 =?utf-8?B?amMzVXV4QUhnaHVWN2JNK0s2SGlJeDhTU2hLQjRVSmVwdU1qMG1HdTU5RldI?=
 =?utf-8?B?dXdMZ3FFeUxoc0IyUW9NUCtIVHR0UU1oamRMS05pVHBzZTVxSmtPTHJZaDM4?=
 =?utf-8?B?UzNyZmZLRXpLSVJudE5IVnB6K1J5ZHBXc3NyQjRQdWxtQThYTk9PYlk0T29v?=
 =?utf-8?B?Y25VTC9yMS9EVXpDQ1RpQkVrZ3JYcjRXSDI2Vkd5cUxTNGlNM3NhR2dBRU1z?=
 =?utf-8?B?OEZxNFVjbjlPUkM0OE1oSmpURnNoRSszcjlyN3RNVk85YUNnQ245VjZJSjVD?=
 =?utf-8?B?K0VqbEdIcjBaT2RBeE9SYUx1UFl5NWFDdVRNNGhlT05iYmFxYTFoM2lTM2Vo?=
 =?utf-8?B?QTgwemR1V1pKU2FWMzl6NVIxTjA2Z3JLZTM0YUhpdFR4ejBjTXpwNG1tVEhE?=
 =?utf-8?B?bnFpSUFlejZhSW92V05vYVRtVWpBMW1xTW5GQWxMWjFoK3VNbTdzcjJBeVJY?=
 =?utf-8?B?WDBSSnhnUHBGM2Z0UWVCdm4yVTdFeVVVSEpMSFpNSHVSUVlmZHVCbExlRkx3?=
 =?utf-8?Q?AGH67+osMm3uY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1BVN0ZXMlNkQmZoZXpPMUVjTjZuSDV1VmlBMC9yKzlPQmk3MUVGREgwSVR0?=
 =?utf-8?B?dW9WQkRGMGo2dXl1bkFrQ1MxQ1hCNlFNcUpXZ3RwcVRyazgvWkc1bkMxOTlq?=
 =?utf-8?B?cVdYTkRFRGRCUnh1eG1wWFR1UllGTEFpNS9KRzF2ZlFoRGxZcUFHeTBnY01L?=
 =?utf-8?B?TktpMEdiNExGSUk0UmtpSGNkMUtYWnQvNE1zdWFzSGJncExtQ25Pc2drcXhL?=
 =?utf-8?B?MUxNc3lrOU9XK3FndDFSVVlHZGxYTEx5YXExRThCMFlISGhnZGtpcVlVUFB1?=
 =?utf-8?B?ek5PNkZKMGRXang3UlBTYzdiaUV4eU55M0xzaXR4MmdOeWhEZVRmYXhrWGI5?=
 =?utf-8?B?MkxjcHlENEpTaEFMcmNsTTNSaGtXN3VsMzNvSDd6VVU4Z2IySVFwK3NZNnAz?=
 =?utf-8?B?WUtKcTFscC9jTE5zQi9XQWluc1BVdnhJTTNKWUhYM3JwK056dUtqSXByaXdw?=
 =?utf-8?B?ZTFXMVFtYWsrdThSL1FkNTRKeEJvanU0aVR2RW5tbVc5WUUwcjZSR3BzWDQy?=
 =?utf-8?B?YStBeWZCRlFvL3NtK3FvN1hQSk8wUm04d0Z6ZHJFYld3ZXZKYlducFJjQndP?=
 =?utf-8?B?VHRTMWMyalNEK2lRd1o1NkIydVBvYTFLaDJuR2xsZVk1cDFWR05KSlplcEpr?=
 =?utf-8?B?M3JnWWg2bXV4ZWlheC9XS1F6cGcvaHM1Znprb2xBN0IzeFRYbjhQUldOQW9Z?=
 =?utf-8?B?OVJ0Q2lJL1F5a3Z6OXBHU2l3clZRN2F2QXRRNzBPUzE2aGdwVkZDa3VSR3V2?=
 =?utf-8?B?WXF4TFRJdloxYUJFZTFaK2RURERCUTUyNzBKRmxYLzdXK3Q0VXhqdk9kOVRB?=
 =?utf-8?B?c3U4S1pYMFFJOG9SL2pzVWJtQ3AyZ1FBK0lzWDRzY2ZIOFFvY0RlZnd0YWho?=
 =?utf-8?B?YTMwQW9lSlJ0NFNKTjZOUklrM2ZqbHRvMHFhUk9OT1dsMWV4VkxPSVRVeUlu?=
 =?utf-8?B?QXR4QzhuMDNIenp5V3JEU21zMzRWRmdaMzJ0OE9tQkcrWXdnbzc3czNNK0hI?=
 =?utf-8?B?eEwzMkdrckdNUmliZmtidSsrbGo2Szdwc1BuR1kxWE9QcjdXdHR0T3RxMkkr?=
 =?utf-8?B?WmxZQkpiRXlWSEFERWtFLyszc3A5ajN3OU1NMGx6RFhrdlhYVXA2ZnAyT0lX?=
 =?utf-8?B?OUxUYzBSdW1NbE9ZYVdQNHJSeDVlaXNjYWhRM2JiS09RNzQyam5pRWhndlNP?=
 =?utf-8?B?Rmw4aE1WeVZXU3JEdkVYL0ZTd3FwdnhxNWhSQUwyekdxTVdKRktHc0NZRW5M?=
 =?utf-8?B?ODN1VHo3VHZvb2JnU2ZnNldHWTZ1VTYrZzJUa3VwSWJIVEcrcTJLNGtWeWg5?=
 =?utf-8?B?NUdGZ3ZDclIvMTJZQWZ6ZzFNSFBwMzFhTmpldnFUTVErWnAyUWgxTHFTUDFV?=
 =?utf-8?B?NjV0eG5RaFd5YVR0amdJcjZ6NEY2Kzk4b3J5T1gxK0Y5MlNGem1DcU5KdzdU?=
 =?utf-8?B?YmwxazJhOVdtd2gxUWluUDd3aS9TSFV1OWVJVjQ5VG9RQmxScEZWZFNLRnJI?=
 =?utf-8?B?MUhSMHREcyt2ajM1aUVXellzMWpqMzFjdmFPa1U5WlFkaGZOVWt0QU91NDJi?=
 =?utf-8?B?OSsrVk9IWUVRTHVDWFFialNGbjdXcHZuQzJkbHBIUHdFL0U0R3NpU2VaZWg0?=
 =?utf-8?B?Z3Myb2U3dWtJb1RCblF2Y092alBMUFZkMGxBUk5jUTRiRVJ0TWRmWDlJejFB?=
 =?utf-8?B?WXFMYXBHT1dBNXNGa3FFd24vUC9mWHpIRkxCOUxGeU9KcjdBYUl4dkdua1BV?=
 =?utf-8?B?cUxKRG1EMmNFVFNHemMyTzN5YXhWMlBVRU9kYTFiZkwwUU9tNzRaR2diT1dv?=
 =?utf-8?B?d3lRczRwZ2FaNi9XRlp0N3BMWVJpcEFsNnlRblhTbnRsN0ZNZkVCSTJlSXcw?=
 =?utf-8?B?bXJCNW84Q0tObTlMRjBxOCtCM1pGVTAvVVd1KzVrNXljRXBPUC8xZW9id29Z?=
 =?utf-8?B?RmtaSDVDYm9VYWM1dm1ZOUJoU2o0cmhRRUt4K2hzWExGUzJKa0prcUk2NjN5?=
 =?utf-8?B?WW01Mi8wMVUwQXkyT0o1emY5ZG9GRHVOK01LM2p6bzFRTDhKa0lLcER2ODNj?=
 =?utf-8?B?a1BEQUxLZUdSRzBNTjBZY1llSEJIY25FQUhkc1JRSXl4dW5hK1ZrN29zRWI3?=
 =?utf-8?Q?x3jgNOCdOjfLFeLCaIKTAYeTi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24122119-9eb3-4f7d-b2da-08dd46fa22df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 22:03:50.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5Plo+ZI7VJnQkl7hOI44PTsp7AE6gtOQ4CNANGA9cB+ffETr9X3cqpaXcgeynmqybo6rf5Y72T1KHx1hDIfnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006

On 1/27/25 19:53, Zheyun Shen wrote:
> At the moment open-coded calls to on_each_cpu_mask() are used when
> emulating wbinvd. A subsequent patch needs the same behavior and the
> helper prevents callers from preparing some idential parameters.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>

Not sure if this wouldn't be better living in the same files that
wbinvd_on_all_cpus() lives, so I'll leave it up to the maintainers.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/x86.c | 9 +++++++--
>  arch/x86/kvm/x86.h | 1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e7134809..b635e0e5c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8231,8 +8231,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
>  		int cpu = get_cpu();
>  
>  		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
> -		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
> -				wbinvd_ipi, NULL, 1);
> +		wbinvd_on_many_cpus(vcpu->arch.wbinvd_dirty_mask);
>  		put_cpu();
>  		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
>  	} else
> @@ -13964,6 +13963,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +void wbinvd_on_many_cpus(struct cpumask *mask)
> +{
> +	on_each_cpu_mask(mask, wbinvd_ipi, NULL, 1);
> +}
> +EXPORT_SYMBOL_GPL(wbinvd_on_many_cpus);
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index ec623d23d..8f715e14b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -611,5 +611,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
>  int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
> +void wbinvd_on_many_cpus(struct cpumask *mask);
>  
>  #endif

