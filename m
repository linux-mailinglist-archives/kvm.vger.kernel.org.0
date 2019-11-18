Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB04100D48
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 21:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfKRUtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 15:49:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34603 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfKRUtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 15:49:00 -0500
Received: by mail-io1-f67.google.com with SMTP id q83so20473369iod.1
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 12:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lYUPL7LYiLpbPi62Bde1AvyYTd/DiPcC72K5qbOI79Q=;
        b=tLp0mDyhCWsmlvFSx/dRK982ALccECmnMaIW5vb4h2pOf7zB+DibalBCVnzvaEe6pj
         E5hZPEh3GaEpF0L589QNGtf3/DfzO1PfwabJrlax2XbAvL4npKCiCX7zzZbNFoU9gQzk
         +GpPwFDYiAtDOD/h8h+n4hZ/40LCsEs+H9LaiGO0swo48XE60CKxTjzemdre2YhFNOBZ
         EwXWYr5hKKP/lJ4yNVyusMRV6Hj2U0b+MGfG5+qmSnEvAEx62Z7XeLmdT7cUyW6ws4gv
         ayxGmjezQ7YfsSyKsZdakRize3JycjielCGP0IZfi4kFxE1LQpvSiPZGnaBhoHGF5nXe
         VRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lYUPL7LYiLpbPi62Bde1AvyYTd/DiPcC72K5qbOI79Q=;
        b=c81G0dvAxQwPpi+zlJ2AB6E+K4Str57bblTXEj0smUKVb5cVFLjkuovEz+wiJmdC9A
         NIpPbH/CBLFlETnjlo9KFc6bkD6N8uFYyqpEHMB+QcQF7bAKja28OCx69Ll+bk80/sql
         dwysa/BvEUDw6dVKImdJWWxuJOw0VQj0QAieW4865uDmE864V7df+exHOpp2+SF+vUlC
         5KYzegtT2VuLC27k7cYJSOGVkhZ9AKVoJ+ZQ2aF7J/MajlHj8/JzntCNv0odeG5ymnTS
         2gGldTfGvWHtEg+lsp4g0aESARvkxzS/DlyIzs4nKGX/j5FMmBVNBAEe3Hd8Y7OPpE9W
         Vziw==
X-Gm-Message-State: APjAAAVV5j/MzgSwaP2Zey9octeXSoQK9QeVTSx8+SrAVK28D0z2923J
        d0dednCGZXHshyYOfy1xurJ2W6l843bc1nSDnknj9Q==
X-Google-Smtp-Source: APXvYqwGxn84c5252LqX6hJfnqETNfYhJ9uz/KdjP2d70/w96bBvjpt32Dqlk8iAqTtojNrJFUpGf4G3NrE43KIsLDY=
X-Received: by 2002:a02:1d04:: with SMTP id 4mr15810607jaj.48.1574110139684;
 Mon, 18 Nov 2019 12:48:59 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 18 Nov 2019 12:48:48 -0800
Message-ID: <CALMp9eQRZv75kBiqAaugqhSLxSoiAb-1bBz3YTk-EyWb4gfBDw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM does not implement MSR_IA32_TSX_CTRL, so it must not be presented
> to the guests.  It is also confusing to have !ARCH_CAP_TSX_CTRL_MSR &&
> !RTM && ARCH_CAP_TAA_NO: lack of MSR_IA32_TSX_CTRL suggests TSX was not
> hidden (it actually was), yet the value says that TSX is not vulnerable
> to microarchitectural data sampling.  Fix both.
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Ignore my previous comment. I see that the functionality I want is
coming later in this series.

Reviewed-by: Jim Mattson <jmattson@google.com>
