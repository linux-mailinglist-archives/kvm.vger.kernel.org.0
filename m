Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DDC758B39
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 04:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjGSCOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 22:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjGSCOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 22:14:36 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC771FC3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 19:14:28 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5700b15c12fso65559687b3.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 19:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1689732867; x=1692324867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F9eL+vRLh2IMmmWxtSCYk4DtifazKKWTBnb901S3j94=;
        b=E0qagBYe20SR0SALzjMEgzAAwWZNBuyNfIuFOB5oHd7/unduwTPDowOXpp+9jaIhsk
         yWWws98rOg0AI15RrkDBVlvYl+q+EWOCtTO4U5wc9SPXFO1NrHsi1lJhfbpMLnVvCYSu
         oaogCqHUw7nH2YLUiLkB73e/lfZwIXPUSJs7W+SWDWF5uZgcQ+XMineDaONtZ9cLz3x6
         qFIwAxqXBML/rim1qQxNWhMp2wpGTXV7YkFVf+0lJR5qbVIjM/GxPwfH1ltdJggyZlow
         mW571RQ0nZa7z2F/9ExiiTsk1vBPkwJLlWHYvCs5k2sRgQGq40SZGqPgHZcShBBgy7hi
         TVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689732867; x=1692324867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F9eL+vRLh2IMmmWxtSCYk4DtifazKKWTBnb901S3j94=;
        b=M03GcsJ/mGkLUDxOkQB8NHa8R4O91t6qDV6s1SV3Ej7eNh4UdGRu1sQaLIGnVHsgKG
         +Gy7B/9ygnn5gOTxpNp5IAOYb1z44o+8+OiWzjtURqjkw7GAUyoqvzcNVEPn8X29OO48
         QARmNQe2ZxRnXRpQbelUTZ4SeFq+6BF4iB2Bo+BzDAW7k/SmHfmquZklbiuUombXso2m
         xuiqz3wQxqv6evLvY/t0dQxquIWQmx7NmIXWcmQx1umVR3BQuVWbzl9RGRVtqzO612ua
         QGE/nyC+I2KkJTTwDncr7MANNsnj74XnEEnagp9Sf5jORQMN0eh9Ki3S5pJOpRKWf8rm
         OiKA==
X-Gm-Message-State: ABy/qLavyfWltHe2MEMehoMXk7zusbrzmeov1dD4cCPj0ABclcbduCEd
        E3ut4GhLgLwdPyNoyhXPZXlpAcyPoxuKCjPjtxfB
X-Google-Smtp-Source: APBJJlE6HrXGv8FiBWPESZXA4zS7WdaVXKrmS0y2QVal6eHwFQK9KIQhCzYsyt32AHunSvFteTt6TeRzQof/apGmOO8=
X-Received: by 2002:a0d:e843:0:b0:56d:2ad0:cb45 with SMTP id
 r64-20020a0de843000000b0056d2ad0cb45mr17052519ywe.1.1689732867591; Tue, 18
 Jul 2023 19:14:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-12-seanjc@google.com>
In-Reply-To: <20230718234512.1690985-12-seanjc@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 18 Jul 2023 22:14:16 -0400
Message-ID: <CAHC9VhSUhthtS9W1QkqFd8Y+VHsGVXt1vZenYpqRtr7Gw51B3A@mail.gmail.com>
Subject: Re: [RFC PATCH v11 11/29] security: Export security_inode_init_security_anon()
 for use by KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 7:48=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  security/security.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/security/security.c b/security/security.c
> index b720424ca37d..7fc78f0f3622 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1654,6 +1654,7 @@ int security_inode_init_security_anon(struct inode =
*inode,
>         return call_int_hook(inode_init_security_anon, 0, inode, name,
>                              context_inode);
>  }
> +EXPORT_SYMBOL_GPL(security_inode_init_security_anon);
>
>  #ifdef CONFIG_SECURITY_PATH
>  /**
> --
> 2.41.0.255.g8b1d071c50-goog

--
paul-moore.com
