Return-Path: <kvm+bounces-45893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C3AAAFC72
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 136E81C23012
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9E8265CA3;
	Thu,  8 May 2025 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bm6axfZm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6917253F21
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713421; cv=none; b=J8nl8/jIoxgu3ZeqjD6FcrJWosBqhWBNB0qHvVnvZSQAed6RybEHQM1BXrqLcvM576dn2x6BBTn31cXhGSEs/+r02q+WhyOfs3fmBc5Yxljd4SNADjLjN+eEu3zA3Lx1eu0/i06dNPrvkNLTH6VIshKia4S5UDNbxC2cmIrNFy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713421; c=relaxed/simple;
	bh=h9ceh9DWtwvOAv8lZI5QIIzEnFfIR1nnvswMVkuMh7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MtPutXHPY2Rj8ZXoIz7wolIISQHzKWTdmX6dqWEcj8RMyVv9aKScTMxG0HjNKHYKfS8srrb4AnuU2SoIG0WLx2Uf2Srcu+Hb1gLRektdmuXFShW5uRCN62J2g3rnhKZwdcWV24WPx2Qx/ZmeLdyH9i7NxaZpcg1EGq3on1DYqXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bm6axfZm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73bfc657aefso852610b3a.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713419; x=1747318219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=p+56ubm47OlXcm/VaWogaGlH7q4WP+P+2pKjZu9cp4w=;
        b=bm6axfZmRXgeuF9fa6kEQJoma3Qim35CdnI18deLf9b2MaHRq1Z0ouEjlfGuk+Jv6J
         GRT4f8NL/JVvw7LKwHhyuIxPK53pYd0tKVbjFT+JxDH8ZSEeG5NG0vZ1pCNwV0Ic2uMk
         +/dW4LwVu+Mc7JoQ5ms0DVqsVQ4kaAZui1imiDkYSX6Rh9M4wmjdGNyjOJR7hZ2lSO6u
         XSGQpQ3itYTHSfAt2Y/IDTn7OC1x3QzheU7QXT9yWpwImj0U1bzcAjwOUeBMLQSdSVMt
         wm2L+YdvtlqTtY5ChjG6VJ7AgPc6xN0ve0lUaZNMXtC47/4jS5iqUcSZOuGrhOVEIwpf
         vAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713419; x=1747318219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+56ubm47OlXcm/VaWogaGlH7q4WP+P+2pKjZu9cp4w=;
        b=NpjiXjdl75ivtJgs6RjW/4pRcdTNCQ2Q6oM6WX0krewsccs+3Xo27Xa6HwqJY9hSLN
         MjWHl08FR/DiLZkZYiIAGPEE3KvZz7LR8Z9rjbB+BhCIwYwuEdEDjDVxpNoNMPeb+EC+
         X80yY7fiR2pj0Vwohs3cu3fcHhjDJr/JhyTWt2nwOOmRx0y+XhBFaBrdaLXpNQ0PSnQu
         d+FxZhCbmOG9c4n/5atcGG7Pz7gnkFA7YHXM8dDBojoTa/lzF3/yZUriyNhFIGxNGjQz
         ooRQC46zbzkwdGl5W35bF4WYDXCGMeyH5v9pY6D/gIT2shvPMowfvPSh5lkenAIEcG4y
         spRg==
X-Gm-Message-State: AOJu0YyXaWmPdMzijuWHaRP1q/8OeO7u/R9dhXwVAw9vdXoJtvE25xBP
	marP4ebvypVXov6hLipQxgOozdV6GOOMYnhIWkKGIA7m1fwOtyJhSWR+LWhorOH9GOJNoUvqHSe
	ajA==
X-Google-Smtp-Source: AGHT+IG2eg6x/bjzTx5zXZD+HM1Dnr1Anhc1D/g6qFT5/6izbWgde1cjoEAZ96/ZeW59opbMXnoIvhkIYXc=
X-Received: from pfbdu10.prod.google.com ([2002:a05:6a00:2b4a:b0:740:41eb:584c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4c0c:b0:736:41ec:aaad
 with SMTP id d2e1a72fcca58-740a99cdbe4mr5209318b3a.14.1746713418848; Thu, 08
 May 2025 07:10:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 May 2025 07:10:09 -0700
In-Reply-To: <20250508141012.1411952-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508141012.1411952-3-seanjc@google.com>
Subject: [PATCH v2 2/5] KVM: Bail from the dirty ring reset flow if a signal
 is pending
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Abort a dirty ring reset if the current task has a pending signal, as the
hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
in a timely fashion.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 77986f34eff8..e844e869e8c7 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -118,6 +118,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	cur_slot = cur_offset = mask = 0;
 
 	while (likely((*nr_entries_reset) < INT_MAX)) {
+		if (signal_pending(current))
+			return -EINTR;
+
 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
 		if (!kvm_dirty_gfn_harvested(entry))
-- 
2.49.0.1015.ga840276032-goog


