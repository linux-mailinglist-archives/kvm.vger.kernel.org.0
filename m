Return-Path: <kvm+bounces-42036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B69A71A9C
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 16:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E25FE3B8D2D
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 15:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0621F4160;
	Wed, 26 Mar 2025 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y48x+l4Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8C019CC3E;
	Wed, 26 Mar 2025 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743003254; cv=fail; b=ItL55qCr0uqvOatWAF7l2aywSH/XnMQ/DxT3OIvIappCXJiVRbwP8HnRBlUiz2XQFL5jMC4PDfkxj/yQ7WYPtw3CE/S1a4jIoSGA0fA3UKtQDJZrJSpEICbD3iLUPvDDW4bdNe5UTl73rY9SpKW+WEiuwMD/F+wVgbfp2cqZLxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743003254; c=relaxed/simple;
	bh=sJMaH2/zOYGi7zIXAMIsD4f/b/gvO4kuvtxixXhczvw=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HleuYlpGnQ0HMalZBuck1dZjYcs8UK+HznIzPaDs5tdT9ZrD02Jx6A4TZE5Il7Z9eJOqoSGufMONUzeAY3EBLUaXTu0/vKnu1GRNifN1aY0TpWphfPKtgfeMSextjvImR3HgsZRSlhbRispaaBQrDtrQS0oI5JWe26y/rW5pDeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y48x+l4Z; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U9EGweG16Tb75kVrC0md7J/ps+Wb79+aIlzGsqpFqpcdd7J6Ls6XSRCUgXZhlKWoKEZjl0Pe7ODoxREe7hMV5o+qqpFaxjL16UyEdKGaIFvDdw/FLYDn5BT/Ktog4SlJ2kB111jbzLAksWIVGWqI7dCmhhZHpL7ARHTdOrFi++fw93LTtAf+SxJ3AJVR1TsuGhXGZVThWZSP2ISaIRd86AqTnfmskWzFRca0eVYkSF1l0Nvybvh6NTsubLFuqglJ/agfxclQ7pIwzlsSYivOVojfFH5Rk9nWM9AcO/LbOX0W2YPmiRLupPpeuHYYXJyp8QSsQNJklwOa5LbCrF854Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCyQGX+b3hjRRr+9PekR7uqrqUR5QSp99q/mgY8Z7B8=;
 b=I2ATd5o7Bc8MyiXxTr25T2DUNTxzXA+pWmSvODBK1Pa/7b38vysNVP4N7R4XjlhXq5RYvoByNJnnYWLViCwYlQNNZ54CAvnO3pknb9J22enC8TGeoSW/hCjWdjQbQd2Z6yFp7COXuuPvDlDBT6vB8AES7zusGLN3EnwZ+chHEbQfptcnkDX+j+c/0FYDerUn/hAEm5+MPk155yefYdrqGWD1eUPnVdwHs5LwjcBIDSn42FD7LroMFLRY06l62xMh/lD8O4U2F8qjWoGCH+vhe6lSu0JavpJ8LUbMNVAanI3U7c18be3aN/S4eDo+eRwTbH/mI3AniqZuvLUxC5vFqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCyQGX+b3hjRRr+9PekR7uqrqUR5QSp99q/mgY8Z7B8=;
 b=y48x+l4Zx1N6elefycuZIykmi6BSNCnWsoIVkT2Y9nZzF3R0IAptBRUcAqVQYLlj3VVVubMse1lDr4LAZgz6uxSTENffHrxlfKGUbP2GAZN9pXOhuRUwIO8pHhNLaMII+rf4XWqLPpQgP9A11QV3AIBsIZIhlXD6urkvi0mnp2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY3PR12MB9677.namprd12.prod.outlook.com (2603:10b6:930:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 15:34:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 15:34:07 +0000
Message-ID: <41bfb025-008c-db03-2f6d-33b2d542ae65@amd.com>
Date: Wed, 26 Mar 2025 10:34:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
 <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
 <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com>
 <aeabbd86-0978-dbd1-a865-328c413aa346@amd.com> <Z93zl54pdFJ2wtns@google.com>
 <9a36b230-bf41-8802-e7ba-397b7feb5073@amd.com>
In-Reply-To: <9a36b230-bf41-8802-e7ba-397b7feb5073@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:805:f2::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY3PR12MB9677:EE_
X-MS-Office365-Filtering-Correlation-Id: 160e5331-ec82-40df-8289-08dd6c7ba5c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkJmd3QxWVJVVHlqdHdrK3Q2b1l4UEIyOFA5clRQZ1lTbitvcFROdTRDZnRn?=
 =?utf-8?B?ZGc4cEhKcDdpd0NYNlR4c0RPbjNFb3JDK1pLd3FJTHZXSFJja1R0RFljQkhG?=
 =?utf-8?B?RHpJOVVZNU80MlE2R2lSNXdMYjF4TkFKbXBwcTY3bVBFYlM1ZngvZVZzT2ZF?=
 =?utf-8?B?MFVOcHdOMjRxZDYzaTlIZEoxNUVacGhvYitWSlF2bG5UUEhoRmF4SFhhVUV1?=
 =?utf-8?B?NTdBV1ZoVW95ME13VStGa3ZFQUh6NjFkRTdSYzltY2FFMGxVbXNDYTJlOVZS?=
 =?utf-8?B?MWpYWEtJb0VVeTU2bG9YbXdmV2t5bVBLcFVSdHovcDA3VVYwalJ2K2c0MWxV?=
 =?utf-8?B?Qi9TVElFV0lGNnE4V1l6Q1E0dlprNlU4QjBSQW9hSTBhUXJXREdWNHp4aHBN?=
 =?utf-8?B?c0hSY2xQUnBXeFV5cnZnWTFwS09JWWRmSUpheWJ6QkNqQzk0dFJkQ3hrQmVL?=
 =?utf-8?B?blZHNkFkb05qYWZwTDIxR3MwY0xTcXgySGp6eFJqRUYzWk96SGpkdENIT3pF?=
 =?utf-8?B?aUtKWXJiU1JYWHhnVmZ3RVdWcmVCK3pGSFJiZGIwRlRqR3oyVFI0K005Q2tU?=
 =?utf-8?B?N01UOTVNdUVOTXY2UWlYQXNnU01Sd2VSOUZ4cWFhOWNld1ZlYjlNQXV0TFYw?=
 =?utf-8?B?TmUrT09zdlh6K0pCU2dhQ0lOWmdSdk9tUVNzeFZwVlJjT1ozYUJ1eCs3c0g0?=
 =?utf-8?B?ZEdHVGxYVXBFRFFYQW45YWUySnZabm03Uyt4N2NlNm5WR0FTTzhOcUh1WTNq?=
 =?utf-8?B?aStyTEdid3ByYVl4blJRa2NvWGNrU2x5Vm5lWFBXd2EwYm9DczJmanpnWUgr?=
 =?utf-8?B?NzVPWm9nYVI2SmZOcVNmTkRlZ2N3RFl1Mlc5WXNRWE9xMU5FZFQ4TXdaSWJ4?=
 =?utf-8?B?NlNvd0JSOXhLeFJ0Mm1vLzczc2oyV0dvNWZrTzFZNzdKZjdWcm9wLzVHcDh4?=
 =?utf-8?B?bUlSeC9BWDA3WkJLc0lBNmUvSU1qWkhuYy9sTEpRTElvanY4KzFOU25nWVRP?=
 =?utf-8?B?NmNsRVdlZ1RBV1puOC9rWnA4azNWaFYwdUxZMG4xZm80a2JTNDhHVGdBRml0?=
 =?utf-8?B?aVNZTHF0ZDdydFdGYXkzSTRxMm54UDNOVkxXaFRVSStGdXFQTHRkUUFvR2JR?=
 =?utf-8?B?bi9kQnJQM2F0UG9oemhFN25COFh1NEZOc1hvU29rQVpMaC93WlNhZXIrUjFx?=
 =?utf-8?B?OGF5WVNQc09zU1dwWktyWWI2dGZIazI4cXdZL0wyelkvMWRBVEExRTdkbGNG?=
 =?utf-8?B?WGNrU2ltRVRvYlE4QkJTYVRjTEJoRFc4bU83ajUwbUJtTlJTb25VNW9mK3RC?=
 =?utf-8?B?K2cyc2dZUlBkUExGckYvWU01bkpadkE4c2dFYXNKK0xvb0Y1d1dLazZVZUJZ?=
 =?utf-8?B?WVdVWkNTQys4N2tKcWozOW1kMG9QUDA4YlFsSFByUUFPTUZnY2h4TFFFR3JZ?=
 =?utf-8?B?eVB2dTB2akQ0YkJQc3J5TEY1Y3BwQ0txd0tUem50cTZXb3NjZExYZ0YxWDQv?=
 =?utf-8?B?V09QTFhrcGdDZzRKVCszYTN2TW9VbTkyb2ZyemhzL0dzaGJDQVRUOExld0hz?=
 =?utf-8?B?UFhnektRanlITlB5SjN0anBHTWpLTm15S3FLUnczdm1INVovQjJZZmg3N2NC?=
 =?utf-8?B?NC9JODJhQ1hHQ2NtaHFiRUx1ZWxiSGxpdnJRY1gybVN0eGtBdGM5SlRuamNi?=
 =?utf-8?B?a0NQZ0pFVmdsNVh5WDIvaXhHMzVGNFBHaS9CdzJuUUE1UDNlTUVIZzNWUngv?=
 =?utf-8?B?d0pWd1orNGFVYm9SUkJzbE90eSsyQWt0OTVYOVlmanFjVFYxbFh5SW5yaTRV?=
 =?utf-8?B?eU53QUJROEErR2s5bitUaExYVnlheHJMVG9IMkd3TlpCZFBpOUpzTUw1OVZT?=
 =?utf-8?B?MWVZWXdDYmdGZnBLNEI0Q0wzN2pmTkJxSFpaWGw3Ni9VaGVQLzZ0cUVodGpZ?=
 =?utf-8?Q?SZqcLc9O/lg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkRQbXJoWExkT1IwWGlSK01oNk5xYTFrc052M0pNRWNWc1o3eEU1c0N1aFFK?=
 =?utf-8?B?Z0xIbjE0Qm1CVjRKdHBMMC9EZTBtalQ0UnQyZEdVcmRWMW1yZ2UvUTFUbXFB?=
 =?utf-8?B?QU1xRUZmN29vb1lUZDRnSG9zY1RFcDFDVXZDRm8zUVdKTG9XSU1Ncy9nMmRu?=
 =?utf-8?B?cFRVYnh1cXFzeXd4NTBxWk1QVXpVSFB6NkJEVmFtUHhXQkRXWG9IRGxHRVpi?=
 =?utf-8?B?ZzJSL1haeEFMNmlkZGl5T1Fwb3FtNzNhWTFEeWJ5TTZDL082eU9ES0RoQzg2?=
 =?utf-8?B?RFl2TklFSVNCcG50UkVJc2wxQUtvM2JUSjJ1eERzbFY0UGRkTzFtZmhYSUYw?=
 =?utf-8?B?UWVmeFdZVk9DU091ZDAxMzJtd0loTjdVNXRTTlh5MTZROXVKYkd5eFUxMFNI?=
 =?utf-8?B?cXAwQlQ2OXNPSWs5T1lPNXAwSXptYStvbzNodkM2QlJyUnNWOVlzekhrbUVO?=
 =?utf-8?B?NDYwNW1mdXRtK0FQUWFRcWJ4S2dLWUdnZ1Vsd1lEdCtLY0tleHl5Qy83RTNG?=
 =?utf-8?B?bm9YWjZWbGozTzI4dzBkcTJYbThtSVQ1N2hLazlJMEwwbUxLRXRJMXBYa09y?=
 =?utf-8?B?ZlY1SEZQNzNwckIzQmVPbXhReVRhNUNFdnJhVGpxekZEczlxbm5NR1E4ZDVV?=
 =?utf-8?B?M29NS2dPRFJ5K0gwTVVMS0xuTHVaUEg3Q0RmTEM3c3V2SnRYU01ORjh1cm0x?=
 =?utf-8?B?aWFkVzdJN2tDdkJjUlhBVTZmdkFoNEVISTRXRlVmYktRQWtIVzZCNzQvM0RS?=
 =?utf-8?B?U1Z5aXQ4ZVJaZTNLZG5EdW1FaWN1OHJzM0lsQ0dNVm9lVDZ3bHRVSEVQbzBO?=
 =?utf-8?B?MXc3VXhwTHpOVEtDQjFWekkvQ0tvMkdHUzh0T1dKTTRENkROb2FsUC82RU9y?=
 =?utf-8?B?YzNQRnJ0VS9LSEtURW1ObmdQZlY0eDE2YzJNdmNJQjBZNXcyREpGdVFkc1Vj?=
 =?utf-8?B?YVFMWHVuaS9xbGt0Y2xIdFcrWVI2STJKT0pxNE9jMkZlMHgzcnN6dndXYlR0?=
 =?utf-8?B?cVJBdXhSUmUrU1dYOXd3ZWFaTW1COWhDb3VoYkdxNlNMTnIxL2FpWU1SeUJQ?=
 =?utf-8?B?Zy8vZ0xQS3p4M2x1dmJKRkZXZlNVanlLNHF4eUFHRnlQRCtpYmpqeVVkbXhS?=
 =?utf-8?B?YkNkUkVBc1pHK1BoSno3Z1NMT00wR2h0K2NXTTZaWEVVVGhjNkNlNThrWHp4?=
 =?utf-8?B?c2hlYm5MVklzSEhENnZlODVnNDdRaG5UcGNxZVozUGx5MlNkbVpHemdQdGpX?=
 =?utf-8?B?NTBJbEFIa293QzR5YTVMYVk3Q0V6N3V0Sk5TblpEVXZOUHZRdWxNd01aWUc2?=
 =?utf-8?B?c3lKSUhJTTBvbTJ0dEt2d1ptN3RPUDFQcXJ1WHhlOHFhd29LRWIxcDJtVDRD?=
 =?utf-8?B?VnVqN1EyVCtJNnV4cm9rRW5ZUkpVQSthSkFLZk5lSTdNdUtHdHFSamQzUE9R?=
 =?utf-8?B?QXo5S2ZVWFQwYUtjRVFpWndBdzJpUkNlTW1aQUc3aHNtN1B3alpKdHdXWHg5?=
 =?utf-8?B?TjlIM1drb3JxVTNmSFJsVnFkUGtqUk13dVdXN0wxdVdIRG9sbno0cDg2ZVc3?=
 =?utf-8?B?cktvRitUa2R3SnJaZExpb3hJdU9TUjJIdEdIb2ZOc2wxUUtrVEhiL0lyWm16?=
 =?utf-8?B?dGdWRDRZb0JMaitCSVNkbWtXWlhkNVpFYzFXLy9DWk41SEhkVWJOWi9SM2xE?=
 =?utf-8?B?MWdGM1I0WjBTQmIyRHJ4UVk2amtEL0RLeXRaeXNnenY5eElmSExxUkFlUWY4?=
 =?utf-8?B?T2lXTGYvRHJBTWErQktGTnVpMkU3Y0NYdkZUN0VJYXFJOHcvSU5YeVlucldM?=
 =?utf-8?B?cHRNREZCMDJGeFRkQ1pGa2JuSXFxTzlrN3ltWG9NZlkwdHVmb3ZoNEtYbHJp?=
 =?utf-8?B?WWc5Tk9vUW5uSVpkLzJuSGpnOTVIcXZNaVJ0ckZ1TTdyemdjdThhMTcxb2Fx?=
 =?utf-8?B?YzUrMmZJYjJEazJqM3NMbjVNajFyTk5SQVFXRVR3cnBzYmYzNUZIRE1xQk5I?=
 =?utf-8?B?TDJuZnIrQi9FbU5IczdKUzUvSGZCRnFOWmlWVFFndFdRaEVxeHRheGRvbnpV?=
 =?utf-8?B?dTVuUmV3dW93Um9DTHk1VnNNd3RqRlQyQ3Z2VWxGZGd5TEJYRER5Uy92bS9n?=
 =?utf-8?Q?hE1Zh8KnYpde8sYwBpsrk2r2A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160e5331-ec82-40df-8289-08dd6c7ba5c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 15:34:07.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9YnN7Pv27v+YV6MunIIL/CrsgQbDcDoYLNwbBornLjuxzHWqDjyQLTGdD4GYL9IEEL3Mabauwh7wl51J1JaZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9677

On 3/25/25 12:49, Tom Lendacky wrote:
> On 3/21/25 18:17, Sean Christopherson wrote:
>> On Fri, Mar 21, 2025, Tom Lendacky wrote:
>>> On 3/18/25 08:47, Tom Lendacky wrote:
>>>> On 3/18/25 07:43, Tom Lendacky wrote:
>>>>>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>>>>>>> to be annotated with KVM_REQUEST_WAIT.
>>>>>>
>>>>>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
>>>>>> This is much simpler. Let me test it out and resend if everything goes ok.
>>>>>
>>>>> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
>>>>> me try to track down what is happening with this approach...
>>>>
>>>> Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
>>>> plain kvm_make_request() followed by a kvm_vcpu_kick().
>>
>> Ugh, I was going to say "you don't need to do that", but I forgot that
>> kvm_vcpu_kick() subtly doesn't honor KVM_REQUEST_WAIT.
>>
>> Ooof, I'm 99% certain that's causing bugs elsewhere.  E.g. arm64's KVM_REQ_SLEEP
>> uses the same "broken" pattern (LOL, which means that of course RISC-V does too).
>> In quotes, because kvm_vcpu_kick() is the one that sucks.
>>
>> I would rather fix that a bit more directly and obviously.  IMO, converting to
>> smp_call_function_single() isntead of bastardizing smp_send_reschedule() is worth
>> doing regardless of the WAIT mess.  This will allow cleaning up a bunch of
>> make_request+kick pairs, it'll just take a bit of care to make sure we don't
>> create a WAIT where one isn't wanted (though those probably should have a big fat
>> comment anyways).
>>
>> Compiled tested only.
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 5de20409bcd9..fd9d9a3ee075 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1505,7 +1505,16 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
>> -void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
>> +
>> +#ifndef CONFIG_S390
>> +void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait);
>> +
>> +static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>> +{
>> +       __kvm_vcpu_kick(vcpu, false);
>> +}
>> +#endif
>> +
>>  int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>>  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
>>  
>> @@ -2253,6 +2262,14 @@ static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
>>         __kvm_make_request(req, vcpu);
>>  }
>>  
>> +#ifndef CONFIG_S390
>> +static inline void kvm_make_request_and_kick(int req, struct kvm_vcpu *vcpu)
>> +{
>> +       kvm_make_request(req, vcpu);
>> +       __kvm_vcpu_kick(vcpu, req & KVM_REQUEST_WAIT);
>> +}
>> +#endif
>> +
>>  static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
>>  {
>>         return READ_ONCE(vcpu->requests);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 201c14ff476f..2a5120e2e6b4 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3734,7 +3734,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>>  /*
>>   * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
>>   */
>> -void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>> +void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
>>  {
>>         int me, cpu;
>>  
>> @@ -3764,12 +3764,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>>         if (kvm_arch_vcpu_should_kick(vcpu)) {
>>                 cpu = READ_ONCE(vcpu->cpu);
>>                 if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
>> -                       smp_send_reschedule(cpu);
>> +                       smp_call_function_single(cpu, ack_kick, NULL, wait);
> 
> In general, this approach works. However, this change triggered
> 
>  WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> 	      && !oops_in_progress);
> 
> in kernel/smp.c.

Is keeping the old behavior desirable when IRQs are disabled? Something
like:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a6fedcadd036..81cbc55eac3a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3754,8 +3754,14 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
-		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-			smp_call_function_single(cpu, ack_kick, NULL, wait);
+		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
+			WARN_ON_ONCE(wait && irqs_disabled());
+
+			if (irqs_disabled())
+				smp_send_reschedule(cpu);
+			else
+				smp_call_function_single(cpu, ack_kick, NULL, wait);
+		}
 	}
 out:
 	put_cpu();

> 
> Call path was:
> WARNING: CPU: 13 PID: 3467 at kernel/smp.c:652 smp_call_function_single+0x100/0x120
> ...
> 
> Call Trace:
>  <TASK>
>  ? show_regs+0x69/0x80
>  ? __warn+0x8d/0x130
>  ? smp_call_function_single+0x100/0x120
>  ? report_bug+0x182/0x190
>  ? handle_bug+0x63/0xa0
>  ? exc_invalid_op+0x19/0x70
>  ? asm_exc_invalid_op+0x1b/0x20
>  ? __pfx_ack_kick+0x10/0x10 [kvm] 
>  ? __pfx_ack_kick+0x10/0x10 [kvm] 
>  ? smp_call_function_single+0x100/0x120
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? migrate_folio_done+0x7f/0x90
>  __kvm_vcpu_kick+0xa1/0xb0 [kvm] 
>  svm_complete_interrupt_delivery+0x93/0xa0 [kvm_amd]
>  svm_deliver_interrupt+0x3e/0x50 [kvm_amd]
>  __apic_accept_irq+0x17f/0x2a0 [kvm] 
>  kvm_irq_delivery_to_apic_fast+0x149/0x1b0 [kvm] 
>  kvm_arch_set_irq_inatomic+0x9b/0xd0 [kvm] 
>  irqfd_wakeup+0xf4/0x230 [kvm] 
>  ? __pfx_kvm_set_msi+0x10/0x10 [kvm] 
>  __wake_up_common+0x7b/0xa0
>  __wake_up_locked_key+0x18/0x20
>  eventfd_write+0xbe/0x1d0
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? security_file_permission+0x134/0x150
>  vfs_write+0xfb/0x3f0
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? __handle_mm_fault+0x930/0x1040
>  ksys_write+0x6a/0xe0
>  __x64_sys_write+0x19/0x20
>  x64_sys_call+0x16af/0x2140
>  do_syscall_64+0x6b/0x110
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? count_memcg_events.constprop.0+0x1e/0x40
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? handle_mm_fault+0x18c/0x270
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? irqentry_exit_to_user_mode+0x2f/0x170
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? irqentry_exit+0x1d/0x30
>  ? srso_alias_return_thunk+0x5/0xfbef5
>  ? exc_page_fault+0x89/0x160
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Thanks,
> Tom
> 
>>         }
>>  out:
>>         put_cpu();
>>  }
>> -EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
>> +EXPORT_SYMBOL_GPL(__kvm_vcpu_kick);
>>  #endif /* !CONFIG_S390 */
>>  
>>  int kvm_vcpu_yield_to(struct kvm_vcpu *target)
>>

