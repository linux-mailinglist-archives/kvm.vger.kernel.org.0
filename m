Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4755C646647
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 02:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiLHBLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 20:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHBLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 20:11:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F117B8B1AA
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 17:11:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so3106390pjp.1
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 17:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PuptZMN7vunrA9teINtxZ2esf/Hdp6MybgUyi21FWx4=;
        b=jY64ETL2kkECdTEQMg8rucstga2N0o3I3CD1CJFV/JeOWXAaYuTbpQQqzU1sRTkcES
         /CHFF2U33jfhZV1WIf9wl22SwVCyxsEMERxBvuubV/7GvqGNT+wfsP1k8zdVxBhJfd8K
         FpE5jIAoNh5Yi69Y3gb0t1HGyW1L/04baWYyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuptZMN7vunrA9teINtxZ2esf/Hdp6MybgUyi21FWx4=;
        b=f6tGtQJf4bnwUtQK++zPMvswjaIbPyYa4VykuB0Nz609EJQ7ZLe+CU2h7BQjwlfQYs
         85qZczpJ16dSKuH+iqUMvfDIVk7D+PmiN/U+u7y4Iuqno9zQVXgisGcYcFQhk1nr5RwL
         UAnOVenw6tiKOqJdDtobSDHWpjAorKPMni9IvVQMccxYxLp7Kba0Uas9zX0MkfFRChaA
         mwC4RBOIxjV6oI3rMUnUapqnqLNIpcQ0ugQ9cDU7OaxbufLvCeNpg+/KqZuocSAR2OWD
         PkqYnZQnnTyxr1sFmw8FtLU8guEgXuYD1P6jBm117xEtCuZvEI5UIo5vUE0d/7RnKvIn
         G7jA==
X-Gm-Message-State: ANoB5pm+q+WUox4YxITBOF+0BjSRAHOIXan9mOjFAj1J9+rEb8d6ut6W
        iPOSDXJJyqverTRXgCny0fNFHIvBuB6duSUwadGl
X-Google-Smtp-Source: AA0mqf6CSFfmG2Raqa4l9T5ncQkVtnTWU6KsrQOuHWlK7TspyF+qEuTbbJX5K8jKmy9tOHCbtPknVD0wG9lIZBJfsIs=
X-Received: by 2002:a17:90a:7d0f:b0:218:d50e:5af8 with SMTP id
 g15-20020a17090a7d0f00b00218d50e5af8mr77754002pjl.26.1670461881483; Wed, 07
 Dec 2022 17:11:21 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-9-atishp@rivosinc.com>
 <Y4oxNbQwOldICdnw@google.com> <CAOnJCU+Eo7do0Rd+S4RBOMYpY+sG8ODqpkqA-Cii92bO-cG5+Q@mail.gmail.com>
 <Y5C/4s7OannaS8+H@google.com>
In-Reply-To: <Y5C/4s7OannaS8+H@google.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 7 Dec 2022 17:11:09 -0800
Message-ID: <CAOnJCULpCy6Mt6EdJBHvH9Uei8OUiOx_dE52At-ZedCgpi283Q@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Implement perf support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 7, 2022 at 8:31 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 07, 2022, Atish Patra wrote:
> > On Fri, Dec 2, 2022 at 9:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Jul 18, 2022, Atish Patra wrote:
> > > > RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> > > > the virtualization enviornment as well. KVM implementation
> > > > relies on SBI PMU extension for most of the part while traps
> > > > & emulates the CSRs read for counter access.
> > >
> > > For the benefit of non-RISCV people, the changelog (and documentation?) should
> > > explain why RISC-V doesn't need to tap into kvm_register_perf_callbacks().
> >
> > As per my understanding, kvm_register_perf_callbacks is only useful
> > during event sampling for guests. Please let me know if I missed
> > something.
> > This series doesn't support sampling and guest counter overflow interrupt yet.
> > That's why kvm_register_perf_callbacks support is missing.
>
> Ah, I missed that connection in the cover letter.
>
> In the future, if a patch adds partial support for a thing/feature, it's very
> helpful to call that out in the lack shortlog and changelog, even for RFCs.  E.g.
> adding a single word in the shortlog and sentence or two in the changelog doesn't
> take much time on your end, and helps avoid cases like this where drive-by reviewers
> like me from cause a fuss about non-issues.
>

Absolutely. I will update the commit text in v2 accordingly.

>  RISC-V: KVM: Implement partial perf support
>
>  ...
>
>  Counter overflow and interrupts are not supported as the relevant
>  architectural specifications are still under discussion.
>
> Thanks!



--
Regards,
Atish
