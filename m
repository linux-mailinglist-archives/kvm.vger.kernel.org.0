Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228256FB45B
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbjEHPvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjEHPvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:51:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2A4AD3A
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:50:32 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50b9ef67f35so8604274a12.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560988; x=1686152988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B5xrVSFXNONHQZv+ctxWTjLEE37nX+KRXheeqpmsl7U=;
        b=gP596nGFow60lpa0U3YEEbE+uiiolKA5POlsfxokFBvwXMFnt1qMQ4Y98hJX0Za1d9
         E5LrzjWHoF740qmOgWjm2V26pwgF7YH4ENL+W6clXvalNW2s7yQVvyvoZIa4SlRqpSAv
         wr7EpsaVSMKs3eDtH2OGVCQHpjNQoHmQJova0ckp3wvTnp4GE4UKYgKzP6HspXKNb2V9
         j+UMjrYFtz2Zq5GEurLfNbxXAerFf8urXPZvkpZy6mkG45+E/+viEl79iwpZ2qbhSat2
         hS5K+KnGYnbszuAEWjOREXsy1na19UG0NCxanv/tz3phPlepXe4Ky+CEAZ7qcii6Zsoi
         7Swg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560988; x=1686152988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5xrVSFXNONHQZv+ctxWTjLEE37nX+KRXheeqpmsl7U=;
        b=ggskDm3xokGGobo5zKs5PDwkiUf33CfHzPatQcDIworH1mSTILSCfxd7KANPMixjNQ
         77WExKMYo6W5OrG2iT6kiFP+CA/8LMfmKdFC98cuqk1Vk7ghfzcoV/op+Tp7RjR46oqy
         wCLEbIEUMD7q2hSgp9JwXxz5pQurXn3MEQPO8vOoF3W7qCosK+5+NBIkCIsaPTbVYX6i
         siLPwK9Eu5iknZxNp5P2ipwUSnnIcIBqj8ECC6fQL9ml3mFJepKc8BzPJnp33NhLcgfh
         dFwLzW6ElKaoRfIwmC91rpPmtsP/uKEgp+hrJ0AYaVaUf6+3r0JTaEXQ6wY0t6BJOrUy
         Akxg==
X-Gm-Message-State: AC+VfDybrWn9UM15e7O8ScmHWaIxAsu3wyx9dDaAIEIHuO0I+N4B4HOa
        rmXS7qLnu3r7XzVtE7C1EFlBBQ==
X-Google-Smtp-Source: ACHHUZ43w9I+bqUWoxWMqbJykwCy4dFwdbDQtEjB1PUOLTSNT7cXrVUfyIftOWzYvI1YtzQLi3xvKw==
X-Received: by 2002:a17:907:7284:b0:961:b589:d075 with SMTP id dt4-20020a170907728400b00961b589d075mr10850427ejc.25.1683560987824;
        Mon, 08 May 2023 08:49:47 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id bu2-20020a170906a14200b0096654fdbe34sm117550ejb.142.2023.05.08.08.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:49:47 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.4 0/3] KVM CR0.WP series backport
Date:   Mon,  8 May 2023 17:49:40 +0200
Message-Id: <20230508154943.30113-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a partial backport of the CR0.WP KVM series[1] to Linux v5.4. It
limits itself to avoid TDP MMU unloading as making CR0.WP a guest owned
bit turned out to be too much of an effort and the partial backport
already being quite effective.

I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
a grsecurity L1 VM. Below table shows the results (runtime in seconds,
lower is better):

                          TDP    shadow
    Linux v5.4.240       8.87s    56.8s
    + patches            5.84s    55.4s


This kernel version had no module parameter to control the TDP MMU
setting, it's always enabled when EPT / NPT is. Therefore its meaning is
likely what became "legacy" in newer kernels.

Please consider applying.

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
[2] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git


Mathias Krause (2):
  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
    enabled
  KVM: x86: Make use of kvm_read_cr*_bits() when testing bits

Paolo Bonzini (1):
  KVM: x86/mmu: Avoid indirect call for get_cr3

 arch/x86/kvm/mmu.c         | 14 +++++++-------
 arch/x86/kvm/mmu.h         | 11 +++++++++++
 arch/x86/kvm/paging_tmpl.h |  2 +-
 arch/x86/kvm/vmx/vmx.c     |  4 ++--
 arch/x86/kvm/x86.c         | 14 +++++++++++++-
 5 files changed, 34 insertions(+), 11 deletions(-)

-- 
2.39.2

