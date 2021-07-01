Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7A13B9821
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhGAV1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 17:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhGAV1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 17:27:34 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30A1C061765
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 14:25:03 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id w11so10518171ljh.0
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 14:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uPZE1BnafEGGofshB/oCVcT1sDDIq1gVM120dwnS8WQ=;
        b=qrtMwvxzuwsefQ6MJGziiD+Zj5B/8NlZ9l3QFDoj3ttI3TNctdjKL/H768lEDo7/Bn
         /3S6E3Ik34hDvHag9Jvgh6/jZKUdvSGeWVOwzEO+uXMzcleV2c34BBqNO1360HuEtzdb
         i9u7JnTIujV13k5YXPB9Rv/7PvdXAHIKNAinJt+jZzAaGMWh/sckm2pLHbJqGrj29NSY
         eJQmEiA4i+ipiUKAquwa8mEeOEy20UojSuA9pXleAP0XbvWIqE/i7bnFzHX/nhA0zng3
         h4Ii8qO6AMa5okkG2Iq01cFfhHGIfwgw+mkVDuwm8QQWYRyn4vUeH30TybayS3uX9JBQ
         qcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uPZE1BnafEGGofshB/oCVcT1sDDIq1gVM120dwnS8WQ=;
        b=LyyhXSX0Fg+HldLRlOrv/SsOZHYJXxPTvSdFGM+hQLoEVd+9xGJ8GfF3h5w92F3xBy
         H2Mc4h5ERXi5grofiQ+OsGzenXcdUKrINzyqDsPRN83tSTvlbFPMU3GoX/sS3cnRVGBZ
         Jazm8DOKPNdirGtWtNevgvsH/IaH8jASnk56tsXzni9HUQlPHjWY7oaMQxZf/Fcwb0Ox
         oOwEWt70Nj0EQDVtbBL1l31vKIOLVIvuS4pXOOEQAUeVEmX5IG+XjqsD2GtapGWEuPNu
         9wfrNuh9Kz78tRQHJTYnuuqM/SS2g54h37STpM181WiQvH5dLmqYqo2fiq6jlfQ9uJ9Z
         BGiQ==
X-Gm-Message-State: AOAM5316HDqO9GeMDx0hwC9YLIyv9g9XJThbPN+tK8yPRt39PA6QUxIp
        ImRU6n748vicRbRG3+EMXYX/BoOM9Fp6gu3xDQlUDg==
X-Google-Smtp-Source: ABdhPJyczRahnz2Bvg+RDafJ0A1MHyUUYYJlaOn5sOi6JrcXxe2uH2eeAHM3Uf0K6fIBEA9Mczbi05sPz2qTgefQYUU=
X-Received: by 2002:a2e:9853:: with SMTP id e19mr1224260ljj.256.1625174701631;
 Thu, 01 Jul 2021 14:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210701195500.27097-1-paskripkin@gmail.com>
In-Reply-To: <20210701195500.27097-1-paskripkin@gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 1 Jul 2021 16:24:50 -0500
Message-ID: <CAAdAUtiAA+H178X7pU1KLzKwmPZ1jTOUpmsP0TvFzqVH5gJAdg@mail.gmail.com>
Subject: Re: [PATCH next] kvm: debugfs: fix memory leak in kvm_create_vm_debugfs
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 1, 2021 at 2:55 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> In commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> loop for filling debugfs_stat_data was copy-pasted 2 times, but
> in the second loop pointers are saved over pointers allocated
> in the first loop. It causes memory leak. Fix it.
>
> Fixes: bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7d95126cda9e..986959833d70 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -935,7 +935,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>                 stat_data->kvm = kvm;
>                 stat_data->desc = pdesc;
>                 stat_data->kind = KVM_STAT_VCPU;
> -               kvm->debugfs_stat_data[i] = stat_data;
> +               kvm->debugfs_stat_data[i + kvm_vm_stats_header.num_desc] = stat_data;
Pavel, thanks for fixing this.

Reviewed-by: Jing Zhang <jingzhangos@google.com>
>                 debugfs_create_file(pdesc->name, kvm_stats_debugfs_mode(pdesc),
>                                     kvm->debugfs_dentry, stat_data,
>                                     &stat_fops_per_vm);
> --
> 2.32.0
>
