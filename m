Return-Path: <kvm+bounces-66228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F280CCB01C
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BD0F4300E4EF
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD46288CA6;
	Thu, 18 Dec 2025 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVvM1S8+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvD3P0O1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D126738C
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766047758; cv=none; b=eqkUvVuAszvZ5pRwfrmDUhc5NTmWzKGzO9+ttmPMfqh4hmgvJSPYfu7XjihspeS28CDZV3T0jYx0gYtgUQd0rD4iMkDURwHmzTjYj69dBk8hOMMBUZoKhab/oaOIzUNLdeYcnXKAFbQHqoerGuYJGGh8+04u0YfML8fYh/dIK9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766047758; c=relaxed/simple;
	bh=zbFQTVbzAcnxC0KSvv1cIgK1AO9VPWN1Ik5nyWyMluA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HIu0usyUODhUdQLqnuUeLLoi5od5E5rVMy5T3d50hpZvD03x1iT3yCOL/hN8Vtxy1WX30PYPuyJpm28wokNhDrtNagGujtZquYZvwZbQoL7MwHn+zXQmuE1gtpQEkNnS6vsZjFI39n32XC/0H0tZIwLM6nI3FHQ1PooMH8vueIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVvM1S8+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvD3P0O1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766047755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E3Smmd8mt/DKblta/sNLoWME5GxV7PYjo3wfpy3lvls=;
	b=GVvM1S8+kaBux/yIg8K4Dn2i9xxQnd47OE0vIQSPrLO/iv00U+fbEaSAboVtnZnqXdYouG
	9w5jJul9vmUNMQLo+pZnpz2DIfvK/PE6DD9n8kcvZStPR4dxoiXSypJYtc1qYxBDJ35Fmg
	71XuU1dReYlS4tedkvRlWLL+6qfWoYQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-Ox9yJfXRNMm22GMuGLemCA-1; Thu, 18 Dec 2025 03:49:14 -0500
X-MC-Unique: Ox9yJfXRNMm22GMuGLemCA-1
X-Mimecast-MFC-AGG-ID: Ox9yJfXRNMm22GMuGLemCA_1766047753
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso798483b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 00:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766047753; x=1766652553; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3Smmd8mt/DKblta/sNLoWME5GxV7PYjo3wfpy3lvls=;
        b=dvD3P0O1ah+hxBqV9tBnMPOUHHTr3rEhSyFfKOq23V+m9vhqFe1bqQ59VWm3BJpTAP
         LMNx66uTU03EqePNF36QJDrHD6EK4Ok4imU8bluilX4x1AKp93Wk8GAqpHi+49+S+o3n
         7aAOp25O/AUMragNdJiKBEkJ+3dhW22pomsPJxWg9Cj8HYnd47spsVT2fnS8SpPYd96P
         nFnd+hg3325OAVyBrP4hMDazlwPqKUZIaIrPn7NJDpKxBwr4uAuywexlk5Vy498/Du7p
         bd66QK+vOoTG/3FlUwmRN/hqYrOd7MwPuzAEWBoUmNBrmDW/j+YF0HbZ1+kP9NXhnR3y
         utVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766047753; x=1766652553;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E3Smmd8mt/DKblta/sNLoWME5GxV7PYjo3wfpy3lvls=;
        b=N9MjTODXRejtzpWUxW/5ck74NA7/JaeSuqHGIUb1PvnM/jDctUAPudRymrLZM8GJ4J
         0sVXYHuq/qOm6aqDyAjn9HHcGqCugzGPL5c8dsT860nddbsYdXf5KdxM6RaXspNsLatq
         OR5ThYsuXSskAm1oc7cWNPx36Uts5yOncdBYHYiO8vz9Rxdux0kBoXsanQ9isQy8rSjH
         YvHDTxlcXHNAukJ/UnxTL/zdo24AH1RRQ3M0x0zXII4FafCiGAhmek/gRA+QJ723VvUd
         9hdP/gMlmniU33Fmrw4cYYUL2riufXHIY4xZkhn065/29BHMQWMCdVr0EOox+i9YgOk6
         quiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDBRGIxAlkFd8IUyJYQBS3dfHbxNx82eGlp4GOqL6/zolFFTKqEPAWba+oBvPlJ/xC/BI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkxeoR5YmGFJkDt0U2Pq8P2DN8jNtELS1AoC/YyVpNpOKDJEDX
	NolQIxUs2AEzr2rgJszEAuDdcZu1w4/TDraMHrh8MAapdxU0ORgtN61gVWGfQ48LLNgf3E8yBoZ
	D7dhUZ+FdGVQk+NbYzj9ivSJi5PiD7sS+L9RtE8+dyShgC3jRvfIvcA==
X-Gm-Gg: AY/fxX69VBJLHzcWDTFkXKhEc0gNZP86ERnl+vnK5C7rg+gbZ8K16spTOLvPuJpfi7g
	/VfcSsJ0c3PO/00ZmNxyTO57NXZufcynqJqYGLf681tPO2uohwvb5P1npLK/B1RBE6+GWklrIrZ
	0sDft0hNvSHOKJdyzflg8zMmKODrOhQsSgYtFYxLO0+cIKqejGhx76GNcIz2g1l7Gzrpbk82EVJ
	ev76ydIQ1PJRg7u5b80KLv/1FlgJ0nKBntHRKbyeqH5fU/ynHcUrDzeQ1WXOCK0qQUxI7E0S1VF
	lcgBUGi+DEP96T9K7ikv5JnzOqZSGCvqvipx+8DNWVbPaIxcAOdqEp/3oQ+lBaI/aa33Mujm6lS
	tvt/R7+kUwb5WszoD2jEDGWYasr3tcNBbta07fA==
X-Received: by 2002:a05:6a20:9147:b0:366:14ac:8c6b with SMTP id adf61e73a8af0-369b04c6afbmr22270425637.65.1766047753154;
        Thu, 18 Dec 2025 00:49:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl6QZqKLbeG+27cLeEMo1auqdiS2FC+o/5/xhV6DvEZN7/DFBfxJmABO1JpZAZHnrteg65Qw==
X-Received: by 2002:a05:6a20:9147:b0:366:14ac:8c6b with SMTP id adf61e73a8af0-369b04c6afbmr22270409637.65.1766047752772;
        Thu, 18 Dec 2025 00:49:12 -0800 (PST)
Received: from fc40 ([27.58.53.10])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1d2fa22a1bsm1679655a12.21.2025.12.18.00.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:49:12 -0800 (PST)
Date: Thu, 18 Dec 2025 14:19:07 +0530 (IST)
From: Ani Sinha <anisinha@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
    vkuznets@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 13/28] i386/tdx: finalize TDX guest state upon reset
In-Reply-To: <ubmc2igckwxxpgw3zq7lmrhztygazibobjq3ruuhr3kbuzhfpr@odnoz7izs4hn>
Message-ID: <b18a18b8-0bc7-926e-d5ba-52f304db63da@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com> <20251212150359.548787-14-anisinha@redhat.com> <ubmc2igckwxxpgw3zq7lmrhztygazibobjq3ruuhr3kbuzhfpr@odnoz7izs4hn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Wed, 17 Dec 2025, Gerd Hoffmann wrote:

> On Fri, Dec 12, 2025 at 08:33:41PM +0530, Ani Sinha wrote:
> > When the confidential virtual machine KVM file descriptor changes due to the
> > guest reset, some TDX specific setup steps needs to be done again. This
> > includes finalizing the inital guest launch state again. This change
> > re-executes some parts of the TDX setup during the device reset phaze using a
> > resettable interface. This finalizes the guest launch state again and locks
> > it in. Also care has been taken so that notifiers are installed only once.
>
> > +    if (!notifier_added) {
> > +        qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
> > +        notifier_added = true;
> > +    }
>
> Is this notifier needed still if you finalize the initial guest state in
> the reset handler?
>

Yes good point. Following small change will be needed.

From 59e1df5f3c64a75a14139c498106a225bf3b42b2 Mon Sep 17 00:00:00 2001
From: Ani Sinha <anisinha@redhat.com>
Date: Thu, 18 Dec 2025 14:11:40 +0530
Subject: [PATCH] i386/tdx: remove notifier that is not needed

Take Gerd's suggestion.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 20f9d63eff..144020e378 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -392,7 +392,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)

 static void tdx_handle_reset(Object *obj, ResetType type)
 {
-    if (!runstate_is_running()) {
+    if (!runstate_is_running() && !phase_check(PHASE_MACHINE_READY)) {
         return;
     }

@@ -429,9 +429,6 @@ static NotifierWithReturn tdx_vmfd_pre_change_notifier = {
     .notify = set_tdx_vm_uninitialized,
 };

-static Notifier tdx_machine_done_notify = {
-    .notify = tdx_finalize_vm,
-};

 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
@@ -778,7 +775,6 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     kvm_readonly_mem_allowed = false;

     if (!notifier_added) {
-        qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
         kvm_vmfd_add_pre_change_notifier(&tdx_vmfd_pre_change_notifier);
         notifier_added = true;
     }
-- 
2.42.0


