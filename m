Return-Path: <kvm+bounces-53688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8092EB15589
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D218B18A7243
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84ADC2BE637;
	Tue, 29 Jul 2025 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzBEm4nk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569AA2BDC29
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829745; cv=none; b=bHsLCLl5MXMoNFwcGr47/IWBW+O9BJ/5N09AtyX0dCtDmS40T70vXrvv1nKF7aVw4pc23JOhznMFUvjt0z7KqSClpGRaupln6Zk6yPnWhrGqb/G3ETXIcCcwYDj1m9s4pLkUBt6XlcL5l7F/7ff556RpFNcjln03kBm6fAGxIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829745; c=relaxed/simple;
	bh=t6cvLBrPM9/1VtvPzsJKVP/et9Zij9EVmcFUvQb2kwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lQogoy8ZhEYB7p/rZXrrnbzTPzmLEKcIlmuZUkyHhorpEPim8OvbnFa8zR2pyr8RqNWLPz8xBy3de54CmDiJjqZ8Lnmq4wRZrBSe1eY4lDqpNvUwTaeeG3tT4D9mPE+Rf9MEYFDfq4q90tWUA9yAyuINVMz1CGYK4ydi7PxjvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzBEm4nk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3ba7659210so3944761a12.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829743; x=1754434543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M1YWU7ablLeHyEQZv+XErUzYidgNy71lF3ZCKk+Y1ss=;
        b=uzBEm4nk3bmHcJ0POTIEoEeKPrqyzESnWe+MQJ2Jr9SUMGwCZHtSgJCqDsflmppogF
         AjfegOqUBEF1V8owhf2S4hLERvpE4nDonFRTip+nU1InIRM0JjG2UIg0rapb7seExleV
         y5HVMVvaEnAmbKGH+cPNOmm4nYVntssbrPhBtWUwZvWvmf85TsXdJnZjPS5f9KV8Witj
         TTpVD82R4nierWVAOix3CPyK4yUZ6GC8q9wqVkECYuPcwPeMgJVbJEbBPPoWesxXzmKz
         9cIzOk6zSUSIpxgNt2aJmEwA25IwVclkPbSS/4Z9FBqj9KOOrueg5PMUA7Hw7XgK4E1q
         gv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829743; x=1754434543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1YWU7ablLeHyEQZv+XErUzYidgNy71lF3ZCKk+Y1ss=;
        b=TnwFLd7osup+NfEAUScb7mwbQv5u9LeicBkbKMXJ3+YYuRirjlecpJllRnW6LisY1n
         n3lQxznS49MWIYOR4e0IFwz2ZqpSd1oJHcdYVoIC/mt+p2Gzo7zVdJb4lpGVnoJvm421
         COfl9noE4HmwcPdpdfMsSd+Ew8494XP4SYtFNZiKYHg/JRv8XHs/lboSd5fAZhp+KApT
         ASIzD3y9NAVl56S42A+qOxzLKUvOnXjN8X4HeVAbhCvhSjgrhE6L4Gx7XlFKUTqwCaV2
         fGVYxx5FXXDBEWMakXPPV0zSWcAxizVLmsp2syf6olQtJaJiWRz+THA9SKpUxrcfrYcA
         2zcA==
X-Gm-Message-State: AOJu0YzTNXRr/hFXQLM5eduCJLzHm16DjXqmpAxLEKYt2R70HHefHvw6
	m5AhUDVLrNoeAFLXCRsLfHTCQ1ghoTyGksqNq6Cul8nyahxPhDEv5V1HloIiAm0yVis23swN557
	1KWeO9w==
X-Google-Smtp-Source: AGHT+IGVcslDz7bQMIRMZU+0Y4qmg1DflFiXRNbdJAEQP1alfIjp0PIHNIVeHhCtlJmnFtEV0iZyubohx5w=
X-Received: from pjbqo4.prod.google.com ([2002:a17:90b:3dc4:b0:31e:cbc7:c55d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5111:b0:31f:1744:e7fd
 with SMTP id 98e67ed59e1d1-31f5de569fdmr1627875a91.31.1753829743638; Tue, 29
 Jul 2025 15:55:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:39 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-9-seanjc@google.com>
Subject: [PATCH v17 08/24] KVM: Fix comment that refers to kvm uapi header path
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c25b03d3d50..56ea8c862cfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.1.552.g942d659e1b-goog


