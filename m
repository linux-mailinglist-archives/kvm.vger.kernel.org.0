Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9971643A52A
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 22:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhJYU6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 16:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhJYU6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 16:58:33 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CD6C061767
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:56:10 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so16735869otk.3
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lr8LZgkPwRWJNrzlR7/1JMJvMp3PtBdOlimdKnBnxLk=;
        b=is4zuvBzpafyka1/8lyKw28YpFS3Noe7Q2cQ69D4IStId6bDNCGsjDoUK/gfaUVtGk
         WIlB/GxcYkckRxH4aN4yejJGpfZowglMmqJ0nZeqYysDPIml9ILTGB7SjxP/wOmuOQHz
         G/rjSagiJJ4AbhrsLit+wQqfDeyNf9EQsJJDbOYvh8R2g5DrApaVyOIl6lhdJ0TXTFyg
         fnueEiOHifqeWRMoXzC0dRFJeZLbQiZpusr4rWn2zyyjND+N7uFxr3TlsZEC1REr02Y+
         nWZJ6yRWm6qcS/6i7Mx3qNz55+9nHlOFU/vrTsstX0CZjCdA1TZClinlF9kBalzzHF1y
         dclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lr8LZgkPwRWJNrzlR7/1JMJvMp3PtBdOlimdKnBnxLk=;
        b=ftWbyaMT0wHXQNeYSQbk7m9IiA1tFEpnhslFXuWPGizgDhOPIwQiAqxqg9W5n7djfu
         GUQkFWUwwlamMeTnfyH+Qe3QYFQrkL7B1pVb3dJ/lvbeP00qjNvocmV0D6C3DiqQ7rHA
         TOcOPoxwusdnL/zowx7NUEh+/PfesAj/EFIph7kl0xmounA7wzP74sRkhzh5N6Ll+NGX
         8z9r2uvbG5+MmKLACHQpwA7tl6177Lmrbs20CZ117qgU8DVZkCkhR5IQ03Wjt8/NhnfF
         hzzyIvy1uACovBJCD5W4dVbaInE6ke/d+h0Oqb8Z/J7D+PaFQKQ3iNalS7vbSy6iH17/
         8Pfg==
X-Gm-Message-State: AOAM530Jt2d2v+DlXmMBcGV+cQlQJBbLC7YH3ywBC5VPJ5TTZoq0YZxN
        F4Ox/4BgLWmp3xfm0bsYMV8ibOPRsGZn9MqJ0ZE2HA==
X-Google-Smtp-Source: ABdhPJynTro4WvcY+FDf3A05tFJVzOfKdP4WXpbnB4IO1APQD0dChMa7gB395u0WNW44VnkRgqyEDv/ZKATeAnzup+s=
X-Received: by 2002:a05:6830:2492:: with SMTP id u18mr16119610ots.29.1635195369622;
 Mon, 25 Oct 2021 13:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211025162517.2152628-1-pbonzini@redhat.com>
In-Reply-To: <20211025162517.2152628-1-pbonzini@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 25 Oct 2021 13:55:58 -0700
Message-ID: <CAA03e5E+tP30B1DOgwZQGRTMmXXTwKUFHJ6HNFk-jMRgxKMF+A@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV-ES: fix another issue with string I/O VMGEXITs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 9:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> If the guest requests string I/O from the hypervisor via VMGEXIT,
> SW_EXITINFO2 will contain the REP count.  However, sev_es_string_io
> was incorrectly treating it as the size of the GHCB buffer in
> bytes.
>
> This fixes the "outsw" test in the experimental SEV tests of
> kvm-unit-tests.
>
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Reported-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e672493b5d8d..12d29d669cbc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2579,11 +2579,16 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>  {
> -       if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
> +       u32 bytes;
> +
> +       if (unlikely(check_mul_overflow(svm->vmcb->control.exit_info_2, size, &bytes)))
> +               return -EINVAL;

Maybe this is only an issue on our internal setup, but when I tested
this I found that `check_mul_overflow()` is very particular that all
three args having the same type. Therefore, to get it to compile, I
changed all of the arguments to match the type of `exit_info_2`, like
so:

u64 bytes;

if (unlikely(check_mul_overflow(svm->vmcb->control.exit_info_2,
(u64)size, &bytes)))

> +
> +       if (!setup_vmgexit_scratch(svm, in, bytes))
>                 return -EINVAL;
>
> -       return kvm_sev_es_string_io(&svm->vcpu, size, port,
> -                                   svm->ghcb_sa, svm->ghcb_sa_len / size, in);
> +       return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->ghcb_sa,
> +                                   svm->vmcb->control.exit_info_2, in);
>  }
>
>  void sev_es_init_vmcb(struct vcpu_svm *svm)
> --
> 2.27.0
>

I've tested that this works. To test it, I (temporarily) modified
`setup_vmgexit_scratch()` to always treat the scratch area as if it
resides outside of the GHCB page (i.e., always go down the `else` code
path). Doing this, I was able to see the stringio test case fail
before this patch and pass with it.

Reviewed-by: Marc Orr <marcorr@google.com>
Tested-by: Marc Orr <marcorr@google.com>
