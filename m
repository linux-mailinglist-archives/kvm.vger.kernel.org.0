Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EED577795E
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbjHJNQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjHJNQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 09:16:54 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BBFC10E6;
        Thu, 10 Aug 2023 06:16:52 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxlPBC49RkDLEUAA--.44585S3;
        Thu, 10 Aug 2023 21:16:50 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax98xB49RkxTVTAA--.56519S3;
        Thu, 10 Aug 2023 21:16:49 +0800 (CST)
Message-ID: <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
Date:   Thu, 10 Aug 2023 21:16:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <20230810090218.26244-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Ax98xB49RkxTVTAA--.56519S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr1xXFWDZw4kWFW3tFyDtwc_yoW5CrW8pF
        WDKrZ5GFsrX3yqgayjqa1vya43XrZ7Wa18Ja4fGr9xtFn0grnrJrW8KwnFvFykAr9YqF13
        Zayjqr18u34UAagCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcApnDU
        UUU
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/10 17:02, Yan Zhao 写道:
> Register to .numa_protect() callback in mmu notifier so that KVM can get
> acurate information about when a page is PROT_NONE protected in primary
> MMU and unmap it in secondary MMU accordingly.
> 
> In KVM's .invalidate_range_start() handler, if the event is to notify that
> the range may be protected to PROT_NONE for NUMA migration purpose,
> don't do the unmapping in secondary MMU. Hold on until.numa_protect()
> comes.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/kvm_main.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dfbaafbe3a00..907444a1761b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -711,6 +711,20 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
>  }
>  
> +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
> +					  struct mm_struct *mm,
> +					  unsigned long start,
> +					  unsigned long end)
> +{
> +	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> +
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
> +		return;
> +
> +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
> +}
numa balance will scan wide memory range, and there will be one time
ipi notification with kvm_flush_remote_tlbs. With page level notification,
it may bring out lots of flush remote tlb ipi notification.

however numa balance notification, pmd table of vm maybe needs not be freed
in kvm_unmap_gfn_range.

Regards
Bibo Mao
> +
>  void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
>  			      unsigned long end)
>  {
> @@ -744,14 +758,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  					const struct mmu_notifier_range *range)
>  {
>  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> +	bool is_numa = (range->event == MMU_NOTIFY_PROTECTION_VMA) &&
> +		       (range->flags & MMU_NOTIFIER_RANGE_NUMA);
>  	const struct kvm_hva_range hva_range = {
>  		.start		= range->start,
>  		.end		= range->end,
>  		.pte		= __pte(0),
> -		.handler	= kvm_unmap_gfn_range,
> +		.handler	= !is_numa ? kvm_unmap_gfn_range :
> +				  (void *)kvm_null_fn,
>  		.on_lock	= kvm_mmu_invalidate_begin,
> -		.on_unlock	= kvm_arch_guest_memory_reclaimed,
> -		.flush_on_ret	= true,
> +		.on_unlock	= !is_numa ? kvm_arch_guest_memory_reclaimed :
> +				  (void *)kvm_null_fn,
> +		.flush_on_ret	= !is_numa ? true : false,
>  		.may_block	= mmu_notifier_range_blockable(range),
>  	};
>  
> @@ -899,6 +917,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
>  	.clear_young		= kvm_mmu_notifier_clear_young,
>  	.test_young		= kvm_mmu_notifier_test_young,
>  	.change_pte		= kvm_mmu_notifier_change_pte,
> +	.numa_protect		= kvm_mmu_notifier_numa_protect,
>  	.release		= kvm_mmu_notifier_release,
>  };
>  

