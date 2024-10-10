Return-Path: <kvm+bounces-28458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0A6998CCA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0E471C24DF5
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA24C1CDFD7;
	Thu, 10 Oct 2024 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGxTUdEH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C44B1CCB2D
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728576415; cv=none; b=NBjttMxd+KjulYxvI2Vv/zL+RBKOa1YN8znmCUwKyMjKG8BqeZ1MycQLl7v/lQDS4YuutT6mUVyAdAxAn9BlZ3xP1FnzqPBEQ9bPDW8M7500mJRFSg5W8idBbFd4biDhNfvsVHKKp8N807Jb/gY/ziDgNHAXfA1y2exYLu0U7a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728576415; c=relaxed/simple;
	bh=iiFqIaeGWzn5Xw4KqI1wHYf2EWVoHUdUhd1tZQSD++s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpYhVj2VcrJWJpC4SQPW7q0eU1a8cI8FkAWoL2sjH3/M35/RkBAybTpsyZI/YF9AdIN68prmaqwlU3yHBariP5SpDjVOslGbKYY9wut5hZODeHN0sUbEcb9Wwdtrrd/4PtDY/18oqwieSAtm/hMZTqCh6F5Y6Qh9z5aMErdLW80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGxTUdEH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728576413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/HNyejBOzZNAS2pmhlTCa73HqHtmX71UiVQvzZUuQU=;
	b=QGxTUdEHfw9YI7qTW6dVvwz5Bz/HVK36p0i7c9QcpFAh6PjuJEnznjLzl/q616+DxlUA2y
	BqCAMWExhUGpGjnOKiYex2E2JVxDvUCf6ApKaakQihXMVzrgGmvDWLifPzzY3ks/gduVWK
	jbeiWW3W4aJOEANxLQNusFF5G7UwGR8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-URZPmGdLMVSj71fLNmKUaw-1; Thu, 10 Oct 2024 12:06:51 -0400
X-MC-Unique: URZPmGdLMVSj71fLNmKUaw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71dfd9fc0e5so971050b3a.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728576410; x=1729181210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/HNyejBOzZNAS2pmhlTCa73HqHtmX71UiVQvzZUuQU=;
        b=l4ggbohqFngS6AAD7OBOXniQgS9+9pmJejEfaWX9CzuqDOkI49ji2WF8dMt7AOqxzt
         P5zP44HVtnUYuIHJa9pXAV3R1kYt60RVm9ITf7G3xDjh8ghxVyZc36KPiL8RBZeVbCYV
         E2Rzy2XHPpRXy6ppMVJjnm8MBifgq5dMMfoiaBeiGGlfP5CecRGkMNwtMawILi15sThK
         oNkUhvExR1KGAmrCFOOetJSkLq8rUcU29yJ3V7axI7HPfn9lPmwha+jm1likuU8h0Gy4
         BdCy6Wc6xnz+pvRrITf+4a+tFLc8vI9WqRqS0oyTcwlD1DU0C/GaGnVNkBqsct/catNI
         98jA==
X-Forwarded-Encrypted: i=1; AJvYcCWd9MbwyHkeYNxLOgOKEv1kGyc/54lJoZeWpJgvm4AkcYae/a94vLVNKX0RtKiFisuPbJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT//ArKh8w9VjIGgWvCHAUerghKix6W5bCYgKBRFl8u8TxOdq9
	HbWRRBANstcEwzERTr0Pe5S3H3rO+LkZN85iNveZOPzHi1+2s12RQKpmCQR81tclS+/176/+MTX
	uDRDxDSEWziS/iVOud/1JPcvyg5yJyCCUSU9LZwTCaY67VGLfsw==
X-Received: by 2002:a05:6a00:179b:b0:719:7475:f07e with SMTP id d2e1a72fcca58-71e1db6481fmr11819859b3a.4.1728576410006;
        Thu, 10 Oct 2024 09:06:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+7f1RLhbjySKF/4qyAXiKo7lGpEQ+qrTVlBlzhq+59C96dfh+Iq8tKg2tVLc+cHIQsd5gOg==
X-Received: by 2002:a05:6a00:179b:b0:719:7475:f07e with SMTP id d2e1a72fcca58-71e1db6481fmr11819813b3a.4.1728576409638;
        Thu, 10 Oct 2024 09:06:49 -0700 (PDT)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2a9ea46csm1229368b3a.17.2024.10.10.09.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 09:06:48 -0700 (PDT)
Date: Thu, 10 Oct 2024 12:06:43 -0400
From: Peter Xu <peterx@redhat.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
	jgg@nvidia.com, david@redhat.com, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	mike.kravetz@oracle.com, erdemaktas@google.com,
	vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
	willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
	bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
	rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
	haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
	maciej.wieczor-retman@intel.com, pgonda@google.com,
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
Message-ID: <Zwf7k1wmPqEEaRxz@x1n>
References: <cover.1726009989.git.ackerleytng@google.com>
 <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:57PM +0000, Ackerley Tng wrote:
> The faultability xarray is stored on the inode since faultability is a
> property of the guest_memfd's memory contents.
> 
> In this RFC, presence of an entry in the xarray indicates faultable,
> but this could be flipped so that presence indicates unfaultable. For
> flexibility, a special value "FAULT" is used instead of a simple
> boolean.
> 
> However, at some stages of a VM's lifecycle there could be more
> private pages, and at other stages there could be more shared pages.
> 
> This is likely to be replaced by a better data structure in a future
> revision to better support ranges.
> 
> Also store struct kvm_gmem_hugetlb in struct kvm_gmem_hugetlb as a
> pointer. inode->i_mapping->i_private_data.

Could you help explain the difference between faultability v.s. the
existing KVM_MEMORY_ATTRIBUTE_PRIVATE?  Not sure if I'm the only one who's
confused, otherwise might be good to enrich the commit message.

The latter is per-slot, so one level higher, however I don't think it's a
common use case for mapping the same gmemfd in multiple slots anyway for
KVM (besides corner cases like live upgrade).  So perhaps this is not about
layering but something else?  For example, any use case where PRIVATE and
FAULTABLE can be reported with different values.

Another higher level question is, is there any plan to support non-CoCo
context for 1G?

I saw that you also mentioned you have working QEMU prototypes ready in
another email.  It'll be great if you can push your kernel/QEMU's latest
tree (including all dependency patches) somewhere so anyone can have a
closer look, or play with it.

Thanks,

-- 
Peter Xu


