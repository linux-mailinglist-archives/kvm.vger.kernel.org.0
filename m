Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB4D7C98BC
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 13:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjJOLBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 07:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjJOLBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 07:01:31 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364E3C5
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:01:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9b2f73e3af3so532619066b.3
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1697367687; x=1697972487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fs39SiB6AuYzRrVv1Gnq3GGO7EqmckxlOmPzVLozahk=;
        b=XB7ZsX/nJEZVUnhBP4eb4de5YvxhiTXQDFFWNmTWtqYe8NvHrfBQGtBvBIX9+sA8Rv
         nnUlH1rV3QPDZs0jAr70Rx2Q0DLqqJKGBrHX+fRdDmGfWBd4Tn19WxJ8nJTuzi0Tr8co
         puiQgWqYGZoZR8R2aNFdQM8BU02dwP+aotp7W7XKJ5bdjAekA2WEpnMPAP3JBXRb4ylx
         xesnHdQodsPT0lPVYUJ7o+vLrhCdKkebmpEdMR9VMwXX14zMj8bYi0vyw68ECYKV2l47
         GZWEL+6r2OOlRHvgb79mhumA9N1OGLmOY93Arw8FYpVDcaaOcxuSHPESMapAjwM5qjAl
         p0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697367687; x=1697972487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fs39SiB6AuYzRrVv1Gnq3GGO7EqmckxlOmPzVLozahk=;
        b=HKCrSwCxzERlZSbUjWtGCkSxkXQ065NuvWXqox5Tf2Q/Wkvp9soUbuQWQEerb7YCic
         ZcNoy4NeFgjhW53azBJVf52cvUVYzBg33rc9+9xsqkyDa1zjF0OQwsCag5IQfv6gTr8y
         cDUW+Iq9rbBYGrWa9BMChQukIbvDXsm3s80xIBgYVzlPTurOkrkBcRZJ/GCnCorjKMwq
         j89kobn+55JwHFU2vsi9Mcpn89c2qXEJoMHotfUuZK7d4bxF3vcUeNZr524fAi94lWEg
         /99bdAqbl6N8HDqq9wRsyTa8ImYeg/RdRLiZIlamRL4GCSn1HEQUYURyB3BG/6DY5zQ+
         G37w==
X-Gm-Message-State: AOJu0YyXLfCagQ3M9aBWUBxBBIeLh4IFwDCPx4SRIZW7D/8hwA+inVvK
        I3DWhXKkK2MOCRzPhmEM/DgwxRz7Cw/qsN33SuA=
X-Google-Smtp-Source: AGHT+IHenaEhoDJsYzAxyvZTf2FyNuJ7tJ4U6hzrfQ4XoOo7qf/i5l2ehgIwJViqWO3jCqJzeWishw==
X-Received: by 2002:a17:907:36c8:b0:9bf:889e:32a4 with SMTP id bj8-20020a17090736c800b009bf889e32a4mr1827606ejc.54.1697367687201;
        Sun, 15 Oct 2023 04:01:27 -0700 (PDT)
Received: from localhost.localdomain (89-104-8-249.customer.bnet.at. [89.104.8.249])
        by smtp.gmail.com with ESMTPSA id l1-20020a170906078100b009928b4e3b9fsm2137412ejc.114.2023.10.15.04.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Oct 2023 04:01:26 -0700 (PDT)
From:   Phil Dennis-Jordan <phil@philjordan.eu>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, lists@philjordan.eu,
        phil@philjordan.eu
Subject: [kvm-unit-tests PATCH v2 0/1] x86/apic: test_pv_ipi checks cpuid
Date:   Sun, 15 Oct 2023 13:01:00 +0200
Message-Id: <20231015110101.24725-1-phil@philjordan.eu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test_pv_ipi test from the apic suite doesn't behave on some non-KVM
hosts. (including TCG and macOS/hvf) The test has been gated on
(compile-time...) presence of the test device rather than anything
specifically indicating host support for the feature under test.

This patch changes the test to check whether it's running on KVM, and
whether KVM advertises the PV IPI hypercall feature.

v2 is based on Sean Christopherson's draft patch which brings in
kvm_para.h verbatim from the Linux source tree:
https://lore.kernel.org/kvm/ZRQ5r0kn5RzDpf0C@google.com/

In addition to Sean's changes, I've also added:

 * A wrapper for <linux/types.h> which provides the minimum required set
of types for kvm_para.h to build on non-Linux platforms.
 * The check for whether we're running on KVM at all; the feature
flag at bit 11 of eax at CPUID leaf 0x40000001 might mean just about
anything on another hypervisor.
 * The +kvm-pv-ipi CPU feature flag on the APIC test suites' Qemu
command lines, without which the hypercall is *supported* on KVM hosts,
but not *advertised*.
 * Explicit 'skip' report when test_pv_ipi doesn't run. I find this
helpful, and other tests also report back when their preconditions fail,
but I'm equally happy to drop it if there's good reason to do so.

Review notes:
 * checkpatch.pl complains about the formatting of KVM_STEAL_RESERVED_MASK
but that's inherited from Linux upstream, so I've left it as-is.
 * checkpatch.pl also offers some warnings which I wasn't sure needed
addressing. "Co-authored-by" is apparently not supported, but I'm not sure
what the etiquette for multiple-author patches is here. Keeping Sean's
patch as a stand-alone commit would cause build failures when bisecting
on non-Linux platforms, so I didn't go that route.

I've tested the patch builds and correctly executes on macOS (hvf & TCG)
and Linux. (KVM & TCG)


Phil Dennis-Jordan (1):
  x86/apic: test_pv_ipi checks cpuid before issuing KVM Hypercall

 lib/linux/kvm_para.h       |  39 ++++++++++
 lib/linux/types.h          |  15 ++++
 lib/asm-generic/kvm_para.h |   4 +
 lib/x86/asm/kvm_para.h     | 153 +++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h        |  40 ++++++++++
 x86/apic.c                 |   4 +-
 x86/unittests.cfg          |   6 +-
 7 files changed, 257 insertions(+), 4 deletions(-)
 create mode 100644 lib/linux/kvm_para.h
 create mode 100644 lib/linux/types.h
 create mode 100644 lib/asm-generic/kvm_para.h
 create mode 100644 lib/x86/asm/kvm_para.h

-- 
2.36.1

