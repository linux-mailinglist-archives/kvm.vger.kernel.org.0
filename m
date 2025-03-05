Return-Path: <kvm+bounces-40158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59144A5018D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81912170C59
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7AF24BC03;
	Wed,  5 Mar 2025 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="fUhr+fZd";
	dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="VEbEw3V/"
X-Original-To: kvm@vger.kernel.org
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866E0155751;
	Wed,  5 Mar 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741184096; cv=pass; b=h5hWlc4JTOhekmmxoPeH0g9kaooQ+dbeqfEmZH8zAP7bbpenQXHEkK/K/FgM1yOKCm3MVgJ2KxTeEAwAU8gn2Reuq2A3wKA71/XEQgqkCT69kMggMah7gozSYv4XQya10/59RMjP91o+b3/2nn+dNUB98FnvkK0hEHfSa8Au3FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741184096; c=relaxed/simple;
	bh=aWOrg0kFCs07mvG7SMft2khd/jNHqHiEbXdDYsIZw5U=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=AvLJWXlcqeKXUmpOea3Qtu/toBTB65Jnwn3o11TF8jV2+SAjIdgA67lqAGRw+a8378vp8HU8iouHtrJ7ViDhy80Jgsbatk/SCwK7J6dzYQfEBkXQ8iT1KuiFzS3vxIeVwovd04a49izYqQjwPZASI8ndms0lFYBBPpRxq5Q4ss8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de; spf=none smtp.mailfrom=xenosoft.de; dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=fUhr+fZd; dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=VEbEw3V/; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=xenosoft.de
ARC-Seal: i=1; a=rsa-sha256; t=1741184065; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=CWDaimXSwk1sUD60tEP0N53EtqW1F95Qgk/sD3IZShhOFHvPeXIYxB3HtC1O/ITF+B
    V5vGlTsRd8Nb60t++0cAhO7qLZhlbmllEoCYZcAzwwuYIsEojFoW9rzaFbzPdhxSPmBb
    jhJT2kQ+MT3HyP/bUME3ARa/FI5FYtmj3fyq9+S8dnmD8Mkb1/sm7nr8i0Cm6pcMryVQ
    rIHeNo/9MggU1Dduuvo6m4/P66bePfKRC+KEYO1BPq6IIUeCjJ3ea72np6nPhRpa+gGa
    kMwbXI+UhsEINWsgAMJMipg7yTMEyNJnZYuLBi4W14KqrjvAReGSCCq27gpQXWemYnd0
    p9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1741184065;
    s=strato-dkim-0002; d=strato.com;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=XG+agOvW8ppEzopPxKXPNXl9FwqxrC3qL6otfZY6Dvg=;
    b=KGgVBEjIz52vYzYAPtj1IaG+RFhJaIx6Xr8IZEgvMZ6ZyP8Ub+rsGSUusZYo+GrvOe
    PIF4ynLeSI9C5yV8nuD6i/fEf8TRWoNGV7f84X0gv3IpZFZJCfDw+WgLla/YXGc2mfUN
    YdynFpiRDuQi0MERFBCLdnRGq84MmaibU/Vehxa9QyVevVTFwO1vEINFkXy8w6O4324X
    kNv5ato72i+9vb2iIH1+IRbxPi4kpBdPLRjtvzQZcnyZQIiQdRTYO9B9ccE1qwZzLNWO
    TT8/0oQe4CYVJ+Xz08Li9Aom4utxR4fHn6153q2KSPtL4vXahQHpKsMuwugtIyyQOsHH
    6jWA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1741184065;
    s=strato-dkim-0002; d=xenosoft.de;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=XG+agOvW8ppEzopPxKXPNXl9FwqxrC3qL6otfZY6Dvg=;
    b=fUhr+fZdAUFqeeHI5Oj6gCyIZ7DKOIF0Si4KnTCNnzDVy/1E8xwUVCXQp1G26IkPBd
    cfmQGQtt8FycM9BYf5ascZy1JarpwGoYg70a3AC7yH0LvcC3ERGRm6Mw3NgBUoZQA0O3
    1pgDlE3ykIgrNB3huyq0B6wQ+MyvEES+eqen6b9lyL0ReoaQPs1ht8EpKBDL8aR3SJQh
    z/S5WgovSOd5FVK5IZtR6gHgT5r9o3tk9v0tnEk1wUDOmlhzLXb/OOwHBbhRqD3Zg9P9
    OSbPtfHXtmDdQoEJmslHtSHsujSBL18ekSj/Ci+KcRIf3gdqmFjr16MEAYf0MiB3/K97
    x+mg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1741184065;
    s=strato-dkim-0003; d=xenosoft.de;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=XG+agOvW8ppEzopPxKXPNXl9FwqxrC3qL6otfZY6Dvg=;
    b=VEbEw3V/vVNB/Bx0MOVubiCRR4pqIA9VSi92Emrv6RNVDNnP12qsPKxZLFuko8ZQGL
    KgfkUAqhQ14RVHRvioCA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr6KxrfO5Oh7V7VZrgs3iXAXqZnhDuuhhnGfQQmpdNZeQ5Fv1TtRo="
Received: from smtpclient.apple
    by smtp.strato.de (RZmta 51.3.0 AUTH)
    with ESMTPSA id e2a9e4125EEO3YE
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 5 Mar 2025 15:14:24 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From: Christian Zigotzky <chzigotzky@xenosoft.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: [Kernel 6.12.17] [PowerPC e5500] KVM HV compilation error
Date: Wed, 5 Mar 2025 15:14:13 +0100
Message-Id: <DDEA8D1B-0A0F-4CF3-9A73-7762FFEFD166@xenosoft.de>
References: <20250112095527.434998-4-pbonzini@redhat.com>
Cc: Trevor Dickinson <rtd2@xtra.co.nz>,
 mad skateman <madskateman@gmail.com>, hypexed@yahoo.com.au,
 Darren Stevens <darren@stevens-zone.net>
In-Reply-To: <20250112095527.434998-4-pbonzini@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, seanjc@google.com, linuxppc-dev@lists.ozlabs.org,
 regressions@lists.linux.dev, Greg KH <greg@kroah.com>
X-Mailer: iPhone Mail (22D72)

Hi All,

The stable long-term kernel 6.12.17 cannot compile with KVM HV support for e=
5500 PowerPC machines anymore.

Bug report: https://github.com/chzigotzky/kernels/issues/6

Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/x5000=
_defconfig

Error messages:

arch/powerpc/kvm/e500_mmu_host.c: In function 'kvmppc_e500_shadow_map':
arch/powerpc/kvm/e500_mmu_host.c:447:9: error: implicit declaration of funct=
ion '__kvm_faultin_pfn' [-Werror=3Dimplicit-function-declaration]
   pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
         ^~~~~~~~~~~~~~~~~
  CC      kernel/notifier.o
arch/powerpc/kvm/e500_mmu_host.c:500:2: error: implicit declaration of funct=
ion 'kvm_release_faultin_page'; did you mean 'kvm_read_guest_page'? [-Werror=
=3Dimplicit-function-declaration]
  kvm_release_faultin_page(kvm, page, !!ret, writable);

After that, I compiled it without KVM HV support.

Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/e5500=
_defconfig

Please check the error messages.

Thanks,
Christian=


