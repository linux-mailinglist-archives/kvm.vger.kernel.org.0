Return-Path: <kvm+bounces-9366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EFD85F53A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC2401F25EA1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534C439AC3;
	Thu, 22 Feb 2024 10:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLFBAFuS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7962638DD9;
	Thu, 22 Feb 2024 10:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596259; cv=none; b=NzLnU9bC6t+ZWS2R1HXLT+2ZcYDDcBUntiirKGteE8hD9Vl/JMV5jEYUYdv+RwGHXcr0bIy66fVre85ZoQJF9u6gmi7u3X/DDFa+pHtwbiynoL/dveICUk8DP5/BAzdUCDrqr5hs1J6ztlmUQ4TRmulZakmY7PqHxUe0IPsJp8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596259; c=relaxed/simple;
	bh=DY+laaDGWADlgjZ4aCk/y2nEJQIg6zplT0mKVagO2gE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lS97D8ngWiBiXsGfHeO6IpXaPe+VmfzfMEeRtPlpgE87wFV0nVeKwCaH/GObn768VtBqBZVRpEtxEDCtkImY5RXatwv27940GDJD+bhzXfqUMueADzR/I88wtYUzShfX488tLwaFG/AdjAy1QldRtDQ0CSwXTEuP2A/tAXyU1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLFBAFuS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB37C433F1;
	Thu, 22 Feb 2024 10:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596259;
	bh=DY+laaDGWADlgjZ4aCk/y2nEJQIg6zplT0mKVagO2gE=;
	h=From:To:Cc:Subject:Date:From;
	b=BLFBAFuS1IqZtsu4OkQIujYD8nRbeCwV9jGbdUmQMen0qak0DD7GCeTMy/o92a6jR
	 QeG2H/KO+xVYKuqf9XuyYY1IjgvMDAhzJgMIngXNJ8H9CwJHcN+nuee/C55+kXemL2
	 VFxAPStbgXsHPBhbovrhsre+27Ku68taiwDZQ70gNT4NEfHnqYSd93mlIvsHeaHlBW
	 HreItCp7zMUEGA5rJK6Lj6QSpohfJk77GuHoDmC2XtmdB1t2AeZNdonBBnx9NbcmHt
	 V2ywIcxpAVu3ABiTXPPA9lDMZPnTmZHcXz3EhZpGx+nwz16SuhEUjhaEkGu6I4CtiK
	 kC/MGvB3U6UQQ==
From: Arnd Bergmann <arnd@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/xen: fix 32-bit pointer cast
Date: Thu, 22 Feb 2024 11:03:58 +0100
Message-Id: <20240222100412.560961-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

shared_info.hva is a 64-bit variable, so casting to a pointer causes
a warning in 32-bit builds:

arch/x86/kvm/xen.c: In function 'kvm_xen_hvm_set_attr':
arch/x86/kvm/xen.c:660:45: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
  660 |                         void __user * hva = (void *)data->u.shared_info.hva;

Replace the cast with a u64_to_user_ptr() call that does the right thing.

Fixes: 01a871852b11 ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 01c0fd138d2f..8a04e0ae9245 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -657,7 +657,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 						     gfn_to_gpa(gfn), PAGE_SIZE);
 			}
 		} else {
-			void __user * hva = (void *)data->u.shared_info.hva;
+			void __user * hva = u64_to_user_ptr(data->u.shared_info.hva);
 
 			if (!PAGE_ALIGNED(hva) || !access_ok(hva, PAGE_SIZE)) {
 				r = -EINVAL;
-- 
2.39.2


