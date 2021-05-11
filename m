Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC3D379C4C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 03:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhEKBv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 21:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhEKBv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 21:51:29 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C551C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:50:24 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id z12-20020a05620a08ccb02902ea1e4a963dso13070046qkz.13
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+e3DQI5+4u8ZvT6ywl9deoyFR4AY5xstyyS/fx3b8IM=;
        b=RczG1P/vIpzmrCj3j0YYvtcu9W6kjsEkKTq8Pb4I31wjSQ1v4Pz67dRx3iFaFhvakp
         EHay4Go4+2i3apauSnSjnPuFa/aWas9DDw1b9+6PbeWWEEN9Ak5QP06aZvZb07E4O6xF
         H6msZm8ox98mqrOOpWBe22pZWuiO8tfVA7kyiCuS5wQQw8N/dq+LzZt9Hu+eWH9yzkqt
         OEpoijMDZ/3vgw568OSNz9Gx3FrQ9/GK0IAjILSP0SEg4zzvFuAljnD2iTQoAOnsvvvl
         z4K2O8hJJuhSjxBzbFT+Yvt9DgZurNIxXes3WFplXLWQnETQf64TjA2VTAEecOgRU/qu
         XDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+e3DQI5+4u8ZvT6ywl9deoyFR4AY5xstyyS/fx3b8IM=;
        b=Ael/adAYiBoQb7NbxmduS4lQGvKrmuUuPt8vfTqIeEHROg9VUhuqJopZ+iCrCzrQc0
         sqv/YbifPKyuc3Y2NKJObYSMlZbXpyUnZJnzFwLqFu02/P63RafqvE+olvLBUQohyvMI
         CsqUqeFiEqJSZJVQNaBKD3FLZBiLz/2F/hDZt1uoNov3WYHqtKJXU23rLfVZplXAkeFO
         CTvlykemOIqTmdPeRl0+/QsUJEHXbrilRH6QJUfb6xYZ35Wbcro+xzH/8uZtsPS5S+WJ
         CfDrzxTxBT+bTY+xmQIyakmtaMkdt4bQi9FufBqaSrCtgvi+LSbWRnb4okBAQNAFBEjO
         5qjQ==
X-Gm-Message-State: AOAM5306dy3USLD/LJnqGr3wr1TbF2UdnllshQETnNOAVsxRe2DDeXvv
        2febCNNa/CDuQZCTCB0+UH/Sjz8OA7eS/Q==
X-Google-Smtp-Source: ABdhPJwwej8xDubz04rqIuVYEiRjngACgxZhTfMucZvWvP7DaFlGw7voRWy6jiJuz9NfKRq0pwChpF5m33ZY3A==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:da9d:6257:8f5f:1bcc])
 (user=jacobhxu job=sendgmr) by 2002:a0c:ed47:: with SMTP id
 v7mr26617572qvq.17.1620697823171; Mon, 10 May 2021 18:50:23 -0700 (PDT)
Date:   Mon, 10 May 2021 18:50:16 -0700
In-Reply-To: <20210511015016.815461-1-jacobhxu@google.com>
Message-Id: <20210511015016.815461-2-jacobhxu@google.com>
Mime-Version: 1.0
References: <20210511015016.815461-1-jacobhxu@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: remove use of compiler's memset from emulator.c
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Sean in discussion of the previous patch, "using the compiler's
memset() in kvm-unit-tests seems inherently dangerous since the tests
are often doing intentionally stupid things."

The string.h memset is already imported through libcflat.h, so let's use
that instead.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 1d5c172..d6e31bf 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -8,7 +8,6 @@
 #include "alloc_page.h"
 #include "usermode.h"
 
-#define memset __builtin_memset
 #define TESTDEV_IO_PORT 0xe0
 
 #define MAGIC_NUM 0xdeadbeefdeadbeefUL
-- 
2.31.1.607.g51e8a6a459-goog

