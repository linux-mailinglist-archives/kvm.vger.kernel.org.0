Return-Path: <kvm+bounces-70096-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AmBFJNygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70096-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:11:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE6D4DF1C0
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27EB430C6280
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C213E3783DE;
	Tue,  3 Feb 2026 22:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7SDxHg1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF56374750
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156597; cv=none; b=YV9nvJQKOklyVgcZmhgibW3lFHBK0apJVFiehaF0jxjA0LgQCWpV5QbBgU+DsXLoOsdByCKLWu74ULQFM7wjxLlDhvRxhdNNDdRL4B9Q7pMiduht7GDs37yU9vqIIRPly6GoxQTYxQo/2iR24+0GRY4Df78zeTlwzSKeXrsBl8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156597; c=relaxed/simple;
	bh=U2NeIRFaQ3Zq0bn+PGdbije6ufeaFsRzIb+El2Dmm70=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ud0CMyfad4NwmDNhxXumKjpYkwsfnLvmMgEJNO8YopPrMlAdnwSrL30P4tfnAT2QbtH739rj+EwxwTShA+ZAMXHccnqsIKwrpMOrQ22Vo0+7SQ69RwMdG6ZGQkkrcWPweO/zJvHioFouaMJwEmzTGSGfuOjs1nlojnlwYTn52HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7SDxHg1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c61dee98720so3636718a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156595; x=1770761395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7JJwhexRKvGqKj8BmK4wLoDK8FPsWDJ7kCbEwN39qlQ=;
        b=X7SDxHg1hJz1i1K7/DGmt3D3V53aYOQ+7PoUFFv7giIT7gIphjv9b2zDeC1alQyfgp
         WfmeIIka5TQk7PzXmr2m7z1UlVxHkX+YoXbQQ8WBSxNNc6Wjege7+lVhf0vUwNRjedp3
         0YevDou1ye9dVBobaIn0YMtLSI4QERzhgbbB+BcqAEFb3YJkzV1va5JHSWp75jW7HQ93
         fT4A58apSzJsf48eQn3AWjr9UfxVvh/xxnj5zqaf5cgf8zTeYt3HGj5UnbmGY5p3c6kU
         dfBy5C0m1BtU/6LLU/6iDupzCLYb9v0abGSGxkqps0QuKZhSJJuA8zYC33lA8MOi02Bk
         01sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156595; x=1770761395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JJwhexRKvGqKj8BmK4wLoDK8FPsWDJ7kCbEwN39qlQ=;
        b=wYMr/dOTnrbTBa+YP1TcDqZx81LnGK5qQYEoqlyrvTHVwBeHVWK41W+8ucpY3s28r0
         2eS4XhdjGtRpGadU2vOtzWRLYIdMpUulQHX6Nm9HMwrPSCjKEijacmBj8iPxujPwtfXG
         eWiiSOph94PI4j5kZKvp4mPuYYJupEc1vhkPrGLnT9X2oCsmPGTAC/6i2bQCs+jwpva4
         db7XMsZMjOh0Ih5NiJfd6Rdo0XJwjrQBfoHHgaggxNKTHsQiw/PUSa/vKqozsO3PxkHA
         5OJ2jfKEf5VilBLS+A4t1sHXIgstqASpk9VnjrM2ZdGeGPOlE39DZW8jAL9hiz1pdR2l
         vzIA==
X-Forwarded-Encrypted: i=1; AJvYcCVtqMGsZv3NzsUXmah9RoUpywIAgBovf1DhHrP7uJpKYZQsVjl4HjNfsnmf+A5zrVb2wKc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp1LxRol/H6CRS4HqZxR3NJ5GUh3QImcau60tZGPYb6VPXjKAX
	4YCyl4fdcWZ2q5tMla7H6PDrTeUixSEfFO8dxbcJTDIuF23cCmyS1kZRYSeYSXtDFYsrtWMwe+q
	NN7BJAIyxhaEJng==
X-Received: from pgbdv5.prod.google.com ([2002:a05:6a02:4465:b0:c65:e24e:cef1])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6b85:b0:364:be7:6ffc with SMTP id adf61e73a8af0-393720db58dmr925648637.18.1770156595253;
 Tue, 03 Feb 2026 14:09:55 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:37 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-4-skhawaja@google.com>
Subject: [PATCH 03/14] liveupdate: luo_file: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70096-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[soleen.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EE6D4DF1C0
X-Rspamd-Action: no action

From: Pasha Tatashin <pasha.tatashin@soleen.com>

The core liveupdate mechanism allows userspace to preserve file
descriptors. However, kernel subsystems often manage struct file
objects directly and need to participate in the preservation process
programmatically without relying solely on userspace interaction.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       | 21 ++++++++++
 kernel/liveupdate/luo_file.c     | 71 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 16 +++++++
 3 files changed, 108 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index fe82a6c3005f..8e47504ba01e 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -23,6 +23,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
+ * @session:          The session this file belongs to.
  * @retrieved:        The retrieve status for the 'can_finish / finish'
  *                    operation.
  * @file:             The file object. For retrieve: [OUT] The callback sets
@@ -40,6 +41,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
+	struct liveupdate_session *session;
 	bool retrieved;
 	struct file *file;
 	u64 serialized_data;
@@ -234,6 +236,13 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
+/* kernel can internally retrieve files */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep);
+
+/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -281,5 +290,17 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
+					       u64 token, struct file **filep)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+						struct file *file, u64 *tokenp)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 32759e846bc9..7ac591542059 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -302,6 +302,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -355,6 +356,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -383,6 +385,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -404,6 +407,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -590,6 +594,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (!err) {
@@ -615,6 +620,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieved = luo_file->retrieved;
@@ -632,6 +638,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieved = luo_file->retrieved;
@@ -919,3 +926,67 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	return err;
 }
 EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
+
+/**
+ * liveupdate_get_token_outgoing - Get the token for a preserved file.
+ * @s:      The outgoing liveupdate session.
+ * @file:   The file object to search for.
+ * @tokenp: Output parameter for the found token.
+ *
+ * Searches the list of preserved files in an outgoing session for a matching
+ * file object. If found, the corresponding user-provided token is returned.
+ *
+ * This function is intended for in-kernel callers that need to correlate a
+ * file with its liveupdate token.
+ *
+ * Context: Can be called from any context that can acquire the session mutex.
+ * Return: 0 on success, -ENOENT if the file is not preserved in this session.
+ */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp)
+{
+	struct luo_file_set *file_set = luo_file_set_from_session(s);
+	struct luo_file *luo_file;
+	int err = -ENOENT;
+
+	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		if (luo_file->file == file) {
+			if (tokenp)
+				*tokenp = luo_file->token;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
+ * @s:      The incoming liveupdate session (restored from the previous kernel).
+ * @token:  The unique token identifying the file to retrieve.
+ * @filep:  On success, this will be populated with a pointer to the retrieved
+ *          'struct file'.
+ *
+ * Provides a kernel-internal API for other subsystems to retrieve their
+ * preserved files after a live update. This function is a simple wrapper
+ * around luo_retrieve_file(), allowing callers to find a file by its token.
+ *
+ * The operation is idempotent; subsequent calls for the same token will return
+ * a pointer to the same 'struct file' object.
+ *
+ * The caller receives a new reference to the file and must call fput() when it
+ * is no longer needed. The file's lifetime is managed by LUO and any userspace
+ * file descriptors. If the caller needs to hold a reference to the file beyond
+ * the immediate scope, it must call get_file() itself.
+ *
+ * Context: Can be called from any context in the new kernel that has a handle
+ *          to a restored session.
+ * Return: 0 on success. Returns -ENOENT if no file with the matching token is
+ *         found, or any other negative errno on failure.
+ */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep)
+{
+	return luo_retrieve_file(luo_file_set_from_session(s), token, filep);
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..a24933d24fd9 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,22 @@ struct luo_session {
 	struct mutex mutex;
 };
 
+static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
+{
+	struct luo_session *session;
+
+	session = container_of(file_set, struct luo_session, file_set);
+
+	return (struct liveupdate_session *)session;
+}
+
+static inline struct luo_file_set *luo_file_set_from_session(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	return &session->file_set;
+}
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


