Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA98654693
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 20:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiLVT2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 14:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLVT2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 14:28:36 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B047AE0AE
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 11:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=H9r5xJOYvt04o7CZsnEyvLDvXHcsF5KYrv7tbq7gBag=; b=iX4AAEeQWvre3TdwPhBBk5bCA6
        GZkC418GfKxeWn+KXuX3hwlWgLmuMvCNqeSlPfBuYpITCnwKD26n6/A3tu1pzcBo2el+UcWSRcnG4
        51WKIdFKpE0Def/cBGapFvp2tXMLvXsVyXTK7N+FKl6f5Wm13Q8NDHvNlAFUU8GJw0GiJLf7Vtv3J
        XjQYuTXeL/v4MVErsuTqXoqmII0j3zLKVTobWCCbfL6hLCOHkJOQe5YfDMGqUdfygh0wtosj/fTzK
        Lo6EuIrOActwpo8qWftwL/YqILfyf92/MmFl6W4MfX8k156w7bZ5GfKlW6tvSIKYbzGVswYmi06iS
        cEMCcPDQ==;
Received: from [2001:8b0:10b:5:3fe6:e898:d1ea:429f] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p8REv-00Dwq8-1J;
        Thu, 22 Dec 2022 19:28:25 +0000
Date:   Thu, 22 Dec 2022 19:28:25 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
CC:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        paul@xen.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/2=5D_KVM=3A_MMU=3A_Introduce_?= =?US-ASCII?Q?=27INVALID=5FGFN=27_and_use_it_for_GFN_values?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y6Snr42pMGvIO+9d@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com> <20221216085928.1671901-2-yu.c.zhang@linux.intel.com> <Y5yeKucYYfYOMXqp@google.com> <89a8f726e6fb1a91097ef18d6e837aff31a675f3.camel@infradead.org> <Y6Snr42pMGvIO+9d@google.com>
Message-ID: <9E3AF816-144E-43F7-8AFE-68BF405DCC4C@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22 December 2022 18:53:35 GMT, Sean Christopherson <seanjc@google=2Ecom=
> wrote:
>On Tue, Dec 20, 2022, David Woodhouse wrote:
>> On Fri, 2022-12-16 at 16:34 +0000, Sean Christopherson wrote:
>> > On Fri, Dec 16, 2022, Yu Zhang wrote:
>> > > Currently, KVM xen and its shared info selftest code uses
>> > > 'GPA_INVALID' for GFN values, but actually it is more accurate
>> > > to use the name 'INVALID_GFN'=2E So just add a new definition
>> > > and use it=2E
>> > >=20
>> > > No functional changes intended=2E
>> > >=20
>> > > Suggested-by: David Woodhouse <dwmw2@infradead=2Eorg>
>> > > Signed-off-by: Yu Zhang <yu=2Ec=2Ezhang@linux=2Eintel=2Ecom>
>> > > ---
>> > > =C2=A0arch/x86/kvm/xen=2Ec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 4 ++--
>> > > =C2=A0include/linux/kvm_types=2Eh=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 +
>> > > =C2=A0tools/testing/selftests/kvm/x86_64/xen_shinfo_test=2Ec | 4 ++=
--
>> > > =C2=A03 files changed, 5 insertions(+), 4 deletions(-)
>> > >=20
>> > > diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>> > > index d7af40240248=2E=2E6908a74ab303 100644
>> > > --- a/arch/x86/kvm/xen=2Ec
>> > > +++ b/arch/x86/kvm/xen=2Ec
>> > > @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *k=
vm, gfn_t gfn)
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret =3D 0;
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int idx =3D srcu_re=
ad_lock(&kvm->srcu);
>> > > =C2=A0
>> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (gfn =3D=3D GPA_INVAL=
ID) {
>> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (gfn =3D=3D INVALID_G=
FN) {
>> >=20
>> > Grrr!=C2=A0 This magic value is ABI, as "gfn =3D=3D -1" yields differ=
ent behavior than a
>> > random, garbage gfn=2E
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
>> > So, sadly, we can't simply introduce INVALID_GFN here, and instead ne=
ed to do
>> > something like:
>> >=20
>>=20
>> Well=2E=2E=2E you can still use INVALID_GFN as long as its value remain=
s the
>> same ((uint64_t)-1)=2E
>>=20
>> But yes, the KVM API differs here from Xen because Xen only allows a
>> guest to *set* these (and later they invented SHUTDOWN_soft_reset)=2E
>> While KVM lets the userspace VMM handle soft reset, and needs to allow
>> them to be *unset*=2E And since zero is a valid GPA/GFN, -1 is a
>> reasonable value for 'INVALID'=2E
>
>Oh, yeah, I'm not arguing against using '-1', just calling out that there=
 is
>special meaning given to '-1' and so it needs to be formalized so that KV=
M doesn't
>accidentally break userspace=2E

Indeed=2E I should make sure the xen_shinfo_test covers it too=2E We had b=
een fairly diligent about selftests for all this, as I *hadn't* yet got rou=
nd to posting the updated qemu support to go with it=20

Will update the docs and test accordingly=2E I have a couple of other mino=
r doc fixes which I spotted as I was doing the qemu support=2E If nobody be=
ats me to the uapi header part, I'll do that too=2E But I'm not *scheduled*=
 to be in front of a real computer until next year now, and and time I do s=
teal is likely to be spent on qemu itself=2E
