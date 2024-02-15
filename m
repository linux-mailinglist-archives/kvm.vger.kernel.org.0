Return-Path: <kvm+bounces-8838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1347857206
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024411C22930
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94211146902;
	Thu, 15 Feb 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wf3NszRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A6E14601C
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041258; cv=none; b=NLsNQVw+4xodDL/wU2r3a4hHdUdPEYsGRsc5OaBOsF0fszTQq+cicQchCUQG5xHmV+JhSullA9UElRk8us7ZDILwBSsvakOqxZ3+ZocWosb+QmQ+ik3q3m8T5xUMV4lrmfqVNy72+1dYTDVnKyaXmoXNKasdp0NsVoy8tzj8dTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041258; c=relaxed/simple;
	bh=Cgdei//BJ4TfS7THt3BBXytD0NBWfYjOmDteYlMCj40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gdd+ARoK4NQ/WrEArkByNCHZ2IquyBiA5x8GVOeO7xQovHOv+MDbiGKI3r0ywPVrp8ai9oor6VybPoWfPAjbndbbnSIHwJheVsn3OG4fGdJ3eu1IvO+WslswZ8OYFzgXTliAqv/DBOG32Dk/E9RJF8bhW/+iiq5/SXDd48LpSwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wf3NszRU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ffee6fcdc1so2803067b3.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041256; x=1708646056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/E37B8pEtQeUXPVkKOjh16ZsPiNTw6lyoy6KXMrnX4=;
        b=Wf3NszRUefVYQL46yUGzTkb9MQvbFqmCr/nbAcx3ymu195JE6mSOQ5juOuypaTcUGj
         3aDAeHG96ydtNFayyPQ1HY5UF4TRW3RSNDQ3O0sjgPCZaJgM3WBm5tRmLyIa4g5aXRH6
         U6z5fe9iJgYoccEeVvwS/19raoPDeHX7lvGNNtx2BYVEVEsANUvQOWsKxgwkrtv3xwAY
         N+iXuFjLJlGsfD9/x/qQ2pFrmCQoW8Qvb1hZRQOvA70FSEkmi9ETTH5RDnp0DJ+DElCs
         Neowr4Kj2fJrrQQyzgUqjMLnjKuKyD6hnMqyJJg4z9oXUM+FugF+Xra/2dpcjfJpWWOq
         ppBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041256; x=1708646056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/E37B8pEtQeUXPVkKOjh16ZsPiNTw6lyoy6KXMrnX4=;
        b=X2mbVeaIIPQBSG/jqlCNqRt6fh1s7ZXebx3b2zXYTPO203h+WVpexXE3vFTTTgaD98
         PdkTVfLSB2ylB8Kq/GUlAifz4yrF9cqdmRo1uoBxjFmSU7Y3tUpetGEY7aCHC8f+aNAZ
         uQZ1yHIDI43wCc513ymeubxiCFGMYqw1Nf5HTsMoAPuQnQ3TAAOAKMjYNppRXDKpEgPF
         oADNZcwCEGBacvBSgD8IHHtdrkEA1yczZhRArcHEhiZC9VT1mzmNVsBwcWOZ6MOXcbgr
         N7ZtbD/A5g/FHbzgBTFTBkB2jGinrcReVnnf73IGj6l0L9CaZ1mEqbTFXtAL96Pme/es
         6PQg==
X-Forwarded-Encrypted: i=1; AJvYcCXE5BciTqRD2QcQ/MJ6WnroKwdaPlaJ95w5911DkyxbHMMR6nrDyQ6m9CwHC58UjID1Sh0R4Mv8XsRT3epvBEOKuEwM
X-Gm-Message-State: AOJu0YxJzsd0LX4pPCuo6suJHOdoLhGh+nuTdWgpKUtGpNfNaEP+x50d
	GoGXvWsnNZkX5WVEuCSxqOp0LPykUiyfyKUNlxCbTcF82fUSyCMhZT7YVIUSPRaxXB+PtAMvjK1
	8yOIPy3PlAg==
X-Google-Smtp-Source: AGHT+IHedA2uvd08JONpyjwItnwJE43l4fF1/9gQHix0D/EhvKZ7QtfHgjYc9NTkUnT48me3Qd8VZVAkzw6WqA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ad8e:0:b0:dc7:63e7:7a5c with SMTP id
 z14-20020a25ad8e000000b00dc763e77a5cmr197747ybi.11.1708041256253; Thu, 15 Feb
 2024 15:54:16 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:56 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-6-amoorthy@google.com>
Subject: [PATCH v7 05/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

kvm_prepare_memory_fault_exit() already takes parameters describing the
RWX-ness of the relevant access but doesn't actually do anything with
them. Define and use the flags necessary to pass this information on to
userspace.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++++
 include/linux/kvm_host.h       | 9 ++++++++-
 include/uapi/linux/kvm.h       | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8f75fca2294e..9f5d45c49e36 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6964,6 +6964,9 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+  #define KVM_MEMORY_EXIT_FLAG_READ     (1ULL << 0)
+  #define KVM_MEMORY_EXIT_FLAG_WRITE    (1ULL << 1)
+  #define KVM_MEMORY_EXIT_FLAG_EXEC     (1ULL << 2)
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
@@ -6975,6 +6978,8 @@ could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
 guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
+ - KVM_MEMORY_EXIT_FLAG_READ/WRITE/EXEC - When set, indicates that the memory
+   fault occurred on a read/write/exec access respectively.
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..32cbe5c3a9d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2343,8 +2343,15 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.gpa = gpa;
 	vcpu->run->memory_fault.size = size;
 
-	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
+
+	if (is_write)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_WRITE;
+	else if (is_exec)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_EXEC;
+	else
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_READ;
+
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..36a51b162a71 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -428,6 +428,9 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+#define KVM_MEMORY_EXIT_FLAG_READ       (1ULL << 0)
+#define KVM_MEMORY_EXIT_FLAG_WRITE      (1ULL << 1)
+#define KVM_MEMORY_EXIT_FLAG_EXEC       (1ULL << 2)
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
-- 
2.44.0.rc0.258.g7320e95886-goog


