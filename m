Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13724FBC0
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2019 15:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfFWNPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jun 2019 09:15:23 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35881 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfFWNPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jun 2019 09:15:22 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so242150ioh.3
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2019 06:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oGBAVMzjO/rR0DdPnEAKQWgObypUtRNC5C7SVEEpyh0=;
        b=rYSvF9BZJ5M8ivt01DVcOMv9kGDH+ID+xWJsxc/V9D1Hebo6lEr1o8VdxZ2C+waoxA
         WrwNhfNM73618YgS8k0w/Nhfe+o5pN4LTHingdi59WX3Ut7yDSQx/fb15Cm/IXBf0u6l
         z2qfPPT4+oreEhFkWLka0akRs/73RzqlsAlY/dondQ6CY3h7KuZCgnKw4scg5+j93Wyl
         FsW7ARdi+tzqoCXJhHLXpxdSer/uEYHwKO7sq+ou964qS5GtoiyyH47MEPHTNOd4ytiQ
         VTJcx47Bo/PHULqZBlZd6sDmx9VdtqPyhEQpi/2uReoQCqEQFoNm5Pu9IgDFixfPcc2X
         G4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oGBAVMzjO/rR0DdPnEAKQWgObypUtRNC5C7SVEEpyh0=;
        b=PRpp1E8apRKuDSBydhGYQY8ol03r7/Bw1q+UIfwoWqaGvLBJYsywGH40lM+JMYpSf2
         2CumhVdl++qWEcnwBNCIYgabhVUzVmKTOppICQsbPRek8jHifxaaSJ3EhZGhQ74ioW84
         bxhVbLmrAkrEnP/J1xfXlNdOn75rttX8vzuU2OC9nVnfkSFd4uKQ/scF+2e4AdGpVvYJ
         Iy1H3s2PW0G4nqzQ9C1Z4ATHz5VuHxVdKloAqMZvGh/FDr0rfpt1DRH5U/0BoG+xAmQP
         lX9yVa8ljDTrLHm8LYW+emqRuBoL/L6UgXPCqzY6SpIRwuMSOCc6TjEHGbu/krlud1KW
         GDkA==
X-Gm-Message-State: APjAAAUjyGk1W+oSmx/dMhHzrXBvUl7x2o3kJcPt9coJ/8TI+Pm7CHLk
        Qxx+lSlesK1E1USm14/PtWWwtOg6Ptat4SfFkxa7WA==
X-Google-Smtp-Source: APXvYqyuVG6E3R7fQONRX5XyFNYlaFarskiAI1WT00v5gOo+hxtT9WEnH+uejdMVvJkZDWu0YkPSwoCbnRc2LX5DlBg=
X-Received: by 2002:a02:c7c9:: with SMTP id s9mr118924663jao.82.1561295721860;
 Sun, 23 Jun 2019 06:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic> <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic> <20190612205430.GA26320@linux.intel.com>
 <20190613071805.GA11598@zn.tnic> <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
 <20190618175153.GC26346@zn.tnic> <CACT4Y+bnKwniAikESjDckaTW=vE1hu8yc4DuoSFwP3qTS4NpmA@mail.gmail.com>
 <20190618182733.GD26346@zn.tnic>
In-Reply-To: <20190618182733.GD26346@zn.tnic>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 23 Jun 2019 15:15:10 +0200
Message-ID: <CACT4Y+ZKcbcZmMs_PMJuofieLeugkFjx6CDQertWYhxiF9aTvg@mail.gmail.com>
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
To:     Borislav Petkov <bp@alien8.de>
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM list <kvm@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 8:27 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Jun 18, 2019 at 08:01:06PM +0200, Dmitry Vyukov wrote:
> > I am not a KVM folk either, but FWIW syzkaller is capable of creating
> > a double-nested VM.
>
> Aaaha, there it is. :)
>
> > The code is somewhat VMX-specific, but it should
> > be capable at least executing some SVM instructions inside of guest.
> > This code setups VM to run a given instruction sequences (should be generic):
> > https://github.com/google/syzkaller/blob/34bf9440bd06034f86b5d9ac8afbf078129cbdae/executor/common_kvm_amd64.h
> > The instruction generator is based on Intel XED so it may be somewhat
> > Intel-biased, but at least I see some mentions of SVM there:
> > https://raw.githubusercontent.com/google/syzkaller/34bf9440bd06034f86b5d9ac8afbf078129cbdae/pkg/ifuzz/gen/all-enc-instructions.txt
>
> Right, and that right there looks wrong:
>
> ICLASS    : VMLOAD
> CPL       : 3
> CATEGORY  : SYSTEM
> EXTENSION : SVM
> ATTRIBUTES: PROTECTED_MODE
> PATTERN   : 0x0F 0x01 MOD[0b11] MOD=3 REG[0b011] RM[0b010]
> OPERANDS  : REG0=OrAX():r:IMPL
>
> That is, *if* "CPL: 3" above means in XED context that VMLOAD is
> supposed to be run in CPL3, then this is wrong because VMLOAD #GPs if
> CPL was not 0. Ditto for VMRUN and a couple of others.
>
> Perhaps that support was added at some point but not really run on AMD
> hw yet...


Interesting. I've updated to the latest Intel XED:
https://github.com/google/syzkaller/commit/472f0082fd8a2f82b85ab0682086e10b71529a51

And I actually see a number of changes around this for the VMX instructions:

 ICLASS    : VMPTRLD
-CPL       : 3
+CPL       : 0

 ICLASS    : VMXON
-CPL       : 3
+CPL       : 0

 ICLASS    : VMLAUNCH
-CPL       : 3
+CPL       : 0

But VMLOAD is still marked as CPL 3.
Perhaps it's something to fix in Intel XED. But for syzkaller it
should not matter much, it's a fuzzer and it will do all kinds of
crazy non-conforming stuff. These CPLs are only used as hints at best
if at all. It should sure try CPL=0 instructions in CPL3 regardless.
