Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD29478F1FA
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343812AbjHaRcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbjHaRcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0737CFF
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693503122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8FdFcMS4h0jDMyeMR6ivKaAEr8chG3zE9fOpBunNMw=;
        b=OZsz+iGuC5avT7XImK6s5jux4+L2Uf/jg276aix9WMZNn+AHrQhzVDbpy7l7Bhfn/Y1tHd
        cLXRAipCqxuXLdD1O4gm4wIaMF8Qy4+Lua0pXQyXO6L7CiQJYyMejKGicBSfGjrSwStpU6
        JQyB+gcu2ciLZ6tuBmmriB/WaJ0t+kw=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-OLUeyWrpNzm1qRTvOa0_uw-1; Thu, 31 Aug 2023 13:32:01 -0400
X-MC-Unique: OLUeyWrpNzm1qRTvOa0_uw-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-44d5a0d2dd4so447734137.2
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693503120; x=1694107920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8FdFcMS4h0jDMyeMR6ivKaAEr8chG3zE9fOpBunNMw=;
        b=ARtcMBcXeY8OHy/ZgEjqB4V3kRww/ux9M1dj0Jo+2HP4XbNNb56ngh1tDR5lm/9MW9
         CkHkjlQzzozKXLK9MVh+Bc/KiAdnbzION4ROVWz3OpPm4focpz0eBBSwK+OqpOT7VK7g
         LDGYEDCnBGQ3DiwPgoJrd3grmOXVtFphXURNGIte7hhVU08bW3QsXQLNtVO4mOHFr3lw
         byjWwF7uDP9W7mTUMMIvVHiVfhoBugROa8Fm3ee41EMMcAw7Vwh7HFfJN+0gpf9D5LX6
         PAPnbqrkbLWc7QuJFQ7ayf44BN0u9ymXC+tAJ1GgO8hsIgwUhA7ZaFbJ9YqI7uxVNP2L
         j3Jg==
X-Gm-Message-State: AOJu0YwOMQcPp1/BFy26i8oOczquyZhWNzjq32ja2E8gmkwCilMC++zo
        z8W091gQAKkAOPXjAN6ztdSaoTOG5PmftF67OQm4XkLr5vU76RoJmR/dma4wzfZzqW5PNBXJgZy
        PWqPQDlok1UhxUe7lkIgtdpoDrhPA
X-Received: by 2002:a05:6102:3662:b0:446:e948:ebd4 with SMTP id bg2-20020a056102366200b00446e948ebd4mr210156vsb.21.1693503120594;
        Thu, 31 Aug 2023 10:32:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQJ/d297UW18m4y7qpRVkmnuERtzakts8x18oMJVj2wFynbJaGfAkSxBCY8QI2oCIkg6+7V0ikwkx9oUMRL/8=
X-Received: by 2002:a05:6102:3662:b0:446:e948:ebd4 with SMTP id
 bg2-20020a056102366200b00446e948ebd4mr210145vsb.21.1693503120360; Thu, 31 Aug
 2023 10:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-5-seanjc@google.com>
In-Reply-To: <20230830000633.3158416-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:31:49 +0200
Message-ID: <CABgObfYww88yuuwSMNgLMq3KGm_2aGQsWDFucv+qaJOQgXGv3Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: PMU changes for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 2:07=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a light round of PMU changes for 6.6.  Basically just a singl=
e
> cleanup.  Note, there's a counter truncation fix that I have been neglect=
ing
> for a few weeks[*], I'm planning on getting back to that after the merge =
window.
>
> [*] https://lore.kernel.org/all/20230504120042.785651-1-rkagan@amazon.de
>
> The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b57=
4c:
>
>   Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.6
>
> for you to fetch changes up to 6de2ccc169683bf81feba163834dae7cdebdd826:
>
>   KVM: x86/pmu: Move .hw_event_available() check out of PMC filter helper=
 (2023-08-02 16:44:36 -0700)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM x86 PMU changes for 6.6:
>
>  - Clean up KVM's handling of Intel architectural events
>
> ----------------------------------------------------------------
> Sean Christopherson (4):
>       KVM: x86/pmu: Use enums instead of hardcoded magic for arch event i=
ndices
>       KVM: x86/pmu: Simplify intel_hw_event_available()
>       KVM: x86/pmu: Require nr fixed_pmc_events to match nr max fixed cou=
nters
>       KVM: x86/pmu: Move .hw_event_available() check out of PMC filter he=
lper
>
>  arch/x86/kvm/pmu.c           |  4 +--
>  arch/x86/kvm/vmx/pmu_intel.c | 81 ++++++++++++++++++++++++++++++--------=
------
>  2 files changed, 56 insertions(+), 29 deletions(-)
>

