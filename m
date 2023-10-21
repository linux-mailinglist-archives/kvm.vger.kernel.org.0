Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B057D1A93
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 04:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjJUChE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 22:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJUChD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 22:37:03 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFEED78
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 19:37:00 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-57ad95c555eso827261eaf.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 19:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697855820; x=1698460620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ouyQBwQ4qh6wsB5x6fZJ+oP0bTkrI0Wymndb1rjzvk=;
        b=Ce36C8BTRZ3I6WrxyJrapqZKDeQLOzKIN0+cNAJCq8XIjUk2E975Fnnhg1FtBRme0J
         zGcIU1gE6VmvYyjZ28vk1FgRxT26NK4O6pbS0XTUOYvwF21uOsgvpF64Vy6mmveVQs6f
         T+Pmh7v8MMRPbmRmTzr0Y32eqixAE3zozwqpgkcFpwL5U4VULMedLoSDcBvMHluhcwQz
         f6h5fJSCd/hG8AMwcaqSn9EoV0a1ufcqEIdTHW/0uA9IJ/vELevfnVGlamBEiVsff+y+
         LvqiWM1NUlwMsvXVuyxDulkqcpTyt5seWo2U+086LHyx9+CO7TfYsPZIhK0dLAsZ+crF
         f3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697855820; x=1698460620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ouyQBwQ4qh6wsB5x6fZJ+oP0bTkrI0Wymndb1rjzvk=;
        b=pmmd+ymK9TFeAzb8/JNQCaCe4uSWH9Y4oulK9TPCuXPeIZZO3rir7d8uNbesCGo7mY
         B7V1m9dYPprGgkKD/Tke/yoRA471TAA0JifjT7u5K5/8SeFolNMv+XC83OCUx/gTjGy/
         o0jvImZP8M9lUl9DqhtEXJOL0C8R/UnLMSAKVilcjX7MDfxnXxLEROfQhDMxrq0+kTg5
         Xc07KQdu3qI0Q8rWuYt83vNdGHzfgPWuluor1hYdaf+e/T0KdA2Go2JqtJe85KBQXgju
         hvT5isVPf0IU35S/RC4DpYAk5iHwgCkmVhynepg5ut4/a9TIC+LhIVAUMC6C3vF36yu/
         5hTg==
X-Gm-Message-State: AOJu0Yw2qgxFKyUrTk3QFxxYAD0NNIhx8V2oeog5kFEN3KlAk74B7Ffk
        +ZKgEwmPQ7PDSWgsZCxqkPPo/BiIhkwPCHmQ4m091g==
X-Google-Smtp-Source: AGHT+IGRmrBlhw7ztCnH+tx+VClAto6ArV7p14pPZgGxuzEFQlE7XfmIFaFfXPaZ9eEXpeWHrH8yFETRUSh200wrQiA=
X-Received: by 2002:a05:6870:7a06:b0:1e9:e0df:eeec with SMTP id
 hf6-20020a0568707a0600b001e9e0dfeeecmr5062745oab.37.1697855819937; Fri, 20
 Oct 2023 19:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231002040839.2630027-1-mizhang@google.com> <169766419668.1911126.2774635531681023250.b4-ty@google.com>
In-Reply-To: <169766419668.1911126.2774635531681023250.b4-ty@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 20 Oct 2023 19:36:24 -0700
Message-ID: <CAL715WKeA=_qY_oRtG7HzbFZ_PsKoRusOy--8nUzTmHiAM-UoQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Service NMI requests after PMI requests in
 VM-Enter path
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>, Xin Li <xin@zytor.com>
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

On Fri, Oct 20, 2023 at 3:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, 02 Oct 2023 04:08:39 +0000, Mingwei Zhang wrote:
> > Service NMI requests after PMI requests in vcpu_enter_guest() so that K=
VM
> > does not need to cancel and redo the VM-Enter. Because APIC emulation
> > "injects" NMIs via KVM_REQ_NMI, handling PMI requests after NMI request=
s
> > means KVM won't detect the pending NMI request until the final check fo=
r
> > outstanding requests. Detecting requests at the final stage is costly a=
s
> > KVM has already loaded guest state, potentially queued events for
> > injection, disabled IRQs, dropped SRCU, etc., most of which needs to be
> > unwound.
> >
> > [...]
>
> Applied to kvm-x86 pmu, thanks!
>
> I made a tweak to the code and massaged one part of the changelog.  For t=
he
> code, I hoisted PMU/PMI above SMI too, mainly to keep SMI+NMI together, b=
ut
> also because *technically* the guest could configure LVTPC to send an SMI=
 (LOL).
>
> Regarding the changelog, I replaced the justification about correctness w=
ith
> this:
>
>     Note that changing the order of request processing doesn't change the=
 end
>     result, as KVM's final check for outstanding requests prevents enteri=
ng
>     the guest until all requests are serviced.  I.e. KVM will ultimately
>     coalesce events (or not) regardless of the ordering.
>
> The architectural behavior of NMIs and KVM's unintuitive simultaneous NMI
> handling simply doesn't matter as far as this patch is concerned, especia=
lly
> when considering the SMI technicality.  E.g. the net effect would be the =
same
> even if KVM allowed only a single NMIs.
>
> Please holler if you disagree with either/both of the above changes.

That works for me. Initially, I thought you would touch the SMI code
(if so, I would push back). Nothing like that shows up in the change
so LGTM.

Thanks.
-Mingwei
>
> [1/1] KVM: x86: Service NMI requests after PMI requests in VM-Enter path
>       https://github.com/kvm-x86/linux/commit/4b09cc132a59
>
> --
> https://github.com/kvm-x86/linux/tree/next
