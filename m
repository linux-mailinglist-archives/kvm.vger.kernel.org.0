Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2C48D00A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiAMBPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiAMBPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:15:06 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50F8C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:06 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e10-20020a17090301ca00b001491f26bcd4so4297778plh.23
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jQuEwdlAAUUXBm9trb22ra0yJN6K7/xu5viOW5rF1KU=;
        b=g2FKRiHKD/ADHDE9QG8CmIh+q0X5HEBkvbDTCDo3YTTPFito3nXNBpnkukVgsql/0y
         c0013TdN8TiSNjZjv7aq4LdgBZVoiROEWkXot3FVahqEkinjzCco+xL7c9M0FqyJsPfO
         6JFeSc9kjaToyPOrwO3t5x25IN9pCmz/sK5x1YBqX7Lv5GGqWusjk9lQwmoxRODwE7N3
         ehX7D/2O5cG3aZ1gZwXbhgEkNUEOXHz4Kje/yF4QM+RouvVrzyMNujQLvL6sWchODrLC
         p+zgCzf7wgB/we1nZZSFfsUAfKRwRyiw3DcRMLUZzl0rTFxKC4KNvxjr0rweXVJe7lt3
         96UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jQuEwdlAAUUXBm9trb22ra0yJN6K7/xu5viOW5rF1KU=;
        b=p405F5F/AmwUV8xuFLKsSqpzY+2zDkAkvPPM7OximFbZAsYBK2fCHoXLX7Aq9HN1Xa
         GaLgOdKTRCdi9rI9zLQAsraSWuhtBzWNMc7uoeLrQ+xQ1P/lEfqwDH6sc8EspvW/S8Wv
         FfAhX7jT4fY0Efkzq5EdnlUjEO4lIVNt6kI9EQvNFzd/wF8y+O8xjRDrCLkuQxDRH340
         yX6yLeDNrvFSXR108cJTVj5Hdzq9PLMJ04YkDyWydpwtkzwEaYPxsOBhIF8He1ohO3rb
         /vlV+g5+Zm5J9wlu+sFiiUQ6Nx+HY1Iv7h35dc0Qfu/XSGtI27z96xbUgSrODUU7wzfE
         Mpcw==
X-Gm-Message-State: AOAM531jkLTp8+EZBdUNX8jz/jetdQ5x7sKVpPcNAdnSnNkmNmAotMu8
        TmPDqkg+h5a0DN5p8ny1mU4PukV4eIg5BxFrQWaIcwZvos12v208lR/jye04Xm6Vyeav5dDw72e
        SmCzQnHRnNFfCFcfj33h1WPXBoc162CpVuJPOpKVq45ztircIXYuRZ2jbdRY1Za0=
X-Google-Smtp-Source: ABdhPJynWX/9qfJXx4NszBize559IKWcXX1TuYSDyn2nUFIPQNXYsPJ0HAuDTxaW/D3gsLbvrtlUhhRMClSWWQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1a08:b0:4c1:9f31:6d18 with SMTP
 id g8-20020a056a001a0800b004c19f316d18mr2030514pfv.0.1642036506095; Wed, 12
 Jan 2022 17:15:06 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:52 -0800
In-Reply-To: <20220113011453.3892612-1-jmattson@google.com>
Message-Id: <20220113011453.3892612-6-jmattson@google.com>
Mime-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 5/6] selftests: kvm/x86: Introduce x86_model()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the x86 model number from CPUID.01H:EAX.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c5306e29edd4..b723163ca9ba 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -361,6 +361,11 @@ static inline unsigned int x86_family(unsigned int eax)
         return x86;
 }
 
+static inline unsigned int x86_model(unsigned int eax)
+{
+	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
+}
+
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
-- 
2.34.1.575.g55b058a8bb-goog

