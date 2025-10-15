Return-Path: <kvm+bounces-60062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D15BDC7A5
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 06:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A821A4EE36A
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FFB2DCBFB;
	Wed, 15 Oct 2025 04:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lY6XRh5L"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEA51EFF93
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 04:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760502752; cv=fail; b=oQFOTWXBxVvn86qebIPRtkVCbhzK7a+bmcVExEmaWx+5rm5Jo5CxlQIDxghlg4VEaOTGndNw1KyVzGLMKuxR/aEfcLqMvRcHrlOaY6Rgt94+xXGV1AGPEcTxWQMHKA6aZ2kvsDyYoGJMn4J1x/TiS+idXxYh70L1Ynqo8ErN4qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760502752; c=relaxed/simple;
	bh=sNrmNl9Zi+rkWAmbRtA6YIeVo+nyMY60481U6qtEklc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eCXCg8jeC1Juny3qVUReYv0tgBJmj9dat7a0HhVtag9O5TkOuDqw8hcvNrwMTyomFIfMF/5av6bIr3JdIZbYTmV+PVsCzTOTaTNvBGQHKonREM+iUh+4tv8yZzUtYKwgAiH7MRqjEkU9cMs4/rsexIeGafMj3sv8CNBelEDmswo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lY6XRh5L; arc=fail smtp.client-ip=40.93.194.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ucm5pxspdUdDDzL/yyrpbt+yMoF2hgW7kRU2ALL7R3qaLTDzlerWfSShPq4uVyj/TOHckcSN5lodtpPKISV3b29zvlK24A/FKHGLVYnQZyLAiIobpg4Ri3HEPE4cYn/cURn8auAkN8QRWOPk+F9cMrpzzsfltL+I9fm6fR8EtP+7MmdcfVVy6c/qd6bynAe8FhbiuctQHefI59sNXfPN0m15/4rSMXrre0QrKD0qvleacAupkdS+LmEAqsWUUGrLbIxZBPpdOEy9sIVFeT0sIXxXMf5LpcIStT7KCwhnpHC+hE25SOwljpMjTtpfnyuYh5sw9w6KCw40Z6XzeOlTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vuoSFV41CyTmRlZfBjSTANbHob56g/RT/SZ3tY2Wio=;
 b=yyWghQhtlevKQ2j9fcItddSGLXpaev1Ih6oil2YBeeXlQsV0yl5SvUC/sNRenmOvKKyeVf7WblJawhL61Ly0s3bl2XIkVcnTsE9szAJIYO7r+2rZnGN6QeEEeCR0CBLBCZLXRFEdyDAeR0aTxaUB2dN3/DKPEtdWH3s2ofdyMxXYgakolHJbGBTReL9wVp120zN1V2L4XIfGJY+UYH4xLHwWQfC7Z1VrgpoO4IPZ2xBqk/OTFjWKTh6UBjxnaHQYG0c2U497PHZbk5uVeNSxBtV0j6a0ICHS/GUq65Q7+QskqQBH0Oczo1phIPVz0jL5CnL2iZCRDtiV4KgZ/EkDAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vuoSFV41CyTmRlZfBjSTANbHob56g/RT/SZ3tY2Wio=;
 b=lY6XRh5L917E960WRKchbueaeQkCQrer7ixdb0QK05lIzxWfeSfWNTk0ofKyXTeFrnYo+1gKonfowXvzPi2YvIU9kJcsVYSVKwwrNgka/Aud4KwVfdw7w2UALQxAO2aw4Sz3qVWtETsXumFN/MdN6285WUJWiPwBA3DND8MM2RU=
Received: from BL0PR02CA0096.namprd02.prod.outlook.com (2603:10b6:208:51::37)
 by LV9PR12MB9784.namprd12.prod.outlook.com (2603:10b6:408:2ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 04:32:26 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:51:cafe::6a) by BL0PR02CA0096.outlook.office365.com
 (2603:10b6:208:51::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Wed,
 15 Oct 2025 04:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Wed, 15 Oct 2025 04:32:25 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 14 Oct
 2025 21:32:25 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 14 Oct
 2025 23:32:25 -0500
Received: from [10.252.207.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 14 Oct 2025 21:32:22 -0700
Message-ID: <a72e71b5-08ad-493e-8f48-39bc47dfdf97@amd.com>
Date: Wed, 15 Oct 2025 10:02:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] KVM: x86: Carve out PML flush routine
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-2-nikunj@amd.com>
 <77d07401b9bf6bc6b10c1eda7c09d3e8a64debfe.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <77d07401b9bf6bc6b10c1eda7c09d3e8a64debfe.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|LV9PR12MB9784:EE_
X-MS-Office365-Filtering-Correlation-Id: 22888676-3ba4-4ca7-7981-08de0ba3d7a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OExoblhTNUhLUDQ3ZmUzOUVwNGw3aEFtbXJPZEpvSXNsb0o1Ky9zTTVienJk?=
 =?utf-8?B?YVErVUkrdlgyVENsdlFZQ0ZoTmorTi9TRzNpYTh1Q0lzQlFRYmdIMTZVdE83?=
 =?utf-8?B?SW14b0tzbm9xWmFqY3phbTZJOE1TQWpzZStRVHJPaTRKOTZsQ3o0MWltRGV3?=
 =?utf-8?B?S2JTbnNyZ1B5MWN5Qk9seEdaazFZWTFhUGE0Nk9iaTliRkgrNThYRlNZdUpa?=
 =?utf-8?B?MCswMlNvWkdHL2x5UEN6aGxRT2FCUUpOTi8xZ29qZFQ2aThIa21CWUc5TUZL?=
 =?utf-8?B?TGpIVEs4YmhyVUU1OWRyNUFpVjVFVGNnejlIQlZZbTJVeS9raU95SG9ESWN2?=
 =?utf-8?B?UDlTQnNmWlR6Zy8zUE9EM3R5WWd6c01RTERFVGZweHZIRkJ2Q3ZleUxnb0Vz?=
 =?utf-8?B?SDBVWWZ4N2Y4UXNidXBRb1NwUWtSbXlMeHMxQ3VjYklqODJGQmFrazBZa3ow?=
 =?utf-8?B?N3RFOWk4eUJLZXhqZWJXNTJKVnhtZjVLTlRTcm9SUXFTb3J1aHRnaFgzcEQx?=
 =?utf-8?B?MkNiWFdZek5tVzl3ODRMRFNIUklJUVFrSVVsQnUrcUFKQnY3d3NxSlZ6M1A5?=
 =?utf-8?B?YThpaXFxbXYyRmZnTnFDVjVrOUY5aEhQMUlBWGFNN3c5aE92bEVpeVV6MGho?=
 =?utf-8?B?aW1vcGNBNVdrVmlWMTE5N2pvcWRRaFNJUEk2bmRlTk8wRWdlTnNmcjFFOTZ3?=
 =?utf-8?B?MGRYczJ5QzVDRjZrMFdxUllYaURBRXNxOEVyaHNvSW5TZnpwcFU3cEU5ODBq?=
 =?utf-8?B?eFQ5aHN0V0JiNXhNZlRtWHEzQmZhbUh3RFV1WTA3R2hVR2dEUStKcW9BU3k5?=
 =?utf-8?B?QXArclp4NzVBT294ZlNlUm5WZmlFaGNPQm1LZFlJblpaUys5K1RqZWd1b2ZM?=
 =?utf-8?B?a25hQXJHYm1OOVc5SHBIRk1yeVRMOThEeXI1N05vVTI4UFRLNUprRndYSit3?=
 =?utf-8?B?MVd3WWJrVHI5QWJKYzVqZ291VHZoZDk3cmRjUUlZVGEwdVBLeCtmTkJiTHEr?=
 =?utf-8?B?Wm9aQ01xcy8wdnZrdHN4M3JOOEYvQzYrdWgva0xEYXo5dWNjdGJ3Q2JaYWZk?=
 =?utf-8?B?a3VQQnZEalBiK2xXRFFvem04YjhlcDRBVFIzMUVZU3R2dGFtQXJBbEkxTzBC?=
 =?utf-8?B?ZnR1SnVpTXZPeXJOcElnR3VtdmNOMGRVek9tZ3IxeVl6T0J3ZFM2SkZLdlBV?=
 =?utf-8?B?T2xlMnJISEdoNFZHT21nS09aTnZvdTVCSWlVdFJvaENoQ1BZcm94TnJKWEwr?=
 =?utf-8?B?di9JVFpLRlNwMGRMQkxXVDZDRWNFUkUzdk1HZHVpWXM0YUlRVm81NTJwakVP?=
 =?utf-8?B?UDNiWnhxWlhZVkw0bGQ5Lzl5WVJselFQVzZxSzNZbmpKekZBRkczNXl5TEpv?=
 =?utf-8?B?L0lMWkRDR1BlRDN5WjY1em9GSG1tMnl5WFc0YkNYeDIvK09kc1R3dThZVE1u?=
 =?utf-8?B?ekNoaHhjcXFyYklPVHRiMHd1UkQvZStZM251MmJweUtrZmpzN0hjZHJaVHQr?=
 =?utf-8?B?U2JCM0lyUU4vQ20wYldDT3B5RTZsTm02RlpzRUhvWERYY2hnV2d3eWVoNE5W?=
 =?utf-8?B?R2hhcFZ6TVBVVUxPNnJNdFRoK2ZIczYyZm15OC9NVFJRS0Jvdm4rV1ZqNFEv?=
 =?utf-8?B?c2FybHZtaXVnbUV0WlBnUmxtV1ZTNWtYRUpEdk5rb08vMlNzYzFsNE1Pd0V4?=
 =?utf-8?B?RjFENDloWDBGb1B5T21aMmJ1a1gvZ0ZRbEFsMUdyRzRlRDJidWppaUtFdUp3?=
 =?utf-8?B?Y1lWUk1lN2ZJTGgvRGxMaitsVS91Uy9YbnJtYkhsditxNWdrNGdNQzlzV1RH?=
 =?utf-8?B?MHZlYTlNN1lmTXg5RStUOEloWTZNbFBEKzJLdlg3bFQxeHRpOExBU3ZPWDJL?=
 =?utf-8?B?RVNlSVAxVDJacitmQ21jUDY0Rmp0bWcwNHVMb0FrQWxIQWNXV0ZvbUV0cE1F?=
 =?utf-8?B?SnFmRlh6Z0VXNDl3THFBckJNZUR2QVZlMnVPeUVSYm5ReVRmZTBBZ0wxcHNS?=
 =?utf-8?B?Mk5MVG9sbU1nZXhES1gra1FrQmxFYlBuMWtyTld5M1dkMWpiQ0s2ZjlObW1D?=
 =?utf-8?B?dTVvYlVrdVZZMjdHYW0wYmNaaW5kTjlrY1ZNZVNjRGZ3NHJheGJWc00rQVNh?=
 =?utf-8?Q?/Zvk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 04:32:25.8529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22888676-3ba4-4ca7-7981-08de0ba3d7a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9784



On 10/15/2025 3:34 AM, Huang, Kai wrote:
> On Mon, 2025-10-13 at 06:25 +0000, Nikunj A Dadhania wrote:
>> +EXPORT_SYMBOL_GPL(kvm_flush_pml_buffer);
> 
> Ditto, please use EXPORT_SYMBOL_FOR_KVM_INTERNAL().

Sure


