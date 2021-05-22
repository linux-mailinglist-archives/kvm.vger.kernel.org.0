Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD16738D6EB
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 20:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEVSSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 May 2021 14:18:33 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:39553
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231370AbhEVSSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 May 2021 14:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcHNtkTKKIgWal++E3kgD0JbY4Rc2H1P8yrgnKapl22aImPJWci7TlYnKEaKYflA0YTjNsF3WHiKqWwREGM6JEphvDiScF8Fh3qDauqNSNXBPZfmX8nI6nBo0c8Obcl7W5Yuftiq2r4xZaGK4h02T1CepXAlKm1eN6h2wd8YyRn2K12Xb1cF9YTHX8dqZz7aqfanRqMoEo0wY/1xWh0Vg6K7iJrcSgypFMlMUMB+lq7j99c2Ut4nrIMt7tnybw7sOOgY985s7LcqntLmsdN66w9SiRyB+3Ksus2Hwqajdl0SU8QyYPAPH2rNbh/6p+Y7BVTEL0lpHufXONc2odd3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfxdG3SiuDroZC+Ff21WGLSXGQmwEVKADZ+OQGBpMrI=;
 b=Jirpv0sLfwh1XnrjwuHhzeDaxG6rpp5q1QatzTgR/XszHEn/gS2Lf7PTRrYOKct0y2urp4o/ThYCWsdswUvpfDKP0EYvpQPyE4vQtbzRDqsWH4XhvJTNjoQcMA4k6e8voz/G5J7+7R5Jt5gm01Piv5anbmbap4WY5WGXbDQIc4h1YXC1TKU5zttZ3W2v1iZNbpLn+PHfcR9V50LEAZL/w7R4OVfnSWnN2zA5UJF4J50nDYp6rqwCtbALNm+mKQE7t1f9RJ+rZY/XH74yU5zmGjtVM+2S5ruoPp7e4NdAPdubZkAoZxQgn8qMaYLr+nYVvbbCVWbBBoXc0KPBORNbSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfxdG3SiuDroZC+Ff21WGLSXGQmwEVKADZ+OQGBpMrI=;
 b=b+HV9GybJ+GNEDC4RUtYB4xanYDKAJE5wSgkOtqPWsiivi4duUjrv4XiaIW68TkM4cpXFsXVNRyQHAhvc6c2M7IZ4ylCabPKZG/bnKnuXnCc0kOaIxQbMMqbneyjLAa4jtOJ3v2yakYuPsVD7GbvGsGthUqStO5Wh1yCyr3AlMw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Sat, 22 May 2021 18:17:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.026; Sat, 22 May
 2021 18:17:04 +0000
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
Message-ID: <f9521737-f46b-4d7b-a04b-7f67c5c5dc65@amd.com>
Date:   Sat, 22 May 2021 13:17:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:802:20::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0059.namprd12.prod.outlook.com (2603:10b6:802:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 18:17:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2f2f5a7-39ee-4877-4398-08d91d4dcd2d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3179010EB4E4E9350B92295AEC289@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRAFGNGY6IOOJg13m52fJKU1Sbrn1p4vYd+nRU9M/NX+Pt7+JrPkrhP7h4J/pR03/fXtwNGqaYg0xPhSh0W7rqGZ3WLQl04ZagMIrJD3NLcUPm3fKzwSt1PMci1v49HXMcQXnrIws+TZv9Zl0Twyo9+glIoTQcbfGVKYeSFV7Ntv4KVumIWbykRZj2JUrSMhblfIRLm3gjyioTuSSHF+XYs9XzCGv+LQY+XKNnWFxCmNnzH2nyo7eGQ6jCBr2udUARk7BjlhMeO4PI5AdbUwy06pnHJUpTQYPpBSwyQt3fErKKZqWrK2eMJxke5eiDTbf5c3Xp1deIXxALCKYKdWy49BZY+UBUiddER9fIUiBLW4RHiTs4w+9ht2Nc4LKD13MBuTIvioU/tGs/fNJin1dGnqftwPIW7sOiJotme41FfWKyQVAWvt8GSEwurXY2yOPW1tNDaMYJmCduWm5R45o4sFqX1v1VIcNOhHgTxuoz7jw5mWnXPCFRDAvG+PdK/NsamZJnkjVgi7wGaE2xFTTx21Uk882k/YyYhLIPD5tXVq/n5DZg1KvP2BhPKQFqB1v4faOnR/aqv9t15L7LiUwcEt4EcAVY7eI9H0vLLdpxvCLcvM2ztCW6SaDR6cPJjHDr7khgAbwt979csSXRzglLDEVdM1/Grn0fFVOupZlTJykDTQjCS1kKOu+EQYC0pG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(38100700002)(86362001)(26005)(478600001)(8676002)(6512007)(2616005)(7416002)(956004)(6506007)(31686004)(53546011)(31696002)(8936002)(36756003)(5660300002)(83380400001)(66556008)(316002)(4326008)(16526019)(186003)(6486002)(54906003)(2906002)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bGlVYzBYN1l1MXBnV0RLUjBMaWM4OTVWd09RZ05SWkdwejRMcktIU0duc1FQ?=
 =?utf-8?B?VzYvZ0VjV0JpS1dTTWVHb1ZpL3QzakdFc25waGVpTjdJMlZ4RFB2cmI5NWh2?=
 =?utf-8?B?NGYxU0NmMVRvK2UrNFR5bW5PRU5jREpiMkdCRURLWWRXRkVFeUZjQUpjU0Z3?=
 =?utf-8?B?NUJ3bkZWMytxeEZGc0lqSzBMcEpSb01zTUZaZ2x0QU01MUlYVjBBOS94Z0lY?=
 =?utf-8?B?dTEvWDArVm55TmgxUGM4RGNiZldxTmtPU0xhaTRJN0d3YWhGaHFybjFDdEZT?=
 =?utf-8?B?TmhERHB5ZTNSSm5ndVZhYUd0WFZ5c01SVUF5MDZwWHBOOHFpWWpFUGhsWE45?=
 =?utf-8?B?M2Vva2N6ak10UXV1aTc3UDdqOGJOSzAwRjdXaTl2SHF0N0FIS2I3ZGhZejlO?=
 =?utf-8?B?a3BxeXVHcGlDQnNsU1g1akovQVBudlhCTjhZSm5iVlMvNGUvYWd1cDVsYlho?=
 =?utf-8?B?UmZsYm1Cc3VHWmNqdjlScmpxSWJYVGNLKzlsUjNwY1ZkZUJwZXBIU0ltUTM0?=
 =?utf-8?B?d3VSZmJ4dmZaMXlLdU5yUFBuZ3RBR1l3YVhlTzJNcHZ1SHBkaHEzUWYvb2hF?=
 =?utf-8?B?Q1Z6WTZwY3RsUHR1anNMV1RRaUlBYkpiTzI0OTZNNGRSK2JZNGlqUHV5UlEx?=
 =?utf-8?B?VnpDQ0hnSVBwMEhnZW56TzQxT2lSb0Y5REQxbHl6ZWRSTDdZSDJRMWFzRWNK?=
 =?utf-8?B?b1hJN3Y1OE44RWV3V05qN0JPbURTejNHOWN2TzRJbEhMZENBWUNSN1JXOGkv?=
 =?utf-8?B?V3RWYzZjdUpBNzFRVEJWaUxZdVJubmNIWU5nTXVuS215VjI1K2N2QVc4UXJV?=
 =?utf-8?B?a1RRdkJpK3hNM0l0Y1IwRzBtZXZRMDkyVnJURExHazh3NHNBbkdzRzN1bC9y?=
 =?utf-8?B?NG5iTUJyNWFudVBUczlnQXdVdWkxNTQ0SVFxT2RiTXVmQzdjWGYvQXVSZlNm?=
 =?utf-8?B?YVJDU1IwemdtdjJXTUJEcEVjL2FRWktQNEJPVVNCREdJK3FSMlovQXpQcStS?=
 =?utf-8?B?eGhnZnhaTnk3M0x0WFdLTlNiZmtscXg3bHZnRmRUbkZ0bTV5UWlHMU8vS0pQ?=
 =?utf-8?B?NktGbXpNY3FkNkpTRWpFVmUzc3NoNGxCOGFVdnA4RGY5VEtGL0djdm5ZdG4v?=
 =?utf-8?B?ckdQVjJhUThkeGhwWlJaMlNMbVl5TVloZ0tNbGNpSWdUdG9ialdxSzNLM25y?=
 =?utf-8?B?UkpLZUVHWW9mR0ZNUUlCLzFvbHNOc0dFdHpzTTREQk5HM0hiL0dwc1RZR3N5?=
 =?utf-8?B?MVQ5R0hFclpiZGtQK3JMbEJWTXQrcHZ0emZOaDVlS05XV1dRamtLMzJOelY3?=
 =?utf-8?B?SllBaVBqdVM1dE83a3ExdDJaVGZmUVYyUnRZMDFkaktWWjZYbSt5ZHk4RVAr?=
 =?utf-8?B?dEU5WFB4VVVBck9ZeXRtY0NoOGRKV01TcUhLNnFLbTQ2MXo4bERGOWx1U3ZJ?=
 =?utf-8?B?YkVObzNaYkFkMkJEMnpNdXI4UVNpWWYxY3ptTVhxMkovbFJscHUrL28vZE1Q?=
 =?utf-8?B?S1Fvbkw2anlxM2NNL1VQVmJ4dlRBOTlkQVR3OUt2Y0wwVitSUmVldjBwVTE5?=
 =?utf-8?B?a1BHRnpZT0lWSkJBeXphcHRyVUtxQzM4YmNiTDBJWC9KNlhaZHR3cGhQa1VN?=
 =?utf-8?B?dnBkY0tZZm0ydG4xdUpia1d0aDhGMjNQcHRKVWpsN1dFdDBwWjRENDl5Y0cr?=
 =?utf-8?B?L005c241Y2I3RjhzR09NaSs0QTMwSEt6WjR5MzBQSmVLVzNsTlZFQ2tVb2kw?=
 =?utf-8?Q?ZAD6Z53VvO1GRIhWfPJHmIzgZ3ftGCyanYFvJI7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f2f5a7-39ee-4877-4398-08d91d4dcd2d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 18:17:04.6196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0IZbsv5+aFD5ZJExvO6FXuy8zrkdGi6lvd/joXWnsAcqmk3WhsQwHPCisz7JmFMJesUQBiEkWLax3l/KU2eVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/22/21 11:43 AM, Tom Lendacky wrote:
> When processing a hypercall for a guest with protected state, currently
> SEV-ES guests, the guest CS segment register can't be checked to
> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
> expected that communication between the guest and the hypervisor is
> performed to shared memory using the GHCB. In order to use the GHCB, the
> guest must have been in long mode, otherwise writes by the guest to the
> GHCB would be encrypted and not be able to be comprehended by the
> hypervisor. Given that, assume that the guest is in 64-bit mode when
> processing a hypercall from a guest with protected state.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 

Subject should actually be KVM: x86: ..., not KVM: SVM:

Sorry about that.

Tom

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..e715c69bb882 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>  
> -	op_64_bit = is_64_bit_mode(vcpu);
> +	/*
> +	 * If running with protected guest state, the CS register is not
> +	 * accessible. The hypercall register values will have had to been
> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
> +	 */
> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>  	if (!op_64_bit) {
>  		nr &= 0xFFFFFFFF;
>  		a0 &= 0xFFFFFFFF;
> 
