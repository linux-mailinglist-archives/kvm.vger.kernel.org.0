Return-Path: <kvm+bounces-40824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6A1A5DBB6
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 12:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5DE17A030
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 11:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BA023F395;
	Wed, 12 Mar 2025 11:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwJvAkD0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F27123F279
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 11:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741779436; cv=none; b=A9MubcG6CjK5phQhi9GMqmqRkbQ/umITgnD3pqtlE0S8s2Th8j3kM7aGeHnvN8hSYDnxF17qLyG2sI+Zl4+tzpgLRglBOY0qeqmOWiK4/pMoTVzbnA6VsKLTLMHCAER3h+Rt74v0YdwhfqUG4YlR8MARs0NPSiMsOwAiEHZysp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741779436; c=relaxed/simple;
	bh=7Z26bGllpYXu8uBHNuMML/I4jSffsSVsXJKQG3g7s9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDNvjWpOPnbGa3qbYx8jkthEGPUNR88cf3wIR/VBcgiG9ApU9a9MVqJUNA/pepLFuWAHfrviU8LMZnOs5l5YUyuVjC5kg9cOPqFg5Q84Vg+3ZRG5L5uLQSi1stUwzMZWWv95puRLFUC4vZVQdzLUsN0ivPCqY9qfJYBkG/7wBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwJvAkD0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741779432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v39mmJ/ZoF+dw+zjNgOr5RkZMHs7oG2cf+OVSp6s3sM=;
	b=HwJvAkD0cnKPxz+/hkAmilNPE8BBGyFV/ArWs2Pr4N1NtPOPZZU7/TrNijNq1d/xYT73Gl
	g3/P5MCWi+KsM8oGdvA7oU6ADC1dkaIUY/7BbT9nugT7iR1JnyQB6PuO/TbI7OenVJ047b
	2GYkNK1lRCRJ9txfndiM3XmQAa0gGwI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-fz3-L6tIN7SThkGoWWjTvg-1; Wed, 12 Mar 2025 07:37:11 -0400
X-MC-Unique: fz3-L6tIN7SThkGoWWjTvg-1
X-Mimecast-MFC-AGG-ID: fz3-L6tIN7SThkGoWWjTvg_1741779430
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3913f97d115so376327f8f.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 04:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741779430; x=1742384230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v39mmJ/ZoF+dw+zjNgOr5RkZMHs7oG2cf+OVSp6s3sM=;
        b=Heb3ctCzTaaIE8KUj/xN9wXJH3IHXWk7q5OPD8CeuYkqqQdoI36ZAiTk2wc25e6xVn
         NRzoCATUZ2QBLYjI/DCQl2mAhBipHXmqrHz6gdfPDuRo2eZDaz1PpTACEMsKNLW5IE0n
         j90MwybdIBB9ykkgC/FTBo0stLabQDOytOrz7dpD3JbJvNdii7JyUdx2IxoIgAJnHrYl
         ScY/RBxI8FWjW7vBe2QL+KQeo8XW2EEu5JJMy0MIzZT5e74FkXz1Kj8t98cjkwCVLml5
         fbexku22h5/k52pOUwYu6Srw5zM783in/7JGAcQ2qZ27RVdFrLIQOUwLe1fxpSdkQ/VO
         Fh2A==
X-Forwarded-Encrypted: i=1; AJvYcCUYBHEp/kg0rc/sE7RY8LLxZRxcoWhHNuVPl0DeZ3X1oHteQdbYH6DSXLBTudssu/gfOkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YySod+H0gQMajfwZHT+Gel8mdxy3tuPQF5+ypb/qxTZ3HqDqG1U
	pdRDYX0dksdfdi2NVhmC1eosuMqOzg8USowKoTITJoxmHYesIiVTlCpuI2SZfHBroNP+X2BlRsh
	Zie3j9MOqjiqZd5ROorIOi4iDj32kCCumbXnGUpjJXfIksrX09ZPehWMgfNBCOYvPOvzBpa73l1
	KXpNH4VlRKkCs3mlu6w4scIai3
X-Gm-Gg: ASbGncssWaIfcYbxAmV+fnFfH399hr+fBLeYhc2PMVdBL0ESkLgv2fzpwOdNA74i55k
	XIrEuCoqrSHHGOvX3TGRnM1Ha34X1oxqjQT18Z9VoRVzY1gLBun/eL2N4QuqmqL00oz3uWxX814
	s=
X-Received: by 2002:a5d:6c65:0:b0:391:98b:e5b3 with SMTP id ffacd0b85a97d-3926cb6442fmr6993442f8f.14.1741779430053;
        Wed, 12 Mar 2025 04:37:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7hIva+qqfbAEoA76LRf9FvRMmtz4KNW3wTSXaAkTtMnkEd0MmL7x1VFb9AhRfs/15MSWdNi4TGmI00qsBok8=
X-Received: by 2002:a5d:6c65:0:b0:391:98b:e5b3 with SMTP id
 ffacd0b85a97d-3926cb6442fmr6993432f8f.14.1741779429767; Wed, 12 Mar 2025
 04:37:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307212053.2948340-1-pbonzini@redhat.com> <20250307212053.2948340-6-pbonzini@redhat.com>
 <405c30e9-73be-4812-86dc-6791b08ba43c@intel.com>
In-Reply-To: <405c30e9-73be-4812-86dc-6791b08ba43c@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 12 Mar 2025 12:36:58 +0100
X-Gm-Features: AQ5f1Jr4qB7EzSh_KRS3HvUL2rvLWxmR_egbZcCrsJItfsIes2DzNlQGEhnpkNw
Message-ID: <CABgObfZOhNtk0DKq+nB2UC+FFhsEkyiysngZoovoJP-vF43bYA@mail.gmail.com>
Subject: Re: [PATCH v3 05/10] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, adrian.hunter@intel.com, 
	seanjc@google.com, rick.p.edgecombe@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 8:24=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > On exiting from the guest TD, xsave state is clobbered; restore it.
>
> I prefer the implementation as this patch, which is straightforward.
> (I would be much better if the changelog can describe more)

Ok:

Do not use kvm_load_host_xsave_state(), as it relies on vcpu->arch
to find out whether other KVM_RUN code has loaded guest state into
XCR0/PKRU/XSS or not.  In the case of TDX, the exit values are known
independent of the guest CR0 and CR4, and in fact the latter are not
available.

Thanks!

Paolo


