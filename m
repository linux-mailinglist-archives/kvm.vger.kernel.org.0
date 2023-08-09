Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613A27762A2
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 16:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjHIOiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 10:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjHIOiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 10:38:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63461FFA
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 07:38:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe1455e7feso2796e87.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 07:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691591902; x=1692196702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIYHqN573i4m0xBR4po1MavQBRxO9IhPxpT2FqODpvA=;
        b=TvniPABn8pq1qp5Ziy5FMSj67rVRNehgZsdJglTihNL2JllM6eyFRmS5CjOBWPXTOB
         iWjwQNY6oO3eCKwYXcWHCEWsXuMxiWNPeuDed8byUdtgd+DpRHISnFqPxI7H/FGbUjzC
         OOpQI6YAA4GZJ1L16gFtEN9GM/b7z8IdQccUX2Wc8au+Y/Pwi7lUvy9LefrZrH4UrLgn
         MCwHAeCEeqmYKFWavS0jkQqdPNeaYcsBwCZ32S49VM6oddxv37c2EXLik19idhScY5ef
         KrcjfN3jdq4mpBW9AAG3REhIyCiFA3Kc3sY0ZVZAfiALbtJn87VO9dhzGSiAoigYnkrb
         xQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691591902; x=1692196702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIYHqN573i4m0xBR4po1MavQBRxO9IhPxpT2FqODpvA=;
        b=WmGwxjKkrfOyI2cvAgeuudnk2IWlcmdcYjTFHRGlCQ1c7A/IjZEqDhQ8zFEgSFSr3l
         3X9xnfc+YcaY/MJNMdRUq5EcWK3oN/a/uwzX1XnI/FJIBaGBEABWkvSht57DPEdz7HId
         OYeGc1z/eEpPh8rsEdz3ELo2tlTn7Ga743nBXgVfkVc+3hhLfTCIADx5V/nO5CRp+C0R
         H1eTfMvJsPPWhHXlHXFw/tnddLZ8LmTrKEtKO0Mzqm1ZRSdVTzakzOp2xgbe1cFxdjYF
         nq0prsCcE+GS9ixzwmOqeoDhsTry/QVElNUn1q4+zxNss21a8zenDilJnUCDBKX8Afd/
         b6zg==
X-Gm-Message-State: AOJu0YzTfAj8xyonjhMJ9t9doTs6TzumKno5Y0Xd604EhaV/TaKrlqcK
        WXvOEwzFx17ruSgVDGarYGSAYXtEVyio2w8Ad+7okw==
X-Google-Smtp-Source: AGHT+IF/wLdtHYiJ9OpNc0jnow3dqSyojhrw6+Cg5U6//Gq1PUEtxaEvCYQ4uJsAIGmxUuhxA12LNl+dmOJbKj17Sno=
X-Received: by 2002:ac2:54a9:0:b0:4fd:d759:a47 with SMTP id
 w9-20020ac254a9000000b004fdd7590a47mr46277lfk.3.1691591901743; Wed, 09 Aug
 2023 07:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230804173355.51753-1-pbonzini@redhat.com>
In-Reply-To: <20230804173355.51753-1-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 9 Aug 2023 08:38:10 -0600
Message-ID: <CAMkAt6o1OGCXb1ET5qduLX=211f9SRs+CFyM86kHXZPZRN_KCg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: SEV: only access GHCB fields once
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, theflow@google.com, vkuznets@redhat.com,
        thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 4, 2023 at 11:34=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> The VMGEXIT handler has a time-of-check/time-of-use vulnerability; due
> to a double fetch, the guest can exploit a race condition to invoke
> the VMGEXIT handler recursively.  It is extremely difficult to
> reliably win the race ~100 consecutive times in order to cause an
> overflow, and the impact is usually mitigated by CONFIG_VMAP_STACK,
> but it ought to be fixed anyway.
>
> One way to do so could be to snapshot the whole GHCB, but this is
> relatively expensive.  Instead, because the VMGEXIT handler already
> syncs the GHCB to internal KVM state, this series makes sure that the
> GHCB is not read outside sev_es_sync_from_ghcb().
>
> Patch 1 adds caching for fields that currently are not snapshotted
> in host memory; patch 2 ensures that the cached fields are always used,
> thus fixing the race.  Finally patch 3 removes some local variables
> that are prone to incorrect use, to avoid reintroducing the race in
> other places.
>
> Please review!
>

Tested-by: Peter Gonda <pgonda@google.com>

I booted an Ubuntu guest and ran our internal GHCB correctness test
with these patches.
