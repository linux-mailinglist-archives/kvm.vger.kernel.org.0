Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207E03591F2
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 04:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhDICZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 22:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhDICZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 22:25:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B05C061760;
        Thu,  8 Apr 2021 19:25:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i4so2146698pjk.1;
        Thu, 08 Apr 2021 19:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOZ83lWyBCeICtWu3/0oO47MuS4gfmvFARW76Re2qv0=;
        b=pnksMaMbcw2Kq0VfamCd+NoAaO/msJ0ONuaV1DRYfmYaIxFlb9Ibt91G75cXrhGHnT
         oh99VNTSluVMwcibbbsy0eSx08PUlHc2G9NyJReUrCKHZAfAJ2WLcXAiqM2Cc7Iwht4/
         gcwmXs3iaSNBQRmUKQkRag7za8cHgINf07A7GYJ8ZWWtqTKKHZ29r5wy/rzfmcye/DQt
         GmQBcwgJpTvqx0xLEh0IWvpFgnvKRHeQJdV3S/5m6Fnxzh4PBX89o/yUN/42lnJgf0mG
         dRJzaaXjBgtTQKGyVeyK/pKEgKQ36d9BjVvGt/NJ2vTr2bycj0w0SVluU2W4S7D2lrud
         bcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOZ83lWyBCeICtWu3/0oO47MuS4gfmvFARW76Re2qv0=;
        b=eX+CuzwXYN0NdLwLXBzt+1QfNzmj6rRjDPC7r/BwaoyavbNJO5SopUXutROaUpaPgU
         VIP8gFkWVEbD2ltrk1mVN+sJXUz2N9cTonug84qaj56qxoeVQkME7M/AtmSGc7FuaJa8
         wot8Su4POQX8cmAIqtrGYBWlk/IlRWYLW/7TM9u6btNqQOamG99UDkZSHaxUSoFgKD0X
         qp3MDk8EgOvgxq16VTw8DWiwESZzjwOvncIapl+RTsHUdYjmfx8jO0XI2EGaN9pw4a5l
         CG5p0Wpo89a+aOmAeQ1SExdiXA0qfQe7YGQLG5LBqmZGY2G5KoBTvQtY1CwlSFvzrgNY
         hA5Q==
X-Gm-Message-State: AOAM531i/eOB9FKk22f6OHJowONKoF7jltBExkp8K8tEUQFTuBfXgISu
        VJSmkLORtESp792nAf+3Ukvsr/WPRQ==
X-Google-Smtp-Source: ABdhPJxBqyPBV7mvWUarynkXmg0LYKsdjSQuLcC46ABbv+hpqtNFMZwBi9RUoevkzKAkBSzq7/URrQ==
X-Received: by 2002:a17:902:b602:b029:e6:cabb:10b9 with SMTP id b2-20020a170902b602b02900e6cabb10b9mr10449221pls.47.1617935113792;
        Thu, 08 Apr 2021 19:25:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id r10sm608769pjf.5.2021.04.08.19.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 19:25:13 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v2] KVM: vmx: add mismatched size assertions in vmcs_check32()
Date:   Fri,  9 Apr 2021 10:24:56 +0800
Message-Id: <20210409022456.23528-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Add compile-time assertions in vmcs_check32() to disallow accesses to
64-bit and 64-bit high fields via vmcs_{read,write}32().  Upper level KVM
code should never do partial accesses to VMCS fields.  KVM handles the
split accesses automatically in vmcs_{read,write}64() when running as a
32-bit kernel.

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
v1 -> v2:
* Improve the changelog 

 arch/x86/kvm/vmx/vmx_ops.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 692b0c3..164b64f 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -37,6 +37,10 @@ static __always_inline void vmcs_check32(unsigned long field)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0,
 			 "32-bit accessor invalid for 16-bit field");
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,
+			 "32-bit accessor invalid for 64-bit field");
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2001,
+			 "32-bit accessor invalid for 64-bit high field");
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x6000,
 			 "32-bit accessor invalid for natural width field");
 }
-- 
1.8.3.1

