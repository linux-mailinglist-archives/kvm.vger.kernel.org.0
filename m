Return-Path: <kvm+bounces-70882-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FUhOWyzjGlLsQAAu9opvQ
	(envelope-from <kvm+bounces-70882-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:50:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B57612652D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4394F3077E7C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7F7345751;
	Wed, 11 Feb 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUYm0Lvp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10517328B45
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828450; cv=none; b=N45x6XYfQanHDo2L/8uoKTQE3VFTpBnBKgRuU6ukRqg/2+8/4ubTCq6Q/X1wkO3Frps2VQ2XxsmNiZRt8F3v0edJeaoi7vrbaI/i4vjLy3ApmQDGsyYbFZ1tZJ2akL8Q43einvUvWZkKI0tEs6jDjTczOxOicRWEuaVHivTwCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828450; c=relaxed/simple;
	bh=6tT5JR2+mxZcE0qfU4XovEwaBeUCjefHu/HQsjDXXRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k67TARPm+5TocGckPqfrhJDLSmqTonbz+ZioraguWEm6y4RTEUGMYiWyfoBiTC5ibFNCmavBO6rpk2Sls7j88GJwVGh63hV9Hd6x65BVIHaxOIgPTH5gZAntiUnHDyaprd5Y7NDt/FIlY2iGrlyBKLFIhNesnhNTKSVrkZW/aQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bUYm0Lvp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so6871877a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770828448; x=1771433248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BLVUVRl8y+39Clu7ugddgpxNZE8kBHF6JKudZmEKj7Y=;
        b=bUYm0Lvp8IfPdHyeguh1lQMA1ktHx9haKkfR+jd/yhjDCXZg3y6OVSwu5uRA3RIQ69
         q0gOled+wc+ilUFYV0B42IHHxKs7QiTk5Jt6430bmo4zUdTO2/iCXt88dcpVeoMwwckB
         6MFoOkIKmToSfR1F+kFg3WnaoCYumE+TWc5D7pk0LLiCHHQUkCfGf5vwZXrIkfHlldA1
         PIQuHGkCDjL3cgdfEwuAuhrvb9PP1PFX8sh7xvX/sZLuac+uKDWq05jDzIZQgIUHhQYC
         6tlUkTUCPKRtxrwGbG6CJm0JBFcJtMrm6P5aDAomzwz0zsEXbpzJYZGG3GSSBkodPFJd
         vwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770828448; x=1771433248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BLVUVRl8y+39Clu7ugddgpxNZE8kBHF6JKudZmEKj7Y=;
        b=xT2ZqzcvomzIdD0Bjpta2EAAytJ7XOUIC/xx1JtIQSKJdhjygUoCohSst4Yq/byOG8
         Y0zBrbEk8zeHFsn/RXaxdUfHD4falwfBtde/S1zmOCSUDPKuxFeYIbOxhULaUcaSOK8k
         amTyy8oxi73PLQ8onDsrqyCKfMpJah5z4DlRhQ6WkV+ovCVA5cTCuk6Bsc490ozrhwfq
         +FN6504GY19LZE9zXT2UEwzuSjvg5ZqqchjGGOQ4PvRimROawqiEGXxLTyScBVo2zR9S
         lnfvy5u0Bd1S/tOcXaLn6VOs4/tA3PmXEjZybPU13zxa+rUWCOZmi0Na3XrZQwF1RIKs
         4Y0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGhRrsEDR6/uHRske+mLjP9lIiBC7PjFPPvhqqsK1uuQ1kr3qpt0JslFsaz2N73w2XqUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTcssZaFzAr7y84abtKs1lZW+D3F7e+dpJWYnV1YPkYkDsmNmv
	Oq2DdHaOmx4peUxPjn4uJ7k59C9vWgZxgcePS8mt2rVPIkqKMrsBbq4AJ4gvloOyaAgbMlQWoHL
	jDnB2sA==
X-Received: from pjqf3.prod.google.com ([2002:a17:90a:a783:b0:356:7a39:db8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d84:b0:354:bedf:8e64
 with SMTP id 98e67ed59e1d1-3568f2b7d65mr63493a91.5.1770828448379; Wed, 11 Feb
 2026 08:47:28 -0800 (PST)
Date: Wed, 11 Feb 2026 08:47:26 -0800
In-Reply-To: <421a20ea-2788-493d-8f25-497880c04a7e@thorondor.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
 <4d286692-3e29-4e8d-b6d9-f04ceb748499@thorondor.fr> <421a20ea-2788-493d-8f25-497880c04a7e@thorondor.fr>
Message-ID: <aYyynvi-alYQ1-_5@google.com>
Subject: Re: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
From: Sean Christopherson <seanjc@google.com>
To: Thomas Courrege <thomas.courrege@thorondor.fr>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70882-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6B57612652D
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Thomas Courrege wrote:
> Gentle ping

Sorry, we're in a merge window so this won't get any attention for at least several
weeks.  See Documentation/process/maintainer-kvm-x86.rst for details.

