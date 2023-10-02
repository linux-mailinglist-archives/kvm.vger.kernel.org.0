Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4325E7B5839
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjJBQhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 12:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjJBQhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 12:37:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433B59D
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 09:37:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f53027158so247949227b3.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 09:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696264631; x=1696869431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+EcUpz1fNgfQrh7LLts+jbrgy/+j0YPHuBsINvIDrQ=;
        b=3fWQmz5Rf2WxXH9DPI+5+itorXo7AjThxrb/fKYVCrScsTAwx/hAkB2hoHdg8sVUFA
         7rOEvI8B15JEt5mmwOJqhb2OIbQhCzvxjhOrEZfBgS6sXYnnozUv/OA4hn6nt9NgnpgM
         GdgcKUn9ABskCNSJXaBmxDRAs/qlsy4wMsOdSsK16QWt1isle3LFJZfj2ECRFn0tHzXI
         F6RumftOUkYGY/NDqbboX5EZ78T4IKEkg3wYG6TCDhDTdZHq79n6J/b2h2G/3P+mCyik
         1lHybnwrq7v830sBSygp1k2BaqzrnxaUDO8ThTJv9gjVMNc0WDhD5tU9jwyRk9+oedLg
         PFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696264631; x=1696869431;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L+EcUpz1fNgfQrh7LLts+jbrgy/+j0YPHuBsINvIDrQ=;
        b=Hg62YbSl2zyAz9FpGPFZmpHQ7KiqoLwFLdIzxxVe7NMNXC4fKZpuIeGxF2MAutH181
         KmiUX4rL4WrNOukmnZxe1m9G6Ak6Ota4fDVOec+8vXHMkN60dXUxN40pg0fUKHpiqXwn
         QqJy0/6Z9SFzyoin+ObnAvvwWO1hkW8Bh+bjsZlqTygU5y9LYcSLI500atzmDwTft2UC
         Us1BQtdWhS/kJ8pwt2p5ak4d5yfw9nOOXybV51232Uzi1cQoc1YU0SqIE4DW2TJ5ThfF
         n69rSsAIvVr9xJDsRcpnXO2+RToP/32IgAISEIEayg96LB9X3uOAzekB05SmK2f0fp47
         6jDg==
X-Gm-Message-State: AOJu0YwMKxLi8xOnPS0HYmIIhhL3FhPBOuj7gvNbv9SPqiKT+fqEJ08G
        xtSELfmi6mnrg39aTPqe0+N+thFIVqs=
X-Google-Smtp-Source: AGHT+IEV5L+j/C1nV3eQIMCUX7B3iFZq5jh5tRrMs0tGOt9NN2mF9eB5tmjLOupbUmkPs+Rb3BOsdgqL7MY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b8b:b0:589:a9fd:8257 with SMTP id
 ck11-20020a05690c0b8b00b00589a9fd8257mr207253ywb.6.1696264631460; Mon, 02 Oct
 2023 09:37:11 -0700 (PDT)
Date:   Mon, 2 Oct 2023 09:37:09 -0700
In-Reply-To: <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
Message-ID: <ZRrxtagy7vJO5tgU@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, David Woodhouse wrote:
> On Fri, 2023-09-29 at 13:15 -0700, Dongli Zhang wrote:
> >=20
> >=20
> > We want more frequent KVM_REQ_MASTERCLOCK_UPDATE.
> >=20
> > This is because:
> >=20
> > 1. The vcpu->hv_clock (kvmclock) is based on its own mult/shift/equatio=
n.
> >=20
> > 2. The raw monotonic (tsc_clocksource) uses different mult/shift/equati=
on.
> >=20
> > 3. As a result, given the same rdtsc, kvmclock and raw monotonic may re=
turn
> > different results (this is expected because they have different
> > mult/shift/equation).
> >=20
> > 4. However, the base in=C2=A0 kvmclock calculation (tsc_timestamp and s=
ystem_time)
> > are derived from raw monotonic clock (master clock)
>=20
> That just seems wrong. I don't mean that you're incorrect; it seems
> *morally* wrong.
>=20
> In a system with X86_FEATURE_CONSTANT_TSC, why would KVM choose to use
> a *different* mult/shift/equation (your #1) to convert TSC ticks to
> nanoseconds than the host CLOCK_MONOTONIC_RAW does (your #2).
>=20
> I understand that KVM can't track the host's CLOCK_MONOTONIC, as it's
> adjusted by NTP. But CLOCK_MONOTONIC_RAW is supposed to be consistent.
>=20
> Fix that, and the whole problem goes away, doesn't it?
>=20
> What am I missing here, that means we can't do that?

I believe the answer is that "struct pvclock_vcpu_time_info" and its math a=
re
ABI between KVM and KVM guests.

Like many of the older bits of KVM, my guess is that KVM's behavior is the =
product
of making things kinda sorta work with old hardware, i.e. was probably the =
least
awful solution in the days before constant TSCs, but is completely nonsensi=
cal on
modern hardware.

> Alternatively... with X86_FEATURE_CONSTANT_TSC, why do the sync at all?
> If KVM wants to decide that the TSC runs at a different frequency to
> the frequency that the host uses for CLOCK_MONOTONIC_RAW, why can't KVM
> just *stick* to that?

Yeah, bouncing around guest time when the TSC is constant seems counterprod=
uctive.

However, why does any of this matter if the host has a constant TSC?  If th=
at's
the case, a sane setup will expose a constant TSC to the guest and the gues=
t will
use the TSC instead of kvmclock for the guest clocksource.

Dongli, is this for long-lived "legacy" guests that were created on hosts w=
ithout
a constant TSC?  If not, then why is kvmclock being used?  Or heaven forbid=
, are
you running on hardware without a constant TSC? :-)

Not saying we shouldn't sanitize the kvmclock behavior, but knowing the exa=
ct
problematic configuration(s) will help us make a better decision on how to =
fix
the mess.
