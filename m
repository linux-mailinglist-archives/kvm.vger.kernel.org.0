Return-Path: <kvm+bounces-40425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 03575A5721A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FEB77A4074
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7213257449;
	Fri,  7 Mar 2025 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q0vdQz8x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDCF257420
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376250; cv=none; b=QKWP2ovvqJsb9hWVLyS9J+RLoZ3aZ1BD0r+564dJ4+XtKG69u8ogxYzoBjKyJWuADG4ZaYEjBV+TMfQlSSLuefoPCP2RnebbgveIKzneRc31xjHo9S6f/ns3U0CcItRe6v4WHtSrCQRwHU1ZKFwmQ2KduXInl9tMM2nEjM2Xyrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376250; c=relaxed/simple;
	bh=yio0TGkUh6/xOEAR0qrHm9LcWB2v70X+5IB7niAjnMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J8h5von06UBnxbeh0SOJ1FJkNjHxk9ZkpUsENHuupIdC4zDbX7Yc2bO8CAqImMlIAKTVWc8F67ymI5Vcq2M/3hYjUS6DVxq80ytWWemUxsJ7v9NbJ+ewSFAdAM4phfEXpQm1Me8iY40+FfE9/l6CM4wHxshGxYuUT9Oeb9Fxtvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q0vdQz8x; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2239c066347so42625535ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376248; x=1741981048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=Q0vdQz8xFzdTnxyQtZqgMOme5OqKGF/U29++74Kmloqjy+rjmRlZVmRI4gWypDSrc+
         6eCD+M8BLzPbWPOa0dhVWDxkQ2AhE58r8dyVZQkd2ZOkX0jNhsZM3TpepXamwBVAJ2KC
         7sPN/Qya8nPpeFT8UfdfcXdbaAsJG25y0jNtjDlgbRC6G7tdQQUhFXAHVS/LzNBfWb2v
         QCttEslc1Lz+yDEJLvweiTitCcLKnLfYu3pYIvLkYXhKM262ysbnPB4N7PR0DDPuM0Zz
         F/Cb+VZ8O+Yqm8uMGBd7g5i3CA0BZP3Rh7/MkmsYar0tqIXg88XW3K96OW3ZSlgA+CQl
         J+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376248; x=1741981048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=w16onlbQZoMFNp+qf7OXCCbXOR6sjVa8CtNtr2VCb6/7aIE1ZVVUa1x65OBeCNSvDJ
         YyBPwwU9B2ihm+AtxNmh6pVbo6MPr1BLn+5q57o1OMuMmzaKUi5+SGv7PWIhiGpKdXlD
         /UlgjyY6heP2K5Swc+qOqfdEjA4T0bJyDhwICLpS8FTFXsV1sqdcJg5AUqy0BfFpRnq5
         5t6Su4mVzMorg+d3VlJMBM0sMYDpI8oumrE0xt4FiC9UNvHtFNT0ytELHpob0CHalXC7
         OR3ksEq/7jRnCfWdfMxXLndzD7wnSX0UGayQW1NwFbNyjmAok6Uy8f1An2mLuzOEs6S3
         xC+A==
X-Forwarded-Encrypted: i=1; AJvYcCXAt+/0WC+Q+7PcpUEMoY5UONyamW656PsEQ1fmfyEWMl6cCFq7HsXpxht5UUSgwhuXNIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg5joujjE8H8vOfZM5QD4eUSZFHqPil8Nd6F+UN+Tnm3ymeMrp
	8QLyVFNdP9OAfdJqU/AdNPlLXhoQYJNzN//e8sj6MW6JIffBNZyWxjmerX+uYqA=
X-Gm-Gg: ASbGncs72zv+0YMa8ZC0LuCdcyJRw/b0gDllRCCXAyHqTtngW9ilvjDgHHX9LSfjE9p
	Mv9yCvdopqLpYTuivt0PB+xthmULx9EJECbuP15s+VLzDjF7dMjzLJWPrmiXQyWxvHPkMjRoGDF
	ABgAKvbwkCnD/AvonE7M4BVznagY8CuyrY8j0ODlplobL2z8CphUYtfuya7H4q6+Vb71wGldNep
	JTkyD0Cs80reJk8H4PVc/HhSNn59Llq0LEFkaRhhWUxArje44plRmr83EnIn894yqOQprQ0v+Pc
	LOPI/MM+/qjADqV6rC5NpJkbOKs5/5qRLDwQjUA0hHk7
X-Google-Smtp-Source: AGHT+IGKXR+9X4ZONBcHhkFUf7VCkwDzjzA5G8MCEve5FuXHVvZ8UObc/5ZN1Vfg6Uhf+SHMCfpo5w==
X-Received: by 2002:a17:902:e947:b0:216:6901:d588 with SMTP id d9443c01a7336-22428896951mr76142875ad.15.1741376247903;
        Fri, 07 Mar 2025 11:37:27 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:27 -0800 (PST)
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
Subject: [PATCH v3 6/7] hw/hyperv/balloon: common balloon compilation units
Date: Fri,  7 Mar 2025 11:37:11 -0800
Message-Id: <20250307193712.261415-7-pierrick.bouvier@linaro.org>
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
index a9f2045a9af..5acd709bdd5 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,5 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


