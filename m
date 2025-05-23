Return-Path: <kvm+bounces-47646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1F1AC2C64
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB026176A28
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED630224AF6;
	Fri, 23 May 2025 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3cbeesok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EF1225A32
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043073; cv=none; b=Pn607KL8gZxu5lCtMcao5NXEvaMZ0pHmHie+BlWl4SMutYgAx94DykV8yLuT5dEQg+t+OrE5YhK24J31v/ebk6Ll7hn5h9uXPdP1BZa4rNazVEimi9Vg2sxnbNp7b1cUlzBcTSEQv8eZkGF/Tmr/l4tBB1L/nB10th5qSt0Ekuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043073; c=relaxed/simple;
	bh=iRmwnk0PM4Hf3mgEI6zwXc+LDu9EVp0n9/ZhsmiqBxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VL57X3c5OwLgEqnzEY87g2gkX6fgzV1lM6s+tkNWLe2gN7SjUq4onfmFFoNRpxjCizqb8YMfl1NGzTzy+0Y5fIJdeIJgnLRX4PwhsWX+6kwuWqDSDGE33WFiOAUt9P0OXXz4Q9uSyYdP4NVvahqvSYxHdLZsSuZqO+Qgmtcyx4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3cbeesok; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26cdc70befso205898a12.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043071; x=1748647871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4vc5iaoQdMCELnH2bjQjNG3ycmxby9Jwfat7xnJ+cIE=;
        b=3cbeesokxX1HtedECa0vQUfWdqQelcTpWc3PVQfOwPcYv53QDNGE37k76zEPu/QwoQ
         RH3naQ9V/mJMCCJVQ5iINHHRvH4liIWEtA5AtWzLeGM3nIQpiSIkqSbMESYxtt6ZcEAk
         aq9buLOwkAArF+KBQpilppkbFIjyn8od3/VidHBNG7ZB1DZkc+7Y35JzgBPVimEW4GtI
         zQDQqT47aMBLmW0MK9v4JHqc3zVLa4DcLHSoUHp5/L02jwglT26714936J+r5u5NrfrS
         sm2LR/IH3InJqE4EKwayzdx+UCrST9D1ye1toXDElgKnFVNQroytzZ4EAZThe82lpniB
         a5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043071; x=1748647871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vc5iaoQdMCELnH2bjQjNG3ycmxby9Jwfat7xnJ+cIE=;
        b=wS8/R2Q53SSA704Pw/V+ZBw0Yyjozlsxjso503aDxyZuEDoKsy29WpVUXe02JxS4q4
         3y+7KsbxCI8tRnHNmhiNp9eygpiF3f6ic5wNy2bBFp8lulXLKuX3gL2Qt17kQfnXpCRw
         KV27nZnrzBk0TK3UAZNJNcAMsU/GVLGekLhDs7Db7tBzpyMR6IIWtvn/KlgKXdNYBf0n
         vVZLTjI1WAbSGGDWL/D953qfoSCW+GaYHBCNc9yQLltGk0IQ3iVkp42+0yCrBiaNyAS6
         b1ZN3037Hy8BIfEs/k1L/PjmB86oIc68gYubOxiaVnxYuJIoTFC2/q2bDWvE1aYq8x+u
         CwPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCRxP5F2Qoq3hKWHrtioSYTXraaZYjuQIM+HA+zGE4fZRrftN91QtiMWZQ6b7wB/AIohA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuORvbSMnriwIRGFZVSNJOFwj0egY46H4dFLXPL0fBg+SZch/k
	ZL699to1TDfwhw70L0SURYng4uixKs1JFi03HOraCT5UqOk3adLcqS5cQtTZCsLr1BNISTbojg5
	giKoQXBIpHsOCVQ==
X-Google-Smtp-Source: AGHT+IENl5MZx9Ed61vrQtEhT0u+T8Rn2almAe9O4wV7zO3WdxHu48H2yMXx6eyRV4vIc9HaVDD+Ouk3nTGwEw==
X-Received: from pfbjw32.prod.google.com ([2002:a05:6a00:92a0:b0:740:4dd9:9ebf])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9185:b0:215:e1cc:6356 with SMTP id adf61e73a8af0-2188c2677f4mr1813659637.13.1748043070879;
 Fri, 23 May 2025 16:31:10 -0700 (PDT)
Date: Fri, 23 May 2025 23:30:14 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-30-dmatlack@google.com>
Subject: [RFC PATCH 29/33] vfio: selftests: Make iommufd the default iommu_mode
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that VFIO selftests support iommufd, make it the default mode.
IOMMUFD is the successor to VFIO_TYPE1{,v2}_IOMMU and all new features
are being added there, so it's a slightly better fit as the default
mode.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index d996e012a646..d3c3958136cc 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -432,7 +432,7 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 	},
 };
 
-const char *default_iommu_mode = "vfio_type1_iommu";
+const char *default_iommu_mode = "iommufd";
 
 void iommu_mode_help(const char *flag)
 {
-- 
2.49.0.1151.ga128411c76-goog


