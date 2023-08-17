Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60D77F662
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 14:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbjHQMYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 08:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350783AbjHQMYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 08:24:00 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FA91BFB;
        Thu, 17 Aug 2023 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692275038;
        bh=SmZfuOazkBB/9dXy3IBokg28/S6ezc+fJp9fFOBO+DA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=iU0oIbJClbAQK+vJDjruv2frDEjEvd7BY/NGDYLww2yn/V4WTIMv9AIALw69MrehL
         TrFPUzQWfvV4LylDDcZpmTdU4Y1oazvcP4r/0QTxMQkqvuRo8VbeYWMN3ZP50fTeaX
         EzRG1v3xFmzOAa1aW60X5gb0MKyRA51RL/dF/h3X4v+RitVn/KIqCSCFgSlGJQtuGF
         MNZ7wwtNNyY8DT0SQ34FeLuPvfhgY4RPqgZVPGklg0VIG+Zuk2t4DnFa3TsFYW4aU6
         YZ9E9VACmbAdlLVE33xLV16gxfD4fm7GnEolu5VLiaS/IUsZVmOmygyLoS8fTq9Kys
         eBfaPVESahD9Q==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RRPLk3vzWz4wZx;
        Thu, 17 Aug 2023 22:23:58 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH v3 5/6] KVM: PPC: Add support for nestedv2 guests
In-Reply-To: <20230807014553.1168699-6-jniethe5@gmail.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-6-jniethe5@gmail.com>
Date:   Thu, 17 Aug 2023 22:23:58 +1000
Message-ID: <877cpteu1t.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jordan Niethe <jniethe5@gmail.com> writes:
> A series of hcalls have been added to the PAPR which allow a regular
> guest partition to create and manage guest partitions of its own. KVM
> already had an interface that allowed this on powernv platforms. This
> existing interface will now be called "nestedv1". The newly added PAPR
> interface will be called "nestedv2".  PHYP will support the nestedv2
> interface. At this time the host side of the nestedv2 interface has not
> been implemented on powernv but there is no technical reason why it
> could not be added.

Some build errors with powernv_defconfig, I haven't dug into them but
presumably some ifdefs needed.

  ../arch/powerpc/kvm/book3s_hv_nestedv2.c: In function =E2=80=98kvmhv_nest=
edv2_vcpu_create=E2=80=99:
  ../arch/powerpc/kvm/book3s_hv_nestedv2.c:954:14: error: implicit declarat=
ion of function =E2=80=98plpar_guest_create_vcpu=E2=80=99 [-Werror=3Dimplic=
it-function-declaration]
    954 |         rc =3D plpar_guest_create_vcpu(0, vcpu->kvm->arch.lpid, v=
cpu->vcpu_id);
        |              ^~~~~~~~~~~~~~~~~~~~~~~
  ../arch/powerpc/kvm/guest-state-buffer.c: In function =E2=80=98kvmppc_gsb=
_send=E2=80=99:
  ../arch/powerpc/kvm/guest-state-buffer.c:592:14: error: implicit declarat=
ion of function =E2=80=98plpar_guest_set_state=E2=80=99 [-Werror=3Dimplicit=
-function-declaration]
    592 |         rc =3D plpar_guest_set_state(hflags, gsb->guest_id, gsb->=
vcpu_id,
        |              ^~~~~~~~~~~~~~~~~~~~~
  ../arch/powerpc/kvm/guest-state-buffer.c: In function =E2=80=98kvmppc_gsb=
_recv=E2=80=99:
  ../arch/powerpc/kvm/guest-state-buffer.c:617:14: error: implicit declarat=
ion of function =E2=80=98plpar_guest_get_state=E2=80=99 [-Werror=3Dimplicit=
-function-declaration]
    617 |         rc =3D plpar_guest_get_state(hflags, gsb->guest_id, gsb->=
vcpu_id,


cheers
