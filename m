Return-Path: <kvm+bounces-6371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A462882FE81
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 141231F2905B
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292B11C11;
	Wed, 17 Jan 2024 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQawmJL0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D18C1364;
	Wed, 17 Jan 2024 01:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705455816; cv=fail; b=LvMhKdLLWusIedaeljqCWunLmnCiq8pcmBfcK9oosiDaBhVg0GC2G6TFPwPY52gP93k3+r3GsdhjlsEGHpp/ekwTq+u1s/tKNJgmeesYZGnXmgwK8zfj/hdXxmbZQD+WViVJl2NVd4W9X6VgQ20mpl/55Ik59EmBNUIwMaFFMbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705455816; c=relaxed/simple;
	bh=Mt6fTnrzj2Jlsqc2sWxIEx+kMGVvIO0ApdlmLXO+sfQ=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Message-ID:Date:User-Agent:Subject:Content-Language:To:CC:
	 References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=V7bGDRv2/FqbbbUoXJLjJulcAnosmyLdChKr00e+XPeyuV9nMGxs3N3+d0yEjafNpkqcnOLUM7ARleisEcADItkcUFZ+geMr/qYAB07m1omwjwGsQJFtMZlEyg6N6Z/bSpPEcLCgk6eIHSeCBnZXL76+Rw1kyfIuwswKtMsTLOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQawmJL0; arc=fail smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705455814; x=1736991814;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mt6fTnrzj2Jlsqc2sWxIEx+kMGVvIO0ApdlmLXO+sfQ=;
  b=NQawmJL0tHOPNXiBxiPMmUJOLM02Gu7KIBfRJ0lvfslaTUAEG77+8lDL
   zaiOz7RTFIe0zF2ak6Gothr2kBFPT2p2fZyyQf4LBOXF6n/9sxe2OfkvC
   rFkVdaYFEoOkpX8YxokMLrQu7fyCnSx218Hc7l7OU0la0yQqoBzCveCav
   P+4+2NGJoneXJkC8Lx5A3zzesuePctq0Rln57fPxHafkyV0e/pZcKD4py
   k64DADHEZjs/8utUqS5LWseRZVW+ZWaJAXsYCnMvT8Pske/0PUtZGrZga
   +qMLAMXh2Wo3A+zDG8ZXhnG6/ujvoT2xtrgqEhdTxwLAdSoIBtqFRb/W1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="464326694"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="464326694"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 17:43:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="733802787"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="733802787"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 17:43:33 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 17:43:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 17:43:32 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 17:43:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIl+EGXQisv66vUdFuZyYLxhrGuyMo++JZ8PFNnXKzckrVjayYOk+o8zUiSsYkLJl8eSkXOr3ac3kpqttqjRMznnMdDaL5S7GrCv/0SoeVh9s72pRDiyFPyC473hOEq0OedrOzOo4r0m7HrDEz7RtzWfKcDm0tud+hnBz6uZS9ixt2ABOWj+KAfQo6FzNEoDYBYlW9YiZ6MUdI9oUD+ZPw/RrgJahrIBYTi4LBTctSPIefsDbq/H5KiEd0JsbL8V8mIOqtoGU3ikoQPxyIdz+euzv1Q+/QxRcUD8ix+r2TqDqQD2EafXc6Et4sX7Mgs8+aKgDG+QkcEEXbE/Y/O82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68wtD9Jfe/kuRxP17+RPbJXaQOlsqYeMedZIG5XrBys=;
 b=m9u1soGOYX1xAYAxLYkM8m15rbfwp0+LgloWD+zrCj4L2d8Ymzi8kwxwj1D/xCXfmGK5NurGQ+/7tx1ZvjCahrmoVJW1/10be133Ih2A2pVTSORWSE4P/XddfryM1C4QhDDfoQxB00UGDKlmW/nzEOUHvwZol8Z0N2Rw7LBFixEhfckxlX08kE+9WP6cq6WV7at/TAcMxoNmfTBdoyCWytpkxarMhXvBAua01JMouF2XhG6plNEOBGGD/k+cBWWAeLdxONtqDQMeoYtQWhMAU8M8p+en6/EGsx1ZMB+1Nv/W9bCz+NDv8bwPg6hsQeMwcPOCF0DIfFLD/88txiNo/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB7571.namprd11.prod.outlook.com (2603:10b6:510:27e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.18; Wed, 17 Jan
 2024 01:43:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.022; Wed, 17 Jan 2024
 01:43:24 +0000
Message-ID: <18f3d0e9-316a-49ec-87fd-3fd16828c7f8@intel.com>
Date: Wed, 17 Jan 2024 09:43:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 24/26] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Content-Language: en-US
To: Yuan Yao <yuan.yao@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-25-weijiang.yang@intel.com>
 <20240116072555.jnj74yairx7add6i@yy-desk-7060>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240116072555.jnj74yairx7add6i@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 3654d3ad-fdf9-48bf-2936-08dc16fdb1c9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nUxEL7xIhgPzzcEoDNmMBp4GXI+NKOGSJDw+d63fN5p4eAyRJjvFFa/XE8e56GDMcH9fVTQss8BBxLMDg9DzuFpWt4rD/bLH04/CgC4O7t3i9ty23iyzx8I8ICIwdz9M7wNWIzCDq1epXZ6Vfdu2uKXzQEVUcedK/TyuHLmqIi5+ih8g5FrAhzUpY7cU2R2lWEN1pixlbUCIXOSUg9i/x8ApeVa7zo524TXqfduoP6GFStu+guALJ5cohixy9aNh8AQAMK+f3u20UoOgGfhfNs2t6uE4U/PyBBK4j4nm59jy47BN8ypz9CVJGHElxlKd16bBg5zOZLieaXmJhZ+dqWDnNpMkdTfN26LFmxTgXlj30pyS4YCjBgCInbUAFgO35CnM0xtAmBac1XEx+GZKZg5c4r3ll4/FqFLKpgLnZYVjKnxn5eEjSoTB4Ri+rz9KW6gnDfxlasDykceJoTLgLp3l9MSF86QXKyNsWgXMxa5LSy29qRVuYQNfOXfvA7YUk+WOAnvjWPgRj9hzx7vm2wd1eD25JUhz7B+Up5afuc1tuJm44Qmy8dQXKGkOxYRfVBjLZhz2H0dJq5OmPv8fflGJvUSIXYC2v9K+DWwjoncA6P22pIFXiVN8KZQa8iPIu6Md8GPUBH6kyC1NC4Rvw69FIuYSds9i+gHd6qPyrE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(6486002)(6666004)(6512007)(6506007)(26005)(2616005)(36756003)(31696002)(86362001)(82960400001)(38100700002)(83380400001)(41300700001)(478600001)(53546011)(5660300002)(8936002)(4326008)(66476007)(8676002)(66946007)(66556008)(31686004)(316002)(6916009)(2906002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFE4TTV1LzVaa1dXcVZxVWZLc3FFZWI3b2V6aEdjR2R2S3BHdi81dzJLZDJN?=
 =?utf-8?B?U3MxS1BITUh1WFRONUJ4YTdyMGlTMzhoZ243a1kwRkduYVVwSmt3T2VESG5J?=
 =?utf-8?B?cGN0NVVkWjNTVUJWUTZyQ1RkVEMyUVMxbXNrVlZ6U2ttdDM0cnVCUWxpa1Uv?=
 =?utf-8?B?eEdzdlQyRXdBZGozeFVhMVQ3ZWdzekJ2NmFROHU4WDNqUFVHVUM3SEpPVDBq?=
 =?utf-8?B?Vmx0NUhrdkluUFZFczR4Yk5vYjV6MFR0bVE4eFNjek1qMU1PUXEzZFZJM3Nl?=
 =?utf-8?B?OWY2bC80eklYcDQ4K05YWFpwdTRzT0dyVUJSQ3hQNkF2MkxxdHVEcWhSUWx4?=
 =?utf-8?B?NHluYkt5OFJ4VmRzMGFVLy9xZmFQOUhXQkdhWkErVW1lbVQ2Wkh3RDY3U2cw?=
 =?utf-8?B?N2hvejdnR3p1TWZGU0dNNGthSE43RlpVUXFoU1o0amRtam16eU1McFNMOHlV?=
 =?utf-8?B?OE9uZmJNY0tzSmVSTDZmZ09DN0NmekF1Sktpb1VKSm5ERVJJd3EyMkkrOFNS?=
 =?utf-8?B?YlVHU0w2djY3SW92QlkyY1pOdmREbnRHVlpFQW50cGRvMGtCMkZFWG5xaDlC?=
 =?utf-8?B?VWp2aFlSNWZydlVxYWQ5VVNRYm9NQ05EeWsyOUozVlE4QzVRV3pxK01oTVI2?=
 =?utf-8?B?Rzg0Wk1Ga2kxN3lCdzlMM3NKMXY2cWN5My9Hc3VxRUd0dnRGSldxNmJsUnNK?=
 =?utf-8?B?VHlHNzg0aVNrQmZFU0xlMFNPWUFYcGJITGJQT0FIYlIrbmd6UklCUjI5VDMv?=
 =?utf-8?B?ekFNQjBxRXN5WmFBbXRrWWI1c0VoSDlXUktrYU1vNWgwcENvaDRmVHZ4M21G?=
 =?utf-8?B?aTM2LzhkYVZFOCt2R1VCUllMZ3VxMzlTRDdkSXg1T3FEcDNRamRyeXlvSjVy?=
 =?utf-8?B?ZVlRZHArUGFmaDdyNnBMNThMYkxla3FlWWRjQVBrWWZGSGl6WU0zSElvditu?=
 =?utf-8?B?UGtvZjRPMjR3djdKZER0MktGRnZtcVJVMk1Zdm9HOWx3QXZONW1id3kzVDhv?=
 =?utf-8?B?NUJYMzRaZ1J5ZmtqbGVrcWFBUUxsVFEzb0FnZXdmRDdxUGZ0NmdIemttZTkw?=
 =?utf-8?B?b09aaUg0dlBBY1QxYlJVc2daZWc5Y2haT0RkZ1FhNmdZVGZBTk5CMmtTcnhn?=
 =?utf-8?B?UW9GZDc1c0xvS0lNVWZrTllwYkxxYWdhcVkvVjc5MTM5WG9qRkxqYnlCSGls?=
 =?utf-8?B?MXNUSnhLMFBWcHZsYTRMdWgrbExBN1FCYmovb0xub3NocGh0OUhvUEJFR2Nq?=
 =?utf-8?B?Z1FCRXZ1ejg4RTZqb1RNSXdwYTYxVmpIZG5wcFl6U21naGlEa3M0Zis3UU5S?=
 =?utf-8?B?MDgrYmZpY2x0RHFSYnh2ZU4wZDFYQXZlQmRLWVFKU0ZHOGExRHVLa1ZwdFNW?=
 =?utf-8?B?UU85UDlZVmpyTnZRTkliR0FWcFpYNXFQajkrNWxZVUdyNDJmVWdjS2FVNUNj?=
 =?utf-8?B?dmRNSTF3OFlPUmZRaU5TbS9ZOGFkTGg0T09qVkpCMHUvbTJkbVlxVmNITUVY?=
 =?utf-8?B?Unk0MVlqN25ZQ0ZBUGZ5VE54Smdja1Rmckk2YThmc2ZNWlBya0wxbW9xNzli?=
 =?utf-8?B?eHIzNGYvQWY5Y2RSUUlkN0gzSW81dWw4NGc0ZDMwVG1hQWxLeW1rVkRqcU9o?=
 =?utf-8?B?V3cyZnF6bVZXNjczcVljRUJmY0NOdDFoZU9RVkVwdis5WVF6NFUvakNmTWFv?=
 =?utf-8?B?dm00NVZYcTNKc0JQRzhmelg0alZhb0JuZEZCZ3RNaCtGM0RFeTUyR2RSSTRo?=
 =?utf-8?B?ZWJ1ampocHhkWloxK2FqY0FUcUpKbEtYRVBnQkZsL24vOHEzZVI1aDduQ0Q4?=
 =?utf-8?B?NkpMd0FMbm5HcThQeVNNeXg3N0I2Mk9VZnBKU0xyZVVxU0dMNE1rdVJkbGta?=
 =?utf-8?B?YVQvbnFRWm1WNyszUy9JR0xBUm4yOEhFYnJqcDN2Y2FTek1YS0VtOTQ2dDdi?=
 =?utf-8?B?TDVZMTVwVngwMlhFNFBDTldScHA4b2NvbkJvR0JRbHArY1FDWGs4cElnalVy?=
 =?utf-8?B?QlVEN0hmN2Z3M1ZnYzZNdlhoVXB6bERiUFdEdnhsZnZrREJ6ei9NdGxvMmdy?=
 =?utf-8?B?UXVwREFLNjRBalZZODk4RTNHVWYra3crekt6ZlBrMm00NndjSlp6T2xocVFI?=
 =?utf-8?B?ZXE4UUF3UnRsWWV4b0NZa2NFS043SUI5VWVkQnplekoyUW1KSnovK2RaTjNB?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3654d3ad-fdf9-48bf-2936-08dc16fdb1c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 01:43:24.7909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAxGUshdiQ/QqJgDsaWgIBGvwSYg0R17zLRPm70OOvdSO3U45BaH+7/dNowdsaBhtyrPVYIDRA4xd9I3WC1evg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7571
X-OriginatorOrg: intel.com

On 1/16/2024 3:25 PM, Yuan Yao wrote:
> On Thu, Dec 21, 2023 at 09:02:37AM -0500, Yang Weijiang wrote:
>> Expose CET features to guest if KVM/host can support them, clear CPUID
>> feature bits if KVM/host cannot support.
>>
>> Set CPUID feature bits so that CET features are available in guest CPUID.
>> Add CR4.CET bit support in order to allow guest set CET master control
>> bit.
>>
>> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
>> KVM does not support emulating CET.
>>
>> The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
>> guest CET xstates isolated from host's.
>>
>> On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
>> code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
>> error code is allowed. Disable CET feature bits if the MSR bit is cleared
>> so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.
>>
>> Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
>> in host XSS or if XSAVES isn't supported.
>>
>> CET MSR contents after reset, power-up and INIT are set to 0s, clears the
>> guest fpstate fields so that the guest MSRs are reset to 0s after the events.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h  |  2 +-
>>   arch/x86/include/asm/msr-index.h |  1 +
>>   arch/x86/kvm/cpuid.c             | 19 +++++++++++++++++--
>>   arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
>>   arch/x86/kvm/vmx/vmx.c           | 29 ++++++++++++++++++++++++++++-
>>   arch/x86/kvm/vmx/vmx.h           |  6 ++++--
>>   arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
>>   arch/x86/kvm/x86.h               |  3 +++
>>   8 files changed, 89 insertions(+), 8 deletions(-)
> ...
>> -#define KVM_SUPPORTED_XSS     0
>> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
>> +				 XFEATURE_MASK_CET_KERNEL)
>>
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>> @@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>   		kvm_caps.supported_xss = 0;
>>
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
>> +					    XFEATURE_CET_KERNEL);
> Looks should be XFEATURE_MASK_xxx.

Good catch! Thanks!

>
>> +
>> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
>> +	     XFEATURE_MASK_CET_KERNEL)) !=
>> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
>> +					    XFEATURE_CET_KERNEL);
> Ditto.

Yes.

>
>> +	}
>> +
>>   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>>   	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>>   #undef __kvm_cpu_cap_has
>> @@ -12392,7 +12407,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>
>>   static inline bool is_xstate_reset_needed(void)
>>   {
>> -	return kvm_cpu_cap_has(X86_FEATURE_MPX);
>> +	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
>> +	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>> +	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>>   }
>>
>>   void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> @@ -12469,6 +12486,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   						       XFEATURE_BNDCSR);
>>   		}
>>
>> +		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_USER);
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_KERNEL);
>> +		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_USER);
>> +		}
>> +
>>   		if (init_event)
>>   			kvm_load_guest_fpu(vcpu);
>>   	}
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 656107e64c93..cc585051d24b 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -533,6 +533,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>>   		__reserved_bits |= X86_CR4_PCIDE;       \
>>   	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>>   		__reserved_bits |= X86_CR4_LAM_SUP;     \
>> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
>> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
>> +		__reserved_bits |= X86_CR4_CET;         \
>>   	__reserved_bits;                                \
>>   })
>>
>> --
>> 2.39.3
>>
>>


