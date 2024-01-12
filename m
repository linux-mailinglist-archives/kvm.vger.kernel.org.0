Return-Path: <kvm+bounces-6141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FD682BED7
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 12:04:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0792BB23ECD
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 11:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C435EE9B;
	Fri, 12 Jan 2024 11:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="khKgviO2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B85788A
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 11:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33765009941so4991700f8f.3
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 03:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705057478; x=1705662278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuBv+tjjYyX/4wybca/v00Vtc3kwStjz3AWoQ1ArRxc=;
        b=khKgviO2UsR+F4hqXiQlDDEsuY6kYLCHMxXRMcDEE+84NfEYezjRXY9vA2G/HO8AkR
         Fe0k7kjoBNRbOqoePmETBW0sOm1/IE5kzh8TGpavHcaNv0ssGgijl4NfO4u30J3wX0cA
         9ebYGJCfRtc5iz+ZxMV/T4pVtw0MQsxm8XBDRQp1rLRLxmN5y1RtQGdn3fXvvVRS0NyM
         dMSCJGYEnNA5vkCt+iS5sh85ULw9gqS5T/rA2nTsYdYCcos552V3+0cuXcOFfxAsgXWk
         Ie0L4q5BN3fbY8M3WaEN2MP23kJYZ95EH9LV3CGNam9VU8qWQtHCtU5TfLOoLqA8Qg3U
         LgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705057478; x=1705662278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuBv+tjjYyX/4wybca/v00Vtc3kwStjz3AWoQ1ArRxc=;
        b=qjiaOq3PDDiVOFe2wdme+rsGO46oQL6qgUiXvHLcgE4HaRRvBaic0lvjYvWVudsu6Q
         ms+8c+3xJ4dKOPDEBhJhnlZqGzvuD1mIRiB9pSZfzMx6kwBN1KWkucihNl9ms6qRQRXC
         EZrDtSpu03Y+dT1FCLWWm0lWKtyLZNLawHKHPNgggBCCgQBJb5ha3vKebol4LPz+A6yA
         BC87CH6sjasCeHGAHK9+Xe4we+Ik2Cm/ppAO1AvoDg9Ue/Jaon74+K2icA1uN728pIH6
         BYdFThZOXrcLcuWCIKth062WT2mPDBqu8G8Rtig9v0QNqOU0E4gTfs9D8ZNJOYqaUitb
         GwZQ==
X-Gm-Message-State: AOJu0YxIUVH5g0pLHY+xPB8EXqfPI0kHmKSAeu2LE0o4hoEBgvQFqOuQ
	dRjc+3hwd/ce8Xzsu2IqgqOlYVmyA7OPCg==
X-Google-Smtp-Source: AGHT+IGbQuk6POLM8cxr7zqiCsayNJdOK1YHp5aSWlH5Oi8N4gAaQM7Kvf2fzp4dWrgkdmm3cu2iEQ==
X-Received: by 2002:a5d:65c7:0:b0:337:767f:c989 with SMTP id e7-20020a5d65c7000000b00337767fc989mr636755wrw.12.1705057478759;
        Fri, 12 Jan 2024 03:04:38 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id s27-20020adfa29b000000b003366cf8bda4sm3566784wra.41.2024.01.12.03.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 03:04:35 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3C0005F7AE;
	Fri, 12 Jan 2024 11:04:35 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Cleber Rosa <crosa@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 02/22] tests/avocado: use snapshot=on in kvm_xen_guest
Date: Fri, 12 Jan 2024 11:04:15 +0000
Message-Id: <20240112110435.3801068-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112110435.3801068-1-alex.bennee@linaro.org>
References: <20240112110435.3801068-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This ensures the rootfs is never permanently changed as we don't need
persistence between tests anyway.

Message-Id: <20240103173349.398526-3-alex.bennee@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 5391283113e..f8cb458d5db 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -59,7 +59,7 @@ def common_vm_setup(self):
     def run_and_check(self):
         self.vm.add_args('-kernel', self.kernel_path,
                          '-append', self.kernel_params,
-                         '-drive',  f"file={self.rootfs},if=none,format=raw,id=drv0",
+                         '-drive',  f"file={self.rootfs},if=none,snapshot=on,format=raw,id=drv0",
                          '-device', 'xen-disk,drive=drv0,vdev=xvda',
                          '-device', 'virtio-net-pci,netdev=unet',
                          '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
-- 
2.39.2


