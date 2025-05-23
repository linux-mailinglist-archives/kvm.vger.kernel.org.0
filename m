Return-Path: <kvm+bounces-47626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3794BAC2C39
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81A0A1C06DA8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787D4217734;
	Fri, 23 May 2025 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z3qLNnRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0A0217701
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043044; cv=none; b=sLk1QCHZKByGG//R5m+4xe0hJL4AWGcfZwTTQnbIEzNAHZioDfruoBRyncs5Atv78PjuGF2pIUTHq0/BPvDdVmEZwDBdsIGuN+gTuhg8x3s2TkUr9pRfBF5sR/dduFfgGlZ1H5BE0gi31hPhN+KZFay9HQvcsE5jGAjTL7vRLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043044; c=relaxed/simple;
	bh=yS8geeqjAUls9UiEIvDEsZ7tIg4douCZvryUO6q26k8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rAw8m+TZB+bIzo9fLtlzxVnzuvWvJ0TDA1AEk6wC/biuqOxHeiUvChvYMRDL7VssSqcKY02NWKCY6k6SGFd5ck4B2b3Xm3tIYkYiG7OhE7gujxx1UKK12F4lrq7dUp/LM9LHc+F7eMCVM7F1Ggr5arBbe4NIoGkhyO6rmK+HS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z3qLNnRZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31104378182so559515a91.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043043; x=1748647843; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9ZBqtvM1a+IA6geHqKdkRcQxTFXplx9jl6g2ELrQv4=;
        b=z3qLNnRZTEM+KVAMEyAkFbyOhTFQXPt4trMh4jOw7SMzeX3NGLt+FCBs6SN5Fh/8Xx
         kZkxHbzFjjPlOovzLZYiFYIfbaTfP0YiXTrGTpquFHXmYZfXerz2OSgMgOsDfNaNDX+E
         q4sen513cU2iL/L2F3g00m5EOqTS3bgYZPwRyxBEsHwTP1UE7/+GgZKGDdcTBpnv3rUg
         mGdaNlan4i0UenXH1msijmD9iJkBtyVBKNCFlQN/+67wQIjNb7psdyBcRZVvGsU3k4DN
         NDsplZRJrfJ0jno+jnjK01PRKejQc8e6k+3+86N0FObh4OpIxYwF9eyXZgeAvfM7DQdm
         qQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043043; x=1748647843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I9ZBqtvM1a+IA6geHqKdkRcQxTFXplx9jl6g2ELrQv4=;
        b=jOKGZ3FbYNlXsSJmfw65G6tkmSeZsounzJxURBiv0zla9nismTYwXL6hpg7W6zIput
         D99RXnUfgnTouz9m8btIbnYSdz7xbzjiReCvKB8RE+ItyVrv1P/c3ldfU+z1DBRCNbBU
         Yf4tz+95Rbg8r5i2bJp1fnUaMW4aCjJDMkOfqSPukJq5HMgfUIfoypraYvX6yw7GYpXJ
         IKDtXN1+sxzqxpAI9kfC8jyATsRQfh1IMNEuFumMOODvVvC+eeLIkM/DAfOv2/XmDECl
         j1G/+I4yxMDsM57bvFxhalCVjmV3JusVId0frqG5p/HUB309/jW5lblDXkgF17EKuVHr
         qL+A==
X-Forwarded-Encrypted: i=1; AJvYcCUCRPV9ArxpaV2vd8Nq7miCP0e4iujNr4P3YWA7OoqclowYL6QPraY+oJQC9ssJ96k7sgA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7SfXZmItRGQ66KQcZYmwCVzqOuDO6oHJ2EL6pSNlMEm9Z5B2U
	hWYfUIusa//wLIWGfnW0WiOE7Uu7DRH7XwrIeY+jecmiifDeVPAqqdNwk+514fS3qve2kK/LhDw
	vUzfwJ8jBMy6o8w==
X-Google-Smtp-Source: AGHT+IFuhaighmM5rbtJX90BYn6ywhpqCWSktMhRSkKEnzlRxIqBZQ88WOm3xXBf6Fevs9snK/xotR61OUtxnA==
X-Received: from pjbsr13.prod.google.com ([2002:a17:90b:4e8d:b0:301:a339:b558])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48cc:b0:30e:37be:698d with SMTP id 98e67ed59e1d1-3110f72e206mr1183238a91.31.1748043042952;
 Fri, 23 May 2025 16:30:42 -0700 (PDT)
Date: Fri, 23 May 2025 23:29:54 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-10-dmatlack@google.com>
Subject: [RFC PATCH 09/33] tools headers: Add stub definition for __iomem
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

Add an empty definition for __iomem so that kernel headers that use
__iomem can be imported into tools/include/ with less modifications.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/include/linux/compiler.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 9c05a59f0184..df503ed8e038 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -116,6 +116,10 @@
 # define __force
 #endif
 
+#ifndef __iomem
+# define __iomem
+#endif
+
 #ifndef __weak
 # define __weak			__attribute__((weak))
 #endif
-- 
2.49.0.1151.ga128411c76-goog


