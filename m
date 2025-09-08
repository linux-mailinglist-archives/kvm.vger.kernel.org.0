Return-Path: <kvm+bounces-57028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F67B49C47
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E97813BAB9E
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3DA2E091C;
	Mon,  8 Sep 2025 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L9eBSSrf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98361DDC3F;
	Mon,  8 Sep 2025 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757367364; cv=fail; b=UJoCqxdYtNXHvtEXrH9t3hneQKmU+fzzhIeiKCgzlsuUR9nIeV0CR8i86c/Kwz5jRfrU8fXlV7YrEcKhRALCSSgfTcxuBmx7xID/UtUTM5CnuvF+6uMJ/iEyh4/QSLgtLsy6P3zHFf1k2X6cL2V15NLtKY0dtZGMIy1GnqW+lUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757367364; c=relaxed/simple;
	bh=+OwcvYZUFa2fCg/D/YhmoCQDMIZtjROte5rPNrkQQrY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VtCsxeUbTknvmN9axTMSVbind/5pfT+izBgPdWVmxSUAGLNaGDqJ4LtZEnNBevDHgzN8I9B794ZTO51fjuSkhoJHLE/9oeo9AtBs0o0VphBmG9P6WJieLkgxYa/SSgQXlKDNp8gmlIL2eisx6kuTMpdeQpOM2Q05bMDkXtFNjOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L9eBSSrf; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWM+IR0LKxYiBWOW8YeHW3FADK6chyapybZrI1Vu1iE/Eowlj8bJHNGwX9irW9elLC6j8GF7Zui+GzklMTPBaOTcKbybLdOAsXhK/dFWAv2S68yvK6gpxvkHR5eNTCMY+cefyBesPKCe7zBsKZdZRYNtSquyIFLOtqfsxFqPtLK5WyeKOzEvjWsUDdiwUBwb/F6UBEjJS+lX4jOFWNpHZbuBlLlDLjgqZbleRhY2eJK1kTkdn+7iUjE3uVUpC8SGNWPsyZwEBOuqGdcc/vY951Fr3VAVHYNLGepJUU1egdCzkHnw/eIs+uW+tegjiKIHYL7NnvbizQelbjbfhMGeKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNX3BYJAdKnLBegSwjZ8Sdx8SjxMGETivBpKJMCY9yE=;
 b=OObYDOE7Bi9M6VFfet4O7exz/eOZ2u7dSS52oZzXNT78H4vI4H3uA16OkN36kcyh9fg9G9641lpXGuQ/LefcjEpJh7oIrPsXFvK5CyKYQ1R9UwWYLMSWDJjTYdq0vvKWGoRijEwQanlFcephg7FcKZCvlHVcTd++BUatrOLwyr7zzIBJSIB4OMxGvrdrDtysulyeAsy8yKrCRcclezsZ0LoEoxvBBqR9SyvtR7lkxFwD4HCSDkmIFPT5RKj7y2qy73q1WXjqagukisxtlsgeFKCzSXHgEaxxeeZnMwcXxqJNpft6lU/v/n1iouClP7iiRSpU42qtzOAFAILUossgWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNX3BYJAdKnLBegSwjZ8Sdx8SjxMGETivBpKJMCY9yE=;
 b=L9eBSSrfznLIBJ1kqaZ7E3aFd9s5MNVzRC5wD91AIU65sLqTJVC44PVfipoEcVJf0AWe2d7pn8NQxqR2rU8JW/D42pPQvotl8Ekdm5WGaREo1jnUjN8VWYjuNYPCi6OjPrj0M6LIFThrM6Br6OwslD5GI45mOi5qyVFH2Y5ZSSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH0PR12MB8551.namprd12.prod.outlook.com (2603:10b6:610:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 21:36:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 21:36:00 +0000
Message-ID: <b55f2ab4-da7c-5fed-adab-ceca54282ddb@amd.com>
Date: Mon, 8 Sep 2025 16:35:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SEV: Reject non-positive effective lengths during
 LAUNCH_UPDATE
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>
References: <20250826233734.4011090-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250826233734.4011090-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH0PR12MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1472e2-8af6-4432-bef5-08ddef1fb40a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUc5SnRzL2c4akU4WG10eEJzY0VTcTdsaWEwbWFaZjcxMm8xSFJNVSs3eWcr?=
 =?utf-8?B?MXpPZzZSTGg1ckZSUm9mVTN5dWtPSXAvMzUyTkZhdWJPS2dwR2U2c2JVTzdv?=
 =?utf-8?B?Mm9sRXEvVzhnOURLL0pRTit6UEovaHRBdW1CZUgvM0pHU2R2RTR2MG4wajJM?=
 =?utf-8?B?S012SjRzVkJBWithVEI0b241SkxhZmdWZndVZmU1Yzl6eUJZVzdWc0kydGVB?=
 =?utf-8?B?TVV2ZzdmOTEzaTZMMzNzdlJIb0NydmN6eGxTNStwWTBSdk0rWTVKQ3R0TnIv?=
 =?utf-8?B?UlZSY2UwbWQybTB4Sk85cW1hbDlsUEZpeHlJZTQwT0MyVDczZ3RHZTkwT2l2?=
 =?utf-8?B?VTJOQ25uL2l4aHZXcG9oM2szdS9DVHNHTWpLUXVxc3gyeHJFSGJhemUzM1BD?=
 =?utf-8?B?YlpwNitGVTY5cW1BU2QvNHltWUNVb2M4LzBTaVFCbHl4aVBkOFJDYlVwK0E5?=
 =?utf-8?B?a1BTeW9VWEptUVhGQWlxRlZySVg5N3E4Y0xsNzRvSkNzaWhkbzd4akFWeC9x?=
 =?utf-8?B?UTJsTTlKanV1Rm1sZUpuUU1BSlZmMXpmQXZqN0UyNnZhTXFhZXp2cUJEKzlp?=
 =?utf-8?B?d1RsKy95ekpYbisydU1zV3VEdWRGdUtkZXg0eGF2ZnhQR25ORHl0OHB6K0Ny?=
 =?utf-8?B?SENZN256V3ZsV2ZpTCtJbUFyZjVvK1ZtRVZPWldRM1lVYVJGVEJIRTVQUU1C?=
 =?utf-8?B?cHBiY2tFS3ZaZFNIOXkzK2VzV1JDc2l3aDRlTWZsaE1UWmp1MEZhNVliYUh5?=
 =?utf-8?B?VFFrRkpTNGt4cnlINUpKRGtyeFV0ejE1MGhsODVFdW5FcGhOb1F2ZjZhUTJq?=
 =?utf-8?B?ZTBVcXpmWUZkd3d4Y0lqNlk1eDNuclNGbmNaOWxYdGc2bktuekdlZVlyVHRX?=
 =?utf-8?B?cWxMMDlCUGNmNVdRVW4xblk0Sy95NWU1OG1oeXVvVHRCc2NkeXg3OXZCTHZo?=
 =?utf-8?B?UytsSEJmVWVxeDcxRXp1VERIWlVuaDZIM3VEeHB1NVR3TUFwNGU1ZWk2ZHhY?=
 =?utf-8?B?OXcxQkgzOFp3US9pb0sySFFBQWNhWDR3RjNWL3JVTGdoTjVYL0psMFpaNm43?=
 =?utf-8?B?M1NsL1RRenZzWGlqNEgzWXhSVlBYaFBFbEozTzlYR3lzd2lydDNQRDFmTlBa?=
 =?utf-8?B?Q2k0TXh5RUxNaWdkaDI3WGs0c2J5VGpxbEtMU1JuYjlMa2hNZUtzcDRpZ2F4?=
 =?utf-8?B?bFE3NUJVTEVqME8xanhSbExWZHdDVUZPSGhrbjM2Tm9veWpxNC9jZndlT1Zq?=
 =?utf-8?B?ZXc4cnlJeEdOcDh6bE5GY0w3eFpjNWhRd29jTTk4QnFZN3pjc2pFbmVOSlAr?=
 =?utf-8?B?cmdPb2kyZmF2WC9rd3I3ejFzdlZtb2QwRWl5L3I4QXhWeWtIU3F4ZkVMOHJE?=
 =?utf-8?B?amluV09uK0dTY1hhNjRLWnpQMC9GUmlyOHFTZHEwWUdFUGxrc2pEUXZ4eFU2?=
 =?utf-8?B?WmFQdDdwNWlUZXJWS2tKZS9OZk5mV1Qyd2t2dkxVVXdSYWVBZFRpa2FqNW5w?=
 =?utf-8?B?dTNBUUo2dEVDUURSazQ5S1lSWFZMUVVTbmJNck4zZ242WWw4eDc1dHllNzZJ?=
 =?utf-8?B?dHd5Z2FkSk5oMnUwR254eXB1OUdQMStPSmpmdEZCVVJhRnRCbjM1NFR5MXN2?=
 =?utf-8?B?dUg3ZDJnSi9EUyt3RlVVdUNBR2lGMGRIWTc5OUFjbU1uakpjeVpobUVoSnVo?=
 =?utf-8?B?RDZtR0xIb3RaNWdLa3BtUW5sUGxIemRWUlYvSGZDTnpGL2s3UTk1T05mQXVz?=
 =?utf-8?B?K2tFRGpNUTZxblB3d3c0Q0JtOVpaTFZmNXlzQXAyL2syZ2NlaW11U3JyTUUx?=
 =?utf-8?B?bUw5dTllWm9IeTRMV21ScldiNnFBR1VqckRMbWdxOC9odHB2SGM1WXdETDQ1?=
 =?utf-8?B?enpXazFRbnpxeUU0K0Y0Zjh4YkpiVFZKZExSY05vUVRpcmJpQ1ExRkZ0ekhI?=
 =?utf-8?Q?Ys+26W8K3Mc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MW5WYkx5bWU3OXQrTFlHREt1aWg1bFF2a21tNDVKOU5jMDgzVG9XQnM3YzVP?=
 =?utf-8?B?blcyaFpzN1ZDWXFFSTZPN1ZRZDNyTWQxa3c2b1diNTdkTkRUS0hkbHdEMUxH?=
 =?utf-8?B?R2c0d3pLdTZjaHYwamtGYTlHUUNKZGJZWjVFbnA1bldzVktoSGRSd09Qa2FX?=
 =?utf-8?B?Nkh4N0pYWlFENzJHUHE4UmNncU4zRnI0UStxR3Y2dGloR3R5ZWxabXF5WEh5?=
 =?utf-8?B?U1NVTVAxdmcvNDVRUmU1SmxPeUFDR0lHUjRmMVJYMU1NOHlsdkdhamNIY0dJ?=
 =?utf-8?B?ellSVGFFam5WUGxSWXBFei80eEkvR2dEb0FzdnI1a1dnSDBYQkt6Mm9tRENJ?=
 =?utf-8?B?T1IvM0kvOHZEdmdyNVo2SVE0RjBmRUZva1RIRUpUcktkZUR0V25JZjF0aVZv?=
 =?utf-8?B?M1lwTnc4aGlFajRzYUdMb1RDeDVpanZsTFhYYjdHeWVGZVNTQUVZWWxBL1lX?=
 =?utf-8?B?MkgwWTFTVHB4RFlNa0tJSWxWSlc5dm1aVEFKV3dwVWkvZlJIQXNLVXduaEJD?=
 =?utf-8?B?cHIvZWtEcDl3NmJVNmJCNG9kcmpsNzM3aWJXOEduVGE5NVg5eWFkSC96bk11?=
 =?utf-8?B?SFR6aUIrNlV3c2hzMG1OcHBYeVJmTVkvOStKOUx0anIxSUtJc2IrNi85YmdZ?=
 =?utf-8?B?Mkcvd3U4ZCswRXZucXRaV2VnTGtrMWRTUHpNaVA3djUwUzB1MXAxbjZwSG1n?=
 =?utf-8?B?Z0t1c29zazk1S2hNakZ5YzNZSzdZRWYwYzQxc21UVFJ5L01zV25MSy9QVUE3?=
 =?utf-8?B?TFg3cDFFMXd6UXVlKzlMQzlvZks2bEtXdVRXcmJESGZWdC9iN3hYVG11TndO?=
 =?utf-8?B?NDZNODVTcWJBb3o3NnFxblhZWHF4TFVUQ3ZkcW5VcGlsdWFtWnFkUXl1bkVU?=
 =?utf-8?B?VHMzOWJjZEVJc3RUckplVW9uZFFoMmc4a0FuOU15aVRzZmljblpvcDI3TVJt?=
 =?utf-8?B?UnltOVZGMHRZclc0RWVydlFPRFg5VUhYV3NSWWt6elBhUGtKVXNhYlUxd1lC?=
 =?utf-8?B?TGIwT0NlMmtKRloyMGFOaldVdmVsYmdmK2NBMmFUZi9mYnBaZHowTmo0aE9m?=
 =?utf-8?B?bW5ncEhzRUhndkV4a0NSWk9aMnhKVmNLcWIyM1d6UkpkR2UwdkJ2TXZKU3VF?=
 =?utf-8?B?SjFyZWgrenA0dUFDU2YraDJqOXhEc0UyNEs2dEFLaElxa3hTVEhWOTZvWi9N?=
 =?utf-8?B?U0s5RFNXQUFiRTR3WUE2VjErTktuUjgrZzBpWHRKTjBtb0dMdlJIMkZ4eklJ?=
 =?utf-8?B?dWk4ZnczaHJpaWszNDdWcGxibEp3T1JjZHl3VDI3N09GN0pJcE8rS0VyMDcv?=
 =?utf-8?B?NHl1K0RsaVROcDUzQmdGZmVpSmpWcXQ1MytHTXo5YVMwQ0ZMMnVJNXZtSzVn?=
 =?utf-8?B?S0hNbEhXWFB4dU5qYVE5MEp3cm03OVE0VHU5QVFHUVpWS3ZqSVBoRFdYM0VC?=
 =?utf-8?B?WkZmSzdzTkFjd0hGWW9Lb0xEVm1qSFd6OUhwNjRFajBKbWdFVFhxY0h1aU1o?=
 =?utf-8?B?TU5mbXBXY2FMdjM3cFVpR2xkL0dTUGY1SkFCVUw5ZjRtRmlwRXpGMjFTSGtm?=
 =?utf-8?B?ay9uNXYwUjMvemJFZGNyTE5Kc3BVcnVOQzdYL0prS1BsL0d4UkIzS3NFUWk1?=
 =?utf-8?B?ZEtKT3NvQ09hbk1jeGlFdWxoUXRSTVgraGFhQm0xck5mQUM4SEkvQ1JBbDA4?=
 =?utf-8?B?ck9sUmtXRERGTXB5WTFWWHZacXQrR1ZnWGpTUFc0cWlzb0xrL0FpVzhRYUlP?=
 =?utf-8?B?Y0hRK0lEa3QyQU84OCtRVERteXoyNmNvcXpZZ09WMlIzT2plNkZyZWlPcHJu?=
 =?utf-8?B?UzNsc05SOW9UV0ZSWkNsL0ZOZHFNTW5TaS9iYWw5S1h3Q041OE4zMXZhdVFO?=
 =?utf-8?B?d0hJOFNIcDgyQ1lybHg0N1ptdjM0NWx2ZmpqbUw1MWJCMm83cVpEeGwyUHZk?=
 =?utf-8?B?Q2I3QWpzZWE2K3o0b0FZbDZNRGVpWjh2ek1rUVgzYWRBVk1pNTBqYjZKNWJr?=
 =?utf-8?B?N250cjdnZmdqMlcwTFE2blNuUnZrSlhoNjFSRzZ6d3o5ZnVxd3lzUFNQSnZS?=
 =?utf-8?B?Z29ic2xDZnFHUXFpZFMyOHU1RTJuYnBKcmlseFZEaGM5Y2V2c2NXcmlPMEt3?=
 =?utf-8?Q?aCo/6eqdZ1Ejmde/vauNwilYD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1472e2-8af6-4432-bef5-08ddef1fb40a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 21:36:00.2745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/s/RpWkm2BtezgY7vP5xPo59ywLnCKfzsKT65EEfrI9gxmoFruHl0HCspnARC458GHKe/6YyJQqccCTlgbYLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8551

On 8/26/25 18:37, Sean Christopherson wrote:
> Check for an invalid length during LAUNCH_UPDATE at the start of
> snp_launch_update() instead of subtly relying on kvm_gmem_populate() to
> detect the bad state.  Code that directly handles userspace input
> absolutely should sanitize those inputs; failure to do so is asking for
> bugs where KVM consumes an invalid "npages".
> 
> Keep the check in gmem, but wrap it in a WARN to flag any bad usage by
> the caller.
> 
> Note, this is technically an ABI change as KVM would previously allow a
> length of '0'.  But allowing a length of '0' is nonsensical and creates
> pointless conundrums in KVM.  E.g. an empty range is arguably neither
> private nor shared, but LAUNCH_UPDATE will fail if the starting gpa can't
> be made private.  In practice, no known or well-behaved VMM passes a
> length of '0'.
> 
> Cc: Thomas Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Compile tested only.  Came across this when trying to figure out how to
> handle the batching of gmem post-populate calls.
> 
>  arch/x86/kvm/svm/sev.c | 2 ++
>  virt/kvm/guest_memfd.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f4381878a9e5..746a57bf1f71 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2360,6 +2360,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		return -EINVAL;
>  
>  	npages = params.len / PAGE_SIZE;
> +	if (npages <= 0)
> +		return -EINVAL;

Would it make sense to include a !params.len in the giant if check just
above this, e.g.:

	if (!params.len || !PAGE_ALIGNED(params.len) || ...

?

That way everything related to checking "params" remains in the one
statement.

Thanks,
Tom

>  
>  	/*
>  	 * For each GFN that's being prepared as part of the initial guest
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d85cc33c0bb..79552467add5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -639,7 +639,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	long i;
>  
>  	lockdep_assert_held(&kvm->slots_lock);
> -	if (npages < 0)
> +
> +	if (WARN_ON_ONCE(npages <= 0))
>  		return -EINVAL;
>  
>  	slot = gfn_to_memslot(kvm, start_gfn);
> 
> base-commit: ecbcc2461839e848970468b44db32282e5059925

