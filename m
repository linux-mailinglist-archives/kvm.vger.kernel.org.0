Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880E27ADE13
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjIYRxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjIYRxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:53:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E497E10F
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:53:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so2430a12.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695664379; x=1696269179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQAUGuB1GRbrSoxuGxorFHaO65+s+bdtuVDBMkIEFgw=;
        b=nU5beNhdDBf2+PDbj4fCNif71bqU7SrsNZgv44L3bzltF8Lek8d5WIQMOthj9geUgB
         WCtg2bLmiHjRcrLlV7s0Zg97VBaBxJNOAd8GepdFTUZAljD82u1Hmn7dRBpJgFxY4/zr
         ApUDM2jskQeSgLuoJV+NF+89gAraT9Dq7+O4WlvxRQdlbLynmxRcjamyew3hRaIOVEKT
         MhbKzaYchvVczMb84vVh0v4bSLZkl5m0CPGTzl6XXOGK/fs9zrn6Gk5hWJLC3JBGC7Y8
         c6aiP8J+32IDMx45kfY8JUdhatINKvESSyz8Xf9T6IrOfFcCxTPZ0JVLUKCqdZDq6jVE
         5EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695664379; x=1696269179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQAUGuB1GRbrSoxuGxorFHaO65+s+bdtuVDBMkIEFgw=;
        b=IazrmN2/hQ79Ke4/+vNlM5LQn1xq1ETRscjvuxkwBO1uGre1MZXGuPSMJ7ORg8JbFV
         fuwsxr8j8nOwlTXNhB3nPfP9kstXXpL+Qc0JhzIMLyhAwetJsNoUaBlPnjbN0Q5m8D4P
         ypuum7mE8QaAvveKVJoYrKVZjKf8pv2m6+NvYgCcJelUzNntpUpyFXzVK/Bt9eS1kYOq
         iZZNUv2IUEzavr7LmYtIRbUff/q8biQCYLvOFfGvXsoL4JzVIJrxViUVzze4DS3iyCcf
         5HfPe/OvlyIBENhEl1VNuaBGGBxbTJ+oL0zbtrg2Ho8wtf/Wr0RHxrbKymC5xQwKDonn
         JnxA==
X-Gm-Message-State: AOJu0YxDrf99KXFB8esAUr9LsW8npCoHetPEHCEoe5EKj1461TzTjj0L
        oQtGu8erHeuvMQ3wDaI6iMxheQqM1GbCKrjJQlX8VQ==
X-Google-Smtp-Source: AGHT+IEVLTmA816npkncGLkEzDkSP+NwzY4DunzPsUZHljlbPbwOZ/440I6YPkmqsrbpqAfAAMgMxG/e5MsxqpIcOdA=
X-Received: by 2002:a50:d61c:0:b0:51e:16c5:2004 with SMTP id
 x28-20020a50d61c000000b0051e16c52004mr10587edi.6.1695664379205; Mon, 25 Sep
 2023 10:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <20230901185646.2823254-2-jmattson@google.com>
 <ZQ3bVkWoUerGufo9@google.com>
In-Reply-To: <ZQ3bVkWoUerGufo9@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 25 Sep 2023 10:52:44 -0700
Message-ID: <CALMp9eRBH=MKGeXxy+a-OWRCPJEw4hYtrB_V60AAbWk8Eg--VA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:22=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>The SDM doesn't explicitly state that mask bit is left
> unset in these cases, but my reading of
>
>   When the local APIC handles a performance-monitoring counters interrupt=
, it
>   automatically sets the mask flag in the LVT performance counter registe=
r.
>
> is that there has to be an actual interrupt.

I assume you mean an actual interrupt from the APIC, not an actual PMI
to the APIC.

I would argue that one way of "handling" a performance-monitoring
counters interrupt is to do nothing with it, but apparently I'm wrong.
At least, if I set the delivery mode in LVTPC to the illegal value of
6, I never see the LVTPC.MASK bit get set.
