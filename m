Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20648105B2B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKUUeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:34:31 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:32927 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfKUUeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 15:34:31 -0500
Received: by mail-pl1-f201.google.com with SMTP id l6so2380410plt.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 12:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aqOTm5v0rHBakRrOPoUNzG7lV6TjlvhbUVefSloyIL4=;
        b=S8Lhg5SL/sC8nrW2Jcf7xI4+wIH3gqxfkBkw90zvJ3pDOxDGVsYvZZ/T3m83YMisEG
         XxfQLEU4lkOp2CP1hFkbSN5/5kQ9kNWhHxPa0pnZK632NkcuLpkzqkKZ12x+C84utEZb
         tHKIU0yM2/1k4kTJg4fZtGWhrgYq9pP5ylisMrIrgBSeN8tnZVr5IQC/GdQcr9zsAXi/
         CYgtfnMyNvj2eSuXMcoXi7cOeaI8CXvbU+raSRtOQ0l7K0HvZ7esVtL7JCHvlt60OYBJ
         4nu69vvVlOzxg4wrj3H2EroJInZW+AIhUKkPsbdH5wK4quRZAYNR6y44Rq//W+FzDULR
         lYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aqOTm5v0rHBakRrOPoUNzG7lV6TjlvhbUVefSloyIL4=;
        b=WKmdJpO3pzFJHNscDbCmIdFxgHzmCVl3YfJlBNFmphwSVUhwgNDj0vCy7jjMzJuz8n
         wSknBcYPAegRdAfqJMHntbBw9nj3ek3FRfat3HoTozLGxoxgT5wPHto1vgufpp+SrpW4
         h/2MPYNgPaDXq8+0FnSZblwOkOyFggck3wPAId0BnTq6Eo5bCfiYUemo1SaqVqlbIWtg
         3a5cI9iSLGSXacaPu9+tZv0h0y+yhoZ482sMFDPJ8ulS6HW2uUe3nxiVJQe9+sXdKGu3
         SBDFLrxLtHigzWNVsiPwhby1KcnAuEkOkKDxIs1leaCe3ttqJnPW+/Ac25FbmWWf+Ao3
         3O2Q==
X-Gm-Message-State: APjAAAW5hqEKAKhx0K6FAS1kwboBKf0Zvg3w9Sz1dgJH0Y98dBKrSBZt
        kkQ219XkRrlJNweAqxeSSZQioBKyfdc=
X-Google-Smtp-Source: APXvYqw8pMXVhHLaGsWD1PAi/csXcTIQ8RkBj7citCE1Iga8zCDTgqfHMBDBPOqx8sDjU8bT0sK5LiZCwTs=
X-Received: by 2002:a63:f702:: with SMTP id x2mr4981165pgh.300.1574368470114;
 Thu, 21 Nov 2019 12:34:30 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:33:44 -0800
In-Reply-To: <20191121203344.156835-1-pgonda@google.com>
Message-Id: <20191121203344.156835-3-pgonda@google.com>
Mime-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
From:   Peter Gonda <pgonda@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only pass through guest relevant CPUID information: Cbit location and
SEV bit. The kernel does not support nested SEV guests so the other data
in this CPUID leaf is unneeded by the guest.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 946fa9cb9dd6..6439fb1dbe76 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
-		if (!boot_cpu_has(X86_FEATURE_SEV))
+		if (boot_cpu_has(X86_FEATURE_SEV)) {
+			/* Expose only SEV bit and CBit location */
+			entry->eax &= F(SEV);
+			entry->ebx &= GENMASK(5, 0);
+			entry->edx = entry->ecx = 0;
+		} else {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		}
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.24.0.432.g9d3f5f5b63-goog

