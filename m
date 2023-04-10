Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629CB6DCAD3
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDJSfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJSfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:35:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B311B
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:35:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54ee12aa4b5so61350707b3.4
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681151709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYcWUq+RIwWz8Eo7iiZJMzQD5opPcDYMKh5WAEAfwa0=;
        b=PQIS5I67a+QovAhPS8Mo2H8sht28bi9bN5JpD57lSH6EjaDR0b/9pd4uipxMffBbSM
         yCYiZfJ85/3SkbqFWDyEorh5AyndOKBUFXKk9G1aKk3j35mNaMtFrkwf2znFdQaEllRF
         Y2vSAfDAPaxZW50Rixw9KGLbqGr69SDRNUnLFlLbxL2b53o1VQmBFajE74cp8+jrd/Uu
         2jjcys8SPrjqNDZn+p2tjNO4sxlwu61GKYtjF/8l9xy5ZN4Zeqz9nRuLkcTw8r4ieu5S
         eKtPzI9uMuc9CoNHtoNUP8wy6JTL2pRt1VCAIq3BCIokkqFa5Nf8m4qpFx4/cPw2DGzg
         kPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681151709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yYcWUq+RIwWz8Eo7iiZJMzQD5opPcDYMKh5WAEAfwa0=;
        b=gQNTWp5fA70E1fVDiovSh0ie6LqN4p0ob50/5S+FJ5FV9/RjyT3qZs11RvXLD9RLQ+
         MkNknkMGUkYa0AID9o2l7io9HzO6EwcV0UD7N0sqTImw90bofNZGUJR6msv7FQeJGGWM
         wUWTzqAt+VJXYrsV2gVCC66iUS3mPWSc2u0DSpmmsMCfkOkxiuc5quYfC3NmqkM4QAXv
         93RoQQXJ1f0VsYksJ5yVJ5Y4T5iuZ4DXLCReEbCCOwsiRcjfC5410OyPb+1ELtOhYcQY
         7vfCeeU099a+aDEHQ8z7BLI79bvx9jaawq1GHjQuni7yVsZCSytoLVFFT9ZZJteoRYeB
         DFxw==
X-Gm-Message-State: AAQBX9dncBVVQdzmxKu8ZDy2jhRSzTxXmd7h6SuNafgPm2YBOpLs6XgZ
        Skn2nfCM+1gzpXo4FiP5aDyiFAAnK+Q=
X-Google-Smtp-Source: AKy350Zrf5mTw9i6XgUfHx08xdPKi2FDbRfLGvGIySAGJJe9tzJpB3PQHixlgSrGQTgJGo4clyrt46lNCuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c682:0:b0:b8b:f597:f3e5 with SMTP id
 k124-20020a25c682000000b00b8bf597f3e5mr7507097ybf.9.1681151709623; Mon, 10
 Apr 2023 11:35:09 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:35:07 -0700
In-Reply-To: <CA+wubQBDU4y97HrShmn+=0=o0HGwTckU1_y+VJLCuJtf2M+fyw@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-3-robert.hu@intel.com>
 <ZAtW7PF/1yhgBwYP@google.com> <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
 <ZBHz7kL7wSRZzvKk@google.com> <CA+wubQBDU4y97HrShmn+=0=o0HGwTckU1_y+VJLCuJtf2M+fyw@mail.gmail.com>
Message-ID: <ZDRW2zvPxa3ekDVv@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023, Robert Hoo wrote:
> Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=
6=E6=97=A5=E5=91=A8=E5=9B=9B 00:36=E5=86=99=E9=81=93=EF=BC=9A
> > > Sorry I don't follow you.
> > > My point is that, given it has passed kvm_is_valid_cr4() (in kvm_set_=
cr4()),
> > > we can assert boot_cpu_has(X86_FEATURE_UMIP)  and vmx_umip_emulated()=
 must be
> > > at least one true.
> >
> > This assertion is wrong for the case where guest.CR4.UMIP=3D0.  The bel=
ow code is
> > not guarded with a check on guest.CR4.UMIP.  If the vmx_umip_emulated()=
 check goes
> > away and guest.CR4.UMIP=3D0, KVM will attempt to write secondary contro=
ls.
> >
>=20
> Sorry still don't follow you. Do you mean in nested case? the "guest"
> above is L1?

Please take the time to walk through the code with possible inputs/scenario=
s before
asking these types of questions, e.g. if necessary use a whiteboard, pen+pa=
per, etc.
I'm happy to explain subtleties and add answer specific questions, but as e=
videnced
by my delayed response, I simply do not have the bandwidth to answer questi=
ons where
the answer is literally a trace-through of a small, fully contained section=
 of code.

	if (!boot_cpu_has(X86_FEATURE_UMIP)) {    <=3D evaluates true when UMIP is=
 NOT supported
		if (cr4 & X86_CR4_UMIP) {         <=3D evaluates false when guest.CR4.UMI=
P =3D=3D 0
			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
			hw_cr4 &=3D ~X86_CR4_UMIP;
		} else if (!is_guest_mode(vcpu) || <=3D evalutes true when L2 is NOT acti=
ve
			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC); <=3D KVM "bl=
indly" writes secondary controls
		}
	}
