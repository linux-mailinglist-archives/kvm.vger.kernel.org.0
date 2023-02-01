Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E74686CC1
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjBARVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjBARVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:21:43 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A1D7CCA3
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 09:21:34 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5073cf66299so210070377b3.17
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 09:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dAwj5/lXzInaS9jfWyz64yLKr8tCxS9Z5jRLKFKML64=;
        b=raB/NA4dIkmnR516pfEwm0knT2JV3hTjtNysGUJa+oNJCoRdQNCWT+eWHWDUkGMp1z
         nemcgwGweS+1PvCf03HlnV+zFsGcHKROEKijvWQ6tXXQdNKDFPFV0uhc9DTBJ2WxkUnD
         l8nczlgz1IRMAsISGk4zS4qd0+zKNSxMN5LrFP3E/aHtvMyOBmqt0QPtMeh9+LQLuhE7
         YA5VQbnuD2vUKPAmUuc71aFHIb2NospTr7b8PdI0iObEnZamBeIldmxT4Juqt4e9/VgS
         JCl/b9x1rvanRMgnH5/Iy264T9XmSpOsVQQ89FjS50NRWwDF1s1oZFokADOfd5bCDQTj
         IGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dAwj5/lXzInaS9jfWyz64yLKr8tCxS9Z5jRLKFKML64=;
        b=GvY3P1qJ5lFB65+oy5DYAFSjQ3WmwO6UKjXlWb+p3SxcgE4dlxe6Hz3awGi2sdayBt
         OZUCNiLS987Evo1YFWU+p8PHFAbhXGQsYCPJ5eMC+OlJk/NRvbLvsVwNtqzekx2klKEr
         WnF/tWwO0TG/b9h4fxCKMRkD4N4I3HEsLO4mzxicsZwIe87Hf0YXOOMGmyk1Ynn+9Klb
         B4sIewx2Pd7YfRRCyKKYGDV9v/eRuVdyTuHHr1UOAmZV2x5BjgxYevLGukkGx3B3cC5O
         hGPirVwq0ubD6gKvvekaQL0qTJGYpVigAdPFojqjqavdOT3Cd3bw1AB0wHtywpviCNhX
         B6+A==
X-Gm-Message-State: AO0yUKUZnyT/LnQE5P5aXxKerb+YnVf1O2nRgboZJA0J4Fp35ykfpi/7
        J5d8Ccrfx+0lUoBYcIDxST76PPwxOPXURC8+Ww==
X-Google-Smtp-Source: AK7set9VoaOQ2sAxqOHh49EW15OK6oX7ZpblUNowiUpwgVsH4yb9krf7pPPf6epwC9xHunRGiv1kYyw7qr6muap8xA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:a84:b0:4ff:1141:f621 with
 SMTP id ci4-20020a05690c0a8400b004ff1141f621mr284480ywb.224.1675272094212;
 Wed, 01 Feb 2023 09:21:34 -0800 (PST)
Date:   Wed,  1 Feb 2023 17:21:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201172110.1970980-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v4 0/1] arm: Replace MAX_SMP probe loop
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

v4:

Remove last mention of awk and fix spelling mistakes in commit
message.

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.1.456.gfc5497dd1b-goog
