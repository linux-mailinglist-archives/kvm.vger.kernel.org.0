Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319941CE0E7
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgEKQsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730759AbgEKQsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 12:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/ymy6kM/nogLN2u2BJrGjfq2sxiQ3A46kg9O0WBDz0=;
        b=M4ijXmnSNf73G7DfLbaNPyHylxluYZqq05FHcDUUEIlCzwegpjbPl0m25YHKRCZ2vzgrdw
        XvGl3wxnxNr1dyWsSJxuawwcePNwR/GZCGeeaTER3GxoTzlNwroQ2yXB5HhmBbfFnXZdqV
        KTqaQr1MzlpC5QltrQiwqjYU/68LD/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-WxD0fqNsN1ipJXJ4sSM_Aw-1; Mon, 11 May 2020 12:48:26 -0400
X-MC-Unique: WxD0fqNsN1ipJXJ4sSM_Aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5441D1899525;
        Mon, 11 May 2020 16:48:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0C4D196AE;
        Mon, 11 May 2020 16:48:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] KVM: introduce kvm_read_guest_offset_cached()
Date:   Mon, 11 May 2020 18:47:47 +0200
Message-Id: <20200511164752.2158645-4-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have kvm_write_guest_offset_cached(), introduce read analogue.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 01276e3d01b9..235109a23b8c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -733,6 +733,9 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
+int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
+				 void *data, unsigned int offset,
+				 unsigned long len);
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 			 int offset, int len);
 int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..c425be6e6d98 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2503,13 +2503,15 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_cached);
 
-int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			   void *data, unsigned long len)
+int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
+				 void *data, unsigned int offset,
+				 unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
+	gpa_t gpa = ghc->gpa + offset;
 
-	BUG_ON(len > ghc->len);
+	BUG_ON(len + offset > ghc->len);
 
 	if (slots->generation != ghc->generation) {
 		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
@@ -2520,14 +2522,21 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 		return -EFAULT;
 
 	if (unlikely(!ghc->memslot))
-		return kvm_read_guest(kvm, ghc->gpa, data, len);
+		return kvm_read_guest(kvm, gpa, data, len);
 
-	r = __copy_from_user(data, (void __user *)ghc->hva, len);
+	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
 	if (r)
 		return -EFAULT;
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
+
+int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
+			  void *data, unsigned long len)
+{
+	return kvm_read_guest_offset_cached(kvm, ghc, data, 0, len);
+}
 EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
-- 
2.25.4

