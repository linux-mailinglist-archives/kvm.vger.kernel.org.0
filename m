Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0FD40BAEA
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhINWF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbhINWF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:05:26 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BBAC061574
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:04:08 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id p15so1449574ljn.3
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4r/QuEek1IJxOTV0kb5k4wwB4qARh5+mDnfq9y231lI=;
        b=JkTwfbecRPqhMK7XoQ8d92T7iOKua5f+IVTLSDSDJB9qWyiIkM0SaCWyK06t6HTfzz
         0i3FD4mp/tlKdDdsrBvEqcHZOynglvHdU/AL1a1ZT9cikXbKyCr702n3S+K1FmC/MORo
         UsU0+uneGV8wluKv+9naoH8tUlhNqaaE+lUcuMzc3Bj68pKI7UL3So27UkZRr7ASSPyz
         MkcB63hMgusMPBIXy0v6/ke/SIcj9e/1nhA1gLB/jI2/DGVx3OtlNc3vSkYLgZZX3Uo3
         hBXV6LMnLsIxD2hLgTG0MrAWWizIDYq7aGRuvLWeQlBHWFdOZFqXI0uoKT8+JISo/g2V
         JKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4r/QuEek1IJxOTV0kb5k4wwB4qARh5+mDnfq9y231lI=;
        b=U2z4UcjmXJfHdAhOCb7gCSJusN1TBtA55vK1kCikf8QnjfXFBaJZL0QXeHBE7Kb9Lz
         sanN+BAwLUalQ5mqbixhp/4g/sJnhXPqV/HfO5MX4/bRDPIDqjcWZXpFiOBG+UoZvVx2
         sY58gl7g5RnGYRAnj3vOr9LyyGoDOpCLM5WHSemMVdTjEVXCZ9rDiIhAmgWgjEa6/bl8
         xQqou+rg4E+krA2ikQweZuX2TQmyB2UwCfJ1hgL+dkaAQp4Cs0+vQOYdel19MjZ8Kb45
         yRegdeu48+VJhZaqbyU60eMUMH6AuRlYCKZ+PwdW1By52RJdvrMfDwgs8O2eqrwBOrn5
         mQ/A==
X-Gm-Message-State: AOAM532L5ye81Zru3qE3unUZLDfntjPX9zlCavo/QxRvdMlLr5qnggSv
        t18zBRt+GRkJNNKgI9tasD6gnJK7LS0azQoqyfFb8A==
X-Google-Smtp-Source: ABdhPJyRlHmWOTMX6JO0I0LrUpZjPoiigiqAXnBic0Wf6wKgYPtz+W4ySCH25h/SuTM2qi/MjIA2o7jci+EHEpqI5VI=
X-Received: by 2002:a2e:86d5:: with SMTP id n21mr16992991ljj.278.1631657046349;
 Tue, 14 Sep 2021 15:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210914210951.2994260-1-seanjc@google.com> <20210914210951.2994260-2-seanjc@google.com>
In-Reply-To: <20210914210951.2994260-2-seanjc@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Sep 2021 16:03:54 -0600
Message-ID: <CAMkAt6rnUUS9t1Z73dqZ0_3iUmyRxz5hJmZ+A3vQ34t3N=JAFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 3:09 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Require the target guest page to be writable when pinning memory for
> RECEIVE_UPDATE_DATA.  Per the SEV API, the PSP writes to guest memory:
>
>   The result is then encrypted with GCTX.VEK and written to the memory
>   pointed to by GUEST_PADDR field.
>
> Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Peter Gonda <pgonda@google.com>

> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..95228ba3cd8f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1464,7 +1464,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>         /* Pin guest memory */
>         guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> -                                   PAGE_SIZE, &n, 0);
> +                                   PAGE_SIZE, &n, 1);
>         if (IS_ERR(guest_page)) {
>                 ret = PTR_ERR(guest_page);
>                 goto e_free_trans;

Not sure how common this is but adding a comment like this could help
with readability:
+                                   PAGE_SIZE, &n, /* write= */ 1);


> --
> 2.33.0.309.g3052b89438-goog
>
