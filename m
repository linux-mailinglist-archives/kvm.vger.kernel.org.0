Return-Path: <kvm+bounces-31892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566B89C954B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 23:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED2F1B262A2
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 22:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9317C1B140D;
	Thu, 14 Nov 2024 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWldz69k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291701AF0B8;
	Thu, 14 Nov 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731623923; cv=none; b=vFDLkso/BsENPjeK9T43wKPYDjHxINxL8/B1l69vtw88AV3IwIMLe4Ihj9itMM0PsN1WKam8g3tiaeZyVdZ+8Z5+MiZR7ugZ0DLi9sIq89zlvgkKJ4ZwtcKqS+mZNDfcIWpgbRMGvT+cn+uis5RoFSjj0D5n7gH+KwIKoS7jFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731623923; c=relaxed/simple;
	bh=jfwKPCpopufFWD9Ev3ygbtRCRNmWNcPHigANsmnFEJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f02jWzA6se8avC/Mcio1k/WvbSjyTqfmwdMvJ102rqQfVncp+RJVVxheygDDMT4Qcml34iVWFkRtyoWmQXCMSPPblF0pS3USoAHQJL0s+NQwqkQiFTJhDDtA7MZ+lmiEcdLTbS0rICX9ulf+ETDCVvtdYiSTilnhPtaawgaRtGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWldz69k; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9454f3bfaso1568397a12.2;
        Thu, 14 Nov 2024 14:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731623920; x=1732228720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ewOjEm+zXLMRvqgvZxyNTNKpEsApVZXLnwUj0o7UGzQ=;
        b=jWldz69kawWEpHf8mwTCr7qdmEEVL7zn+l0IRrt8DX3wbtTXu/t99X5WTiqoZ4Eo0Z
         1cqwzJWEPrnJGrjbcfzMqSN1V8aEdHW/bEZETMvT813wJ/GEbwf/MgPlSxwZe/gKyey2
         PFRZUgDyUdLui+Imjdl9zTu5P1RHn2aTf9xCfg1BMexY+WNbkFpq3V22TpmHH9/bWeYS
         +Rnnwtp/Idgzq+UazbiRp/zyiwj8Hh4O9sS4e6BV3WzUEAcTcX+9wudxDqmNJVWYKdCF
         KJVXJjpeETXfo0aDRN9WGfpdd7IXtO6EqrAOtbVzLuKm9rO3c/X20Iz0e/mTCezdkIKp
         z9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731623920; x=1732228720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewOjEm+zXLMRvqgvZxyNTNKpEsApVZXLnwUj0o7UGzQ=;
        b=YHLot95AqF8fvEnlIsbhcu3HO9llpIjY4Uewb1ub4UnoojVis6aZ4xlVu9yXo1bTaI
         T+raajHToqtsvaDQ4AScWcDe0kt/hWiaL1J8yiulXmD+0wPNNwvYUOgQpgXmQRM5JGWv
         srdUEKrubzQXFtY+zaQhIjVw/r0ELGIMBRnc5qIzREyeY6zJ2stqMLZNgh2WDEMIk/Ca
         tF2mPq/UiIYcU8Q8Ot5R09sQcswKCB2tf6to9poRxLuoiWEPeKOwp4ARY2MaNrN8kP2b
         4bJSCNRT0MiJ49Xj2Mt4N2yYEhtJ4Pkvp7hLi+a/MDjO6wk5jaa5K1Ibg1OqMlcrPgLJ
         BKow==
X-Forwarded-Encrypted: i=1; AJvYcCVnZPjrzC7CN/WRNuh0/mXa6qg5SPtjAF+eF0ZMUe/n8m8X3EhtDKaNab67CacICg98hPnizUTqv1w=@vger.kernel.org, AJvYcCVypzyaWDA52sCoA458HXcmq76leFw0sJu69Ge2LPvbLqpgToXi8z+lvMrTxA+XZPduFRv4Yu4gWLkDV6ml@vger.kernel.org
X-Gm-Message-State: AOJu0YzRTmRiCREtTJtVk2EfoQnDRVwxK4JKELnuJFm72FYplL2etCbB
	vwnAfpV/SB0r7KVtHrkzo/MgfiFSxmUmO3/dNZg9QT3qWYMJyFYd
X-Google-Smtp-Source: AGHT+IHFp8ClbEAINV6q1F57vi2kkXRAdo4AFZETAWImh3SRNRycGOhRYHL11/0OHbjk1OBVKlcmnQ==
X-Received: by 2002:a50:9346:0:b0:5ce:fa13:2668 with SMTP id 4fb4d7f45d1cf-5cf8fcfbf47mr172321a12.27.1731623920093;
        Thu, 14 Nov 2024 14:38:40 -0800 (PST)
Received: from gi4n-KLVL-WXX9.. ([2a01:e11:5400:7400:513e:a5ce:5482:f40e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf79ba0997sm955320a12.35.2024.11.14.14.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 14:38:39 -0800 (PST)
From: Gianfranco Trad <gianf.trad@gmail.com>
To: corbet@lwn.net,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gianfranco Trad <gianf.trad@gmail.com>
Subject: [PATCH] Documentation: kvm: fix tipo in api.rst
Date: Thu, 14 Nov 2024 23:37:40 +0100
Message-ID: <20241114223738.290924-3-gianf.trad@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix minor typo in api.rst where the word physical was misspelled
as physcial.

Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index edc070c6e19b..4ed8f222478a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5574,7 +5574,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
   in guest physical address space. This attribute should be used in
   preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
   unnecessary invalidation of an internal cache when the page is
-  re-mapped in guest physcial address space.
+  re-mapped in guest physical address space.
 
   Setting the hva to zero will disable the shared_info page.
 
-- 
2.43.0


