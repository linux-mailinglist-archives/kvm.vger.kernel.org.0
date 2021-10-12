Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BAC42AA11
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJLQzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhJLQzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5901561076;
        Tue, 12 Oct 2021 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634057627;
        bh=bdYGI9lrx6Tnzb5nNPVXo02uugTxR7LDtvCKQbRJrTg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rc+ZLr1kvmuvQrn90U9XVb1z84w5AebJQZ1IfVNAbutk09wV3W4S/UDhG7Yh63f7/
         90JE8ahZHw8ozEKr5PchAIAJP0wfguSk41uOLZy6Hs6KrRixonY10vXDQmes7fr8UO
         csG+nQkuMU041zIv9QeUe0GfljwLhilNCDGrm+H8drkAbbfB54Gbov1bLDaAKq8IIV
         X5644lRcWqiYx6/brEP1VIeczRC3P2z7oOBHqn0FqZaCDwoxNJFIySqkcNgCfvK1Py
         YbKhvcd4ICLMs2JDB0/ErJgdEv2j8qwfeNHtAG4RV4cphE9AE7BpujTMgw90Qyutvj
         /J1eUX1vIzAUA==
Message-ID: <7a456461cd1a23f5b8a3116d44e5b94db5f68826.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com
Date:   Tue, 12 Oct 2021 19:53:45 +0300
In-Reply-To: <20211012105708.2070480-2-pbonzini@redhat.com>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
         <20211012105708.2070480-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-10-12 at 06:57 -0400, Paolo Bonzini wrote:
> For bare-metal SGX on real hardware, the hardware provides guarantees
> SGX state at reboot.=C2=A0 For instance, all pages start out uninitialize=
d.
> The vepc driver provides a similar guarantee today for freshly-opened
> vepc instances, but guests such as Windows expect all pages to be in
> uninitialized state on startup, including after every guest reboot.
>=20
> One way to do this is to simply close and reopen the /dev/sgx_vepc file
> descriptor and re-mmap the virtual EPC.=C2=A0 However, this is problemati=
c
> because it prevents sandboxing the userspace (for example forbidding
> open() after the guest starts; this is doable with heavy use of SCM_RIGHT=
S
> file descriptor passing).
>=20
> In order to implement this, we will need a ioctl that performs
> EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
> other possibilities, such as closing and reopening the device,
> are racy.
>=20
> Start the implementation by creating a separate function with just
> the __eremove wrapper.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0v1->v2: keep WARN in sgx_=
vepc_free_page
>=20
> =C2=A0arch/x86/kernel/cpu/sgx/virt.c | 12 +++++++-----
> =C2=A01 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/vir=
t.c
> index 64511c4a5200..59cdf3f742ac 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -111,10 +111,8 @@ static int sgx_vepc_mmap(struct file *file, struct v=
m_area_struct *vma)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0}
> =C2=A0
> -static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> +static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Take a previously gues=
t-owned EPC page and return it to the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * general EPC page pool.
> @@ -124,7 +122,12 @@ static int sgx_vepc_free_page(struct sgx_epc_page *e=
pc_page)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * case that a guest prop=
erly EREMOVE'd this page, a superfluous
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * EREMOVE is harmless.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D __eremove(sgx_get_epc_=
virt_addr(epc_page));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return __eremove(sgx_get_epc_v=
irt_addr(epc_page));
> +}
> +
> +static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret =3D sgx_vepc_remove_pa=
ge(epc_page);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * Only SGX_CHILD_PRESENT is expected, which is bec=
ause of
> @@ -144,7 +147,6 @@ static int sgx_vepc_free_page(struct sgx_epc_page *ep=
c_page)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_free_epc_page(epc_pag=
e);
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0}
> =C2=A0

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

