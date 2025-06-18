Return-Path: <kvm+bounces-49799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD58EADE276
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 654583ABDFC
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4306121B8F2;
	Wed, 18 Jun 2025 04:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5OD17Ho"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66142185BC
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220682; cv=none; b=js5fMgzPOxaJuD0qmT3Ek/dc8D7+lM5RopCsI/QUrQJrAdRODsujDg2UkH3v7uIu0dFrWdUKmV343grcKgKAqRNntCtxzBYfJse2nRQpIktw7ExK4TRW+94zJFaU1WmYmY02b3F0IqCeUFn2sILP7pFk+JSWfp3pp2EBeIafA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220682; c=relaxed/simple;
	bh=M4cA5QCIbC4IC69I7rkdIXP2+hXIfCYUAcCljeAUiHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i6Uwvb2WVVEGCWw6rRBOdoKzxhSIn3HdswuUELCb99eKRSv6fSXQiQ0bd2agh3YvK9ZEcZvKzLx16FXKUkMqZ6DSVFsV9T7ikj/hum1IM9YVhj0SkDFqb8exia4m3HgkhkLfmgz+pRo7DiExWMBFGHFqDvyz+Wdcm72uzJY1TbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5OD17Ho; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23536f7c2d7so106268605ad.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220679; x=1750825479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EMNAB7VqggYskY7+oMW704PIZytljaHYvhJuoy4xGs=;
        b=l5OD17Horq3OM1avRrphBdfnroSlZGi9P2pMC+1CzyShVQ8woxzk40rE9G6tOo0Hcd
         G7voY+f9Iy8T2C4XHckV+Ipf6DhcHHerj0RBQjxxWKgjovOPKxMGCPdi4iYxgjnXdKsk
         9qXFh/Iy+aQ9uMOCAEPPH/ZRX2DwbiJ/r356hzeQlOx3b+ka6AbezRc2JX5HBI7p3J5Y
         XclB9pYg4ztShPeYW6prdILfWrCywDr05QdAVyzPcbO0JT9IHSK6JHEbYjQtZuFm/ivb
         VgkPP/SCtHO6/oGFEiSN2uOh5LUBieCtXMmeaEYG6RhGhZOxSncMf+zM9ypLj/fklQX+
         aN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220679; x=1750825479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EMNAB7VqggYskY7+oMW704PIZytljaHYvhJuoy4xGs=;
        b=Q0/HDYXwOQZMW9bnylwlot+bKaD3xMqyAyVUvYQR/AaBxNFj6UHWBd8lvkwFqgu5uZ
         KksHYnm4QK+/9MjdVbbnnqQbf0caVWO6f2JQFeKkPVbLigEMQFryEOrVfVunXbqlvkr7
         JGqSyQg/SdE9yJQI3xauZqAmPFNrKpGBeJ1MZ70BR7s37ohLnzuQQvgqAEPEzIVHrXux
         v6+/zoEmkwEPRTLLW6rWxu9lqag5L8y/pAG3e+kcGMyEhXKBFvC8k5jnl/px4P4lx6Qn
         zg6+iA/M6EqSfjWbx0ZKgIki0xOA9f05t4Cu2qiRgU/eUsE8UgqTCYZ/MKgKGor+NLId
         +96g==
X-Forwarded-Encrypted: i=1; AJvYcCU6xFZyWwCOEgKkqakcSmt0uV7rKrhY/Di9HDYUI3DUoqe2Mi60uOTd1tXHVg4kyv6cOkw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ+Liwjf9PEINRYYl1jdk4L0KPcyeD+6zPWsy0aOaWlyP6xjuo
	J6Men3+yQUG7kJ68eikR6IGZY4U6pG00E3et56CYjsx7+09ZHYwvmspZ+CpBN4kCPRjmAUPN9vu
	XJnCJy8RnA7tzXzSfTFly4Q==
X-Google-Smtp-Source: AGHT+IHf6vnwz6tnrJF7nGJhTQOliXFukjknoI4nKYkvX84klDeaakiCUnur6sPI4XGwPrQLqZt03lOgVrYxLq6x
X-Received: from plbks6.prod.google.com ([2002:a17:903:846:b0:231:c831:9520])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2c9:b0:224:23be:c569 with SMTP id d9443c01a7336-2366b32a5a5mr279237755ad.22.1750220679165;
 Tue, 17 Jun 2025 21:24:39 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:17 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-9-jthoughton@google.com>
Subject: [PATCH v3 08/15] KVM: selftests: Fix vm_mem_region_set_flags docstring
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

`flags` is what region->region.flags gets set to.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf75..ca1aa1699f8aa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1200,7 +1200,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   flags - Starting guest physical address
+ *   flags - Flags for the memslot
  *
  * Output Args: None
  *
-- 
2.50.0.rc2.692.g299adb8693-goog


