Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A4B413AE4
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 21:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhIUTpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 15:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232145AbhIUTpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 15:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9158160EC0;
        Tue, 21 Sep 2021 19:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632253455;
        bh=FhR19ytvM6PIvdn64c/rO/2ncDXvthf5GNYXiJGVTIU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uoeGFOXH+i0E4o+FWimGM9wwW8JvLiLkVyqEUH9T9XUbIda3I9Fw/LsvhjPReJ8pN
         6KTtmrx0lJAmSuYrhe/x5Bba8Z38qnuBMZll01ot3PGIZN8O2AW7opmRukrBGZk62T
         fx5vGG+hiE7HgfprofLwW0XdSNe0LnQgwuRvxmePivwTZ2KIdM2YaA9bBkCSqxT1d/
         ++A4yvctTY8EiZWy/Aiu2IJbPTx2+VtXDr588VW+z8kejOvczXHQ5phzh2BqOh0EqL
         bnsucek6YxGI6i/ac6JHmupJBz5gZgDtYptM4mUwjcrzm3CuJIU+6CyYiG6t3m9A23
         N8Xt/9C56gqtQ==
Message-ID: <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 21 Sep 2021 22:44:12 +0300
In-Reply-To: <20210920125401.2389105-2-pbonzini@redhat.com>
References: <20210920125401.2389105-1-pbonzini@redhat.com>
         <20210920125401.2389105-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-20 at 08:54 -0400, Paolo Bonzini wrote:
> For bare-metal SGX on real hardware, the hardware provides guarantees
> SGX state at reboot.  For instance, all pages start out uninitialized.
> The vepc driver provides a similar guarantee today for freshly-opened
> vepc instances, but guests such as Windows expect all pages to be in
> uninitialized state on startup, including after every guest reboot.

I would consider replacing

"For bare-metal SGX on real hardware, the hardware provides guarantees
SGX state at reboot.  For instance, all pages start out uninitialized."

something like

"On bare-metal SGX, start of a power cycle zeros all of its reserved
memory. This happens after every reboot, but in addition to that
happens after waking up from any of the sleep states."

I can speculate and imagine where this might useful, but no matter how
trivial or complex it is, this patch needs to nail a concrete usage
example. I'd presume you know well the exact changes needed for QEMU, so
from that knowledge it should be easy to write the motivational part.

For instance, point out where it is needed in QEMU and why. I.e. why
you end up in the first place having to re-use vepc buffers (or whatever
they should be called) in QEMU. When that is taken care of, then there is
a red line to eventually ack these patches.

About the motivation.

In Linux we do have a mechanism to take care of this in a guest, for which
motivation was actually first and foremost kexec. It was not done to let VM=
M to
give a corrupted memory state to a guest.

Even to a Linux guest, since EPC should stil be represented in the state th=
at
matches the hardware.  It'd be essentially a corrupted state, even if there=
 was
measures to resist this. Windows guests failing is essentially a side-effec=
t
of an issue, not an issue in the Windows guests.

Since QEMU needs to reinitialize VEPC buffers for guests, it should be as
efficient as we ever can make it. Just fill the gap of understanding why
QEMU needs to do this for guest. This is exactly kind of stuff that you wan=
t
have documented in the commit log for future :-)

/Jarkko

