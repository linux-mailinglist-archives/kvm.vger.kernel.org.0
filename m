Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF25584B5D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 08:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiG2GGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 02:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiG2GGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 02:06:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F46B24C;
        Thu, 28 Jul 2022 23:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kivefSVoxjXjSLi+/qyaV7eT8YdO9RvqkoT0/pBYEIJBc8FtQdp6x8TgJXSjVZL/yfkT2pPsUwb44A7mrNfTqguaoU9pcB4RJHfvYuPx2XVs6aSejBen2uw9vjSyw6EeNoIJNTd/HWYpD7lw2LlCdfW/8q9OU1Cr2LTVH7cJdGYkEuJvEUGV0SvAqh99rYly6iTX5jADATOyx/a8hmo7WwU/kC2QlV3GWJzgaZsuULWyTzFA7RKF1T7lmY8xySR0s/HLmT5wdalzPYRFLHXRUO+pMjnlGfhIR8g/3CqyA51k7NpqHiz61g1H7bhiNdwC8LjVHi1xH6DRGwrvTm4BHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnA9H+1uM1ZoSijHclKkaEW0o2yJ/jT73MfNgphOE3g=;
 b=PDfYDXvgxcUsgjCpzBcBgYLaM4aKjC4ERIa0XRdTXUUkps1zRvD1WwX4NKy2TaQaCpVGmuHFonG+HXvGyYBeXWfiVXEslHcOucYAfBcHBX0az5ekLjqTGM3Ht+2BgdssAdW95WR+YMxmzcicW0nh/ZHKa9RfnTAVmMbkdXDZ0sEsXGxu83VZv+kG4eZFNfc2OOWpZ3Jabvk70tjtlqV5jOAsx+1qu4zOAeOTOVJN+DJeruIiyxvg+0+gFklNNQJUCEIqS2z+WCds59YCYOnPewnT8qmqRdQHIZuebZEg22L7c2zOvLVv2ax7KBHHPiccpyHHmRRc3theUKIQqfDpMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnA9H+1uM1ZoSijHclKkaEW0o2yJ/jT73MfNgphOE3g=;
 b=ILlc3y1bOsaBwRChlAzSxVt2aMsUDR4/hZkaedLvR6p181Kx+IF+RcOGcdDe4Sczj5HEYIUXpof4BbCdLkiMTb2QN2LiG0CjYYpA7B/T66yk2kYyxXPsVi+4M/ZzhCFmU6Zt9laSK5jhsulmi76Wg5Ehotvxbotz1br4mgUx8hg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 06:06:42 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 06:06:41 +0000
Message-ID: <23b43ea0-0a92-e132-ada3-ebe86dbaf673@amd.com>
Date:   Fri, 29 Jul 2022 11:36:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-6-santosh.shukla@amd.com> <Yth2eik6usFvC4vW@google.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <Yth2eik6usFvC4vW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::27) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ab4bf45-a776-41f2-6a6e-08da71288166
X-MS-TrafficTypeDiagnostic: MN0PR12MB6032:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYfsTyXQYgMFO6HkQZKLUJr2FSl/6YUvZrxcGug8hTaxvv0kn1/QsjCTv5Mr0rS7zU0oks8lO2XHLaSPhz+wbxAl258rApV0uKbVNInGBdtGzQ6h15LaQSd5WBp/873Exkb8zYsRap0bcn5hNzQYyT6FjLv9UQR+sadpi+E8+dX6+RjtPYDWiBfhFx10xhTKNghPEsF9ib1MvoD+2iArYx0W8H8DAceyZNiRnQ3dCk+gcbZqXvJ6JWpxzsz/DlSi0dnB8xElM8wL8+7N4vzNb8IypW6CRFzU1/mo3G02m7tLNTIJ0+j8U/QTMNJMKNK9QZvIFT7Hc1Bfl/CvRBgQZbt3RY1i8IPhQNGzX80so2RQbxxp/7ifE0c5f+iwE8l2+r16rMBRToXyQ2tMKCKvqpgZVE/TlbTJmC94NYE+N9xJah4IBydtmVIVN4yKKCmmrwIHxcy9CRl3PeJk4tszW0mx53eQHZ/nMQX+XzJHKizn5BNW+3mtkvHs77vD/PfRhz4GQSATHPUonoZxj1L3nRbyWSKCWKBq4EYXzHoPX/Skxt2kjA58VBjJoEF7PUpABpwQ5Dos66VI2paCuCoHTFhCnPcKv+a4K91ShiasPU4lPd6hJEeyyxdStqM5RrZbcq6MOM/LlayuGqWWpKrdbsIZO54n2f13RerI22S1n2J0FBM/+nb0W+QFnrpa0ssjC4EoMZi1Xc94uprXLPwD8dbZSZWH2nP1NTFOt4UaZEVHBi0DXCznQGJuTZTpX5Z0lkiAbtVuwplkOBChk2tEA92xsK9J98fPjKPmb9DS1Ttac+5/fa+r3qoLdT1j9ubWD1kYskuJRxwZADTB6UZTpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(8676002)(4326008)(6666004)(8936002)(36756003)(41300700001)(5660300002)(66946007)(38100700002)(316002)(66556008)(2906002)(66476007)(6916009)(31686004)(54906003)(83380400001)(186003)(6486002)(86362001)(6512007)(53546011)(2616005)(31696002)(6506007)(26005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2U4RWZFQ0lXcHowdDllZkplQzlzT2JXa2tHbTgra1hXZnZySWxnSmM3UTJ6?=
 =?utf-8?B?R3VSUFBDZFh1NXY0SDNDSmkvVlk2dVQ5TVZ1dGh4ZkZSZWd3R0tOYjRnM2hk?=
 =?utf-8?B?V012aExYMzlVY3VpUUxKcVJOM1dvNTd5REJ2ZE9zZDBQd25jVFhFY0dtZ3pl?=
 =?utf-8?B?MjRQM0gwQ3JKL0diZHlwWWhKS2EybFdsRTRadDJBS2NJeTB2djJEalBiWXY2?=
 =?utf-8?B?YlVIUTJMelNxck0xdk9wMWNZWDhBQ3l4b1Z3bThLZFNKb25ubmNlOWZYQXZt?=
 =?utf-8?B?VjR3SDRRN0NIejg1S25lZHJNaEVET25MQ2hZQi8rNGpyZjFSQWZ4aFdOUC9H?=
 =?utf-8?B?Z0NUUDNIcnBMRFY1QlhUWWdpWGlIdCtUVTNzUGt6UHhRMjBhbnpmbjIwL2lF?=
 =?utf-8?B?b2sxVjdybkU1WFRUWDI2enhhOWdYYzRpVW9CQkp0ZzIrdEJHbGVtNVRxdy8y?=
 =?utf-8?B?SGYwSDUzYTVYQTZGS0o1N2x6ZmNIVjNET3pVZ0NGMjlmbjBnOFE4ejVBNUdX?=
 =?utf-8?B?dXBJeDljQUpSUmJoY1RjRzkwbHlNTEVNUDFwNXRZVFpGY0NKbkd3WTVKbmtG?=
 =?utf-8?B?TGhlYWVIUHZ1YXpLZUJWTEFVU3hadFlDTmFXZVdkOERaRnYrYzZrcVJhUjR1?=
 =?utf-8?B?NHdyR1h4dEdhaitBUlFyZkNxVCtsbDhrRjVHbk01MWFVV1lkQkxXdzNKd1pE?=
 =?utf-8?B?UzZOMk5zY090andNd2c5Wlgrb2kvbU0xcTJYc2VKZDE0ZlJQTjJ2RGFvNk9Z?=
 =?utf-8?B?dzdzQlE5WmF3T1JxbFN2U3VvbmNQZEEzT0Fjai9lbEF5dmIvZlV0TngvbGw4?=
 =?utf-8?B?dm4rWmZiOW1pRUZYc0djYUNzNllZSmVIRlhCNHg0bUFWSGY4Q0wvdEJDRXp2?=
 =?utf-8?B?MExwVUxQT3IrOWxaWTNtekxmeHhVdDNUQkE5UEtKdmh4Ti9HVTNtYjNhTGx6?=
 =?utf-8?B?QmxLRWFJMU5xdklmdkZYMDBBdnZzbS9KUlVFa1QxUklTV1FLVlU2SHBrUXIv?=
 =?utf-8?B?RFZOblFrQkN5ZGVvVnZDMXJPWXI1YURsVzJvUXZDNm9EMXZJcUtySEVDREtM?=
 =?utf-8?B?enVrUWhQN3ErL01kWTJscTAyMTd6eklIWGNIRlg0T2NET1JaYTdJeUpwTmpu?=
 =?utf-8?B?aCt0aStSc3JDNzBxYVM5NGVzbndiTkU3cFBxNVB6UkkrOVFDRWZCL0d0S3hn?=
 =?utf-8?B?Q2o5WklmUEFHMll1OHRlaGs5Z2h1bUxXcFNUUG01SjVWQWNLMFFqekZFTjNk?=
 =?utf-8?B?T2krb25EVVdXeGtjeCtMQ3hFUGdUZEhNSzlxeG9RK3FnblJWR1hiWklOVXNG?=
 =?utf-8?B?NmE4ZDNLMm9rVEVSVlc2d3lLSFVpUjFESGcvRU1xRnRyeXN4N1J1QjdoN08y?=
 =?utf-8?B?ZXV5YjJuOXUwNXRRVE9tWkkra1NIaDJ4R0RWcll6dENxWXh0SDk2LzBOSXVI?=
 =?utf-8?B?ZEs5a3JHSDljVjBXTW0vOWM4YjVDUlMzbm8vV3RxYkUzbFJ3YzVJSld0OS9v?=
 =?utf-8?B?L2wxNit6U0EyUDZjNDdydnBxTlZCMHBIVStSUTBTTytPYW5CcWFocW1qcC85?=
 =?utf-8?B?VDZjcEJTTkdKaitjVlo2djZmbVlOd0pzV2tjbXY1dklvenBPZ1lKa1drSVFB?=
 =?utf-8?B?enBTaStrWmRPTHFIZVVOeFB2dkZndXd1M1BMSXRLZGJGQy9nTkNGalY1M3Zz?=
 =?utf-8?B?ZjdaMGdWMFhWUmZUYzVZZzJwcSsrYTZveVI4blp3TFJPS1ZTd013ZzVSc1Bx?=
 =?utf-8?B?Q25jMlEvcHVDaUxwZ3BoL0xhYlJjR1JtRlhZc3lFQlExMW1XQWFXZ2gxN2FS?=
 =?utf-8?B?ZzdUeU1icGx3YnBkL21ESmR4OEk3Qzg3S0UwZlFQbGU3TTF0ajl2TzFtKzdM?=
 =?utf-8?B?M2d2YnM3bllRYUNIRXB0bkE1Q0FPazFyVWhoS3NiU3VWczJWcE5TU3RHeDRp?=
 =?utf-8?B?N3dsQ3I2TzZWNUt1eG1DWnVyY3FPS2NVNjFmajdNT0t3NU01V0ZXQTd2Ukkr?=
 =?utf-8?B?d0hObXpSaVpMY0g0TVFYcmVxVnhLdXJMNDF5blYzRDJJVWQ0SkFSMGlyNnls?=
 =?utf-8?B?STJKemhvdHUrNzJpcjF0em1kakxFOFB0N3FGc2VQTXNaUDlUbWJWUEFzckU3?=
 =?utf-8?Q?S9pslcdQJb94T5nhtCkXc/wTk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab4bf45-a776-41f2-6a6e-08da71288166
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 06:06:41.3051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obMqSZL5/k3/OVFwmBKlQUOdYQXKNlxlc53rf/PmSg/e4Deu2ZhG3WCxGgiOFRlJ1o8mc6gWtaX1FNTggosUgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 7/21/2022 3:11 AM, Sean Christopherson wrote:
> On Sat, Jul 09, 2022, Santosh Shukla wrote:
>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>> will clear V_NMI to acknowledge processing has started and will keep the
>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>> v2:
>> - Added WARN_ON check for vnmi pending.
>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>
>>  arch/x86/kvm/svm/svm.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 44c1f2317b45..c73a1809a7c7 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3375,12 +3375,20 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>> +	struct vmcb *vmcb = NULL;
>> +
>> +	++vcpu->stat.nmi_injections;
>> +	if (is_vnmi_enabled(svm)) {
>> +		vmcb = get_vnmi_vmcb(svm);
>> +		WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);
> 
> Haven't read the spec, but based on the changelog I assume the flag doesn't get
> cleared until the NMI is fully delivered.  That means this WARN will fire if a
> VM-Exit occurs during delivery as KVM will re-inject the event, e.g. if KVM is
> using shadow paging and a #PF handle by KVM occurs during delivery.
> 

Right,.


For the above scenario i.e.. if VMEXIT happens during delivery of virtual NMI
then EXITINTINFO will be set accordingly and V_NMI_MASK is saved as 0.
hypervisor will re-inject event in next VMRUN.

I just wanted to track above scenario,. I will replace it with pr_debug().

Thanks,
Santosh


>> +		vmcb->control.int_ctl |= V_NMI_PENDING;
>> +		return;
>> +	}
>>  
>>  	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>>  	vcpu->arch.hflags |= HF_NMI_MASK;
>>  	if (!sev_es_guest(vcpu->kvm))
>>  		svm_set_intercept(svm, INTERCEPT_IRET);
>> -	++vcpu->stat.nmi_injections;
>>  }
>>  
>>  static void svm_inject_irq(struct kvm_vcpu *vcpu)
>> -- 
>> 2.25.1
>>
