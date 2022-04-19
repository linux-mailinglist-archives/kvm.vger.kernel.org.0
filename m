Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1175063E8
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 07:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348576AbiDSFhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 01:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDSFhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 01:37:13 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDF71F60F;
        Mon, 18 Apr 2022 22:34:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KjCD10cMlz4xXW;
        Tue, 19 Apr 2022 15:34:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650346465;
        bh=LASvUK9v/c4iVL7PX/RcYrawCz7wjdGe7O3W4abbhJg=;
        h=Date:From:To:Cc:Subject:From;
        b=XAwLGFd646aP5BRAuht3wKcw3DZ/zZCO+jYSbDTjU6nHtstfI8uCr+jZc/H78D6sh
         NSu751OhhVckf/NG9CX64u7wgJOxNHPNUlF3pRq9OlCuxP7lFengXttDniDenkbG+3
         lZF9r4QN5bDo/Rno5Qub2/dW+eVBlQBwI0zPXFiTPkTThCcth6iL9SFbUW+VTcvaQl
         b1z1hXzmBkzpc3DoGoxXPTEqqIq/gchuyxrPNCb6SWXdi57/wn97E+swOEpjgk9hIm
         ZdGFlhJBHg06A8F5fuFDl+xxP3fR4b8ZEYTM3uW0vz7Q5sVe0Jec1apEq5I37K9+W0
         cggihrWAvVVSA==
Date:   Tue, 19 Apr 2022 15:34:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20220419153423.644c0fa1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DcR__SR_4Xx_1cFlZkvC3gW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/DcR__SR_4Xx_1cFlZkvC3gW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (arm64 defconfig)
failed like this:

arch/arm64/kvm/psci.c: In function 'kvm_prepare_system_event':
arch/arm64/kvm/psci.c:184:32: error: 'struct <anonymous>' has no member nam=
ed 'flags'
  184 |         vcpu->run->system_event.flags =3D flags;
      |                                ^

Caused by commit

  c24a950ec7d6 ("KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES")

In this commit, the uapi structure changes do not match the documentation
changes :-(  Does it matter that the ABI may be changed by this commit
(depending on the alignment of the structure members)?

I have added the following patch or today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Apr 2022 15:25:17 +1000
Subject: [PATCH] fix up for "KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for S=
EV-ES"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd1d8167e71f..68ce07185f03 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -448,6 +448,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
 			__u32 ndata;
+			__u64 flags;
 			__u64 data[16];
 		} system_event;
 		/* KVM_EXIT_S390_STSI */
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/DcR__SR_4Xx_1cFlZkvC3gW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJeSd8ACgkQAVBC80lX
0Gzqhgf9E3HBLYVdNuA4RE47McIbBq/Lun8JbASZFHYeDAmbwPYH+e2XpnKj3iHz
6iOQ373UROq9qv5GPMTpz1QZtVjzipwTm/yAWDcwBvlWdlRW1JWs9m3PMVkfF4hF
NeK81BeP97RkdHrvqAW+o3VdYUc+R59XCoUebfNfY55EaaPxBSLE0dmq8rSsD1/C
vKZhjzG2jDC9FPaJjiSPfzM59qwwjoYCvtg3L4BKUYdiegzU79oKJ57U60ja5Po8
tSmL/FSXqX8dOSviCS77dUsiztBcKsjkSKXaYQBR6kumkWl2/PWwZpWCn3s93Lo8
n4LOnkrdc5eWa7j7/sbYrRHXeTsnyA==
=fZAm
-----END PGP SIGNATURE-----

--Sig_/DcR__SR_4Xx_1cFlZkvC3gW--
