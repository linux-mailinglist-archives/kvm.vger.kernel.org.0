Return-Path: <kvm+bounces-60703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3B0BF8066
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D7EA408223
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0684E350284;
	Tue, 21 Oct 2025 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJktEg+v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90134F27C;
	Tue, 21 Oct 2025 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761070383; cv=none; b=BYM3UElhZZPr7g4xI6S+mi7cKdp4DeWMdSH9jyxyyEvReKpQmZKuqvfWJBHew1YYPk7ZS0oKBRA/z0fjxJ3tAGRrtotdaWOW45edf3C83TIZVQvtW1hT0rePT28kD6QbqK/jnmszzQGHMbWYrqfQcBLLdfgkt4wT6unr0BYsfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761070383; c=relaxed/simple;
	bh=qEtRyFu2JyRfkeVJISTlGQJFGZB8HDaIGH3H4eIHZGM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=H2U3QqniY5Zp9N+Mbq/Huja+gHdeLt+hmwTPHVmqgUN5wmaaNe60JDMXLHJs+DMWlyLcLheQewXYh2STeISDzRFidFy0G2r6zdRPhE+lajJd0VIcHKQGWBa8YzU11Mug7L8uTUVKCrmGb25lQKxbf/DdNsC8YmIwGx+JENlc3ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJktEg+v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA51C4CEF1;
	Tue, 21 Oct 2025 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761070382;
	bh=qEtRyFu2JyRfkeVJISTlGQJFGZB8HDaIGH3H4eIHZGM=;
	h=Date:From:To:Cc:Subject:From;
	b=mJktEg+venEXDoxzg7uNpbWr6Tdota/l/YUnHyQDd8UUtHFfnEXWD0qRhhqvi0nzD
	 +qvzRayzCQrHIQCNqXVEFBI4dc4B0gExeSkhHVKMRBbNjZMH9ELwKAQQHxhWihePxV
	 NTZOJOzEosnv8gbbFL8UoDYVokn4h4EEmqnKpT/A47ZYArdvCdfop6wT/PR8bhq1bT
	 ENWNW1uYeAHgoNIgqO/6+7YFr70ZjwKdJgpb85kTqYHptTw8BaBo/JtnjY9t8j3Rn9
	 mGuLGlnKnzifM1CRJ2Apz7qQy1nHX4vOZWY3o6UlEw1zz8eXKHanVA+AZakg8Yya8f
	 0PdotYY5jyVOA==
Date: Tue, 21 Oct 2025 19:12:57 +0100
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] KVM: Avoid a few dozen -Wflex-array-member-not-at-end
 warnings
Message-ID: <aPfNKRpLfhmhYqfP@kspp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

So, in order to avoid ending up with a flexible-array member in the
middle of multiple other structs, we use the `__struct_group()` helper
to separate the flexible array from the rest of the members in the
flexible structure, and use the tagged `struct kvm_stats_desc_hdr`
instead of `struct kvm_stats_desc`.

So, with these changes, fix 51 instances of the following type of
warning:

49 ./include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
1 .../include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
1 +./include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Notice that, before and after the changes, struct sizes and member offsets
remain unchanged:

BEFORE

struct kvm_stats_desc {
        __u32                      flags;                /*     0     4 */
        __s16                      exponent;             /*     4     2 */
        __u16                      size;                 /*     6     2 */
        __u32                      offset;               /*     8     4 */
        __u32                      bucket_size;          /*    12     4 */
        char                       name[];               /*    16     0 */

        /* size: 16, cachelines: 1, members: 6 */
        /* last cacheline: 16 bytes */
};

struct _kvm_stats_desc {
        struct kvm_stats_desc      desc;                 /*     0    16 */
        char                       name[48];             /*    16    48 */

        /* size: 64, cachelines: 1, members: 2 */
};

AFTER:

struct kvm_stats_desc {
        union {
                struct {
                        __u32      flags;                /*     0     4 */
                        __s16      exponent;             /*     4     2 */
                        __u16      size;                 /*     6     2 */
                        __u32      offset;               /*     8     4 */
                        __u32      bucket_size;          /*    12     4 */
                };                                       /*     0    16 */
                struct kvm_stats_desc_hdr __hdr;         /*     0    16 */
        };                                               /*     0    16 */
        char                       name[];               /*    16     0 */

        /* size: 16, cachelines: 1, members: 2 */
        /* last cacheline: 16 bytes */
};

struct _kvm_stats_desc {
        struct kvm_stats_desc_hdr  desc;                 /*     0    16 */
        char                       name[48];             /*    16    48 */

        /* size: 64, cachelines: 1, members: 2 */
};


Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/uapi/linux/kvm.h | 21 ++++++++++++++++-----
 include/linux/kvm_host.h |  2 +-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6efa98a57ec1..99d13ebc5e82 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -14,6 +14,12 @@
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
+#ifdef __KERNEL__
+#include <linux/stddef.h>       /* for offsetof */
+#else
+#include <stddef.h>             /* for offsetof */
+#endif
+
 #define KVM_API_VERSION 12
 
 /*
@@ -1563,13 +1569,18 @@ struct kvm_stats_header {
  *        &kvm_stats_header->name_size.
  */
 struct kvm_stats_desc {
-	__u32 flags;
-	__s16 exponent;
-	__u16 size;
-	__u32 offset;
-	__u32 bucket_size;
+	/* New members MUST be added within the __struct_group() macro below. */
+	__struct_group(kvm_stats_desc_hdr, __hdr, /* no attrs */,
+		__u32 flags;
+		__s16 exponent;
+		__u16 size;
+		__u32 offset;
+		__u32 bucket_size;
+	);
 	char name[];
 };
+_Static_assert(offsetof(struct kvm_stats_desc, name) == sizeof(struct kvm_stats_desc_hdr),
+	       "struct member likely outside of __struct_group()");
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fa36e70df088..c630991f72be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1920,7 +1920,7 @@ struct kvm_stat_data {
 };
 
 struct _kvm_stats_desc {
-	struct kvm_stats_desc desc;
+	struct kvm_stats_desc_hdr desc;
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-- 
2.43.0


