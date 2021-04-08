Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A63358936
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhDHQFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:05:15 -0400
Received: from mail-eopbgr690059.outbound.protection.outlook.com ([40.107.69.59]:11062
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231526AbhDHQFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:05:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/7OmKq+2+uO4SdD88aOj0/7sgcUIHIU1ZfzuVtrFw2kHCu5XtNA3RTHQRiqGQu/AXMQcLqKeCmieQ18V3cZSWuk//j5QYK55fsPSv/ES+ILCULSOEShB3L3b2oiOUgTi/MueHT/YFN/EtEtoz9g6IHx3ZoQQarmYTCLQ6I5N/ARAG5GjmwGVuWYxbKiMNPtkbhZia62U/g6rEoQ2q4IEIc+8Cxii/maHoA0b3O/TAg88wb/igx8c5cBfLEB3S4Sik5u6Syx+DuIYpwB1iuNTaS6pyqTzXOCmdNfUMYvJCdLn8k/ApoL+DoG0qtz69tCe+paAmSukPzrYgh1fzOfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEjcsEDhV3nfTLuJ3HBiXyf79tI8P5a64C1kJ/AvCPQ=;
 b=eTXNirf0AKCgbNU6cB5O5/2TvvGlsZ4aPicpBebB0+b4cPgJ3W+KojO91dk58hTX+1DQKM+1DHbWvpciJ4PiTXR4Zb4tw7HwK3U+GNVP5bxDw+JdlkTSrcMfXpVFuOyGb9WX6LhDpwvaKpBTpawWm5uOTzFIZC7/xsOv/61BwHbj7mirsWfjb5Uycv5K8c1XghPVjwI6y0RzwgNU8GMgU2VSVYvNILX9yM3TdVOo5ZFpVxJCMNtXKgfyi3yHDukoxYKk65FVtRxQ6FftXbOfs/yA7pzrEI0vC7tD08yPEmdxX6xpVD9KIiAWPTaCdbF5X94DuQDyPuftlMes5IKFWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEjcsEDhV3nfTLuJ3HBiXyf79tI8P5a64C1kJ/AvCPQ=;
 b=BlzianNqO97tjgTgzy79qcioSPmrmL3Imq4AKspVzmi6ng+v/8oeDQ3AtuslAezrE/TJ8r+jc0B61UrtC9tgcfYYj6Uikno5iDcYdiJOls+/FVO2EX4UW5rxGDM+JzOVTamNa6iDOWmOX10O69DV+pUF0ESdaSZeRZqy4WWoZTc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Thu, 8 Apr 2021 16:05:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 16:05:00 +0000
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
 <YG4RSl88TSPccRfj@google.com> <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
 <YG4fAeaTy0HdHCsT@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b1a6dddd-9485-c6f6-8af9-79f6e3505206@amd.com>
Date:   Thu, 8 Apr 2021 11:04:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YG4fAeaTy0HdHCsT@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:806:d2::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0087.namprd11.prod.outlook.com (2603:10b6:806:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 16:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5524f9c8-554c-4a8b-de2d-08d8faa81042
X-MS-TrafficTypeDiagnostic: DM6PR12MB4124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB412402300B316E2E1E279104EC749@DM6PR12MB4124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stA0kMSfVsTlMjYaBnLhbGOPRQNsSAt34TKz+LrtTN6GgMvRIClr5AvIzF9AorTYph+o7CuYYDblTcswDuhx0+vBWKuQUoZuTxX9Q/b89dWKzo0HZeH7twdctmh6AbkgDoF/PFRV7ZdXrg0+sgK+VLMW6wyB8EQ6WCEqsT6GJp8Qn1IEqTXTLjrOT+p4lHy4vMD2Pq5+xf5M73d/rTPu2rb/mlK3cN8x0GLRWDMmgSixmpIlCQl5Lfnw882tvMpHZOK4jhuUe6rc7GCHO6oUIJvqdA1n3LPvX9U2mhvdyd9tH180OgGH2Kv2zv2WQ7EuoYmzgcTqqjgyeXJ2CcdenLMV4WzaBPQeQ1DjCnEbVMXYPZCarIXQFjjeLJYHes8EdsbSldpaPA6VWLGvGzWuqmFHYn3v1oduVlrLJzcymRWLW5ncyTiCn4/UuM1Wc1s45TdWOakVOtAVpxYGuWRzrvdKsMtMr8eRLk+9769s8c0MOsre1O5/fh9xUyTCYRaaAJiXjoJt+xHgJzlrvAG0MNvuNH2LI6mJIN+o653jk7Lj23KtzuauQgwEqfcudRyCc15ryRfU2qHQBmv+sx+8HTRBqDg6h7SNDAMDUhHGpGahdz3EPS0Ygb8BXjoovxT2j8+BN+3iCUU4O4cJU1tYMThTmtSHr/UhRrlYThK3xPsDOACbWQz1ThsM6yPPJDKC0e8CfYyF3Yj69PwK74JR10AWQgLkS0DanWuBgrfWoyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(2616005)(956004)(8676002)(316002)(66556008)(6916009)(8936002)(4326008)(6506007)(53546011)(5660300002)(83380400001)(6486002)(66476007)(38100700001)(54906003)(66946007)(2906002)(26005)(7416002)(86362001)(36756003)(186003)(478600001)(31696002)(31686004)(6512007)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YVNpUzUvR3Q2d1Y3MndVTUI2eU9iblBEMHQ5akJmWUpBVUpaUUY5eGlncGNW?=
 =?utf-8?B?dlZoR3N6TlFreTB2WFM0Uk9LVzBKSXplOHRScVBKbll6TkVyZGRYT0N5UW5w?=
 =?utf-8?B?UGtjOU1Sa1hQQndNV2s4MklHQXRIVFlYekxFMFljczc2MFhYKzhRN25NMEEv?=
 =?utf-8?B?R2pFYkhneWdGYjdMVmQ4dzNaWGttaFBQOHRwMXRrS2haa1gwN0p6Z0xqY3E3?=
 =?utf-8?B?dUJaVE1EZ0M1WE8vMzdOMVZFbFJtaFpNYzBLQ0tLZS9XeEs2Q3dZUFpkZzV0?=
 =?utf-8?B?Rlg1OXI1RGxBdFhyUWo0Q3RONzhkKzQ0Qm4xVjdjMWdFcU1ESU1DVnFsOHRT?=
 =?utf-8?B?TnhWWU8vdm1rZUJoVHIvSU5vV0t4TnRveWJtVnVyR2VhS0ZsZkdnRFZxVkpy?=
 =?utf-8?B?VzFaSmNMajNlQVhTYjloZnA4TkViekNJQ3d6UlBQM25uK25TZTlHcGU4Y3Mr?=
 =?utf-8?B?TDRDeXJsTzRLMzhIaFMzYi8wWFFEbFFJdjZkU1VQVmtwSW1MWWtidFNRdWxG?=
 =?utf-8?B?aDk4RnFwL0xsK29GRFluWXQ2QUl5V3VRS1JKMWZveTh4MDNOSit3aDFobm9w?=
 =?utf-8?B?S3A4cW1yY25qS3ZFL2lTWU9ucHg5YTNBSFVGd1ZkYnQ4VEdFOHArR09CUm9o?=
 =?utf-8?B?dHFGRVVMZkUyYTlNV2VjemVzek9PS1VETVd6c0RCUE5INUkyZG13MFkyeCt2?=
 =?utf-8?B?NDVpc25pZmxrRFF1ekFyTlM2YW0vV0U5L0hmdkhtSkVGTGdxN1BOclIzaEVG?=
 =?utf-8?B?Y3JPUnBHTW5YbkFpbWNmNDJFM25BQlZqandpc0QyaVRhRXJqeXBXUGZvWXRB?=
 =?utf-8?B?QWkzRzJ5S0NTODNqc1pwb0FOYmM3V1JTcVdoZWYxN0F1blFiODNaUXgzT3lB?=
 =?utf-8?B?ZFE4dVROSFFDY2c4MmpGUDRBL2hxeFhWYmxRNkVVdFZzemwwKyszWkpWYlVW?=
 =?utf-8?B?TzVsT2puU1JKdWtNYVBqMWNBRVNpODlWZy9WQVZ2bTNxWUZrQzFKQUZVOWpp?=
 =?utf-8?B?M29sL0FPSXRpd1dYYTFpMW1oM1M4QXhteEZQRFYzUTdlZGZjSnVRTzJQV2RW?=
 =?utf-8?B?UXNISEdNSG1ZUW5jejBENTFib1Z3bTluSU9XUTkyY0tLeFlPN2ltc0JOUWNr?=
 =?utf-8?B?NnVEaHB5QWx6T1Q0cmpDbUVIZGp3b3R0clN1M0R5U2pKSHQ2Z0tEWTMyWkhx?=
 =?utf-8?B?S3l0NkhqdmZnTHFuU2Q3cmVyVWxXU0dYQzJVSElyalUrWTI2RlY1b2U4TnI5?=
 =?utf-8?B?OXhUSmNTbkQxVzJpWXdMUitTNXR4RjdwdFpkZHl0cjRHWndZZk9VY0wybDJQ?=
 =?utf-8?B?azNmY1NCNTZoZFVmOURzSkxPUS9HR3llcTVaSEtXakFoZXhWZ0xRN3V5bTVm?=
 =?utf-8?B?TWwvcHpTRDVFMzQ1RnB0bmM4Q3ZUeWhmeGdxTlppRE5kQldiaG55MDNXWS9u?=
 =?utf-8?B?cC9Dak5XNVNoYTErd0V3SmRzZ2NzZ1htQTltaG9zQnBlbnE3cm04M0pqK0E0?=
 =?utf-8?B?ZjBHVHVlYlJ3SGIzVU9pbU81RzZ0U3RCR052SFZhNGVmVXNiUXZwV1Y3SkFY?=
 =?utf-8?B?eDRvckQrRU1SQWx4R0VoeXArMWNGTWh3djlOc0psaGFoTXlFOEZBWnlaTVRD?=
 =?utf-8?B?ZDBKaU9NVTd4YWgyRkhieXlja09CWXhkeUNhbDFIWG85aGhMdy8wVC8rZG4x?=
 =?utf-8?B?cHkrejQ4Szk1TXZKc3lxOU1OZ2dhYTJ4ejd1TmRQVURXYXF0dDFZQjJldmlu?=
 =?utf-8?Q?b0nejoGzztnLyZ7rLX+JlTDj12r0EHErjKkH7SK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5524f9c8-554c-4a8b-de2d-08d8faa81042
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 16:05:00.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsS7cXRllJ+DK/UfXR/4Ql7oMK/AvG0FfaLiv1GcvXAtV0arMD6ExHTFc+fw+BieLGzpIFpFEAJV2e5apEZ6hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/7/21 4:07 PM, Sean Christopherson wrote:
> On Wed, Apr 07, 2021, Tom Lendacky wrote:
>> On 4/7/21 3:08 PM, Sean Christopherson wrote:
>>> On Wed, Apr 07, 2021, Tom Lendacky wrote:
>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
>>>> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
>>>> However, if a SIPI is performed without a corresponding AP Reset Hold,
>>>> then the GHCB may not be mapped, which will result in a NULL pointer
>>>> dereference.
>>>>
>>>> Check that the GHCB is mapped before attempting the update.
>>>
>>> It's tempting to say the ghcb_set_*() helpers should guard against this, but
>>> that would add a lot of pollution and the vast majority of uses are very clearly
>>> in the vmgexit path.  svm_complete_emulated_msr() is the only other case that
>>> is non-obvious; would it make sense to sanity check svm->ghcb there as well?
>>
>> Hmm... I'm not sure if we can get here without having taken the VMGEXIT
>> path to start, but it certainly couldn't hurt to add it.
> 
> Yeah, AFAICT it should be impossible to reach the callback without a valid ghcb,
> it'd be purely be a sanity check.
>  
>> I can submit a v2 with that unless you want to submit it (with one small
>> change below).
> 
> I'd say just throw it into v2.
> 
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 019ac836dcd0..abe9c765628f 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -2728,7 +2728,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>>>  {
>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>> -       if (!sev_es_guest(vcpu->kvm) || !err)
>>> +
>>> +       if (!err || !sev_es_guest(vcpu->kvm) || !WARN_ON_ONCE(svm->ghcb))
>>
>> This should be WARN_ON_ONCE(!svm->ghcb), otherwise you'll get the right
>> result, but get a stack trace immediately.
> 
> Doh, yep.

Actually, because of the "or's", this needs to be:

if (!err || !sev_es_guest(vcpu->kvm) || (sev_es_guest(vcpu->kvm) && WARN_ON_ONCE(!svm->ghcb)))

Thanks,
Tom

> 
