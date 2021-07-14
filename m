Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C7A3C87C2
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 17:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhGNPg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 11:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240007AbhGNPgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 11:36:42 -0400
X-Greylist: delayed 393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Jul 2021 08:33:50 PDT
Received: from mail.thalheim.io (mail.thalheim.io [IPv6:2a01:4f9:2b:1605::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B188C061786
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 08:33:50 -0700 (PDT)
Received: from mail.thalheim.io (eve.i [IPv6:2a01:4f9:2b:1605::1])
        by mail.thalheim.io (Postfix) with ESMTPSA id 00D28C2AE0A;
        Wed, 14 Jul 2021 15:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thalheim.io; s=default;
        t=1626276436; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=xjHlv0OyBsLdQnfYGQhtE5KnFGOLXIQ9KwS1YjM4m8o=;
        b=N3LlkGN7gK2tzan3uQuWHyaV0QfAuIq2ah88DmfHZ6MsQu7/l2D1Me+qf+iv06rg6mgJGK
        vn3xpP68R6DC5oe7yajU5uokONWMUA8Ar7sE33OxA4RBgvd/a+jPwlN9r/+czp9b2BuSHv
        LcO3lDJCVm3LUEnGyJs2SjLDK8NlEMw=
MIME-Version: 1.0
Date:   Wed, 14 Jul 2021 15:27:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.16.0
From:   "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@thalheim.io>
Message-ID: <8231a065caffd539c6dee272d78b1df0@thalheim.io>
Reply-To: cover.1613828726.git.eafanasova@gmail.com
Subject: Re: [RFC v3 0/5] Introduce MMIO/PIO dispatch file descriptors 
 (ioregionfd)
To:     eafanasova@gmail.com
Cc:     kvm@vger.kernel.org
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=joerg@higgsboson.tk smtp.mailfrom=joerg@thalheim.io
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The patches does not compile because vcpu->ioregion_ctx is missing a len =
field.


arch/x86/kvm/x86.c: In function =E2=80=98complete_ioregion_fast_pio=E2=80=
=99:
arch/x86/kvm/x86.c:9680:58: error: =E2=80=98struct <anonymous>=E2=80=99 h=
as no member named =E2=80=98len=E2=80=99
 9680 |   memcpy(&val, vcpu->ioregion_ctx.val, vcpu->ioregion_ctx.len);
      |                                                          ^


Gcc8 was also unhappy that the function would have no return values for c=
ases.

---
 arch/x86/kvm/x86.c  | 1 +
 virt/kvm/ioregion.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7dc1b80170f1..73205619cdd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9709,6 +9709,7 @@ static int complete_ioregion_io(struct kvm_vcpu *vc=
pu)
 		return complete_ioregion_mmio(vcpu);
 	if (vcpu->arch.pio.count)
 		return complete_ioregion_pio(vcpu);
+	return 0;
 }
 #endif /* CONFIG_KVM_IOREGION */
=20
diff=20--git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index d53e3d1cd2ff..e0a52b2a56df 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -311,6 +311,7 @@ get_ioregion_list(struct kvm *kvm, enum kvm_bus bus_i=
dx)
 		return &kvm->ioregions_mmio;
 	if (bus_idx =3D=3D KVM_PIO_BUS)
 		return &kvm->ioregions_pio;
+	return NULL;
 }
=20
 /* check for not overlapping case and reverse */
--=20
2.32.0
