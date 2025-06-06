Return-Path: <kvm+bounces-48662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD6EAD0375
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 15:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60E943ADD6A
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 13:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F1F28936B;
	Fri,  6 Jun 2025 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbG6q4zG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311942882C3
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749217752; cv=none; b=fE2fzmtgMcd9PqCHugePGFE6f08s/GS2UVoioKH8rmX7B3Zkm0JF02GQLluLOUl/B/dRnP67h2ZQvDddEAkYJ9sOoohZLR+ShCUi06YzdALcrA5RRyNpb1wkJe7OlQ0jFb8Q5QeVHuFqNMMDsLxSLAuK1zPXySLMh56jimgP6TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749217752; c=relaxed/simple;
	bh=eOrgybtFDd1McNbczIGE5aDNUmgzfN7eK5kKrNqNOWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1lUh4PLPzV/f8BbeADr8FDQy3KTZI0dVrM0WWzRB9rqZaVrhqJU9bv29cql4avhYKNfJWXJTrk33cKhvRsRkyZPUJHKI/vw9C4/e7VXm7kjHPXSKoiTddlMGsioLDzDEy0IcI/s0A7iIjfbfO5Vs4TSR4UcyCAFNuYC+R88AIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hbG6q4zG; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747ddba7c90so1797071b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 06:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749217750; x=1749822550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hzNM8F6NiHQrZckFu72OcpGDXikxNc9SHjTtjEP9BA4=;
        b=hbG6q4zGu72nlfjztjZI0YfG3LrK3U5rqr49NBzYKxHpYmX7Q/QgeuqdEZTGrfz3u8
         0baJ7R3HdwfNb3zphZbuA8nrau8lSUvmdN8hzpCzMWFE+Z/P/sEbmdkKuOyIBCJva1Fl
         r/uvOXlwy9kwa3Etd27BwSyw7z3kvV6VAaq2waeAk2jD960y09ESm5DBx5J3zlHtck/q
         Gd7VY7RUmKLmtjDzCOsgchwUcJFNusuMcLgIHDxC9klwfp+Izptiue85HfwBr/rMjsuo
         9wrE0hN1NWhrrC66vOyy0ePwQBl6Ab/jFarAjBS0r3CNFABPhSpwYIEl2ABD0v9c69HD
         ZH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749217750; x=1749822550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hzNM8F6NiHQrZckFu72OcpGDXikxNc9SHjTtjEP9BA4=;
        b=MYJ1F7TMtbKqNdp/Zj4/aYVVNjUk4Fl3Mvcz4c+8DzMZ0+ujZrQFnpgHUvbE9wLMZx
         CRyYMn0YAbCJ5sfMcqyUORSsGElvIWRg3dj7dXru4UKyfIFCT9X/jqip665THSnrPDW5
         RozMeBvSfmSp6bnOygRaH+WMhoiwfdoVuWmEAi8XHllvLE4/jwzFRG5JZXnk11Y66ZWn
         hVdqGe5SrTBUqYhxuFVgpsfFYxmIZEq0Z0ElZJvHa1Qa+neUDCui2qweNoeeTGemXr5J
         Rfm6JnBWwOJimKQ2JQkR+Aum3mAymNqmJmfm4tzCBLh52bDUk29WvPms5tm2wupT/v5F
         brFA==
X-Forwarded-Encrypted: i=1; AJvYcCWehj45KbPVsZnCVtYQrHgVi8by1K0z4e6tUIMFmxX7CelGyw3P9nCP6mOAGVd38gKI9+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwHBey6q1O75wb2JIIbETgnesvhBi0cGacJeTPaRtQWm+mkIKD
	AMcW698AbQE54Ruis+QdQM/EeZlBZUMBgkC5hRTX7pjCeECM0HAgB12SVfwMzaJnoqPP685t5vU
	N+bNQbw==
X-Google-Smtp-Source: AGHT+IGvZHCQQyzNzpnMEJUc2ZlKMTphQYXkVqOMWSYOWdZh6uqcMIUnZOUB8iQqtYXwGJfi7xk18c0XRq8=
X-Received: from pfbgr12.prod.google.com ([2002:a05:6a00:4d0c:b0:746:31ae:c7f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f8b:b0:742:8d52:62f1
 with SMTP id d2e1a72fcca58-74827ff9ff0mr5353880b3a.8.1749217750454; Fri, 06
 Jun 2025 06:49:10 -0700 (PDT)
Date: Fri, 6 Jun 2025 06:49:09 -0700
In-Reply-To: <aEIeBU72WBWnlZdZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-8-pbonzini@redhat.com>
 <aEIeBU72WBWnlZdZ@google.com>
Message-ID: <aELx1fPBfuyxTnJx@google.com>
Subject: Re: [PATCH 07/29] KVM: do not use online_vcpus to test vCPU validity
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 05, 2025, Sean Christopherson wrote:
> On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> > Different planes can initialize their vCPUs separately, therefore there is
> > no single online_vcpus value that can be used to test that a vCPU has
> > indeed been fully initialized.
> > 
> > Use the shiny new plane field instead, initializing it to an invalid value
> > (-1) while the vCPU is visible in the xarray but may still disappear if
> > the creation fails.
> 
> Checking vcpu->plane _in addition_ to online_cpus seems way safer than checking
> vcpu->plane _instead_ of online_cpus.  Even if we end up checking only vcpu->plane,
> I think that should be a separate patch.

Alternatively, why not do the somewhat more obvious thing if making online_vcpus
per-plane?

Oh!  Is it because vCPUs can be sparesly populated?  E.g. give a 4-vCPU VM, plane1
could have vCPU0 and vCPU3, but not vCPU1 or or vCPU2?

That's implicitly captured in the docs, but we should very explicitly call that
out in the relevant changelogs (this one especially), so that the motivation for
using vcpu->plane to detect validity is captured.  E.g. even if that detail were
explicitly stated in the docs, it would be easy to overlook when doing `git blame`
a few years from now.

