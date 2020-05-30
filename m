Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704831E8D1D
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgE3CJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgE3CJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:09:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53C0C08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:09:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k18so1433334ion.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lqDi32x6iIYDJ5ilkXExUgzGIAaBDt88sozwNWhNmdU=;
        b=RhfP+E6xLXMrOdhs7pGiXkUtf/Q2APSBbCzR7ENp2GV2Mhp7KfwjWWG5ewzaiSbaFZ
         jcPK7ztClNkm+rHICrsvvj9amcs3/0JXNcMMIpevGuLPmv2Di6ulvNDz/pnBt69KM5vI
         xUphgMdRTNzYYV1EXCoGtRVgnW9fH/TUmLrD86+ua23q1XZ4We0m+ONYM+Vh/T2SeRhF
         D9EGIYpGRGbfjuWFdyNLwSQ0dbjsatuWyaj24ZLORdAL1os4zUHV/lHvxzmSMbghmG5X
         E8n8IGK3fWKccK8dDw5l23TdC18Ex0rVE+0/Wv4vsU6o2mdxSBPVhLrqj3G6dHqhDkDk
         QYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lqDi32x6iIYDJ5ilkXExUgzGIAaBDt88sozwNWhNmdU=;
        b=IBw5ZoHEnbwFsol5aqmsmuSGhmSgpzOE4irggpAjgfnKNknosGySY9FfcKxzlfBWHW
         FfP3ETO+vawKXtVveb1xLMX/H9IJoItDD5AQDeEPbm/m6LICA5xMCJt5Z3AqtdBV1X9U
         xbZw2AnnL5PrzACzo9PdsoIyU2v3YF6i88yA9EAsh4fDoQtho7pB0inc6hDmsuIetmg5
         1X6NKxv3o38ilqj1nxgPs7bFnk5F5b8+36oiHXqpJ0UqnWiV54z1IRB953KuOJKSnqwc
         eNZKwwfxCUH+2u6a0nE3vxoBoM/nceOBKVyzrJxFfJ/O6RJYrVEP8/LSQ5j2WnOw6KKy
         68SA==
X-Gm-Message-State: AOAM533vUWJeGbcJlY6KOVkqJoHvbpuAvKEgCJo0+Z0o3D6/tqu+NM74
        Yk++2r7HubM7UqPLY6tIn+fJDfQexfk5VhHhBJ0xkw==
X-Google-Smtp-Source: ABdhPJykXa7KkdUCgL/FbMksAxXmFiHP4XmgzhKapsn9lXwI/qbPb87Flz5ZHG3INWXxlR2pmR+O0in8fiyDOKt3Ubw=
X-Received: by 2002:a6b:e311:: with SMTP id u17mr9073494ioc.51.1590804583872;
 Fri, 29 May 2020 19:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:09:08 -0700
Message-ID: <CABayD+eR7e7H_titvO6AVMK1Dv=wGLVvaTMOkhZfpAp=YQH8Sg@mail.gmail.com>
Subject: Re: [PATCH v8 18/18] KVM: SVM: Enable SEV live migration feature
 implicitly on Incoming VM(s).
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> For source VM, live migration feature is enabled explicitly
> when the guest is booting, for the incoming VM(s) it is implied.
> This is required for handling A->B->C->... VM migrations case.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6f69c3a47583..ba7c0ebfa1f3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1592,6 +1592,13 @@ int svm_set_page_enc_bitmap(struct kvm *kvm,
>         if (ret)
>                 goto unlock;
>
> +       /*
> +        * For source VM, live migration feature is enabled
> +        * explicitly when the guest is booting, for the
> +        * incoming VM(s) it is implied.
> +        */
> +       sev_update_migration_flags(kvm, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +
>         bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
>                     (gfn_end - gfn_start));
>
> --
> 2.17.1
>

Reviewed-by: Steve Rutherford <srutherford@google.com>
