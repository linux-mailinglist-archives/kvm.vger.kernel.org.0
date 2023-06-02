Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F3A720C01
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbjFBWiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbjFBWiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:38:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E761AD
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:38:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b025aaeddbso23785ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 15:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685745495; x=1688337495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOke210ZG2qCrXueICZdzlar0bsESjlgdEpyeyJDLZo=;
        b=OaJ9cJ6+hx+T9iavnJOvrLzUdrxHnuOWTzhT2K2OdmphAMV9UaOqe+pOzxjutSyCXQ
         lViNouorJiF+mzPEe0R5uuTHrBnef5vsT5704lxd0yF6aGdnWm55hdAioNvpjIVR6cD1
         ls3M5CkCxdVCTMu+BEPVwULVO4hvqeq5tQozgtaq3KEvkKbG3rvTbSmqnL7NVbWaAJ1Y
         HnZa7rWN8ShhweUx9kTOEYPlkO5TiSzAZz7E/F7cCE+SScJ7ZYUSSRjWwN+sqNmCxLYD
         WDVjJWdOWU8RtMvqOSrxVEHcm070o1U2DO9H0D4hk7MzD1K2xFM1Bf1IvUrsdJu3AHK1
         NuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745495; x=1688337495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOke210ZG2qCrXueICZdzlar0bsESjlgdEpyeyJDLZo=;
        b=HA36DW3HQqXYq0aGLi3yIOecS2PdiYOn76A0KO/Ked7aopd549vQ+s4Fym8LMFPyP4
         TD8b3prd5wF/t8kR3LhD/aghSxvhUU7Bgq1Nx7jE2y0iIKJk/rrtX8sIdc+b2M1/XhkI
         7sbrYRGExOn417r197ieASyhWT+4kEcq/3b/i/fQEWIzF1Trr0eBwLy01rwI5g80kGmO
         ILdOiOzBBmvaKehAjIO+TX05I4KZzLhETMvhHPhproOWCXrb/ZAuQ066BhgB2tX67iq+
         JopCtqtzBHSi+9VXusIXlWd+bG/d570vYe7vGe4m4ixtC/vK7pmV9YHMpPNRBO6e25Dy
         z3dg==
X-Gm-Message-State: AC+VfDzFfHE+NI6lInhHVKOclHhzwgOOJkWj0S+T6P/1HTp75B3uy6c5
        ZCTXOEetJKd4rErVfKX/67CyMQRbMLFlNG7cklYC3L1Ef0bgyiN+ZQD61Q==
X-Google-Smtp-Source: ACHHUZ4W0xflgR0ozn057qqy60YCtXafUTxDoioc7WUUE63ADVU+cVRZLEja5X3DkrUJ6kSfKYOGvJX2XVuSMpWwVpE=
X-Received: by 2002:a17:902:b7cc:b0:1a9:48af:b4 with SMTP id
 v12-20020a170902b7cc00b001a948af00b4mr265101plz.9.1685745495085; Fri, 02 Jun
 2023 15:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com> <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com>
In-Reply-To: <ZHpjrOcT4r+Wj+2D@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Jun 2023 15:38:04 -0700
Message-ID: <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gao Shiyuan <gaoshiyuan@baidu.com>, pbonzini@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, likexu@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 2, 2023 at 2:48=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Jun 02, 2023, Jim Mattson wrote:
> > On Fri, Jun 2, 2023 at 12:16=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@bai=
du.com> wrote:
> > > > >
> > > > > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> > > > >
> > > > > When live-migrate VM on icelake microarchitecture, if the source
> > > > > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maxi=
mum
> > > > > number of vPMU fixed counters to 3") and the dest host kernel aft=
er this
> > > > > commit, the migration will fail.
> > > > >
> > > > > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM a=
nd
> > > > > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM=
's
> > > > > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x70=
00000ff.
> > > > > This inconsistency leads to migration failure.
> > >
> > > IMO, this is a userspace bug.  KVM provided userspace all the informa=
tion it needed
> > > to know that the target is incompatible (3 counters instead of 4), it=
's userspace's
> > > fault for not sanity checking that the target is compatible.
> > >
> > > I agree that KVM isn't blame free, but hacking KVM to cover up usersp=
ace mistakes
> > > everytime a feature appears or disappears across kernel versions or c=
onfigs isn't
> > > maintainable.
> >
> > Um...
> >
> > "You may never migrate this VM to a newer kernel. Sucks to be you."
>
> Userspace can fudge/fixup state to migrate the VM.

Um, yeah. Userspace can clear bit 35 from the saved
IA32_PERF_GLOBAL_CTRL MSR so that the migration will complete. But
what happens the next time the guest tries to set bit 35 in
IA32_PERF_GLOBAL_CTRL, which it will probably do, since it cached
CPUID.0AH at boot?
