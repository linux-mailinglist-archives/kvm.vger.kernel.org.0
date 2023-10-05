Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8A7BA81F
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjJERch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjJERcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:32:16 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA6D30ED
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 10:27:57 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-5032a508e74so360e87.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 10:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696526875; x=1697131675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7XiMb1pgpAFxLWD6alC9RmL+y1j3mmz1w57H6g7qLw=;
        b=KSs+53Kg0kyGrVI3EsN1eGcG2Zu5i30Wk+O3Um3ruPykvAfszTA3Y+DJzvqcjKGzEB
         U61tmD/Fqtoh34extaexd/SQOqe3uHU0y28iwEvTvGNqwTzj9OZ3WJD7bzZUKOxMNrd5
         GQpP/14wp3ROmo9WFOqxXbGcAJZqDeU960tQL9xMAY73VEGqdO+OwnZjcmGPdDy1cUaR
         oNpbHUi74tlsdVg+KC/Y97e0Gkty7LJaZo2DmLcMfvwjJdlYnAcrYMRWKagVIY7hxCVw
         ca2kCZ8O7BThD7qqewmHndGQo+wShElLWBUA/HEefBp8+PXISDUZ087XVz34brlXJVvi
         cd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696526875; x=1697131675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7XiMb1pgpAFxLWD6alC9RmL+y1j3mmz1w57H6g7qLw=;
        b=m3b4Od/B2/9U65p3R1T2gRa7mo2tFgXZ5ixWKBkFfrnCWODonXuGXpUH8DBn1AZsdE
         AJtA62ZRKnm/Q6r6/okvuFKoomjmWHJ7U1rT4QjVpuIPkEAV8dZd7bwMyww+7Rxig/Q7
         /UGi3ZxsYo5Kn/AZRWCYLAxyX1X372oMk+wBKe8i1AoDV3P7ciyjcmVM3kwBIXWCC6ur
         X/QwghEoP4lZZGZjELts39te2Gx3sI4qvZzZsuPdX3YxG8qgdItCUfiAuQmUx1s+VR7e
         OrmaRxCP8CavIdrjcq1GtUm7o8ZFLzuo1v8CirFEfEd9EF2Q5SPQ2LLSHPuVqtMp/cYL
         ZLcA==
X-Gm-Message-State: AOJu0Yydl05bElA5pPPeWZxOfJkTQw1xM4xLC1jA8myT+KRMuXizj9Tg
        FQqdkbcpRBqAxpyZQedmeRfBg8bvCZ+zdWNhxI3290BLq9PEKLUhjNg=
X-Google-Smtp-Source: AGHT+IHdIFU0zGX5w2gRSo0ggFIvjZdhp7uCzH8hvETpQCpiD5AvXxp5kMeO2grkwKHAi62mufV7/qDm9pH983jhKN8=
X-Received: by 2002:ac2:59c2:0:b0:501:b029:1a47 with SMTP id
 x2-20020ac259c2000000b00501b0291a47mr58317lfn.1.1696526875122; Thu, 05 Oct
 2023 10:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local> <8c810f89-43f3-3742-60b8-1ba622321be8@redhat.com>
 <CALMp9eR=URBsz1qmTcDU5ixncUTkNgxJahLbfyZXYr-2RkBPng@mail.gmail.com> <b9a454c9-e8aa-02f0-29d5-57753d797cfb@redhat.com>
In-Reply-To: <b9a454c9-e8aa-02f0-29d5-57753d797cfb@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Oct 2023 10:27:42 -0700
Message-ID: <CALMp9eQ70wepTpmw9O3D+YnN1kaQ1m7etE4sa24bnya-vNai9Q@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 10:14=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 10/5/23 19:06, Jim Mattson wrote:
> > On Thu, Oct 5, 2023 at 9:39=E2=80=AFAM Paolo Bonzini<pbonzini@redhat.co=
m>  wrote:
> >
> >> I agree with Jim that it would be nice to have some bits from Intel, a=
nd
> >> some bits from AMD, that current processors always return as 1.  Futur=
e
> >> processors can change those to 0 as desired.
> > That's not quite what I meant.
> >
> > I'm suggesting a leaf devoted to single bit negative features. If a
> > bit is set in hardware, it means that something has been taken away.
> > Hypervisors don't need to know exactly what was taken away. For this
> > leaf only, hypervisors will always pass through a non-zero bit, even
> > if they have know idea what it means.
>
> Understood, but I'm suggesting that these might even have the right
> polarity: if a bit is set it means that something is there and might not
> in the future, even if we don't know exactly what.  We can pass through
> the bit, we can AND bits across the migration pool to define what to
> pass to the guest, we can force-set the leaves to zero (feature
> removed).  Either way, the point is to group future defeatures together.

Oh, yeah. Your suggestion is better. :)
