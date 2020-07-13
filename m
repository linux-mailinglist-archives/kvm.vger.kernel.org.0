Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21521CE55
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 06:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGMEjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 00:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMEjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 00:39:42 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B060AC061794;
        Sun, 12 Jul 2020 21:39:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4rXS3ndgz9sDX;
        Mon, 13 Jul 2020 14:39:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594615178;
        bh=v/MgjPrqiPe4ZuBU4tfWPEezuWjdEPIyi5/ryEXFJ20=;
        h=Date:From:To:Cc:Subject:From;
        b=P3rtYUhcPvPZOTsyIvefv/IuitUkCrDUyk1g8GlwotOhWW2079csyInalZwUVs7om
         gmGUnTAdAyTazMrmdM0SJvBPXkpFvKucxP7C87o4Uc6zzeIk3zbbh/icfTRtHoibq3
         DIn6xyZbCO/MuZN6DGc5qXSuMn0qVc2pzYeM8R7tMV+xwg8+IbyqD/jURj6E5r70yJ
         qfoLc/yoP/c7S4+KB2oTgDFG6uan1oOHaz5fNIIqJmarI2QakEoqBDLLXH8t13AbpF
         PPt3x1dHZzG4YIIIFqyE04kGLgPB//CdxOwmnF8EZksd1JI3QU1eYjtPbGudRLXC3X
         uSoN4QCd1HZCQ==
Date:   Mon, 13 Jul 2020 14:39:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Gavin Shan <gshan@redhat.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20200713143935.799861b9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mGnpMwZ8P.+TqiQs4kELvSQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/mGnpMwZ8P.+TqiQs4kELvSQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got conflicts in:

  arch/arm64/include/asm/kvm_coproc.h
  arch/arm64/kvm/handle_exit.c

between commit:

  74cc7e0c35c1 ("KVM: arm64: clean up redundant 'kvm_run' parameters")

from the kvm tree and commits:

  6b33e0d64f85 ("KVM: arm64: Drop the target_table[] indirection")
  750ed5669380 ("KVM: arm64: Remove the target table")
  3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")

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

diff --cc arch/arm64/include/asm/kvm_coproc.h
index 454373704b8a,147f3a77e6a5..000000000000
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@@ -19,20 -19,12 +19,12 @@@ struct kvm_sys_reg_table=20
  	size_t num;
  };
 =20
- struct kvm_sys_reg_target_table {
- 	struct kvm_sys_reg_table table64;
- 	struct kvm_sys_reg_table table32;
- };
-=20
- void kvm_register_target_sys_reg_table(unsigned int target,
- 				       struct kvm_sys_reg_target_table *table);
-=20
 -int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run=
);
 -int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 -int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 -int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 -int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
 +int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
 +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
 +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
 +int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
 +int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
 +int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
 =20
  #define kvm_coproc_table_init kvm_sys_reg_table_init
  void kvm_sys_reg_table_init(void);
diff --cc arch/arm64/kvm/handle_exit.c
index 1df3beafd73f,98ab33139982..000000000000
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@@ -87,9 -87,9 +87,9 @@@ static int handle_no_fpsimd(struct kvm_
   * world-switches and schedule other host processes until there is an
   * incoming IRQ or FIQ to the VM.
   */
 -static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 +static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
  {
- 	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+ 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
  		vcpu->stat.wfe_exit_stat++;
  		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
@@@ -114,12 -115,11 +114,12 @@@
   * guest and host are using the same debug facilities it will be up to
   * userspace to re-inject the correct exception for guest delivery.
   *
 - * @return: 0 (while setting run->exit_reason), -1 for error
 + * @return: 0 (while setting vcpu->run->exit_reason), -1 for error
   */
 -static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *=
run)
 +static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
  {
 +	struct kvm_run *run =3D vcpu->run;
- 	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
+ 	u32 esr =3D kvm_vcpu_get_esr(vcpu);
  	int ret =3D 0;
 =20
  	run->exit_reason =3D KVM_EXIT_DEBUG;
@@@ -144,12 -144,12 +144,12 @@@
  	return ret;
  }
 =20
 -static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
 +static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  {
- 	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
+ 	u32 esr =3D kvm_vcpu_get_esr(vcpu);
 =20
- 	kvm_pr_unimpl("Unknown exception class: hsr: %#08x -- %s\n",
- 		      hsr, esr_get_class_string(hsr));
+ 	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
+ 		      esr, esr_get_class_string(esr));
 =20
  	kvm_inject_undefined(vcpu);
  	return 1;
@@@ -237,12 -237,11 +237,12 @@@ static int handle_trap_exceptions(struc
   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
   * proper exit to userspace.
   */
 -int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 -		       int exception_index)
 +int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
  {
 +	struct kvm_run *run =3D vcpu->run;
 +
  	if (ARM_SERROR_PENDING(exception_index)) {
- 		u8 hsr_ec =3D ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
+ 		u8 esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
 =20
  		/*
  		 * HVC/SMC already have an adjusted PC, which we need

--Sig_/mGnpMwZ8P.+TqiQs4kELvSQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8L5YcACgkQAVBC80lX
0Gxuhgf/cFDQ0wfIGNx/nFEnhCoKM11C5xyKwgAmkBa5nE8zrjJCI6qpJLcLU0n6
1AHTcocjSeXAanxA9NXdnRo8LNiQ91zgQnzh2WruQGIkARrxO8DjKSJNg/9yB6tJ
aQBizgLk+Kd64ZfzC7b4QgZDYZuNLanjrXc7Rp+8byVKprUS1tokdqYLdYdjfZbu
Eg5Z2SETfSj9f+ms82uHswv59uakDB2vOj38vs25eCRTN4e31q9PjhqXxD9odWit
kTE9AeF7G0sNwoGaDPJvjij95VxYkL48/6UmLT0e2fGVhgJ2ahUUqWcV5s5PFhKy
zmlnXo15+3CVh9X1QbiNj4zlaVdrWA==
=0UEf
-----END PGP SIGNATURE-----

--Sig_/mGnpMwZ8P.+TqiQs4kELvSQ--
