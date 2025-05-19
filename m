Return-Path: <kvm+bounces-47047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D05FABCB7A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00E207B0864
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5086C224B01;
	Mon, 19 May 2025 23:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uak+riy0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07599224243
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697316; cv=none; b=A7ouebAIeCU8k/49mgvDQPwkoDUUPzzuYhTl4tRvsEN5MGMfqItSXstnVQ6p2myBRwMOdi/HF4aRLPlsKdz6PB3SxgB4M8q9KrgaVqcIh2+ctid9Gy+SiS8tUIY3+ERgs5XvUE+mBk53+mM77vxzeQT/EavOKkZRr9rRAsuWDX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697316; c=relaxed/simple;
	bh=kXdCtkWuECHGgWR2OT6Gy3/nttBLueu1XR40dPgOpQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hDu0WBLxak1ydM6bpJg/7AG9+HgyZu2cKSVW04TUz1UFKpdcr3zrLSL7iP14m2Gg5RPilVBqFxlm+vshV7aTtBeh1dHya/uMw558nrjPNm6AsW4lOvqGn/+N+WpNJQAk6FhxQIH5Hi07gIqdVsHiZYDoMfI5RIJmvdyPwhE7V9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uak+riy0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so4024206a91.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697314; x=1748302114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9gLcS+OzRCY/eRWGmdNSRPdTQEpCa40B7+xlZSCIkqg=;
        b=Uak+riy0pk/lDPBqauIjSQ6y6gTKbo2844R+OrpbLvLBd9K/P8kWdBTPCZT9pFZDzY
         u7lCpONqecUQjGvGO85+bQSSa66pPhTVPovx0O/UvE3NSesM0ZI624lYgsuq0DbfGwUF
         tK+NfT/x56sFkKnGnGNXtWHk3nGVdMofRMtE2WBua1avIFiZ4cp6VYRd3y+pVhEV+Mjc
         ZiFDYDdcaD3WqZHRgYwrjfupuvYrQK10kK/vBY1x4l2xhW8m5eoZrZOC9pqF0rb6Xw3P
         zGmWd3sNmll6LanF35Ktm/Z29+ZtKXQuZU/L9ALDQtX4VmeWYqK7xBU2pwuE3+fCVPAZ
         nr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697314; x=1748302114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9gLcS+OzRCY/eRWGmdNSRPdTQEpCa40B7+xlZSCIkqg=;
        b=W5sxr5vsjqKYEQey97uJxRx8IsiCLhXmkvubStRyNsUaiXq7h434l5Aas0tANssf91
         ZDOWgAexhDn8YPM5i92SX+NHjHQP2iZobovOi9mLxRtLoC9VLyqemT5gr5Ay33SbphbN
         lULEMrbh3OS98k4Wi+beATMCI+bx4j6DLSv3894/AUaUI62o90aAM3YrsyEUcGDvj2N6
         kwqGQt3CJmN76eievi2dPEbEmdxCxMoIlXYQmQC7QBhh7OAipNw7VJmzZCfoj/LyCi+B
         wX6Djx2y0htMlEUUqhA3BJsKDC4kErtrmM8t4yuzJt1NYtPpK/vySD0lRe0alB3PtQfI
         bxzg==
X-Gm-Message-State: AOJu0Yygcp/1f9jix+mJTAOMIZRSEGtMQh/jyddVy7iF+CspEGjp+MtF
	5vgYCJfns6YcYsn240Sc6aE+TKt/Teil23Pa2NZgjPj3vaQ4QzeHPj7DLBLrp1yia9XrvYFmzZV
	biJW1kQ==
X-Google-Smtp-Source: AGHT+IGsS44SKP9udDnxbnYqpNtWDNsH2nu1RdF7aCNajWwjT1ZSWe7ZKUxh/RwFmGOpvKqPfnwHgOPVukI=
X-Received: from pjbsl15.prod.google.com ([2002:a17:90b:2e0f:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1343:b0:30e:9349:2d88
 with SMTP id 98e67ed59e1d1-30e93493309mr24785255a91.12.1747697314420; Mon, 19
 May 2025 16:28:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:05 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-13-seanjc@google.com>
Subject: [PATCH 12/15] KVM: Squash two CONFIG_HAVE_KVM_IRQCHIP #ifdefs into one
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Squash two #idef CONFIG_HAVE_KVM_IRQCHIP regions in KVM's trace events, as
the only code outside of the #idefs depends on CONFIG_KVM_IOAPIC, and that
Kconfig only exists for x86, which unconditionally selects HAVE_KVM_IRQCHIP.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/trace/events/kvm.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 1065a81ca57f..0b6b79b1a1bc 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -82,7 +82,6 @@ TRACE_EVENT(kvm_set_irq,
 	TP_printk("gsi %u level %d source %d",
 		  __entry->gsi, __entry->level, __entry->irq_source_id)
 );
-#endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
 #ifdef CONFIG_KVM_IOAPIC
 
@@ -93,8 +92,6 @@ TRACE_EVENT(kvm_set_irq,
 
 #endif /* CONFIG_KVM_IOAPIC */
 
-#if defined(CONFIG_HAVE_KVM_IRQCHIP)
-
 #ifdef kvm_irqchips
 #define kvm_ack_irq_string "irqchip %s pin %u"
 #define kvm_ack_irq_parm  __print_symbolic(__entry->irqchip, kvm_irqchips), __entry->pin
-- 
2.49.0.1101.gccaa498523-goog


