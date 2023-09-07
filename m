Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D0796E38
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 02:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbjIGAv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 20:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjIGAv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 20:51:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D46B196
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 17:51:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d745094c496so435933276.1
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 17:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694047909; x=1694652709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUH5GNhw6h16pTv/SpzxbMt0geRMFmR0znGoV0rGo/s=;
        b=EDMgIp2Fg8jZACCGABvIr2K81MQC09LDy6lRf3T5DFI9m+qNuKt1Ziq/p+WM7iIJTR
         l/Rxm+iVHkbIokiz6N2CnpuuOPVcV97DB1wcd08MNaBx2MQ1RIuvlPAXr/axB+brZs8T
         XcabSzLbl590ZaAEh0SQwcI5MIOVB4kJyLsTUcAGXPXZbENnk+NtAcAUW1fzYGMxs0sI
         M5YbPYKQxHnt0Ri89cgPPgS/xEIpSSe02NCO6wS9BJyDL1JojaYCX8zFRebTvcR9dpYG
         2bB17uIrovhSq+3xYET+fYPhQ1T5wot2UrEP2Z13/vrue0qAh8zCSVUECr0KQp+FOPRb
         1FUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694047909; x=1694652709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yUH5GNhw6h16pTv/SpzxbMt0geRMFmR0znGoV0rGo/s=;
        b=Bhzn5HJbVMDVMdflqpEDWyztYlXHxLJTLPrU9P43LTB2k/X/gW+WsJgg7du9MHX/le
         XWZHyQ7ToNIby0AMBW+hwa2tVL7w8zKMVeexrcKF42IhDb8csJd7ElWEXLyHMKx3rIcc
         vvqyXzAzrqVPp7cBRcf1XNqBYXvrg67Ubpg7rwdEsVyHbqvKokcnMQOmVyOO1QQtHI7y
         n2QTff4Jt6DVq3kcj4nh32t0EpT4zuvipvcqKJuSr94nRdifuskLeDnpzycJf1gouTBC
         q5fqCcC1MAPh67kcwisbbOmAGgd9tIC8OdwSp671k3h9akHLVm/2rma4+Izo0Uh3b7DF
         /mOA==
X-Gm-Message-State: AOJu0YyYWhiHNQd3Gy4GrFo/XQrcXlmq0nmSP04NUGum2rkqbjk1Wf89
        IJISjjtJydv43y4zJV7YlrMwumPNVPI=
X-Google-Smtp-Source: AGHT+IGDlXZ5S/hNR4V4bNTd9qDl20qc8uf02HVuD2eHTTh8dnaVoxZ7rW3Z9vSE4dEeiY92HUP8MRNFNec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2543:0:b0:d4d:8ade:4dfa with SMTP id
 l64-20020a252543000000b00d4d8ade4dfamr462429ybl.1.1694047908942; Wed, 06 Sep
 2023 17:51:48 -0700 (PDT)
Date:   Wed, 6 Sep 2023 17:51:36 -0700
In-Reply-To: <CABgObfZ7MRShYm79NsH2=WwvTAcaoz5jUSBxPb57KEhotcr_oA@mail.gmail.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPeND9WFHR2Xx8BM@google.com> <CABgObfZ7MRShYm79NsH2=WwvTAcaoz5jUSBxPb57KEhotcr_oA@mail.gmail.com>
Message-ID: <ZPkemGED1QD7kgUo@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Sep 07, 2023, Paolo Bonzini wrote:
> On Tue, Sep 5, 2023 at 10:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Ooh, actually, maybe we could do
> >
> >         static bool <name_tbd> =3D !IS_ENABLED(CONFIG_KSM);
> >
> > and then cross our fingers that that doesn't regress some other funky s=
etups.
>=20
> It probably breaks gvisor-like setups that use MAP_PRIVATE mmap for
> memslots? It would instantly break CoW even if memory is never
> written.

Doh, I completely forgot about gvisor and the like.

Yan, I don't think this is worth pursuing.  My understanding is that only l=
egacy,
relatively slow devices need DMA32.  And as Robin pointed out, swiotlb=3Dfo=
rce isn't
something that's likely deployed and certainly isn't intended for performan=
ce
sensitive environments.
