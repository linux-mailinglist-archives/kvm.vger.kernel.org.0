Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD007C5F5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfGaPTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:19:14 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35165 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbfGaPTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:19:13 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so66028285edd.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EvEqqoCYvSiaJViGsfZgvE8wYjGeg4BQWYRIZAIdYOQ=;
        b=bZcGmOHwm0gi6j5t/BbUGsKtOCIZr4doGxyXBg+bAsntyv91YXoAwS8iK8gYH/2Rhd
         EZoLChmRluivD3XLirlmMT5W1vFicn0Th6yRJbjlvSCthP29u5r3kvQbgKOL0NnWdm5O
         z6WKnsGxsng9YOVJ6s+hk1x3ysUEVhPOmeDyo07xX324wqjHjFQ9yfcsBJPs6sEkZfG/
         j1P95OYBR2KAtJYWJH/9fdcbulUD7i7ZdBv1U7AlRZ5qi7KMU65oMM+umaihE2hREq1N
         HFgl1iVKn4xa5Uwqe5PFQO1apPGzMbp3tx+aOQoTXOpVFI0CqNnOhoaQyl+Z3LmysdM7
         SIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EvEqqoCYvSiaJViGsfZgvE8wYjGeg4BQWYRIZAIdYOQ=;
        b=VCS/kkX+Nh4Waqx3z0quwkzV4NEheFvKYfQsoX4Jz3sF8SlYKT23OdAiZZgarg/U4d
         rwi1TJ99/lr8sD9kYspDyiu8iEmUE+fBrQ36DqSHcvN2vENFx4V4YnLM0tOop1h29a8Z
         h1zM7+S7qnIPpK3uV7BQNGl2qXH90VQs2qi5GnIq8G8nLrFvDn2MVzKIgAWNy7f260GL
         PCt5i0VqVeQu6iiDZ44P8BF4V+7KExCifnaCmYFN4fTxYImGLkLe03F7fMkqP0gge44q
         m1nPsphkgif6hvT1V3vQnu1QHswxsKkEWTkxzHw0Iq9Sxz00ZVbKJKGPDPFvXkgkj8XA
         pIDA==
X-Gm-Message-State: APjAAAU9M3QwaKJqXfm/5eYQu8voSVFawJtZALxgXKlo5wO3adExf74M
        2qdeMMN8mfenP9Zw/8kKEbE=
X-Google-Smtp-Source: APXvYqze/zmPMD1Bsfoldl9kgWqcWF2ltGwH8c0r7lo9vR1AXcu6XddkT5YuYdRgsgxlZcifb+OJkw==
X-Received: by 2002:a17:906:4d19:: with SMTP id r25mr94272907eju.125.1564586035045;
        Wed, 31 Jul 2019 08:13:55 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g7sm16945101eda.52.2019.07.31.08.13.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:53 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 874211030BD; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 22/59] mm/rmap: Clear vma->anon_vma on unlink_anon_vmas()
Date:   Wed, 31 Jul 2019 18:07:36 +0300
Message-Id: <20190731150813.26289-23-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If all pages in the VMA got unmapped there's no reason to link it into
original anon VMA hierarchy: it cannot possibly share any pages with
other VMA.

Set vma->anon_vma to NULL on unlink_anon_vmas(). With the change VMA
can be reused. The new anon VMA will be allocated on the first fault.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/rmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e5dfe2ae6b0d..911367b5fb40 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -400,8 +400,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma)
+	if (vma->anon_vma) {
 		vma->anon_vma->degree--;
+		vma->anon_vma = NULL;
+	}
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.21.0

