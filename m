Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536C63D6B81
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 03:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhG0ApP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 20:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhG0ApP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 20:45:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F03C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 18:25:42 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m1so15504527pjv.2
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 18:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/t7f81wmDGE9gCk41v1NLLvWhSnv41AnaYKKhZPegeQ=;
        b=ZCvsBQewZ907UF3Ro1DLZ7PZByNA2KJqY0W5KZBeHARVf2pSvfuWo0/UpzW5IOP5Rq
         MKfoaMIuKidCUFJZVSr/kLhxBnckBso5CQrxEucrCRZUg3XrWtgsRjszBEkat/g8tmHI
         QG0jIQYGQ6/OfSaklFvphljMPZdkney/9f3um/CoYKMuiaDjT+tP90tz+mfbcEK5+BhA
         JhATmylKSCdz8hduBFM19J+sn93/1CMUkWpI7zl2vBzDSdKPS6CrG6Mmw2OLJmDb79SK
         cwJl+plrWbxUCcW9HGvpbi86VFYq3T04sC4tthEePLDoCxSFlv8avoro7yGcPc648uNz
         Fb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/t7f81wmDGE9gCk41v1NLLvWhSnv41AnaYKKhZPegeQ=;
        b=t2zoynOVStuF6h/xNjozQqmKzOLAVTzFlBunKpGnz7PSAkQ+O1j0fsJ6Vi5Ohyr24w
         hua3pCTrGARpht1iMkWBNpIYQDN+LtEWbms2En9ZkRxDhfcgheC1GN5S7cmPxR2nC7lA
         7iW34uW26NGkKsrfZtf7CVUfK3u5aywnICXWSF8p+10ipMYysvAOOpw/jpLqFsYLYBtG
         wzYOygseYR8ATQhq44VTxJb716ZzN+KE/sprDibG2Ho2zbsqMehul8XmeBGk3+klxhue
         TwF5RLGt6lQkPNUC1oCAqVwKH1k2nev8nwcneoKIT9q5jk5w+calGOgCDyERGZHksrWe
         /sRw==
X-Gm-Message-State: AOAM5327yRgjhhequoFooYMtMqUs/Qc6Laa32CqrJuIY6TPszLJdTklr
        PdOXkoUZE7Ik0kZfz4BcCFyhng==
X-Google-Smtp-Source: ABdhPJz890wTAonMOzNcvs3uodhfLYosNqjCzI0af1SDHIip2c6ld2PEFx1LJQf2b9AXimtwpxAdRw==
X-Received: by 2002:a65:6498:: with SMTP id e24mr20844452pgv.447.1627349141523;
        Mon, 26 Jul 2021 18:25:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k4sm798222pjs.55.2021.07.26.18.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 18:25:40 -0700 (PDT)
Date:   Tue, 27 Jul 2021 01:25:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] KVM: Consider SMT
 idle status when halt polling
Message-ID: <YP9gkSk+CHdKLP/Q@google.com>
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com>
 <4efe4fdb91b747da93d7980c10d016c9@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4efe4fdb91b747da93d7980c10d016c9@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021, Li,Rongqing wrote:
> > > > SMT siblings share caches and other hardware, halt polling will
> > > > degrade its sibling performance if its sibling is busy
> > >
> > > Do you have any real scenario benefits? As the polling nature, some
> > > cloud providers will configure to their preferred balance of cpu usage
> > > and performance, and other cloud providers for their NFV scenarios
> > > which are more sensitive to latency are vCPU and pCPU 1:1 pin，you
> > > destroy these setups.
> > >
> > >     Wanpeng
> > 
> 
> 
> Run a copy (single thread) Unixbench, with or without a busy poll program in
> its SMT sibling,  and Unixbench score can lower 1/3 with SMT busy polling
> program

Rather than disallowing halt-polling entirely, on x86 it should be sufficient to
simply have the hardware thread yield to its sibling(s) via PAUSE.  It probably
won't get back all performance, but I would expect it to be close. 

This compiles on all KVM architectures, and AFAICT the intended usage of
cpu_relax() is identical for all architectures.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6980dabe9df5..a07ecb3c67fb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3111,6 +3111,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
                                goto out;
                        }
                        poll_end = cur = ktime_get();
+                       cpu_relax();
                } while (kvm_vcpu_can_poll(cur, stop));
        }


