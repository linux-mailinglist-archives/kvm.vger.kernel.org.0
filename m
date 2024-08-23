Return-Path: <kvm+bounces-24988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC60795DA0F
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 774A01F21FCB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDBC1CCB5E;
	Fri, 23 Aug 2024 23:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oajxsVtB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116101CCB4A
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457522; cv=none; b=tjIo5E7mRKZlmYGnYHMixZwRi932tgFPmwtVgA8c4qJ6EkCtaowUADEnSAH+gxHNOqimOPjacywj7zGnswPaKtMeJxKmEQ76k8woIPJx5b/hJ5IybJtayXo8JranvbUiiR5fVKq/ZyrV3c5BB2wggVEaEXo20vQFuc2EvwMLbj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457522; c=relaxed/simple;
	bh=EZnDiP+H4EwOKgX7qkLqjYtgAGsjgTHhpEH2SYUK4xw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BXfUqUjBD2iks648SR8vpwAJnHenMcboqqkuqoTdHlJhqvnO0dxo88TXalMkCAs2vpW+zDxO8OXo4zQrKNOnkl+S0FhbwSjP6E9qo/cyHUel0WM49B0hi4M/68vugWSEpVr7XKrxr7WUNCYSu++u4NYi3Cm0KJli252VOJ0IdyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oajxsVtB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cf546bbcffso1105933a12.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457520; x=1725062320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rR0a1BvyppOzWFu9WKacrQqpVmdl/25JJw93CQIjilE=;
        b=oajxsVtBhdj1US0x2DYYzAbsBJE7pEi7e5Tp8BzI5My1ncjd3rIbINYZEQrSeN3DRI
         TaAF3OvyomQOyI+nWb9FVOr+hwIuKCjvRRSAjdUd+6SXbIVxUw2DgPvjTpZi1jbncE4a
         06ztmhZNOXgOFPCc30tNXnuajZjuFfbvtj2Nh1WaX/h1aKbFHtBR8UsUQZ5JXBa5hdOo
         Fhm8oVIaDaAPBK6vXOFuRVl6kecXQx50JaNlc3+ygEgnb2CpIMEBmJKDeF1RKl8JVGBu
         8VJNWsCnd6yXP/AsU2kPy4qoGZXyHhN8KSWdkpxPEAwEgM0uiAsjBZopBQTWbPBqTM6N
         UciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457520; x=1725062320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rR0a1BvyppOzWFu9WKacrQqpVmdl/25JJw93CQIjilE=;
        b=AdwG8uKfvfySm1OVldg1Ddg1bL8mD3QCPr1AkEmFCACx1tQa8KG5/QA3gzOyZsU+k8
         YVC35dB3N75yY09oyZBim+/tpCXugPthfUcBLhFot9X09OTb8uzOE/hCIJHIAiQDKhAh
         UFcjdY1voJNele2TuJi0TTBRNfMDNlZ5PmD7DIdZhkMUz6cGwC0lMazpboFtjsuEXCAc
         uYW7916TpoZmsRkKW1mLs51ABoY7WnLMIJY2uX8xJqSpoXzZIdIbv/oXKLEAw7qevgRy
         LLeTP6s2mSfAdFNrWQD/VxVY+rtrxOb8ooaeRz+cshulZqa5r15gwBWJ8dEtp+1rX75F
         q8Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXiFIAE5qztnJtjwK3NPUxZj/4DWMDMak6DY9iHlrNiKUQVQPYQ3uQcRp4uWhYHZm9/95s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQOE/Fe9gxyRxz8Au6y1eiAa1o8z9wjdr9KkKSpNXav8WSPmdn
	EPZ5wl078xe1gcpW1SZN/VpjvOSFrH0hF4pJUIj+i6XJNwp5oGx3SxeuOfJZ/l1PLWctppvKBQz
	rdA==
X-Google-Smtp-Source: AGHT+IG5VtW+JpePTOa8v1oWLzCJ3MY+DXJlX9JgMVSjvzgFJr+VY3CC4ZhaQ8GeVnaLr8IUKRsezzzkiFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50d:b0:203:616a:8673 with SMTP id
 d9443c01a7336-2039e4d5cdfmr3410755ad.5.1724457520203; Fri, 23 Aug 2024
 16:58:40 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:48:09 -0700
In-Reply-To: <20240816130124.286226-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240816130124.286226-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443886668.4129032.11970184788806787426.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: hyper-v: Prevent impossible NULL pointer
 dereference in evmcs_load()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 16 Aug 2024 15:01:24 +0200, Vitaly Kuznetsov wrote:
> GCC 12.3.0 complains about a potential NULL pointer dereference in
> evmcs_load() as hv_get_vp_assist_page() can return NULL. In fact, this
> cannot happen because KVM verifies (hv_init_evmcs()) that every CPU has a
> valid VP assist page and aborts enabling the feature otherwise. CPU
> onlining path is also checked in vmx_hardware_enable().
> 
> To make the compiler happy and to future proof the code, add a KVM_BUG_ON()
> sentinel. It doesn't seem to be possible (and logical) to observe
> evmcs_load() happening without an active vCPU so it is presumed that
> kvm_get_running_vcpu() can't return NULL.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: hyper-v: Prevent impossible NULL pointer dereference in evmcs_load()
      https://github.com/kvm-x86/linux/commit/2ab637df5f68

--
https://github.com/kvm-x86/linux/tree/next

