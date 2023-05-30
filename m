Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048AA716E66
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 22:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjE3ULN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 16:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjE3ULK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 16:11:10 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8279D
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:11:08 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-33baee0235cso5455ab.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685477468; x=1688069468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/S8s+47fBfTE9tXqv7S178kRy+2k6gtD/IVWr+1+k4=;
        b=7w3n8g6tMmQLHHn5OEBquFT+csZgz7ZNEAaRGNm3Bda6DPMM7H+vlouBGWvxv62VYF
         zBeHmm7ZnI6hs8YXH358DtSQWPOlhOjJyVYhAWhKFubZGPgIghbuq0MZK+IxntTZM6tW
         nzNiO28UztFCet2p7MFyGncjuSe/3Yj0c6ad5Xz+twsHSfqxqstnogfbepv2w0GMbvlr
         li32BvvjfgXibZ7ViXwNeiK3gXcbmjIhYc8B15ejKxrq+JSo4juVQ55zfw5Xpvs7zWbE
         CmkvDD9CfyVZWJfJB6CQ0JilKkOKMNjbluiH7uyAZeCLnWaTQUAHFjsqrkI0z/G/Lx47
         W7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685477468; x=1688069468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/S8s+47fBfTE9tXqv7S178kRy+2k6gtD/IVWr+1+k4=;
        b=QoWyrb4YbSMkifUtOAsE89RqWyqqNpdi2VvO0FErHCEUMlIFHsEeXEhZngerlH6YoY
         20ZAksXiG125TwzFyrj5xXoWQynQEmiobXdkpA/3GEPYXJO41V7sEgjgkjFu0Spg3Xub
         AyPd3OrHvoNiQr4FLC7w2dLyZG/HmCx4mgT0FUIo2zcNxY+lM/0CfWUZD1fNzRGr2Q/r
         iuuq+Sb7R8PDqBCJh0ZQOgB/Rno0JaPQXfQFRpHFhphgMon68UMXtpX0YRZMPZeLQqPu
         A0g2Q3L9viurYHV5pMtmIxe0HhXn2jcLPtBSxQZbeaLfSABhlJmmzaLFZwqjeSZEndkH
         QI9g==
X-Gm-Message-State: AC+VfDxYDfEOxB80cMByD29Ljh/NNzOVyfKjNqMdX5njhbT6sxv2bdU4
        U5v9+DQtkGOqeKjY2lnKXvA7qU44bbySHNKmIlsm6w==
X-Google-Smtp-Source: ACHHUZ5JptC6hOMEoMM2NPrgAlABXkbmZJcA1z655mA+2sxMdist6DXlZFtoQhG9xqKE3jn0dEBGPw0ikEQceJ7IgDM=
X-Received: by 2002:a05:6e02:12e1:b0:320:9759:bf6b with SMTP id
 l1-20020a056e0212e100b003209759bf6bmr4600iln.3.1685477468094; Tue, 30 May
 2023 13:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <NWb_YOE--3-9@tutanota.com> <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
In-Reply-To: <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 May 2023 13:10:57 -0700
Message-ID: <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     jwarren@tutanota.com, Kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 6:44=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.com=
> wrote:
>
> =D0=A3 =D0=BF=D0=BD, 2023-05-29 =D1=83 14:58 +0200, jwarren@tutanota.com =
=D0=BF=D0=B8=D1=88=D0=B5:
> > Hello,
> > Since kernel 5.16 users can't start VMware VMs when it is nested under =
KVM on AMD CPUs.
> >
> > User reports are here:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
> > https://forums.unraid.net/topic/128868-vmware-7x-will-not-start-any-vms=
-under-unraid-6110/
> >
> > I've pinpointed it to commit 174a921b6975ef959dd82ee9e8844067a62e3ec1 (=
appeared in 5.16rc1)
> > "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
> >
> > I've confirmed that VMware errors out when it checks for TLB_CONTROL_FL=
USH_ASID support and gets a 'false' answer.
> >
> > First revisions of the patch in question had some support for TLB_CONTR=
OL_FLUSH_ASID, but it was removed:
> > https://lore.kernel.org/kvm/f7c2d5f5-3560-8666-90be-3605220cb93c@redhat=
.com/
> >
> > I don't know what would be the best case here, maybe put a quirk there,=
 so it doesn't break "userspace".
> > Committer's email is dead, so I'm writing here.
> >
>
> I have to say that I know about this for long time, because some time ago=
 I used  to play with VMware player in a
> VM on AMD on my spare time, on weekends
> (just doing various crazy things with double nesting, running win98 neste=
d, vfio stuff, etc, etc).
>
> I didn't report it because its a bug in VMWARE - they set a bit in the tl=
b_control without checking CPUID's FLUSHBYASID
> which states that KVM doesn't support setting this bit.

I am pretty sure that bit 1 is supposed to be ignored on hardware
without FlushByASID, but I'll have to see if I can dig up an old APM
to verify that.

> Supporting FLUSHBYASID would fix this, and make nesting faster too,
> but it is far from a trivial job.
>
> I hope that I will find time to do this soon.
>
> Best regards,
>         Maxim Levitsky
>
>
