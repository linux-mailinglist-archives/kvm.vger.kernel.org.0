Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E252626ADBD
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgIOTi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgIOTiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 15:38:22 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D01C06178B;
        Tue, 15 Sep 2020 12:38:20 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id f11so2342947qvw.3;
        Tue, 15 Sep 2020 12:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DrKIC45XC0KGpeV0oBCU8OHCyP4cVWlaUSa9xbQiv/w=;
        b=c0jvgxx0sHwf85JCYsq19kBF/I9d9866K4D25V3KPGkpmAxYiALD6TolCOl7GOUbHs
         ZOj+AzK+ht45FNSBj0xH1FmcqM6IcaxICSSwzq0d+DefwPFPan7WC+Y9pDNAp4icOR/n
         g+GYObbyGXP8LiyHEDKIMxoeFgz7XTDbe2PpECLB0hIRKHnZTaOyxCMpduIBDxtG2t4L
         BpU3h1xtD1WHKxgHMMFvapechnQLuorRGxRLgeJWeY91kp6MHx+mlMduc/uysSxGd0km
         pwytl9df9Eb3svt7Fnf4R0pPOWO//QnfkuHgeUB9rkPDHdNgAVO8UBjlH1aEZiiiZ+tn
         I0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DrKIC45XC0KGpeV0oBCU8OHCyP4cVWlaUSa9xbQiv/w=;
        b=UwZVNVttk6pBc0LeA8AeTeq58Lq/u4ORcARAZYfjAz4rXhflU6CEeJmT09QY1VGy5H
         q1ILjKtjlxyxsS8Pthk69gzADtKRX/RXXqSrKIJEsa8GwwbrgDEOWED+qryleS2ZAIRR
         sEZfw1ztL75LYFmkkMql3linTCZNsgY0qLjTrEKss/+mhQsGLDndmRSZn0pw7mx4aPmc
         sJtDAh71FhkeXFDHD1QgELsSf/W/pHH4/AkIxf5vffJAmU7IqQ1XL0rFWGcGxnV4eyM3
         HC4kmU/yblalAvuVsdx7r9xGQmcvw9Ggs6cQotbOwJvhDcpf8En15In8QKikyQpoqWEp
         wHaw==
X-Gm-Message-State: AOAM533d7c/pAwgn8GUgCItcPSKnZYgJFO5M1dB/c4UB8FNney6S0WWI
        ovfhaYF1ZAZFchQYT74Exjyd+lABqLNJYfgM7FU=
X-Google-Smtp-Source: ABdhPJxpi9KDYOcVyQVMUOfrybjdKvN/Ea0A5zYoxOESvTDgtqpb41V52FoP09K2eLJI1MieHVDA8gshUBM15N9CRWg=
X-Received: by 2002:ad4:4594:: with SMTP id x20mr20254899qvu.4.1600198700030;
 Tue, 15 Sep 2020 12:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200915191505.10355-1-sean.j.christopherson@intel.com> <20200915191505.10355-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200915191505.10355-2-sean.j.christopherson@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 15 Sep 2020 21:38:09 +0200
Message-ID: <CAFULd4bUpn=oRntt3_H2hmNmMwm=tp-kumhetCssjWJCH9Yx5w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 9:15 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> into a proper subroutine.  Unconditionally create a stack frame in the
> subroutine so that, as objtool sees things, the function has standard
> stack behavior.  The dynamic stack adjustment makes using unwind hints
> problematic.
>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Uros Bizjak <ubizjak@gmail.com>

Uros.
