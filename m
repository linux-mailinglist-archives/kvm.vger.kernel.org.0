Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2612A720C32
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 01:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbjFBXJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 19:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjFBXJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 19:09:27 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C39C1B9
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 16:09:26 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33baee0235cso17515ab.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 16:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685747366; x=1688339366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JM9jmzmCn0qao86i2IMFGZ86750GNCmUQyqY9w1kwqU=;
        b=PPiee1X2nVYiuyU/c6kzelbjTgP4h7Uv/k/jeSZRPAplg1HKNxYZcfntrFL8i4Pd5p
         S/JnEBC5SALsAzs9BKD/9vN1FBZcryC/+SIuIAEqSfFVZnfDsrxLj1vq5QIHoJOXRVId
         bjdfw1qknHfclahE2XO/Vpx2LMNK5GY04GAbz5B2tfIDvSmxm9XOXAJv68adn7EMA1XW
         PUMcnwdTO95Fk9ZOg/UTg81nv63nThwD1YpK55lNUkBZ5wsGeHs1yGA77yfSi7x2w8H+
         vihdEHZCSRF+3hiD4FDitwJf5ShHDhcMC9wPqyleWBtALnrS1nQ3j4WMlXX3wedhOZTk
         QtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685747366; x=1688339366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JM9jmzmCn0qao86i2IMFGZ86750GNCmUQyqY9w1kwqU=;
        b=HjavubU5Hym0y03pLMT4eCDyUpyYOElXiyCXZ169CtIUcK+8iQfgGmPDbNTpgD8/r7
         dlILq8pNKj9Psfib9RxI+tANm2p9JNRwTxURRlHdvp8X5ZzoFYlpN1ab8smzs1ILK1d5
         S88t7JpUylFF3mIlml4ZliBquZWkrEpXX2k4Pzb1/SReX64QGBU6Z6giM9MHZk1P7q5P
         hHpi6siaRGgQWxaBz9nfjYeVAyqe8SU3a/aWd/Ln/TRTIyFBXlSODf85jFfbJA8ede3l
         PnuCHkGZJyk2oTuprDVV5mKBm9rP9HfkWXRJJTMZF32+1PhQaGu/pB2jS+T1vUx2zApj
         qKWA==
X-Gm-Message-State: AC+VfDxyzsSwW/sW+839Hg/4WtpUSOb0xj2QT/0oD4yWp6PPldZOvnpM
        RSPNoYvCKIGBhxQhF4uPzP/BFNc+YNzjIYBen0YKvg==
X-Google-Smtp-Source: ACHHUZ5CAPELWH1sJvUrvER+rTzyY/GkwGJBAVoWZhmPqSf3WX4DV17x9FXldQQp6SpGGrhA0Dnh4hFngyMpI1rY/h8=
X-Received: by 2002:a05:6e02:1a65:b0:33b:71e6:d6b4 with SMTP id
 w5-20020a056e021a6500b0033b71e6d6b4mr335614ilv.14.1685747365717; Fri, 02 Jun
 2023 16:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com> <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com> <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
 <ZHpyn7GqM0O0QkwO@google.com>
In-Reply-To: <ZHpyn7GqM0O0QkwO@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Jun 2023 16:09:14 -0700
Message-ID: <CALMp9eQq8a=53WfoTUYdaPCZ_CO5KDUodzgw=0J2Y8erUirvag@mail.gmail.com>
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

On Fri, Jun 2, 2023 at 3:52=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Jun 02, 2023, Jim Mattson wrote:
> > On Fri, Jun 2, 2023 at 2:48=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > On Fri, Jun 2, 2023 at 12:16=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > >
> > > > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > > > On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan=
@baidu.com> wrote:
> > > > > > >
> > > > > > > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> > > > > > >
> > > > > > > When live-migrate VM on icelake microarchitecture, if the sou=
rce
> > > > > > > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the =
maximum
> > > > > > > number of vPMU fixed counters to 3") and the dest host kernel=
 after this
> > > > > > > commit, the migration will fail.
> > > > > > >
> > > > > > > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by K=
VM and
> > > > > > > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the des=
t VM's
> > > > > > > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is =
0x7000000ff.
> > > > > > > This inconsistency leads to migration failure.
> > > > >
> > > > > IMO, this is a userspace bug.  KVM provided userspace all the inf=
ormation it needed
> > > > > to know that the target is incompatible (3 counters instead of 4)=
, it's userspace's
> > > > > fault for not sanity checking that the target is compatible.
> > > > >
> > > > > I agree that KVM isn't blame free, but hacking KVM to cover up us=
erspace mistakes
> > > > > everytime a feature appears or disappears across kernel versions =
or configs isn't
> > > > > maintainable.
> > > >
> > > > Um...
> > > >
> > > > "You may never migrate this VM to a newer kernel. Sucks to be you."
> > >
> > > Userspace can fudge/fixup state to migrate the VM.
> >
> > Um, yeah. Userspace can clear bit 35 from the saved
> > IA32_PERF_GLOBAL_CTRL MSR so that the migration will complete. But
> > what happens the next time the guest tries to set bit 35 in
> > IA32_PERF_GLOBAL_CTRL, which it will probably do, since it cached
> > CPUID.0AH at boot?
>
> Ah, right.  Yeah, guest is hosed.
>
> I'm still not convinced this is KVM's problem to fix.

One could argue that userspace should have known better than to
believe KVM_GET_SUPPORTED_CPUID in the first place. Or that it should
have known better than to blindly pass that through to KVM_SET_CPUID2.
I mean, *obviously* KVM didn't really support TOPDOWN.SLOTS. Right?

But if userspace can't trust KVM_GET_SUPPORTED_CPUID to tell it about
which fixed counters are supported, how is it supposed to find out?

Another way of solving this, which should make everyone happy, is to
add KVM support for TOPDOWN.SLOTS.
