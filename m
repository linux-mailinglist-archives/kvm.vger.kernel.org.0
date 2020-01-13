Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457E7139D19
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 00:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAMXG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 18:06:28 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34145 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgAMXG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 18:06:28 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so5604747pfc.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 15:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+g7O5egqdF8iI9aeovacSaUjyiYi7qPnHk0ZDx6IymA=;
        b=RhlDl4RcVnEazVF40UJPtKzOvlz1TMXRlyeVzNxwg3p3ib1Zzp+8HEEbfIt+5JpovJ
         TT5R3MaAaHpd94k9IN1fZ0ElcUR/Fyr4OZo3gKw/hUAjpN+mHA8TOwubaXlkTZfjD2R4
         lCOo4BngWgIX9VxugVlCPmrv0uf4J910rdzf9x5Jt4JdD05xsArJ6jSJ0zGfEN5uR3wy
         ANknro1Y6XIIMsqkCyPgXbG6qPcZhcBm9rf+86HGkPFUcsfmQtn/VxuSdRUTIrqueg+f
         Y9o8P7IGaRmJTZgawHxl5efOFaUxKQTmzIDCvl+uv4SrUQOUwXp+HjFuyYvv19bzWdkd
         rKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+g7O5egqdF8iI9aeovacSaUjyiYi7qPnHk0ZDx6IymA=;
        b=Q4ky73JWLaPeptw6JpLf1hAihbfxj9GKDMtxHq/LFqF3mvQYl0g8p5f8zKjCeZpzYa
         EKJc7p2C5Saug7jMYrwco5+ZzfONDB3QUysKyLOM0X/Y4hYB3XVr4VS4uOSsejLeY66v
         kppBejpTixZ9oBMPUjnuM5G6z0g86s46gSl7XfOFYAXFFAXJjNVUeenWBqJ4yI7kB9gf
         ycMhIjVlSqxKu7fypmB5qTZu0GisUIHOTkKohqMmOBV9ecCyKlK2Mrm3om6ralKJEgvB
         9mt5a1+BbcGoH21tTomRpumJhJtgy359PojjcSIhRlzIeC1r8bPbsVxXg8awRO9tmXFt
         VibA==
X-Gm-Message-State: APjAAAWe+PVihGQ3obrjQOpmmFMrcpJGySnWQDHCuQohni3207rgczUE
        cpHlh56Imsyw2IIiX2VuJV5ZZQ==
X-Google-Smtp-Source: APXvYqzyEyQDYFMpqcBL4/LeFRFFgW2Qg11Eg0+Z2OMCbJS2bbEUh4n1uk6qV4ozxZlZWqOdeA3B2A==
X-Received: by 2002:aa7:86d4:: with SMTP id h20mr21161690pfo.232.1578956787632;
        Mon, 13 Jan 2020 15:06:27 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id u26sm14791921pfn.46.2020.01.13.15.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 15:06:26 -0800 (PST)
Date:   Mon, 13 Jan 2020 15:06:22 -0800
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] Handle monitor trap flag during instruction emulation
Message-ID: <20200113230622.GA43583@google.com>
References: <20200113221053.22053-1-oupton@google.com>
 <20200113223504.GA14928@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113223504.GA14928@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 02:35:04PM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2020 at 02:10:50PM -0800, Oliver Upton wrote:
> > KVM already provides guests the ability to use the 'monitor trap flag'
> > VM-execution control. Support for this flag is provided by the fact that
> > KVM unconditionally forwards MTF VM-exits to the guest (if requested),
> > as KVM doesn't utilize MTF. While this provides support during hardware
> > instruction execution, it is insufficient for instruction emulation.
> > 
> > Should L0 emulate an instruction on the behalf of L2, L0 should also
> > synthesize an MTF VM-exit into L1, should control be set.
> > 
> > The first patch fixes the handling of #DB payloads for both Intel and
> > AMD. To support MTF, KVM must also populate the 'pending debug
> > exceptions' field, rather than directly manipulating the debug register
> > state. Additionally, the exception payload associated with #DB is said
> > to be compatible with the 'pending debug exceptions' field in VMX. This
> > does not map cleanly into an AMD DR6 register, requiring bit 12 (enabled
> > breakpoint on Intel, reserved MBZ on AMD) to be masked off.
> > 
> > The second patch implements MTF under instruction emulation by adding
> > vendor-specific hooks to kvm_skip_emulated_instruction(). Should any
> > non-debug exception be pending before this call, MTF will follow event
> > delivery. Otherwise, an MTF VM-exit may be synthesized directly into L1.
> > 
> > Third patch introduces tests to kvm-unit-tests. These tests path both
> > under virtualization and on bare-metal.
> > 
> > Oliver Upton (2):
> >   KVM: x86: Add vendor-specific #DB payload delivery
> >   KVM: x86: Emulate MTF when performing instruction emulation
> > 
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/svm.c              | 25 +++++++++++++++++++++
> >  arch/x86/kvm/vmx/nested.c       |  2 +-
> >  arch/x86/kvm/vmx/nested.h       |  5 +++++
> >  arch/x86/kvm/vmx/vmx.c          | 39 ++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/x86.c              | 27 ++++++-----------------
> >  6 files changed, 78 insertions(+), 22 deletions(-)
> > 
> > -- 
> 
> What commit is this series based on?  It doesn't apply cleanly on the
> current kvm/master or kvm/queue.

Blech. I use torvalds/master for initial review before sending out (woo,
Gerrit!). Seems I sent out my set based on torvalds, not kvm. I'll
rebase in v2 (while addressing your comments).

Thanks for the prompt reply, Sean :)

--
Best,
Oliver
