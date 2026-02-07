Return-Path: <kvm+bounces-70538-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPJvHo67hmkEQgQAu9opvQ
	(envelope-from <kvm+bounces-70538-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B99104D77
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1AC03064E94
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8EE33E353;
	Sat,  7 Feb 2026 04:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBAn8w8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D324A3385A5
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437419; cv=none; b=ARW0IsZds8DPh0vOhYIHt5nMxGMGPqmO62QD4rrJ1nD+oOcns5WS/kzmeyMjlqQupU2jsaw8NIMqgPCVAPl/jKkrXnF4w3wCzqZRaRmmO/wjPPEVFyB+9QZe+fPc+WYvBWAmrn9ZXrhaNY8ubiIOjE1oZFYZVbPKGneRFihwchk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437419; c=relaxed/simple;
	bh=ICq9z5wZm/HHfA3UeX2OlHXVs+Q68enXaSQlZD5Ewes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UAZiKBC1LRUe429NIag/Erbdj8Aj+Hw5MgGQcbPG7QMMTuL1ztcXrUZVNeaNCnowp17bH4NEpxRCMmv131OvBaL8XXbUJGxBPMnXTHEhmuSB90THQVeU2gm78g/L9SGEwuZTwFRUynW6rpdA65RL5H+iNtoUp7DHyqh6gl07IbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBAn8w8Q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337cde7e40so1724449a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437419; x=1771042219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cEIeP+OOJrdocngptUX72ejpUt7qJfQ0ZWyP5pIkCBs=;
        b=MBAn8w8QYxNPjda6k3i8BxhdCmuG4S3CUjn8a5gr+5c3eZALyXsOA5uvmlt2hTZZ2r
         L/JoMVtVCdQvBxbotqfVIsYwBhe6x+HqLqE52XtpYyz3mASoewp3GLzF1h7B0xGqAk5E
         R8fWTYetuDblIhN3g/XuiWC6lhlhPvbP1b0fs3E/5W3VJsB1E6BhrWsVvfV6bBHIhX8O
         aZfTrNQr05PxTTT76Mcsks2pQW7O3HQ+RYaQ3aXQtatzFWjvzGYD+N130VgGv66BOBQS
         vhIyPqHfFyhf90yw0mHX/XmjY0llEWyi9BzhUqMG8Lt4G05ihAsivqAC+izgKbtJpU5J
         1DLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437419; x=1771042219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEIeP+OOJrdocngptUX72ejpUt7qJfQ0ZWyP5pIkCBs=;
        b=VbsmV0T/4CVHB2n/ggGx3q74zfU8Je94YObbceD+tLVEjNd5qtaPAm1/ekGyq+QKsH
         745tKIc7u10Rpwx7C0032omCR6D6Nvn7pTrFRIZa3mrIEhXEUd8nApSEdNUU5IQvibvx
         o6XgLdu7Vp8KhRB81ApHJvVrcsYscKUXUoPwuCYdKwpn9r+SJzeYlEffQxzrn/iSbJvU
         f0hPtgz5AJawF7Ot5qlKtyiUIAZCMIPPjiML9ecrTOsQRLJoOJvmvIUOrxMKP16c5/Nu
         HszOZxOTAzmDA8+jxPDGjgAFA5jAps0UwVm2hPzAYrZv9VF9iPs1Rx9SmP6GQdZtsQr2
         LDtQ==
X-Gm-Message-State: AOJu0Yz2zxccb/sgJ/z7GQrsNZE4gHiuCk8vy7RhBqRCDlQN3tyD702Z
	HVBP5KuhfLNqIRTbJF2cQJPn8DcpcLoe9s2TbvZ0cK1WbxJUaXTYPy0G5a1EdMqNHMTDbrg+R69
	QUjtUWw==
X-Received: from pjblw12.prod.google.com ([2002:a17:90b:180c:b0:354:bd6f:c03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734c:b0:35f:5896:85a4
 with SMTP id adf61e73a8af0-393acf885b1mr5258839637.5.1770437419284; Fri, 06
 Feb 2026 20:10:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:05 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-4-seanjc@google.com>
Subject: [GIT PULL] KVM: guest_memfd changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70538-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 24B99104D77
X-Rspamd-Action: no action

In preparation (pun intended) for in-place conversion, drop gmem's preparation
tracking, GUP source pages outside of filemap invalidate lock to avoid AB-BA
locking, and require source pages to be 4KiB aligned.

Regarding the retroactive alignment requirement, I know we discussed it in PUCK,
but I forget if we ever formalized a decision there.  After going over various
VMMs, we gained enough confidence to just bite the bullet and hope for the best.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-gmem-6.20

for you to fetch changes up to 2a62345b30529e488beb6a1220577b3495933724:

  KVM: guest_memfd: GUP source pages prior to populating guest memory (2026-01-15 12:31:17 -0800)

----------------------------------------------------------------
KVM guest_memfd changes for 6.20

 - Remove kvm_gmem_populate()'s preparation tracking and half-baked hugepage
   handling, and instead rely on SNP (the only user of the tracking) to do its
   own tracking via the RMP.

 - Retroactively document and enforce (for SNP) that KVM_SEV_SNP_LAUNCH_UPDATE
   and KVM_TDX_INIT_MEM_REGION require the source page to be 4KiB aligned, to
   avoid non-trivial complexity for a non-existent usecase (and because
   in-place conversion simply can't support unaligned sources).

 - When populating guest_memfd memory, GUP the source page in common code and
   pass the refcounted page to the vendor callback, instead of letting vendor
   code do the heavy lifting.  Doing so avoids a looming deadlock bug with
   in-place due an AB-BA conflict betwee mmap_lock and guest_memfd's filemap
   invalidate lock.

----------------------------------------------------------------
Michael Roth (5):
      KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      KVM: guest_memfd: Remove preparation tracking
      KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: GUP source pages prior to populating guest memory

Yan Zhao (1):
      KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()

 .../virt/kvm/x86/amd-memory-encryption.rst         |   2 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   2 +-
 arch/x86/kvm/svm/sev.c                             | 108 +++++++---------
 arch/x86/kvm/vmx/tdx.c                             |  16 +--
 include/linux/kvm_host.h                           |   4 +-
 virt/kvm/guest_memfd.c                             | 139 +++++++++++----------
 6 files changed, 130 insertions(+), 141 deletions(-)

