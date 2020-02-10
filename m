Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADF6157EEA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 16:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgBJPf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 10:35:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgBJPf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 10:35:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AFYLtj188710;
        Mon, 10 Feb 2020 15:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BAJtlUFBeU9vdpqs1Ne5FDMQCX4Tpeov/LFTBTNfdl0=;
 b=IuZk1WhpYDwpe6vHHg8wIU10EELLc9vg6ZX3nVaXGDLs/vgWnyKkqhrvBtPROEe1WzBq
 6KsqYXosz3qQhb6RmpJxxawJ1bXLoBRtEMU+tGQknPJOWJTjel2x6x87sCUKmrazn4T1
 UWfLUCSotXq3gKCobHPdyxBgn07LF3IRQFVyiyo2nqjNetsR0RkYW0XKyU3/UdC+AKaM
 cLjwv43qaVPLnZ6j5zEVPX98Uyu86LZmLAhz+MfG5Bvd14aCrU6qN/Jh2OBJ/wmHZD7J
 F9pm3Ve1+YnnBcEULUIaGJU/5SKFsi4eHKOqjT/CTc2qUAflB2IzEI75ZPqLfMeCcr5b yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y2jx5wgfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 15:34:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AFWu1N170522;
        Mon, 10 Feb 2020 15:34:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2y26ffbjmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 15:34:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01AFYXiT023567;
        Mon, 10 Feb 2020 15:34:34 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 07:34:33 -0800
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id EBFB96A00DD; Mon, 10 Feb 2020 10:38:15 -0500 (EST)
Date:   Mon, 10 Feb 2020 10:38:15 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: Introduce pv check helpers
Message-ID: <20200210153815.GE7395@char.us.oracle.com>
References: <CANRm+Cxd55Sqi4anpXD_Urmx8BV=R9ZDUwejChJHLBsZeGoWbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cxd55Sqi4anpXD_Urmx8BV=R9ZDUwejChJHLBsZeGoWbw@mail.gmail.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 02:37:30PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Introduce some pv check helpers for consistency.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!
> ---
>  arch/x86/kernel/kvm.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d817f25..76ea8c4 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -425,7 +425,27 @@ static void __init sev_map_percpu_data(void)
>      }
>  }
> 
> +static bool pv_tlb_flush_supported(void)
> +{
> +    return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> +        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> +        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +}
> +
>  #ifdef CONFIG_SMP
> +
> +static bool pv_ipi_supported(void)
> +{
> +    return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
> +}
> +
> +static bool pv_sched_yield_supported(void)
> +{
> +    return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
> +        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> +        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +}
> +
>  #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)
> 
>  static void __send_ipi_mask(const struct cpumask *mask, int vector)
> @@ -619,9 +639,7 @@ static void __init kvm_guest_init(void)
>          pv_ops.time.steal_clock = kvm_steal_clock;
>      }
> 
> -    if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> -        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> +    if (pv_tlb_flush_supported()) {
>          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>      }
> @@ -632,9 +650,7 @@ static void __init kvm_guest_init(void)
>  #ifdef CONFIG_SMP
>      smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
>      smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
> -    if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
> -        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> +    if (pv_sched_yield_supported()) {
>          smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
>          pr_info("KVM setup pv sched yield\n");
>      }
> @@ -700,7 +716,7 @@ static uint32_t __init kvm_detect(void)
>  static void __init kvm_apic_init(void)
>  {
>  #if defined(CONFIG_SMP)
> -    if (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
> +    if (pv_ipi_supported())
>          kvm_setup_pv_ipi();
>  #endif
>  }
> @@ -739,9 +755,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
>      if (!kvm_para_available() || nopv)
>          return 0;
> 
> -    if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> -        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> +    if (pv_tlb_flush_supported()) {
>          for_each_possible_cpu(cpu) {
>              zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
>                  GFP_KERNEL, cpu_to_node(cpu));
> --
> 2.7.4
