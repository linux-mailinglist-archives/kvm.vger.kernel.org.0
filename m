Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE36DCA8F
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDJSMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjDJSMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:12:13 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD7C26B8
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:12:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c01480e3cso138912417b3.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681150327;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/n1Pxmg/UOg9KyrXwFbetRz7jqbcZQ1Ll0ehgYOnfE=;
        b=oM72fNkFqZMHZv0rAbOwTho1NR7QEKReb7A1INzikoowLrmGDFdiyM0NSR3Jtl5hUc
         fJaFYhDKfRtY+zbomLdFCLUHFRVQGHOCWo+otIbQaaORbZ/390ylUS+dVAf6T8GLf0p8
         Ss16YKMvfoypH32EBQ5Z0qr/MVJ/jsgUWM3imbw4OZHavuvgKvmY2PJ6UH+K+eCs6x00
         MDg7EcJqsLMaCq7DRSz46a1LAiBFK0TNMoaz3cIQLppgzo6ddMFwQSj5iYc1w8SAqG/g
         srQpzwtfHvPJkUmdkNKgwv8a6FvsI/YQ6YfEmYlyIomBJUcwzdoQuvpJpC7xEcfnwYtq
         oPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681150327;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D/n1Pxmg/UOg9KyrXwFbetRz7jqbcZQ1Ll0ehgYOnfE=;
        b=tcH6ujtSyB55mnlbvMlvKb4OdEfe1gBf/o/OA7s4Lc6ctpKtiCS+IG5gPmiyNXXwRV
         T95dB8j+Ga324xmqs5Ynj4XTFm/gwmO3N3fI8Q4vlS80ZakdYb21yVF+QIoQyBJqXiBd
         PXqAb6PlOkba3wgUaZpuDXMeAC0VknppsyUJp2rdsW9RZkdIMvkgA5KzHwdIhKa09oO8
         Dz0gtTXitzaWCxvbK0bMjknEn3o8GRQ5aK7O+ltw+dSuHyRGRbSajLAh0roqrRLGqp32
         +lH539LRZqb1GJ7NoWtkunGcIT1GlZmmS4R0v2SQM2hFWfQBLlV3yag1TGahcc/zx108
         7Z8g==
X-Gm-Message-State: AAQBX9ekNiNH22ME0A/71jsea2L3u3zriyy1IIv4EqU0+zdczS8RSQMq
        HIIo2bP9oxDb1yF/fwW1pg+kojYKljg=
X-Google-Smtp-Source: AKy350Y1xrw62peIh9p0yOXDR29P75YDAFzVRtmFri5ZudcsRVZkmZZN51o4afjYDsZnaLJi7gM1MiDfCWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab67:0:b0:b75:e15a:a91b with SMTP id
 u94-20020a25ab67000000b00b75e15aa91bmr9985227ybi.6.1681150327149; Mon, 10 Apr
 2023 11:12:07 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:12:05 -0700
In-Reply-To: <CA+wubQA3HP2s6dq7JUvxHj8jkjfK5E__RenzAk7tyf3xtmgoJg@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-2-robert.hu@intel.com>
 <ZAtT5pFPqjM1Ocq0@google.com> <CA+wubQBWgz4YAi=T3MV82HrC3=gXSC_yD50ip0=N_x3MnTE1UA@mail.gmail.com>
 <ZBIFgH4YBC71n6KR@google.com> <CA+wubQA3HP2s6dq7JUvxHj8jkjfK5E__RenzAk7tyf3xtmgoJg@mail.gmail.com>
Message-ID: <ZDRRdchT2IHN7FUs@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
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
6=E6=97=A5=E5=91=A8=E5=9B=9B 01:50=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Please fix your editor or whatever it is that is resulting your emails =
being
> > wrapped at very bizarre boundaries.
> >
> (Sorry for late reply.)
> Yes, I also noticed this. Just began using Gmail web portal for community=
 mails.
> I worried that it has no auto wrapping (didn't find the setting), so manu=
ally
> wrapped; but now looks like it has some.
> Give me some time, I'm going to switch to some mail client.
> Welcome suggestions of mail clients which is suited for community
> communications, on Windows platform.=F0=9F=99=82

Heh, none?  The "on Windows" is a bit problematic.  Sorry I can't help on t=
his
front.

> > That leaves KVM's stuffing of X86_CR4_UMIP into the default cr4_fixed1
> > value enumerated for nested VMX.  In that case, checking for (lack of)
> > host support is actually a bug fix of sorts,
>=20
> What bug?
> By your assumption below:
>     * host supports UMIP, host doesn't allow (nested?) vmx
>     * UMIP enumerated to L1, L1 thinks it has UMIP capability and
> enumerates to L2
>     * L1 MSR_IA32_VMX_CR4_FIXED1.UMIP is set (meaning allow 1, not fixed =
to 1)
>=20
> L2 can use UMIP, no matter L1's UMIP capability is backed by L0 host's
> HW UMIP or L0's vmx emulation, I don't see any problem. Shed more
> light?
>=20
> > as enumerating UMIP support
> > based solely on descriptor table
>=20
> What "descriptor table" do you mean here?

There's a typo below.  It should be "exiting", not "existing".  As in "desc=
riptor
table exiting", i.e. the feature that allows KVM to intercept LGDT and frie=
nds.

> > existing works only because KVM doesn't
> > sanity check MSR_IA32_VMX_CR4_FIXED1.
>=20
> Emm, nested_cr4_valid() should be applied to vmx_set_cr4()?

No, what this is saying is that if a (virtual) CPU does support UMIP for ba=
re
metal (from the host's perspective), but does NOT allow UMIP to be set in a=
 VMX
guest's CR4, then KVM would end up advertising UMIP to L1 but would neither
virtualize (set in hardware) nor emulate UMIP for L1.

The blurb about KVM exploding is calling out that in this very, very theore=
tical
scenario, KVM will fail on the very first VM-Entry (if not before) as KVM u=
ses the
host kernel's CR4 verbatim when setting vmcs.HOST_CR4, i.e. will fail the c=
onsistency
check on a "cannot be 1" bits being set in HOST_CR4.

> > E.g. if a (very theoretical) host supported UMIP in hardware but didn't
> > allow UMIP+VMX, KVM would advertise UMIP but not actually emulate UMIP.=
  Of
> > course, KVM would explode long before it could run a nested VM on said
> > theoretical CPU, as KVM doesn't modify host CR4 when enabling VMX.
