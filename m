Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D454FF68
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 23:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiFQVfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 17:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiFQVfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 17:35:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540B242488;
        Fri, 17 Jun 2022 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655501736; x=1687037736;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sxgJKV75KdB+WuwRkPBhygLckm+cyE2joiOUZjcl5EI=;
  b=AjOFYHyfIR4j3Qkt4PrO8AM75e0zKPKskbk2E/3fG4YEbT6CqAULPG/8
   /74yqeRDDCC0qHufLlzCA/SQVE8KKfd/lBP2bu8ZR1esT4Bz3azNhHiiB
   WKaSpdS4dSGxs+KaDomnJQHgH/Dz0zeO+3UfQ2cTVAqDrMy52d38wfpEl
   jK+1v0C1m77QyKkToLJCXf4do3+izsNt53mCPjD1Ox+w1ngA5ABlzTJCX
   Bne2/CG0aRRoZXPT/r2SVHv0Vh0evBmt1syG4Y7sEqY5x4AxiW+jY5pMq
   /mjBW+prgWqLob2PPPtxrkikumoAAGTOIacyFEjIv0Z8zAjUDYJu5WVJJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280324894"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280324894"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 14:35:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="590277280"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2022 14:35:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 17 Jun 2022 14:35:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 17 Jun 2022 14:35:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 17 Jun 2022 14:35:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 17 Jun 2022 14:35:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXL49slvjVoDmr0LgL10p3d8BKFI+UNJQ7Vs0bgNbNWTwlnRlxE/L2Te4yi0CSplzn9g4lfw8Wvmyrx3yUjc7a+uvkBckcCf1DzKvQZ9grB8vw6B52asQHtUwrZPgewAz3gjHytzIhJlpOZDnj6gkb6XqDyzOZIVz11l8J7XprJmw+mMfLdhwHux9KzTtLpE+CcVAu9mC6l41mP10/5Q3yU3aA+0i3BIiRGrx4sZi7RCQb/3okM2LF/RwauzcJpL0IbSKiU5SpSPbrp7k22c8sZyRdVjAMEE0eIMhOgkFaCQeKnzsGVZf8LgstZUgkNiqRfdsY8gDE8LpnNDm1Fhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdZxAp9CzfnFwujzXS7XGRG6tj4e8ezmkrOGkqVCbBk=;
 b=oRSrppEWtq2GRjVBlXnaMmNTvThP2hN3qiXW4wbKOiQn2KwP+4Ip2UAst899sJQoExqdyz7nsAPxaFF+36KxfJ+8FsZHiHcb+tnK1Ff3v86H4C/ZgIWp16iXpYNd85Xr46e9cQj6+QXmnks6X5L7ZY4v/If8HkAwa8HfTZH2gUMykGa/4ABEiwpNFOQOmAE6aNm/yvFPsswHHQRmwVdCQdJP6oIqtVACvEWTNWgSq3l1uNWieImiB9IL/N22EcfxE9axmOK/Tkd4Xx6rOD5nMYYpijklAqVsgIcS+2OuK6x7c2iaSUSqpONBSF6TdrwobSeLVCREBDDGsb5bhn31Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB4864.namprd11.prod.outlook.com (2603:10b6:a03:2d4::21)
 by DM5PR11MB1564.namprd11.prod.outlook.com (2603:10b6:4:d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Fri, 17 Jun 2022 21:35:31 +0000
Received: from SJ0PR11MB4864.namprd11.prod.outlook.com
 ([fe80::d9ce:f198:beed:4605]) by SJ0PR11MB4864.namprd11.prod.outlook.com
 ([fe80::d9ce:f198:beed:4605%7]) with mapi id 15.20.5353.018; Fri, 17 Jun 2022
 21:35:31 +0000
Message-ID: <86952726-53e6-17a9-dbe0-3e970c565044@intel.com>
Date:   Fri, 17 Jun 2022 14:35:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] Documentation/x86: Add the AMX enabling example
Content-Language: en-CA
To:     Dave Hansen <dave.hansen@intel.com>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <rafael.j.wysocki@intel.com>,
        <reinette.chatre@intel.com>, <dan.j.williams@intel.com>
CC:     <corbet@lwn.net>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-2-chang.seok.bae@intel.com>
 <d8278c53-71fd-3400-9ba6-079c99d66645@intel.com>
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <d8278c53-71fd-3400-9ba6-079c99d66645@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:a03:117::14) To SJ0PR11MB4864.namprd11.prod.outlook.com
 (2603:10b6:a03:2d4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f9cd9a0-79a1-4011-2efc-08da50a94da0
X-MS-TrafficTypeDiagnostic: DM5PR11MB1564:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB156491EC1E55371E6C7E8F69D8AF9@DM5PR11MB1564.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtglfwcmvvFso6aMXoZyjyECpIvEmcgteURg4ijosnDiZxyZAhEurLRJf9i6DGQeZx+ZD07CUPG+gTgXvzEzyAmm4XOertwxaRtxsn8ShiErHtR6Pr6hkX04fKFmhjgjUQ5ZNlol7ZTMc4+vDVd9P8cs3YCEAsJZlsQTXVw1kmEIPlEuF5/IVni65pO5cXmvrFeJsTFuqc4YsJNnRJTxooW53UMK4tVteVaBBwUynRnrF9xKB2v7aDSPBrGQHVoNVJeBCth45nb/SRh6xyJM/xW0Yhw7ZeyBSZf0dnqkAg2iRH6QvKvRabxSTcpee4XJpL8Cy47bhdh7svwXjPPZBd5hdacjBr+4J2aghv7VTTsfmy1u/MC9zkdPmIZx7SiWFkQxxoM6HGiTUgrgjbaO3e7O7RZYl6B8FAKOgMUaG+PqJlp0EKNfAZeYVq+FZEqdtvp5Ko2Jxyctsow1a3gscAWMge8mrsAF+jq5CeBDWTGbsKXc3VDBJjBzqR5soKxx3hywuU2C0p9zJBXXzWHUJuxixhoLPuK5Klc3VG+y4YDDWCzdGI2Pb43PWeM0jzIsmYTmf9DrLDwjvVN4Y5R0tsyJxxvfWHVZ4+FI6V31CmoZD5U1EWEholYW87j5kLOKUTW2iEC5tx+Ywv6GCDus9WsVqj7gEaifoIl7IpZLAI9v3MPIa3QIQqeXY+0k/eq4A3Gw1xaFh6NJOBjZbMXCxXNMZpnJs7N0rens4dLnOFw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4864.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4326008)(8676002)(66556008)(66476007)(66946007)(38100700002)(82960400001)(53546011)(8936002)(86362001)(26005)(5660300002)(2906002)(6512007)(31696002)(6506007)(186003)(2616005)(6486002)(498600001)(6666004)(316002)(83380400001)(36756003)(31686004)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dElhV25zV05odlMweC9CQ05yaGVSRVVIY1plUlJiSEczWTVtZmNRd3FUcmpy?=
 =?utf-8?B?a0tWbXZxcnZyMFluWks5a0J2SGNCbjNONW9qeSt5dlJiOC9WbUREbHdJUUhD?=
 =?utf-8?B?ZnUxdWhXeERYUDEyK0EzOUNHWHN5dk5XNEVmRmNZR0hkMlErNGVxSzNtL3Jt?=
 =?utf-8?B?ZlNtc2Jac2g4ci9uY1ZxRjgyc0NIZk14WjRjRWZlL29vcDJoYXBFUmpUQWdj?=
 =?utf-8?B?WWszb0srSEZld2RCZ3JlZ0I2MWFGWFZRbmFWMlhnbWNqakMrSldLVnlQb0lp?=
 =?utf-8?B?VklZUk8yVHE5ZzR6TFZ3WDRlQWh0aVJ1KzRmcEQvYlhkWmtsb3lFMXByUHBq?=
 =?utf-8?B?WTNtcVVJRmNvd3ovb1NicXdTSVFXZmtlckZhQ01pUE9TSk93K0VkSm5MYksx?=
 =?utf-8?B?ZmZwNm1EZXpheHlGcnBoUnFpWkw4ODh4MVRYQkg3Q05wWndELzBtOWN0ZWV2?=
 =?utf-8?B?OFpPUWJCNnFSbkNRMVJTb0UvSFJkTForVDM0L2dxbnphVyt6TEtiOHlDUVFN?=
 =?utf-8?B?MVhGdEFhT3VqSUZwaHhxaUlnVXAwN2FEeW0yTHB5VVdQOUMrNldrT2dGMXVp?=
 =?utf-8?B?bjc2a3o4Q2N6Ri9zVVdWK3JDb2VwcFhMMzRkUW1KYVVIQVhjUHJMS0FMTmVr?=
 =?utf-8?B?c2xkalBWVEhaaktJZ0V3YXdlZnAvUTNyajBnc1BnQ2Y0NFZYZGtZaXNWZ3NL?=
 =?utf-8?B?Wkp5L3ZReVVNZmJncVdTMUI2U0xhNlIxeU55cHcwdXdLVTRSTmF2SFhlTFZr?=
 =?utf-8?B?dmVDMU02d2FCMFJreGE5SXNxWGthdXlqNjVZNXByaEFwazlQNFpJRDYwRjdl?=
 =?utf-8?B?TEVtczI3Y2wxVHlwUUJQTzFIZmh3Q3RRbkxielRkRnZndjJ6YkJhYlB2TmFw?=
 =?utf-8?B?SHFjbHZsb1pqeVI3elFGMWhXMVN2MzJ0NkF3V2wzTG5BbWNOOVY3L251S2dW?=
 =?utf-8?B?eXFBcnVMc1RkYkNEc0VTMDNXQVVuVk03STJHSEE1YldaaldkYjRIc3QxZzVm?=
 =?utf-8?B?NU9XWVBoY0pISlg5WUtQTmlSNEhML1Q1bzdsbFVMZ3dCamxWeVQ2ZzdtT1pO?=
 =?utf-8?B?c3M2OVk5bTNzeFBZTTBZa2JqcmxQZlBwS1dWVmhEN3ZLaTYxREI4OXQ3ajVj?=
 =?utf-8?B?ZG5Ud1V5MVpETlAxZWR6djNBNHVyZG9FSVhESWR5K3cvQWwwOVk0RUVaNjFF?=
 =?utf-8?B?bXlSNEtLWXJKcGZ3T3FWNmFVUXhmajZiQTM1c2VnZE1VYWU1TExzU1ZNQVBh?=
 =?utf-8?B?MUtDQTd4aHZ4dUEySUpGTXhzOGVTUjJtaVNTNVcrTmxQZTdIZ0EwSE1VeW9B?=
 =?utf-8?B?RWR5cFVqUUxWeFBFVW9JU015VjhrVUROd08vR0srTkUzbHNBZWdJTStRT1po?=
 =?utf-8?B?Q1hzODdnMXdjVkRIZWlpdkRHbkZlbm5jMG5rcHZmVWNjMFZPYTFSWnRJcE9C?=
 =?utf-8?B?QldnSnVZZVNCZldZT3hySDhsT1lzWnhsUEo2Y2ZFNWR4VE5IcklPTmZSTnZ6?=
 =?utf-8?B?cm4rdUNRaDFvdFR5L3R4c2JPQURydFBJVU1meUtlVVpIOE9WSzBDREFkR25N?=
 =?utf-8?B?QndnZStFTldyWjdGQnY2SjlRc3NLOGQ3NjZSRXh5czhPaEo2UWhIZU0xeFZv?=
 =?utf-8?B?Y0hhQ01vZE1kS1ozZzh3NlhFTUlXWUdLMlg4aUswRlg2RWtPRGlVd0JqTk9w?=
 =?utf-8?B?SDR0UFZxQTZVWXFWbmpPOXJWSFpoYUNtNUpDRWF5V05HNFQrTTlSWElmZnVS?=
 =?utf-8?B?R3VCN0lqMjkrVVZybEF5MzNMR3BvVWNaZnUyajF1UHBKR2loWitXaUJNOHVo?=
 =?utf-8?B?UHIySUxscjNnU3Y4emkwOTZQR2huQXppUHNROVBIdEpEaEdRRFgwTjRHTGtl?=
 =?utf-8?B?eGdLWGFLV1FrTDFEWC90TFptek1JcFdJU0t1dXpPMXhjV3lmdGpCZmhNcjFD?=
 =?utf-8?B?WndoQjRTNWYzL1dyK25XUVRFK0o1V25OcURncmdYTWpNZlZIMHNnem1tYVRL?=
 =?utf-8?B?MmhxVDNjUXQ1Rk5lai95ejRJL2lpSU1NREQwdlNMb2VYbFhHTHFVZ0hGWlBF?=
 =?utf-8?B?dEEzanNJTkhnWlhXYjRtWVN0TVQzNTQ2bU5BTUUyenNIZ2tjQm0zZFBYaDJt?=
 =?utf-8?B?ZlBqRE04MitEQm9YbGNPM0VjRithcjBFNEV0TkhXT1RyUk5QYmQ2TTNMbVJs?=
 =?utf-8?B?N2twL3dTNGxmc0gwYnRJZUdDOGlvRUc1WU1uSmhnd2o2Qk1mLzZnYzZlU2di?=
 =?utf-8?B?eTFOZjhBZWUxa1Rtb2Y0TXJRbjQwbzlSSHZsL2xwWHY1T0wrVE1oY2dOQ1dL?=
 =?utf-8?B?ZEZ2RkxVWHlWY3FYRUFiUlNlRVdMek1Ia2o5dEtid3hFVUkwbU5TU2kycXNu?=
 =?utf-8?Q?z+hk6oEdJHiHuP78=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9cd9a0-79a1-4011-2efc-08da50a94da0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4864.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 21:35:30.9634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkxgxV34CiYMhfm9nMrgysncwI9x+IL5Xd5NiBu9WFpDz+5OHHDvxxZ0/PAaPB+Q7GzXz49x4RrV+F8I9ZosRgQpYkep4IRLkO8I0Q4uw9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/2022 3:45 PM, Dave Hansen wrote:
>> +  1. **Check the feature availability**. AMX_TILE is enumerated in CPUID
>> +     leaf 7, sub-leaf 0, bit 24 of EDX. If available, ``/proc/cpuinfo``
>> +     shows ``amx_tile`` in the flag entry of the CPUs.  Given that, the
>> +     kernel may have set XSTATE component 18 in the XCR0 register. But a
>> +     user needs to ensure the kernel support via the ARCH_GET_XCOMP_SUPP
>> +     option::
> 
> Why did you bother mentioning the XCR0 and CPUID specifics?  We don't
> want applications doing that, right?

Without checking them, this arch_prctl(2) option can be tried. Then it 
will return either EINVAL or the feature bit off if unavailable. Yes, 
that's all wanted instead of that old way. So maybe something like this 
here:

	An application first needs to determine the feature support:

> 
>> +        #include <asm/prctl.h>
>> +        #include <sys/syscall.h>
>> +	#include <stdio.h>
>> +        #include <unistd.h>
> 
> ^ Just from the appearance here there looks to be some spaces vs. tabs
> inconsistency.

Sorry, a tab instead of spaces was added later to fix a compile error.

<snip>

>> +  2. **Request permission**. Now it is found that the kernel supports the
>> +     feature. But the permission is not automatically given. A user needs
>> +     to explicitly request it via the ARCH_REQ_XCOMP_PERM option::
> 
> That phrasing is a bit awkward.  How about:
> 
> 	After determining support for AMX, an application must
> 	explicitly ask permission to use it:
> 	...

Yeah, looks to be concise. Thanks!

Chang
