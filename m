Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466A6431A14
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhJRMxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhJRMxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 08:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 804B060FF2;
        Mon, 18 Oct 2021 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634561496;
        bh=wSAPygQazTQCxuDvZ0F3rHqQvWlL/kR4Uo4hpNZSHw0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BOSqgA/MH3tMfhEB9L562M5BHU1uTYoUIt8/LMzwgwy2F/MV55RnC1iZQmOYtdzhj
         /fwuYbnZ1cEGA+yQExXby+49sUFGNclVDm96J+vZzllszL1s03/ddB8BoRz1ikovyf
         mVd1VGZrv6gEzwJpZa9a2C9Yc1Yo0+t+5Q7kxo3NaIGSUol6viOWkdA+Jnehh6N3CC
         C4Vr4sTrlKEeys/LoOAtjKL30BnRCcLZMsQ/rnDotTJyDU/xEF6OO7wrOtLAVW4xhF
         +3vYBGEKazh7aqf+luCKGKtO6f6hRd5a9YtjJPx8W7so/j9wIbr/JpZtN+wtNK8zzh
         MT4YD5Xj4m9Xw==
Message-ID: <5f816a61bb95c5d3ea4c26251bb0a4b044aba0e6.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, bp@suse.de
Date:   Mon, 18 Oct 2021 15:51:33 +0300
In-Reply-To: <20211016071434.167591-1-pbonzini@redhat.com>
References: <20211016071434.167591-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2021-10-16 at 03:14 -0400, Paolo Bonzini wrote:
> Add to /dev/sgx_vepc a ioctl that brings vEPC pages back to uninitialized
> state with EREMOVE.=C2=A0 This is useful in order to match the expectatio=
ns
> of guests after reboot, and to match the behavior of real hardware.
>=20
> The ioctl is a cleaner alternative to closing and reopening the
> /dev/sgx_vepc device; reopening /dev/sgx_vepc could be problematic in
> case userspace has sandboxed itself since the time it first opened the
> device, and has thus lost permissions to do so.
>=20
> If possible, I would like these patches to be included in 5.15 through
> either the x86 or the KVM tree.
>=20
> Thanks,
>=20
> Paolo
>=20
> Changes from RFC:
> - improved commit messages, added documentation
> - renamed ioctl from SGX_IOC_VEPC_REMOVE to SGX_IOC_VEPC_REMOVE_ALL
>=20
> Change from v1:
> - fixed documentation and code to cover SGX_ENCLAVE_ACT errors
> - removed Tested-by since the code is quite different now
>=20
> Changes from v2:
> - return EBUSY also if EREMOVE causes a general protection fault
>=20
> Paolo Bonzini (2):
> =C2=A0 x86: sgx_vepc: extract sgx_vepc_remove_page
> =C2=A0 x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl
>=20
> =C2=A0Documentation/x86/sgx.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 35 =
+++++++++++++++++++++
> =C2=A0arch/x86/include/uapi/asm/sgx.h |=C2=A0 2 ++
> =C2=A0arch/x86/kernel/cpu/sgx/virt.c=C2=A0 | 63 +++++++++++++++++++++++++=
+++++---
> =C2=A03 files changed, 95 insertions(+), 5 deletions(-)
>=20

BTW, do you already have patch for QEMU somewhere, which uses
this new functionality? Would like to peek at it just to see
the usage pattern.

Also, can you provide some way to stress test QEMU so that this
code path gets executed? I'm already using QEMU as my main test
platform for SGX, so it's not a huge stretch for me to test it.

This way I can also provide tested-by for the corresponding QEMU
path.

/Jarkko
