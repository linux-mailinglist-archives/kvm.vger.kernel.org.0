Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5107B427302
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 23:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243446AbhJHV0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 17:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243433AbhJHV0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 17:26:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF42FC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 14:24:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a16-20020a63d410000000b00268ebc7f4faso2263305pgh.17
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 14:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XgRk7jMmXWMK1ft8S8aZQlO3WgE8ydvGH5GMK1xYeFQ=;
        b=FOXFeik0qkoau19FOAQcWRarB0u1fhJugKXSax61e2dE5I9F3WDnv653+4tkvE3HHS
         Pj/OKqIdOsf/ctPOEeGU5lFOXlZ3N4k2vdoS6I0NWGpl/ShVlMVbCPL1rFrbSdMInJJj
         /Amrf9/bLKlibGVo5IKuzk2XDUp0FUPbgJSGZ2NXL9+Gfwbt1ovUqtpMz/qz9OepgE5e
         rWmYvWZV5LLruifjM3bsFyHX8qbG9HUOpWJE2whtbj8Mhu0iDN5zrrw5hskEZ+zBKMvH
         O1e3kudiKOY2IVk5EbV73moq0O3qCex/sv+yHeR1b3Yh/lDjLd0+nGhHh1IpZxngBrUf
         Ak+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XgRk7jMmXWMK1ft8S8aZQlO3WgE8ydvGH5GMK1xYeFQ=;
        b=M3znhr3TcfxWhOkkeZs2TXPbGonIyR/GUO1wfWodV/VExcrLaebHHBkH5DLKVrE2oo
         vhQrNeydfoBW52zn0ulMN0+GorQhkCMKoTqrKTBQJ5fx6HghZ406lw1NqKa33hADaI7T
         mfVChOs/AGYk7+JnqM0GTjw6NXikug0SFdFk48dJCwGKJ/Sl6PDj6U1RQ0QVc0YyCu0q
         qu4diChOh98/yIbsfKkgWNFkjOjE8XbYMSo9l6aVFoO4u1QHL1bJhyK580oGKmn3l3S5
         QRiQY8y5c5CH2BS9yOslGytrVBE4C8P2CizMzLlep1AGjSewsTm80u+Vf6drh1ea+Ybu
         IHRA==
X-Gm-Message-State: AOAM530SUo8pkFa0ECWzJkJXnwgg117ulobNG1XH+dZveAOyTJ+hX8rm
        d9/4DhcY9CZjwLeFELaCdmZHOaPKOGEk026XNS1teCj6lhoPtWTFVObV6LYnow2R11PT4CcDJYm
        YdsadbonIAiVoqH7kjCKdYlEcHlv9hAnQTrJzOnZGWqAQeDl1R6M0WDrgyPut91s=
X-Google-Smtp-Source: ABdhPJxUxfU3wmyt49LXxZq3TMb9YGOq35kJ9av6LPYaOSKRSJCwK/+LCJBu2+WKlrtYDd4ZWJ0CYh1J+9zmJw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a63:4c1f:: with SMTP id
 z31mr6611249pga.50.1633728297286; Fri, 08 Oct 2021 14:24:57 -0700 (PDT)
Date:   Fri,  8 Oct 2021 14:24:45 -0700
In-Reply-To: <20211008212447.2055660-1-jmattson@google.com>
Message-Id: <20211008212447.2055660-2-jmattson@google.com>
Mime-Version: 1.0
References: <20211008212447.2055660-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH 1/3] x86: Fix operand size for lldt
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lldt instruction takes an r/m16 operand.

Fixes: 7d36db351752 ("Initial commit from qemu-kvm.git kvm/test/")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index eaf24d491499..fe5add548261 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -443,7 +443,7 @@ static inline void sidt(struct descriptor_table_ptr *ptr)
     asm volatile ("sidt %0" : "=m"(*ptr));
 }
 
-static inline void lldt(unsigned val)
+static inline void lldt(u16 val)
 {
     asm volatile ("lldt %0" : : "rm"(val));
 }
-- 
2.33.0.882.g93a45727a2-goog

