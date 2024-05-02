Return-Path: <kvm+bounces-16392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3BA8B94CF
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 839A9B20F7B
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 06:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8F01BC4E;
	Thu,  2 May 2024 06:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="LKe0TM3L"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45757819;
	Thu,  2 May 2024 06:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714632443; cv=none; b=fqqvpDrq3HYNcfcuTcoujxUSsUozfIeSg8FZfds7RRklTndRiN0Ry/0KCriDZzV/3P8wz2KEDjiFQH/qw6w0N7kp5Ad3fTGbqrIlqOu44pRGOeGHxei77+mILcdcaNmZpBwF4RkQ5N+XlzXjAn/pRA4S627NEf8BNlDmkO7POfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714632443; c=relaxed/simple;
	bh=SLYUWv1FqeTmDucVkpoJ6azIPS2DejVJixDpKAATot0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Z2TtyPyOH0DgJYgu8S2XN3DqCHKT3I1lO5abxB7NLf7KRUHJghRIlLDMHfpg0wFWo6GIu2sFq6WZnPA2bb/HGvt6Yvt2W3GCP9N+RuryaNSb6XEGm1L1hEMEI7XJaV3bxMg5ojJalt6aF70F9IITWezZFny3ZLJ928Hf3iLBeZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=LKe0TM3L; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1714632436;
	bh=mrGgxvSw1F21bEEOMCuH3SGmeA9rITTKwq+RASVYwX0=;
	h=Date:From:To:Cc:Subject:From;
	b=LKe0TM3LD3wZWwj/dP77NlSbI5kZ3W/iQZF2Ey9s1g2QDPfK00qDN+GeZrSmIdlnB
	 w1X2TruWqj79fGGXvxDMRLktYA0LvdYh6cjTudFdVerht02CfeKvJmZxCsAD9fWV/B
	 J9h8bki04nxNCUojXHJ8tNxOKUNiDXO+FaQSY4cJithJJQkoklhLtK/vPnv9l4fGRE
	 9EOrS07Rbf2QMmajADs+fomDQnU91dcEOFPIlK8qFeTIRewQQygpcWD6bP4pNr+edV
	 l+3aYs4iEdue4huXXt35hTWp0bmAxUkGIXiexm4aFbPi15wX+FeAAUXqiORrSKhNSs
	 CVe6c5U8m4c1g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VVPcd5kvkz4wxf;
	Thu,  2 May 2024 16:47:13 +1000 (AEST)
Date: Thu, 2 May 2024 16:47:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Sean Christopherson <seanjc@google.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, KVM <kvm@vger.kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20240502164711.06b5aca6@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u9taxsfNaih2JgKfzbuTXpf";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/u9taxsfNaih2JgKfzbuTXpf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/kvm/vmx/main.c:102:43: error: 'pi_has_pending_interrupt' undeclare=
d here (not in a function)
  102 |         .dy_apicv_has_pending_interrupt =3D pi_has_pending_interrup=
t,
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/vmx/main.c:131:27: error: 'vmx_pi_update_irte' undeclared here=
 (not in a function); did you mean 'kvm_apic_update_irr'?
  131 |         .pi_update_irte =3D vmx_pi_update_irte,
      |                           ^~~~~~~~~~~~~~~~~~
      |                           kvm_apic_update_irr
arch/x86/kvm/vmx/main.c:132:32: error: 'vmx_pi_start_assignment' undeclared=
 here (not in a function); did you mean 'kvm_arch_start_assignment'?
  132 |         .pi_start_assignment =3D vmx_pi_start_assignment,
      |                                ^~~~~~~~~~~~~~~~~~~~~~~
      |                                kvm_arch_start_assignment

Probably caused by commit

  5f18c642ff7e ("KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch VMX=
 and TDX")

interacting with commit

  699f67512f04 ("KVM: VMX: Move posted interrupt descriptor out of VMX code=
")

from the tip tree.

I have applied the following merge resolution patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 2 May 2024 14:13:25 +1000
Subject: [PATCH] fixup for "KVM: VMX: Move posted interrupt descriptor out =
of
 VMX code"

interacting with commit

  5f18c642ff7e ("KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch VMX=
 andTDX")

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kvm/vmx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..d4ed681785fd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "posted_intr.h"
=20
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
--=20
2.43.0

--=20
Cheers,
Stephen Rothwell

--Sig_/u9taxsfNaih2JgKfzbuTXpf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmYzNu8ACgkQAVBC80lX
0GzQeAf/QqH2Kd0FrILfzRcfD/fuGeTiiQhbezCcAffbBJ0B74DONLWlg1Zi/UAz
4LyeaRA6E8FrL2/wfTe+XTazFuB9hzWxvEr+sPbwPBwtjQdk+c/0/JlQ1ZLhbT3T
t2k/xkPQEIZm5s9y37RjemCVvLICSdcr5FnJBKnR8SBwH4U6TqE+g5GYmAIVdDhC
29t9Ileob+8btzcIRbP/13JYnSQBfgkQqJbT2Ff4Q/CVdYCP/HdICm5KHuXUzMD6
rHlKsHynE91+zOSwOnFei/PZuC2Qte/lwddcK9Xi8OebO9kRv1cUNu64whVRx3iN
E7TDTmPlXwsXo5YRpVSd16d+uG3K7A==
=HXEM
-----END PGP SIGNATURE-----

--Sig_/u9taxsfNaih2JgKfzbuTXpf--

