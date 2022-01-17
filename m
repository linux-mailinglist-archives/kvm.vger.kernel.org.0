Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD72490468
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiAQIxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiAQIxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:53:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9BAC061574;
        Mon, 17 Jan 2022 00:53:17 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e8so6955628plh.8;
        Mon, 17 Jan 2022 00:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OdJNVxNw9yfwSsIs/iRT12RGoZgVefZ94MyXYoIdi/I=;
        b=nuDOMHT/Xoico3jVT2V64Xl5hHUpYen4VK1A/eO0YmsQvC4KTeiyZb36eKqXbRtvr8
         48cT6dlkBghG4B8JlpHVXHz/NssXXaTisYYz3yXnlikTVLGuyUsWyhm3f2H8bK9C3uOy
         4z8Bay2cNBMnfNu83FS6NRf0XUhCwoPRyMOfHsx5PPPND+lv5otHRG58sHMmZD3UYnUy
         10mwV1RXMUgm6eLZPVaGw/vCnFkcdprwnZRU91Xx4F0Z8pUAfEkaoIEiMXqqlgTDUH5V
         Na1+bS10tavGZi4m/TiygVuvk+HNVYGWFFmvvLcetOdoXU75iavIYkIXBUFIQHUKh6A0
         USJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OdJNVxNw9yfwSsIs/iRT12RGoZgVefZ94MyXYoIdi/I=;
        b=WqE1kxByzN5Swwy6BYZ0WuD6gabyPXkHZdHSsoknzi67sjFqHxKPl2rbxIxNn6dd9N
         ssgJEZJ5ozlbgzF3TWxowIcivfbo6nFSjL0QKm81J9ufzcB6esRcoImGxtRxnWeMEIuK
         bT928smP4yvwac9I8USCtmT1qDIfsyruFASpGFSzOpQfqnAnTXC//+ChvWF4/IAzpiLI
         Sg0AMuLX+pgoqvPz5TsWwRCYkOv2HZwrQZUeXvIPA1M82Mfi5JbPNYyn73nY5PQY6QG5
         UYWy737GarwQjBlrIj5mE9chs6+DHGze3/+En3L7V7witjIVQGZj4g4s0iq3BiwfDmHa
         8IYg==
X-Gm-Message-State: AOAM532hoYwzrQJ01PldCB12XRAt13+H4ZT64tKxjgFmreVvP52GkryU
        IXgw94ZaijP806JCQzhxhM6CZwaG2eH2pQ==
X-Google-Smtp-Source: ABdhPJz3f6l4FpW4LcFgEyHXJWFhbNCkMVer03KGuDaGoK/AXw67oy9tjyytfUWnC+PpCpjhhYGhtQ==
X-Received: by 2002:a17:902:b215:b0:149:936b:830b with SMTP id t21-20020a170902b21500b00149936b830bmr21115865plr.72.1642409597495;
        Mon, 17 Jan 2022 00:53:17 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q4sm13849686pfj.84.2022.01.17.00.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:53:17 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH kvm/queue v2 0/3] KVM: x86/pmu: Fix out-of-date AMD amd_event_mapping[]
Date:   Mon, 17 Jan 2022 16:53:04 +0800
Message-Id: <20220117085307.93030-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current amd_event_mapping[] named "amd_perfmon_event_map" is only
valid for "K7 and later, up to and including Family 16h" but for AMD
"Family 17h and later", it needs amd_f17h_perfmon_event_mapp[] . 

It's proposed to fix it in a more generic approach:
- decouple the available_event_types from the CPUID 0x0A.EBX bit vector;
- alway get the right perfmon_event_map[] form the hoser perf interface;
- dynamically populate {inte|amd}_event_mapping[] during hardware setup;

v1 -> v2 Changelog:
- Drop some merged patches and one misunderstood patch;
- Rename bitmap name from "avail_cpuid_events" to "avail_perf_hw_ids";
- Fix kernel test robot() compiler warning;

Previous:
https://lore.kernel.org/kvm/20211112095139.21775-1-likexu@tencent.com/

Like Xu (3):
  KVM: x86/pmu: Replace pmu->available_event_types with a new BITMAP
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Setup the {inte|amd}_event_mapping[] when hardware_setup

 arch/x86/events/core.c            |  9 ++++
 arch/x86/include/asm/kvm_host.h   |  2 +-
 arch/x86/include/asm/perf_event.h |  2 +
 arch/x86/kvm/pmu.c                | 25 ++++++++++-
 arch/x86/kvm/pmu.h                |  2 +
 arch/x86/kvm/svm/pmu.c            | 23 ++--------
 arch/x86/kvm/vmx/pmu_intel.c      | 72 ++++++++++++++++++++-----------
 arch/x86/kvm/x86.c                |  1 +
 8 files changed, 89 insertions(+), 47 deletions(-)

-- 
2.33.1

