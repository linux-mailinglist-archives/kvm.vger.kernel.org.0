Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4566DB5CA
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDGVaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 17:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDGVaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 17:30:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BC3BB96
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 14:30:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 4-20020a251904000000b00b7f75c3cafdso27973415ybz.16
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 14:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680903008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yGVxZ1tTd+0zx7YtxQo364qUbcPpGZ5+RS4xpgV8CRs=;
        b=fDbsOezJPSaKXGcPOWn5syZZqF2gK2woGs16YpxXVBnpjdjWPfF1GDAKVlGOV06MTH
         taLi1twAhJCZbfhjLeMGI+IZpbNhPTbUwm72w3xwRJce9nldI5pPPmxVXc1S8gnQTX6e
         fuKx2p+CYDke5y3nxvnO9ABbSPYu4nw4w7f8JKSDjK3A59AFqLn27U3yecxzbBYwAAMp
         HCOUrRidjGhfkAEzJJDQAss1GP90NwFXhLt3D3JhNrjesFiA7E2FQrJKYeXjnlHlgwf3
         CU0D3LGkUujPf4KOcNuZN01YuHomve7rCUlrHkmm7H++qQPpsB50aphlYV+t4A7DbZpk
         AlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680903008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGVxZ1tTd+0zx7YtxQo364qUbcPpGZ5+RS4xpgV8CRs=;
        b=gp9+7WHG77hqJbZgeaOb29fx9evBlTQoYWkHUUsNbwuWKTX9v1SOPqGW/B6h4XxrW9
         sYv7DrA7fqtnzUWxEB2RlC9FfmReP9ahVk8uFYB7frRTiWi7McAXR+YduOZjkJw3CoPh
         P83T3Hixt6ni+lCY4YlWpwgjOh/JdQU7j5QahIJrWNxt+Byw0jsj8R83lLQkl3spsyIr
         6z0wQnFrEprL6ecv0nhIt85XlppAuGScoGjnt+AdJSP8yeR//7YvaKizet8B1wRvM3/f
         5p7y+FIir8wDBxiBG5bcAIbf5sGsDO0hhfpGiexe+VPxUy3+VU4daPpXiDLrIV9Ueq1V
         5kdQ==
X-Gm-Message-State: AAQBX9cfG86CwLReLkvg72feHDWjmDkzEAtaCfAX3FRJa95Bc53s13dK
        G23GCI39wLRbQwv5XX5yzBJ+ROlJHXI=
X-Google-Smtp-Source: AKy350af2Gd0/N0r1cBiGtcPvXmRymrmNyGF7TgT1X/7NpsCVRyBow2E9jF6/mcizS++Cvfn/ZdNUGAooYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:12c7:b0:b26:884:c35e with SMTP id
 j7-20020a05690212c700b00b260884c35emr5182069ybu.4.1680903007881; Fri, 07 Apr
 2023 14:30:07 -0700 (PDT)
Date:   Fri,  7 Apr 2023 14:30:04 -0700
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168090289120.942347.12601363927480329925.b4-ty@google.com>
Subject: Re: [PATCH v3 0/5] Fix "Instructions Retired" from incorrectly counting
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 07 Mar 2023 14:13:55 +0000, Aaron Lewis wrote:
> This series fixes an issue with the PMU event "Instructions Retired"
> (0xc0), then tests the fix to verify it works.  Running the test
> updates without the fix will result in a failed test.
> 
> v2 -> v3:
>  - s/pmc_is_allowed/event_is_allowed/ [Like]
> 
> [...]

Applied patch 1 to kvm-x86 pmu.  I prepended "pmc" to the new function to give
it a bit more namespacing, i.e. combined your pmc_is_allowed() with Like's
event_is_allowed().  As mentioned in my response to patch 5, I'll post a
new version of the selftests changes.

Thanks!

[1/5] KVM: x86/pmu: Prevent the PMU from counting disallowed events
      https://github.com/kvm-x86/linux/commit/dfdeda67ea2d

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
