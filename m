Return-Path: <kvm+bounces-54075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61576B1BC6C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 00:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D0A07200AE
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0D525C80D;
	Tue,  5 Aug 2025 22:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TyxDPmTr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D62200127
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754431819; cv=none; b=sv7pq5ODVQxDQSIbHZPDVjxSWME/GCc4e2tMoaLTi09iX8qvBaj0HFaxVrb2zuNaC856Rg63oTYKekLBslijtKwAtgkVQ8QYY+Mj9X8UIeFZBAURiRVBOglN+xtK3GzkFEH1T5BRVvuralQ0dizMue032eg5BrtM5v6mUtM4S8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754431819; c=relaxed/simple;
	bh=HGDuFjReAfewqVaprtDAnHSIYkGpY4ku4L/vMCGO8J0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7/yI5bRjZnD2boVCY3f25Gr1HDfFAnr0OBDfTTFkNL3flJzzxJSCh6Pvkv4Z6SSCG2FsSQ8/bUPaiDiOqzoCYXrMV7EUNah1UV1ftpVpIjQMnTnAdUoktaA2tVZ201knVTvgZqzpnxBYOC2ETkJQy+5TKlhQvVBSpJz7Fq22qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TyxDPmTr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754431815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xIIzT/N3LyBuOd03XC1idJ7HEO5JqKHutggq4vspDdw=;
	b=TyxDPmTrE8aUaSYRxjQ+i2zF2ptEN+ROXBd9VSB3if8+3uVd3R/lHH/LqLIAVzIp2Tdw1n
	aQUfWWWTGVDyYfcSqg6nGTRnugtaZjB1A55VqhfC+NdfARRu3Ko4lOLzz+ul20PtekAtGB
	kVU+ZWhusBSvEEOkudjRuWYDm+ipGMg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-Uu47ry0FOaG_pHS77uo8Vg-1; Tue, 05 Aug 2025 18:10:14 -0400
X-MC-Unique: Uu47ry0FOaG_pHS77uo8Vg-1
X-Mimecast-MFC-AGG-ID: Uu47ry0FOaG_pHS77uo8Vg_1754431814
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e51bd62f3dso66745ab.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 15:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754431813; x=1755036613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xIIzT/N3LyBuOd03XC1idJ7HEO5JqKHutggq4vspDdw=;
        b=w5K2iKc8wPWDOwwUPW/n9BBATLvmA5M6Jz/slVhDb7qSUhB6+Z4FwjITkhhdLuzP7B
         +VMDw5QtxOUDYEfvgmxc8KHb9hI8bnQ7oLufJFfIdT+AjVWs91AbH4YJQgj2JzQvRN/A
         4z1t5jg/sFPmZY7MMn57eyQkJEid/dXqDQNtFL6GyXC2eHtIc90DfokCVhe4BRH4PLRN
         mZbba9YyBeDhwAgS8Yqf/KVxfWY4zFrmqOvJqS38oC9527Kt432yTqll3DPa3vk4KPjz
         K6XmboXzRovq3R6bYLSjSobdNfAq5vedO7x6COs/9JOfga/zdyaeshvVnkE192+a4QUJ
         YLow==
X-Gm-Message-State: AOJu0Yx7/uJbG6W4HBM/6oWo8zgSgJ/gHgVv2TrKaxIYu6Vy9iK0z6uu
	3bkMtHJV4D02PfMe8LeTRT0OfFuBYuT9uZxX+ThSCZ99MVVdIt12gXfqqjaw5stjW9ObjVr8rLo
	5zJu4WkWQ+JQt2iO2OMUsvJNgzkVhSPup/eXd1fKyDeHr3UN9FSbx2waHPVl+mg==
X-Gm-Gg: ASbGncsK3l7/OV7qgUFPR034s1N8i1EdINrTnHcMyBEOrEFFh0PjPtwLCBDwzT4DduJ
	mc3KRjumW9xZ8FGuUONq+oAVgYLkyFBZ1n0/FIqspqVjy4GklhscMTUAiKsod8j5OlREUfRSBuu
	PYyFY5QAOhPdDbOP5IovFEqKZsk3HxXmkUrZiBcllmRe4dA5mGSNOQHDDeFJWSy/+PCVZ66PX3A
	0xd22lbtDxMvHSVqosKBzEZRviJ+tuDUffsnlBjmFy4i4vMCIgyn8IYZ2QNaUsyg80hBFDkJdu+
	GyfJ5e4WutSJ5etYO0uIhSx0m0kZo8Q60KJ1pKhHPwg=
X-Received: by 2002:a05:6e02:380e:b0:3e4:8c0:5a49 with SMTP id e9e14a558f8ab-3e51b93509emr1135685ab.6.1754431813287;
        Tue, 05 Aug 2025 15:10:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeTSYrNvNeXvcGMNTLoxrsoMZhdOEaAZlUZUu8v9nriIjltaZhbcJZV2jAASlJ5IbTkR6l5w==
X-Received: by 2002:a05:6e02:380e:b0:3e4:8c0:5a49 with SMTP id e9e14a558f8ab-3e51b93509emr1135535ab.6.1754431812866;
        Tue, 05 Aug 2025 15:10:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ab413fdcfsm996665173.75.2025.08.05.15.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 15:10:10 -0700 (PDT)
Date: Tue, 5 Aug 2025 16:10:08 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Li Zhe
 <lizhe.67@bytedance.com>
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Message-ID: <20250805161008.04ea1c64.alex.williamson@redhat.com>
In-Reply-To: <20250805121558.5f86b5ac.alex.williamson@redhat.com>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
	<7e03b04a-33da-46a9-a320-448bc80f3128@redhat.com>
	<20250805075643.53aad06f.alex.williamson@redhat.com>
	<20250805121558.5f86b5ac.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Aug 2025 12:15:58 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 5 Aug 2025 07:56:43 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Tue, 5 Aug 2025 15:27:35 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> > > On 05.08.25 03:24, Alex Williamson wrote:    
> > > > Objections were raised to adding this helper to common code with only a
> > > > single user and dubious generalism.  Pull it back into subsystem code.
> > > > 
> > > > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > > > Cc: David Hildenbrand <david@redhat.com>
> > > > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > > > Cc: Li Zhe <lizhe.67@bytedance.com>
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---      
> > > 
> > > So, we might have a version that Linus should be happy with, that we 
> > > could likely place in mm/util.c.
> > > 
> > > Alex, how would you want to proceed with that?    
> > 
> > Still reading the thread overnight, but if there's a better solution
> > that Linus won't balk at then let's do it.  Thanks,  
> 
> How soon were you thinking of sending an alternate proposal?  I don't
> want to make this any messier, but this patch gives us some breathing
> room for the merge window.  Thanks,

After chatting with David off-list, I think we agree that just moving
this nth_page code into vfio is likely not the best solution since
there does seem to potentially be some agreement for an mm/util.c
helper.  However, it's too late for v6.17, so I've dropped this
optimization from my next branch with the expectation that we'll fix it
properly and re-queue it fro v6.18.  Thanks,

Alex


