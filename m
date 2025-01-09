Return-Path: <kvm+bounces-34965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F6AA081C3
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC13A1614B3
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189B7207A2F;
	Thu,  9 Jan 2025 20:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VnaZAejF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF0204088
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455809; cv=none; b=WXU/k+GbamaWK9R1S6oVh/xfqL/85hnrgln+C1HplCO37IEv7soCGbsZeA/6HfEzIr/CIss/QdxwkiLBQLseZCfF74/bMVnUl2L8oWvrpKtXkUp/UMf0O5Px1XOXhNgsPl5JZ+Qwy0vbYCS43pt+/cAD5lQZwf2XwvdA6wW+ejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455809; c=relaxed/simple;
	bh=CDB0cv1aSXnhbWgtnZoFSntC80Trm0mVRdwCoCUf0ZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JCyLo4U/laZcZ9pz7bxo2K3MV8FxzWiusl/t2XTD6JI3gqMV7sZxKQjQTnMQqyUvSFc5c4K5slpNd9jA8g9Wpmhd92n90kpFi+JV6Vjqpyxcka4bmEq027vbOC1sAsYWGyW8fsWK5GAK1S5JSEH9ypwp9emPeget8bsxYm/oyoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VnaZAejF; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7b6f943f59dso227575985a.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455805; x=1737060605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A6d9SLIy3ba7m9amfCG873jUIu7Rw+T0rUlSTA7+tzA=;
        b=VnaZAejF2+Jqkh4bYYgT9N+jpl0rhrHwVG1gBNsipuFLNVLqWmkcJa9ewOH2gj+eAq
         7JAyN7it5uFj5hCSjnzS0ANZ6bq7/WPeBC0peVCsUD18n25ESD+sGuCqiwdOIRQpGWJ3
         0n1MCnUoBSxUoZSce8fWefMXXnk1zG19BDPeMEknS1gXe+9iU5Ibs4+EUxPG50Kf2Nr8
         jhnWA5Dj+qSWU5HgMtW/CmP6+60/GHnnCQ7NROquJKtG6NbP9QSitloRjORonS6X7/rW
         P5wL0NBAaUQgJWysHg/HyIDJvkEFbbSBzP6VBc4bVr2mBtFZYoOpxd0FZGJTC9F8iFpQ
         sxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455805; x=1737060605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6d9SLIy3ba7m9amfCG873jUIu7Rw+T0rUlSTA7+tzA=;
        b=WoAPsa7Dzqi5RSDWOQNl/ceMozKwqNBqDUkgLv6Pq4sLjIo8LyDKUc9bqkLO/U4uv8
         odDAs9qfsDBOPcrwcYtuGZTJBeT9jZFZvzfaKIVJ/maabb3Rumz3pxULB432EWs/Yibg
         jXlPJbVbQ7R6Mx3qJgTIDHihIUCMCAFHbZ3PV+WRzRE5H76otfgShDsE5/nriHpYyBpm
         RYTCiuLiTO1pL4IXk10lnJr3pJh7qEh7DJJRRe3v4Cw6JrxiZf/4CL/SuW9t+iN+Y5i7
         z+Lh53ciITJemYgrgybovcWG/b5mh5T01+JjdoK+42arcJJb7ckjwuBvNGGhYHSt+qBJ
         GbYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWpGvJNe2t2N40lhGd8THlIAieL4n4lSk6iv25UTfEHSke/M1cZR1w9mBe8yYJ+cSWwLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsA6yh7DlucfkPg2rx++6TpI5Nagss4dL+YIPFLMyux/G77goc
	Uy3fFx1hFu+d0CfmXvaM3e8w7xpPTdiverH4NNaTQZqNrAjApCvEN7yvUr7uW92bTq+TH5JWloD
	Ge8EgDfITsEBOQ+KqVQ==
X-Google-Smtp-Source: AGHT+IGuiGH+ZZwCsi1PGFRN10vipIun+GV8y4B9awYjMBGGjqu8CtE272hh3gh4o7UZqaJM/jxBCOqhOtlKtS/V
X-Received: from qkpr8.prod.google.com ([2002:a05:620a:2988:b0:7b6:e6cf:180e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:240d:b0:7b1:e0f:bf9b with SMTP id af79cd13be357-7bcd97afd59mr1217697485a.45.1736455805434;
 Thu, 09 Jan 2025 12:50:05 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:28 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-13-jthoughton@google.com>
Subject: [PATCH v2 12/13] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index adce75720cc1..1fea8ff0fe74 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -556,6 +556,35 @@ static void test_add_overlapping_private_memory_regions(void)
 	close(memfd);
 	kvm_vm_free(vm);
 }
+
+static void test_private_memory_region_userfault(void)
+{
+	struct kvm_vm *vm;
+	int memfd;
+
+	pr_info("Testing toggling KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memory regions\n");
+
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+
+	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
+	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
+
+	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+				   KVM_MEM_GUEST_MEMFD | KVM_MEM_USERFAULT,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	close(memfd);
+
+	kvm_vm_free(vm);
+}
 #endif
 
 int main(int argc, char *argv[])
@@ -582,6 +611,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog


