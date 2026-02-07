Return-Path: <kvm+bounces-70541-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBPYD1e7hmkNQgQAu9opvQ
	(envelope-from <kvm+bounces-70541-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E1E104D53
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E3D8F300E476
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD6A33F8C6;
	Sat,  7 Feb 2026 04:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5uvnI1g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3233F383
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437429; cv=none; b=DN5buYIeIiw+CKTOVwCC60ajLEZPbQW2k5XB6HohoEfy8CFuTuZx53SSpoFe6xHXGjLOVopqTEmCeuzpvPpEfMlJU/39bpkRmkfYFkQZu/T1vDupZ/Is2jE+z7OccGsxoUko3npM/0CrzMB5XkXtf5Vap5igbP7Lns/S3nVxa8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437429; c=relaxed/simple;
	bh=P4Sa7dZb1Nfom/LISSVzZfbMBXyCEFM6fHdjKFn3t+w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MR/+h8TdlCQBirorFBvO6fUw1xBVsfywCJeuHk7ELJi2ExAUIPdI5oSL47BLQOIxJfDbFrp0JaRoYJpy0WgcXO2qelTSC+5okWIZLce5F2QtgMUZlS3We5Aihxys63UDEL8nqA9nMxoxk3dywLJCYJQO2EVQUCdx7fZI4Z9BLs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M5uvnI1g; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82436a49592so1427104b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437428; x=1771042228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VlNioCvIfIQZRS3oCEYLN5B7K+bIa2/hrm7ZFysFPQo=;
        b=M5uvnI1gU2nSN8rKc9QQLLT9FC3jZRAjnyDOealuZ9Mr2q2sm838bpau4rNeDoz5NJ
         rf0nIyrFBpbFVT43v/L8zwHQ1xW9K6OppxOqO92xyCz5pSo1t52B0s1Tl6xrWbw66jSy
         P8AAQMZ13IdYwLNy5Pai5EpbbDS5NV9itoq5Mo7P1nvruzYGwX7mxNVFevFy7mEMtMcM
         xLMK9bfe3fvRSroaPhbDhbtYT7Sxf6+eqNIwzJFNV+4tZd8zVzOKTJEe+/QugVDPGAVs
         wWbiXy69qCHjPZr7p8GJvBVk3FqNbUaT89zh2tMZHJzt7PwGvWxToLbwSY2OwKyHyvYM
         la0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437428; x=1771042228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlNioCvIfIQZRS3oCEYLN5B7K+bIa2/hrm7ZFysFPQo=;
        b=GyJiM53it5gpkqATovdQS9gPc/ovSB+RZbPjy6wOEg1Q756e5+Iwz6PInU98+gXyVw
         2o7dxlrruKCRPRa5r+tU0HjO1rMJAyG4O7p8Lft5QytlDUlRxurDY/kPDZN1UPhP1ybF
         RNh0ItOdiPU9W5z+pCayl2Vm/cCEph2rtiJmndaPMNN0V/PtQEP0eccYtlCGTPfpYPnW
         HGyOXp9QDFJep8OZ+uMNrFRlDw7jcYPElPWZ0J8nxLzL270IWRq3U2bsFURlW5EV7c9b
         5H8i5Jbsd+nJJcMme+oqQl4TwLHSDr2JQJsVyGz0KICqnl0ab/BBs+Xg0Jlv58Scqw6i
         Rp6w==
X-Gm-Message-State: AOJu0YyPlbVaeEbL+VS2fLmNq4G2X0ad9NNM5Uftyl7GxXz47fqRJRIP
	P2Uw4ac1qtfoQRdfSBECt0/0y2oCSHgDUDhqtx+/o63fyjHNt8mn0gBpMWSwK4e2h4phGJCcO96
	eUd9GNA==
X-Received: from pfbhj3.prod.google.com ([2002:a05:6a00:8703:b0:823:5939:cc60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:71c2:b0:824:40d8:9d68
 with SMTP id d2e1a72fcca58-824416efca2mr4000686b3a.32.1770437428265; Fri, 06
 Feb 2026 20:10:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:10 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-9-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.20
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70541-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 66E1E104D53
X-Rspamd-Action: no action

The bulk of the changes are to disallow access to vmcs12 fields that aren't
fully supported, so that we don't have to carry a bunch of isolated checks
for shadowed fields.   But for me, the highlight is to finally print out the
offending offsets+values on VMCS config mismatches.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.20

for you to fetch changes up to c0d6b8bbbced660e9c2efe079e2b2cb34b27d97f:

  KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch (2026-01-30 13:27:46 -0800)

----------------------------------------------------------------
KVM VMX changes for 6.20

 - Fix an SGX bug where KVM would incorrectly try to handle EPCM #PFs by always
   relecting EPCM #PFs back into the guest.  KVM doesn't shadow EPCM entries,
   and so EPCM violations cannot be due to KVM interference, and can't be
   resolved by KVM.

 - Fix a bug where KVM would register its posted interrupt wakeup handler even
   if loading kvm-intel.ko ultimately failed.

 - Disallow access to vmcb12 fields that aren't fully supported, mostly to
   avoid weirdness and complexity for FRED and other features, where KVM wants
   enable VMCS shadowing for fields that conditionally exist.

 - Print out the "bad" offsets and values if kvm-intel.ko refuses to load (or
   refuses to online a CPU) due to a VMCS config mismatch.

----------------------------------------------------------------
Hou Wenlong (1):
      KVM: VMX: Don't register posted interrupt wakeup handler if alloc_kvm_area() fails

Sean Christopherson (6):
      KVM: VMX: Always reflect SGX EPCM #PFs back into the guest
      KVM: nVMX: Setup VMX MSRs on loading CPU during nested_vmx_hardware_setup()
      KVM: VMX: Add a wrapper around ROL16() to get a vmcs12 from a field encoding
      KVM: nVMX: Disallow access to vmcs12 fields that aren't supported by "hardware"
      KVM: nVMX: Remove explicit filtering of GUEST_INTR_STATUS from shadow VMCS fields
      KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch

 arch/x86/kvm/vmx/hyperv_evmcs.c |  2 +-
 arch/x86/kvm/vmx/hyperv_evmcs.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 31 ++++++++-------
 arch/x86/kvm/vmx/vmcs.h         |  9 +++++
 arch/x86/kvm/vmx/vmcs12.c       | 74 +++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h       |  8 ++--
 arch/x86/kvm/vmx/vmx.c          | 86 ++++++++++++++++++++++++++++++++---------
 7 files changed, 171 insertions(+), 41 deletions(-)

