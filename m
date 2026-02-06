Return-Path: <kvm+bounces-70426-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPKsG82yhWmbFQQAu9opvQ
	(envelope-from <kvm+bounces-70426-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:22:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0426DFBF97
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 16C26302D0EA
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 09:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF4435C1A5;
	Fri,  6 Feb 2026 09:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xUBZ3rFy"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010060.outbound.protection.outlook.com [52.101.193.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2A348463;
	Fri,  6 Feb 2026 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770369737; cv=fail; b=dYSFh5e08aV2U5cpOAE09iMhl+42p55nVOnF5aYrayOOwbjLorpv09bhvXTAAKR/nAIrVqoQCQw5wecEfpE8j2H6rdQQqNDBCctSphsOn8KxehnwnPnTKSsbB0jo8d2h2rEBYCCHA4xYo3EASTs1lzktRu+QSNLFj0aY3TMQwf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770369737; c=relaxed/simple;
	bh=TqIpqDrXEHbtTXzGWsSJLBqfsYb2uYPjLldsdNXWFkI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=MXLu4e3UOoJsrIYkmT5ZQsMd54iOxMvtD+RaQFU8k1Vbxtt1pRJ5khlH7uo7duajUys11CJzT44Pde9E1L/eViq6uqWxpXlHzVrjTL3vATEXOLgBXk8lmr+Uf7iMyM+QvH03eriOs1BZ6+QFB7KUkrMxLy5+Gr4dMgAxMDwiwhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xUBZ3rFy; arc=fail smtp.client-ip=52.101.193.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFzNpmb2bwtUzGScJkF0DGB4UJEmm0eXUWN0YqtlKHPoxVb17g2jvSAfjXfdm6QdSmQRMIb8EXoQ1066MbpBYzM2STC1c41O+HmllJixMM3IrftzZT8bk+RkEhY+O0nRwGQSo/uHmhBDmbxuXlOtQl3spSuCpF0/WbmfpljDifQIeajvU2RxFY/Mx34VzyhOt9G4aFBkPQe0tYb+WsANZr5WyEdbcz8AU64MpbEwe94JAZkF2mCFmpIBlEgtJfllT05dM8p6ISIeNx5iZ6XL0fm2fQjxtcZmzrwHkoZo57jLJxRYGpv/rzUm/UF90NUeHLATV5KEKCOj8wPBRWNkSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJc8F+VXJHMpTRxcVFJR7bz7Dw/EpjOZoaoiwjlW/G8=;
 b=bOyzvmQ4HzVffV6D2iNFuQPjY8hcoynym9dsWJkbA6qtGgM8EPlXNQYscKgCcwFalbTa2/zA7+VEKoLBX9vx2J23OqNCuGNJlCZihGQecZ6oQYvWewfEE4Vd7Qms/mzaHoLFE3L+M6cONW1tO61sDa6GF2KQvjPsM6ISnB6Sgbxxyma1DoNYMkyVVFVbS0JNW5SCQRep13xbew5lFQVzp2zEpTXbU3K21JAqSxdQH9mifZelv8lwJJ130SwdcNeMwjSbCH7OgxnVDqsrIWmtQk9XN8dquO3WFDGZw6TJD3u7z8Zq/AZYoPPHzqukSGLaDJbaJ1Feiu3q/DsWwa3z7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJc8F+VXJHMpTRxcVFJR7bz7Dw/EpjOZoaoiwjlW/G8=;
 b=xUBZ3rFyiu3NkQw019/H86bIZfGwGgKdq8J1aIQyMHBu8DdihrDbPPgSgCySaLQuM3bHjfb7FVTaD+vCXT2AdGBaKJURJ6lm3TFlWglsfvnUoo86EFt6mI+DeHTgP0EP+NsTe01F5faCTslu8l6lg1RlDt9XdaCzZex6Bxjpw2A=
Received: from CH2PR02CA0011.namprd02.prod.outlook.com (2603:10b6:610:4e::21)
 by CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:22:10 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::6e) by CH2PR02CA0011.outlook.office365.com
 (2603:10b6:610:4e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 09:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 09:22:10 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 03:22:09 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 01:22:09 -0800
Received: from [10.136.45.190] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 6 Feb 2026 03:22:05 -0600
Message-ID: <85958aa8-98ee-40bc-8fcf-750bbf62ccce@amd.com>
Date: Fri, 6 Feb 2026 14:52:04 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: SVM: Enable FRED support
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>,
	Shivansh Dhiman <shivansh.dhiman@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Content-Language: en-US
In-Reply-To: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ea69fd-0ac9-4b48-86c3-08de656134c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUU2dU5mZzJuak41SXQxRmFHZDV2bmtUWkhmRzVMTTkxMmR6K0hHMnFZU1J0?=
 =?utf-8?B?RzAvZE8wdjM5RWwvSWtJQWE5SzRxSHVkU1R2V2tNVnVrdU1aZnNTSUx0Y3B4?=
 =?utf-8?B?bE5EcDczM0NyNVB1UTdxWFN6Szd2QXl3YTBnZ0s1NkNVY2pCY0ZJclRtazRy?=
 =?utf-8?B?aVNRRVVYeU9vdElSQkhYQUtEU3ArL3I3SFZidG51U2hWamNBdFFNWHZRY1Fy?=
 =?utf-8?B?N0JvUFo3ajI2UDRGUytMRi9hdmF0RUFnUGZoSHh0VElJdjdHN1R4bWsxMG5i?=
 =?utf-8?B?aEdhaWNlZzZPMVBPMW1RTGVqWE9NUXdBSnFsZFJBeVNXVWFHTlpZakxhQ3V0?=
 =?utf-8?B?bGVjcGhRNjBnMFlVbWJSRFVrREc5V01pSFRXUEI4VytSeEc0MXZUU1U2aHZu?=
 =?utf-8?B?ZTAzUGx6NFNnME9ra0NicGE2eEgyMS8wOXZyV3JYZWxIUU1XcU1mRUxpdjFS?=
 =?utf-8?B?YVVGaWcvSnNWd0VvWFRJeEMxMGFDVmF5cEEvNWZRb3RLRWR5ai9pRU9aUmR6?=
 =?utf-8?B?dnJWRzVUcTlqTWFreHE5VW1rRy9XNGIwRnZzSUlrbzZ0TEs2VG84a2FxYUsx?=
 =?utf-8?B?aGlocTMyQlNmaG5Lb3Y3NHp1Y204bDJCSjFKMGI3VE0ra0ZsbkpXc2dBdENy?=
 =?utf-8?B?NlNIVnhJYlA5YlBmT1JnZTZKOEFMU0dSc0VORlNXbHc0WklMUkJtMXg4a3BG?=
 =?utf-8?B?SHY3dStnTmQxK05vNjBIZHNWd3BLYlRMZVIzaGRqZHIzaGJsWE1QTmhrNXJx?=
 =?utf-8?B?VFlMM0dSK1NlRHh1SmlBUXliQmJENk9PODF2YTYxUTZLRlFRSXBHQ2xKZUdu?=
 =?utf-8?B?ZzM2WFU3bGhZMHdQcUZDQTNsQzdINm5QYWJEVE1WMUw2eXlJSHBiVjRQTXBP?=
 =?utf-8?B?NGRXMUp5MHV4T0crNUs0YlloajVuSVcwUzJTM3NKemcveExBcDcwbjJ0RTU4?=
 =?utf-8?B?a2tmSzYyMHZFbXNuUGtDNHNNN1JFb1A3U0NNT0NQUEZ1Rmpaa3pCaHh6aHhi?=
 =?utf-8?B?eFM3R0c5elNENzB1dDdSNzFBOHlGUUVaOGV2VkVuWGpFUlVZU1RqVmh2NGg2?=
 =?utf-8?B?STFtR0lHYXdBSmtwRjRnRnlETy9ySGRacGozRUhEaHRFUWpZSHFaYVVPVVNm?=
 =?utf-8?B?VE5Dd0ZUMjJJYXI2cEk0QnR6dCtrZ3QvcGlhWlhleXFQVDJEZG5na1hGdHdT?=
 =?utf-8?B?SmRPYkQreUtPTGF6elMwWmtyMHJZRVlxU2tQaHhXMkFIZmYxL0xzOWdwd2k1?=
 =?utf-8?B?Rm5ZVTBwRnhTNHVTemxwNExoR3ZHWHVpQnhqN2o5ZEhTQzVadmdtcEg5Ynp5?=
 =?utf-8?B?N1lIZmMzVDlOejRlV3RMU3V0WENqcFFiU20xTFNSUURCUDEvM0RkWFpablk0?=
 =?utf-8?B?OGY2Y2NFTHZWZXlCbkRtaUhLanBybW9ubTJZTlIyenpvemZpV3FCR2J1UEpK?=
 =?utf-8?B?aUMzeWJOcDJJUEZQMHAyK3o1TTBIWUowdS9EOUNzQWM0bk8zOFkwTnY5cjJh?=
 =?utf-8?B?dldDcUx6TXdwOThRYlV4bzNSdThjUjFnUmhUN2tFUFNmb3RNUVZJbFRJc1BU?=
 =?utf-8?B?SE5XNlI4OTJLNDk2ZmpqYUJNN3EwYjFaUlYxaHBLYzA5VFhMeWRRMi9ESlVq?=
 =?utf-8?B?dXdQUU14RzhUbTd0cUNyK29YczVIb3phYWZVZmN3WEwwemdjMkJpZ2JlTEl1?=
 =?utf-8?B?azg0MURSNEpnK0RHTVRRV2tpNkJHZHRHMUNEbExLVkwyTWZVTHExeFZvRkYz?=
 =?utf-8?B?NWJCRjh3VFQrRXQ2WGRLUHFzOVo4OVJHMGV6T3VVeldUSmV5UjE0RDBjMCtV?=
 =?utf-8?B?dVlXUW5lTHhnUmxpbDJ2TTF4aldES3crbjE0bzZFOE5tV3NEZFgyVmZWd0tm?=
 =?utf-8?B?OEFCSUhhOHZEZHdrZk5LcTZTT1pieHo2Zmliay9tTnpLQkxjUXF3S2pPMjND?=
 =?utf-8?B?aTNkblphek1FMWRGcVk0OGlEZyt6NTV4VXg5VVY2NUkwSmkyZ2NTUjRObVN3?=
 =?utf-8?B?cllKaDJSdG90WHgxZUhUL0FhM0VRRGhuR2hMNjErQUZMZDF1L2NvaGFKOWM1?=
 =?utf-8?B?NWtkMW5JdG5TUjZlNHkvKzdsdUlINklFeVk1NWxlWWlzVUlJUzlqeUFZQ1ZN?=
 =?utf-8?B?UVZScmJ4RnV6NUM4aDlNSHJGVUJtdUVQMGoycVdXeG9CaWZuNi9YdFQzL0F2?=
 =?utf-8?B?VE9JMEdwSml4cXBkZWx2UjZnamc2bnd1TnUzYm0vVGh4WEV0WHlYeEhMTUIz?=
 =?utf-8?B?YVoxNUZmeldCOVhxaXpBd0lndXNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fbflLSIEPnj5CR+y29BAT8f+ZRb480juKB9Mp8WOLcOiJqs/q6OmmLUyXv+/GAmTpuL/zTHjJ6W1sft+jqv6ZytBphoNe+gwhFUKYPS3XMFcAwx3f3x/XF29/TE2YBl9GVmR7zUGAS4/2G9aUdBFRNIOiRJYJn5GU823z/mpJawvieMqNm7wx7Ue+7nobhnP/8W/KA7zDAUkjvqxC3jaCwo15EDPJg2VFVsbWzHGx3eDMQ0L0vyvuxfymiouXoNNTjp3dCKOxBB90aXXqGfM/0k710tqoRptzHahfHsQcRzhRdxL/D1c5fQEsK2envTNoHykxIS8SFkLUptFsezFeFi+gPjlbBTy+SkgI6VmqiabXkuNHhDomq+gj/ovRNJ5/M/Dl/Gfv/Vh3hFiE0Pqh78ujARs1IyuIOUPPuOX86C+NodOCdnMU/f925UpYObh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:22:10.3935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ea69fd-0ac9-4b48-86c3-08de656134c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70426-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:dkim,amd.com:url,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 0426DFBF97
X-Rspamd-Action: no action

Hi,

Here is the newly published FRED virtualization spec by AMD for reference:

	https://docs.amd.com/v/u/en-US/69191-PUB

Please feel free to share any feedback or questions.

Regards,
Shivansh

On 29-01-2026 12:06, Shivansh Dhiman wrote:
> This series adds SVM support for FRED (Flexible Return and Event Delivery)
> virtualization in KVM.
> 
> FRED introduces simplified privilege level transitions to replace IDT-based
> event delivery and IRET returns, providing lower latency event handling while
> ensuring complete supervisor context on delivery and full user context on
> return. FRED defines event delivery for both ring 3->0 and ring 0->0
> transitions, and introduces ERETU for returning to ring 3 and ERETS for
> remaining in ring 0.
> 
> AMD hardware extends the VMCB to support FRED virtualization with dedicated
> save area fields for FRED MSRs (RSP0-3, SSP1-3, STKLVLS, CONFIG) and control
> fields for event injection data (EXITINTDATA, EVENTINJDATA).
> 
> The implementation spans seven patches. The important changes are:
> 
> 1) Extend VMCB structures with FRED fields mentioned above and disable MSR
>    interception for FRED-enabled guests to avoid unnecessary VM exits.
> 
> 2) Support for nested exceptions where we populate event injection data
>    when delivering exceptions like page faults and debug traps. 
> 
> This series is based on top of FRED support for VMX patchset [1],
> patches 1-17. The VMX patchset was rebased on top of v6.18.0 kernel.
> 
> [1] https://lore.kernel.org/kvm/20251026201911.505204-1-xin@zytor.com
> 
> Regards,
> Shivansh
> ---
> Neeraj Upadhyay (5):
>   KVM: SVM: Initialize FRED VMCB fields
>   KVM: SVM: Disable interception of FRED MSRs for FRED supported guests
>   KVM: SVM: Save restore FRED_RSP0 for FRED supported guests
>   KVM: SVM: Populate FRED event data on event injection
>   KVM: SVM: Support FRED nested exception injection
> 
> Shivansh Dhiman (2):
>   KVM: SVM: Dump FRED context in dump_vmcb()
>   KVM: SVM: Enable save/restore of FRED MSRs
> 
>  arch/x86/include/asm/svm.h |  35 ++++++++++-
>  arch/x86/kvm/svm/svm.c     | 116 +++++++++++++++++++++++++++++++++++--
>  2 files changed, 144 insertions(+), 7 deletions(-)
> 
> 
> base-commit: f76e83ecf6bce6d3793f828d92170b69e636f3c9


