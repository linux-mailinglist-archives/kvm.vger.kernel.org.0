Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF0971F48B
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 23:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjFAVXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 17:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjFAVXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 17:23:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E3F1A2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 14:23:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a950b982d4so50265ad.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685654617; x=1688246617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+anUQPQ5nwJea5x9S41SzUJzVAZ4hONAhzugoJuW63k=;
        b=gf+KwotDEfn2Fr2bIkJVU9msFMj7Tcqe5rtZDxlimO0mw8cHxo22Jb+YfIPoUB9LYv
         /pK/q/mTyV2kXEzJPwjaaSdv7GykOoP7OYogZUwsYcASZfdXHizPtCeqmMRkSeFHAgf4
         rzgG2JUoD9vvh/S6yWJh51kJFXJqyDrvY226RrtE4mzVZPpyC/0zN/GXLT3EeQRfZxiq
         QgfJyK2Q/vOPRM4kKY26Weoc49CkImkvPQ2y5BYn6fd4LwYski73cWMHgGx/NoRFGllq
         Y5C58ftBUm8J2I0f2DRxdz8+7T+d0U+zdpRyzBX9LRD2oKKzHtSsieH3AeQu7hOcq6Yr
         R8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685654617; x=1688246617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+anUQPQ5nwJea5x9S41SzUJzVAZ4hONAhzugoJuW63k=;
        b=i9L6ZRnk/WpZc7HquvdfeFIcvzq8FU/C2ByCnWmeb/ZZmxRVd6jlUOZCIAIg4Wxijn
         sK9vHrLv3y+wiY8CMLaZPHHDN4pjQXZZyv00z3zQ6WspTFhkmeonOOHGq9vcU5gVmec5
         2lU2Dh4pCvsQXBhrEtTbe90AgJfO528VvoZkG4dXx4o5/KcPVv2LGTu3Wy5elwWqlvA/
         InHGy2J6nM4R1Q84jZhiPM2Sp+bN68g8KrYYUI7sEtTI/kjzjr18rkHvADJdZGhkMGMk
         hPK4YB5goqjP8jECW5pk3dEBjR7poUM0fhrKKBTzF7MI/4LQHsbCp5hOayhdn7lPZzB9
         ScnQ==
X-Gm-Message-State: AC+VfDyuss3NT4V2uLylkWcS9FOMGzAyLrMyqXOtDJt65+9gIF5V3EsE
        tx8MWIQprQAJ14E1ALKRAapn367mE2Ui7gDlFOXJqEjSb3/7im/ySXc=
X-Google-Smtp-Source: ACHHUZ49YwOiHVnPivj1UlyMIXNWd6YKixq9CTGwvl1CukOZ51h+EvZAq/xgXhV/G4Xc9X7W+TPvgiN5RNIO70s97v4=
X-Received: by 2002:a17:903:27c7:b0:1b0:5304:5b6b with SMTP id
 km7-20020a17090327c700b001b053045b6bmr62185plb.20.1685654617442; Thu, 01 Jun
 2023 14:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com> <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
 <CALMp9eQNNCwUbPQGBfHzWnTAEJeRO-fjQAFxb9101SChe9F5rg@mail.gmail.com>
 <623EC08D-A755-4520-B9BF-42B0E72570C1@nutanix.com> <CALMp9eQ17+XRpxJjMnmvPnKOC1VP1P=mU-KykoOzYZsgtGN8sQ@mail.gmail.com>
 <658D3EF0-B2D3-4492-A2A1-FC84A58B201D@nutanix.com> <ZHjYsKVBFLsOmHcF@google.com>
 <BF7121B7-B2AE-4391-9D1B-D944B5BC44D0@nutanix.com> <CALMp9eQ247GCxHnn3VwFatKEswWq9cMaoZCOivC-OQ_asvFHZQ@mail.gmail.com>
 <ZHkBJ+RdPYIZjolX@google.com>
In-Reply-To: <ZHkBJ+RdPYIZjolX@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 1 Jun 2023 14:23:26 -0700
Message-ID: <CALMp9eTja2iFa8dW4vPdTeFAZkvMGQ2FD45239BYcTr-Nh88rA@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Waiman Long <longman@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 1, 2023 at 1:35=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jun 01, 2023, Jim Mattson wrote:
> > On Thu, Jun 1, 2023 at 12:28=E2=80=AFPM Jon Kohler <jon@nutanix.com> wr=
ote:
> > > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > > index c544602d07a3..454bcbf5b543 100644
> > > > --- a/arch/x86/kvm/x86.h
> > > > +++ b/arch/x86/kvm/x86.h
> > > > @@ -492,7 +492,31 @@ static inline void kvm_machine_check(void)
> > > >
> > > > void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
> > > > void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
> > > > +
> > > > int kvm_spec_ctrl_test_value(u64 value);
> > > > +
> > > > +static inline bool kvm_account_msr_spec_ctrl_write(struct kvm_vcpu=
 *vcpu)
> > > > +{
> > > > +     if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapsho=
t) < 20)
> >
> > I think you mean 200 here. If it's bad to have more than 1
> > WRMSR(IA32_SPEC_CTRL) VM-exit in 20 VM-exits, then more than 10 such
> > VM-exits in 200 VM-exits represents sustained badness.
>
> No?  The snapshot is updated on every write, i.e. this check is whether o=
r not
> the last wrmsr(SPEC_CTRL) was less than 20 cycles ago.
>
>        if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapshot) < =
20)
>                vcpu->arch.nr_quick_spec_ctrl_writes++;
>        else
>                vcpu->arch.nr_quick_spec_ctrl_writes =3D 0;

Okay, then maybe this else clause is too aggressive. Just because we
went 21 VM-exits without seeing a WRMSR(IA32_SPEC_CTRL), we don't want
to clobber all of our history.

>        vcpu->arch.spec_ctrl_nr_exits_snapshot =3D vcpu->stat.exits;  <=3D=
 new snapshot
>
>        return vcpu->arch.nr_quick_spec_ctrl_writes >=3D 10;
>
> > (Although, as Sean noted, these numbers are just placeholders.)
>
> And the logic is very off-the-cuff, e.g. it may be better to have a rolli=
ng 200-exit
> window instead of 10 somewhat independent 20-exit windows.
