Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484181F1684
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 12:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgFHKPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 06:15:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgFHKPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 06:15:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058ACoUg058320;
        Mon, 8 Jun 2020 10:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l34Xot7MybPSbqmYWFa62Zo+/7NSV5MICSBYANC247Q=;
 b=SxjCr9G/3QtNn7U8znTEG1NfoSqEFwwu1NcBbPIl1DJ6xFWT385v9+an1ItZuGbfyrJ5
 xXfOBftZGgqhjzyJdCMae5NugB/9j4dCqvX+ZaXks4MjHuXJpS6kH8ViFgLevlYzi+Yu
 uZBrZ7PjwHz1gEUNeSqgH/q9uNQnn9fjUoasHZgU56D6wLAOPlt9MSWl00/mWkrY4tOP
 Ne31YSIAMMIt/+ntwX/jL96Vv7bsI14/mnkQ3SmIcbbaOUsE3TxD4cHiEcwUe7/cqkDl
 THuAyDL7hJKGTM/x0Sr5HUsWmcVOpz/0g7hktq45VdC9DbV9TyG7gVVWHL1kH+C8RhV2 VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smnwj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 10:12:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058A4KY4098781;
        Mon, 8 Jun 2020 10:12:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwpqspn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 10:12:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058ACdun032703;
        Mon, 8 Jun 2020 10:12:40 GMT
Received: from [10.175.214.200] (/10.175.214.200)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 03:12:39 -0700
Subject: Re: [PATCH] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during
 wakeup
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        liam.merwick@oracle.com
References: <20200605200728.10145-1-sean.j.christopherson@intel.com>
From:   Liam Merwick <liam.merwick@oracle.com>
Message-ID: <b2ac2400-dbc1-f6bc-a397-17f1ae10bd83@oracle.com>
Date:   Mon, 8 Jun 2020 11:12:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605200728.10145-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/2020 21:07, Sean Christopherson wrote:
> Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
> where firmware doesn't initialize or save/restore across S3.  This fixes
> a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
> taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.
> 
> Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
> with the case where the MSR is locked, and because APs already redo
> init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
> used to reinitialize APs upon wakeup.  Do the call in the early wakeup
> flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
> a resume hook is not guaranteed to work, as KVM does VMXON in its own
> resume hook, kvm_resume(), when KVM has active guests.
> 
> Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org

Should it have the following tag since it fixes a commit introduced in 5.6?
Cc: stable@vger.kernel.org # v5.6

> Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/include/asm/cpu.h | 5 +++++
>   arch/x86/kernel/cpu/cpu.h  | 4 ----
>   arch/x86/power/cpu.c       | 6 ++++++
>   3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index dd17c2da1af5..da78ccbd493b 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -58,4 +58,9 @@ static inline bool handle_guest_split_lock(unsigned long ip)
>   	return false;
>   }
>   #endif
> +#ifdef CONFIG_IA32_FEAT_CTL
> +void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> +#else
> +static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
> +#endif
>   #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index 37fdefd14f28..38ab6e115eac 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -80,8 +80,4 @@ extern void x86_spec_ctrl_setup_ap(void);
>   
>   extern u64 x86_read_arch_cap_msr(void);
>   
> -#ifdef CONFIG_IA32_FEAT_CTL
> -void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> -#endif
> -
>   #endif /* ARCH_X86_CPU_H */
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index aaff9ed7ff45..b0d3c5ca6d80 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -193,6 +193,8 @@ static void fix_processor_context(void)
>    */
>   static void notrace __restore_processor_state(struct saved_context *ctxt)
>   {
> +	struct cpuinfo_x86 *c;
> +
>   	if (ctxt->misc_enable_saved)
>   		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
>   	/*
> @@ -263,6 +265,10 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
>   	mtrr_bp_restore();
>   	perf_restore_debug_store();
>   	msr_restore_context(ctxt);
> +
> +	c = &cpu_data(smp_processor_id());
> +	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
> +		init_ia32_feat_ctl(c);
>   }
>   
>   /* Needed by apm.c */
> 

