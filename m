Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F869D5D5
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBTVhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 16:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjBTVhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 16:37:14 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5773421950;
        Mon, 20 Feb 2023 13:37:13 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id a10so2503470ljq.1;
        Mon, 20 Feb 2023 13:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntTegXxHE2C6Lp8xdtMzn8aIclw1LjjCN5pS0JeaA8A=;
        b=K8zGSFBNI3bdU6J5gbrSYZcfL5sYsQjVxJTFkpIjhAqxR1Xxr817nUsCsnvL/JrUMp
         qoPWnoDVVtnpBTvblsnDdqASG0UQ7WxtCHGWIaD8xXMKvw5xxrEYv2zRrGw6EEzNHKUj
         UvEzax+npqRsxhJ8JA5VL57mkKzv9SPf0eqWr2PQ9wgxyXnOW9NxfdumExqueZbw8FsP
         wisNc6cs8i8MKfQZbkfwjawdBzTETXo+kIWV3oi/vN1tHuW82XTJjBjtLNQC8BQNNasi
         WK8w/uHuMYgkSPwZ4AYAG3k6i5mpyxrTtxYMwhqKcy7nCMpQ5pEsrC1o/nSFiQWyHmA1
         CWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntTegXxHE2C6Lp8xdtMzn8aIclw1LjjCN5pS0JeaA8A=;
        b=s86O6DVA+j36TewuTjirw4ij08QE4aNeKj504Ccn6pER2jgO7BtjTYO0ukKzTA2fS+
         +AxOztBbX7XYBr35em0BG1OqFfbCVwQ6Y7h5tRQ83KraHEKJ084UyC3vAQZKOx12CWFN
         FS6wBVQixbJzsisScHkKvL2QGconoYgjATGW5Dkjr/9zEfphVogbBD0Eg7oBe3+19qVt
         jVJksFLWAE2QHJAiDUA0qLy6/CQyse2DGN1KSiXa7a+t/aDivoChoV279en9u69jB7+s
         ylXrTN2L6WO7Vp1vHmr+pvME1WjSz9/e9fgsAum9uSMA0s9rJfhURY6GZ/aFDC8h7bPs
         JEsQ==
X-Gm-Message-State: AO0yUKUCqR72wuO2l/Qe4p+GMec/EOfW6VkOSzCNXWRU5rG0kx5IQnWU
        DODvHPM6b6TMCH/TKutxEaQ=
X-Google-Smtp-Source: AK7set9ere6899+uPRGjAaNY74PLHi6orKNOrPSws3NLJTJtiICDHHa4uvOj8GLhs/n/V591Itkx1Q==
X-Received: by 2002:a05:651c:210f:b0:293:52a4:9717 with SMTP id a15-20020a05651c210f00b0029352a49717mr1528073ljq.4.1676929031468;
        Mon, 20 Feb 2023 13:37:11 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id y2-20020a2e3202000000b002934ff9c817sm401104ljy.107.2023.02.20.13.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 13:37:11 -0800 (PST)
Date:   Mon, 20 Feb 2023 23:37:09 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v8 04/56] KVM: Add HVA range operator
Message-ID: <20230220233709.00006dfc@gmail.com>
In-Reply-To: <20230220183847.59159-5-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-5-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:37:55 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Vishal Annapurve <vannapurve@google.com>
> 
> Introduce HVA range operator so that other KVM subsystems
> can operate on HVA range.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> [mdr: minor checkpatch alignment fixups]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  include/linux/kvm_host.h |  6 +++++
>  virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4d542060cd93..c615650ed256 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1402,6 +1402,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
>  void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
>  void kvm_mmu_invalidate_end(struct kvm *kvm);
>  
> +typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
> +				struct kvm_gfn_range *range, void *data);
> +
> +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
> +
>  long kvm_arch_dev_ioctl(struct file *filp,
>  			unsigned int ioctl, unsigned long arg);
>  long kvm_arch_vcpu_ioctl(struct file *filp,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f7e00593cc5d..4ccd655dd5af 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -642,6 +642,54 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	return (int)ret;
>  }
>  

Below function seems a reduced duplicate of __kvm_handle_hva_range()
in virt/kvm/kvm_main.c. It would be nice to factor __kvm_handle_hva_range().

> +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
> +{
> +	int ret = 0;
> +	struct kvm_gfn_range gfn_range;
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	int i, idx;
> +
> +	if (WARN_ON_ONCE(hva_end <= hva_start))
> +		return -EINVAL;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> +		struct interval_tree_node *node;
> +
> +		slots = __kvm_memslots(kvm, i);
> +		kvm_for_each_memslot_in_hva_range(node, slots,
> +						  hva_start, hva_end - 1) {
> +			unsigned long start, end;
> +
> +			slot = container_of(node, struct kvm_memory_slot,
> +					    hva_node[slots->node_idx]);
> +			start = max(hva_start, slot->userspace_addr);
> +			end = min(hva_end, slot->userspace_addr +
> +						  (slot->npages << PAGE_SHIFT));
> +
> +			/*
> +			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> +			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> +			 */
> +			gfn_range.start = hva_to_gfn_memslot(start, slot);
> +			gfn_range.end = hva_to_gfn_memslot(end + PAGE_SIZE - 1, slot);
> +			gfn_range.slot = slot;
> +
> +			ret = handler(kvm, &gfn_range, data);
> +			if (ret)
> +				goto e_ret;
> +		}
> +	}
> +
> +e_ret:
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return ret;
> +}
> +
>  static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  						unsigned long start,
>  						unsigned long end,

