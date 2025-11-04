Return-Path: <kvm+bounces-61943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFECFC2F68E
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 06:53:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53A2B3B7A8C
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 05:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F04128640B;
	Tue,  4 Nov 2025 05:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RePkx32Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E81448D5
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 05:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762235594; cv=none; b=L6+nyqCjzUlXRzm/zYlKi2WbWst9OHnW6lS+pvOaxPj6E2CpaaIiqNpOM+PgtWo++oGlKpwepjsG2cf9m1OfO4HzGNGjDXmTkEq36+g9lAxldJYKAWlxQVmeEcOWgCkYUbo1m2SvL29F81vYUMjMn5aU5KazQ+auwJ2Bld8jBgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762235594; c=relaxed/simple;
	bh=nz2jKsSewJdjve1TWZ5oTdnV5DPEjYvPSLTTEBQvjnk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iGpBsiS87DzNpiawer0lc8xPu2ihCgY+HgVqSbAD07AiS4oSp3HO8ShLYwpUEfJkyP43vCIErt6bY4gdK7NrdtZ5SUpkJ/+WWCTV8xPiPIL7hjpXLIBLJIWAR1+Y12CUh9HkCprb1L4jptcB54c7vb4ywR5r74/HENoiG5e+OSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RePkx32Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00B39C19422
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 05:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762235594;
	bh=nz2jKsSewJdjve1TWZ5oTdnV5DPEjYvPSLTTEBQvjnk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RePkx32YWbfqoiYlTsKlkjviWwQknSLBrU2se0Uwa1Kr0GWOFO63tnjic/w8Nd80p
	 QBxPsvb6/t7eWffhMVTZqL/4U0rfkO9C5++ldSWaIaWlTYHT4cFHINWz9hCAtUFP3Z
	 1VmFOdxMterkl07oTKmFbXD0y/uKSDjlJvmH/ybzPDTTgbjLAAqxES9EDdQAfI70rb
	 IEowgbwhDFLLx4j+gjt35SittV/a6/G9WTRM9XqAO9MNhFqHtkWyAhGWOZv8sY4rI/
	 BuYR5+xA/paX5eA8Agr9IVtECLRkbBUED5G+cBUFs74GwwU5r6MJ+UH+36ts+/1ifb
	 jH1gQee+jdDNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EF002C41616; Tue,  4 Nov 2025 05:53:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Tue, 04 Nov 2025 05:53:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220740-28872-nAV4ohjDds@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

--- Comment #4 from Chen, Fan (farrah.chen@intel.com) ---
(In reply to Alex Williamson from comment #2)
> (In reply to Chen, Fan from comment #1)
> > I reproduced this issue on SPR, GNR, SRF, CWF.
>=20
> Were there platforms that did not reproduce?

The only system I failed to reproduce is the one whose BIOS has no "Error
Injection Configuration" or "PCIE Error Enabling" is disabled. So I guess t=
his
issue is platform independent.

>=20
> > If we disable "PCIE Error Enabling" in BIOS, host will not crash.
> >=20
> > After bisecting, the first bad commit is:
> > commit 2b938e3db335e3670475e31a722c2bee34748c5a (HEAD)
> ...
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/io.h>
> >  #include <linux/vfio.h>
> >  #include <linux/vgaarb.h>
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> >=20
> >  #include "vfio_pci_priv.h"
>=20
> Theoretically this would only define non-atomic ioread64 and iowrite64
> support on a host that doesn't already have native support for these.  Any
> 64-bit x86_64 host should already define ioread/write64, so no change in
> behavior is expected or intended.  Can you provide the kernel .config and
> compiler information?

My host OS is Centos Stream 9, so the complier is from centos 9 release:
gcc-11.5.0-11.el9.x86_64
glibc-2.34-234.el9.x86_64
glibc-2.34-234.el9.i686

And to make sure I didn't use wrong .config, my .config is also from Centos
stream 9 default kernel, attached.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

