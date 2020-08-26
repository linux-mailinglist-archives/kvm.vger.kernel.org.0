Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D2B25398E
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 23:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHZVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 17:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZVNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 17:13:34 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FAAC061574
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 14:13:33 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id v13so2784319oiv.13
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=skezCpaXkHnWJG3CYg/3DX/Ca64HjeAEqxv8Bp8O8C0=;
        b=gZumU8HfjznAZ9VGfZGR8gUgrWjeHO7wzGRJ2olDYjfRKsLVf++gquOlQ41F3/toDN
         sb5aOBE9wjtkaLPVLbrREX31Ym3BN4FdRlPe0sVgZkCH3UWvhvWxolXNGOnPfbbGEIEP
         8NdzhgxgJAccCcNZX5VJegwgYg8gKz7FXms+SAdzLMfOSIJk+D5kdD4ueOCYcYiMO7nR
         P4ZE1Rt+WiUEmg9LrAfPio1yk2f5LOy0HMm+/Oxn1BYqsdMiN7FfAj8boJaBdrnRawVa
         qCaK65UMX+DR+pBBmcdGvt1670MiJV/WonkKMM3rWvf7QtbjeLbp5dRcv5zDXzy7Ilq3
         Xl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skezCpaXkHnWJG3CYg/3DX/Ca64HjeAEqxv8Bp8O8C0=;
        b=jUlT4OhArwC1DbRQWomeieCGoYWE1zivPJHf30UfPI5h++Z7EYkU0K6UFFrdFgArzX
         OE88bxGJV5tAG8zMrlRKJvKZc/689QJvf9sKPXJOPn82Dg/HwWaM+Jo+yo1r2w45I+Na
         Cz6yzcMuIK9qsi7VGcpz0+P/cQ/TITTkzzwyAiUNMSU+6314DxRsOTP86mvN/uW7VD3t
         TY5FwOCQX7Sl9pKg1MPKj4FOD0WaIskq2TTnsW4Gzh8ThNQEAFbuHBopppF5QB9Db+1p
         YsQ56eyhBYmgaWxdDc1y0Hv75xpoeO/l6bNCTW1IPdV1OrIdEAuSV7P/ueVQvkf6lriz
         us9w==
X-Gm-Message-State: AOAM530L2Q1+LXco20FS0Y3UO1pvV1HJIwSN7MMZphhQ45G1kowugnlF
        ZH5lKWeakqbtqKvn9z5HR6Wo1zh66O1l3yFxukn+NQ==
X-Google-Smtp-Source: ABdhPJyARu2aDZC+/haxJfZWBmSdVjgOkmXFEjDi6jlFy69OpJWLptw0eNQPByZSemLS8XgQEGK2JDAWB7ISnH/R7T8=
X-Received: by 2002:aca:670b:: with SMTP id z11mr4739617oix.6.1598476410107;
 Wed, 26 Aug 2020 14:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu> <159846930119.18873.955266273208700176.stgit@bmoger-ubuntu>
In-Reply-To: <159846930119.18873.955266273208700176.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 26 Aug 2020 14:13:18 -0700
Message-ID: <CALMp9eRj1ez29L-V1xOeEvrihH-XBa05ou=nrDbc_wJfrHfmWQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] KVM: X86: Rename and move the function
 vmx_handle_memory_failure to x86.c
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 12:15 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Handling of kvm_read/write_guest_virt*() errors can be moved to common
> code. The same code can be used by both VMX and SVM.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
