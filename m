Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4BB76DAE3
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjHBWoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjHBWog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:44:36 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02D2211C
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:44:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb98659f3cso2907095ad.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691016274; x=1691621074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMuR5EiinHFoNrMaaPJwbYiKuZcp1klr2wXsm/Nte/E=;
        b=c6UTu50EZKn5y0gAF3wjm25qcQfqapqE1Vo3sJC2wM4S4HmvbaZAynRqldlmf8pDWU
         BgAyh0sDqGRLSW8FC67Z1WxaahxEuuE1BmtmxJ7QhFeRGRxen1NPU1Rc97gO/7CXtcIj
         IUuFQPaqiaGsc2B8s1htZ1dOTqCUzwxpQtrbE4wlzd1/CUGSDgHBbc/Rbwyq8GRsynGK
         huoKIVHd3th86h9P6u6gyMUPegT67HL0kGH5afaykWjZn5w3Rxz1hHQouXPwBu5f5GHH
         J7bRAhjFMlcl9yd/Lt9jiaWe7GDaG3WIjw/N2WeFU+oOLAomLvoIwTjL1zpw8qb2ecj0
         YfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691016274; x=1691621074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xMuR5EiinHFoNrMaaPJwbYiKuZcp1klr2wXsm/Nte/E=;
        b=T8WhtBWUlXgYCc45U8wp8o7SMjcppBK86Dmc9fQb16FYRFxKWqYOn1BOUsw0/in8v9
         Dp+573tdqfh+X7kNYJOGNWZ9AXy97n9ZsIbbmjHaZ7Y6gg00IReAHraxmqMmMOi9aD37
         UnLIirDWuj524Xq/srJnzch7GRouFQtWyS07YBQTZgY+sRqUpeGcRYUczj/myMIPT6yz
         uxL5d5XN3dJvIWZSniGEZHiq1c7M00PHyj7LfL9f6OP6eiZgBALM0Oiqn+gtp3nvLuq9
         llN2+rjsQrFTmjNgRtV1VqARfrDFVxwuSQ45q2M1cdkba58NthVVhaeeE2DnFbRWyAoP
         odYg==
X-Gm-Message-State: ABy/qLaDMo256fhMEedTVK8CDcGLcIc4scHau+IwHXbDoRDOkhjSHvEA
        raRbiYqCbbKv/NnicOPPpU+dnULxFRc=
X-Google-Smtp-Source: APBJJlGjna/BNEZIOqnpmIKb0vhY4kEqii1Zq8G5DClZNdG/CKfPd9E2Bwh3hwwA2v3lEo6gD2nUj0zAlWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d1:b0:1ac:3f51:fa64 with SMTP id
 e17-20020a17090301d100b001ac3f51fa64mr99044plh.13.1691016274443; Wed, 02 Aug
 2023 15:44:34 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:44:32 -0700
In-Reply-To: <20230608032425.59796-4-npiggin@gmail.com>
Mime-Version: 1.0
References: <20230608032425.59796-1-npiggin@gmail.com> <20230608032425.59796-4-npiggin@gmail.com>
Message-ID: <ZMrcUKBldWBCQ9R2@google.com>
Subject: Re: [PATCH v3 3/6] KVM: PPC: selftests: add support for powerpc
From:   Sean Christopherson <seanjc@google.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023, Nicholas Piggin wrote:
> diff --git a/tools/testing/selftests/kvm/lib/powerpc/ucall.c b/tools/testing/selftests/kvm/lib/powerpc/ucall.c
> new file mode 100644
> index 000000000000..ce0ddde45fef
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/powerpc/ucall.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ucall support. A ucall is a "hypercall to host userspace".
> + */
> +#include "kvm_util.h"
> +#include "hcall.h"
> +
> +void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
> +{
> +}
> +
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
> +{
> +	hcall2(H_UCALL, UCALL_R4_UCALL, (uintptr_t)(uc));
> +}

FYI, the ucall stuff will silently conflict with treewide (where KVM selftests is
the treechanges that I've queued[*].  It probably makes sense for the initial PPC
support to go through the KVM tree anyways, so I'd be more than happy to grab this
series via kvm-x86/selftests if you're willing to do the code changes (should be
minor, knock wood).  Alternatively, the immutable tag I'm planning on creating
could be merged into the PPC tree, but that seems like overkill.

Either way, please Cc me on the next version (assuming there is a next version),
if only so that I can give you an early heads up if/when the next treewide change
alongs ;-)

[*] https://lore.kernel.org/all/169101267140.1755771.17089576255751273053.b4-ty@google.com
