Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B984B9759
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 04:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiBQD4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 22:56:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiBQD4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 22:56:22 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4D82A0D72
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:56:08 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id o9so6384579ljq.4
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGLw56RZKhiWCoemgAzhNBngh8470bgB/uGqFoyd97s=;
        b=s/jKdaCx1c5Zknn67tB5iKEw70fP3Ww/w3R3N4KF26eZY0B7drVF2pIkj2awBEIpqA
         C9bNqqw77AnCB/xdkuNXlqvxUSMhMiFrMGeTvKBovUckUgCK6ruT+QOdmycPoK4WFI8b
         aPUG/ZHmXuqnE9XL7l7gy141RxJs44/WVZQJc/tE1oE4OZpBVHGhA+Y4lNpTDeKv//m8
         Yfqdi30vW7oCaTLyN3CAY6l+54fcZ9XJn8MY5pWfAMfiz8Z7j0C2gCBreMIUJ1L2ATuX
         7cmGJ9OP4Xxx3nls8q3AeSmEAE4WYzRLehstFnQG6uGEXa/oATeyrtR+fsS0eb26LNV+
         +KrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGLw56RZKhiWCoemgAzhNBngh8470bgB/uGqFoyd97s=;
        b=k8oCe/nX0vYvxaErTseL7DS5x6PvIvRb+bM24Aoh79hOko71HhoJNXrKgc5YoDXPDL
         rue7aaNJGUt5BCRwXbRrKroxuzcnmERREsUm/kftbD4EBOn/CY7kZmvBn9GZ3xbY9l6+
         mT5QGpN7LdXB9XGtTrndlqYkPreycLDwgAShlKh4LxBFwDBmxiIcc4WH5/a0Zd+WB+ZX
         1HgY8KiV30OF6XQsS+pfcThir9rFYe+VkAMHSuTxsprvzvdwz1Wp7t2fsQsQhtGxFOT/
         3A2zQywzaK4IJLgAm41ZiGeEIaa2B1BxiOzSPYXzO9oJWSP4J4ACm02TCQ24tA+S2Y2O
         Abrg==
X-Gm-Message-State: AOAM530LJXVD6Q4+zhqXwIVDmvmwGB19j487LWj4Ym+gU84P4YV5B4U6
        70FSgUt3KOOSwR5OcbVpt3wtGGMOQTCJE5xd8z9+aA==
X-Google-Smtp-Source: ABdhPJzA7AvxxXTvomAuL2mrvPmtha3aKyUkxODv/5sSEeLdgib/0wWu0Z7GezyZLwNPCO+11W5CUPLZhD2BHe8ilDI=
X-Received: by 2002:a2e:b16e:0:b0:244:d368:57e with SMTP id
 a14-20020a2eb16e000000b00244d368057emr865694ljm.251.1645070166217; Wed, 16
 Feb 2022 19:56:06 -0800 (PST)
MIME-Version: 1.0
References: <20220217034947.180935-1-reijiw@google.com>
In-Reply-To: <20220217034947.180935-1-reijiw@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 16 Feb 2022 19:55:55 -0800
Message-ID: <CAOQ_Qsj4fHf4X1ysJ93D_f+582p66vSqEVznXyS6xtsBT_MH8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 7:50 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  If a test repeatedly
> creates and destroys a VM with vm_create_with_vcpus(), which
> (directly or indirectly) calls those two functions, the test
> might end up getting a open failure with EMFILE.
> Fix those two functions to close the file descriptor.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/lib/elf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 13e8e3dcf984..9b23537a3caa 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>                 "  hdrp->e_shentsize: %x\n"
>                 "  expected: %zx",
>                 hdrp->e_shentsize, sizeof(Elf64_Shdr));
> +       close(fd);
>  }
>
>  /* VM ELF Load
> @@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>                                 phdr.p_filesz);
>                 }
>         }
> +       close(fd);
>  }
> --
> 2.35.1.473.g83b2b277ed-goog
>
