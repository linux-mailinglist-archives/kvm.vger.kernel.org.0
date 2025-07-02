Return-Path: <kvm+bounces-51258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E83AF0B41
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE2993B2B06
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0355121CA1F;
	Wed,  2 Jul 2025 06:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AT7zKBtU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006C219A86
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 06:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751436212; cv=none; b=XSwcKRb5Su8ZsrypF36Di6pHk1c5FbWmbEyCP0tLXoPYzDV+v7tlO2CI+ooP5i1TDzr6iwZ+GxR9l7nZRtUBYFtqss4KmkDF24481n8XHdI1rV72zlOmviR74RTwUWtMdvQWn3dZOvsk1hXXRarqIgd14AgZNVtsbVnkktHFzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751436212; c=relaxed/simple;
	bh=2xBaIOFPWQc9LYdkz/z5VV41m28n/9SuTEsMYuArsEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLLE8cv4Fb9gAViN9cOqyB2wCQcaVuSG8a0jIyOTE5zG1poAb6+uGPkZk5lHW8a6B+szcJHTr/a25BOZDD+k7HUYyHMFDyc5d2C3LoqCE9O1kzGlMUv5ecR68SGH/9X5e1tiQLy5WmD9AFoz7L2eopN9Py8Q9rMtpqF5NrpJ86E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AT7zKBtU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751436209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BL4N4vQUHRolZ4DvmG3fojJiew3wsR9YAjpgmgCVCXk=;
	b=AT7zKBtUyZNGfzpP3wKMtvUCSo7yLBioykbod0XnTW+UCqRHweHoWzVaFi7fQ0d2JwAR0n
	1/jdPyBQ+UILgBkSy5oOTpOV75LNcmP7lYOEFR0LVtSEYymUA2M9z+N3QbG+sJpBITAa8m
	+G2xmVn2zsw7NUGt2iE46Zw+/kh9o7w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-WQ_eRFWENs2ee4mZhZ6sXw-1; Wed,
 02 Jul 2025 02:03:26 -0400
X-MC-Unique: WQ_eRFWENs2ee4mZhZ6sXw-1
X-Mimecast-MFC-AGG-ID: WQ_eRFWENs2ee4mZhZ6sXw_1751436205
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 779421955D4E;
	Wed,  2 Jul 2025 06:03:25 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.120])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24BAB18003FC;
	Wed,  2 Jul 2025 06:03:21 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-stable@nongnu.org,
	qemu-trivial@nongnu.org
Subject: [PATCH] accel/kvm: Adjust the note about the minimum required kernel version
Date: Wed,  2 Jul 2025 08:03:19 +0200
Message-ID: <20250702060319.13091-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Since commit 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and
KVM_CAP_IOEVENTFD_ANY_LENGTH") we require at least kernel 4.4 to
be able to use KVM. Adjust the upgrade_note accordingly.
While we're at it, remove the text about kvm-kmod and the
SourceForge URL since this is not actively maintained anymore.

Fixes: 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and KVM_CAP_IOEVENTFD_ANY_LENGTH")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 accel/kvm/kvm-all.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d095d1b98f8..e3302b087f4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2571,8 +2571,7 @@ static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     static const char upgrade_note[] =
-        "Please upgrade to at least kernel 2.6.29 or recent kvm-kmod\n"
-        "(see http://sourceforge.net/projects/kvm).\n";
+        "Please upgrade to at least kernel 4.4.\n";
     const struct {
         const char *name;
         int num;
-- 
2.50.0


