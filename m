Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A237B37FB
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 18:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbjI2QbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 12:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjI2QbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 12:31:23 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC37199
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:31:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9adb9fa7200so195060566b.0
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696005079; x=1696609879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEESJxIPT4V2OdRKxrESII5B/xql/dGH8zhLSEdGpIA=;
        b=S6Og3fNyFd2TxHwhG5si291ut1A1ehOF5eAwtpWinyP4aKgFGKoCK1M+x0anL5eu4c
         7xm/L9EhHGtFI88+PIs5xjDwyCHJhVCM29ZLVxApvGd1rtRP37eYq577a3uDrPlZ3QKU
         I0uc8hVMFPzZ2mZn1ntjLm9jCc2Uy7H5Ep/pZU8WftVRxI8OQiStjgnRxdfq70Ku31Mi
         1p83wfqfCWLfnmXAiDKF2DwE4yInfmrBTVxPyFcnFqKOD2GGe40MgIwXIZu9U2jpY+0f
         lXgjzZWLVaP7bZiJuNMwtYD9RwGdrvZwejGJm34fAABPe+ApT2R/FGlhGF6jfcq8XuDf
         J2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696005079; x=1696609879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LEESJxIPT4V2OdRKxrESII5B/xql/dGH8zhLSEdGpIA=;
        b=ag3L+zC+/ZVi+q+q8Dn9sp9gYnJIEmoDamJoUZ5Wt2YjjX4CRN1rOpwjHM+g5cHU1U
         hMLpUNkkPCK1aaBlWGA061YbdgvXiVIF9fuJ93/0+uTHHhrwlwjIZLFhltVNBN2Lm/Ol
         GRFbITVbtrXfdSgCbQnEcFTL67Vti0J2bmziEnnqbzTmSzj+cx6Qne05FN9hvZHLnRns
         29X/8pZUM8bRL6WC4LSaiBpUwG8z6aoAuoRiZSR3CBEjC86JIlas0bmpeRTwQOC0R0I1
         7CBmxy3G+xtT+qY5xefC38h3zRA2n4LQFsiRubS8sQnwNl5XT7U6mdvyXKB5XcC1V8pQ
         3NbQ==
X-Gm-Message-State: AOJu0YyX6I8Gv4wQBeb9Vj40M7FfQv6upTiwsIUThPint9/MLjN9WHG3
        4S5xll8ccmJSaF3DhAtIttbcuYNky8TFjQyUHjL99SDYTpX3/cpXY5k=
X-Google-Smtp-Source: AGHT+IF0Ai1B4fJBn3+wI8pP2599xK8wIqhyB1MbotRml5IPLYUjQjBC3iJ88z/IphmtRoFscQUVXfJbdr0K4/PjrTQ=
X-Received: by 2002:a17:907:75c4:b0:9ae:6196:5094 with SMTP id
 jl4-20020a17090775c400b009ae61965094mr4491917ejc.30.1696005079337; Fri, 29
 Sep 2023 09:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230913000215.478387-1-hshan@google.com> <169592156740.1035449.1039175365762233349.b4-ty@google.com>
In-Reply-To: <169592156740.1035449.1039175365762233349.b4-ty@google.com>
From:   Haitao Shan <hshan@google.com>
Date:   Fri, 29 Sep 2023 09:31:07 -0700
Message-ID: <CAGD3tSxPDVb9sN1g+gTV5SykY57Szpx1SjEcmHJvK62u1fiXmA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: Fix lapic timer interrupt lost after loading
 a snapshot.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you very much.

I do have one more question. Is this fix going to be backported to
v6.3, v6.4, etc? Or perhaps that will be a decision made by other
maintainers? The reason for such a question is to decide whether we
have to keep the workaround for certain kernel versions.


On Thu, Sep 28, 2023 at 7:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, 12 Sep 2023 16:55:45 -0700, Haitao Shan wrote:
> > When running android emulator (which is based on QEMU 2.12) on
> > certain Intel hosts with kernel version 6.3-rc1 or above, guest
> > will freeze after loading a snapshot. This is almost 100%
> > reproducible. By default, the android emulator will use snapshot
> > to speed up the next launching of the same android guest. So
> > this breaks the android emulator badly.
> >
> > [...]
>
> Applied to kvm-x86 apic, thanks!
>
> [1/1] KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
>       https://github.com/kvm-x86/linux/commit/9cfec6d097c6
>
> --
> https://github.com/kvm-x86/linux/tree/next



--=20
Haitao @Google
