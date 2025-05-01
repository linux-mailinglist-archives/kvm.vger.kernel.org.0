Return-Path: <kvm+bounces-45154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 834C1AA62D7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505CE9A74CC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDB6225A5B;
	Thu,  1 May 2025 18:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qhNcs6fu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C763E22576D
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124411; cv=none; b=mgjvu5ErfSik3UCvn6fMCXMcS/7uoQM8AM41yNCrkEtoMUJxEx+5Z3jUVPhDJZtUgLrdT1XXBPuLlckaPIP5RcRJwlOEgzY3GNEJ8UeiEPVfPDv2xoHTWqKCRfSOHN4wvSptDGUYnJODMHbKT76c39C5NUSpGJ/3jOmzE8BDPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124411; c=relaxed/simple;
	bh=AyQYns9VrYXUgKE1RAyvfX8Qdmj+bL5M40qUKypPI3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DaPW4NXB/WyU+749+/zukcbUEGZkYXFxjWq4mczKNB0PGfDsn/qPNVrTTLM0w22IHk5cfZZYoI3dWcAsuWmLrkykGdNLNH9zA6n3/mKLtSZPJYnxrAKkyiIt9JkoJThg58Jcw2gHcMH9bTaVWLBk00/16i687uEx3Cg09WhXZw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qhNcs6fu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1c122308dcso1422246a12.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124409; x=1746729209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmZxT8OePR70IlcHk3w9PyaS2Ebe0ZK5Neg7TiicVTQ=;
        b=qhNcs6fuZAku1ZUvddPSpyPHBHFBiqC8JFshOyc2PSNrzC/tnAqjIZnyWBDFqByP6G
         V8pyWkdPUxpAv7G0w1bHY7uKRwLGLgB9zJlbk7VKxyE/gclDWEGc4bfQoKjFHcaNLiC4
         rhwgq8EBcWJ0rX4M19G/Dg04BMZvfxXI/8SHmJwDukWF46axrw7ZMtNiRikc6YYX4lon
         WZ6hgPU16ryqePfqmDlh+MSoBUuFvqGJjgn/TxPeEdUsRKzg4APPVqP6HsQFZbptrzHl
         /vuZfbEHE6tqttZaz89dzDzq8B50gIpZ1zogY8aZtCLbV3ydBAQB1xKGAtDULjvkGVFQ
         FCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124409; x=1746729209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmZxT8OePR70IlcHk3w9PyaS2Ebe0ZK5Neg7TiicVTQ=;
        b=LRxXS8RSQ4wy2RJKLNe70Ageb4QUJcjjcWr2rnLUrL5AE9xKoOpCLGNseFieV1oDJ4
         VcVuefDCIq/DZhCgQ1NeoWxVWNnwTuWJzbEtYy6ppnf02w1oxrm9oA2DLregaWn8uJ1e
         w6AvFck7UPqiFb/PpdHxl+PWRkyQELhyv4FL9zWqrteuUiPYYF0AgiJq9ax0sGH/9lrH
         z8cavxO1ayjzwu7ycZb58f+n9mRu+4zPlUYJoz1EAEjaOWyP8WIY/1zFA42jBdtezRei
         vt1W0y54cUt4puJiIz4bysCTlhDRpFYhi+TQoOB1qZZeucM3qVwRjRUbcG238GUcbWdN
         tX8g==
X-Forwarded-Encrypted: i=1; AJvYcCV4WGATtQWQcISvFNbwbT4+6qoJ3exWaIckOFpMBDLzTVoEC4untiYdoOgSQ5Re1BNK+ks=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMaJ+QzSrFYchSi5lyHJR8OuzvoK6N7S1Bk/BXuMfrPvF7zFEV
	oeFLNMZz3RMx6ApE3WzUZRLBenfVX0bJhyZgFNWnbugah6QmB3GGp73NQRRVNyn7p39Iy/25Rx0
	TK3zqjIH5Xw==
X-Google-Smtp-Source: AGHT+IG7ZB54jjneYfe1tn18St+FGK/8C/RP49qADT4OdwlvOWaJA1tk/v3Dm4OeF0p3gO05OEVmZwLAOdDMmg==
X-Received: from pgct19.prod.google.com ([2002:a05:6a02:5293:b0:b1b:54f8:d2ee])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1587:b0:1f5:8262:2c0b with SMTP id adf61e73a8af0-20cde46dddemr28056637.2.1746124409090;
 Thu, 01 May 2025 11:33:29 -0700 (PDT)
Date: Thu,  1 May 2025 11:33:03 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-10-dmatlack@google.com>
Subject: [PATCH 09/10] KVM: selftests: Use s16 instead of int16_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Use s16 instead of int16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int16_t/s16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index afbddb53ddd6..0f6d5c3e060c 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -288,7 +288,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		else if (qualifier == 'h') {
 			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
-				num = (int16_t)num;
+				num = (s16)num;
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-- 
2.49.0.906.g1f30a19c02-goog


