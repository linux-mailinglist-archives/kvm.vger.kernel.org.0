Return-Path: <kvm+bounces-15010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 837488A8CE3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D4B1C2105C
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C5239877;
	Wed, 17 Apr 2024 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMGtJeKo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356EC25619
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385690; cv=none; b=PuNr5G/vHny4VWbycVj06V0rD6ncwIZNP1U7DQYy6v7ZbJnObPfxAwdonYnej62370py/Nwt/dEczc5YNWsZyb7g4MMOOtaFl3cVZIy4NyEYsS9+IbbgStwPO5/olQq5AHNV849dLYqVXWnAy4yReEmQdMNNZVH4NH7iaBgUdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385690; c=relaxed/simple;
	bh=TKa18tGzAfrtBiHI97dQCwDXkQzwG1WcyFcf/12hjHE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e/oQod9ij3ROemeRYkWA3wMLw1vRD3QP2PgkEUuN+LjONZVEGvBF1RsQ+SaixU9+dxM7d1PYXAIIkzzcHPYNx4xdCvuCnVkq3n9lRJyYZKwrcUDlcJXIwHiE0BlDVezDVn+jp/u3FgWkgjbYKY2qQwbpv/XOP++UOaFSjINgA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMGtJeKo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a20c33f06so1106767b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 13:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713385688; x=1713990488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8rpi8+pt1UAh2lq4JjPOfu96xW6K+NN18uPPlVeL70=;
        b=yMGtJeKorKMyFrQJcIiNa+LxqdGWuBp4gY+Jikkm9CThfRtFSumaiBNQ8O46Eg+6Kk
         yFtt08S60Ec72CFJ32UFV12lkUFyvHDwcgoeYrQ1/VFhv7hKeRadJnajaJy7f0PuNvdk
         kkmWp47xsq2BiETjsQBFXgVRc2POXoqw9xoa9AJOOWCOGeW1Q4y995LR5NjIkOWOVVFC
         h6gnKRuGHsexZc4Z3M6+Upq2jug1F6TdZgXThHxAbOG9EET5D4B6iinDfM5N4XkcHvvp
         4M31pZk/4nE6ru8+1Fc08JxCuLDIBjwE+3QJpbcmplxwZz83lN8o7PK4ja6bRFkaEZrn
         kj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713385688; x=1713990488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8rpi8+pt1UAh2lq4JjPOfu96xW6K+NN18uPPlVeL70=;
        b=o5ezgHfHOe0z1kKcaKB305Zm1y+qP5JthYnbh6RNxngqJAkl1hH9eoSmrImjbZKFvE
         MencC6Nop4Ep7lGpVx0ILt42D9q9qmdB7g4cFj3sQo+RHs5/U/5ZWPabE+aUlaodTmSA
         J6Xyo8/uNGgLpTVutJ559tRrWR+bTEtoZZT9k01gEOw7Og3a1lLTd97NdfNAfYFjk33+
         WahNPKKdRt5Hi9FSVT0Ay/33eeV7Vecm5qRWjMBRsArokQWbOgyIy7BAn5nq6Y3xc36Q
         deVkAjAdjFi3OBdxKd8zev9iVWtRZj9mYOxX5dyajh995f4PvIuTYBHYVB+yRTLnmDHF
         jAUg==
X-Forwarded-Encrypted: i=1; AJvYcCXmsfwGaY857mkMRjqZYInsVqlCizB0D1PMV5M3ykX88fs0AiKbMrMuoji2hijakU3BV1EtSgkpmjyIWCIq4zK4GHL6
X-Gm-Message-State: AOJu0Yzauz2eHV6Ba5HXecmvCOg8WsQirYl6NK39rPfdG9P1CrYPO2/z
	7w8VL4HZBWq+BuHO663aey7M29m1nqUF0er1IhoVWdcg8Rx+ZAplJpW+8eM1y4M1hH07PAbrOPh
	/eg==
X-Google-Smtp-Source: AGHT+IFhJMi+k8vbtha0g5GO0c7KEfVkisb1ShxsP0uYBV363cNoXzS6Y/3HV3imow+Sivxokcm9sC0algc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d808:0:b0:61b:11e0:a98c with SMTP id
 a8-20020a0dd808000000b0061b11e0a98cmr74105ywe.4.1713385688298; Wed, 17 Apr
 2024 13:28:08 -0700 (PDT)
Date: Wed, 17 Apr 2024 13:28:06 -0700
In-Reply-To: <20240417153450.3608097-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-2-pbonzini@redhat.com>
Message-ID: <ZiAw1jd8840jXqok@google.com>
Subject: Re: [PATCH 1/7] KVM: Document KVM_MAP_MEMORY ioctl
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> +4.143 KVM_MAP_MEMORY
> +------------------------
> +
> +:Capability: KVM_CAP_MAP_MEMORY
> +:Architectures: none
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_map_memory (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `base_address` and `size` were invalid (e.g. not
> +             page aligned or outside the defined memory slots).

"outside the memslots" should probably be -EFAULT, i.e. keep EINVAL for things
that can _never_ succeed.

> +  EAGAIN     The ioctl should be invoked again and no page was processed.
> +  EINTR      An unmasked signal is pending and no page was processed.

I'm guessing we'll want to handle large ranges, at which point we'll likely end
up with EAGAIN and/or EINTR after processing at least one page.

> +  EFAULT     The parameter address was invalid.
> +  EOPNOTSUPP The architecture does not support this operation, or the
> +             guest state does not allow it.

I would phrase this as something like:

                Mapping memory given for a GPA is unsupported by the
                architecture, and/or for the current vCPU state/mode.

It's not that the guest state doesn't "allow" it, it's that it's explicitly
unsupported because it's nonsensical without a GVA (or L2 GPA).

> +  ========== ===============================================================
> +
> +::
> +
> +  struct kvm_map_memory {
> +	/* in/out */
> +	__u64 base_address;

I think we should commit to this being limited to gpa mappings, e.g. go with
"gpa", or "guest_physical_address" if we want to be verbose (I vote for "gpa").

> +	__u64 size;
> +	/* in */
> +	__u64 flags;
> +	__u64 padding[5];
> +  };
> +
> +KVM_MAP_MEMORY populates guest memory in the page tables of a vCPU.

I think we should word this very carefully and explicitly so that KVM doesn't
commit to behavior that can't be guaranteed.  We might even want to use a name
that explicitly captures the semantics, e.g. KVM_PRE_FAULT_MEMORY?

Also, this doesn't populate guest _memory_, and "in the page tables of a vCPU"
could be interpreted as the _guest's_ page tables.

Something like:

  KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
  for the current vCPU state.  KVM maps memory as if the vCPU generated a
  stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
  CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.

> +When the ioctl returns, the input values are updated to point to the
> +remaining range.  If `size` > 0 on return, the caller can just issue
> +the ioctl again with the same `struct kvm_map_memory` argument.

This is likely misleading.  Unless KVM explicitly zeros size on *every* failure,
a pedantic reading of this would suggest that userspace can retry and it should
eventually succeed.

> +In some cases, multiple vCPUs might share the page tables.  In this
> +case, if this ioctl is called in parallel for multiple vCPUs the
> +ioctl might return with `size` > 0.

Why?  If there's already a valid mapping, mission accomplished.  I don't see any
reason to return an error.  If x86's page fault path returns RET_PF_RETRY, then I
think it makes sense to retry in KVM, not punt this to userspace.

> +The ioctl may not be supported for all VMs, and may just return
> +an `EOPNOTSUPP` error if a VM does not support it.  You may use
> +`KVM_CHECK_EXTENSION` on the VM file descriptor to check if it is
> +supported.

Why per-VM?  I don't think there's any per-VM state that would change the behavior.
The TDP MMU being enabled is KVM wide, and the guest state modifiers that cause
problems are per-vCPU, not per-VM.

Adding support for KVM_CHECK_EXTENSION on vCPU FDs is probably overkill, e.g. I
don't think it would add much value beyond returning EOPNOTSUPP for the ioctl()
itself.

> +Also, shadow page tables cannot support this ioctl because they
> +are indexed by virtual address or nested guest physical address.
> +Calling this ioctl when the guest is using shadow page tables (for
> +example because it is running a nested guest) will also fail.

Running a nested guest using TDP.

> +
> +`flags` must currently be zero.
> +
> +
>  5. The kvm_run structure
>  ========================
>  
> -- 
> 2.43.0
> 
> 

