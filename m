Return-Path: <kvm+bounces-24150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50729951D82
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 059C21F23B27
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A6D1B3756;
	Wed, 14 Aug 2024 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9Ov0I7Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0FE1B1402
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646566; cv=none; b=jrB0dZKcLh2n5PBttAiCUPN+mWI6KXSnPkuboXK+8x8TqJYTbecglNXbfRqdFhKzMjAb0Q8hWeXkeC9ZTJhth0QXKOLizL3Xu61uXaQgNuu/WhvPxYoXuCI+DG0n7806FOvVoDISUtRJf6oPvQcGoD3BcMrP5cEejWht7qkrNPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646566; c=relaxed/simple;
	bh=aDnv0IqT062+fKLr04AH2+xuNLUhOsdmpPpXsIdGfVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfSZFBnBmhymQc/X897bFlv/J+DhgM89kec3NOUMfu9ncm7rVb3L7o4hPiOygoBCN7QMWYin554HrVAqLj0+Qp5Zex8s8x1fycHfUJh4K0FFTlxoEW/xOW+cOH/yTFAgcNzAV7yJnfE3OE6/iy4NBaFsbHAgfFkgT80MeYMbQvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9Ov0I7Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVYdNdGbsg5hDvwTYOliW2fHo02oz1rG9FEP2u4lRJM=;
	b=X9Ov0I7Y6zMu/rztQMH5/itmeS8Rq4Tf+vFBumDNM+kon1gKQ3BC4EIObnnlXGopQsWGwy
	GWfikL7yVhaMTIgtStjgzqdeRcwh8fluQ3jZegNCyMrkBoPGLpLhDLyOkbdBz2pYVN/aDi
	qJMK3Wt+zxVFb4LocpeDzXcOTzPp9jQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-OczRVv1ANF6OfBHeEdSYdg-1; Wed, 14 Aug 2024 10:42:42 -0400
X-MC-Unique: OczRVv1ANF6OfBHeEdSYdg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3688010b3bfso4538167f8f.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723646561; x=1724251361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVYdNdGbsg5hDvwTYOliW2fHo02oz1rG9FEP2u4lRJM=;
        b=t5hVHYFwEVLD53G4twSv80yYqMaCvQGliIex25QADo9+ibfpVutReK+bNc8+njmr++
         Y3a0iJSqIFiCijJnPTM/Jn4urJXkkC3zmtKNOAJEjUZstwK+YGZx/BMP88Elp2kYkW15
         ZND4r1U0lKKIVNpBHa2A0qedURC7m76g6QHM9Db+m7WaWtF3jjH+F1ncXpvc2DV+M9/N
         I66uR2FuxXILH5h57Lx10mTEi2GJc4YThChvrkmMbjVR8WaT2d+sjcPOwv+KaKDwYphp
         o3wznGGCgO54EpkrHOvqwdNG7cf0BopTkgrnIdYaR6X7WygMEosbGATU8kuG94E5yCU7
         COrg==
X-Forwarded-Encrypted: i=1; AJvYcCUCO4fm7W6BExWtYsZEgKSdyMkFvGHMyo56tvn+kL8Ccd58y3/rGfqXDrULD+y4FToAKBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP1l/+f4z1z/w96J6xQjMptPNnM/o0J9bPgEoYkhMlJSLn06/o
	fSMrfG1moaBhzGYQBfseZ1J83W84aNbw3BDOW+7+sTXiMVrBD8zM7Tz3uZEGUHPM1Pe8vDpXbvk
	EMYaTQBaWrDHEE7crvEATI9F67SML9UmocdCxuiNaxkSS+tUvQ9Ux5Tc5D99xA+nngu0cMwzHnM
	g0wGKqpQ3FRMldmt/CM7VWv/+H
X-Received: by 2002:a05:6000:2ac:b0:360:75b1:77fb with SMTP id ffacd0b85a97d-37177742ccamr3183761f8f.8.1723646561317;
        Wed, 14 Aug 2024 07:42:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtP+rSeBmdU6XVoONivIqjh3NiciH9BKIZVBTlvjlI3aofydQJhEqWOqQib+vR63crzrcjSC2qHRhrq2xiWUg=
X-Received: by 2002:a05:6000:2ac:b0:360:75b1:77fb with SMTP id
 ffacd0b85a97d-37177742ccamr3183718f8f.8.1723646560795; Wed, 14 Aug 2024
 07:42:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com>
In-Reply-To: <ZrzAlchCZx0ptSfR@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Aug 2024 16:42:28 +0200
Message-ID: <CABgObfbaRwob74An5=s+HiaRiPa2_z-LFF1sPtEtAHO8_VuF0g@mail.gmail.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 4:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
> > setup the IOMMU, but KVM is not able to do it so reliably.
>
> Heh, KVM should very reliably do the exact opposite, i.e. KVM should neve=
r create
> a huge page unless the mapping is huge in the primary MMU.  And that's ve=
ry much
> by design, as KVM has no knowledge of what actually resides at a given PF=
N, and
> thus can't determine whether or not its safe to create a huge page if KVM=
 happens
> to realize the VM has access to a contiguous range of memory.

Indeed: the EPT is managed as a secondary MMU. It replays the contents
of the primary MMU, apart from A/D bits (which are independent) and
permissions possibly being more restrictive, and that includes the
page size.

Which in turn explains why the VA has to be aligned for KVM to pick up
the hint: aligning the VA allows the primary MMU to use a hugepage,
which is a prerequisite for using it in EPT.

Paolo


