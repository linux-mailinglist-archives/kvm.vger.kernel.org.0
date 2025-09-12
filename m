Return-Path: <kvm+bounces-57404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 963FFB550B1
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B5A13A0FAE
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ADB531352B;
	Fri, 12 Sep 2025 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K7IVKoPb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035E311C20
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757686486; cv=fail; b=nC8DSYGoMMFcz6na14mfV3BPYEKZy05VeOxtG/CTuZxrTOKkMTG4bik/RuVPdS6iGmrgKQ2TLgM2ySA6fJXIqgrF6cMRDh8Aok1CJTskaDDUxsb/rxwic90sX0MLsCBI5PM4R71tFNHB4LevDFbeKPQHR2UmIifcEFJ6j78/2WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757686486; c=relaxed/simple;
	bh=rydkPBBe++WDoKtNH+PvNVqPzJt4bq9d7oACJvWYU2M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PNCFAyLJ0TnIwBCuruuZBb6G4QThpqlTDIEtwgW9VCFsc0GjftXpsjFGX3ph+4e4JP54YVZk4ylZeNSBB8yG5DcxTJHMCeHYeGwImcAAp+Bp+OoIwI5b336LOBOrRmuXpguf191KHDP9VNg7Idlbz2UR6N3Y0jY7GSmNoky9/4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K7IVKoPb; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaamogCmXFhx3np2pJ/TRu97ZBIsNNkcjVnC9z2284DObjpKMtk5kG3GMKC1KIC3dLA3Tk4e4qz/a7H0TeA6MprCqqdCec35b6m0ZlY9wsYwZ/Sp8uP20JoF3FIxtFQNo2atFgWyWrLELPRdqHUTGcnGuA7P8JyFcp7kUqjBp5iBREpiwgoZCS56eczkuOddm2q2yD0V64pecdDPJwP24QrjqZ6TDHQOSP5sUUPEZptSysdsuPBR/s/BnL/AgAKjd2GdDVfWyF1hNoJXYje1MWYl14tfsT/Zcnck6Tgn2VSX2QtpGN8WA1OgJ7XLlVk6FJDJIm3ff3GyaMFJalNm/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noZYnj+29JWdJGb6iAVHO954V0GJoHyNyv82h6MF7Sc=;
 b=c0oFAslS+xLd3S5SQTFpNo9pBIHdDvqZUHEp5NCDX1oq+mo1eYiAj6yMnYzSQfGgn6yM2cku0LRKwJEdUt0SAKSn4BO8Bxl/EI6vpjUGOM1HvCpzdO5Vwi5kvBpAofPwv7DQZ6dK873JBuyoUDjUHKAhhbHEC0ytj+f4n0ZmhKUzwO0QURsTgu8EeqvH+h+Rx0C3KHGjFBUCS/CnXgY0xjPIcmdztPuQkWpH1aeUf3pzBOBIhrAW1iDXSLJnnqahAl8I22de1K9ASgIWMhek+DB/rq057faR8TlZhkD7H6pE8Qwrpwm5FOak54seVgDnZ0A956G89+XOFchu5rJ8XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noZYnj+29JWdJGb6iAVHO954V0GJoHyNyv82h6MF7Sc=;
 b=K7IVKoPb2mjTAlI+GeoW5jYVmgSpdbbNkm168U0D+6E8uhNpgQEshY4Fm/EK0SXHKYLw6HGvCXqiFajN4hNuE0LDm9XUUIlkgVpvQqpz2LqJKy+dkdq+xSrmkUp+99oJ9/hMXJxdA+xcG4++a+vi2yQEfSoK1hWZ3N+VYikJJ9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8711.namprd12.prod.outlook.com (2603:10b6:610:176::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 14:14:41 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:14:41 +0000
Message-ID: <e36dbf38-0bd7-4812-a90e-5bbda03c758c@amd.com>
Date: Fri, 12 Sep 2025 09:14:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/7] target/i386: SEV: Add support for enabling Secure
 TSC SEV feature
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>,
 Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
References: <cover.1757589490.git.naveen@kernel.org>
 <4c5ecb5835d8600e1b7b30fba2e36e1163b8da83.1757589490.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <4c5ecb5835d8600e1b7b30fba2e36e1163b8da83.1757589490.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:806:126::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2b6ff9-1ac7-40e9-efe3-08ddf206b6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWVDNy9mTjZlT1VlVExBa05penN4QzQzUkdHUUI1ekgyZ2FjK1VPVnR2S25x?=
 =?utf-8?B?SUNJZTIxZEIyK3JRQUxzbjR5ZGpna1JROGY5TVpvejVFQnVaN1MxOTRqWlRC?=
 =?utf-8?B?TklRbkR3ZFA1NEs0Mzh0NkYvN3Z6aW1GNDRrUDdGOGNUOS9GTEdzT3pCRDBD?=
 =?utf-8?B?M1RNUlJRQStXZGw2aktVRWtiUDUrUFVjbnlQVm5ET3JTazlhVkhPRUNMUHlo?=
 =?utf-8?B?K3kwejZSNE1yZ1c4RTVGZncxZ0dDYU1iLzlkUEJ1aVQzZ2tWVmNoZEJsanVk?=
 =?utf-8?B?dVJuc2d6MTlyUGpWS084VXFrdi9qNjdCRXQ1aVU2RG5yMGtFSXF2NU1MMjQ1?=
 =?utf-8?B?MGhLZkdJeDNPSjY0THI3aE44T0twUFlLSHhzUDJPMUFhWkJIaG5lT2pxT0I4?=
 =?utf-8?B?RlpocWo2amJEQUZlR2JUOU9wa2t4TXZvcjdZTkpzNE1nMUpyeCt0cGJnVjNR?=
 =?utf-8?B?c3l5VWg1aU1sS1U5V2EycERDZ1NEeldNN2FPM2tlaWJDd0dzbTgyM2RmNHg3?=
 =?utf-8?B?ay9PSjY4eWN6ejNWeGN4V3ZkWlVuRjR4QUJYcDVzYkNWcGdZdWdCU29KQll5?=
 =?utf-8?B?REVvYTVpTnQzY3F4dWFEaStqSHkzbVA4WFMrR21Ud2hjTUFONlhhOHZycVB4?=
 =?utf-8?B?TGo5SmlUUFNMRTNjUnAzWmRUNzJOTU1FTWhhU05iVlhiYnIzeDBCWlMzbWNp?=
 =?utf-8?B?YU9ITHVwa0VDcFBUc0ZYR2trMTBoVzNOMnRsQ1lvbkdabjQwT0tGckpIZXFB?=
 =?utf-8?B?QnMyT1JxMk9adXlWenNteGNRSUxBdFFUeW82VEJPRXpicFNuajV4MHBtZ1R3?=
 =?utf-8?B?dGQraGJSSC9EVjlhREJ6YWF1d2dwbW1QMXhYQ0hsOWdKeE4zUng0U1NteS9C?=
 =?utf-8?B?Q3BzSDJzNGlJWStjTlFxdEJPZGtPazZVNjFsWjdvK0RTNE1ITXkvQkJuTU9X?=
 =?utf-8?B?cWhidmtYd0E5WFF5MG9WdHk5eVc4Vk9DTkJ4NjRUVnVwWnM0WUFjckI3ZDhR?=
 =?utf-8?B?VXFMaVhDZkFpMGdHWUI0ekZTeGE0T0tuMjIrVTg4VGlnbFBHM2c5OTV2YkM0?=
 =?utf-8?B?WnAyd1R6L2tTdXJBU2diT2E1T3B2ekNBMlRIRjdNSjJ5VjlKczUyQWwrN1Yz?=
 =?utf-8?B?SzVmOG9ISlRDQm8vQU5jVTM2RmpaZktEMlF0SGJOQ3NSQnA0UHh4OW0rNVdE?=
 =?utf-8?B?SEtuVFU2T0loMUVQaUlkeWJaVzhJUkE1OXlrSzNGNVVObm9TUjhjRG1yd3JX?=
 =?utf-8?B?cmxuYWNJR3NIblFxRERGMTlqZ2V4WWN2Y3JJYmFJNHpxQmZtd2s2cVQwanV5?=
 =?utf-8?B?OTZySjFqbHNiaXBsSGhmY0cvV1NNN1RabUlrbHkrWVpXUUtyNXRJK3JYRTB0?=
 =?utf-8?B?TGhKb0ZVSlYrRzhsZERKYVA2cm1WMGRGelJKb0pvTGRrU05ZQmhUL2N1M0du?=
 =?utf-8?B?aXpzclVwV2RwZ21zaEcvSCs2eStsQzBxNG9EOHFiaDViY1lBemJ3Vm1zVGFF?=
 =?utf-8?B?L25rc3I0ZmkyRmFDSVdBWFZCT3RFWlJFcy96SzZ3QW93Sm8wUUIyY2FMaVpq?=
 =?utf-8?B?bTRERkRWMklxYU9JbTlDZDZFQzJrS1F2dS9lNzBxTlo3U3AwQnVxNm9jMm5t?=
 =?utf-8?B?UVNWOXB4UmdJbitxR0pjVEtZRTNKclBvU2lCczFTQ05FZTQ0cU5FWG1iN0hL?=
 =?utf-8?B?OEVlNUhPMHZGd1VYY05WNHB3Mno4T3QyOVRYZWRjVGVKRlV5VEhMK09TOExK?=
 =?utf-8?B?Uzg5aGhITkQzVDVCVGlLcGtJUHd6ZzNlWVZuYm02TXNaeUJzRWlJaEdSc2M3?=
 =?utf-8?B?eVJDakNKc3h2MG9DRWxvTktPbWlGZHN1NE9wSzF0VWRSbXZVaGgyTjBHYWJS?=
 =?utf-8?B?UDBNWHpsY210T3JJc1d2RENFclUxaEkzWllMTjlqbmVGN1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHEwbDgwcDN4U1ZOUllsL1lGZFdMYWF4RzZibmhyV3lDTXF0YjhaditYME13?=
 =?utf-8?B?Wk04TGZaeFpMcytmZ21uWEJXR3o3RXhWOGtQZlZQM0RxTWQwTHVtYXlRZ2k1?=
 =?utf-8?B?ZG9uRTU1K0U3VlUrV1ljeWlIYVBXYXZ2ekxRK0I1TFRWek9uTXdpYWNNNW5i?=
 =?utf-8?B?T05vSWZwWDBHb01DVHoxa3diR0I3M2M3RWVxKzgrWlk5VmJGYkxIckg5QlQx?=
 =?utf-8?B?aGM1YWJTUmp0L2psV2NZZ2UvNlhrRjF4cDBvd2dmREp1dGx3bGdOZzBsVGt1?=
 =?utf-8?B?Ry9BSU9uN29KT0w5NnRraStFdXpPa2VGTEtaRDlENHlKK3RqQVE3TXZQVUdj?=
 =?utf-8?B?KzJGTDU3a0liRjhodXM2VExaUXlSN1d6Q0dVWmxXUmlQN2FzTmNmMjUxYXBP?=
 =?utf-8?B?c3NvNXErK0Jrc3FwK1FCWUlZL01oY3FBTUpFYlBMRTVvOG12ZmxLZjhScDYw?=
 =?utf-8?B?Qm9KaEJVY0VmUmJ6cHpYUlpVeEMvYlk0aUNxam5zU1dOSGFVeXR5L1J2bEFw?=
 =?utf-8?B?T1FjUk9ST2hBS3lCTEJaWlpqVmJuc3U0QUV2clRUYXRkVHFpMjNwclJFN3Bj?=
 =?utf-8?B?aEJlTDhZTFMwSjg2SjluTW9jTXVYUHAvdnhDUUw5Vkh4T0VpeHVWTVZETkVt?=
 =?utf-8?B?dVJkSTQrZXUrckRGVk82dnN2dU0xdmNvcGJKOWhhZ3hMNzFuZmtPc2JaWFcy?=
 =?utf-8?B?d1ZRVDB0QlV0NHVkNUd2b2Fkc2VncXMyQlZDL0VFMk9RZXZqVVQrM2w5azNP?=
 =?utf-8?B?OFpTZSt1U25kZUxnZ1c5dDduSDB6dGZmN3Z5T1d4OFJsWHFlcnU2SmdwR1pk?=
 =?utf-8?B?WmhhOHZkTmowUjBrUnlDcXgwZDV3Tmk0TnRabUxjQ0I2OWxNR3QzK1J0Wk13?=
 =?utf-8?B?U3puQWdtZ05uS0RDM3lJYituZzVuZ20zbUZpZmRremN6MzM5NXhVSjI5LzQr?=
 =?utf-8?B?VndqaSttSEVyQys4VE9MRWhYZCtEV0x6aFVMYnhOQmdYcGRtVktaUHJQZ0tI?=
 =?utf-8?B?MS9JWnNmRVFZbXlQd0I2cXRLNDVxNXVoMVZZUjlOc21uVDdRQmJEYzBZSVZs?=
 =?utf-8?B?OERFWXB5WDU3TXVZSGRFcmR6RFA4dG83ajRKcUJIRjJJcHNweUpMTG1Ka0N1?=
 =?utf-8?B?aVFUS0x4WTdYMVZLTWZUSlJpVnZTQjI0TU1INDhROWNGa2V2K2kxdENCak85?=
 =?utf-8?B?UTNVeFBjUGt4eWFhV24rdVZMNE9WSzVHRUw4UkVBcGIrQ0x1WSsvcTBPc3Yz?=
 =?utf-8?B?VjJ1OThRa2ZaVXBUZ1NXNlUyY0pCVzlhSDgvZHhMZUpnRk5Ibldnd3dSQThk?=
 =?utf-8?B?SThjKzNUOGJrVHU5SDRWZlJGU1pTVXZlOGcrVHFmZTU0OHo3ZVlidjdod05k?=
 =?utf-8?B?eE13bTJrRWV0Z0xDUFZucVc2Y3BTRlgwa0JtOXdFZkF5R3piaDhJN0ZIQ0Na?=
 =?utf-8?B?SE1wbHhTTXlBRVRPN0gwWU1jN1BzS3o5SkIvdnEyU09QR1RBNTRKL0FGcTJq?=
 =?utf-8?B?ZHp5ekc0bHBrZW05Nk1ubEhlZ1FxbGZENUVCWmY3dmtvbE1jUzRmS3FOQTQ5?=
 =?utf-8?B?MytGbEZiUlpZbk1aQVN5ajFaREVYQjc3NEUvMmFUTThXNkU3enNkeHFGeG1P?=
 =?utf-8?B?T1p1USsyaUNxZWg5alIxMjlOWUZ2ZTVHbW5lU2FqMStkejVWaFVrZFcvSkFp?=
 =?utf-8?B?cHlNY3dzeDZObVo1R24rbnlWR1Z3bTZWMkVrMFFzMGxXM0hKak1WZEdCRUpY?=
 =?utf-8?B?VlFDdStVWWVodzE1ZjFtK1BKK3ZPeUtCMFhiMkZ3RHZBMFJIRGZWNmVTRTN2?=
 =?utf-8?B?KytJWVYwQThoUGkrQ2ZHS2V3TDkwY0xqTkxRNlRXenhMVkZiSWEwMFdVdzV6?=
 =?utf-8?B?Vm4xN09RQmZNdm1qWmNycXdxT2dGdVdkNllXeHhrTkJTdnczWmtrSzhOUGJj?=
 =?utf-8?B?VUpESWdwUUszTFN3NGNraENSNjFLM0UxeEkvL3daUFVmVDBMNllOSVZTMFha?=
 =?utf-8?B?OVpNb0FYNWpOTWFSZHVGR2EwWnpNWlNnRUQvVXNKSUFCb3dEUUVKdGVtUzRO?=
 =?utf-8?B?NTZzV1lHZit4SVlSUng0ZG0yVGl4SG9wM2JZNHE5anFUamhFazFRUDRrN29Q?=
 =?utf-8?Q?d481IdAxW+1i3Oyfhsf+8q67E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2b6ff9-1ac7-40e9-efe3-08ddf206b6f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:14:41.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fWiPOnOsIjlgJ3XLZuojRD8XYztAAZNXMlW8LNmqAy1rlEBo3OHSbQRudVHBXhDV6nmpyNrJeS/D66UivCufA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8711

On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> Add support for enabling Secure TSC VMSA SEV feature in SEV-SNP guests
> through a new "secure-tsc" boolean property on SEV-SNP guest objects.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on
> 

Since the next patch talks about setting a TSC value, it would be a good
idea to document the default TSC value that is used when you specify just
this parameter.

Thanks,
Tom

> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  target/i386/sev.h |  1 +
>  target/i386/sev.c | 13 +++++++++++++
>  qapi/qom.json     |  5 ++++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 8e09b2ce1976..87e73034ad15 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -46,6 +46,7 @@ bool sev_snp_enabled(void);
>  
>  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
>  #define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC     BIT(9)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 3063ad2d077a..8f88df19a408 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -3117,6 +3117,16 @@ sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
>      memcpy(finish->host_data, blob, len);
>  }
>  
> +static bool sev_snp_guest_get_secure_tsc(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC);
> +}
> +
> +static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
> +}
> +
>  static void
>  sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -3152,6 +3162,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>      object_class_property_add_str(oc, "host-data",
>                                    sev_snp_guest_get_host_data,
>                                    sev_snp_guest_set_host_data);
> +    object_class_property_add_bool(oc, "secure-tsc",
> +                                  sev_snp_guest_get_secure_tsc,
> +                                  sev_snp_guest_set_secure_tsc);
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 71cd8ad588b5..b05a475ef499 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1100,6 +1100,8 @@
>  #     firmware.  Set this to true to disable the use of VCEK.
>  #     (default: false) (since: 9.1)
>  #
> +# @secure-tsc: enable Secure TSC (default: false) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1111,7 +1113,8 @@
>              '*id-auth': 'str',
>              '*author-key-enabled': 'bool',
>              '*host-data': 'str',
> -            '*vcek-disabled': 'bool' } }
> +            '*vcek-disabled': 'bool',
> +            '*secure-tsc': 'bool' } }
>  
>  ##
>  # @TdxGuestProperties:


