Return-Path: <kvm+bounces-44242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77FDA9BC82
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 03:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 135427B16C0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5193D1494DF;
	Fri, 25 Apr 2025 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEHFugIi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905348F6F;
	Fri, 25 Apr 2025 01:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745545927; cv=none; b=p/WICWrKVIpQ9BjasetYvzmffJNdVpcRXO9VwjmGH25TImUE+u62HvfhRM71UOiLkBMTdOtNN2roZ/iMs4kdkdwd49xQ1Z7oivleRG7dS9mCU4aKcyxJ6NYt2OKlYCUdFZgXrLPt4LWW4/CDJMlJNBAgaiozXwr3FE3Aa1WwCUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745545927; c=relaxed/simple;
	bh=V2GhYtX/RAS91BKlbdzL3AXQN9zpMr6bs1eXTIMeWB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bpA8LkWgi3q2+tRhcZoJYVGOz526VlSgGmkwU0pD1dpQGx3glrIh5DhfVyP0Yv0vkrsBF0MkHcNIqk3m3M5D1Kbdm16wki3BUuXMTfwsBEUxIHt/NgLvrKyrVD+Pz4QYqoSARc59aGMpWJO/yOpF3flo+An30qqWFWF4omlTZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEHFugIi; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fd89d036so21938965ad.1;
        Thu, 24 Apr 2025 18:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745545925; x=1746150725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bzcb9l6jnlJVTTrhjniisis7ocrOwZboyax9flKlwKg=;
        b=SEHFugIiMVfr0+QXJGsbb3b6ZRL+ru+PxM4hIgDkMghls3uZpcQTioAEIgjmIaPcNI
         dgyk88dYoqrT0O9SIQ5uWSzeiMnBMMVXDi1lG/OcG95jnt9/DxxHPOxJ9ReWMtNlDAdk
         fDhLn20tK8WO6tY49nZ/HPUVe8TyL6Z7Rd/+z9hgXqBTgLFL6U620P86sI/jfeGm0QfR
         Lm2UPgZc7h3iToBV62sqE1mcKhsZFxY2j96WYvE/jCMezO+uIAKUDDqfrbJzwM1kVikg
         LiEomVVfFBBRxZh0QD+ow1H7p//FtmRlPF9EClMAZ9s5SFbQfM4bN6+58m2QYf1Pz6hq
         a21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745545925; x=1746150725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzcb9l6jnlJVTTrhjniisis7ocrOwZboyax9flKlwKg=;
        b=LY+u7JAsPO/ez8cMUW77gsWf/iaLW24igm4/OS0t7uQpaxpfWpYeia0bQzYyKgoKHs
         Y3+r+M6KL+owQ5dCgAEBdfCRWzUJqAIkg1k01TNZ1HAnC6Mt6acIynkwWVpU4B5PIY2V
         ngeeN6AXLR3bYDhA3q+0JnXyMFeA1nzExKwN7Kny91R2JRvVGFlfopUNZGyfagnAv0El
         TnS4VWCtejyUF4gB1AmwNqmm/baXdrH/HHfhuFx2i4l7ssvKMkIFZdjnQnq4iPW6GHPz
         tmteMsZEjZYgLQeYwUGn0Vzlt4dEK5Qmi5bwdGP9UWgPvkHt5z74/ozxaNMZZy/vpBKb
         sIfA==
X-Forwarded-Encrypted: i=1; AJvYcCU/DlMub9ADbf8B3cp/OFH2HTHKWd2SeXr1cHGWHGszPeRWdmQQRe2fVfzzFE8epejZvsaC/sEqvLKj@vger.kernel.org, AJvYcCXMvW8e877a0iDwqjnV4QztaBevKk63hW9NJaY3l4igywXfN4DWE/+LeNgME+//3nbMnMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTUW2ls/mPI1WzFJs4njiq+Yyzq89L2mPATheaNX7iUW1m/1aV
	YdCsDy+0XHxK1PsNJIEhcn8Uok47gvZpx2mpsZgkeha7BHIQ9xn3
X-Gm-Gg: ASbGncvTx/oKKdnrUQ5AHUK/P7pkl0h8YsbX2mh7hqXada0amwPnTgOsm6sU8HSQY4d
	x82RVFAZsCXuXHfUD0UTf9c+sZV2a6bxZ1RXvbFXnWG8eb86VeD65BHEI8D+Rq/L8EZhETLvOdD
	xdCcisFZh9WzR/kw1bU7ifWGUfNnBADjrQ2l5613ACAZ7aB6aGsCSlQ8NeVC4fCyAdDgtpbN62n
	JxAiOGLUcKOwpt8veupqMeDMbAjfT3P8QgGssh05CsR/GEV2P/IYTa14bNktBUAQSTTpu3jHl0c
	bvM4+wazsR2sQ/iR11bKK8jBYLHpkdZjGUQmyxyF
X-Google-Smtp-Source: AGHT+IEfZq4dl31NTgId1f0SiJaWHPLKmt6pl5/2P0FoqCAz/XiLpihi4au2UMsMmklPXxLLzVhJrg==
X-Received: by 2002:a17:903:1b6d:b0:220:f151:b668 with SMTP id d9443c01a7336-22dbf5e04ecmr6371515ad.20.1745545924562;
        Thu, 24 Apr 2025 18:52:04 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309eef7cc58sm2189596a91.0.2025.04.24.18.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 18:52:04 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 4670F424D913; Fri, 25 Apr 2025 08:52:01 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v2] Documentation/virt/kvm: Fix TDX whitepaper footnote reference
Date: Fri, 25 Apr 2025 08:51:50 +0700
Message-ID: <20250425015150.7228-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1837; i=bagasdotme@gmail.com; h=from:subject; bh=V2GhYtX/RAS91BKlbdzL3AXQN9zpMr6bs1eXTIMeWB8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBlcr1RX1oTy9mh5Hmp5a6m6NzxrYXvMHds6hYrr85+U1 Cd9fC/ZUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgIk0JjP8jzkZu8KhIGeZo2dS h3Phgkt8s3IWt1/YI62oHx76tlT0DMM/Ba5fmdOXiwfKnJNpE7p+WqHpKHeYWO651/bRgrKT6va zAgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports unreferenced footnote warning on TDX docs:

Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is not referenced. [ref.footnote]

Fix footnote reference to the TDX docs on Intel website to squash away
the warning.

Fixes: 52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250409131356.48683f58@canb.auug.org.au/
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://lore.kernel.org/r/20250410014057.14577-1-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---

Changes since v1 [1]:
  - Add Reviewed-by: tag from Binbin Wu

[1]: https://lore.kernel.org/linux-doc/20250410014057.14577-1-bagasdotme@gmail.com/

 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c68..2ab90131a6402a 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -11,7 +11,7 @@ host and physical attacks.  A CPU-attested software module called 'the TDX
 module' runs inside a new CPU isolated range to provide the functionalities to
 manage and run protected VMs, a.k.a, TDX guests or TDs.
 
-Please refer to [1] for the whitepaper, specifications and other resources.
+Please refer to [1]_ for the whitepaper, specifications and other resources.
 
 This documentation describes TDX-specific KVM ABIs.  The TDX module needs to be
 initialized before it can be used by KVM to run any TDX guests.  The host

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 
An old man doll... just what I always wanted! - Clara


