Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF32A358B65
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhDHRaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:30:15 -0400
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:1408
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231954AbhDHRaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:30:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRzPQ0QBeLgcGs/hVxGKogQfvoZZlUgOSKVM7oOh5VTy/0AkSr2I14P1kM24r1XSKuEgmVT0MbQtfutg6tlFVCKjNeVBjbKCoCYpZx0wWVMDfUN9O/BNrCsmsyKLOycYEXXVJgnbQCf9JFdH+8EbklW4PI5cf2Nz1tqx29YY3pFdBA/XJ5zmZw1GK8bdhtIO/1RtQWNkLsru2QSoMvMcdlK4QO8WLkknTVBUSnH3WCqEeJhBrHMJYRH6PBj94QQ2mJ9+peccVCibMbANQZ8CMLb6UJ7/74G+ApaQlv1xSdbmKCAu0s+bg0EN9AdxfzrvDq1AzkyU0u54PLiFc2Si5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+di0luBdQxJ/yqodedGqg4BqfjjliawVmdICSeHGU0=;
 b=QzNIG16IcPYK/9gyhtu4RszByfEtHbN5NCOSGjU7DLd7LE3hFoMSvvok1lT6aEbLfy0dlDHOF51UwofzeAoksC+5ocCWzg6J/J7gCDrudwnohO1xcRVK21D+ko6lcJeScc7hao1NBg23KI+4ipFbzn688lK1wj2ihyLUCM19AJwUeI8YphXGJVJfFSMWlSsArsgYvJEb6VOlF07//iE9gCnkLf+CRA/AfBgDNt3UpXgNasXfE6Rz+kV1qgCTGKm2X9J/fX70ijFk9oL2ZUMChEoqqpZULC73zx04+Gm5pWRxgjV04gSSIHYPPaausF6tlNHSOH06p8oNyiCKJujxeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+di0luBdQxJ/yqodedGqg4BqfjjliawVmdICSeHGU0=;
 b=QD05PjRziLQrMnlEF3K1fvIcUfNGnKJnjZKxoCND46wXfKZQ2fEk01Uf4LaqnkU4oEtTrZD/SYGMlfsFScZhncmUhrzM3T+ssM7rKR4auQCwYgaj1igmx0n0j8XUyFWxhuSAeJ2TLzMD6qbuLUxJxt7o7QW8M7irzbJmWqAfTkE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (10.168.234.7) by
 DM6PR12MB4862.namprd12.prod.outlook.com (20.179.166.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.17; Thu, 8 Apr 2021 17:30:02 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 17:30:02 +0000
Subject: Re: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
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
References: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
 <YG85HxqEAVd9eEu/@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <923548be-db20-7eea-33aa-571347a95526@amd.com>
Date:   Thu, 8 Apr 2021 12:29:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YG85HxqEAVd9eEu/@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:806:22::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0059.namprd13.prod.outlook.com (2603:10b6:806:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Thu, 8 Apr 2021 17:30:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dfa7d5b-01bd-4d7e-d2f0-08d8fab3f0ea
X-MS-TrafficTypeDiagnostic: DM6PR12MB4862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB48623A1B19BAFDD9B15364E9EC749@DM6PR12MB4862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXlYs/ZacZ9VYECJwdyVkJMP3TsvOFfC4EQ1yk+fqTkc8dVj5H5BoIZp+fKFgrzAnmSXElnt5DxIyT/oGinFIMsS1D4azjWMPe3aMFhzukR8PebDRRqJ+aOuo75ZX71sA5Jhp6Kt0kRr8NNjg0YAlq5OKh4EghJn9i35BvrBtqvHRHxajBA+IZ/cLiIPKMqifbBA3sbyHnHw9Z2xgfQFMjyPsiOZmRN81EBSZdaoKbHwko7q3JsaQqQ9Kkstz+n9AoM+8R+T28/qQ2xCGXZHyHxbq+9KcLIGOKNB93Z4c/tW4RdTolB5rpcI9lWFoRjiwfrHoC15L/BUA0Glb079wkZtiEOwfhmN1Lv4SI030olEO5UFMrLtEfQgYFIaW8KIA46TYzKCq3xL+Gv/mu0Wh7LU/7+QhiXzK262BAXqR05ic5YaNJqCP3OOk7hKdym+NLBZxQSwR5/1dtKF2BDbWAY+PC47Pc5yqY83jWM1zC3p+lRmkW62DHy858GMtTvpKXA6q8edYTyFarcagANUpVcgQPEMiHEmFl9H9RYYOYAf3Nh9/T+akHPm25nB0eRy5ix0HiS4bxT2JDB2GfwKvJlDpu6ArAzBVQ/T69oUqYYX9aYZ6XCJTGlCYNDQg9HsqQ3iggpjQHrcax4wlyYaC4Z7OVThHB7Qkyq3OP778H/c/Xe7WmRcvRpJF2sQ/Zr/6ZGNfowGJoXDxzESvbPAFjNDTo8fEXDRckqbCh+nh7c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(86362001)(66476007)(31686004)(5660300002)(36756003)(8676002)(6506007)(7416002)(478600001)(83380400001)(2616005)(956004)(6512007)(66556008)(4326008)(6916009)(31696002)(38100700001)(6486002)(8936002)(186003)(66946007)(16526019)(2906002)(53546011)(26005)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZjJlR2llUFpoNGpsUjZZUzFDWEpDOVV1UWVUaDFlNmFsRmFMa0hXV2lXVG9u?=
 =?utf-8?B?UGsrWE5qUjZQWUJpWnF2WERzRXlaWWt2R0VvTHBVeS9YOTNkc1V2Zng3UzQ5?=
 =?utf-8?B?aUZHUnlXUjJQam1vNnY3WUUyRThZVThjODlzejg3d0puWHE0NnpUV1ZjZnk4?=
 =?utf-8?B?dXROMHFwdWRpU29qUU5FaVVHZnUwSTNyV0NrYm5zbitTYTZhN2YzVHZoWVNr?=
 =?utf-8?B?eWRmUjkzaHMySUprbmhUYVJVOGVqK1ZndFlTL0xDdE5yOGRWZjlUYjVlTGor?=
 =?utf-8?B?SXpJUHJ0NW0vY3dQdFl1WVFxcDYzYzFSREhDajNYWUNpV3ZlaHVTZW1RSmlN?=
 =?utf-8?B?S1dnbXlQa0NjYy9CUitWLzFnRElPbitYb2dSTEx4bVc5ZmxxQmFiMXZlZGFB?=
 =?utf-8?B?bVc0UGFjSmlaTldWVXJLVkpUTDhmZG5IK2dvazZSZ2xOVEZlUmFYYVo3cHR6?=
 =?utf-8?B?RlFjTFZ6TWVvcHByVHlYWUpIdWhaR0R5dG92Y0E1ZytUQ1h4VWtzU3QvOFRP?=
 =?utf-8?B?TVJlRWNvZENxMTdkK2I2RldSTW5lY0RHMGJFN0xocXN0L3hhbnJzMTBKelBX?=
 =?utf-8?B?dklLUGk1SUhKOFFyamdOOFk2eDU5cVh5cGt2a0U2RzlaNHAzQ3NKcElxK0Jl?=
 =?utf-8?B?aEpaWTVSOHV1TWpKNGJac0NmNkRVcFptYlJWUmxCN2V2N0lXczZmU1pFSFZv?=
 =?utf-8?B?NGwyanBZK0Y0RFBKdDR5b0F3NU5oV010aVRXclVQWGNoQW9VT2ZjVDFQa3hq?=
 =?utf-8?B?UnFSbHU0Y21vcUFiUkJoN1I4VjdUSmVCZi9WZWJkcDRaQmxjSlRyYnR5V2pw?=
 =?utf-8?B?b2pFRkV4bXFHcTg4UXpRMHp2UkJ1TExoVlBWeW9JZWFqZlo3MEY0RjdsekdU?=
 =?utf-8?B?YkY2SE9MNm9lVzJGZWk4eVowaTlLSHRoWTl0S2JtZmg5dU04TW9hTFpLenl0?=
 =?utf-8?B?NUluL05YOHcwZ2N4ZnFBeUNHTG1pOXZaa04vL3J6WXZNcnUveTNEV2h2eE4y?=
 =?utf-8?B?bUdsbGxqS0dUZVh4bkM3SWRDOTAzcmdReEgyLzJWelJ1Q2pleVRpY0xLQnMy?=
 =?utf-8?B?M0FIajJuSzJhVE52RlJPa3RYNmRpanQ0UUx0Z2ZNTjlaeWFvQmV6dXB4dSts?=
 =?utf-8?B?VEQyZUNYa1NRY1BQQVFRaHpsOElDRDhJdlpKaFQ2bWRpU2UrYWFWRHkvdkxh?=
 =?utf-8?B?akRlK0lncUd2aEZpaHJXbGVXYk1pb2M5d1Z2ck1pWWtDVStmazIzaVhrRU1K?=
 =?utf-8?B?dHp2Q0R4eTVxazV4N3FGZHRrMEJBVC90eUJGMTMxK0U3Qk5jSjRVUVBWWWZ1?=
 =?utf-8?B?MkEvZHpFZXJiN0FaZFR0ZHpNTHpCWEJUVlhBTU4wWGd5TndHdmw2aW9ra0RE?=
 =?utf-8?B?QnlIelVSaHJiajVYQ0VvMHFpZE9nR09ZR2ErZG1xMm8rMWRRTGJrWWtaSGRK?=
 =?utf-8?B?bkxyOFU2ZWpvdE5OSDZWWVdDN3ozZllGVUFQaGkwZkM0NnQ3WHd2eFBDTlVT?=
 =?utf-8?B?OFdCM0FoM3pKZHhqSVBhbERzd3JwVFE4UXd0NkQvU3lEZUd6TGdybldTVzQ4?=
 =?utf-8?B?bWxCYVUrL2JieVkrdFhWQjBPN2ZvNkd2R0Z3MEpCWEU2SVQ3UkZVR0phdFdv?=
 =?utf-8?B?WFI4QUxDbTVPcWdSMXlKSnI2aWhEK0pRYVNBV3N4SHcrcm1EZjhublU4WFZ2?=
 =?utf-8?B?VkVReGk3ZHRwVWNNSmV0Q2o1L1BCd1pwZERTc0VnZXdvR2FhMEV1MHZ1dkRX?=
 =?utf-8?Q?ikJ31jVC9dR/igO7LWA6UAOfu2x9VFg2j+FyYNx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfa7d5b-01bd-4d7e-d2f0-08d8fab3f0ea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 17:30:02.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6awZofPSpXp6zbIb9GcRJ1ln57W3Cb49SGC1cb9Mv0LGpx809RPIkMAOre1WZw9s3yastFZm5FVL/z9wkvI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/21 12:10 PM, Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Access to the GHCB is mainly in the VMGEXIT path and it is known that the
>> GHCB will be mapped. But there are two paths where it is possible the GHCB
>> might not be mapped.
>>
>> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
>> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
>> However, if a SIPI is performed without a corresponding AP Reset Hold,
>> then the GHCB might not be mapped (depending on the previous VMEXIT),
>> which will result in a NULL pointer dereference.
>>
>> The svm_complete_emulated_msr() routine will update the GHCB to inform
>> the caller of a RDMSR/WRMSR operation about any errors. While it is likely
>> that the GHCB will be mapped in this situation, add a safe guard
>> in this path to be certain a NULL pointer dereference is not encountered.
>>
>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>> Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> ---
>>
>> Changes from v1:
>> - Added the svm_complete_emulated_msr() path as suggested by Sean
>>   Christopherson
>> - Add a WARN_ON_ONCE() to the sev_vcpu_deliver_sipi_vector() path
>> ---
>>  arch/x86/kvm/svm/sev.c | 3 +++
>>  arch/x86/kvm/svm/svm.c | 2 +-
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 83e00e524513..7ac67615c070 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>>  	 * non-zero value.
>>  	 */
>> +	if (WARN_ON_ONCE(!svm->ghcb))
> 
> Isn't this guest triggerable?  I.e. send a SIPI without doing the reset hold?
> If so, this should not WARN.

Yes, it is a guest triggerable event. But a guest shouldn't be doing that,
so I thought adding the WARN_ON_ONCE() just to detect it wasn't bad.
Definitely wouldn't want a WARN_ON().

Thanks,
Tom

> 
>> +		return;
>> +
>>  	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>>  }
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 271196400495..534e52ba6045 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2759,7 +2759,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>> -	if (!sev_es_guest(vcpu->kvm) || !err)
>> +	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
>>  		return kvm_complete_insn_gp(vcpu, err);
>>  
>>  	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
>> -- 
>> 2.31.0
>>
