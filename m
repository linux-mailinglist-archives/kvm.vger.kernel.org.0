Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96017722EBE
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 20:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbjFESbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 14:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjFESbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 14:31:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD24411B
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 11:31:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bacfa4eefd2so8196295276.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 11:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685989897; x=1688581897;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IO/Fs3eGWzo23DrzeVi6xYXoO5D8M7e0QwyLF6JWXrg=;
        b=ycRoK2OfE9MEm1ayzDiR63HOQqu8GiIfBSQVBKpNGRHXt5GdzNLQRrq7NwCVD6vG3U
         ZQWh4PjDb5hstSmguBpzROCAC+EnQQfgZbqXUCOuPoMCqVALO9JHWg0EPyz2UPOuzDvg
         eP9kjPGLYVCejjfWdVh9/11Ea8S8eTMEfBDOCDXbovxOJ/XsvTL0J58jwVfMYRq5w5oB
         9q++eh1qTFl1szhzEBhCYIT1W0LM5yGC575YzxsZ4VWd+TUFUP53RQHECjtVW+f+kIm/
         myhvUEVRvdfpwdilcp0kaQ6s1aMZVgHMSa/LUtGFpY9k1gGTPOA5mAZXVtv4bOJPNp2G
         GVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685989897; x=1688581897;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IO/Fs3eGWzo23DrzeVi6xYXoO5D8M7e0QwyLF6JWXrg=;
        b=G7tul42IX7cRQ0JG6ynRCxrKBexmHJdgDGydUhItGkeS7yLbobJuuHZNerpKb4K/4J
         6p32LZuQzo4k49Q/muY1x7CkczeIYngfDt9zYOLFRNMw+mREKQ5wemqYjgtRAEtGugDH
         mZCqCCuFGc7MP0f1HJ704mqdrfoHgumAAVe/vTRzdn5Ne5wFRVaEN3234bq9Pux22Xw0
         0m/YzFaB+uRweoR6DWpXCrvaW37KYCoN+IhSU9EIyN5HMu3W8LsdVDg4uwq+rk/FIlqC
         gL/ilOecs1zX6wOukdRQD0jcE9MUPyL044FClmP4Oc612yrxPqlhgRGvGhNkXWxMks6S
         fD5w==
X-Gm-Message-State: AC+VfDxj8telUP4VT0fPJ64IID0PSv6SlU/1JAlKXc3G+gkRgjQgeN4G
        VYruHMPhv36G2K02VsrLyk95gvtJzBQ=
X-Google-Smtp-Source: ACHHUZ4NBu7vF5TjFZr2Ug3j35ct3jGPLL/h6oWgYrrkJtBc0ZMdj9ipL/l+ZEawI0+Z0CWUZEe/C9ODobI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120d:b0:bb0:f056:cf43 with SMTP id
 s13-20020a056902120d00b00bb0f056cf43mr4262890ybu.1.1685989896966; Mon, 05 Jun
 2023 11:31:36 -0700 (PDT)
Date:   Mon, 5 Jun 2023 11:31:34 -0700
In-Reply-To: <20230605173101.iflfly3bt6ydvvyk@desk>
Mime-Version: 1.0
References: <20230531231820.trrs2uugc24gegj4@treble> <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble> <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk> <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com> <20230605163552.hi5kvh5wijegmus6@treble>
 <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com> <20230605173101.iflfly3bt6ydvvyk@desk>
Message-ID: <ZH4qBjLi0egsuC1D@google.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Jon Kohler <jon@nutanix.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Jun 05, 2023, Pawan Gupta wrote:
> On Mon, Jun 05, 2023 at 04:39:02PM +0000, Jon Kohler wrote:
> > >>> Yes.  Though in practice it might not make much of a difference.  W=
ith
> > >>> wrmsr+lfence, the lfence has nothing to do so it might be almost
> > >>> instantaneous anyway.
> > >>>=20
> > >>> --=20
> > >>> Josh
> > >>=20
> > >> Coming back to this, what if we hoisted call vmx_spec_ctrl_restore_h=
ost above
> > >> FILL_RETURN_BUFFER, and dropped this LFENCE as I did here?
> > >>=20
> > >> That way, we wouldn=E2=80=99t have to mess with the internal LFENCE =
in nospec-branch.h,
> > >> and that would act as the =E2=80=9Cfinal line of defense=E2=80=9D LF=
ENCE.
> > >>=20
> > >> Would that be acceptable? Or does FILL_RETURN_BUFFER *need* to occur
> > >> before any sort of calls no matter what?
> > >=20
> > > If we go by Intel's statement that only unbalanced RETs are a concern=
,
> > > that *might* be ok as long as there's a nice comment above the
> > > FILL_RETURN_BUFFER usage site describing the two purposes for the
> > > LFENCE.
>=20
> We would then need FILL_RETURN_BUFFER to unconditionally execute LFENCE
> to account for wrmsr branch misprediction. Currently LFENCE is not
> executed for !X86_BUG_EIBRS_PBRSB.
>=20
> > > However, based on Andy's concerns, which I've discussed with him
> > > privately (but I'm not qualified to agree or disagree with), we may w=
ant
> > > to just convert vmx_spec_ctrl_restore_host() to asm.  Better safe tha=
n
> > > sorry.  My original implementation of that function was actually asm.=
  I
> > > can try to dig up that code.
>=20
> Note:
>=20
>   VMexit
>   CALL
>     RET
>   RET    <---- This is also a problem if the first call hasn't retired ye=
t.
>   LFENCE
>=20
> Converting vmx_spec_ctrl_restore_host() to ASM should be able to take car=
e
> of this.

Is there an actual bug here, or are we just micro-optimizing something that=
 may or
may not need additional optimization?  Unless there's a bug to be fixed, mo=
ving
code into ASM and increasing complexity doesn't seem worthwhile.
