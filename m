Return-Path: <kvm+bounces-60046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E007BDBE80
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 02:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B3763353F91
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1951D5151;
	Wed, 15 Oct 2025 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROeNfe4s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE01A5BA2;
	Wed, 15 Oct 2025 00:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760487742; cv=fail; b=AtTQZrL235FxIraU7BRMT5x4DbYaapQ0GwPgU5ru/5v4XyjbmZZrHGR5DSpAt0CnfUcGppOim6+JWJfP57FKC1CQYviMxV9bYsaPAqdGJY9V5nqTuC6qPpKe1edj2LuULcjz0XFDuoxSgptLrKK3YIsTjf1d7DYIKEYlCcGS/1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760487742; c=relaxed/simple;
	bh=K9wo4RbxCxYyb+bG579BjEpZjPtC0DVVLxDA8vSTP7g=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=SHER/QwflURaZ+mcCiAwcghd7qH4XrFPtd3OSvQmGcqKFG1xp5A5LGWIGVOWoLD8phwF6ZqDkLKskl5wf8kZ0hcEvl8NavuYR2CuA/4Ly8JXuxMw1IOMvE+A0cdg3GJJhwhHGtyUokpGhU1BL8zqGF8K3vYhUTz6piSa5ukdHhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ROeNfe4s; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760487740; x=1792023740;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=K9wo4RbxCxYyb+bG579BjEpZjPtC0DVVLxDA8vSTP7g=;
  b=ROeNfe4sBbvy/BcINjsGI6mxOuw8R578CEx71R95CDGoiAroPkzmTFF0
   nRV5kEypXCgnOnPl9y+IwKkfWy5KXESss570xcrq0vx2QABWcdws+wupz
   HXfaUCQIsV4YgjgYxOCENXrNC5q6MJCbBXjkXGQBSMyh55H7+fUp04ri8
   U+rUQzcwjdj5rWKcnT/F8pCLB+op19bnhn+JzADoT6/yyDITxrQK6qKKz
   SiV1Tck5JDHu4WA27GAJ4t1Aw8SqVC8y7Rx10kj0kj6DgK8bI8+oarD5o
   alPeq/5zIS8BWrdaD+n0AC6YdygrsFB5KeZ6MYKbQZbWF4/Ai0AZDtesp
   A==;
X-CSE-ConnectionGUID: 30qRnK/QSXqqJyFnMow+nA==
X-CSE-MsgGUID: GcekE0HPRWOVqZ8QTxusLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="61864101"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="61864101"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 17:22:19 -0700
X-CSE-ConnectionGUID: GVGOCeAISAq5IVR+JbML8Q==
X-CSE-MsgGUID: 4GHsR1lmRvea/tR5xHUpQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="187329863"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 17:22:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 17:22:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 17:22:19 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 17:22:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJoofdCcNOXRDjRUuoKMCq3s7DNXbw6XjmvXigITAr3ltX48USmqrDFu0KLU6evIhp64Rkli6JtFuterM10p1q7T+b1ohwJUbp0tQT2C+wxrX3CzNf/eLK+8DbeTKqZw6ctc9V2VXjhHPYQWgBf+oJSl3XmhQeds7zh5lyN4CDzdVQnC3Je3K01O3lxZYF0/r4X60rfMdUIgFZfl6+4ysJDotD69nKIZkXnVCg+7mI9OoDY18VfTWj1khGJ5Gt4ydqfe6+fFQjM05uioap9Avu4Lz0Fnz06/sMPU2K5jwP9GcQPHJkjv5ju3Eu4Cu+xfrSKMKYWQZiwBfbhYrOWzxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vhLUvJXPqHzB1oY8kjHFUf/+rmrTchad64rJTdrivk=;
 b=ZXxdO7s47dHICbhY2z/qBX3kVnkLEMWT+HXk9HFcrdukNe4TvMew0/caclUVROuqt4N/y+7y6ZswwQGr3sTyhTPJBh59MywTtfIgia4JDAZZFrWzUv+KQ83PShMrhsh4lNfN/0CUbOYIqrus6fEarcMShpI4upqeWmrE79RCMf4q8oHujCBOkoN4Fmy6H6H4MdAfpntUEJfzJQa+E4z7zVlFU7Kp+EU1DWU+0FMwJ6i5CPIa+Z0FPABPmz5O4Yg3jHDjdUbDqb5qyJwoGzaouQOZ4PkDSsSAw9EU2Nfl3dL5LozpokMf4EqCA9AnQhGUQ0PQDyT6SPDuXuo7Gs0fvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA3PR11MB8987.namprd11.prod.outlook.com (2603:10b6:208:574::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Wed, 15 Oct
 2025 00:22:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 00:22:17 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 14 Oct 2025 17:22:10 -0700
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
Message-ID: <68eee932c6ef_2f89910045@dwillia2-mobl4.notmuch>
In-Reply-To: <20251014231042.1399849-1-seanjc@google.com>
References: <20251014231042.1399849-1-seanjc@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA3PR11MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: b77a09e0-5b62-45ac-09e6-08de0b80e57d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y1hXZW9JbXUxdWlIVmFjRGlxTGNSZTBScW9obGRpQmJwWTRhbkZYU1ArSUc2?=
 =?utf-8?B?SjdTVEU1Mk9ra2R3ZUhES2ZMTmJzYUdNTUNKQ0NKaFRyMW5qRDRMQkJnUGtJ?=
 =?utf-8?B?Z1JvNWhxQnJaQVlJU0NiNXhLTEF4dmUxdit0TlAxQnMvMlpaaVpRRzR1Rm0y?=
 =?utf-8?B?cG9zb0lOYlllU1FhNGhFRnBMajRPamlGMDJLeUZNOHEyVE5DWTJtdjdNYnBz?=
 =?utf-8?B?eFVwYUtKQVJEODdTbkRGQnhKa01IK3FobTlvZ1BiVlJKYURhenZyN3I5MkV4?=
 =?utf-8?B?TC8wR0RVeDJuRnBsZS85Tlg4TTFUeklkZ1BEUmFnamhiV01tOTI1YndkQjNk?=
 =?utf-8?B?d3F1L1A3KzljWE9IZS85cnFDR0ZXeWE3OSs1cm5oQlpCSTRUVjByN3FJeEhy?=
 =?utf-8?B?aWc5ekpLYnhTUjhmci9NbEF4eTNqdXFORlFVeDBJbWRmRlJqMEpqTWJEYURh?=
 =?utf-8?B?Nnovd29IdE12TjlKcGIrOUFZSnNvekdIUjVTYVc2TThyRlJpaHdZK3NLNGo3?=
 =?utf-8?B?U21uR1FaaTdISU5wbHdQRmkyWDhCVzRrRmViN3pOV1BxdUJ2WFVUb2xJTHp2?=
 =?utf-8?B?WDl6Z0ZHWnFPNnFPbWxha3c1UHcxc24xMG1DRUhOOEs4c2JFRmxiNzNaenY4?=
 =?utf-8?B?bnF3dnhvS21xT1IzQmZSaDFYZ1Y4akVOcmtYR0ZUYVhjK1BFd29PbzhmQm9x?=
 =?utf-8?B?U2NBdGhGcUhFUkxjaUtSVHkvQmM5b09CTjZzaVdoSTdWYjU0cC9WcXQ2SmNv?=
 =?utf-8?B?R3ZrbGM4Y1JWalNDSklabXp4ak9sV3pyR1A3c3VDODhSK2lKSjJrMWdnUTlw?=
 =?utf-8?B?bUZuR3NJaTRKSzE3TEpDUlBweXFlMGszVDJCa1hWc1BRdmdnbE40S3dFWHZr?=
 =?utf-8?B?NzB5eWc2S1dQVDVnSjhCTVg0TWNCYVJZRm9iVUZJOXgxSnprR3pOanRwbkZt?=
 =?utf-8?B?RW9JbUNqRnc1UlZIUUgxeno2WlAzdnJ4UzdsUC8vNWR3ZWY3TVhiS095anpJ?=
 =?utf-8?B?VVNQRVJBMnk5SVZMVkVhMjRYc0tyZkY2aGJvSnhDSjYyYlpvTEx0cWtXMVFT?=
 =?utf-8?B?dUYwVnp6OEE1NjdJaEJLZVJBdW56VmZsUjJ0MS8rTVJ5NWxVZkNlcjMrNWhq?=
 =?utf-8?B?Nko4V0lTNjhVNGtJUVRDWEZoTWczTUoweTU0NTloRmJiZVc2SitRLzR2OS9G?=
 =?utf-8?B?RmJTUm5YaUhDampsa2gzaDgvaGQ2WFZUelVHNEZmRjZkOXdYOGJja0dNQlZV?=
 =?utf-8?B?VE1xQXowcnV4T1JYNEJQMEJNT296Ly9BRmpHUE9kT0R5dHdNb0ZrTGczY2Zj?=
 =?utf-8?B?eDArMzRDNXZGckdLcUpiajQ1K0xVaUVmd004M29JRjk5ODJESGZvNWhURlJN?=
 =?utf-8?B?eXMrcmdYVk84Zy9Cem9ia1BpcGpLMlFPZnQybHMxYmo4cTFTanUwajB6Yzlh?=
 =?utf-8?B?WG1JaGs1NjlJR1RqUWNpb1FsQUMxL282VkNGN1Q0MjVNUE85cVJnNktaSktj?=
 =?utf-8?B?NTVwaVpCRmN2b0J3NThRZ2dxSmc1WEdYNk1SV1BLQVdZOElSb3NnbjhxdVBC?=
 =?utf-8?B?VU5OeSs0M0EwYzkzQXRnUWhXM3JNSjQzcGJ3Ym8zVDFmdE9aNGF0SkF3U3Jm?=
 =?utf-8?B?dHB0WGN5NTY1VXExajlvckxuWGhwRVh2ZndVNXd0amNwbW9kVmZGMEN2NDdD?=
 =?utf-8?B?SjNXWGJpTVFJb3JQMDN5SWNzUGNUSk54U0p5SVA3ek9FTWxkM2ZvWk84STZF?=
 =?utf-8?B?U0tzYVRKWEtGVDdNN2hGd2IwMGswVE4yY05XK1pCZ0x5SlBqWnVDWmI1bUoy?=
 =?utf-8?B?OWRyallIWXVoQjJwOW1TbzJDZ210WVJITlZEQ1cyaGxFVE40MXNSMDQ1dmxk?=
 =?utf-8?B?aTlPZXpSY3o2ajY0S2k5VHdKYUxIbm9vdzQxYzdLREdlb0hMZzdKdUZHYlow?=
 =?utf-8?Q?MNEKkNqnUgyIft8YnAC+gZMAr2Xw6lqO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmlaRnZ2UVdRSStxangzTnZPVFhwRk15NUVzT1NCSzlKcU14RlF0elA2aTBB?=
 =?utf-8?B?MUhpMHV2YUlucXU5a05CVG5UakZPOXNpSFlxZFlSdFNMK21IK0kvazIvZjFt?=
 =?utf-8?B?Zk9HZ283ZmxMZEFoMk9najdraytCbzYralhHeDNTTmlqTXVFeG9TcDFVYW1C?=
 =?utf-8?B?eHR3cVhlazc3SGtpT0xCTHBTRkFaWk4xVVVvaklDU1FPaXBjb0Nyc1MzYmpx?=
 =?utf-8?B?MW9CUXJiaWpJNmw3Nk80aG5xMTgxWjFsOC9BOXlTYWFxSjNtWnFJRnRtOG9t?=
 =?utf-8?B?UWtxUU9BaEZpRk9vUnlPdG9LdC9qeXljVG80K1N2MWd0YUUvenZxWnJ0MkZa?=
 =?utf-8?B?YXh6aEpFRjRXN3NtZVNGSTY0TFp3TXVudnB5cGpBbDhFUm9BNnE2NVlhSW5Q?=
 =?utf-8?B?OHd4NU9GTkZCbXIvQlZuVWZoMTR5Q2FhNFI0aEh3enNtOXhxRjFZZG1hR0Vk?=
 =?utf-8?B?RVh4U3BHaXc2czVPR212NjhSODVURnh1RTFxR3BiQUZoRjFwOFhtU053WmF1?=
 =?utf-8?B?d0dKSEl0R3BGZkhhc1g0QzdUb05NZEpUL3RicGhtTXZGcTg5SEtKa1I4bFBH?=
 =?utf-8?B?M2paTmU1dzF0M3FSTCtrb3ZQZ3czK2d1REdsU1VmVUNuZmY5VzM4SUdTcjEv?=
 =?utf-8?B?LzRhK0dhQ09kdnAwa2c0MWZ2TjgvSHZyOGhaaXJ3MXF6Y1RZM3Q0YVhVZW1P?=
 =?utf-8?B?Sk5FTzR1M3JPN0ZZYVJ6LzZnT2U4YXU2a0J5N2xNdzFITEZNN3hlRFIwRTU2?=
 =?utf-8?B?QS8rWjhoRmNMUFFONGhUUkpWTXRTZzZDaFJXSUw0RU1pUGtwSFhIQTFBS3E3?=
 =?utf-8?B?VkhIcndoam9kd2JubThpVWVYdHliR1FhRVRmQjZVeTJ2L1FMMkU4cXJTaVRU?=
 =?utf-8?B?WDFMcmtLTzFZR05GRitkL1lJWGRCM1E3YlZKZjdTN01VRTlkNjRyV1lCbkd1?=
 =?utf-8?B?YnhiTXkvQkYwOXV5WEVFc2p1Y1ExMlU3T1NlcDNLR3VMNGJ5VDNUdFF6b3dR?=
 =?utf-8?B?TWN4SVNZQjk4eU5yWDkwUGpNL0V3eHgrRlA0VDFFbFljelkzNTZNOE1qaEUv?=
 =?utf-8?B?RjExY1U3WnZYcWZoOFAxaUY4OTA1bGc4L3U4SDV5NVlzVzFsTjZBS3l2Y1Bo?=
 =?utf-8?B?WC9BNWNCdE1Hb1Z2RzNERUdTTEFPV3ovaTF5SVdrbDh4cHV0Z3d5d3pSRndJ?=
 =?utf-8?B?NU5tV0t0Nk9iUEcrWWsxSjJFUVA1eWcyNytET2dKZ2MzaWc5SHJkdCtyUkpY?=
 =?utf-8?B?WFlGWHVOMEw1SXdXcXFKVTArMGl0dXBoRkhYa0tjcm1EbWIrRjlhUHNHY0RR?=
 =?utf-8?B?WlNNdXdkaVJJMTByN1ZMOWhuUjN4MlBaaE9NWWlVUWNKcTEvYUdMeFllRG5z?=
 =?utf-8?B?UGVodFVpaUlSOGcwOU9wY1B6eXNzWGFZWUM5dzdFUkhBZ0JZVWV2OUg5T0Rj?=
 =?utf-8?B?cjBZdTk4M1M2VGlYRFNFcXdBNTlYMkloNFlKYWkwK0RRNE5NMDNEdm50d2w4?=
 =?utf-8?B?cnpzZHZwUkxNcm9hS3IxbmV3aVJkc2JNUEFCbkhPd2ltaXE4R1IzQkFNWUZs?=
 =?utf-8?B?V1VLN0U4dEI1SWVTOGlqSHluZ2dQVUFNcXgvNXJ5R0xSZE1nTVRTUkIreHFL?=
 =?utf-8?B?ZnlCUlVRM0k2Y0YzczVZZHF6amQwenQ5elpHOWRnZUxXTG9aYnozeFBvb2pn?=
 =?utf-8?B?TXAvWVU2S2RrWGNKc2dDNm5NWGZkbWtVM3lKbWRUN0gyd3pNV2taK3pWQVhL?=
 =?utf-8?B?UUMrK3RLb2p3QVJZc2ZxZDE4ZTJ3bHduVkQ5dkpCWEtmQXMycGZBZmF5RURZ?=
 =?utf-8?B?cVZRbHpVR0xZOVprZUExMUdBNzk1aGxSTmRFc1FSOUpFZk43SWF6SEorVFpB?=
 =?utf-8?B?YVdHUGp2YzVKK0pWdjhKMHlrSDBCUGdaM2IyZzFQRlBvQm5yOW5MMGxwZWZh?=
 =?utf-8?B?cmpsL1lOTmlRUUhteEJ5V3o1aEhwUEU4czIvZXAyMnk0ME9IQlhDKzExSGVO?=
 =?utf-8?B?ZDZmeGJEcnY3SXRJWVRZVmJFeDd6aWd6MlR2aWp5ayt2KzJ0ZGF3UGJGVzhn?=
 =?utf-8?B?VUV3eGE5WW9WcVpLUmx6bkw0OXVwNlZYalR4a2MrOUlhd0ZodWRESStZZE5R?=
 =?utf-8?B?MzU4ZGlMQWtqZTA5ak9OS0ZCVUp0VkREU2FqUUV4QitjS2crTXlHRHBxeE5y?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b77a09e0-5b62-45ac-09e6-08de0b80e57d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 00:22:17.0235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWIFEsN9T+awHZ1A1OxtHPKEDwL38o3PMWlZTDq7JMD2dW6rnahpS7Chl6lgRFvK924i54YQisAXeE+W2v5l/+LXHRvonnmJ/qDYavyfluI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8987
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Add VMX exit handlers for SEAMCALL and TDCALL, and a SEAMCALL handler for
> TDX, to inject a #UD if a non-TD guest attempts to execute SEAMCALL or
> TDCALL, or if a TD guest attempst to execute SEAMCALL.  Neither SEAMCALL
> nor TDCALL is gated by any software enablement other than VMXON, and so
> will generate a VM-Exit instead of e.g. a native #UD when executed from
> the guest kernel.
>=20
> Note!  No unprivilege DoS of the L1 kernel is possible as TDCALL and
> SEAMCALL #GP at CPL > 0, and the CPL check is performed prior to the VMX
> non-root (VM-Exit) check, i.e. userspace can't crash the VM. And for a
> nested guest, KVM forwards unknown exits to L1, i.e. an L2 kernel can
> crash itself, but not L1.
>=20
> Note #2!  The Intel=C2=AE Trust Domain CPU Architectural Extensions spec'=
s
> pseudocode shows the CPL > 0 check for SEAMCALL coming _after_ the VM-Exi=
t,
> but that appears to be a documentation bug (likely because the CPL > 0
> check was incorrectly bundled with other lower-priority #GP checks).
> Testing on SPR and EMR shows that the CPL > 0 check is performed before
> the VMX non-root check, i.e. SEAMCALL #GPs when executed in usermode.

Filed an errata for this.

> Note #3!  The aforementioned Trust Domain spec uses confusing pseudocde
> that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
> form description explicitly states that SEAMCALL generates an exit when
> executed in "SEAM VMX non-root operation".

This one I am not following. Is this mixing the #UD and exit cases? The
long form says inSEAM generates #UD and that is consistent with the
"64-Bit Mode Exceptions" table.

For exit it says: "When invoked in SEAM VMX non-root operation or legacy
VMX non-root operation, this instruction can cause a VM exit".=

