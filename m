Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27A37B22A7
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjI1Qmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjI1Qmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:42:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5FC1B0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:42:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c729a25537so30793115ad.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695919355; x=1696524155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGSaUROQXQCdbfnq5W92vVAiWr6RA+1OO94Wb6mQU/w=;
        b=2F9wAaubcH++R4ALbleuNIFylqp+QwbEVv7Jse5G0Va+OY9gQUjhlQy0u3p5zXrWCV
         xBT4CrwiTlBxwXtRJm7y9K+pN2FeYlxr4dfZLbvBxwwQcJ2RWHHbPJY5xZ1c9SO6VVfy
         UwNJPuzUGhggowldQUy5lwWcNjmFBu0a+46gqAgFYqVcB3SxfoFPl/LNFPhsk3Dag92e
         H/lvGMeYiT3LmeHat4LwUVc5RF0JNnMYEOuR8IVGnArInVB40FH3WMrlPgfi7eknHUm0
         KyIa6aeD0vm82pYp1fCP19nO0GSEYPbc9rNptmdklGllbCIOxGpOcwIPmdJ5P3jSn7dF
         Yqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695919355; x=1696524155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGSaUROQXQCdbfnq5W92vVAiWr6RA+1OO94Wb6mQU/w=;
        b=fdzPyQ2e0oPKTjONtIPcdsNpKCH4iEU4p7ox1qTTOOHNmhFhrnMC2qYlGl8w3Ygpwr
         2AXHptFU1jBf/MokAu/vpsjcDfZY5LCJYYyKTHrdzRaC2V80FMg0HVIF5VwN8sDX7Qz0
         2jzZMewfgjTgu8Js8lW//Ahvy6kWS+HltoFOxN+EcRlIwZNdz9suv9p8Weg3Nup9M/kH
         aqjSF4zFgOuEQfR5JmLTdHpaUyW4j6IgZXTUdaUnN+80hnjppsfvn4HUfry/X28jcJmi
         1e5FNRvLhlL6/UbVgKASZWHIa2rKGBRrTG6NGNApqVLHu2xpbF3eSUVJmssm2/L5uiVr
         3wqw==
X-Gm-Message-State: AOJu0YyOoJw6bWNCu5hFWukVUTih+h1LoBectNEVmZMZcD4eX1/or67v
        /EWTE82ucH9mHmsJ4t+zYZtEdPy/Zxg=
X-Google-Smtp-Source: AGHT+IGL1kaaynpSzZs9P9RfVZGfoeYZA85TB4CE++bWqrA+6EfosmDI1QwBzU5oHPOLD8JBNEskPNw/hVE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c714:b0:1c0:d418:8806 with SMTP id
 p20-20020a170902c71400b001c0d4188806mr21489plp.12.1695919355670; Thu, 28 Sep
 2023 09:42:35 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:41:54 -0700
In-Reply-To: <20230925173448.3518223-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230925173448.3518223-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169567819674.170423.4384853980629356216.b4-ty@google.com>
Subject: Re: [PATCH 0/2] Fix the duplicate PMI injections in vPMU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Sep 2023 17:34:45 +0000, Mingwei Zhang wrote:
> When we do stress test on KVM vPMU using Intel vtune, we find the following
> warning kernel message in the guest VM:
> 
> [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
> [ 1437.487330] Dazed and confused, but trying to continue
> 
> The Problem
> ===========
> 
> [...]

Applied to kvm-x86 pmu, with the order swapped and a bit of changelog massaging.
Thanks!

[1/2] KVM: x86: Mask LVTPC when handling a PMI
      https://github.com/kvm-x86/linux/commit/a16eb25b09c0
[2/2] KVM: x86/pmu: Synthesize at most one PMI per VM-exit
      https://github.com/kvm-x86/linux/commit/73554b29bd70

--
https://github.com/kvm-x86/linux/tree/next
