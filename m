Return-Path: <kvm+bounces-23801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D27C94D83E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 22:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B97C2B20FA1
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E92316A92F;
	Fri,  9 Aug 2024 20:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jub9747I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2556B166315
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 20:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236727; cv=none; b=fEXx7XwWdsZ81nzcgN0yHEaR3G/EWxVhmuzY7n4nh+ht8Qn63zusIaaSSJMblGbM2DlF+6fBwdF82zRwgGPia17de6bKHZC80kfuj0n+mYMPgNHTLGZuuSYO1T1/pxjs9hJGA0OdtRYSJKanGw6QWRbnf3/T3MakKy10kPOnYsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236727; c=relaxed/simple;
	bh=F/i+lgt9dfMODC8lpmtv7OIwLyDsx7Z0jTeBvQyEnTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oeIAj6kMt4YqlmT1V8ebZlYlL49gCxFvfGgdfT4ikyfh2zgveFY8VurJ5MPbblG5Pt8FkVUI/rqrcEExtc4xqaEc5P8y4e8noH1rkFCQbMLQs/tncCIYDom1+17P1rRuK3uTHk7V/2XK8pXZzsIlS3Pn7aS78XCsDNxyQBdeBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jub9747I; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6902dc6d3ffso61135827b3.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 13:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236725; x=1723841525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=54OZeUBWyPXA0S87QTioBQQ7Q2CkC6lMvkpXhup6C7s=;
        b=jub9747IQgCw0kZHtpkL8hMF+7U/w23VBZBH474tfcxbiMyRawADGZwfe9t3O82zjz
         A1Ah2K8waVHedjgDAowst9Ro9d3dUa89KITohY6ZcSAPYqsDgUC8i/ywaD2TlHknwu7N
         HSD/iK/86QCxmezTxE0ds+CokjU4JBlubIoPsyY2Ux7yHpGdYBlMhc1rQ7r+HPeNPw5V
         yu2uj+gMD070OpZjALXZ9JzugCPFpQMLQhoGMQEOoN+eGquz1xm6Zu73Jb2iTKnCbSgP
         +M28q7Mwh2NjmNGHhf2a2m/nvWTYyfT8jhPusPXq8LqZc3ENg2I8q7aK1tJZiLhSf1SV
         a3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236725; x=1723841525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=54OZeUBWyPXA0S87QTioBQQ7Q2CkC6lMvkpXhup6C7s=;
        b=kgIU7ckhE5wTtkhXS4oAqPHv2rPzjN0sBiV15CDFmmYb7EFHLcGT6luPkMKnp7baVR
         eOh4qFcsDMD89AH8O5v2Pb2fmxp5Mb1scgPdrZZYkCZ/5L+/cR/0KtAXpnExkef0ll5r
         zETz0ySVQkP/M/tXRCHJ/4GGZrQt341V58Hw5tRv6wkceTtJJaULWOl4nwm9AyvZYVDV
         TTq4vLB82W4kmOcYr09VjTSqa2Faoi0kSvyTNXc2f6gLx9H3tOeRqhwpVxbbK7QljHg/
         m79M51DIfGBVExkxGSGmRuzRECS3vWZX/Q1bDmTh53z2YYr5gV0IDrXjspMLF9YOT8LR
         qX3w==
X-Forwarded-Encrypted: i=1; AJvYcCVzByb0y7VxP5b3HuvYOwOvySq/9O/91hgLyHy0yUJgSVVQStVlgWJniUsPI2u/LTbSkNTYWETjsBIbjMG9Isl02Dg5
X-Gm-Message-State: AOJu0YxHnc6S4MbsAWdlMMB75LioYSg7jo7GPgWzEPAFqr6iZk7+my1F
	hrXJm57IIjIN9KEqaWXwQx6fHV8aw3aVLW3cAgGj11O3hOm4qpI1T2ntEHddADhIwtb7PZpemIQ
	WMNgSRpO0kQ==
X-Google-Smtp-Source: AGHT+IEd1rLj8FyLEliwY0HHp1LBZ6RRlFIxvN6TqVFlyWLq4RucNIuVDKVa8kZXEO3o2onu1BiztI0aOW/YaQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:d44:0:b0:e0e:426b:bf6f with SMTP id
 3f1490d57ef6-e0eb99f2ea1mr5705276.7.1723236725130; Fri, 09 Aug 2024 13:52:05
 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:56 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-2-amoorthy@google.com>
Subject: [PATCH v2 1/3] KVM: Documentation: Clarify docs for KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The initial paragraph of the documentation here makes it sound like a
KVM_EXIT_MEMORY_FAULT will always accompany an EFAULT from KVM_RUN, but
that's not a guarantee.

Also, define zero to be a special value for the "size" field. This
allows memory faults exits to be set up in spots where KVM_RUN must
EFAULT, but is not able to supply an accurate size.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..c5ce7944005c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7073,7 +7073,8 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
 could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
-guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
+guest physical address range [gpa, gpa + size) of the fault: when zero, it
+indicates that the size of the fault could not be determined. The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
@@ -8131,7 +8132,7 @@ unavailable to host or other VMs.
 :Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
-The presence of this capability indicates that KVM_RUN will fill
+The presence of this capability indicates that KVM_RUN *may* fill
 kvm_run.memory_fault if KVM cannot resolve a guest page fault VM-Exit, e.g. if
 there is a valid memslot but no backing VMA for the corresponding host virtual
 address.
-- 
2.46.0.76.ge559c4bf1a-goog


