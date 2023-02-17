Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D106569B326
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 20:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBQTb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 14:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBQTbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 14:31:24 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8EC52895
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:20 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m21-20020a05600c3b1500b003e1f5f2a29cso1734721wms.4
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=36c2t3bxTYAXxN1sWnIe/NpwPxNe7BvAQ4RverxEpho=;
        b=BujsuhQlQ/vmzD35Tq0BOi+ArpHBIxvhv5hgzCk/NIAlsM1Tb90KM7c67qp/QmSLPJ
         0AxwBCHqXUfs3ggEhatYLFrjglhO0sU36azEhu/3OMIijcx3xL574kFCGFLxxU6XpM1I
         Q/jIxdJOwo0doZfssMOcGp2rb/c0z0xcQmtnp7o1tnNoXqZj6VloYMGP31Q/FuGp4A/l
         7ul7X/Ocgot+UDJMM9+vCVfEiLEszCiw9ryRu7qhDNP/mpQYidjdkKHHwfaWDh4obey5
         M/rD4+al+n06rkDrOMAJA6EV6c8IQP+WR5Awy3LYyOIaJ8ddlKmWQePE1g+2qzCtOVMb
         XxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36c2t3bxTYAXxN1sWnIe/NpwPxNe7BvAQ4RverxEpho=;
        b=Lq98IzszRBCeFVTiUGYjWnm4M3ONmyvcE3pxsPp+AJQmaDKTUWqYZG0Kxr6/IQfNfc
         jVeRrWyiqMp7SeCmVSO4KwXz251/BJfZxRcStQPYWmR+ce3PHPwcsWokPrX7+6UoSdP3
         XRCwcNeMhl/uoxhhkFMJTEe9LlyQIvinI0hh5xzbvX/yRxjRl+sypfumW+CgKCqBBEt/
         un4e+GQn1IT9rAD8BhsbRnjndUNv2n3o7VN/D2BBwwKhW8DrpChlq8z7Pl+1hH+Cygyw
         OUnlT3bE2IYI+dpJcmGO2e+m/0ZCZM8N9e9wCuiMb6GHyGsL3l2ZiQM2rWrDFAi+W6QT
         uGoQ==
X-Gm-Message-State: AO0yUKUdLPuI7Qf+xtfHJlQAm87kVdG+X7TmKkyZ/5D2obrh2nSYem9X
        WANp13jPJg9JcRGXDrRtYDguvWveI8tDmDkD
X-Google-Smtp-Source: AK7set+Do8Oea3EiNpOBU6NsvYLWCkCaUZhItfU6Qy+K5HebfbKb0emwIEFSkUdueCyYckis503Obw==
X-Received: by 2002:a05:600c:998:b0:3e2:20c7:6544 with SMTP id w24-20020a05600c099800b003e220c76544mr2530540wmp.19.1676662278862;
        Fri, 17 Feb 2023 11:31:18 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af465a00bfa0a0965e5e0d85.dip0.t-ipconnect.de. [2003:f6:af46:5a00:bfa0:a096:5e5e:d85])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c4d0900b003e1f2e43a1csm5393618wmp.48.2023.02.17.11.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 11:31:18 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 0/2] KVM: Minor structure layout changes
Date:   Fri, 17 Feb 2023 20:33:34 +0100
Message-Id: <20230217193336.15278-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
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

v1: https://lore.kernel.org/kvm/20230213163351.30704-1-minipli@grsecurity.net/

This used to be a more exhaustive patch set shrinking kvm_vcpu's size.
But we concluded that this would be too fragile to maintain and would
require a more radical layout change to group often used members
together instead of chopping off individual padding bytes.

The remaining two patches are nonetheless useful, as they either make
the structure layout a more natural fit (as for kvm_pmu, putting the
version atop) or removing pointless padding (kvm_mmu_memory_cache).

Please apply!

Thanks,

Mathias Krause (2):
  KVM: x86: Shrink struct kvm_pmu
  KVM: Shrink struct kvm_mmu_memory_cache

 arch/x86/include/asm/kvm_host.h | 2 +-
 include/linux/kvm_types.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.39.1

