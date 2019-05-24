Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E594529F12
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbfEXT0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:26:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42248 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbfEXT0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:26:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so11057763wrb.9;
        Fri, 24 May 2019 12:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=b3Gt3nCXb0rhnImTl+/ddhNNml+7l/9DP/rB9AdAbXQ=;
        b=sL7oJAkjFMOlhtC4l/nYSpc36PhbTiok7yW75uDyMZi7i/pA2E1Xs4P+ueugu3HEx2
         fiiXAMK0P0/gF7mq9uy7NLd9UVFFlc7JvDAhw8b4TOaRD6hWJSo9SNND8MINlwZnY7Hr
         IUeu5SzruvjUq5WOTptZxspf9mJHCLA6IYXEwB5u6hkIX6Sccn706fhuLQjivBJYuSPZ
         +uIEElFTSZgw3GtvvCN8YGvB7LRRpjSyj9MqKGXByVl+phiFKCaZUXbvlk2UhlddmhPl
         vbHC7Un+sH7Yoyskv3fc8+yyi68NrT2ds8kAp5DfyYlu8cvf4x+Qcu7YGgv4Pv8yL3Dx
         Jw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=b3Gt3nCXb0rhnImTl+/ddhNNml+7l/9DP/rB9AdAbXQ=;
        b=SvChrcK8xlb5bGvpCQqc0i6aDBLHrCTDiN1zHc02g/iZCGi19DhuR7UsBr+pGV5LSh
         OcISj3yPMkhqyIHEtibBQT1f4bk+97XVxC/FkCrecFUIXrF5IMJSIwRf7EShJRref5IC
         hJNBQJTHaogoG6ot+vMIrs/AIHWINruA+NMK0iFAa5A9e5ZGEY3lXbi9uz0QEMI5Sm5A
         nOQTaYVZ8+tg2/hX/JIyzksY5NkczFN0zvoboZJ/ub/4YxsXJS8J/MJY0zzj+PggAtty
         jW1D0N++vlaPqcEHQ9hsSyfbQ+2TbQY9TXqM5vV65rUtoYwgfsesW6O2D3WLJoT0GOFh
         hEOA==
X-Gm-Message-State: APjAAAXDNcPNILRKatwirJ6hLGC6/YmaXZfrqklt4Uv6EY6R3oDidw6w
        o0lddIiNiUEitiMHTNGThTQNN+To
X-Google-Smtp-Source: APXvYqxLD46pCMgTMBYIaIfb05LIoR14pDM0/aay84vq3fwyYPsdtMRD1gZzhynBQQOPUB0Agwu0Hg==
X-Received: by 2002:a5d:6402:: with SMTP id z2mr1100317wru.350.1558725960064;
        Fri, 24 May 2019 12:26:00 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s11sm682660wro.17.2019.05.24.12.25.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:25:59 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mkubecek@suse.cz
Subject: [PATCH] kvm: fix compilation on s390
Date:   Fri, 24 May 2019 21:25:57 +0200
Message-Id: <1558725957-22998-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390 does not have memremap, even though in this particular case it
would be useful.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1fadfb9cf36e..134ec0283a8a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1761,8 +1761,10 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
 		hva = kmap(page);
+#ifdef CONFIG_HAS_IOMEM
 	} else {
 		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
 	}
 
 	if (!hva)
-- 
1.8.3.1

