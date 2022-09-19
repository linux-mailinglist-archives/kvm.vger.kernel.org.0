Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA345BD86E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiISXrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiISXrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:47:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851544F3B3;
        Mon, 19 Sep 2022 16:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN9cI0Zu4J0d6VQGm5PwHj+tFdCgAFQkgXs5J8Hhkuwc8N5jhn8u9Q54qGRFteCfZEGWUfNNJ6xIgzJie7yenSci+b0/rbJeEija/14SyCzGFj3YJYsyTHd3KGt88TYNYms4Ww5DQaOtE0eB+qf1fa7zFYzDvDwnpalflEwu3mrTDIfQEbZ3KjUUk5fJ44Tb1ppFy9QyKELo4pDLS9BKzsxH8U/fzWLSuLshEChpFQX4Zf40TTqeT9hZT4qeSa+iPmmsM7J2UJ2ma78YGjqFdyz3yufd+tO4q1OvyZgrqNdu0pxm6WLHr6ANsPbRxXkA1D6hzg3767q2kxKlm2sVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Df1Qft9DOKFHkGisPgguY/CcqjU/CvKnGNSPmNm+erI=;
 b=EWBWxond+UN6JGFPmcwrTi4Fsu6GDPRUXwUNXpgNBqmiGX4cyrbBAFtg7XwErO7v3ZWYovlv7H4RCjb5+UFw/FPOE9tU3v3vCJKCMZfqUFNmWPaH5pBJzYUtZroCoKLtd/FbrszhgDc4S2gDiJ8TxeQ5jMeg5aG6xulT199ihmLrYAeFs1BrHaSgcdauE4WSyCVFGB/1YolqJlyCPk0FfpVQrAPRk534MoO3aE6Ob81CyA3tkj/VF6PU7ha9mYNxSAggh8T9vlfSBZHgTjFZ4oPxMIUQqA1eliVPlyPHD4abjJA+K/ClGCa0FqLd3CpwtAkkPDcYJa9VM9fkPyAfpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Df1Qft9DOKFHkGisPgguY/CcqjU/CvKnGNSPmNm+erI=;
 b=Xdo9AXS05sQS3sjF70Et0z7EroSpUVmfzef/522AF/7xjeTclgfvce2+E/+Z2MeGPwBkHP5ICEVAdi+Fdf3/0GTswvPg+4Au+c+s4IOcIEj/OHalUJbQUUGv5BCi3AcOg9/cT/dfckSyt3xVw1tcOHnofwSOeL0UaN7FNhhX+8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5343.namprd12.prod.outlook.com (2603:10b6:5:389::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 23:47:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 23:47:01 +0000
Message-ID: <31c1b2bb-b43a-709a-2b7e-0e945b9e8bb7@amd.com>
Date:   Mon, 19 Sep 2022 23:46:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Alper Gun <alpergun@google.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
 <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
 <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
 <CABpDEu=quPsv6cXfbvpsGS2N+5Pcw7inCfmv=sx3-VaK0UE76g@mail.gmail.com>
 <8113b5d4-31c6-012c-fc0c-78a9bdbb1e69@amd.com>
From:   Ashish Kalra <ashkalra@amd.com>
In-Reply-To: <8113b5d4-31c6-012c-fc0c-78a9bdbb1e69@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB5343:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e316d6-8358-4a8c-3090-08da9a993f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTRNTh9uUK7l2luv1/+2KGHAtasU1Y7c5OIVj34rLu3JAd/LQQcsgu2k4UlUC0snBMLFJKVIfGULKE2rZ520RhCeBGligp9B0IH1ZDhdevzFQjYWdvFSpIs9/5y8niqigkZFCxZntNgwGWdc2wT94NS/mt0iOKN0d4gNrqoKKYzaRvVvto6UCaTrQghmwsnyPAWM3Qv9HM5OKr142zTkMtpFu6ciTRiRL8TH0nIURsoG/Sddfwa51Z+pwN/MyhZW26w3FIlIaQVYICXA294fqTW4haa/IuuOvxWpy8M+G0edobUQTbDglQikcQz/3t8fy6nhmwszClKAtocmBsLSOKEnyHtecV/IOO8YMG2vvYQAUMgxFMzdtlRMpfUaApg1429ki2Z6fzFR3UUmpXoXa6RTVB7Mwo5QgCKMNbJJk6rXR5g+ppob3YQsFOq0MDQNTYsPj8BVNDs+1jczVZq5rk/0e6UMieTtzJg+VyGXJoFn5OoSQrEWzRPRWHUNltvI7I6uZ9NrqPzDr02CSbUSxP7ZPBiJcLTAIpjh2Dw7Xvx9fqFLLftODUsQY9rY/UYyGZpDaBtfEs5tfEVTHd6mudLeprYuz8EtA9dRSh+gwgGuMPE6aZVwOCXI54fxBXGTV11sTFOJBURVZ6AjjOwWUUxvZIXphIffmofhlTjHHp7WyOssUxWxqyHvPcCVVfndAzrUTfMFU19SRUcf9CxpZ+PN3Uk6Nx+6ZwmsueTfAyxZwONAZepSnyCTDeP9s4hmuYItUOFikmqloB6KtFFy/c1OOnmtHcXcDEhzF60HVxU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(2616005)(2906002)(54906003)(53546011)(41300700001)(6506007)(6666004)(4326008)(8676002)(66556008)(83380400001)(66476007)(66946007)(316002)(110136005)(6486002)(36756003)(7406005)(7416002)(5660300002)(186003)(31696002)(8936002)(478600001)(6512007)(38100700002)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0t2bGEyYmN5NzhqVmg1TnR3aEt2U1lVTmh5NER0VGVJck5rYXdhTDJVanJ6?=
 =?utf-8?B?ay9DWDduMk9WQnQ2MEp5aXdwU1d1QzZaNy9wbHBzK1UxMFJGY3pYVVVxTktT?=
 =?utf-8?B?VEpmSmExSW1LcnpQaDdXcFV1MFNPWThtcWhOYWF4T3ZFcWNXNm5GeFFlQXU0?=
 =?utf-8?B?cUFJZWZTTWJkNjJVcWo2UzdQNnI4MEFRTktsQjBlUWREakl1OGRYYVp3Z0VG?=
 =?utf-8?B?UEhUK0E5ODR1aFJKS2wvOFQxWGJrZ3VHWjErK3VrNGh5QUlYOXNSSkZrQ0RT?=
 =?utf-8?B?d2JHTDlGM2FNczJUVkxyUk5pRlp1MmFqb0k4U0M4R21paUJUZzBzMkkwQ293?=
 =?utf-8?B?aC9aa2dPakNDTnlrRWViUUhBSlkwWmVOR1ZMZGJXd2dINCtwV0NsUXZlK09u?=
 =?utf-8?B?Z3JQaW9zTkhUOG9UNUI0MGJkRmtuQy83VGhBOHpRdURRRlRCeWhlR051cUNL?=
 =?utf-8?B?dDdNVFRSaDYweVhhNWhSRlYwSHY2b1BVTWMybnk0dForc0pmTFNFZlcyRHFC?=
 =?utf-8?B?ai8vcTMyZTgyeFQxR0F4SjU2T2laNnZkR3dKemFsamE2Z0xuaE5tQjZjTkh4?=
 =?utf-8?B?TXRMMTZnVEtkRVZ5UkV5aHV5QUVQa3hwSm95WmlYd3dqRk1NSjZlcW1ZcXl0?=
 =?utf-8?B?a2pqdjQ3NVZ6WDJOcTJFckFPVlNOT1dCVlZkVm1DVnFic043SEd1ZjlpRGNR?=
 =?utf-8?B?R2xiNWxPN2ZUZXBQNmNJYTRBL2Y1aHB1cEJMaHZPbHRRTnhPUEJkeCt5VWFi?=
 =?utf-8?B?aFFqMEp5MmUrUmplWFVtKzdWTnNKcnd1Si9aNDNsVTNLME42U2ZmNmxQVHJt?=
 =?utf-8?B?OGl6VEZjSjh2WWtkWTkvR1BvWWNSNHlyN1YzQWdWdDNnY2hhUjBKR2RKMHB5?=
 =?utf-8?B?NnNLNXl0VXJtTU5DMUtVa2I0RjNOdFhUQU1qcHpKSDF0VEMvTVBYaVBwSVZr?=
 =?utf-8?B?cGNIVDZtQ05zamNobDZpeEhKdE81SWZUcTE1WFBKUmE0OWdrRHd3UUpoQm4r?=
 =?utf-8?B?UDhqYXJ0aTVKWEtNYmdoYk0xOStxYS85Q1ZxNi83eGxheitLckNUT0Fwa2w0?=
 =?utf-8?B?S3BlVUlGZVdTSldlbitpK3F6aS9pS1Z4WEdFb2plV1FXcG5RZVVmcWdVTW1W?=
 =?utf-8?B?NW82bjdROWVsdzRJa2NLdjRGZWxHSTU4emdVWWs4SVZ4VTFkTkZvdE13bFdK?=
 =?utf-8?B?YXAxaUhhd2JsbEs3am1ZNk1ML1VFUUthSVZ4aDlUOEQ1N25FMEM4bnJFelFH?=
 =?utf-8?B?UGZ1NmpFNGNnaHR5b2c1UWVBSVRURnBOcGt4d2czTUZzMklnVDdzd2FvcDQy?=
 =?utf-8?B?OHZWQkVKQXFjblFpSmM4WEtzd3JkTjJlNWtjeFUwRkRNb1B2eGVncWlvZ1Yw?=
 =?utf-8?B?QTJJVXJlMFFXN0ZPQzQ4WHN1bjNVY3M5bE5mNEJFNmt6VTBMS0tPYXNHY2lN?=
 =?utf-8?B?YUpNSzRodk8wNXU4cmUzaEFsU0FvSFRRYXlQbUl0M0JyTU5WbytHRXdWa0VS?=
 =?utf-8?B?YVVqcWtSTFFubHBLeGZIY1Jpalo4YW50aCtva1RmdDhTa2lDYWV4SUpuL0ww?=
 =?utf-8?B?V1RwT1oycktnM0NwU04vT2xsbGlWTGpiN3h6Y2xxWTNjQnZUTHpnQkswcURm?=
 =?utf-8?B?OWtqLytRaTl0VnlFQUFTNTIwNi9CWWVYWU1LVEVqTzJPTEM1TExwVVAwVng2?=
 =?utf-8?B?cWs0am50UEhjcTN0U1JrdWlKOUJYQnhGTFZEcWsyaklKOTFUTnYzS3BoWlND?=
 =?utf-8?B?TTZKaFpkQVVTdGEvSjQwNWRsVnlGWmpTdEhNZ2pwekhsYzY0NEIzVzhZQ0tp?=
 =?utf-8?B?TXllMVprTlRRbTlFUGhOWWVDenMzREtoSXliaTRqUUYwdHFwckpmdGV1L0pt?=
 =?utf-8?B?QWNsUEFRSXIyYXFrUlhnWi85SFFJMEEwTUJac2VzTUFLNlErUjVYWkc2SVhB?=
 =?utf-8?B?L2FKdFpCTE5HY1B4VWV6MkZtVjNBQWJWRFNIbHpGblgvRjFNSEd2T1p0dzNC?=
 =?utf-8?B?cHVRd0RuREovTEZST1QyYnhaSDR2R1hXazcySGZWcG00bEM1c3pDcy9YRmdF?=
 =?utf-8?B?MmhWYjJuRVk5aXExUkp0Qk4vVUJ2TGJIRXg0cmhuNW54N0ZUNmllUTV2S2k2?=
 =?utf-8?Q?bqbnB/rOO0mBuMdhJvjapWrLD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e316d6-8358-4a8c-3090-08da9a993f44
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 23:47:01.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtIS6ocbAMOcHeGq4R5GJc8CFClLek9kHGx52/QStoH5G6qJEy0FfdFZ7sIe/JPcss3i8KW6SCXcEMRFp0wQLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5343
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/19/22 22:18, Tom Lendacky wrote:
> On 9/19/22 17:02, Alper Gun wrote:
>> On Mon, Sep 19, 2022 at 2:38 PM Tom Lendacky 
>> <thomas.lendacky@amd.com> wrote:
>>>
>>> On 9/19/22 12:53, Alper Gun wrote:
>>>> On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
>>>>>
>>>>>> +
>>>>>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, 
>>>>>> enum psc_op op, gpa_t gpa,
>>>>>> +                                         int level)
>>>>>> +{
>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>>>>>> +       struct kvm *kvm = vcpu->kvm;
>>>>>> +       int rc, npt_level;
>>>>>> +       kvm_pfn_t pfn;
>>>>>> +       gpa_t gpa_end;
>>>>>> +
>>>>>> +       gpa_end = gpa + page_level_size(level);
>>>>>> +
>>>>>> +       while (gpa < gpa_end) {
>>>>>> +               /*
>>>>>> +                * If the gpa is not present in the NPT then 
>>>>>> build the NPT.
>>>>>> +                */
>>>>>> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
>>>>>> +               if (rc)
>>>>>> +                       return -EINVAL;
>>>>>> +
>>>>>> +               if (op == SNP_PAGE_STATE_PRIVATE) {
>>>>>> +                       hva_t hva;
>>>>>> +
>>>>>> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
>>>>>> +                               return -EINVAL;
>>>>>> +
>>>>>> +                       /*
>>>>>> +                        * Verify that the hva range is 
>>>>>> registered. This enforcement is
>>>>>> +                        * required to avoid the cases where a 
>>>>>> page is marked private
>>>>>> +                        * in the RMP table but never gets 
>>>>>> cleanup during the VM
>>>>>> +                        * termination path.
>>>>>> +                        */
>>>>>> +                       mutex_lock(&kvm->lock);
>>>>>> +                       rc = is_hva_registered(kvm, hva, 
>>>>>> page_level_size(level));
>>>>>> +                       mutex_unlock(&kvm->lock);
>>>>>> +                       if (!rc)
>>>>>> +                               return -EINVAL;
>>>>>> +
>>>>>> +                       /*
>>>>>> +                        * Mark the userspace range unmerable 
>>>>>> before adding the pages
>>>>>> +                        * in the RMP table.
>>>>>> +                        */
>>>>>> +                       mmap_write_lock(kvm->mm);
>>>>>> +                       rc = snp_mark_unmergable(kvm, hva, 
>>>>>> page_level_size(level));
>>>>>> +                       mmap_write_unlock(kvm->mm);
>>>>>> +                       if (rc)
>>>>>> +                               return -EINVAL;
>>>>>> +               }
>>>>>> +
>>>>>> +               write_lock(&kvm->mmu_lock);
>>>>>> +
>>>>>> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, 
>>>>>> &npt_level);
>>>>>> +               if (!rc) {
>>>>>> +                       /*
>>>>>> +                        * This may happen if another vCPU 
>>>>>> unmapped the page
>>>>>> +                        * before we acquire the lock. Retry the 
>>>>>> PSC.
>>>>>> +                        */
>>>>>> + write_unlock(&kvm->mmu_lock);
>>>>>> +                       return 0;
>>>>>> +               }
>>>>>
>>>>> I think we want to return -EAGAIN or similar if we want the caller to
>>>>> retry, right? I think returning 0 here hides the error.
>>>>>
>>>>
>>>> The problem here is that the caller(linux guest kernel) doesn't retry
>>>> if PSC fails. The current implementation in the guest kernel is that
>>>> if a page state change request fails, it terminates the VM with
>>>> GHCB_TERM_PSC reason.
>>>> Returning 0 here is not a good option because it will fail the PSC
>>>> silently and will probably cause a nested RMP fault later. Returning
>>>
>>> Returning 0 here is ok because the PSC current index into the PSC
>>> structure will not be updated and the guest will then retry (see the 
>>> loop
>>> in vmgexit_psc() in arch/x86/kernel/sev.c).
>>>
>>> Thanks,
>>> Tom
>>
>> But the host code updates the index. It doesn't leave the loop because
>> rc is 0. The guest will think that it is successful.
>> rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
>> if (rc)
>> goto out;
>>
>> Also the page state change request with MSR is not retried. It
>> terminates the VM if the MSR request fails.
>
> Ah, right. I see what you mean. It should probably return a -EAGAIN 
> instead of 0 and then the if (rc) check should be modified to 
> specifically look for -EAGAIN and goto out after setting rc to 0.
>
> But that does leave the MSR protocol open to the problem that you 
> mention, so, yes, retry logic in snp_handle_page_state_change() for a 
> -EAGAIN seems reasonable.
>
> Thanks,
> Tom

I believe it makes more sense to add the retry logic within 
__snp_handle_page_state_change() itself, as that will make it work for 
both the GHCB MSR protocol and the GHCB VMGEXIT requests.

Thanks, Ashish

>
>>
>>>
>>>> an error also terminates the guest immediately with current guest
>>>> implementation. I think the best approach here is adding a retry logic
>>>> to this function. Retrying without returning an error should help it
>>>> work because snp_check_and_build_npt will be called again and in the
>>>> second attempt this should work.
>>>>
>>>>>> +
>>>>>> +               /*
>>>>>> +                * Adjust the level so that we don't go higher 
>>>>>> than the backing
>>>>>> +                * page level.
>>>>>> +                */
>>>>>> +               level = min_t(size_t, level, npt_level);
>>>>>> +
>>>>>> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, 
>>>>>> level);
>>>>>> +
>>>>>> +               switch (op) {
>>>>>> +               case SNP_PAGE_STATE_SHARED:
>>>>>> +                       rc = snp_make_page_shared(kvm, gpa, pfn, 
>>>>>> level);
>>>>>> +                       break;
>>>>>> +               case SNP_PAGE_STATE_PRIVATE:
>>>>>> +                       rc = rmp_make_private(pfn, gpa, level, 
>>>>>> sev->asid, false);
>>>>>> +                       break;
>>>>>> +               default:
>>>>>> +                       rc = -EINVAL;
>>>>>> +                       break;
>>>>>> +               }
>>>>>> +
>>>>>> +               write_unlock(&kvm->mmu_lock);
>>>>>> +
>>>>>> +               if (rc) {
>>>>>> +                       pr_err_ratelimited("Error op %d gpa %llx 
>>>>>> pfn %llx level %d rc %d\n",
>>>>>> +                                          op, gpa, pfn, level, rc);
>>>>>> +                       return rc;
>>>>>> +               }
>>>>>> +
>>>>>> +               gpa = gpa + page_level_size(level);
>>>>>> +       }
>>>>>> +
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
