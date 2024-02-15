Return-Path: <kvm+bounces-8768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B19188565C3
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3C751C23D26
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D51131E35;
	Thu, 15 Feb 2024 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="by3WlXYQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B59A131E30
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708006847; cv=none; b=hHvcbIuyM4K0KB+R/TYPIAttvwAGVtUlY9TZ+WTzK04U5usMttAPvyjIs0M986q8+Ube43z5DfbZLPk796x3kFW1yrGiUoSIj/goo5lCLtwE/Ho4oQudg6WWjkI/+qwyCNYifKymWkOhj8wPZd2MegttNu7J7WCHXvZqunxe+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708006847; c=relaxed/simple;
	bh=xHRMWJ8U4kbvMXSdNn6Zps6Lxpkqp7ZuqexgMReFnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqQp80bn63wP/9Z1GTIRb5n7NOfpXb8OC1wgqmmbIiHY5i3CEU28HoebC4v9Mr4cGOFiYES8zkCdgn0SlF8JCHt2bw5KOOuIK8aDxDSo53KMDZayGKjZ3Owkpxc513xD/JwihQDjzZdS95+RH/55iomVRZATgj/ghKEnCXinGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=by3WlXYQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4122a8566e4so2380335e9.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 06:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708006843; x=1708611643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nHBcC1vTxuWuhw1KTr8iuMLr3JCNHYJX8skgFi1VDE=;
        b=by3WlXYQuWqrO3poTGUh9Yiyf+2d8Cx01UNl/897ZHyywPGOP/wBzhuN0p/nvByHEj
         iYM6wYv81KpcebEEhQchB4jwY4gQ81HYBoN/FTORWzTagjGL6KNaAVhTCfSot8UYdjO/
         Uo7HlrZfwoCKM0uaR4RrtgpYGt37+pttbwZ3n78MyRbaptbpSIGJTWaY4zW8g3VpzJuJ
         EiD9kiOvXAPaIoboQ7XE9GFhVGIsIwc4yLqkOWKBm9iIGAYpA9NW8mw3Ua+rgX/p1MIx
         kNnQ9Uti/kH+YbAA7MVXQay+Tr4ERVN57ol4eRwrkvJkhEQb13uGfVR3vy5Wny02Jgmz
         hMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708006843; x=1708611643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3nHBcC1vTxuWuhw1KTr8iuMLr3JCNHYJX8skgFi1VDE=;
        b=q/FhuilWcyQPGRHQpnVMytmPiY4HcFvastdTD64jktHXtEMaCGmkILGUd51WYt5sPA
         vhNSmYNRuoFaYny9Lt8yOGFlXjS1a5Db69UnPlNvNiKqtpYqhuRIZKP6Wfg38QrZ8v00
         /wPuz2HLLkg4C+OT6XUTph6QsydlJuKWAx9OJ+PtqHc8zx7YKovZ/MK7YAMrO+3nfW1s
         knO+GNPrgJ4KRDRbZedH3GybyGNM8ZATxv1asMuhqSpAOjmVR293RCj+p50BwWF8O49+
         6Zf8riPCwdXLqbsZIxTYzXOGAwNPe+xFcAez/+HV2KTkTRqVeVBeRTQa57tuD2AVFdu7
         Izwg==
X-Forwarded-Encrypted: i=1; AJvYcCWjbl1iZyK2tHExjkRmpi+Ed0Z+vfpbRNu8ZF1qOAPo3skKYZ2ZZONAVC3U+/jCqqXgBVm+/nVSoDsNYidW44i7EAWH
X-Gm-Message-State: AOJu0Yyn+NYXeieg7O6J14/86czaAAs/aKux6hj6Df0seUsIQbeHRP7I
	o35XJmAV/ILbkP+jGHSjKw9eJf3B7h2dgQfQeFimY9noGZqOE/nIauLd/1DjOxaYQDCg29mhsfx
	IKBs=
X-Google-Smtp-Source: AGHT+IGYTlTqE8oJnVvdqEH05RJIW0vLAV8SwKPHsQTNe656NKaFZ1cePEGe5vdZtMaDKsmuuMyucg==
X-Received: by 2002:a05:600c:3caa:b0:411:d7de:ea8e with SMTP id bg42-20020a05600c3caa00b00411d7deea8emr1310715wmb.23.1708006843679;
        Thu, 15 Feb 2024 06:20:43 -0800 (PST)
Received: from m1x-phil.lan ([176.187.193.50])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b00411c3c2fc55sm2159883wmp.45.2024.02.15.06.20.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Feb 2024 06:20:43 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 1/3] MAINTAINERS: Cover hw/i386/kvm/ in 'X86 KVM CPUs' section
Date: Thu, 15 Feb 2024 15:20:33 +0100
Message-ID: <20240215142035.73331-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240215142035.73331-1-philmd@linaro.org>
References: <20240215142035.73331-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a24c2b51b6..b526a08015 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -490,6 +490,7 @@ L: kvm@vger.kernel.org
 S: Supported
 F: docs/system/i386/amd-memory-encryption.rst
 F: docs/system/i386/sgx.rst
+F: hw/i386/kvm/
 F: target/i386/kvm/
 F: target/i386/sev*
 F: scripts/kvm/vmxcap
-- 
2.41.0


