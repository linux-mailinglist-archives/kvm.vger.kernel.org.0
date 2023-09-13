Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1706379EC49
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbjIMPP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjIMPP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:15:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D633EBD
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 08:15:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58cbf62bae8so74780707b3.3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 08:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694618153; x=1695222953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yuguTZJphIzcHtloJk7sEI3taMODTwx8agdtmjBok8=;
        b=cDNUjK4jCYzq7KyC1tpKzJIYs0ixWhHAWqvfkD5hIP0xWDCerAVwsgu+OQiWoJ8p8N
         9f0ypbhtMDDlH2eW5fyluYYUDFyWHuI7L6G7VdMrcM5f9LrVL/MPdte14U2AtuoFv1U+
         0KowTs6oI+JRIMMO8qr+wVBBgZzsLL9/vz/EBC+gLVfl3DU3znh3q4MxDgMUnYFxc2hH
         rTccjcw5YKKH7clBy4Uq5MVaNsoYHEIIf9n+xhp2T81hqSJpWadNj2ANepw0QaUtbDZ+
         ykzqxgVLX5ypT6978lSb++8l2jXeVd0+jKmpqa6b5V9lkGn8rMazND8tPBSdesVamKVU
         dkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618153; x=1695222953;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3yuguTZJphIzcHtloJk7sEI3taMODTwx8agdtmjBok8=;
        b=xKuZrcfSMYOCQfG8K7EtG2wA2j4/jbzkicFWAi/y9Trg7tzfCA03RMoyrqZA4zfqtl
         KzpEAaskzaD/2yKSJjMhyumIH4Ff2DUp5jvdoNgncwl7DWs2FBYFFAFs633ontkQAO1g
         B287NJJXlPZMGHFKqBPi91plZ+CmfXz+r9E5OIAWDfKCf2N+y27mt5hCOd1ofgr2b/vK
         sDO5zlAnZ6CbhfgNoPD1v7q3uoN9APoLXSc+AXZptw3dz6JTkWkWpXSox9whpCYZvRTa
         CdugT39UIhHJ8XxGiZb0G+Qz2QOz8urJoZw3YOVauudPnMOV6p/Z+trpkqnnVvE61ekg
         Uhfg==
X-Gm-Message-State: AOJu0YwXU1+6dqXBiL6VY+ShgLw2kehelRoQDRc7FMsoaInrxynK2tkb
        VkdO3trNKtrTZXAzMNReNfw9MiirLCU=
X-Google-Smtp-Source: AGHT+IHIoGsPkDCBi9zS/tPBchCVUNLZF6EQl7Jy3Q7OdK7WwT5buuWGDcP+2dJeYoCQIwGxSbKzW2jvrSQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:417:0:b0:d78:2c3:e633 with SMTP id
 23-20020a250417000000b00d7802c3e633mr56895ybe.2.1694618153075; Wed, 13 Sep
 2023 08:15:53 -0700 (PDT)
Date:   Wed, 13 Sep 2023 15:15:51 +0000
In-Reply-To: <b83a52bf72b951e69d3df23fff144899b0d6c11d.camel@infradead.org>
Mime-Version: 1.0
References: <20230801034524.64007-1-likexu@tencent.com> <ZNa9QyRmuAjNAonC@google.com>
 <055482bec09cae1ea56f979893c6b67e9d6b26a2.camel@infradead.org>
 <ZQHMM8/7xXReZHdD@google.com> <b83a52bf72b951e69d3df23fff144899b0d6c11d.camel@infradead.org>
Message-ID: <ZQHSJ9Epx1oNTZGE@google.com>
Subject: Re: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, David Woodhouse wrote:
> On Wed, 2023-09-13 at 07:50 -0700, Sean Christopherson wrote:
> > On Wed, Sep 13, 2023, David Woodhouse wrote:
> > > Userspace used to be able to force a sync by writing zero. You are
> > > removing that from the ABI without any explanation about why;
> >=20
> > No, my suggestion did not remove that from the ABI.=C2=A0 A @user_value=
 of '0' would
> > still force synchronization.
>=20
> Ah, OK. Yes, you're right. Thanks.
>=20
> > It's necessary for "user_set_tsc" to be an accurate name.=C2=A0 The cod=
e in v6 yields
> > "user_set_tsc_to_non_zero_value".=C2=A0 And I don't think it's just a n=
aming issue,
>=20
> In another thread, you said that the sync code doesn't differentiate
> between userspace initializing the TSC And userspace attempting to
> synchronize the TSC. I responded that *I* don't differentiate the two
> and couldn't see the difference.
>=20
> I think we were both wrong.=C2=A0Userspace does *explicitly* synchronize =
the
> TSC by writing zero, and the sync code *does* explicitly handle that,
> yes?

Doh, by "sync code" I meant the "conditionally sync" code, i.e. the data !=
=3D 0 path.

> And the reason I mention it here is that we could perhaps reasonable
> say that userspace *syncing* the TSC like that is not the same as
> userspace *setting* the TSC, and that it's OK for user_set_tsc to
> remain false? It saves adding another argument to kvm_synchronize_tsc()
> making it even more complex for a use case that just doesn't make sense
> anyway...
>=20
> > e.g. if userspace writes '0' immediately after creating, and then later=
 writes a
> > small delta, the v6 code wouldn't trigger synchronization because "user=
_set_tsc"
> > would be left unseft by the write of '0'.
>=20
> True, but that's the existing behaviour,

No?  The existing code will fall into the "conditionally sync" logic for an=
y
non-zero value.

		if (data =3D=3D 0) {
			/*
			 * detection of vcpu initialization -- need to sync
			 * with other vCPUs. This particularly helps to keep
			 * kvm_clock stable after CPU hotplug
			 */
			synchronizing =3D true;
		} else {
			u64 tsc_exp =3D kvm->arch.last_tsc_write +
						nsec_to_cycles(vcpu, elapsed);
			u64 tsc_hz =3D vcpu->arch.virtual_tsc_khz * 1000LL;
			/*
			 * Special case: TSC write with a small delta (1 second)
			 * of virtual cycle time against real time is
			 * interpreted as an attempt to synchronize the CPU.
			 */
			synchronizing =3D data < tsc_exp + tsc_hz &&
					data + tsc_hz > tsc_exp;
		}

> and it doesn't make much sense for the user to write 0 to trigger a sync
> immediately after creating, because the *kernel* does that anyway.

I don't care (in the Tommy Lee Jones[*] sense).  All I care about is minimi=
zing
the probability of breaking userspace, which means making the smallest poss=
ible
change to KVM's ABI.  For me, whether or not userspace is doing something s=
ensible
doesn't factor into that equation.

[*] https://www.youtube.com/watch?v=3DOoTbXu1qnbc
