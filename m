Return-Path: <kvm+bounces-12996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E3588FCC0
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DB591F28CA2
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA01D7C0BA;
	Thu, 28 Mar 2024 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6L4usuu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E68D2DF92;
	Thu, 28 Mar 2024 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711621068; cv=fail; b=Lh+MnKRZPsIr45PzPz7ZTJb1fPSWVQsEqqW+jZmr1jrvV14bXC5gWv4wBVDWIX8UJf2xa8kLS0L/7UCDI9GxrtjBLoRwFkPMnCV+al4WvuAPKd1cs5tT3ViYtjK6KBCwko6XhDVzP4FRDNgcjMZVyVdEcaNNY30pPX6F5oZOKQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711621068; c=relaxed/simple;
	bh=+iQkUXeHE5zfQdpqUkcMjtp4TkoFfahZyMcTPUu1m6M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u9qypYiEKw/WgRuhHxCZ3Bu91r3Lu2cpJj9rw6pRZP1CXVTNk/LjrFPsV2Eza3l0k9ffgQTPuy6NbtfVh2T+/aqGOoY8qsOmaxwAGf+vExrnD8SPjnqrFr2gTr/UH+8G2xckskOSKgec3QPAIU0nKIsWgvrXauW2IRoVeKJ4E0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6L4usuu; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711621067; x=1743157067;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+iQkUXeHE5zfQdpqUkcMjtp4TkoFfahZyMcTPUu1m6M=;
  b=c6L4usuuUwy4jIWLV/g3VYh3fn10JfSMYsEkt3eG6HKu5DA/Yz7vTWAU
   lOQIaZtemaU7aBs9jML9OL6K5KwnidAqBC0QE5ERoFKDF4BbvDzOOlS0z
   +JICuist3gb501+FJV2OaGw6qt6b8gmWkjXeAMUclnSj51eDPDCLuTnw3
   LOHTlXSCQoubardHj1m15HgQokoBjxCm3yspFzkoeg/FGcpSwUzUWhTPN
   z8qYcVOdgfHohaMCpi4k1KTIVgC+xyIkSgL40x+Lx2nS5ajmyfAbhjl+5
   VkwpH6jnDYOgp7Ci0/3cbQUim6wUfvNSN+LUtgFCYle5/6O/ozJcQ3vUs
   A==;
X-CSE-ConnectionGUID: yS7P1bKWTHC18wGXxCdfuQ==
X-CSE-MsgGUID: G49BPqgeRuKv2Zv8sSvi9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17492526"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17492526"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:17:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16620308"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 03:17:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 03:17:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 03:17:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 03:17:45 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 03:17:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnOKgRbxv792ggro8lSLawlxbbLmFGPKh7/Zse91IbayTWnAhyO+d4CcyD1p0Ob3iYXjluOIkPmOH6ceBRTJwJK19ilVq3HwWhHYEYNjFDL5fxp9ErLZGXWLsz0blnQqmeH/ZFiZJ+kgKDn36TayP92+QzdVsYvZNMGggPk8ZzbD2Ca8P8JBMYiZ5QAZ66SfzoQplKLeL70zK7Y0JKr1qd7Jz7mN6WF2MvBsd6yjEt+4DM1E3meb7QhgrLx0apZGukrVwTZTtvdoG3lqz3fk6YPDD3Hc87L57lA9L8Yq7HGHoGl3d7DbL2xVoRB/1ZB+YuoC0HjQ0bQxqBd99oauVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SExnGu0tJ1z14ouwqkC1X9ngNRy6s4aDKGwCJEh/vsQ=;
 b=oDe2ddCQfb+j7ONzuabBPRt/AEw4bO+R5UGyr9uYlmF+THRGaYW0Ax+WQPRpO1zzTeyQldQIM0aUlnSc4xzhp9BQcSS1SiCbFQzNSHLqeOyUjI29EFtHE9zrKvz3CzZLsxYHLE0dwp7jTBTG6b2NA1GXUikg129c9sFowSPs8ULrLTk5NPR8P1dCkvUp8s6aiqSzq0QesCpHlPRdMsxDQStLawmhzugNc3QfnOOGDIjAP8Iw6BVZpeo5kQzz8YoA/QN+fe4qyWXyPuzrjHVGA2xiszAAq+zgcjiuttnh/xJEynRvSgyruXr8rxQQc4ZOdxJmQSM8n6TNLBRh1GpbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8761.namprd11.prod.outlook.com (2603:10b6:8:1a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 10:17:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 10:17:42 +0000
Date: Thu, 28 Mar 2024 18:17:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <ZgVDvCePGwKWv0wd@chao-email>
References: <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
 <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
X-ClientProxiedBy: SG3P274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::34)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8761:EE_
X-MS-Office365-Filtering-Correlation-Id: cbd86131-810f-4e5c-5f52-08dc4f104de1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPabO1GHQqb+xlAhq6ltfhYhGeyfeQyOI89JwhwUHr4rySyq9KQVKhZmFscHw3XemcSgpkZbF2fciDBQ88+D0i0/bLID+4xARJCA1bEOZKeqV9KgIlacVLOJZzuVdKlaqxgIb/Utz0pBs1NGsNOQIYZH/qjrYay9yFBm9SZjzJH2f3WCn2h+TJVclcLErU0HC9Efc08FbFSsvvqOIaWMn4Yn9LktyxFKfC7FmIiMQ0a9ZHN6s5c0xWPFRpQfGNIihn6Cvjh5elyDKsD+6yxZdyv1k0zI9XGJf+w7Gucs8bERLHOlKBYXEjSUXYU2KoP9vCdBTfHN1M4hFHW7qwAEaeCCuMN9CieZdkUKyueIeT6Iinp11DbDwp8CHwfNWYIKYdO1aWF2ZMIpIWjpBC8amQZz6GKMlI0x8gc0SGx0XfuKC7wHLRRlHHEj6oj/yZ0MtAoakqqQ21r+pmc1DxRgJqw5wwENR90+k4k61nh7FEcVK5lar4hje9vSikcSEo7BRYIQlAifaxawmXFNQ3kawz5vmbBXp+nzQ75YyRanqXm0RNWiR9+qEVcy78nNFiQ9WFp1lYJCe9got45Tr9bKquhSk/GTwHrxfk+ktEYRScZdqgiRz+tMWRaKcr8dS5VsakZ16ERgFlKBRBxyJR90h1Xnac+rs7VeFODP9HFaDBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Y+GJAJRvnODxylf5fHyqBSoAhDF0jjgjNl5hwZD9e18TWoNQdghr59p73F1?=
 =?us-ascii?Q?9qOhhSQ3YZ2WeUPzrTEvIAnquZYTLF7m7Ld5XSiUSIY5sa03PjlGq48i6evX?=
 =?us-ascii?Q?+ZF/waDuFGtC6ePTyRgPHEZ6sqqwVSWtJQZn7tZYHuuy5CKN6Qbg7dLZOFTu?=
 =?us-ascii?Q?PGzLtIxzRUQ28OnSFf0BmuAW6nEJVHG6ZpIevF8LTsHoOjXj4a+1+U8DmgaZ?=
 =?us-ascii?Q?qnwhCJWyUP1xt/bsE4GEOfDwi/MSQBQs8s9Bfognwg9jRE3sJ5X15CiNHOZ5?=
 =?us-ascii?Q?OLJ/fIJbMp93UxaDxfIY+pp26qTK1QdyJLyIukgZhKHGi+k1DdcLmIVYqVOk?=
 =?us-ascii?Q?DYGM9S2Dj1eZZa3JKGTUFZP/JlbF8X40GBffVSbSlvi6VUO2VjHs78nXOXly?=
 =?us-ascii?Q?/zD5HhTnlWs6Ifc3AjP36Fdo3wafr9iwr5A9FNg9cp4oAhB1pFhu0D41Bt2A?=
 =?us-ascii?Q?yqTqsTvqm4OmJl6CGLpWmqdZgQxqVDpqLjhfFMu3Uf3wpWo/GIDj2I432/V/?=
 =?us-ascii?Q?qVjsx2J8+sopgDKj8oB497TsRWEV5uMH7/ChOcQk4Pf1P8kGC4qfc/VXhCrO?=
 =?us-ascii?Q?N3gnIW83zBMtMvjX/l8aKRWQDN6bdkn1NVphb7xYnuN/vuYqBPtSYIDGSBRt?=
 =?us-ascii?Q?Pt87i0mpgvIMyS36GXalvhSogJK/omQeBPXVYDFuCvPKTWBrkJHZ7YEzkkW3?=
 =?us-ascii?Q?Wo3lGUZ+QSEHmowYKEa6hIttFojUtOiCARBS4uH7e9UJ96u76VotHCynZdNr?=
 =?us-ascii?Q?IdjruZPrjPLPjdepALAVY3Foun0XyH6Ku6xp+I6beiahXKJ7qTTC2Z2C/wm9?=
 =?us-ascii?Q?hCetTlOF0yJjPSXWJIFwRTzDUCIA3DO8eHymEf55JsN34CkeoR1dYo0iHlUG?=
 =?us-ascii?Q?+NBX4L4OEOsuXQUc/VfpdvjfzqCqUO+fuU+eJh1FRgy2Gjtqqjcckb9TTEVu?=
 =?us-ascii?Q?rEDDXgUmcRT69lkT+sgpQwQSB0JNHvCha8oSB16phyfJsVlzjLfSbNcoMXs2?=
 =?us-ascii?Q?UwKKYm1pdQmfytzPgonQP2DXAT2k/+xG5gF/w48oUXkHEGya9OSZurEa/BTx?=
 =?us-ascii?Q?Vd2518FtOTkF35WivnuCuIZ9ZvBnCUa9XFqWlmZtVVpj60g/PBLd/QiiqnfY?=
 =?us-ascii?Q?L6PEq14g/xdyTXAGvQkUDSIypKOiiFasZ1AfnzS6Y8Nu4m50UqS6SOp8Put2?=
 =?us-ascii?Q?6xWguhJbfrKazH7aTQY8kyRJpMfoBLp+scrnNg2TvQpTOCzCXXlbTUt6JyAq?=
 =?us-ascii?Q?Zbpymx9CB/opJcbQsgwpyuyAl7rtnHE+UW3bSrK/L/5GcwXAIp0Mjk8xhHFY?=
 =?us-ascii?Q?A5jYBRRbBJAx4qKY/xuf/GRZro63qX1oMXv+tncdPHXhZqJewi+84uwDXh/O?=
 =?us-ascii?Q?wSEhiPmrU2CBS/+pWkDlav6Mkio/0ypDvPWFhho2H6ZH+SEYlj98rWj7FzL4?=
 =?us-ascii?Q?o47AOyZivBq5qjFm9PIFHyZN+iiHj+gXPEXX54IZMsH0SwrajM9EH8M0DjZn?=
 =?us-ascii?Q?fg4Dl0kYD3PD6/K0fw0XqTWCXo24U/OME3SaDr3E58ISXtJJTv4wj5IdvK9z?=
 =?us-ascii?Q?2fFbiQqUf6CHePrYleubmaHP2ru/SQR4SijqkoDX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd86131-810f-4e5c-5f52-08dc4f104de1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 10:17:42.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/f+ibZK0NhWRcUyr+0DMzFQq2aAIItvcjXQ8oNDvJkiCiLFarJKkHqMcuJPeySH8O+8IgmKuZ0dOBlyXNuy8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8761
X-OriginatorOrg: intel.com

On Thu, Mar 28, 2024 at 11:40:27AM +0800, Xiaoyao Li wrote:
>On 3/28/2024 11:04 AM, Edgecombe, Rick P wrote:
>> On Thu, 2024-03-28 at 09:30 +0800, Xiaoyao Li wrote:
>> > > The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this
>> > > is
>> > > any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different
>> > > exit
>> > > reason or behavior in mind?
>> > 
>> > Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.
>> 
>> MTRR appears to be configured to be type "Fixed" in the TDX module. So the guest could expect to be
>> able to use it and be surprised by a #GP.
>> 
>>          {
>>            "MSB": "12",
>>            "LSB": "12",
>>            "Field Size": "1",
>>            "Field Name": "MTRR",
>>            "Configuration Details": null,
>>            "Bit or Field Virtualization Type": "Fixed",
>>            "Virtualization Details": "0x1"
>>          },
>> 
>> If KVM does not support MTRRs in TDX, then it has to return the error somewhere or pretend to
>> support it (do nothing but not return an error). Returning an error to the guest would be making up
>> arch behavior, and to a lesser degree so would ignoring the WRMSR.
>
>The root cause is that it's a bad design of TDX to make MTRR fixed1. When
>guest reads MTRR CPUID as 1 while getting #VE on MTRR MSRs, it already breaks
>the architectural behavior. (MAC faces the similar issue , MCA is fixed1 as

I won't say #VE on MTRR MSRs breaks anything. Writes to other MSRs (e.g.
TSC_DEADLINE MSR) also lead to #VE. If KVM can emulate the MSR accesses, #VE
should be fine.

The problem is: MTRR CPUID feature is fixed 1 while KVM/QEMU doesn't know how
to virtualize MTRR especially given that KVM cannot control the memory type in
secure-EPT entries.

>well while accessing MCA related MSRs gets #VE. This is why TDX is going to
>fix them by introducing new feature and make them configurable)
>
>> So that is why I lean towards
>> returning to userspace and giving the VMM the option to ignore it, return an error to the guest or
>> show an error to the user.
>
>"show an error to the user" doesn't help at all. Because user cannot fix it,
>nor does QEMU.

The key point isn't who can fix/emulate MTRR MSRs. It is just KVM doesn't know
how to handle this situation and ask userspace for help.

Whether or how userspace can handle the MSR writes isn't KVM's problem. It may be
better if KVM can tell userspace exactly in which cases KVM will exit to
userspace. But there is no such an infrastructure.

An example is: in KVM CET series, we find it is complex for KVM instruction
emulator to emulate control flow instructions when CET is enabled. The
suggestion is also to punt to userspace (w/o any indication to userspace that
KVM would do this).

>
>> If KVM can't support the behavior, better to get an actual error in
>> userspace than a mysterious guest hang, right?
>What behavior do you mean?
>
>> Outside of what kind of exit it is, do you object to the general plan to punt to userspace?
>> 
>> Since this is a TDX specific limitation, I guess there is KVM_EXIT_TDX_VMCALL as a general category
>> of TDVMCALLs that cannot be handled by KVM.

Using KVM_EXIT_TDX_VMCALL looks fine.

We need to explain why MTRR MSRs are handled in this way unlike other MSRs.

It is better if KVM can tell userspace that MTRR virtualization isn't supported
by KVM for TDs. Then userspace should resolve the conflict between KVM and TDX
module on MTRR. But to report MTRR as unsupported, we need to make
GET_SUPPORTED_CPUID a vm-scope ioctl. I am not sure if it is worth the effort.


>
>I just don't see any difference between handling it in KVM and handling it in
>userspace: either a) return error to guest or b) ignore the WRMSR.

