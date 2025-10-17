Return-Path: <kvm+bounces-60357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9600EBEB0A2
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 19:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6BA5856BC
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BA42741BC;
	Fri, 17 Oct 2025 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVI+k4Z6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C52FD1CB
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721019; cv=none; b=sFXnL1TUKrXOxd+FDC24qoRoqfsadDyPR00rIeAqTYnmEfid+XdJG8WOEbmbR/d5Qgj9dcNLjz+1uq1m1gLKxbhU37Oo/0XLiftoxV4qE+FQbI+0nmwvvJVer7pBh2hTlKuepkK8CwTXa1FyhhRT+qF/7r97KvSJ0rzGq24MNRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721019; c=relaxed/simple;
	bh=BCRpauX8EGhu4tSnjwT10f6Zoi0e1G8sa0Y+n+4d9jU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X9LwA5TSulOhla1giGCcu9+hhL/Dt2uAgcioTUGqaCdkdxLraAxbzOzrfjg4V5D/UwltDQw3eP+ZH2uCOCkE8GO3QYNBeEhSuOhb0bNYrbRRVJT7uF2ZqxqdWF5pDsLBAzc0bKHaem5BNfA2d1wM4hFont9sI0tJFaPyJ4SH3yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVI+k4Z6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so1886824a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760721017; x=1761325817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifJ61lnza1eEGqNIU2Rf5rvGvVu/vXThPUsXhboidrg=;
        b=zVI+k4Z6Cy6sddsCxrfaxyq6+Q03PJPwFqVlMfjQPPGIxpoRG9h5SqhCTFLgJCmi+2
         hNnjyXSjLLFLcLqFueZM4cGZYRwxmFddiAVLMt27k9KMzJJjB4J678mX3uDj1fFtA9B8
         MKfAEVnSMkDwHbzOULeqjGIhPEIpKXcUTfUiq1EIo6g7w3zaPtAzblQKTtUCbw6SbIIl
         6PETpKyyNd/CzBuzz2CYcUyMBXzELt+IU4yVdZ8/4nPirXrBlwRLe935YcYWQBROEbDk
         amTQplxvAUcWesInqjkeieu+qAp3SurVA34XFn/Kxp2oSQ2PtWCiSfuKNrlzQoEHdc0w
         1WMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721017; x=1761325817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifJ61lnza1eEGqNIU2Rf5rvGvVu/vXThPUsXhboidrg=;
        b=ArI/D8Couk6p06zRsalFbVFjvc6neEpSgZd6MMzqBnRWgYnpLKVFjZUbiZiHTe/DrZ
         u9CEdmoYxjf5Zx4zBSPdWQcGqWKe9Hbqd3SV0QCG2hoSnwOWh0LRLLjX9a5HcRH2s4Ca
         MKhUbrfZyH+FSLnGSwYNKr9d31fd3U2ajTufQcRQbWqSPwOVB8b61dJfV+AVNvVKFXHk
         a3pXjEFzbERmYBOQp2OWsfMPIg8BReJ8yXysVtXWNXvRh9lVnSQ4zgHx8yTGKrbuQN3j
         hClQy1ldPS6qsu/1MPFuejWPxcn3f95tz3OWyCOdww4gwEHVStadfcTPePRDCILZBLf2
         Lpgw==
X-Forwarded-Encrypted: i=1; AJvYcCWo0MTnenfINhkSk+I8Xa7AfD+4acJ6Z6uG3JpLjexBnR1YSllX5LQnYPtlxT92uiYJTxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxbpkR6eBWpKwY8X2CSz0JvjkYKVX/LPSkB3wvAahsi6kQmdhU
	hZFptAGVeytP4aW/Iht17DLQ4V6yN0vbPa7zMz8ALhzRGcHOxodHtqrnL69l9uKd32BeOJfhau1
	6VlJwVA==
X-Google-Smtp-Source: AGHT+IEUYB0R7dtvKf9oX+a/EZzYYKzh3p3ExodHlnWKuRtJXwDliYrt7t1caDRrBgIsgz5MAIKuOjmjxVk=
X-Received: from pjbgz13.prod.google.com ([2002:a17:90b:ecd:b0:33b:51fe:1a72])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c0e:b0:33b:c5de:6a4e
 with SMTP id 98e67ed59e1d1-33bcf853711mr5333787a91.5.1760721017415; Fri, 17
 Oct 2025 10:10:17 -0700 (PDT)
Date: Fri, 17 Oct 2025 10:10:15 -0700
In-Reply-To: <aPICkLKEMFI2OouB@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com> <20251010220403.987927-3-seanjc@google.com>
 <aPICkLKEMFI2OouB@intel.com>
Message-ID: <aPJ4d3frVpRA7WKG@google.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, 
	Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Chao Gao wrote:
> > void vmx_emergency_disable_virtualization_cpu(void)
> > {
> > 	int cpu = raw_smp_processor_id();
> > 	struct loaded_vmcs *v;
> > 
> >-	kvm_rebooting = true;
> >-
> >-	/*
> >-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
> >-	 * set in task context.  If this races with VMX is disabled by an NMI,
> >-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
> >-	 * kvm_rebooting set.
> >-	 */
> >-	if (!(__read_cr4() & X86_CR4_VMXE))
> >-		return;
> >+	WARN_ON_ONCE(!virt_rebooting);
> >+	virt_rebooting = true;
> 
> This is unnecessary as virt_rebooting has been set to true ...
> 
> >+static void x86_vmx_emergency_disable_virtualization_cpu(void)
> >+{
> >+	virt_rebooting = true;
> 
> ... here.
> 
> and ditto for SVM.

Yeah, I wasn't sure what to do.  I agree it's redundant, but it's harmless,
whereas not having virt_rebooting set would be Very Bad (TM).  I think you're
probably right, and we should just assume we aren't terrible at programming.
Setting the flag in KVM could even hide latent bugs, e.g. if code runs before
x86_virt_invoke_kvm_emergency_callback().

> >+	/*
> >+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
> >+	 * set in task context.  If this races with VMX being disabled via NMI,
> >+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
> >+	 * to virt_rebooting being set.
> >+	 */
> >+	if (!(__read_cr4() & X86_CR4_VMXE))
> >+		return;
> >+
> >+	x86_virt_invoke_kvm_emergency_callback();
> >+
> >+	x86_vmx_cpu_vmxoff();
> >+}
> >+
> 
> <snip>
> 
> >+void x86_virt_put_cpu(int feat)
> >+{
> >+	if (WARN_ON_ONCE(!this_cpu_read(virtualization_nr_users)))
> >+		return;
> >+
> >+	if (this_cpu_dec_return(virtualization_nr_users) && !virt_rebooting)
> >+		return;
> 
> any reason to check virt_rebooting here?
> 
> It seems unnecessary because both the emergency reboot case and shutdown case
> work fine without it, and keeping it might prevent us from discovering real
> bugs, e.g., KVM or TDX failing to decrease the refcount.

*sigh*

I simply misread my own code (and I suspect I pivoted on what I was doing).  I
just spent ~10 minutes typing up various responses about how the emergency code
needs to _force_ VMX/SVM off, but I kept overlooking the fact that the emergency
hooks bypass the refcounting (which is obviously very intentional).  /facepalm

So yeah, I agree that exempting the refcount on virt_rebooting is bad here.
E.g. if kvm_shutdown() runs before tdx_shutdown(), then KVM will pull the rug
out from under TDX, and hw/virt.c will attempt to disable virtualization twice.
Which is "fine" thanks to the hardening, but gross and unnecessary.

Thanks so much!

> >+
> >+	if (x86_virt_is_vmx() && feat == X86_FEATURE_VMX)
> >+		x86_vmx_put_cpu();
> >+	else if (x86_virt_is_svm() && feat == X86_FEATURE_SVM)
> >+		x86_svm_put_cpu();
> >+	else
> >+		WARN_ON_ONCE(1);
> >+}
> >+EXPORT_SYMBOL_GPL(x86_virt_put_cpu);

