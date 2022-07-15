Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7513F576A6B
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiGOXGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiGOXGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:06:35 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0386D8B4A1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:06:35 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-10bffc214ffso9468371fac.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBpXtEslnV1zurvmWEIDiRzGKqnjEUmVJoFW6W9qWCw=;
        b=AECQ0eHEqmcRYhw/kZaytfxobirCfOqjKbk7//nSJ87Bw9hMpidynMX+QaIk0VUI5O
         iHNnNLHUStvEkFZ9O7Jbf/Xqqrvods4PMgTxcqJzPLHWW4BzOKzYuG/+BEgP6V3t9XTB
         LoGIe6NRjIoYGor1s3QyYmhDXT0nn0nuup5cgmfulhkcsULKU1V22NEYCLNP4wJftyg8
         pWlmK/tPSHI6BCKkvqrxOmdz4+mffWYtXZ3ZPQQ2cL0gECDioTEYSrFvVu/KUStlW2zR
         WRI/3qDj/hdlTbRDmWEVxaFWgP1TZfR949+D1CPbIQPAlrR2evnu1Oy9FVERBGc1ePtb
         icfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBpXtEslnV1zurvmWEIDiRzGKqnjEUmVJoFW6W9qWCw=;
        b=OAD08Nk4r8fi68sjTyU8jipcywrIFxVcVFTTvGQdQWCLZWAHuWY/5lMp1Wl57cQzc2
         sWTzHUFvkm4qXUP7nDR/pJcInrqD5wMmPT8AhOWUSFhROw/Ripm4BvA9Tb8MxFXxNFEy
         VrgGlRzl20bvYTmGPNt/yMQdAcZXA1RUTiZDmvBGaBMfr/2B5Rcr3XCKBWnanH0NN3VG
         KyGe4v5C1YLZl06ty+0rzWWevgeiuQqR+crOIMLYRuS0dR95SUUPc4FRQ3G2vcogCjpR
         EMdSuzN+RMmxPqQc/2v4QbgtQkq/EvGV4CXdezPHfGtsJlMZeoZ12Hcr9cALP9xjbBix
         9Eow==
X-Gm-Message-State: AJIora+gcSWObzHgJMp+AzvqlSsnEd6HJr05/pkidsyjj3OhlslzxGnd
        MLyKpIs3mDZrkLFV8ELs1UGn7x43riLR7r+e8MewhOpaaTU=
X-Google-Smtp-Source: AGRyM1u1OTXm2QGLPrI1m/Pl+zrnOXkxWwMmzH8915eiu6wZd+mbVdweoU84R3ujtobf5TgYhtrJSnbOzEOuYLsKi/U=
X-Received: by 2002:aca:5e05:0:b0:337:bd43:860b with SMTP id
 s5-20020aca5e05000000b00337bd43860bmr7988724oib.181.1657926394114; Fri, 15
 Jul 2022 16:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220715230016.3762909-1-seanjc@google.com> <20220715230016.3762909-2-seanjc@google.com>
In-Reply-To: <20220715230016.3762909-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 15 Jul 2022 16:06:23 -0700
Message-ID: <CALMp9eQdzZK4ZAyQZXUWff_zuRRdr=ugkujWfFrt9dP8uFcs=Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: x86: Reject loading KVM if host.PAT[0] != WB
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jul 15, 2022 at 4:02 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Reject KVM if entry '0' in the host's IA32_PAT MSR is not programmed to
> writeback (WB) memtype.  KVM subtly relies on IA32_PAT entry '0' to be
> programmed to WB by leaving the PAT bits in shadow paging and NPT SPTEs
> as '0'.  If something other than WB is in PAT[0], at _best_ guests will
> suffer very poor performance, and at worst KVM will crash the system by
> breaking cache-coherency expecations (e.g. using WC for guest memory).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
What if someone changes the host's PAT to violate this rule *after*
kvm is loaded?
