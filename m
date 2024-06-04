Return-Path: <kvm+bounces-18729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 432358FAAE1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE0F328D781
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA7313DDC2;
	Tue,  4 Jun 2024 06:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VuZgpL7m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB26137C57
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 06:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717482755; cv=fail; b=dOKyKqJs19RbYVErghj678FGixr46VH1FYySpU/hkkUcBVuPw1IStENe2G5t2JW9fbECloiID7xlxoNCp9i1UM/d9k8+Q+2mK01CdFeIXxLdTsf2byKLUb01omhJZdDpeE2Pweh/YAtUb4Z5/rSUr4bhtWkWp+OueEvpTcP0BUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717482755; c=relaxed/simple;
	bh=KvbWUWK4PH5WBnPNpdWHZ0020IVVC7kyKiespahKF8o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QqSU7+pomVuGZBVoJhzkqUnCXZCpZvo6NyMx1gaA1gcO9xNqONQN0QSBCQPYYRjV/hdnVjQ0MU0VW6I73/5gv4qanIH7y9/sPYAYZBF54YQ2CByIgnGXXP/iCfppR70411+J0khgn0ttFOYnWW+I1kENVlRpdQLuVixZ9x389Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VuZgpL7m; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717482754; x=1749018754;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KvbWUWK4PH5WBnPNpdWHZ0020IVVC7kyKiespahKF8o=;
  b=VuZgpL7mnQTqmYxVLw7yEXzIDnzwxnnFEJCOVSpFzp49TWph89b880of
   J1MbBF3F09819O+YC/ieL8mxpYXWwIqFfFK0mbHzKjpE5j5xjzBnXSbk5
   SfqhFXhU5ArxutD3PxE/Xt7Or3mNCkBirgx01/AxY7eyIR0RPL60VOP45
   ROVIZLvvVtBucAn7YmpzQ9mL0japm9hFvA/xdbulDk9j7qt+KEc1Xwhxi
   ctUF/YPAGS9EU/PBN8c5W4r1RuLuUE1XdJ8XLh6vc5A3mIxdlSPl9KsJz
   FpnbAXyHv/GXWBaomsbWWgyMrJun8E3CsagVnne0EdwnYojthAmmEgABd
   A==;
X-CSE-ConnectionGUID: rJtp/Ry0REGaqCZy5U8wUw==
X-CSE-MsgGUID: sqydPQFjRyapiBE6152sYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="14131053"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="14131053"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 23:32:33 -0700
X-CSE-ConnectionGUID: FeiaA29CT+mX4Od4YovWxQ==
X-CSE-MsgGUID: YM27IljLQCe2LXIitE8WIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="74614848"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 23:32:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 23:32:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 23:32:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 23:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHr+wdP7oJDTdLalwD0CslkSVUD3nkOVEbkVxMIijBrNeytIOL7Iqm93pUfygwSrtlKfszUGDprc95+7xHSqIeVBEOOCnMLiC0DpOhSpjiT/D1lDRTH+ZfFAr5mEsSfoeHxqZ8CEo8pqTaTx/8e9G+nml8sx7uEadwjyfthGd7+t0vIWWkZ/EBMNSN39MmBy9X5SC34htAGaEfEVpb4O/K9uKtV9beTygXB5clMq0gO6FZGo0zKdFp/FUnJr/fiIBQqll14vkiOkPQSJAiELnBooTd1n1BIur9saKNQ23Bm3GIhg/oay+LMUgNtBwpBwQXiKh0EooorQWR+FMsOZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SB5to0e7h4ctlQs6hj7RS+LeSF1GNCyzstdIj2hJAhY=;
 b=H2iefdo4Quvkx2SO7h0M3Xa8Sn19pL/Rm0u8r1XlQcTqINVQAKHJAhVQB8/6OWyzapsmnGiEA2xfD829MOWmpfB6gHOLtRtChTyF6iar2CD+El+MUHvtnTE2uqt8/rwvqnLFFXrtSWmBug0V8yM0BB7C/ubLuBhjew65ashtmkMG/YZsZPD4K7vVHfMM+m8fOuWJ9jOj89xpnbR8v/9nM9REQdp7rWIADYyEnAdJYkkFU4P9DE4k5yExxpyDxjwmmJVMw1YJki+ltiUM/lCzT3SOq5PdVFJouuFV2f+A0IBk6A3br0pytRrNu+1yPSCGREWDChQBo93sAaqAq8DVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by IA1PR11MB7892.namprd11.prod.outlook.com (2603:10b6:208:3fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 06:32:29 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%7]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 06:32:29 +0000
Message-ID: <05be79b3-f388-7c12-af60-3a679a63db15@intel.com>
Date: Tue, 4 Jun 2024 14:32:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v5 37/65] i386/tdvf: Introduce function to parse TDVF
 metadata
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>, Cornelia Huck
	<cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>, Michael Roth
	<michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann
	<kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, Chenyi Qiang
	<chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-38-xiaoyao.li@intel.com>
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
In-Reply-To: <20240229063726.610065-38-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0099.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b4::17) To SJ0PR11MB6744.namprd11.prod.outlook.com
 (2603:10b6:a03:47d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6744:EE_|IA1PR11MB7892:EE_
X-MS-Office365-Filtering-Correlation-Id: b532ae17-da04-4494-698a-08dc84601b99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WW1pMm1TYlJzeEIvYVFUWVJySUFKNjdNUEdSWFdFMC9VdEFBaVk2Z0UxMjkr?=
 =?utf-8?B?VTFKZG80S1hXS3V3bGx6VWpKcFBzeUNYSThubHJVRjVtME92MkppcTkzTVdD?=
 =?utf-8?B?dFdOMGFhWWFzT0dpNmNpcEIvV3VmNWYzaTZpeWkyYWFRSGY5MGdQODQ0d1RD?=
 =?utf-8?B?RUJYcGVLZW1oTS9CazNkOUtSTlR2MjlOTWZ6NEhHamltNDV5OXA0WVVFTUVh?=
 =?utf-8?B?YnNLZDdhRjdqeWJicXBROUtqSGpJM0FvQW5zUzl5cE5jRU5mcVFIRFZQRjlw?=
 =?utf-8?B?UWp3am43Znk1cEZBdTdrOW04SWF2RkNEQVBLamxWZWc4V29lRGc2NExoRS9y?=
 =?utf-8?B?Sk5JV1kwRWtNM2s1V2FZTkZ2UXQ2QTBmS3E1M2NwOHI2M0E2eVNzSENQU2l6?=
 =?utf-8?B?UkhGZG9ONnR3OERxdlV1MkV4TUFhSGZNdU0vbEhsL0taWDBzTUZkVTRvVGJ3?=
 =?utf-8?B?OEdmalNlZTk2NlB0SUFteXBENHVid0x3S1NCTVcwTmZXVXNnL05hbDlXWFAx?=
 =?utf-8?B?Vjc3RHAyeHFob1cyVlovRHBRYXd1QmozeloyUGdQRkE3NnJHSkFWL0FZZTZY?=
 =?utf-8?B?ejYwdnRqY1RVMVVMK0g1Yyt3YU12eXhDY21kRmM2WlFXRWJBM3pwdlZFWGcr?=
 =?utf-8?B?L0hNT3pESHpCV1d4dG9sSCtOVkJra3RtRXlvVUhlL1hwYmhiVE1Oa2FDZFhD?=
 =?utf-8?B?NWZNeVp6ZVdmQzNrRnc5ZnpmVkhHcEgrV0pUekhTMytjNm9RZFc1M0VPTzZh?=
 =?utf-8?B?dzdmcVB6cHZtcFpSaHgrQ2JsMXhxM25ySzBhNURROFIrNEVGMHBjWENSdU5s?=
 =?utf-8?B?TE9oa3YyQ1VlNDdCVHA0bisySmhka1c4WDBYbkhYRkpBSXF4S2FNcjNUSFR0?=
 =?utf-8?B?SVUxVXRod0tpSmFlbnNMTFB6dGNxRysvKy9lekN3TllzYnFLdjg3VkFPU0d5?=
 =?utf-8?B?b1lnbmEzemU0aUdURTJlUWJQVEsvNDNUMU1LV041ejdGVEUrNitjTk5NT3Vq?=
 =?utf-8?B?U1FlTnpnemg0UkE4MG5Jc1VZbzJOQ0dpZVEwVXh3L3FFekpFdjlDTFUvRmo0?=
 =?utf-8?B?aGhvSUxDYnJQMm9LUjU1WTl3NzBEQXBNVERtaUkwVkFXWFg0NWMzUUE3S3Iw?=
 =?utf-8?B?WjNBZEtjdThFR2tVLzZla2pIVmhuV1FRUDZoWmY3cERsWG5BT2J2Z3pQbVBN?=
 =?utf-8?B?aVBHNDFnaDltWE9jR1hqMFpKTXZMR3c0U1dtN1lxMjRCK1J4eE03K2tnZlZ1?=
 =?utf-8?B?VUQ2eGwraVlIUXBiMVd5UHNENkZFNlE0TWJwSHZMM0tFOVU5aGhXR1FFdU9l?=
 =?utf-8?B?RkF5ZExKTnNuOTRUVFQyUUwyNHdEV0xNUmVxL1hxTnFvZm92RS9HM3Q3OTBK?=
 =?utf-8?B?U1p6RmJqZ1JXZUcvTHFzdTIzZitQa2FNMUh2aktFUGt0Q1RFTE9naEgwVUZy?=
 =?utf-8?B?ZVFFMDh3MUxWQmlvQkZzVGtQV3NuYWpWQlQzcGJtWUU2NGtESVU3NHp0UUd5?=
 =?utf-8?B?eEZodStJYjJWL0l0NFRKQlNuOGZxUjhqZ3BxeE1iYkhZcmplOTNRQm04QWV6?=
 =?utf-8?B?Q0hibTVmdXdPdFJFdW9OVFA1eG04SjVFdHNiQldJV0s0UUlvLzdXaHJrR25w?=
 =?utf-8?B?K25ZcC9NYW8vNGdTOHVTWFl6Z21PVTYwSFhlbW80cUFncWNNbnA0NWhEclFa?=
 =?utf-8?B?TkJ0ZHdNWTlCQnZYbEtyU3BOdkdQbkQ5WGwvR1lhb0huRTF4M2ZTK3FvRHcx?=
 =?utf-8?Q?8gFYJGwW/hT33Bn5PaeNv7Do6B+UdejcdH/iQiC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVlGREk4OU1mcnhKekpaUDV2OUorc1pYQ1BncTluSWNvS0RyQ3lNM2R5WWZJ?=
 =?utf-8?B?UHpVaVFvc3VEMS9TbFkxMXpNdE1wQThWVHhKMXpCRFUrRTV6WiswZjJvdS9o?=
 =?utf-8?B?TUtETEVQMXpUcmdZcWZLKzlVYmhVYzBEWTBGYlhVOU9HVzhDM1UwV3RiNHJY?=
 =?utf-8?B?bWs3Z29GSkJxODFRS1lUaGEzTjFhdUxaVlBydkk3Q1hneGtYOXN5bTJBaW1R?=
 =?utf-8?B?clUvOUt6eXVnMUwvU09wWi9iYVZCaWlBNDB6VW9ZYlBvTGlmOXVNenpyNVRn?=
 =?utf-8?B?Mnl0ZUVkYk1pTzZIVjdsZ3dUbGpQNG9mQ29GZm9SK1Fxb01reDZnR3MxWERo?=
 =?utf-8?B?dUVnMjhFMGpHaU1TU0FRbXdlSndXYTRhdHcvVTE1WmNmNXZzSThBa2xYbEFX?=
 =?utf-8?B?VWx1YkJISndOOVJVeG1xelF4L0JkNE5WWXA5SUpJaUFYc1RsQitCRllPbmFN?=
 =?utf-8?B?VjhxWGp1a0k5ek15WU44YTZBN3hsTWxJbkRLalJyZFpRbFNheG9aU2REYmRo?=
 =?utf-8?B?M3JRYVpHcGpCOW0vUWJIVmlabndyZWJPWnpnMXduSHoyYUhWTlVrTUtLNnNV?=
 =?utf-8?B?c3dpVFA3M2s1WFBtUy9WMldCc242dGUwZks2ZVU3OTB2c2pRSUFXcGJkamdv?=
 =?utf-8?B?RTJRSmRaTjMwNEJ4SzEyaXkwd1BjNEh3NXBkSTBXcFdWM0tienhpUzNUV0R0?=
 =?utf-8?B?MzNMR0hScmtkNExDT3kxUVZYVXU1SjRoQWVINDhTaSswazQ1VlBFL2ZoUWpk?=
 =?utf-8?B?WFB5Wmk4UVNtWFE5Vk5EVFh1OVB1V2dPUk1UT1RJSVVzeG8vUTR5a2JTMDh0?=
 =?utf-8?B?RXRZYmJuQ3MvL2R0NDIxQjQ4dWFkYXdJTHI0RWxjSHdoQXVIQmZyVk1yelJL?=
 =?utf-8?B?bHNMOUo3c2FGN2UweWIzd3Zyb2wyaXZXd1k4VnNWZ211MVBZeC9jUWRpdVBK?=
 =?utf-8?B?dUpUN2NoZDdtNUw3d24yUUJURVB0SUVxdDVEMHNaZmdZNUY1dDdDUE03aE00?=
 =?utf-8?B?Wlo2LzlzNWhRcXVSQmxSNnczckhlNFNjd3F0cW16MmhUdnlXL3RwV2NmUGxH?=
 =?utf-8?B?aGpxR2VRSXY4T1RpN3ZMKzRBNzVqVUNucEo3MHNLQStycjhwVUtxMTlwMTNZ?=
 =?utf-8?B?UkY0NXVscUt0WmdnbjgvVllCaVhQWTBBUkhxaU1QSHdRd2s5VDVMVEt4dVlo?=
 =?utf-8?B?UzRBTTlsckN0VnUxOGUwQTArZldRZVp0NlJ2L0xZc3hGZkZTbU5mTTBkK1Jo?=
 =?utf-8?B?VW1LeGxWVXlLYVZDaCttS0hNamJNMko0RmpJM0cvRGh2ejBZRktxNDBjQnRI?=
 =?utf-8?B?ZllEUXNYbENkcHlsd3VjM3UwM0s4WWVmSTRlWnZKMm9oeGROaXJ5NXg4OUsy?=
 =?utf-8?B?WXhqK1pPMWF2QnZrb2sza1lFNkdoa0RTWnBSa093SnFwbmFrSnpNNFgzMk9x?=
 =?utf-8?B?K3hZRGoxcG5HRnpaRmp6Y1gzalp3Umd4MWpEalYvOVMyWkpWMUZ4RE00azI4?=
 =?utf-8?B?eDhQUURhU0Y5OUV4MytlNGd5LzN4TjVEM28yM3ZIcGN0dlJ6dU95UU5JQkZS?=
 =?utf-8?B?U1ZhcnNhOTNKSTNjdHBic3Y0Q2NGMGZ4alQ0OXFTMzFHV2JCc3VMc0duZHpE?=
 =?utf-8?B?NnArQ2VBelhRKy83MldBSURoOXcrUWpzUmJ3SzlMV2dTcUw1MXFTbXZ5cGpC?=
 =?utf-8?B?Slc0dW1sVkNnSXZlUFE3Z0o2NVhRbzNWeE42MDFid1lYWWUxSkdGZXZsWXBC?=
 =?utf-8?B?ZWMweStpRDR4bTF4d0pvZEpEeWxXU1BRb1ZmUkM4RnNEUUZJMlJicHZBTUp2?=
 =?utf-8?B?cVl1TzJEUXlvbm5sMU82MFpSbzFiNTh4TDJyZk0yY3Y3QXMwUjIwK1FQUis5?=
 =?utf-8?B?RDY4elB2WWMzZm15amQzUFhFazdId2tuM2dyV3J3Yml4SmNLSWErbWZnajVw?=
 =?utf-8?B?eXBsd1ZickZxUFVtaW9ZTmNmVmhxMUw0eldtSDBDTXdFOURuOEpHUzAyUHJp?=
 =?utf-8?B?bUw1eFVkYlpsNEVyam9SUVpwT0s5OUIxQ21VVm5OVlVIaURoa1A3bzJ4UlZw?=
 =?utf-8?B?K1BIaXFKNTFqWlNSWnA3d1ZFeUdQaXJ4UFg2TjRxN2Z0NnN6b0FnaDZ0V2Zw?=
 =?utf-8?B?dlV0QUFXMldhcjlXaldvRTM1dDQybjJIMnN5M1JoMG9oNTRsajhZZWc5clZK?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b532ae17-da04-4494-698a-08dc84601b99
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 06:32:29.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bF6kp7UEk36lyujR4fHFxbGCWuTBVOewv1G3NsYZALFLlMgetUscQArUl1VgaN1C0cRWPq6nzDI8LN6uvVnSC1cP1K8MEwZGwDE/mBq1l4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7892
X-OriginatorOrg: intel.com


On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX VM needs to boot with its specialized firmware, Trusted Domain
> Virtual Firmware (TDVF). QEMU needs to parse TDVF and map it in TD
> guest memory prior to running the TDX VM.
>
> A TDVF Metadata in TDVF image describes the structure of firmware.
> QEMU refers to it to setup memory for TDVF. Introduce function
> tdvf_parse_metadata() to parse the metadata from TDVF image and store
> the info of each TDVF section.
>
> TDX metadata is located by a TDX metadata offset block, which is a
> GUID-ed structure. The data portion of the GUID structure contains
> only an 4-byte field that is the offset of TDX metadata to the end
> of firmware file.
>
> Select X86_FW_OVMF when TDX is enable to leverage existing functions
> to parse and search OVMF's GUID-ed structures.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>
> ---
> Changes in v1:
>   - rename tdvf_parse_section_entry() to
>     tdvf_parse_and_check_section_entry()
> Changes in RFC v4:
>   - rename TDX_METADATA_GUID to TDX_METADATA_OFFSET_GUID
> ---
>   hw/i386/Kconfig        |   1 +
>   hw/i386/meson.build    |   1 +
>   hw/i386/tdvf.c         | 199 +++++++++++++++++++++++++++++++++++++++++
>   include/hw/i386/tdvf.h |  51 +++++++++++
>   4 files changed, 252 insertions(+)
>   create mode 100644 hw/i386/tdvf.c
>   create mode 100644 include/hw/i386/tdvf.h
>
> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
> index c0ccf50ac3ef..4e6c8905f077 100644
> --- a/hw/i386/Kconfig
> +++ b/hw/i386/Kconfig
> @@ -12,6 +12,7 @@ config SGX
>   
>   config TDX
>       bool
> +    select X86_FW_OVMF
>       depends on KVM
>   
>   config PC
> diff --git a/hw/i386/meson.build b/hw/i386/meson.build
> index b9c1ca39cb05..f09441c1ea54 100644
> --- a/hw/i386/meson.build
> +++ b/hw/i386/meson.build
> @@ -28,6 +28,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
>     'port92.c'))
>   i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
>                                           if_false: files('pc_sysfw_ovmf-stubs.c'))
> +i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
>   
>   subdir('kvm')
>   subdir('xen')
> diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
> new file mode 100644
> index 000000000000..ff51f40088f0
> --- /dev/null
> +++ b/hw/i386/tdvf.c
> @@ -0,0 +1,199 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0-or-later
> +
> + * Copyright (c) 2020 Intel Corporation
> + * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
> + *                        <isaku.yamahata at intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +
> +#include "hw/i386/pc.h"
> +#include "hw/i386/tdvf.h"
> +#include "sysemu/kvm.h"
> +
> +#define TDX_METADATA_OFFSET_GUID    "e47a6535-984a-4798-865e-4685a7bf8ec2"
> +#define TDX_METADATA_VERSION        1
> +#define TDVF_SIGNATURE              0x46564454 /* TDVF as little endian */
> +
> +typedef struct {
> +    uint32_t DataOffset;
> +    uint32_t RawDataSize;
> +    uint64_t MemoryAddress;
> +    uint64_t MemoryDataSize;
> +    uint32_t Type;
> +    uint32_t Attributes;
> +} TdvfSectionEntry;
> +
> +typedef struct {
> +    uint32_t Signature;
> +    uint32_t Length;
> +    uint32_t Version;
> +    uint32_t NumberOfSectionEntries;
> +    TdvfSectionEntry SectionEntries[];
> +} TdvfMetadata;
> +
> +struct tdx_metadata_offset {
> +    uint32_t offset;
> +};
> +
> +static TdvfMetadata *tdvf_get_metadata(void *flash_ptr, int size)
> +{
> +    TdvfMetadata *metadata;
> +    uint32_t offset = 0;
> +    uint8_t *data;
> +
> +    if ((uint32_t) size != size) {
> +        return NULL;
> +    }
> +
> +    if (pc_system_ovmf_table_find(TDX_METADATA_OFFSET_GUID, &data, NULL)) {
> +        offset = size - le32_to_cpu(((struct tdx_metadata_offset *)data)->offset);
> +
> +        if (offset + sizeof(*metadata) > size) {
> +            return NULL;
> +        }
> +    } else {
> +        error_report("Cannot find TDX_METADATA_OFFSET_GUID");
> +        return NULL;
> +    }
> +
> +    metadata = flash_ptr + offset;
> +
> +    /* Finally, verify the signature to determine if this is a TDVF image. */
> +    metadata->Signature = le32_to_cpu(metadata->Signature);
> +    if (metadata->Signature != TDVF_SIGNATURE) {
> +        error_report("Invalid TDVF signature in metadata!");
> +        return NULL;
> +    }
> +
> +    /* Sanity check that the TDVF doesn't overlap its own metadata. */
> +    metadata->Length = le32_to_cpu(metadata->Length);
> +    if (offset + metadata->Length > size) {
> +        return NULL;
> +    }
> +
> +    /* Only version 1 is supported/defined. */
> +    metadata->Version = le32_to_cpu(metadata->Version);
> +    if (metadata->Version != TDX_METADATA_VERSION) {
> +        return NULL;
> +    }
> +
> +    return metadata;
> +}
> +
> +static int tdvf_parse_and_check_section_entry(const TdvfSectionEntry *src,
> +                                              TdxFirmwareEntry *entry)
> +{
> +    entry->data_offset = le32_to_cpu(src->DataOffset);
> +    entry->data_len = le32_to_cpu(src->RawDataSize);
> +    entry->address = le64_to_cpu(src->MemoryAddress);
> +    entry->size = le64_to_cpu(src->MemoryDataSize);
> +    entry->type = le32_to_cpu(src->Type);
> +    entry->attributes = le32_to_cpu(src->Attributes);
> +
> +    /* sanity check */
> +    if (entry->size < entry->data_len) {
> +        error_report("Broken metadata RawDataSize 0x%x MemoryDataSize 0x%lx",
> +                     entry->data_len, entry->size);
> +        return -1;
> +    }
> +    if (!QEMU_IS_ALIGNED(entry->address, TARGET_PAGE_SIZE)) {
> +        error_report("MemoryAddress 0x%lx not page aligned", entry->address);
> +        return -1;
> +    }
> +    if (!QEMU_IS_ALIGNED(entry->size, TARGET_PAGE_SIZE)) {
> +        error_report("MemoryDataSize 0x%lx not page aligned", entry->size);
> +        return -1;
> +    }
> +
> +    switch (entry->type) {
> +    case TDVF_SECTION_TYPE_BFV:
> +    case TDVF_SECTION_TYPE_CFV:
> +        /* The sections that must be copied from firmware image to TD memory */
> +        if (entry->data_len == 0) {
> +            error_report("%d section with RawDataSize == 0", entry->type);
> +            return -1;
> +        }
> +        break;
> +    case TDVF_SECTION_TYPE_TD_HOB:
> +    case TDVF_SECTION_TYPE_TEMP_MEM:
> +        /* The sections that no need to be copied from firmware image */
> +        if (entry->data_len != 0) {
> +            error_report("%d section with RawDataSize 0x%x != 0",
> +                         entry->type, entry->data_len);
> +            return -1;
> +        }
> +        break;
> +    default:
> +        error_report("TDVF contains unsupported section type %d", entry->type);
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
> +{
> +    TdvfSectionEntry *sections;
> +    TdvfMetadata *metadata;
> +    ssize_t entries_size;
> +    uint32_t len, i;
> +
> +    metadata = tdvf_get_metadata(flash_ptr, size);
> +    if (!metadata) {
> +        return -EINVAL;
> +    }
> +
> +    //load and parse metadata entries
> +    fw->nr_entries = le32_to_cpu(metadata->NumberOfSectionEntries);
> +    if (fw->nr_entries < 2) {
> +        error_report("Invalid number of fw entries (%u) in TDVF", fw->nr_entries);
> +        return -EINVAL;
> +    }
> +
> +    len = le32_to_cpu(metadata->Length);

metadata->Length is already CPU endian, any reason to convert again?

> +    entries_size = fw->nr_entries * sizeof(TdvfSectionEntry);
> +    if (len != sizeof(*metadata) + entries_size) {
> +        error_report("TDVF metadata len (0x%x) mismatch, expected (0x%x)",
> +                     len, (uint32_t)(sizeof(*metadata) + entries_size));
> +        return -EINVAL;
> +    }
> +
> +    fw->entries = g_new(TdxFirmwareEntry, fw->nr_entries);
> +    sections = g_new(TdvfSectionEntry, fw->nr_entries);
> +
> +    if (!memcpy(sections, (void *)metadata + sizeof(*metadata), entries_size))  {
> +        error_report("Failed to read TDVF section entries");
> +        goto err;
> +    }
> +
> +    for (i = 0; i < fw->nr_entries; i++) {
> +        if (tdvf_parse_and_check_section_entry(&sections[i], &fw->entries[i])) {
> +            goto err;
> +        }
> +    }
> +    g_free(sections);
> +
> +    return 0;
> +
> +err:
> +    g_free(sections);

This can be g_autofree.

Thanks

Zhenzhong


