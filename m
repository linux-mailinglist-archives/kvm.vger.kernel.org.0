Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15A313D19A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgAPBi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 20:38:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgAPBi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 20:38:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1Tjmn050537;
        Thu, 16 Jan 2020 01:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GWh1sgtya/qcBgnEbum74PRtCB072WON8vFm/24xoNA=;
 b=kookV47tfUn5jNN7eEWFXSoU8Z+PDWaJDgoDhv5GZY+bSTeS3BPrwuwgeuW5xCBtNrgI
 jBEXHzmomWZl46Ay2GT42NyW2VKCZISvXOZsxPumQBnRuCAc1xwqxbVpYQtERuvEDvYP
 gHM+ZZJo0BqpNm6SynXi/25c/3hwECSDygpIbQYpnneEtqJUiPYKBoNF0iTaGrwrPfAj
 wtGKJIQUM0wBTbcAFrXiWMl2E6rYoYUR5Ic+vjgNBhgsgTv00xswyHnEPBJ89e88dyNa
 3Xpcz+Iaw3oDAM4aX379vIk8g770OreWIXLxui5OOJa6m9EmluzdEwgx+Oqy9vpxAEiC dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74sfp3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:37:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1Uh6G131571;
        Thu, 16 Jan 2020 01:37:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xj61kq616-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:37:21 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G1bIbm030780;
        Thu, 16 Jan 2020 01:37:18 GMT
Received: from dhcp-10-132-95-72.usdhcp.oraclecorp.com (/10.132.95.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 17:37:18 -0800
Subject: Re: [PATCH] KVM: x86: Perform non-canonical checks in 32-bit KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200115183605.15413-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <cf9a9746-e0b8-8303-afd5-b1c3a2a9ac83@oracle.com>
Date:   Wed, 15 Jan 2020 17:37:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20200115183605.15413-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=554 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/15/2020 10:36 AM, Sean Christopherson wrote:
> Remove the CONFIG_X86_64 condition from the low level non-canonical
> helpers to effectively enable non-canonical checks on 32-bit KVM.
> Non-canonical checks are performed by hardware if the CPU *supports*
> 64-bit mode, whether or not the CPU is actually in 64-bit mode is
> irrelevant.
>
> For the most part, skipping non-canonical checks on 32-bit KVM is ok-ish
> because 32-bit KVM always (hopefully) drops bits 63:32 of whatever value
> it's checking before propagating it to hardware, and architecturally,
> the expected behavior for the guest is a bit of a grey area since the
> vCPU itself doesn't support 64-bit mode.  I.e. a 32-bit KVM guest can
> observe the missed checks in several paths, e.g. INVVPID and VM-Enter,
> but it's debatable whether or not the missed checks constitute a bug
> because technically the vCPU doesn't support 64-bit mode.
>
> The primary motivation for enabling the non-canonical checks is defense
> in depth.  As mentioned above, a guest can trigger a missed check via
> INVVPID or VM-Enter.  INVVPID is straightforward as it takes a 64-bit
> virtual address as part of its 128-bit INVVPID descriptor and fails if
> the address is non-canonical, even if INVVPID is executed in 32-bit PM.
> Nested VM-Enter is a bit more convoluted as it requires the guest to
> write natural width VMCS fields via memory accesses and then VMPTRLD the
> VMCS, but it's still possible.  In both cases, KVM is saved from a true
> bug only because its flows that propagate values to hardware (correctly)
> take "unsigned long" parameters and so drop bits 63:32 of the bad value.
>
> Explicitly performing the non-canonical checks makes it less likely that
> a bad value will be propagated to hardware, e.g. in the INVVPID case,
> if __invvpid() didn't implicitly drop bits 63:32 then KVM would BUG() on
> the resulting unexpected INVVPID failure due to hardware rejecting the
> non-canonical address.
>
> The only downside to enabling the non-canonical checks is that it adds a
> relatively small amount of overhead, but the affected flows are not hot
> paths, i.e. the overhead is negligible.
>
> Note, KVM technically could gate the non-canonical checks on 32-bit KVM
> with static_cpu_has(X86_FEATURE_LM), but on bare metal that's an even
> bigger waste of code for everyone except the 0.00000000000001% of the
> population running on Yonah, and nested 32-bit on 64-bit already fudges
> things with respect to 64-bit CPU behavior.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/x86.h | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index cab5e71f0f0f..3ff590ec0238 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -166,21 +166,13 @@ static inline u64 get_canonical(u64 la, u8 vaddr_bits)
>   
>   static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>   {
> -#ifdef CONFIG_X86_64
>   	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
> -#else
> -	return false;
> -#endif
>   }
>   
>   static inline bool emul_is_noncanonical_address(u64 la,
>   						struct x86_emulate_ctxt *ctxt)
>   {
> -#ifdef CONFIG_X86_64
>   	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
> -#else
> -	return false;
> -#endif
>   }
>   
>   static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,

nested_vmx_check_host_state() still won't call it on 32-bit because it 
has the CONFIG_X86_64 guard around the callee:

  #ifdef CONFIG_X86_64
         if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
             CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
  ...


Don't we need to remove these guards in the callers as well ?
