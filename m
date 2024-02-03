Return-Path: <kvm+bounces-7877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEF9847D8C
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:10:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 542941F2D399
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3829E6FBE;
	Sat,  3 Feb 2024 00:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cK2RC+av"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702AD1FAD
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918967; cv=none; b=ebJebhaUhdWx6jRA9xnspAaE/OKoqTzPoK9WNrFIX2h5SYhW6+pG81zoeC+lapoaxjwKUKrvrOTG+I3D8VOfjNh9JvBltIdg0rowg5clBjLMAyfcHwENA2vzixudPB20C5cXoWmjR6BoAFAWNWLq4hiy22dNvUS9Ul5fwFBMbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918967; c=relaxed/simple;
	bh=CNPk1afhnBjcfCeKhJ+dXXQAMfAeimm4XlBq2aq6RHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j1CKuEAELfF96atnuF/5GO/ldfRV7AoV1kAnYefy0O2wyacH8K2XdtOXuRqLvdavJyYIddimuzZbvz+abDMDIEJHYbG424ithrX9n1Hmm6I9+0A4DJ6e9quRaPnpoXHn4hkvXBIo47PbvB2dTQ0uU33ci1H7M3lWsQb/Royg6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cK2RC+av; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d5a080baf1so3012187a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918965; x=1707523765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fg/vqH030f9YZARetCg5UZ+D2wOsplctpRVUYVfmsZ0=;
        b=cK2RC+avJAJ9jOkjhYkgaGPwauQ9rNIT7+b4lLLqyTyDYkgVBM2xqSDpE9OXH5bJgy
         SR2p+BFGQPaS1svOYUrk9Im3R3/p2h04PXTlx56tom05gPAcV7MCefxNAAQZioDZlFKj
         H23/DBtfZqWbZJATe6fDsjVzKsmSa3sBNZJJpNLGvnrK6f/TgD4U/lTN5q7msnt8n7pK
         YX0AkwK3MHkP6GJcqDgWoAp0HgICmc9fIptRjN1lpAGu8s5+9rtakwVkyXt9PR9jyoTB
         djlM7b0MNylgEEOFwlZejT3/Qo0/Bv420VVTn0bC8fHsmIgyKB1ucDtohxcLGQWFpUB7
         7gCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918965; x=1707523765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fg/vqH030f9YZARetCg5UZ+D2wOsplctpRVUYVfmsZ0=;
        b=d6B15G8fbD7Y1cQpbogYQYQq0qCX1Zgj0IOKTSBx1rOED/HYRpF5rFW+rNlBHG7hHR
         4NM1/+VUQ+LRncIu9iIsfpuL3g2w3RIi47sE7PoKC/drtgiNLWO7NydcsNcEz31dbSDx
         BBzecKQNXrea2Hj33+ZsvDfBZKp5GS/mw8Zt+pU+bK7fDtgl0yvVDKpF8yDNqB9Uty2l
         /bbBY/REbaT4iDUraCktw5ODGPo59JmHaeNgFkdQji9p0mCPiI4YWEiXNcEUMmZf6zPC
         YcupGOvd3jQoVAd5De0A7egF0mm3GG2hU4NPFFxKwKIMNHuDAyIOGZIGWuGcQbzw9tnK
         bsPQ==
X-Gm-Message-State: AOJu0YyselS+ih+/jwF1aZp6tjLyltyFeASeVjd/MGr29VtmtUnKgi8v
	/rx/oCALmAO1y24BK5ARRmsj3jkC/micOgTyXaidnFzrZJd1hZMPrawFnDWdYcIHybXCiBhE2+U
	7YQ==
X-Google-Smtp-Source: AGHT+IGM9HGyUUoLJfu31MYrwpoT/03aGaAM8UVTlWmMdWn4RNq+59MKCFyERKnp3/HUc35fvBADh6Lb6+Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c4:b0:1d9:697d:6817 with SMTP id
 o4-20020a170902d4c400b001d9697d6817mr174835plg.1.1706918964815; Fri, 02 Feb
 2024 16:09:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:08 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-3-seanjc@google.com>
Subject: [PATCH v8 02/10] KVM: selftests: Make sparsebit structs const where appropriate
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Michael Roth <michael.roth@amd.com>

Make all sparsebit struct pointers "const" where appropriate.  This will
allow adding a bitmap to track protected/encrypted physical memory that
tests can access in a read-only fashion.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/sparsebit.h | 36 +++++++-------
 tools/testing/selftests/kvm/lib/sparsebit.c   | 48 +++++++++----------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index 12a9a4b9cead..fb5170d57fcb 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -30,26 +30,26 @@ typedef uint64_t sparsebit_num_t;
 
 struct sparsebit *sparsebit_alloc(void);
 void sparsebit_free(struct sparsebit **sbitp);
-void sparsebit_copy(struct sparsebit *dstp, struct sparsebit *src);
+void sparsebit_copy(struct sparsebit *dstp, const struct sparsebit *src);
 
-bool sparsebit_is_set(struct sparsebit *sbit, sparsebit_idx_t idx);
-bool sparsebit_is_set_num(struct sparsebit *sbit,
+bool sparsebit_is_set(const struct sparsebit *sbit, sparsebit_idx_t idx);
+bool sparsebit_is_set_num(const struct sparsebit *sbit,
 			  sparsebit_idx_t idx, sparsebit_num_t num);
-bool sparsebit_is_clear(struct sparsebit *sbit, sparsebit_idx_t idx);
-bool sparsebit_is_clear_num(struct sparsebit *sbit,
+bool sparsebit_is_clear(const struct sparsebit *sbit, sparsebit_idx_t idx);
+bool sparsebit_is_clear_num(const struct sparsebit *sbit,
 			    sparsebit_idx_t idx, sparsebit_num_t num);
-sparsebit_num_t sparsebit_num_set(struct sparsebit *sbit);
-bool sparsebit_any_set(struct sparsebit *sbit);
-bool sparsebit_any_clear(struct sparsebit *sbit);
-bool sparsebit_all_set(struct sparsebit *sbit);
-bool sparsebit_all_clear(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_first_set(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_first_clear(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_next_set(struct sparsebit *sbit, sparsebit_idx_t prev);
-sparsebit_idx_t sparsebit_next_clear(struct sparsebit *sbit, sparsebit_idx_t prev);
-sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *sbit,
+sparsebit_num_t sparsebit_num_set(const struct sparsebit *sbit);
+bool sparsebit_any_set(const struct sparsebit *sbit);
+bool sparsebit_any_clear(const struct sparsebit *sbit);
+bool sparsebit_all_set(const struct sparsebit *sbit);
+bool sparsebit_all_clear(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_first_set(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_first_clear(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_next_set(const struct sparsebit *sbit, sparsebit_idx_t prev);
+sparsebit_idx_t sparsebit_next_clear(const struct sparsebit *sbit, sparsebit_idx_t prev);
+sparsebit_idx_t sparsebit_next_set_num(const struct sparsebit *sbit,
 				       sparsebit_idx_t start, sparsebit_num_t num);
-sparsebit_idx_t sparsebit_next_clear_num(struct sparsebit *sbit,
+sparsebit_idx_t sparsebit_next_clear_num(const struct sparsebit *sbit,
 					 sparsebit_idx_t start, sparsebit_num_t num);
 
 void sparsebit_set(struct sparsebit *sbitp, sparsebit_idx_t idx);
@@ -62,9 +62,9 @@ void sparsebit_clear_num(struct sparsebit *sbitp,
 			 sparsebit_idx_t start, sparsebit_num_t num);
 void sparsebit_clear_all(struct sparsebit *sbitp);
 
-void sparsebit_dump(FILE *stream, struct sparsebit *sbit,
+void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
 		    unsigned int indent);
-void sparsebit_validate_internal(struct sparsebit *sbit);
+void sparsebit_validate_internal(const struct sparsebit *sbit);
 
 #ifdef __cplusplus
 }
diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index 88cb6b84e6f3..cfed9d26cc71 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -202,7 +202,7 @@ static sparsebit_num_t node_num_set(struct node *nodep)
 /* Returns a pointer to the node that describes the
  * lowest bit index.
  */
-static struct node *node_first(struct sparsebit *s)
+static struct node *node_first(const struct sparsebit *s)
 {
 	struct node *nodep;
 
@@ -216,7 +216,7 @@ static struct node *node_first(struct sparsebit *s)
  * lowest bit index > the index of the node pointed to by np.
  * Returns NULL if no node with a higher index exists.
  */
-static struct node *node_next(struct sparsebit *s, struct node *np)
+static struct node *node_next(const struct sparsebit *s, struct node *np)
 {
 	struct node *nodep = np;
 
@@ -244,7 +244,7 @@ static struct node *node_next(struct sparsebit *s, struct node *np)
  * highest index < the index of the node pointed to by np.
  * Returns NULL if no node with a lower index exists.
  */
-static struct node *node_prev(struct sparsebit *s, struct node *np)
+static struct node *node_prev(const struct sparsebit *s, struct node *np)
 {
 	struct node *nodep = np;
 
@@ -273,7 +273,7 @@ static struct node *node_prev(struct sparsebit *s, struct node *np)
  * subtree and duplicates the bit settings to the newly allocated nodes.
  * Returns the newly allocated copy of subtree.
  */
-static struct node *node_copy_subtree(struct node *subtree)
+static struct node *node_copy_subtree(const struct node *subtree)
 {
 	struct node *root;
 
@@ -307,7 +307,7 @@ static struct node *node_copy_subtree(struct node *subtree)
  * index is within the bits described by the mask bits or the number of
  * contiguous bits set after the mask.  Returns NULL if there is no such node.
  */
-static struct node *node_find(struct sparsebit *s, sparsebit_idx_t idx)
+static struct node *node_find(const struct sparsebit *s, sparsebit_idx_t idx)
 {
 	struct node *nodep;
 
@@ -393,7 +393,7 @@ static struct node *node_add(struct sparsebit *s, sparsebit_idx_t idx)
 }
 
 /* Returns whether all the bits in the sparsebit array are set.  */
-bool sparsebit_all_set(struct sparsebit *s)
+bool sparsebit_all_set(const struct sparsebit *s)
 {
 	/*
 	 * If any nodes there must be at least one bit set.  Only case
@@ -775,7 +775,7 @@ static void node_reduce(struct sparsebit *s, struct node *nodep)
 /* Returns whether the bit at the index given by idx, within the
  * sparsebit array is set or not.
  */
-bool sparsebit_is_set(struct sparsebit *s, sparsebit_idx_t idx)
+bool sparsebit_is_set(const struct sparsebit *s, sparsebit_idx_t idx)
 {
 	struct node *nodep;
 
@@ -921,7 +921,7 @@ static inline sparsebit_idx_t node_first_clear(struct node *nodep, int start)
  * used by test cases after they detect an unexpected condition, as a means
  * to capture diagnostic information.
  */
-static void sparsebit_dump_internal(FILE *stream, struct sparsebit *s,
+static void sparsebit_dump_internal(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	/* Dump the contents of s */
@@ -969,7 +969,7 @@ void sparsebit_free(struct sparsebit **sbitp)
  * sparsebit_alloc().  It can though already have bits set, which
  * if different from src will be cleared.
  */
-void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
+void sparsebit_copy(struct sparsebit *d, const struct sparsebit *s)
 {
 	/* First clear any bits already set in the destination */
 	sparsebit_clear_all(d);
@@ -981,7 +981,7 @@ void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
 }
 
 /* Returns whether num consecutive bits starting at idx are all set.  */
-bool sparsebit_is_set_num(struct sparsebit *s,
+bool sparsebit_is_set_num(const struct sparsebit *s,
 	sparsebit_idx_t idx, sparsebit_num_t num)
 {
 	sparsebit_idx_t next_cleared;
@@ -1005,14 +1005,14 @@ bool sparsebit_is_set_num(struct sparsebit *s,
 }
 
 /* Returns whether the bit at the index given by idx.  */
-bool sparsebit_is_clear(struct sparsebit *s,
+bool sparsebit_is_clear(const struct sparsebit *s,
 	sparsebit_idx_t idx)
 {
 	return !sparsebit_is_set(s, idx);
 }
 
 /* Returns whether num consecutive bits starting at idx are all cleared.  */
-bool sparsebit_is_clear_num(struct sparsebit *s,
+bool sparsebit_is_clear_num(const struct sparsebit *s,
 	sparsebit_idx_t idx, sparsebit_num_t num)
 {
 	sparsebit_idx_t next_set;
@@ -1041,13 +1041,13 @@ bool sparsebit_is_clear_num(struct sparsebit *s,
  * value.  Use sparsebit_any_set(), instead of sparsebit_num_set() > 0,
  * to determine if the sparsebit array has any bits set.
  */
-sparsebit_num_t sparsebit_num_set(struct sparsebit *s)
+sparsebit_num_t sparsebit_num_set(const struct sparsebit *s)
 {
 	return s->num_set;
 }
 
 /* Returns whether any bit is set in the sparsebit array.  */
-bool sparsebit_any_set(struct sparsebit *s)
+bool sparsebit_any_set(const struct sparsebit *s)
 {
 	/*
 	 * Nodes only describe set bits.  If any nodes then there
@@ -1070,20 +1070,20 @@ bool sparsebit_any_set(struct sparsebit *s)
 }
 
 /* Returns whether all the bits in the sparsebit array are cleared.  */
-bool sparsebit_all_clear(struct sparsebit *s)
+bool sparsebit_all_clear(const struct sparsebit *s)
 {
 	return !sparsebit_any_set(s);
 }
 
 /* Returns whether all the bits in the sparsebit array are set.  */
-bool sparsebit_any_clear(struct sparsebit *s)
+bool sparsebit_any_clear(const struct sparsebit *s)
 {
 	return !sparsebit_all_set(s);
 }
 
 /* Returns the index of the first set bit.  Abort if no bits are set.
  */
-sparsebit_idx_t sparsebit_first_set(struct sparsebit *s)
+sparsebit_idx_t sparsebit_first_set(const struct sparsebit *s)
 {
 	struct node *nodep;
 
@@ -1097,7 +1097,7 @@ sparsebit_idx_t sparsebit_first_set(struct sparsebit *s)
 /* Returns the index of the first cleared bit.  Abort if
  * no bits are cleared.
  */
-sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
+sparsebit_idx_t sparsebit_first_clear(const struct sparsebit *s)
 {
 	struct node *nodep1, *nodep2;
 
@@ -1151,7 +1151,7 @@ sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
 /* Returns index of next bit set within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are set.
  */
-sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1244,7 +1244,7 @@ sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
 /* Returns index of next bit cleared within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are cleared.
  */
-sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1300,7 +1300,7 @@ sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively set
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1335,7 +1335,7 @@ sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively cleared
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_clear_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1583,7 +1583,7 @@ static size_t display_range(FILE *stream, sparsebit_idx_t low,
  * contiguous bits.  This is done because '-' is used to specify command-line
  * options, and sometimes ranges are specified as command-line arguments.
  */
-void sparsebit_dump(FILE *stream, struct sparsebit *s,
+void sparsebit_dump(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	size_t current_line_len = 0;
@@ -1681,7 +1681,7 @@ void sparsebit_dump(FILE *stream, struct sparsebit *s,
  * s.  On error, diagnostic information is printed to stderr and
  * abort is called.
  */
-void sparsebit_validate_internal(struct sparsebit *s)
+void sparsebit_validate_internal(const struct sparsebit *s)
 {
 	bool error_detected = false;
 	struct node *nodep, *prev = NULL;
-- 
2.43.0.594.gd9cf4e227d-goog


