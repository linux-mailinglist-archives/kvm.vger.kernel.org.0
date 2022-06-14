Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914CB54BE0F
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355318AbiFNW7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 18:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiFNW7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 18:59:51 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6BE52E49
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:59:50 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-fe023ab520so14394996fac.10
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ai9uz9Kgmbv+1IKOW8tsBXcg4zvXfHiaRlhJIRWIRQE=;
        b=qQXMdCcpfHeFPj9Pb9fSBN6SYEUOuzVQU1avMKuhlKUQW1uDAmygKuX1jPvGpP8MPN
         B6suRyJZrlGEVFaU6iAVcAxpJGNzFa51L+1QRc8vxKSWNKfai9k5LqZzpD2YyrnoCq7n
         3ByhekydRz6JBrNklDUE8i9ySVVu+xgLxusNld2q8ECzSbvRWHDGR7M5vJ4GxtG/hRf7
         iOPc2tIjGS1+J3xTrZbGDu0RMzoIE0yzTmF2BAK6MdyGrwWfgAHmM/9XYmtxP7iTJFGQ
         g/YBQMlEXzenqRWvx3UCsZKJt6yRXzE4Lgn2wlxvslnYHA8yVgQaaDX97Yll48hcVXTh
         65KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ai9uz9Kgmbv+1IKOW8tsBXcg4zvXfHiaRlhJIRWIRQE=;
        b=LrKuHHlv7tKUK7v5fjlF83P3Po7N7cuIbBQwCrEtbDbKgkkHHHWfbKmyJsmYAsindY
         D0A5OA9GgR8X1LRLBAP5yyRFsgBc40p9qxjOjkToDJ+OyQTREX10QLRsXIeqtaWyrRfj
         oWTIwpb5r27xMW1I4ePWfXF0f9HvMz8SNyeS3ryULv37BsAxQ3qlzz1vh4Ad1ExVB4bF
         WiL+t2+eqWJbVqnF8DGtULIIQz/uB2Ngn2LtpJAIEOfo4WFprKnshA6BQX1j/Nkh+yud
         Kmuf4Q+PtaVSphpXiMd5NIMOkgfZjsuFLguGXDkLYecrti59aYmb4A0e43MZdzc4dWrQ
         2aig==
X-Gm-Message-State: AJIora/LWu6HBYXbw6nUxXPbqbqZZQjAz1/kjLO9ngz6WWvEQ0BkkVJQ
        yiHA8XKrfwgo4gxSn6vxPp48niJwsiZcaWE7O0u1zg==
X-Google-Smtp-Source: AGRyM1v/A3R3ACL9bTJ9F2oyDopfksaBm4buK5bKF4I9WA9CnavOyJWyL6jkFtiVCsLQdE9u6Xn5OXBJ1Rs5gtS6mws=
X-Received: by 2002:a05:6870:891f:b0:f3:3811:3e30 with SMTP id
 i31-20020a056870891f00b000f338113e30mr3842884oao.269.1655247589406; Tue, 14
 Jun 2022 15:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220614225615.3843835-1-seanjc@google.com>
In-Reply-To: <20220614225615.3843835-1-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 14 Jun 2022 15:59:38 -0700
Message-ID: <CALMp9eSYmxMRAGE3kZvJMsf53F1WJp397eJp3YvqitcsGzVi_Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Query vcpu->vcpu_idx directly and drop its
 accessor, again
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Jun 14, 2022 at 3:56 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Read vcpu->vcpu_idx directly instead of bouncing through the one-line
> wrapper, kvm_vcpu_get_idx(), and drop the wrapper.  The wrapper is a
> remnant of the original implementation and serves no purpose; remove it
> (again) before it gains more users.
>
> kvm_vcpu_get_idx() was removed in the not-too-distant past by commit
> 4eeef2424153 ("KVM: x86: Query vcpu->vcpu_idx directly and drop its
> accessor"), but was unintentionally re-introduced by commit a54d806688fe
> ("KVM: Keep memslots in tree-based structures instead of array-based ones"),
> likely due to a rebase goof.  The wrapper then managed to gain users in
> KVM's Xen code.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

ROFL

Reviewed-by: Jim Mattson <jmattson@google.com>
