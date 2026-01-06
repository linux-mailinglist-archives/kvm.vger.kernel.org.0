Return-Path: <kvm+bounces-67173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B72DCFAA67
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACCBF3349CB2
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0446D1E412A;
	Tue,  6 Jan 2026 18:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H5FDoZwg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60685695
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725839; cv=none; b=EMZrZuKcF5tsJ5lC4fpm3AiVtlC7D2DFa1yCz5/ZvqglxIA0AuUWyTHzZMYtOrD3wDKoicLFsVWuG7IHAwYsc9WsSPhW2FdW3TjxGVkVEVhB6bOVkSiFDjaKnzYN5gbA+t2HWrKt6AfwOUmGLHCHzMnYKz5BoC+nd43VL4EengM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725839; c=relaxed/simple;
	bh=+PyeIABNujjyLtbDpNFpeXtNfj1/FsEsgjw0JhaLChY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EmBYNyvR1djbB7NAso+YDJrHYZtouO8K6wWlkHuoKJT568dlvjIbT8eemjgfBBtGbCR8gnezvhlAsLkL4nDLruQH7sUdVJZI7JFNz4zOYVEk7PB7eroWcLA6dFd+ASOwcBYjzwLDbXrm9briAbXKkiL0x3bAWxwQkb85R4PitWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H5FDoZwg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-815f9dc8f43so2081438b3a.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 10:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767725837; x=1768330637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kSzoJlm6vX2WUM8FmguhKjIb1ZRG1MeJzjUGe2zOzUs=;
        b=H5FDoZwgAg6lazMrk3shl4TvaUbd22vz6VFH4u6/KKPY/tl3cV6BW/+nDzPPwG62YD
         iDdQJXE+fOloPPkGBqC6PyQbhsDTz4UV0kJBKsPOqURf1VP0VyhHD3Y1WtlteELRR1Tk
         N2VZx2A0PuG9yKtasntxqCMePjlhLbWSF3n4LZ9x1D5xR+tLFdfZydTf4lRtdmuVZaTS
         93X4HT61RIsvnUzHRORD5HAk9OPxE8GWW78cHYJ52NG0QUt11CE5b0KBie0rzZgQGTE5
         APeHeUKhvdHo49Ye64YzyvRPI5hOnXJMqNmsangu7FSDOH4Jk/t8DKZ5vetihoXwK0Xe
         zT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767725837; x=1768330637;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kSzoJlm6vX2WUM8FmguhKjIb1ZRG1MeJzjUGe2zOzUs=;
        b=sPX1FQ36muFNw8yzQbicFAsTcryyjylQNuSL0oe1TQaV8tox2MbF8Y9RBd0FUSBYyQ
         N581PXyPHMofLG5RVgIat4U3pDzIuV2GCMhRuokXcaLge74ntsuSEMuZE7YS0vDbGeQa
         KcWYlmkccx2IWQ3BV4fwB0wEFHAd6RuO2Sr3EuLYJe+EunlBZ2fmzRyIkyXPU3EBRxU6
         H731Gx08M3WDaoQvIcUzSLqs9HezNAwiVo1Is4LQ7kbycQNIX6u3oEZPJMh17/6p75qi
         7XH3s4V/INmfiTQmYcFsKk4jZ32qO5OuC8zVDKCPbwk87tK5T2eVsr2lBCZUyulazZLI
         8gpA==
X-Forwarded-Encrypted: i=1; AJvYcCVSAw079Q3OOM1W5K9CElj6kfxoGPqXLjx1L2UTOsiuTef6awoGHfw1+W/AFQRGpzK0LBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVKDcZjZAUMr8duQhxszwzems47t5ELv1J/ns9wTrAzzsKtDz/
	0vN9hgjhi0Yzsi8nSeDjgGT6GXNSDKu3rrvh2yPE5y6Pc8eKBnu4KDRz9Fkvjt96bJgS62EDTO4
	NCzLZsA==
X-Google-Smtp-Source: AGHT+IFxGyiNsU+bMGrti7oCMLKlVqa3y6k03fA5qsZnqU/n8rMV4qDTONBW7egW/vHqGbRZ2ZWRC3CsSJ4=
X-Received: from pfvf19.prod.google.com ([2002:a05:6a00:1ad3:b0:7dd:8bba:6395])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:e8c:b0:7fb:c6ce:a858
 with SMTP id d2e1a72fcca58-81b81197415mr17362b3a.68.1767725837201; Tue, 06
 Jan 2026 10:57:17 -0800 (PST)
Date: Tue, 6 Jan 2026 10:57:15 -0800
In-Reply-To: <4c45344f-a462-4d18-810d-8a76a4695a6b@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aV1UpwppcDbOim_K@google.com> <4c45344f-a462-4d18-810d-8a76a4695a6b@citrix.com>
Message-ID: <aV1bC3Wk-LbP1hUZ@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Sean Christopherson <seanjc@google.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: chengkev@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026, Andrew Cooper wrote:
> > Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavio=
r.  And
> > IMO the most notable thing is what's missing: an intercept check.  _Tha=
t_ is
> > worth commenting, e.g.
> >
> > 	/*
> > 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> > 	 * and only if the VMCALL intercept is not set in vmcb12.
> > 	 */
>=20
> Not intercepting VMMCALL is stated to be an unconditional VMRUN
> failure.=C2=A0 APM Vol3 15.5 Canonicalization and Consistency Checks.

Hrm, I can't find that.  I see:

  The VMRUN intercept bit is clear.

but I don't see anything about VMMCALL being a mandatory intercept.

>=20
> The "VMMCALL was not intercepted" condition is probably what the
> pipeline really checks, but really it means "in root mode".
>=20
> In most nested virt scenarios, L1 knows it's in a VM and can use VMMCALL
> for host facilities.
>=20
> ~Andrew

