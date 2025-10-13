Return-Path: <kvm+bounces-59943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E128BD669E
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4E77734DF0F
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 21:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF822FAC16;
	Mon, 13 Oct 2025 21:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="esP8N1wr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACBF2DF13A
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 21:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760392454; cv=none; b=fi7LOSj9ZWd5JFntjGDFW3emnVPqvXQiT+zjhm69i6Fn019/b1cTfsGi9po4j7UgOcasZcaW1HK4nuIBxgSOWk3YP5qCBZbkzmBiPy7MDVVKnpeO7gkIe5o7x9gk10p0imursqmYOLcUTaoOV6yom5eIR8C+3JvpiwYbhJsME24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760392454; c=relaxed/simple;
	bh=c8PgEYT1UO/0f1Wh2jOegSR8o5GUTjmlEtS5G3nllTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ACiklF/rersjwz7gdbd/+axURXQTPKD85YNtsq1ljn+gHCo3Y6g/hHc8qurHy5sJt4FYneTuK2vbTo332jv//sWzhyvkx5co3j1RdzXU5PMG5sCpf3OxgANcOVs/9NW84O7G8XvdoHIiJ1qqupFK2zPqWsWuYVA2tHcTaiXVq6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=esP8N1wr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57c2371182so8808255a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 14:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760392453; x=1760997253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+QP3Cy0vKPQw+tIJxZZU82amYw2x80Sms+suxE5xk9Y=;
        b=esP8N1wrxTGlJPV4qIraBmdCvN8xfCR7twttGlRbHytVkVzftTXloMt7dYBhPKRpEe
         vtD3D+Lr5WoPcUx4m3BE0WZAonXJuY/Lr8tzsZcWGCnDttGTD90gf3nI6o4LpOhUWqAv
         1csQ8sOUJrxLOGsjefNUoPL2gew6Jz3bHPbRyQUD83e5W/WzMMRnVu0+X6jmvFRXJmL0
         vR/I4cLRJ7nkYqhlFb1F6USMOrIRc3M6vkJNQnVwtUHoJapOsV2lxTgvWY+DN2MKHX21
         VgqJPIHdEaolKO6d7Xj9dsgOuL29gN87Ayx/5dbUNkFbDKV0s02H4sdz93GbARJdhYIH
         MAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392453; x=1760997253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+QP3Cy0vKPQw+tIJxZZU82amYw2x80Sms+suxE5xk9Y=;
        b=dVToFkVOm0aV/ESaDdmBO1PTMEZsbwz1RmWuCt5ETATvkdl2MMUMKu8ocZcIiOr49y
         wCCwz9V+eAE5uUNdGlf9wZZ2oTp1X/SNQkHO3sYUi0gKA3d6tgcUlzH29oOR+AKNIKZC
         0W304IvJEjTR0/4V66rFq8V2MSFPdwOYFOEImSSd2yiqBWyK55zTLNy7SpxCkedpHv2p
         Z7tRpulZIwPAfvJqZYgjyTTa4f+T4zeh4Yuplca45aOS6bntnGMD+/iqeUi733FNTdXx
         CaTyeXmQ5HAz3PdFZYPNz+/MeepeCwpN063hJlhZAIt0fUL/yn+fdsIp3bGYy5/Il5wQ
         fKWg==
X-Forwarded-Encrypted: i=1; AJvYcCU3nj/ADhxsPLF7RGOKZ/Rq19MM3dK1G/w/CORx3QJJGMq+hU2rRORxcQmOGQ/2NuDYtN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxranMr34MvWmiEfd7QyEbg1o7WP9jvYwmg0pT/BfpP97TSHtal
	KAmObw1vn3TxPjeWxlq1kGLBRg/9E7rbjNntwQulT0IaZF66vTGobHp1hn23P9feoUBPW5M8eU4
	xJvjUBw==
X-Google-Smtp-Source: AGHT+IH+OvpGiH0IgYJpMd8LjnAd5lINrWxs0pvJ0oYogGsEcPQWDdgkN8WnNPjHzTrFeO+4uDyp/AksaYY=
X-Received: from pjbst8.prod.google.com ([2002:a17:90b:1fc8:b0:330:523b:2b23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0b:b0:2f5:6466:af20
 with SMTP id adf61e73a8af0-32da83e40c1mr33805676637.40.1760392452762; Mon, 13
 Oct 2025 14:54:12 -0700 (PDT)
Date: Mon, 13 Oct 2025 14:54:11 -0700
In-Reply-To: <20250922162935.621409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com>
Message-ID: <aO11A4mzwqLzeXN9@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Aggressively clear vmcb02 clean bits
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Jim Mattson wrote:
> It is unlikely that L1 will toggle the MSR intercept bit in vmcb02,
> or that L1 will change its own IA32_PAT MSR. However, if it does,
> the affected fields in vmcb02 should not be marked clean.
> 
> An alternative approach would be to implement a set of mutators for
> vmcb02 fields, and to clear the associated clean bit whenever a field
> is modified.

Any reason not to tag these for stable@?  I can't think of any meaningful
downsides, so erring on the side of caution seems prudent.

