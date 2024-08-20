Return-Path: <kvm+bounces-24566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7DE957C78
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 06:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 696571F23FBF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 04:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAA81487D1;
	Tue, 20 Aug 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUC3M/fQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB36513D2BC
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 04:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724128695; cv=none; b=klQPORsXn7Ec3JsnXqUVhu6Ej8cmohG+5IUW3goml+XRjyl7qcpPcm+GiVf/zDTeyxM/d77KoL/DIIL2YtOgWRQ9vfAxysCeuDO7Rc9bkAik5wBUcljaNUFrgBGLqgnfEtjSsFOP3tYbaa6LFCRUS1hrccwkBlR4L6VTySR+t1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724128695; c=relaxed/simple;
	bh=poG3kBQSpIW+a3CJ5/IyZwN+BzRPc6FZnR04OujsFQg=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=dyYex07o7hubJwaf63th9RE2KKHA3XVQKJsItExxJlsv1BgjwTjg5maRncunMWDSESnBokIGJUvOqATcrxTdDE5weQE0O+SGFW0ywcnbtGPHIEWEgnciIA3uqkpTYeCDrT77O8944GIVngyBTb/0Ym7jy9niIin4s6wIBMy/IVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bUC3M/fQ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159fb161fso7297342276.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724128693; x=1724733493; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FKSsf9Lzm9EYSf/AobA/jkSovK0xSmbEfKJnNNfJ50Y=;
        b=bUC3M/fQqZnqH1rD8fpY3F9qkrAMk0f+EUiXIqH/UVW65QGRQXTOurrRZcvnpmtu4G
         jgAn5BT8NEUe1al6TBJSv+qYvgV2Wte8V826LErJ96/5DUjhxG2SXsHONgzNvrnAwM95
         5sGtSot3OrqbEVvWjOhJxPHNMwhLDZh3hJiBnGTmtYUfM7SAEqRA2so6E3dlNnwJce2P
         65urq+d2lfGiqv7fuwGHEbSVr8a+/pjG9OQcj3j77NHRHzc3ly11ah8S3C3vBusadEcr
         U586u0Iqy08zMYigEKQREx02PBrxG9J2HbvoKmJsHnk7ja2PazqfvMmxCTazc1Ug7lhx
         /MVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724128693; x=1724733493;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKSsf9Lzm9EYSf/AobA/jkSovK0xSmbEfKJnNNfJ50Y=;
        b=iFKWI4nyKZjfbt0D3XuGz7zy/iDGnAMvfxc0KDYW3+8TmsbJRvIGshZkWmuLr8MCdM
         Di43OXEe6HQRx7djMIHYnsIYGHScxY0Ln16wlaYkuTXQ2KxTrTDfD4gPXHqMHhnRLUuX
         pDLGdWOiPBRVD6pKeZBM9F2a07yHJoKyzIqFozStEKTTCeKo2QcOMxmrp1H9gZdDrntR
         vvo+ycv1bKjqEIcFm/nRVt0MQKCifsRm59M/YLQg2/04F6eGdlmGFNxS0oFuBHizVMIb
         ZQaE3wCRjIQ0n/M+K7reqE1lK0c2ey+Ojz3yHeVrnQyiheSPXTifh9Qa0hu1OuCk9oGl
         J5UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMUW+alSie0aPRpRB+O2sTIHy8HTDyOCMCnTw8EWREcdXFIq/nueI+sNCnYF86J1tJ5E4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuah3XBpog4e8xTPLkd9ZP0v9gDrhMZF72i3U517KzOTUcDcm7
	87YAMd2yGLOqxp3zYM4Zjc49S/Q5YhW/RrYD/R+T07wydlJWkfjdhT7l6xdK9P6QG8F5Viy+7q5
	+1so+4FuIMA==
X-Google-Smtp-Source: AGHT+IFPqwVaoVkfiG5pcO12KiFYHLAsirwex5WI2NFCnwFw7UYHoZ3jKbECokBCiiQpEVBTD1Terc8qaRFOPQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:7c18:89e3:3db:64bf])
 (user=suleiman job=sendgmr) by 2002:a05:6902:504:b0:e11:7105:956a with SMTP
 id 3f1490d57ef6-e1180e6c0d4mr23970276.3.1724128692630; Mon, 19 Aug 2024
 21:38:12 -0700 (PDT)
Date: Tue, 20 Aug 2024 13:35:41 +0900
In-Reply-To: <20240820043543.837914-1-suleiman@google.com>
Message-Id: <20240820043543.837914-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Subject: [PATCH v2 1/3] KVM: Introduce kvm_total_suspend_ns().
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

It returns the cumulative nanoseconds that the host has been suspended.
It is intended to be used for reporting host suspend time to the guest.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b23c6d48392f7c..8fec37b372d8c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2494,4 +2494,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+u64 kvm_total_suspend_ns(void);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb2b78e92910fb..2235933d9247bc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5720,6 +5720,15 @@ static void kvm_shutdown(void)
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 }
 
+static u64 last_suspend;
+static u64 total_suspend_ns;
+
+u64
+kvm_total_suspend_ns(void)
+{
+	return total_suspend_ns;
+}
+
 static int kvm_suspend(void)
 {
 	/*
@@ -5735,6 +5744,8 @@ static int kvm_suspend(void)
 
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
+
+	last_suspend = ktime_get_boottime_ns();
 	return 0;
 }
 
@@ -5745,6 +5756,8 @@ static void kvm_resume(void)
 
 	if (kvm_usage_count)
 		WARN_ON_ONCE(__hardware_enable_nolock());
+
+	total_suspend_ns += ktime_get_boottime_ns() - last_suspend;
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.46.0.184.g6999bdac58-goog


