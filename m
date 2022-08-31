Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDE5A84DD
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiHaR6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiHaR6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:58:38 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98E7DD767
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:58:37 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11eab59db71so22031260fac.11
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mnuRXQYw+PDg4Esm1oYn5QiuF7oH3z8MEWV+uoTWof4=;
        b=El/hH7bWJ0ULPCX/nQz1pdsFzI7+6T4+wIZsZozg6Rc0mgpkHZQnRRQAJr5JqplHno
         hut+8KRYpSuIZuIyV7RXCB43cnaSUuLxBanbkUu4ZPik2RIQiXi3IS2+Nx/Fv3HIG8jV
         uvxb7P7yxVecLtSg72GCnwBr/87Qk4+bb5eLzQzfhdtOb1B2XBEfkaaHX8gU2zUTdYcv
         pEdOu9Nzmasluy3geGEO8nVVkSiRJ9NdhsT4MzYSmwsgsi7CJ+4c8lj0LHJQuCvX9a0f
         UjiPQXm/SevmRWzST9KBFuyYFi7kvu84YLB/y8Yf39ygvDfS+TtDnH6fJYGuy++gdYfc
         xfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mnuRXQYw+PDg4Esm1oYn5QiuF7oH3z8MEWV+uoTWof4=;
        b=OLwSBhsOExfR6Xb1tktTNo0+l3GOjBQBnIA3oyiu82m9Nw6cPgjU1y6X21QdEFq2jB
         YNX0+eNTuLgX+mZJne/s73b0CahCEQfJoPKXsN3SAKXXmJ/RVKxOv32VKTviG38xOsub
         U+K4ON2r3z7wCh70rABBDEun5cstbQqN9Vj2YcClevtcfTE4HrACB0GXmBHGrsdx+XCM
         8HIpxE6/BQY0L2tX7IoWwnkPo348m9JtWOMUDvr1fQRlabUld1A5Jnearfcu6SfUFsiS
         CH+o0fYRu6RDf5VSvn/ypConTg/aowRP1LMzqUqS1FRD0Qk/mjeLPc0EMi6fXWgusoeD
         yfZw==
X-Gm-Message-State: ACgBeo2ucf9fnnyuMp/a5lSCtxqSSUfuhlnjlyLFEl9nRnLfLomOlQo0
        2AHWV7/MLboMpCsA9foJF2YHtfFUnjf/S+LtK9YtUw==
X-Google-Smtp-Source: AA6agR5rmt9cw+4REXG0cF46hXLCJKclNwBs64EAGBudNASu2RctnbRhQxBD9ylrrHt06GyG4Uns4cZ/NaThP6I4P2s=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr2022785oab.112.1661968716785; Wed, 31
 Aug 2022 10:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com> <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
 <Yw+MYLyVXvxmbIRY@google.com> <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
In-Reply-To: <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Aug 2022 10:58:25 -0700
Message-ID: <CALMp9eRKa97GbvbML=VTrQ=Y3gaF6eZtNhrWD2UNGbL1Q8r0fA@mail.gmail.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
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

On Wed, Aug 31, 2022 at 10:49 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:

> In this case I say that there is no wiggle room for KVM to not allow different APIC bases
> on each CPU - the spec 100% allows it, but in KVM it is broken.

This would actually be my first candidate for
Documentation/virt/kvm/x86/errata.rst!
