Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F927BB098
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 05:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJFDuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 23:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjJFDuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 23:50:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146EFEA
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 20:50:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2777d237229so1449407a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 20:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696564200; x=1697169000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2G7odMMkPTde6ooevhbuWblep4YjCVrOlqJpRqgObg=;
        b=u4aaRuqaxiEVX7+fgxXP3JAqmgAGNCkhTNBvcjzdXtH3ZzClBJqoEhSyvLh6ntegqz
         lVgJqb1noh8GVJyNGTny+yLOyMKurVkBo++aIU+lYLN2Rj0DxPOy36ptbc7u64V4xUrn
         OUWjZuXt7dJSlijzMyfz1cQo8MsYpoc2kMmLwnYO9odpzN7afgjF1ohmyNgNbOMUWOiD
         i1tKNpxIjVWe8IrF1N0/gQ4/AzPAmV6Dx7C2wKYB4wizAjy9jqGfsrsiqkdSLkkbqYWe
         ukjK+w/Pn0U1Qa0AT98shCgdesRO3zS89xTLZ2EMEPphWWiNOJgSDgtkoNYJC+OBWWuM
         nLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696564200; x=1697169000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2G7odMMkPTde6ooevhbuWblep4YjCVrOlqJpRqgObg=;
        b=Gqn2j3lESFprspGHfv1ghugkKeYK/ORcMi57rTj8ldICmbamP3YMDGPnK5crEAf8tr
         Vt9W/LuO2fGJSjz4xa1uH34IN/m2M5xmsS8XbZBA8sbzNIT4FIdCmQdEY1ZjICVLP1np
         ZbxsndVp78cnWWhPRdKazQTtu2bPIKBNEBZelXScuDzBLlhG535uG84A2voDVo/6fqme
         UbyaTyei+k3l1Lqya26Y9u6+v3dXgCoknL7icDwOiCjBQikSEk98DWh16MVYpGSKpT3B
         n24HLgZtIx1cEAM4xx3kzdegc5OZ1nknyE1ATaow6JkgyTwvb3lfK2PKpN2AeOrAXPih
         l9ng==
X-Gm-Message-State: AOJu0YzU8AFQJhiJUH/jJ+/VuWO78CDOETKgsZuuoAusfpcAvVEMcP20
        i9O1g9+PZm4Ps5pIOfBodjFKCcblWFI=
X-Google-Smtp-Source: AGHT+IHJw+5gT02f8H3V0ZCldxQSI2F+UC9hQf1f7PEAGRtWd0XB6YuIcXo2+LzVUVQz1YEHyEKidHpzLLw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cb8b:b0:268:8e93:6459 with SMTP id
 a11-20020a17090acb8b00b002688e936459mr110389pju.8.1696564200585; Thu, 05 Oct
 2023 20:50:00 -0700 (PDT)
Date:   Thu,  5 Oct 2023 20:48:47 -0700
In-Reply-To: <20231005002954.2887098-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231005002954.2887098-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <169655906345.3551422.1856629391041106669.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Zero-initialize entire test_result in
 memslot perf test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 04 Oct 2023 17:29:54 -0700, Sean Christopherson wrote:
> Zero-initialize the entire test_result structure used by memslot_perf_test
> instead of zeroing only the fields used to guard the pr_info() calls.

Applied to kvm-x86 selftests, thanks much for the quick reviews!

[1/1] KVM: selftests: Zero-initialize entire test_result in memslot perf test
      https://github.com/kvm-x86/linux/commit/6313e096dbfa

--
https://github.com/kvm-x86/linux/tree/next
