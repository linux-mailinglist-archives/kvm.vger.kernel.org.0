Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E69189092
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 22:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCQVei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 17:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgCQVeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 17:34:36 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2E82076C
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 21:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584480875;
        bh=FU6/YhzHCy5DWzCb2Jjd6xpKYKIlYfn0Nkn8S0an218=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aaAKrQvr1UPKXoqSl2Xez3aX9YvAC2YlC+m1eLZNTBLgDh8s1vRjXMcwG3x4vnBM5
         TTa5g/gdhOFRAZ1DFOxjMw7JMMKwzmTdHJS3CXSqETyMXBoHn2YbAFrjzXNVBR7bjQ
         lFXC0+JRfZOZDujzOCrU1X4Iz1w2OacosqTLJYCg=
Received: by mail-wr1-f41.google.com with SMTP id f3so20712211wrw.7
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 14:34:35 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0io+DojFaqAXFyqJlbpNfginc4DH+a3C6IvL1cFOSfg0URqVY1
        rG++2CNXqPf9zG1V96puBRmACACjL87Hrd4bJPGnZQ==
X-Google-Smtp-Source: ADFU+vtGXARxy1KWOouUhaZnISUK705uJFt7DrOok2Eu+G2fu4TjnS61RAdWYoQTjxk7jomgV/TRyqL9G7ZtF7EGMwA=
X-Received: by 2002:adf:9dc6:: with SMTP id q6mr1062310wre.70.1584480873869;
 Tue, 17 Mar 2020 14:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-39-joro@8bytes.org>
 <CALCETrVRmg88xY0s4a2CONXQ3fgvCKXpW2eYJRJGhqQLneoGqQ@mail.gmail.com> <20200313091221.GA16378@suse.de>
In-Reply-To: <20200313091221.GA16378@suse.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 17 Mar 2020 14:34:22 -0700
X-Gmail-Original-Message-ID: <CALCETrX74dJEXd7OxZZ=2sPy8nOjqO5Lzjt04VrxP0TYgTXnUg@mail.gmail.com>
Message-ID: <CALCETrX74dJEXd7OxZZ=2sPy8nOjqO5Lzjt04VrxP0TYgTXnUg@mail.gmail.com>
Subject: Re: [PATCH 38/62] x86/sev-es: Handle instruction fetches from user-space
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 2:12 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> On Wed, Feb 12, 2020 at 01:42:48PM -0800, Andy Lutomirski wrote:
> > I realize that this is a somewhat arbitrary point in the series to
> > complain about this, but: the kernel already has infrastructure to
> > decode and fix up an instruction-based exception.  See
> > fixup_umip_exception().  Please refactor code so that you can share
> > the same infrastructure rather than creating an entirely new thing.
>
> Okay, but 'infrastructure' is a bold word for the call path down
> fixup_umip_exception().

I won't argue with that.

> It uses the in-kernel instruction decoder, which
> I already use in my patch-set. But I agree that some code in this
> patch-set is duplicated and already present in the instruction decoder,
> and that fixup_umip_exception() has more robust instruction decoding.
>
> I factor the instruction decoding part out and make is usable for the
> #VC handler too and remove the code that is already present in the
> instruction decoder.

Thanks!

>
> Regards,
>
>         Joerg
>
