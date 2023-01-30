Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28654681AEB
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 20:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbjA3T5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 14:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjA3T5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 14:57:30 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59F34ED3
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:57:29 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p19-20020a25d813000000b0080b78270db5so13940580ybg.15
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dc3zeGOnu3cTQ/J5hLWHzEQjalk/Y7p5kM2vIQsVfdo=;
        b=jO+6VN04K/g8QUcbl5dTFT1VhMllp53XmX68l83m+V5lMp+uA+xRKuw1i0xWjHyyKv
         +87p7/8WRZoWFAshisB4RTUVt60qfwGXnJPvWMBfnQUSAUORWrGCaPwQ6ysrJ7FTOE4a
         vhQVfrOXgkVn39i2q9lMSBu9YdcQCGT/MEtCZqVIKMA6scbKR+9gbjUKqPY9jQJGzQjw
         X3e/EzIs8yJw0tgpovn5Gnz83WOlaj/TdFPkf8e6qyebCJeQCJOwgfzrJYX7V5q8cdxM
         CuTJYYr/GB/o6Q4GMqAzXHMnZzlPqy6EQdnGaMspgTIdPS39pGz9jGYn2GTlt0Bfqt9s
         S1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dc3zeGOnu3cTQ/J5hLWHzEQjalk/Y7p5kM2vIQsVfdo=;
        b=iK7xqAM2eCLK3ZnR2IHHlAWDyW4vYc1rWDgrcc6qTpyGdSMexknT36UqcZG6Rqin//
         2FnCFUn5cg9/fTtqT/6lVZ3fgkWUfmIQmH3lRpeSAs+EuPGn7viGJc/vjlMIomrkAwtC
         /qZI0lAObSTXkqY9+pPUzNAIlf/o/UQc9CYIJqnAp7nricYF2LL3R71zQb+MY6PD0/fC
         ulPs4ofCxWK+i0/dOGCakgrZhEtjjeCEf804CHzA8ANk2W5BpZXJA4zZ4x6Bgjod2sXJ
         gPYgcwwBYR7SeAZmjMb6f7IIXMMdjpNqWUPF+oA+d9ZaP+uIml/qsok1tN8FHBuQP1l/
         aLEg==
X-Gm-Message-State: AFqh2krHuiPemXvwCmr9Qym2PNAZHmBjOUNycqYNmgcHyYV5N+oLHN1r
        e+SkiEmLqB6mS6/4ynvRVycjZttCJNLfv2sqMw==
X-Google-Smtp-Source: AMrXdXukGiKGext+HoYi0FMssBPzeNnJoNs6OajphJY57A/gXUEykCiHaxyUvILJUKdjq2uzs/x5YkE3DVGWvtUyBQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:7b44:0:b0:4ff:a70a:1286 with SMTP
 id w65-20020a817b44000000b004ffa70a1286mr3537786ywc.447.1675108649088; Mon,
 30 Jan 2023 11:57:29 -0800 (PST)
Date:   Mon, 30 Jan 2023 19:56:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130195700.729498-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v3 0/1] arm: Replace MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:

Rewrite v2 using one invocation of QEMU and bash parameter
substitution instead of awk. Clarify conditions under which this
change is needed.

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.1.456.gfc5497dd1b-goog
