Return-Path: <kvm+bounces-40427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60E7A5721E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8EA07A4C51
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63AC257AED;
	Fri,  7 Mar 2025 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZmTqG+G1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434C25743D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376251; cv=none; b=H+oHDqPhJg9A8a+UNDqfHjOg1okHLQbwNIBEfkxcaojDFg+iujgPaY4QHO+mDBuc/MHmQfkKDzBmz3dT0qgaBaunGkIdz6dmbf1lDGN+CRKGwONANujOafGL/DXzinm9C8JkR41CY0WfC6syR0bFDmphdxKWVcJAy3FrGpLMn7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376251; c=relaxed/simple;
	bh=yY9+XTJM0pOnsUYB702ihOubwlN9+6GRoxh8d7LHLcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8uNPn5bcrHKc1neI3D6H7eTxylfCgt0jqARj8LZWVmXnHFOgWtV+X1pFSkFaiuLhewL5mAGlxE6y5JR46cu6h8rJJMlvMOoOwFavFRSSp087OjoZICoQFYkA07HUX+DY2ACxB3vgb0d+Dh8rQyfr+OMjwpk/OHNbPGEKASICKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZmTqG+G1; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-223959039f4so47898815ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376249; x=1741981049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=ZmTqG+G1euAG764dDLDyQXXEohVDMyMA9983hHHi+NMVu86NNdduNS6xOsoSgpLt73
         kiUNLxvRM9jDbLM45Ohbjr4F4G06nnDs1aFSmHFJ+lHhyA+WaNbzTFNPnlT0V4tsieT3
         QrCvtIULwMVE6YNg7f9UC57oFtahIX0K8t+JHdh0ipqVoeAJYRpukMmjtMM4GGv9Acwq
         5WQdmkHNkI3o1UdRLdjCd7FsdCdiKfrF2zkDTmWg8/pMY6+Jt9C6VrVQKa6kmq06luY2
         BSW9wb5aSPQTCvIlqZXmXTWpv/8MtbRFpWl6gVvSXplKdOFtm8vzbRg1GmOo8PjCg6O/
         +ogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376249; x=1741981049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=hxdg1HlO3BjJ3usTYdvSXqgFsFzciMrJen+ZuckfjUWQgJlylS2IXP27P2hjOdml2H
         oQpEMGSVK/KIEjjaOLHWyAU9xeoSWNIZhL4d9jsffmlLhA9ZWiS4LCsq0yQPZl9xNOci
         ZVKzdmFXZW+1OLe+JVdTKYwmxbaR+lPUK6WZ712b0+9/Pvt9rJbTsiRTERlOt/e0nVIe
         cEV4uYGMugGij8xYlJGXZ220quGhJk8UX0x+25Blb7uCdfzED173vvVhA0CUvPWmfpNO
         gZFcIYtmLzIkWYNjL0FFn0ZUqtXlV2itGz89clb3Gel46fM4er4fjHfHcrgcebUoB0Fq
         QwEw==
X-Forwarded-Encrypted: i=1; AJvYcCWDQRBxSv1hI5Lizci2YfBeR9Nd7CVCcae83iX22zzbcogqkhnKk4SIga33BM5M0XhniHM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4V5cedvP/d6VW08z1ct9KubsdVtj2j3lRuX9P6j+YGzeryj3j
	kclJoZOc1lTisqNihTHeHZ03JJDjVSVNerKJQecp7DzlkeBmkpoA4gCh/00I1mE=
X-Gm-Gg: ASbGncuZJ7mZHS+uc7XvbyTTt0mO81fOsQRH45rt7rIiPzT2Uup+seq7Tbmaoz1I3tM
	U5QDIDtX2aPLWyz84cRgFWzKvbRzwLwIyZ4R4Eq06UnBySChrJsmX5RUOQIvsxafWlWKmXxqp0v
	ZPfQb3ogTK2aulDBI0HfC7o1kN+yQTJ2W3J/qKk2OkK63yfdKkTG0IJGhx19h4NZLVsgaT9AxN/
	4kOAp0K+lDGqzYMg7KKKrrEopotSP3y3PsOLocf4q7rG11z3MY/5bwNqbZrvWCZLb/Z/UJsESTM
	p6vtZWFeQ9KAH9efYPWElHo/uWk+B65aIXJCw7xfbv+9
X-Google-Smtp-Source: AGHT+IHWCKlEFd/V+IXVDyRg9UgdcAnAKe1xUxYmKmGOcFCl5FIjv1cYNHI8vIQzpKEocH729xzagg==
X-Received: by 2002:a17:902:f786:b0:224:c47:b6c3 with SMTP id d9443c01a7336-2242887ecefmr70236325ad.6.1741376248782;
        Fri, 07 Mar 2025 11:37:28 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:28 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 7/7] hw/hyperv/hyperv_testdev: common compilation unit
Date: Fri,  7 Mar 2025 11:37:12 -0800
Message-Id: <20250307193712.261415-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index 5acd709bdd5..ef5a596c8ab 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,5 +1,5 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
-specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
+system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
-- 
2.39.5


