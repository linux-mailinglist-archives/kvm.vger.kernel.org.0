Return-Path: <kvm+bounces-37702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 666C0A2F419
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 17:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 319E83A9800
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554EB2586CE;
	Mon, 10 Feb 2025 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GsZZoUzA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3342586C9
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206135; cv=none; b=eSRVtWXy2hRKFb0I0T7RqiO6pRbq8dc6/7/iSwqnPwCMUHpYinql7U4o0uF1oOjyZQG1rQR/27+mUYyuEkY0tQUPWishqzSP2ztVhISFT6vmdK4n826eXV0Rsjz1hiKu69+CsHFWpKUhiJhlA1eF5G1i7V6953NiqFFpBUDJ4zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206135; c=relaxed/simple;
	bh=H42i1ip4Iw5Qwi2tznsusxX0mXVzotkigTTo4X/6OWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVARtfP4DDoOQlIkyjhasMIDv55YdBWc8mXUcxPsc3wCyFWLuUdD6unse3N6mQG0Nvi5J4IZ+CeZlKXOwT/wuzWwu12DyyHK2o2h6hKEfUoajCL8E6Wk6HA+VU673pM7fmDgoKTleK+Maa/ST6kMNBTCC/OVLkyTlainj2qtV/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GsZZoUzA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739206132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbJ/q4McdqvgWbdZpzsX0c88NodzGfPGVk3OSUhSBag=;
	b=GsZZoUzAfZ4Cu6G1O3+h+guQ045padYYUZDmd4Bv/ruC//hfKZC1P6b0ycrNhIl++TicBV
	O0pl/QOuWiZgWxTt+/1sXY2k6tSlkcKMQe32hXMKqfFMjqcfkxIejr7u0QUqElYb6dXcnG
	X9kmzmSEynVCwYJRswxsTODC4UP0A6U=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-Eh6R1jqNMJ6Z6duGsdwONQ-1; Mon, 10 Feb 2025 11:48:51 -0500
X-MC-Unique: Eh6R1jqNMJ6Z6duGsdwONQ-1
X-Mimecast-MFC-AGG-ID: Eh6R1jqNMJ6Z6duGsdwONQ
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5fa93886118so1488696eaf.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206130; x=1739810930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AbJ/q4McdqvgWbdZpzsX0c88NodzGfPGVk3OSUhSBag=;
        b=pwXhUARTaH5tW4RP6n4jGpP/KCty4obPRy4qgS5IXg7M/IfO3G5fg8lY9PpTXUgILu
         t0BUKbSHTgqxIqVLb7qXZ0XhhiW3E3mLlgUlj8KJn15qBdv/kDMC6+ZbkVwjBZ0fs6Bq
         prqJEH62kZGM3H8mGwRqnjJhCFP0JhEd2hWX+5d4h3WzoAjrmvOsXj+9O2hNHhppyB9c
         QVa8EQNv3y9j5Qgx9h46jp74GFtbgzyjfhcNSoUk5fVImus3ONWv7euV9LHTyYcdbqE8
         0Xe7yd9XCfHJIthLrMlGV1AcLOTbCSo/+cJSZKtCg8UTq7n0egpm5gbjfWCQDW62reMi
         /XVg==
X-Forwarded-Encrypted: i=1; AJvYcCWpWF/cikmnIuWTyxEzxJp3G/ZHD4HV/yAxiWF8iFe2UEnB7f7DleTjDQhp0G90R0d/y9E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9NmHj2f8DAvmXCRxhQgCYXQbZRjTM5vIF4X9ASF6M+KAZ56sP
	dFVw3WVHcr6ew2eA0xDycY7IoXuip3nHVXd3bxzz9SptQbMRKp2yMK60iHzijkNG2ksgpbEXiJ9
	4M1f3u9S20pJdaPUbSHzvfCui5Uvj+n+qRUuV8au+UR59JA9+9w==
X-Gm-Gg: ASbGnctCCtozBUnTrzpkVzbUXEtBrvUnY+uMMRlKM4DJF4Jd1gdnTz32Hj2vX6XGiMB
	kjnrLi0hayphT2lLChnhph9+mg6b5gCg0v8PEJwkeTxvRnptFtiF3ukH9Iqo1gBXcasagr5WXWf
	lakcP8ALtQvus/vYbWf1cQRBjnCpHV1JvRr3oGLpUvUt9pXXbXiWQuDMPC7FigJvMr9jQX38KmP
	QZKlLP6W/oW8jbBigkW4Ww42r3LKeHvTP/MzxbfgtJ7sZCCTzSLMuD34D8=
X-Received: by 2002:a05:6808:219f:b0:3eb:3f7d:b777 with SMTP id 5614622812f47-3f3923d19d7mr10657881b6e.31.1739206130608;
        Mon, 10 Feb 2025 08:48:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGDM6RuSO7MF/NKzwxTpGMG8lDWTPXctAudaMtSfVl3hoVW+dX0pMXbd2UCko5vBGcDooydQ==
X-Received: by 2002:a05:6808:219f:b0:3eb:3f7d:b777 with SMTP id 5614622812f47-3f3923d19d7mr10657866b6e.31.1739206130266;
        Mon, 10 Feb 2025 08:48:50 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726af9411c5sm2467490a34.28.2025.02.10.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 08:48:49 -0800 (PST)
Date: Mon, 10 Feb 2025 11:48:45 -0500
From: Peter Xu <peterx@redhat.com>
To: William Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
Message-ID: <Z6ot7eVxaf39oWKr@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-4-william.roche@oracle.com>
 <Z6JH_OyppIA7WFjk@x1.local>
 <3f3ebbe8-be97-4827-a8c5-6777dea08707@oracle.com>
 <Z6Oaukumli1eIEDB@x1.local>
 <2ad49f5d-f2c1-4ba2-9b6b-77ba96c83bab@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ad49f5d-f2c1-4ba2-9b6b-77ba96c83bab@oracle.com>

On Fri, Feb 07, 2025 at 07:02:22PM +0100, William Roche wrote:
> On 2/5/25 18:07, Peter Xu wrote:
> > On Wed, Feb 05, 2025 at 05:27:13PM +0100, William Roche wrote:
> > > [...]
> > > The HMP command "info ramblock" is implemented with the ram_block_format()
> > > function which returns a message buffer built with a string for each
> > > ramblock (protected by the RCU_READ_LOCK_GUARD). Our new function copies a
> > > struct with the necessary information.
> > > 
> > > Relaying on the buffer format to retrieve the information doesn't seem
> > > reasonable, and more importantly, this buffer doesn't provide all the needed
> > > data, like fd and fd_offset.
> > > 
> > > I would say that ram_block_format() and qemu_ram_block_info_from_addr()
> > > serve 2 different goals.
> > > 
> > > (a reimplementation of ram_block_format() with an adapted version of
> > > qemu_ram_block_info_from_addr() taking the extra information needed could be
> > > doable for example, but may not be worth doing for now)
> > 
> > IIUC admin should be aware of fd_offset because the admin should be fully
> > aware of the start offset of FDs to specify in qemu cmdlines, or in
> > Libvirt. But yes, we can always add fd_offset into ram_block_format() if
> > it's helpful.
> > 
> > Besides, the existing issues on this patch:
> > 
> >    - From outcome of this patch, it introduces one ramblock API (which is ok
> >      to me, so far), to do some error_report()s.  It looks pretty much for
> >      debugging rather than something serious (e.g. report via QMP queries,
> >      QMP events etc.).  From debug POV, I still don't see why this is
> >      needed.. per discussed above.
> 
> The reason why I want to inform the user of a large memory failure more
> specifically than a standard sized page loss is because of the significant
> behavior difference: Our current implementation can transparently handle
> many situations without necessarily leading the VM to a crash. But when it
> comes to large pages, there is no mechanism to inform the VM of a large
> memory loss, and usually this situation leads the VM to crash, and can also
> generate some weird situations like qemu itself crashing or a loop of
> errors, for example.
> 
> So having a message informing of such a memory loss can help to understand a
> more radical VM or qemu behavior -- it increases the diagnosability of our
> code.
> 
> To verify that a SIGBUS appeared because of a large page loss, we currently
> need to verify the targeted memory block backend page_size.
> We should usually get this information from the SIGBUS siginfo data (with a
> si_addr_lsb field giving an indication of the page size) but a KVM weakness
> with a hardcoded si_addr_lsb=PAGE_SHIFT value in the SIGBUS siginfo returned
> from the kernel prevents that: See kvm_send_hwpoison_signal() function.
> 
> So I first wrote a small API addition called qemu_ram_pagesize_from_addr()
> to retrieve only this page_size value from the impacted address; and later
> on, this function turned into the richer qemu_ram_block_info_from_addr()
> function to have the generated messages match the existing memory messages
> as rightly requested by David.
> 
> So the main reason is a KVM "weakness" with kvm_send_hwpoison_signal(), and
> the second reason is to have richer error messages.

This seems true, and I also remember something when I looked at this
previously but maybe nobody tried to fix it.  ARM seems to be correct on
that field, otoh.

Is it possible we fix KVM on x86?

kvm_handle_error_pfn() has the fault context, so IIUC it should be able to
figure that out too like what ARM does (with get_vma_page_shift()).

> 
> 
> 
> >    - From merge POV, this patch isn't a pure memory change, so I'll need to
> >      get ack from other maintainers, at least that should be how it works..
> 
> I agree :)
> 
> > 
> > I feel like when hwpoison becomes a serious topic, we need some more
> > serious reporting facility than error reports.  So that we could have this
> > as separate topic to be revisited.  It might speed up your prior patches
> > from not being blocked on this.
> 
> I explained why I think that error messages are important, but I don't want
> to get blocked on fixing the hugepage memory recovery because of that.

What is the major benefit of reporting in QEMU's stderr in this case?

For example, how should we consume the error reports that this patch
introduces?  Is it still for debugging purpose?

I agree it's always better to dump something in QEMU when such happened,
but IIUC what I mentioned above (by monitoring QEMU ramblock setups, and
monitor host dmesg on any vaddr reported hwpoison) should also allow anyone
to deduce the page size of affected vaddr, especially if it's for debugging
purpose.  However I could possibly have missed the goal here..

> 
> If you think that not displaying a specific message for large page loss can
> help to get the recovery fixed, than I can change my proposal to do so.
> 
> Early next week, I'll send a simplified version of my first 3 patches
> without this specific messages and without the preallocation handling in all
> remap cases, so you can evaluate this possibility.

Yes IMHO it'll always be helpful to separate it if possible.

Thanks,

-- 
Peter Xu


