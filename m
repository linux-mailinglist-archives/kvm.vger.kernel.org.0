Return-Path: <kvm+bounces-70118-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNALJLCOgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70118-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8E9DFEDB
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58E8330D6DFF
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0225133985;
	Wed,  4 Feb 2026 00:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUsiikIv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F4627442
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163840; cv=none; b=Nx03vjVxS3SWZZQrlyfL45AxrmvHBZw070BdTj98w5SQfHhGb2uzHBCMeln20fp6YEQGpfdnwzMCImNwloek/X9ONQ4uTyA51kCagR7UpoQVbfAwPVW74t9jGstq4BmDupL5iTqFHgaqV9aVn1Ez+FVE9ajn0e63xSoGBpYjXao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163840; c=relaxed/simple;
	bh=vqzHv7lXFONrgk1q1S1d7m7ni/z2/e2XsIvvQuEyR80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nGamD5NW5d81FDcsnWrpV4O59NCnuYT+s+CxplYep7fab7vnw0+eAne4HqOOOWwv2YSa55sKTatzn0+UhFgsQ+xVWUpuVMU9n6FLEo4GfLcl8RkCaJaygiqMRiIN4PolUBs0m6l5JvRGXVQNkJUxDjdmW0yQPQ264uux4o0R3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUsiikIv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35301003062so14907274a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163835; x=1770768635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T642Vz3ikngqdidKik0xkf1miyZGBg7zmmEdVffHrRw=;
        b=KUsiikIvMuLi339Ef6GTZnRqn73MSj6vsyX6Hpa4gZIX0Tyay/7PkJ+mLE/VcQnVLT
         9p4Ces+RplTpHYRgjFWC+tBnSjob9qByNhdlFMS7azEsk12hEqllRXYDHm2Bb79+sbmO
         Cfz+TI2adN7/sICL2Rb4H5LvaUj7/eTpIZPijdOz7x2pgwP03zuCEUd/BLNV6BHUEAjk
         3Re6CvL1wWzRZPjEyvj625i0Okv/tZeC9leaqXn9e/elSc1cU1U1QfyRijGIczgBGFBy
         zAH9b8KUyU8/lehV1tddgAFnOxKGC6uHOkZSuGB6ZiPDRz0CeXQPtW2al4TH6jxdBeX0
         DGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163835; x=1770768635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T642Vz3ikngqdidKik0xkf1miyZGBg7zmmEdVffHrRw=;
        b=FhcpH2+jmh1gyAKQGpZEoav+BkfdmQHtwgPlISSfrv/cvka6AF8B/RkoSryJ8YWVMa
         o741T+CeV8tDHHKaYf/ee//UIwGGX/HrlFWS7HyPSOZSopLvz0kDFDFEPePhLVqBBbpy
         y72XuMQ5bFKUYy1vaSghim90V58/bYGOVK3VidR3p9UGaW7yRd6p76kf9voDTQtbWkks
         PJVg4Do3kvAaPl4T0CYgnmfU/BYLqp/Ge4tOhrORd08qGFQZOuVoFUsr8utVUy2YQ41B
         fIzw4OqnzpJk9qmfpNa6IGDlP7ic2YIMgnEQaTHNzFUZvSOvhcmnLholGKFujhxGBJFR
         2+XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoy2D6UMeoyQyDZN5xmqGRGfgWa6g0mRRl3ZDL+df4CqTNWlQYyWXiMF3gXEX8v2ls528=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEqqT+vikq2wdzqkl6UMkWfi/V8z2RHCBGjTCiTkUOm+hgDdkI
	XDjGzDxY0DGAmz23khW9LM8iKauDsFAOAqgE+BB4Fj5j4Av83WoFASzmWseS+4ml9IfWxPaqcqu
	yP7la+g==
X-Received: from pjyl6.prod.google.com ([2002:a17:90a:ec06:b0:34e:d39d:454a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:32e:7270:9499
 with SMTP id 98e67ed59e1d1-35486f57774mr858279a91.0.1770163834977; Tue, 03
 Feb 2026 16:10:34 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:17 -0800
In-Reply-To: <20260123125657.3384063-1-khushit.shah@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016270726.565816.4840269573401291170.b4-ty@google.com>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kai.huang@intel.com, 
	dwmw2@infradead.org, Khushit Shah <khushit.shah@nutanix.com>
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70118-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1C8E9DFEDB
X-Rspamd-Action: no action

On Fri, 23 Jan 2026 12:56:25 +0000, Khushit Shah wrote:
> Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
> for Suppress EOI Broadcasts when using a split IRQCHIP (I/O APIC emulated
> by userspace), which KVM completely mishandles. When x2APIC support was
> first added, KVM incorrectly advertised and "enabled" Suppress EOI
> Broadcast, without fully supporting the I/O APIC side of the equation,
> i.e. without adding directed EOI to KVM's in-kernel I/O APIC.
> 
> [...]

Applied to kvm-x86 misc, with some minor formatting tweaks.  Thanks!

[1/1] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
      https://github.com/kvm-x86/linux/commit/6517dfbcc918

--
https://github.com/kvm-x86/linux/tree/next

