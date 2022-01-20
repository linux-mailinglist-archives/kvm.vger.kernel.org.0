Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F55495278
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377074AbiATQgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377069AbiATQgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 11:36:15 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE78C061401
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:36:15 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i65so6062761pfc.9
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hGaZsbiJASZErJtXYCPHOy1LfSDGgGXtNK8v1f4hcw8=;
        b=o+rdUyvifLx3ikdXYUoHJurQvxq7YxvpOCpZ913bLSAFfJdv1FeA4DzBVfwYyzp/xx
         sRXNXHT1DjEv5C/sOoEcIXueahEhgLsLFsBhXF/VvO2+x64307aqQpB99gPQr0YoXgF/
         j3ffQEl5nSb/eB+Zv6r+zKEVpLi7tpoUunQ6+iEA0MslqBMK7Hxt8DLwM6RAbJJhxeEU
         Bm9tvbF8jgoojBRBvTTb4FZUjhqtrNmLo4wf7fo5nXz8DT2WlwB1D2uC1XGwUJSJUfWN
         L5wncvmyxxHORjtU95qKZ3L1iToNSCa5EOOeKysjqlcCn4CcY+hoF1yify8Imk7IQn9t
         gH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hGaZsbiJASZErJtXYCPHOy1LfSDGgGXtNK8v1f4hcw8=;
        b=HdjgHTEzycVu2giXx2TJ3A7P5dhQSSIG+ei/x1EwA6EXHkHp35+ruofCfdRP98GAhx
         C0NZ7rKw825U0vymknb3lNnZo8XqseHdJpJXKijetPKAD1QsoYEmqg7bNMNx6al1U9hS
         4dZHgELOPqBMjzoC6Za2q6/aEq5bie4Fc0tYXCywcG7Bxaqy7/8z8lhEcHuYZ1I4qrXj
         0+4P4zakLd2bU/uA2g/0DyFidGlJ65uiAY6RTsocK1FE+kyIoB7vgxJeb2ub4Q+gGDLo
         1e1z7FgkLwjPW4LRmbK8D7U79uzc3xWisbKSnRG3o15FfxebBw9acIfctWUO0P32CmAv
         KMTw==
X-Gm-Message-State: AOAM532qiBTxfHUhYPsmo0HT9deQxLFuUVxxnnuJ7vUpeGUrSopGQnpx
        qg2HvR7Nda+cnYmqy+3BcXaVpQ==
X-Google-Smtp-Source: ABdhPJy2KMiUwwcpNDufnYV3aa3quRyuPhEgbY9ZnI+pU4+XCZzIePZF1nRIQuWmclQrwc/AuqSXeg==
X-Received: by 2002:a63:368f:: with SMTP id d137mr32791437pga.0.1642696574570;
        Thu, 20 Jan 2022 08:36:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x32sm4230347pfh.151.2022.01.20.08.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 08:36:13 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:36:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Cooper <amc96@srcf.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS
 blocking shadow
Message-ID: <YemPeqpcFDjhGfRQ@google.com>
References: <20220120000624.655815-1-seanjc@google.com>
 <f3239ec0-9fb8-722a-00c5-11b18f19f047@srcf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3239ec0-9fb8-722a-00c5-11b18f19f047@srcf.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Andrew Cooper wrote:
> On 20/01/2022 00:06, Sean Christopherson wrote:
> > MOVSS blocking can be initiated by userspace, but can be coincident with
> > a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
> > executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
> > is problematic only for CPL0 (and only if the guest is crazy enough to
> > access a DR in a MOVSS shadow).  All other sources of #DBs are either
> > suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
> 
> It is more complicated than this and undocumented.  Single step is
> discard in a shadow, while data breakpoints are deferred.

But for the purposes of making the consitency check happy, whether they are
deferred or dropped should be irrelevant, no?
 
> > are mutually exclusive with MOVSS blocking (T-bit task switch),
> 
> Howso?  MovSS prevents external interrupts from triggering task
> switches, but instruction sources still trigger in a shadow.

T-bit #DBs are traps, and arrive after the task switch has completed.  The switch
can be initiated in the shadow, but the #DB will be delivered after the instruction
retires and so after MOVSS blocking goes away.  Or am I missing something?

  The processor generates a debug exception after a task switch if the T flag of the
  new task's TSS is set. This exception is generated after program control has passed
  to the new task, and prior to the execution of the first instruction of that task.

> >  or are
> > already handled by KVM (ICEBP, a.k.a. INT1).
> 
> Other sources of #DB include RTM debugging, with errata causing a
> fault-style #DB pointing at the XBEGIN instruction, rather than
> vectoring to the abort handler

Ugh, I forgot about RTM.  That mess should also be mutually exclusive.  CLI/STI and
modifying segment registers cause abort, and XBEGIN in the shadow wouldn't activate
the region until XBEGIN retires and the shadow goes away.

> and splitlock which is new since I last thought about this problem.

Eww.  Split Lock is trap-like, which begs the question of what happens if the
MOV/POP SS splits a cache line when loading the source data.  I'm guess it's
suppressed, a la data breakpoints, but that'd be a fun one to test.

> > This bug was originally found by running tests[1] created for XSA-308[2].
> > Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
> > presumably why the Xen bug was deemed to be an exploitable DOS from guest
> > userspace.
> 
> As I recall, the original report to the security team was something
> along the lines of "Steam has just updated game, and now when I start
> it, the VM explodes".

Lovely.  I wonder if the game added some form of anti-cheat?  I don't suppose you
have disassembly from the report?  I'm super curious what on earth a game would
do to trigger this.

> >   KVM already handles ICEBP by skipping the ICEBP instruction
> > and thus clears MOVSS blocking as a side effect of its "emulation".
> >
> > [1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html
> 
> This URL is at the whim of doxygen and not necessarily stable.
> 
> https://xenbits.xen.org/gitweb/?p=xtf.git;a=blob;f=tests/xsa-308/main.c
> ought to have better longevity, as well as including test description.

Thanks!
