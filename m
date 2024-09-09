Return-Path: <kvm+bounces-26140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00CCE971EBE
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 18:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64B41B22107
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 16:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91124139D1B;
	Mon,  9 Sep 2024 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XxrsWFrP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B31BC40
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725898057; cv=none; b=OHIDQhxbcNDQSQcSXWGQRhHqkKqQUjQM5kzVhdzx9V5g3g7qCNs/mH2T1jPVqzfZP1SjKdTL3QzsxxKEFwi6+HAH8XbHfP9AzpjrqX39tfuxLkC0E88ZWVOgrSNr7vMESHM/ncvYbyA11p03w4Sytp2wjLrSlDUV/nlfaFcIiAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725898057; c=relaxed/simple;
	bh=f6yvKNsFjmjzWxrkN5lhYMejTXn6xE6/txpSzmpV8dU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISjOSrC7wm0r29zGUZweb+0AEp3mK6V733BJPnSwsn9rguc3mjuWBJg5D8c1NNs6NY7aedg1IrDUu/081oOt81OzJCn8iOBNEPye9rvzSlrxCUCCCovXyezeyieoPAoXD7e9WfW6YenTjVeONr+qkFd/E5ex8L/Ziuk70k7+nAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XxrsWFrP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d876431c4aso4750228a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 09:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725898056; x=1726502856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOkcFs26faVAy+v5vuvM4jOtiHbzcdzkj3w0oqgWGOA=;
        b=XxrsWFrPqWMbZ/JaQBAYM0+gAK3AgT0DyiZu+bTmV8ZUU9OXpdaPuhjbewQzj61Zat
         14qoNaM2mYJXSivJP3ZzFYBsgfrpjobQay64D48cyt2aZgxQVRqb8Z/vMq/glXbIR5+i
         ZJ/PjU+K/OTev86yyt17IKUBjG0ygEbL2jiov/Mn4551P1wHjDvjjGvO/LSGDmfcHQaM
         wnngzP+vZCKs0VwTZYjvnn+ynO4EwpeMyR3LMKu4DM+yZ0070BmJUhsAu/f7Gi6E/lDA
         +FZaaT7JrJcI6vcDfis667RyEkXCillPptCreGonz2fB4T3YEk7q+Y+WDFpDMMDGfXBK
         NxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725898056; x=1726502856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOkcFs26faVAy+v5vuvM4jOtiHbzcdzkj3w0oqgWGOA=;
        b=hVDp54fhvQ4Hh4iWglUuHk+ADnK5yfFMfXfpuM1OaisfkDOjN0Iw9X7IcflBtcshfv
         yj1w/wN1jdYeYl+sIRhVrYzajGno7eLEZgGtr1uZilyJy/Sgbdtb4KOSV7RMQseY3sQy
         +Rasiwye0PUy6Zd6UL9VOjZvnY1AhRGIynJrN9gGwOzpQy5laohaNU8vz1NFv+/A+sqI
         8hAi21oGbHzIGM+0eDfHpK3RnZKLmqjw6FWvXrJnLl+IYjXbdAhGI/Ui5etkp+vZT0Z5
         59AXyJOj0hMzfrJVulYBcUK9HIGvvA3xEUqzFK/V0Barun/aXiehJZXlbP2nBJ5l0KnY
         WPVg==
X-Forwarded-Encrypted: i=1; AJvYcCWiNi6JeFGbm+ZN1xsbyJXkl6urqISl7+HfqZqxGh4eyu2gmXlkzQrzwBerYmlgL6SOtLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDBOqtb9Au+IiNG5VGfYTBBILDiG1GakySMvJ+RoQMG2RwCt3x
	wW/3BwaI4svfDzv0JDMIOu0NDjIch2HwaB1IBS29nSJedejIQFx6C0zZjMv+2cIjOhvYvv7mVmi
	HnQ==
X-Google-Smtp-Source: AGHT+IGdS5AEspkaZ5HysEAAR8XN5A9j9iYho87mTahmA+y1bRLz6oeeqrWw8yM7G4QQcl3nJY5hkgKGlW8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1481:b0:2d8:bd72:c5e5 with SMTP id
 98e67ed59e1d1-2dad4b82644mr27082a91.0.1725898055523; Mon, 09 Sep 2024
 09:07:35 -0700 (PDT)
Date: Mon, 9 Sep 2024 09:07:33 -0700
In-Reply-To: <20240904030751.117579-5-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com> <20240904030751.117579-5-rick.p.edgecombe@intel.com>
Message-ID: <Zt8dRVdkT2rU31jq@google.com>
Subject: Re: [PATCH 04/21] KVM: VMX: Split out guts of EPT violation to
 common/exposed function
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, isaku.yamahata@gmail.com, yan.y.zhao@intel.com, 
	nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 03, 2024, Rick Edgecombe wrote:
> +static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					     unsigned long exit_qualification)
> +{
> +	u64 error_code;
> +
> +	/* Is it a read fault? */
> +	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> +		     ? PFERR_USER_MASK : 0;
> +	/* Is it a write fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> +		      ? PFERR_WRITE_MASK : 0;
> +	/* Is it a fetch fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> +		      ? PFERR_FETCH_MASK : 0;
> +	/* ept page table entry is present? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> +		      ? PFERR_PRESENT_MASK : 0;
> +
> +	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
> +		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
> +			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +}
> +
> +#endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e7b5732f35d..ade7666febe9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -53,6 +53,7 @@
>  #include <trace/events/ipi.h>
>  
>  #include "capabilities.h"
> +#include "common.h"
>  #include "cpuid.h"
>  #include "hyperv.h"
>  #include "kvm_onhyperv.h"
> @@ -5771,11 +5772,8 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>  
>  static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long exit_qualification;
> +	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>  	gpa_t gpa;
> -	u64 error_code;
> -
> -	exit_qualification = vmx_get_exit_qual(vcpu);
>  
>  	/*
>  	 * EPT violation happened while executing iret from NMI,
> @@ -5791,23 +5789,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>  	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
>  
> -	/* Is it a read fault? */
> -	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> -		     ? PFERR_USER_MASK : 0;
> -	/* Is it a write fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> -		      ? PFERR_WRITE_MASK : 0;
> -	/* Is it a fetch fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> -		      ? PFERR_FETCH_MASK : 0;
> -	/* ept page table entry is present? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> -		      ? PFERR_PRESENT_MASK : 0;
> -
> -	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
> -		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
> -			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> -

Paolo, are you planning on queueing these for 6.12, or for a later kernel?  I ask
because this will conflict with a bug fix[*] that I am planning on taking through
kvm-x86/mmu.  If you anticipate merging these in 6.12, then it'd probably be best
for you to grab that one patch directly, as I don't think it has semantic conflicts
with anything else in that series.

[*] https://lore.kernel.org/all/20240831001538.336683-2-seanjc@google.com

