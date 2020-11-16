Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596522B4C86
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 18:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbgKPRTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 12:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732710AbgKPRTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 12:19:54 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA34C0613D1
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 09:19:53 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id h6so12324723ilj.8
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 09:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2cDMST3loBmPEvX019dbwyMNULGzjxVtVrkk6taLCiY=;
        b=I2/AEI+J2uOrdL+VzQ+YLHqurMISMWwy90/fFJ399bYZ9AWrHzW0BJ50tC2tJoO6nJ
         tE8aEuMCgORkymYeamzS9okalmgb/rXqVhznQO9otzGxGf83vwc6wKOV+4APJqe8Tjx7
         bfBg5W3djzGz9/7U9hcjeypuQ39BD+CbVjPFPaJg5uPiPfkAQT3E9ZN1skSa6oG6m/qk
         h+YNVyepPqtiXr99rpziwhQvbOAJsxlugtuKvDzrzhMoV0YBj/smHw1CqVVy+UlzqotY
         MOyNYuAFtyn8w/uKg0/7sMfs/oEDhEi3cThm1RGWJr9SIAXru5jPaj7lMlntQFQcYrEf
         zqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2cDMST3loBmPEvX019dbwyMNULGzjxVtVrkk6taLCiY=;
        b=s2qUweb/q35RxhYGPlAeH7I008dkU/M6UlCUxuc72z0ZOX/PoXKfCT5PJzzlTE1SJm
         Sb83FEXpixWjPLNWGTtK0jAtQORTVu6/S9k2PuQjBRKAnzHH/O4GQijaZYPY8/XTw5UE
         oGaPlrWwu8jeYaf+Uws3lMyEP5UJtTFLzw2541Xvo9ya+PKb25nktM1DgdS8yu1TJSOw
         8uckyFAZCr1xnknIPKF3iUxbiq3jLWIf6n3R3V4iWlIz5q3uMyNnPYCtUdiUZ6lH7tuY
         YkUONo6j4WVcZhj95w+w4BCSxHXE8pxp6fh+fQOJ9YV7qKQDdI2CJa3wImwf7zQw7O3w
         m7Lg==
X-Gm-Message-State: AOAM532qHIwbJvxQaMGaxRJx+iB5IJFvaOSMbl4plBXSkHjgqcET0S5a
        s4yXE2/xks8aP0tnU2bsCYBhU/3nf4aTSEFCDsaY/PfbR5c=
X-Google-Smtp-Source: ABdhPJzElPUJjtskrFleP7E3SdPQRsAoyT1yuPaEsbXdGdP+ZaGwNiERgoW0cL+yKMh7Fz49XPtfiKOQapoAEGTRmVE=
X-Received: by 2002:a92:7914:: with SMTP id u20mr9039534ilc.203.1605547192238;
 Mon, 16 Nov 2020 09:19:52 -0800 (PST)
MIME-Version: 1.0
References: <20201115152752.1625224-1-pbonzini@redhat.com>
In-Reply-To: <20201115152752.1625224-1-pbonzini@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 16 Nov 2020 09:19:41 -0800
Message-ID: <CANgfPd8QjQEpSrNXxYUztOZ=+_Vp6KwbS7PyPwH-MxT906Aa8Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: mmu: fix is_tdp_mmu_check when the TDP MMU is not in use
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 15, 2020 at 7:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> In some cases where shadow paging is in use, the root page will
> be either mmu->pae_root or vcpu->arch.mmu->lm_root.  Then it will
> not have an associated struct kvm_mmu_page, because it is allocated
> with alloc_page instead of kvm_mmu_alloc_page.
>
> Just return false quickly from is_tdp_mmu_root if the TDP MMU is
> not in use, which also includes the case where shadow paging is
> enabled.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27e381c9da6c..ff28a5c6abd6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -49,7 +49,14 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  {
>         struct kvm_mmu_page *sp;
>
> +       if (!kvm->arch.tdp_mmu_enabled)
> +               return false;
> +       if (WARN_ON(!VALID_PAGE(hpa)))
> +               return false;
> +
>         sp = to_shadow_page(hpa);
> +       if (WARN_ON(!sp))
> +               return false;
>
>         return sp->tdp_mmu_page && sp->root_count;
>  }
> --
> 2.26.2
>
