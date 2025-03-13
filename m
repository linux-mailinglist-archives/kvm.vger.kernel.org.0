Return-Path: <kvm+bounces-41015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFC4A60480
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 23:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA75189F96B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D031F8921;
	Thu, 13 Mar 2025 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADm6cHCG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D31F8738
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741905499; cv=none; b=ccjvUNO0/f3maciAKiHNIZ6LHZ2Ap4XKw4jtZwVD8GoK9x1BPMLPXcWh5AMJsbY5QG8UdlT+i5Me8mxBsYXLN8vkHg2aNvedCf27EyS0vKclcHCRBiz7bVqQn8gd2rVHoVpFKJnzcBjsL8tG8jeMrcf685B5+N3BYlD5fn2xBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741905499; c=relaxed/simple;
	bh=DSWQgIJ7FXheJ8gYzjYJfYWpUIUUzmSGNhkDx6tGNEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=df7n+n1gT0LM1cc0n3OUZSqDp+u6z9RhV8i1eY2ECcbaFDDVwdpkhHwaWMjq/LYldJc/SoiEhsE7qIZt+Vh6AIDLi4CdH15ClFPO30jjD8CL55mzMjZAXf1Z/kVEGmdK9dYFYCt4BtXBD/xBFtV9x/zYp2ZNVQ+rtsuy5+4jUvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADm6cHCG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741905496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFzr4WLi5EWJd9Q1lyDlYMS58+KhEJhXt4VWqBCulsA=;
	b=ADm6cHCGyS0YJiIuj7UKM+ElLuVvH6PQEVRszHhbeXJZKtP1bdzupMtudEF13svCHs7lVf
	BALzOKLqKbzgySfQbs/KeDng+OEbMUI+lVBsmHj21hjQWE8GCbLZuPfbeyJkJ/EQkl4XdK
	y7TpJ15F9E31qwuBVKEF2BOSwmuvjkQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-11zLeY24PdSsibzPuVcd8Q-1; Thu, 13 Mar 2025 18:38:11 -0400
X-MC-Unique: 11zLeY24PdSsibzPuVcd8Q-1
X-Mimecast-MFC-AGG-ID: 11zLeY24PdSsibzPuVcd8Q_1741905491
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-47699e92ab0so30030531cf.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741905491; x=1742510291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFzr4WLi5EWJd9Q1lyDlYMS58+KhEJhXt4VWqBCulsA=;
        b=UzQlKhhphmEnkwLqnNiCBCLco4yQWA2gaeaQgrIV9Bi3BB3Txydc0pIEBLOhbLCJ+A
         jdqWHUYIV1lV8oESsO7qQN4DzcBU4NkFMntA1emqyVBdOWaSeIkuhJtq9zt6dGLeQSwG
         pcg7GkMOaRZQ20kwMyQn63rdunjWdhiClOpulx+A+Kc8Qh2oM3PGtrPVAvQ/GUqdIQ5C
         E5P8NWlgvCTOSVBH0O4Sp3Q/uyh/bDy9SiSROnKiy1vEkcRzWFd9Wkzdr4ycEdLXdSpr
         uIRY6YAOrZKF4Uqf4UTOW0hx6FkI2lBG7+u/UBYLLc6YAuw/Yl62lmqD+06RMimiD6Fd
         QE3g==
X-Forwarded-Encrypted: i=1; AJvYcCUunVxtKBQf7qB5TrzDUJ4q9ZimI/43Rex/YKx57kVvs+4GN5p+nDCe/x7iqYA01jJtgrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YymVoOYswe8AQ8d+ez+QcZCv5cI1ZvcBFDF0OyFWwGt654lUeCl
	7ZzO6zA/31wqCMX3ChS+WWVQ4ooloAYWlvixx6jzx5mhWUnx3L8ZNPkWhVO6FPVO9rTzr/Q6PRD
	JcDRk6AABQ2Zt8CeYErEw2N69wizFDdT8eofCtpq+uD+jJ6gtmg==
X-Gm-Gg: ASbGncs6pgA9TIUC1HpRYtLzaZRw+hxLxQm2fe2qg6Tsuz6KGhym5kl/+ibT5MFnqz/
	EeTjY+gqN6x97SXiKFiaj6j+yDMABISCTz3UFwy0nwtEVqDt/4yzdEZXwGd4/oUWjtfTtscfdLV
	dFSHmBnFkmxFXfMreBB7Gw3lfuz8wwhrLrqOMjxOp+chdB/e7SMAWZq1wD+X5iMFPA6jxEDBfWa
	Iw3kjat7EkrpRD7Z2ewSyZvgPxl+rPpjCl6Bf9RmyxZYRN5MgjvuzlqmLQkgHP3QKAJhuuiqEzC
	N01fT0M=
X-Received: by 2002:ad4:5d65:0:b0:6e8:e8dd:30d1 with SMTP id 6a1803df08f44-6eaeaa5fa9amr2466966d6.22.1741905490927;
        Thu, 13 Mar 2025 15:38:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBXIseFJxXyT7V3i4JYoBiq0nyGeT0Insspj8UcFpuo+ZEN+6NwuINfQg0ot8cSpabuM7JsA==
X-Received: by 2002:ad4:5d65:0:b0:6e8:e8dd:30d1 with SMTP id 6a1803df08f44-6eaeaa5fa9amr2466586d6.22.1741905490665;
        Thu, 13 Mar 2025 15:38:10 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eade208b20sm14700356d6.9.2025.03.13.15.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 15:38:09 -0700 (PDT)
Date: Thu, 13 Mar 2025 18:38:05 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: James Houghton <jthoughton@google.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z9NeTQsn4xwTtU06@x1.local>
References: <Z8i0HXen8gzVdgnh@x1.local>
 <fdae95e3-962b-4eaf-9ae7-c6bd1062c518@amazon.com>
 <Z89EFbT_DKqyJUxr@x1.local>
 <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>
 <Z9GsIDVYWoV8d8-C@x1.local>
 <7c304c72-1f9c-4a5a-910b-02d0f1514b01@amazon.com>
 <Z9HhTjEWtM58Zfxf@x1.local>
 <69dc324f-99fb-44ec-8501-086fe7af9d0d@amazon.com>
 <Z9MuC5NCFUpCZ9l8@x1.local>
 <507e6ad7-2e28-4199-948a-4001e0d6f421@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <507e6ad7-2e28-4199-948a-4001e0d6f421@amazon.com>

On Thu, Mar 13, 2025 at 10:13:23PM +0000, Nikita Kalyazin wrote:
> Yes, that's right, mmap() + memcpy() is functionally sufficient. write() is
> an optimisation.  Most of the pages in guest_memfd are only ever accessed by
> the vCPU (not userspace) via TDP (stage-2 pagetables) so they don't need
> userspace pagetables set up.  By using write() we can avoid VMA faults,
> installing corresponding PTEs and double page initialisation we discussed
> earlier.  The optimised path only contains pagecache population via write().
> Even TDP faults can be avoided if using KVM prefaulting API [1].
> 
> [1] https://docs.kernel.org/virt/kvm/api.html#kvm-pre-fault-memory

Could you elaborate why VMA faults matters in perf?

If we're talking about postcopy-like migrations on top of KVM guest-memfd,
IIUC the VMAs can be pre-faulted too just like the TDP pgtables, e.g. with
MADV_POPULATE_WRITE.

Normally, AFAIU userapp optimizes IOs the other way round.. to change
write()s into mmap()s, which at least avoids one round of copy.

For postcopy using minor traps (and since guest-memfd is always shared and
non-private..), it's also possible to feed the mmap()ed VAs to NIC as
buffers (e.g. in recvmsg(), for example, as part of iovec[]), and as long
as the mmap()ed ranges are not registered by KVM memslots, there's no
concern on non-atomic copy.

Thanks,

-- 
Peter Xu


