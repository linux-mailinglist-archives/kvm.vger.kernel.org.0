Return-Path: <kvm+bounces-33433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9746F9EB5DB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44BA4282B3D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B851D516B;
	Tue, 10 Dec 2024 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5tiWQ7DH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101E19D06E;
	Tue, 10 Dec 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847337; cv=fail; b=W3AL0SjDPJTxQlEftnEGYbOHntw6UTEJ8BYpjxgFdqqBBhkHQbEPphz11byK/IpKGQgemsC262vYGn8t8K0EUgbKFmJkKgiDOx+Ap4tbUfQ1ELPE+rvV2pj49HnmOULUStQC4cJq4l6a14uDq53oCJ0xDMAwtB0F9DDcBHlBhtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847337; c=relaxed/simple;
	bh=FhwN31j5A8W8WVNisf+N+uQDugsjcqV6ILwAN69flSM=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=GKhfkKMgjybOC4qGR6P05qUQy21ye8j+m1kNmUO+KGH1dy/sgjQnkeT8ku3HeApC4ZxNTkJFAvMk2ZP+8Jowxk6OLDWifUZxlMF/6bHNacrpxTJGWVgV3hQXVX20hI8Qrx4IAm2EImcPkLEgGV5EjuVPuSlY6Oy9ncUXF6ezjko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5tiWQ7DH; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrHtkVqpQAvYvBawpoUgesWetRn1HBLL2YgjfHaaJwjg5N1j47A3sNtPu+CwJZ/j4dogrKrKL6ax7GS3oSiEp8dKMOU994a7fr0BSt3SOZCvWtFgJ9FjSJyjr5c/tXeHH2/pGzurEmbnsnuaaXDjU9mcKX29gsGCnlAnO0Kj6ErCHqOHl6YcSNUYZJ8T0In12LwR/hHkVBdI2Ay3IOIt7D8jAGpTU1oX6R/uKOfQEt9C1++7JfIBP6DUu2TBw3GcGQUSb3HVd7cak/XSz01KQdGFjCk9ej4xtekcYvqExFOD1oz97j1JXWbBDtCnruTmXY3F7R3bYx47uIYUP8Dibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jN9tYBS9bHomPYv+sGBWobT+99EALGh3iXP7LSaIlg0=;
 b=EZo14Bfs/1xaUpzb+9v23SgOSF/+NQSuQdeknu/SJbmp+Ipu43dAI4h/Rt24VAJvmf1OGFX8uWv4JKTFWausT0Im8kDolYn7qXV2/2G7XSe5fk3D0bmDfAO+D632M7Ecnjwsx+czeEI4gDD2CuB0aMwphUb0e5KJ6kGCsJjuQyP59t7ZD8RNhdU7QEqhO+WyNH/wTSU3PSs3No4CNFWl6btMhROOoNJvWZGZ3uG1hMJbH8rWYAdrR1OBlRG0Wc/ixg7gLNmKSO+Xz1AlnMdezDAoCTN7EFopBiwvEjrZl1SzkOeH6WzzLD75uQfekFRbremUuzXHT2PCE2obLtJTwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jN9tYBS9bHomPYv+sGBWobT+99EALGh3iXP7LSaIlg0=;
 b=5tiWQ7DH7LBHvGCU59rUHuUivssulsZWglpijz/yXydn/Wz5iE8kCPs2r+Vkh/A6JTtEllwLf0VC0+3uPBzSlckSyyEpDiEQN3WFLYFITNEnJc/g2eA1EPU4evcWtBdrTI1oW3la72oiQXGA2V5Ig1svm4IAdn0L+FYjcxo+kac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB9490.namprd12.prod.outlook.com (2603:10b6:806:45b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Tue, 10 Dec
 2024 16:15:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 16:15:32 +0000
Message-ID: <f9de6870-5cff-37e2-90f1-75fad96737cb@amd.com>
Date: Tue, 10 Dec 2024 10:15:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Simon Pilkington <simonp.git@mailbox.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
In-Reply-To: <Z1hiiz40nUqN2e5M@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0158.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB9490:EE_
X-MS-Office365-Filtering-Correlation-Id: 361442d6-ec5f-468f-3c42-08dd1935df4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekdVakdVQlRxVTRyRlZGcmNuaVZjTlZETHVVWllCNEhISU9mUkZFUnRBcU5Z?=
 =?utf-8?B?UmJtWUM0M0JEYUU3VS9uT0xnZTZjVTBNRXY3NkZYOWhNTTUvaExkVE5vTTlZ?=
 =?utf-8?B?Y3N4MTJWNk0zUWhSTE9PUkU0Q085L3BhRi9PcXdzTWM3YkdHRm44eEgrYUFX?=
 =?utf-8?B?SlJ2OHlOZGZSOUx6eSt2dmNzd1BDNzd5ZEd3LzlOejJSNUQxV0pvakRmMjBR?=
 =?utf-8?B?KzdJRS96NEx1Qk16cWtwL2dDTEhZOVdSK0lmQnFSL0twcjM5V3ZqdUpwOGpC?=
 =?utf-8?B?Tkg0eStiODBQWjRkL01QUDZ2Mm9qR05oZWRpVGZxRHBpcUdnVEpYZTVQa3Rs?=
 =?utf-8?B?cXFTMlVxVHlVQ0FUM2dvWm9yK0FTcjhhL3NiWmxRQ3N0emdNbzZiaFRWSHF3?=
 =?utf-8?B?WWtVbW5WYnVqdDhIRU5qVjV4OXdLTVFoNFdRMDVxeUVkd3lyTkZ6cjEyamsz?=
 =?utf-8?B?bmtwbURaU0tlNHphcU9NZ2JWWXJqTW9uUERiaE1Nbm01NVBGdnRJTVB4RjVp?=
 =?utf-8?B?WEt1N3V2UU9jRXEvd0tKUW1Hd256SzZKSFZiYmJUNFpadVRjVEY2d05aMmhq?=
 =?utf-8?B?Qi84QlhrcW5wWTZqMnFzckpJbkhDQTRsZDBhdHdnQzI5MlBVWlBaMmp6VjlH?=
 =?utf-8?B?SmFNZlBzSThyQmVsaWZlS0NBdG9UeHhpbFhIcDE1RForS1psTzNqVkE4ZzR6?=
 =?utf-8?B?TjR6NGJFWTBMaE1IUHlhd1kwZk9DV2tBOVpDZnNNYWZMVFM4RUgyMVRLTC9P?=
 =?utf-8?B?QTZ1Z1czbTh1bWFsbzh1a3RDWWh2YXVvc2JlUHlGaTV5Sm5mTEx1Q2ZmWjBz?=
 =?utf-8?B?MmZpZWNEM1ZXdi8vRjRMcFdpR0ZYR3ViNjlwM2hFTjVKU1RCeDBwRUlHQ1h6?=
 =?utf-8?B?SFpMdzhpSnp2NXNLOGpCbk5pTEdSMFVYeGVSODhpOWYyMkUwMU9jQUhyUEky?=
 =?utf-8?B?TEVYZnhTdHEyQnppVklhVGpvV1kzWklaSjdEZUpzSmlhRERhTGhuWGpaSWRX?=
 =?utf-8?B?Mi9Hdm4rKzB4ZTRjZlRFWE5vTEU0dUlUekRON0RjY09nRkRxeTN5UTcxYng2?=
 =?utf-8?B?WXJtRmljRXNuemMzR0M2SGRHZytqWmtlSVdFMGZYWW1jbmhhV2pVUDV6RVA0?=
 =?utf-8?B?MWt1T0hZQUNGc3NBN25BRlVQTDU4SnR5a2ZCT25GZENHTkRSNEp0WllpT0xO?=
 =?utf-8?B?c29ob29aeUdtT2tMVXFFZjRGaDFISm1VTVBYOGNKbEhWd2NJT0ZkZXhVWDNh?=
 =?utf-8?B?Mi9DUkJOdUNIbHZnWDFLTEV2UUNGQ3R6K2JOSXZJYXd3L0l1TmJvbHpnc2pm?=
 =?utf-8?B?VlZ4MU1wVTFoeTFPL3dRUnhncWN6OXRrcTJuUitmd1VLa0tNZEpaVXhueW9x?=
 =?utf-8?B?VWMvaTNMY04zcDhFazRsaEN1SDdRR3o0Y00rY2tMZlNJcXAxR1J3TGdpY2I0?=
 =?utf-8?B?RStYWlREZTBCa3Z4VjV3aXB5czc4eFgwb1BPTXN3KzNPbDdMYmFQS3JFRTU4?=
 =?utf-8?B?VnZ2ZnJRVGVOL3NxbUI5M0hWUGs5VkRMSEFKK0NWTzZzOXNZOFJIMXV0YnV2?=
 =?utf-8?B?eERnZG9pb0V2SVlrbWwvaDVNTUJuU0ExOFZkUS9ORm85K2N4MmEwRGc4eXdM?=
 =?utf-8?B?Sm9IU3BYUzJCcnpnU2VaUzJ0eXdvaWdtSDdaakRpSS94bDBRVExNVlpxQjY0?=
 =?utf-8?B?eFA1RGhhWStQU3l0MEhpNWxrU3RRbE9mVVkzSWxOc0FtM2hKYWZjdlozb1pq?=
 =?utf-8?B?dDJKTWt1enBVSTNFbzliVnc4bk4rcklFWnpXMnZ6cU15NjZTcHI1STRuR1Bl?=
 =?utf-8?B?N2pHanBpUmxFT0gvSWJwdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejdRMzhGa3lpWG12dEZWdC9PRElPcWFwMXZTOXR1cmpDOEtyM2hCRmJTbFk1?=
 =?utf-8?B?VDVLWHk5N0tvOEM2cXBsRlBQa0dpei9tT1o1RzB1T0ptTWlQSDBsVFFvWmxx?=
 =?utf-8?B?R0JPaHhSUnNzK2VaTGwwbjBBV0xmSjEvMng4NklPTmgyK3d6Mk1QN2Z4QmxH?=
 =?utf-8?B?cmZHN21iazNRNWJSUGpQenRNbFNEWEN5ZVdCS3NGVXdGczh0TnYzUHBOakZM?=
 =?utf-8?B?UjByZ2l6OFp3MWlRekl2SWVKb2ZtL1l0a2hQS1JqSkZZQlMvcDVBVkpPclRM?=
 =?utf-8?B?UDdrS0hqRitxd2tMbTNSQkp4WGhuSnFzTzkzb29IamVZZ3pJZTlTTGhvU2pQ?=
 =?utf-8?B?L3ZKYVlJTWJRQzlPWTNxNjVJM3NDKzdsbVlBTTJXWnJLZGJNVWtBdm5acjJ5?=
 =?utf-8?B?MmVDblJGMjE3aXpTNHAveXRHZVIwK09oSExjZmRjelREbFJ6Tk9GMjd6ZVpH?=
 =?utf-8?B?STJRMU1lWU10UWZTZ1RubDE5VkpyNEhqMHpSTlNnaE1BT05TMWNxN1ZPQTJJ?=
 =?utf-8?B?d0VKL3AybDlEL3hFU2pVMnBkOERWVVUyMDFBRjdlU21ydmw0dlplM09tbDVV?=
 =?utf-8?B?WGJIUkl6alFzYWQ2YXpzZThuUFo2akdBeDdKS2FGM2VxN000d0dzOXhoVTZn?=
 =?utf-8?B?Y0k3MmlLSnh1dGFLY0FzbVlwSjdiMDRaaDVXQUswZlQ5Smptc1ozMG9QcVkw?=
 =?utf-8?B?R0kxZ1ZPTXAyMitGTVU2SkltRitlQTlENXhZbnRxZnozMVJtN096c0N2VG9w?=
 =?utf-8?B?UFdYWHpvTUIrUFg4YzlId2Nqd005S1lGN1VJYVJBTmN0a0NibjhGallsWVl0?=
 =?utf-8?B?Z3Q3WmM2Yko3Sy9tNVQveUNoeTJPYUFVc0EvZFpTVHdvYmg4K3g2TktNOWVU?=
 =?utf-8?B?Sk9ydlB3N2d0UDc3NXpVWjB3ck9YZnZQaTFFQWxpQkIyWERGV0FYMncwK3ll?=
 =?utf-8?B?dHNCMUNRelBnT2wxL3cxS1VyMm9XMGgwcmVzZWxWV2VJQktEQ1hzUGxwa1A2?=
 =?utf-8?B?RzE1RFRoaTlEc3ZrSWJ4SElzTHduRklEZEJGSno5TXlZTjY2UGtWQlJrcFZi?=
 =?utf-8?B?VHRLSkxsajg1aUhQTEtISWVIUUdMWUN2bUs0RmxVQWpCcVNZdjhNendLRzlk?=
 =?utf-8?B?bnY3VTE5VU8zVEJ4UjI5Nmd2NWJoNjJYMFR6Y1pWS2ZrVW9BWVhYb3BDVHVn?=
 =?utf-8?B?aU5hbWVoZ0kxQUNGbGZtQlZ5RmtFNU9xanlYUU51TzNqcDFhMElXQm82S3k0?=
 =?utf-8?B?QzNiNnNxV2k2VDdhcHBoOWZKbldJT3AzV0JaTFEvcy9ySXhjV1UwcE9JbDdi?=
 =?utf-8?B?a3RmeDVMOS9oSERld0FnUnlqRy83QUZvcUxEa1B3QTVrTnBhYzl2T252Z2c5?=
 =?utf-8?B?MEJMR2xvWURITmNBbkRtSjhYT1RjWHM0TC9jUFcrbFB1R0hoM0Zua2JBS0Mz?=
 =?utf-8?B?RWV6Um91aG1SZkFQd0tBL2MrdUpRak0zaGNvZnRFM095dG82L2Y4aGkvNUtD?=
 =?utf-8?B?UEpUZVFZd0U3V1V0bjBrL0dsdUNIMnlJZ2ZtQnpRMVlWSWlhYmcwckhHVXdh?=
 =?utf-8?B?T0JhZGdrQndXN2E5bzdsWFgzNzVzQ2p5czIrYTNuS3pocC9oZ29CdDhwKzFZ?=
 =?utf-8?B?WFJqNFdjbmVxV2kvVk1EM2pQM1RlMDBBcmY3L3k0VWl4SDcvQmRibkN6aVNG?=
 =?utf-8?B?aDNpL3IrcmZlMWhxeUhEczdaaEpDYk1yMVAyOFpORWR2K0ZhTWl5UlV5ZndG?=
 =?utf-8?B?Um52bGhhRHdyc2FSem5nWGdCaXFFYmExeTRRTWR5MU5mSTQwb2xaYStBRGJl?=
 =?utf-8?B?Q0ZFaWx6VlJ2NzBranVpdjgxbG1HbFloZituUDJJSHl0K2E5VlJZZXk3VGwr?=
 =?utf-8?B?RVVOSzQrTStTSEN4Q3ZRMXduR0VhS3hRbWIzbklKY3RsTjZ6ZzNqNGFud0Jj?=
 =?utf-8?B?aHRvb1FVdURUUXpjRkZsblA1VEx0ck5LUzE4amJhTTFid3NnOTN6K0JJOFo2?=
 =?utf-8?B?NzBtTVNZR0UzUXBwYTZKTkoxYkZzcU41M3AxYUpFM29ZZGlUa3pLcEpOcGQx?=
 =?utf-8?B?T2VxZ3EzRjdOK2ovc0tKY1RsOW9HWWdmMDVnT2JxS3RZd3dQcFRuOS9yT0FR?=
 =?utf-8?Q?e+e6qtBWwWGU7v2w223zpoQNM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361442d6-ec5f-468f-3c42-08dd1935df4d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 16:15:32.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CLOoG5xrUFVrofkkE7OCoZpEGMlICC4wqSHJ7+cDtHsjUzdENeTBunKsDpM+8WZmz7CMfhnQuEWiHDd2XoCsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9490

On 12/10/24 09:47, Sean Christopherson wrote:
> +Tom
> 
> On Tue, Dec 10, 2024, Simon Pilkington wrote:
>> Hi,
>>
>> With the aforementioned commit I am no longer able to use PCI passthrough to
>> a Windows guest on the X570 chipset with a 5950X CPU.
>>
>> The minimal reproducer for me is to attach a GPU to the VM and attempt to
>> start Windows setup from an iso image. The VM will apparently livelock at the
>> setup splash screen before the spinner appears as one of my CPU cores goes up
>> to 100% usage until I force off the VM. This could be very machine-specific
>> though.
> 
> Ugh.  Yeah, it's pretty much guaranteed to be CPU specific behavior.
> 
> Tom, any idea what the guest might be trying to do?  It probably doesn't matter
> in the end, it's not like KVM does anything with the value...

No clue. I do see that in Linux there is a zenbleed-related bit that is
used in DE_CFG:

  522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")

I wonder if it might be related to that.

Your suggestion below to see what bits are being requested might shed
some light on it.

Thanks,
Tom

> 
>> Reverting to the old XOR check fixes both 6.12.y stable and 6.13-rc2 for me.
>> Otherwise they're both bad. Can you please look into it? I can share the
>> config I used for test builds if it would help.
> 
> Can you run with the below to see what bits the guest is trying to set (or clear)?
> We could get the same info via tracepoints, but this will likely be faster/easier.
> 
> ---
>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..5144d0283c9d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	case MSR_AMD64_DE_CFG: {
>  		u64 supported_de_cfg;
>  
> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
>  			return 1;
>  
> -		if (data & ~supported_de_cfg)
> +		if (data & ~supported_de_cfg) {
> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
> +				supported_de_cfg, data);
>  			return 1;
> +		}
>  
>  		/*
>  		 * Don't let the guest change the host-programmed value.  The
> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 * are completely unknown to KVM, and the one bit known to KVM
>  		 * is simply a reflection of hardware capabilities.
>  		 */
> -		if (!msr->host_initiated && data != svm->msr_decfg)
> +		if (!msr->host_initiated && data != svm->msr_decfg) {
> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
> +				svm->msr_decfg, data);
>  			return 1;
> +		}
>  
>  		svm->msr_decfg = data;
>  		break;
> 
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4

