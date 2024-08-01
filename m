Return-Path: <kvm+bounces-22999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B89AD945508
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 01:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51F79B219CD
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 23:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB79414E2F0;
	Thu,  1 Aug 2024 23:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQn35Y0z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A614D451
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722556422; cv=none; b=eh0tpA5XSbsxkRdhRqDkGycAkLuAD8elRe2IW34n0NmoV2qu2ymuonn4WC/b6MzRhGZz4HEhef0Vb9PlCeIeO3LH2xacYGYvlWZUFdapnDjEjXaQtKyuvnBkieumJ52XNLwrKdnvEYxkD+JPGHi9PkHpnRXwJNHBQ9PUrG9L0HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722556422; c=relaxed/simple;
	bh=0bZmjV35Y0DFFdYimWpib0vJhpUru5xOxkDSJHkavgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rg2Gnnb/4TVI7/FVhAJw7M6o7K8IO60Fl16x5IO0dqfJpBcM4HrVJUs6mlSLEEvEKDAuZJZh6nxKVF8jxp4AIiA1A6NagGJ3tjL7gI+xZElQqufFkvXiGwr2C0NkBBgFh8zVhDGNscIZ9XtkuFrVmcQJ6UskgXdjHtGRhJ341y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQn35Y0z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722556419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OUSx7yeM//U7xgBRSiunnDzCLJUpTvy9KfWqh4xwHw4=;
	b=JQn35Y0zCbg4qvTKLp0DRPO6Ag6NGmptLqoDQ6KqOJr72kSkFg+vA+sByxNsgW25YuZryj
	c38YtOljpNrhafjZ3vHAioGT1PgB1I6JbJcHgiQ1DBMNiyk0C0UiIyESiF/R3GP9MVBEBw
	mLFLNF18oNHUGRTWerVoTqpnHPFZS8M=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-kJORcFtKMmKxfVvpGLX08w-1; Thu, 01 Aug 2024 19:53:37 -0400
X-MC-Unique: kJORcFtKMmKxfVvpGLX08w-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52efcb739adso1975307e87.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 16:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722556416; x=1723161216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OUSx7yeM//U7xgBRSiunnDzCLJUpTvy9KfWqh4xwHw4=;
        b=ceP13+hMlqNCtWN9d1JcKOt+DsRDcuRpZ+5HOfW8yoQU73Dmc84z/eoDNzntjcPLc0
         jdDRWjE1NYr3k0xCaMUNK4yzSvCMnwg2www/vMeSJhqzmKqq4NrpgpJSFgXMff4EbJgf
         0p8SyXYQPEgvDoQagYBSQACiklAvypbFWKxf9m8vlQ5gUlJFZ3kW9pzVqJoMGUfsXVw4
         DRNzCfgShdtXpbmNK1XjCbwMYUscG+mI8dmfTIpmT2Z82YXPKPT8Io1+W6IxMWHvPxZx
         e2UCX8tOULr8AA2baIbdbzV4KsGy7AL6O0OVx/Iesrj8GZecR/qvCrhxn7bgBGPRvMli
         ntFw==
X-Forwarded-Encrypted: i=1; AJvYcCUDk5Z8bFdshPRK57f4gOjooD9PUOMkBub9Q7Zqdq3UzhVi2J/pat7bDrutG7kPMwhR026lgSjCUNXAyyCBCkVfB7K+
X-Gm-Message-State: AOJu0Yyxmp18+fh8e+D64JAPx2cr0UOAIdhFKI94+HDeXgjmF+DTUrrr
	CW2SB+VIIbaAVr46i3A0XrRO19R+KDxQLjExiYF1QrQoBcYSQ6ttxSeTvzxj65DDStnNs6RiNXM
	pM7wRQMRXmkstD6Pj0fAZPJZEQIGVT1TZKHihb5zdWCPtM9SdRD/++vV7+w==
X-Received: by 2002:a05:6512:2805:b0:52c:dfa7:53a2 with SMTP id 2adb3069b0e04-530bb6c7b28mr976214e87.50.1722556415754;
        Thu, 01 Aug 2024 16:53:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExnzW1SZ0twUMkNblcsaDTxDqmZnuFJH/xxGE6TmjBsdB/4VFoq/tSC1skMpS/DYOFOCcPiQ==
X-Received: by 2002:a05:6512:2805:b0:52c:dfa7:53a2 with SMTP id 2adb3069b0e04-530bb6c7b28mr976202e87.50.1722556415163;
        Thu, 01 Aug 2024 16:53:35 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c0c58esm32725666b.86.2024.08.01.16.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 16:53:34 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>
Subject: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP guests
Date: Fri,  2 Aug 2024 01:53:33 +0200
Message-ID: <20240801235333.357075-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Even though KVM_SEV_GET_ATTESTATION_REPORT is not one of the commands
that were added for SEV-SNP guests, it can be applied to them.  Filtering
it out, for example, makes the QEMU command query-sev-attestation-report
fail.

Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5c125e4c1096..17307257d632 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2587,7 +2587,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
 	 * allow the use of SNP-specific commands.
 	 */
-	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
+	if (sev_snp_guest(kvm) &&
+	    sev_cmd.id < KVM_SEV_SNP_LAUNCH_START &&
+	    sev_cmd.id != KVM_SEV_GET_ATTESTATION_REPORT) {
 		r = -EPERM;
 		goto out;
 	}
-- 
2.45.2


