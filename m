Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88E6C7DFE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjCXMYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjCXMYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:24:44 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10AC24BD3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:24:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eh3so7194057edb.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1679660678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saiJWfiBJYUHFmmkpXKqAcWXgG16rIcjFJWmsrkcUI8=;
        b=EtKrFAIJqJ7YZIEm/FMGhq05IjhpUe6/Li67kSto0rxiCIL9ChSECmKLpZP8MICvTJ
         A4LHKUIBYl66xKKWghQbVhEdqlDgGPZEYd2HSUiblT6Vo1VXHrFQlUEOFe1OebHWzo7w
         rwO+LIZs1KftyqlJM2mcOpIUhnH/IyoXSWnuzw2kjpysVG6cQVYfE1q+fMorBZbWDwGd
         fADvXukNqjPLIZRBWs5TTZjekakGChj4gh1AUE06DWDCuGHFuJfzs+XJWGfh/Q282xjG
         p9zUmlLcgePiwXKo0ntqmBcx/pqwztc0KqarUUddIvb+7ACbF6J6uPnKdbi/ZQOTWWgG
         Snig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679660678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saiJWfiBJYUHFmmkpXKqAcWXgG16rIcjFJWmsrkcUI8=;
        b=xAJafDEGhKGhBmOApqy7cs6U0FJpJPyH7p93TPrTwpMe6FgWcwPM44krDzAl42F/3y
         ywyuG+CziT1p/brKhLV1cLlXQyePB19RofmVVeoJhkPxWJgL2pD3ovBoo7b0NiKkEcHL
         bmmexYwvLeJHfqnLs7qrhxjB+7wOmzo8BALJyLVSvV2VXA6FT8i7OOTtcCNv31lbUa9W
         1uCHtZ4Kwsze1Id4cVJPiZjHwLKnLAO0LaFMwlEZiQkBFCWGzA2PbLmy5TgF1vqHiYjL
         dKyhhnxj36wXgcj06W3t1KNEuCbMoIeZj0ydOB+dvryDVF8YBNuiwQwtuEuIYm++o9Q0
         vWXg==
X-Gm-Message-State: AO0yUKXjrKmdhO6Odj2Q7NjrYyUe0Af8KTSodb5mOHQKn0ZMybdDOCK/
        nrd0/lkoIUyBB7WPQSFVBMBtjJIilEJS/1HVVk6TfA==
X-Google-Smtp-Source: AK7set9rky6P4VsXrUmz7PYgIM7cL0IKBL36K0jYa02+JzZXAjW8VAmeF9bBNJsOXuA+Z8/lRmfSNoLeRN5Gl/Db24Q=
X-Received: by 2002:a17:907:11c6:b0:930:310:abe3 with SMTP id
 va6-20020a17090711c600b009300310abe3mr5178745ejb.6.1679660678163; Fri, 24 Mar
 2023 05:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230317211106.1234484-1-dmatlack@google.com>
In-Reply-To: <20230317211106.1234484-1-dmatlack@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 24 Mar 2023 17:54:27 +0530
Message-ID: <CAAhSdy3RJvsCTTfr6mCJe+=on-B0QOM10dTchAR7rKq0tyVWEA@mail.gmail.com>
Subject: Re: [PATCH] KVM: RISC-V: Retry fault if vma_lookup() results become invalid
To:     David Matlack <dmatlack@google.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 18, 2023 at 2:41=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
> detect if the results of vma_lookup() (e.g. vma_shift) become stale
> before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
> VMA could be changed by userspace after vma_lookup() and before KVM
> reads the mmu_invalidate_seq, causing KVM to install page table entries
> based on a (possibly) no-longer-valid vma_shift.
>
> Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
> is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
> inducing spurious fault retries).
>
> It's unlikely that any sane userspace currently modifies VMAs in such a
> way as to trigger this race. And even with directed testing I was unable
> to reproduce it. But a sufficiently motivated host userspace might be
> able to exploit this race.
>
> Note KVM/ARM had the same bug and was fixed in a separate, near
> identical patch (see Link).
>
> Link: https://lore.kernel.org/kvm/20230313235454.2964067-1-dmatlack@googl=
e.com/
> Fixes: 9955371cc014 ("RISC-V: KVM: Implement MMU notifiers")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>

I have tested this patch for both QEMU RV64 and RV32 so,
Tested-by: Anup Patel <anup@brainfault.org>

Queued this patch as fixes for Linux-6.3

Thanks,
Anup

> ---
> Note: Compile-tested only.
>
>  arch/riscv/kvm/mmu.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 78211aed36fa..46d692995830 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -628,6 +628,13 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                         !(memslot->flags & KVM_MEM_READONLY)) ? true : fa=
lse;
>         unsigned long vma_pagesize, mmu_seq;
>
> +       /* We need minimum second+third level pages */
> +       ret =3D kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
> +       if (ret) {
> +               kvm_err("Failed to topup G-stage cache\n");
> +               return ret;
> +       }
> +
>         mmap_read_lock(current->mm);
>
>         vma =3D vma_lookup(current->mm, hva);
> @@ -648,6 +655,15 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>         if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SIZE)
>                 gfn =3D (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_S=
HIFT;
>
> +       /*
> +        * Read mmu_invalidate_seq so that KVM can detect if the results =
of
> +        * vma_lookup() or gfn_to_pfn_prot() become stale priort to acqui=
ring
> +        * kvm->mmu_lock.
> +        *
> +        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pa=
irs
> +        * with the smp_wmb() in kvm_mmu_invalidate_end().
> +        */
> +       mmu_seq =3D kvm->mmu_invalidate_seq;
>         mmap_read_unlock(current->mm);
>
>         if (vma_pagesize !=3D PUD_SIZE &&
> @@ -657,15 +673,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 return -EFAULT;
>         }
>
> -       /* We need minimum second+third level pages */
> -       ret =3D kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
> -       if (ret) {
> -               kvm_err("Failed to topup G-stage cache\n");
> -               return ret;
> -       }
> -
> -       mmu_seq =3D kvm->mmu_invalidate_seq;
> -
>         hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
>         if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>
> base-commit: eeac8ede17557680855031c6f305ece2378af326
> --
> 2.40.0.rc2.332.ga46443480c-goog
>
