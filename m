Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E8015DA13
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbgBNO7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59241 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387540AbgBNO7v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUqIGqmqTlWhCnO3laBt7PVCBO/kZahCFWpqV7cgUxI=;
        b=XwaMV7gdEs0lfJEF3VuUkOJEVL+PYO/+HStamGaULnMmNkveqFcgS3zJUldZ9fN6MvqYM/
        rhjPjC5DwkpxCQE+upMayQT9jqJbIjqwFAtUzE1UyfanFzDmdBfU2BiTHN4/FsY/7aKfG1
        1rBbI6qMG0DEtdW3+Z9dK8XaoqxTDRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-6ZTDD3oqOnW85Yrz3lBefg-1; Fri, 14 Feb 2020 09:59:48 -0500
X-MC-Unique: 6ZTDD3oqOnW85Yrz3lBefg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EF23A0CC3;
        Fri, 14 Feb 2020 14:59:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5793D19E9C;
        Fri, 14 Feb 2020 14:59:40 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 08/13] KVM: selftests: aarch64: Use stream when given
Date:   Fri, 14 Feb 2020 15:59:15 +0100
Message-Id: <20200214145920.30792-9-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm not sure how we ended up using printf instead of fprintf in
virt_dump(). Fix it.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/=
testing/selftests/kvm/lib/aarch64/processor.c
index f7dffccea12c..053e1c940e7c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -197,7 +197,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm,=
 uint8_t indent, uint64_t p
 		ptep =3D addr_gpa2hva(vm, pte);
 		if (!*ptep)
 			continue;
-		printf("%*s%s: %lx: %lx at %p\n", indent, "", type[level], pte, *ptep,=
 ptep);
+		fprintf(stream, "%*s%s: %lx: %lx at %p\n", indent, "", type[level], pt=
e, *ptep, ptep);
 		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level + 1);
 	}
 #endif
@@ -215,7 +215,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8=
_t indent)
 		ptep =3D addr_gpa2hva(vm, pgd);
 		if (!*ptep)
 			continue;
-		printf("%*spgd: %lx: %lx at %p\n", indent, "", pgd, *ptep, ptep);
+		fprintf(stream, "%*spgd: %lx: %lx at %p\n", indent, "", pgd, *ptep, pt=
ep);
 		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level);
 	}
 }
--=20
2.21.1

