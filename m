Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E9367DCEF
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 05:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjA0EpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 23:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjA0EpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 23:45:20 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0984F40BDC
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:19 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso3786947pjp.3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6M4DthXPC4gMhg1OPPEKYo+hw8FePXMyAs9+vCYexbk=;
        b=Y/rFTwSG1gKa9M9vhn2eA1s22bwBixDVDnTu0sEeFX/6fZwMhrook3PYT8EFnLKFiF
         7eTHTHuPlKXGInkE3FzUPWPYGLgYxwCjWJS88s4sWquuNBzcYENmVtSJfxR680bWQwV/
         fuUhLoKlYuk1Xd0mQk0rCIiiu7+EuZAbJBpCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6M4DthXPC4gMhg1OPPEKYo+hw8FePXMyAs9+vCYexbk=;
        b=sErZzBSh8JlBy++Eln9JbrMaYx1s2LxB52JLryXzlPLEIyUKH5TnRdEBjqKcsednir
         pHbDbQf2ZA17zCaPG16mdThUgJ8SkH3D9WnIa/8GRX9+SAvnMJog4WN9Yzx4C9JInmAA
         EIHj1E5ctmOM+HwMwf5gcrLXHMdhz13Gc8OnU2p0KsbuRXufu1D9btWKaA0t9e4skJMd
         Z887K/FJFU3pUhsOkL3Xxen5WTy4jLIoAQbINARDYNyAaxyO1KrQmZxi1bZFvfx+JdBb
         /Zs3L+yoNCDgzo7hna+cIbvcDlCgmgFoSxR9oiPkPG1RsI3W928sww5y7/1GEgrvHA7Y
         zOVg==
X-Gm-Message-State: AFqh2kppCJuCdP/PCFCJh2QIJuUPv5wDO9PPnt4fkGOMzmVpAuEpm6ds
        XRQJVAGEGxv7LSbjfoXi3l6Wxw==
X-Google-Smtp-Source: AMrXdXtrn6IvBthxF3U4TE7/HsX1Mp5+8Mhv/5hFpByjELXA5WZfQhJqSyF/P29Xs8juRo12KVQ3Nw==
X-Received: by 2002:a17:902:b20d:b0:191:4389:f8f5 with SMTP id t13-20020a170902b20d00b001914389f8f5mr38673112plr.34.1674794718524;
        Thu, 26 Jan 2023 20:45:18 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:24fb:4159:9391:441d])
        by smtp.gmail.com with UTF8SMTPSA id o14-20020a170902d4ce00b00183c6784704sm1766186plg.291.2023.01.26.20.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 20:45:18 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 0/3] KVM: x86: replace kvm_vcpu_map usage in vmx
Date:   Fri, 27 Jan 2023 13:44:57 +0900
Message-Id: <20230127044500.680329-1-stevensd@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

This series replaces the usage of kvm_vcpu_map in vmx with
gfn_to_pfn_cache. See [1] for details on why kvm_vcpu_map is broken.

The presence of kvm_vcpu_map blocks another series I would like to
try to merge [2]. Although I'm not familiar with the internals of vmx,
I've gone ahead and taken a stab at this cleanup. I've done some manual
testing with nested VMs, and KVM selftests pass, but thorough feedback
would be appreciated. Once this cleanup is done, I'll take a look at
removing kvm_vcpu_map from svm.

[1] https://lore.kernel.org/all/20211115165030.7422-8-dwmw2@infradead.org/
[2] https://lore.kernel.org/all/Ydhq5aHW+JFo15UF@google.com/

David Stevens (3):
  KVM: Support sharing gpc locks
  KVM: use gfn=>pfn cache in nested_get_vmcs12_pages
  KVM: use gfn=>pfn cache for evmcs

 arch/x86/kvm/vmx/hyperv.c |  41 ++++-
 arch/x86/kvm/vmx/hyperv.h |   2 +
 arch/x86/kvm/vmx/nested.c | 329 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c    |  48 +++++-
 arch/x86/kvm/vmx/vmx.h    |  14 +-
 arch/x86/kvm/x86.c        |   8 +-
 arch/x86/kvm/xen.c        |  58 +++----
 include/linux/kvm_host.h  |  12 ++
 include/linux/kvm_types.h |   3 +-
 virt/kvm/pfncache.c       |  37 +++--
 10 files changed, 418 insertions(+), 134 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

