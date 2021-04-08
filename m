Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AAF357DAD
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 09:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhDHHzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 03:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhDHHy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 03:54:59 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A26C061760;
        Thu,  8 Apr 2021 00:54:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y16so1208531pfc.5;
        Thu, 08 Apr 2021 00:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CoS1npLzHqbBGhM1kld5Nqvh9c2M3eNx2lB/qJCxtRg=;
        b=g8mMLsKHXqOfy+etT+ceR1zg7Uac4PbVYYHN0IyHbTXJGvNOgMR60Fszav5yaXR+9N
         QOp6nvRugEqzMhpUlJaqkjQqYIAqpTUpuZ7VSyjL79Y/sxO55LTYbndhu4neak44/TZw
         GOFB5Iyi9hCijyOWHc/WT/OoD+zg37e/+Q6gds6Mj9wGZ/BK5M2z8zMDQdcy0YVf+rla
         oaLwZVsxnp7fpxOTDMYkQD9jjugR0B93O6D1Eajg7wUZRggu+NFrHht0Arj9b48SMXnI
         59Ed2cscQrrqZPVlfcfVdATvvObQfmN8+GcV/KfLIrU5XfGHClbcja0us+G1IH4Y8zAu
         jAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CoS1npLzHqbBGhM1kld5Nqvh9c2M3eNx2lB/qJCxtRg=;
        b=ZJdyL5WLVEDuDrIugIZpahlG07jW+EIa7dM2xhLEmdyZ9Ow0K/pB/pjZzDhpjwg185
         JXBDTjvppRJ0sD8tskHf5nd6D30cdX/y85J8cQho2Oa/sgahGsaPNGtk2ZsJBUWt70wm
         n+Huh14D+AMW0zh3Wru46pHiVjMjok5aKTQpc45J0Cr3UK9ypUVLu2zME0Zgm+EG8vdz
         YVO4O0Yu3f6GAEPLeWT+lYgDhDoaMUz9RzTPsRqGTyo1g2t9qhh+CSrmvIYUk9Veewme
         5DByOBfWTOa5n+4PrfzIi/SrerGpRXCQslYCQcNdjBNLqw8AmtBIftFoGyiMF12b1uui
         kvpw==
X-Gm-Message-State: AOAM532EZiU3114kXtZaCOmWDLKA0cZhfSUm45hw+nf1QG0hZXS3wzGM
        oLX1Vb/5ObGQsXK0P7MKdcVG/7Y2sg==
X-Google-Smtp-Source: ABdhPJyL9NiJ1vzRx75BEIMSlr75VDg4PHTVbX/6J1Esa6o3xxp9dTbKUmXRTm5vHVkjXOa/SSTlzg==
X-Received: by 2002:a65:6844:: with SMTP id q4mr7051917pgt.48.1617868488196;
        Thu, 08 Apr 2021 00:54:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id x125sm22912637pfd.124.2021.04.08.00.54.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 00:54:47 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: vmx: add mismatched size in vmcs_check32
Date:   Thu,  8 Apr 2021 15:54:36 +0800
Message-Id: <20210408075436.13829-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

vmcs_check32 misses the check for 64-bit and 64-bit high.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
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

