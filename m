Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B738C6665E2
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 22:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbjAKVzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 16:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjAKVz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 16:55:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF82062DD
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 13:55:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4c0fe6e3f13so174414057b3.0
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 13:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vk+h98K5lBZ1bCzuFSe+82Rbn+wHuQAUnYI8WkMMMOI=;
        b=avMM2JU0X4lmETlxVdkMkrdrPhQ0b4xrnVCw/NaGabIDJr0OT0NUtFBKXlZmftj/+k
         3KrqnKWiGt7v7zoD1zgZDz4qkgJTIlX4BpatPOYrvsea4b0w821NOOAVtaflI2/UuCVb
         xLMflreox6WdGXOtrVHDkURwde2QyGfn3/XPhHeqy7OajAc0aUr9/+88PUHyZKJa/1eb
         t8XNhqmWQHrmwFQ0r0kPvYu+7TRPjrN06Yseiw0Wa31UArMRIKqshMf7+F4kcyMhJP2V
         BNz2CSvzoR15/Y5dmbdjLUkz6v64fSKDJKlutFwBeXbb3Wc7nnO1051ySIR1mGcgQPq2
         wsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vk+h98K5lBZ1bCzuFSe+82Rbn+wHuQAUnYI8WkMMMOI=;
        b=Q8puAtl9J/j33Q5TL/G7VtXL9z9xxExcBkkNyhXUUFFYAMRh2asnRLl9hDxn3ZzR2s
         g9GNCm+5uM8hmdeDtMpmdoBp/EJvYw7F9ia9Ka5F4HjEzqkltt6TWr/NN+Qr+1uK9Sqb
         q1BNzN+HbKf1nZBSaTQ3YsShiO04GPGRo5rke3jWXD/9Y3WFNtZ5Kae3EtC+uGWz+PmI
         iJ3+qZdpDO7Q3fgZoFbWhlFDVBlaxd30J8b3QOEtB/7x9t6QgO74owZ0mwXCYPuAoOi0
         bfe48FjzIbO6oSPpxdIAONd3OJNmlAP3JW3f4iUqHqMKuckmCTOMZbOzIj2Zy7Hlj0mX
         xaGw==
X-Gm-Message-State: AFqh2kr8PFq72icvW6ANuD3uIaQPKz7wo/TCEWwkvWR0+6etlLwA7gOq
        YT0LwQ1WoeBgdgOQ96KkVtsWGF0OY8sNAVZjTA==
X-Google-Smtp-Source: AMrXdXsNW5o4o7MCk0DjPQAefT6HrLTRimvDYJJbr5zamKD8u3tg+gV411xOco5ktrlIKB7JLt7x6+h8uRXsJcjVSQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:4188:0:b0:703:2633:87c1 with SMTP
 id o130-20020a254188000000b00703263387c1mr3074882yba.132.1673474125182; Wed,
 11 Jan 2023 13:55:25 -0800 (PST)
Date:   Wed, 11 Jan 2023 21:54:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230111215422.2153645-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 0/1] Replace MAX_SMP probe loop
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

v2:

Instead of deleting the probe loop, replace it with reading QEMU error
output.

v1:

https://lore.kernel.org/kvm/20221219185250.631503-1-coltonlewis@google.com/

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.0.314.g84b9a713c41-goog
