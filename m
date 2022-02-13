Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAC4B38D1
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 02:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiBMBlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 20:41:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBMBlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 20:41:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C044B60063
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:41:16 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o24so18608009wro.3
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7TNtxHTSBIWmlminwm1cIw6o+ANI8DeNQWwFD0Dk2E=;
        b=EqajtAQzBOH3gffsQtJUivP8KgEU733/ggRprPOlG/2C6sEW+UZdfOkOj/Rl5tM8KG
         Ixv41rgkyFCsd2YYiryvGFho6peAYcObw4AFxyGFPnYkSfClKGdwi7dFpQXy3yoVes9Z
         uBsnagmRaC5mq62mkU7HqOkbKrjM7qXPeNE8emgDY6y/WbAPGFIDhsaL4M2bzxLuiEII
         qeKXG5Lko3uGSREbKSvFmQjcLF744zlX9LVx5kk5xTzVZ9nxWjpI6N5VYfTlCIiQKLHw
         yhqdrF5Cgfn4w/2jeJkMiq5aeryx0yZcTIgYhUP8FAY9KvF4L5HbNHeAa/dSiVz51AkP
         yUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7TNtxHTSBIWmlminwm1cIw6o+ANI8DeNQWwFD0Dk2E=;
        b=Z7AK8J/4ek+y1CaV0weQM9LgTdcFnCgLa0vfT/JNj1ahGoBBoMYl8Nzz5qtgNoKQcQ
         pjBZoY/fe/c5LCA7NwN2k4O+gVoFH5gbFKVeQSwtCfmzKd/6g55CrwFYM47oS28KGEOb
         RaPgywPMLLLD9+lWo2ISJkMRtHsvD5pk2cv0u1llzbR2/wxADYwZKGo+YIlnSw8MSusB
         y50z3DhRWFfzwMnn/YC18sqzElDpJEbxmu8XOi+sKCWbsS6mUv6bQYr/6yP6kno0HU6g
         099pQ8Ww1RKH8fErcpbo/okpAAGITm9sZrlK0Ri6h1Lh0VFYnneIBrnHMa/MLeIEGmZG
         ydDw==
X-Gm-Message-State: AOAM531S/LrJG9plIphUJ39Pt6l0wQU2lWNf/L/O9ooDh2VWbhSWSmoQ
        UE7UPxo/hsN4xlM6sSUiGFuxZez7ICm+umL1fozBWu18cCI=
X-Google-Smtp-Source: ABdhPJx0KmByeMdX0SSdT0mKZ+2n5N40DV+3LrEbjCaSs0i+F4b/6PcqNEgIERouxP9YPct17MRYXX/nElFA90gHDoI=
X-Received: by 2002:adf:ee81:: with SMTP id b1mr6197734wro.149.1644716475214;
 Sat, 12 Feb 2022 17:41:15 -0800 (PST)
MIME-Version: 1.0
References: <20220203014813.2130559-1-jmattson@google.com>
In-Reply-To: <20220203014813.2130559-1-jmattson@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Sat, 12 Feb 2022 17:41:04 -0800
Message-ID: <CABOYuvb4v7X=5VXwH2dtJKtUE0+AFEQmfBdd7MMLm+5gLC43Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when
 creating a perf event
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: David Dunn <daviddunn@google.com>


On Wed, Feb 2, 2022 at 5:52 PM Jim Mattson <jmattson@google.com> wrote:
>
> AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
> a PerfEvtSeln MSR. Don't drop the high nybble when setting up the
> config field of a perf_event_attr structure for a call to
> perf_event_create_kernel_counter().
