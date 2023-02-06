Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23DD68CAD1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBFXxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBFXxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:53:49 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7496D2F7A6
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 15:53:48 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id t20so260482vsa.12
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 15:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zxq2MjNyjTiKPe+e54ZGdQfseG5oFgTN20Sk0NhevJU=;
        b=KXN7BgkAKRfghoPQliwOEcghdFgCavhapKhYhu24kwgo1ru29J+4xcKmC4xtdC9KnB
         e+KgMvmFy2al1UDxFsGEyqfiooVMqZ3PGqr/IZ1wATNQII0NlTXXsnxJvOtFM7YP54K7
         QogVCLD/z3zYZfadSjEIgQg7MDdnr4DEwhFMA1fzgqfanL8L1R+QSPpi3uHQXBhfgQmR
         lcyqCxPhS4KbzYzCDhIGSTiyfZWQUdVQnP7WguaVNu2eYigQUZvqwUE4+npf+9A4pqix
         lnHfDA8sG/nw1NUDWPiXSFuI9oIq3d0Ah9VcEGAx8Va5azEO5tnkQ94onQs5+pvFoo0B
         PwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zxq2MjNyjTiKPe+e54ZGdQfseG5oFgTN20Sk0NhevJU=;
        b=KVTddw/Wqi4UCgXpAyGQqZyopyhWFnAz9pjCY1nBQbIx1UB0+d2eU35kXaJUdD4fem
         r3rz8c+WKk8jwukqAIOYuq3Vp04FFI2p7KNJXP+DkPc4nKXRcfQcp1tMVvjZwOvpqD/7
         87Gkra8IqqaXu/DX18B5addLG4xrYxMG3bpjRENroVmjT2ViIPAhmQ02QgQzBJK9qdsD
         OJdeyW7tpqeL/iNvDOA8ckUSsSrobH/3+xh20eqQx24PYgggHaWrDjPrWWwAZza7loX6
         ODMH4H8H/CH8amp5n43K7OqxzpEM+fkT6GqxVtz4hiFchvR++FEMXM6+NuNggjrNqKsP
         wSWg==
X-Gm-Message-State: AO0yUKVG/YCeev7xudSvYptuhFiU6M0wuTl1bFtGXBxWLQkhBkfZBzGm
        nqH0nRTmD2D7FNMIKnQCmhmgJPfy6iIhJGI9M6uQXA==
X-Google-Smtp-Source: AK7set/72A43ENFd2BdH7pYwi9k+sdd+lus7IGlzGM/pZdnZ/Ydu6qyXLx4kzwdB6htpvRUQRWTwIEaUI1SAoeSB88o=
X-Received: by 2002:a05:6102:352:b0:3f2:f733:fb2e with SMTP id
 e18-20020a056102035200b003f2f733fb2emr287571vsa.38.1675727627535; Mon, 06 Feb
 2023 15:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-3-vipinsh@google.com>
In-Reply-To: <20230203192822.106773-3-vipinsh@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 6 Feb 2023 15:53:21 -0800
Message-ID: <CALzav=d9h-fVgdsK138m74a_qTyay9cprcbdWAJk4GJtw4p6tg@mail.gmail.com>
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 30a52e5e68de..21046b34f94e 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -121,4 +121,17 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
>
> +static inline u64 kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
> +{
> +       atomic64_t *sptep;
> +
> +       if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level)) {
> +               sptep = (atomic64_t *)rcu_dereference(iter->sptep);
> +               return (u64)atomic64_fetch_and(~mask, sptep);

I think you can just set iter->old_spte here and drop the return value?

> +       }
> +
> +       __kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
> +       return iter->old_spte;
> +}
