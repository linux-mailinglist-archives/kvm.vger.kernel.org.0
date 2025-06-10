Return-Path: <kvm+bounces-48871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B38FFAD4350
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 446FE189CCC4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EA9265CC8;
	Tue, 10 Jun 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AcFGE6SR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D86265637
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585269; cv=none; b=obThVf83CICqTl4T7B/AbveYX5KoiCAGu/jvrgXZTMo/oz4LjunnGp3x2Szufxao/AKkoUqs8xi4lE+594osjK44KEHCqVVS4tnuXoDGYHI5NEebz8ahXXYejF8/t+/XPt9OozlThx9H/NLqR8aNC09OYn1qCCi278l54htxHok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585269; c=relaxed/simple;
	bh=gzsysHevYRPJIWqCQVGrz5E1wVC1w7z7c0KqnUeeEFA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sHwQPVC2m17yKzGRZTxEEg+noCza1NTPOh1F2dyJugGWtczAlVfOVs9aqngI4w4TABB3OMTlDHbTIYvTdE5FsyU14E3HBKw7YCJlCVu6rqW1wLgJGGL88eQP91cUiELWEEjcNVhoo0fh3hmbxQEYl78+EOZjNV/19wauMSnCPsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AcFGE6SR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747a9ef52a4so8224770b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585267; x=1750190067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pENf+ubz/9uUej+YZgSxLThR/bvZTCB4ij8FYt6QzBY=;
        b=AcFGE6SRYLNekRkS1NHf4+H1Hbg4M8S+EzK5+EMk1W9kBH4d/gIkzFUx7hFmsaXnCs
         kvRcGw18mhjIvTMlmkcT+O+ouJYqRxuT8nAa8H9nnuBZ7uyDlPtwZTCFy/b1CbmKYJfV
         Ay630vSusVAkV/Fgb8nGGY5O503TvIqMfoy+1SpHzulkLfo2weD4GXKyPJE4IBOQ084g
         GNP4KonF4xDg+KLVZZjVuW+rHL5sSPzYeG39wV5n20FAw6oB95yyZj3NWAC5SxDBDYfD
         ftmsuK5cCgIh20ClV2Dmj4luWCKZMFbisrv3p7yFsgsGErSNXNO+nlkU8cJg6jyPVmMK
         MgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585267; x=1750190067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pENf+ubz/9uUej+YZgSxLThR/bvZTCB4ij8FYt6QzBY=;
        b=O6Q/VHgLDxp6o2DOcnnFj+KofORE7yqDEfB/rDGLdRsjFW08gfuhypv97w9XoJ+2Sm
         89n2riYyel8qvbigqiafHPgJ2pc6FoFXNeh4FIITa//FZlI6rsom65xMklto/gVKzvy9
         vLrptgm0hQ4M3Ek2kZQ3kMLRqn1YCt5W37FpSoisKKd+hxzHxVHG5TYW+aNjWLl8RlkN
         bv57825xTmV7z0orHkL1XZGQtnbVVl4XzcWWKNpDWp8gUFaNfaruIvFK34NwsMZvTvBI
         qV8IwK6yegdaAD6rgeUhMOtB0vw+b2OOoBSBeWHca7SXJpKwNExHJ8/G4GEE489nA55y
         CqLw==
X-Gm-Message-State: AOJu0Yw57Ylj2xJVfGsYoidXroMRy7jVcOifX6z4XcZeeZ/0a+kdreWJ
	hXHR5FqJ4kG8MIaojrwW4RJm38GOD75uDcr/gKjw2GgxOjQB/wVoQx0zeZz7XgsPu+3ezjqWg0P
	2KmVJjA==
X-Google-Smtp-Source: AGHT+IHTovsw9Y1rIYvKCoId6JUAdGGWaivNh/C/qyI0YetmappAXEUL3V1smkYEY+NQPacorDJb7UF8t/s=
X-Received: from pfjg10.prod.google.com ([2002:a05:6a00:b8a:b0:746:1c55:a27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:158b:b0:21a:de8e:5cbb
 with SMTP id adf61e73a8af0-21f890ae72emr82050637.25.1749585266988; Tue, 10
 Jun 2025 12:54:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:06 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 05/14] x86: Add and use X86_PROPERTY_INTEL_PT_NR_RANGES
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Add a definition for X86_PROPERTY_INTEL_PT_NR_RANGES, and use it instead
of open coding equivalent logic in the LA57 testcase that verifies the
canonical address behavior of PT MSRs.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 3 +++
 x86/la57.c          | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b3ea6881..e3b3df89 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -370,6 +370,9 @@ struct x86_cpu_property {
 
 #define X86_PROPERTY_XSTATE_TILE_SIZE		X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_OFFSET		X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
+
+#define X86_PROPERTY_INTEL_PT_NR_RANGES		X86_CPU_PROPERTY(0x14, 1, EAX,  0, 2)
+
 #define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
 #define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
 #define X86_PROPERTY_AMX_BYTES_PER_TILE		X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
diff --git a/x86/la57.c b/x86/la57.c
index d93e286c..aaf9d974 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -288,7 +288,7 @@ static void __test_canonical_checks(bool force_emulation)
 
 	/* PT filter ranges */
 	if (this_cpu_has(X86_FEATURE_INTEL_PT)) {
-		int n_ranges = cpuid_indexed(0x14, 0x1).a & 0x7;
+		int n_ranges = this_cpu_property(X86_PROPERTY_INTEL_PT_NR_RANGES);
 		int i;
 
 		for (i = 0 ; i < n_ranges ; i++) {
-- 
2.50.0.rc0.642.g800a2b2222-goog


