Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F6517143
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiEBOL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 10:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236886AbiEBOLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 10:11:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D4565E8;
        Mon,  2 May 2022 07:07:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iE+EQBrL9d2PH70AJGBrzanINsdbe6R201rWAN7Nx+QBTgFdboXty/SIMC/x7lJp9v8+LFaX/EHlMGyKC2ztrc0ESyfa0rdTFeZx3Z93Kff6sBrlok0/dHtB6jJTSoHnUVJ8hy1qgAdFa/9xknGpRRLB/lln/qRAC/ji8+wFjds4aqjsAUzxNi7sIfZoTEZAPd8TRGOlGP6Sr4ASqqn35ZiZeAy8G8wnLw2ool5sCuFyeYR9upB+3fQMGBcGEZvU9B67+GTdj1jKU35kyVeIQO/il72w9eaOgFU9VIRu4mCfchfb1tW4zdyBXJK54hS+oiIwjyjGCboaTarMCYy9mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53ncLg147Md6qas0lmh8o9YfpeIe3mIs2lVW/UtbGto=;
 b=NwdXGL0ds3akpmWVzE8jHCtXxATBGAD+j6+gbT75h31szBS5Yl9dpk4GsVO2QiE8dCEy2TUhyYzqkxTyPz+nDYlao24Kq31RAU8AYQVEY7m5hmU8/nWlU8yfI9NbEmSy/KoH5+gFZphuLMJ/EvXRx+eh/inOsQV78X06DZxywXnmLXsvlrAt69bW1oISs3DwvLNEERzKpTgSEcpOZOjxcqB96t7gOiwzCgy9UDFPUPQNwDKegw5dMkLJZYxkdNEPBm4Ussk/bnoIimni66K7aEWoHNuVecfOqJuT/O2IeCjZVrU1nrx2HaEvIdk4ftjMy0tq21XOzOJSEBp4uONw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53ncLg147Md6qas0lmh8o9YfpeIe3mIs2lVW/UtbGto=;
 b=euK6/q1hVXsC6i6M8XIGkB2fo6r87Kzyt06awBisAACQYRdXboKnjrfbaN3YPV+GrWJ5MfjPyab5hLOpkgweyq1Gl6yXhJHsmWhdzimmZjkG2npI87rdiR8VI8e/ZLbUbZGj4h8iTuHD+3vzN9Mps2o/Wj9lyLH/Jikg+rKzcUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SJ0PR12MB5488.namprd12.prod.outlook.com (2603:10b6:a03:3ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 14:07:53 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5206.014; Mon, 2 May 2022
 14:07:52 +0000
Message-ID: <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
Date:   Mon, 2 May 2022 21:07:44 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
 <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
 <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae16e21c-a637-431f-cd80-08da2c4525cd
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5488:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5488CD21DB522F0913CFB68DF3C19@SJ0PR12MB5488.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MTVh/uACB689d/fZPm9KJR/TntrnlGBH4CFFX2wjtKcwwm8bnZdDKTjH/cVFJmwF6PTpQLFXMXCC76vUyCK0IBk+N/TEmF7g8PEoM37a0EViW22mrjOxT3HWchleahj+Km32hwKzF8W3/mfasJyB3+2uJ4YJdZvKTsHPRZNCVrs5jElEJqQHbzUbGbwMGYlvLdkdVIGe98Q4MZAdXCO4SRlG3EDshV8o8i6f/rCG+WBObPBY5nP4G5hQ8/UQtdJi/rtSeYcs9hPzWW1ikepLjph+h2h1SsiKXDb6VCJeZtJ2rGHzmkgS0EHd2tekGNJAb027TEvFL3d71WmqxbHne42K3qDsdJruN/oT9NfTU4s9t8aOuGQd/9EtJ9TdVQBSNAicn93r6j1KNzcbyoREFT+6jgqaivxjr+FCCdU+wI+oTGA1ohuEWeH3wSvQyf3uLFw5pZCsCV9xmQRpW+GtnbzWRl5U0IICdSgTefSUkVIQtadb320+0hNnJCQq3LoSCN7RjnrAxnouBnzDXQXutjOGISBTtr24HxualEmbzg3+rVP5neAxtxokUcs6DirEsfD5VHMziX4DYGR+6Xp/IPGYFW86ZQMNB3ovOSIMNqvYlagYWC/2p0aKku0tA1hMnBTOf6WdiMqc6y5SgqC3Ft/owv5WQ1KisjYtqLdzkDX8U1MTfmYg0X0sEsTPZI7MLqfTOoO/x9l2j5Q1GioKXEyKd3zbaDt/mIsqinZ3e4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(15650500001)(36756003)(38100700002)(31686004)(66476007)(66556008)(8676002)(4326008)(66946007)(83380400001)(6666004)(53546011)(44832011)(6506007)(31696002)(5660300002)(2616005)(6512007)(86362001)(508600001)(6486002)(2906002)(186003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVFhV3FyKzBkWmZ3YWZtNUFvWXhoVzQrak80ZUdFTE9sN0haZDdkMHBSWlla?=
 =?utf-8?B?alNOU2N5N2ZMT0pHdWJuMk55dkI3ZUkzZ3huNEN4TzRoZ05KMzd1Vm5vNWdY?=
 =?utf-8?B?NjVIeEdrNzZGVFVLVDJNR21mNDkzbmhOc2xHa1A5OU9FWkJoYnJmV0R0cnEx?=
 =?utf-8?B?cEpWdnNHR2czNTB5QjhFVDlLMkYzT2YrclZqRDl4VHdPbHVNS3VBVnFuR3NB?=
 =?utf-8?B?Vkp0K0RBdzlRMytUYW1MV0QveFpZNjZ3bTlTY3MxWlhvZVVna2dXVU5DLzM5?=
 =?utf-8?B?Znl1UDBMT0JEOFFxZU5FaHNCOXdVZ3dzRDlhV25oRlJuZ3N3bW5PNkRhTzRY?=
 =?utf-8?B?d2VZMllOSkt2V1dhT1h1RWN0eXNNWTU1YnFPSFZvejltemZweUxUTGRVVnhj?=
 =?utf-8?B?dWE2NWhBSjVXeEIxTjZHVnJVMzg5dHhCcVh1cmlNeXRUSnlUaklsU0VXbXM2?=
 =?utf-8?B?RGdtTHR5cXdxeVF4SnBiakVETHpTbTVFWWZBeVdDNjh1bTBWTFAxZ2RzdWFU?=
 =?utf-8?B?MitVR3lXSndmcGNDOC94VnZ3TWJDaXhzZHZEbVk0eWFkYzdHcFcreGNoQzd1?=
 =?utf-8?B?VzIrd0pWc3NiQ21nQktoWW5KSUVDb0JNV0JCUW9ZVURJQmpLU3F6STFuMjFa?=
 =?utf-8?B?NjlmUERuNU80ck5jNDl2MEdZRitHQllkSTI3b2RMY3hnZVZZd0h3ZHppRTF6?=
 =?utf-8?B?V21PNWxLSVBGTkQ4SERSbVVBQ2YzaXFaWG54eGg3R3h5Y1dqM0F2RkxIeHI1?=
 =?utf-8?B?c3BpSlB0UHQwS0NiakpZVzVUSW93ZFJIWXlacEVURWNZeUk4ODE2dzFrZFpT?=
 =?utf-8?B?TmR2NGVRUW1ycjMzRnFoYytrMERvUjUwK1llVk1ISGUxbEVuWUdUeTkxVXc4?=
 =?utf-8?B?bjdhQVZjZnRXU0VEN04rcmJnQWRReVJ6eHdic21ISUpsbVE4MnBvOUtIdTRj?=
 =?utf-8?B?WlV6U3V2M0k0ZVVCOVo3VGo0L3d2MmlDR2s0ZkhRRU91UnZDWTg4cE1Rekls?=
 =?utf-8?B?Tk1BVGZKcjdkVGRsTU1aanBEaFMrNTEyVHJkR1dZcHRRY1B0TFljRWU5QjdY?=
 =?utf-8?B?TUxTYUZQL3IzYmdRcTdza2VlODBvbzRZTkRRUUN0emVFTWVOOUNFTTlJekMx?=
 =?utf-8?B?U016djhSTnRNaGY3S0ZHV09ZNDFTTWNEaStoYVZ3TC9MbTRnbGdFL3dHbUVE?=
 =?utf-8?B?Qi9JNGQvOUorZ0xnbEhPRy9UOFpPZ2V6bmZRSm5CT3Z5UFRQUzZlMXRDVmo4?=
 =?utf-8?B?V3RlajNKZDN6YzVhdFdRbWpvNjRtazh6d2M5QzZXYlh5NkU4bGJCbnZVQWZ4?=
 =?utf-8?B?QXhlRU5PRmJVeFNZN0dtZTF0Z2J0NTBuTW01TzBSV0FZUEpHYlpvdmhPbS9T?=
 =?utf-8?B?bEo1a1VMemRTaUxzc0Uwam00N2pvQ2owSTdQaUZnaTNyb1I3Q1NvNlpQajdw?=
 =?utf-8?B?WmplOW1UNjEvT1JHTXJOUlFibWIwMWNOdE1kM0hyOUVKVllJMFg5bkhVa3Ra?=
 =?utf-8?B?R3JiUG1QSWh3aXNxMi9VZ08xRFBwMTR3SFFINmZ6VE1TcWZmUjhUaEdNQ3p4?=
 =?utf-8?B?NWFNZ010NUZHcDE0MVBDeEtsQzZFWCtqWEduazdyNHF4M1NEaDMxczd0Rmdy?=
 =?utf-8?B?ZVJ5bTZIUWJGYVhoa3hSY24zMElNblowdUxjdkdieVBpVllxL2s2cGRHaXZr?=
 =?utf-8?B?TG5kTkRHMXlBc1lxRkxiU0crNytQb1Q4eDAwUzcwMTU3MUFDZlVVd0RGWXda?=
 =?utf-8?B?U2xlMVdGZnpWRHk3cVF1TUFsVU5SV3VzQ1NaVnM4MHZ2RGxiZStxQUp5U0Vj?=
 =?utf-8?B?SW05blNCWHNybWNnaHA1MUtVMlZmNWNHdUFtZFlIaE5IZWZmblkxL0x0Ynlm?=
 =?utf-8?B?TUdwVGxSZDlTUit1R0FYZ3FGRzlXcHJHRG5Kdy92NkRSMkM1UkZlZEtJa1d6?=
 =?utf-8?B?aGMrTW82Z2FWa3htam40MEtqYkd0bmE3SXF3Mjl0dW5aUkVsMlRoaUorTjlL?=
 =?utf-8?B?N3kvMnRHakJKUTVGbE96Z05WUFR6c2g5SWdtTUYxdUVoazVTYjJrVEtiaEdM?=
 =?utf-8?B?WE9vWEtQeE5IMlN6QitXaGdGUTdFcThpWW02K2ZNY0VRY3pVczJQREt5dUtm?=
 =?utf-8?B?MEpJSkE4aDZSNEdEYVBQemtMN1l1Nkhpd0g5UXQ0M2dId0N5cTRneFNWclhS?=
 =?utf-8?B?NFhvWk9vUU52dWI4UlVHUmVUcGdrRlpXeTEwOHRlK3piMmhpaFpxTldTVW92?=
 =?utf-8?B?S2w4SVg1NFpiTGhYWXFLRmFDUDA5ZjRaWnQwelp0QU5ocWZLeGpIb0lBUkZr?=
 =?utf-8?B?TVNNNUNjc29JeDBVKzFGUXMwQmhRbjI2VWVSZWs5aFVlWFUrZks1ZWY1QW0w?=
 =?utf-8?Q?hzH7OfUhnpp7Xcwbp0knIQTVM/3cpUcoH+jjRNpF4nGKM?=
X-MS-Exchange-AntiSpam-MessageData-1: wkvnfTQJ0m0pGw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae16e21c-a637-431f-cd80-08da2c4525cd
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 14:07:52.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEFnjEtK8/HHdSPRNxuE4qAQVVupoTo14OJgcNkwmxyHlPpOd6p+oOos6vhwQUAvJSH6hbp9vOuPoeNw5VgSmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5488
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim, Sean

On 4/18/22 7:55 PM, Maxim Levitsky wrote:
> On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
>> When APIC mode is updated (e.g. disabled, xAPIC, or x2APIC),
>> KVM needs to call kvm_vcpu_update_apicv() to update AVIC settings
>> accordingly.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 15 +++++++++++++++
>>   arch/x86/kvm/svm/svm.c  |  1 +
>>   2 files changed, 16 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 22ee1098e2a5..01392b8364f4 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -616,6 +616,21 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>>   	avic_handle_ldr_update(vcpu);
>>   }
>>   
>> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
>> +		return;
>> +
>> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
>> +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
>> +		return;
>> +	}
>> +
>> +	kvm_vcpu_update_apicv(&svm->vcpu);
> I think it makes sense to call avic_refresh_apicv_exec_ctrl directly here.
>   
> I am not sure that kvm_vcpu_update_apicv will even call it
> because it has an optimization of doing nothing when inhibition status
> didn't change.
>   
>   
> Another semi-related note:
>   
> the current way the x2avic msrs are configured creates slight performance
> problem for nesting:
>   
> The problem is that when entering a nested guest, AVIC on the current vCPU
> is inhibited, but this is done only so that this vCPU*peers*  don't
> try to use AVIC to send IPIs to it, so there is no need to update vmcb01
> msr interception bitmap, and vmcb02 should have all these msrs intercepted always.
> Same with returning to host.
> 
> It also should be checked that during nested entry, at least vmcb01 msr bitmap
> is updated - TL;DR - please check that x2avic works when there is a nested guest running.

In the kvm/queue branch, I found a regression on nested SVM guest, where L2 guest cannot
launch. The bad commit is:

commit a4cfff3f0f8c07f1f7873a82bdeb3995807dac8c (bisect)
Merge: 42dcbe7d8bac 8d5678a76689
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri Apr 8 12:43:40 2022 -0400

     Merge branch 'kvm-older-features' into HEAD

     Merge branch for features that did not make it into 5.18:

     * New ioctls to get/set TSC frequency for a whole VM

     * Allow userspace to opt out of hypercall patching

     Nested virtualization improvements for AMD:

     * Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
       nested vGIF)

     * Allow AVIC to co-exist with a nested guest running

     * Fixes for LBR virtualizations when a nested guest is running,
       and nested LBR virtualization support

     * PAUSE filtering for nested hypervisors

     Guest support:

     * Decoupling of vcpu_is_preempted from PV spinlocks

     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I am still working on the bisect into the merge commits.

Regards,
Suravee
