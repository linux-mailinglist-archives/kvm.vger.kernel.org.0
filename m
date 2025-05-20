Return-Path: <kvm+bounces-47132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F009FABDB2D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 920EB4C5D43
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B1D24677C;
	Tue, 20 May 2025 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3DwZm0w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F6EEDE;
	Tue, 20 May 2025 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749758; cv=none; b=cEe/4eAPCa5HwAd2SbSAwu+c7QLTpp8e3t38KD0a46C22RdNd77x9Zd3blJEohcJcxine6f/Nmd9pwxod/uB/WyfJnKlp9yu2JLTBAWGzL47roa/p6zmfXPBKYTmvzwjKC8KR2nxGGA/L5BM+ovjguzy4vta9c/8nexiGIFB5Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749758; c=relaxed/simple;
	bh=+XVHl7O7cwcc4RjEIonMkVtZ3q3THUWZ1aEJqOwFFIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJwnhXUlJq3ANqjkg5SxzAGV9ls7p0gsOzHBTih1j5ItxBDZA/2dtWglQhTtpvJ4HNMxLSi8/9InbcYa03RamdcU3JzzhobMKkxKA1JNYFdmQ1MawwBkpCAxnJpRRfjX5riILhH2RLySVYCQChVFfYHRC0LkxxHhSSyqMjtsIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3DwZm0w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E28C4CEE9;
	Tue, 20 May 2025 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749758;
	bh=+XVHl7O7cwcc4RjEIonMkVtZ3q3THUWZ1aEJqOwFFIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3DwZm0wL4IzJ5OqyF++mfUQGftLsWp2+IonrwhtxjrVhisp6TPLH9xIPFBlHNxOZ
	 T02HrCPkJAZ75Tx9eYp262iPxPW0np5SGQR4i5e6l4ej78RwSBSXj63F4gytvJnTU5
	 GYzwDTZl80kFGlg3dDtZN0OZCNZZMJwHUuHWf+JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/117] KVM: SVM: Update SEV-ES shutdown intercepts with more metadata
Date: Tue, 20 May 2025 15:49:45 +0200
Message-ID: <20250520125804.782364770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Gonda <pgonda@google.com>

[ Upstream commit bc3d7c5570a03ab45bde4bae83697c80900fb714 ]

Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
only errno=EINVAL. This is a very limited amount of information to debug
the situation. Instead return KVM_EXIT_SHUTDOWN to alert userspace the VM
is shutting down and is not usable any further.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230907162449.1739785-1-pgonda@google.com
[sean: tweak changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: a2620f8932fa ("KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 29c1be65cb71a..0c01887124b6c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2211,12 +2211,6 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * The VM save area has already been encrypted so it
-	 * cannot be reinitialized - just terminate.
-	 */
-	if (sev_es_guest(vcpu->kvm))
-		return -EINVAL;
 
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
@@ -2225,9 +2219,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 * userspace.  At a platform view, INIT is acceptable behavior as
 	 * there exist bare metal platforms that automatically INIT the CPU
 	 * in response to shutdown.
+	 *
+	 * The VM save area for SEV-ES guests has already been encrypted so it
+	 * cannot be reinitialized, i.e. synthesizing INIT is futile.
 	 */
-	clear_page(svm->vmcb);
-	kvm_vcpu_reset(vcpu, true);
+	if (!sev_es_guest(vcpu->kvm)) {
+		clear_page(svm->vmcb);
+		kvm_vcpu_reset(vcpu, true);
+	}
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
-- 
2.39.5




