Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98D7ADE4F
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjIYSAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 14:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjIYSAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 14:00:50 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7674F112
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:00:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c615224e02so25718355ad.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695664844; x=1696269644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OavTTzOL6q1dcYXXMBZ+vp1pvr+8P33EslFWiRhI8Yw=;
        b=jqmoAXuXJDlL/gEh7OECOBZGf7I+m5X4SObdg9uQCLXzaI/mTplw5WOVrBpzD3zIUS
         0/l3VGAd5sVx/D3PtMpLnwSGWVW1/Y7Lu+7fJIhyaNkuPsz837ruwqRvHkOhKAuaj9Hi
         RVtvCbb6+uVvUpMbSJqOhFYIlV07/rHKX35OI1RgJWtGqDDkx/kzfnw6y0/c0Q2v3a4K
         nFvIiTMx/vVs6S7MDdrIYZ6FkTql0o0b9CKFgvk5ggcBh/8/dJ41/06AcDyrcN1mOmW3
         /iB0IVMQPZlbwtMvWFvMamR9l9mXgsy32xKLIzDxOj25lQNXfTvBDgqymJTmazRYHnDl
         7Q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695664844; x=1696269644;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OavTTzOL6q1dcYXXMBZ+vp1pvr+8P33EslFWiRhI8Yw=;
        b=D/aWhldjiNuGngbRA4hR1YonoQL+G5sY3TRYxRY9Yz/ksHK0RQGnLS5bjyIl0quckG
         FFYuP3flwB6G0gjUMKHjT9WOYTdBlCbJeosCV9rO8yjoPII4SWECmw7DUD97rFQUo3xd
         qN4wtH0it9YTSgoK9TDBBNq45GrAIfVG5K3C1Rn5BXYJ87k4QKwvlRVYvZf9bG64Io3P
         Hov8fEU2JxBUuZG60fccXSZ9NupvwPiGJrE2GA5HzTFeRiDGXJyC4mwrcuVjemxWlVqd
         6z1UUbnUIKnmXumlO+kj9dfmlYs4hre1B2hwL3ARdx7tEiHBWbt2m0Y30X2EQtn0xRSj
         uBSg==
X-Gm-Message-State: AOJu0YyUMHfUHm1iXw+i5YfHP8CCD3EsrspRMlkCX1ea6qlRNqG17pLJ
        rrqhMXCzsHRIrZNAENNVAl6rCbdsdzE=
X-Google-Smtp-Source: AGHT+IGSCIhiwk+hP5zR2qLtVS823QXJ/VIZVV7XvnuoUwjCkBqMD9Xin0erMlWfe1279dit8BhDhxAaLHw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d2:b0:1bc:7c69:925c with SMTP id
 o18-20020a170902d4d200b001bc7c69925cmr76067plg.10.1695664843961; Mon, 25 Sep
 2023 11:00:43 -0700 (PDT)
Date:   Mon, 25 Sep 2023 11:00:42 -0700
In-Reply-To: <CALMp9eRBH=MKGeXxy+a-OWRCPJEw4hYtrB_V60AAbWk8Eg--VA@mail.gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <20230901185646.2823254-2-jmattson@google.com>
 <ZQ3bVkWoUerGufo9@google.com> <CALMp9eRBH=MKGeXxy+a-OWRCPJEw4hYtrB_V60AAbWk8Eg--VA@mail.gmail.com>
Message-ID: <ZRHKynolEOlbJszo@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
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

On Mon, Sep 25, 2023, Jim Mattson wrote:
> On Fri, Sep 22, 2023 at 11:22=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >The SDM doesn't explicitly state that mask bit is left
> > unset in these cases, but my reading of
> >
> >   When the local APIC handles a performance-monitoring counters interru=
pt, it
> >   automatically sets the mask flag in the LVT performance counter regis=
ter.
> >
> > is that there has to be an actual interrupt.
>=20
> I assume you mean an actual interrupt from the APIC, not an actual PMI
> to the APIC.

Yeah.

> I would argue that one way of "handling" a performance-monitoring
> counters interrupt is to do nothing with it, but apparently I'm wrong.
> At least, if I set the delivery mode in LVTPC to the illegal value of
> 6, I never see the LVTPC.MASK bit get set.

Heh, you could complain to Intel and see if they'll change "handles" to "de=
livers" :-)
