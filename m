Return-Path: <kvm+bounces-71206-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EQkHEotlWmkMgIAu9opvQ
	(envelope-from <kvm+bounces-71206-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:08:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25186152CBD
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D88B304A8A3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 03:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4631D2EB5CD;
	Wed, 18 Feb 2026 03:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RT2Jth8L"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550432566F5;
	Wed, 18 Feb 2026 03:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771384123; cv=fail; b=gFtM8++VengUXBcc0LXVWfirjA9tIOt6BLbYhVUUO6DSe4Rkg07cX58SXlUH7n/CuVPW7gL1igFOvyO4ofbaQcYRdyuWIV430AMfDz06DVyPgXbPn8eokpZ5B1JPrRDOV1ATXqSKSlwmcxMyJsCK6ZvFsjMKOIzGQBv/p+pRkx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771384123; c=relaxed/simple;
	bh=rbhUnOVyDcUt597WeG3x+3MIOAfTx6PY0JVl1/BgWs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HmIBzF5sPyhAsejBESsLEAOSCyBT04VbE51+sg3e15u8ke7XB236DGxq1qubyKkL3nKgAacE1S863wJFVeeFhqj+885FS+37f/YAdrIxMMelATDQPTMEzHQjCYpoqATuY4LhGQJBo0loPpoxwwnogbuihlNJzMFcNYSIEDMiugU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RT2Jth8L; arc=fail smtp.client-ip=40.107.208.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YTeg352qLNH1DYvk6YlNye28kfxez98EeJfbJkN/sPpM8DzgQ7+oj1VKzkeZE2z/D6et2pZ6k3bT+iO5dYNsBq/ggmfOGHxUIlqhP09QiEdm4eHe7DEDr6r92nKctdg+kz5IWgVyZ7pchnQ+spVVhy9WkBMrJGuHHEiR2UTnzehxCOe71aMoPw99agXgb4Bggjk+1fK5hOWiAOI083JJ5fcKXZ+/QX14uh+r7i6fnrgq3TkIJwOP78TzPnW84jnw+nL8GvVSFhwcW1yrphteu/O2UmbfWF+KicJJ2inMdHgPV7dwgeGWCeqAD00nS6VQK30jJU2tR3KxPHgRf8DSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9dkO2sDL0mpsuSf+V6J8rD+SqybfmztFCUyVWpNyi8=;
 b=zPdp/+Z4y6KkPzcIGunSWyt3Z1A16/KiH2UajPGlHb2AmCRlZXI7bRutzHF2sZ8UUeesED44tLx0XdLXM8Y1GQP4io7Ogdy600g+0nl8GhzsfVBbnfW+gT7Ilr/7FWxSJQ/C0qhmxC3xK6PZa1Zm7ul/iPXLYsg8C3u6dlX3ml5FpaCyAC2bd4503ZsiSs+GjGSzi7EQXIuM5XgPJZBsAGOQc7TqBSx+DmSjcuUC/Mf/lR9/PL2pOO4lylGJN9ZrEzK8Mo39mF5twvDib788uGErc2Av6rHj/Kt7ejyB7nayiYhKxxqYD8Tbu23Q4cmUQ8yrOnmolQPt2MvpfboL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9dkO2sDL0mpsuSf+V6J8rD+SqybfmztFCUyVWpNyi8=;
 b=RT2Jth8LF66B/p/z7+k4V24a7bQWSOdr0V+woKFlqW24RRmUiOB1nfRsmOXvzllgyhvDhoCp2avpXirnGq92oVCWJzaz3Kj2usZDdZCdjjAt0RYbq/AnTvC+bP/l88pWrPV3xlNNBTObvkTP8AzbGnHCWNAody6Eh3V3L5b5KGQ=
Received: from BLAPR03CA0164.namprd03.prod.outlook.com (2603:10b6:208:32f::20)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Wed, 18 Feb
 2026 03:08:38 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::d9) by BLAPR03CA0164.outlook.office365.com
 (2603:10b6:208:32f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 03:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 03:08:37 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 17 Feb
 2026 21:08:37 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Feb
 2026 21:08:37 -0600
Received: from [10.136.47.100] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 17 Feb 2026 21:08:28 -0600
Message-ID: <b860e5f4-4111-4de7-acc7-aec4a3f23908@amd.com>
Date: Wed, 18 Feb 2026 08:38:27 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>, Ashish Kalra <Ashish.Kalra@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
 <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ffb0c8f-63b2-4eac-4df6-08de6e9b02a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0djbjZGSExkTk9JLy8yblRJSzJSM0NZMUVwbHFlWFRaUTRHQXExdjFyWmlN?=
 =?utf-8?B?NExCNTlXRTdMQzlmNFd1cmtleHBoMFFBYVpUbUNRZUNSeVRIbit6UUs3TVVk?=
 =?utf-8?B?RzluZnZrMzVxNkNaRTFESXREdk5OQ2dCWjNHNEFoZVJmSHB0UlJ3dGY0dWg1?=
 =?utf-8?B?ZngyNGVXbDl5Z1M4dnZTQms1ZjkvVzh3U3RTWnYwYVpCZzhaNHgzZzYzT3p4?=
 =?utf-8?B?M2Niczl4WXF4RVFYN0g5eHhqcWxVQjdNdmdHWGM4a29MZkZIVTVncTF5bGho?=
 =?utf-8?B?aVIzL3NuOFRKMWZFc3UrMENJbHlrL2hpUFMwQVZOMnd4eVdSTkhDY1lub3hM?=
 =?utf-8?B?cjVudkJNMCttcTd4bU8weGlhcEYzTzFGMEVoTGlzQkpqTXJpSDE2REZ1RnRB?=
 =?utf-8?B?Q2pIZ2tqaHV6ekMrNmwweEJIMVZYRk5ocmpNeWJDTW1hL3RBTStNQ1g0Nm9Q?=
 =?utf-8?B?Q1YzNTA4QmJmd0RDQkQyRStVb3lvZCsra1lqaVlLc0loams0amIwOWpyYnYy?=
 =?utf-8?B?LytBR1hBUU1TY2N5MjY3RVVZRUdzTkV0eTZ6Q3RwYzh6c1p1Q3JtQXh6dmxR?=
 =?utf-8?B?ZnY2Wm16blErc3NRTXBWNURFeUJlaXZMUGdGaUIzWWtxUmpwc1RTaXlpcGN6?=
 =?utf-8?B?ZFZDcElYTkY5K2FRSzFLdnJScHNGVk9HQkxYMTZMeE81MjAvdjhvL011K3A4?=
 =?utf-8?B?SWFZSTJyREwxODRrOGd4RVA3a3pWM2tQM0RoV1JzWlJHdFo4cXdxQTdXWWZa?=
 =?utf-8?B?TXhGN0dTdWZaVjNvRjJFU3NSZ1E3T0tCZHFEQzNMaWl0N3I5N1BLakdtS2Ux?=
 =?utf-8?B?aXVHQlV1ejJTajE0SFgraGVGNG5nTGVpUjdiNndxSjBWaUdCL0FWUjZnb1ha?=
 =?utf-8?B?Y0RwdHpEUDdpSzUzcmwvNm44Q3ZRSi9QVjd0dUlRMndZd3VCbWpYdDdtWUpw?=
 =?utf-8?B?cVRRMG5LNDduNnE0a2pxak9RU0pSN2x1VGpmNk5nc3Bnc2RtdUdQQlNvV2JT?=
 =?utf-8?B?K3NUcUJzMDl2cy90cGhISzV5WTlPUWxDR29IY2QvTWt6Y01mUDkzL3BCaGcr?=
 =?utf-8?B?YjdubVR5NDUwbC9KWDBaYkVycFd2ZlVqckdnWHRRRlZLQTVuM0NsUy93Y1pX?=
 =?utf-8?B?dEtsdTZid2N1R0ZkOXQ4Q3duVUZsOFlzMlpDai9rODh3cytmMm9DckRQQmRa?=
 =?utf-8?B?ZHQyTnoxdnJLNUpPRkRjVkVPS1Z3Y3NVNEVBNml4RTFHNVg0VVlxZm1jUnl2?=
 =?utf-8?B?Yzc0TTh1MDRzOWxKelJqSVBNWU9qb1Fab005UXQyQS9iVy9PWnl6bG8xM0lX?=
 =?utf-8?B?MHI4N1BXbGs2a2tKajNjejZNMk42NnpPdzgxZlhEbzF2RW9WbUpRcWtvc3dx?=
 =?utf-8?B?UCs4T2pjOUovYTc1SEp1TlB3aHQ4VFNCTHlYRWFCSjF6NU5pcUFQOXo1cEE3?=
 =?utf-8?B?OXR3emRVbUxxVUlJNmU2WERiUk9EaTlSeDlwZHlHckhveElNUEU5RE8zc2ha?=
 =?utf-8?B?bUhremZDTjJtTEhJV25lTGt3eGJWcnpHeEt6RStlbUk3U0dENjVDRkhhVk91?=
 =?utf-8?B?ZytuVW1hbFhhS3ZjQW15TUtPa1VFcmwzTmppQ3MrYndGRzlpMzZWZWZ1V3JV?=
 =?utf-8?B?Sy9DZHRVMHl5Vys0RlNBcHE0SHFNMGRmUUFVemJMejV6Y1BidURMZlhiRXRF?=
 =?utf-8?B?aFlBQ1NBZUZuMVU5TFN3MDZUU0FvWTBmYjhwVnlmLzJyNGlCVWFMNGMyaVlz?=
 =?utf-8?B?Wk9zVTBYNlAyeXZQTUdHTE9XT3JuWWh2VE1VelBUbmtQRjBKK2FvUDVkcjMw?=
 =?utf-8?B?S1VBRnFvWmltM3NPWXpPUk9Wa3FUQVhuSnc3STE2a2ozbDNncDEwdlRvZUtl?=
 =?utf-8?B?YlA1OTRQUjF0SWZTYXlKTDJqSFB1Z2dQZGtuN3BsTkZpY3kxclpmaUhvMTR5?=
 =?utf-8?B?Nld3R3puSXQ1MTFQdVZwcHdxemlyUDY4UWFxTU82RkcvR2EzaDhyb2Iva25Q?=
 =?utf-8?B?TXFmQVhNeUZrODAySmwzSGxXbndSdkRma3duUWQzeC90UnNNSlE3UUdUNHZj?=
 =?utf-8?B?Vnc2OGtSQnNMRXdKbGF1T2VDK2VTUGJ0aE1ONWZYQzhMaGRVQ3pYWnBWYWRu?=
 =?utf-8?B?bUFlOCtIR1J5bUpkS0xWeDcxYlpLVTVTOHB4V1FaOXlYeE4xMWpRUFFwQ3U0?=
 =?utf-8?B?VnBFSkpjWExnMHZDd05saHNmd01CWlMyd3l1RGRMbDBBbk9hVXFJOHBZYjlv?=
 =?utf-8?Q?8nM6/nwj6WghdqEFKqgbZJ5wDDgVp6mE2Hhk7NOOzU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OhcLr6YvFgncPXxTUyFzBzCxc/iCS7TdpRO1fS9jgjwSIxP14PqZXP4iOPsgg4F4fw3QQIgznOgEQRx3PRkGAF/EqFtj/V2gm8H+BTs4X8s8DcU5s5sjCusw9u08AxgQ6sSHpXgLyHKzMiwO9Qp762uKTpBL4JF+W4tEn7FLW6AJTF3i0j64JgfhjC3Pg5pEaszCRuSUAw5rI7HoZ9CQCnQVqcFQNqkxRUKq3txEjgnpkFsVkK3colPKU9JjRVO0ARtZ9/f+jXh4SvgTipU7RitR7Ti8y3H6HY4jOsHOd930CwtfYnpzrz77sEu1t9fOjDURvITaoFkkjJNrY85qATfM6OexoLGM8cQCCBwR58I1SvxPIP/waW8CHlynjPMv7Hhls6O/B0U7xGr5G5MTeGNtKlBK7hPh3ydf7TpQCm7hzDDEFR5OJsgj5lqaGqQx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 03:08:37.6359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffb0c8f-63b2-4eac-4df6-08de6e9b02a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek.nayak@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71206-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 25186152CBD
X-Rspamd-Action: no action

Hello Dave,

On 2/18/2026 3:36 AM, Dave Hansen wrote:
>> +/*
>> + * Build a cpumask of online primary threads, accounting for primary threads
>> + * that have been offlined while their secondary threads are still online.
>> + */
>> +static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
>> +{
>> +	cpumask_t cpus;
>> +	int cpu;
>> +
>> +	cpumask_copy(&cpus, cpu_online_mask);
>> +	for_each_cpu(cpu, &cpus) {
>> +		cpumask_set_cpu(cpu, cpulist);
>> +		cpumask_andnot(&cpus, &cpus, cpu_smt_mask(cpu));
>> +	}
>> +}
> 
> Don't we have a primary thread mask already? I thought we did.

If you are referring to cpu_primary_thread_mask(), the CPUs are set on it
based on the LSB of APICID, specifically:

    !(apicid & (__max_threads_per_core - 1))

It can so happen, the primary thread ((apicid & 1) == 0) of the core is
offline while the secondary thread ((apicid & 1) == 1) is online but the
traversal of (cpu_primary_thread_mask() & cpu_online_mask()) will simply
skip these cores.

Is there an equivalent mask that sets the first online CPU of each core?

-- 
Thanks and Regards,
Prateek


