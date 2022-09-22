Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B6F5E6373
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiIVNSZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 22 Sep 2022 09:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiIVNSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 09:18:11 -0400
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3125DECCE2;
        Thu, 22 Sep 2022 06:18:10 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id v192so4909025vkv.7;
        Thu, 22 Sep 2022 06:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FmC3Wnd/dYfP2uqwVfxKzutzBThKJES4nPc9HEeo7QQ=;
        b=J06j6o0MXCQP79avP20hWcMOmr+9RUIwA65iEYK1TDKGJ5Pkt4ivky+PNfPf0ptbKQ
         e9cOZbzfe2EKgMQrxeiuHP1iwqX2jQn7OCZxn9ox7kLXzFmDCitxzBY1yW7ClW5f3InW
         D7I/8VdZJ9SaWeWA0iRbx2u2P5uE9C9bQHJMotaeZTs22t54R28NWWNt5nJ+EkX4DeYc
         f7sMTqlMbBO70GYj88PVVZpbiwv5xTzzIDp/45cwMwW03LyEVq/2s6BIrOsxRx1eZNu+
         WYAFtgy6cnM0Jaf72W4XSS5Nuz1DbZlN/Ngb2ua9LrAnt5/vhu8XGKUWsWUgqzN3NjXk
         jVJQ==
X-Gm-Message-State: ACrzQf18+i3lKb/ifowgiSu+9kuzaWXCFq1v4R64n0Azlf7zVcTsFLQg
        ftqib/F5TPy1JE/jhOLtMVaH+zgZ2HAIER0/2Ds=
X-Google-Smtp-Source: AMsMyM5hAS5sGeCyGhDs3JB8ybhSoe0SBFugJqR9UWsYlOLvGt3tSKkrbx2I2RYfB9/ZOUlHboLppHif1VOrjItnvws=
X-Received: by 2002:a05:6122:10dc:b0:3a3:4904:2941 with SMTP id
 l28-20020a05612210dc00b003a349042941mr1265866vko.24.1663852689165; Thu, 22
 Sep 2022 06:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com> <20220921003201.1441511-12-seanjc@google.com>
In-Reply-To: <20220921003201.1441511-12-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Thu, 22 Sep 2022 15:17:56 +0200
Message-ID: <CAAdtpL4yFdh3V0Be05OKxUFBTSgFs6oTy9U5FjSRGwOhi=tDMQ@mail.gmail.com>
Subject: Re: [PATCH v4 11/12] KVM: mips, x86: do not rely on KVM_REQ_UNHALT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 2:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> KVM_REQ_UNHALT is a weird request that simply reports the value of
> kvm_arch_vcpu_runnable() on exit from kvm_vcpu_halt().  Only
> MIPS and x86 are looking at it, the others just clear it.  Check
> the state of the vCPU directly so that the request is handled
> as a nop on all architectures.
>
> No functional change intended, except for corner cases where an
> event arrive immediately after a signal become pending or after
> another similar host-side event.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/mips/kvm/emulate.c | 7 +++----
>  arch/x86/kvm/x86.c      | 9 ++++++++-
>  2 files changed, 11 insertions(+), 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
