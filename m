Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA8540448
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbiFGRDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345371AbiFGRDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9E64FF588
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73ED01480;
        Tue,  7 Jun 2022 10:03:29 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0B47C3F66F;
        Tue,  7 Jun 2022 10:03:27 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 10/24] Add memcpy_fromiovec_safe
Date:   Tue,  7 Jun 2022 18:02:25 +0100
Message-Id: <20220607170239.120084-11-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existing IOV functions don't take the iovec size as parameter. This is
unfortunate because when parsing buffers split into header and body,
callers may want to know where the body starts in the iovec, after copying
the header. Add a function that does the same as memcpy_fromiovec, but
also allows to iterate over the iovec.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/iovec.h |  2 ++
 util/iovec.c        | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/kvm/iovec.h b/include/kvm/iovec.h
index fe79dd48..55a03913 100644
--- a/include/kvm/iovec.h
+++ b/include/kvm/iovec.h
@@ -7,6 +7,8 @@ extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 extern int memcpy_toiovec(struct iovec *v, unsigned char *kdata, int len);
 extern int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
 				size_t offset, int len);
+ssize_t memcpy_fromiovec_safe(void *buf, struct iovec **iov, size_t len,
+			      size_t *iovcount);
 
 static inline size_t iov_size(const struct iovec *iovec, size_t len)
 {
diff --git a/util/iovec.c b/util/iovec.c
index 089f1051..c0159011 100644
--- a/util/iovec.c
+++ b/util/iovec.c
@@ -93,6 +93,37 @@ int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len)
 	return 0;
 }
 
+/*
+ *	Copy at most @len bytes from iovec to buffer.
+ *	Returns the remaining len.
+ *
+ *	Note: this modifies the original iovec, the iov pointer, and the
+ *	iovcount to describe the remaining buffer.
+ */
+ssize_t memcpy_fromiovec_safe(void *buf, struct iovec **iov, size_t len,
+			      size_t *iovcount)
+{
+	size_t copy;
+
+	while (len && *iovcount) {
+		copy = min(len, (*iov)->iov_len);
+		memcpy(buf, (*iov)->iov_base, copy);
+		buf += copy;
+		len -= copy;
+
+		/* Move iov cursor */
+		(*iov)->iov_base += copy;
+		(*iov)->iov_len -= copy;
+
+		if (!(*iov)->iov_len) {
+			(*iov)++;
+			(*iovcount)--;
+		}
+	}
+
+	return len;
+}
+
 /*
  *	Copy iovec from kernel. Returns -EFAULT on error.
  */
-- 
2.36.1

