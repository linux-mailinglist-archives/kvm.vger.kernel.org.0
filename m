Return-Path: <kvm+bounces-60501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2A8BF09B4
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E4904EB542
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC8E30103A;
	Mon, 20 Oct 2025 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o7ZTv4Eb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7DE2FB98E
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956730; cv=none; b=NdDiVcXLHgEnCNh43Eo/Ida1O3+vKdWqCmQqykKi8nDDRYLEVh4l1Js8KqQuz/T5Byd1g1GV8vOvNVw+U4Fndwtz531buJjmPJ7crmPxRMOB8dDJPjelQ6szdaaxHhrjG+X7A64csteJBfF9ZqmTXIwYh2l++BbS2zm6NRPjtEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956730; c=relaxed/simple;
	bh=FzQDChSwym9H2evrgW1e1vjPVYgUYi3UtGRdw45i0c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vg6obfypnoGIeG3XgmJCtp9tEQ8V6M5NgBmhLvjTiQu6odvG1MTbRvebEfZeVo9ZKXzWDMK34q8YvUof4X8P96m42cf/3MvhvT96MXEZDdt283xh3ghObx6W3GQYbW7xDHKa4u/zkKXRbxYUu+Rw8+PWabwZ0WzsUpzShz5e83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o7ZTv4Eb; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4270a0127e1so1679585f8f.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956727; x=1761561527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XchvKX1P3pmKtpFUzec2QYG+hUglh7SzS1YPHheIc9Y=;
        b=o7ZTv4EbI2lwDbZTQDedkbGINVb5xWQ23Xm2h2Xsrw5AQcoBPFADVAjwgpdVqTCk1B
         tuhcoEsiytKZCWcFwUeTOEbhcFGEK3je9iKx5eZXHEpqWTqJbLXbvWu+SNlEktmHKvpZ
         qL1G/3XvhX2//85ZH3EHnk2W0VH1z9ULRfibSM9dd+jlgYunv4a+OHCJw8vSxY7/MwRc
         uQk0iNK2Fs380OPUNgywpgV0azTwq9znhxQu9tF6UuFIECu9pxZ0EeFu96/emEOY0ro3
         7Ze41dGybOyAJxOiYhqLR1ERJV0Ld8IxafcEIXifDVrdsDSnPJsHqxYB0589jLSnIpqi
         hupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956727; x=1761561527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XchvKX1P3pmKtpFUzec2QYG+hUglh7SzS1YPHheIc9Y=;
        b=DquCvdAklqtgiknzscSTIB0v6gxAf17IZXDHp2aFUx3ElXuGIomlFMu1jIcxf8z0us
         hprvYVhuBsp/GXCmdKjI5cL2VDj7MBre2MyFJTRqOLphtOQMv58tuP+vZPheDDsEvWme
         56lP7t02HMivAVEipjpotK4Vw8fFAgnLSvH/UngOm5TvbBnuwOHaQ0SIkxPPY/I4XGe4
         14pWvD+yc6W+EdeYqpfcqWLOExh85tqMlzB+Oes7XSBVdY8IUbbU16zTFoTXYUlyfDJM
         yFHstZFJhnSSDHkObdSrPtjkYF5gO8/ajFFHnSfj9WscGzo5YImUgAEXf3JAZAv3Pewb
         EXWA==
X-Forwarded-Encrypted: i=1; AJvYcCW/YnWcrNb9curc0fMluflp6f/kTme1mjQl2j1BJMmVoaqOHTiOaS6g+TlQI0E7FyM1eqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQnlu5s5L59+gupfk8m7pMFBFtbmRHgUvKTkLFHeYk5Ctlgeto
	MZemetdyIauSlogaTCAgLeKealYd/BU6mskb1jjOZKMD17XKdmw0bwPibmMkwMMlmoU=
X-Gm-Gg: ASbGnct6rBOGjYhfE+Zd0KUfYfkHGwEaawQSLIXjNqbAJoxZ9KqRrtq0W7e2/unb4fR
	eOuGq2B0xeXECz+RVCTeW1ZS50OPGrZ3eCSS1xgL+YEWELeKjhQkSQ7tT7Gk/4k5AmUTjjXIbtN
	vJ/BQTKqBiMA0gRz47yS5mDmCEgiQxWnMbGQE8r8nL1zSVF6audWTS75sdd0asjQ7VmTBG0Xqh/
	ZYrYp+/TDZQwrFGmxiJeqUUQqTLGX5WohEOR8F9/KDQGCyw2bSV1aBqyiKKU6Tz9/vVo2nGRuPk
	Abjm1JiDRiXOw5JoKjPklUDejxS9LbvrjIGQN/0KBizexWe5fTKB3hgrPBtZiKduKSujQ12BAgE
	bV41gVp1izIuom/2UHghhdx72Mn/y9o1j0D/rj+RDg3OWISpSWTxqhtfEAnadrZRwIh7edeE7cG
	ff3sTV0nk4Q1srifckw2aJi2WekpP4MvB2NZ1RTEAmzZSvanygnPbJy862BCrg
X-Google-Smtp-Source: AGHT+IHQgd4IyBZk1X8qax/mfrCj0WRZC+hpDHiPajM8IGn0ydegHDG75cWXcjnzX++NX0Exg2anBQ==
X-Received: by 2002:a5d:64c4:0:b0:426:d51c:4d71 with SMTP id ffacd0b85a97d-42704d44253mr6869195f8f.8.1760956726904;
        Mon, 20 Oct 2025 03:38:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ba01bsm14420098f8f.41.2025.10.20.03.38.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:46 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 06/18] hw/ppc/spapr: Remove SpaprMachineClass::broken_host_serial_model field
Date: Mon, 20 Oct 2025 12:38:02 +0200
Message-ID: <20251020103815.78415-7-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::broken_host_serial_model field was only used by
the pseries-3.1 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h | 1 -
 hw/ppc/spapr.c         | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 494367fb99a..06e2ad8ffe6 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -145,7 +145,6 @@ struct SpaprMachineClass {
     /*< public >*/
     bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug of PHBs */
     bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
-    bool broken_host_serial_model; /* present real host info to the guest */
     bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
     bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 2e07c5604aa..e06eefa3233 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1213,16 +1213,10 @@ void *spapr_build_fdt(SpaprMachineState *spapr, bool reset, size_t space)
     /* Host Model & Serial Number */
     if (spapr->host_model) {
         _FDT(fdt_setprop_string(fdt, 0, "host-model", spapr->host_model));
-    } else if (smc->broken_host_serial_model && kvmppc_get_host_model(&buf)) {
-        _FDT(fdt_setprop_string(fdt, 0, "host-model", buf));
-        g_free(buf);
     }
 
     if (spapr->host_serial) {
         _FDT(fdt_setprop_string(fdt, 0, "host-serial", spapr->host_serial));
-    } else if (smc->broken_host_serial_model && kvmppc_get_host_serial(&buf)) {
-        _FDT(fdt_setprop_string(fdt, 0, "host-serial", buf));
-        g_free(buf);
     }
 
     _FDT(fdt_setprop_cell(fdt, 0, "#address-cells", 2));
-- 
2.51.0


