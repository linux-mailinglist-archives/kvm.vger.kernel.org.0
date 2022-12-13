Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068A564BB79
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiLMSAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiLMSAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:00:08 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0E523EAF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:00:04 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3bf4ade3364so203526247b3.3
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2q+Rlxn3qcFlUNSciCIoJUlAxGRPH5SvwBIqL2VlTbA=;
        b=Y3EKdkCCz47F1VcdeSbmrq5L87OKF9hcbaSJwl+vnhkaDTm4pAPVaJZO4qSLylN1xy
         nQHd/9Sp9UuHEXiH71uQLKDNxISd9dPDhYG8MiRaq40MHC8Qq1fF7RORHu1FbGaM2NCU
         WsslMSfLGkh7joBah22hpO7VN5hJywdRuWVFsC4VtxHQRJ49lH+VOH5R5Eo5kf9S0iNY
         BGyRcciuSQs0JM+eHv4Mhq5z+ZGRQwewYZH5HNPJmwcqamUFnpWXUnXQIeXdddTJVj4S
         yDNs/5OKiz/comNWoMoMz464dgZDU93zMff+ff7rF/0gEK0SMZ4O3MLHIxJNPv04xURx
         5/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2q+Rlxn3qcFlUNSciCIoJUlAxGRPH5SvwBIqL2VlTbA=;
        b=x1YopqusR+ovZhkcZIkePbp5HgU3LqFq7ZvP2Sa3ysy3s5m5OEKNKcVFat75nMiOYo
         lOpCMEIPClpgBAbALhV9HJeQ+vzYsrNB4f9KQvqdWeFEUGhd9yCWWU0XzpytaLQuW8r7
         Ye8hZXeFLppX63MPNIcAI3HgKBN1BTuH0KKWROKNQMlet6SmCa4kaGfi9eIIlwrcXQJ2
         kOI3q25vsVNiZ/ToX6S3mfZYKoSzORpJv/nitsh3wFM4+B0hyDDZIXl1ucKJ++4c2cKV
         01TKpnELgXxxXPSroCdfi1KBN7BJDnNohy6VzF7aCcWVAjnd7VexNMHwffx7id0MhCNA
         uIjw==
X-Gm-Message-State: ANoB5pl2kQgRq4PIor+70gNMqK02dETo1O8XvOueH406oHyHMlvZx2Qa
        qaOTcNV0jYCUjTqfGlUgwn8oyqxs2eym9VT+dx0QsRBP5n+c71qq
X-Google-Smtp-Source: AA0mqf7zoDhSCFGuitR+bTdKPjJ9ycAs0uqWym5d/fV6e9qthNhf0Km8CAYRdu3t68xP5sDvEPd8+ipZWf/nrVbz9CM=
X-Received: by 2002:a81:1401:0:b0:3b0:b9aa:46eb with SMTP id
 1-20020a811401000000b003b0b9aa46ebmr3924120ywu.150.1670954403842; Tue, 13 Dec
 2022 10:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com> <20221213033030.83345-5-seanjc@google.com>
In-Reply-To: <20221213033030.83345-5-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 13 Dec 2022 09:59:37 -0800
Message-ID: <CALzav=d-9G6SSBCB=TbVWi9Szprm1wD3AqqgZzoCq26_LF_ySw@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: x86/mmu: Don't install TDP MMU SPTE if SP has
 unexpected level
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 7:30 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Don't install a leaf TDP MMU SPTE if the parent page's level doesn't
> match the target level of the fault, and instead have the vCPU retry the
> faulting instruction after warning.  Continuing on is completely
> unnecessary as the absolute worst case scenario of retrying is DoSing
> the vCPU, whereas continuing on all but guarantees bigger explosions, e.g.

Would it make sense to kill the VM instead via KVM_BUG()?
