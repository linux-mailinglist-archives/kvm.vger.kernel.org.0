Return-Path: <kvm+bounces-66192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 621F2CC958A
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 20:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4C1D307D354
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 19:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BB3280A5C;
	Wed, 17 Dec 2025 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tk54E9qi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A991D63F3
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765998123; cv=none; b=qTK47Hxcm0usDnUmla+GoGnHG9PcZgY1dl26W6Kkm7HQXOKrEP2XIoZiUlO92nVZ5c42k5yWMakjobCGecRqGlmg7zSV93vgIXHQB66Ao3uEsQz8ZStkYn/53g7scQb3Wj833hgM7gon5FoG80zPKU9daNq6wNia5wyQ712HWZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765998123; c=relaxed/simple;
	bh=m8dUE8g1LgHdwHNkk7BZCZqvG8Sc2oxSqpY7oOcjwS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SZAzHG0Xs86QZkRYdvAf5t+7DwIPWXLt+ON++JVjjEimk6rivNfYF9gV0m0TaSBralkQz5Q/3y7ViXXusnNAa0+v/B4EiAtr2bBGrzcDLf/3BUHmfqomT7eu03ckdgVieIHmWHCpnOU+jQR3ViOr064cTTLiU8Y40nWSM/i4+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tk54E9qi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b90740249dso10108293b3a.0
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 11:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765998121; x=1766602921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b196TMa7CXfRLkl43jhb5OXtBZInCMzwhdlHo087zrU=;
        b=Tk54E9qi4MiMA0y5NpRq6xBFYTgmmnM2yLFUj29qnEYcV1illL9PbuISppdH6BzKdM
         /ldOqZtIlrL7KeI0WSBJIkqBO79rKbu9z6l7l957mjEzlFzgw60TQr7aC/k0ZmadNz9E
         WMt+TERJqdEMdYxtSNtHH85+EqwMUqKLy7Af2pajMmOPD7+I5JJmM0UQOm6ZVTm9Emmq
         FkrpsD1ePMTfyvrMdpzMAfT1TQJ8tnZL2LkML0QhaXpRngnc6LuzTQ/KUTH2di0zqz+z
         gYXMsfMkMPX0gukHF0j7w//SKQxqC5I9sO3v6xTsbeXR2tUGyWsCIpXUJBJo0QKg5ia/
         EsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765998121; x=1766602921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b196TMa7CXfRLkl43jhb5OXtBZInCMzwhdlHo087zrU=;
        b=ItPb6aebmj5aaMBNU4JzmMr2A5QKjj3FA1HABL0bo4UmEE3ZoRo3wkeWMU/rvl4qcP
         NE1becLipN9Qqf41oq1x6LHJ5k0SLUbH4jim6YaejW/yjIe1TqEm7Sbj6l/cvebdUaCa
         IlgkRVL+iiYkRAHy5SHuGnN3VYGDcZ44sEDDbnUb6OAyOoXnyHpGL9dYm+KN7UW5RoqD
         0YmWXpEZLJe9bvTiXL1gL66ZVoihz0E7YSkj10DrDUQE7KucqffF5GnnqgC9h2+UBfpo
         8HeigUGZqER4KZLAgFUHuZLT8VCaRb7laX9SgY11DDCdv9krBkaC1dqhsaWWtLYQ9fcM
         m9dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiG5aXsm93B/frxDo0L6kBw6ErZr6s5xc7WT9UonREt97coAAzZd9YF7SAAxVqdKvrcGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzygmjOysMmMhCUYhwIO8ESfWhxXqb/VngfDCVBQB26oDTs2I1k
	gAmMJ+BXhlMG+VsEsDTWINB63xqzXADCRKL9VC9ybHPkJDwPOrj4TAPjjAGtWmOUEnIq3VhaRyQ
	KiysWNw==
X-Google-Smtp-Source: AGHT+IGD0zDEZTKQcWsJyRh7TATbcIzYyFxP7Izy5G+weXhOkr6e/I6dVMxD5z7EImnePu9h8mI6YEz7V1I=
X-Received: from pffv13.prod.google.com ([2002:aa7:808d:0:b0:7f1:8c5b:2e3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8c11:b0:7e8:450c:61b7
 with SMTP id d2e1a72fcca58-7f671474d70mr18440345b3a.39.1765998121154; Wed, 17
 Dec 2025 11:02:01 -0800 (PST)
Date: Wed, 17 Dec 2025 11:01:59 -0800
In-Reply-To: <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <aTe4QyE3h8LHOAMb@intel.com> <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050>
Message-ID: <aUL-J-MvdCrCtDp4@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 17, 2025, Xu Yilun wrote:
> > >+#define x86_virt_call(fn)				\
> > >+({							\
> > >+	int __r;					\
> > >+							\
> > >+	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
> > >+	    cpu_feature_enabled(X86_FEATURE_VMX))	\
> > >+		__r = x86_vmx_##fn();			\
> > >+	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
> > >+		 cpu_feature_enabled(X86_FEATURE_SVM))	\
> > >+		__r = x86_svm_##fn();			\
> > >+	else						\
> > >+		__r = -EOPNOTSUPP;			\
> > >+							\
> > >+	__r;						\
> > >+})
> > >+
> > >+int x86_virt_get_cpu(int feat)
> > >+{
> > >+	int r;
> > >+
> > >+	if (!x86_virt_feature || x86_virt_feature != feat)
> > >+		return -EOPNOTSUPP;
> > >+
> > >+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
> > >+		return 0;
> > 
> > Should we assert that preemption is disabled? Calling this API when preemption
> > is enabled is wrong.
> > 
> > Maybe use __this_cpu_inc_return(), which already verifies preemption status.

I always forget that the double-underscores have the checks.  

> Is it better we explicitly assert the preemption for x86_virt_get_cpu()
> rather than embed the check in __this_cpu_inc_return()? We are not just
> protecting the racing for the reference counter. We should ensure the
> "counter increase + x86_virt_call(get_cpu)" can't be preempted.

I don't have a strong preference.  Using __this_cpu_inc_return() without any
nearby preemption_{enable,disable}() calls makes it quite clears that preemption
is expected to be disabled by the caller.  But I'm also ok being explicit.

