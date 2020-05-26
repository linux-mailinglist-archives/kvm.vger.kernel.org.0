Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44F31ACC62
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406733AbgDPP71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:59:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2897213AbgDPP7N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 11:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=toq7sOeh3Oxre7YgXmyZ7yZ/oSgoiV55xEipFX9W/e8=;
        b=OeXEN1TVB2gqjwV47bMW3I7tbfhsDT5KORnwTppfZajqlXqlGU1RHhB5oZsDVoj0QaiUUT
        jkfcKARjNsfVspB13/kizegYJX8nIELEcZyJbE0xquJf2MaBka6x2OAcqEdLRv17pHK4WD
        RnomzhuyNHdqgjXrBXW+TcFMoB0e5/E=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-y9Rb8g2tOSmEN8P-n19jDg-1; Thu, 16 Apr 2020 11:59:10 -0400
X-MC-Unique: y9Rb8g2tOSmEN8P-n19jDg-1
Received: by mail-qk1-f200.google.com with SMTP id r129so12931547qkd.19
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=toq7sOeh3Oxre7YgXmyZ7yZ/oSgoiV55xEipFX9W/e8=;
        b=hzjHNA02gKy3Z3B65bOI6zT0vem6wjqo5EK0R3pzDjijvn5wLTBqpBSCgE/tTECR2a
         7OTJsmDgOeIZkxp7mLBUHK72MqDv5tpgvzlNXsnwbBx35iEWXQq6YlFNyGrHhnTLoUBC
         QwNZyxoW2MlVe4xwG7Ll+CXVViePLSVVi5yC2wOskySrCDH0dV+K+IzXdJcAVZ0F+77D
         0A2LcrErttyVcHD4zhvM8XJy5rpow8I1+g/Ui1Uy+Jva0XbDM/1OOgH800QT31WEEoou
         nGVKUpNHtkzifV3l2Yq+Dr5qRAUiszpmndddOa7PkJEY7Z/R9/+HkHmFbhYUjpLV3VjZ
         QNjA==
X-Gm-Message-State: AGi0PuYoUKeI65XneH4O5Fy8+S7Hr1rDf4h3OlCoHfMz37s+putRXan1
        1wId+dQ71KxpoNNNRIo+2ElCwT7rNLbTev3bLNzmivDQcw8+mnLzvcQ6Gynth3Klk3sVdyhDxWu
        FlbLdYfenSW/r
X-Received: by 2002:a37:6754:: with SMTP id b81mr11643863qkc.129.1587052748954;
        Thu, 16 Apr 2020 08:59:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypIp14On5d+FqJCkdeoD2L1ux2G7lAjoz3TzLNQDBoXBLDbiX6e/+Ywl75dqRmGHTVCB1srDGQ==
X-Received: by 2002:a37:6754:: with SMTP id b81mr11643846qkc.129.1587052748695;
        Thu, 16 Apr 2020 08:59:08 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l7sm15398153qkb.47.2020.04.16.08.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:59:08 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: No need to retry for hva_to_pfn_remapped()
Date:   Thu, 16 Apr 2020 11:59:06 -0400
Message-Id: <20200416155906.267462-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hva_to_pfn_remapped() calls fixup_user_fault(), which has already
handled the retry gracefully.  Even if "unlocked" is set to true, it
means that we've got a VM_FAULT_RETRY inside fixup_user_fault(),
however the page fault has already retried and we should have the pfn
set correctly.  No need to do that again.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2f1f2f56e93d..6aaed69641a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1824,8 +1824,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		r = fixup_user_fault(current, current->mm, addr,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
-		if (unlocked)
-			return -EAGAIN;
 		if (r)
 			return r;
 
@@ -1896,15 +1894,12 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		goto exit;
 	}
 
-retry:
 	vma = find_vma_intersection(current->mm, addr, addr + 1);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
 		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
-		if (r == -EAGAIN)
-			goto retry;
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-- 
2.24.1

