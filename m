Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0E235A29F
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhDIQFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 12:05:41 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:40033
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231946AbhDIQFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 12:05:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkAPwhws6SsIvUlb8WR43HHVWeq3WVtDbe72UTJe21Z6MYuIV6rqz+6yRdFhZKwuuYdA4GqlrCBdfYWNTFExjrX+f/DT0GW3D3Ia2N44mb6xhJgoWHpNm8AU4fAEgXfQBtnKWHR9PN8pOghvql/278YUDcNccKEA6G/AjElwhp2Ze9tL7pBNN6kpEi6TlB5H8ilAr+xY5fMGfaWpm2IgZHq8BnZoTYXFkSrvmb8fRTpOxFmo2MGAIT6vXU2f86KtSTaEJwvLZLj2ehici/uvJuYdYMxDgmOupU5r7qSL7w8rqV997a8KTyvnftQOJZa6vE2CmA9pLVm0lO4vdb7aOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sObVReoGnKzR8332i/1HnK4lQ6ZpkgE6I5O/kHc8Kwo=;
 b=bEw2CNqVDGPi6ARhVDIROlIsn3qasVoGqvlcJxNrV9sR+wbVnsNleT3b9/nhpV9BR+M12JAuQjPD0YC1bR1NpEj/chpsIuoEwiMHVtbFpZOunmBAzdogvYuJwQ6dKdj5/mvlRwg9SFPlnNHNvps7hWBM6uaScoQGQsXZ0RTjk3JaP/gc5nm4TTbutdGmq0mBobWh8XpL0L1n2KizLNjz1rsqsXBb7pO00u9iOJGFe+Pk6RsKCrDHLYe6+jUFQFQm/jSb4qwFzXSTjdpIzW9Scq9CFrGss0P05ATeA3wutWrQpznoce15IY22o9GLyubf+iPl4pjXHn34EgtaCTWAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sObVReoGnKzR8332i/1HnK4lQ6ZpkgE6I5O/kHc8Kwo=;
 b=odNlg61iPgGKVOtog9odKxgWGTxvmjtrZxcsuLQ3INYevXSqSQqNnLlQc2535bkP0AyeqiyMuH3oEWe1RTlFlhqUWRD9iFMFeri/LLpDXf3GKw3+/ZsPlRdfmv/CnWmYuPTrcDVCsLysGMllA2Vne6fCK3vCT1P4IDwAKv/Wx5M=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Fri, 9 Apr 2021 16:05:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4020.021; Fri, 9 Apr 2021
 16:05:25 +0000
Subject: Re: [PATCH v3] KVM: SVM: Make sure GHCB is mapped before updating
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
        Brijesh Singh <brijesh.singh@amd.com>
References: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
Message-ID: <0657f056-11d4-6262-e25f-fd84f963104c@amd.com>
Date:   Fri, 9 Apr 2021 11:05:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:806:122::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0106.namprd04.prod.outlook.com (2603:10b6:806:122::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 16:05:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2af6fe7b-e90e-4504-ed51-08d8fb71490f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB443527F8BB537457F5D8133DEC739@DM6PR12MB4435.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QqprKeGKMzXHbaqzORxwiVc9d2nHd0P1o+xtsh75NlfULXrFRXl+RtmhyCwQioXqf7Byqmadq+VhcMGrfgapT9Ek612e0+PyOaw65i6l1IU94O8J8WsbotYbcR7Ws8NFU2bKOlQd9E4wHh95lAZ0JVE+ruqngBwLmmE0V/T6xhKXWZW/z2Ldd2dNB6HBIRLrv8ByzGlS1nnCKAvhsPUdFJrweVHHkso/CrYXlnKR4l8JJYFbt5fMD3bTL2lHbbpVBdk+dh7Q81V7l6+A9NCTJCO+dIa+qbOmO60AswUM4Iw0dOLvrv0EazyunnHaegPzyxFHyM013+Y92nVU9xopqg5IoHqMSJFX6OYPsGaDCTvlRYU+7R4m2bdDm+S4Lgfbqe+siM6pMuOz9O4wa5ZG8zghSH5pdzJ2492hj7hvoCDxtd5fY9KOrg3NCxB++Aye7Wb24u69oJDCPpHD3/OOahgJ+qWLuoOOGSNB2EzGEKzOfSnmS+MLdnb4v5JiLJ+WimNnVJoaY88JakAOSRWStaE/J2HiH8VLQEKlpA48K01tgV1dSYUgbto12sgza8BtzTjJoERXsURvujetzhnAKavso0eLMmuiAdSGR1qeoeYpv9QY9BPTtWbsFS+HnH9zky6Ho4i9PD9Dx0xtsctxBUhW8J7mnEIy6V6LgeW5hlIEwOnqr1XQUNuR0O3n7gVG0CDfmB38lt17OAwu+COTkMG3mD6cYOq8hmKIMTYheE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(6512007)(36756003)(86362001)(8936002)(7416002)(38100700001)(83380400001)(2906002)(26005)(478600001)(186003)(8676002)(31686004)(6486002)(31696002)(5660300002)(316002)(4326008)(66476007)(66556008)(66946007)(54906003)(956004)(2616005)(16526019)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?KzVrRmJhYTlUbUZTa0pOOUgyeU1TR3grNjBZa1RXajN6V3dJS0hkS29FZkFW?=
 =?utf-8?B?U2w0Yk9QMjg3TmtDSG9QM0tsUXNJVEkzTGR6dm5obkI5clJxS0JoUVlXS3dY?=
 =?utf-8?B?UCt0ajRoZXUvd1MzVGUzb1FRNlExZGdRc2pmZDhIb2JZYXloZzdQblFselJt?=
 =?utf-8?B?MFYrNDZCa0dodGFJNFJzd21VejdFck5WMkwxSk5DNng4OVorMVZleVhGckRJ?=
 =?utf-8?B?R1VWMEhnYmcxZlRmcWFZdThkbStxNTNRU05RQmZybEhzYWY3Z2J6b2dQdFhB?=
 =?utf-8?B?R01MOE9ZQW5LdlhCc1owY2dPQ3Q5WSt1K1VuUXYyQlFHb1I4dU9mLzlTcklB?=
 =?utf-8?B?dzJBUWJISGlzTnJsL0NxSG02K0F1cXRXQTV4SnNKUkIycFVVRjJlSHYyak4y?=
 =?utf-8?B?elo0dHFCck1MUjF0YkYyd0Z5WndUdk4zNUthbmhscUxidWFyWVZjL21nWjB6?=
 =?utf-8?B?UEVJV0FMMkdWbmhSYjRpS25JcW93d0kzc3FqNkNWRWJwK2h2Ty9PdW1laFdT?=
 =?utf-8?B?TmZKQWNNeklIaWJlTUNKa3ZSOWdsTytXTDFRLy9Bc2c3WXM5SGwveEJSM0N0?=
 =?utf-8?B?S3Y2TlFzSnZjM3VUMlBNMDlGdFVIeERVd0tVTEdJNHhqVjU5dlYzdUFqWjlR?=
 =?utf-8?B?Z0NsOC8rK2x2YXA1dTAzVGFlNDg5QmpYS05lRnVrVThvUlVVV3RtK0ljUG5y?=
 =?utf-8?B?RHRMUGpzdDB1UTBVTnA1ZHVlMjczSFdiRmdWbkNEN2lWUXlaQzg3SXRjWFBq?=
 =?utf-8?B?cjNqYmlqTzFsY3gxTXlaTDNIVERHS3Z1bmJ1NHhKL29BZ1N5ZXJPUEJhTzgr?=
 =?utf-8?B?dkwvZkFFTG5idW1OaGs3dmlKOWJEK05RQjdRYTdqUHo0dTZFa2xOT3NrMnpV?=
 =?utf-8?B?YjZPYlIrSytCYkIrZVVjd2ZYR291N0JrakcvUldBckw5eEFWbTJzZytWMDZP?=
 =?utf-8?B?M0RWNktiT2FhNUpCUTBYZjlaYW4wSEVBODMwRHVxUjZpaGw4NWVvN1c0NGcx?=
 =?utf-8?B?YUJwSGl4RC84RW1VcUdTa2FUaU9BQ2ZCTmlzVXdlSGNSMWtvdngyMHQ4VExU?=
 =?utf-8?B?K05nbjBkZ2lTc2QwZi95VFQ2cUxSVW5DeGVXTE0vQktMNVJRb2JJM00wcTFW?=
 =?utf-8?B?LzhKak5nKzV5WTlQc3RvU3ZGQ0dCR1IxVmphUVkzMWhDa1pJSWtDMnJsanpP?=
 =?utf-8?B?aWk2QzJiOGRjOWU3Vy84aytSSk9hWXltdjdoSHF0c0xVV0NFUWpsNTU3Z3Uv?=
 =?utf-8?B?UUZUTEJrWnMyMlo4WWFLSFA5TElzamYwQ2s1UG1jMUMvU0w0Y0RjdjlVajVv?=
 =?utf-8?B?b0ZYYkZiT09NdkY1VjQ0L1hycm1GRHN5QlBJRDB0SitJQVhGVVoxK0pXdnVM?=
 =?utf-8?B?L0JNd0NIT3JFRXptVkFhb3h6K05JOHBOcUg4Rzk2QjhxM2xBVXNqM2E3aTV2?=
 =?utf-8?B?Q3o3cFNRRGNiak5ZM1NwRW9xTGxkdituUGFjZHNZNnVKclF6QnBIUFY5VGg3?=
 =?utf-8?B?cGhxTitkallUU3RGMVl2cFVmcW9iTzZjMzFJaXgyUlkzMDVJSklFN2xNamdK?=
 =?utf-8?B?ckJQTkppMUhubU51ZXM2a2NRV1BJVWxwNnAvZWYxeHN4RFAxUy8rSnU3TEY5?=
 =?utf-8?B?Y2xmanVRVjJPZ1kzeUZ0VEM1QVhOeHRaRWdrZFdNT3p1bS9wK203azBnbmty?=
 =?utf-8?B?NElJeWMvUCtoUE1jNFdTNVZZZzBnUmY1UnNldkVhUWQ1bnNCMVpOd24wSEJR?=
 =?utf-8?Q?wbTlXr66ZsWdU8usUAxJ+hYcjDrXd2Ss41s4FwH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af6fe7b-e90e-4504-ed51-08d8fb71490f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 16:05:25.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaSadpInGehJ/0177N3t1/3qtzYQ8876cAKqk5XpgnfjbRy+w9oicwtdJo7EIvQCYirSWOikkrsP5p70vy6mhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/21 9:38 AM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Access to the GHCB is mainly in the VMGEXIT path and it is known that the
> GHCB will be mapped. But there are two paths where it is possible the GHCB
> might not be mapped.
> 
> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
> However, if a SIPI is performed without a corresponding AP Reset Hold,
> then the GHCB might not be mapped (depending on the previous VMEXIT),
> which will result in a NULL pointer dereference.
> 
> The svm_complete_emulated_msr() routine will update the GHCB to inform
> the caller of a RDMSR/WRMSR operation about any errors. While it is likely
> that the GHCB will be mapped in this situation, add a safe guard
> in this path to be certain a NULL pointer dereference is not encountered.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> ---
> 
> Changes from v2:
> - Removed WARN_ON_ONCE() from the sev_vcpu_deliver_sipi_vector() path
>   since it is guest triggerable and can crash systems with panic_on_warn
>   and replaced with pr_warn_once().

I messed up the change-log here, the WARN_ON_ONCE() was dropped and *not*
replaced with a pr_warn_once().

Thanks,
Tom

> 
> Changes from v1:
> - Added the svm_complete_emulated_msr() path as suggested by Sean
>   Christopherson
> - Add a WARN_ON_ONCE() to the sev_vcpu_deliver_sipi_vector() path
> ---
>  arch/x86/kvm/svm/sev.c | 3 +++
>  arch/x86/kvm/svm/svm.c | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 83e00e524513..0a539f8bc212 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>  	 * non-zero value.
>  	 */
> +	if (!svm->ghcb)
> +		return;
> +
>  	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 271196400495..534e52ba6045 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2759,7 +2759,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	if (!sev_es_guest(vcpu->kvm) || !err)
> +	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
>  		return kvm_complete_insn_gp(vcpu, err);
>  
>  	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
> 
