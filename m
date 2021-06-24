Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309AC3B358F
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhFXSY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:24:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232348AbhFXSY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=awHctwhnQvOlpVBlIdZsLdHggoa/5k/F8OaeC4LX72g=;
        b=RGHU5CCHPNP/ArVj+0PxgpKKOsT52XOzutt7XePhNdPTdEuKgU1E1Iu42tN4SDDpKfQFCA
        v3GJbdMf7I/KEmaHhr/cg87ryo4vGjhOG0Xw34LyCYlXVX/RVoojqG0VmsOZKF0l+URfRu
        DsqhSiW/nB+t3onIaTeZzxXBG7hz6RQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-NiwAuCoVMxqzL11zRD_7NQ-1; Thu, 24 Jun 2021 14:22:37 -0400
X-MC-Unique: NiwAuCoVMxqzL11zRD_7NQ-1
Received: by mail-io1-f69.google.com with SMTP id r3-20020a6b8f030000b02904e159249245so5095249iod.19
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=awHctwhnQvOlpVBlIdZsLdHggoa/5k/F8OaeC4LX72g=;
        b=fph/rFK5IYXPCiA70DWWcXO33g9yU4oMyLzMKJ/vSAYdGSaOK4467CmM2OHZlRL0gp
         hp23eE5cOo7Mf/t0rEEv+OUfosVd0LiCNPWD+GfFwZI3twCWV2dQFgGvk8aF/skZuk8m
         gFzHXbBhz+27+cc9i0RTBvc+uAqQhgXcz3BHm36FNC5/Tad03P4NWoxKdbHR5K4tYJUt
         X5DKuIynKwzKNPR/nkwRHXzlrB5IP20bXOiSFHnHbQQxGgAwDfpBpd8X1iMSE/PdQPy/
         1Y1P1/0fcjJ4oa74tOEMg/aOf3roKku7u/5CANhP9mPrnsc72PiPW2V0PjZQjDGmxT28
         Ubxw==
X-Gm-Message-State: AOAM530Jj8F2aSWin3NqYclAF3zAe2efjKFym3eF5C4KDWX8hFLN9+CJ
        s0E5Qy4HaptBL3hMkhVAGupux4ZWZ62++P+6f2BZO0VgTlatq2L3wYZ+u9cEBtEbMiDlFpd1nfC
        A8RNvrAY29byG3Srj8PFp1SL1jJ6odxSVrslImwtrMG+Ta7arr4C/E1enAIsFgQ==
X-Received: by 2002:a6b:6604:: with SMTP id a4mr5023609ioc.205.1624558955584;
        Thu, 24 Jun 2021 11:22:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg+o1eNxgdUNhNG8a1icn8Vk7vCzH2OYMK8xo7ifeVWce358fH5bTw02Yy2oUGfNStYNkjVQ==
X-Received: by 2002:a6b:6604:: with SMTP id a4mr5023583ioc.205.1624558955311;
        Thu, 24 Jun 2021 11:22:35 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id t10sm2144495ilq.88.2021.06.24.11.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:22:34 -0700 (PDT)
Date:   Thu, 24 Jun 2021 14:22:33 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 6/9] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs
 file
Message-ID: <YNTNaTOsY4lr7Y2Q@t490s>
References: <20210624181356.10235-1-peterx@redhat.com>
 <20210624181356.10235-7-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624181356.10235-7-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 02:13:53PM -0400, Peter Xu wrote:
> Use this file to dump rmap statistic information.

I should still paste some example output here in commit message, which I think
could help on review but I forgot..  There's actually a example in another
commit message, but still, it looks like this (6G guest):

# cat mmu_rmaps_stat
Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
Level=4K:       3089171 49005   14016   1363    235     212     15      7       0       0       0
Level=2M:       5951    227     0       0       0       0       0       0       0       0       0
Level=1G:       32      0       0       0       0       0       0       0       0       0       0

We've got another smm address spaces so it's just got doubled.

I'll append that into commit message in the new version (as long as I don't get
a NAK on this patch).

> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 113 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2acbea2f3b5..6dfae8375c44 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -30,6 +30,7 @@
>  #include "hyperv.h"
>  #include "lapic.h"
>  #include "xen.h"
> +#include "mmu/mmu_internal.h"
>  
>  #include <linux/clocksource.h>
>  #include <linux/interrupt.h>
> @@ -58,6 +59,7 @@
>  #include <linux/sched/isolation.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/entry-kvm.h>
> +#include <linux/debugfs.h>
>  
>  #include <trace/events/kvm.h>
>  
> @@ -10763,6 +10765,117 @@ int kvm_arch_post_init_vm(struct kvm *kvm)
>  	return kvm_mmu_post_init_vm(kvm);
>  }
>  
> +/*
> + * This covers statistics <1024 (11=log(1024)+1), which should be enough to
> + * cover RMAP_RECYCLE_THRESHOLD.
> + */
> +#define  RMAP_LOG_SIZE  11
> +
> +static const char *kvm_lpage_str[KVM_NR_PAGE_SIZES] = { "4K", "2M", "1G" };
> +
> +static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
> +{
> +	struct kvm_rmap_head *rmap;
> +	struct kvm *kvm = m->private;
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	unsigned int lpage_size, index;
> +	/* Still small enough to be on the stack */
> +	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
> +	int i, j, k, l, ret;
> +
> +	memset(log, 0, sizeof(log));
> +
> +	ret = -ENOMEM;
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
> +		log[i] = kzalloc(RMAP_LOG_SIZE * sizeof(unsigned int), GFP_KERNEL);
> +		if (!log[i])
> +			goto out;
> +	}
> +
> +	mutex_lock(&kvm->slots_lock);
> +	write_lock(&kvm->mmu_lock);
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +		for (j = 0; j < slots->used_slots; j++) {
> +			slot = &slots->memslots[j];
> +			for (k = 0; k < KVM_NR_PAGE_SIZES; k++) {
> +				rmap = slot->arch.rmap[k];
> +				lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
> +				cur = log[k];
> +				for (l = 0; l < lpage_size; l++) {
> +					index = ffs(pte_list_count(&rmap[l]));
> +					if (WARN_ON_ONCE(index >= RMAP_LOG_SIZE))
> +						index = RMAP_LOG_SIZE - 1;
> +					cur[index]++;
> +				}
> +			}
> +		}
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	/* index=0 counts no rmap; index=1 counts 1 rmap */
> +	seq_printf(m, "Rmap_Count:\t0\t1\t");
> +	for (i = 2; i < RMAP_LOG_SIZE; i++) {
> +		j = 1 << (i - 1);
> +		k = (1 << i) - 1;
> +		seq_printf(m, "%d-%d\t", j, k);
> +	}
> +	seq_printf(m, "\n");
> +
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
> +		seq_printf(m, "Level=%s:\t", kvm_lpage_str[i]);
> +		cur = log[i];
> +		for (j = 0; j < RMAP_LOG_SIZE; j++)
> +			seq_printf(m, "%d\t", cur[j]);
> +		seq_printf(m, "\n");
> +	}
> +
> +	ret = 0;
> +out:
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; i++)
> +		if (log[i])
> +			kfree(log[i]);
> +
> +	return ret;
> +}
> +
> +static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
> +{
> +	struct kvm *kvm = inode->i_private;
> +
> +	if (!kvm_get_kvm_safe(kvm))
> +		return -ENOENT;
> +
> +	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
> +}
> +
> +static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
> +{
> +	struct kvm *kvm = inode->i_private;
> +
> +	kvm_put_kvm(kvm);
> +
> +	return single_release(inode, file);
> +}
> +
> +static const struct file_operations mmu_rmaps_stat_fops = {
> +	.open		= kvm_mmu_rmaps_stat_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_mmu_rmaps_stat_release,
> +};
> +
> +int kvm_arch_create_vm_debugfs(struct kvm *kvm)
> +{
> +	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
> +			    &mmu_rmaps_stat_fops);
> +	return 0;
> +}
> +
>  static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>  {
>  	vcpu_load(vcpu);
> -- 
> 2.31.1
> 

-- 
Peter Xu

