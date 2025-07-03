Return-Path: <kvm+bounces-51440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00773AF7139
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEFB93BC0D7
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FB22E3B02;
	Thu,  3 Jul 2025 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AlgEd2Da"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C32DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540342; cv=none; b=FnKcn8sU47RkvbQih5MJE/9VQAMRVHL3oLN4ro+4oOFNaAzWdXH8/rwgnyRNfxvIiW7G81Qts8eQFax0n8Z/u+uepLXZj4pqP1YwrvrGxxwQJhDDYxCXeQlwbTYqrDFe5lxecbjz19kr7p9odycJbxrHUYTmPM9e6J0q8W3Bz5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540342; c=relaxed/simple;
	bh=lYIFkmQpxVLAzBS0L3GYAx3+YzUSqNvBNK9FdB9NHGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8qBMjBQ/grtmqL2SUiY5o97Pxvy7K7tCa0QeVnuZ44vAURXlCygzEA/2l/TRFi5R5aap958pXp7tCVrNLF4Eo53cd1WuhlCl2QBNOHgVZTtL8fJYjgGEyg+kdMJZbMxWC6hYr2C2zj/l/3oJlhN+GnN6zqLYG2Y4NluDkqAKaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AlgEd2Da; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso55545685e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540339; x=1752145139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7w2y29aMH8m2GXB1cVKamGcDeB4cPEpvmgmQ9G6W5E=;
        b=AlgEd2Daiegto3+QhSDvg2xQJKlJTN9+ywQLla6MuIqPsDgUoQevsUH+LpgwA2C+Bn
         PtfsjYDkidjxt9rWCJ6S7kDZvOaDfRHWvtYt0tJ1Wso3IHO+3dcQlyu9lPQXcbZ/3fHh
         fp+WmTGEhUmh2lRjsfulH62wIoNrOBJaiEFdgwRjEdXZy/th7FZV2LK2w/a90KPG6wSp
         2RF+ryfGFR9BjaIAhJNOirrXpYKFL4Ccwg1+4TkC9c/T96AFMr9YCwOMdV9kpw+cTCHE
         4kVHSihEVw9w0mizgKzxEJw6zS8NXnOFNRItEUkJtQSzRzqstCiRH4A8gAAVwp9H6TAi
         b9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540339; x=1752145139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7w2y29aMH8m2GXB1cVKamGcDeB4cPEpvmgmQ9G6W5E=;
        b=MCyrUcIcSq13fP0N1A0GjpzvXtxfmLngWC2rMs4zWuF8vh4eyxtvxJF1yVYDRaWIOR
         mrQhLDn/pa3XzmS7TjxBWH5p6oSZtu/0FJs2sHhHmrNalEErKDMOX7VlUvZRCwrPvp0w
         B9lAY8aa1mDGvEG1uWrxxnJ/UctliRWz1iU7eV5lECu82QHABG/hDsz0qrNE2mlCQNR3
         GtOIXVZy+9ncJ3B/HaTGx62MvZlRBQa6YhaMB5Ur7Wi9w1Q8Dl/COPdpP7Aynq7ty4D1
         uXb2R1qnOLWrQqcsZOfXHP1qISfGj9CZAJC4AFvrrFdK5xxoMJ+4IL6YMMw7SB1Ltr7u
         oyTw==
X-Forwarded-Encrypted: i=1; AJvYcCXHiWDXTl5ZeAc54bpHEd323NUJx7DYpnNwUjg7hWtJfYBjWlvTWtFLw/c1Y3XMMIf0N8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiQKPhRXj62D+xp647hZdXilwRFNjX0tE1yv1IxcQTs8fBMWdi
	BMvBHbPEgE7H8DICDHiOz3OlpGcekpETgM/bONQHt0J/Y6JPbnH0n5z9lLccXWBuv30=
X-Gm-Gg: ASbGncu5GeRtdVt82OSXS7NePtSzRs/tyqnsWbvT5fw3A2yp3RX1HbFVUP8/cm13AxY
	BBb4HunKTk9SSJ9FHUikA3zBlQL4bB5KmmYrLkytEGt1G2v/Y8mUMKGsQyWxh970V/iWOA3m2IP
	UunDwoMOsxHpqeZmcUcTLJofcZtwTHgzqFG/IkqTkAZUyiaCNKtyIHDlYQQ/3VVnNAPqmz3dJ3r
	Y/0yI0MdjKCtxeQHIhKFLVZBPnwyH7BthPuQff50KBa4q8eQuxb4PtyqffNRvdmXVn/DT0r6PGy
	BX9r8LxoPCwEWmREUDoS7YBK54L/vkC/bIWwfyRw9R85RKdr1wOT3nakffxbgioy+rSflFtl0ab
	iOF65JHnSPf4=
X-Google-Smtp-Source: AGHT+IF5ahPc5pVpL/RRiZOMFhVAwIuTvCHpmYwi9QJmIWkfcSRYSeWG3E6EuXcDJdUkQxQiYDk1OQ==
X-Received: by 2002:a05:600c:8b33:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-454a3b33b8bmr66043455e9.15.1751540339032;
        Thu, 03 Jul 2025 03:58:59 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99b1c2esm23268505e9.30.2025.07.03.03.58.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:58 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v5 37/69] cpus: Document CPUState::vcpu_dirty field
Date: Thu,  3 Jul 2025 12:55:03 +0200
Message-ID: <20250703105540.67664-38-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/hw/core/cpu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 162a56a5daa..5eaf41a566f 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -442,6 +442,7 @@ struct qemu_work_item;
  * @opaque: User data.
  * @mem_io_pc: Host Program Counter at which the memory was accessed.
  * @accel: Pointer to accelerator specific state.
+ * @vcpu_dirty: Hardware accelerator is not synchronized with QEMU state
  * @kvm_fd: vCPU file descriptor for KVM.
  * @work_mutex: Lock to prevent multiple access to @work_list.
  * @work_list: List of pending asynchronous work.
@@ -538,7 +539,6 @@ struct CPUState {
     uint32_t kvm_fetch_index;
     uint64_t dirty_pages;
     int kvm_vcpu_stats_fd;
-    bool vcpu_dirty;
 
     /* Use by accel-block: CPU is executing an ioctl() */
     QemuLockCnt in_ioctl_lock;
@@ -554,6 +554,7 @@ struct CPUState {
     uint32_t halted;
     int32_t exception_index;
 
+    bool vcpu_dirty;
     AccelCPUState *accel;
 
     /* Used to keep track of an outstanding cpu throttle thread for migration
-- 
2.49.0


