Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0345F76C4B4
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 07:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjHBFR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 01:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjHBFRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 01:17:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843571BF9;
        Tue,  1 Aug 2023 22:17:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bbc64f9a91so54227015ad.0;
        Tue, 01 Aug 2023 22:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690953440; x=1691558240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dkoEp84j1DGzvSVNEGeItFOPk6M5o1otGhPU2Tvf3HQ=;
        b=H+OWNHqkRBidw43Z1JGFe9QE/KjisbeFbygFPdBkrk8SNR2drbUcx3lkY9lQ+Q/9dM
         MoJInkwAFHhQCMtK/p/DdiUBHHE5/X03H+sq8Ttc/VTMlDZ0loxblAAR+tyWIP2MhabK
         EdxyCyvtRYLr6EscR6Wi6EywBzTzozO3/x1d/W8EiLXclGuftLD56Dm1s+MTeEZXQi+W
         nGzYlYd5C+Jzk2128EkKnGLrh63NXqd0goMtRyGsvyLjG+e94Vj9HFzP7FvGGucHezp4
         nw2n+vVKfMFfq3MCz1sS2liz90585kZVBfcXrMpisoySotosfneqXMaM/23MKjd3sugt
         qPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690953440; x=1691558240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dkoEp84j1DGzvSVNEGeItFOPk6M5o1otGhPU2Tvf3HQ=;
        b=Ki+AUypX0ZssIXW9uldktxdtkLmVBFOKlaw9sqm1eI+La8YgpGNcg0VtOY+IQBQW3S
         lYE5kXskoiP3A+BK9jImfUKA3Y7LcuhOn4012Ji/A5i0Q9/PIRovpYd0z8JM0xQBZh/k
         FsIuF2DZpE9JZdgPmdzwD+/WMN9ZWT2JF+vQN7p1c74WhaOdpR1Mvwb+kkgdKEYYaeP5
         tHs+AA3FDSWeNrqffSBwH1nW2mwPe80kRDFWW4xQOK3BZFGH7PU65WPhP25AXkouff5V
         fVL0B/ysQKd4mbxDw5MqhQjr4MFODGbPIE3vFpQJrE0twCf+dNrZ/ZewWm3C+j3ivs+G
         549Q==
X-Gm-Message-State: ABy/qLZ++ymmJSe20xSNblCL1McBTMZXl15J23e6gdElMhz2ByWkYyk7
        68ktGTpOjDEf4ClFRYQAtdw=
X-Google-Smtp-Source: APBJJlG3g0jkLRJwUaBHnSlEAzFBf6W64q2xAbM9NFHHGyTiMqiqBuHdQGJPEQ7algKP2m0AIT5w2g==
X-Received: by 2002:a17:902:c255:b0:1bb:a522:909a with SMTP id 21-20020a170902c25500b001bba522909amr15209376plg.37.1690953439919;
        Tue, 01 Aug 2023 22:17:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090274c800b001bba7002132sm11330446plt.33.2023.08.01.22.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 22:17:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: irqbypass: XArray conversion and a deref fix
Date:   Wed,  2 Aug 2023 13:16:58 +0800
Message-ID: <20230802051700.52321-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

When VMM(s) simultaneously create a large number of irqfds and register
their irqfds in the global consumers list, the global mutex contention
exponentially increases the average wait latency, which is no longer
tolerable on modern systems with a large number of CPU cores.

The patch set is intended to reduce this source of latency by
converting producers/consumers single linked list to XArray.

Please feel free to run more tests and share comments to move forward.

V1 -> V2 Changelog:
- Send the prerequisite fix as a series; (Alex W.)
- Keep producer and consumer connected and tracked; (Alex W.)
V1:
https://lore.kernel.org/kvm/20230801115646.33990-1-likexu@tencent.com/
https://lore.kernel.org/kvm/20230801085408.69597-1-likexu@tencent.com/

Like Xu (2):
  KVM: eventfd: Fix NULL deref irqbypass producer
  KVM: irqbypass: Convert producers/consumers linked list to
    XArray

 include/linux/irqbypass.h |   8 +--
 virt/lib/irqbypass.c      | 127 +++++++++++++++++++-------------------
 2 files changed, 63 insertions(+), 72 deletions(-)


base-commit: 5a7591176c47cce363c1eed704241e5d1c42c5a6
-- 
2.41.0

