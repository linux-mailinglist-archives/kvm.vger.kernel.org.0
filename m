Return-Path: <kvm+bounces-41620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8961FA6B0D2
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A30E17B0DAA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B75F22D784;
	Thu, 20 Mar 2025 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y/CLqNno"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F64022D4D9
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509831; cv=none; b=k7eHRtH36uE6LH/I+QEBnDC5fmbIjJTd0Vz48TAUIkNQ5k+ULoaVojFuf3uOC5VVnRTyO14CUlmliBE3XTyz1X6QJ7zQeed1CjwY+7Du8ARDdfgyLlogthZYTT5cWfmDY3dlmtShVu+nJu7znHYjYKN5nLivFDsITBihSP0hK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509831; c=relaxed/simple;
	bh=koOePhk4+szypPcCLvagB8jF+4HgkO7+nLo/kOSwecE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DbcOKPo8vBr2ATAPon/lld6739qqAaS75h1Ll5ig0qzfHgxP70Chj+BSlX549+wflKYcvAai2bZ6MYyEWgtw7eqngbkd27Vip1uKqrFYTicDMlojYjHRBO3QSnoELb5ToC5d03rLgFccAsbbxjkiKMim1fDJjWMkd2GOq3SygEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y/CLqNno; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22548a28d0cso36159775ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509829; x=1743114629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=y/CLqNno4p0QmUF/IFO1ZPyGX46UjVimrdfm+xU/ZvarMP7mZg1Nt+f52VB75HpNkY
         FcTN0xwYGvlvP7/7SV2hnQe9SsME8SF8LMjHRooT9+UE5zdPF9KTvcD15O0KMYX63VKW
         LsZy0ksatpd+sWaQpD/4fteIsBgSZr4G4ibtyzPmgJDc+ZxbdS1gG4EKNJ441LsO0Ib1
         GwQhoG1HOLDql9naKIy2+czqRddz0PLjxb0RdY6ZPhKqEx/zBxmEskuHYfkS6NgVR9Z+
         qaLzwt43cgyGhalbYimabP463CNhtq1LjzDO5MNJOTzAIbHaQFYOsClkM52v2smKNqOH
         eRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509829; x=1743114629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=QvFDNfAfaZMldOcTyPOk2TsphXKQTxp8LeAyrNpJH34iRxZ9TkQPuBoMM82mwJ/N3l
         b8MG7TGdoiCaIOYZk3rv60z/1TsX5aZMUENnza+f+eLxN/bj85lPPxFl9NSOL5dNVEBp
         37IA7WKRVOxZ1PbWO/LVblgZgwx9eZbJTf6BKYcSwvmBT4m6obq8sdku84JSf5OgMzlm
         S3nrsOh9oeG6NWuBavCjRn9SBTd83AGDfZ/2w/1bp8UK/JBqxRuRo65WQhVaSpIu7+/z
         6q/Nd6DMiqFCDP8e9VAvqA0ggFb1g9lztMI0flN+TJ7rsa+UHK03qS+eewWN5WY2U85V
         EVnA==
X-Gm-Message-State: AOJu0YxhE1DPbjmSGHx2rOiotNNm88GjnhnwNH4OccPa/UuQkfzY5nle
	saeemcPkRDJzaG9Vuek7CyTbUY853vPLqhaPNi8sLmD128d80YPBvTkNzGqeYi0=
X-Gm-Gg: ASbGncvtNG8fpohvR0O/k8AFIgneicdyretCgevOKlQLJ6thCd0XjnwqbI14Iyt8hId
	ueFz6RsEJZvWcFEXt4pZS3t8Lv5VPM6Qb9Pak3iI2kWpde7q64lG4tgaPczQ6Sy7mJ2I7QYNsx7
	B/M5KR8ltEa/imkP5PxEpZ4m9IdtSFyUeNfW2su7RmN0VZNpDbAEJ1kqBUjKzcqh095YoDlvobe
	p+8O6d1P4By9B6IW3uiC6JEFdGdtUMGrm+rEvW25Y4TaQgwJIWaWUEbxg5qmuVi89/txxkjxdi2
	rthO0wsF7dhBaBhiOhz4gHmomZkCg+1pV8fT/JOq6/XX
X-Google-Smtp-Source: AGHT+IGVCpx0QpmCi1amSZVFcp3Lx1psopBE1QGnul4nGQtrAHd3RHBlWFA8EFnCJxNgJUKeuy/0dA==
X-Received: by 2002:a17:902:daca:b0:224:26f5:9c1e with SMTP id d9443c01a7336-22780c55312mr14787485ad.2.1742509829392;
        Thu, 20 Mar 2025 15:30:29 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 17/30] exec/target_page: runtime defintion for TARGET_PAGE_BITS_MIN
Date: Thu, 20 Mar 2025 15:29:49 -0700
Message-Id: <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We introduce later a mechanism to skip cpu definitions inclusion, so we
can detect it here, and call the correct runtime function instead.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/target_page.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/exec/target_page.h b/include/exec/target_page.h
index 8e89e5cbe6f..aeddb25c743 100644
--- a/include/exec/target_page.h
+++ b/include/exec/target_page.h
@@ -40,6 +40,9 @@ extern const TargetPageBits target_page;
 #  define TARGET_PAGE_MASK   ((TARGET_PAGE_TYPE)target_page.mask)
 # endif
 # define TARGET_PAGE_SIZE    (-(int)TARGET_PAGE_MASK)
+# ifndef TARGET_PAGE_BITS_MIN
+#  define TARGET_PAGE_BITS_MIN qemu_target_page_bits_min()
+# endif
 #else
 # define TARGET_PAGE_BITS_MIN TARGET_PAGE_BITS
 # define TARGET_PAGE_SIZE    (1 << TARGET_PAGE_BITS)
-- 
2.39.5


