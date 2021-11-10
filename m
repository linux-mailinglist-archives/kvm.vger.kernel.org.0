Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE3344C986
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 20:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhKJTxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 14:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhKJTxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 14:53:20 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DF3C061764
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 11:50:31 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id o83so7307559oif.4
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 11:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=tJKTPrK6u5HNWo1Jtzs/NEObBhL/iPYlTnu4f8tMjxc=;
        b=NDGaL+pt4BIMWrbp8LoeCbhTArnmkUJI16CFRL8w1QDQuAf+wJG5I8ukqIrIdZe5z7
         Xis9uzQX6zxl7ld8rk8TXi77XaUGWan9Q0U4E4NW8tFbVNCHdX2qdOGz0i88/H1G/vs3
         hkdKhERE4mfCE4Wsj3TEaXbyXVvmEtTLsRIT64gv0hkajWggTM188IiMuys6wOIFlxe+
         pOqncd5FuqF5EjWuGmdkpUQ5fzbrc4edDszcRR7vDvVNpj5fFF/9YaEBjSPF0oqWEySv
         IIuiCY700Mny+X5L89hrrpPn84wAS0w1Ki1S7TdDKeUVUqgX0FcuH1xZTwM51I4KtTly
         5Gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=tJKTPrK6u5HNWo1Jtzs/NEObBhL/iPYlTnu4f8tMjxc=;
        b=ijCVcnA79AQUOrLugWR1RAJLwnzG/GtJtP87TWy8N+yZQziUPwVJZj1Q+zkA9ciTjW
         zqx7sGj8uA4GyBMRNwTiUC+CWrk/ZKEYdYbBaXB50LDYjDO03MLO55XiANr7UwhpgvxE
         IDZcaLFDVjCVHomqEG/d6LERyH1bqpkXfU4VkN2+HVwrN/5Vdsc/TqtIZW9Bd5CENw9u
         YYgGyg/yj4TeE+rdc3L5V4MZkn5C4YihJGsBfnOJQR5Yjg8hHN4RHXA6/u39Cq2lNE+G
         P/0M+7TA6efy5MS6lB1k3xGwfiLnazmVteQENWbq6zWl8WgFg31iiP3Vfr39j1tXrelV
         iaxg==
X-Gm-Message-State: AOAM531gtmbCP6rjlvmhrrvaYB8PSugm9prLGdH7ZWO7OpkLPy98pqWp
        lzPc8xAjLKEpCIT9AZSUCphMRLRw0li4U2QxcA0tIROa3zw=
X-Google-Smtp-Source: ABdhPJwVOBm3MTvvTSkxRfhxG4uj6+IVr4gRHs7nnRG/INayKIozt/inV2EH98220KAYqJGKvDv3zjpFkePrTGfSubk=
X-Received: by 2002:aca:c654:: with SMTP id w81mr1516867oif.66.1636573830027;
 Wed, 10 Nov 2021 11:50:30 -0800 (PST)
MIME-Version: 1.0
References: <20211015195530.301237-1-jmattson@google.com>
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 10 Nov 2021 11:50:18 -0800
Message-ID: <CALMp9eSFFQP9HVuScsatmmazLkNhure=8qwABAaJs8yr9+udVg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR
 persistence bug
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 12:55 PM Jim Mattson <jmattson@google.com> wrote:
>
> In Linux commit afc8de0118be ("KVM: nVMX: Set LDTR to its
> architecturally defined value on nested VM-Exit"), Sean suggested that
> this bug was likely benign, but it turns out that--for us, at
> least--it can result in live migration failures. On restore, we call
> KVM_SET_SREGS before KVM_SET_NESTED_STATE, so when L2 is active at the
> time of save/restore, the target vmcs01 is temporarily populated with
> L2 values. Hence, the LDTR visible to L1 after the next emulated
> VM-exit is L2's, rather than its own.
>
> This issue is significant enough that it warrants a regression
> test. Unfortunately, at the moment, the best we can do is check for
> the LDTR persistence bug. I'd like to be able to trigger a
> save/restore from within the L2 guest, but AFAICT, there's no way to
> do that under qemu. Does anyone want to implement a qemu ISA test
> device that triggers a save/restore when its configured I/O port is
> written to?
>
> Jim Mattson (3):
>   x86: Fix operand size for lldt
>   x86: Make set_gdt_entry usable in 64-bit mode
>   x86: Add a regression test for L1 LDTR persistence bug
>
> v1 -> v2:
>   Reworded report messages at Sean's suggestion.
>
>  lib/x86/desc.c      | 41 +++++++++++++++++++++++++++++++----------
>  lib/x86/desc.h      |  3 ++-
>  lib/x86/processor.h |  2 +-
>  x86/cstart64.S      |  1 +
>  x86/vmx_tests.c     | 39 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 74 insertions(+), 12 deletions(-)
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
Ping.
