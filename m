Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24E73DDF28
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhHBSac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHBSa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 14:30:29 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA09AC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 11:30:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d1so20682384pll.1
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 11:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L3jHyeWhOPlnmHEQqXQZtFquEdYtQ8PlFuxX/iA0B/s=;
        b=kkjr9Q/jcBdtyVY5j9GqKJURedDDefAXP9V4LLH7jtLeQqkTsQo/ZuqK1HHxKKvaLY
         ckm/XCuKGJyChRIRNCuBPMHQY90EAtuNL6ptK857EoNl7NBUH+omXWvJKVbIv0+ljlnU
         IiHomGcvuGugBEKgR5O0j5SlsR5VOunsN5drCoPuO916v4Kz6Zilh157r0R12lMvZirw
         1AeNotywzHUneXGQGeV3QB0utob2Be5+J7zESX0D/ZOO2ozyaNV+lh2IiZ8++WadhUl2
         A1yKt7ur0DcQrw+3deesKHw2I2qg1XlE2o/MWjsqOTIfeVUGZ86Fg/F+8ToYMRQbeDQl
         LA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L3jHyeWhOPlnmHEQqXQZtFquEdYtQ8PlFuxX/iA0B/s=;
        b=DACpfrXR+9xiIicP7tR1OrQS7Quvk0ZhUrRKtKJwuVhDAysGu27n0Jd360j8Cbu2S5
         kD2KRdqQz5eCyAyUhyguDlf2xJAaArjv91WDESQgPMRZkBrNx1Zh+IDodaLmoVrHMt/g
         g1UboxQRFTB3R3VKULJUec+Nfwt+SisuPINtPmBHmRExbMTDEW383YJM/t0YineZgBAk
         /MoO+r238q8ken322kd5Qh3kvFVHWYN0YBRW4hG3QOwKQs3HBavCYiMrCxR3eIQ8d7f4
         b3IvA+WU15Xdm5fKNAENeHDREBxxEigxkeJr5LcKjgq+uEsqCTIBJ5v0wH5w+QxTaZlf
         RhNQ==
X-Gm-Message-State: AOAM531e3O0KyFbb6CGrzZx40/+0iGDoXtSesuV0tUmi5pbdo8WEx+N9
        9/6JRmhUey7lAzkskdlGhQibVg==
X-Google-Smtp-Source: ABdhPJxRFU6SpKvF4ZIie4VYq4AmJSV23DiH9m8nZORtUbgYg8beriVgY9zbA/I1wRaSH3jlkqsqcA==
X-Received: by 2002:a17:902:ab05:b029:12c:3d3:cc93 with SMTP id ik5-20020a170902ab05b029012c03d3cc93mr15525090plb.74.1627929018268;
        Mon, 02 Aug 2021 11:30:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j10sm13563971pfd.200.2021.08.02.11.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:30:17 -0700 (PDT)
Date:   Mon, 2 Aug 2021 18:30:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Block memslot updates across range_start() and
 range_end()
Message-ID: <YQg5tQslPv83TTQW@google.com>
References: <20210727171808.1645060-1-pbonzini@redhat.com>
 <20210727171808.1645060-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727171808.1645060-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021, Paolo Bonzini wrote:
> @@ -764,8 +769,9 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
>  {
>  	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
>  	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
> -			lockdep_is_held(&kvm->slots_lock) ||
> -			!refcount_read(&kvm->users_count));
> +				      lockdep_is_held(&kvm->slots_lock) ||
> +				      READ_ONCE(kvm->mn_active_invalidate_count) ||

Hmm, I'm not sure we should add mn_active_invalidate_count as an exception to
holding kvm->srcu.  It made sense in original (flawed) approach because the
exception was a locked_is_held() check, i.e. it was verifying the the current
task holds the lock.  With mn_active_invalidate_count, this only verifies that
there's an invalidation in-progress, it doesn't verify that this task/CPU is the
one doing the invalidation.

Since __kvm_handle_hva_range() takes SRCU for read, maybe it's best omit this?

> +				      !refcount_read(&kvm->users_count));
>  }
>  
>  static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)

...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5cc79373827f..c64a7de60846 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -605,10 +605,8 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>  
>  	/*
>  	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),

Nit, the comma can be switch to a period.  The next patch starts a new sentence,
so it would be correct even in the long term.

> -	 * and so always runs with an elevated notifier count.  This obviates
> -	 * the need to bump the sequence count.
>  	 */
> -	WARN_ON_ONCE(!kvm->mmu_notifier_count);
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
>  
>  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
>  }

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
