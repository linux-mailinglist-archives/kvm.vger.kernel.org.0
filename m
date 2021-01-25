Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1304C3049EB
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbhAZFUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:22 -0500
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:13920
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730395AbhAYPrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 10:47:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls/NaYzmcAVXlzgt95ClCKc6QZjyU3pkuTONdcrb3VEFQR0coDxcGIhsJ6foeBBVXnxpXUYtP0NBYIUcylHHM+SSfI8K2EVh1i0k0lzU2S5niGb9awZQDtlKxOWk4T+N6pYhRUMB6vxDA8ugKWhaJgSui5Lq7sfCbQsFQ+HtjZG1XwUyczAvQ12V04/WDEITXiHqDFxsUZjUVj3TECPHYXbpyl1APinj4daSy4Kg1026TQcSh3KrUwm0b3aYMkYNwPOdIEci0ZvgCycyY7vbMV89W6/tNIeuTZUHuEUdyLXZRzha+22gVNU+a7YELZeVh7729YyLgJ9PZAOKpLYEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LASskOZ49R9ZzT7tv6orbb98nzbdCh7WhFZvTAPVDPk=;
 b=HXDGl1HVijMtYcxQFARmGR6wEa5Nw8HNSBcBe0ccGOaIgi6gdTDfv+LJr2H1haCVRPPU9Xmg8Obb5wj4O42BaxadrKLGYoWeeSI8MUajauAGRVMtvmq7uYEhvkVnWUaoScBHHzGis1WVt+6hAvrHHavk+MklcbYyQlBVJJGLkcbegF5T+6iUXgyYoppYFTuJer9dLtzQy5xmzGDSIyMPhpl2VSHSssnoxU5PGPft5bIE+lUjQOIjovYItxll2/iIa5XFDi1+hqN/809kyNDugW4mh2A5Ggf4grUpIPWye6/7xi/G2kVFswh9Chm/S5/9yLUZ/4+jxsgm6Z4e+OsG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LASskOZ49R9ZzT7tv6orbb98nzbdCh7WhFZvTAPVDPk=;
 b=0MD4bpLHiQtCWJt6fnOK8BivH/VvaZVs7HpiVdYHYGc7DlLd2ul2Tye9gyA2PMDuxqycmfKCSG8ryk9iR0pWk0Rl9w0TVVuvk2F01Hee/jfC/hAsKFQTVTjFBzm+cLGGIlRXe8vcbc2AZ7TrPv01a2NLDJcq5wxAwnFSP+Htcvk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2780.namprd12.prod.outlook.com (2603:10b6:5:4e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.19; Mon, 25 Jan 2021 15:05:49 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 15:05:49 +0000
Subject: Re: [PATCH 1/3] KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN
 of SEV-ES guest
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
References: <20210122235049.3107620-1-seanjc@google.com>
 <20210122235049.3107620-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9d92a765-fef3-dded-7478-443f25370661@amd.com>
Date:   Mon, 25 Jan 2021 09:05:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122235049.3107620-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0299.namprd04.prod.outlook.com
 (2603:10b6:806:123::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN7PR04CA0299.namprd04.prod.outlook.com (2603:10b6:806:123::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 15:05:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e05de211-4ee9-4a78-d616-08d8c142b34a
X-MS-TrafficTypeDiagnostic: DM6PR12MB2780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2780EE1FE90A2659223C3696ECBD9@DM6PR12MB2780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bwmy2hgZV6CpnAlG8cowlEq+B4SkQxpkc+IAqsYXm9FJ2v7ZbR2sPfmDU0TkfGkqbE1AflQXuMkGqU3+1XSmgNvuksm+MLKTmdM+vCJEmoSlUr8zSd+XJJAa7XDNODjmZuk1LsTLxyVZZ/RYf1jckHeKtZN+5wE0CfyKe28wdFRh9uDmRXY3KHzcJvUA0UpetPE4wyJAtApaKztbASpDSoqrCFck2esWBTWFodSguSWl61YmpqgWA9dW4i9BFNPaDIXqOet1sHqTS3VHvaAcgBLDlAoRcxYtJK3Po8vWH6rVY8baSw7RLdgLLrf1lCqI80evSOV8EyNo7jsh6BJ0+D6TqP5uqJsJfwLm3Kd7ciJFJCZ6mkMRq4LTYp8N90Br+jqIcXz5ZEatcb9tg9cwHXHPMkFKnhD/C1kBsJ9Exbpj+b703egSa/uohOtS1ZM6PIiakmFvvgTNUfgldR+/q5euhhYYB47Waxdqb4kFmG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(16576012)(54906003)(110136005)(66476007)(66556008)(66946007)(8936002)(4326008)(2906002)(83380400001)(5660300002)(498600001)(53546011)(31686004)(26005)(956004)(31696002)(16526019)(6486002)(186003)(8676002)(86362001)(36756003)(52116002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHZ6N0hyblBjUlhkOFphQkVSOUVtRjZQNEVaR1lBRGdncjcvRnd1V1A5VWNq?=
 =?utf-8?B?WjR2VVRaZ3JwZWZwSXd3L1VTazVmenJ3eSt6NDA3NGRBdWJ4R1paM01HRmJ0?=
 =?utf-8?B?U05wakhZTlh6bDJpeVVPMHNNTW1FUVh3YVE2dm4rRHZCSkg3S1hraWJnTlMz?=
 =?utf-8?B?ZTdFSDNNWFJQaUJ2M01UQUx4QzBNTFg0TVdaaGtiZER1ZmNkOHdqOFRJYzk2?=
 =?utf-8?B?a21MZjlKSmt2azREV3pmRXhkTFdWMWl0L1NYbG91ckQxcm92elFkMDRFcXFU?=
 =?utf-8?B?YTZyTGhtN05uVElmYU56ZXNLYmZMTGpKMTdWZmx2ZE5sSWpPUkFRRWpXelhl?=
 =?utf-8?B?VmU2YXgzV1hVY1h2VXJwVFZmMmg0aEUvZHUyY0swNnQ3cVFidUVlNkovb2Iy?=
 =?utf-8?B?WDVDSlJiZ256ejJpNllrdTlSb2JUMTIraTlQSVNGQmpid2RISTd1ejNlRVZ3?=
 =?utf-8?B?UnpSZ3NjV3BZQUk2eDYvb1M5LzdpemlaQmVUR2RJSm96TzlhNUdpZCtDSjAx?=
 =?utf-8?B?emhFdmZSR2VzTmZQUTFBcnJzUU9kS0lUM3ZvM3pFeUF2MkI0b29ya3ZvSkNW?=
 =?utf-8?B?QStMdDJSNmhpRjY5T1dMVk5Wd3QxSjJ3b3ZaR2RMNXBaQ0NJelJDMGpCbVk2?=
 =?utf-8?B?T3BJbldDb0NJa1J0NmU1SUtaTW9ZbHowK2duM29sa2gyZnZBR3RIakVYbUZM?=
 =?utf-8?B?LzF0OWJPcmZFRjU4Uks2Mk56ZThWd3p1NVlxM1UwVGhabkRJTS9VODV3cW5v?=
 =?utf-8?B?RktsbWM3Mjl0UTMvZ3VodFZ5UDlUZGRtdWNCem5NaXZ2cmRFRVdEdnh2aWtZ?=
 =?utf-8?B?QnNEVlBzRWo3bnRxNnJaanVOQ0g2VnhHSS84ejBWdHc2UEgveElhYllOQVgx?=
 =?utf-8?B?SUhTRWs3SUlMbE9iMGRDMHE4aW94RE9yMXlrSGIyYWVoVG5FVy9rUW9peXNh?=
 =?utf-8?B?NC9uRUVsUlZEMTNHYUFNa0djUkNkb2xnMkU0UHY2WGIzbU1Md2Z6SUgrRGpH?=
 =?utf-8?B?bUF0UnhyRjdocVR3OFpUQU5nZUIrWmdMQ05DSmRaVTA0WGVIcWtzbW8xK3Av?=
 =?utf-8?B?ZmpnUHl2dmRCWE1vWldXNFdYVkdvVVA5TWorQ2owNmdDdFBuc3BxZ056WHo1?=
 =?utf-8?B?UGluL1FqbG1SbGFEUWNEaERETnAvMXFBOU5ORWF3Yy9xTHM2Z1F3andlbW5z?=
 =?utf-8?B?Y2I1WkpzTHpCRDNTMFFqK3BNVng5dGdTTnpoM2RtZnZLRmROQVg2WE94Qy9Q?=
 =?utf-8?B?ejc1NUczVmptbTJnTVU0ZVRwd25EUjF2M2RyVlpLZlVFRkhHMkU0dlJ3SlV6?=
 =?utf-8?Q?IVOSEeSh8To5obk1a29DKDwynaU9HeyPjL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05de211-4ee9-4a78-d616-08d8c142b34a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 15:05:49.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvL6u11BOOKAayyf8NFjTrULQRNfDDPz4rdAfCd2+UX2B//tAtxjVV4RqMJxLH5TrusLv8TrY75BDOCmCPxhjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2780
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 5:50 PM, Sean Christopherson wrote:
> Drop the per-GPR dirty checks when synchronizing GPRs to the GHCB, the
> GRPs' dirty bits are set from time zero and never cleared, i.e. will

Ah, missed that, bad assumption on my part.

> always be seen as dirty.  The obvious alternative would be to clear
> the dirty bits when appropriate, but removing the dirty checks is
> desirable as it allows reverting GPR dirty+available tracking, which
> adds overhead to all flavors of x86 VMs.
> 
> Note, unconditionally writing the GPRs in the GHCB is tacitly allowed
> by the GHCB spec, which allows the hypervisor (or guest) to provide
> unnecessary info; it's the guest's responsibility to consume only what
> it needs (the hypervisor is untrusted after all).
> 
>   The guest and hypervisor can supply additional state if desired but
>   must not rely on that additional state being provided.

Yes, that's true.

I'm ok with removing the tracking if that's desired. Otherwise, we can add
a vcpu->arch.regs_dirty = 0 in sev_es_sync_from_ghcb().

Thanks,
Tom

> 
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..ac652bc476ae 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1415,16 +1415,13 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
>  	 * to be returned:
>  	 *   GPRs RAX, RBX, RCX, RDX
>  	 *
> -	 * Copy their values to the GHCB if they are dirty.
> +	 * Copy their values, even if they may not have been written during the
> +	 * VM-Exit.  It's the guest's responsibility to not consume random data.
>  	 */
> -	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RAX))
> -		ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
> -	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RBX))
> -		ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
> -	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RCX))
> -		ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
> -	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RDX))
> -		ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
> +	ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
> +	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
> +	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
> +	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
>  }
>  
>  static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> 
