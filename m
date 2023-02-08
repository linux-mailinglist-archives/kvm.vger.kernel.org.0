Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBC868EB7A
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjBHJd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjBHJdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:33:06 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC130C4;
        Wed,  8 Feb 2023 01:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mw1Tv6w9x2OpbvRcH8mbvrcgcWzs54oSarc8P32eBrQnYhlhezfCKkAtZj4VYbm6/7xY4pCJa9LXPoiiwTuPkJnpo+xidFw/Mt2FWqVwL4+khC+bIiAX/U2svYtmigCRJmbuL8QiCjCFIzjcU5z2n9jC2mmGlotFIShYEVJmgnEdijpZx0sCl+3ZxsFbyUu/g2vSMrIiB6CvPyZfoYDyHdc3XWAcpgAPjDBwqfH//E1Mn8DhSxS4yB/hvm5DHi4MpsAFK+UvDYYMYhCYWiBsdM4g4XVAnSuNcA5c+RKNWs0jWixgnD6grz+L56SzTiqAgHth4eEsjsk2HMWb3ninGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EPenKhm8MVZE+3vKdyeNgUjEBEO5Z5l0Ty0x9H6UR4=;
 b=ag8xUPT6R5KL0bU4r6vdoj+4rpNvxUn5367wqtEw+/dqLEpnVhW+sRqeDmtWjWmHcB4qz/koB5k4l4ShnWsz2jCxQZdkA92mfv5YowNbk5Unw71ooyE/SR0nccRCAv5S8nd4imSeXjqP+UDo2TzKdrbPpQUYtyzqkVgzsnFzM7RoFAimfsbwtwFkoyj8h7/G/dzWuSdvDsm6m/yJkSuhwpm/NcfKSKAeJYAX8QQYhMcwDcKhkZtw0IagbbQfEavbDfVrL3eygIVSeohW+STWN0jDa2dGRL5nR+zqfJ7c1hg2fSGw04Hf5akcoTNIb3VoI/rkp1BL3lfRIFQckGVo2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EPenKhm8MVZE+3vKdyeNgUjEBEO5Z5l0Ty0x9H6UR4=;
 b=BXOPsYw8bUgk/AajOrWFFoxo8a/Fj5ts88po/+Vu5kxE25opp1/IQ8xpYzd7WDg/fpdOo+1jMb4B38AJOU3hKX8W+4wYtGhJMGMOP7Oa6DZaZn4aSfR7pAYP44pWF0IneHWv8Kh4tGjK5FINcIYEoojssa+iJENnRXxdqbuGwQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 09:32:37 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%2]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 09:32:37 +0000
Message-ID: <374fa3a2-a4c4-1f45-4bd5-17a3c0a13b37@amd.com>
Date:   Wed, 8 Feb 2023 15:02:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9R1w8kfQjCNnEfl@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9R1w8kfQjCNnEfl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|SJ1PR12MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: a16137e0-1495-468a-f991-08db09b76a79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZBTAhVw5dHl7p0IQpRmMPga3tU0DmHMUTT8OJPTFYdfsoRjUO51dhHZ8rUYc5yIs29feRQzO7cSMsAzsqZSvQGmt/0704Gqszfgf+bYckbccUpfulGXZT4M7wLYaE8fak34ZZub7s5tU1YDRfza8zbqjcg1gJfTFhCQoBjTbQ+QgLx7+pZImgh6SwRVWU2ZkThkXorItDwPrOVCH1sNOnLHoaZG/OR0nw0gVSqG4pUpHmpsuX4Dw8r4c8emG3btvmnmRt1Fc14nf6kqm1+Ydq2VE7lgh2qQqrzjub5zqOwwS/SM9HNdo3RXLdS3llsQVbjDxQGFsmfsls+zH+ozgOx+SP+GXEjjpc0emGmJDh6tABC0IgnvkHwnoWTIqv+S+jDgmTgZQHL8gjRB+YTRxjrpQ7FMoNqVWa/wTYCoBMGROSqyELrxqaNbNvlE+uZksV9F95oVzw/APE0Mwo/W2m6sUu3xQV+EZg1LUecOTsPe6XeC2qQ0gBMRLsFbh/nkLKq3/ac5QyPkRa3M2ztdLrmknbOqJoI8kxghNjmWjNHojg662EzdpfrJ9zXIcL0jLbsI0VkoSdt8jgS8hFd/X5rnhb8A2rhe5pLWZrLeJ1s90JryPTaohUtDxjijGUMJrx3zlywdTlKsnUfYt2hEKg3vDLGJLpqlhiUaQ1Kg0zKpIWHAmdgdKBHOhT/90HQyGoqD8eykLAkpE5ylenC9Yw2aMIL8hPmId/PSa98SZVY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(5660300002)(44832011)(36756003)(7416002)(2906002)(83380400001)(2616005)(38100700002)(8676002)(66946007)(4326008)(110136005)(54906003)(66476007)(316002)(8936002)(41300700001)(66556008)(6666004)(186003)(31696002)(6506007)(53546011)(26005)(6512007)(478600001)(86362001)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enRCbEJyOWlZNStzREl6Y0VIQnFHeFp1SlA3bGc2aEZDUmthQU0zZTdYdksz?=
 =?utf-8?B?dmRwcjJLcEpQcTFuYVFvL0tFY3VlRUlDZXhqK2ZkTUI4ZUpvOU90bUJwUEN3?=
 =?utf-8?B?RHRQK3pxMjhuQ2FLcjhpUU45c3RIcExZZld4L1dSTUhnQXZHcWpRdUlqTENG?=
 =?utf-8?B?OUwxV09kMmtBLzVPWUdKN2gwd3NQcGlNcE1qUEVmeWE5TmlzbElXUnlUam9q?=
 =?utf-8?B?ZWw1dFlqQjVvWmo2eUF5a3VCVGJWOC9PbC9IQ1ltYXBIN3VqY0hKazlnRXZR?=
 =?utf-8?B?SFZhRHVnZUNQQWFYSGNGdlk5VUt1M3ZrNlhtcTFnTTNCQ1dNME9BME9hOVVZ?=
 =?utf-8?B?Y084UGlwaEFsOVRnUGtMYmY4YmgydGg1eXhkU05rMVF0Wi8xK2ZEUStyTURy?=
 =?utf-8?B?YWhWcVM5Q00rbGdXRGpsWlFuM1JLTnpSUnBIM0FmdUZBODRqbTYzUXRTZm9F?=
 =?utf-8?B?T2FZZ09LTXdmdS9PVG5USGsreFNka0NMbjZJNlMrWE5iYXR5VXF5MHIzdkoz?=
 =?utf-8?B?ZnlWZm1VRnFPRVFqYVRLc01tTTlNcXVTVFE0cTAvYU0rR3RRTkxRUlZOVVAy?=
 =?utf-8?B?MjkyazMxQ1ExeHlFSUs2b1grZjBMSDRSZHJyaDZmZXFCYWhPbDVhNW5FdGNL?=
 =?utf-8?B?dmVYeC9tVUpWRTFFOXpQRHB6eWlPZUhVeGM0VFRoNjlPZmZVek5zNWoxYXk4?=
 =?utf-8?B?SmNMRm1hZFZLcmxId3NESCtVVmhWdmVwMGJtcmFUMXArWTk4clA5NGZKMG9s?=
 =?utf-8?B?cW81QmF1N2VlYnBWeHZWaGgvZU9IVDlQM0tLcEY3VWdpVzZHSzhmcXZHV3kx?=
 =?utf-8?B?STBmemlGWk51MXRZcTJiVzJMRFZLQURvQ0NzWTd6ZnBrMGxwb0N0NlI5T2ZN?=
 =?utf-8?B?NXdaWmZZWUxSUnlnRXdXb3owazk4Q3Z3QmxEWlhRWE5uOTZDeFJDNFpSQUE1?=
 =?utf-8?B?SXB3Y2lOYWs1T2ZqcWpPM29WMGpEaTJhU2lrdTZuWDB6VGgvdjFxV0FYamJs?=
 =?utf-8?B?aXNObGp2cjlpbXJLaWZxRkd1UFlkeGxUM2ptM3BZM1QxZ1laM2o4eGtodXMz?=
 =?utf-8?B?b1k2ZGozMGZGSlIraU9qSmFtQnVrQW1ORkNzOUNNSHliVXZBTFNMbno5emU0?=
 =?utf-8?B?R3hBaGFBTHZGM3RLSmRTNDVYTHNkc05VbDJtdFNkL25wWlBDUzRhek1keG8x?=
 =?utf-8?B?cFdMZTVaUlJXYko5ZmFRdzQ0T3dwNmtFWEd5THp4bDVST1l2OU5hMm5FYlpJ?=
 =?utf-8?B?aVRkWVl1Z0REdG1kSTlxYXA5cGNMUThtMlQzR2NJdVYvTy9FQkorNzlkRGtv?=
 =?utf-8?B?cFhyalA4VWpDN3NITGp1T3lkeW42TTF5NDhCenc1UityVU8waHpLZlJraUN3?=
 =?utf-8?B?SEtrVVJlVkZTS1FBNjJ5TElBZkZlaFJSUjQ0YUlGZmtRdnI5b3UzMU0vRFlO?=
 =?utf-8?B?d0ZiRmV1d3g3dTBRNmdwQVFYcGxoWHZseFkxck9XcXRxU0tWRlVWcWtFOHJi?=
 =?utf-8?B?Uzk4R2Q3aUJrSlJVVnhscjFuOFFHYkpYTGJZQW1vM25SbTkrcnozaVJTL0p0?=
 =?utf-8?B?SDVtQ2gyZWVtOGRuVFFSMDJia1psaTJSVFNiL2tmWGI4aUJ6T2ZVYndjOW5X?=
 =?utf-8?B?Nzd2cERtdEVqSFVudnNVZERvcXVzdjlGZTd4clBVT1lrNnRQME5kekhlQTIw?=
 =?utf-8?B?SW1mUjkraE4vVWovZXhxemdudkNjRHR4RnNyS05iQ0ltMWhLTUNUcGJ6Skg3?=
 =?utf-8?B?ckF4MmlaUG4vN0Nib3hDSng4OVpVQ3ZudDE3LzRQY0xpT2hkS01GaU5qZFJV?=
 =?utf-8?B?TDJvZC92MkU2SVh5UFZKOXJvMVl6cStZeE5GVlhVenNZZU5FZ3BJMnE0TURD?=
 =?utf-8?B?K2tRMFlxMHpJM3huTWh3b2VudzFyOWNlenhkWVk1UGRFb2x6dUlGWlFkVUZ1?=
 =?utf-8?B?S0x2UFdDUDJ6dWJZVmlTTkxPNU03Nm9NN2xOdHA5dkZnRjJRTStlRmdNRzN2?=
 =?utf-8?B?blRIVDdvNldYMjBLcXVIYTRuV09WQ1VOUm1SZzZHcXFqSGdsZWsxaEFUK2Vp?=
 =?utf-8?B?aE84ZTJMU01pWFJKcDJUNlI5VFZ0ZTFlbDM2Mm5XZE9mbjhVclhNN2VoclJC?=
 =?utf-8?Q?nmKgj7aaBlhwQBAXXZ686PolF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16137e0-1495-468a-f991-08db09b76a79
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 09:32:37.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmS0oFta1uZKR26Lxpuzug+NScju7GIle81fEXQU5FiguBzBgZnmaFnB9XH5L2PLF+ZLIT7xeAuiJq430DjpUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6218
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2023 6:39 AM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>> This patch adds two new vendor callbacks:
> 
> No "this patch" please, just say what it does.
> 
Sure.

>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 684a5519812fb2..46993ce61c92db 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -871,8 +871,13 @@ struct kvm_vcpu_arch {
>>  	u64 tsc_scaling_ratio; /* current scaling ratio */
>>  
>>  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
>> -	unsigned nmi_pending; /* NMI queued after currently running handler */
>> +
>> +	unsigned int nmi_pending; /*
>> +				   * NMI queued after currently running handler
>> +				   * (not including a hardware pending NMI (e.g vNMI))
>> +				   */
> 
> Put the block comment above.  I'd say collapse all of the comments about NMIs into
> a single big block comment.
>

ok.
 
>>  	bool nmi_injected;    /* Trying to inject an NMI this entry */
>> +
>>  	bool smi_pending;    /* SMI queued after currently running handler */
>>  	u8 handling_intr_from_guest;
>>  
>> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>>  	 */
>>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
>> -		limit = 1;
>> +		limit--;
>> +
>> +	/* Also if there is already a NMI hardware queued to be injected,
>> +	 * decrease the limit again
>> +	 */
> 
> 	/*
> 	 * Block comment ...
> 	 */
>

ok.
 
>> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
> 
> I'd prefer "is_hw_nmi_pending()" over "get", even if it means not pairing with
> "set".  Though I think that's a good thing since they aren't perfect pairs.
>

Sure thing, will spin in v3.
 
>> +		limit--;
>>  
>> -	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
>> +	if (limit <= 0)
>> +		return;
>> +
>> +	/* Attempt to use hardware NMI queueing */
>> +	if (static_call(kvm_x86_set_hw_nmi_pending)(vcpu)) {
>> +		limit--;
>> +		nmi_to_queue--;
>> +	}
>> +
>> +	vcpu->arch.nmi_pending += nmi_to_queue;
>>  	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
>>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>  }
>>  
>> +/* Return total number of NMIs pending injection to the VM */
>> +int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.nmi_pending + static_call(kvm_x86_get_hw_nmi_pending)(vcpu);
> 
> Nothing cares about the total count, this can just be;
> 
> 
> 	bool kvm_is_nmi_pending(struct kvm_vcpu *vcpu)
> 	{
> 		return vcpu->arch.nmi_pending ||
> 		       static_call(kvm_x86_is_hw_nmi_pending)(vcpu);
> 	}
>

Yes, this simplifies things.

Thanks,
Santosh
 
> 
>> +}
>> +
>>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>>  				       unsigned long *vcpu_bitmap)
>>  {
>> -- 
>> 2.26.3
>>

