Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91CE426D9F
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242988AbhJHPkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 11:40:12 -0400
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:34272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242780AbhJHPkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 11:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cetidWRJrSUTqVNKh10sgNIQOvrLOEf984x15+RlVNzE9p3OJ0JYyCYB5nMTm7CK8prG3EJOLKOV4WezBW3BOkYSplsKDzMESTKrnYU8FvfCjSLm0NEMp+pxlHLv35fHD1jtcCSSVu3JJhLxTPs0se4o6G1f1MNxfVyL3nXAYdM/gJO5rJ8SMwDFIpPj97THxFZqaYSOPQ6juONBrWrqpaYexEArOHyZ/QEoGmoSGpEbj/AJ02ZQMU3CSCYsf4P3Yv7TSm0EW55H454wYYySaaE7seXCuAO1lYOUU9z6kEtgL39gEwEgNLBg6SSS3ta1XyXvPqdzLkXCR5T/iiLYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jH87RTtGPAm/ZkqMmaVcBZQHbJjtN0CtO5psRNRs7k=;
 b=XVP/etP1fgU2/mEbc3b1EcqNEAVatYiDDsNPdVah2fRTyaCPnIYcQ6maRUpx1axCXMGtYY69Dd0K6hazQnuBv76R0NEpxkeZMQ5jsmzVtFXctaVzHSfghseBU79+K4OnievEhz3mJh3EPjwDvjV2eCXZ2YYUg//yoQ22bwIUHWINCR2vZBpGqRKyNMXagsXKvf8BlvkOd/QMDm9o/hP9UAwfjUHrWahlAMcQQlkSkJM3Dn2NYgy2sxzf+2qNZuwu/Kqhc5b8bA91jhIxZBcI9XkrMyU9ArDvsPFzrAzlvFXXLszI2Xvi84eSeUmH32ELpj0JUtROfvCDEqQx2gcHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jH87RTtGPAm/ZkqMmaVcBZQHbJjtN0CtO5psRNRs7k=;
 b=0fhUBzoCVt9whjroGaJ38Yx7lHjXB86wuUW5G5V34ENI4vB5+LFpZwY3Aq7aLC529kE+TXQdbseElwM4qoXD7DW1b7LF7MIVu3U5qUl0tQSoq8/SP8OSoN3wKAbVF7sAb95Q7m63Zdueav0mnZC0LXrfeoYP03Dn6L+2nmAjnqs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 15:38:11 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 15:38:11 +0000
Subject: Re: [PATCH 2/4 V9] KVM: SEV: Add support for SEV-ES intra host
 migration
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20211005141357.2393627-1-pgonda@google.com>
 <20211005141357.2393627-3-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5f6e6f61-0d34-e640-caea-ff71ac1563d8@amd.com>
Date:   Fri, 8 Oct 2021 10:38:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211005141357.2393627-3-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0027.namprd05.prod.outlook.com
 (2603:10b6:803:40::40) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0501CA0027.namprd05.prod.outlook.com (2603:10b6:803:40::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.16 via Frontend Transport; Fri, 8 Oct 2021 15:38:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 287152d1-9726-49fa-e937-08d98a71a2a5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB513686790B91C620F4245AFCECB29@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9NBENTZJbHO2sFJQwnRT7h5mkS5CBWN+SFujq1R2WadMqCs48Pa16fCeinTjk+Ez2WaM7Z3p2s+FXr3E0ETcwpAvacYj+QOKpr8zsIDZrS4TROt77gk8/jHGMLSaoWisVC4TsFIQd6ZSwaZSlc6+ymkH6NHSnNat8VDh3VVRbzlQxxuVH5J6fW0a87VeQWbiVZumLPwPvggBFjauK5/r3aLtUwuZtYyKasQc+BmrmY23ol4r2kQlgslfkifNo1DNoqvF2JcoZlbl0ZcbghOinXwIIyWpSumRbQcezT2MU5vuZHgUMt+cu54Q7ofmKdFVzU5Wd/75urx9hFjiqwY11Jm1gz+zNZD9gK6Y8DuwhMlF6/p3LpztHM82JYym1FbfXBXqUjpuVb3OlIT9m0jwpju7GeFZXtoGYQRr1MDsTZbMWCY0Oz96CvnD4WYEkxYwkluB/htVrMu8fI8tAhPhJyF/PT5zltsajnSGgS1vBgXki1F3o2Xxsa/UWu88lS4qlTF7Hn76MYPN07kQ+wWz9+gQe5sVi/Uq7lUlL+mIAeSMzO6qSrY9CFt5AlZ9kq5MhkVq9CDuurIhN/CySMNl33DKV4IuTZnYIgvx/qeLfG7eEvymsoRkdJNgR7T1Rt37mOtUzBwBn5s1n40iK9ULFAAXhRULxD2uz8b5W0PgBOMV7Zyu6lRWEgocgpl3QMjJ36v2Na2hcmj3uXmRd/yaZhtu0nw1PxELw5eVyEt26UqsSfUrC54NINFURQ/mwGs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(7416002)(8936002)(186003)(31686004)(8676002)(66946007)(83380400001)(2906002)(66476007)(66556008)(6512007)(956004)(2616005)(508600001)(31696002)(54906003)(36756003)(316002)(53546011)(86362001)(6486002)(6506007)(38100700002)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFJ0UzNqQTlyWXg1NUdDMWN6Z0ROZVVwdE9PN09qS29rMEVVNCs3cW52bWFY?=
 =?utf-8?B?QjVrV25hcHU5K0N2NUViY09TS3I0ZFU5eFdCR3ROdXdXRWNVb3dLYUhRSmtU?=
 =?utf-8?B?RkFlQjlGU1NWV1hnME1SbzlkNXRpQWkzUEZYK2R0cTFIeVM0SlhGSmk4WDds?=
 =?utf-8?B?bXJBbkI0WFpjUDhOUVZ2akdRVXFVWkk5MlhRTHVnRUNhZHJJSG5GMnBZU2Ni?=
 =?utf-8?B?U1hEVXlSaTVhVURzVkxZanJSR3pQVnpPWHNyeFF3SVRRaFh2SFdPbVZVNkdX?=
 =?utf-8?B?SHJBbEhrK3dkT0RwcEF5cEFQczhEYzBLNFVudkc4Y3BvaGVBQmlUSWZHUXFE?=
 =?utf-8?B?eWhBMUZWY2xtUUdwbEJCTmRQQ05UYTBiWnlWM3BzbUl5bHRsMjdvdFdKRjVp?=
 =?utf-8?B?dXNiejdJZ01uV0I3Vlk4R2ZPekR0Mnk5UDNNU0lhNElLQnZQNmk2N2NDbFAy?=
 =?utf-8?B?Wno4RXkyd0t6ZjIwK3NsR1lvd0hmcTV0SEtSd1FxUzllRFJkTmJtdFgwN1JT?=
 =?utf-8?B?bWkxZlRYSW1CWHlNNHlSbExVMjJIM29xaDRudTRxYklsOFE2bUppMmdqRWYw?=
 =?utf-8?B?cnV3dTlSZXRsekpPNmk3SWdPRWdSeHMvbGJGWWlQU2Z2Rk9OM1oyaGJpdFlv?=
 =?utf-8?B?bzdZN0hrZ1JKRXMxQTMyQ1prNkZBeWRKTkYwRVlIVG9FTU5MNDFpU1lRNzQz?=
 =?utf-8?B?OFptbkpLeitoR2xDdHBIdm5jY2ZOOXlnSHZBd1BxZFJXOHpVUnlGbjdMN3Q2?=
 =?utf-8?B?UEdyZUJ5RjBWUXhkcjhDQ0JidG9OVE5lb3lLeTNqRVFaZnBudHlYSXkyZHlI?=
 =?utf-8?B?OE96Y2ZiQzdBVTZNTGJiSnBkVkV2aHVqSWlXMnVHaVpmWG16RnR3TU91dmhH?=
 =?utf-8?B?UThaWjFLRkxJS2wwSTBMaXB3cFFRTEI1Z3NFUytyRnZ3SWs1MDJQN3NZM2hy?=
 =?utf-8?B?WG5iSTNKSFdSbndtbDZQbm1HS3pTdTBJZ3lYYUNjM1lrem81cVE3Nmk4K3NI?=
 =?utf-8?B?S0hUSnU2WUJCWHE1dzJKRUUyNFU1NmhVR2k3V0tNWDIyZ0QyaHhSNnlHdTBi?=
 =?utf-8?B?bDArUjhNbGQzUDBhMWdrLzNlNkVHZkhhNTRZTmlaUEE5RzQ2R1AvQnF2enkz?=
 =?utf-8?B?MXB5K1VodUJpK1U3ZDRnMjVWLzREUnAvaVdudDl4RnFselJRRDFsa20rb3Jq?=
 =?utf-8?B?WFFFdUw1U05OemsrdjR4SE5Ra0lLTjl0Qks5bHZSSWdLbStxWEpCZkVVK1lI?=
 =?utf-8?B?ZVVoVC9pK01xQ3BRQlBNQzRnMy9vNDFuc1VyRDFRR2x6WE01eTRXa1B5Skpq?=
 =?utf-8?B?Q29tdWhOWnpnaXE5OWh1WmdFNFV2SUtGMmlxVndhQUZ5OUFKWDh5bGZ6OGMr?=
 =?utf-8?B?VERKcjlmcGs1UTY3cUtlUmo1ZFdUMTZrWUhPMFdmNG4yTkFxMDlzcWcyaFlO?=
 =?utf-8?B?ZVpXa0tzNFhDTWt0enRlRlRaSGVrWEQ2UHlHOFNXS2F0NzFzSE9aKzB0QW4z?=
 =?utf-8?B?ajN6UitVRTZiRFdjdkZtRW9uMmxBQllJMzY4T3Zsc1l1bWp6M0F4ZEc3V0ta?=
 =?utf-8?B?SDhMcGJ3ZVEzM0dIc1hDajBXWlVDaHpBQk5QY1JYWEtJK1p1VEppTGJsdzZ3?=
 =?utf-8?B?RVhpQTJOT29yTC9YRXl6dThjcno2cGkvaUlNTjFyNDUyT0E4QnFIaGNYcjBh?=
 =?utf-8?B?UDJ0OTFaVlNoVDZaZ2tocHZRaTF0b3NMZkxWTDlBUmc5azloOU9URWJHVnIx?=
 =?utf-8?Q?1xguNzsKgzJ/0vDBOfIDyHbBcTq9RD7dYpyiaA5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287152d1-9726-49fa-e937-08d98a71a2a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:38:11.6710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQ+w2dYV26Z25Ip5clT6TwEQqK2s3mM8BXlRQYJ2xhL5OL5GhaDdKgf0QpREuGEcELGwcKunruHX9rSm+O576Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 9:13 AM, Peter Gonda wrote:
> For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
> and other SEV-ES info needs to be preserved along with the guest's
> memory.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/x86/kvm/svm/sev.c | 53 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6fc1935b52ea..321b55654f36 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1576,6 +1576,51 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>   	list_replace_init(&src->regions_list, &dst->regions_list);
>   }
>   
> +static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> +{
> +	int i;
> +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +	struct vcpu_svm *dst_svm, *src_svm;
> +
> +	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> +		return -EINVAL;
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		if (!src_vcpu->arch.guest_state_protected)
> +			return -EINVAL;
> +	}
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		src_svm = to_svm(src_vcpu);
> +		dst_vcpu = dst->vcpus[i];
> +		dst_vcpu = kvm_get_vcpu(dst, i);

One of these assignments of dst_vcpu can be deleted.

> +		dst_svm = to_svm(dst_vcpu);
> +
> +		/*
> +		 * Transfer VMSA and GHCB state to the destination.  Nullify and
> +		 * clear source fields as appropriate, the state now belongs to
> +		 * the destination.
> +		 */
> +		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
> +		dst_svm->vmsa = src_svm->vmsa;
> +		src_svm->vmsa = NULL;
> +		dst_svm->ghcb = src_svm->ghcb;
> +		src_svm->ghcb = NULL;
> +		dst_svm->vmcb->control.ghcb_gpa = src_svm->vmcb->control.ghcb_gpa;
> +		dst_svm->ghcb_sa = src_svm->ghcb_sa;
> +		src_svm->ghcb_sa = NULL;
> +		dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
> +		src_svm->ghcb_sa_len = 0;
> +		dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
> +		src_svm->ghcb_sa_sync = false;
> +		dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
> +		src_svm->ghcb_sa_free = false;

Would it make sense to have a pre-patch that puts these fields into a 
struct? Then you can just copy the struct and zero it after. If anything 
is ever added for any reason, then it could/should be added to the struct 
and this code wouldn't have to change. It might be more churn than it's 
worth, just a thought.

Thanks,
Tom

> +	}
> +	to_kvm_svm(src)->sev_info.es_active = false;
> +
> +	return 0;
> +}
> +
>   int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>   {
>   	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1604,7 +1649,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>   	if (ret)
>   		goto out_fput;
>   
> -	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +	if (!sev_guest(source_kvm)) {
>   		ret = -EINVAL;
>   		goto out_source;
>   	}
> @@ -1615,6 +1660,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>   	if (ret)
>   		goto out_source_vcpu;
>   
> +	if (sev_es_guest(source_kvm)) {
> +		ret = sev_es_migrate_from(kvm, source_kvm);
> +		if (ret)
> +			goto out_source_vcpu;
> +	}
> +
>   	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
>   	kvm_for_each_vcpu (i, vcpu, source_kvm) {
>   		kvm_vcpu_reset(vcpu, /* init_event= */ false);
> 
