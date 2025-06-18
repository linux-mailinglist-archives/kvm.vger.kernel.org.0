Return-Path: <kvm+bounces-49903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68345ADF7E4
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86291189C1A0
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 20:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E276D220F5C;
	Wed, 18 Jun 2025 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZsrSHb5o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CBB220694
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279155; cv=none; b=i4TjDhbVilEsJQYTp+yWus529Da4+vABTyjB0KFCBrbaPwKizPN73YWWwLpYJgCe84AifJrcNxA3de2qXfcqKVSRmecAl447vybMxHtydvb9cnr8MqP0OapW3/zLmut1ZgOVWBQWZ1F/xmJDWOGiuukqDrtXyt8WhzbRNeYOeN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279155; c=relaxed/simple;
	bh=/NM+ak0rLMjlCOg7dWPSQwADmJXEiX9mllS2HtmWndM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3KUx3hvYBUrWUJ12LlZkM1fGJOmtH2nwfGkACN5zsU9qxK0YU4Jut/FweoFcRlS4fp33mCf4ySwSfoBoqiXU0ix9q9KdK8/8B6/gNIEeflQojdVSzhqCV8B+pvLN/y7ItZvOh/tpgF18Lv4dAVG+kdbWS/0WSFd2WDw/sQu/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZsrSHb5o; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-710e344bbf9so986507b3.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750279151; x=1750883951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xd7fVESQIYURer+XcfloCFqoNH9nVlZcYjsVdYV2DsQ=;
        b=ZsrSHb5o7CPm7jkVJW1Wk+lrgdJb2t9toHvCpfvJuWlkNDXG/QIw60s/sCTxIaVal7
         UoZba6KvbXw5PwQb2xmpwpsd9ns8DKg6vr/YthpORgHjnD7ZT3givznH1bUKACI+dL6n
         Q1tgGSDz3iZEvw3B64uVTk1LgX532xL4s9TcwXDXuPPa4PW5S3qjwA1ls9baArnqaXQX
         faazgQWe9bYJYiBBWq3goh+abKjXqybClAyjz0vFs84MFrnrmPZBDBZaalVc35y93wKK
         Bs9+rHRMLsd/0afLdRa4Y50ekhTyJqfV7HaHhtAlhm2uGzIZEcvuv1Sv42ehiTGwIlD0
         +9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750279151; x=1750883951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xd7fVESQIYURer+XcfloCFqoNH9nVlZcYjsVdYV2DsQ=;
        b=chcMe1ukmERn3mf/uqNuIx2xmKBEcEbb6CShPV+HwHSJ9ZsPWEnBabQeEwtkAOyrTf
         iyhoq3XaoImk3M6j1lu9yL9BrS3oZvpv/isIGP6MnGI/a87/RlsEtZ3Emc/7eRSLDuDz
         LbuEdDkjAIEqKd3qvwiZZg6alTkwplCU4dJA5ON4V1S+4IQzD6ELkqpYcYTY1ghsLUfR
         BEVTZBDsSWolrVqKJLr9aeDmpRQJ69SFeE/lcs5h8qN+QuQMrpbAp0P6o2R4k/KTp4/z
         R0Yswpd5K7g3PCT5DMeElt35mNKJcFrbg9W28uIbEByYsGkx4kkjPisFMjpVn6HOx85l
         f8nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD5Ty4Kisw3dhvbCUlJSHXh5T089pKQp9OgjDAZ0bqG/uxpL8TsS44+Az5khbZZu3mqTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPAnpLUGLKN1wI8D4hdE3PNV3oUMZcH48mitgrV2CQkmXiyn5z
	BwMghGMKf/4mlN4XjBS9JZmF8nPCMKgcOl2FFYdVUqMvGne4EXnhbzmGrKgQd4V+SlB6zd3ATbF
	/qhttcVeCBoWI+5yJOGdV4RkgsuavBBMdTKDUL8vM
X-Gm-Gg: ASbGnctA1oaAB2AjdaXQlVQ4yy6zE7C7qjqVozNhRA5QXsoRHwJqpbuQi3MiE0zPUMv
	RP+Rb3z83aqiJAAnDet9l3waqLX4fW78z7gysZceALUyXgwnBHD0NJ3ETAMk285ZILN9/1LIgW9
	Zf+h9e7uTpQZwOmdIAcuenMLyoExQzU+9co6FyaEi/BOZh2iAKUW8NxQrwJqoGt8G9N/svvTygG
	DlhytCGnn4=
X-Google-Smtp-Source: AGHT+IH1NWNvanAK0XOjMJEe/GTsQrjRFVmMnXkKiISsTuc+7lPoCeqCpycNb+zFFUr9NjVAP8ZmiqXZcDijHwWFKtA=
X-Received: by 2002:a05:690c:7241:b0:70e:2d17:84b5 with SMTP id
 00721157ae682-71175203681mr284981287b3.0.1750279150493; Wed, 18 Jun 2025
 13:39:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev>
In-Reply-To: <aFMWQ5_zMXGTCE98@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 18 Jun 2025 13:38:34 -0700
X-Gm-Features: Ac12FXxtgm7oIFvlTJaEkpAlCqjTucv9lNobWhug7G4AqcUM4fEMOn24B5rvNUA
Message-ID: <CADrL8HXdBY-sxPJrKEKOzdyZ5C82dE3qUobQuh+LABgatCfgdw@mail.gmail.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2025 at 12:41=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Wed, Jun 18, 2025 at 04:24:13AM +0000, James Houghton wrote:
> > KVM Userfault consists of a bitmap in userspace that describes which
> > pages the user wants exits on (when KVM_MEM_USERFAULT is enabled). To
> > get those exits, the memslot where KVM_MEM_USERFAULT is being enabled
> > must drop (at least) all of the translations that the bitmap says shoul=
d
> > generate faults. Today, simply drop all translations for the memslot. D=
o
> > so with a new arch interface, kvm_arch_userfault_enabled(), which can b=
e
> > specialized in the future by any architecture for which optimizations
> > make sense.
> >
> > Make some changes to kvm_set_memory_region() to support setting
> > KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memslots, including relaxing
> > the retrictions on guest_memfd memslots from only deletion to no moving=
.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
>
> > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > +bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa=
ult)
>
> The polarity of the return here feels weird. If we want a value of 0 to
> indicate success then int is a better return type.

The way it's written now feels fine to me. I'm happy to change it to
an int (where we return -EFAULT instead of 'true' and 0 instead of
'false').

> > +{
> > +     struct kvm_memory_slot *slot =3D fault->slot;
> > +     unsigned long __user *user_chunk;
> > +     unsigned long chunk;
> > +     gfn_t offset;
> > +
> > +     if (!kvm_is_userfault_memslot(slot))
> > +             return false;
> > +
> > +     offset =3D fault->gfn - slot->base_gfn;
> > +     user_chunk =3D slot->userfault_bitmap + (offset / BITS_PER_LONG);
> > +
> > +     if (__get_user(chunk, user_chunk))
> > +             return true;
> > +
>
> I see that the documentation suggests userspace perform a store-release
> to update the bitmap. That's the right idea but we need a load-acquire
> on the consumer side for that to do something meaningful.

Indeed, the below test_bit() should be test_bit_acquire(), thank you!

(N.B. I don't think the current code could result in an observable
bug, given that the later write of the PTE has a control dependency
here. But it is certainly written incorrectly.)

> > +     if (!test_bit(offset % BITS_PER_LONG, &chunk))
> > +             return false;
> > +
> > +     kvm_prepare_memory_fault_exit(vcpu, fault);
> > +     vcpu->run->memory_fault.flags |=3D KVM_MEMORY_EXIT_FLAG_USERFAULT=
;
> > +     return true;
> > +}
> > +#endif
> > +
> >  int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                                                 struct kvm_enable_cap *=
cap)
> >  {
> > --
> > 2.50.0.rc2.692.g299adb8693-goog
> >
>
> Thanks,
> Oliver

