Return-Path: <kvm+bounces-40977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD938A600A1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78A567A4106
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FE61F1523;
	Thu, 13 Mar 2025 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrGS++3q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09051F0E40;
	Thu, 13 Mar 2025 19:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741892852; cv=fail; b=UsECZCJghYZVcUh0L5VVnRPij9jgfv2WM7YJSbAWYeLJWM+L58sIiy06k2TYhjDDZLsZMeMFZGVVpPs/43+qSFo9M2bsV82AdOLHkjxr/bOYjtTTmaYdzY2hxQ4OHQB0xRpI+eRMvsXKiVWGbWUw8099K9kHg1OkVK1o8fCCHHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741892852; c=relaxed/simple;
	bh=/oTUdXR1U5GXcKC1tmh1AC4e6q5+dmr2MKBEgtd6TuQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dm4cIK7GfvbCGF5k6Bv4S8C89uXjfReJgkskdbwkO94onAbo5MRTW/bLzAmrWxT6feua1UFYgcN3OECb/lWB22UZNrvzZsw3A4xTj+Fq2FoJiWeHE5CaFhkx0IVzwPtcTugoWVv0YuzJmD3xJDclmkgY6dCatYi2UZC6guGvjXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrGS++3q; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741892851; x=1773428851;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/oTUdXR1U5GXcKC1tmh1AC4e6q5+dmr2MKBEgtd6TuQ=;
  b=XrGS++3qXLUnDbS8F2yVzHNvDA+R9NGb2mYDOC6Qat8OGvLb44llc6gN
   7Rvg9NDNYO7aPofSY7XvRgQ1ZsV6k3cWfTtdHSQfIBbm3WGzgQzMBz/iL
   pNSEHMHODSIgGHHXhPey6NdZXXzDh98hrFg4K4UIAgezCICSXfurj6l3+
   h3BbYTjFyBNowB6krS6BTw+rC93G6pgHEDao8//9m/vykmN9+RfJcqg1m
   z4KkGotoUPrzUJ2gPNr63ygGysUkTeZUpLwev5vGSkklZs3XrbDiKScBG
   Azeh0KqteM7rQ8i59z8LJhejls6uo4X3hhVE16BEGSaC36mgS+3ocOTa4
   w==;
X-CSE-ConnectionGUID: uy5BDPVKTb66Xrfc+YorNw==
X-CSE-MsgGUID: QQaCqG1WRN6Jq0n1y3DVDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43133014"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="43133014"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:07:31 -0700
X-CSE-ConnectionGUID: KY3EVOZWQ1CwBpk0xrTUJg==
X-CSE-MsgGUID: qfAncpkBTKKevYiT/wnglw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="158197233"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:07:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 13 Mar 2025 12:07:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 13 Mar 2025 12:07:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Mar 2025 12:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zu6jtLiFJEK4/EAYZyT1GVhpbnRbCYOsHVdotcnoKs0ZBMCnDDsGRYlnxWr1ardD/Iw1UBzNtPD0vyL7SgpN2T0u/ckCEgVVHvJfY6l+/ZeZCSXapSKPqw/f+PJrtC7rU53e+cJYY9tWhgwp4t8qK+tP7bpqCbKFOifI08w0QZ5NaCDiB9NXF9lbIqbsUVQu4Qgv0l4MeVC7t5dqi/EqAEp2Ap+uF//oCgAvTVkmFATV62V9+S8Zd2Rn1FyMVDhPVj2U+nIPVOw3/SeqaBtMcCEnE6qq6nu+qncCB3VqL8bXRLzp2ArNRv88Pz4HjbQyv9thPL5/KewR7CyjkXRxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR6nwZ8DX7fwZ01oBN+pwGGHs68OU9JcetSERaNw+9I=;
 b=rL84tJCZ0IR7iPJtotdsRsxDvOotbkcF9Q1vyhxmIp+xJHi+CiRnEmchDBsizo58TqZdD2QZ1BL9vh9BVU5tMJHWykz42DUREcP4tU0Yc0Cu5YEyVk3hYj1gYBCKnAt49t+sO7UPDiXssZx7q/+uHcKneNYfOsjLHKE+gCmJx5XfdW5n38hrNvILfxf+kFo8HFiZ9iQFCj8Y0IJYbg+ydLHzdwd/F/7+QSdvXeSCDAnpmdJkKssu5RNkHvHyTL6LFAungzrgth43C3wc/QOGRRELFQ/Z22FcwIWWjdjzVztsxYqyiBF2TJP6znDgFCND74PXveCc8LnOFNQiXl9XCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by PH0PR11MB5808.namprd11.prod.outlook.com (2603:10b6:510:129::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 19:07:26 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 19:07:25 +0000
Message-ID: <2a25d2c8-6b2e-443b-98aa-723dea2c9e78@intel.com>
Date: Thu, 13 Mar 2025 21:07:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kirill.shutemov@linux.intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <CABgObfZYjdW_Mp3JB0z38-RoAdhr4rwjzb_AOYfrmwZZ0ERBsw@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CABgObfZYjdW_Mp3JB0z38-RoAdhr4rwjzb_AOYfrmwZZ0ERBsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI2P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::11) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|PH0PR11MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: f6393a76-0e6b-4579-22ce-08dd62624a79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rm5sTWxCQ3RqWXFoWEQ3SDRpdVR6TW5pYnlHNzBwSWY2MWFXYjZHb0hhc0t1?=
 =?utf-8?B?Q21yRFRXSXFBeWFWL2Zvb1pudGFzV0ZPaEdjRm1vRVRsU041Yk5xN2dGUmpV?=
 =?utf-8?B?RkNSZzF0ekFzclFQV0hUbDdVYjJwUmdMdVV2WjNEenc1eGdnbnUzTm9BdE4w?=
 =?utf-8?B?VlRrNmtveXo3TW4vdm9rZDBJbWZyVEJ2SFpxMVdKaTIrOVBza0pMblcwRjNI?=
 =?utf-8?B?UHVydnVNNyt3ay9lbEdMcXJtajFQVklKM0NEQkhDc2JocUozUnB4Z2hGeUxl?=
 =?utf-8?B?MGJuU0RQYkcvdmdSbWIwU21oRTduMVNwOFFHMnpCUWxSc3dYTGpvc0QzWjdJ?=
 =?utf-8?B?NFhZZnhUUlpqM0ExYmI5SExxbE00S09talJmNDN3cVVOVjIrVTBKVlBGeExO?=
 =?utf-8?B?WUYxNnR5UVM3SWM3eGgzWGNiWWY1MEg3WkpneHArWkJtYXJzWnRBZ2VLNXho?=
 =?utf-8?B?OXBSRDR3VGk1eU9GTU5NeEhnVHdiZGJXc3JvdnpXS3Yvb3VjL2xlRFE2bUVk?=
 =?utf-8?B?Z2ZWT2VTempXOXlkR2s5NUJuRGdRT2JJbnVQR1hwVEtRTkk3NENXNVM0ZEhl?=
 =?utf-8?B?Wmg5aVk5VTd4VmlsdzlmTEl2SEtNV3p6eVVvUTNFMGd6SkRNb1dTb1RDcWNL?=
 =?utf-8?B?cnJnNCtOZE9XWWZ4RXliRExGbFlSd3ZmeGZsMXJFekZDWkpaUlB2N3RDYm5Q?=
 =?utf-8?B?M1RTcHIrdDBEdDVSSExVcjZMQWVmdXJuSzlESUVOenU2K2huV2t6aDhsWUxG?=
 =?utf-8?B?VzBuWDh2QkwwN0FDQWJOeUNPRnFsU2pqSzEyY0RJeTZyMTBWQVJVakJxWnJS?=
 =?utf-8?B?c2pOVHFFamFuTmYxOWVabXg2OEU2VklSVHhUUklQN3NMNks0M2lmYmRLMUIy?=
 =?utf-8?B?WmhJdUFIMzJhaFAycWwrTlRoMXI0L3RYYVJOWC81NVFFSkxmUGFwOGdOSE4z?=
 =?utf-8?B?a2h3bUR2aHN6R01ZbUh4dytxMjFHdTNVWDdrdTU0NlVaeWNiQVUra2tGNTJs?=
 =?utf-8?B?Ni9OZ1dCWExyc1dsTnJrQWhJcnVML003KzVVczl4cEJiSndBY2trS2NVVllr?=
 =?utf-8?B?OUVlUTlCOUt1eXlPUWVGYXpCck9zcnh1VTZuRjZOS0xNTFh0QnJQYkU5Skti?=
 =?utf-8?B?SmR2c2R6Wk00L3BPSXdMbnF4YVJlWngvbkpIUFcyRmVnVEZjZUF6SWtCd3Rw?=
 =?utf-8?B?YVJOUXZNcXJkR3hZTmt2Zkd2KzRGZ1lQUWo3MGxveGlocHBSemVGTCt3aytF?=
 =?utf-8?B?RUNZWU54YzFLY01Jc2pnb3Q5dkY5aU1pbk9Xa3dZT01LWTRoTUxVV0JkM2Zx?=
 =?utf-8?B?clRxNFBCcldtVWhJdG9mT3cyT2sycEFCTGVxMVNYYzZlUUNFc2YyS094RWdR?=
 =?utf-8?B?REh0RHRJZ0FPSkRCc0V1WmcvVVpvbkJxMzdJVkgzM3ovL0wvRGloNVJDZjBQ?=
 =?utf-8?B?YjZGNWVDMjVrc09FbWs2ZFE5RG1MaGFxYWZLVndWbjRNOUcwbUxneDhFckZB?=
 =?utf-8?B?bmQ2aUxrbjQ5K3pyMHptZnAyU0dqOXhrS0dYRi9pN2dxdWs0QmN1S1Fmem9V?=
 =?utf-8?B?N3Z4N1ZqcGJLZkZhU1pnMlZOekYrT2lIcWZkMzh0SjFHa256bm1wM2svbDdj?=
 =?utf-8?B?TUIzaCtiZVFiZlpUK2ltek9zTC8zV2pXYVFxUmc2TnRKUWNHYVA4YndzcjBO?=
 =?utf-8?B?SGM0Z05GUEY2M2U0SWIzOEh5OEQ1aVF2SDE2aFlEOEVNM2M4Kzh0dU5jUElX?=
 =?utf-8?B?NDJ4aEw0cnJnRHhiUWIzSE51OE9hWkpxR2NsSWpOdFMzUytxenhrcStmMTA4?=
 =?utf-8?B?UFI3V091TDlwaHFYZjNaVlRuZDJXQUdMUzEwVmpFU01jbjhtS0xSMHdYMXdB?=
 =?utf-8?Q?NiMLK5e1kPXO/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekJ2UHJBL2ZzdVk5N1lqZytvbTJGM0xUQmlxejZxSEdISXlWRER4dlh5Mm42?=
 =?utf-8?B?TnZkekY3VVZQOFUyZ1hPLzdDUnk1YXdNajFMUlRJYmwrRTNLYm8vZG9NU1NU?=
 =?utf-8?B?MFg0YndqcEJJQmEwdnJtTVlPQW85M0s5dFBSUHZUdjZUNEJzRnVhRXVYaVlM?=
 =?utf-8?B?ZUg3Y2JkNUxIanNjbXZtd2RjOWhXdWc0dXNKL2tZczRCc0hCSGJCNk5neTlw?=
 =?utf-8?B?QVRmUkVqcmM4TzJHSklaUlJQdzc2MHY5ZmtMR0VpTUYvYUI4UWZuRVZsR0RZ?=
 =?utf-8?B?SG1GRllHSm00VitUY0lZeDl6c0xENW9VTklMQlArSmV5NGFTZzl4bVlLOWRN?=
 =?utf-8?B?WWZlRUFJaTJ2WUNQekowNTJGdVg0WnpZVUpMdzhYN1g1cXI1dnJRaUVhQ0Vr?=
 =?utf-8?B?WUF2RFJWNFhqV0FzNXpXVTNBVGx2cXl2dzFmWklZV2tZdTdOTzZRZnladndi?=
 =?utf-8?B?ckhRYnNoaXppangxLzNWdzVacURIaDkzbFVGMktZdm85ZFc4QkY3Rks2U2Vo?=
 =?utf-8?B?ZkxxbWRWU1VTZDk3ZUQ4YWZ4aHF1UU5kKzVWcE82MG9ZZEpWNlBITDM2ZXl0?=
 =?utf-8?B?MjhVZ1A3WkhIRFdiUEl3clY2ZEdkb3NITHRkazJybVpLNUk3Zm9nNytwK0hK?=
 =?utf-8?B?bWtCeThUVnE2Qjdjem41YzZrcGJUbzFzUjlmWU9yNTJQNlY1NTluU2dOd1Yr?=
 =?utf-8?B?S3hHa2R2NTBmMElKMy85YlVYQnJUeCtMWUozQlVyYlFOY05NMzgxSkJPbC9Y?=
 =?utf-8?B?dFgxSkJ5RzFQUytqZlk5ZnphdS81aUcxRHB4aXFmQllDV1ErNmQ1cGpLd1o4?=
 =?utf-8?B?djRWMm1leEg1UWlMdXRmRk11RldOTDVHSGRHUjRHZWRxTUF5aXhLVllHWTRK?=
 =?utf-8?B?MEtHWXdIYjhKeGFqQ3R6QXZGNFZLWmMyZ2ROQk1YSXVtN3U0S3FLeWFjNUZN?=
 =?utf-8?B?VnczRGpSWloxc0ZRaXRmNDZDV1BtRVlUTm95VW5UWDRJZzdNNk5Ec2lQODF6?=
 =?utf-8?B?TmtSQUszUG1rRGVod0FIUjlBNEt1NnhOZzlPeVJ1Z0N4LzhPaUtCaEFwWW9z?=
 =?utf-8?B?OFA0ZFhiT2ZQQTVQYlh2bEEvajJSc2grWEN5b3R4UmkvWDU0cWdwWXdQM0JZ?=
 =?utf-8?B?MmlTNzRIM20zQjBpdFRhaGhBMDZicENCNkVDazRBUnhrRnlhRjF1czhJN2x0?=
 =?utf-8?B?cCtIck5hNXduZHIvZlROY2M5ZzNOMzgvcEt2OHFNTFAwUjFJTDhNcnRTeFE1?=
 =?utf-8?B?TVI3VG1CMGFxT3JRMWcrZ0E0dzV6NjVkSmwyOTFTY3ZDKzczbGd1cHNSQ2tW?=
 =?utf-8?B?NEcvVmNQa3RHM2dtZkpGOXk4dHZsTmNhcTk0QUcwSXZCTjR4Z3JZeURkNTh2?=
 =?utf-8?B?dW9LMlA3WVhVL0Q5eFhqa1daMmVVYm54bDZKSk1GbEN4OTFBaUZWMkVCM0py?=
 =?utf-8?B?ci9aRU41NU4ybTFhV0dhSWd2NjM3MVptck9HUktzeE9nL2U4d0xYcW45UEdy?=
 =?utf-8?B?NTBmUVlEbWtsaERpR2VTR2Myay9FdFJLTGM0RTFkNjFuM2dwd3NseWxYSG5r?=
 =?utf-8?B?M3lSa1RQZVRsa24zaEpzODk3alJGVmZpREpGdVRlRFFVbE5XMG85emMzQ1o5?=
 =?utf-8?B?U0ZMSGNZMm5rRHNEVUVMdmFVcGl4RmNJMkVuU0tPTVlnU3MyNE5sMUdVb3Nl?=
 =?utf-8?B?VmozQ3lRbFJUaEVoSDRFNW02T1RPNGhtS3N3enRLbEsvczhlTFNKQ3JNb1NV?=
 =?utf-8?B?Z1BZaGxsK0xyNms2YS9CU2tQVEVHbGhkSm5rb1FmemJ6bW1PQSt1OFlMc2E1?=
 =?utf-8?B?TkoxdTRKUGNydHVhK0Rsdmg0YkMxbmIyRzNBbWp4WTNhSlBXc2Rwd3VrNDUr?=
 =?utf-8?B?OHdpOWRlYVp6d1cyZ0V0SE51aU9CRVdCZ0UvY3pVTFNWeG5WRzR0Vm1yY2xH?=
 =?utf-8?B?azRaWThVZTBSVHoyM1FWbWlQYzZMVVE1cjd2cDhoOTFhdlJCY3EzR1dZYUxs?=
 =?utf-8?B?N0d3bnl4UEIvNVhxYUZNNWY1V29wSTNkbnRlMjlycitTb3I1NTBDY0cwQzBH?=
 =?utf-8?B?Ylkxd0hQUURMMUdvZS9XUG5WazE4bHpQUGhCUWh4amVZcTBDUXZNUUN2S3dm?=
 =?utf-8?B?Z2J6VFRQNFd2bjNYc2NmVTVrNU9WeGxKOE1ld0Fib0JnQzBobWx6UDZTRjln?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6393a76-0e6b-4579-22ce-08dd62624a79
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 19:07:25.6455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fen26SXpfhrM3AieISVxHtONJu9hAqEK+n7kQXPobTizYS3HjjNJBoqa3evBYDZFN3CvWqKd3eJSbzib+0vlBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5808
X-OriginatorOrg: intel.com

On 13/03/25 20:39, Paolo Bonzini wrote:
> On Thu, Mar 13, 2025 at 7:16 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
>> Improve TDX shutdown performance by adding a more efficient shutdown
>> operation at the cost of adding separate branches for the TDX MMU
>> operations for normal runtime and shutdown.  This more efficient method was
>> previously used in earlier versions of the TDX patches, but was removed to
>> simplify the initial upstreaming.  This is an RFC, and still needs a proper
>> upstream commit log. It is intended to be an eventual follow up to base
>> support.
> 
> In the latest code the HKID is released in kvm_arch_pre_destroy_vm().

I am looking at kvm-coco-queue

> That is before kvm_free_memslot() calls kvm_gmem_unbind(), which
> results in fput() and hence kvm_gmem_release().
> 
> So, as long as userspace doesn't remove the memslots and close the
> guestmemfds, shouldn't the TD_TEARDOWN method be usable?

kvm_arch_pre_destroy_vm() is called from kvm_destroy_vm()
which won't happen before kvm_gmem_release() calls
kvm_put_kvm().


