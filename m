Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DACA4CD351
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 12:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbiCDLXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 06:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiCDLXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 06:23:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280A2137776;
        Fri,  4 Mar 2022 03:22:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mqhs2+3SceH3DxAZod4dieMj0Qh3Wl080lXDrQndHPrR8db6im8ktwdW7RzOks5XdK19GXdnnrMx8pouTtKVUxCHB3j+GcAj1vk1w5SZjRKc9Z1hHB+80HkG3ql9IiM2/km6dCpDEu56Q3Pg1ml9B+scOCk9+Q/ovg5TcSon4Co7JoAicP3iQOqtAfNiY4pP3CbRDef2aGTaxS9n1BxcT9bW988VZXV43haCAgN7cOw3QfuHsWPctygNCqhVezVpQ3dt5vo22IiGz+IrH3phErGAM/kg3RwzDSY5UkxttHjpyPJQXwkrXmcy9196Ab2QFVn6xhWG9CET9lCG25D54w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTmVjO29G0niBlfnYbftvVF5x2QRhPnZBGeyLcwscHw=;
 b=GIyE7lJhn9tAJa7kyiyErR3WIlhWKZHidEDPyQ1PJD8UZaGip4QKQZdWb226DQZyPJr5sFT1SfvY2DUvlGdjFNOHSQBLqKNHHXXtLr8myj2pujI6G3bJAxz31YSDLrfiEuWCUUcU4e8nq8Z0NybtDUzEQPQJFkc/32EhFRJYBpgAI2ydXqs8dnE043nBO/ago3Fe9dwI5pajCGEQ0LP8M04060ZhExMDO/nMtFPY3JlkvLnM4nAc1tYKXGJRYT32uJbeC1OFQgu4PGRA+tBQj37zCw5yxpsJX4y+Ec/sHmkkSzFC60V4LbYvN6Yii0GMGAqx1VWCux/nHpNeoGy6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTmVjO29G0niBlfnYbftvVF5x2QRhPnZBGeyLcwscHw=;
 b=IhtKVRYajfTyZmVcOE4rSdt+vejzOitRQs+U030U+IQiwc750P22ne4XludlhrBdSprVWBVT1eaaVzHMFXweQrNSxJQwpv/2oU2WHQUwVlondrMn1wrcrCFSYLp39+hzbUPt2XFj83jZujGfpmdSEC0unj7cdpl7RKKg1wuUFFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SJ0PR12MB5485.namprd12.prod.outlook.com (2603:10b6:a03:305::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 4 Mar
 2022 11:22:17 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 11:22:17 +0000
Message-ID: <6ff5a6ce-780b-0234-aec5-ef5cff290feb@amd.com>
Date:   Fri, 4 Mar 2022 18:22:06 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 11/13] KVM: SVM: Add logic to switch between APIC and
 x2APIC virtualization mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-12-suravee.suthikulpanit@amd.com>
 <5f3b7d10e63126073fa4c17ba4e095b0fa0795e8.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <5f3b7d10e63126073fa4c17ba4e095b0fa0795e8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0200.apcprd02.prod.outlook.com
 (2603:1096:201:20::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3801cc7d-441c-486d-3463-08d9fdd13d41
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5485:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5485B0A40A8278CC7079477BF3059@SJ0PR12MB5485.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GmApfPfjP8hMtLoHrWYmkL+iL8Ii7vIkuaXU/5aWxhPNlu3sRRL+d8nlcNzkCRXMA2Kmakg4ude5nsZAgGB6bOefAmh5BsZML3YyJF2IKp1EreCpxt/AybA+BGwFKdpBuCLoWIfXNj6PGhQDo5n6tLNCiqBXbH2u/HlpXn3jf/xZIWv6lamajwE5ceiXlkPfk6TFEwrrdXjLyQQyzAP/sacrWQ81tJ4lm0XTs6+3c3ZAyfPABifth2A9mvtZsgD3F87MusSrZCPbeALUWZM1C2xt9Hu/EdAgdk8C9U5X5Rj/0oDK250k4EZQGKk0or895vAfdzEaXfspnLzT8CSVPsJTW+XXxcr3lW770Kad50Dt2VfytkMB4lfUYRxotH8HGh+9qCq2UlcksrUDbwg5Nq4IB8HoaNuEmQHdQxDei9o0j1fvcmYqdB+Z/g8csYk6uU4ygy6gcO0lhDRZ6OoLSxKY3D1y1QD6T7CgnvsdSZVHlPofuZSgMHzhAgcHzk4tq5bX2+8X2IgyN7l5csuO2L82ji0m5bviUvwrl/JLZh41anrKudzajL/COCFoMdGUgQMg3zbJAbUxGb+swIy75vC+04MSys+rfBW6Mi/VjOHHpt8eFysJNmsQqC82QwaMqFdrcJ+hMm4/ydfGdsKdfwHOutijrJfjeQaC52UDc/j13Rj9k7upXgYxxDam8i9uJF1jqJlaen7/v/G/nukTBzZCYtAdQWtIjs1qIW3m3+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(508600001)(66946007)(6506007)(66476007)(66556008)(31696002)(6512007)(8676002)(4326008)(86362001)(316002)(6666004)(2616005)(6486002)(36756003)(31686004)(2906002)(5660300002)(83380400001)(38100700002)(186003)(8936002)(44832011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTZyZmN4d2VsbUhvNkdQQUQ5UXRkT2Z6UVNha3NmTEI4MXhVV1JYR1BpS2Fn?=
 =?utf-8?B?eDJYSjY5RlZ2NTdFQkcvQWs2V3E5TzZYL0paejFUZlpWeFFCaTFPOGhyVEI1?=
 =?utf-8?B?cldKNWk1dFVJODFJaGtQbnRqRGdKM1QyMzhFelhrQkpVUUdwZTVSd2dLN1JF?=
 =?utf-8?B?K1Arbk43azJTaldtZFhqSWswdmQxY0wydVZ0cjJtOVYxVXNkY1lLeXZ3NjBD?=
 =?utf-8?B?ZnRUcGZ4MnRGb1lRc2hydWo3dXBSS2wyVGh5a3p2VnRXMEdhMCs5Y0J3Y04z?=
 =?utf-8?B?Q1Y3SWE3cVQ0dzRlL3hKSExabDlMK1FUK2dWeWJ6Z0RaTDZQUGNVeXVlOHJk?=
 =?utf-8?B?SjV3dmt4N3QyZGxNVXlxL1RYNkdHdGZ0ZVJiWVpsdzN4TnlTbVgxd3FSL1JO?=
 =?utf-8?B?R1FUZzdGOUVnRFdKU2RGZVhCaVRVdncyUUwrcDdaaUdiNVRtcUtBeGhGRlNI?=
 =?utf-8?B?dnVJUWY3cGJMNWtIYlRmb0hTVi9tS0cxS1c4Y1g2WGJwQW4xUkV5emNLTERM?=
 =?utf-8?B?TzhIUmNZNUVuSndjNDNCWE41dDlTMjVNWmlKT0tQdnhtMVFWZTdJU0FtUEtE?=
 =?utf-8?B?YzAxZW8yNlZNUkRZSmtyQklYVmZUTTdoZXdTMnNMV3p3cUYrQTVvclltSGVs?=
 =?utf-8?B?eG5zSTRmaDg2WlYycyt1K2EycTk5Yks3WTQweHd0OGZWS2FUTmhuVVVFSzVn?=
 =?utf-8?B?bXlsanh1WWx5RWhCY1YvZmxmZ0NjemtMaloyN1p3UTdIQjRMdU1CZy92ZUM4?=
 =?utf-8?B?ZU1PU3dncUZVWVhsVm9KOEJNSUJCRjR4bjc5S3QzeGxRSnFiaEhqVWhNMHoy?=
 =?utf-8?B?aGZONjN0YW1NSzRtYUpCVUxkVUIzZ1c0VE9TdlNNNnRGOXBkcmd4Z3dkMk14?=
 =?utf-8?B?clBKblNDVVlnazhQYWJXSG0vaVpFckkvcU85QlRhZll5VlBwUjcvTmtHL3Jw?=
 =?utf-8?B?L0JDVjZWSFZlVFdLTkRBQXRzRTZBa2RtcUM3OUVPWHdFVDFIQmlYVTM0c2Jk?=
 =?utf-8?B?WU9LV3lwemNvOHRVN0kvenpsUXFRRDNvZEh4MWRkMTZ3Z1pnQk92bEg2UStQ?=
 =?utf-8?B?RFozVEtQeEVEbGtZczhJTTZOb1k4RG1pcUN1NHVBTlk2NVdVMUhPWjVqZU5o?=
 =?utf-8?B?VGZsczZSNlkzeGtGeXZWRnQvZzc4eTVFY3lqbVY3Vm52S2xMbnU1MnBRVWE2?=
 =?utf-8?B?bXVUNXNxOHpYY1pOSlZqdTVVQ2FGTjVqTlQvN25QK1NqT2svMlN5YjR3d2xr?=
 =?utf-8?B?ZFNMWHFwdWdYTUZscDk3YVA4VGoraE1aMnNicnc3SFczOWxDWDQ5RGhRelJj?=
 =?utf-8?B?V1gvaHdPWjMwTEl3eFp1V3Y0Tk12WFl0SUlEeENJbjE3OFZ4d0p3R2x0d2s3?=
 =?utf-8?B?ZHRCdE8wVXo5K0FFOHN3Um9nV0JieXRwQWZCcTY4WnhMU1JkaitQQldZRmNR?=
 =?utf-8?B?UkI0a0VWNmZBaGdLb281c2owVzNjL29lUk5tNVFKZzdYUWxiYldYSmhCdzIv?=
 =?utf-8?B?ZjhVWVJDbVpwdTlEc1JyYjFhdDRJVk1vaDJsTkRGOVRiNm55cndtaEpFTGd6?=
 =?utf-8?B?byt1ZVFueEhFUS9wVEo1ZGh4dytQY3NUUG44R3JNUWFZeEdacUQ4dlIrblNX?=
 =?utf-8?B?NVBoWlNCQkxwa1BYWkNwY1d2L0F4UXkxVHhmS1pwWEUvWU5xaS83d0lMWFh1?=
 =?utf-8?B?WUc4Q013RVRNb1ZEelBKb0RIak41Z3E1TFo0R1hoa3RMb0dXUnpnVnQvTEVE?=
 =?utf-8?B?MG9DK0hNVnA3Z0dua0ZScWgxTStwcFNMZmRodS9iVHpzVnJXVHV3a1lrYUZk?=
 =?utf-8?B?alA0cFYzRVBJY1NpZWZ3V05XR3paWGkyUUlmazI4OXhraDhUYTY3ZFQrWVR4?=
 =?utf-8?B?MTV0K2VaczBIa0U3OWJ4TjN0Z2xTZnZtNk51ZDhlU0ppVXdPcnQ5UzlyS3A3?=
 =?utf-8?B?Skp6M0ZaZTdCNFM4YkI4ZWRrbk9IMnJ4Q3dkMVVXejhEVFRpRDk1WkNtOVNa?=
 =?utf-8?B?RWNmaElZeVlMYk1OTTBESkpSV1YxZ0wrakFVTEhLdUJia3NFUTFBakR6S29p?=
 =?utf-8?B?d0NpL0FqY1lEeUlnVElObTJBZE1PakJydUpUNGdxcGQwZURjZ3dMSk45dHAx?=
 =?utf-8?B?UVM4b0lmNjBzbklGcUhMTFkwUFd5WmRTY2w3bC9JSGQ0QlliMGdFR1U1Z0ls?=
 =?utf-8?Q?K2SfTeCSjUU84Durm+SNZSU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3801cc7d-441c-486d-3463-08d9fdd13d41
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 11:22:16.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19P6+y3aZ+t7Onlc8lNKH23g4ml9246MwM7ejp5kb68Mq9K+9MZBgXNwtsLzJ3TpzodRiCABCCDo3uV3aUQ9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5485
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 2/25/22 3:03 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> ....
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 3543b7a4514a..3306b74f1d8b 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -79,6 +79,50 @@ static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
>>   		return AVIC_MODE_NONE;
>>   }
>>   
>> +static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
>> +{
>> +	int i;
>> +
>> +	for (i = 0x800; i <= 0x8ff; i++)
>> +		set_msr_interception(&svm->vcpu, svm->msrpm, i,
>> +				     !disable, !disable);
>> +}
>> +
>> +void avic_activate_vmcb(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>> +
>> +	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>> +
>> +	if (svm->x2apic_enabled) {
> Use apic_x2apic_mode here as well

Okay

> 
>> +		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
>> +		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
>> +		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
> Why not just use
> 
> phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));;
> vmcb->control.avic_physical_id = ppa | X2AVIC_MAX_PHYSICAL_ID;
> 

Sorry, I don't quiet understand this part. We just want to update certain bits in the VMCB register.

>> ...
>> +void avic_deactivate_vmcb(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>> +
>> +	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
>> +
>> +	if (svm->x2apic_enabled)
>> +		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
>> +	else
>> +		vmcb->control.avic_physical_id &= ~AVIC_MAX_PHYSICAL_ID;
>> +
>> +	/* Enabling MSR intercept for x2APIC registers */
>> +	avic_set_x2apic_msr_interception(svm, true);
>> +}
>> +
>>   /* Note:
>>    * This function is called from IOMMU driver to notify
>>    * SVM to schedule in a particular vCPU of a particular VM.
>> @@ -195,13 +239,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
>>   	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>>   	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>>   	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
>> -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>>   	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
>>   
>>   	if (kvm_apicv_activated(svm->vcpu.kvm))
>> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>> +		avic_activate_vmcb(svm);
> Why not set AVIC_ENABLE_MASK in avic_activate_vmcb ?

It's already doing "vmcb->control.int_ctl |= X2APIC_MODE_MASK;" in avic_activate_vmcb().

>>   	else
>> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
>> +		avic_deactivate_vmcb(svm);
>>   }
>>   
>>   static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>> @@ -657,6 +700,13 @@ void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
>>   		 svm->x2apic_enabled ? "x2APIC" : "xAPIC");
>>   	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
>>   	kvm_vcpu_update_apicv(&svm->vcpu);
>> +
>> +	/*
>> +	 * The VM could be running w/ AVIC activated switching from APIC
>> +	 * to x2APIC mode. We need to all refresh to make sure that all
>> +	 * x2AVIC configuration are being done.
>> +	 */
>> +	svm_refresh_apicv_exec_ctrl(&svm->vcpu);
> 
> 
> That also should be done in avic_set_virtual_apic_mode  instead, but otherwise should be fine.

Agree, and will be updated to use svm_set_virtual_apic_mode() in v2.

> Also it seems that .avic_set_virtual_apic_mode will cover you on the case when x2apic is disabled
> in the guest cpuid - kvm_set_apic_base checks if the guest cpuid has x2apic support and refuses
> to enable it if it is not set.
> 
> But still a WARN_ON_ONCE won't hurt to see that you are not enabling x2avic when not supported.

Not sure if we need this. The logic for activating x2AVIC in VMCB already
check if the guest x2APIC mode is set, which can only happen if x2APIC CPUID
is set.

>>   }
>>   
>>   void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>> @@ -722,9 +772,9 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>>   		 * accordingly before re-activating.
>>   		 */
>>   		avic_post_state_restore(vcpu);
>> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>> +		avic_activate_vmcb(svm);
>>   	} else {
>> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
>> +		avic_deactivate_vmcb(svm);
>>   	}
>>   	vmcb_mark_dirty(vmcb, VMCB_AVIC);
>>   
>> @@ -1019,7 +1069,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   		return;
>>   
>>   	entry = READ_ONCE(*(svm->avic_physical_id_cache));
>> -	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
> Why?

For AVIC, this WARN_ON is designed to catch the scenario when the vCPU is calling
avic_vcpu_load() while it is already running. However, with x2AVIC support,
the vCPU can switch from xAPIC to x2APIC mode while in running state
(i.e. the AVIC is_running is set). This warning is currently observed due to
the call from svm_refresh_apicv_exec_ctrl().

Regards,
Suravee
