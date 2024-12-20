Return-Path: <kvm+bounces-34195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D145D9F8998
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 924C1188A10C
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BB629D05;
	Fri, 20 Dec 2024 01:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cg9ARUip"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525A125B9
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658752; cv=none; b=QaWFOF4Yw8pLU3w1bqvts32ZX/KkvepnaK45M4yByzw6gEHIQyB5bW+eZLU7oDYoev8ai2D2B6pWANPW8Wd0wLbc6eh+sLiLqUIPXiYt3VFYvmUtcQmwsthhlPp2wJuhiEvA9x9NoLtQrIOyBSc2mYFacjoRBmpuM+1klHO+D2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658752; c=relaxed/simple;
	bh=vUAkr3IX2LE4GH/mlPkbcxzVyqeoUOtvVrlhcSINMSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQ3osmzosFrz4jDvaFDVuYQnVL9FXj+WBb9CNvmbB/Z6CgMqJ+V2Vq3LVgqJ+/qSIFEZM7IzsYPuk1qRtFLT8SYnZt78EqLecwf9nmB1F5Q2jN4F19CWQW90JQsp8D+ZNNJxJ56zrJP+xvO+0AE/01aRA45PRDW/5FZjMb3AKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cg9ARUip; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eaac1e95ffso910717a12.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658750; x=1735263550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=Cg9ARUipzj+8HUO5coEyze9E5jPY0yiPMCRfSBVxS71MrLP8NEMYVYkiIy+Ufm1/hM
         TIzx3/DFVt+IFZ446W0z9lnHIGWpDqjmtY5TuenifpJOAMQoqztmfk61MV6wBSuXYWsN
         Ru56Gk6HOo+FHKP8I4qiOx8Mvx0PovvW/GKRAS/JYvgEMV3g+koLHzLCCgbLHpNQaFab
         MP+JqOBEchaCE9KBn/ddVBGK5z7iscaAmbavLRrOu+RPSJ4mg48m/OVKMK2scDlQT+gy
         CLsHGOMXBy2Rcb5MUJyD4QJfxRd3ZPiWOdFdrJEzrGYduFAJJdkWCHgkGeYCgOkQfOi5
         O+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658750; x=1735263550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=VUQGFB6iNyuG+vJCQdgIvJ4xNQ1etU4Z4a28RAvcC9Mbqx7x03XMSlnlKwDzMU7ZNB
         aia2rrl9BS2hdhS4QkFdLyRZK8EUEBVyLFy2RSVeJpRys5MP1jTsl1KOWLcVAmAjNkk3
         1li9muXt3tXNZvh7kkteZV1yaGbh/W3H1jp3u5xCG2ErVC90HuIqaQtYX2Q3ZGX1BIis
         WyE061sCay8Z7xT3n9x/Nxd9BBsNTwsMyv98V3KIr/igyYaROJrADd/9t3juu3XekgZh
         vtoXCIZGRwCFV5h3BEesmHZDYz05d9hl0UG4LKBx/iHS7q+Z+C0sY351bltiVWMpUZ9H
         LOBw==
X-Forwarded-Encrypted: i=1; AJvYcCUw/mQ68bauPWTPAPP+MkdL13QH1ghBNqyqm4FWbRKXUBrOcPCDyu+Vic1vhQCyxrzQTtw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw518zZs2jXsf8chFaMsED6G5XtN+jfbLDTY0+evDuwpe33/RAW
	nWyrkZb7TNBhYXok7FDEH7x5jBzkmBuBfpHLqZvXDfbRrRnyhuREM216N5p2lhYECb/vMpnAlJe
	RUQ==
X-Google-Smtp-Source: AGHT+IGntiLPaNNzeAfuu6/TEmKwPAvoTiJFX2SO6583j9CN5As5xvpXTmf/fSQgTUKQrOus8R97PMQPQe4=
X-Received: from pfbch14.prod.google.com ([2002:a05:6a00:288e:b0:727:3a40:52cd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a85:b0:1e1:c8f5:19ee
 with SMTP id adf61e73a8af0-1e5e04945e8mr2117339637.25.1734658750347; Thu, 19
 Dec 2024 17:39:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:38:59 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-2-seanjc@google.com>
Subject: [PATCH 1/8] KVM: selftests: Fix mostly theoretical leak of VM's
 binary stats FD
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When allocating and freeing a VM's cached binary stats info, check for a
NULL descriptor, not a '0' file descriptor, as '0' is a legal FD.  E.g. in
the unlikely scenario the kernel installs the stats FD at entry '0',
selftests would reallocate on the next __vm_get_stat() and/or fail to free
the stats in kvm_vm_free().

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..91d295ef5d02 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -749,7 +749,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		return;
 
 	/* Free cached stats metadata and close FD */
-	if (vmp->stats_fd) {
+	if (vmp->stats_desc) {
 		free(vmp->stats_desc);
 		close(vmp->stats_fd);
 	}
@@ -2218,7 +2218,7 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	size_t size_desc;
 	int i;
 
-	if (!vm->stats_fd) {
+	if (!vm->stats_desc) {
 		vm->stats_fd = vm_get_stats_fd(vm);
 		read_stats_header(vm->stats_fd, &vm->stats_header);
 		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
-- 
2.47.1.613.gc27f4b7a9f-goog


