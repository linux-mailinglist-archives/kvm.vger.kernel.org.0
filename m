Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3115F223BB6
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGQMwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 08:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQMwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 08:52:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27543C061755
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 05:52:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z13so10963873wrw.5
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 05:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oahFvkWn9xu77yQoX7qxwILoCEWOJVcZ/jZ2Dt3CCSQ=;
        b=ubnRa4178Nm2mxDbZhK4nXMmrWyvh7zjC8mmGU4mcCvpvh7xIVcQ7lAIFwlpzyhd9j
         8uXeqjab/PGn5wDu61cZhyGh5ctswuBMiAXsdCfKWFo2jvr49XacD63+BfcoAgaSm1gK
         p+DXcn9tfRBU6Nk0JOW+5mdJa54eZFFFcpggblwsG5lpPcZOKaT+p3S/KaArrfPQJ0zt
         DeeWVkdviiBNx2rMYkpxuqdMViIXTKmC2qdGdyDKQuNBZnvuXOz5brQNBs09RwLTNYJ4
         gs1Cj1jneIY3XmP7K9C2aekcTb5e2cKyP197vsf5UTry7vBxAfzzjsqFpeRebh7kV+0h
         ZC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oahFvkWn9xu77yQoX7qxwILoCEWOJVcZ/jZ2Dt3CCSQ=;
        b=V/NWHfJy0oy3PADlEuZTG6sPBycQwsfMWJLGD8YD3FHV1mpcRF8OEXQ4LZeasIKz4H
         Ux+HdZOiXmLtrmiTTIFZgwG0/nEOXttdhhyBPOdx0SbPvDViTYeWl/6XENhnGJuZPtDT
         JlUio5NXYehlteQlHb8vl10kpPTS2gJL3R8x2WN4/VhOCHp/wkwvYh81EHPhdUWoA8FO
         gWe+KjpIwVHdcGXnbSLu6lKl10wozhcIIDmA1zsV3FT69tLwpkqAnVN9UEjYCBXBrMfq
         gGBPnOs3FMBqLMR5G6UyEU0rw/lej2Nd5f/gdrF+8O8uILMDvoeBvgMW5UZzFnSu3EJf
         N9rA==
X-Gm-Message-State: AOAM532IOAMXj+rlNkXUvRoSuW78U6+Skhu2sZ4+ekIpN6F+p8DUhfFN
        GydYPVsditUVmxN+wK1kmPFW0+1B
X-Google-Smtp-Source: ABdhPJxX+7PYBknUfX1DIm+w+CZnA5xttM2A/g18AdQqPcJxzmStnvpnmX6loPZsQuYxnRMMaNX9CQ==
X-Received: by 2002:a5d:4591:: with SMTP id p17mr10153266wrq.343.1594990371449;
        Fri, 17 Jul 2020 05:52:51 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-64.inter.net.il. [84.229.155.64])
        by smtp.gmail.com with ESMTPSA id z132sm15160699wmb.21.2020.07.17.05.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 05:52:51 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 1/1] x86/kvm/hyper-v: Synic default SCONTROL MSR needs to be enabled
Date:   Fri, 17 Jul 2020 15:52:38 +0300
Message-Id: <20200717125238.1103096-2-arilou@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717125238.1103096-1-arilou@gmail.com>
References: <20200717125238.1103096-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Based on an analysis of the HyperV firmwares (Gen1 and Gen2) it seems
like the SCONTROL is not being set to the ENABLED state as like we have
thought.

Also from a test done by Vitaly Kuznetsov, running a nested HyperV it
was concluded that the first access to the SCONTROL MSR with a read
resulted with the value of 0x1, aka HV_SYNIC_CONTROL_ENABLE.

It's important to note that this diverges from the value states in the
HyperV TLFS of 0.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index af9cdb426dd2..814d3aee5cef 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -900,6 +900,7 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
+	synic->control = HV_SYNIC_CONTROL_ENABLE;
 	return 0;
 }
 
-- 
2.24.1

