Return-Path: <kvm+bounces-9878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1918678D1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 226682921B4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89215130E4E;
	Mon, 26 Feb 2024 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMqw5NCR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F5130E34;
	Mon, 26 Feb 2024 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958128; cv=none; b=LwdDR6wcxNfPmYMWAOuF0Z8pXQtDDPCK20SKmnLhs9O6fFWIvNLeg1xZhWybgtaX6VP5H8AF3Uj+8wa4kLVKkPkMsD7vuMOwcB4eR/N85Cv0+glSOx1jZHyuICO22iyCEsOMYAGF571XkO84dBvVyWPZtZ4/zpeTd25BEsLENeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958128; c=relaxed/simple;
	bh=bsV9BT402z/Bw0WTA6E9ywSofSFLcIXPfojxj3LNnZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y5gG6KcU9pTkELrI/5hgAd5sbmycI7C+ywrRp5pV3JhfesHD9pQ4JycbXtyXdCZmDe12bpKrYfkoQMyihdZ/ukVv0ORNvyhR+48x035BxyL66+gUozSwlWlHcv9kWO+7rHdJm+RWva0YwpG0DzdJ34bp3MZbpCzUimufKJiOcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMqw5NCR; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6da9c834646so3175976b3a.3;
        Mon, 26 Feb 2024 06:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958126; x=1709562926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7SpjWW3M3VT8K4eO43rbegmmX62zA+So7hwLN6Ereo=;
        b=QMqw5NCR0RJRsriE0ZN9FFW2tJ0rkM6qN6R8JKYCXTn9hfxq9N40rAdpwBLVW7hSQ8
         Sx6AtBEGjUTiGX+pUX/FNF3+gkT9CzQ0Ln7GnT2TQ3QksuWoEJhvKx/RwGEER5G6/2WV
         r7sCU8X9+daKD6Cijvvmc4oPsfrfOnJuxa7zxGVzjeMWT5jK24lSiIy4ko1UhMnAV/JV
         ss2wjuSUDZm+6m22bP9Za5b0SloN/MvGCHHx2NbqY37O4+pvT+rvjhA2PdV8UXkDAkY6
         FVzF3RL7eVYiF4+rg0lS7y9rglLepO8b+owNHKcxw3Q7DhP7aCIlV2hl/weJb01UESDX
         Hs9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958126; x=1709562926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R7SpjWW3M3VT8K4eO43rbegmmX62zA+So7hwLN6Ereo=;
        b=uHqcQruh7Z/B8TCjizlj+lyGlqdXFW3O+ob7/oQDGk1WUyD9zLqp+Ej7S3Cg6iTdA1
         eW+1bsUBW6nWebACUxeuM95L3ba3ecTeADXrTLj3I0iWskLFVCKGQYSh9+UOHPTqLQiP
         4W6Pf3eOCmBjouIVeCMMNjwuNO8wfT0+HY/YGpOIgYZylhaoj+YyWVWuTuOEmGO4cEA4
         rj/x0Rm+gMlA+boVSwQ8uaRmyG8dXS59Ox85CsSZavMP8OeWStP7M65dLjoVMh6gJVJX
         EMU1zOyQ1FxrGzkqlBUlz4Yrc8s42eTlxnWris3pL0A6o5yIXighSfsR3X373lZqCUED
         xvZw==
X-Forwarded-Encrypted: i=1; AJvYcCVxBlwQuHNGV0+DfLXfkrOlIv643BEHBgiNh4CEIr/QKE3dEQ3XbyrWqTZfbVh8BJKTI0JK2Rd+jCfJ203FgLXyLMhY
X-Gm-Message-State: AOJu0Yw3TsKfykZoDyMdRhCi6oqt+rZThmbx38YTYra+DIOiHRvCpf/0
	5ZWJ1NwQ7M+phEpgo28aHrM7uwfujioefUw3Al2vvN6TFOYtop+DPhVRCKbd
X-Google-Smtp-Source: AGHT+IGxAib7PTEOyHxSwfGQM+HxjrBdjOJVRLrLNJZ8c+/eWVFjsZhC6aQYApF7JqdEKo6G4JQCnw==
X-Received: by 2002:a05:6a00:92:b0:6e5:9a7:34b1 with SMTP id c18-20020a056a00009200b006e509a734b1mr5652064pfj.4.1708958126496;
        Mon, 26 Feb 2024 06:35:26 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id fn7-20020a056a002fc700b006e4e7cafd65sm4076819pfb.42.2024.02.26.06.35.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:26 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH 15/73] mm/vmalloc: Add a helper to reserve a contiguous and aligned kernel virtual area
Date: Mon, 26 Feb 2024 22:35:32 +0800
Message-Id: <20240226143630.33643-16-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

PVM needs to reserve a contiguous and aligned kernel virtual area for
the guest kernel. Therefor, add a helper to achieve this. It is a
temporary method currently, and a better method is needed in the future.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index c720be70c8dd..1821494b51d6 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -204,6 +204,8 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
 }
 
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
+extern struct vm_struct *get_vm_area_align(unsigned long size, unsigned long align,
+					   unsigned long flags);
 extern struct vm_struct *get_vm_area_caller(unsigned long size,
 					unsigned long flags, const void *caller);
 extern struct vm_struct *__get_vm_area_caller(unsigned long size,
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d12a17fc0c17..6e4b95f24bd8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2642,6 +2642,16 @@ struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 				  __builtin_return_address(0));
 }
 
+struct vm_struct *get_vm_area_align(unsigned long size, unsigned long align,
+				    unsigned long flags)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL,
+				  __builtin_return_address(0));
+}
+EXPORT_SYMBOL_GPL(get_vm_area_align);
+
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				const void *caller)
 {
-- 
2.19.1.6.gb485710b


