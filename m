Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9C7C5964
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbjJKQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjJKQnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:43:25 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908A791
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:43:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so253a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697042602; x=1697647402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnZ2PNbtpkahI22IHIp4eThBFyxkrDzPh/5rscFI1Kg=;
        b=Y8vvZdsCkjyp94lG+KpgBemzG82x5fYHmdDWzooot6UZxH5qzvyjG5tRGkhD3s3i1m
         qe6ax60N+M43NA3DlLu+c2i6GCZF+G0SmcNC4S7E9+g7YO0tPjxV7qFnvLOp5vLxMpQR
         nj1zV/qWivsV6BtHEYSlGmRn6rJNgs/QFL1no6VPRAXCNYP8YOqz+cL7+Rzwwhx/pe4N
         VqoszfCZMfsEZC1/FZYlmkAFglxcWzfBPeSPPNXXpBhDH7mkFhkbqO26yiUPtLP+b4iQ
         3vYX03LLb9W8PnvVT6/K6ZzcwhyZOXCa/unul+U3touU29yr6cLNqvbXTvbLe34B7V7Y
         ARfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697042602; x=1697647402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnZ2PNbtpkahI22IHIp4eThBFyxkrDzPh/5rscFI1Kg=;
        b=vdg7t3zaSl4Ugyfi9LBk6uvxeyCp1b43qOXrDASn7l7uvXXLE7+iaaH18RGrUDiPl1
         7iHu2EdNRmAVWvsHxZpeUKD6aTiPcaWbxPmF3F8Jurf6G1/D8gNhK1ELEXP5sx8qPcFP
         dyYP2tlXckiZSMT3EUEtme2lTEL3xOkVtHTqGA04eqa1fCqob7LAcLoip06yPuSGFgee
         UFtvxoKl1ONqEyQc4uqobgoIoBWGNiv5n5EKtXIr33Q91au3TgiyN+DOfXuThTkUUptl
         OFKrwvmAZ2VwLNrfVT/Q3LidbtsvYSgjk2b6ZI7qOv8in+ZoGy3mYgcabT3yaEyoJ5M5
         hLgg==
X-Gm-Message-State: AOJu0YzNZ6/0d3K96NdMECp327pWz9MGtgTKyHf36ZE1PjuDXTPBPhro
        wTvBDm27qeGVwVZUaV1w+E/hO5rLrE6EhupRrRjuUNmV495piIZwU/k=
X-Google-Smtp-Source: AGHT+IGeMaBNu+d6EqjyO7ei1p5Ru0cYcbF2aqEN3nZhqQpWDUvzwWT8OEKk3h9xJDQt4wCGqhFfyZJBmyv7OqOJI+I=
X-Received: by 2002:a50:9f8b:0:b0:538:1d3a:d704 with SMTP id
 c11-20020a509f8b000000b005381d3ad704mr141567edf.1.1697042601903; Wed, 11 Oct
 2023 09:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
 <ZSXdYcMUds-DrHAd@google.com> <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
In-Reply-To: <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 11 Oct 2023 09:43:06 -0700
Message-ID: <CALMp9eTz-p7RER-h+XEmF+Tcy=MTuoRXKV70XW0Tds5gQzrckA@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Bartosz Szczepanek <bsz@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 1:21=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> ...
> But I'm confused here. Even if I don't go as far as actually making
> CR4.SMEP a guest-owned bit, and KVM still ends up handling it in
> kvm_post_load_cr4()... why does KVM need to completely unload and
> reinit the MMU? Would it not be sufficient just to refresh the role
> bits, much like __kvm_mmu_refresh_passthrough_bits() does for CR0.WP?
>
> (And what about flushing the hardware TLB, as Jim mentioned. I guess if
> it's guest-owned we trust the CPU to do that, and if it's trapped then
> KVM is required to do so)?

Yes, guest-owned bits become the responsibility of the CPU.

With the TDP MMU, KVM probably should not intercept writes to %cr4 at
all. I'd argue that it's better to construct guest paging attributes
from first principles every time KVM needs to know, rather than
intercepting any operation that may change guest paging attributes. If
that's too expensive, perhaps KVM is emulating too many instructions.
:)

Particularly aggravating to me is that too many of these cost/benefit
decisions were made without consideration of nested virtualization. At
one time, someone observed that Linux hardly ever writes %cr4, so it
must be cheap to intercept. How ironic that they didn't consider the
fact that KVM is part of Linux, and KVM writes %cr4 all the time!

If the cost of determining paging attributes from first principles is
really prohibitive, maybe the solution is more flexibility. KVM can
start by intercepting writes to %cr4, but if the rate of intercepts is
egregious, it should do something else.
