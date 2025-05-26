Return-Path: <kvm+bounces-47733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA381AC4491
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 22:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4C8C7A5B9D
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 20:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F12E1E5B7E;
	Mon, 26 May 2025 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aG1aDKoH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C974819D880
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748292335; cv=none; b=GXlkQhVLqH8HXfDAyV1vapmKkEoDZQ8VVCYX0Wl5AqZ1urRBXStrAnwDrYwFF6HImJUUCgfVHXp2B29FWMgVOXW3m7mb4d9KgnOFIlJ6WmNdUjJD1uX3Qw491ofNKJKlx9iHhJP58pa5A6cVLXDSzvc72lzyxBqOvI+HoMfHHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748292335; c=relaxed/simple;
	bh=YzVfqM7isCpur9lKuyl8+MnXjqPSAYoEufr181o/ojU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bq8bOQwSPhxiZvRrWlUhKM2/bk4rvUlR9QE1r4j7sFY18bY5B6umUJcWjn1sCLbtd5LtXKyu01LA8vMbqiBWjQ9bmGBGp1TJCWqFFN+loBURFSgMbzJ6W2v6qb7jAc/4bIE7JriF9d8yY7RZVc/9za0lAG0sCJDY0ko1/ianQCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aG1aDKoH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748292331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Hwbp3hCpje483Sa0qCp5UGHnKUUud+4LtTTy2eYUPhE=;
	b=aG1aDKoHZOTgVhi3Z5WhC+xkzPHOJbidAV4BNPTi9ODs0dP/FgROQuiUpRgo6RcwrpofmX
	5OE5E7JLYq7Ac0jTBiG7tBbNGZn9WaJGu7yayo5gTrLC65qt7lEjE7SxxmXeLK5r9vZoir
	bqCwgQlYUun9HEQmFT4f76zYFR25ypg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-CRjVJVarN0S7xBTdGm2FGA-1; Mon,
 26 May 2025 16:45:26 -0400
X-MC-Unique: CRjVJVarN0S7xBTdGm2FGA-1
X-Mimecast-MFC-AGG-ID: CRjVJVarN0S7xBTdGm2FGA_1748292325
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 022C319560B1;
	Mon, 26 May 2025 20:45:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33F9A19560A3;
	Mon, 26 May 2025 20:45:24 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Date: Mon, 26 May 2025 16:45:23 -0400
Message-ID: <20250526204523.562665-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In some cases tdx_tdvpr_pa() is not fully inlined into tdh_vp_enter(), which
causes the following warning:

  vmlinux.o: warning: objtool: tdh_vp_enter+0x8: call to tdx_tdvpr_pa() leaves .noinstr.text section

This happens if the compiler considers tdx_tdvpr_pa() to be "large", for example
because CONFIG_SPARSEMEM adds two function calls to page_to_section() and
__section_mem_map_addr():

({      const struct page *__pg = (pg);                         \
        int __sec = page_to_section(__pg);                      \
        (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));
\
})

Because exiting the noinstr section is a no-no, just mark tdh_vp_enter() for
full inlining.

Reported-by: kernel test robot <lkp@intel.com>
Analyzed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505240530.5KktQ5mX-lkp@intel.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5e2a937c1e7..2457d13c3f9e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1517,7 +1517,7 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-- 
2.43.5


