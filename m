Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0ED7ABAAE
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjIVUwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjIVUwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:52:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2347CE
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:51:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d852a6749bcso3506816276.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695415916; x=1696020716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4TX9KW3UehaM567vdSiyy0Ql+tl7bQVV2vujujJ5luk=;
        b=TKxem65r1PfMMIIRUef+Xh6FkGGiSY+iKGrJe7pV54cNgzZe6/z6x5n4K5nXOU+7PK
         V2f6NCzRH8rDargvcUn/bpZfKXYSqYfLysIz2Wsz4/kTmtusSmAf4WkRb1g3eeKviSg9
         3fnnc9WLK4ZKWg38ksOacUfyVccO25QTm+tHEbnD3Mbp+cy9MV7QrnIdysAaoN8YOpjY
         p1I6CIvyJlbttk5YDRrIt95Q1Sg98nyKCrBc83Dn3/VvQ9V593IvyNwTsN2ZCC7WiR+h
         HW2yEHMElgmm6EzimhzhfKlhe2H43VpCagoxpEEkfJ5VYyv6rUtMrSCaGlwcD+jjVq7g
         mr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695415916; x=1696020716;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4TX9KW3UehaM567vdSiyy0Ql+tl7bQVV2vujujJ5luk=;
        b=DRq5Y6p36Hj0ce3BSXZtdFCv/cvwEdly3DG/g5dcfd+MJxMrfo2jIJBuk+A1PKd3jj
         TGgZ4XE1E7IHl+WBjip1cuLMh5T3Mm/bpucIB2Qcwv6HNQasq4p7NQDP9diikBPWvXdv
         MsxEckSnNkvyYq97pOwQ0E2Ha+0JbXHaUPPI6+Nt5M2cc+gc1G4O01Cp6twMaEp4ADdg
         8stzSIb8W1nl3fjhVjtQw7JA+OSL0WOEir6QzE6z1WJ8I+AGdB2BtGQHdJjWkquetoc3
         G/fuIihsXV+dP3zZe2oup+ztyf02jgg1wYS4BSnj12XPZICIat8y77S27+42xhFHoXZF
         jPFQ==
X-Gm-Message-State: AOJu0Yx93S8UGbqbf57uqdeGoiMBeVxpMZPlVU7aJ5/CN/gVY6xCQY52
        MlBlTSmS/4UUM4uTFBOiQ+gbdhKa46M=
X-Google-Smtp-Source: AGHT+IG+6sCx36xUq8ZAtxKWiXYb9PJ6ey1dkPddZF5Sm3OngemBdX3iKMTZ3NbYiOvoehUeX+vwYaFpvM0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce49:0:b0:d80:ff9:d19e with SMTP id
 x70-20020a25ce49000000b00d800ff9d19emr4495ybe.9.1695415915896; Fri, 22 Sep
 2023 13:51:55 -0700 (PDT)
Date:   Fri, 22 Sep 2023 13:51:54 -0700
In-Reply-To: <CALMp9eQN=SMo00Xo-ekD4EF8fQjp6DqUrLedO9TbwXcPGwt3hg@mail.gmail.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com> <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
 <ZQ3Z25cu5gnsedqr@google.com> <CALMp9eSQx5KWxDN97GTevxx-UkyAW8WCeVWbH0nAAnAY+phqKQ@mail.gmail.com>
 <ZQ3txHpC9XQ9mc8c@google.com> <CALMp9eQN=SMo00Xo-ekD4EF8fQjp6DqUrLedO9TbwXcPGwt3hg@mail.gmail.com>
Message-ID: <ZQ3+auXRFAE/OiRW@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Jim Mattson wrote:
> On Fri, Sep 22, 2023 at 12:40=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > Okay. What about the IA32_MISC_ENABLE bits above?
> >
> > One of the exceptions where I don't see a better option, and hopefully =
something
> > that Intel won't repeat in the future.  Though I'm not exactly brimming=
 with
> > confidence that Intel won't retroactively add more "gotcha! unsupported=
!" bits
> > in the future when they realize they forgot add a useful CPUID feature =
bit.
>=20
> I don't understand the difference here. Why not make userspace
> responsible for setting these bits as well?

That probably would have been the ideal approach.  I'm not entirely sure it=
 would
have actually been feasible though, as I suspect enumerting X86_FEATURE_DS =
without
any kind of guard would break userspace that reflects KVM_GET_SUPPORTED_CPU=
ID
back into KVM_SET_CPUID(2).

Even better would have been to never merge PEBS support in KVM in its curre=
nt
form.  The whole thing is a house of cards, e.g. if counters are "cross-map=
ped"
then the guest counters simply stop working.  And those warts aside, the en=
tire
enabling was a chaotic mess.  See commit 9fc222967a39 ("KVM: x86: Give host
userspace full control of MSR_IA32_MISC_ENABLES").

In other words, setting the UNAVAILABLE bits was the least awful way to sal=
vage
the mess.
