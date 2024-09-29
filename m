Return-Path: <kvm+bounces-27651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E429894A2
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 11:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3A941F20D47
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 09:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A8614B970;
	Sun, 29 Sep 2024 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dE4CcqPj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEADA184D;
	Sun, 29 Sep 2024 09:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727603360; cv=none; b=Xrvz2XrDEiu9Frvj1GGlVnpYTt4b3YcutVFUVnMBnW9OYNJlZeLYfmp/qZv/4Np3Ojak1IA894bLKLSs+YeFBsfm6zlGKr90n/yokrNW3kDX2IMqyplJ1uwaGOOEfUiXF3k8ij/A/E9EkTkfTVd5+3dzl5pJ0p6tfc9/VQq+tDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727603360; c=relaxed/simple;
	bh=/hAaLQRaGYbGjC12s1FK2c4MVPn7kXs7CHjzldec3Ko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KHY8QwTmRSUyx7CdInG6BRW3977cOi1mbcej/EHbZdWDuGQ9pQnO/NSE1qWV2KmAU1i0r0H+KdDbA953Fm1jWIhICuuEYN25Pp8ga4agtAXXEeiOTPnpBzfUPJ/ceYGeIsrSMZDXF1Ko6y7Sret4Ey7ieJ9iAWZCJAj9n042XT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dE4CcqPj; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71798a15ce5so3386155b3a.0;
        Sun, 29 Sep 2024 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727603358; x=1728208158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oO6xy91qlhI83XdLLLglm85KjGrzhEnTuyP21KJW/0w=;
        b=dE4CcqPjxgDe5fRlKIZbgNFRfqqqyXhz6ckO7YJGZWSTMo2rDEa/bDeJgD81P8tspn
         hHY6B0c3zuDhdZptGIagtArF4wUaLrTVnteJQ59zN7Vi2UJ6TZEI0nzA7EE4NlV2/g+2
         reha5MCaGXBXDUgoIqCfnic/wM5M835Fr9/qp6w/MeY1iuye3k78xla4Enytg36nBqm6
         hRpL0tT2AQCGrzYXSMOPiVYI/M/5VRxXdELMEo0FTmqsd6MgGDQdmTXfioIkCpMBNZPC
         gDrBgzH2iDgeNcvaUfCfeDdxCRYz7857iNFayaRhyT3I/jHctpwZzGXWVir9fZJoNejB
         pn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727603358; x=1728208158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oO6xy91qlhI83XdLLLglm85KjGrzhEnTuyP21KJW/0w=;
        b=S1nWx4fXpOEau3ZZHc3h7c4k/y6G+JmFIUaKIe5iO2gYv5xNwEZqbH55OpyZMqNZnp
         ebFu3FEahgs+OxXviQnJOp95/H21C6LIQxwugIFt15zmu1H7VQ8UWkZwHhRgm2X7ISVN
         0Rc2gSIrG2SKR6EG3MlopxdUp+HTwuTnDJMQaSMQrzfhQB544vLDcE+HjeoGI1WItcPR
         NZeIvaKyg7hCPS/XsRkYEeBVAFDHII6e/muWTWSlz8o8uhd5C8AZAlEx5bBQ2qGjqakn
         wYVBvLSbuhAQxCh+ENtCcZvQuWbezz9NcppNzfS2hVm8Of2VZ7Cel/OlmH/brYOmwB06
         DxVg==
X-Forwarded-Encrypted: i=1; AJvYcCUNqYpLYff0gQjxKQ2P9gEy7YKUj0d0gXUNymJfk+AZXPtHmWovQ5PyIhYVk1KbIKYHDpAUeEfATDc1vsc=@vger.kernel.org
X-Gm-Message-State: AOJu0YygeAMszmqLJz21NOLFLEo7nWsQ2tIKeRSnFJZLocY2ac6YaWfQ
	gS2LwE1R7zXbO/m4mCTGj+yFHLHnQCOA4owbR7xsO5BJQqO7f1cW
X-Google-Smtp-Source: AGHT+IH2NgmPUTDhV1ajfOzq5hJ2UM7453zMFtzTuyyj7t1lefMX6kNgEw9jugmIMKUsI1PYc/xSig==
X-Received: by 2002:a05:6a20:c79a:b0:1c8:de01:e7e5 with SMTP id adf61e73a8af0-1d4fa249577mr14139994637.15.1727603357872;
        Sun, 29 Sep 2024 02:49:17 -0700 (PDT)
Received: from thushi ([171.76.87.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26515eeesm4293531b3a.130.2024.09.29.02.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 02:49:17 -0700 (PDT)
From: "Thushara.M.S" <thusharms@gmail.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thusharms@gmail.com
Subject: [PATCH] KVM: Fix checkpatch errors
Date: Sun, 29 Sep 2024 15:19:13 +0530
Message-Id: <20240929094913.8231-1-thusharms@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit addresses coding style errors reported by checkpatch.
Warnings are not fixed in this change.

Errors fixed:
$ ./scripts/checkpatch.pl virt/kvm/*.c | grep "ERROR:"
ERROR: open brace '{' following function definitions go on the next line
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible
ERROR: code indent should use tabs where possible

No functional changes made.

Signed-off-by: Thushara.M.S <thusharms@gmail.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8e72056581b5..d7b5afb5adfa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -127,7 +127,10 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
  *   passed to a compat task, let the ioctls fail.
  */
 static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
-				unsigned long arg) { return -EINVAL; }
+				unsigned long arg)
+{
+	return -EINVAL;
+}
 
 static int kvm_no_compat_open(struct inode *inode, struct file *file)
 {
@@ -3341,7 +3344,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+				   void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -3374,7 +3377,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -3432,7 +3435,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+			 unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3598,7 +3601,7 @@ EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+			     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -6088,8 +6091,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	 * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	 * avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
@@ -6422,7 +6425,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
  */
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 {
-        return &kvm_running_vcpu;
+	return &kvm_running_vcpu;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
-- 
2.34.1


