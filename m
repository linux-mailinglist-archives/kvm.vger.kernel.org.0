Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFCB6D1592
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 04:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCaC0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 22:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCaC0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 22:26:31 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785BEB61;
        Thu, 30 Mar 2023 19:26:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PnkgR5HmFz4xDr;
        Fri, 31 Mar 2023 13:26:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680229588;
        bh=v3jndaBJ+HdzfcjpfsdHRytz1x5Dz2zRYXIwuA6OI5I=;
        h=Date:From:To:Cc:Subject:From;
        b=dyN2IEYv2kW4F2DocGDPpbkXi131tVrc6gMKZNx6ZQBLUuV2H7jdW+4osPy4MzOR+
         WgXrDV5PbX3XUitiL/r6zUcoI3Kp8h/0AX+Ixjj2CWlG2mN8iDNJDa9jBde/L/pEP2
         4pd4JTxrhZZFaK8e0gqG/ozSXUiaxCFUhYWJo+bFgoSCV4fD3HzbOqIQpwnDDBh18y
         WBl6bD9wSkbSV23anBDwaUeDoBK0/19OFrsCRMZIe+CFXlAfWnJfXaOEM2nMfhB4Rg
         DJZfUEwV2+MPLBP15s/abLRAcieL25zamicKkOVMByOYvMen53tSC5wj3REiIFA/Ee
         NVcZycODC2fqA==
Date:   Fri, 31 Mar 2023 13:26:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20230331132625.4c8149ae@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7fvVbFba6VEeFY19kqLE7wU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/7fvVbFba6VEeFY19kqLE7wU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/include/asm/kvm_host.h

between commit:

  2def950c63e3 ("KVM: arm64: Limit length in kvm_vm_ioctl_mte_copy_tags() t=
o INT_MAX")

from the kvm tree and commit:

  30ec7997d175 ("KVM: arm64: timers: Allow userspace to set the global coun=
ter offset")

from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/arm64/include/asm/kvm_host.h
index 6f7b218a681f,a8e2c52b44aa..000000000000
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@@ -1005,8 -1020,10 +1020,10 @@@ int kvm_arm_vcpu_arch_get_attr(struct k
  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
  			       struct kvm_device_attr *attr);
 =20
 -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 -				struct kvm_arm_copy_mte_tags *copy_tags);
 +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 +			       struct kvm_arm_copy_mte_tags *copy_tags);
+ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
+ 				    struct kvm_arm_counter_offset *offset);
 =20
  /* Guest/host FPSIMD coordination helpers */
  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);

--Sig_/7fvVbFba6VEeFY19kqLE7wU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQmRNEACgkQAVBC80lX
0Gxvwwf+OUK3UxfiKP0pzejXJO8EdvLHitBnq/Tm6upW/of7Z82JJfC6g+6hGhQL
qiYLxJpJ0BqFB5Xn/NvErlmV+NHxjQ7wfBtzHPmS7nhgP/BdetNpKnLPhQbwMi6N
KXoH2rBfo8L2vecuQgqjYDZZ74ly+js8iQDlplWjEFq9oZoeNk0ekKfXKxnOJ+TH
rvZNgx7LlfLabfCkmMgiFq5GcZ6NIGQJLWeR8HaLXPhAtqk8ctnAuacl/7ul6IP/
FeT2NRfAtsaK8CrKb+oAvmPC16STY18BvsZjxO7wcT86FO1CKRhJA/KkZkRs0K42
fMWD/1TlS/IFMPnnhwzP91o74/Ug3A==
=JLBC
-----END PGP SIGNATURE-----

--Sig_/7fvVbFba6VEeFY19kqLE7wU--
