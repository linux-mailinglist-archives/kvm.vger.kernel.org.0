Return-Path: <kvm+bounces-51329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DECAF61EF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72E23523D39
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC00248F54;
	Wed,  2 Jul 2025 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rQToBJEY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEC12F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482512; cv=none; b=XTsb8C8ramtKVYNdvzmgeytiZgplfCXRz5tXolImQ8R5dyxwlxsnzFVp00S0yu8+tYNbN2SiHs5ddGg4urwl4ugo7xWHr4dqV+65vKokBFhpY8QT0Vn65PbVPSSH6+8oF++3PQGLTzZCeYo7HS25FWPnJHUL4MhhXc7EMcHWzgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482512; c=relaxed/simple;
	bh=kqKMQrqf9g5uByfl7X2Uj93lIRZtbbkGJIh8HvnmsWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFNpNZ/1MVqDZVw8ZzepRiA/J3YuKinnAX+k/ccawg2cO7rIlE+dst3Ed91MDN21uI/wzF6dcbqmW0pq7txmsM+lLKd68cFrMVE3lEUwhwbwqcRD3Vl65K56XQHsJ5rLs4jaKiRFSRIFfRgYxYZ6ZDY2VRbakT6HUHBKaj5TI44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rQToBJEY; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so185665f8f.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482508; x=1752087308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6K9mSwv/CYdnYj/oy8Qn9vjsBz9CL/OwJ6+0PwH1Uw=;
        b=rQToBJEY7g5lCJjEKK1WScVjd2rPhqTNfxPapENfotRM3pyqo1bKySlNjlWarZf4gr
         R33s3Fj/F31kGeXKC4ajQCW4MDX1vUYRuTjpbndHHOUIOsfgJcGCLurXrb+9l2bogYTy
         GAjscoNxIcQJQxxxz+T2DxIMJ3cA7x8N91CC+wN/AujOLiVL0/nXI0Bo4GOBRXmbvppj
         58wOXgbZBTlztw1zxklI9JkTIQT4tBkDpgyMIgd9R7a0k/uEBmrLht6upH+DnpQW8noQ
         2OFuy5AvBgXPJzWc6z1MaBHWBiZoxejTeO/jvkjFAYMOQTwF7AncIP4VBcPRhp9BaH/Z
         aJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482508; x=1752087308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6K9mSwv/CYdnYj/oy8Qn9vjsBz9CL/OwJ6+0PwH1Uw=;
        b=pPEqyl4aaIywneYc7wbst97uUUh64Y9q556cVpTGSto7dZHZmdd6Xw11jvGLWZfQDz
         vF+uhwBgLQeHff1raXuEOocBVKjY+gzBlVBvidpDCflKcMwwTsLNCUqk1I0h/Z7/1NYv
         uXdmsMyjrONQgGZea8nSv0tL31htAEvIbk4NWm8+jbxA2JA7+WI0E0ior/GAjijNWeh/
         LJgkvoYBioNUPmcMTqC+QWpNfyGZhNRYOJbyVjani5QMKBA4GVCLNnQ+ypw4DZr1kvqu
         wSph/ba274cWS+Ec5IvUlynCIlstrnbdz//iK7IpNkTg7tLzWbXUnfdcbxhdXDzyuh+R
         W++g==
X-Forwarded-Encrypted: i=1; AJvYcCVrq5BPsiIE+wrwnUq08X9txMTqupcaBjUfEJcbUVdlkJOpk4l+zzo1RhobV7JAiXBPf6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMDPy1zFQfD0Tfj1TvD+3YcD0BTv2iGj6JMofDr1drLzenkXrv
	xAgA2DgcgbmY/1NuiLfyXDqbVrfS8BsqUrXQYHpx3NdJti/iDHLSOtpFtJYR0r+1iHw=
X-Gm-Gg: ASbGncs/SRgAHeKtViDvjG/CPddBqMnO4VIIgxxjB0ATdKR3OrWojFwr16uDKS8Av8O
	Wvqn/jaT/qVQoN2NMblKRb36tEQzejy8xwNiWz4qx8GfD03LapaJs82pMiKNDv++38cr6dFSWSl
	K+7yWiQNs2Vx/NWOM/T3BfkA16khgfEIZC4qBv4tvs7hqiQyu7EzkvMAMcaC39euXmpyNpMSUCh
	WZsiCre1Sa+XZ5ezNgb2B3ry1pXQyIzEm9VrJD9KOkk5Hqi8diUFO7HplpOKALoVshI7Pxwj/Pb
	5FKERw9J/zeTL9befe663hMeFEPsHXEfLvm1uugIEtkCkxcGcojqSyc7edLhfGBSXQjwVNTrDiH
	VyUOS7T24ukWq+boCCZVxpoiA9DjPviV3ADVEtxuX6/RV93M=
X-Google-Smtp-Source: AGHT+IEzzMX2NSpxlPsQ1b+gUvUOHoEJg0ltNzuqMHl7tYtFJYsLby7jGahEMqpM5rnI2gJXqZ+Fmw==
X-Received: by 2002:a05:6000:1885:b0:3a9:16f4:7a38 with SMTP id ffacd0b85a97d-3b34243febamr29187f8f.2.1751482508444;
        Wed, 02 Jul 2025 11:55:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5b2a7sm16819760f8f.69.2025.07.02.11.55.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:55:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v4 13/65] accel: Directly pass AccelState argument to AccelClass::has_memory()
Date: Wed,  2 Jul 2025 20:52:35 +0200
Message-ID: <20250702185332.43650-14-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h | 2 +-
 accel/kvm/kvm-all.c  | 4 ++--
 system/memory.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index b9a9b3593d8..f327a71282c 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -46,7 +46,7 @@ typedef struct AccelClass {
 
     /* system related hooks */
     void (*setup_post)(MachineState *ms, AccelState *accel);
-    bool (*has_memory)(MachineState *ms, AddressSpace *as,
+    bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 
     /* gdbstub related hooks */
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 72fba12d9fa..f641de34646 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3789,10 +3789,10 @@ int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target)
     return r;
 }
 
-static bool kvm_accel_has_memory(MachineState *ms, AddressSpace *as,
+static bool kvm_accel_has_memory(AccelState *accel, AddressSpace *as,
                                  hwaddr start_addr, hwaddr size)
 {
-    KVMState *kvm = KVM_STATE(ms->accelerator);
+    KVMState *kvm = KVM_STATE(accel);
     int i;
 
     for (i = 0; i < kvm->nr_as; ++i) {
diff --git a/system/memory.c b/system/memory.c
index 76b44b8220f..e8d9b15b28f 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3501,7 +3501,7 @@ static void mtree_print_flatview(gpointer key, gpointer value,
         if (fvi->ac) {
             for (i = 0; i < fv_address_spaces->len; ++i) {
                 as = g_array_index(fv_address_spaces, AddressSpace*, i);
-                if (fvi->ac->has_memory(current_machine, as,
+                if (fvi->ac->has_memory(current_machine->accelerator, as,
                                         int128_get64(range->addr.start),
                                         MR_SIZE(range->addr.size) + 1)) {
                     qemu_printf(" %s", fvi->ac->name);
-- 
2.49.0


