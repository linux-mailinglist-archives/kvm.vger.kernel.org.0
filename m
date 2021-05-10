Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4F377E28
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhEJI2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230245AbhEJI2Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8yWz/56H24m+Rwv/XNZpgOF6AS+kBigZhTf8M/eMyKE=;
        b=g8VXzkzCnrul/2jV+9upDMCRWJYgivhoglXRCa4BCb/hYCA0/yg+9c/fWX+xF4gmUHeol+
        YB+lAT6jsUv6gMSFqBF6lcY3Xhebu6JsbqlGL7kyhVNrZjqmrGN9xDt+XN1uOfs+6qlAR7
        ZFIRi4ac0gJZP3rdXU2OZ1hohwxgQ90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-e2Uu-8UAPd2--03jhoQNUw-1; Mon, 10 May 2021 04:27:07 -0400
X-MC-Unique: e2Uu-8UAPd2--03jhoQNUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55AA4801817;
        Mon, 10 May 2021 08:27:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DD7F5D9CA;
        Mon, 10 May 2021 08:27:03 +0000 (UTC)
Message-ID: <e1a46c206cedf836c41de01e9af7fb5160c3b083.camel@redhat.com>
Subject: Re: [PATCH 12/15] KVM: x86: Export the number of uret MSRs to
 vendor modules
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:27:01 +0300
In-Reply-To: <20210504171734.1434054-13-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-13-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Split out and export the number of configured user return MSRs so that
> VMX can iterate over the set of MSRs without having to do its own tracking.
> Keep the list itself internal to x86 so that vendor code still has to go
> through the "official" APIs to add/modify entries.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 29 +++++++++++++----------------
>  2 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c9452472ed55..10663610f105 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1419,6 +1419,7 @@ struct kvm_arch_async_pf {
>  	bool direct_map;
>  };
>  
> +extern u32 __read_mostly kvm_nr_uret_msrs;
>  extern u64 __read_mostly host_efer;
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  extern struct kvm_x86_ops kvm_x86_ops;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 90ef340565a4..2fd46e917666 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -184,11 +184,6 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>   */
>  #define KVM_MAX_NR_USER_RETURN_MSRS 16
>  
> -struct kvm_user_return_msrs_global {
> -	int nr;
> -	u32 msrs[KVM_MAX_NR_USER_RETURN_MSRS];
> -};
> -
>  struct kvm_user_return_msrs {
>  	struct user_return_notifier urn;
>  	bool registered;
> @@ -198,7 +193,9 @@ struct kvm_user_return_msrs {
>  	} values[KVM_MAX_NR_USER_RETURN_MSRS];
>  };
>  
> -static struct kvm_user_return_msrs_global __read_mostly user_return_msrs_global;
> +u32 __read_mostly kvm_nr_uret_msrs;
> +EXPORT_SYMBOL_GPL(kvm_nr_uret_msrs);
> +static u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
>  static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  
>  #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
> @@ -330,10 +327,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
>  		user_return_notifier_unregister(urn);
>  	}
>  	local_irq_restore(flags);
> -	for (slot = 0; slot < user_return_msrs_global.nr; ++slot) {
> +	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
>  		values = &msrs->values[slot];
>  		if (values->host != values->curr) {
> -			wrmsrl(user_return_msrs_global.msrs[slot], values->host);
> +			wrmsrl(kvm_uret_msrs_list[slot], values->host);
>  			values->curr = values->host;
>  		}
>  	}
> @@ -358,9 +355,9 @@ EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
>  void kvm_define_user_return_msr(unsigned slot, u32 msr)
>  {
>  	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
> -	user_return_msrs_global.msrs[slot] = msr;
> -	if (slot >= user_return_msrs_global.nr)
> -		user_return_msrs_global.nr = slot + 1;
> +	kvm_uret_msrs_list[slot] = msr;
> +	if (slot >= kvm_nr_uret_msrs)
> +		kvm_nr_uret_msrs = slot + 1;
>  }
>  EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
>  
> @@ -368,8 +365,8 @@ int kvm_find_user_return_msr(u32 msr)
>  {
>  	int i;
>  
> -	for (i = 0; i < user_return_msrs_global.nr; ++i) {
> -		if (user_return_msrs_global.msrs[i] == msr)
> +	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
> +		if (kvm_uret_msrs_list[i] == msr)
>  			return i;
>  	}
>  	return -1;
> @@ -383,8 +380,8 @@ static void kvm_user_return_msr_cpu_online(void)
>  	u64 value;
>  	int i;
>  
> -	for (i = 0; i < user_return_msrs_global.nr; ++i) {
> -		rdmsrl_safe(user_return_msrs_global.msrs[i], &value);
> +	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
> +		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
>  		msrs->values[i].host = value;
>  		msrs->values[i].curr = value;
>  	}
> @@ -399,7 +396,7 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>  	value = (value & mask) | (msrs->values[slot].host & ~mask);
>  	if (value == msrs->values[slot].curr)
>  		return 0;
> -	err = wrmsrl_safe(user_return_msrs_global.msrs[slot], value);
> +	err = wrmsrl_safe(kvm_uret_msrs_list[slot], value);
>  	if (err)
>  		return 1;
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


