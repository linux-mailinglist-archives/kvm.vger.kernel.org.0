Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343383756C1
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhEFP0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbhEFP0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 11:26:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CA0C06134E
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 08:24:59 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i190so5328163pfc.12
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 08:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shlq1RaufKc8PpYeWS/qnMOG5GjUOzt0+QikQVANxeE=;
        b=mMUovUXN46smRWzujAFi7lKyBjSRyXqPjmkFWpDBnl3SWxEroEqQUsqJ2+ZX16/5fF
         Cze1yJPAMKSmvtOb/Fdzu+1RxCIJRlli7tB+z6LX29WxGJkpKFPw8lz3H1R+Ch/DZiK1
         z0wbXgsEp6DPMjJ1AEGOeMNplVZhmJhoAo2ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shlq1RaufKc8PpYeWS/qnMOG5GjUOzt0+QikQVANxeE=;
        b=IgNEzuiK7qZbcGWgbLyexInc6tmDshaHXzx3bTt3i8m4YW+5mNASRStWK/dUEn9s5o
         cpWI6c9n0q1+SUjoZHhm9HlrH2PTdMzqn1OaJh5DrkYO49c/KHgcqo1S9h+g+mmNqBTv
         UL1ykrDExQmDTTYNrm1IBEE+d8zYP+HthfXabrsTYhSUHC/vuBa9mrr7/UV8PGh1LKwL
         MrADK5zow+Y9HV4ZEzdZbfCJsSKUq7SmRqZ8iOFipNymaLBKVWPC1/ktm0yeqz9EOE44
         oSo1kSyOpuwvZZM8I5Y15XmyyevXVzbnMXkcXRXzfGynVN3gfIHmkNjmuzk7KDd/rA1f
         ugGw==
X-Gm-Message-State: AOAM532uTJ2yp4CMPdkp/R8svM8hywuzl79J4yiDRov+VWCQgJsRku5Y
        j19XAf4p3goV3iRCRlqQiDGmuf/zhN67gQ==
X-Google-Smtp-Source: ABdhPJz4FSt3yUXAuqeCbI3i38KjH8f3dIVyp1YL46NRW35t0PLETOSwrqqYSNW0mp7q8fZC73EeSw==
X-Received: by 2002:aa7:82c3:0:b029:276:1d63:cd0e with SMTP id f3-20020aa782c30000b02902761d63cd0emr5192264pfn.13.1620314698535;
        Thu, 06 May 2021 08:24:58 -0700 (PDT)
Received: from portland.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d63sm10660556pjk.10.2021.05.06.08.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:24:58 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org, dmatlack@google.com, pbonzini@redhat.com
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>
Subject: [PATCH] kvm: Cap halt polling at kvm->max_halt_poll_ns
Date:   Thu,  6 May 2021 15:24:43 +0000
Message-Id: <20210506152442.4010298-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

When growing halt-polling, there is no check that the poll time exceeds
the per-VM limit. It's possible for vcpu->halt_poll_ns to grow past
kvm->max_halt_poll_ns and stay there until a halt which takes longer
than kvm->halt_poll_ns.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..120817c5f271 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2893,8 +2893,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > halt_poll_ns)
-		val = halt_poll_ns;
+	if (val > vcpu->kvm->max_halt_poll_ns)
+		val = vcpu->kvm->max_halt_poll_ns;
 
 	vcpu->halt_poll_ns = val;
 out:
-- 
2.31.1.607.g51e8a6a459-goog

