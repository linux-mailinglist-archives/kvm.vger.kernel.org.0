Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DB02934BD
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403769AbgJTGTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403861AbgJTGTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:11 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C78C0613D9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m16so739453ljo.6
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pE6faVejbkAIUEORvfpEBGX8dWE5OEtccf8+g3bpDfA=;
        b=wqgOv0AdT4cxsnlRIT/UMGHB0RcEbRbr7Zk7Ij6sVDDKQ58f7O/mJyeJdUG+lVOM3W
         QjB2s1DT+SUQVCNFzdwwY6LrGOrnKqHLcaVwezTp/Ec9EVQ9VbKanXvyaP7kWY8cU2fq
         xY9yC+/+uB431+nxnsp4hOyXOgds8MRIVEpVaR03fauEGuiOFNxj51NvTD9SyN28NpnC
         Ze3LwVbA7FzXuB5GisL6E+XJJtIHsF28V/8BG4LccqzrGvrvEyfsyh2ImhaGa6ZZkVI4
         qdy3YOAYaheLIrtXdvNRCy3VuuIYqQBQxV5+IXrn8aZ8CysQLNcewpbbGqREi6qJO9Iu
         GMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pE6faVejbkAIUEORvfpEBGX8dWE5OEtccf8+g3bpDfA=;
        b=t5wS3hTAk8FLur/O9jU3YvAoJ7WdYTChmuaT1JPP656z7xzCRr/WBvO3+Vz01p6e/3
         oOIA1A8OMqfv/JxfE4Y8dirQS6tQHhH1ZPdiiGhgwNXMZ4HAy4hwbr71uH3zU43MxLZ5
         CwnmXEquLFlsmfb6Dm91JgV7dr27QFn1mKtGw293SIA7qaXIclv8GGsJoCFaV8QEA31E
         FiNDJDS2H/+HAOADzOipA8q0RYsSx+IXKFrube8nHJfqyCnYyoSLCiURB0fC0ZJ2i6r7
         vVBjZRV2rQ5+2eKFqPe5BElo3Ts04Q6UC0a23UzsQzmSy1Se1L1VIM5VP7OsbXBFrWoL
         Y2Ig==
X-Gm-Message-State: AOAM530Avv9u3RbkC0J/SXwG+jS6RI3QtBGb/pBuhGL+mtBycT53gklH
        pySOTYtAuyFxGZTo+KlmTBxioA==
X-Google-Smtp-Source: ABdhPJx7ahPxugd4z72ja1bSn+DqbXFXAuU8ORtiw6nlDwM9v5+X158Jixbz9FhEJVNgbphYkh7WWA==
X-Received: by 2002:a2e:8992:: with SMTP id c18mr456881lji.318.1603174748897;
        Mon, 19 Oct 2020 23:19:08 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id m203sm135528lfd.195.2020.10.19.23.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id DFB58102F65; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 06/16] x86/kvmclock: Share hvclock memory with the host
Date:   Tue, 20 Oct 2020 09:18:49 +0300
Message-Id: <20201020061859.18385-7-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hvclock is shared between the guest and the hypervisor. It has to be
accessible by host.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..ac6c2abe0d0f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -253,7 +253,7 @@ static void __init kvmclock_init_mem(void)
 	 * hvclock is shared between the guest and the hypervisor, must
 	 * be mapped decrypted.
 	 */
-	if (sev_active()) {
+	if (sev_active() || kvm_mem_protected()) {
 		r = set_memory_decrypted((unsigned long) hvclock_mem,
 					 1UL << order);
 		if (r) {
-- 
2.26.2

