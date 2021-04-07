Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FB35762D
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbhDGUhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:37:06 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:1600
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234141AbhDGUhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:37:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkCUMKK5Nq6nh+jizQk3Dv7e1ntY6kPldFUfyp52we0HJ/CN4ILaFxix7+KvdLks/ury4rLvPboKktMUwMUb3hSaJwCstQhboi3w8k+CcNPr/MoIqHJCQnQJ42nxJhT26buuzQnlnwaBSw9s8kcda3W1TonZQbr1TH26KNlQMzGFGYOGIjFRjDSzlVahuRhuma4bLUDZzqjNpzDDaoc0NS2HppfoJ7obZhEy+fZCJrDCnznfZW29aHTj7G+4Jq8+6bfSObaBvwUqfhgb4qk+8I55GTIoOPw9en8nL1/BVYLdUjSlB1ttz6ORL5+cc72HJ+cjGA4ep0JaSmS1rxyDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UaeESwYw3migkh1zYDTB2uj3an+3RfEZhZmxY1ojow=;
 b=dKB1G8hhLJqsHTGUmwYySrClsg9tCEiPsQN+dMRW2c+pD+og0cb7hshJHNPsZEOc/9Bns/jcGsPSwxfMqCSZsFGMTd9OhwtNP5BqhHyp75F4c2mnymeKoJe7zX0JknFy9UTfh4xhjtLSZ86tFIS5fF2wFk1NatnIONkOXud7LueCJbOywEyQcTGDzEn6x24j37pi/EDPvylki2Kv7jbT0+IetDCuZdwF3r5PB+rM1G1Swy89wfA5L7o+UN/ohgQR/8qQ8Uh8k6A4RoiYVnFJYtdgRmODBDgtzJVb0NtSQ6aCOPx9KWllW67G5ESr7aATp1I+kqWqLeedp9wM4VzsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UaeESwYw3migkh1zYDTB2uj3an+3RfEZhZmxY1ojow=;
 b=NE0rKBau4jHoWgYZsUU9gp0s6S2xcp6Vml6em8Adhq8Cqcl09KlmKH2qJloBWLTR5wPMmfPvM1aKqWrzhnGwEUZS49WeczQhpqth/idlZSM1WDgPA6wmE/VXlhqV1pHdLcUMFQYCuKrZd/v9h5xEXxQx1dOLNy/wSt3hjG/vgNE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Wed, 7 Apr 2021 20:36:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Wed, 7 Apr 2021
 20:36:53 +0000
Subject: Re: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
 <YG4RSl88TSPccRfj@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
Date:   Wed, 7 Apr 2021 15:36:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YG4RSl88TSPccRfj@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:806:22::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0044.namprd13.prod.outlook.com (2603:10b6:806:22::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Wed, 7 Apr 2021 20:36:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5cf46a4-ceee-4f63-0495-08d8fa04e0a8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12589CE8738497317A4DAAD5EC759@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FphMT+WuQojtugUUGHbjNXPRn2Fb4Voties3QdHP2SrrwC9SaqVqXaJ+IBEQgMMxRFiruj7CjUt5R3j4CQtSXRBznUwG0nYuU2ntmAZyLmXA1prt9G+ZTVveiUBjE7e6mUAap9Zgriq4gnopwCVB8J0MflVNDfZIGSM0ufFlCHa0vTAFRCJ0h1YDggvdAdNLbMJDOTizrqbTPyRT5izW7GqiSiD1SpXp3MsiGrqd2QwULHzu/5zl+OYBCS6m3PB3ivKdNBlOQ76QeiirDgR8oNlos+LgoTj8xLC3aDeol3GNVarcmF64mtxC+FuYTDl43Xo2WlShgnK4USntYT+8JwooPGAkfaUhhdYoOprPDQYQgZ6/bRmvKsLlHf5pMyYnbI8/G2wdBbGWN/bziSaWuLlufLkiRQSInPvAEt3tQ7abVn/Q1+EsGyon3v3Za7espFtDbNpI6O14FP41uxL5i55Bpw2HvJUkcMqpcpcUG/OCKSNtjxdAsMALiersNJ7VD7p2cdFsDMMSpmlbffLvluQbEURWL4ybngpevhbN6rqe1zaZtKkISpSyr5AWiM+QGObmwT+NLgAKCInRcd2JyiiBgEIn2p7jbn2zLkoWeDP29Dym7nkb+P02mdi9Dj81lkLq4ryXCmalPVxaB1ZO1gyDVMR8tZUhaQRsNGfpsg1rj5eYOJX1lMs4b2tDedo6u44ua3UFa2DfcY2y17VAYwUfINNinjhZDUo+uKxE3Xg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(31696002)(8676002)(6916009)(6512007)(4326008)(26005)(8936002)(2616005)(956004)(7416002)(5660300002)(66946007)(66476007)(66556008)(186003)(6506007)(6486002)(53546011)(38100700001)(2906002)(83380400001)(54906003)(478600001)(86362001)(36756003)(316002)(16526019)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R3lLVFlhZndHTE1obzE0ajhjNTFCZkljNFFQcjJvZHNtd2crQlAzVms0VTJj?=
 =?utf-8?B?M01CWEl2SmRrTWNBalUxMnlEWHI2MWFNOVY1d1dhQ3FkUDRHZkVtekVWU3dj?=
 =?utf-8?B?U012T1FrWTd5U1cwS092OUdPemh0d3V6WjYvTEZsY3VvK0VySzlwUU1SdFhO?=
 =?utf-8?B?NGx6YkVPWkt4S1pVa2ZiRDBCWVhMNUxzcGdpckRaK2hKdmtXWFdOTktZeGVZ?=
 =?utf-8?B?bjNMYUhEVy9pSVliUnZSVWovQmVaWXRtdWdLUStjTTBxTldlT2t3OXE2L25w?=
 =?utf-8?B?aHUxdkVsc05neFNodk80c1R2UVVyMTV1b1QyanJvS08yTWRxL1ZMcnllb3VR?=
 =?utf-8?B?dS9nQSt0MjVvVTFFeEtqMWJLcHJZOVJ5ZVdybEJGOTdIaGFaU05sQjJpdm1S?=
 =?utf-8?B?d3A5eVBiYnQwSWJiWjZJQ21sWXRMcTNrN0lyS050MWVTK21PV0p4ZVpqSFZC?=
 =?utf-8?B?MWpQNWdqUTc3S2hJTTAxRjVCdDhicXYzMENXNmJCQzRYbEFwOStUa01QM2xR?=
 =?utf-8?B?OHh3S0tJMFg5Q1JHYURSaXdTZjJGOThjcmRMSGZuSFhnWVVzMmxmVmkrK3ZE?=
 =?utf-8?B?VTJ6K20xcUlXR1JacG9GdFJhZ2dqVmNLdXd3MkdyNkc4UHR5TW92M3Y4aWE1?=
 =?utf-8?B?TXcrL3NLRmFCdUNBc3JVdDZuL3ZrTmp2Mlh4RkhYMDdCM1FiY1UwaC92VEJC?=
 =?utf-8?B?ZFpHNkVhbFA2Y25kZW9oT1ZTUUdhNDQ4enE3elduR3hDZUNTd2F3TXV2M2Zh?=
 =?utf-8?B?VE01YWlZdStSWSs5TE5hM1MzeG04UjlOL0ZJNHN1ZG4ySkFhazgvSU9IaHRu?=
 =?utf-8?B?MHRaSWUva0gwVUtTVzU2aHNRbHNDbEVOZUVSMEx1WllidXdaN2d2VENNd24y?=
 =?utf-8?B?bHRaWFovQjRiY1VaTmwyUTNIdG41dE8yY1I0NEZRY0xjM3lNY2JPdEo2d3ZH?=
 =?utf-8?B?YUdOTm5WcGZNS1JYWFJOMEdWYnZXQ2V0a3RMQXZqbVhxNk1qckNDTVlpMUs3?=
 =?utf-8?B?aTdGMnlLekExVUZZNWJYK0xXY0MwSEFHR0srRnF1TlRvQTQ4bVltdjhWTXM0?=
 =?utf-8?B?dHBCb0ZBOTRVWG96YnJmV29NV0JyN2VnY05HZWtTQ3F6TEJ5Q3VONVd2NkVo?=
 =?utf-8?B?cTh6c1BZc3d4UUZwbXowKy94Vjg4a3F0OE9tejhpd09udWFOdCtkS3UwQzNL?=
 =?utf-8?B?bFdGeHNiRS9HdkIrcXp2aWxybDBONVlVVGNYZXcyL0drSC91UmNwN21LMWdQ?=
 =?utf-8?B?Z1FlVHA1dk5iS2M1YmE1aVZnMzZyQXk2WHJDM1c0Y1ptRzA4V1hHQTRIRENa?=
 =?utf-8?B?akFGem0vQ3hvMERDTU9jWllXTUwveVZubVFuOEFvamhoUTV5SjdFZmJiMkc3?=
 =?utf-8?B?TTUzZ3RMY0NJV0NVNThZRWxqQmEzL090TndLbWFhbjFsQzdFM0t1QzVOVERn?=
 =?utf-8?B?RWVTL05GNDBrKzZqcWplL1czcU15TDZWVUhpK1ZmNjlsVWU2S1VnSGRKQVhz?=
 =?utf-8?B?ZHpuS2pCRWlZNHJ2MFlJNEpDSnlDV1M5UTZ3Rjh5K1dkQm1SMGZQdmNPV1J1?=
 =?utf-8?B?VFdRbkFUY21CU2NjR3lFVEtUbWkzSlRwbUpQbWpaSXNpUWljbkEwd09TOGdY?=
 =?utf-8?B?cktQUUQzQVI1VFBaNUtnQmtZMnRJQm9EN290UG5kNzBTQm5USHBqcXpCNXox?=
 =?utf-8?B?V2Y5dm53Y0ZCbU91WFU4OFEzREc5N2l2elBXZWZoY1R1a3R3ZFhTczk5eUZG?=
 =?utf-8?Q?9DtkI3g7OHpU+JZbLAmw2UhJKYKKKbtXQk5je2k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5cf46a4-ceee-4f63-0495-08d8fa04e0a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 20:36:53.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ay/9Waa7VbZZzksRuZ2dmRTlWRRUqvu9lYrxK/pFfQ5LwBaMb9r4p4WI9zuXOQUjLkk27pAp5RSvKfTVeRXVtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 3:08 PM, Sean Christopherson wrote:
> On Wed, Apr 07, 2021, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
>> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
>> However, if a SIPI is performed without a corresponding AP Reset Hold,
>> then the GHCB may not be mapped, which will result in a NULL pointer
>> dereference.
>>
>> Check that the GHCB is mapped before attempting the update.
> 
> It's tempting to say the ghcb_set_*() helpers should guard against this, but
> that would add a lot of pollution and the vast majority of uses are very clearly
> in the vmgexit path.  svm_complete_emulated_msr() is the only other case that
> is non-obvious; would it make sense to sanity check svm->ghcb there as well?

Hmm... I'm not sure if we can get here without having taken the VMGEXIT
path to start, but it certainly couldn't hurt to add it.

I can submit a v2 with that unless you want to submit it (with one small
change below).

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 019ac836dcd0..abe9c765628f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2728,7 +2728,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> -       if (!sev_es_guest(vcpu->kvm) || !err)
> +
> +       if (!err || !sev_es_guest(vcpu->kvm) || !WARN_ON_ONCE(svm->ghcb))

This should be WARN_ON_ONCE(!svm->ghcb), otherwise you'll get the right
result, but get a stack trace immediately.

Thanks,
Tom

>                 return kvm_complete_insn_gp(vcpu, err);
> 
>         ghcb_set_sw_exit_info_1(svm->ghcb, 1);
> 
>> Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Either way:
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com> 
> 
>> ---
>>  arch/x86/kvm/svm/sev.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 83e00e524513..13758e3b106d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2105,5 +2105,6 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>>  	 * non-zero value.
>>  	 */
>> -	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>> +	if (svm->ghcb)
>> +		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>>  }
>> -- 
>> 2.31.0
>>
