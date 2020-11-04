Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DCB2A6F92
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbgKDVYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729828AbgKDVYP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ta4c3SkSpR1JFNXe1Sdfrmx4O8Exk6ixKFQJIpVIZMk=;
        b=KZlp23n806zdLXoHqhNoXe3TYwCLZiIPEhx8aZxwsj9VgnSIrfi9kX9koJPzKylLVCUphV
        yweAm1hU5P6EpGC2U6oj8PQa9UBoYnyF1HG+pxIqzn7E2eHx+9AHB+Qim46KGKm1VtA7Ey
        d7X3AFkOy2WKw3C8WejgIquVNt5eZ2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-kIKKjSkHOsyw--1C20YeGA-1; Wed, 04 Nov 2020 16:24:12 -0500
X-MC-Unique: kIKKjSkHOsyw--1C20YeGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73E3B8049CB;
        Wed,  4 Nov 2020 21:24:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 946A35DA33;
        Wed,  4 Nov 2020 21:24:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 03/11] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed,  4 Nov 2020 22:23:49 +0100
Message-Id: <20201104212357.171559-4-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

We don't clear the dirty bitmap before because KVM_GET_DIRTY_LOG will
clear it for us before copying the dirty log onto it.  However we'd
still better to clear it explicitly instead of assuming the kernel
will always do it for us.

More importantly, in the upcoming dirty ring tests we'll start to
fetch dirty pages from a ring buffer, so no one is going to clear the
dirty bitmap for us.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 37445aa4876f..954331c2fda2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -195,7 +195,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.26.2

