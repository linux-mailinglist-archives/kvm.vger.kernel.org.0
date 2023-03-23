Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32AF6C7350
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjCWWu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCWWuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:50:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689D44B8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:50:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso187082ybi.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=74Bca3+J0Cb4vQ6fen5CaUBDEj5b5vV7i4MEot6v9Ds=;
        b=YH7MTbm9mvyot6ZU2+XkcDSlj10Nsc7kiE+CaqrEGoRHP+5Wp1aXsacMGgUuC+9V/C
         WVpEYg6CLbPyr+dvSfXfFo9SzojYnPgv2zPNeoMiLzTDGGi4AOX40qM/0GVJy3TDdzri
         /A1NFKBZszV6ih13Bp4d8BSvUXewKzg6VmXODUInfnB0TEN6hYV85WwJX+9wI/qq4era
         0a3SNXpZRFkv2GXJSpRTaAfqAeuXeGfauq4Kc6Df39oJSG3g/+pwfT0MoMzqhhdMMan2
         GnM5KMzJNUIZtfs56MGTlzzcI0yeX13rZ0t+OMLFxMcw4SONq0Zz6RyW2BIHRmVknLv5
         Kafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=74Bca3+J0Cb4vQ6fen5CaUBDEj5b5vV7i4MEot6v9Ds=;
        b=E59UyTUGhZUaGPUaFXtUAcPcS9n6XC757db9nlVhJuJ3clICqU14RAiU+nR4aWL1vj
         LVZLdPJGnbXV1WCeabXZv8pqukSCcsabIm0JpTCeHbltzvw6/otphl9zdLaCm0xDp2Kk
         q85hCd80P9PhZeHSQpJm8cGNr3D4eahiYGSALKeJhz0b7rXHftIezL8lZB5RJHmF/uNE
         V/Nr0hcK/bcSHuMvIW5mUZj2GWVq54u5eCoO7Jpuw8LAVUg56+OftgEg+4IlvDjgyDbG
         KBh/Vdtxmoe3PKti33aBkF7bQUpAIwKTX1/PjnxctkEySSV4/QUd7p57c4Sw2hmdFMb5
         tSdQ==
X-Gm-Message-State: AAQBX9f+i+1EWKGnXqP/MC4y6RJhEjxOdbsz+Doo8Iy9CpHZHqNQGF1Q
        glD3CpnuqbnPRIi/kFR1JyFvU4HEY3w=
X-Google-Smtp-Source: AKy350ZsIJuSNQoMPlJ5+eoOr2kgPIQRx9B3zNmq76T9BVO+0ZLsWEOoUS4XgvR/h7pV3ogslqbmAO1mcEk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4426:0:b0:544:5aa0:e212 with SMTP id
 r38-20020a814426000000b005445aa0e212mr87638ywa.6.1679611851706; Thu, 23 Mar
 2023 15:50:51 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:50:28 -0700
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167934082066.1939558.14724526021018063522.b4-ty@google.com>
Subject: Re: [PATCH v2 0/7] KVM: Add a common API for range-based TLB invalidation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Jan 2023 10:40:18 -0800, David Matlack wrote:
> This series introduces a common API for performing range-based TLB
> invalidation. This is then used to supplant
> kvm_arch_flush_remote_tlbs_memslot() and pave the way for two other
> patch series:
> 
> 1. https://lore.kernel.org/kvm/20230109215347.3119271-1-rananta@google.com/
> 
> [...]

Applied the x86 specific cleanups to kvm-x86 mmu.  They're good changes on their
own, I'm quite confident that this series a whole won't be going into 6.4, and I
suspect/hope that getting these into 6.4 will make David's life easier (there are
more cleanups in the related x86 code that I want to get into 6.4).  David, if
I'm wrong, you'll have plenty of time to think of an appropriate punishment ;-)

[3/7] KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}() together
      https://github.com/kvm-x86/linux/commit/28e4b4597d65
[4/7] KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
      https://github.com/kvm-x86/linux/commit/8c63e8c21765
[5/7] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
      https://github.com/kvm-x86/linux/commit/9d4655da1a4c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
