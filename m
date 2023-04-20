Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4746E9825
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 17:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjDTPRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 11:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjDTPRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 11:17:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631B5189
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 08:17:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a682ad2f8cso7745905ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 08:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682003851; x=1684595851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Fvh5Bs16xnW1weT2SPid3PSg+u8/Q14PbTNxokyuWo=;
        b=0Lwk6zvT1sdE3h8JzGU30U5B2GAF3IGSbkbBGobwWjNzCZvLtIOzkNc+aveiepxTAs
         WaAK/i7YbEhDG2NDLUpNX6THYw8haqXyojuWZ4wmeO7iGc3cq8HwF3oUxq8Ol92O1z2T
         hi4MCRBBTGq2u6EMEsQiLxQDCm+QEsU263UVSRUL2PE43LmOVPxu0eFMHRPbEkDg4TfT
         uobdLbwf2YItMZtIgpTxQ2rIfnYXNx+lpmvnNGMtHXSo0bDbtU6H888CU9MzugYu3YZg
         DWMBre8DaUAzW3gfyRElbNJemM8dx6YakEoK9mD3yLdn1MRKe/fRStX26QgHS1FoeyUV
         uNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682003851; x=1684595851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Fvh5Bs16xnW1weT2SPid3PSg+u8/Q14PbTNxokyuWo=;
        b=P4Mj1so69Qo3SSSyz81gtXw/pQa5/4AY/hb/b4h6JIXIuWShgTwsz5WkWiqGYMDRqo
         whNIvEi7c/9YrLQIs2mLoRKN6u8ipfumzCAqLk5T3ezfzk/L1JYZugas6doksA+ezVDg
         3W95usY/7GDvKOMBlYd64rqvVrty93yN35Kkm1MtyfExBsslHyZ20gqy1MuqRFmxygxR
         vXIIb8CPbys9U6RUyM1+NgT9cOY+Vo45OxdiPk53zm6LDp0+xirK2zDnYexx6Fue3mez
         Rdh94d77HlqPaGwVcurjj0D7DwnR3w2X2r7DuPNapG9No5gLg1+/UDE6QVxoCHOLTUVN
         DPAg==
X-Gm-Message-State: AAQBX9fvm5xvNuZ2+NZqFrhJUWzaOoYSePFpQelP+lG/T15LwRZGIHw9
        f2eeWO1XXubF91MPJaf3dpL13uK6REE=
X-Google-Smtp-Source: AKy350ZBzilYp4PKzE37W4X5nKyyeFADvasG2SeZc5SDTlWjPiAdZDU+NJV1a/nzmUjYdsysw7dwNLoKUeU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:50d:b0:1a6:3fb2:f52d with SMTP id
 jn13-20020a170903050d00b001a63fb2f52dmr618731plb.3.1682003850946; Thu, 20 Apr
 2023 08:17:30 -0700 (PDT)
Date:   Thu, 20 Apr 2023 08:17:29 -0700
In-Reply-To: <20230419221716.3603068-11-atishp@rivosinc.com>
Mime-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-11-atishp@rivosinc.com>
Message-ID: <ZEFXiXu+0XLSdRkQ@google.com>
Subject: Re: [RFC 10/48] RISC-V: KVM: Implement static memory region measurement
From:   Sean Christopherson <seanjc@google.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        "=?iso-8859-1?Q?Bj=F6rn_T=F6pel?=" <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023, Atish Patra wrote:
> +int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_cove_measure_region *mr)
> +{
> +	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
> +	int rc = 0, idx, num_pages;
> +	struct kvm_riscv_cove_mem_region *conf;
> +	struct page *pinned_page, *conf_page;
> +	struct kvm_riscv_cove_page *cpage;
> +
> +	if (!tvmc)
> +		return -EFAULT;
> +
> +	if (tvmc->finalized_done) {
> +		kvm_err("measured_mr pages can not be added after finalize\n");
> +		return -EINVAL;
> +	}
> +
> +	num_pages = bytes_to_pages(mr->size);
> +	conf = &tvmc->confidential_region;
> +
> +	if (!IS_ALIGNED(mr->userspace_addr, PAGE_SIZE) ||
> +	    !IS_ALIGNED(mr->gpa, PAGE_SIZE) || !mr->size ||
> +	    !cove_is_within_region(conf->gpa, conf->npages << PAGE_SHIFT, mr->gpa, mr->size))
> +		return -EINVAL;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	/*TODO: Iterate one page at a time as pinning multiple pages fail with unmapped panic
> +	 * with a virtual address range belonging to vmalloc region for some reason.

I've no idea what code you had, but I suspect the fact that vmalloc'd memory isn't
guaranteed to be physically contiguous is relevant to the panic.

> +	 */
> +	while (num_pages) {
> +		if (signal_pending(current)) {
> +			rc = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		rc = get_user_pages_fast(mr->userspace_addr, 1, 0, &pinned_page);
> +		if (rc < 0) {
> +			kvm_err("Pinning the userpsace addr %lx failed\n", mr->userspace_addr);
> +			break;
> +		}
> +
> +		/* Enough pages are not available to be pinned */
> +		if (rc != 1) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +		conf_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +		if (!conf_page) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +
> +		rc = cove_convert_pages(page_to_phys(conf_page), 1, true);
> +		if (rc)
> +			break;
> +
> +		/*TODO: Support other pages sizes */
> +		rc = sbi_covh_add_measured_pages(tvmc->tvm_guest_id, page_to_phys(pinned_page),
> +						 page_to_phys(conf_page), SBI_COVE_PAGE_4K,
> +						 1, mr->gpa);
> +		if (rc)
> +			break;
> +
> +		/* Unpin the page now */
> +		put_page(pinned_page);
> +
> +		cpage = kmalloc(sizeof(*cpage), GFP_KERNEL_ACCOUNT);
> +		if (!cpage) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +
> +		cpage->page = conf_page;
> +		cpage->npages = 1;
> +		cpage->gpa = mr->gpa;
> +		cpage->hva = mr->userspace_addr;

Snapshotting the userspace address for the _source_ page can't possibly be useful.

> +		cpage->is_mapped = true;
> +		INIT_LIST_HEAD(&cpage->link);
> +		list_add(&cpage->link, &tvmc->measured_pages);
> +
> +		mr->userspace_addr += PAGE_SIZE;
> +		mr->gpa += PAGE_SIZE;
> +		num_pages--;
> +		conf_page = NULL;
> +
> +		continue;
> +	}
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	if (rc < 0) {
> +		/* We don't to need unpin pages as it is allocated by the hypervisor itself */

This comment makes no sense.  The above code is doing all of the allocation and
pinning, which strongly suggests that KVM is the hypervisor.  But this comment
implies that KVM is not the hypervisor.

And "pinned_page" is cleared unpinned in the loop after the page is added+measured,
which looks to be the same model as TDX where "pinned_page" is the source and
"conf_page" is gifted to the hypervisor.  But on failure, e.g. when allocating
"conf_page", that reference is not put.

> +		cove_delete_page_list(kvm, &tvmc->measured_pages, false);
> +		/* Free the last allocated page for which conversion/measurement failed */
> +		kfree(conf_page);

Assuming my guesses about how the architecture works are correct, this is broken
if sbi_covh_add_measured_pages() fails.  The page has already been gifted to the
TSM by cove_convert_pages(), but there is no call to sbi_covh_tsm_reclaim_pages(),
which I'm guessing is necesary to transition the page back to a state where it can
be safely used by the host.
