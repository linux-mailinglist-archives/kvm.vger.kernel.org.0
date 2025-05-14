Return-Path: <kvm+bounces-46534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6E4AB748A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 20:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2071D8C2D2D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C60288CA2;
	Wed, 14 May 2025 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bKsVEnG+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E43288519
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747248118; cv=none; b=urbZTo8bZZ50iMBkbetSe6KC6y2DD3R4SKcET+LEBP5c90uaUgi344ix9Vh8rYXE5Kl/YQWFREvlMOY3Wpphxg8GUGq0QV4E8J4eTEuoGC8y9lOOQoARAO4HsUPuTLPQvCratEfX21vvli8GEVkt4GH62yeEoIGKyicM4Je/WTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747248118; c=relaxed/simple;
	bh=2O407uN7TPj25b78VqtGudUAcYRMX6ZZFh6qGZMf62g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t/tFWYVRDE5hlGzed/rSpGCTAYClJ7Is1w5AUTjXk9ucGzLqb+b5KN7iwB/sUfVIsEF8zDMH2hG14BIpKUb1TCf1u0EHz6tX5Qdv+c3h7wS0C5GhrrYeS2dJSiopvsEBilm+Rl27NlQXWYVYL+bncmyWGPv8Vb06+MZ7GUqX7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bKsVEnG+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73bfc657aefso118410b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 11:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747248116; x=1747852916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QvCauuU2L9CGciSBd5j7n776p/pTGMk1tOvrluwsTQo=;
        b=bKsVEnG+vvBag+77Mu037rJ3BA+ea5Vu/BPF8y/FiNNFT1APwolHZtCHy3g8xI3sAp
         do81ent+2acVws5rD/VDB8wLKCQfxKEXyzIGL2IRyx+wi9fRZQXNDoSbCYNFefitCpw2
         /uv8ZKiAr/08plgbfL7YQXPcsuZlAXz4qMt3OVwBPne+v8nD+QxQu5Gfp6A5xyJ6ICu/
         m3BtL3ct3HFBZcot1ByAe3sPcY22XCs2wlhcaSNubf8V3vL+365QVbIs2qdrjOH/zEH5
         2/JFuk2NdOCeSwcSR8RYoSMPyX9Xh6fK+B2mi9FmrYivouB/5HlOoK1CVoGOLUGX9Y9O
         hXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747248116; x=1747852916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QvCauuU2L9CGciSBd5j7n776p/pTGMk1tOvrluwsTQo=;
        b=XrkTBT4nLn842OLsLlFmEUVs4ysfZqwKnP5bUzE+xuM+Y+txU3dKTbZexsWcNktxel
         1lmfh6U288w6ncrdG525G1iC/sOa1GMB/Cw/jV0iW4vDI4DA9Htp2iZtkRoYLLNzJlpV
         flZAeBmnc/M94f4b0Af/5SftY5Tapg+ciURROXuXhgJR3lPMZVZyer1aJP916X5tQm4P
         tSHjRCKTNRbBXtCrqEskjqh0wVD9S5eygVDkuLXEHuTfjncP5D6Q4SbHCgT4ZbZ4CY54
         pfim/4BoTtf28SaQQNMkEZ6ft/Q0IioYC6DAJUq9jlITbfBX6SDrzEDo8hItCnlhDdkg
         J1zw==
X-Gm-Message-State: AOJu0YxRqyge27hXnU+8Q1J3ATmytNX3leIbChjJOSxL7giv0Hj29QYP
	xD6PLxyLbmM+ITzi5QtWhSnYDBOn+SxFyRzIbcKpyjc4I66mcne4WOqOqX7vQHfS9Ecccn516Ml
	cXo+wRd4OaopRWj9xecd43VMVNFjhmc2rpyHhi7l/s7VOYHOgRgpyEdeuPKjtxSIrIsGoHYX1EA
	Itp00j5SbKijqOiuEmIKTg/HhsTKrThKD6qvGOlMBKaws7TPlgvlwsDAE=
X-Google-Smtp-Source: AGHT+IHAyCtpbaFX2wLqdc+E6NWHdYXGqYB3sKBEGQUjo89w5UgIHgCaHe6vWLT29dng2koFOR7LeCkZ+D5XCeyATw==
X-Received: from pgc11.prod.google.com ([2002:a05:6a02:2f8b:b0:b14:df7a:ff1])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:62cc:b0:215:d4be:b0b1 with SMTP id adf61e73a8af0-215ff194479mr8038203637.32.1747248115718;
 Wed, 14 May 2025 11:41:55 -0700 (PDT)
Date: Wed, 14 May 2025 18:41:35 +0000
In-Reply-To: <20250514184136.238446-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514184136.238446-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250514184136.238446-3-dionnaglaze@google.com>
Subject: [PATCH v4 2/2] kvm: sev: If ccp is busy, report busy to guest
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Dionna Glaze <dionnaglaze@google.com>, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The ccp driver can be overloaded even with guest request rate limits.
The return value of -EBUSY means that there is no firmware error to
report back to user space, so the guest VM would see this as
exitinfo2 = 0. The false success can trick the guest to update its
message sequence number when it shouldn't have.

Instead, when ccp returns -EBUSY, that is reported to userspace as the
throttling return value.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index febf4b45fddf..c1bd82c26a11 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4061,6 +4061,11 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	 * the PSP is dead and commands are timing out.
 	 */
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret == -EBUSY) {
+		svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, fw_err));
+		ret = 1;
+		goto out_unlock;
+	}
 	if (ret && !fw_err)
 		goto out_unlock;
 
-- 
2.49.0.1045.g170613ef41-goog


