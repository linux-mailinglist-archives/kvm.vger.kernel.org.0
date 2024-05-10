Return-Path: <kvm+bounces-17170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6FCC8C236A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C5321F25519
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF7017556F;
	Fri, 10 May 2024 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FzC308oj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE5176FAE
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340455; cv=none; b=tVGS3ie+Ps8wn4++5PKbNwJ+KexHjXp79gZQ32IUckYKkVoAcydRABAPE9K8b6syKrk/kb1fK/LPgWGIVuU3uxvfZcuYDXsA8zXqFq09w7iXST0OhKC/DXqPL81DDTNafc0KVzlcahLuIjaXTBLT1BcTc78Lc7CnDJ3cjlSc4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340455; c=relaxed/simple;
	bh=WDIF/IYfsmu+ixH4sDQsPfWeDKguwD4ZsBjXEU5uvDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cM9WB3mFDGvzMvhYVYPfyUvLJ2QTTcbHiXs5QQSOgCSv6Rq8JyBqx71nRyHxGwACRHMYbJBpa9A0oLPDtY4iWZH982kkw3YJGwaLR5iKXrXu6pq8SKDSM7/rTk+6eTZaEZrtojMR1XAL7jv+3MPdFWQ5hIBzPNd7kn6zUvsE+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FzC308oj; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a59a1fe7396so121441266b.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340452; x=1715945252; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49RDvmrkbnpDyrHr4vuzEjRKizGtD9K6IaD6JegXO3A=;
        b=FzC308ojcNMJkZM3YxXTK+w3wg5Pz6lGRrSy0zorI3EQIauOrkvl0vFGZ4vk4406Oa
         Cc3htdP/pz12bT7BvMCOeU3zFi6uR5Vknb8jBSEwP+sGhEu0uIJi3EjlMfcdOi4WgDG8
         j8vbTZn/obkxbc69gq4K3L3CrWw+Vx7Sj61QbMgaihOuHQLWkLYH6hJ4anqBf9aPquJp
         uSy0YmmoB1LVVV9+0FTPgYOIoWqHs8m4uKSY/L3t1LK009NM430Vr4s3PwFQvQeS1VDz
         R9W8Fx5kBWEp8HD2QkHfys2/+M1iRPH8R2qAXseQWXtB87zHWd5ZvM/U313C7t4ltSwW
         a/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340452; x=1715945252;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=49RDvmrkbnpDyrHr4vuzEjRKizGtD9K6IaD6JegXO3A=;
        b=I5XaaR5cE0XZfa3eq9OFeartyxFz9cSO10Gs4QeT8QiQbFiWXTLJ548tTxqYqpSrca
         yBRskmdQ8/qYjGnYm548kWrnorXO7jxZdpFrbVi3WHJPbBs+rXZKpE5QAkV1ZHoaFufj
         2O8a6RlC8sIvBZJRgVKRZkEL9yTQoWx/zsugrLJzzrvM3wgRRqGr4KSmHMB3Vi6BVxTS
         zbUE979SkRP0PS2HbEBOsmmxnERyJm7xmysI+WFOOdRTz0PnMErCa7GYfZCtct0xz5rQ
         kLhANagxgS5s4soHAPBipSem9zehWKcVxTdbOqh02EiytCIOqwzgbKopBk1Tri5p+Nu+
         9phQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOLmIAS8iYJKxtGCi3kLuwBcJ6KA66jRzZ7TaJlLrrMKSCgjXsQFx/hq3w78LTVo6qBe76SLbqsIDDpwkQIlxC0jB4
X-Gm-Message-State: AOJu0YyXckvRcpPvart5J3GMj8pL5tY615SaCgBPJ8cPV3xCt8z8nDet
	etWYFTVyfLJ6EGoOeHbDzB2BpE3AhIrOvYGe93xNMgmAsC/g+goE3HGc7i9nOmmjRJYkpHKxkA=
	=
X-Google-Smtp-Source: AGHT+IGbgNiv89bjQrlHWpgNH9EcVBcfDrRvtOjM5hynq/y8S7do68WKAWDs0MZ3rKCKgKDcmOOmZ9+0TQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1188:b0:a59:c39c:f202 with SMTP id
 a640c23a62f3a-a5a2d5a6a3amr235366b.5.1715340452299; Fri, 10 May 2024 04:27:32
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:35 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-7-ptosi@google.com>
Subject: [PATCH v3 06/12] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe=
/gen-hyprel.c
index 6bc88a756cb7..b63f4e1c1033 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,9 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_ABS32
+#define R_AARCH64_ABS32			258
+#endif
 #ifndef R_AARCH64_PREL64
 #define R_AARCH64_PREL64		260
 #endif
@@ -383,6 +386,9 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow 32-bit absolute relocation, for kCFI type hashes. */
+		case R_AARCH64_ABS32:
+			break;
 		/* Allow position-relative data relocations. */
 		case R_AARCH64_PREL64:
 		case R_AARCH64_PREL32:
--=20
2.45.0.118.g7fe29c98d7-goog


