Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFB64CBE93
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiCCNNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 08:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiCCNNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:13:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B0A26F;
        Thu,  3 Mar 2022 05:12:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Khw9GpedO2Xb97RtTjsDlNE9OU29WCWgTY8Wc+gilnxMtrWB7kEvgQgwcPcp0F3g2s4P/KrIPWGLdZFzb88tIny+YiCdp93HzIKZzGZZjndg+1UQQwGeqBCh28GPImDRWeojXltdBD9E91tiqHViDqb6MVZpS3GFFSTKflr37W+QPj8VyEXDRCW/xZCXRmHbuh+AYLT7JdaxIo044PE1AvMEbgGDBlyFaQjOkUE4mOC+MdmNJHG/2TIHW1p0jLjMqROld+IUL3yb5bSYsukfWVdsriDtgqjJcpK6jN1TfDzEt1RF38saxX8mjmsvT/nEUaoAa3GJEs4jIzsaI5ziLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gVbiMyPES683cOLfIq8YZ7SSgpK0ksX+yFm+lItVJw=;
 b=Nr3ywO3nZ4+vjP1D977vRUKmT9VF76VEMSO2ULWLmCr3z1TCBIEXcJieRJ5jY54jc3754EXWiOrOrwDKqUdZ2jWOqTog5Mzc8tczh+DWbY0/Rn3GXyjuyq4LbE9cK04J7vAVPyKFYin/e+QzbpLno6xdSS5xIcHGFMP6ACYhUueNjPR2r9Vcx64obp/SnNIgmypzkxx/7oDHZjqc7x16wIGE3Y8SHpKG7ZN+zA9MT6VkYaLsyIK6h+Gs8poFec3PP9tBBhfak4WSbJHiVBWlIk/1tdZfphInv0BHRMiDWICO1xMoHqeU/OOHObAGn9ddLQPiH2vGRRD7LpWF5hB47A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gVbiMyPES683cOLfIq8YZ7SSgpK0ksX+yFm+lItVJw=;
 b=T19Brq1/8lVftXXAlpjnfuj926kT6wRc/XPErTUV+XwaJpBGDMnUjEZqPCI8oNd9cEP8wAGffvFKiwGl13+WlPvBaWBjL8iGKmUgiW4ysIXjrs9AtVsorg01u6o95rSh8rBNG4o0e0MJ4U+SPoL9URvm2dqarv14ewGM/RyEH78=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH2PR12MB4955.namprd12.prod.outlook.com (2603:10b6:610:68::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 3 Mar 2022 13:12:22 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 13:12:22 +0000
Message-ID: <c8b8521c-6b9b-6891-21fe-f51c1981932b@amd.com>
Date:   Thu, 3 Mar 2022 20:12:11 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 06/13] KVM: SVM: Add logic to determine x2APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-7-suravee.suthikulpanit@amd.com>
 <334aadda53c7837d71e7c9d11b772a4a66b58df3.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <334aadda53c7837d71e7c9d11b772a4a66b58df3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa0bc1d3-8fb9-4790-6e17-08d9fd17741a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4955:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB49559257ECE8F63F405DD968F3049@CH2PR12MB4955.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XcyseVyMIMO/Tylz2z7QmY1TSx5YCdY1hBIqQ+L1Ujj/yl1/pdhR0gVOrQ2tp7lPKO4FUPxrDtzUgb5daycqATarj2P8MM3Vu1i726mIJsQCnUfwarU7D3KDUO5OmUZRSYXNhEjPveB2BZqYHzw3xh8DJ5Pjk09mtCFb4sD4VZUvKbQv4kSDxVOCpJPUSIPFbSW+fCC4fYs0Lzu1yKPlvA0FXi0M94lLobjuCsEUHj7xCdup23OWnjcukdreycRMN1rS6e+Ip7Z7+pDfl6OcxyTzmkH25glITjH2NoXH3GUhpVghI/XZaOFv/S26RCJlyGuXB7WRBr4Lg35bb5t4WHlDz06ZKE42lc/9xwh05/bwqBA5Mi5oA9FKp3vtVEk180fSW3IljNBZdqRiqPV4/lMmEgP0l0Ecx+z3KR7D9XvCf35b8jGVpAtiBmNKk8OCG+9wuY03pew1xx1Wkv1+X7OSynbjZRb0qweYdv+5UV/24yc5hyKQYbQWac5fXltLTbxAPKq9x6E96DXAW0vq61IOLqGe5Z/3cZ7qfJCTkt5/fhF0FXya4tkB1XsbajQW7P8RwEVi/uGqRgWvDe70tISAQSVZTG3xVZ29LCCJmDtDsCY1S8xlaiyovjzP+sB+1w6gF0vGRau/lGUCo6PD1WMMbnVwjvryjTq5qJzQPLf/lL5mizLb3IkpPSIdpRP8MXXlchew8PlWoLMEpDzppTRyyknLiu6e+q5muqIVfdI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6512007)(8676002)(2616005)(66946007)(4326008)(38100700002)(5660300002)(66556008)(66476007)(26005)(186003)(8936002)(31696002)(44832011)(508600001)(6486002)(6506007)(53546011)(83380400001)(86362001)(31686004)(2906002)(36756003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWcvcmM0cHluR1FJWHdXd1k1Y1FQUEJyUnp6a2tUWXA2a3I5emtxU1lPQzNm?=
 =?utf-8?B?OVM4ZXJiNFRKU21EZ3YySjdLS2ZramFyQS92djVUMU9hYnlkcjBkbWtRN2pX?=
 =?utf-8?B?SEsrdi9nVGZWNlNWRGVDV0tNckZqZjVjKzd0czNvNUMzZVV6VHg4cmJzY2xq?=
 =?utf-8?B?S2ZEWnpnODdWNTRNWUthQTY1YzZpZDI2MlpxcW9UeE5xUWZNL3EzMUp5TllJ?=
 =?utf-8?B?UmlNeHNrdUdDdlJvMkNGUW56UEFMNWZxMm1ZdnRoOG5IS0pKSC9MK1NhNDAr?=
 =?utf-8?B?Qmt1Z1ZUUUtzL09vV21kSFM5cUYxNEcxejRDenhVdTF3STdSSjd3aUc0aVBw?=
 =?utf-8?B?SzhHMHBBTzZ4MWZqd0FacHVoeVA4QWhDN0dibUhUZCs3T3ZVdnJXMGFtNzBX?=
 =?utf-8?B?NFlpditwTWtOZVdPUWY2NWNldW85N0Z1UTQyMDhBak5zVGg0ZUxFRnA2WmJw?=
 =?utf-8?B?aUo1eVB5cVpUU2F3M0dYdHpPTDk5VnJHcDFpYmpEbVQ0NHFwbWtKbWhzbk41?=
 =?utf-8?B?MzF1MWtXYzhDK0JIQXhPek9EYjFRZDZlYThWQ3pucXA3REVremhLSTZqUnZD?=
 =?utf-8?B?T1NvRHJZM2U5VTgwNWJmVVAvVjgxeVppZ0RvZ3VDSVh5SFNZckdlRXVyZ2hr?=
 =?utf-8?B?YXFsOW9YZ2dqZ0g0VVEvZGdSa0lmaUcrSlBhYlhyendTQ0FzQ21ZeXhVYTNR?=
 =?utf-8?B?R2NvR1dIYzFwRnFYYXIyVnNmZ2E3NmhwRFRXSVZwTVQ2cnhlT3A2MWhnT05K?=
 =?utf-8?B?QVVZb3h2dlF4R1R4a2pDdWlEQlY0SmlCZUsxNUExOXB6bTI4Znd1RTh2UFJU?=
 =?utf-8?B?UEQ4RFBCaERoWmxSSUY4WnBhWmwvdW41Y1doZ0ZZNjA0YityUVFiNDkvb1dm?=
 =?utf-8?B?RmxSaHd0bXVrSitVVCtXY0V4cVVVRXNUb21xUjc3TkFGMTRPaVRpVThIN0pP?=
 =?utf-8?B?RkZvQjB5M3ZnYk5Lc2ptZzRmRVZPY1QrSnJlcnlMYmxNRy9LWGFIWDdxMkpC?=
 =?utf-8?B?TGdtV2IwQUtJWmtIdVRtNVJvSS9pRzMzRDhkUC9kOHdFaVJnbmpBcnBTM1Qv?=
 =?utf-8?B?Sjlvc0lWZXhWSk8zZ0hZamVyK2tiT002TGJrSWpwMkVXMEN1OVJCcFBzNlEz?=
 =?utf-8?B?YURVTFFSalpyb0piYjB2Njc5RXYzU3hYYlNXRUVKQmJsWjNoT0JvL21kK3FK?=
 =?utf-8?B?cFdzMm1tT0VKNFVYaHdVVnM0enB2QkdKd3Z4SFBuR0RlcHNwL0FkV1lUbVla?=
 =?utf-8?B?TkE2bU9DdThjUGVLbGQraU9iWGwrd2Z6QzljN0xjNVc3QnZaczJDbkFiT3Ix?=
 =?utf-8?B?ckl6TzdPNGVHcEg0ZDVKLzhUcDRzS0hhZTY1QUFyQTRzOG9aVFh5eXFtMzBT?=
 =?utf-8?B?T09YajNnMVM5NWxpcnd6QXlXTVdKY1Q2OTZMRVh4RDRHSzRwOUZITmdHclVY?=
 =?utf-8?B?aFZSUUFnQXRJWVIrdTVHNlJ2NlNWT21OQ1BYZzcrbWlCRDE2T1Q0OGRyamg3?=
 =?utf-8?B?TTdYdGlXMjdaK0RQTDIycTVqa0d5NCtPdG53a2F2OTBRd1FIdzlZQ21TUzk3?=
 =?utf-8?B?aCtKV003UTNtM2VZN2daeENEaUJ6RkVWM0kvMmFNWVMyTG1SdUpaMm85RzdG?=
 =?utf-8?B?TitrTXlhTnlxYmRqWGhVa012cys4c0xBaWI3bGlSYUg0eXgrMXBJbXNTOTVq?=
 =?utf-8?B?WWRvSFZ0TzV4TUVCMUMyNU9VRld3TXRlOWwycXhMcDNIOGkwNjAxU3l2UTY0?=
 =?utf-8?B?bEZqcnFJb1N6L3MzbThnOEM0L1hlcjdyUEZtUnIzQUNXUjJISERtdXgzMGpm?=
 =?utf-8?B?VTNoMnpKVjVxVGYzVzhrOUlTdEcvOUx5NmRKNW51VDM5cCtxYi9EQXJZZlJv?=
 =?utf-8?B?azBuMHErU2xRK0FNbmt6QjRjcWdPL1NYWnVKWnpZS2Nsa1NaVEdOQTVqNTVi?=
 =?utf-8?B?eUNnRkRqREdJRWVVdUZtTlU0aFZDeDN4elJEWFpHVzdaalhpSU1rNlFiQnB6?=
 =?utf-8?B?QkQvclU2RGYvQ3d2MzlRRjI5SzFSWS8wSjFtcWdVem1nSTRVSnJOMXZubW9w?=
 =?utf-8?B?RU1Ga0xXWXQxZndNN01LcEhKQXR5bHIvNzhQTmxneFZGdFVCU3I2cTVubHlh?=
 =?utf-8?B?am9tUzN2cVliMXhKanluL1hwUWVreGVFVU9LWE51MlFqbitmaGxLUFBFSU9M?=
 =?utf-8?Q?1CRUW9/SCDTxwyXE6QHyioI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0bc1d3-8fb9-4790-6e17-08d9fd17741a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 13:12:22.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2PllMQjg3Z2ehGIkYJyBy8xxb8oOG54qHIccv3anMzACZ1tMEkgAsQ9rigA2jXwPHhaj3pHRHVV4h5jdCdf2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4955
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim

On 2/25/22 12:29 AM, Maxim Levitsky wrote:
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 1a0bf6b853df..bfbebb933da2 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -225,6 +225,7 @@ struct vcpu_svm {
>>   	u32 dfr_reg;
>>   	struct page *avic_backing_page;
>>   	u64 *avic_physical_id_cache;
>> +	bool x2apic_enabled;
>>   
>>   	/*
>>   	 * Per-vcpu list of struct amd_svm_iommu_ir:
>> @@ -566,6 +567,7 @@ void avic_init_vmcb(struct vcpu_svm *svm);
>>   int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>>   int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
>>   int avic_init_vcpu(struct vcpu_svm *svm);
>> +void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
>>   void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>>   void avic_vcpu_put(struct kvm_vcpu *vcpu);
>>   void avic_post_state_restore(struct kvm_vcpu *vcpu);
>
>  ....
>
> I also don't think you need x2apic_enabled boolean.
> You can already know if a vCPU uses apic or x2apic via
> 
> kvm_get_apic_mode(vcpu);
> 
> in fact I don't think avic code should have any bookeeping in regard to x2apic/x2avic mode,
> but rather kvm's apic mode  (which is read directly from apic base msr (vcpu->arch.apic_base),
> should enable avic, or x2avic if possible, or inhibit avic if not possible.
> 
> e.g it should drive the bits in vmcb and such.

I'll also clean this up in V2.

Regards,
Suravee
