Return-Path: <kvm+bounces-21605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B2C93070B
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 20:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34EE1B25489
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 18:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B79140E25;
	Sat, 13 Jul 2024 18:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mitaoe.ac.in header.i=@mitaoe.ac.in header.b="D0GjrcNR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04718182B2
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 18:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720895920; cv=none; b=BjB9i3h7szNxHLBLz20KTnNj5lD7GJ/OrAga0hlM/w9vENUJXXAKNRoZyvht477f2g6YByXf7TFek1W8A4g384PU9rc5nu2zV3SzkQiFk9YPESld9OV1DEP8JzmgbJxjtc9EHDKUPA8jX8GHWwmLagQRwoE+aqXrzVenvOrV7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720895920; c=relaxed/simple;
	bh=66JM7MTshMlOTzGaZeayzTXOiK9+WXLBxR6p2mbsZ6I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O3okfBaw/ewBAVta9YEdx0G/FJVbv6egwGfFtuTK4YO1QvRM4v1c+RwoTreVDG7XXyUrerviBtVyGxhucB0DUH+TdOnbmx87QAO3DsMTKDjY7oCN8Mog4SGGUj/FxdQo7jTy4vS0nA1bMR9YV3fpRzzdWJOsIyUW2ssHtSGk50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mitaoe.ac.in; spf=fail smtp.mailfrom=mitaoe.ac.in; dkim=pass (2048-bit key) header.d=mitaoe.ac.in header.i=@mitaoe.ac.in header.b=D0GjrcNR; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mitaoe.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mitaoe.ac.in
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fb3b7d0d56so16956685ad.1
        for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 11:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mitaoe.ac.in; s=google; t=1720895916; x=1721500716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LBPw5aAlo17a0qcvw45tKrPGk8ZlsZwPKEwzWdjyf7A=;
        b=D0GjrcNRTV6QX0uedoc98l5zy3XYNscR7XSsqgs8L6vjZrJyK02Zr+7h4x7i7yb7HB
         ot+gSwRoGMcLx1YqMlOtjnMJMMxmY6sMyY3+PC0wk16IuOewHawMNaCEWDbfgSHw4L28
         E3Nuz5cNvBy+8/owVk6QNrgidX+jIwgbuPfcbufgjnOzaqMX8BAvYbNN6SLQfjVSLntT
         buxOd0rANtz9uyJ6TyGMwIL+1+B4PWyN40z01TfFqq2MwhUjzMcBoi8bQayTndTzotlQ
         4HeHT3iZwmuqYKKj5+2Nr13e6JFjYK6M2uKxBCA8aAq9NdiLUJi225Fzl1aCPjmpT0kO
         GdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720895916; x=1721500716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBPw5aAlo17a0qcvw45tKrPGk8ZlsZwPKEwzWdjyf7A=;
        b=q9Nk8vLYTO5KbKti/UA1d87IX+ZN3c/pNBan8nWz1nIiYc8cTAj4VhQyqGd1RKsRlj
         DgA6ecW3q+a+CommuOKwGaqZvUei3lRoJfV9PH/qopWwdVlRlQ1DHMbG0xRoL9EOE1/m
         +aTX/EscfAnkTWRmxQ2HeRDYvE3iWYUckVD6ZaVBYoO9oGAfne3CpeyMfELSsj49bD2A
         c8AVqR12Ss/iR9HGe/gvNCU027tTQknSTxnn7HtAWTavQ2TVGn/m/EKm3H+2gU2zclXe
         swyz+PCGIZV6fKuMefqyfwn0lXp/dQ6zYlApneOZ4bwciO3ejRMiQGBR4dZYYxE6uj18
         g+tg==
X-Gm-Message-State: AOJu0YywWIc6tUwgPRJP8W/N7R8KZxdi10DiHC9UZJu6k/Rb423Qy6+L
	jUwg/2VPHMcOgP3A2B6g35xyhqFR/0bz05Hz5XGXDMTzDHr4Nn5RCh/Kij/6eiPs2cEnJzK5ljU
	EG54=
X-Google-Smtp-Source: AGHT+IEAGCPvPUUX0mH+chWYU7b4BUEc+3xxeZoD9yWvB/3c1yEm1dy33ooRnGEm9lyXYu2x1cHGbA==
X-Received: by 2002:a17:903:228b:b0:1fb:6ea1:5e with SMTP id d9443c01a7336-1fbb6ec1f2emr129417495ad.44.1720895916109;
        Sat, 13 Jul 2024 11:38:36 -0700 (PDT)
Received: from localhost.localdomain ([152.58.19.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bc3787csm13061605ad.189.2024.07.13.11.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 11:38:35 -0700 (PDT)
From: mohitpawar@mitaoe.ac.in
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohit0404 <mohitpawar@mitaoe.ac.in>
Subject: [PATCH 4/4] Fixed: virt: kvm: kvm_main_c: Resolved seven code indent errors
Date: Sun, 14 Jul 2024 00:08:13 +0530
Message-Id: <20240713183813.127677-1-mohitpawar@mitaoe.ac.in>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohit0404 <mohitpawar@mitaoe.ac.in>

Fixed 7 Code Indent ERRORS-
virt/kvm/kvm_main.c:3347: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:3377: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:3432: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:3598: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:6006: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:6007: ERROR: code indent should use tabs where possible
virt/kvm/kvm_main.c:6337: ERROR: code indent should use tabs where possible
---
 virt/kvm/kvm_main.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1192942aef91..4b9090693527 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -130,7 +130,10 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
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
@@ -3340,7 +3343,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+				void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -3369,8 +3372,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
-				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				struct kvm_memory_slot *memslot, gfn_t gfn,
+				const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -3425,7 +3428,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+			unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3590,8 +3593,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
-			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+				const struct kvm_memory_slot *memslot,
+				gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -5999,8 +6002,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	 * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	 * avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
@@ -6330,7 +6333,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
  */
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 {
-        return &kvm_running_vcpu;
+	return &kvm_running_vcpu;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
-- 
2.34.1


