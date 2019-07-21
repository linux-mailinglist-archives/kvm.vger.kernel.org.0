Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138526F31E
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 13:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfGULwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 07:52:39 -0400
Received: from mout.web.de ([212.227.17.12]:47363 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfGULwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 07:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563709939;
        bh=btq/NddCH/tBv6VWC+prOsX/3dYEBSLbulYlgnhhyW4=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=ZSfV3BtAplVSC7J6V0/ufd1eA974zM542VaQUXYL+jfKDNT173kof7kfvnNVfEzQv
         cum9bJm5jaxJSi33h92hEorCoUxkHCiR5epwz1XOtGNwZMPcj3edCOTfYBigQ7hz9b
         0j3RsxetMywCfyd/snXEcd6WPrS5m8SWCj3ZtrdM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MOzoR-1hkToq1iA3-006RS0; Sun, 21
 Jul 2019 13:52:19 +0200
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
Message-ID: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
Date:   Sun, 21 Jul 2019 13:52:18 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BUhVY1KfEebEhwk+cPK4e+ICDdkZ4AMDc/+30gzGZf6bG7D3OWG
 +yAGqq0nQZZxdt82YqOfhT56YLmbExsEtyVm1Z+9JrQdGrlYYLq69hE1w+9UqdOtztm2TAf
 Egy42hugNcW5aC3W7yuvqkKJD4k2vtnistXjg4HOX/RSVKEvfjYBIPtAoGKmy7IU0TcqpaM
 z1cpt7zmNmWz0SnN5f/bA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GZCuZqkwPws=:HnByMOD7JK7fzXVWYCMN5Q
 ATe/Rar+Y+XgVIYvCuVvIRrMW6yivEQuvE9OvdZM2aUaY/h4Nfzc4rNbIPnti9WrFnDnPp6SW
 hRZr33UQRIUJsLjYjFwoymNVeAAwiGVuBHObnfnSha3WrmMguBTcLzDQ39lhJGkp+25ST/JOw
 GEtumpQia17VlDTpFa0oALGP8Pwnm1pIftfIGGfAg6O2fOAqnELpbYLjetttSmX5iLBRqx4HN
 r2GaxmoOevz2EGy6bmcI+VnO3BGBgclJD3C4Eobuh1e6tPxfUtALDvSgMojJWsVqOZLu5uO/c
 PcE69IAllSVZAX5b8tnMd08tSU97+9FYvdGY08KxIag/pm/6NNtk14UzrapQDRHIBs0udLYp2
 gbgZjm6wsa/u1CJVS9WyoCBmBLmF0BHzYcuqysrZwHOD502kw+FEUXww5BZI6o1B9SDa3j9eZ
 1WVpXUbc84+dIicemHn8og+1Pv2IdTR0VOtJww5BYwXX4wOsfiSqabK0G2opFHdEroHr3cPzx
 svdIXFNzuP6nf0Z61DP+GVK02x0hovsYEmb4hANqtGi2asAs0eFcfQBPi9AfwlVjQNYj11iPH
 qoW36KMM5jhbTLoXTzNh5oe0lVT8pzNJGOcVI4osmmhLv2dEDkWlbBWkUVOyF+6kkxnWbbwYy
 KKcs+1jBB7lUV1qBvgU/xzUkUOR85kA+RVroX8WYmOnWjFuKjgWq3CzuG4LzCTXXaAlRTvkl+
 w0/rgJsKrlWO7u2Rdct+9FpqMCuQJX/k62ysMFVjZ/ycE+1FOyBZJo3gCmmXWTH+YNUROwQkv
 AKNKZseciBFF5JYnswU1JB7ChUEMQA+2KdbbaBy/EIwtpFTbLxLnluRjdVrkVm3zdeAkqNcwB
 4RkwTGVarKOwxEAHJofajeHGRGfWPVDqq8q8utTb1EyY7WT5rZ5uKY6p75LeKh7BwAgs9Dziy
 B1MSBwzMVQkvLBTws9oPNiwNJ8sGc2W9uTcRq2y6DtACWf0yT5cHQCJhC/npi3fiVP7/3eQBI
 JaGFtGfeNco7xPLJXUACXvxM+ifMRQikQy3nAVr1342nixKbVIUs/mxdQF72RrYNw+SvWPg5S
 z5xGlg2Dti2XWBAcr5IMbTDMG3f6skuJOjG
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Letting this pend may cause nested_get_vmcs12_pages to run against an
invalid state, corrupting the effective vmcs of L1.

This was triggerable in QEMU after a guest corruption in L2, followed by
a L1 reset.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
=2D--

And another gremlin. I'm afraid there is at least one more because
vmport access from L2 is still failing in QEMU. This is just another
fallout from that. At least the host seems stable now.

 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f1378789bd0..4cdab4b4eff1 100644
=2D-- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -220,6 +220,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;

+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+
 	vmx->nested.vmxon =3D false;
 	vmx->nested.smm.vmxon =3D false;
 	free_vpid(vmx->nested.vpid02);
=2D-
2.16.4
