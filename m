Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5367676ACD3
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 11:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjHAJX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 05:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjHAJXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 05:23:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF288273F
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 02:21:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-522382c4840so7889523a12.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 02:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690881710; x=1691486510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gm17gZxC0/vm/Jdu3xQH50fn0wnKiSVhKMApv17FsGQ=;
        b=dq5CAvhQQ+vveH4MSteCM4KpxWqvSjfMuOapn0LnoQqDOErjMIbbWNheVH/uLc2KIf
         UdBwINkexXsFRjBN8poea9hv+4sXzWagYJkGf39toFnDnN3gA3fyjhZTQCaYda/GblQa
         pkw6dcECiAkZW/+Wy1xwLXzUC7d0jC/4tRCVUhI1fyGS501AuV0YVethzHboQgI7CbyL
         M5k4ZKy5NVWRN6++5pgESXlnIknAxtut14Hcvq275w4blo8RZfULkrUqc81+6hPmItwP
         3fxQ350OyrMQNDnLyh3ELg4ylCq9dGO2couVM6uXKHIXQCaUruaeC2pK2fs6kliqSArs
         ZedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690881710; x=1691486510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gm17gZxC0/vm/Jdu3xQH50fn0wnKiSVhKMApv17FsGQ=;
        b=SBWRcfWx6Wcqp8n74CN2YrxWVXh7z0KIgInrL8QUBSAhWisQ3FPPFKY+EfrqPLGXUM
         hGsKb3hJisQ4Gm630CBiCLugyhag/nE9j00fwZrSuxhSaWeQbJQYLcPgBbZH8GAnAG1f
         8KQhvVPAR9SDeUDznaGv3t30P5vsD9nRADZO21lJCXnddFY5psB4ZQx3ta83MFhnJhZx
         PZQHVSLT8ugTQ+sKP83TF3fwiBeiqOVHcdhql6QkR5tq0d0FPgHEdw8j0PefsrSBwGNr
         brMTmt+A75FmaJagRmK2kp1k3HGunPdfUmIKMZiQwAsSbJQqp6+mkMttL/tDdrKhBNrR
         YYbg==
X-Gm-Message-State: ABy/qLbMa2O+RElgSHqJ5QyCwHCg9g3LKKwsT09b9KzSOkxboLZm0qdC
        pjdWjKJtNoZaVrmfYIfx/QIcrA==
X-Google-Smtp-Source: APBJJlGhr0BuIoveysf7HtzpSl2Jm+kRbIcFJ2Y03OXcder2XbQzIJjvsXJoXuSOYODVVZsM7UAnIg==
X-Received: by 2002:a17:906:518a:b0:99b:fdbb:31f1 with SMTP id y10-20020a170906518a00b0099bfdbb31f1mr2052678ejk.16.1690881710061;
        Tue, 01 Aug 2023 02:21:50 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090607ca00b009931a3adf64sm7529760ejc.17.2023.08.01.02.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:21:49 -0700 (PDT)
Date:   Tue, 1 Aug 2023 11:21:48 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4.1 1/3] KVM: selftests: Add arch ucall.h and inline
 simple arch hooks
Message-ID: <20230801-3ab43c432cbaafcadbffb092@orel>
References: <20230731203026.1192091-1-seanjc@google.com>
 <20230731203026.1192091-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731203026.1192091-2-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 01:30:24PM -0700, Sean Christopherson wrote:
> Add an architecture specific ucall.h and inline the simple arch hooks,
> e.g. the init hook for everything except ARM, and the actual "do ucall"
> hook for everything except x86 (which should be simple, but temporarily
> isn't due to carrying a workaround).
> 
> Having a per-arch ucall header will allow adding a #define for the
> expected KVM exit reason for a ucall that is colocated (for everything
> except x86) with the ucall itself.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/aarch64/ucall.h      | 18 ++++++++++++++++++
>  .../selftests/kvm/include/riscv/ucall.h        | 18 ++++++++++++++++++
>  .../selftests/kvm/include/s390x/ucall.h        | 17 +++++++++++++++++
>  .../selftests/kvm/include/ucall_common.h       |  1 +
>  .../selftests/kvm/include/x86_64/ucall.h       | 11 +++++++++++
>  .../testing/selftests/kvm/lib/aarch64/ucall.c  | 11 +----------
>  tools/testing/selftests/kvm/lib/riscv/ucall.c  | 11 -----------
>  tools/testing/selftests/kvm/lib/s390x/ucall.c  | 10 ----------
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c |  4 ----
>  9 files changed, 66 insertions(+), 35 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
