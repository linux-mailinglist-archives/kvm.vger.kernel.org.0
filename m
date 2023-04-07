Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D206DB727
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDGXa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDGXar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:30:47 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7845FE062
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:30:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t9-20020a17090a3e4900b00246669ab458so202999pjm.6
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUj6O6CB3iiBV1uvi/t8sklxmHPNBdsFm6z4ma14Yo=;
        b=g5wwO/E/km9HV/J4Uo40AnPSisucwkmavL4S1Pf4Fx0jHCk1WbKxYKFrTEZxFx6XHp
         2exvb76Kc6SS9Ds8LXjXF0I1WFqClQxCNCC6sf4daSWTnp+YpnSO2121ov5N7kOpcqib
         YCLGPirwnvPcpp/S3fo5s+vT7QnEVjcGGwmgFHFlmScqbAaLkGHrQ6ia2vS3XVAARuDd
         sMCqZDZFuZewtQIjpJWpW7S/bUTL7IiTKNWpDkyOWB4W2AE70oenj4IH+Pui3ZI77/9t
         egivxNBn8aOes50PuEtPh0HjwIwXrfmgH5cXyJJ/cO29tWSweCMf9GcheLm+s0IsbY3F
         CJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUj6O6CB3iiBV1uvi/t8sklxmHPNBdsFm6z4ma14Yo=;
        b=AGN1hEcCvvLneT1C2ijPksAkVb3NgSFVT9PckMGtve+ICflhkrDNjAQNrK2nQ/ifgf
         9tXPbWyAD961Z6/6AUcVU43LKMnRRfWdvOJIfLVKR43zEx/i1UuCbw7aDe2/Idy9aN5M
         7VMRGiADijf7uZO4FtZxUQlcslSKGNFspkHn7xrbGdw9u/izJsi72OYly7j9J09PG4a+
         elvSBDekQEz1d9ayIRnq4BE37qxlOpOnrUBDw6oARaxiptpTIViiY5GzUMY3ESpiviRa
         xeloBICaMVPkedoJ+rE8WB24OZasJpBqwlKY4Wm0tM1terxy2z7uVC3ZO1XUv4Afpjn7
         BtRg==
X-Gm-Message-State: AAQBX9d9lBZSoSLNZMh3MDvG4zCoiMTPQF/CQjNgOnNQzEdYZBsOEWJc
        TNYjX/v7DbYFU2vMwS7Y3AC6EfyiFJY=
X-Google-Smtp-Source: AKy350YxihhHFMNV20FoO+AQH03z9Y8GXCy5PhVvBVZ1Rdqa7VXUgXNseSxSRo6RlhR0sxbeKagnCEmAUJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cc01:b0:244:9909:6e60 with SMTP id
 b1-20020a17090acc0100b0024499096e60mr959943pju.3.1680910245959; Fri, 07 Apr
 2023 16:30:45 -0700 (PDT)
Date:   Fri, 7 Apr 2023 16:30:44 -0700
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
Message-ID: <ZDCnpAd0fh2cKcpS@google.com>
Subject: Re: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom
 stat names
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?=" <philmd@linaro.org>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023, David Matlack wrote:
> David Matlack (4):
>   KVM: Refactor stats descriptor generation macros
>   KVM: Refactor designated initializer macros for struct _kvm_stats_desc
>   KVM: Allow custom names for KVM_STAT()
>   KVM: x86: Drop union for pages_{4k,2m,1g} stats
> 
>  arch/arm64/kvm/guest.c          |  14 +--
>  arch/mips/kvm/mips.c            |  54 ++++-----
>  arch/powerpc/kvm/book3s.c       |  62 +++++-----
>  arch/powerpc/kvm/booke.c        |  48 ++++----
>  arch/riscv/kvm/vcpu.c           |  16 +--
>  arch/s390/kvm/kvm-s390.c        | 198 ++++++++++++++++----------------
>  arch/x86/include/asm/kvm_host.h |   9 +-
>  arch/x86/kvm/x86.c              |  94 +++++++--------
>  include/linux/kvm_host.h        | 179 +++++++++++------------------
>  9 files changed, 314 insertions(+), 360 deletions(-)

For the series,

Reviewed-by: Sean Christopherson <seanjc@google.com>
