Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4A5A3103
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344820AbiHZVcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343858AbiHZVcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:32:47 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1980F91D05
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:32:44 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bq23so3573857lfb.7
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fGX1OPYHOyAdnf6z71dmW2DwOr7H4Y5wRyKl79aJ7R0=;
        b=ZC1efQqpG/Yl12c9Sf0lbSneIvuydmkz6lD+4KwRibO24kQUatXopq6xrBTE+YeeyR
         q7A0vfCIleUquEfbTOnSyFHAwePTyBPeqv2/ma8GgFea/Ixx3aLVwoY9Fes1qIrjLDr1
         Nd6jCOOn88THmF7GLR+a8EWPAuq3Zz3zn1PzhUigNoDANZ/JbADf29mivcvkYSmlIyPY
         Mljmir8oMpLOPvbS8ez1m+7uKdlmCp6LGxmF12PPwjzauVS8cA/Z9xWvqjCO8f0T0wuz
         kyy+4B1CYpyEZxjTV7uWkKZFEeBcp8NRBYb+60p59rhCoYViV4f4TSJ6kjl/TbfqRvpL
         g1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fGX1OPYHOyAdnf6z71dmW2DwOr7H4Y5wRyKl79aJ7R0=;
        b=qwxUdm/SJEl7jrCkxXO+HTfR3R4xDMQ06JASAZLVrw2wh8/YuBCYs31HcOGfbM75ze
         BJkSWAMPDMqAJnfHZOkQ7DnCAruj2va+unCAWyMDOg63vzKJmWF+7/oyjrZ57I20G1OW
         e+qtloVbd+etrCCzjfg2p/qWUu9sp+a+Z088Bouz6tLh2Cz+92An0lT3w3R/LJwg1sS7
         q//B8USgtWf2fCzSi5YI7EB7FGO8dIkhBR51BPj/5sZmzpNcoKEmtcFP1DLp6VFmLu2T
         M6hBIFwZ7unYWdnKe3kiMzRblrxKp/l7jJTPrEqobemJlkrL5TGLARNUpql8ZVrHx3Gd
         zPbQ==
X-Gm-Message-State: ACgBeo3Q9IerdmLID4acr3dDY/T4qbOYFKLqrheOEY/ZMjiwvtP7a8NR
        HJad7YTx8NKKOlWVE0nHWxXJVkOf1CDBVqqvhDkM9w==
X-Google-Smtp-Source: AA6agR4p8yZHknOzoft/51CAneJ1hrsnJGIMJ3qvD2H+dBtk7IsckDNc/Agfws5rxxUjM+VYCG98DW+qqx4b3NOZuyc=
X-Received: by 2002:ac2:4e15:0:b0:48b:3ad2:42c8 with SMTP id
 e21-20020ac24e15000000b0048b3ad242c8mr3415436lfr.391.1661549562159; Fri, 26
 Aug 2022 14:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 26 Aug 2022 15:32:30 -0600
Message-ID: <CAMkAt6ryLh-gQYvmUYfxS3+CRwCLfK3Fby1W5NxxFLSK7M_v0w@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: selftests: Implement ucall "pool" (for SEV)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm list <kvm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 5:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Non-KVM folks, y'all got pulled in because of the atomic_test_and_set_bit()
> patch.
>
> Rework the ucall infrastructure to use a pool of ucall structs to pass
> memory instead of using the guest's stack.  For confidential VMs with
> encrypted memory, e.g. SEV, the guest's stack "needs" to be private memory
> and so can't be used to communicate with the host.
>
> Convert all implementations to the pool as all of the complexity is hidden
> in common code, and supporting multiple interfaces adds its own kind of
> complexity.
>
> Tested on x86 and ARM, compile tested on s390 and RISC-V.
>

Thanks for the help on the ucall-pool Sean!

I rebased the SEV selftests on these and everything works as before

TESTED-BY: Peter Gonda <pgonda@google.com>
