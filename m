Return-Path: <kvm+bounces-40962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9F9A5FC10
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F07AD189471C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FADC26A1C7;
	Thu, 13 Mar 2025 16:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LaTpj7Ox"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E4126A1AC
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883968; cv=none; b=sPBqQyFLn+od3Jf5dyyFBBFilTduBLXk9BWFRYon94PdDNYaUOXSVxQpopXXc+KUJFzN2Yk+Onez8FZFFSCz8ICRnBtjk0sOKynThRD7SvIisV0RNJUxG2JTur0JQCaJwwVyQdRh7Bf3NFCKUJn7CKBx50V0IQfgW00UYaJtOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883968; c=relaxed/simple;
	bh=CzPhR8gRelKLEDtp1LKolN6jwIOO5jPAQq57RMOd2W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDf3d8iOTOIFQtHOdGiAVVYk6KlhwF6ayEO9YaZazWXFrhGlf5285M8WfznAE9CUKn1W1j+ynXK71+UqiEA3vajjnENuKUhh8JP/2gkAGDoeuo0w0vfe+wkEYRZx7UEOy+DR2MLGnjE/+f8cmVi4+3J4soyQ2plS9uA0QwHX49g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LaTpj7Ox; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2f9b9c0088fso2395626a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883966; x=1742488766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=LaTpj7OxyfQsV0ZrnXKamGtKSvbN0XZ+UcHcwTtTFv6kRCN3gWffXwrfCwKsjZLrvK
         12TryOQ3DorU0RY4v5SMR5ScndhcCRn6MiDqJdnhZb5p5iSMRQ1hTmueqAsZjBdZfm9d
         WhdE9cMM2QroC6E4AAprhOxSz0Qw7ysiR89AMJ/+HpCr95ZWTZI6BMNP9ewRJG6DZGTC
         RIwtFvYNvaFO0HT3SQJrYBj2ww/eljZNiw+Urm41f5hrlc/1WV3PjrJVvUdIZdo3lGan
         CteZ6BJAadIZMNPbsEtAYFpy04DutqnB6ye24uLWiHnrzQx+w1Zblbe3t0y8feevaLqc
         gXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883966; x=1742488766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=KUtbHvQAo/utFwWu15jIFZpTi2X9KrzkDLK9XeUbAhpFETe25seKupk2ZN4y0kEiQq
         TjZAMFb/qlgfbs193v+TDeg9nBRybVp+bnPWx7m8iF27lUCEuwMkZSLHfzUPipoGm69F
         /xk+0lAgHM89s1dUyZQRKnPKFSqmsxz6czedyN/Y4Zo1FuzlVYjjWwTSxKXs8jLMKELI
         J6qiP9KtuKvrjLGz/x0iLy92WTzYU+MDyDv5p+Jfqy5kItKfACuQsqSJNBLSTph5kbP1
         aEjiZsaAJgt/vH7JVSJeUaUAN+PruNe8Q8X0RbZhHP9KhYgudaaGP241X7HglaFv/o4U
         4ttQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFOjv8YHtXpDJCJUYsJNj7D+tW8MRNmgPCMkgoPZAqtmk7HYGkqKCj8Nn2PoRcRT8v6ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMfxpZbJjaU+Q8DY23v9Ersd9bCalufgGrTsLNeUsEYar7mf4W
	oGnVyA9OW1dlEhvMN2EKkveBXc6GMYD948m5gZexAggTYOCypeOigAccZF5fqak=
X-Gm-Gg: ASbGncu0tGBQG7yfpdrw7SYixPywI4dhU8wioPnca+3q7r4n8BX6U80C9ZQ9macPyas
	iAmhWGGN7DefLCRfYf3eM53CRgeUhKQLGDYTQVeFRgnuae2/CaqYbYGe9JFh6ccUr7LON1+YwOW
	7DzACZx5VAyHAkTMabtnSgVmigusP65r0yw/HvksCPr/+QUfcfMDXgifkJfQ9r7IANk5/DxQemO
	mO51MrqWWW1WFVgumEyvPyV4tWFOxAQnZceBBAPoUnJ4zWBVLyeyMtBPZ0Pm3oQE7gsVnAjYwKe
	ZKDGxFrrhtubH1TxBVCYsSl456rDsq57F3515/AS2loX
X-Google-Smtp-Source: AGHT+IF4AzvOcFWztZZ2bxlYvUCRcZgJhJkixRgg9I+5NbaWKKn606UlzAb4zSHX4i3sVnz0TZr9yg==
X-Received: by 2002:a17:90b:574c:b0:2fa:30e9:2051 with SMTP id 98e67ed59e1d1-30135eab105mr4295980a91.5.1741883966469;
        Thu, 13 Mar 2025 09:39:26 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 13/17] system/physmem: compilation unit is now common to all targets
Date: Thu, 13 Mar 2025 09:38:59 -0700
Message-Id: <20250313163903.1738581-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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
 system/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/meson.build b/system/meson.build
index eec07a94513..bd82ef132e7 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -3,7 +3,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'ioport.c',
   'globals-target.c',
   'memory.c',
-  'physmem.c',
 )])
 
 system_ss.add(files(
@@ -16,6 +15,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
   'rtc.c',
-- 
2.39.5


