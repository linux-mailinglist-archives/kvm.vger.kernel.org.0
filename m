Return-Path: <kvm+bounces-59548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E89BBF2D3
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 22:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17FFB189BD58
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 20:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5522DC341;
	Mon,  6 Oct 2025 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yW4oXocW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8DF242D6B
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759781996; cv=none; b=YWyYZplul5PXk9+4WDD8fyqNuGi/UxY3zrMM9fWaX6Bc31cMCLfDRAmoGxkQpotUOgjsyRcRK41R7QUKl+Iz3pq3vi6ZTo7/CluJyDonCgg2w3wEJgl4Qfjgeu19KUVjuimDVdypS6jexwiRL/6uxyy7cxnCP+p8gZi+umJDZI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759781996; c=relaxed/simple;
	bh=/SYC2F5CivU54FwucLiYMKq6VGD4NHmrnyTKCQAvMpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nq/JcH8EtfiY/enlMY+4q6v8SlNspntoy3thu7DJJPGM3dZe3Wn/4H7eVg6904EfCDFMV54tQCsRHkpwcMPnEo3K8tS0YY4nJnEyhkLstI1u/OjFfvxWOM8w2JKXwRQ8b1qukGFX1L19yer6z7mG62TiVCviC8Jm3nJQk8NHp0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yW4oXocW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269af520712so57222085ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 13:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759781994; x=1760386794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9pN3I+qDlRm86RsLpONZsIyYY5NvfWVzalcxaJr2Pds=;
        b=yW4oXocWW14Dg2vFl/jgQyfg4+dizJ1sxK1o7D3TCJCt+P1m0sbaavf5A1Ve3e3mQ1
         cxJlYIBl61ursrpp8Wr4PhVn4KNy7qXLYnhwE6Z1PQuyXezDKaOwSHSPK2tOSLUigvty
         zsuhNDKlm8anfz7ldVPOSU5RmVqa8CSlxlz7Cc3NFiqNPXtpHl4+jzOs7+Gqb8ir3S1/
         I2wROZWTMon/AaEBwiKMRJuZmWZcjn/C5hsRDhXDVRww60ajFCBWITCeWMlGhwaX8njn
         394LPrzrmIoRP2nkg/9kP2NFjOl/OdKVGMLXSfo7jHrIj62SFtXdB0cOQ+15dgKOBwd9
         J00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759781994; x=1760386794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9pN3I+qDlRm86RsLpONZsIyYY5NvfWVzalcxaJr2Pds=;
        b=gwZ+6VZXm1EO3YucrOzhs6H79a94+Aq40ahKXUhENBlGBlIE5XScJmojdWzJGj6o0x
         et43OVOyCKdekoJKDHogatAWhDse6YBle2iJufZu38VaT3oXXG5DHeNn8pX7xueltdfg
         +JaFIEDZ/kjp3UTlsFKy1REFcuNoDoaC5dK4zTrzVInjRdlTlrYNEItZ89vEowdUryEW
         LuiacRmMGxKI0zBpYJuUa2XNa0jEGgKjl9usc5IxHRqvhFPfgDYoL5OTvQ7hNslX4YaD
         DS5KX+mew0Nr6uB2AebjCram9Xv1eRPqZwBs8fozGE4uEIzzPxchJ4pYl2jjfrKVWqtp
         cl9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyV36dufWuKhXu9Tn4p8JrZ8gF+wVMhkPnw3VVz8kgOCT6gNVKF9ukK+ZXmrsYcnrZlVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTVAa9jlrzrkrhg6SnpEiA6M0RVlyEmFQLi091lWHdbypyc1Ic
	GicOAOGAl+EMPOwW4c+/IW9V274V/h14rlnHAnGBLhraxGlu06RejW7Jgm0wJc7NPIQqD+trDJH
	8xr9lng==
X-Google-Smtp-Source: AGHT+IG+dPypssAxxB1AhIyikjpakIZz2qhMM7F+pWzPuRCSHZx5xpLGrwjB3vBabj2YhH49dtdnSu/VJJM=
X-Received: from pjxx8.prod.google.com ([2002:a17:90b:58c8:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc86:b0:267:f7bc:673c
 with SMTP id d9443c01a7336-28e9a656997mr180158905ad.44.1759781994498; Mon, 06
 Oct 2025 13:19:54 -0700 (PDT)
Date: Mon, 6 Oct 2025 13:19:52 -0700
In-Reply-To: <diqzplazet79.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-2-seanjc@google.com>
 <diqzplazet79.fsf@google.com>
Message-ID: <aOQkaJ05FjsZz7yn@google.com>
Subject: Re: [PATCH v2 01/13] KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 06, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Rework the not-yet-released KVM_CAP_GUEST_MEMFD_MMAP into a more generic
> > KVM_CAP_GUEST_MEMFD_FLAGS capability so that adding new flags doesn't
> > require a new capability, and so that developers aren't tempted to bundle
> > multiple flags into a single capability.
> >
> > Note, kvm_vm_ioctl_check_extension_generic() can only return a 32-bit
> > value, but that limitation can be easily circumvented by adding e.g.
> > KVM_CAP_GUEST_MEMFD_FLAGS2 in the unlikely event guest_memfd supports more
> > than 32 flags.
> 
> I know you suggested that guest_memfd's HugeTLB sizes shouldn't be
> squashed into the flags. Just using that as an example, would those
> kinds of flags (since they're using the upper bits, above the lower 32
> bits) be awkward to represent in this new model?

Are you asking specifically about flags that use bits 63:32?  If so, no, I don't
see those as being awkward to deal with.  Hopefully we kill of 32-bit KVM and it's
a complete non-issue, but even if we have to add KVM_CAP_GUEST_MEMFD_FLAGS2, I
don't see it being all that awkward for userspace to do:

  uint64_t supported_gmem_flags = kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS) |
                                  (kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS2) << 32);

We could even mimic what Intel did with 64-bit VMCS fields to handle 32-bit mode,
and explicitly name the second one KVM_CAP_GUEST_MEMFD_FLAGS_HI:

  uint64_t supported_gmem_flags = kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS) |
                                  (kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS_HI) << 32);

so that if KVM_CAP_GUEST_MEMFD_FLAGS_HI precedes 64-bit-only KVM, it could become
fully redundant, i.e. where someday this would hold true:

  kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS) == 
  kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS) | kvm_check_extension(KVM_CAP_GUEST_MEMFD_FLAGS_HI) << 32

> In this model, conditionally valid flags are always set, 

I followed everything except this snippet.

> but userspace won't be able to do a flags check against the returned 32-bit
> value. Or do you think when this issue comes up, we'd put the flags in the
> upper bits in KVM_CAP_GUEST_MEMFD_FLAGS2 and userspace would then check
> against the OR-ed set of flags instead?

As above, enumerate support for flags 63:32 in a separate capability.

