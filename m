Return-Path: <kvm+bounces-9928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E1B8679EA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF75FB33285
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C33214CAAB;
	Mon, 26 Feb 2024 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="km8qtcDh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9914AD3B;
	Mon, 26 Feb 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958361; cv=none; b=GTPbMTB6x6/pZ4bbBK3uWVBVz0zsO6F5N+sqZBndB2+qoe+On4Q4d03p1BD8nmq4J3SFmQg/JtGSR/9Q5WmoL2LgC3e014H37G+OKVAE48Xe1rFRN/upPTjA3SLH+krElgAAToFu8ruiF6rJPX/T8AzDFJPelSpW2vbGo8AhGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958361; c=relaxed/simple;
	bh=XhSoym3qQlKNWcZaO1fmucbwOJAhaGU0ZDzfY5zhuSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AvrL2yEVwObNlWd5YgQQkzkilx2JzkYaRwfI8GYlGyuNTNeMvJT6U309O0xcB8Pz+TKPBPhLYXYavPJwuR6qjc4YvTGAAZ9pJDurSqUj7PuCdBxFMFO9y35RyGMkwfA8sS3Iga6lHlXpmak6XZ3qzIi+P6HdwsAk8VFpy6jMRMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=km8qtcDh; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dcafff3c50so3680195ad.0;
        Mon, 26 Feb 2024 06:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958359; x=1709563159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkFyhfs2k+/ZiDzHPyMbRms0OafqFweJ9xnGHR0iLV8=;
        b=km8qtcDhONpx3iGTYwvzSZTeaCQUZLPRlKLAAnm+nDZXnmuiCpSvU3aDjI2f2+wcyj
         9R9zPCS5dcnEGWyht4zpdJcf3y86FDNnQZsg6/7c+vakIEkp+lNCffDEyYMK1c9XIhmO
         XGCLdXyJFjUo6xNmrfM5lczAEuU1mbqDY+3lry/Zwdtl0dFleT//VJfl4wQ2AvjWQN1n
         i190qpCZ5ejZPEum/3rxE9+jhtGAIJXD4FJf71v2VtYyNsduJrK98TPHEOqxj+NyjvqP
         b220mHUMYfWQe8p03aJ+oZXPxUF8IlhqH8r0WHljj2xuwkYXzGu38KnP8uaQV4iBIJoA
         daWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958359; x=1709563159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkFyhfs2k+/ZiDzHPyMbRms0OafqFweJ9xnGHR0iLV8=;
        b=QLfjRmAE3+g0JOShuRWDVMLAGoGxb4dnlynOCMWzZHz6BbVx9tuZwQ/atYeYKpZn4g
         NLeL+l0dVAWs991UO3SNY0Ri37W3r+QZxhg2iKIQiFULgs3DsdoKu/F7p8GyjPQVyndB
         2kHZBFPUJXr8Wzcf9KSCJ+77aFiASjBEIB9HmheCcBuEyYRB2N1vZlnLK4wP71UC5qVj
         WBf1OM2zcAEUjSigZu3aPCQ/uf8VBFsZbHb+MnRvM1MJNUVtIqfoVpp9YAhf9gMFIuXU
         OBXcRGEHdoSdW+t7udCwlSi3ABzWSxTMNyDwQ+WDZp6uEO3fU6Cgz7sS82rof94sE/Rk
         3XnQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/92nAyb+4OnrYd5XiInYZguhoAtZTAIWrNNZqahzpMobFxK0m2eZHoYTP//9v7STJmmgqJyrkytt5mjzeepGolKVB
X-Gm-Message-State: AOJu0YyfAh+9xksGH7f2UUxqF4usGqpPEBnBBTajRjcdRLAwt/rqKmun
	gZQNQn+YcsFSxKksRGKvMKgaxO3FbUaUWdHBj5SWVLCZsdH79fMRbYvyqkfm
X-Google-Smtp-Source: AGHT+IF8tRUu66bSXe/aJmjWB0UBmQOoCiQpAK7DNUmyzrYAZTKYIv0rpCc73qQs0tztBkfqpn2XWQ==
X-Received: by 2002:a17:902:d488:b0:1dc:8042:3b76 with SMTP id c8-20020a170902d48800b001dc80423b76mr10400301plg.2.1708958359247;
        Mon, 26 Feb 2024 06:39:19 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id b4-20020a170903228400b001db5ea6664asm3997276plh.21.2024.02.26.06.39.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:18 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
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
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 65/73] x86/kvm: Patch KVM hypercall as PVM hypercall
Date: Mon, 26 Feb 2024 22:36:22 +0800
Message-Id: <20240226143630.33643-66-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Modify the KVM_HYPERCALL macro to enable patching the KVM hypercall as a
PVM hypercall. Note that this modification will increase the size by two
bytes for each KVM hypercall instruction.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm_para.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 57bc74e112f2..1a322b684146 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_KVM_PARA_H
 #define _ASM_X86_KVM_PARA_H
 
+#include <asm/pvm_para.h>
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <linux/interrupt.h>
@@ -18,8 +19,14 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 }
 #endif /* CONFIG_KVM_GUEST */
 
+#ifdef CONFIG_PVM_GUEST
+#define KVM_HYPERCALL \
+	ALTERNATIVE_2("vmcall", "vmmcall", X86_FEATURE_VMMCALL, \
+		      "call pvm_hypercall", X86_FEATURE_KVM_PVM_GUEST)
+#else
 #define KVM_HYPERCALL \
         ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
+#endif /* CONFIG_PVM_GUEST */
 
 /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
-- 
2.19.1.6.gb485710b


