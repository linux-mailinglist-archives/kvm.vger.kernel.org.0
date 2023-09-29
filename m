Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038DC7B3D12
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 01:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjI2XvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2XvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 19:51:21 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE3BF1
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:51:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso1997804666b.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696031478; x=1696636278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2wajKZDIvMciUg8xByXy694yXFOrkLdNS5AmqD12N8=;
        b=M1GNPIvrdMjK5Hwth8nPOaaqJXdUMLtvHZSg3Wb7c47n9BtqwOuvIJvYmt/KB8e5UO
         IK6m/grLGWWEdHX19Qt8YvSObK8MjFLgHEfgVqwhqBDnoeyrkDTJbSmWbJfbGb0EOuOg
         z3EOmJ60grahBijemzbzpDPEuYYGCVFl0XYAxqS1D+yUUxdF0ayVRiAN/fbWeyocYwVv
         MmVFuXDwbabdQsBfyrx87xwXWqyfCdG0G3bykV/o0/eKJmIW3ALEt4mVo/SOPJZalMzY
         BSjEVokLXMpEtoGFW9n582ijt/wymWFgE1SstNfdQISV49lAvEz+3lyG4ZPrrhsx4kSk
         WROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696031478; x=1696636278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2wajKZDIvMciUg8xByXy694yXFOrkLdNS5AmqD12N8=;
        b=ZaShrtc9vg2hq6Gx56hKlkSxLBOyLZviLi2ZwhEI3qDjYg7F3LxpOYjpGAJKDybfK1
         zNbr9DyzWPadC6N7bc9aMdkPAn19LejBXWj2vbHkwaamQBS3+xosl7D8wQkcjVzl8AeY
         DmKrP02CgKsRWFX7LrYfqrPqVGW/SO2skIjLclRNeCQaREOInjs5nhEUM1hBOljFLPcd
         b1x+orMnUDRfW8qDEXGJC1iHXW+IKKhG/lkBK21xx0b5N4JSlMvgUa+adww+dOpQMAvZ
         xrCjQD5XIqzndI+K+FMpOOexp4VFaJfjABbWPpuRbsozJI1VFZS3ZobOfd2xCqOxfNrl
         moeg==
X-Gm-Message-State: AOJu0YzKmyoti4VCqcICubwFiyfvDKCq3HaKT/hRGTXOPkaWwxsl2S+d
        BEwh9HM04BQ1TrsiYGVI5nlthplD6Rkz7OLdedYLsQ==
X-Google-Smtp-Source: AGHT+IEmFuWWbtxm0Y5UkJSA7NqsH73Vwu6P6ZHuEt8BdB70iZoIroQQ1XowS9SbFDIY6aGZoRGoBaUE26YmOWgZs64=
X-Received: by 2002:a17:907:75ec:b0:99e:39d:4fa7 with SMTP id
 jz12-20020a17090775ec00b0099e039d4fa7mr4805914ejc.22.1696031477774; Fri, 29
 Sep 2023 16:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230913000215.478387-1-hshan@google.com> <169592156740.1035449.1039175365762233349.b4-ty@google.com>
 <CAGD3tSxPDVb9sN1g+gTV5SykY57Szpx1SjEcmHJvK62u1fiXmA@mail.gmail.com> <ZRcFR6Tf-9QzfbnD@google.com>
In-Reply-To: <ZRcFR6Tf-9QzfbnD@google.com>
From:   Haitao Shan <hshan@google.com>
Date:   Fri, 29 Sep 2023 16:51:06 -0700
Message-ID: <CAGD3tSw0y=NYf7h1TvDW_w=yR0ckqwmt7cdaLM_26LNXJArXLQ@mail.gmail.com>
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I understand now. Thanks!

On Fri, Sep 29, 2023 at 10:11=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 29, 2023, Haitao Shan wrote:
> > Thank you very much.
> >
> > I do have one more question. Is this fix going to be backported to
> > v6.3, v6.4, etc? Or perhaps that will be a decision made by other
> > maintainers? The reason for such a question is to decide whether we
> > have to keep the workaround for certain kernel versions.
>
> It's tagged for stable, so it'll get automatically selected/backported fo=
r stable
> kernels so long as the patch applies cleanly.  That won't include 6.3 or =
6.4
> because those are already end-of-life, i.e. not LTS kernels, and not the =
most
> recent release.
>
> If the patch doesn't apply cleanly, e.g. I highly doubt it'll apply as-is=
 for 5.15,
> then someone has to do a manual backport, where "someone" can be anyone. =
 Sometimes
> that's a maintainer, but just as often it's someone that really cares abo=
ut fixing
> something in a particular kernel.



--=20
Haitao @Google
