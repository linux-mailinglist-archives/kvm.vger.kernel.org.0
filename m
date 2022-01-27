Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B784549EB32
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 20:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245646AbiA0Tj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 14:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245644AbiA0Tjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 14:39:54 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5693AC06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 11:39:54 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id k13-20020a4a310d000000b002e6c0c05892so921590ooa.13
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 11:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kht99chlE/8EVCcEzEOZy9Nky5Oo1PbC0W2KcaE2cSo=;
        b=mP3qGPjmtboPf8Yk2ZKAeQ65zhSMOXTErzRCDV46nMqlSzBKzGzQoAk2Ho3GEEHrRT
         yNrhzILA6f3QDnCs7haxVg647xOjC5xfHY6ONuOOK2dVTP3l2asjwhvLydhwuLUilIgy
         00k53ZTXufNY9780N9gmKfvIlpnjcTokHs3Nu4aJdJ9Sx4eWOpBB/k6LJy9i50qRXjO0
         O/DuEh74u61FJxflu7g1UvoBQFIy9OftZv1UawnKJY3Cqer+QDnphElyDHFwCs/fqof3
         W40sDy6oVzD4L2/O13HuiRfGpos500CbEaUmaUiXGMKF50wY2BbWHZS1WlQ/eJgkzCpe
         OzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kht99chlE/8EVCcEzEOZy9Nky5Oo1PbC0W2KcaE2cSo=;
        b=jeq5kkPBNKDyl0CzCFog1PBgUPiq6CP+f/kZM/UUsyKOVgPK+eAUcAyM9KXgjaI33W
         QHk5RGdhsCe/HgSCftHf5tmj2uDlLLTbivY0lYym2UgpPL+4a1LKA3a8NzJiqNerRG0z
         bwzT3nSo74c1DqEuxYm809JZrKuFn13XJbBJt5Is9Cps3FpxarivcC38F6OTW1rb5Y7z
         IzeumgA8RD9sYyjfw7opJ+CApsqAlih/smMEeIr3pLWcwr9a+A0/maH5D/fxFdurZQ4/
         As/5zr1XpFLTpDADhkAl0QvIe2YVycUbHbBN4JHUz3kgQcFhOCsNpe5gezhBmkyCOtTg
         FM2g==
X-Gm-Message-State: AOAM533aRSpEQKh6BhMK4YnlXlFxh5moyUdNtZMSzwCRaNXlaFy4/rfx
        yRNQYMiNzbG2ti6q9TRMAu3jnguQQ3fBD2VNEfNXrQ==
X-Google-Smtp-Source: ABdhPJxqPDcgf2LwtsCXaeGr3ALh7VWF6KNIyDFo8rhocZL9wDIjd1haYjfdc3Yabyu3Qd1t4dGh8mjA1PO8QNkx3d4=
X-Received: by 2002:a4a:b787:: with SMTP id a7mr2620025oop.85.1643312393447;
 Thu, 27 Jan 2022 11:39:53 -0800 (PST)
MIME-Version: 1.0
References: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
In-Reply-To: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 27 Jan 2022 11:39:42 -0800
Message-ID: <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com>
Subject: Re: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 8:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> I would like to raise a question about this elephant in the room which I wanted to understand for
> quite a long time.
>
> For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
> again I am asking myself, maybe we can get rid of this code, after all?

We (GCE) use it so that, during post-copy, a vCPU thread can exit to
userspace and demand these pages from the source itself, rather than
funneling all demands through a single "demand paging listener"
thread, which I believe is the equivalent of qemu's userfaultfd "fault
handler" thread. Our (internal) post-copy mechanism scales quite well,
because most demand paging requests are triggered by an EPT violation,
which happens to be a convenient place to exit to userspace. Very few
pages are typically demanded as a result of
kvm_vcpu_{read,write}_guest, where the vCPU thread is so deep in the
kernel call stack that it has to request the page via the demand
paging listener thread. With nested virtualization, the various vmcs12
pages consulted directly by kvm (bypassing the EPT tables) were a
scalability issue.

(Note that, unlike upstream, we don't call nested_get_vmcs12_pages
directly from VMLAUNCH/VMRESUME emulation; we always call it as a
result of this request that you don't like.)

As we work on converting from our (hacky) demand paging scheme to
userfaultfd, we will have to solve the scalability issue anyway
(unless someone else beats us to it). Eventually, I expect that our
need for this request will go away.

Honestly, without the exits to userspace, I don't really see how this
request buys you anything upstream. When I originally submitted it, I
was prepared for rejection, but Paolo said that qemu had a similar
need for it, and I happily never questioned that assertion.
