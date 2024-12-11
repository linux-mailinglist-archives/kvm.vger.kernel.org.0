Return-Path: <kvm+bounces-33495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A356E9ED484
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:15:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97EE1282DDE
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620F2201267;
	Wed, 11 Dec 2024 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WcuIsx01"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC2F201258;
	Wed, 11 Dec 2024 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940904; cv=fail; b=h9v0nEqp4Ci/I2vZaEuMCbprAd+aQXf0/hJ1MzYzI+zzvGG8bBGReYp3RIUoSd2gTyKpo0ndktahdtaTzQa5X/W7WFtR/v3Cu9glMAJmL24XRIM4etswRvNlzWN9VXbp42DUqvzmpRrF3USfQeWeS8V963jSFgWOKfQUD/Rd1hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940904; c=relaxed/simple;
	bh=G7X+4C+Qaokioz+vMx8aKEpmjiyijQW0lrJ4Vh8QSiM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=URLk2QeWQOa+hDE4qVVH0wyhYFmm9cNDFN8ADVm7HLm9uzPgKLxHc1A2m7sgxkKETLkyTnN9Lti8sH5/fskMi9WQjsQH9NLFaszZom3xP6EGQ/yf3rmm4ajEb4GRZi7ZKq5iscSZWxlFL3EeyhJgP0qumdMQvEjSRRbNv+AHX5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WcuIsx01; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sqp7OENKHfKWi6r2LoDB1YZ6o6ClR5NVWfTlUG5spCuKUxl38FuvOjxeqwT+nhQfq+WpLzaJ3X3bdiZ1SAJK4kVh2deF8pil9c/rkQzNtVkoZIctYcjLd/Aa66LW7akCP8RUkvWUrI7EUe5chEc2BRYsySx3WkH6QBYTMMFaTt0jGH6d9deBvAv7EQQkQqI4kRoOt+a1MqMIht5O0varTdTKnVT1StvcWqKIV65OOKL5WFm6A1Y08nSnymqkOPpSVxse77OKhLcETCeMdi9ajfL+n39PwQhd1E0R6AHM7mTNTvRgouPUtIFubI4TrtNkwi0ViIEPMJiClcUnX22UZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn7XVUzc23Vgr0QRUciV4uSwc6SeH2Qru7kbFtLKsh8=;
 b=oFkB5ldo1xV8z6hPbB+V3aTZBOOFGSmxiiiA9PmR609n0Ed0SyJdVh8mplYejYomTbCTHdnhR5HTydQYB3B6J2jHdFsT1bDg2MyNqneRSC8NghKanY4VLLxHwPledHJY7DI4AlOi+faHUVSmr88XnpZQ6BZofOJdX2Y6Q4ghgEYaTymMKzsf4psHlEAt9vY8XnvqiRkWVZADJDKB1+ocIZ4kY8iIvs7M6XSyZk7OdQVofmOxngKjuU9UrITqS9QclH0FZMUQYmy5kH1gDXbupVAP+hvhzwg7R9bk+Zd1/ohxTkHVjIB5owcL3tDUIZZvoZg6v7IX9Ztd999xo59LvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn7XVUzc23Vgr0QRUciV4uSwc6SeH2Qru7kbFtLKsh8=;
 b=WcuIsx01wvd/dwBS03Hcf/G3TBXC1ewDnjpME5565ykj9WoFQGlb3UNj+wOJRrR37cj2+kITau8cWKiGvq25FxDTLSgofI6sj1faPnjdt2tuPk1bOs5WtZE01OrQoRm3cl82ersAYJQFaqYjPvAifv4kR9iJbGtOoTdRNMBnOL0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB8559.namprd12.prod.outlook.com (2603:10b6:8:17d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Wed, 11 Dec
 2024 18:14:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 18:14:59 +0000
Message-ID: <d9194ef7-8259-a205-edc0-f45963447b1a@amd.com>
Date: Wed, 11 Dec 2024 12:14:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Simon Pilkington <simonp.git@mailbox.org>
References: <20241211172952.1477605-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241211172952.1477605-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB8559:EE_
X-MS-Office365-Filtering-Correlation-Id: d561e10e-49f1-493e-1745-08dd1a0fb959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmFZSEhaSjc3UnBFNkd4MzlocTcrR3pYOGN3ZldqdXdFdVoyUWtpSGpFZ3JO?=
 =?utf-8?B?V0E4NUxjRkFXQWZSYU0wdkNZaXVmakdVMWZoNFIwaitKYmZza3FlZGticks3?=
 =?utf-8?B?YXc4RG96Um1RdkIyYnVBK1FRZVMwejZSdTRRZ1Nrc2hPWWwrR0lITHc5M0ta?=
 =?utf-8?B?K3JxS2JXTGdHb0tvL2piNDZERDZ3UjFtV25xbFc3SXdJcTFDeFpDbHBlWVdB?=
 =?utf-8?B?a2RnTlJVQWVsSHBtQzRVa0pCSGVKVnd2cnZVU051VFNlYnB3OTI3NS9GQ3Nq?=
 =?utf-8?B?NW1DTThvNy9ycjU2Tml3R2pzU3pSUURHTktDOE5ZMStSTHplbGs1RG85U2s4?=
 =?utf-8?B?bWlBYnlxU3RpU2hORThwTTczNXZZWkVxZndiT0kxaFF4TWZSNzRPYmlhL3hZ?=
 =?utf-8?B?NjNueWl6U1AxVkxvY0NNSDc2TlpTbWZqT3BYeTh3NVFHUG5CSWF0cWl2R1oy?=
 =?utf-8?B?OUhYMm44OWRqYXo0aVRLOGZ2Y0x6WkRVd2tkdDd4Z08zWmU0K0cvbnFVOExE?=
 =?utf-8?B?T0NieGlCeEJaWVBiS0ZWWFJiZ0I2MDhVSlg2YjhMLzA0ZngrQW01RytqeDB4?=
 =?utf-8?B?djZvL3VWNzJ1d0NTRUJvK2hFYk5Xd0d6eHZwaGtqdG5BczRMNmh1UmRtWG1S?=
 =?utf-8?B?d3IzTGFZc3VYSjdxWGJkZjZpR01TZlNmSHpzUDRoSTlDQlVVcm50QjZLdnVE?=
 =?utf-8?B?VE91d3E1MG9ER0ZrSlFwNVFqa2grQTN3SVo2OUpKQkx6eEUvTzR3Y0pUSzMr?=
 =?utf-8?B?K296aXFuZUYxL0trZjQwS3U4NHdIcnRYcTdpSGhSR1JHZVVuNUU1N1NLTHVS?=
 =?utf-8?B?TkhvRXU5WmdnZHRUQWpXM3c0TUI2dnlMd3V0NVppckF3OFZVVXBPbFBHckNh?=
 =?utf-8?B?NjdpaDg5cStzRzh5bFNwdDl6NFQxMVpxMFVqOFhqT2NVK2RFckNGN2h1T08r?=
 =?utf-8?B?cTZPWGhpczROR0EwenlNeVF3V05lVzJxMk54ZFBod2p0YWtsU2J6RTdBUHFU?=
 =?utf-8?B?MW00VUNyQlk4dTRRNGlhNmZlNEMvYitRdkE4RlRjbFZJK1NRZStmdTgvWU5T?=
 =?utf-8?B?QkhyRjNjWW81NzJRdDRlM3FVc0hPMzFUWjNCY0lMVkY5WFNkNU5hZk1BelJH?=
 =?utf-8?B?ZXFNaDJMQ1JXTy9DTlFkVnlvaTZlaERqMHkwcys4QzhzRWFRNld2Uk9BdldB?=
 =?utf-8?B?Z3lndTdTZ3hTSGxCZjkxcDBwVzN4a2JWZVNPVVh4cjZmamtCVk14N2N1WFhq?=
 =?utf-8?B?TUF5NEp1enBtMjdDOHdBZjdNbWE2NXoyK2VRYmxtTjl1OE01bjZ0MStBa2dn?=
 =?utf-8?B?ZStYejM3azlhdnA4cDF5MFBEeU52WlZoZEtxYWVrakVPQXo2Q21oMHlWdUZD?=
 =?utf-8?B?QVcyek9tV1Rrd09TcmJOMWFPS0ZXWTJDaURIbngzQVl3akhBWlhvRDNaeWwy?=
 =?utf-8?B?d2d1bzNrajdoSmE1bEUvamZ1L0ZRdnJyeEFrOGhNSjhEc1RUQ2FUN3IrVjN4?=
 =?utf-8?B?WUJUdHFIamlmekRWdkVHcDFYWDhTaEs5cjkvNEg1cnBlMjMvR1ZtbklxcEIy?=
 =?utf-8?B?dlVTYkdQdXR2aWNVTWtVZ21TVU1taW9ZT25HRWl4dWsvY3cwa1ZGYzVXRytV?=
 =?utf-8?B?Ty9veVdvSkNNUXJpTW41bS9LZ2JxdGFYYXUxc0luYmdaSmg3OGw4ZUFyN0hU?=
 =?utf-8?B?RTB6d0FybENIZ0c1Mm9JUDVIWDVPcEFmbXcwSXU1SVozVVprOE5NQm1FQ1p5?=
 =?utf-8?Q?Pdn6zigXGAd+aS1S/0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mzh5QXZqZ2JoTnhmNitVVmRBdmFPSUpCcHpwTWJZSkJWQmFvek9YRFhyU2Fm?=
 =?utf-8?B?T2J6MjlNSWFqRHRTMHNYVW9OVzBJWXBDREljdzdBeGNqNk11WVZlOUg2NVVR?=
 =?utf-8?B?STIrRUJOeFVDSzZJMXh3ckRGNXQxSlVweFltbXNROFNBUWlCNmVCVVJqb3dT?=
 =?utf-8?B?L244SUVDMEVMRk01bnFadGFqZXFZci92MUhwQlRrbFUzd2VFTXByMC9tdG04?=
 =?utf-8?B?MWswS290VlFONEFWcm05OFROZTBQWEFpUVltTnIzYVVQNzlXR1NjYkc0bmFR?=
 =?utf-8?B?U3lhN3h0RjVnVmF3S1NveEtSRVlnWEtUT09oTVlEdFJQL0o1a0ZQQWJkd1Fs?=
 =?utf-8?B?N2ZJYVhIVlhRTlN1TGRQUUUwZHMyVEJZUnpRMFQ0Y1RCZkt4ZmMxNnhITDFH?=
 =?utf-8?B?RXR2UThOcFJtZkl1bldlQ1lYMVlDUjNnMDFnOEJtRzhCSk9EcElFWDBDdHZj?=
 =?utf-8?B?a1RpWmdJaFJJT3dreHlPNGxUVjA3K3ZBek5UeWVBU3JQQTBML2lRV2tjVHlk?=
 =?utf-8?B?OVF4U1kyZzZHZi9BdE9lM2NNYStuK09Ta3hpZXpybHVhdCtVeGxsVDB5aUYr?=
 =?utf-8?B?ZzlLYmF1T1VpVGdvTXBTNFRuaFBsbmJkZDhramNhZGNxMk0zRnJqME5JdTUv?=
 =?utf-8?B?QzE0QXJOTlF0bE1LYmxjbm4rdXhnd0tYNlRSbjVZcTdsa1NtWUpQdi9CdUFl?=
 =?utf-8?B?eXVsOGsvRFhDUWtSZ05MbjRORkxENkhZeVphRlNXQ1o2bEpQbk1FUkdyTjFO?=
 =?utf-8?B?M0Z5aTRrZDI1M0ZLMXlXMVNieUpMT2tNbVlmblpBMWQ2TkhQTElYaE5RSHha?=
 =?utf-8?B?U2d5N3B3cWtpTExtTFNoRU9Fa2lCZ21vbHM0VjFFb083SjZ4bExSRmZFcWpt?=
 =?utf-8?B?MkEydmlZNkhibFppZ2IrMXdNdEZRZzVYQVpyYjZwR1gxSEVVV2k3YWlLQkhE?=
 =?utf-8?B?VnFDZThwMUdQYzV5MXdoRVpLTVViN3ZhcEMvTzIvdHBWeXhmOXlsQzdZWkRy?=
 =?utf-8?B?K0VNSExaN2E0UUVURHBMdy9TNWh1ZUVDVHhqcXl5bHhEMlhuYk5GSkd0QXdq?=
 =?utf-8?B?V2owdHNYTmR6UzV2a2Y5NzJIVjJpVHVGbEdiMkVkK2VVKy9Lc2VxQmtHeXk4?=
 =?utf-8?B?bEhqYXZaVGM5VUlueTh1NHo2MHBUbWpIaXh4ZHB5Vkw4alFqMTZsbi90TjVM?=
 =?utf-8?B?NVVIR0FXU1h1VEF5Zm9ZSzlqWEx4ajVKZlNGQ05zMVFxWmR5TVZHdWJ6cDJH?=
 =?utf-8?B?VklNUVczbWorYTdadEZGRGJLOUJlU1JEQnRybE9Ob0hCdmlzUGNsVkl6RXp0?=
 =?utf-8?B?bVpocXhzbFVQTVIyMmUvb05BMjJPbW5CWFlrRWV6aS96Z0U0QVhUYzVkRFQz?=
 =?utf-8?B?czgvYzZSYmQ2UWtEUHdZbjdoSGNzc3BqZFBBUEI5bXBiQkoyUGtDRktTL1Vr?=
 =?utf-8?B?ODBuTmk2Nlc0dEFxNUVRQ1l4Zkt2RUNVOGpkWDFhdHRzUEVSV3VGMWplQVZC?=
 =?utf-8?B?Mm1uT09SY1JFSU5hdGRJNUs4TWg4N1U3MVNBVHRTRTJuNEhQdTkzVkVsSEJ6?=
 =?utf-8?B?U1dFK3d3a1JYdnYxdGVaYmNsbmJYZGdnczV0dXVKdjRzTDZYTExWNDVmcGNy?=
 =?utf-8?B?S0J2MlZQbStFR0N6RWVHT0xpdDRBU1pPTTY5cVRmWW5sWnJuN1ZKYUVESldG?=
 =?utf-8?B?VDlxUDAwVWpjWG1GR1FSaU1EbVpFMndYUE9KanFTOWhtZ25kWWpyNDdrUWY0?=
 =?utf-8?B?dWRKNUZPSmo3NjNSNDlXc3ZQOHYwdjZuakNnT0tXYWR2MUllQi9ValNtLzhv?=
 =?utf-8?B?UW1TanlCSFpZOTd0RW42VktzaURkSGtzTGtIbnZZR1pMb2NVOEx4SXNQeXd5?=
 =?utf-8?B?V1Q1V3JWcGRhb2ljWGp5YXFNT2JuNlBpclhNNERIL2ZiL2NBK3NsUkJQOXdC?=
 =?utf-8?B?L2Q4NWwwcHBVaHdnd21uZXE0OTdFa2NUcUhVUk95REx1RCtpaUlPMy9mSmVB?=
 =?utf-8?B?YWNlQzR4cmQwcmIyMUY5NEE1RW1KTHFaTTF5Mm04ZjNUSjN6TWNnVVZ4YS9n?=
 =?utf-8?B?MDczUE8wZjJMVnk5UFpZUWFYVmJJS1Z5b0tveS9ZWUdvMld0dThsbHFlNzRm?=
 =?utf-8?Q?rb6xSyOa87NniV2/D3SqfIQ+i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d561e10e-49f1-493e-1745-08dd1a0fb959
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 18:14:59.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSNQUbyfdfvxW4Rm5+IXfBcT3SOm51aQK+uE1uRZDdLapxwuv9q7seqdiGMHiZ32+GOzHt6rLsrMZmxT+xN6HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8559

On 12/11/24 11:29, Sean Christopherson wrote:
> Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
> for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
> in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
> nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
> it exists_.
> 
> KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
> underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
> to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
> the desired/correct behavior without any additional action (the guest's
> value is never stuffed into hardware).  And having LFENCE be serializing
> even when it's not _required_ to be is a-ok from a functional perspective.
> 
> Fixes: 74a0e79df68a ("KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value")
> Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
> Reported-by: Simon Pilkington <simonp.git@mailbox.org>
> Closes: https://lore.kernel.org/all/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..21dacd312779 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & ~supported_de_cfg)
>  			return 1;
>  
> -		/*
> -		 * Don't let the guest change the host-programmed value.  The
> -		 * MSR is very model specific, i.e. contains multiple bits that
> -		 * are completely unknown to KVM, and the one bit known to KVM
> -		 * is simply a reflection of hardware capabilities.
> -		 */
> -		if (!msr->host_initiated && data != svm->msr_decfg)
> -			return 1;
> -
>  		svm->msr_decfg = data;
>  		break;
>  	}
> 
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4

