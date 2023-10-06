Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03487BAFA4
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 02:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjJFAgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjJFAgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 20:36:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E5ED8
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 17:36:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a507986ed6so23658547b3.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 17:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696552595; x=1697157395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFGyyoIZBiPvd1jiREWMi+h6K+SB/tS5bqtQENPZq7c=;
        b=aqT4ORo/l10vL+kqA1ASydM9+OG+3ClmXzBlF+/zjfVZGWLomMNC0Eh8/cxIArJdm7
         Mk8LyXkprs31nyitgKoZO/LKuK4eKgMIO29uR/bABdAcgmI4MPBUoitFXYnvvLaz6IeW
         A+NpCvS0UoRz7ACdDIwJkNJ5/Acw3FAXOtyt/31tozTSo5hPioJt2Kih9NvroMsz2aCQ
         7pkUs8Xro6BB8GW0Q6lJIMv1gmJkLjasfztUIlccwM6oji5KVBxGLQRLpFJYBhlgY36V
         mLkDtomBmnVd5lhIdZhOB0Qc56mxtKJISLwt7KdsF2Lrne1ZS0mfZ/p+lcPWNVMzBQjb
         SVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696552595; x=1697157395;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FFGyyoIZBiPvd1jiREWMi+h6K+SB/tS5bqtQENPZq7c=;
        b=lUGDvABOGkBhHmFCPS1i1DShnu46UbF3EqvA30IUWrw25pYk2UTJmy2nDJgr6dqf2V
         K7i84qAGBkpt549xgysdMbyrA6CVVIHsnS1GLBzXIS5wD9qGUA6/o8Q/j1n82LWOcPJ/
         cEGCVGpv8cJoHZOpDroshizXW8wISUsSVZ3UWuWvLk+W3gK3idNCnJNYI+DGz/3cu1GR
         PUQusJBv7CevPZtfik4l3k6lIti8SYksM3F4zSRLjK9hc81TkCNC3VhfR0dglvcjNesi
         1hjsMMhOHPyIaJnTS00cisy4dEhzOUAuon/6R/pdi85IlMj2QQemlx6pjNO3XOdoNMvC
         cXEg==
X-Gm-Message-State: AOJu0Yx9yK4cxVzPW+w8LKv+GHzenzpikbC8NFN3w+amVTiGUQJ2UD7J
        izDi883xVwLGXu1nNAuL/lYY4efbW6s=
X-Google-Smtp-Source: AGHT+IHMHN7swFenOS6CqX1CulxSvfnTXe0NuHV3YDhFkwlpsdK+cW1savjCK047jlFW+8MdB9+J5s/Vl5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:988:b0:5a4:f657:5cb8 with SMTP id
 ce8-20020a05690c098800b005a4f6575cb8mr118734ywb.10.1696552594876; Thu, 05 Oct
 2023 17:36:34 -0700 (PDT)
Date:   Fri, 6 Oct 2023 00:36:33 +0000
In-Reply-To: <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-7-amoorthy@google.com>
 <ZR4Qr4Yzj7nUNIT3@google.com> <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Message-ID: <ZR9WkaObdPTIc07-@google.com>
Subject: Re: [PATCH v5 06/17] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
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

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > ...isn't helpful because it doesn't provide any
> > insight into the actual impact of the change, i.e. requires the reader =
to already
> > know exactly how and when kvm_handle_error_pfn() is used.
>=20
> Ah, true. Hopefully the following is better?
>=20
> > KVM: x86: Annotate hva->hpa translation failures in stage-2 fault path
> >
> > Set up a KVM_EXIT_MEMORY_FAULT in cases where the stage-2 fault exit
> > handler successfully translates a GPA to an HVA, but fails to translate
> > the HVA to an HPA via GUP. This provides information to userspace which=
 it
> > could potentially use, for instance to resolve the failure.
>=20
> Maybe the "via GUP" isn't really doing anything there

Yeah, drop GUP.  Not all pfns are resolved via gup(), e.g. see hva_to_pfn_r=
emapped().

Actually, I would hedge on the "HVA" part too.  It's an accurate statement =
for
both ARM and x86, but only because writes to readonly slots get treated as =
MMIO
(stupid option ROMs).

And what part of the translation fails isn't important, what's important is=
 that
KVM is exiting to userspace with an error.  Using "can't resolve the pfn" i=
s fine
and desirable, but the changelog should first focus on the important outcom=
e,
which is that KVM is now providing more information when throwing an -EFAUL=
T at
userspace.

Something like this?

  When handling a stage-2 fault, set up a KVM_EXIT_MEMORY_FAULT exit if KVM
  returns -EFAULT to userspace, e.g. if resolving the pfn fails for whateve=
r
  reason.  Providing information about the unhandled fault will allow
  userspace to potentially fix the source of the error and avoid terminatin=
g
  the guest.=20
