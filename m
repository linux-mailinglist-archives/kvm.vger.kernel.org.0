Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB559718529
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbjEaOlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 10:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbjEaOlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 10:41:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C80B2
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 07:41:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fa00ed93dso2358932a12.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 07:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685544078; x=1688136078;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ti837LRqDnqpbatqjoYClzKSIJAuB63XL95slvLWNWw=;
        b=jbHrV8laR/9h4HJU6Oe0XOI8XhVtvHNwqSXwabnJ1B9TLJ1ikxm+VeMCoNOCAQhYy5
         MOAsnUKZ/XEuZbvhSL8D3d0vv22bXbsnlZfWr/5eeQsU57f8usPlpmki4eOENzYxly3q
         hekS0XSrg2VXycdgeH3XdrkWNMklvfVleAmKThYeH7PRy08zVNtHgr4MgoELArjZgSxg
         D2G1cLJt+ndFNPnNsGscN3/DyRmg0KxhjNJZokj+NGrlNyaVLc796bmhKBZyj4JYb9YT
         oRViTa0hh5fzmvK3msZHdR5RvIpVFt6XheLhQudK2Xmd+4JZny6bX3SlgyJGfM4rfSas
         DHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685544078; x=1688136078;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ti837LRqDnqpbatqjoYClzKSIJAuB63XL95slvLWNWw=;
        b=GHqHPQxLt073axel0/xnz6C8RY3UuwVjIGdL8dQkAX6DJK2GI9QPdn2YELHR+E+QE0
         04d8WnIDVSOrqtoMb25KrgsZgajC5xdMtKiby4WxriLV5C6yXjXdlnQpCBarTQpn7yDA
         RvNwmfyD6v8+kRQdw7+yA4hPl3/TxfdcjlmEttp1SX7Vf5zCzyI6/XSklG00Qo7eO86A
         ZSxrIvkl6xvP2IAI1W9HB6G6VOILsJZXxrGyd0DRIo6fHTTS6jaUX/Q3CA6LID3MhARH
         G25p4xZC9CzE+l+CClIfFZsUITr0HGRqMrHD7yQZ5WHOLKKdtZ6xupQfQIgDFHVtJ0uq
         KbKQ==
X-Gm-Message-State: AC+VfDzE975SPSUX3JlCo6rzgRLH6ESg6/rtx+Ko4LGDwjvmsYYqeU/p
        8aCJVJQ63dtVwutrWj3AfHsaJLyFf6o=
X-Google-Smtp-Source: ACHHUZ4FBX6k6njlZVJF5P3Da8UtchtKVJtSG6TZhD6bq6TRIEPJllWxu07/YePjB7f/meQ/f+3/j7b539I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6d1:0:b0:520:ba5c:324b with SMTP id
 200-20020a6306d1000000b00520ba5c324bmr1149460pgg.2.1685544078008; Wed, 31 May
 2023 07:41:18 -0700 (PDT)
Date:   Wed, 31 May 2023 07:41:16 -0700
In-Reply-To: <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com>
Mime-Version: 1.0
References: <NWb_YOE--3-9@tutanota.com> <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
 <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
 <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com> <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com>
Message-ID: <ZHdcjFPJJwl9RoxF@google.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, jwarren@tutanota.com,
        Kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=B2=D1=82, 2023-05-30 =D1=83 13:34 -0700, Jim Mattson =D0=BF=D0=
=B8=D1=88=D0=B5:
> > On Tue, May 30, 2023 at 1:10=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > > On Mon, May 29, 2023 at 6:44=E2=80=AFAM Maxim Levitsky <mlevitsk@redh=
at.com> wrote:
> > > > =D0=A3 =D0=BF=D0=BD, 2023-05-29 =D1=83 14:58 +0200, jwarren@tutanot=
a.com =D0=BF=D0=B8=D1=88=D0=B5:
> > > > > I don't know what would be the best case here, maybe put a quirk
> > > > > there, so it doesn't break "userspace".  Committer's email is dea=
d,
> > > > > so I'm writing here.
> > > > >=20
> > > >=20
> > > > I have to say that I know about this for long time, because some ti=
me
> > > > ago I used  to play with VMware player in a VM on AMD on my spare t=
ime,
> > > > on weekends (just doing various crazy things with double nesting,
> > > > running win98 nested, vfio stuff, etc, etc).
> > > >=20
> > > > I didn't report it because its a bug in VMWARE - they set a bit in =
the
> > > > tlb_control without checking CPUID's FLUSHBYASID which states that =
KVM
> > > > doesn't support setting this bit.
> > >=20
> > > I am pretty sure that bit 1 is supposed to be ignored on hardware
> > > without FlushByASID, but I'll have to see if I can dig up an old APM
> > > to verify that.
> >=20
> > I couldn't find an APM that old, but even today's APM does not specify
> > that any checks are performed on the TLB_CONTROL field by VMRUN.
> >=20
> > While Intel likes to fail VM-entry for illegal VMCS state, AMD prefers
> > to massage the VMCB to render any illegal VMCB state legal. For
> > example, rather than fail VM-entry for a non-canonical address, AMD is
> > inclined to drop the high bits and sign-extend the low bits, so that
> > the address is canonical.
> >=20
> > I'm willing to bet that modern CPUs continue to ignore the TLB_CONTROL
> > bits that were noted "reserved" in version 3.22 of the manual, and
> > that Krish simply manufactured the checks in commit 174a921b6975
> > ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"),
> > without cause.

Ya.  The APM even provides a definition of "reserved" that explicitly calls=
 out
the different reserved qualifiers.  The only fields/values that KVM can act=
ively
enforce are things tagged MBZ.

  reserved
    Fields marked as reserved may be used at some future time.
    To preserve compatibility with future processors, reserved fields requi=
re special handling when
    read or written by software. Software must not depend on the state of a=
 reserved field (unless
    qualified as RAZ), nor upon the ability of such fields to return a prev=
iously written state.
    If a field is marked reserved without qualification, software must not =
change the state of that field;
    it must reload that field with the same value returned from a prior rea=
d.
    Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ (see definiti=
ons).

> > > > Supporting FLUSHBYASID would fix this, and make nesting faster too,
> > > > but it is far from a trivial job.
> > > >=20
> > > > I hope that I will find time to do this soon.

...

> Shall we revert the offending patch then?

Yes please.
