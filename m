Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419DA25215C
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHYT4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYT4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 15:56:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78758C061574
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 12:56:30 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so7554845pgl.10
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 12:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=sS77HQ4aya/R9+vXtuPXPPA3LGWcRr4UTPM1NZ5LFJo=;
        b=wFmNSi8y7ndowYmkzhO96cnde/aYx+LgT6cp1qz1Kn3sDPyZeoeRq2yLrP0RrQk5Uz
         XjXTP3I1Ck+j7qelCC3Oe4hGzqwrVEzur3WGQ9MINjrdNgOv7zia7qi5tupIzziaMrUR
         AJCV084DG+NT7kD88XWSOK1uLIJALQrtIbHg00FUWqMwB1+Mw8KRQZotqG7PE2SNSkcE
         RsvlGw73T5m2K648JIVrC+wPaXDVwy1kof2fP9x6AB5Wd26iJ9zicyv0GtqKIJQPU3zm
         e5RoU5h5rCrAUEfIH/fyH4MXlpCUtV/mmRMbx6Uq22naGNtrgMzu22XKaKB36ozWVzQI
         XBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=sS77HQ4aya/R9+vXtuPXPPA3LGWcRr4UTPM1NZ5LFJo=;
        b=d6JpwGxaNIf9p2dYjmmKhz/XiApD1eRo0m1tMu1Jun7CTM0ryCHhMsNT/5A7atCh2E
         HUkVc043S4YjJFl4nLMSqDaT4R1jStvr5GtE1BDQxqy4OSvyuyBfTOlHlxNa7VvEisQ8
         khraktxuzEnWdP/RbzP+MLT26bpPJlAvZd8/E5CbGlD2GN4B0bdyUmMbsOFSCcvdCFKJ
         QJS6+KT2RL/Vium4j+Rm/uYdTQjNDxpezZgG4p2lavXAcJNM9JScL67CfJTLHrvRDLOC
         iHmh/DxXVMoZWIS53ysDHLyW2e7p0JqqP+HIiw61jgXgvzXbqv/cwBGLUrsU+QSfmH2P
         e+Qw==
X-Gm-Message-State: AOAM5337WCL6yubA4MEtHZCzWFmvRMZgaOWAUoQoFVQa0Et4KR+dEKGn
        cexGZ2Zi0D++jH1/iQAtkaWiqg==
X-Google-Smtp-Source: ABdhPJzHObK6L0TlqwcnOFpTs7CbD6BXhwqr4tVz7e7Mc4oesBdNTSmF3uDyVkHSXbZ7Gp6t02oiZw==
X-Received: by 2002:a62:79c5:: with SMTP id u188mr9229706pfc.270.1598385389588;
        Tue, 25 Aug 2020 12:56:29 -0700 (PDT)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id e65sm31886pjk.45.2020.08.25.12.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 12:56:29 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:56:28 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
cc:     Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [patch] KVM: SVM: Periodically schedule when unregistering regions
 on destroy
Message-ID: <alpine.DEB.2.23.453.2008251255240.2987727@chino.kir.corp.google.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There may be many encrypted regions that need to be unregistered when a
SEV VM is destroyed.  This can lead to soft lockups.  For example, on a
host running 4.15:

watchdog: BUG: soft lockup - CPU#206 stuck for 11s! [t_virtual_machi:194348]
CPU: 206 PID: 194348 Comm: t_virtual_machi
RIP: 0010:free_unref_page_list+0x105/0x170
...
Call Trace:
 [<0>] release_pages+0x159/0x3d0
 [<0>] sev_unpin_memory+0x2c/0x50 [kvm_amd]
 [<0>] __unregister_enc_region_locked+0x2f/0x70 [kvm_amd]
 [<0>] svm_vm_destroy+0xa9/0x200 [kvm_amd]
 [<0>] kvm_arch_destroy_vm+0x47/0x200
 [<0>] kvm_put_kvm+0x1a8/0x2f0
 [<0>] kvm_vm_release+0x25/0x30
 [<0>] do_exit+0x335/0xc10
 [<0>] do_group_exit+0x3f/0xa0
 [<0>] get_signal+0x1bc/0x670
 [<0>] do_signal+0x31/0x130

Although the CLFLUSH is no longer issued on every encrypted region to be
unregistered, there are no other changes that can prevent soft lockups for
very large SEV VMs in the latest kernel.

Periodically schedule if necessary.  This still holds kvm->lock across the
resched, but since this only happens when the VM is destroyed this is
assumed to be acceptable.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1106,6 +1106,7 @@ void sev_vm_destroy(struct kvm *kvm)
 		list_for_each_safe(pos, q, head) {
 			__unregister_enc_region_locked(kvm,
 				list_entry(pos, struct enc_region, list));
+			cond_resched();
 		}
 	}
 
