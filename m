Return-Path: <kvm+bounces-7139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B956183DA5F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4231292A92
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 12:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C231B7E4;
	Fri, 26 Jan 2024 12:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MJkRSHty"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A251429B;
	Fri, 26 Jan 2024 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706273685; cv=fail; b=tovLnPD2bixly1tg77TGPwYJBsAFrWQ1VcvczFBbrXBFd35YTZkFvHVoKjcIBe+Zm+VDyd65haVlTmxF8GrCRtSMkpjmgS9lYI602RqMtIUBNROi3ZHM/VhIMA46Asp6yUpoLW0EW4mHiFwxxuAEYBCDIRfteOCruqmasMkNYog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706273685; c=relaxed/simple;
	bh=xmaaEg/DeblnRzVNb3im/rbTXIctOrEYMSPfX8fnnbw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HB7XKIRFsgUp1xaVTJq8QeXAetCnu9Kso+6sGfxajgNYYvPGstGj1q3vX/7k3N5Qp4iN5y02zv/WmuaO3sH+EuJ3dSuP1OKUq963xXS7aOWRXsLQVRw/4bLVwaT+1kC9K3QffQqI9QQYy++glRi0wrcBSJBp2ugUVO3O3LYMJoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MJkRSHty; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706273682; x=1737809682;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xmaaEg/DeblnRzVNb3im/rbTXIctOrEYMSPfX8fnnbw=;
  b=MJkRSHtys5LGUjUIsLgPRitD4IfMncJ8uSew398/E/qiHatc6OlRj6ZY
   b6onVkBDGCyBbaH76VbDmLwZJEiSMeM92m1NGEQSuvrbAcf/8ffKwS+Q3
   pXPKSoxvQ0ph28+LvOobyOQJkIW4To1l+1nWgGKuDQJwbIcXWCPp/j9tg
   S8Gxb9rYaNmZvUPkRBU+DhuQ26MSAxtab0WHI/aSyQIYuHO76dS4r+ZcQ
   5/PQpcODxGItyyyOC3goAGkeKbRRiz0tYYA2ZzrGrhznCJyB0bKhuasAF
   850QFJhj/viBLlMgqEwLJKqyvDxWCf4DJDUli5GcuXIznlO1/TQtt0Gd2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="1390417"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1390417"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 04:54:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="736689891"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="736689891"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 04:54:39 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 04:54:38 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 04:54:38 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 04:54:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQJIM2ywU839oRe3WWU7Ky0mHy+KpJ3w1weOCHZ3QnHrER92w+fMkvFyJZ6Q8WAQQ2qnxqDa+0VCwFSqAdIiEDsLbDdQU/Myl7lfd8xBmIY2yF5sJhBPz8Vsvlo1Z2mJUdAS+luSWILw1Txj/NNWucfCWtuYcktmWVGwIhQJ4gEqCBjOj6N2zp3QU6KH9HYXa8iUzPWzuwLaekZzcphCasZEIUKq/t2mT06wDGbwDyR8nGhH0s9uEj2FWfUCc33AXmFUvBV1lg5SuAbIZ6+T4aw6XJ5d2RfsrIQwbyePRrmV2EcurDHPIuwIsQoQu+41CnxicLwL/uFa5rrzwsthIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqKlkmvlKnB1mvZ3SYtsT/Iww1se2yDBgSCME3+z9x4=;
 b=KhvPLWfwc7Q6h4roZhbUOeEhE5ILwZL6bBMWFXo1HmsRWS83Z6YjvVnxSDA/Dqowy2ZN4acqzqeWXgyrmXGH3FivU9xg6xFFZNJE8SkHumy3rA6YN0xeYRKzLcpmcDyzS1jr7pd7I0lE3IEJLu0/YYy6QalksgE2DFjdhNfVGc6oTKnUHc2WANa3nXinuP+r1dSAf4oLNDhY7NZziQl/qHf2ar4JB2YXdicNsxNrWDSC0Pi1Qha2eF9ojtULWvlocn5k7zlWQKwTc/61F+L7gjAFEg8g7LQOa0Y9eaqMBGbXpNVwgUcoQOA9TU6O06U0TG4A75+1fpOH+EuJkQ3whA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 12:54:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 12:54:35 +0000
Message-ID: <38841cee-d4b6-438e-9a9b-ab2fb6a77771@intel.com>
Date: Fri, 26 Jan 2024 20:54:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-25-weijiang.yang@intel.com>
 <ZbNkWFuSP7wwq49C@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbNkWFuSP7wwq49C@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: fd23f40e-18ba-469c-f905-08dc1e6df2ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oV1XeO5/MA8lNa3S21WrZBp9e304RQBWxMD1QGy/PzlmQP0zmipjrqGmZcau4QXq/K/QVs9SaFQGDp+jyTXTotw47jsnG1aHG9mVJ+WrnuKMmqWLw3tgdG56O+FAvJo5b3fizNM0h2S8+LeeNtdHsz0oJTizPFY36ueWMatCVDCRNX7C7vMBniG/Z2inzmDwFwxGhuAgD3sUQni36oBtk1QdeIQBz4DOvfRe6kt9ShdiNUh3x4Z1LNtwjF/yQ8gjDw1MwVCgRQdPJ+Pu77HAl3zk8Ga6p97JQEnj6O0q/khIgaLdchqOYJBA62sPt9raqwuuYfUcjrX/nGfMG9dqFea+s5RBA2qWK0CexeWb9ERsofVYjIoI6ZaQhn0rqQRCwddPQR5pyZxj3rcZssxO+/rC5a0EWK8f2KpY91H1ovtRg5hwNbNfgDoNnZ+n8KqK5pJhFAm4uyLbN6UbKh4VBgg/v8L0fi0eneksbYJ4vuiDO4TtxXU+rQ8Ge5hVURh7J19/BqaG/Io3YTcEFGh+0ZintqiccjSGvqQoE9kI/y2O2JrVt84W8hN/mSB13ixKaK5PIFQ1uDHcFGA+Tx5hwGj99mqjhb5WjfzMDmOTTZVUJCEXe8cNIlf1DU90ar63QP9M+c/u0jHrK9EkK1CImw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(376002)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(31686004)(83380400001)(41300700001)(86362001)(82960400001)(36756003)(31696002)(6506007)(6486002)(26005)(2616005)(30864003)(6512007)(38100700002)(66556008)(53546011)(478600001)(66946007)(37006003)(316002)(6666004)(66476007)(6636002)(2906002)(6862004)(4326008)(8936002)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGI4WmVjWkxSZ2cvR2Z2S0R0LzFBOE5nR3RUeExBakoyWkVFeXFzWkttVTdq?=
 =?utf-8?B?L3dIcW9ZbG5jQW9YRW5WNGlFamZmS3pqL2Q4OUdsdkEzdjNSUDVEcjUraXNu?=
 =?utf-8?B?UDZOa3V1bFdobkp5TGFqUUV4RnZXRlp2ejJ2TDFudXE5cDh2eklWK1k3TFJL?=
 =?utf-8?B?Rjh4OC9McmVKQlFMbmw3WWVxeDNrQ05mWkJRWDhOTnBZc1dta2krNzZqMXEx?=
 =?utf-8?B?WWxMTDJLRG1YQVM1bkxwWlllOXpjdlpYYXYzV1BrTjN6SGJsL1Nkd3JTUXd4?=
 =?utf-8?B?Q21xLytOcUY2UkFWQ24vdExxYm9VR1pJemlkNVAyQnY0NVVTNC9QcDByOHY2?=
 =?utf-8?B?UEQwQmMvZDhFcUxiazVzenJyaUNMbVFWMGF6UHpvYVpHVTlwU0w5ZUhFeGNX?=
 =?utf-8?B?eklnS3B5RTVKS0R4VW5oSUJ5ODNDM3c1NkZZbWN1dDVXeXZxcE4rdmZqblJn?=
 =?utf-8?B?WUVzTVI3V0h5U3VDQ0lXWkNOMjA5WVdIaWFZWTVNRDhXbm5UV3hFWFI1NmxU?=
 =?utf-8?B?dXV3RGZVdW50SkZUa0ZzamtMeVNNSzFsTWNZQnMrT3RrWklFQzE5RDgyY2Rs?=
 =?utf-8?B?REJ4akZXWlM3bmhXLzdHaDVsdG1SQmpuWEhyM0JkK0U4NmJTQy83SEE2ZDgw?=
 =?utf-8?B?MW9mSlFsTGFXYWRiY2l6akRiSzh3b2d3cklxSENqRHI1RzZGU2dIK0pacHdk?=
 =?utf-8?B?V0xXbCtxYU5qOVlRUng0TkFHa1o1ZHNDT2lnNmY3ODZITjFqbDlmR1RPU1BI?=
 =?utf-8?B?T1FSbStkRStzRVVUaUNPOEJPbG1GY0UwdDJGNXc0SnVIMHhrY0NGT3NON3Rm?=
 =?utf-8?B?R0xVcldIWGs2bkFCQ3piWTJMUnFsYmJvdUEwRmtTQlovb1VuQjRmQUY3bUQ4?=
 =?utf-8?B?THh6bWExa2tOWGM3V0tPbEk4bWI0UUc0ZHp1TDRlQ0NsQm9VNHh5RFpSclJF?=
 =?utf-8?B?QUhrelBocUFrZzZuVjRJd3VuODdkVXNQK2ptcFIwZU5LOEpLS3dvNVRseFBB?=
 =?utf-8?B?dDFYbzZyOXdmSWhPK2VGSEYxTU5nbHlXVnl0UDg4dXkzWWFpMDNSc09ueXJK?=
 =?utf-8?B?SlBrM25HaVNVeGxCbWw4bXE5VktlS3VTcDllS2kybWJWd1cxd0o1THdOWGVy?=
 =?utf-8?B?SGJJbE41ZkprRVIrdFh5ZUI4R1dWUkRBSFU3MXc5ZGRtRW1oTUhWeXlVNi82?=
 =?utf-8?B?VU45a2VkaGJ5aGJSY3Zxcnc5Y29YMjMvSEE4Nm5wTU10UHJmb0R1ZDFGaVFD?=
 =?utf-8?B?RTErcXBDYU03bFNSSk4vQ3FVaHlMcHFLZE5nRjlISXFBd1BQOE1MUzluYTJz?=
 =?utf-8?B?MEE0ZnA3bXFJTmd2WnV4K3RWelU0ZWNWanNtU09uVG9rUzdDVkxHemIzWEYx?=
 =?utf-8?B?M2xEdTNGSVg5YnNScUV3SzlXbWRoRERqSkJGS0VLbWI0VXpvN2U1UkszNDh1?=
 =?utf-8?B?aE1LY3k2ZWthSTE1cGE0bE9BZkFmeGtkOEp6WlhZSm5XRzFQV3dhZzJ6Zlo2?=
 =?utf-8?B?TVRYZkNScEZ5Q2VmazdxQndRRkdIMjNEdmRtd1c0RWgvc01CdG1PSnFIaWNX?=
 =?utf-8?B?Uno2OEx5THhjR2tNNnNyaG1UU2l4a0hmeEFZTHNscS9DMjI5NXhCN01xTU80?=
 =?utf-8?B?cnBTSmNZMWhXU1BuWitpd1JOdnFpcU0vZmpwSFN4eFpmM3hsQTBTb05xdkZJ?=
 =?utf-8?B?OFMvdkZyK2J1bEk0d0tpWmtyZ1BPZWd5bWxRVW0wVzFKd0xIaEpHam9XVHJS?=
 =?utf-8?B?TXNlZURTTUVOMENpNmRFTjVSeWFydHVBbHB1SjJrZlhpUzZLMmdPaXR3S3d5?=
 =?utf-8?B?bFRPTjJ0YWpjUWloR2NjVHpRaXIzTnVXdWZ3MFNERXlML0J0aFQvYlV4cGxM?=
 =?utf-8?B?RUVzUHBxRlYwdGNzUTVKSTU5NjJzQXVHakI2RWV1Z3FsRlhRVXBVeEI3U2NN?=
 =?utf-8?B?V0g0dHdsM2JFbm9CWTlxU2pQVnFVWE1oczB2VzFRN1h3VTNVRlIwcVhtd3k0?=
 =?utf-8?B?Tjhxam5SUWF6ckNhMzhXQk0xbWRvY1F1WVhJOUU1TlpSWkEvK1FjT3RjUjRa?=
 =?utf-8?B?R1FaZjJsZDNlUWVmSm5Eb3NBMDFCaEtXckgwYklVM3VRK3dNd0VTL3VmZ2lV?=
 =?utf-8?B?WC8zZW5pVXZBeE5Ya2hmUHRCOEVXZ1NKZVdFOTg5VU5tYUxxWU9EOWp5SnFv?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd23f40e-18ba-469c-f905-08dc1e6df2ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 12:54:35.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBtKi94q9sLwMnEaODKTPGafADu4smsHn1fVKbBrILOweqyh1BE+QRzbeIYf28CBkOnS/nBF/VAwLQGRTbAmOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

On 1/26/2024 3:50 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:57PM -0800, Yang Weijiang wrote:
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
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>> arch/x86/include/asm/kvm_host.h  |  2 +-
>> arch/x86/include/asm/msr-index.h |  1 +
>> arch/x86/kvm/cpuid.c             | 25 ++++++++++++++++++++-----
>> arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
>> arch/x86/kvm/vmx/vmx.c           | 28 +++++++++++++++++++++++++++-
>> arch/x86/kvm/vmx/vmx.h           |  6 ++++--
>> arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
>> arch/x86/kvm/x86.h               |  3 +++
>> 8 files changed, 91 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 6efaaaa15945..161d0552be5f 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -134,7 +134,7 @@
>> 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>> 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>> 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>> -			  | X86_CR4_LAM_SUP))
>> +			  | X86_CR4_LAM_SUP | X86_CR4_CET))
>>
>> #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>>
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 1d51e1850ed0..233e00c01e62 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -1102,6 +1102,7 @@
>> #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
>> #define VMX_BASIC_MEM_TYPE_WB	6LLU
>> #define VMX_BASIC_INOUT		0x0040000000000000LLU
>> +#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
>>
>> /* Resctrl MSRs: */
>> /* - Intel: */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 95233b0879a3..fddc54991cd4 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -150,14 +150,14 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>> 			return -EINVAL;
>> 	}
>> 	/*
>> -	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
>> -	 * state is not defined for 32-bit SMRAM.
>> +	 * CET is not supported for 32-bit guest, prevent guest launch if
>> +	 * shadow stack or IBT is enabled for 32-bit guest.
>> 	 */
>> 	best = cpuid_entry2_find(entries, nent, 0x80000001,
>> 				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>> 	if (best && !(best->edx & F(LM))) {
>> 		best = cpuid_entry2_find(entries, nent, 0x7, 0);
>> -		if (best && (best->ecx & F(SHSTK)))
>> +		if (best && ((best->ecx & F(SHSTK)) || (best->edx & F(IBT))))
> IBT has nothing to do with SSP. why bother to do this?

The intent is to prevent userspace from launching an x32 guest with CET bits
advertised in CPUIDs as CET won't be supported for x32 guest.

>
>> 			return -EINVAL;
>> 	}
>>
>> @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
>> 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>> 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>> 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>> -		F(SGX_LC) | F(BUS_LOCK_DETECT)
>> +		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>> 	);
>> 	/* Set LA57 based on hardware capability. */
>> 	if (cpuid_ecx(7) & F(LA57))
>> @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
>> 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>> 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>> 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
>> +		F(IBT)
>> 	);
>>
>> 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
>> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>> 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>> 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>> 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>> +	/*
>> +	 * Don't use boot_cpu_has() to check availability of IBT because the
>> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
>> +	 * in host cmdline.
>> +	 *
>> +	 * As currently there's no HW bug which requires disabling IBT feature
>> +	 * while CPU can enumerate it, host cmdline option ibt=off is most
>> +	 * likely due to administrative reason on host side, so KVM refers to
>> +	 * CPU CPUID enumeration to enable the feature. In future if there's
>> +	 * actually some bug clobbered ibt=off option, then enforce additional
>> +	 * check here to disable the support in KVM.
>> +	 */
>> +	if (cpuid_edx(7) & F(IBT))
>> +		kvm_cpu_cap_set(X86_FEATURE_IBT);
> This can be done in a separate patch.

This can be put in a separate patch but IMHO it's still related to CET enabling
setup, so put it in this patch is somewhat reasonable :-)

>
> And we don't know whether IBT is cleared due to ibt=off. It could be due to
> lack of IBT on some CPUs; advertising IBT in this case is incorrect.

cpuid_edx(7) returns bootup CPUID available on platform, if it's there KVM
can enable the support. Currently KVM checks the minimum correlation with
host CET enabling status before exposes the features to guest. Unless there're
some HW bugs or the xsave dependency is broken, it exposes the features to
guest if platform can support them.

>> 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>> 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index ee8938818c8a..e12bc233d88b 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -79,6 +79,12 @@ static inline bool cpu_has_vmx_basic_inout(void)
>> 	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
>> }
>>
>> +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
>> +{
>> +	return	((u64)vmcs_config.basic_cap << 32) &
>> +		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
>> +}
>> +
>> static inline bool cpu_has_virtual_nmis(void)
>> {
>> 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 3993afbacd51..ef7aca954228 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2609,6 +2609,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>> 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>> 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>> 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
>> +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
>> 	};
>>
>> 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
>> @@ -4934,6 +4935,14 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>
>> 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>>
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> ..
>> +		vmcs_writel(GUEST_SSP, 0);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>> +	    kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		vmcs_writel(GUEST_S_CET, 0);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> At least this can be merged with the first if-statement.
>
> how about:
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> 		vmcs_writel(GUEST_SSP, 0);
> 		vmcs_writel(GUEST_S_CET, 0);
> 		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> 	} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> 		vmcs_writel(GUEST_S_CET, 0);
> 	}

It looks better, I'll apply it later. Thanks!

>> 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>>
>> 	vpid_sync_context(vmx->vpid);
>> @@ -6353,6 +6362,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>> 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
>> 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
>>
>> +	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
>> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
>> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
>> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
>> +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
> how about merging them into one line?

OK, will do it.

>> +	}
>> 	pr_err("*** Host State ***\n");
>> 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
>> 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
>> @@ -6430,6 +6445,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>> 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>> 		pr_err("Virtual processor ID = 0x%04x\n",
>> 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
>> +	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
>> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
>> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
>> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
>> +		       vmcs_readl(HOST_INTR_SSP_TABLE));
> ditto.
>
>> +	}
>> }
>>
>> /*
>> @@ -7965,7 +7986,6 @@ static __init void vmx_set_cpu_caps(void)
>> 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>
>> 	/* CPUID 0xD.1 */
>> -	kvm_caps.supported_xss = 0;
>> 	if (!cpu_has_vmx_xsaves())
>> 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>>
>> @@ -7977,6 +7997,12 @@ static __init void vmx_set_cpu_caps(void)
>>
>> 	if (cpu_has_vmx_waitpkg())
>> 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>> +
>> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>> +	    !cpu_has_vmx_basic_no_hw_errcode()) {
> Can you add a comment here? This way, readers won't need to dig through git
> history to understand the reason.

OK, I've put some explanation in commit log, let me move them here.

>
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +	}
>> }
>>
>> static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index e3b0985bb74a..d0cad2624564 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
>> 	 VM_ENTRY_LOAD_IA32_EFER |					\
>> 	 VM_ENTRY_LOAD_BNDCFGS |					\
>> 	 VM_ENTRY_PT_CONCEAL_PIP |					\
>> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
>> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
>> +	 VM_ENTRY_LOAD_CET_STATE)
>>
>> #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>> 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
>> @@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
>> 	       VM_EXIT_LOAD_IA32_EFER |					\
>> 	       VM_EXIT_CLEAR_BNDCFGS |					\
>> 	       VM_EXIT_PT_CONCEAL_PIP |					\
>> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
>> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
>> +	       VM_EXIT_LOAD_CET_STATE)
>>
>> #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>> 	(PIN_BASED_EXT_INTR_MASK |					\
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9596763fae8d..eb531823447a 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>> 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>> 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>
>> -#define KVM_SUPPORTED_XSS     0
>> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
>> +				 XFEATURE_MASK_CET_KERNEL)
>>
>> u64 __read_mostly host_efer;
>> EXPORT_SYMBOL_GPL(host_efer);
>> @@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>> 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>> 		kvm_caps.supported_xss = 0;
>>
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
>> +					    XFEATURE_MASK_CET_KERNEL);
>> +
>
>> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
>> +	     XFEATURE_MASK_CET_KERNEL)) !=
>> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
>> +					    XFEATURE_MASK_CET_KERNEL);
>> +	}
> I am not sure why this is necessary. Could you please explain?

It's necessary to put the check here as it guarantees when guest CET is available
a) the critical host xsave dependency is there, b) guest can play with CET in user
and supervisor mode at the same time.



