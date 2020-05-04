Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41D1C406A
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgEDQry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:47:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58690 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729643AbgEDQrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mqG4NiZOzEfqHtOMWsB/ZvHqz1Pp83h0dHQmV0QkakI=;
        b=Ur1cjJ1+sldibkigUwLQWiaX1Xus/EvypZUKVEt9XMHu1wXBRA/707UbASDD93Bq8doYp/
        nnQdUVc4n3VV2UV2vpTbvC2934YSTycYx+9sYfCCj8j74Ns9SWkrjJGflNqmYAJjKmzlXY
        GCAtF6FWhdE/anrhwGMeTuW5isUFm/o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-AF5x76cRNeSKOtSMDrzS_Q-1; Mon, 04 May 2020 12:47:46 -0400
X-MC-Unique: AF5x76cRNeSKOtSMDrzS_Q-1
Received: by mail-wr1-f71.google.com with SMTP id f15so10527wrj.2
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mqG4NiZOzEfqHtOMWsB/ZvHqz1Pp83h0dHQmV0QkakI=;
        b=T3851YeYw0tcMslWuZ6xZNiIh8zauOhF6FEo5iWYbDBFlT6qJhq659OR7dvKrO9DVo
         eaywxa8IFtxcROpMce5124Gy8u/YF85q6RQX76t8D8hhqKcQyvxx5Dt+i72Bfw7jnmPs
         zsY+KyEs+bgPKMxRiLgjJO4UsNSM7VRM975DmpC0wi0caTErgk+OvpJpJEOTEY6PY+6q
         bsY2gOb5wSvt1OndvSOkwvdTYU2RXwKtR6MNTKRNq+FxXO/aTFALmrJyW68EuoCSo5gX
         BfiBQx5/HISpVkjGs7TiqEqAGRhhnu4qEzObLnZ8RFqKr1AG08XGNaZ89XOHeA1/LJrW
         djlA==
X-Gm-Message-State: AGi0Puah4OqKA1YZEZLB7oqQl+mUxddRMrdBoDjUI4klCP6EH0anJkc0
        cswaPmQlqr44HsQJN9Pp9lKaBxl79uM+sddZnltfcl+T+AvVU5TfqAIHFMqV8M5U209fekXWYeb
        7wdnkLWp4PE8J
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr15413152wmd.67.1588610865737;
        Mon, 04 May 2020 09:47:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLDRC0oKvIrSTpQybtrO+sKCnZxuLzQYC4jjIPDre77gM0GB81TEH4UGwNEonZVOzx3VaVo3w==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr15413134wmd.67.1588610865542;
        Mon, 04 May 2020 09:47:45 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id a9sm40312wmm.38.2020.05.04.09.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:47:45 -0700 (PDT)
Subject: Re: [PATCH] x86: Fix RCU list usage to avoid false positive warnings
To:     madhuparnabhowmik10@gmail.com, mingo@redhat.com, bp@alien8.de
Cc:     x86@kernel.org, bhelgaas@google.com,
        sean.j.christopherson@intel.com, cai@lca.pw, paulmck@kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20200430192932.13371-1-madhuparnabhowmik10@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c992b7f-c6c7-44a6-fa5a-c3512646de05@redhat.com>
Date:   Mon, 4 May 2020 18:47:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430192932.13371-1-madhuparnabhowmik10@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 21:29, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Use list_for_each_entry() instead of list_for_each_entry_rcu() whenever
> spinlock or mutex is always held.
> Otherwise, pass cond to list_for_each_entry_rcu().
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
>  arch/x86/kernel/nmi.c          | 2 +-
>  arch/x86/kvm/irq_comm.c        | 3 ++-
>  arch/x86/pci/mmconfig-shared.c | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 6407ea21fa1b..999dc6c134d2 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -195,7 +195,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
>  
>  	raw_spin_lock_irqsave(&desc->lock, flags);
>  
> -	list_for_each_entry_rcu(n, &desc->head, list) {
> +	list_for_each_entry(n, &desc->head, list) {
>  		/*
>  		 * the name passed in to describe the nmi handler
>  		 * is used as the lookup key
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index c47d2acec529..5b88a648e079 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -258,7 +258,8 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>  	idx = srcu_read_lock(&kvm->irq_srcu);
>  	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
>  	if (gsi != -1)
> -		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
> +		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link,
> +					srcu_read_lock_held(&kvm->irq_srcu))
>  			if (kimn->irq == gsi)
>  				kimn->func(kimn, mask);
>  	srcu_read_unlock(&kvm->irq_srcu, idx);
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 6fa42e9c4e6f..a096942690bd 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -797,7 +797,7 @@ int pci_mmconfig_delete(u16 seg, u8 start, u8 end)
>  	struct pci_mmcfg_region *cfg;
>  
>  	mutex_lock(&pci_mmcfg_lock);
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +	list_for_each_entry(cfg, &pci_mmcfg_list, list)
>  		if (cfg->segment == seg && cfg->start_bus == start &&
>  		    cfg->end_bus == end) {
>  			list_del_rcu(&cfg->list);
> 

For KVM parts, if the x86 maintainers want to apply the whole patch,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

