Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474BC327F9F
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhCANgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 08:36:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235804AbhCANgJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 08:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614605683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybf+ggtfILCNltr1swxw8VOdjmkBkmS5pZZjWFFS29c=;
        b=dXhdrFWR0AvmUuUiL+E4OMWKR4BP0JNRprjKROm3kgNbnGUq+WbHCyrPOOXH9p7YsKGje6
        6PtVupHy1LfQSZGvBKQtHh5gseOxPez84op1jbBHA4k2b0PC+B7QEvL63nIdxkWP0tvwpz
        6bTKsnMnCe37gWkaJIsLI7tTd/2Hp30=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448--qj2q5pFOi2wMK4GRCfuxQ-1; Mon, 01 Mar 2021 08:34:42 -0500
X-MC-Unique: -qj2q5pFOi2wMK4GRCfuxQ-1
Received: by mail-qt1-f198.google.com with SMTP id t5so10623936qti.5
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 05:34:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybf+ggtfILCNltr1swxw8VOdjmkBkmS5pZZjWFFS29c=;
        b=swLZ8ZkwaaIrmVHvHgZvKSib30QlIVu1eqm7r5u0j8uYtbyR97XoIv1A4PZh+0ahQp
         /OXbdqPctPteHKM2lksNs37haxYvQOvueN0NkpceE0tNbcN0W2Gs1b4nQau2cEGJgAX+
         KR0IUYvKdZWlzMHQdWdzmxfNOC4wUx5Ee1EgHc0o7TA7LcpYiY/3Knku0HzW9qIK7qQ5
         NyuPvotAYgVECpDr7xrRsCPCc8SnJCtGCnPqs+EP+GgzI7Y34ylrCUXKOjlcS/eei8gM
         vLnOWUmkp6Rd6Ro3kvDXAwdj+1FzZ4HWmBtkuHi5x6jfwcMz54ylCELl0gaWUcB1+nO3
         3dKA==
X-Gm-Message-State: AOAM5324P5La143g4vpVzHVHPXLbrJRu48lWHe3sDIU5SB7KytX2ghlY
        Jn/dpZjYkjBaoj7dJZLmLZq27pgOVNlYZK7CWLdmOqBN7L3wShe17337/okJ6UhDOL72yjZMnde
        0bNNOtZeGzdFCLWDkmX1znYwOFZOtS1xuDkssSHtbGn0z/U4RsZecMnxJSJEIvA==
X-Received: by 2002:a05:622a:42:: with SMTP id y2mr12949619qtw.186.1614605681281;
        Mon, 01 Mar 2021 05:34:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbUlZvZ75QwyBB04IJg5lkgSwuMY2dUKh/WmZDmHG/CWukZ7M0cNmCw70cjtan5HBTOp18BQ==
X-Received: by 2002:a05:622a:42:: with SMTP id y2mr12949580qtw.186.1614605680734;
        Mon, 01 Mar 2021 05:34:40 -0800 (PST)
Received: from xz-x1.redhat.com (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id 73sm6609609qkk.131.2021.03.01.05.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:34:40 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: X86: Fix __x86_set_memory_region() sparse warning
Date:   Mon,  1 Mar 2021 08:34:38 -0500
Message-Id: <20210301133438.396869-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <202102280402.c6iev2Xp-lkp@intel.com>
References: <202102280402.c6iev2Xp-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force ERR_PTR_USR() cast even if the return value is meaningless when deleting
slots, just to pass the sparse check.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Fixes: ff5a983cbb3746d371de2cc95ea7dcfd982b4084
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4d7dd8..44de71995a34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10502,7 +10502,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 			return (void __user *)hva;
 	} else {
 		if (!slot || !slot->npages)
-			return 0;
+			return ERR_PTR_USR(0);
 
 		old_npages = slot->npages;
 		hva = slot->userspace_addr;
-- 
2.26.2

