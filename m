Return-Path: <kvm+bounces-23007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C463C945851
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E9A5B23455
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 07:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B41A4AED7;
	Fri,  2 Aug 2024 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mYyqUp1c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFA6364D6
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 07:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722582025; cv=fail; b=TssfVxsfoXzB2Ezcp6ZO6touSYkE65AmXNK74kUjg2JBX8QBoDk/aNfaLF+BFvsub3GS5/KE8A43hDI+aijlpUXNLLC0Vtfg+WimrdkeWJKDMRbt6AiV8s5eJHeKukEjKQx0ZF4f6v937hvtUlf+8FXZyWoj7w0N9DgULY399tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722582025; c=relaxed/simple;
	bh=6Z09HZmm4g9Lg+uRFTPS1sbGxkC4k94vTl8HOGZ2DEU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JivcqfpyxXLeZDUhR4b16TPiX635vvg7OPJGvUTRi3Bleriw/SZRtz77gqUVx2xkcfdAtxtMI8IgGDbGS+wA00j5Eyli6NB5YpU7qv45OcxdKApXBQBRQE0odtGfwFTQiHanNjmAI5BoPvCcFyJ5qTzTk7pBhmvMHGRD6lWKF64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mYyqUp1c; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722582023; x=1754118023;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6Z09HZmm4g9Lg+uRFTPS1sbGxkC4k94vTl8HOGZ2DEU=;
  b=mYyqUp1c7iR8I7FMjefZKeBkY+kPWzkmtE5ssqCiJMre1zQJ8RNKeEnT
   AtIeU8bnnuokIQiEW2z9P7PZ5/bfVcQBdVKdBsogIerzeCF38N9Q7ct6t
   t1hCx1rBQNN/H0FxFF1lPXfEJNrj/7MiaeXJ+gdkINfazdmV6N2B//9ol
   ABSFY7AGBMOxB0g9s0JLYPdoN4GL48pVlhhlTpS/E108cc6mzp9Gx981c
   KG8dBnzVgsY947cNc/Qf5ZyIu5F5d26yDHuf8teQ/4dBl5dWoxIIacMs8
   mEAUmJWWZ+z0z3TnXPTggoYEqK5GMJa2jKUTVvKl3RVxWcngMaIU4K8AC
   g==;
X-CSE-ConnectionGUID: f2VDkIG3QV2u6OJ13N8cmQ==
X-CSE-MsgGUID: yNYuSZNuTe2GTcLK/q6CTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="31984791"
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="31984791"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 00:00:22 -0700
X-CSE-ConnectionGUID: M0CNt+bWQYeJAqYXC9YW8g==
X-CSE-MsgGUID: Yb7jS9SnSImeVvM60YXCWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="54969781"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Aug 2024 00:00:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 00:00:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 00:00:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 2 Aug 2024 00:00:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 00:00:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9kvgoiiiBqdlFqZTnD+S81k6j2B7SbxbB/SXy9NrOv7qOATmKOFBb/+nmkMly97g+hS0sx7uVMEP5Vh1kZG07juQ6oRFYFjwpRBgDqf3OWXCLGGKOgUUIgTYyQh0sL31O0Dciuqc7QrBF/GdvSA4VRqzclGMrRZr9Blei5gifjS4aYXRfUZkGoG01PodCh2kPdZnWfFX8viBWJFrHofJw9cFo4pSMYVtlz6MVLl+UpuiEBAWZzwm55Fh01fPgPfyT4FT7h6uB73Hn01EOS7FN2eXANLF2ONeHy92n4XZk9159jwGnNqEPOs9lJuPkNVCNktfqdcR6fW3Lq2hIJDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mIfD2+O4h3RqKqGfAVUNMKGz1OleZ8Ve1GjaY6IsCg=;
 b=K/9F0fpK81lrIFk/ScVjEpye3WLP6tktfDdyAAOuEGWFIYwscS9V2l991cHL5wrJyJkgH6iSr6Mhf/pVHvUB80EvdHQgRDHHOpt4XVAB0vgqMDD++xt8QZyYfVhULxXRjrLb+bK3ea/O0sBurF3uq74RXevFha9usHPTCEbpk6vS9Lj4y9CPlN0//7eStqCurCo9dtBhfWpwunvlDLPuNizhXG+3GV2Zq7EL+p0V1fbfrD1xIlDyA4zC04sjW8l22yKxdT+8TrNRJTl1kaTPzJ92qaZRqMI/zoEOd9dB+Yd6XNjZ3ZRizTQxLqezr2YJARCXEK1q6v3m5xCFpbzxVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB7939.namprd11.prod.outlook.com (2603:10b6:610:131::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 2 Aug
 2024 07:00:18 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7828.023; Fri, 2 Aug 2024
 07:00:17 +0000
Message-ID: <de021f3f-4ccd-4d51-a3ed-439ed9f23515@intel.com>
Date: Fri, 2 Aug 2024 15:00:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
 <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
 <0fdd0340-8daa-45b8-9e1c-bafe6f4e6a60@intel.com>
 <d299bbad-81bc-462e-91b5-a6d9c27ffe3a@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <d299bbad-81bc-462e-91b5-a6d9c27ffe3a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0096.apcprd03.prod.outlook.com
 (2603:1096:4:7c::24) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB7939:EE_
X-MS-Office365-Filtering-Correlation-Id: 872c5190-ba12-4bc7-a5ea-08dcb2c0c442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b25ZQzloQjJrYU1zTzMvSmU4TW0wUWxrTTR0SlY3eEZPeWhpcGhGL0RhUnB0?=
 =?utf-8?B?NjdKZlVPYkRJbFlsRW44YjRNUmZ1V0UzZXVkc3B6d2V1cnBUdkxpZDlMUE9H?=
 =?utf-8?B?aXU5alUwSlUxbEdURW1wVklHVk50eHJvaEVlMkxqYjRrUUppS0pCeU9scUhr?=
 =?utf-8?B?MzBJTHZjaEhvbVdRYzZrOGZDalJqWWJSemFvampxazYvWjVzeVhVZ3NnMC9r?=
 =?utf-8?B?bVkzVnFvcGt1Z1lub09yaXlhSmxkU1JFSUhDOS9YTEdlcm1ZTWtaT3UzNGhp?=
 =?utf-8?B?MWZhWjhycU1RUTBFVnNkNis4bFVZNlRFajRFcVNIeE1GSm43RHpCTEtjUmI5?=
 =?utf-8?B?MUpRUXQ5dTlMVUxYdGJJUDZldkRjR3ZtMGV0ZXA5VmdDWE5CaXRRcThtR3lQ?=
 =?utf-8?B?ZWltN2ZPbHNWNDFDelNFMHBXc1ZYM1gzdTRZOFE1aXZka3V3TEgvaDBQS1Y0?=
 =?utf-8?B?T3NCdzZweW9PYkpDN1dWd1FGRzByZEI5dU1iTHQrVEozK1JFVmk2VFRLMEhr?=
 =?utf-8?B?bjg5OFM4eXhnN3lPUWZFZGZrM1ROdm1KQldvSGVBT0x5K0RJa3hQck9oQ004?=
 =?utf-8?B?VVFkdDFYL3lOVjA1VVp0bXZJV2lqcDlFTmdYYjF4ZVNDaHpjdXdKR3BZMXJ2?=
 =?utf-8?B?anVoNnYybXVXUDJlWnkxRkpVemFsWGpqWkdGancvN1dxQk9GQmNDWFU3QmZ3?=
 =?utf-8?B?QWtvRGhyNmNZWUlsRHVBdkVFNFo0UFhBUzVzazhwZFhmWFAwOUJ2dU1LVEdy?=
 =?utf-8?B?S21hMXVrTk9vZCs4K3F1MDEycjhObUJWYTQ0S3BIcW1hcUlHR3VaeFR5emdD?=
 =?utf-8?B?NU5uZmxRVzM3WGZmMHJaSG94b0YrcC9WR3RBS3IyLzRkOE91ZWIrKzUvSjc1?=
 =?utf-8?B?enN4K254SEE2U3k2Tk5CMVZ1MVNUV3ZOWWNRbUNPUk10UEVnYzV3ZDUrNEp2?=
 =?utf-8?B?SDRPWk9OdVRZemJjK05NU3MxMEJJaDVGZWRGNm1GRFBTQWwwMS9ZcnZSa0hu?=
 =?utf-8?B?QVE5WWd0dEpFTy9DMVR1RjZHZzJtMGNBWnRCMTdiSC9EWGo3ZDgvdi9ZYmY4?=
 =?utf-8?B?K0dQMEVyNXN3ZGVsM0dyUDVHRjIvNFplVDFrVkQxdENkcmYzNjZoczhmNGRB?=
 =?utf-8?B?SEZTeEYzdDBCZkJRYm9xZ0NtN0h2QnRkUE1sLzNReUd1THcrNnhoaXV3L0Rx?=
 =?utf-8?B?ZEh6eTRTcDhCZW1wcHZ4ZDYxNS90cnJOamY3MmhxYS9mT1NtZDIwdi8wSUY0?=
 =?utf-8?B?ZnRiZ2RHVmFzeGFsb0RXZUk5SlBXcGZQckx6ZEw0S3hFa2laeUZHOGpDOG5T?=
 =?utf-8?B?NnFEYlpmZGhtem1JQXpzdTZhdXcwdEtMdGtpaUFPQXZ6RHBVbldyRHg1NlJx?=
 =?utf-8?B?SkwvWTlCNnVIMmFiSENMQzhXTHNFc0ZYTmttbXprdzM3TkNlSjUzMmROMm9y?=
 =?utf-8?B?dVZrSlQwRUxDcXIrOHlwdjl0VnpUTmp5MGNncG1SL3RSRVVpS3IyL2xBaFdj?=
 =?utf-8?B?am03Sms2N29Fckw5bVdYc2tMME10WVpRVWZCdno2dGxKd1ZIVjhlTFd4SUdY?=
 =?utf-8?B?a21KYUh0V0xUTzBJUDQ3a3dISmFTZlVyMithZW9Ec29VRVFIc3NieG8ra3lF?=
 =?utf-8?B?bmhoZDhiTUtycGlSN25NS1NrNVNvaEdsbUorejRwTGZ1U1VOM0JvcW9TTFF2?=
 =?utf-8?B?UDNZa2UzVmZSYk5QbDNQTXAzTHVMelZUS0hQSXlsdk1SalpmRzErT2t2ZnBC?=
 =?utf-8?B?WUFOU2Z5YXB5YWFsOC9HWEZXNHFzT2ZJaENvMjZtR2UxS2c3MlNrenhxcVF6?=
 =?utf-8?B?eXRrUUVvWmVIWmRtZlBLQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2ZqS2FjSUc0MkxaNUc5aEloeStNZkgzT2ZHQUhIa0JtS1QyZDFwNlhjNFZu?=
 =?utf-8?B?UW5wbWIyaDRCWlV2cE0vYkIvc29xZHJLVmtKR1Q3YUJyUDhQNGMvTDZ0WGJU?=
 =?utf-8?B?QURBUGVaUWlPbENobVVsUG5LS3pFUWk3azhIaklMRzVCSVBPaGViTFZrQmxG?=
 =?utf-8?B?UWhRWE8rVEJsRy9ZVkRDYm5GMUJ1VGdPTElJdHpmV0x3OGRKSXBqeXMwcElo?=
 =?utf-8?B?ZWxuL29jU2xXOUFWUHA4K2hUYldJQjFIcm1YTzJ0SndQaSs0OCszS3Jkek50?=
 =?utf-8?B?UlRWN0FqS2Q5TS9SaHduWDdoVnRuZENuN1g2bFRIdy9ndlB0bmw5djlhUUJy?=
 =?utf-8?B?OVN5ZWxUaHlMaGtNNERYZnByWHA0U0ZLc2lmdkZFb2Jlb2NtaC9FQ2VWZjhR?=
 =?utf-8?B?NloxdHZmOVRBMWVGbjZnRjZyNnY0Rk1vRFJXbmxOUTdXNkpKM1VuK2YyZ2tP?=
 =?utf-8?B?TmtDVTFyYUc2S3BNR2h6NGZLdXJIRXZNSklSY3N5YkdzekV3QW8vdTlVSjNs?=
 =?utf-8?B?T0I3QWNHQ1NOSEwzLzMxdmZuVXQvbElRRk5LVUM2aEpDdDFMZDJvaXdaTnFy?=
 =?utf-8?B?Vi9Eelc5RTZQYkhpMzdsVHdCclp4Z0ViTDA2ZjRPV3I2WlRIUWw3UkROMDJT?=
 =?utf-8?B?dklxMnlBelBKMXcxM3p5L0JBNGljaEF2RmZ1eVFnT2xyWExtc2prSjI4NkJk?=
 =?utf-8?B?dWZVSStUSGpCYmoyWU84WnpCMjFBdGxwVE1heUx3S2ZLc242QkU5WFNVZHBy?=
 =?utf-8?B?dDJVY01GMHJrZ3B5aUNLYXFuVEdJM2kyLzFLdm80L1hUOVVqR09hanlteVNE?=
 =?utf-8?B?SXBJMTBXZ0dmMi9wN2RQUWo5TEVSMTE5Z3QvM0Y3S1JieDU5VHhNTVBpWGVD?=
 =?utf-8?B?em5FNy9yUE10aXhTZ25qUkxTTWliWENNdDVzZDMvRm52TVVhTUswVUI2eFpj?=
 =?utf-8?B?NktURm5ZdmVCMnNWaFFPQklyK251MzBJbkdQSTlRNkRNUjdwRUFCSkdwM1hK?=
 =?utf-8?B?bTBzVEhCZUU5Z1NMWjh0T0x1M2s1aU5hdmxhSUNIR2pudVZJR3BzQ3JsRUtn?=
 =?utf-8?B?Vmc5OE9ER09jT3NTR0JlUVdIU3REMStpZC9JcG1SRjFPNHRzSlJIclBkUUR5?=
 =?utf-8?B?ZDJpeFMvOEpzRnZZdFZIdWtIU2g3VWc0Y3dUSXk4Z2J0aXl0R2w2anVPVjVT?=
 =?utf-8?B?VHJRclpqSm5xMDZBY0V0M0RySzhsOUlCZndENEYzYkFuWDdOZUtuaEtPbU1F?=
 =?utf-8?B?eUo4U0U3MFdpV0hackxEKzBiRWI1WVFFZTcrMUVqWklrZmE0TjRINklMVXky?=
 =?utf-8?B?SzFoaCtjanVLYzBmQnJKMis0Mzg0TDhoOUpxb2VFTmluTk5Gb2ZVOTQ0eDRr?=
 =?utf-8?B?a0NKc2FCSFV3U1dFb0NTaTlJcGh6Rm1BaUJCdXp0MDV0dmlvZTFaMHB5OGN1?=
 =?utf-8?B?ZjJqcVp5bkZ1aE9wY3FnUktJV2h1U084MDB0dHByZnA5TkRRSTVtRCt6SEs5?=
 =?utf-8?B?R3VCSGQ5OUdLWXI4ZEJIOGtIeWVqcDVkU0ErcGh3UHMyZkIrL05KQTVqejF3?=
 =?utf-8?B?YmFCbG9jbC9rVndYVjNhMHFiOEw4UFBiVEt1UTdWUW1pL1czSWMyY2VCZDlX?=
 =?utf-8?B?c3h6a1BQZXJHZU41aVE0cEx2dFJLZWVLRWFnd1ZabzJEdDQyR0JrTWRnSFg3?=
 =?utf-8?B?bnVFck52RVJsWXFpYTJuazBLa3VmWVBpcWFmai9saThxbUFuN0d4bklIczRZ?=
 =?utf-8?B?cHhORTBJczcrbUc5NGhxMXdoMk9mTDlIQkpnUDBCQzBlY1A3Yk5KSDJVUmVH?=
 =?utf-8?B?QXU2aER6Z3VHbG5PVDgvNStLTUk5SVliRXM1WDJIRDlUSVpJcDk4T3VncWFE?=
 =?utf-8?B?UU5CNjRWQTN1N21EbUFtQy9OVFlNaGVmZzVoanZjZU1kUzlQc0lxVUZTQXBD?=
 =?utf-8?B?QXhnQUdjTG1vN1VxVkJUYU80ZExoUCsyNmhnRERBankrSEdTR0hhVDFZcTlh?=
 =?utf-8?B?Ti9wa0FvS2djY0pCOERtSitPQnBpZmJZcmgyak5CaEx0Y2JneVE2V3orejRO?=
 =?utf-8?B?cmp5SGFwdmFOZ3hsUGlKbG5aTWtLTmtKNXF0em9lTXRNbkhLOUZ2aFoxNnky?=
 =?utf-8?Q?3pLclBIwhnq0bmIhuePlem+Pe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 872c5190-ba12-4bc7-a5ea-08dcb2c0c442
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 07:00:17.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEKDXmEJ59T4sxiqub9ihB/3K9gIxjWrGfaxqUlkDnX/IYqYSUAvftf+W3yDJhuIfVQc6qZvkofdiONvBxfk/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7939
X-OriginatorOrg: intel.com



On 7/31/2024 7:18 PM, David Hildenbrand wrote:
> Sorry for the late reply!
> 
>>> Current users must skip it, yes. How private memory would have to be
>>> handled, and who would handle it, is rather unclear.
>>>
>>> Again, maybe we'd want separate RamDiscardManager for private and shared
>>> memory (after all, these are two separate memory backends).
>>
>> We also considered distinguishing the populate and discard operation for
>> private and shared memory separately. As in method 2 above, we mentioned
>> to add a new argument to indicate the memory attribute to operate on.
>> They seem to have a similar idea.
> 
> Yes. Likely it's just some implementation detail. I think the following
> states would be possible:
> 
> * Discarded in shared + discarded in private (not populated)
> * Discarded in shared + populated in private (private populated)
> * Populated in shared + discarded in private (shared populated)
> 
> One could map these to states discarded/private/shared indeed.

Make sense. We can follow this if the mechanism of RamDiscardManager is
acceptable and no other concerns.

> 
> [...]
> 
>>> I've had this talk with Intel, because the 4K granularity is a pain. I
>>> was told that ship has sailed ... and we have to cope with random 4K
>>> conversions :(
>>>
>>> The many mappings will likely add both memory and runtime overheads in
>>> the kernel. But we only know once we measure.
>>
>> In the normal case, the main runtime overhead comes from
>> private<->shared flip in SWIOTLB, which defaults to 6% of memory with a
>> maximum of 1Gbyte. I think this overhead is acceptable. In non-default
>> case, e.g. dynamic allocated DMA buffer, the runtime overhead will
>> increase. As for the memory overheads, It is indeed unavoidable.
>>
>> Will these performance issues be a deal breaker for enabling shared
>> device assignment in this way?
> 
> I see the most problematic part being the dma_entry_limit and all of
> these individual MAP/UNMAP calls on 4KiB granularity.
> 
> dma_entry_limit is "unsigned int", and defaults to U16_MAX. So the
> possible maximum should be 4294967296, and the default is 65535.
> 
> So we should be able to have a maximum of 16 TiB shared memory all in
> 4KiB chunks.
> 
> sizeof(struct vfio_dma) is probably something like <= 96 bytes, implying
> a per-page overhead of ~2.4%, excluding the actual rbtree.
> 
> Tree lookup/modifications with that many nodes might also get a bit
> slower, but likely still tolerable as you note.
> 
> Deal breaker? Not sure. Rather "suboptimal" :) ... but maybe unavoidable
> for your use case?

Yes. We can't guarantee the behavior of guest, so the overhead would be
uncertain and unavoidable.

> 

