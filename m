Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656123249F
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFBTMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 15:12:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35582 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBTMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 15:12:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so9872928wrv.2
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2019 12:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0VnGDSAdEwstbgO0SqQCQc66bkhZImcDWdyf6sL6Js4=;
        b=uXZkHZiI/JVfke9Ilr/NyhAVRrYDnLCXnW0+W373chiPSeObsu7d80T8U8zfdgr1Es
         dZ4uaA/XjEu0DtDJlbh5TjK/AcW7BgK1w/cYa1/FqIB6Q9F9MWUR/AofI+KejxBWMDNG
         WfzoVjGofkDRFTE1Cf3rPHX5opvPOt3Pnwa8cuydjlGcrDUk84nPl1ecX6ow3NK3svgV
         xVtgqEQGx5TDZrHw0k7CY49oSweBiOyX0cElBDH6fkhedwCblRtsp0avVPAuZ9riTon9
         PHxM7SNh5LfTHUTJtBcaRcUXUo1YVdAHI2RgzJrQ//18+D0Pg+7PBhqnSOy0ZCwfbSsj
         abaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0VnGDSAdEwstbgO0SqQCQc66bkhZImcDWdyf6sL6Js4=;
        b=Yd4weRwPClyyV84ZHrGMJ98Wj3ytua+jFSfVP/ffaf/CYk1sLR+u3ZqLJWNTCo5hEt
         QMgKJo9qT+FU4JBi96F0/6kHI0move79ukRnw4GavDOxBbLRxDUnoZk/DWVJTtuG0Ou6
         syJ7aG0vwYz3wIiLEsQHpX54YkkYbi5y0TUdX13SRFyrBR4pHWB5KNFUnLzAPV9pWIYG
         z/LjJyaba87ezzucaPFiutkhWFjYNkPt5jHY1Mu2Dj1q/OoQl7HcqYMwjUXMQgKjE5L+
         52VRfk2FePYAasUu3h+GkJnPiEW5weRkXWXVb9jo2XlrobvJcoCYouk4Xj27rB1EnEIu
         S2ig==
X-Gm-Message-State: APjAAAWXphYF2hvXlJ7ddo9AuMLQqoK3xpanvfbSdYwlrh3rLiCKDwBm
        t93l+he9xzUfj+hqox1/4H+5OGoFgZA=
X-Google-Smtp-Source: APXvYqyjZkjmFHHL6xpPGEoJC2WUGXxUUJMztaNNYjuG5I2YMQRj0CwSP6EpbCYaa9Fn84iiWD0TAA==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr14041143wrs.152.1559502724676;
        Sun, 02 Jun 2019 12:12:04 -0700 (PDT)
Received: from localhost.localdomain.com (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id s9sm4367155wmc.11.2019.06.02.12.12.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 02 Jun 2019 12:12:04 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH] KVM: VMX: remove unneeded 'asm volatile ("")' from vmcs_write64
Date:   Sun,  2 Jun 2019 21:11:56 +0200
Message-Id: <20190602191156.1101-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vmcs_writel uses volatile asm, so there is no need to insert another
one between the first and the second call to __vmcs_writel in order
to prevent unwanted code moves for 32bit targets.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/ops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index b8e50f76fefc..2200fb698dd0 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -146,7 +146,6 @@ static __always_inline void vmcs_write64(unsigned long field, u64 value)
 
 	__vmcs_writel(field, value);
 #ifndef CONFIG_X86_64
-	asm volatile ("");
 	__vmcs_writel(field+1, value >> 32);
 #endif
 }
-- 
2.21.0

