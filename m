Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC74351B73F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 06:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiEEEvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 00:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiEEEvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 00:51:37 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1C93F88A;
        Wed,  4 May 2022 21:47:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kv1Qx2cVQz4xTX;
        Thu,  5 May 2022 14:47:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651726073;
        bh=i0QIbr2IKIhQN2nt+A/IhRM6S8ecIJXY2MlW7LDDvLg=;
        h=Date:From:To:Cc:Subject:From;
        b=GTiH7XWCFgX6jNOSnabftRU/tSUv+s22rFxzfumXrZsV6fu0tPFjrBYtExCiMSLzI
         4HJQ9DnPwyA/tmCsfa9x2/5jJmDnE65ZCo0Q15YkNkyezsVbiEF+nVgcohYsCuurJ4
         3QU4ajurt33HpcEgkgkYMHG+ed882plJKDrTO4vJ4Vonx2CZLckreDo1rEEzhJ/P8L
         Flp6/WnMMKN6gXriwWhKbY6GYsgCLZKe4hrGOL2lkzNKulxLQpKG4RCoWlAw5teTpr
         KPrJ4CRBDEDNiyFcT+U/549fXXfldj1tZBuL67i89J2stBdSjNohO5FbUJuNboBIo0
         +WQocOfi0i8RQ==
Date:   Thu, 5 May 2022 14:47:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Gonda <pgonda@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20220505144751.3e018b5b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cUaPNtJnWeClM_NH_XKB2wp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/cUaPNtJnWeClM_NH_XKB2wp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got conflicts in:

  include/uapi/linux/kvm.h
  Documentation/virt/kvm/api.rst

between commits:

  c24a950ec7d6 ("KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES")
  71d7c575a673 ("Merge branch 'kvm-fixes-for-5.18-rc5' into HEAD")

from the kvm tree and commits:

  7b33a09d036f ("KVM: arm64: Add support for userspace to suspend a vCPU")
  bfbab4456877 ("KVM: arm64: Implement PSCI SYSTEM_SUSPEND")

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

diff --cc Documentation/virt/kvm/api.rst
index 2325b703a1ea,cbea3983f47b..000000000000
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@@ -6090,7 -6032,8 +6137,9 @@@ should put the acknowledged interrupt v
    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
    #define KVM_SYSTEM_EVENT_RESET          2
    #define KVM_SYSTEM_EVENT_CRASH          3
 -  #define KVM_SYSTEM_EVENT_WAKEUP         4
 -  #define KVM_SYSTEM_EVENT_SUSPEND        5
 +  #define KVM_SYSTEM_EVENT_SEV_TERM       4
++  #define KVM_SYSTEM_EVENT_WAKEUP         5
++  #define KVM_SYSTEM_EVENT_SUSPEND        6
  			__u32 type;
                          __u32 ndata;
                          __u64 data[16];
@@@ -6115,8 -6058,37 +6164,39 @@@ Valid values for 'type' are
     has requested a crash condition maintenance. Userspace can choose
     to ignore the request, or to gather VM memory core dump and/or
     reset/shutdown of the VM.
 + - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
 +   The guest physical address of the guest's GHCB is stored in `data[0]`.
+  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
+    KVM has recognized a wakeup event. Userspace may honor this event by
+    marking the exiting vCPU as runnable, or deny it and call KVM_RUN agai=
n.
+  - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
+    the VM.
+=20
+ For arm/arm64:
+ ^^^^^^^^^^^^^^
+=20
+    KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
+    KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
+    SYSTEM_SUSPEND function, KVM will exit to userspace with this event
+    type.
+=20
+    It is the sole responsibility of userspace to implement the PSCI
+    SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+    KVM does not change the vCPU's state before exiting to userspace, so
+    the call parameters are left in-place in the vCPU registers.
+=20
+    Userspace is _required_ to take action for such an exit. It must
+    either:
+=20
+     - Honor the guest request to suspend the VM. Userspace can request
+       in-kernel emulation of suspension by setting the calling vCPU's
+       state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
+       state according to the parameters passed to the PSCI function when
+       the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended us=
e"
+       for details on the function parameters.
+=20
+     - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
+       "Caller responsibilities" for possible return values.
 =20
  If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
  architecture specific information for the system-level event.  Only
diff --cc include/uapi/linux/kvm.h
index e10d131edd80,32c56384fd08..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -444,7 -444,8 +444,9 @@@ struct kvm_run=20
  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
  #define KVM_SYSTEM_EVENT_RESET          2
  #define KVM_SYSTEM_EVENT_CRASH          3
 -#define KVM_SYSTEM_EVENT_WAKEUP         4
 -#define KVM_SYSTEM_EVENT_SUSPEND        5
 +#define KVM_SYSTEM_EVENT_SEV_TERM       4
++#define KVM_SYSTEM_EVENT_WAKEUP         5
++#define KVM_SYSTEM_EVENT_SUSPEND        6
  			__u32 type;
  			__u32 ndata;
  			union {
@@@ -1151,8 -1153,9 +1154,9 @@@ struct kvm_ppc_resize_hpt=20
  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
  #define KVM_CAP_PMU_CAPABILITY 212
  #define KVM_CAP_DISABLE_QUIRKS2 213
 -/* #define KVM_CAP_VM_TSC_CONTROL 214 */
 +#define KVM_CAP_VM_TSC_CONTROL 214
  #define KVM_CAP_SYSTEM_EVENT_DATA 215
+ #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/cUaPNtJnWeClM_NH_XKB2wp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJzVvcACgkQAVBC80lX
0Gy7aAf/Yii/S9xkocyhFKqo0jo3TKuUASFt4rj+oP9Jr91K6bR/06xOCv1G5pPS
p3wyXuTL4yTCPUkfYZeK2QtKrdGqwYDvBB5bJrZeg4Mde2BHvDv0GSZsSGdTtZ+v
GcWbErROrIh9nVjzuP2uB+H2/NjrehXGm9fmx/aHDHHpVXva4TSdWBt4VxoWg9VU
OXwhfZ2RCaMmymIL5BnOrs6LJK4qOfjVE/IHeaqn1J22RCNlo+FrykeKL3FvbrIW
gyPjs5nN5NGZnWHpLv9iYRkLXoDfTqpmvkI4RaEo+nIi/PVJpZuFmpo2K7DKYdF5
5ZxFFe8BmPAf2ugVqHcZClC8+XjklA==
=EppF
-----END PGP SIGNATURE-----

--Sig_/cUaPNtJnWeClM_NH_XKB2wp--
