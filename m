Return-Path: <kvm+bounces-70304-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2K/SJ503hGn51AMAu9opvQ
	(envelope-from <kvm+bounces-70304-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:24:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 409E2EEFFD
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B670301572E
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B068C353EEF;
	Thu,  5 Feb 2026 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mkXeuNwx"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34183EBF3F;
	Thu,  5 Feb 2026 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770272655; cv=fail; b=mqzKe1l50vrS+woJFmp7N0H7YZdeBxkldIRMVUC45avTrO4yWp1tB8CQ9xfsyPmctycAkgGnqKnHQfTahrwxyJgmCzSByZVKO6u3RI8bZbk+Y/DBv+JC5IqfplCNBWOqtt84G2WpoWd89AmhYtUpgs3Z5Kujf+ddWTm+felDPm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770272655; c=relaxed/simple;
	bh=97xTqL5wyNO95w/2sQMKILN7U+JS5vGv1TtZmaOlyiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Yi+VYL5LJPT+HMiD+6ec4bENgrWaekvETRtKLCFIkbDsSQMUdLZpv/f0L/gqmaDvPLmCebmk9JCkAC5jG+MtDdun9sTnJhez8TVB0EyJ2CGviVq5yeo93YIMWOvzIm0NPHCqU9vT94im2dhlKN+OFYEiRdvujom4ng/ug85I1tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mkXeuNwx; arc=fail smtp.client-ip=40.93.195.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etKJDlCuOwi1qScajAeYpzScnBAizPoqf+YfbPtuuK+W1sPKwrov3lRtwbDCD4TrX4LvY6O3gG20TAJwNBkIlSNabxeTym3DNhg04/ur2zWcCYwuRqfhpok7lSbARthonqXuTjbTk6MOdnH9a61exUp3CfOyV4iW+iNtv+6LhtZN1JHu+YfsOqriUBWNlQ3bTRerhXPKhlP5QsnuR8ASP59Z+pW6fCvzRP9vODkz0GxobSXn7rbfbB6z0+QFDBuWmIweHD31BycE3z5R/vx+WLgtCFAP2ud/it2fYHM94H8BP3Tk0sZhA3ILE5EFWJC0P/W0UvByRByytgk6xeU/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztQta5EuvIu1NoZDhBqwmcEp5cJOkgqrj3mK5fuvWK8=;
 b=kbD+pi1k/9n/C6zPKHgsS/4PBT5FQP/DiJtsf7Y4tMytjMG73sE9RRLwxK0oabCncPaqmfFnlBvNujOzI1BGBWVHBncWlCve/X/+Fwy2YoTS7yV/Ula9zUI3KxKyAy/YyXc+noRPykwTPfKvHgrwqqPr0HG40yWnRRWbkCEkv1bn31aLqq8h97yrTkwPKouTZbIeC3LbC6O/ZjIG3RTVVEgxXnOHHR9N99d74U06jBXExemu6l+hGYPW21Kk/3FjAX4cqAFeLLS0neZQB5KEUUHJFQqrVxjgppwnAbtKI37ZMN452A06246AtwEWVwl9yDv4BS+3KTr7Fp1J78mE4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztQta5EuvIu1NoZDhBqwmcEp5cJOkgqrj3mK5fuvWK8=;
 b=mkXeuNwx333NXkFsAJvGs/HzoxJdZEhMA2CfFGeiJ8CJ0aPKjYVC7WpYHj1AUnfhuFjCynytfqAx3G8lrtOmVowb01enLFv9m59y1nCw7PiyB0qzgX3S01BxvEFWmIjLVBNz1R1DXzHlgm5fVixfuk+HyiXSmQgIUsGr/Hr44RE=
Received: from DM6PR11CA0016.namprd11.prod.outlook.com (2603:10b6:5:190::29)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 06:24:11 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com
 (2603:10b6:5:190:cafe::77) by DM6PR11CA0016.outlook.office365.com
 (2603:10b6:5:190::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.14 via Frontend Transport; Thu,
 5 Feb 2026 06:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Thu, 5 Feb 2026 06:24:11 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 00:24:10 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 22:24:10 -0800
Received: from [172.31.177.37] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 4 Feb 2026 22:24:06 -0800
Message-ID: <d45f3dd8-ecda-442d-be14-529ebd2305ca@amd.com>
Date: Thu, 5 Feb 2026 11:54:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>, <tglx@kernel.org>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <xin@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<jon.grimm@amd.com>, <stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <2026020515-immovably-pacifism-2176@gregkh>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <2026020515-immovably-pacifism-2176@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: a52699b1-b986-4780-9eee-08de647f2d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWE3cmVGTlZKbkc0OVRSaFhUMlJUV2dYT010dEZaTS8xTVAvNjhIWVhWS1Bx?=
 =?utf-8?B?WDRIenBTR1BlSUMvS1haejFJekVVMEdTd1IwYnNHQmEySU0ycE1xYjRwYnlO?=
 =?utf-8?B?VGk1OXNEdDVYK2JrNkxsUXFFM2Zzb21zYWdLcklKQWliczBkUGV1a3Rhd2t5?=
 =?utf-8?B?K0xINGlqdGNzR3IvQzhqOVNSYldXbFFoT1I3b2hLNmkvWHFDTjRnODNhWFU4?=
 =?utf-8?B?OHVsVEdVMGtiaC9QWE8rd3l1ZnJ0WjBCOWNXVnduaER1a1B3MGhaU2RGbndx?=
 =?utf-8?B?NUFiTUpGUlVLSGMvSTlKUE5aNndNNlZzU1NmZXVObFZRMEtPek5JT0FnTmE2?=
 =?utf-8?B?b1h1elJuTTlLQmxwMFdpRER2Ky9NUFNGdmRBNHVLenowWGJXZmkyNUo5UnZ1?=
 =?utf-8?B?WHJ4WDZFcndmVkUvUkJoaHNteVRLaTZVRXBvbHFzVDhEUUZNYTQ2Rk91Q0xM?=
 =?utf-8?B?WXFvTkRtaG9KU2hUM3RZRG9wWmpCZEhiQkpCMjZNb21oUHNscHZEY1MxUU9Z?=
 =?utf-8?B?Z000UGNsVCt2Q1BSSkxNMUpUbzhreWYvcHVFUXowN0Zlc0g1ZTcrQ3BRVkVX?=
 =?utf-8?B?R3Q3T0lwbW5hd3p6TnRibmtFUm00QWhILzljTEprdlU4bFVvSVFpKzFxbFRN?=
 =?utf-8?B?MG5GREp6d1Yyc01NUFJBd1RDaTlucGVDWDRMeWU4WHBqTjdHZ05CYVROTHFm?=
 =?utf-8?B?QnRyNWRwRVllZGVtaUJrNTVPc3R3U2hDNk95dTlpWGlrOE5aK3RvV0tIV1Y5?=
 =?utf-8?B?cHBEQlhVWEVjQ1pZSE9hZXdKV2F1aDRxZ21ITnplL1RhN3VqZGJDTi9XOTlu?=
 =?utf-8?B?cC9YNlhGL1Zrc3VQYWJSdmQrSUhmdjdIN0UvSlNUeXB4NWxCL0RmZERsL0x0?=
 =?utf-8?B?WThtR0lwY1FlbFZwS3ZzTUlka0g1Z1VyQXdQMHBVcnE4OXFyUDVzV29ZcDRm?=
 =?utf-8?B?VUpLVHJDb2ZuNjdoazRuUVBTQ1piK0dBKzZSNzN1RTVDSnVxMG5EYmQyaE5R?=
 =?utf-8?B?UWhINGVqbW1aeG9YRytzQzRKUnd1MVhOZkQ2TU9udEIvWVppY1JpNEUxQnQ4?=
 =?utf-8?B?elBaTDVVVCtZTjFGZFRuUFZTSldQUVVaY2xVc2xJU21GR1liSWQvdXN1blQw?=
 =?utf-8?B?MzhQazNwbGFEY3F3QmNnMGcvMXB3YXhNNnBkNndrdlBwTTZXckl3eVY1NXNu?=
 =?utf-8?B?L2pDZkQ2WGRVUWlHTXJDUTh5dFhjcnNyMWNxcWFaV29Kd1BjZXFGdHJXZFNu?=
 =?utf-8?B?bUE0Q0lPSkRrc0tZZVd2RkJYTUdodjFadGFXZXZHVVE5Y0pNbVg0b0QzWC9s?=
 =?utf-8?B?Z1V4LytQQy9YZWVDSElIU2hqeFdHMEFOcnNDa2xxOWVld3R4ZTRnb2lEUDhQ?=
 =?utf-8?B?eXV0RU1MUHpYa0R3TjkrMWM3Ty9yeURnQzRma1NaZ3EySlprOVdqZkJDbS94?=
 =?utf-8?B?dEFDdVEzeGU0WkNUcXlwK3pyMG9OWkJRcWRSeHZXbTd2TVVRemRMZFcyS0sw?=
 =?utf-8?B?RHhaS1VuMkEvVjdBVmFzazdNbmRkdE93RWh2TDk1NEJZOGZZdVZDT3lVM1FF?=
 =?utf-8?B?aHY1RVpGc0lGV1V2Wml1TFJyczhNcjBzRFVzbktadURIVjRrSitqd3VWdzlJ?=
 =?utf-8?B?VUo2d1h2U2JaYjNoYytLaHhqWnA0SnFRSVBPNVpnMm9DcnV0K2RhSno3UHlE?=
 =?utf-8?B?VDBZaStZSUE4SDJEK1JWUWUwcmRhQjhUekRQbnVQdFpaMlMxWHFzMnpUYkU5?=
 =?utf-8?B?dnJacG5iaXlaSXZxNFdUWFJWZzY5dkxub2tXQk50NVBacXB0c01kRzlFaE53?=
 =?utf-8?B?ZmN0T0NOazdjbE9sbDQvb3hVNXVPMU80WEZaR1BQOWlBVkFYbUUyZzByWEZC?=
 =?utf-8?B?cGtNNTREd3ZPRENjaXVuQlRweDQ3bkp4Y20zQ1dXb2lkVWdMaUdSSGpwWlZw?=
 =?utf-8?B?NVhEY3cxT1pvb2dKK3JMZ3BhQTdsZHQ2QlUxaFQwMUhSb2V5Ymk1Q0ExYzZ5?=
 =?utf-8?B?dnhsWm1TekRLdElCSGVYYVY4Z3pkTjU4SG13QnVjQ25xNGlIdTlrSUJKSE9Q?=
 =?utf-8?B?akxLMUtRNUZpN21iSUNxZDZ6ajVPOFRJVnQ3RCtnU0h6WnpKQldJRytWeDlz?=
 =?utf-8?B?b2YvT0g4ZEJNRmt0Zzk4ai9haWpKT3hTYU9Gckw0aktMdXR5Y3JOaFJrMmFQ?=
 =?utf-8?B?K0JtSlN5blFoVjdLMFR3aDRRWWsyV0hHUHdaRlFmbU1NRVYzVW16TnVQQ2U3?=
 =?utf-8?B?bmF1VmJLVFcrN0wrWVdINHRJNnNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s6M9bUCjyeV66/EW7dvzr7sm1G3YvvY1TO+5n/IoP1tgTeun/kxyRB+adjPPFO0/LJ1OPJ5Nc6F/vTjyAJq+wwLNpE2oOltXfCYQ+wiLZaqwZDL9OSLNmCSEKbyTTF/g0wshjkLb4N299xarAwQCwDtt813aTi7plc10qttUPIzpvlTi+0tjuAoNBskg/ikLF8WZMAKp6sgsdaQ4Py0i/rgKEXp+gjMZYIm0spuuO77kACQRyZjf69ia5TISym7f0dUhAOivpcej6nA+0XdEvY67tn9rzOL93M2NjBp1jr5/RJz9R8A6tiRgMoWgBHUpXqOMEU6i0Su0y0830Rd3/zUiViNSyxKMvJSR4pmR3uF8QVViaVsQ5vOaKcxGoLkSbVUXtn41/mBCMZ46tQVj0VSDlEkjuBXG7c72Rrm+4KOX9pWIfbgomo2NTaQZirJx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 06:24:11.3313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a52699b1-b986-4780-9eee-08de647f2d23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70304-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 409E2EEFFD
X-Rspamd-Action: no action



On 2/5/2026 11:26 AM, Greg KH wrote:
> On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
>> @@ -70,6 +67,17 @@ void cpu_init_fred_exceptions(void)
>>  	/* Use int $0x80 for 32-bit system calls in FRED mode */
>>  	setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
>>  	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
>> +
>> +	/*
>> +	 * For secondary processors, FRED bit in CR4 gets enabled in cr4_init()
>> +	 * and FRED MSRs are not configured till the end of this function. For
>> +	 * SEV-ES and SNP guests, any console write before the FRED MSRs are
>> +	 * setup will cause a #VC and cannot be handled. Move the pr_info to
>> +	 * the end of this function.
>> +	 *
>> +	 * When FRED is enabled by default, remove this log message
>> +	 */
>> +	pr_info("Initialized FRED on CPU%d\n", smp_processor_id());
> 
> Did you forget to fix this up?

I didn't forget, I have moved the message to the end of cpu_init_fred_exceptions()
because the original placement triggered #VC exceptions on SEV-ES/SNP guests before
FRED MSRs were configured, causing boot failures.

> Also, when the kernel is working properly, it is quiet, so why is this
> log message needed?
> 
> thanks,
> 
> greg k-h


