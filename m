Return-Path: <kvm+bounces-62356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD3BC418AB
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 422981882D0C
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4CA9309EF5;
	Fri,  7 Nov 2025 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R4N0PRgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BF4309DA0
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546319; cv=none; b=IKo2jgoFH6U/swd/OqMgtA7RnhBFTHsZsZEH+st2nXraG7Y832tZ5n939aIgfRGkKYoDbJdQohVZtmLMwLjqwE61zSBxTLB4OIj5iDpbqxE8X+ZgQKmLXSlLjs2nEB8CvcaAxhRw92lVMm0MdJWkkFSeSG2ue5pAHu20K13WssA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546319; c=relaxed/simple;
	bh=vu3UIZNsXZvEn3912xlHp6GrYHgg+le6ZZDu3A8AtYY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Bel/FftQ5rzedc4JKg3YEIhJA9OVXiZFbR1ifcU/n8tFcIei8cqqlakCRfiO1mWQDIlFRWijy5YAIKaH9HAK5JpRgjNi6PFBiD3RxdRxcqLMzVyKfsRJffM/YV1EyDbr2tkQ1pVHzOEnJjDVQ5WyQYaV2K03N3r2W6K9OnUSMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R4N0PRgx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5533921eb2so996363a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546317; x=1763151117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F64yYD+PzY/BVLq3NntjbsV9dJABC475STBHx/m6gwA=;
        b=R4N0PRgxuNAETJ2N72yFsoapiPo2d3hHlJ9txTO5N/vqidzbU0YBLFZJRzsFV3c+VR
         tODkdvr7pTqk4oWuotOUm2h+p83svsr9fesEA8FIbbTxygQtZNhmezpAsBH0jCRxEKKj
         +u4yRh7nnMNmAC8rRc7/VuPlwp22GMYFEpUXIIeQ8PBmjRR+s+6n9I2fS40nUmLUaTow
         JI+DHdWhYkjc0QoubgNAijL0AYARkO2zEGFhn6jWitkdL6QKSj92mjRIxujaMUrfP0yV
         4WoW0IlNt8JPaMawuc6tNNd5YymNK7p7TE3HHI5FjYGGpGH4zKFc3NksVxsAkgfvaj4Q
         FtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546317; x=1763151117;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F64yYD+PzY/BVLq3NntjbsV9dJABC475STBHx/m6gwA=;
        b=C7X+h/OYH3jQ5tPhljzzPG+d7MpaOsdu213cSiQxHZ1tV1OvVfaWJlSMrzXI9smEMB
         s/mp2dk+eXCMwE7ipc0vnp1r4kYZMHMiLn8ekSTwH+BEygTZaJUwOHwzjomAWjpRc8Rb
         vMMNbwEa231Qq49BX8gn1TW+9YiV8i0thXjBpyoqENVSYx9j15+KDC9nmUp7Z/ooXD25
         AFwZBnuHQySPw71DVUqzQmYiHE2kJnN6oLopAV6/4U+01GQT6kcCvgA4RpwoS+oRUwQy
         SWxYNoJVT/Z7WrudOjiHY4vLxgN4bWKqlNkavxr2RBcXKJ9g4u5WkEOm/ByJCNAZOSxb
         gozA==
X-Forwarded-Encrypted: i=1; AJvYcCWbL6CdWmNRyR56FSydQTWsNAyGb3ZtAJ3d5IFFjJf/sQYzOnCqaYVW9TepimDLc6FPkPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgM6BQqd1uwkPSKVV2i+PQWjRWX7XjJ4mp3QLue+u8LY43no3c
	Oar7XdxNe0ew3FDJ2yjpBivPIpcJI3way8FPpKHiVoymOCadB7V6exe1xCF7dXbvF+87zME6+ug
	BvQZoV7iTId3EOw==
X-Google-Smtp-Source: AGHT+IG+rJfutR0wYR1zy21ifkRKt01C06Fx3nGIjNOzYgpEnaw3ubx5f+RPFOnj2GZZ9rNeePM/4rP4Y1bnHQ==
X-Received: from pjbfy18.prod.google.com ([2002:a17:90b:212:b0:343:6935:a83e])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28cd:b0:340:ec6f:5ac5 with SMTP id 98e67ed59e1d1-3436cb73b5dmr376689a91.2.1762546317587;
 Fri, 07 Nov 2025 12:11:57 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-1-jmattson@google.com>
Subject: [RFC PATCH 0/6] KVM: x86: nSVM: Improve virtualization of VMCB12 G_PAT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

There are several problems with KVM's virtualization of the G_PAT
field when nested paging is enabled in VMCB12.

* The VMCB12 G_PAT field is not checked for validity when emulating
  VMRUN.  (APM volume 2, section 15.25.4: Nested Paging and
  VMRUN/#VMEXIT)

* RDMSR(PAT) and WRMSR(PAT) from L2 access L1's PAT MSR rather than
  L2's Guest PAT register. (APM volume 2, section 15.25.2: Replicated
  State)

* The L2 Guest PAT register is not written back to VMCB12 on #VMEXIT
  from L2 to L1. (APM volume 3, Section 4: "VMRUN")

* The value of L2's Guest PAT register is not serialized for
  save/restore when a checkpoint is taken while L2 is active.

Commit 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2
guest") left this comment in nested_vmcb02_compute_g_pat():

      /* FIXME: merge g_pat from vmcb01 and vmcb12.  */

This comment makes no sense. It is true that there are now three
different PATs to consider: L2's PAT for guest page tables, L1's PAT
for the nested page tables mapping L2 guest physical addresses to L1
guest physical addresses, and L0's PAT for the nested page tables
mapping L1 guest physical addresses to host physical
addresses. However, if there is any "merging" to be done, it would
involve the latter two, and would happen during shadow nested page
table construction. (For the record, I don't think "merging" the two
nested page table PATs is feasible.) In any case, the VMCB12 G_PAT
should be copied unmodified into VMCB02.

Maybe the rest of the current implementation is a consistent quirk
based on the existing nested_vmcb02_compute_g_pat() code that bypasses
L1's request in VMCB12 and copies L1's PAT MSR into vmcb02
instead. However, an L1 hypervisor that does not intercept accesses to
the PAT MSR would legitimately be surprised to find that its L2 guest
can modify the hypervisor's own PAT!

The commits in this series are in an awkward order, because I didn't
want to change nested_vmcb02_compute_g_pat() until I had removed the
call site from svm_set_msr().

The first two commits should arguably be one, but I tried to deal with
the serialization issue separately from the RDMSR/WRMSR issue, despite
the two being intertwined.

I don't like the ugliness of KVM_GET_MSRS saving the L2 Guest PAT
register during a checkpoint, but KVM_SET_MSRS restoring the
architectural PAT MSR on restore (because when KVM_SET_MSRS is called,
L2 is not active). The APM section on replicated state offers a
possible out:

  While nested paging is enabled, all (guest) references to the state
  of the paging registers by x86 code (MOV to/from CRn, etc.) read and
  write the guest copy of the registers

If we consider KVM_{GET,SET}_MSRS not to be "guest" references, we
could always access the architected PAT MSR from userspace, and we
could grab 64 bits from the SVM nested state header to serialize L2's
G_PAT. In some ways, that seems cleaner, but it does mean that
KVM_{GET,SET}_MSR will access L1's PAT, which is irrelevant while L2
is active.

Hence, I am posting this series as an RFC.

Jim Mattson (6):
  KVM: x86: nSVM: Shuffle guest PAT and PAT MSR in
    svm_set_nested_state()
  KVM: x86: nSVM: Redirect PAT MSR accesses to gPAT when NPT is enabled
    in vmcb12
  KVM: x86: nSVM: Copy current vmcb02 g_pat to vmcb12 g_pat on #VMEXIT
  KVM: x86: nSVM: Cache g_pat in vmcb_ctrl_area_cached
  KVM: x86: nSVM: Add validity check for the VMCB12 g_pat
  KVM: x86: nSVM: Use cached VMCB12 g_pat in VMCB02 when using NPT

 arch/x86/include/uapi/asm/kvm.h |  2 ++
 arch/x86/kvm/svm/nested.c       | 35 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c          | 25 +++++++++++++++--------
 arch/x86/kvm/svm/svm.h          |  1 +
 4 files changed, 53 insertions(+), 10 deletions(-)

-- 
2.51.2.1041.gc1ab5b90ca-goog


