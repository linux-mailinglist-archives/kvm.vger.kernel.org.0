Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1C787EF8
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 06:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbjHYETN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 00:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjHYESr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 00:18:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B151FCE
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 21:18:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fe2d620d17so53545e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692937124; x=1693541924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGG0r2s/zKnKCX6e58SnLQEC0ecMvUzJNpn5TwLz2AI=;
        b=E+XgbNynV/Z9LeBg5FbsjwaaKrFQIAFWx26XsOw6GEO61W8SuADlYDf4KN1+o3QbGJ
         Q/qp4lhv7MXupGWtVnDzKfD9mP8LlCeS0dsIDf9IytNb5yFxNqZPN3Iv5ujArHe4xPTD
         3nvRppadts4tu2P9nRK7d83CFmgU2sLeLf9baUT/Z6l8LQXwbhePiMIGUvz4PCSGWlt2
         x0OPidRpidbXpXKxXJFqMEg3GLskq+EwZGq1t4DUlqhb4kXFGbYpTydWbGE+SZE5Y989
         nU15BA0AqwXmnAV6nULfXGEHqOwvHUOhlxxspkMf8/eStb0JuHWuLNSMnU3hLYaMKDku
         iAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692937124; x=1693541924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGG0r2s/zKnKCX6e58SnLQEC0ecMvUzJNpn5TwLz2AI=;
        b=Ut4qm6h0ks+A79US7XKLNzNVOBxdA57sdaKGrHbApMQrTpGfNJ3LAVWfvpz/HU119b
         b5ikdHD+X/6yndlic58DGZXuVhu+4EPV6YGC+C33tvclCqR1tQazr6N7zjKF5ZjzOEW4
         wBwtE82CYc1fYOPF8w2T3kYIigbB7WtkpcBhVYUvfUC8Q8CvtlDXx+nMpe8G8EjQMJhk
         gTTlslZHytIIo07Cg6dDw+6FQzdjNrfABTWF3hPRTzmgdELEtMTz/j2TMaQWzMap4uMX
         oFt/n+ckVMa/IXTY1YebE1TSzdzHapnglNSGTsMKBOlxllbObaizwu7jCz8IeRyeG9y4
         gB/g==
X-Gm-Message-State: AOJu0YxV+GMZiQUw0t/cflAy9x+Dnafyr770h5SJ2tQYqxzisZPMZjYk
        ikCTtjPWrZ+MOV6ziUb9i0x1FHYw3v7ylbSHDb6b
X-Google-Smtp-Source: AGHT+IE2UsyQUsldYE5MXI+562lkXCqi1kpGWn1pc58IuVJzbLjK3nuhLqcGTqoS4Ye7ZrDQHBn4yggAGKJCIXL+yxM=
X-Received: by 2002:a05:600c:1d84:b0:3f4:fb7:48d4 with SMTP id
 p4-20020a05600c1d8400b003f40fb748d4mr82239wms.3.1692937123755; Thu, 24 Aug
 2023 21:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
In-Reply-To: <20230818011256.211078-1-peter.hilber@opensynergy.com>
From:   John Stultz <jstultz@google.com>
Date:   Thu, 24 Aug 2023 21:18:32 -0700
Message-ID: <CANDhNCo_Z2_tnuCyvu-j=eqOkvDQ+_n2O-=JKpf2Ndqx1m5GqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] treewide: Use clocksource id for get_device_system_crosststamp()
To:     Peter Hilber <peter.hilber@opensynergy.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        netdev@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
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

On Thu, Aug 17, 2023 at 6:13=E2=80=AFPM Peter Hilber
<peter.hilber@opensynergy.com> wrote:
>
> This patch series changes struct system_counterval_t to identify the
> clocksource through enum clocksource_ids, rather than through struct
> clocksource *. The net effect of the patch series is that
> get_device_system_crosststamp() callers can supply clocksource ids instea=
d
> of clocksource pointers, which can be problematic to get hold of.

Hey Peter,
  Thanks for sending this out. I'm a little curious though, can you
expand a bit on how clocksource pointers can be problematic to get a
hold of? What exactly is the problem that is motivating this change?

I just worry that switching to an enumeration solution might be
eventually exposing more than we would like to userland.

thanks
-john
