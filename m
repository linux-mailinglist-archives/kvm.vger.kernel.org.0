Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F97325797
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhBYU0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhBYU0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:26:07 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B62CC0617A9
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:25:19 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t26so4588919pgv.3
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JOqIuOkYNfNei5S5ihkPvqbXAibk+FpZz0aihINz3pA=;
        b=Pv5QWFcnDMm6MJn96nAMy7sFslYSo2nDr7i/1/MdPjuHpBXAqOkl0BNvKi0vaEX3R+
         gjsmeuwFfEdF9VzDgG0anLrMVRCTAuWdX1q5gMt9kpRa7sR2PXDxxWCuTilew+CUEqg7
         VLechlXjwuNe04aXiUbr4WCoW0ZGtFJgv/7gF9vwUDEd/MzbOclVdcCI/Ej7dz2T/C4T
         CkiU1V1awnNDPewhPLgRkRgrRvImVbHtBY9WXUP1w3CJafgkfLXdaJxpyzyV311ZmEp9
         EZSbtEjV/iBpA+H4LMkrRB9c1DdWw/wghBswPcAfE/UaRNghQrgpZpALBCvqTm3+ZOg/
         MqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JOqIuOkYNfNei5S5ihkPvqbXAibk+FpZz0aihINz3pA=;
        b=JpzWN34Y9yOoIU8t5iqpIAynGHPHt6g03v9Z4rdd2m84r52dp9SIYK7otf2UYdegXP
         iog2QZBIOd22fvVN1b8YyRcQp2+wGg4R0zd0CVc0wuxPBlCEpYLk+tNbfAj93Z/MS7jH
         878d2qpRQCnrhyDNCaIClyqGhnBBAU3zvnkvgcVoO2CQ4Of8FYrPpvUslthLJWtcLdSY
         BqnQIX/DEB3iw9MQsiCGa0wT95gC4iC8dUZn9lbxCHgAkBfPjhSzUMwSerKSyazyS5bv
         O55fMMpNP74xZlDtdyaYYKcu6kUcgT+xgSFmFjqoep77rVa4Jl7FKLUuMbr0zD0PaeX9
         Q/QQ==
X-Gm-Message-State: AOAM532ARSdrPh7THdaSh+MQCo78mxPSAtIu8UdBR1H/oXCCcqN4ATDt
        Ua5nIHYE93FsuCTphzthTYeFOg==
X-Google-Smtp-Source: ABdhPJy+cnuWew3jHbZvwLPnxU5cM+OFZqtAAV1VFVzsI3ExMI5mkd/Cf4oGUQ9jez7G4itguiu9Dw==
X-Received: by 2002:a62:ed01:0:b029:1c8:c6c:16f0 with SMTP id u1-20020a62ed010000b02901c80c6c16f0mr4866061pfh.80.1614284718762;
        Thu, 25 Feb 2021 12:25:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
        by smtp.gmail.com with ESMTPSA id h5sm6660099pgv.87.2021.02.25.12.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:25:18 -0800 (PST)
Date:   Thu, 25 Feb 2021 12:25:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        the arch/x86 maintainers <x86@kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
Message-ID: <YDgHp8iTW1NQVJD/@google.com>
References: <0000000000007ff56205ba985b60@google.com>
 <00000000000004e7d105bc091e06@google.com>
 <20210224122710.GB20344@zn.tnic>
 <CACT4Y+ZaGOpJ1+dxfTVWhNuV5hFJmx=HgPqVf6bqWE==7PeFFQ@mail.gmail.com>
 <20210224174936.GG20344@zn.tnic>
 <YDaV+ThL4c+vTo4e@google.com>
 <CACT4Y+ZMdxYdh_VcGLyq_pFDvD0RNbHcKZKcAd=BRu+yzq5z2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZMdxYdh_VcGLyq_pFDvD0RNbHcKZKcAd=BRu+yzq5z2Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021, Dmitry Vyukov wrote:
> On Wed, Feb 24, 2021 at 7:08 PM 'Sean Christopherson' via
> syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Wed, Feb 24, 2021, Borislav Petkov wrote:
> > > Hi Dmitry,
> > >
> > > On Wed, Feb 24, 2021 at 06:12:57PM +0100, Dmitry Vyukov wrote:
> > > > Looking at the bisection log, the bisection was distracted by something else.
> > >
> > > Meaning the bisection result:
> > >
> > > 167dcfc08b0b ("x86/mm: Increase pgt_buf size for 5-level page tables")
> > >
> > > is bogus?
> >
> > Ya, looks 100% bogus.
> >
> > > > You can always find the original reported issue over the dashboard link:
> > > > https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
> > > > or on lore:
> > > > https://lore.kernel.org/lkml/0000000000007ff56205ba985b60@google.com/
> > >
> > > Ok, so this looks like this is trying to run kvm ioctls *in* a guest,
> > > i.e., nested. Right?
> >
> > Yep.  I tried to run the reproducer yesterday, but the kernel config wouldn't
> > boot my VM.  I haven't had time to dig in.  Anyways, I think you can safely
> > assume this is a KVM issue unless more data comes along that says otherwise.
> 
> Interesting. What happens? Does the kernel crash? Userspace crash?
> Rootfs is not mounted? Or something else?

Not sure, it ended up in the EFI shell instead of the kernel (running with QEMU's
-kernel).  My QEMU+KVM setup does a variety of shenanigans, I'm guessing it's an
incompatibility in my setup.
