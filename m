Return-Path: <kvm+bounces-59380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A9CBB26E4
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EADEC32112E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B1F25C80E;
	Thu,  2 Oct 2025 03:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zH36A2C2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF821E9B0B
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375698; cv=none; b=fhdPibyJJ4oivLl7z+BN6ZaVBOH4AgLe5WT5NLO29m4H5TsTmhA+2PRxaH4BJ3RB1giLp/ZFxtAUE7gN/jvmdK9TXCzowkxQkKQvf2i9vpwGibCnBwt7/ARUcdV2LsdVVz57Ekz6tO4PBVAOrunjbr6ICQkkVZY+Z++d3BQMeGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375698; c=relaxed/simple;
	bh=hQufVHl47M1IwcCzm691eDQqDWsbNzmVx47oLcWiD+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nzlUDgP/5NdVYSVbZPdqXc2g2xCkfpNXeMbpYuZ5F/WnsczBNVASBSMjm62FACVWrQgg8ukm3wdDy2AIui1m9PY54Xd5K7OQX5SRh7kHZ429ZLnKq0XUqcHwFfBPhed6heL6Veicn1Jtz4pGZHnVNd/0Iz04KPAvbGCqC2PxTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zH36A2C2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so5746205e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375694; x=1759980494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UfjQR4Y9f8csqu3NmyR/zKukxoGk0bM2pEElqqrIVXw=;
        b=zH36A2C21nV+e7SOWwl4pIDd2FEWCCOHdEyjRS890Ev8B4/TPQHWAki1H4xBIJHl+v
         6CLWvy4c2jIzmEadS0/IfpdM0i8iVNytqWAZkl5Qfa3Tyjvx+rZoss56LykqV0f3Gdni
         roOy42QcPZUW5YDly7KjGMm0l6XYT2jCudvb7JLPy5HYxZMLGtMP52J1u89It7tqpY/4
         ySgn6FLj7vlE+ynsStXYSNgwtSBE3JlpG0YUVBCSKeYXtLneOXXG59IJZTPgJhYuoCt3
         3u/6bmsx70Oa1esYQqle08CMkQLUCI+e/qQDpnNVmmcZTEfQgWggwiaWWQQbT7+96gOv
         kSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375694; x=1759980494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfjQR4Y9f8csqu3NmyR/zKukxoGk0bM2pEElqqrIVXw=;
        b=Sup8EZ+3B2LM8zFMW5aJ9jnSay02cfB24+HmHIsW+2y9/TRFngkm+aI44gLPrHsRXT
         MNT21aRoKDGXt64sve9JTO2x8J3vDQ9sDN8qCm9oyA5t463ikUlf01HQW6sOTLDwn82q
         YVXvTn7dDRqTCuFn+Q3TEV/REJL9KSGJy1rViwubI2x6XGtdVd2VBZmGVt/ZYcMy2iUE
         zPTqjL+XEiFHPVXTtDFQaTwLBSZx9Ax/DHz2NUb/fJ3rn98Q1lBQUk0NYLBsD9VLjjEd
         M1M0lz6nHPfsZpeRK2OO3E0o0Zvb6TbPFlpsukE6Fi7snzNMnanWbZcfy9e1kXbanLY9
         cuHA==
X-Forwarded-Encrypted: i=1; AJvYcCVexfXOq10jVbMS0l+Uo0nAVLN9M3dIp0nzfnC0oR4jOa6UJFiCH63fNn5POnUw71bZF+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAs3IJ+wlQ5tD2se8zvdRa/aeuLCKio2p7Av3oyU+xI6/Pb1cb
	J618JrjP1AyY8NslMFYqwrrU3PdMJWdw2AMaBUySQylNiEmCKUoJGrzGgxC13bBXVFM=
X-Gm-Gg: ASbGncsxK9hZ5MhT8Gy0B1iahrTVHoHXKrkDJ7uzSMT7GizUB7jY3QDElrWT+Vxasve
	7dMgf7ksgrrt/68ldCo7EdBpI7PEQmj3iZ1fruxpagAcVLjLQ9VSVVUqdjt1Ql8XxFa8UU91SmN
	FlBRxjjooBJuNw8aKCE9ZsXsr19CcRdtZCMO9xV2xjVLBzttsWt+xPmspRLWPnpqo2fMMrMsElj
	w+dT+q2Bkj/H23GDuTzGo3JjQUV1lhZH9iaaTUsiZvfkqQxWUVoCS3N6ElHUYyoSmMeODGe2DGk
	A6+mF8UGjVY2GzlAqZe9QMfbZNhdYiwO6qiIyzZTziYa3haarDCWsKrmhZi7rv4Gyo57mteVsdr
	mLQpsPatWyDiH/lQ9hlVe+9wUp21cuCqlH8JSYR1Tsa5EtllZi8BOQBFnvh5xO4izL5zcDWGlMj
	NPPor3L35qMZCivRikP4PN3d/neMxn6w==
X-Google-Smtp-Source: AGHT+IFaMeJH4C+jU1Rs3DrDDuKPH9/s2q9KQI8i51a4A4KvYP56ZA1zsf3emLdnKFGZoWVu/kjBxQ==
X-Received: by 2002:a05:600c:64c5:b0:46e:1d8d:cfb6 with SMTP id 5b1f17b1804b1-46e612bc80dmr40792425e9.19.1759375694501;
        Wed, 01 Oct 2025 20:28:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693c9ca3sm14710065e9.22.2025.10.01.20.28.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v3 0/5] system/ramblock: Sanitize header
Date: Thu,  2 Oct 2025 05:28:07 +0200
Message-ID: <20251002032812.26069-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

(series fully reviewed, I plan to merge via my tree)

Usual API cleanups, here focusing on RAMBlock API:
move few prototypes out of "exec/cpu-common.h" and
"system/ram_addr.h" to "system/ramblock.h".

v2:
- Do not use ram_addr_t for offsets (rth)
v3:
- Updated subject & squashed (rth)

Philippe Mathieu-Daudé (5):
  system/ramblock: Remove obsolete comment
  system/ramblock: Move ram_block_is_pmem() declaration
  system/ramblock: Move ram_block_discard_*_range() declarations
  system/ramblock: Rename @start -> @offset in ram_block_discard_range()
  system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"

 include/exec/cpu-common.h                 |  3 ---
 include/system/ram_addr.h                 | 13 ---------
 include/system/ramblock.h                 | 27 +++++++++++++++----
 accel/kvm/kvm-all.c                       |  1 +
 hw/hyperv/hv-balloon-our_range_memslots.c |  1 +
 hw/virtio/virtio-balloon.c                |  1 +
 hw/virtio/virtio-mem.c                    |  1 +
 migration/ram.c                           |  3 ++-
 system/physmem.c                          | 33 ++++++++++++-----------
 9 files changed, 45 insertions(+), 38 deletions(-)

-- 
2.51.0


