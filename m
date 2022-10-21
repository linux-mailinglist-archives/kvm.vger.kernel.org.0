Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604B16080CC
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJUVa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJUVax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:30:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CF826FF89;
        Fri, 21 Oct 2022 14:30:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wjh7RvJghveDcJojyrabnmWVvWie+PxuC/hUP4fH7tY2ExEnYa+DnUkITSTWA6GvTtv4AXAjyOZwTtwCZej7tQq0T8s2LB/h+yhsUVWHnYSzX6MX1r7XLAoS0VMKMIB8GZU7WndRFR647x56Z5rYUZeOl3w4GW2K8ALXwPmsdibSmgwYA9S4rnew+VW+uFpr2MP9zmkiTaMIz316yxhs1i2IvQMksDICcd2TrDtNvwH8uT42TZ81P/r37rqIp03ahvj+gGSqw0OTWZR6te0mknfc1ZuO+Y6zMf5w0V4vGM4771hzhlgAVhfBawmWVQewAu1kiJup5lauOe3vDBAvWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7yEeoyhb87+Zl4u4Hd7zwvi2FlRnCtOdO9ycMwd5Ow=;
 b=OItllNGLQCKSgnVePeaAVsBlL8F+osLzm0OO4ywtFRaI5QK9T56WKM9zNi8jvAerU8ZarofTuzobe+rLek15y2uMAV9wa6ks+DYtlrFf3/+0NNj1phSWi/plP9Ywj/jObzkI+eT7lLttLKkK4dXdv1Y9CTUuvHnUnq6jfdJoxSjSpIVQtPaHebJfncT8ipuajAHMiWXH0vSwa/Olc6HIbFJGyG4OE3/oiDn0xGpEVnzr2Ctvm0xWFKlqaIIgorrnuNE8h3t1Tuul45abLaSq0EChLr19ZSBVY1dSVRn4FdxpQxqKUwOWfqkKQSc9dfdTGVV1rBxoVEbW+8WtU6lf+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7yEeoyhb87+Zl4u4Hd7zwvi2FlRnCtOdO9ycMwd5Ow=;
 b=1Spg/4t/7lFQ2IQMMxp5SXGjFpxrVC8pleYPsOEQMfuPUQeP5+aK/MKBulisjjogDcEX9EKgeZa7CdN01ocTNnKkKLeNhYqy9UqYCpnBrl51wW37ptM/79DHZm4FZ85MJRb1ceaz3GSuuAK0gqyO8q3q6kA4xQK4vU5PpIiOMqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 21 Oct
 2022 21:30:46 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 21:30:46 +0000
Message-ID: <98e24097-c78f-aaec-72cd-c44e962145da@amd.com>
Date:   Fri, 21 Oct 2022 16:30:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
 <27a90573-53cd-846a-e09f-c22c649db60a@amd.com>
 <ad2c2d30-0b67-69ec-d4bb-3521784fda5e@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ad2c2d30-0b67-69ec-d4bb-3521784fda5e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:6e::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: fdea7b90-b375-4735-922f-08dab3ab83f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlrbUjKi7KtGKL9TEvuZd3SFgG1mdxLusNSZN+W6Al0sM0drfkXRgJM/JYMy03e11e6RWfRb9pN/IZfrCtB16TfeIcjpqtTtGeH4nv0Jlo4mu+Cz2GxrSrEswgQgx7ttwpkskKNeP9G1MUeGcWjZmE1oWUfbHAU/jWohXCyxFNPC9ZICW+4f7OPRgaI9x4mHG87OQ8UlsRUe32+FfytZiaEuUqUrpiDodN3/4sB9i9MZyOn/xbIS1iaIXxOxKHSRH+qsU8SB3Glz2v8WWlOFa+SziofoIxYJ2ifCabH3AKRaU3HCT/7Teqmnya6wljC9CPxfFQmZX6858Z6mD58+W3GjjGme9WOZMmNclH2SZTpOiHJT4iRx+ebKC1STEitumr0gpcx2hK6zXZkV9l8HpMHfgc8IKMKNBNB1L6FiXKUpOWgBexS8Qg0v6H4px3JFvZTN5KaAlkIukdG+ppmOFISvSwH7HtYhFNTn8maTGohRlDH1diiUZjdIFAdJsHcSZu27TuMQGfy5zfpk0Jvq3eIPMx6yHyYTnHpE5R/JEiavpKt3XgRoBbWJ5iYNOZg9rEztuSr6cL5w+9xdQNSHXtFRw33ELpM7eDJmabUOmAcYYtHSIqteMviyROaD6Y8+46raR3/SzAcWQxNBhcd1VL0NKI7uZuVKJXJ1tC/mxTY4RiPrIC7dSklcyS6C+OMsrPXpYDWjGOrTl9ciVsWTI6qI8fjG+3LBAj8pcGYjvw0owI0j4HW0H+QaqqfV3fDrQWS3uJGLL27VdXpAn7+F8EDuT3FAD4n3ZQzDKDQIFW4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199015)(86362001)(8676002)(66946007)(66476007)(316002)(8936002)(41300700001)(66556008)(31696002)(4326008)(36756003)(38100700002)(7406005)(7416002)(5660300002)(31686004)(2906002)(6666004)(53546011)(186003)(6486002)(6506007)(26005)(6512007)(478600001)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjI5c2dBTWY3ZXFyS3N0cStDUkF3S29kV2c4cysrZEx5TmVJQzJQTUZnNldU?=
 =?utf-8?B?citSQmJXcjFQNFhhNDA3Um1SWk03RVo5MjI2cEdmc2dwcjI2T0crN1pHUGIw?=
 =?utf-8?B?bkgvZ0lTQjBhV0FBQWRPdDQ5LzRIZCsyTDRCMlk4QWJQTDdiNzU5TWZOejhQ?=
 =?utf-8?B?MWJkQUVRV0FnSjhCbWJTQkx0RFROemYrUmtSZEJaVUhBZ2tTcHFWbllRcXVx?=
 =?utf-8?B?eUJROTcwVXM5NHRTWjBMWnM2RGsxNHovbVFwSDZoOFQ0Umo3TnVPRE9CbjhV?=
 =?utf-8?B?K0N0UDgzZmFIM0FxZkVNYWdPbklpc3A5ZTlLbldWSkJsU0wyMVZzOGlqN0w1?=
 =?utf-8?B?S1NWZFFXUDBNTld4a3dIY3ZIRm1zV0ZNclk1bGxLdENLdFB0bjVoa3dVazY3?=
 =?utf-8?B?U3REeGZMdkxmZ3djZVJqK2krTWQzcE0vZFdJN1A2MVN5aFY4VGROMHBFQmRs?=
 =?utf-8?B?VVBET3R5eWw2RjB2YnJDaE9SNG4zcFI5dWxwQ3dqRzlOenh1WXIwZDZBSm51?=
 =?utf-8?B?M3VKZkxBTHExVkY3LzdkbzVzeVcrNk1zL2l2TFYrdzhGZHhGeENLWVBsQ3U2?=
 =?utf-8?B?TzdhTzZIRm5na3FWQWpDSWV2N0xBcWlPOG9nc0YyUFRTa3pUSzZLK3BwVGJm?=
 =?utf-8?B?NVZlK1ovY3p2WVBBSHU5ZVZ5Vy9WYVZYRG5pMk90V2JQMnFKOWl4M3FraXc2?=
 =?utf-8?B?bGg4MTRHMmUzdmM0TU1MRldSTENuMzFCbGVPZldpUzZYNkdqYzZvOUNvVFM2?=
 =?utf-8?B?VmprL1ljUnY2QzlMS0NMK1c3clpHUG10L0F6alhsSDgxamhCS1hNUjNqZ1Jt?=
 =?utf-8?B?d2x1S09QekRycytaNUNtR3VHYXYyYkZzc2JDUkRVRTl0UUpSQVAvL0JHRVIr?=
 =?utf-8?B?Q2syTmZjN2xmcStoK3FEd2hWZUtlZklicndHdTdLaEl1Z3grcEQyQ3FuNFp4?=
 =?utf-8?B?Nys0NER4bWVaSWgxQnNQS3lmK2pZbVZaRFFidFQ0N1FIUkxOeDhpMWQvREFl?=
 =?utf-8?B?b2tmekFtRGFQYmtNaG9GeDZoWGk3TXdwd2VKRUFMTmd1cktiNFgvSGtkUkhY?=
 =?utf-8?B?am5BQ1I5N3g4ZnlPZ3I2eVF2bHh4Wm4yVW1sZmNpTGp5Yk9sSTdYbjB5VFJB?=
 =?utf-8?B?SzQvYStjZXFiUnFzWEswN3djblE3NmpSNFI0dW9mdzUvS0psYlU3S1ltb1Aw?=
 =?utf-8?B?UnN1ZUtPR21PY3FTMmJLYTVGeXd0bjBjS05vMGMwUE10U3hGVU5nQ2p6LzY2?=
 =?utf-8?B?SWVoaDljWENvZmtXdkNudW9UZWhiRlE5aHFQc3RnUU1TSlFsRE9wSDh5N29D?=
 =?utf-8?B?STBhbktNR21BWEIzZ3pRa3dnbWRxL3JVYmkzWHRkdWJFQ0RDK1QzSFVTNzBR?=
 =?utf-8?B?NTBDNWdhdWJlYlRrSWN6SGYxNVBLVGtra3pSSmNNRFVIbXluNjBZc3I4T0E4?=
 =?utf-8?B?eEF4dGN2TExJdFJQRnVyUTh0a01Idng3d3FZeDNISVJ1Mm9ybDkrQ2htTUxm?=
 =?utf-8?B?bndqN0dvSkZJZjhlN3FOS3U3MHFBUitGTzB6ZlpXOUgvRWdEYjZxdHIrempY?=
 =?utf-8?B?eEg0ZU9RZ0pRdFNuc3FFNm12bks2NjhMaC9vaGkxaWNzUTMxaTRkVUpVV1lx?=
 =?utf-8?B?cmVwMUNucTgycThxQWdHMVBnMzc5NTZDVGU0T2NQRGl5Zy9vWkVBaXlNZWpt?=
 =?utf-8?B?aG53ejl6ZGQ2V1NYeEo1U3NUa2cvYldoT0FFZGdXWDlyUHJ2dCs5aTg4WjdJ?=
 =?utf-8?B?Zlp5eTRnTG9ZL0poNWVpRVZOSzI4b1VpNVhIMFRBRS9DeFZ4Umxrdis2TWd4?=
 =?utf-8?B?dkJ1UDZOa0t3MmYxcWJiM3JQR1ZmWjN1c0NpdGhOa2ZmeEVzMVZHelVQTENF?=
 =?utf-8?B?MFF0OEJ4NWNOd3o1akdYTERjQStTVGxEYUtSQjhhQTRSaVNzQk5LaDNCaHY0?=
 =?utf-8?B?RXQ1ZEJ5MDF4TjZoNEpuMzJURE5QZFN2QnYySjBrOEFHTUF2SXgzUm52U1oy?=
 =?utf-8?B?T2lZbTh4K0JtNWN4dS90NHJsb3JCOHpCeCtEckxmbmcyV2pSWUlxUEpZOVMz?=
 =?utf-8?B?YTJGdk1jL3FzRUhYemxRdTM1bDdBU3lmcnMySWU5elJwZkQxS3dKQkJWeDd0?=
 =?utf-8?Q?bYyCHzT9sPpcKr0UQS2t+NZa7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdea7b90-b375-4735-922f-08dab3ab83f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 21:30:46.1786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98PaVvS7bDKhKsda0OiabGJ3iROhcezL/ul9kmMeU4reQenZs2HJcDBRnQNbyRs4miiTUT8RHQBOaUkjseCSRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/22 16:12, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 10/21/2022 2:06 PM, Tom Lendacky wrote:
>> On 6/20/22 18:13, Ashish Kalra wrote:
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> Version 2 of GHCB specification added the support for two SNP Guest
>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>> make request to the SEV-SNP firmware through hypervisor using the
>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>
>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>> difference of an additional certificate blob that can be passed through
>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>> both the report and certificate data at once.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++--
>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>   2 files changed, 192 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 7fc0fad87054..089af21a4efe 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>
>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t 
>>> req_gpa, gpa_t resp_gpa)
>>> +{
>>> +    struct sev_data_snp_guest_request req = {0};
>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    unsigned long data_npages;
>>> +    struct kvm_sev_info *sev;
>>> +    unsigned long rc, err;
>>> +    u64 data_gpa;
>>> +
>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>> +        rc = SEV_RET_INVALID_GUEST;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>> +
>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    /* Verify that requested blob will fit in certificate buffer */
>>> +    if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
>>
>> Not sure this is a valid check...  Isn't it OK if the guest has supplied 
>> more room than is required? If the guest supplies 8 pages and the 
>> hypervisor only needs to copy 1 page of data (or the 
>> SEV_FW_BLOB_MAX_SIZE number of pages) that shouldn't be an error. I 
>> think this check can go, right?
>>
> 
> Agreed.
> 
> The check should probably be
>   if ((data_npages << PAGE_SHIFT) < SEV_FW_BLOB_MAX_SIZE)

No, the check should just be removed. If the number of pages required to 
hold the cert data is only 1, then a data_npages value of 1 is just fine 
(see below).

> 
> and that check already exists in:
> 
> snp_guest_ext_guest_request(...)
> {
> ...
> ...
>     /*
>           * Check if there is enough space to copy the certificate chain. 
> Otherwise
>           * return ERROR code defined in the GHCB specification.
>           */
>          expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
>          if (*npages < expected_npages) {

If expected_npages is 1, then an *npages value of 1 is OK. But if you put 
the check in above that you want, you would never get here with an *npages 
value of 1.

Thanks,
Tom

>                  *npages = expected_npages;
>                  *fw_err = SNP_GUEST_REQ_INVALID_LEN;
>                  return -EINVAL;
>          }
> ...
> 
> Thanks,
> Ashish
> 
>> Thanks,
>> Tom
>>
>>> +        rc = SEV_RET_INVALID_PARAM;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    mutex_lock(&sev->guest_req_lock);
>>> +
>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>> +    if (rc)
>>> +        goto unlock;
>>> +
>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>> long)sev->snp_certs_data,
>>> +                     &data_npages, &err);
>>> +    if (rc) {
>>> +        /*
>>> +         * If buffer length is small then return the expected
>>> +         * length in rbx.
>>> +         */
>>> +        if (err == SNP_GUEST_REQ_INVALID_LEN)
>>> +            vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>>> +
>>> +        /* pass the firmware error code */
>>> +        rc = err;
>>> +        goto cleanup;
>>> +    }
>>> +
>>> +    /* Copy the certificate blob in the guest memory */
>>> +    if (data_npages &&
>>> +        kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>>> data_npages << PAGE_SHIFT))
>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>> +
>>> +cleanup:
>>> +    snp_cleanup_guest_buf(&req, &rc);
>>> +
>>> +unlock:
>>> +    mutex_unlock(&sev->guest_req_lock);
>>> +
>>> +e_fail:
>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>> +}
>>> +
