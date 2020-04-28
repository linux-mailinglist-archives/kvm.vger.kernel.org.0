Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566D31BCEF3
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD1Vjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgD1Vjo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:39:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD56C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:39:44 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k6so25032788iob.3
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ul4JdnqYIuUZ+XRuxCZf3WpJHQHQUt+RKURin2OvTJE=;
        b=o2z8EurVpT/nTBtFhpV3btr1ad2aGZqWHCjoLb+NSKVxUolYCI2pV/P7JsCPKcFWer
         cA/JKLDr1YnNYBkindhrydkNLhaLmnVkdmXlvcopD8PYFkfBWOBN6FhqXTjQwvZ8TvUD
         cLlXiGnb0VlxyQPqDpU0VyaCjV9zyYBEOZTRrjwGXw65UalAr3fn4OBD04jObMVnbxMH
         ndppohSLJ9Iln0cDOKrtTY24X9LTp7/CyG0YP/fhRFXj24PhpDCn2PcUpsUD+SdVinjT
         tzAJbACUxDWlH/CZIPjCd4f7pNUeeHvv4xd6UGBMLvAlBkzyhHCp6PaS5LLW4pI6mEHj
         3u1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ul4JdnqYIuUZ+XRuxCZf3WpJHQHQUt+RKURin2OvTJE=;
        b=az8nk4AXUpBUjoa1WexN1n5L74voff4Kj2o9yPttkugxL6XGI2pIn1c8VQWnrGf1BU
         kN3nxXcZqZJavXmyxa9TxYbtxZQ8Rb+RXfKMMTx3epaXm1aVH1uyck1bt6K4aXYCmiuL
         LIox7lfM3YCSrJCC7Fvu/F6mp5vQNVf87K48ptkVqMltfvVkJCPLtnFKa245VC8ztu6G
         lznA8SouvMHs5DkEnnEoe7mA1SE5ZhjoZUTeXA+Dt34IRdL9erkox3Y8mHDDD6Y0Mfw+
         a3o/VzgJCUeskEHmL1yTSSPvk4Juc39Sip9eD/V6xs+e83TH0SpwS5uUiYbqCozcvRp9
         qvHA==
X-Gm-Message-State: AGi0PuYnvlfD6tclTktKDMA/y1de0h1FRGjGEosryQstJJrcL6niXeGN
        KHIbjYyPBlO2ikwlTJgzAY1obmCeaeK9erRiDyP9SQ==
X-Google-Smtp-Source: APiQypJL8jn5sxcb7rjtcHlX2CtaRnYDq2q/Zfa8onXyOd2w3CHlsb24FCCAaPa1UV1HR2IQxmlqXF7TDuggkkxkXT0=
X-Received: by 2002:a6b:c910:: with SMTP id z16mr27919357iof.164.1588109983668;
 Tue, 28 Apr 2020 14:39:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-3-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:39:32 -0700
Message-ID: <CALMp9eTnOs=MMVThBf032XVydj1F40P0Kui7VFAn9F=idLAFPw@mail.gmail.com>
Subject: Re: [PATCH 02/13] KVM: nVMX: Open a window for pending nested VMX
 preemption timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add a kvm_x86_ops hook to detect a nested pending "hypervisor timer" and
> use it to effectively open a window for servicing the expired timer.
> Like pending SMIs on VMX, opening a window simply means requesting an
> immediate exit.
>
> This fixes a bug where an expired VMX preemption timer (for L2) will be
> delayed and/or lost if a pending exception is injected into L2.  The
> pending exception is rightly prioritized by vmx_check_nested_events()
> and injected into L2, with the preemption timer left pending.  Because
> no window opened, L2 is free to run uninterrupted.
>
> Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> Reported-by: Jim Mattson <jmattson@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Cc: Peter Shier <pshier@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
