Return-Path: <kvm+bounces-36294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A127CA19937
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 20:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A2DE3A7BFB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE44F215F56;
	Wed, 22 Jan 2025 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IWwh9Boa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AFC1BD9D5;
	Wed, 22 Jan 2025 19:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737574766; cv=fail; b=czYWCz02CBOS1LjW8/IoOY2Sw0Xm/O9kTNbrhpFcASLVmunUGpPd1M3/elOpcTU6cJs7YZ9r4m7EXCLLjtloeyniETHR/OhVhUEqLIyXDmdOuIobusHy4Bfe7tbYCHxzO2uF9pSYqbUD5WBPBNfBBATuQpaI0rHJFoLKydn+n5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737574766; c=relaxed/simple;
	bh=5o9GSNDXcjdgwIJ7gE1qJawZXHRgKh378EiNhjC39Ak=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gx+ROlxB6UazGF7ZruRzzV++F8aSBI1tPXliVnl2IkYzK6a4rY9gvGw4GfPUTcNZ4qMg33rbLMdr+OQvOiULgi1Vl9wDMGeDczJDw0baHNEoYbz4cdIlOWFMud1gyOMnYQpXNAtZU0dg4CDKjQ0y3akAw8jyy/jMsjw/heleiyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IWwh9Boa; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XhFEXeSnlpKU9VzErkIsM/j9egsYv/QQsvMqRZyyxSL8zXsZL6A6J6oyjX4GA7JXOknlk9WGSgB/Pwr7UmCpDckT/UvTED7Hx1+NjVaKb+loUhuD9/JjtHGKUe7NJZDFfrzfjPCa1C4AHAlFNRYPPC/za14J2D0sE5CpfidquMjgCbqqQVfnazoDor7iSldmiVX6CXgqkGEnkYdFARSfMOl5/kceCM3i0WiBC7OLygjxpPzH4HiSxbyOqXJhD6dI/9O/iqG5libE0lk+431ZKLJr1AhutKtfhmWQVVNPEaT3CHMRiF+pU0QVZdwnS3z6QMuC59LW4xERxRea99i/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBDKA5ZbyPD+9SiwbneD1Ls68GxAOURw5fINSzOhAso=;
 b=C9BjlZ88ixFTrCfo2x6BhdXPXx/mIZZLVLCHZnnocDsXZyAqzJzoTESZh1CjwpDRxDFxBnxuLfRjI5jXm9WWhlxr5jhWGMQmKP63v9UEq1faHCIZ3bZ5bqUNc8hw6Jv1YN4Wtft1Xb+qrav0XNnQj0OTkR07zIIpBeW0ybFaJueZM2VCJ6ZgfJOwCH4zmIcevlbX6M2sygUj5HrokLD6qEkqKsvJAHx5lBLsMkBT/0B11dAMY/QYAIY5Mhv2lLx98ogcP0NfDYAKh+3uosu0ITVt7PcxJijn6U3NW4DwRQVgHyLbYvxx4yYIuWa5spXT7OqiYC+rMVgx0nmmOlFHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBDKA5ZbyPD+9SiwbneD1Ls68GxAOURw5fINSzOhAso=;
 b=IWwh9Boakm9yj2AMLr2kS358hr/gLVnnznjCidgx+BPsXpXe5zPej7KYavJ9FXuUfphXA6fQ4BCWh0l6gtzPaNQD9Bti5AfWI/opyjHpEvDMz6T0aUpyHQAHHn0TpiceIQIWUE9ek9Klv2//npQ7ICV56L3FEQfB8Dv8R+Frehw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB7710.namprd12.prod.outlook.com (2603:10b6:208:422::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 19:39:22 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 19:39:21 +0000
Message-ID: <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com>
Date: Wed, 22 Jan 2025 13:39:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
Content-Language: en-US
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
 ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org, pgonda@google.com,
 sidtelang@google.com, mizhang@google.com, rientjes@google.com,
 manalinandan@google.com, szy0127@sjtu.edu.cn
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com>
 <20250122013438.731416-2-kevinloughlin@google.com>
 <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0122.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca79299-578b-4326-9c98-08dd3b1c7808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WndWVG90blBFZ1FTaWRLOVpzTTZZWEM1QnQxYzBROUJLdkEzSENYUGh2dHU2?=
 =?utf-8?B?blFCZU9ET2FIVmI5Wms5YXVqdzdzc05iQ003ZTBmaFdiVUlMN3ZXVGE1dStt?=
 =?utf-8?B?UFlrYnk2ajdpdS9ubkxBS1o4Y2wrb1VmSEtxZXRHd25iYVMvNUp4QllqMk5s?=
 =?utf-8?B?UVcyc0NKOFRXTllFVmRFTGYrNVY1TUh4OTJqUHB6bzN3NzZMTlcyNVlPNSt4?=
 =?utf-8?B?THNmL1RxaTY3SStnbTB3ZzZUOHB3NmwrUStzVTUrWnpIMVVHeitFaFZGSEwv?=
 =?utf-8?B?Rm9QUUNRbWpoVWhyVXBKOHRyOWZOb0xQTkI4TlVlY0lCTk9CcnlXZE5wN0oz?=
 =?utf-8?B?NUlONStTckdZTWp0K2NEdVA4TWVnV0phL0RlbXBjUmlFTjFNbHpnVnlMb010?=
 =?utf-8?B?dzQxaWZOS2NMazc2Y2N0R1FFdlB4akxnZzAvaU9ucVY0NkorWkUxZkVmdFkz?=
 =?utf-8?B?Y01vanJYV0ZNMUg3RzR1SWFiSFhFU3BwSmg3QjJxVUR4QzhvWjd3Rnl5dGRI?=
 =?utf-8?B?anR3YXpHakVRcWt0V09EL3ZGNDliSWhtM3hXd0EvUUxtaXRzeGx6d0srQ3NX?=
 =?utf-8?B?SFRoV1UvcmFQRHRlaHBnTXBpSmNrckxHUUxUMlhmUnNKbWF2Z3FHQjRDaFlR?=
 =?utf-8?B?RjZLdjZvbThNTDJvN29TdEQzcUE1azNvMlVpR2V1MUhJd09WdzJJZ0w4a2dl?=
 =?utf-8?B?N3dheGxWWVBpKzZ5NGtCdkdROUxwN1h4S2IveHBmK1N3ZkplMnlQb0FBN0lI?=
 =?utf-8?B?eE82cUF2TXpoNEllZk9oekdVVmRRVS9veWVUNXZWOTZUaUVXMGJmaUJFR1li?=
 =?utf-8?B?K2dFUy9qSStWTUJUa2Eza3MrbFlGR3J1ZUVBRTFzd3NsNDZLNFpDMTFveEpv?=
 =?utf-8?B?L0Y1YngxampTZk0xdFM2WlpCN0pwMGhqamVNVDNyQ1dLNmtPY1hYSTNocGIx?=
 =?utf-8?B?QkwwWVZWUWRGZWt0OUx0anFLNkZuOUkwWkQzMWIzb1oxVElxYy9uZkltMis1?=
 =?utf-8?B?cFk5bDdvdWZ4OUxqa081U1AvNEhxaXg1OGlUWSs2WjlvQSsyOVBGMTJ1SER5?=
 =?utf-8?B?M1RRWXZRSUoyT1c2bkFxZTRPZm1qSkxyQVZWaDBpY21rRG5PazlRWDRwRXlr?=
 =?utf-8?B?dmZvZzhVT2xBRzNad0FwbDE3SFZRblozTWx2ZUdsWTE2aUtJM0IwSHRaRVlv?=
 =?utf-8?B?UnV5Ukk2bVlJODQ0NTNPdmQ2d0U4TUVEVUpMallnTzN3akJ1cWFVTjIzL09n?=
 =?utf-8?B?cmpjL3pvc1NZNy9Ed3Q2MkIzNVBDR1VKRUpPeWNLZnJTNXhiWFFnS3pGUCtS?=
 =?utf-8?B?dFFRSkRSck8wemRUdVU3Sm1zR1hObktac3ErM3MwQ3VzUUN0czkvVUZ3UjdN?=
 =?utf-8?B?VEh4bVpnRjVkODFxL1JCdmx6dkZhZWFjbThoUC9TcnpTM1lUeEJHb3ErNklv?=
 =?utf-8?B?RDFvS2JQaStjYzBpWm9NSk1CZm1kVWUvUGkxK25QaUYzSDN6WThCeUFIWGZi?=
 =?utf-8?B?a0pXSTNmWUZITzNXcE1UYmpDNnF4ck5JZkJFS0puQmVzRHhiMzZhUHYyaFFI?=
 =?utf-8?B?K245NnAvUzdoam9JWHlEdUFxRmdBWDYyamozR1V0RFJZZGFpK0Zyd0hucERo?=
 =?utf-8?B?TXUyNHcxTnVPbWN1TVJNVWNreGkzOVFBNnY5bE9ndXNKSjkwYUhySTdYUVVh?=
 =?utf-8?B?eXNhOHFaSkFaTVpicDNmVGJpVDJMSUw4TXdUQlJoQm5jaTFuYVpKdUJ6WEIw?=
 =?utf-8?B?KzBGSDdGdEFUNDZaeVJUQW4rSEx5TEVmRFJSQngycWJqWjBKK3oxWm85YUxh?=
 =?utf-8?B?WHBMVEgydDJBbkhJVlpxazk1OWZRcGJmbkFZclhZSWlmY2F4aDZHaDN0dUFI?=
 =?utf-8?Q?2eVOBMJH8PH53?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ri9DMDJWMmxLMHdrbVpITENIMWp0Nk9ieEw1Z1RHMVgxbDlDcE9sb0h1TFli?=
 =?utf-8?B?VVJPa0xscitvOWpmb0dySHRycjNNaitGVURrZ1ZOYnlhWGxjSkNiZWtIRzNL?=
 =?utf-8?B?aWVHM3lQNU9uZ0hPYXZ3eUhZd0ZvcmF2RzJrOC9IK0RlY1duK2dndDRhRHFu?=
 =?utf-8?B?S3E1OUFlcG82N1ZlbVpHa2tqcGk0cTJZalhNRUdibnlHcmNMdEF5Sk9WNGNw?=
 =?utf-8?B?QS9WSkFXOFoyVGJBUndiOW9NditOd2ZyaWlMVS9WSDVMYVlmenluVmtCT28v?=
 =?utf-8?B?blY0Z2pGRzNnZUdUOVNwTDdZUlo3UXd3RVdzMkU5b0R4akNUTjNBc0x5Q3h3?=
 =?utf-8?B?SjVrWUppc29zMnd6V1IyTitVcG9lRktIU0pZY0IxRkhkNFNleWNJSSswRS9s?=
 =?utf-8?B?WWNqM1V5bmpVanNRbFRQemYvZXQwOS8rYWwyRGx5NVJIcWk2bHRLWFR1T2V1?=
 =?utf-8?B?aDBSclh6MUZPTDFQNEVKa0tJOEVoMWYyZlF4VGNhVStkRzJGeVE2RmxnMkpm?=
 =?utf-8?B?WjlJTU1KR0xibnE2RG8vYU9UWkxMdnpsem9rWVBPSUFiczJieVVWNkxFZVdS?=
 =?utf-8?B?d0kvM2wvVjI2SzI3U2NSSC9mQUEvVy9lMzZmUDZobmdReVZWQnRQd1l0aEov?=
 =?utf-8?B?T2dJK3llaHlkRWY1T3NpYUVTWXN6RnhMOGo0NTdlbUlpYXcxZ1p2UWtxYjcw?=
 =?utf-8?B?VXBocC96YThQY29WdmtjKzE3cjdsK0ozaHhoYmpVVm5NaUxpRUxxZlVCUE5V?=
 =?utf-8?B?SGxmRTRsYURCU3VGRjZDTG02enF4aUNEcTQra3lZSStLT0RzTWE4OVBpUzZG?=
 =?utf-8?B?ODN1QmcxczM3TjJRcjNVTFpMeVUzUTFZanUzM1E1ZmR5bjBqMTk1bHYzOVQw?=
 =?utf-8?B?My83dW1sMTBIYzEwQnREa2l0TmtXajhmUXRjSUR3a0FaSk1EQitMdjVnbG5Y?=
 =?utf-8?B?L3AxdGE5enNNSWU5WmYwK3VId2RWNmJsOEkrU2J4bVNhOGRiT01YaG9wVTRH?=
 =?utf-8?B?OTZldXdHazBwbC9sOHo5OTQxR0l2MmpwTFYzOW5iSXQwSjc2eXlHK1dBUjVY?=
 =?utf-8?B?T2NqYjJZOUpvRjJqSDRnamVSRVpJLzVSQXF3cGNzeDQ2L3lZNVFqTlJZZXl4?=
 =?utf-8?B?bE5jdHhKYWxoQUdaSE8zWlVvbnhvRFVubEl3ZmM2bUd1bWRjUmJ1dEN2dzFi?=
 =?utf-8?B?TmltTGo3c2ZrU3hDdzhUMmRURFd1YjFQaDZoN3FpWFFmZ1BXbTl3UmhaWDc0?=
 =?utf-8?B?Skt1NDFlYUdSVjZuMEh4MkNTZ0d2cjdzeExCZFlVZDZDMXExbDJIaU1PaVVw?=
 =?utf-8?B?dGlnRVBSMGJ0ZWZDcGVFSFNhcyt2dDloU25ub0lOZXlmVThjYmxtazkwVEF2?=
 =?utf-8?B?OE1NSTlzSjRycWJjQ3hhOEhJTDNuM2d4RkVzQlVDQUJOZWVxcWo3cW9mZjdU?=
 =?utf-8?B?UDdIdU9UUHBpLzRONHIrcVV4TTZRcVFaTDRiL0JmNjNTS0xkNTc4Ky9EblZN?=
 =?utf-8?B?SktVREU1VUhmWUpJV1hoRUJXU1BOc3ZTOVNoN2pQaFBab2dha2NZSHh3QnMr?=
 =?utf-8?B?RWdHRmFQTEM0SHFJMW4wRDQzaW44Wm9JdGhmRFNDaXQ4NlVwUy9mSTBFQjgw?=
 =?utf-8?B?ajhzY016SkdteFNSUjkxL040aXc1bmZzenFQQ3NwbGxvZFY5ODUvRU9EMUhS?=
 =?utf-8?B?aStPaGwrUkJ6N3pWazlacjFmL3RiNVlJSElINDBVMEIzVlRpMEJ5OWlEK3pa?=
 =?utf-8?B?TkdlMi83dmw1YzgwbW9xNGxQZEpKMEY3YWZjNEpQdEUzNUFreWhGTG14K3g4?=
 =?utf-8?B?VE9GeFI5dm5ja3ZDbjBzUlhGZ0hsb3hWbEM0eFJuclQ0ZlNUVmxsRVFzMngw?=
 =?utf-8?B?VUNrSHd5cWQyVEh3RDY4bndYY1VpSVMzRE1GVFpuWmhrTXhjbWE5TWFGS1ls?=
 =?utf-8?B?cUFmb3ExTmh1b09FeEYrYVBKaWJSWTgwUHVmRDVEOTRuVUJiajQzU3ZTMjJZ?=
 =?utf-8?B?cVVvWU0xWmM1WWxHZlZwWFN6MytZQ3A1bzk5SWhmS0Y3MFNZNEVTamlYK2hz?=
 =?utf-8?B?UGtzK2gySThUeG9hR29QOHE0cFhuZy9UV29SNW5TbStEWXhDV0hYeGJnVGRp?=
 =?utf-8?Q?MVsKJmJU7pvxDEcmp0Fon97ry?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca79299-578b-4326-9c98-08dd3b1c7808
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 19:39:21.8928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhW2MuMmLrZXAj7E8v84qmGkF4ey4gfm39hNA3eQN/U31K5hfYJqIlb2Hi3kR+B7G4l4GtdMxiKfyf8Rak3K1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7710

On 1/22/25 01:32, Kirill A. Shutemov wrote:
> On Wed, Jan 22, 2025 at 01:34:37AM +0000, Kevin Loughlin wrote:
>> In line with WBINVD usage, add WBONINVD helper functions. For the
>> wbnoinvd() helper, fall back to WBINVD if X86_FEATURE_WBNOINVD is not
>> present.
>>
>> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>> ---
>>  arch/x86/include/asm/smp.h           |  7 +++++++
>>  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
>>  arch/x86/lib/cache-smp.c             | 12 ++++++++++++
>>  3 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
>> index ca073f40698f..ecf93a243b83 100644
>> --- a/arch/x86/include/asm/smp.h
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -112,6 +112,7 @@ void native_play_dead(void);
>>  void play_dead_common(void);
>>  void wbinvd_on_cpu(int cpu);
>>  int wbinvd_on_all_cpus(void);
>> +int wbnoinvd_on_all_cpus(void);
>>  
>>  void smp_kick_mwait_play_dead(void);
>>  
>> @@ -160,6 +161,12 @@ static inline int wbinvd_on_all_cpus(void)
>>  	return 0;
>>  }
>>  
>> +static inline int wbnoinvd_on_all_cpus(void)
>> +{
>> +	wbnoinvd();
>> +	return 0;
>> +}
>> +
>>  static inline struct cpumask *cpu_llc_shared_mask(int cpu)
>>  {
>>  	return (struct cpumask *)cpumask_of(0);
>> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
>> index 03e7c2d49559..94640c3491d7 100644
>> --- a/arch/x86/include/asm/special_insns.h
>> +++ b/arch/x86/include/asm/special_insns.h
>> @@ -117,7 +117,20 @@ static inline void wrpkru(u32 pkru)
>>  
>>  static __always_inline void wbinvd(void)
>>  {
>> -	asm volatile("wbinvd": : :"memory");
>> +	asm volatile("wbinvd" : : : "memory");
>> +}
>> +
>> +/*
>> + * Cheaper version of wbinvd(). Call when caches
>> + * need to be written back but not invalidated.
>> + */
>> +static __always_inline void wbnoinvd(void)
>> +{
>> +	/*
>> +	 * Use the compatible but more destructive "invalidate"
>> +	 * variant when no-invalidate is unavailable.
>> +	 */
>> +	alternative("wbinvd", "wbnoinvd", X86_FEATURE_WBNOINVD);
> 
> The minimal version of binutils kernel supports is 2.25 which doesn't
> know about WBNOINVD.
> 
> I think you need to do something like.
> 
> 	alternative("wbinvd", ".byte 0xf3; wbinvd", X86_FEATURE_WBNOINVD);

I think "rep; wbinvd" would work as well.

Thanks,
Tom

> 
> Or propose to bump minimal binutils version.
> 

