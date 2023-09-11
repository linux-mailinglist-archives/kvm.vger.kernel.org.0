Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56D379BBB2
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjIKUsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243892AbjIKSJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:09:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF33106
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:09:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56f89b2535dso6347341a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694455791; x=1695060591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bK2/eL0z9+3K4o1M3scbW3htV7/trvxL3I3kzz/zD+g=;
        b=D9K33qnywW6nosBBSoodB+7WG4qjgFb/L5hwIY0t7VyHOCg+QaNk0D+C0GH5zXx1D3
         y0F+6/CjOnQDWkeITRVGO+I18Kbea26XJ+5EEMY7cXeqt9slSI0w6ru/gB85OQZipLUn
         VgWc8rvYKVqEXEjr83mRoTNf/Iug+fh2UQSJe8njdX7+sbJ7pGi+r+fE1XIrBwplbj4i
         0pGriOpxBDVGm/4ThiLxOeU4tRyoO/uZxFVd3C2Z8mUFyUjm3rz3xOaSBWfy/KafhAjk
         q820QYD0vGDdPTR/6uADXFANGhujPB2hAw7kROUUAE/Vv5wfYtC4MmH0gdrAVA7ZHg0O
         H2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694455791; x=1695060591;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bK2/eL0z9+3K4o1M3scbW3htV7/trvxL3I3kzz/zD+g=;
        b=GvinQLshQpliuB+S346Ci5phmZq/zkynkuDezrFQtyYrf8Fcac3XNbXyjfdK6kJlxJ
         2sGbMFXdzpSW7P3ATLXUWIJmi1XEzkfktuic9ClGpA1yThg2mQ8CImceyAAAl0W5CEVx
         Ft3gSi+FwFTXfcwWNhSP2I/Ji7s+/WKXIZWrmmLEPqUM0Qe+R7yWylblN30TcfNU8giY
         bEFUYm8o4ZUwCC7vfKjsMId+1HAcgpgbmqLhfXxCjhyePnliIW+H1ghQ9DdviBIve7OW
         RMy0NUVUNz6ryGCkC3fV5ytH85EXwAq2BBC6d7mi6DKjJT6WJ7pEIl2KSOjHV6jV03A8
         2L4A==
X-Gm-Message-State: AOJu0Yw5pc77xv+7e9fo7oaW1dDdEYEDK4qy7vUnLpmda05EzkguPtg4
        aPQyeBn/6Ko8wyjbqp4aiILUF/rGVk0=
X-Google-Smtp-Source: AGHT+IHvJ+1KC78ad0HGpj9xqTWOK9v3QniyTnOOWRffm1eZ5xTzrs5C/sxRjH3w9ag8mYU0F5OLb5P01DU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7353:0:b0:56a:b197:12ca with SMTP id
 d19-20020a637353000000b0056ab19712camr2106042pgn.2.1694455791249; Mon, 11 Sep
 2023 11:09:51 -0700 (PDT)
Date:   Mon, 11 Sep 2023 18:09:49 +0000
In-Reply-To: <CAL715WKyS4sTH3yEOX2OyV+fxMLMOAV6tX-A7fvEAKEUGj8uxw@mail.gmail.com>
Mime-Version: 1.0
References: <20230911061147.409152-1-mizhang@google.com> <ZP8r2CDsv3JkGYzX@google.com>
 <CAL715WKyS4sTH3yEOX2OyV+fxMLMOAV6tX-A7fvEAKEUGj8uxw@mail.gmail.com>
Message-ID: <ZP9X7YvstWhS/pWn@google.com>
Subject: Re: [PATCH] KVM: vPMU: Use atomic bit operations for global_status
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> On Mon, Sep 11, 2023 at 8:01=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> > > Use atomic bit operations for pmu->global_status because it may suffe=
r from
> > > race conditions between emulated overflow in KVM vPMU and PEBS overfl=
ow in
> > > host PMI handler.
> >
> > Only if the host PMI occurs on a different pCPU, and if that can happen=
 don't we
> > have a much larger problem?
>=20
> Why on different pCPU?  For vPMU, I think there is always contention
> between the vCPU thread and the host PMI handler running on the same
> pCPU, no?

A non-atomic instruction can't be interrupted by an NMI, or any other event=
, so
I don't see how switching to atomic operations fixes anything unless the NM=
I comes
in on a different pCPU.
