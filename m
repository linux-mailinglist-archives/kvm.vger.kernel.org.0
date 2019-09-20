Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CD6B99AF
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 00:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404323AbfITWaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 18:30:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37659 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393794AbfITWai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 18:30:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id f16so3621298wmb.2
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 15:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCswEUwj4W7Dbskrcn4907vUH6z/nmOrrNzOO3cw/xM=;
        b=vLbckBQMd1qvK4UrYtluk5vaGK0rG/DTolALQE4nz+PePUHhOdqNEQSjhZUxVC39CC
         DXXIjjG150p1RD+MnVcFh+JGDYQO4HPl8aDXUKlT2ilFOmZbExTVwoT1YtvDbnRGQW+L
         a63JrAia2PzyIuukgvkSWs1v7P+BSpRW+lzA0mPb/qq/CdhRV+0ntjpkMJEgSMdQBpuc
         kJG2AGfw8XiTo3xix+JvJAhj0rnZUe4sb7iM5drKgTnHZdsEWESqe4HWg4mp/Ej5mrQM
         fo9leEJ97dt5LoVDKH4M5WvHEDkLaZxVVAzNVbINM3IGqBHZMs3m7GvkrN0iIoW9pozh
         NYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCswEUwj4W7Dbskrcn4907vUH6z/nmOrrNzOO3cw/xM=;
        b=LQe2QJtLIe2yOTpP5RcrP42FlJyp6THvVnMQV5LOghSUCJpDPwNUHz9rZu2ClFcll/
         ePSqtWnQNhZkSEKrE20WIcF48rVxVWD1pyAiVvtRXzOuT1S1iQgMXGHAAZp6OKfXRzUJ
         QGvLwihA5pWz9r157sCjlu0PO/6zG85NMxQj2hTmK1USSnWbUHW6LoDREk4T7geFWRCc
         bwmf/CoqW0Xqgyh1PzCJFxbZS4ic8rdQ9/3ZZFPf5vVjGT+NGTiU+oCoaaT8CGBKoWVS
         GgT/JimrEohZhENjCOq/JDR7lCEaFv65LF4yANAPWLu0wMMIfFox1ISEwLWbuP639g8z
         ppyA==
X-Gm-Message-State: APjAAAU++EwYGOWU8ZwQenbx26a2K/vs06ZJR+Cb0e9D+clWI21m1MG7
        wydFCBDa0saDy1dLO3P77NgXyNbBgHpf7q97Va9tkg==
X-Google-Smtp-Source: APXvYqzKVy4RotWahJKFfj19JkP5ci+ELFTJoGOJc07MryxOHrj7XJosZDcfVndOUdHt8I+p8SbtY33xTv/4tZTxUhs=
X-Received: by 2002:a1c:7509:: with SMTP id o9mr4982807wmc.21.1569018635044;
 Fri, 20 Sep 2019 15:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190918222354.184162-1-marcorr@google.com> <20190918222354.184162-2-marcorr@google.com>
 <20190919202235.GE30495@linux.intel.com>
In-Reply-To: <20190919202235.GE30495@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Sep 2019 15:30:22 -0700
Message-ID: <CAA03e5FKc+jxWAUNsRnsf=+uLRihmLU8aSnfgMZ4CRYu1c1rSQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/2] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void atomic_switch_msr_limit_test_guest(void)
> > +{
> > +     vmcall();
>
> I finally dug into the weird double-enter_guest().  Rather than re-enter
> the guest to cleanup, just remove this vmcall() so that the first VM-Enter
> invokes hypercall() with HYPERCALL_VMEXIT to set guest_finished.
>
> enter_guest() will verify VM-Enter succeeded, and the guest_finished check
> verifies the guest did a VMCALL.  I don't see any added value in an extra
> VMCALL.

Done. To be consistent with Krish's review, I utilized the existing
v2_null_test_guest() function, which is empty.

> > +     if (count <= max_allowed) {
> > +             enter_guest();
> > +             skip_exit_vmcall();
>
> If vmcall() is removed, this skip and the one in the else{} can be dropped.

Done.

> > +             /*
> > +              * Re-enter the guest with valid counts
> > +              * and proceed past the single vmcall instruction.
> > +              */
>
> Nit: "Re-enter the guest" should either be "Retry VM-Enter" or simply
>      "Enter".  The reason this code exists is that we never actually
>      entered the guest :-)
>
>      E.g. if you drop the vmcall():
>
>                 /* Enter the guest (with valid counts) to set guest_finished. */

Done.
