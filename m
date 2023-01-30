Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E41680E06
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbjA3MvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjA3MvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:51:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBB32C65A;
        Mon, 30 Jan 2023 04:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675083063; x=1706619063;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oSiBgcDDgl568w8eX7ZrnJn9bJo1C9kBGlbAk1lU6v0=;
  b=BBFNMABuvtLmWZPFaC9/jlslAmT4i40d2L6KD/H2kfpopq58QsSQ8AFB
   s+QZXFA/2j7EOYwqb6cI/4D91PayP5zsN9CHblgEmZjs20kGZvOYPx8YH
   XdtHAC6KrLX32On183SXuYMHf92DYlyVJOdsDD7zNDBYMk2snuDsJHW8k
   qjZXDqGuCX+4bI23Hcei/UNAz639ZJ6F4e5xVR6Yuj3Ikkw92Z9F06utT
   gE5vYJ0WYQiAgihCpbjliDHSdGSoURhPSzar+r/HIwijkx82Jyium9MMM
   3PnJTFXTFEyILFUYKrSdMkUxV3F3YOLZBiSNskME9J3kizHwapS7Nhw5t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="315507049"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="315507049"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:51:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="657441128"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="657441128"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2023 04:51:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:51:02 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:51:01 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:51:01 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:51:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVvR6AqkBDQLV2P4+3DZoO/N0OD0rrnwuUzCs86i/A4cDGCqJcVFzzTSYAFmcUkvUDUEsaBJVZZ2ZbWqjbe0bXykdGINwtru3Cvs29jCN9hLPil/rd2G6mnrss8rfhht7pAryjMIklWjnSuAol9lgWFzNTAWHwKd89whVCMxgrV2WtAG0DIg+KdKZk1bo/eNGzad3c+gLFhEn3wqu8pSpjPx6vEcRLa5Ki+D4BDYC77mUeyqlmJrobYF2qDwHBrBG0Zn2C9i5/E/0zGENU+akQ4z4GTM05MOQV1QeHJy3SQi8C2akmuT+PKGqJ3HDgz2E7lhlE0BINIFdWK5r4YnJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UhbuQq7hCMruuP6YZd5mI26VDW6sT1+GlGACWREh5A=;
 b=KhSmAxRoTzOHhUJrXWKHeUxiOOyanGvClAUDMUi+gsGzIwapqmXOQ03dHnp4AtYERpubLjUYbkrORLLITH5TtZcNm0X5E6QmadrZyg5m5mbM6KGOYTy37s+6ka7+IbaCqB4w9KVqnCc1FOszf67upsSv15Xj2sGkRCq9jTFbUfnkEBYd6hw4dqFtxTG7NFjvKf1kaSq/wJfMll2TySm2gGO1ZvpLC6eSpebnelH3lIvIp6L1J7McweY+aWe/nWodwuw2VYaYZp9wReqd6PBtk8sgPztntlcVhsgBjhp1V/bb2SwBKl7QUrsJaxNwX9nUFo4fg+MLHSb/Knn0dGjamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH8PR11MB6730.namprd11.prod.outlook.com (2603:10b6:510:1c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 12:50:58 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:50:58 +0000
Message-ID: <a3cd4e64-aeb6-b0fb-36cb-ad16a6e8b1d7@intel.com>
Date:   Mon, 30 Jan 2023 20:50:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 13/15] KVM: x86/vmx: Save/Restore guest Arch LBR Ctrl
 msr at SMM entry/exit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-14-weijiang.yang@intel.com>
 <Y9RMASMnzc3tPqvO@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RMASMnzc3tPqvO@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0086.apcprd02.prod.outlook.com
 (2603:1096:4:90::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH8PR11MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef0bfd6-28d5-4bd8-8ead-08db02c0a243
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BmA4PiQqa/44QHGJFM/bh5lE4eA/zhIwpnIGCuxxtrMRT3IzlyWbCl+2yjDXpdpIr216lO6N+Io4L4fxyyus5I9bkngqMcoY38jJ6wHxw1lWfj+OFqhKw1vT81MDKJ4c/dY7x17I1ZgOj+ZpFWmiekhkxl7R6DlBM9ISN8ocRBWtnCVyoKIJUUhBhIsB6X2uSr9c9KaNGhRvZguaqHiyesQBcx/XLoLLnXWs2PMpWkLpNNode7M+peMsJFrofQtpOgqznGymwtGVJYGKITofg5VZCE1jzATXkrpEJC2DUhca7mUqXt3DmlDu7tLBT+Bl+H+CCBuyQyVe1SCsbc4pIgplJF5WYlVwKP3GHcIOGmOYcDu8T3TiuXnsL/AWUVG/tHhH+VN0G+1y8W4bt1OGJqo9bmoN3vWu/qNG0/SFR3lXxSJhPlXS0EJRhCvGHIOGlArVvaW0c2krxUpb+Qx5bAYgbv0Mnv5ZPyuA71A0yh7zvALQ9imaR8nmTCY0AnhXRbUsmkp8aoS5yxOUR6eJZNOEYE/souuW7xcjQupUmWJ9V94Rmj+JPgxwaWZdye6u4VptgjLrYEDpVutc4ZgxOup118s7w3pY4co8laDN3W5XncKLU7Qp12r40utGOHVCNH3hgRUtKrHj3PWPBTdAzQgIl4w4OtYvLLKUi05uT0T9AUhGqYyjN4hdpbHoGfM/Ae9oMZOzBAYc/6oACfzS+plKOSe9SxBQ99cFv7X5hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(66476007)(31686004)(66556008)(4326008)(6916009)(6666004)(41300700001)(8676002)(8936002)(316002)(66946007)(5660300002)(2906002)(36756003)(6512007)(26005)(478600001)(6486002)(186003)(83380400001)(6506007)(53546011)(31696002)(86362001)(2616005)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0dDZzJuTks5QWhyKzVoWlhEMlB3MXl2aEgrVm5rTGNJRm9ESC9GZkVTRlpV?=
 =?utf-8?B?UUVrampkYi9UbGdET3YrSnRrTHRpcFlyejFPWkk5VmZBdGxxU0V4Z1BjMFUw?=
 =?utf-8?B?YTN0cnRmMUg1T0dsMzI3M291MDBMSEVUUit1RVdGTFpvNEFaM3BPOEhBMUY4?=
 =?utf-8?B?bGtpbXgwZWZadEVqaWRxRWFCNXZRUHo4ejNOR1IxblY4ZkJ3bjRlNS94c0VW?=
 =?utf-8?B?WGZqVEFlTDJKeHNBYzc5STBkQjBlYmhCMEV1czZNK3dzdTBvZ0xvdlYzY1N4?=
 =?utf-8?B?YzVDdjlQSFFuTWxsK2NHUUJxL2pINWdWaEhnRG85WHBENUJGQmNIOU0rSjNm?=
 =?utf-8?B?MGtuQTFKMEpUOWVZV3RiVHVrVU9aUzd5YUJoTTUrNTJtTjlKTUh1cEg3aTk5?=
 =?utf-8?B?ZGd2QW9wSWRHWnNrL1ZhTi8xd0l5NFV1QVhrR1BsUFJqeGxxUTZCOGUvaXdZ?=
 =?utf-8?B?WUpRaUdZaC9wbFU0QXNydjh4ZDJacGUzcFhOdjNrZERkSld3bGVacTNFMkh0?=
 =?utf-8?B?Qkx0ZkZTTDZCMVpZVUV1eUpFRDRKbFJRQm4ybTBDUzZWa2pUYW1QZlRZc1RP?=
 =?utf-8?B?bFVsQVVWNmNVT3NYWmx6QTRzSVdhK2gwcWxRN0dMKytFVVFjOGNQeEtDNHFF?=
 =?utf-8?B?cjFFb0tzUlRTYnlpdkxIdkhjR2xHN0tReDdJcjhCaEJDcDVoeHRCS09VcmZD?=
 =?utf-8?B?clVzMThYR2hZYndEaFA5NlgwazBSaC8wMklldmRqcVVZMW16cTQ4K05YMkUw?=
 =?utf-8?B?NG9oRS8xRjU3aG0yYkNvU2NPaWExR1N2V3F0MlRpZk1yNFNzR1d2UHdRbjVl?=
 =?utf-8?B?M3UwUnBpUXJJSmx2KzY1SHd2c1JVMXpmU0FrSDNMbTRJSlljVitMWG43WCtW?=
 =?utf-8?B?Ukd0WFNaTmpNbitCVUNSQ0RIemlEZ3RhYS9pWVBIUm1ZdmhBMTBGVUZ3L3E0?=
 =?utf-8?B?QVMrWEg2bFducFc1dXBpNUFLdVhxNkc3V00yVFBZMFRjUXMzS2xTSGtmT3A5?=
 =?utf-8?B?eEFpdnZobkVDL1dtaXdSTUFJRlFFdDMxbXExd05jWTAvZ1Bsck5CYUFRSHZQ?=
 =?utf-8?B?Z1AxQnhxWlpCcEM0WWVCMWN4Uksyc1c3dkRHZ1loM2ZjVy9tbFRJeFVnUGY5?=
 =?utf-8?B?TmxER1NRdmEwRGFRNkJkaTI1eDl3ZGF6WnBhL0ZvSlZKR2NKM1l4L2UyYWU0?=
 =?utf-8?B?RDNHRXV3alNLbTAvdlk2bmZBZFk5cUFZMUdxeWthYTZDU2tadiswVG82dTB5?=
 =?utf-8?B?TkRFQ1VtamkyU3pnUURKdmp0ZkdnUW9qWDVTbnpoZkFNaXhkanM5dHBYSFVH?=
 =?utf-8?B?aVkvRjUyOWZka1NKdmg0dDFhUlJRSjA3ckN0VHZBUWVnR045VXpPVEhWc3Ex?=
 =?utf-8?B?aXJtTmVLNytXSVRPdksyMnVkckIydHdqUDA1U1E1RkNqbTZwNjU3NzBVWU9z?=
 =?utf-8?B?UmdvOVI3MWN2QTM5R1ZvR1JYalZSQ2w0SjR3bHhjUVlEdGg1QXcvSWltS21t?=
 =?utf-8?B?MGtPaG5taUdUR2hVdVNBSGxxM1lZOHpLVFd6UEYzbG9GN1BvRk1OSnlhdEpo?=
 =?utf-8?B?VlRhVUtHZFhlVVZpczd4YnpTdEV1Q0JxNEkyOGdxd3Y0N2habnZXTmt3V0lu?=
 =?utf-8?B?Vm5BekNRbmVrYk5ZWTdPbmtIYktsU0cwcUJZWDBiL0NzSi9iOU5DQndyWjJY?=
 =?utf-8?B?TkdXZkYwL3B0dEdMRnFpWDlIK0ExL0pBejRvL3drQ1Bjc1hIbThZZ1BJdDVZ?=
 =?utf-8?B?R1Nrend2UTVwUk83Rzk1Q1U1cWZBeWNzeHE5bWtDWEJKVUk0cmdSTU00WTYx?=
 =?utf-8?B?dDdadE1UMnA1c29DcEMxUkdHaDV5SVFMemQ3THNTcjYzK0pRSGdrTGRZQWNV?=
 =?utf-8?B?V0V3QWlGVVErYXJnZ3RmUGNteFpleFZvM2tLNmtCWkZrWkgzYitibmR5Wm5x?=
 =?utf-8?B?cE9QeGJ6UVl2YmRrK09Xb1dwZmE1K3RyVWZFajBOSGpvbzlQaFZqTmlvclBW?=
 =?utf-8?B?Zk5MTytROTk2ckZDZEJuamUwdGFIR3ovcGRZeERvTFlmTUZPQXZVNnpJcU9F?=
 =?utf-8?B?cURZS3oxVkprM3dhUFk1bXZsOWs4QlVUd1BuclVHVEdXc09Qcm02WG1lcjF1?=
 =?utf-8?B?T1dGZDlpbVdEY3FnODFVQnFwUWdlS1VOSjFScDMzZklyak5UUE1ISDRHZENa?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef0bfd6-28d5-4bd8-8ead-08db02c0a243
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:50:58.5962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzU6bmWXO+YWw4vZJyx/0VTM10anpSTsd6YJOboS2ZTlrvwo4mgeXD5UlFOjzByiH0j54qnMf7+34fArWah0HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6730
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 6:11 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Per SDM 3B Chapter 18: "IA32_LBR_CTL.LBREn is saved and cleared on #SMI,
>> and restored on RSM", store guest IA32_LBR_CTL in SMRAM and clear LBREn
>> in VMCS at SMM entry, and do reverse things at SMM exit.

[...]


>> @@ -8006,11 +8006,21 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
>>   	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>>   	vmx->nested.vmxon = false;
>>   	vmx_clear_hlt(vcpu);
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> Uh, so this arbitrary dependency on 64-bit vCPUs needs to be factored into the
> enabling.  And KVM should WARN if arch LBRs get enabled for a 32-bit vCPU.

OK, will add the check while creating event.

>
>> +		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +
>> +		smram->smram64.arch_lbr_ctl = ctl;
>> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>>   static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
>>   {
>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   	int ret;
>>   
>> @@ -8027,6 +8037,18 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
>>   		vmx->nested.nested_run_pending = 1;
>>   		vmx->nested.smm.guest_mode = false;
>>   	}
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
>> +		u64 ctl = smram->smram64.arch_lbr_ctl;
>> +
>> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ARCH_LBR_CTL_LBREN);
> IIUC, this should set only LBREn and preserve all other bits, not clobber the
> entire MSR.

Oops, it's a typo, thanks!

>
>> +
>> +		if (intel_pmu_lbr_is_enabled(vcpu) &&
>> +		    (ctl & ARCH_LBR_CTL_LBREN) && !lbr_desc->event)
>> +			intel_pmu_create_guest_lbr_event(vcpu);
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.27.0
>>
