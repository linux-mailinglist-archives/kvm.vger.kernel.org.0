Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C562C672041
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjAROyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjAROyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:54:02 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66B2E3A0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:51 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b4so30429371edf.0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iUpWz208bEkBtTntCJWWI6PRXbjFKq7Xs/7g/86VDX0=;
        b=h1ertN2zUaEpjCbn/7K4xPtl7fJ/hc2QLOARYZf1qUeSIZir3T2ej0F3/3JtMuiCr8
         LQgVlkRUQV31ajRmsAnRsJ1Yi3/zL6SGu4lZrFi+0vrQSllkSw4UJN4aVJ+ZEcAm0Uvs
         Gp+qkb5g35nMJk7qjSHsvhAAsSDJlZ5zJwyyCsIz0W2k7c4mGRtAYQXrbk2c7p5K30lu
         GH5jt51mAKjhFQJFsZK4rq1Ka4PtDb93dMJCIIA7TA7+wI2gIm1QoQbGhAzpP5lykVn1
         yUWGKgPg6LPhv1NmMDHs53K3Du6MP6emmNWxa9LCshmNqv8z6Z1hXH6cqgyVG5pm1CU2
         VXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iUpWz208bEkBtTntCJWWI6PRXbjFKq7Xs/7g/86VDX0=;
        b=L6WRRpRGWEg0uCRZKCOQ9CwOd8ZsMqZ9J318yPpCq5jW14u4u9XqrnL194TI3MPYGM
         7NTDkLilwKpUYOlVNnzg//I/QR3zRvGaTm0oSuFZGRMqCz385JC0hPPLsP9sYX9UV3G7
         mAH8Ixk++ektpbfLJWjC060S46rKmZGcLtf8U+I8gj6TE1itdSMwiaYN1sSYGwvi1U9l
         5PGqfYtumMyHjOApSHZCFRAkPUKo62VjlGAzaxUmLSnDx6T26juwP71AWt1B9ATgOHo2
         P7heGezFL9U+MwS0TNv+cv+4qY4Z45vmadInpZiYd17xwo9+P4qIo+Bs0WOQ60ByhFLx
         6MvQ==
X-Gm-Message-State: AFqh2krd1CeKK8EIRUFyD67LhRp4oP+psznuUzc3MUKttJOEhf/adsvt
        3uft7H1E0JmE5IfaqpH1bh1DDLTwRTIlfUpJ
X-Google-Smtp-Source: AMrXdXvhqmyL35+7chnWFtpBjKJrGJ/kBylUkNUggUKEujw2cMFL6Ninge/uLKTArYjTYUST/fvUOg==
X-Received: by 2002:a50:ef13:0:b0:49b:67c3:39a7 with SMTP id m19-20020a50ef13000000b0049b67c339a7mr8159595eds.20.1674053330147;
        Wed, 18 Jan 2023 06:48:50 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af03d2006e0fc0b921f9db5c.dip0.t-ipconnect.de. [2003:f6:af03:d200:6e0f:c0b9:21f9:db5c])
        by smtp.gmail.com with ESMTPSA id p11-20020a05640243cb00b0049e19136c22sm3627509edc.95.2023.01.18.06.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:48:49 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 0/3] KVM: MMU: performance tweaks for heavy CR0.WP users
Date:   Wed, 18 Jan 2023 15:50:27 +0100
Message-Id: <20230118145030.40845-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1: https://lore.kernel.org/kvm/20230117204556.16217-1-minipli@grsecurity.net/

This series is a resurrection of the missing pieces of Paolo's previous
attempt[1] to avoid needless MMU roots unloading. The performance gap
between TDP and legacy MMU is still existent, especially noticeable under
grsecurity which implements kernel W^X by toggling CR0.WP, which happens
very frequently.

Patches 1-13 and 17 of the old series had been merged, but, unfortunately,
the remaining parts never saw a v3. I therefore took care of these, took
Sean's feedback into account[2] and simplified the whole approach to just
handle the case we care most about explicitly.

Patch 1 is a v3 of [3], addressing Sean's feedback.

Patch 2 is specifically useful for grsecurity, as handle_cr() is by far
*the* top vmexit reason.

Patch 3 is the most important one, as it skips unloading the MMU roots for
CR0.WP toggling. It's the only one that changed in v2 to handle the
shadow MMU case as well, as Sean kindly pointed out.

While patches 1 and 2 bring small performance improvements already, the big
gains comes from patch 3.

This series builds on top of kvm.git/queue, namely commit de60733246ff
("Merge branch 'kvm-hw-enable-refactor' into HEAD").

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20220217210340.312449-1-pbonzini@redhat.com/
[2] https://lore.kernel.org/kvm/YhATewkkO%2Fl4P9UN@google.com/
[3] https://lore.kernel.org/kvm/YhAB1d1%2FnQbx6yvk@google.com/

Mathias Krause (2):
  KVM: VMX: avoid retpoline call for control register caused exits
  KVM: x86: do not unload MMU roots when only toggling CR0.WP

Paolo Bonzini (1):
  KVM: x86/mmu: avoid indirect call for get_cr3

 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/vmx/vmx.c         |  2 ++
 arch/x86/kvm/x86.c             |  9 +++++++++
 4 files changed, 32 insertions(+), 12 deletions(-)

-- 
2.39.0

