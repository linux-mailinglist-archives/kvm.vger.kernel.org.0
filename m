Return-Path: <kvm+bounces-32597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9987C9DAE78
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA1016713E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D2C202F95;
	Wed, 27 Nov 2024 20:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rb00Mci4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EBB203714
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738808; cv=none; b=QgjcaA1u3DBs4/Rpfvwn9MJWeexsKrquCsVdttrVuKX0yWBQzI6Wm+OvnH46UcnX2h+o7fXmAtP4pOGN3WEiN39I7kjJ8hUySOaN1JPP7zQM/B21hGDW7o1vkyXQ3YoHdtGQNoxoEA26aidnWrC9IknPU+PcIBtZRDuwuk7DiUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738808; c=relaxed/simple;
	bh=sgFjzIy4og3iSZFWVYtstA7CQqck6vD0BgX7j5xnkdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n/k/Qf2sSBtdhzJ88R1OnfwnpwwCpBBmSAL+lSPJuMmbWxVaHykSMNGchty3v3b9tPZwTHzl3uXrve37qa8cJ13HiAAs3m+Oui+VgTvt5hHSIMnVsf6OhclhLBZpve9jkGoxU/8ZRuE3Bal0uUe5RVQ5h7nIwvqdbRH76ozgDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rb00Mci4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea396ba511so145082a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738806; x=1733343606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nEtZF4sU5IT1Lhy8Yz5CiCGBeJE0iqSK+FBKQHZElUE=;
        b=Rb00Mci46mSo3subkEqreMqeHJRHEiYizbQwa7HGTGsHHpNqZn6oL40wrUwLw8QP4t
         Bch9QNZeeVa+ze1G3HLXL0vrgWOJDKnWVFqS9Jow7brWud7PDx07jFDzUfFAOaZNFgyw
         w5jMTmZTelJ8taDknaVAHBgwZSawUBEKCPhhDPGRyqEtr3QgbpC04Czx6OchTgl4d4y4
         k4QbudvIu2RltBLcF/96Dl8AwBHChdfla/Jrp6H/z415PljtESrB5/bpPNTm+VkT8RL1
         YnV/0XnkgbtMTVgpqU9awFJEHotK3DsiPX95wlwmRnVyAeOxqYP+JplN8ubEo4+vpAtQ
         pcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738806; x=1733343606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEtZF4sU5IT1Lhy8Yz5CiCGBeJE0iqSK+FBKQHZElUE=;
        b=FJvLWAbnmxbQaeuFUxFDE98Gz98EYqbb+EUlyyN1664odfiqcIleqBmVtnJ0t3Tp9L
         A6JhcqL8sBg4BnwgxfSQB95epAxGP7fTwky+Whbs8sLEd1gqOI6VXrMKC1P0G8uRzNdo
         vVtMlac9LTbB9zLlHs9lBQpBgJjhPHrZYBRVqX7HuckTRb58aS8wdz9Lb6FwQH43lHeY
         EyGduzfjNyMR5i6zk+j+zm9wY43FWsui06rtI4DgoiuVrkUpXpHifYs8yk+MTtl0bPB+
         MNnJSFTsn5zeqro3ViQ8U6Rs4yOpz3UHfMdd1QFLaHKLCAeoqDSyuP/lg5Vbhdfb4OVP
         qm3g==
X-Gm-Message-State: AOJu0YzPW3rvownRFNPCsuutYU71AuqGdJLGcY4lVQY6x65qsPCP1jFI
	efk/wsuh1sz+7p/a16PpoBVLUsumHi6cMSNTgv/N3DNvUmtYIsR/mXN8zo2YmTaS4NKwZJv1atu
	89zXGftuYgAlJz9ThwQOHbwhSi5x68xkc52KxHsioKzsrOOsedxD135u+MxwLOBGVz5SM1aPlMt
	4kMms6lIxenwwnz8u+3e1MXmJ5OFO3pRrPMIOCmYq9IkkFQkt4lA==
X-Google-Smtp-Source: AGHT+IHi5kqbT6hdRXLkmGjsSge8edKwoRfFkYEpfqLDEbV1y6lR+p9ohljvlMdI+LJjPEsgiDHjjuNuewakgtyV
X-Received: from pjbli10.prod.google.com ([2002:a17:90b:48ca:b0:2e1:8750:2b46])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3910:b0:2ea:838c:7f20 with SMTP id 98e67ed59e1d1-2ee097c59fbmr5794280a91.35.1732738806236;
 Wed, 27 Nov 2024 12:20:06 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:25 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-12-aaronlewis@google.com>
Subject: [PATCH 11/15] KVM: VMX: Make list of possible passthrough MSRs "const"
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0577a7961b9f0..bc64e7cc02704 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -167,7 +167,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic, PT and LBR MSRs are handled specially.
  */
-static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
+static const u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
 	MSR_IA32_PRED_CMD,
 	MSR_IA32_FLUSH_CMD,
-- 
2.47.0.338.g60cca15819-goog


