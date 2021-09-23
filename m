Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDACF4166C2
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 22:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243122AbhIWUew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 16:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242950AbhIWUev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 16:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE60F6124B;
        Thu, 23 Sep 2021 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632429199;
        bh=YkmDnE85IjHnkDWWkjXDdnfUT/kZZuzCNUO/FR000kE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cAa3JUfbcGyh5R7mKyFITVqQ8PFKJbq3yhhGM+U2tKpULzikhwJArJyrKTNt0L3ft
         nVtvg9S53vwafH7H870IZLaZD35Z5HGR1zuDurEpgFjkipUJ2DZMN9iaL1vPyC/v3N
         JYA4PBdHHbeyRNj8kbs3ajUt9jdRJrOzE7NE2wJfohYhhXPgxz/GyYx+SdwqtHSD8U
         L/G2qRPrYbJJyp5mhRLqNjvK0hmGFzxR0ynHfPSyWcY/VHGlBU+3Z5rQJHxfVnGhq2
         twovQ9m6wenNwMjIBtSadiYnLQcBZ7RifewJRVzc7urB+Ytqg3eK50xIVIlhLTjKuq
         1Zvlq5kpmwg9w==
Message-ID: <46d9ee41d2a482b19b6a91b978b0154d4f0cbcaf.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Thu, 23 Sep 2021 23:33:16 +0300
In-Reply-To: <a0a2a628-62c5-d620-7714-2c28e4429e71@redhat.com>
References: <20210920125401.2389105-1-pbonzini@redhat.com>
         <20210920125401.2389105-2-pbonzini@redhat.com>
         <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
         <a0a2a628-62c5-d620-7714-2c28e4429e71@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-23 at 14:08 +0200, Paolo Bonzini wrote:
> On 21/09/21 21:44, Jarkko Sakkinen wrote:
> > "On bare-metal SGX, start of a power cycle zeros all of its reserved=
=20
> > memory. This happens after every reboot, but in addition to that=20
> > happens after waking up from any of the sleep states."
> >=20
> > I can speculate and imagine where this might useful, but no matter
> > how trivial or complex it is, this patch needs to nail a concrete
> > usage example. I'd presume you know well the exact changes needed for
> > QEMU, so from that knowledge it should be easy to write the
> > motivational part.
>=20
> Assuming that it's obvious that QEMU knows how to reset a machine (which=
=20
> includes writes to the ACPI reset register, or wakeup from sleep=20
> states), the question of "why does userspace reuse vEPC" should be=20
> answered by this paragraph:
>=20
> "One way to do this is to simply close and reopen the /dev/sgx_vepc file
> descriptor and re-mmap the virtual EPC.  However, this is problematic
> because it prevents sandboxing the userspace (for example forbidding
> open() after the guest starts, or running in a mount namespace that
> does not have access to /dev; both are doable with pre-opened file
> descriptors and/or SCM_RIGHTS file descriptor passing)."

Right, this makes sense.

>=20
> > Even to a Linux guest, since EPC should stil be represented in the
> > state that matches the hardware.  It'd be essentially a corrupted
> > state, even if there was measures to resist this. Windows guests
> > failing is essentially a side-effect of an issue, not an issue in the
> > Windows guests.
>=20
> Right, Linux is more liberal than it needs to be and ksgxd does the=20
> EREMOVE itself at the beginning (__sgx_sanitize_pages).  Windows has=20
> stronger expectations of what can and cannot happen before it boots,=20
> which are entirely justified.
>=20
> Paolo

Yep. We do it for kexec(). Alternative would be to zero at the time
of kexec() but this way things are just way more simpler, e.g. the
whole behaviour is local to the driver...

/Jarkko
