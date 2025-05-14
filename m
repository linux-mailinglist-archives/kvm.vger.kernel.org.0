Return-Path: <kvm+bounces-46532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4AEAB7486
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 20:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37761B610EA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C481D2882A4;
	Wed, 14 May 2025 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d1aqVLQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFD02882AB
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747248109; cv=none; b=LQbTc6VqeEt3Ed3+m5uMd01yKULNBaPC+sYZrsUcSmRnZz8Ejmpy5eIxbpxVjXAuiNW12TVdf/Ub+XtgH7y8RmDSXXSClbsxKcYfbFprIRFX+GCSmH0RwBBh2xlCWuD4hWW0UtnSWshdPlRBl9SfvojvGUPZNiYlLoGzUJIWPwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747248109; c=relaxed/simple;
	bh=HFT9t8JByq0U3q9Zpp+GwOy9wwqsW3GjaGcLtLKWE5A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fpb0IzM3YE279ZMBDebO9150L+KdM3ZXPgcXgGYM+x9LEGtM2eulK/zn09x7XHgjivhcB7D+WwdLgnLYvdx5ANt21jMvyWXHXcT4CPLcvar3wGox0hdrM/w+69Ave4voagzjnsQVkxCVMkPZYo5Tb67GI7ondyVW1MPhMscs5xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d1aqVLQX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742360cec7eso126957b3a.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 11:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747248107; x=1747852907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PexG5nTtuDn9NAs1fVDQQDTrpsd+5gOlT1TA8zdSE6s=;
        b=d1aqVLQXhz8OV5UseWU8jrWXrWI+OzX0wNGJkzBadCXVJQMOqzGYvOMdLX8ylwpPZY
         mWl6e69t+oAjbvZPa3jnSk50IPAaBASnAwdjxDQ7Rl1X/mwweyKlj+6hWykAgQpX3OZZ
         Q9Tpehdxd0KHWY4dm56BksnpUzb65nps/oaKHJ07Gv3aZBI7Dbd2YFOFfn69ROba06dD
         Lc2xjPhHZ7gkii1YMlSW8P5CrwxJ5smmw9jEMaz2tWHh/wPV9FAATfms+dxziPYdxnk4
         r8KDf5ad6CWMxmFQQFLXOeP+Y4JMoE8PUNoCBW2PR+QUGBY5SNz9vVMEHN9EuxDBqzBj
         ZcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747248107; x=1747852907;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PexG5nTtuDn9NAs1fVDQQDTrpsd+5gOlT1TA8zdSE6s=;
        b=RyzDtL8m79BBXs/LHsmo/3kCqYDJ6fyq2XbgwEa5+9xuXPBiOquiSFU2tCxYHHi5Z/
         tpv0vvXWCd/fIoPA9Zp7SJYhfd/IS2nUlwWAmGVj+CN2V18K+gkji9Mzq/0d6T/HA0JS
         G6eeAkQUbDE0etl2H7xX4ZWx6cuxbuqN8QMLw7jyB8ZNmk90qYaDN+ctLKCbe5Wn2Eie
         2K1mJoVxI+4x54YLqQ3DLCS6U05CYQGDp0OAH1eQiO/5Z8bpRiPkO0UsFL4yNLwYVRHx
         4niQllRMbNdBhaumC8IjaiMXn4DGSl+x2w0QMIJdYjw+yyAKs51b8glO/LdH+36IgdF7
         BfdQ==
X-Gm-Message-State: AOJu0Yw+eAEocsgJrDEq6IejArYiz7CR1saTVUbakQjdZJklV0T2SEmi
	CzKJsDEVRVsxaaw2sJ41H/oyvXCtM7Bznl2AQlZwtH1oY/OutHydsCBmB8XPb8bxgeoRl3EXZem
	Fcf/FWOQJjAs6D81qPTpn6lpsj3Ff+43D6w9+pMciY5kjjtdBHRJ8z4imPx4MhsTyOrBmnV3Qtu
	BpWw9DAQrJy1ND6EIjEKpQZK5my5sHBZU4MgD0yFNY9w5OQ+Li3HwYBfo=
X-Google-Smtp-Source: AGHT+IFjxKk2uE6KQVjUIQ4RckpNwknNnOs9R/b6M+Y2jgf5/98sJYyk3yBx0NXwdkePosSEiDmwLxsHZaC5a889hw==
X-Received: from pfbbj12.prod.google.com ([2002:a05:6a00:318c:b0:730:76c4:7144])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2ea7:b0:73e:30af:f479 with SMTP id d2e1a72fcca58-742893490a6mr6147889b3a.19.1747248106843;
 Wed, 14 May 2025 11:41:46 -0700 (PDT)
Date: Wed, 14 May 2025 18:41:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250514184136.238446-1-dionnaglaze@google.com>
Subject: [PATCH v4 0/2] kvm: sev: Add SNP guest request throttling
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"

The GHCB specification recommends that SNP guest requests should be
rate limited. Add a command to permit the VMM to set the rate limit
on a per-VM scale.

The AMD-SP is a global resource that must be shared across VMs, so
its time should be multiplexed across VMs fairly. It is the
responsibility of the VMM to ensure all SEV-SNP VMs have a rate limit
set such that the collective set of VMs on the machine have a rate of
access that does not exceed the device's capacity.

The sev-guest device already respects the SNP_GUEST_VMM_ERR_BUSY
result code, so utilize that result to cause the guest to retry after
waiting momentarily.

Changes since v3:
  * Rebased on master, changed module parameter to mem_enc_ioctl
    command. Changed commit descriptions. Much time has passed.
Changes since v2:
  * Rebased on v7, changed "we" wording to passive voice.
Changes since v1:
  * Added missing Ccs to patches.

Dionna Glaze (2):
  kvm: sev: Add SEV-SNP guest request throttling
  kvm: sev: If ccp is busy, report busy to guest

 .../virt/kvm/x86/amd-memory-encryption.rst    | 23 ++++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  7 ++++
 arch/x86/kvm/svm/sev.c                        | 36 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        |  2 ++
 4 files changed, 68 insertions(+)

-- 
2.49.0.1045.g170613ef41-goog


