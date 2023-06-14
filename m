Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC10730587
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbjFNQ6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjFNQ6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 12:58:01 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6F1FDD
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 09:58:00 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-45739737afcso291951e0c.2
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 09:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686761879; x=1689353879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbbPZyQj/zRNMm09rt0NDUI/1g0HAs04HqoquzS+gs0=;
        b=p+9Jq7EFnCczwqdZtVQcctfkvVaOyjk2B6NgRzfmQmk5d4vI68IwzvFurN+lljEAy4
         F89OyL6ed9X+wceKO/OC1uEOwydC66YBFjuCYmCkx/xa0Ag0rUDEwIJ00llYs/oKg3l8
         WXO0HevvyTuTijUTCrL/EQWbFWdhf9Rzq7u9/52YHrEP8NWbYKoaUTw1qyUBxNoWhULN
         OVxy+3Hwjft87nlppApc7iGn3o/lEgSkgWW7ZZ6v9lmhkTQjeVVw3Av23pqOSBkMO2sT
         Ds1CkVkPx05gA8ANRPnY1BsS9G7Lu/xO5vu275Vyyp5gI64GdKtNihijUr38fWX4HJFV
         An6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761879; x=1689353879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbbPZyQj/zRNMm09rt0NDUI/1g0HAs04HqoquzS+gs0=;
        b=gOn3oQ1ObfbN1Z1sTK2JC5F6UDonXvAj8P2F98d8R89fGOOBBTkUbvqLnBPHvEXkbs
         BfSnBK6iebJ85cfiUsrq3SaeN/Pi5hBmdhzXjgGVAW8OT/kjMPKsVKeCNzwfZUaMLvWE
         8k6RzJHVMTQk0LYnf1ib1i5RwPZLXfPNSHg75OXaT08klU396qM/m4dRz2yXOjcumF+0
         i9vfacKFsWxALV/bjbccYBWtO39MhIQ0mlCkSVIMjGG4UK1ewigLHm12K+6W2hXjw+vW
         sy2LsxvdxjV+lpAfwzkTgQMJPbnDlUOGgmw2hIMBJoIgJ4iUVSn19ppsKP/jofuzc3Fl
         WlSg==
X-Gm-Message-State: AC+VfDyjvM+QzHzL9FqG7YBpeZADgWuzQGRM/e1EO0sY4sMR1htGls43
        zPHzWog39/fr3e5mxSUYQFRqVViXBvIBHfBxbpG45A==
X-Google-Smtp-Source: ACHHUZ6nIKzVAUVzl+Hoo2q7hslSXIyOJcdcAIQPCOok57IYXyBvPoWnN133fLkGoruyGsjlbju9YFOFE31pO682uJE=
X-Received: by 2002:a1f:4c47:0:b0:465:ddcc:c0ec with SMTP id
 z68-20020a1f4c47000000b00465ddccc0ecmr5369269vka.0.1686761879188; Wed, 14 Jun
 2023 09:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com>
In-Reply-To: <ZInRNigDyzeuf79e@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 14 Jun 2023 09:57:22 -0700
Message-ID: <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Jun 14, 2023 at 7:39=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Don't put trailing punctation in shortlogs, i.e. drop the period.
>
> s/pinning/getting (or maybe grabbing?), because "pinning" is already way =
too
> overloaded in the context of gup(), e.g. FOLL_PIN vs. FOLL_GET.

Done

> "read-only faults" is somewhat confusing, because every architecture pass=
es a
> non-NULL @writable for read faults.  If it weren't for KVM_ARM_MTE_COPY_T=
AGS,
> this could be "faults to read-only memslots".  Not sure how to concisely =
and
> accurately describe this.  :-/

"Read faults when establishing writable mappings is forbidden" maybe?
That should be accurate, although it's certainly not concise.
