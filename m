Return-Path: <kvm+bounces-52111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D56B01770
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95B3C7B6620
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7ED263F59;
	Fri, 11 Jul 2025 09:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="QXKkbxeT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7182609D9
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 09:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225291; cv=none; b=ORKIH1OJiGSTITUFrQpU2JR+D8UUHgmxzf3CqWlN3K9s5tpzYT+jw2s/lZk29Cxioe76CHW0C4i/PpOVXXkl3CH+L/f+r52sVOIAjw3ZWBQkjA5XMQL+vlEQf6cl7zNDgyB03HNqX8JOMLz8XdHh1AzOa5FyUzZMgJvYLq4xlms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225291; c=relaxed/simple;
	bh=YiGM+eWaL1Pq7qpvJ5Fe41OGM/+fILUgdHVIG1rOU3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTYQXxazfMVXJS7IjpG+9s0zCvSB6jnvaMyZHVZpphupgGMpXWNP0p9+sLm9h8lse3+NFO84uzkvQ4QRXehAnryMFdJfQSwAHzSC5Q68QY/8ebhVDxa8Y8doJzIzkiEemAqnWOtj8A5py/52PVLNJw+Dr3Fqhimn97sYUIkMS0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=QXKkbxeT; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45348bff79fso22599275e9.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 02:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1752225288; x=1752830088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhtRI1f/a1flCt8+EMDpksM80J7hCvgwFMfD1LxsbdQ=;
        b=QXKkbxeTmII5+czkMLOkmNBniUz0YHZfIuXajivribSLQwn/Wo5lwVhd4JXKXSAYXl
         zWv03AEFUaFQL0HHXQhtRTZiD6Z5IEEVb1XtytVnjcH0GDBAL1JsthJqtshgCmnSxexo
         kV89ZjLBJYyCWpTJmMPq0nviyG5MVEs2ByuNwP0fkc/C168+6/wZicqR5Zwgh2zhg6q3
         eZFMjFuRnLwORtVy+xSJUNNE0kBY7i7S2tUVg9aFrGGY1TydiE/2cgLcfydcJ5sa9Wks
         mJe5KZszo7eNCMTDgB8V6W0RMMR/A6ZqtrQI1wXz+WUs+7/vU6wyUkInZCbFRLkanTaG
         sreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752225288; x=1752830088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhtRI1f/a1flCt8+EMDpksM80J7hCvgwFMfD1LxsbdQ=;
        b=fLUjNs7iI03KRleKEl4Peme495kLBmorSIxr8EQIeu8TskiO93xucD3O92OBI9VxtF
         NZAgQE38vrk4a6G6aXdu4VBGIzjS6LJnUlpyvVL6plTkHTgKLoyLjOOibYKNUkNC20vs
         xU+MxiTPSGVkT5MejxYP3BvJ1KqYm14cUunYdZzyevv/kfeIRLm0b5IiUZNdFWpEJw9/
         pnEDc+Jqewf9gJF3cl2bs0W/WQml/kWh5QxdbOOrVP8WPtZ+PVy3X5Qf4/ggoWb4Oiaq
         28NW2l3ue/2jBfy4ZpO90GaUFna+mVCTmqR2ia4CqbzH/MCTK5GNMRTshBN+oIbBJBIn
         9uqg==
X-Forwarded-Encrypted: i=1; AJvYcCVL6MsmNUVCpbNAfvL9BU7XRrwaSxzStWjGEFV/JN3IyY9dvmo7pt9C5RUj2JoqZWMWCeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZVZPYwAGe4g+ZNS5AmgHWL7SQ8rrt4RN6jNGYPTsc2JTvHeQG
	k7/tWnEbyzvz5UUbXyp2aGEWHMlMKVz5YSyldH+5ZCWJgcZdWMsMJfxRAtONH9B9n1ug+bmBwbz
	AqzKH
X-Gm-Gg: ASbGncvVpkZeb+WK7paBVtgNRqnb2OYZ6qQqW/Sp5MjYQnVq7OS/YXeiAl/n3a0rbHT
	Jd9VuiU4yTBogqcKhP/H5LPlE3wFZ03RNM1melsPgbeKbnovolTJ00AYa1il4LQ8E/uc5gkfn+0
	yRqu9GwGYk+MSAX1Mma7nbRClUxOZHrGiINpq5grAhYcauIxFJtOwkpwMI91V3E681Dw+KcMJac
	ErHhbrOtKT9ASTXhdweHUW44vsY2kJ2NvxBB5lSHi1CYCgPe1xopBSar41AiXKcMjYVxMeNBV3l
	bNv1G7bZCeHgKeX8J97aCGGAUUiUEKt4a5vPuiRn6CEo9N/4NCEAClAJEqRU2+kpeTdj1Sp8LGc
	YGjhfqrzAX/KegeEuxZmpuxOYB8gh/1KYOOpDsIz6ZelVL7Mm6EamX5bbYBWCHQQSjed9BAtJuq
	9EsEb3u8b6/x4osjUY
X-Google-Smtp-Source: AGHT+IGVxicAekVxCsmGrAzzA4fEL2lnSmGHi1AeVLunOlrothi1FTgAQBiicViqaalvV/JSJpd7nA==
X-Received: by 2002:a05:600c:4fc7:b0:443:48:66d2 with SMTP id 5b1f17b1804b1-454f425864cmr23478535e9.16.1752225287665;
        Fri, 11 Jul 2025 02:14:47 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5061a91sm80965275e9.17.2025.07.11.02.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 02:14:47 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 1/2] scripts: Fix typo for multi-line params match
Date: Fri, 11 Jul 2025 11:14:37 +0200
Message-ID: <20250711091438.17027-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250711091438.17027-1-minipli@grsecurity.net>
References: <20250711091438.17027-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to 'vmm_default_opts' for a multi-line parameter contains a
typo, leading to an undefined function to be called.

Fix that.

Fixes: 6eb072c22598 ("scripts: Add default arguments for kvmtool")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 scripts/common.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 283fb30f5533..315c41537f64 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -53,7 +53,7 @@ function for_each_unittest()
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
 			test_args="$(vmm_optname_args) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^$params_name\ *=\ *'"""'(.*)$ ]]; then
-			opts="$(vmm_defaults_opts) ${BASH_REMATCH[1]}$'\n'"
+			opts="$(vmm_default_opts) ${BASH_REMATCH[1]}$'\n'"
 			while read -r -u $fd; do
 				#escape backslash newline, but not double backslash
 				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
-- 
2.47.2


