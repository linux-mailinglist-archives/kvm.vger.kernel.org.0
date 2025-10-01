Return-Path: <kvm+bounces-59328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBC5BB1465
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F5B2A0363
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06372287273;
	Wed,  1 Oct 2025 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KaD2TjU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C43325484B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337102; cv=none; b=K2OtDA4j9JVgesO9l0wbLnZLK6wHuzkzfloFfuWlnQSrpUiutGW4us5KcoGH1d754c7ioDiTCNY4c60f9eyI1vrewBdzrEVPSTPoQO6OrB2hm6t8lJj8Sm0yj8xqpsL8OjCyU6QpuZPmdlfefBfP43CKy7k6qEI8OwMlGrHKIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337102; c=relaxed/simple;
	bh=n2atzHTMT+2cbmOqJuot+6k6uHUNUxmR9x/Xp3x1GLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jdg3r/175iksWc76Dv8TuuKSZ3cefZxoC+zo9c5LxS/lzHRKf7F9aMQRsjV5kXSYc9LAT62C6o+ub7Agy3pbHW3ySMlyXkkgnmffdNuKYCAgF+3h+qH4zESkB3RzjJdFkEvP1LKt6jE3fP2K93SjLMsfr8zxsnkpX/2q+t+A5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KaD2TjU0; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42557c5cedcso14746f8f.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337098; x=1759941898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tPaV+VFWxQXUIKu08GdGOFPhuZfOnUHddrLWV+7K1Lw=;
        b=KaD2TjU0mVtOHL0ojzz4a7dmvGunLrrhm+MXO1S8oOkm1dSuuOFHNYJFIJtVRHo8Ik
         cz9e12Y9pwWEE1S7Aru40zzNHvtIk6UAM9I5boo+nslVOeoM7bHXE21peA8/FZSu4eAg
         R0iv/u4S1hjoXnKJCXHBoc0Fe1XhSgDwZkxZwQ9FQQyCHbPt4zOmJ6Db0OZpP2uBiTPW
         7I5mqjv9rR06JSJMBg9aIyQEKuEfn9PqUzWRPItxiAALTt7R13197mBIol323Wy3sZ3t
         8vU8q+N8591Xz2qBbY6R8ZVvd98K/vvHjZB+Hto1PfP8x31c0UQ2iPxfPJhSrz1v3ikh
         OICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337098; x=1759941898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tPaV+VFWxQXUIKu08GdGOFPhuZfOnUHddrLWV+7K1Lw=;
        b=KAgm+go/nW7DS7qHJxzihR+hq0cYwbjR8fflPuG92aq1Co+8LXYbGBy+b2otLp50wH
         8Pot54W355STdmQAjkYDiOqB1o9P3uBZ4ZmyoZDkVQrwQHQlbLMEUtHe5KJMa8W7oK8i
         yPmtEvk+RYdIenLNXpbxzfX0v6DXqoDUO/EA+Su/V/8QUWueirV9eik4UGgY4n0Dp82r
         6/JPryHH48fG6btnISUc6p1ANqNrYbHO7hHYcIer9cEX4qL0ofq2WtfyvfVNu4kCJy9A
         S3HVmXo8aA9XQml92Np1eoNOfTIsFK7vcoMNsxTCdjWNXgCFl2Pob8yQzE9L8KFbw8ON
         Vz/A==
X-Forwarded-Encrypted: i=1; AJvYcCVXC2puHP6OurxLUH4zmdb+02sLMynV+lqkbOzXmYHydbJBKuylIlr5dCVJ0GH95ZhSdeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqpJyjaUB4vki81rEdc2gyhfEiA4h3iSA9HMBTyqfoHUCnpbFV
	bobbTNmKyUNoXbBaiIjlj92fyexTJAEqYaV1dXdJb4owoZRBmg3RcDGSbGr66dBPsto=
X-Gm-Gg: ASbGncspdpAovOGP/VLYwL1uIridHpcP8RzuYSyUjW8Gjt8Ra0qNGuXfx2D4wobRcO1
	zrgnnESXpfgt/NUV2Lor9yVhMbOh8c2P3WbD1EPelry6x5t50lmZKDLbXSlHQrIwNFt73CQqP+z
	GEsGkkAAlkUqv26afDWyZj/cP8bzNGalw7dQ1ntEul+hNzJLtoiH0IZB1B5FVgf7ipveMTEaBu1
	8aQ0jOrI67nT00gMCE5v3/6uIXh5sFT8KWlJZIP/15zTyEWuRRUBhS6Xbm0u9qc3B8ODp3IMYsX
	7Hy/CLhKsYTeygC8612ZwyIYE8E5XDK8As78wnakbiSxGIGDslIXOCpux2ejpIsBWT+dzWB2ZAW
	Ffur3nFXQ7xejBIvZLSMIulIpJDcoiw2XEQPVU2uYsk9Fuss2a867Us/QdDodIl5TwR5Md+8BGJ
	w3je/XjVW7zmj8WunPdTQQ
X-Google-Smtp-Source: AGHT+IEkbIsBMTIstQ0lP9y8hSs1E0dcxoBKUVnIcQD9/CDQ0YIod8B2npgW5sGEVlTBXLntX/axNQ==
X-Received: by 2002:a05:6000:24c8:b0:3f9:1571:fdea with SMTP id ffacd0b85a97d-4255781b8d0mr3521580f8f.44.1759337098555;
        Wed, 01 Oct 2025 09:44:58 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6cf3835sm27970896f8f.46.2025.10.01.09.44.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:44:58 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 0/6] system/ramblock: Sanitize header
Date: Wed,  1 Oct 2025 18:44:50 +0200
Message-ID: <20251001164456.3230-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Usual API cleanups, here focusing on RAMBlock API:
move few prototypes out of "exec/cpu-common.h" and
"system/ram_addr.h" to "system/ramblock.h".

v2:
- Do not use ram_addr_t for offsets (rth)

Philippe Mathieu-Daudé (6):
  system/ramblock: Remove obsolete comment
  system/ramblock: Move ram_block_is_pmem() declaration
  system/ramblock: Move ram_block_discard_*_range() declarations
  system/ramblock: Use ram_addr_t in ram_block_discard_guest_memfd_range
  system/ramblock: Use ram_addr_t in ram_block_discard_range()
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


