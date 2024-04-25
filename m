Return-Path: <kvm+bounces-15891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3188B1A78
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 07:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5FB9B217E5
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 05:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3513C467;
	Thu, 25 Apr 2024 05:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMhz0GFW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B073A1AC
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 05:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714024601; cv=none; b=kb0Yy0DQvIu96jJek2WGu4mpWhRENPkctc2iL5tPZtd24ZDzy0CCC7nIjh01mCYIFdQVijwHqTqRDNoKTs9gmL1ltE2v+unmEaWVEU0I2a9rTc7P6W/P3I6KCLyCXSqeU37OGX2yksKjh7pQYNvrfeOlVTyD5/PieEhTisCxxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714024601; c=relaxed/simple;
	bh=O4CznqeG8T+JWseL09yaa78FtOWwIBAlH8a0Gt7nzEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uREz7vVu9eFHtNkFwQLdzrCFZDLZCagw1a9wtlTqYUKkqaYyPNkmLEfXgsAnpUlMM3j7ED8LfO+giFns9vHXWwCkyc60HYCsMFwXXf+6cOez1q3j/9c5auwpOOiVG/MKXSclI+5GPDrdqsZon5WrdHjTmG8S3pKTeyCK7//3kd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMhz0GFW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714024599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exOCW1wmcScF7uY7sXoI9wagJW8drQNtgczHEogNU4E=;
	b=WMhz0GFWSLp6xEtX98wV/ODboHM3kiRw/kIJ4mUcX10RYwX1kMBCnlYAoQ0wlNCu0EoHAL
	KZILd/d2AEI3VwkczOgQi4YZ/+EJb6P+U/cQ13BeIiKrwdOgnDITFh3yEp6IIIRB1hc6fm
	s2EkhylBVKPO9xhfUglh7dCos5iYI+Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-y5ku_KHcNNmzOgggQT5NeQ-1; Thu, 25 Apr 2024 01:56:37 -0400
X-MC-Unique: y5ku_KHcNNmzOgggQT5NeQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343e46df264so382963f8f.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 22:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714024596; x=1714629396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exOCW1wmcScF7uY7sXoI9wagJW8drQNtgczHEogNU4E=;
        b=WJm4XY5p5XVu2poSh0Amg97Z7orT5xP/e6OHASzo8BEbMt4GKSe45T6ABUAJqSdC4Q
         bmZISfHQrtHOQUGAg49nUNswWx4BC1gauZQt12dqKCuqLLES/rs2033FQdikGxKJQmVO
         /KS40KpuILsWCZQ0BWgTWb4/XtL8wvZBMGcuhFCymE9A2W2MBp6oAZyLYgPlipsbNMaD
         29t4Asb5NK0VGYR2VxW5orDRCo/a6SBdeuOK8Fsby/kMWjfV4l1zGttyavN2MVKNW8ik
         +9z5UKMrk0zTo9+FyXqxe6C58En440IoNglAMFR5C60czokUtc8J39mbt8bOQR527q+d
         9Y/g==
X-Forwarded-Encrypted: i=1; AJvYcCWCxogBJvfCMUlMR8hBHLlaJMqeIVQsjnRIZ15/twbOt/G7Ygc/Mf6GQfRyliabTvTLUM6lZF7VxBl+/vB8yA3E9u9q
X-Gm-Message-State: AOJu0YwClp/JEuXY4pI8bGom6mMmEo1Z9i+8NDw/DkAoucmwEcepYae2
	bUGDnoK6qepB6F9zW5wySpx3WeEdiMf8X9ovw/Hgk0B0vpKCBHPWLMZrbHOf+i22w6U/5WRPyyn
	0EgIF+rIE6CfGOjBRZMb6jN//kVpRBS8OE9V3B3d2kDi1KNEV7W8GuIA7oMp0dORYrCQPe8TeUg
	bWND0M3grEdyxAEqww2nvL/IJm
X-Received: by 2002:a05:6000:18c2:b0:341:ce05:dba5 with SMTP id w2-20020a05600018c200b00341ce05dba5mr3252464wrq.30.1714024596258;
        Wed, 24 Apr 2024 22:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQMN4AK15f2j3BmYvEcbraA8vxJgm5FQOQBHc0h7FbM4crcHaNHD/tT0WZx2+vXC7+1vOLMupG25xmdYYeTI4=
X-Received: by 2002:a05:6000:18c2:b0:341:ce05:dba5 with SMTP id
 w2-20020a05600018c200b00341ce05dba5mr3252456wrq.30.1714024595937; Wed, 24 Apr
 2024 22:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <ZimIfFUMPmF_dV-V@google.com>
In-Reply-To: <ZimIfFUMPmF_dV-V@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 25 Apr 2024 07:56:24 +0200
Message-ID: <CABgObfYgmuBbzQP+ZQhpm7BEgiwLTz6W0g7=EK-xwd9=CWUCOw@mail.gmail.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 12:32=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Apr 04, 2024, Paolo Bonzini wrote:
> > +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, l=
ong npages,
> > +                    int (*post_populate)(struct kvm *kvm, gfn_t gfn, k=
vm_pfn_t pfn,
> > +                                         void __user *src, int order, =
void *opaque),
>
> Add a typedef for callback?  If only to make this prototype readable.
>
> > +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, l=
ong npages,
> > +                    int (*post_populate)(struct kvm *kvm, gfn_t gfn, k=
vm_pfn_t pfn,
> > +                                         void __user *src, int order, =
void *opaque),
> > +                    void *opaque)
> > +{
> > +     struct file *file;
> > +     struct kvm_memory_slot *slot;
> > +
> > +     int ret =3D 0, max_order;
> > +     long i;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +     if (npages < 0)
> > +             return -EINVAL;
> > +
> > +     slot =3D gfn_to_memslot(kvm, gfn);
> > +     if (!kvm_slot_can_be_private(slot))
> > +             return -EINVAL;
> > +
> > +     file =3D kvm_gmem_get_file(slot);
> > +     if (!file)
> > +             return -EFAULT;
> > +
> > +     filemap_invalidate_lock(file->f_mapping);
> > +
> > +     npages =3D min_t(ulong, slot->npages - (gfn - slot->base_gfn), np=
ages);
> > +     for (i =3D 0; i < npages; i +=3D (1 << max_order)) {
> > +             gfn_t this_gfn =3D gfn + i;
>
> KVM usually does something like "start_gfn" or "base_gfn", and then uses =
"gfn"
> for the one gfn that's being processed.  And IMO that's much better becau=
se the
> propotype for kvm_gmem_populate() does not make it obvious that @gfn is t=
he base
> of a range, not a singular gfn to process.
>
>
> > +             kvm_pfn_t pfn;
> > +
> > +             ret =3D __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &m=
ax_order, false);
> > +             if (ret)
> > +                     break;
> > +
> > +             if (!IS_ALIGNED(this_gfn, (1 << max_order)) ||
> > +                 (npages - i) < (1 << max_order))
> > +                     max_order =3D 0;
> > +
> > +             if (post_populate) {
>
> Is there any use for this without @post_populate?  I.e. why make this opt=
ional?

Yeah, it probably does not need to be optional (before, the
copy_from_user was optionally done from kvm_gmem_populate, but not
anymore).

Paolo


