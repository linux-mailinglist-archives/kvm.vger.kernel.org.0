Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC42301166
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAWAKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:10:36 -0500
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:37472
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbhAWAK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 19:10:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTyGw88II5Xvd8nCNPXVTD8r8CFkjITgx8+2gUflH7B1H5wGB4I1xQdCQROKbM86IchCU2VsI0LSAORE5q+VM3Wv4Vso8MVsS1b0GBaUgtXzdRkvNYiwundNEDDrMGOTaX800o1wAStNs063pvVG8RK5NX+yXaVf20s1aBXAMEtU8EHP0d/70Ldni98HoI46SjcMy8dbbGoAr6BuJGRgOs+aObnTAenRGNiMDSl17K+07ScWN0r202u+VZQHYbRoRqaU8AsvGASlZfGHGp9iCU3V4RTF5tQrtGbCQ6vKBtmJXhKDoG/JqVKDzmCQcXDS9OXXfG8XwaVQxSeEdwD02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP3iMlESZZ8+eftQ2en7UXAZlPWn2NcD1eygMpmgL5Y=;
 b=gAyYgYR5WyaNfna+SUJ7IO2s84UtYHFnuR4lwjTo0Fvfk/WtXs3U6byBQSR/kkcwYN9dk6GhZ0TZPlNZHRhWtyP0YEeiQNaii1fWVB1tR3PDddefKwm6G+k1eQGLDvjAT8Ha01800drViBlRkQfuRorl2WaRMVJpQLz6j9mfgmfKhsMdoqio+pGreRX9JukmMWrk4bXKzG9CXPlwTPWyCsn0KFL0kG9+ALFI3VXsFhUKRGqfGG36bz9S1DlJ/bbCmDl1+RrPab74laTy7bz9fwhA2RoNyfUqx2JBe2bCrSK+kYNYvuQNDZe4n9CA4xxJIsG7a98ApKXqEocCEb/wxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP3iMlESZZ8+eftQ2en7UXAZlPWn2NcD1eygMpmgL5Y=;
 b=UfBMT5TBqJLWuLOqGlSI0ljfYb9GH7OYQaxlFqitcN7LCA6Hm1vXSdWps78NLonjzRh+tIwUbnqSCJiCgKmL++MTJXg427HI/BHKl9tcQAOTUjfUD9xJ0wBfmNgS7QjOL1o2CRVNeF3Z9RSZI12ns+QYVi+Q0DaY1hfw+kwZF58=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Sat, 23 Jan 2021 00:09:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Sat, 23 Jan 2021
 00:09:34 +0000
Subject: Re: [PATCH 3/3] KVM: SVM: Sync GPRs to the GHCB only after VMGEXIT
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
References: <20210122235049.3107620-1-seanjc@google.com>
 <20210122235049.3107620-4-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0d8e9d63-1fe9-af08-dae9-edd80083e940@amd.com>
Date:   Fri, 22 Jan 2021 18:09:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122235049.3107620-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0501CA0013.namprd05.prod.outlook.com
 (2603:10b6:803:40::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0013.namprd05.prod.outlook.com (2603:10b6:803:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Sat, 23 Jan 2021 00:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ded9655a-05f6-4588-49d2-08d8bf3329be
X-MS-TrafficTypeDiagnostic: DM5PR12MB1356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1356C89F5B7D3029E94928F1ECBF0@DM5PR12MB1356.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CAuxYg1SnrbkWNQoyzGBm17PXm/nujuggYMbf0wHhqE1zgggnQ6lvHXLC7ZijSWnQPnwRTdxgwpKaANrGLMTOllHGdRcfVll1pCtNp66TGQeO4NTW4fH91cjJUG3gwzaOXHTSxl36JATlik2nk1bIWgMUMJM6LXgT1hI1skVSR918c3pTT4wMqeUu0pYi/bSRlMULjew/TIWJF5c+9kGqVyYN867+F89h1y7WntnXZnkWaEx4U+vf8sC/lnVpH5fbzurjFZIchT3QQnw0oyktvmSp1lzn96J2kfbZTHvvCo7DpftDTdNP5IADWu1HcsrEcgTvj8HBXntLYra6V5GoC5y1mvyicpF3HSH31KV7fL2SrrzI8k7tYzypaj2ls4P9VBLV0YehGtgdMge3wP5J/lIhd8gv+rzTfl1XKMb/t7zkwdgO/Pn+tTJuYg00mJb0aEMqOYv27OkJxbop1HL0eUetPRYdJ60gEgnjzSbyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(54906003)(2906002)(83380400001)(5660300002)(53546011)(316002)(110136005)(6486002)(86362001)(8936002)(6506007)(8676002)(31696002)(52116002)(16526019)(66556008)(4326008)(31686004)(6512007)(956004)(66476007)(186003)(66946007)(36756003)(26005)(478600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aXVVSUZLOCtDeXlUaUQ5VEN4N2h2Tmt3dmROL2lFSmllWUMzQWJGOUhtS0xl?=
 =?utf-8?B?UENpTGRpY2RKN0p0NjBXc3JMaWlDRzluQkJOTnZEdTJwaWFCTFN3NGNGaW43?=
 =?utf-8?B?S2J3MkwrT0YzRXhWdzJucGh6SUh5N0pld2ZzQlA3bmhmYWh4QmJqc3pXaXZP?=
 =?utf-8?B?VTZvRjFGSE9aN0wwbXRkVlUwbWhLOG93UHZDcitpZGFENU5jU3o4cXgwdDJu?=
 =?utf-8?B?WEQ3cDY4eVpaa0NEcS9IZURpWlEzaVBvYkoxS1JoV0F6Z2hreGJsT0hISzZK?=
 =?utf-8?B?aFVWb1JhMkRKbG9PVTQ4Y1h1VElWNis1Q2c1by9nbTdPVGdsdWVuOW5OdjRz?=
 =?utf-8?B?ZGpHMjBOajNSalBweDFLS3hpSnVRcTJEUFJNRzRJMlNzWkpWQTZMc2Q4V2Jj?=
 =?utf-8?B?WVF4RW13dkk4eldjNlMvMVdQeTVtVUZieTk4VStzckdwa3MxOEtPSkRxcENR?=
 =?utf-8?B?WjJIMWdCU3B4L2g3eWVPQ01EaHQydHErUllqcWk2cFlZZEFnNjJqRXg5MHBR?=
 =?utf-8?B?NzgyN0FYbHY5bnAwczQ0bTJ3VzI2MkRxMHVRejY2WEE3c1VZOVFZVHVuNFlF?=
 =?utf-8?B?K0hzVUZ6RENkQW4xSVFGZlYzYWZXSHdUUWovb3dERjR1NmU2VXhjWVhMU2E1?=
 =?utf-8?B?emNaeENyd2tYM0RFRktlNUI4K3FKckhVS0hBc0VERzRuU3FYV2srTkRKYmRs?=
 =?utf-8?B?c2RDZDVBUU5XYkVtTmM2OC9PQmEyb0JRQTdHNXhITVdNaXFDVXp0WC8yWStn?=
 =?utf-8?B?QW9MRVY2MkJHL0hYTmc2Z3FDUDFKOCtEL1hPMnp4YVNWOWZCdjVqTjFsV0Vh?=
 =?utf-8?B?L2Y3Zmw2bnFKSU94RVJSSWVlZ3laQ3lMd2lXY1JHclJsZHVvUG8rNnRLSFc5?=
 =?utf-8?B?SW90VDFIZUZjalFXWCtwRWN1NlBjbGMzOXFqWHV2OU9vU0VFSVpyaHNYeURr?=
 =?utf-8?B?bmdsOVlUY0I0aXVmT3JFRlhNVXp3d3pLQjV1bEhkUFp3MWhBNGV0YzByMlNR?=
 =?utf-8?B?TjY3enZMQUF4SjZqcXhzNm1vZzhkNlZrNlZCaXJkbmk1QzZ3SEpZWFlYdDNH?=
 =?utf-8?B?dVFJYWhrc2hScjdvK2dKUXVLOEJyMTFsa0Q2TmdsRWl5VEFvSElyQU5JZ3Fu?=
 =?utf-8?B?aUQwVUxEcHJzeDlGRjlVQkQ3R2k1TGMwZm5WbDB5SDY2akYzYVlRcDNiRFFP?=
 =?utf-8?B?cHk0STh1eEs5d0VYRzhrdjVHdnMrWjFWaXhUVGpNZEpEdVBQSzlrb0ZYcnFr?=
 =?utf-8?B?TS80S2hOWlNZVk5FWWhWRUZvcUhFSDh2YTdSVXcvb2Q1QTEyeFNJaHBjTGdx?=
 =?utf-8?Q?gk7HywCOqF48phuH46zE/i94HHKdTFZ0Zf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded9655a-05f6-4588-49d2-08d8bf3329be
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 00:09:34.1757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLxB3L/eoVCiuEUdalxbXFOUb53homXzjZ1eVXP3Ldg8qzYV/u5iAG4fD84EdawHCGCwc/L0J6Io6GB5HdG0pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 5:50 PM, Sean Christopherson wrote:
> Sync GPRs to the GHCB on VMRUN only if a sync is needed, i.e. if the
> previous exit was a VMGEXIT and the guest is expecting some data back.
> 

The start of sev_es_sync_to_ghcb() checks if the GHCB has been mapped, 
which only occurs on VMGEXIT, and exits early if not. And 
sev_es_sync_from_ghcb() is only called if the GHCB has been successfully 
mapped. The only thing in between is sev_es_validate_vmgexit(), which will 
terminate the VM on error. So I don't think this patch is needed.

Thanks,
Tom

> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 15 ++++++++++-----
>   arch/x86/kvm/svm/svm.h |  1 +
>   2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ac652bc476ae..9bd1e1650eb3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1418,10 +1418,13 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
>   	 * Copy their values, even if they may not have been written during the
>   	 * VM-Exit.  It's the guest's responsibility to not consume random data.
>   	 */
> -	ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
> -	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
> -	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
> -	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
> +	if (svm->need_sync_to_ghcb) {
> +		ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
> +		ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
> +		ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
> +		ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
> +		svm->need_sync_to_ghcb = false;
> +	}
>   }
>   
>   static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> @@ -1441,8 +1444,10 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>   	 * VMMCALL allows the guest to provide extra registers. KVM also
>   	 * expects RSI for hypercalls, so include that, too.
>   	 *
> -	 * Copy their values to the appropriate location if supplied.
> +	 * Copy their values to the appropriate location if supplied, and
> +	 * flag that a sync back to the GHCB is needed on the next VMRUN.
>   	 */
> +	svm->need_sync_to_ghcb = true;
>   	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
>   
>   	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..4e2e5f9fbfc2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -192,6 +192,7 @@ struct vcpu_svm {
>   	u64 ghcb_sa_len;
>   	bool ghcb_sa_sync;
>   	bool ghcb_sa_free;
> +	bool need_sync_to_ghcb;
>   };
>   
>   struct svm_cpu_data {
> 
