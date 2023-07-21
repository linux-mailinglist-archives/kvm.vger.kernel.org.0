Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3455E75D434
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 21:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjGUTTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjGUTSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 15:18:52 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABD9358C
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:18:48 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-4036bd4fff1so56341cf.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689967127; x=1690571927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CERdqkdwIcQiQxYqC1DaRigA/hWGJStpMLeqtLPt5nM=;
        b=jSW7UH5S3tzADjP07zcm5QK9xkGHAolPdgkO9EruuGpVksNuhkrednnWP4Loth1tGv
         JblPeDADT27/egNxibKsdNao5GxAS+lxNKVSxUkPEwjSu6nQhQOabcPqHxUlINQctF66
         62P+WGinstCJ9oM800Iw5QV3RnfQd6F+RT/fsK5LPmCyF/FCPQ4Z7PPvuBKqg8rwvqp1
         fucImR9lfIN9xRgRfL3mAkoEa+X4PQLT6LyU7lq/xzP5azeTHbpf7FDllnT7O3VXLECN
         RMvrukgHd6ada7vRF0MKmN70i3h7xq/6nCwtV/cIcC7INN/sTMyaTGgyBRkjgpsHJY9t
         QXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689967127; x=1690571927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CERdqkdwIcQiQxYqC1DaRigA/hWGJStpMLeqtLPt5nM=;
        b=VCQMaGxM+vC4Llr8RFsD5jxzYoEv3pyrbCzgIfo4z1pP8MaJ67h14Xyt317rKNbiDK
         IxIg8cgX8B36kLzvaeE3MJ/lrZos0QUSZ7PMmBeC1aLd0tFlHN/7HvtW50G1A6Rq9W6E
         Pit0FSvT+CL3LPFc3mVt+qjuvtjV/tcOrl/5hZCfH60nMAbOFEXEgkMeFh55k0MbOG+y
         BODty/KbBDcCjyLXCZJ+q1XHwRiasqMxiQNC6NUczCmF5NFglcbZ3F6A5fPDaoZiZdQh
         t21KC7vDhVomJr8qy0Zl/oOtJzPhemxW2eyzyohlpBXoCCPREsrqKlNGguGtO3g3IHbK
         qcRg==
X-Gm-Message-State: ABy/qLZ0dT4X2iDaNADTC+nWiZ+5iLMTE66ZP007p1eHu7RAjXYYwEcl
        q9fX3Obf7DaVoaSyLV1fv/uPkFPV6N/ldvsDmS9KUw==
X-Google-Smtp-Source: APBJJlFv3jPHC+E6LE1/QOXIm2gMb+3RA79/raFjYN7eQyztsMDu2Z/6Gd/GuzmQCz+NREpjI/8tdqKIyiZaEs2TmdQ=
X-Received: by 2002:ac8:7f56:0:b0:3ef:5f97:258f with SMTP id
 g22-20020ac87f56000000b003ef5f97258fmr45634qtk.16.1689967127432; Fri, 21 Jul
 2023 12:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com> <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email> <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email> <20230721190114.xznm7xfnuxciufa3@desk>
In-Reply-To: <20230721190114.xznm7xfnuxciufa3@desk>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 21 Jul 2023 12:18:36 -0700
Message-ID: <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 12:01=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Jul 21, 2023 at 11:37:42AM +0800, Chao Gao wrote:
> > On Thu, Jul 20, 2023 at 10:52:44AM -0700, Jim Mattson wrote:
> > >> And is it fair to good citizens that won't set reserved bits but wil=
l
> > >> suffer performance drop caused by the fix?
> > >
> > >Is it fair to other tenants of the host to have their data exfiltrated
> > >by a bad citizen, because KVM didn't control access to the MSR?
> >
> > To be clear, I agree to intercept IA32_SPEC_CTRL MSR if allowing guests
> > to clear some bits puts host or other tenents at risk.
> >
> > >> >As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] =
is
> > >> >such a bit. If the host has this bit set and you allow the guest to
> > >> >clear it, then you have compromised host security.
> >
> > ...
> >
> > >>
> > >> If guest can compromise host security, I definitly agree to intercep=
t
> > >> IA32_SPEC_CTRL MSR.
> > >
> > >I believe that when the decision was made to pass through this MSR for
> > >write, the assumption was that the host wouldn't ever use it (hence
> > >the host value would be zero). That assumption has not stood the test
> > >of time.
> >
> > Could you elaborate on the security risk of guests' clearing
> > IA32_SPEC_CTRL.STIBP[bit 1] (or any other bit)? +Pawan
>
> Please note that clearing STIBP bit on one thread does not disable STIBP
> protection if the sibling has it set:
>
>   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical processor
>   prevents the predicted targets of indirect branches on any logical
>   processor of that core from being controlled by software that executes
>   (or executed previously) on another logical processor of the same core
>   [1].

I stand corrected. For completeness, then, is it true now and
forevermore that passing IA32_SPEC_CTRL through to the guest for write
can in no way compromise code running on the sibling thread?
