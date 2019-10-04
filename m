Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D496CBE45
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbfJDO5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389131AbfJDO5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:57:13 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 290C5222CA
        for <kvm@vger.kernel.org>; Fri,  4 Oct 2019 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570201032;
        bh=crFelfh0Sn/O8mB2YPt3Mozpd1WcKFo0ht7BKzHX6bI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZV9Uig7IsG0spaw0caqrW3Q2fqYoIacHVBgoYU9FOb8oSapqSp1DIJ4eSjY3x7Djd
         Y6/w8lYmZotuqGOqt2NQV+emn/oW5jSqjOMytuhXYCjGov35flVZxuxnYUaWGgU4f4
         1EZ5D/haZRb8VRyR5cSCjjUDAva2X/lFYafJDhAs=
Received: by mail-wr1-f50.google.com with SMTP id v8so7638626wrt.2
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 07:57:12 -0700 (PDT)
X-Gm-Message-State: APjAAAWvr20yRKhf0gacEjQw8Lrn6XF+R+p7s28F0HdRaFKc3As8g5Nd
        V373/uDAzPv/M7gX+SDGcujcKPFRYiJXx+DNnsTfJQ==
X-Google-Smtp-Source: APXvYqwknDFkFaJzo6VOtFntrB9U7DIZ2Bs13Lu1v1o7MImeIR75HTQyzSZPi+TJSharOuJdeBuc1fee3GNxv2jxmGM=
X-Received: by 2002:a5d:4647:: with SMTP id j7mr12415523wrs.106.1570201030525;
 Fri, 04 Oct 2019 07:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 4 Oct 2019 07:56:58 -0700
X-Gmail-Original-Message-ID: <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com>
Message-ID: <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 2:38 PM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> This patchset enables the ability for KVM guests to create execute-only (XO)
> memory by utilizing EPT based XO permissions. XO memory is currently supported
> on Intel hardware natively for CPU's with PKU, but this enables it on older
> platforms, and can support XO for kernel memory as well.

The patchset seems to sometimes call this feature "XO" and sometimes
call it "NR".  To me, XO implies no-read and no-write, whereas NR
implies just no-read.  Can you please clarify *exactly* what the new
bit does and be consistent?

I suggest that you make it NR, which allows for PROT_EXEC and
PROT_EXEC|PROT_WRITE and plain PROT_WRITE.  WX is of dubious value,
but I can imagine plain W being genuinely useful for logging and for
JITs that could maintain a W and a separate X mapping of some code.
In other words, with an NR bit, all 8 logical access modes are
possible.  Also, keeping the paging bits more orthogonal seems nice --
we already have a bit that controls write access.
