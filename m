Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB951EB69A
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBHgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 03:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFBHgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 03:36:00 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25A1C061A0E;
        Tue,  2 Jun 2020 00:35:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bkNs6kccz9sSd;
        Tue,  2 Jun 2020 17:35:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591083358;
        bh=zFDmif9p+c0zlYbN9eHIw7rrK7P9YAqGApbV6VPU26I=;
        h=Date:From:To:Cc:Subject:From;
        b=W8s81OSJH/5ai9Sq5ElIvSOdUzp53RKl9FI3Y8i1P5m6NJvGqM3eQCDpmAqib/CFL
         0L/QGUqaIHe2swzXMJikoFP8Syw2GuXmqU1r0wLjw9Nhl9fY+S1gZHxj6WlMoSbKKf
         5VPFxedbFzsYrR0YeoaU9HfNbYcVPQ5BWj0bCwkkFNXn+B++3upKB3d2zsPjpOAAmz
         JMCJwqBml3VdhUA2RxageViW3G0zooM1CpitViLzaNCKiBC7dEkh9szrEhhcGweNGO
         kqWNsJEugFl2v0e3leby+imwYS1dYPWRB8XQqHaIL0nTK2ga777C6FH0rLBEI4DvFS
         UxZg4v+q21Z8Q==
Date:   Tue, 2 Jun 2020 17:35:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Wei Liu <wei.liu@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jon Doron <arilou@gmail.com>
Subject: linux-next: build failure after merge of the hyperv tree
Message-ID: <20200602173556.17ad06a1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZbijDR41+1JCnTRd+vsxF7e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ZbijDR41+1JCnTRd+vsxF7e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the hyperv tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kvm/hyperv.c: In function 'kvm_vcpu_ioctl_get_hv_cpuid':
arch/x86/kvm/hyperv.c:2020:16: error: 'HV_X64_DEBUGGING' undeclared (first =
use in this function); did you mean 'HV_DEBUGGING'?
 2020 |    ent->ebx |=3D HV_X64_DEBUGGING;
      |                ^~~~~~~~~~~~~~~~
      |                HV_DEBUGGING
arch/x86/kvm/hyperv.c:2020:16: note: each undeclared identifier is reported=
 only once for each function it appears in

Caused by commit

  c55a844f46f9 ("x86/hyperv: Split hyperv-tlfs.h into arch dependent and in=
dependent files")

interacting with commit

  f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interf=
ace")

from the kvm tree.

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Jun 2020 17:31:06 +1000
Subject: [PATCH] x86/hyperv: merge fix for HV_X64_DEBUGGING name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index abde638548e0..af9cdb426dd2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2017,7 +2017,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu=
, struct kvm_cpuid2 *cpuid,
 			ent->edx |=3D HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |=3D HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
=20
-			ent->ebx |=3D HV_X64_DEBUGGING;
+			ent->ebx |=3D HV_DEBUGGING;
 			ent->edx |=3D HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |=3D HV_FEATURE_DEBUG_MSRS_AVAILABLE;
=20
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/ZbijDR41+1JCnTRd+vsxF7e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7WAVwACgkQAVBC80lX
0GxCggf9En24WCN3nmQmuFLamIsxS87H+KQ6KGMvErhDqyDeyrNsdbB/S2kSVKm1
DPW6gOhnFpwfRcVnJRg31rNz7FGppwtQQTVmwK2ZrRXy1+pFyVwE8Fvb7dqsOH57
Q3cBH3O1k1ZBKu/WVZojHuv0sUl0+c+IEZUiR0fvzvG9SXS1WxKuaHqUKdtOPgRu
FFWUG8B+yEPGCrImwayf1T0CnDZ9PjtShh8EoxGitsWJxyB4Dkv03yc6m3MkvZnG
cPDIDgt/020dZttZ8Opu6xAeojF5Lzt1GJwUHaT8ltyYj4wac9/RqOy5EIh4FuNX
iVpDzgG2fOR8Cb5mWjaTGsCzUiCw1g==
=eTIo
-----END PGP SIGNATURE-----

--Sig_/ZbijDR41+1JCnTRd+vsxF7e--
