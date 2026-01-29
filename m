Return-Path: <kvm+bounces-69635-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEviLObge2lyJAIAu9opvQ
	(envelope-from <kvm+bounces-69635-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:36:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4799BB568E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBB30304650D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBD736A035;
	Thu, 29 Jan 2026 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="36qkEBHv"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C87353EE6;
	Thu, 29 Jan 2026 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725981; cv=fail; b=I1/tUeMBV8m9BQR3RBEM0HEbGJjw0oezD0NZp1YTwjij7GIz9+TvQZqf3bokh4FWlnmEmE2k7QDvDpJs+20Pca1/MuyKGbF4X3a6a1cIYAingqsHDrLhR5kzQVRUiJ0omf2rwvbBEuXoLtBLTVTL8PxET5PI2W68xQTLu2v0CA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725981; c=relaxed/simple;
	bh=J7C3DTS7Qkz8XbU/mE90spCp69iqO1dxmtRAeXQwo7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dTfkRKF89ApYgT0YWVvr58mK2qfPyxW7JOEd4/wk3gC7+TfGrHNL2pVat7NZ+2pW66RB+KabxV4BkYQqayWLF4+kvuBm+K4mAHRxA9ZMhUJ90cTVdODv55KvCntL8oJqFc6Uu7dI2unS+p/T6i3AGe/sVJ5IePeWPUDAbP1A3X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=36qkEBHv; arc=fail smtp.client-ip=52.101.53.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EX1aWNKDuOa74RiJU05U9lLASPBwkdlcUbGPKmsJkL3wODnDBI9RVaq1E3/E+Fv6Q/TX3catLuNHPx6d137jNur+X+EWtxxRE8S0JBjW71HM60/FU204mKlZKHiKNqrXvEwS3DHtqeMOpr/mtScogS+m70WcQT9RgpNorxCFsF6hwyvh4XRbsULKKrI+H8RQalL1s829nRB6B3Pq3YBRF1E1lBU7WI97yPpVkloj4M2h/mA6S6KTuqnMQx+rYD6ISwOE+sUEhZaSdFpMj1Rpx0/a8kSBU8mYWGVuxoFW5ou8QueFr4GALgu0YoCrnfjprmaL9idGUpfhDtTRik6Q3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7C3DTS7Qkz8XbU/mE90spCp69iqO1dxmtRAeXQwo7c=;
 b=i/zSAhV4iiI6D1UWFn2mEwRCkwhGs/XrQ8lH2WJ1mdbOMYTbokrfVt/qzoV9lJ+q4W9POz5C2KfZvM4NQScguuuVke+pKKWlpCnWZH6txzW0wdNVML0y4+zRc4XZwWUP0vEqIBhviZMV4ru2DUmMeblUi3KXcSqLRabjoU8aYsiCf/ohwRZVjNjc7k1j6ermqIJT+mAWXuIxmvVaL4jgyWxJJYnaxv+u1MDgG46HlLGp09hFSbXNpIGhfsQwv+KbWjvCqKwJawamXyW4Qyk5+5PoBsVlzTJE/eN9ZAspaVBOrc29EKPl2dW5QFrapF1//4QmZ1eaBW07u9gjhiMcEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7C3DTS7Qkz8XbU/mE90spCp69iqO1dxmtRAeXQwo7c=;
 b=36qkEBHv4Q6RoWZzJBicRE5UjUP3SlZOCh6f9w45UqViHJ0ixcmFf8rMRlaSAHbWYstJDcxglGsDyqtTJZgSfJmSXYH3AKQV2ZoUotaeWMYdvsQleLvN+xXGrGVv8w23PQKNTBcSLGU9DcFa4Q6RTi/9I/koe39iLOhOMOW3Vow=
Received: from BY3PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:39a::14)
 by IA0PR12MB8715.namprd12.prod.outlook.com (2603:10b6:208:487::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 22:32:52 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::3f) by BY3PR03CA0009.outlook.office365.com
 (2603:10b6:a03:39a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Thu,
 29 Jan 2026 22:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 22:32:51 +0000
Received: from [10.236.30.53] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 16:32:50 -0600
Message-ID: <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
Date: Thu, 29 Jan 2026 16:32:49 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Borislav Petkov <bp@alien8.de>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, Naveen Rao
	<naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
	<stable@kernel.org>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|IA0PR12MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: 49e78696-586a-47db-f6a9-08de5f8656ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REJKN1dYWlVRYU91NWsrVm02Q0NiS1pJTUFCTHhMcEZRWGdmcDZ5Skt3dHVP?=
 =?utf-8?B?a210cTN6Zm5DRkZaOGoyajlIOWpKVmVQSXRsTTJzSGsxa3YreGpGR1JwUmp6?=
 =?utf-8?B?NEQ0bzg3Y1UydXBidmkwbTRId3RDNWxTblBQcCtSdFBDMEJBQmMvUVB6NkFj?=
 =?utf-8?B?dGcxVmRLRVUrMHp4U1Z1NFhiWmFZamsvZ2kwUC83bnlocUZXTzFncm5YWXEv?=
 =?utf-8?B?TjdzL0IycHdGSW1aMXpUaUpTWFVKR1Q0Y1E5QWZlME9qeTFyMEI1dmQwZnpC?=
 =?utf-8?B?TnVCQ0FwZlFwQ3JSQWdNMFdDb3JSdng1TDRHTGp0bXBlZERKM2FTQU9pbmxN?=
 =?utf-8?B?VkhvSHJpa0h2NkxjQmNRQXlKVjIybUUwWHFwYmt4eHV2WUFuMklCUnpxL2FK?=
 =?utf-8?B?R1NRLzBadmNOeVZ3WEUrSWlMcEdZUm9adDQ2akN4ckpvTGc5VmQ1cUxrcWV5?=
 =?utf-8?B?eENMSTljWDR3YkNpakx5QlhMQ0pjbG9lSE53TlFBb1UzNlR2bGgvOUE1TUdH?=
 =?utf-8?B?MzByQzJpTTZCZzZxVnRGeVZWT0FiNzc4MjA2YkViSk95SFI4RWpDdWg2TVky?=
 =?utf-8?B?cTQwRVdlNENGMnl0SlpvTUtqdmdMRmZBUTBMdkhNaEhPNXVmL0JPWFQ5eEp5?=
 =?utf-8?B?ZTV0SzM3djJvekpXbC95ZXVUYm9rVDc0ZjJFT3hlMXdOejJxZDJsY2lnbjBw?=
 =?utf-8?B?TTBmWTVnTWY3M1lOTlNuVVBDbkgyUFp1dHJJK1l6amVpSnlaQjFBZ041dU0z?=
 =?utf-8?B?Sjc2ZFhsbTJ4SVExVll2dm9YSHRvczB1akRISWJ4SzkrNUJqQ1VTdjA1QU1E?=
 =?utf-8?B?YUM1bVozcERHeWtFV3NSNlZweVB4MkQ2UnFwWExXdXVOZVZncW1sSEUya3dE?=
 =?utf-8?B?Vk1JTG9DZ0dVLzJITmZrczdyeHZBUTQwWFBIdS9YN1lZdFJBalVMcnE1R2Fw?=
 =?utf-8?B?NzlqalF0NURJeGJvWU90cDl6aituWmI2M3JqMG82dFBYaGdjQ0M1UysxVVdS?=
 =?utf-8?B?dlorb3pmR2VNWURaNTdRUFZLSnhOTndBZy9Tai9TdHY3Q3RkS01rK3J2QWt0?=
 =?utf-8?B?dldUYW5Hdk1kNXF0d1FIdEQySnVmRzJlcEE1VzAwZGYvZ2FRU0pWQkQ1Q1ZW?=
 =?utf-8?B?RzRZcUdqNVIvM1o2UG85SERuQlVORmJHMXB4N0phZFF0eE5xbmFOMnJ1V01x?=
 =?utf-8?B?MExlT1NYRFlEWTdvbmpkSktYL3JvOEtaMlFIZWtKeUxwWmVwYUJ1L0RlNmh2?=
 =?utf-8?B?QUJYb1RzTUQwREFPZE01c09WV05KcjRacGVwQUxhKzJvcml2SUcwUDU5S09w?=
 =?utf-8?B?QnBzb045ZnpQVG4xTi9hQUNrTytzQUZiTElyM2tVaEtFT1B0Q3hwT081clcw?=
 =?utf-8?B?eXdsV3ZyMi8ySXYvU1VFUTJOWlJyM1ozaUlEa05ROU9JSFJsQmZFdjZ1NmNa?=
 =?utf-8?B?SVNzd3h5bHFVT3g0MUtIckdpc0JJWkN5MmhIQmRCTy9wK3F4SGZkYkJWL3B2?=
 =?utf-8?B?Si93RXJRbTE2amsrRW52U1FzSnptK2dBWGtrTk1Yd2U3aEhoOGs5TWJ5M0Nk?=
 =?utf-8?B?Qlo5elhnRzQvT2gwRXBBVnkzdjY2Nk9SNlBIY2NRVVlsZjA0bGF3NGNXVTBl?=
 =?utf-8?B?YjAwbDROaHVYOHhHS045aDdkaTUrWmh6Vm9xcGthQVJZUG1BbGRISzU5WjlI?=
 =?utf-8?B?M2d3UmZkTE04eGx6a0JWOG5uRjVMTm02N1g0WUVJc0V1V1J6a1lPZTFUVDRs?=
 =?utf-8?B?MTBHQ1ZrekNpaTBTRjdKVEJVTmJyZ1FZNyt5UlhBOVdNN1FRNzZVMytTbzR0?=
 =?utf-8?B?VTA2aWNQRGs5T0habjhEUnM5bVlORVBtV2I5VzZSMGkweVZyTUI0MXJhUjdL?=
 =?utf-8?B?Z1lZbzBZdU5VbytaRFBiMEZqT0pDYjlZbDNUNm04K3JVSXRVUytuOTlTcDU2?=
 =?utf-8?B?dWx1aGxRL2RRcFIvcTRHNVlSYmhuMDFEZ0tZdFRsYzlrVCs5bGV3VmQ4TEJw?=
 =?utf-8?B?aHEyU1YxSmxoM29WbnBiczE4b2NZRnlUMUFYQTBoSXVMNGduQUR4eDlCWjdT?=
 =?utf-8?B?VmdnbCtjQ0x6T0gyeFhsanFpakdjaXF4akh4bnZXeit0dEJHZUpVNEU5L2I0?=
 =?utf-8?B?Z3VJWmpLeG4zVGQ5dVFnTVlJd1NJMVBDa0gzNFErSG9mU3F5dWp0WTgzcHlM?=
 =?utf-8?B?Yktiem9lMnpqLzA0TndjNEU0MW9aNmhpaGh6ZkNwQnE0azRyeERjNFVTUzhF?=
 =?utf-8?B?UnphcWpPOTRuaEZuOFBvbzMvRVVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0FJX4ctQizq/BwDQ5rxXrRcU9/12U7Hk2f9bk8cqGtt7gdb3c3J3LMqSKnUUEhWspfOboKAONHLsjdn1kmxV7w3vzMqmlVI3+3j/ptHTa6D6odXv3EC6r4eOAc1BOi8JXo+5kWg2VoJdoe0v97KQuOEXj91FbRZgGG9cFacF2vBH1nEgbH7n3jxsv4DAGwpLuYT2mWfgA+ktDICJWFiO/Uots6dn3MCdsKBCbcwW3T2c7tYPbv4kxE+aCvmyFxv3Wf7kKlbALiZN09b8Vi1RIZOKAnVZrel1lyOJSNAwaM53UAohQe1n2oZ6spbzFVnMf9NFtA/MLwALMDcQTxqPRnBE149v5T8eZQDiN0wphfm760ZMrb5mtqzioRWUAWc4LtlsryVOKnmyRa1J9rsI9RM69e46606DksoNpsmJcaMFAGmRLCoD0YBLf3zW4Sim
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 22:32:51.6969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e78696-586a-47db-f6a9-08de5f8656ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8715
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69635-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 4799BB568E
X-Rspamd-Action: no action

On 1/29/26 4:51 AM, Borislav Petkov wrote:
> On Wed, Jan 28, 2026 at 06:38:29PM -0600, Kim Phillips wrote:
>> SNP_FEATURES_PRESENT is for the non-trivial variety: Its bits get set as
>> part of the patchseries that add the explicit guest support *code*.
> Yes, and I'm asking why can't SNP_FEATURES_PRESENT contain *all* SNP features?

Not *all* SNP features are implemented in all guest kernel versions, and,
well, for those that don't require explicit guest code support, perhaps it's
because they aren't necessarily well defined and validated in all hardware
versions...

Kim

