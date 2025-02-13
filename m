Return-Path: <kvm+bounces-38100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54153A35005
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C44A3A6B09
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1899E266B76;
	Thu, 13 Feb 2025 20:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIp3YZ6q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9226D245B0B
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 20:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739480307; cv=none; b=lrLOR4f0QSSyeY/vbo/J4KKaaaUWA+Sxomy0c1Su6PsrRbdOMNQSGcRojp2QjCU3/bY+VxuFgOxnsaFpJbKTwlrFBjgKsBrwm9nr3AdPYQQ9HieAR/GL2QhMOXGlR/OiTivlXelgWrG8vkW5ggfDhif/etde85CZkcyx2gAsHrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739480307; c=relaxed/simple;
	bh=zYtE+K5/MPqyky027XB8R9uw9fp/Z+tZe00R0iGPdTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut8ZJ6RrShLamGe3rB/HM2/1kWhMylk27sSb85Zy0u2u7vMEC51mz+YzrassrCjUn2cX/UNxEDjnJXQdHCGnarX3YXeacsOSCi9Wbh4tPcFDfGGHV2Sy0+KNDkTov9Bq9m1BWPXv+kVEOCircvbBzVB6aARqUtMA+5boYs5/1TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIp3YZ6q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739480304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIwv28Eg9o+8B62iOwIAut8oKASTwz+J/sQ3Qky9Q8c=;
	b=DIp3YZ6qLJqMe7kckhUft4TSqpVChtyNKhmU9pjfY65dLi2bSYgZRVYcCBocVLxC3zB5rs
	7JHkFIBMOkFgR8fbx090UIM40axugwOFfQ+SYScLs420N8z05aHR7BmDPlEfDk0AXpEIRB
	mvdYeg3OulXC4BtvKLJn8jlxvGaiJYE=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-vjS8q371OLO-z-nWvWiTOA-1; Thu, 13 Feb 2025 15:58:23 -0500
X-MC-Unique: vjS8q371OLO-z-nWvWiTOA-1
X-Mimecast-MFC-AGG-ID: vjS8q371OLO-z-nWvWiTOA_1739480302
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-2bc76a4085aso138386fac.3
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 12:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739480302; x=1740085102;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIwv28Eg9o+8B62iOwIAut8oKASTwz+J/sQ3Qky9Q8c=;
        b=V7nm7nanD4UUrEhwEUHN7uC02ZyhSRmvjmjloBCsF2XFmEzMglx3+bQuT3gDVmVRiu
         kzk1fUJz2YNWkYK6RIieDpejGGgJnVfzZIId4LG8hbdjquozPSaTLLE25bp9hSjQECJb
         ND/yu/bJXuCQCWeQyB4MixCZHAbshxJWgVBza74+gkBtWfDYdl/WpfxnocrPIAdcwd6h
         bPXnVKJgYJbAteo1FyY2/Hhci/t8aIG7e/xtOem/LNzbOZpLcn3twrdox/xLVHc8llw/
         gEhq7o5O7flZGuxxgzAsGfFZV5WB84dsQel0TmwEGcyct9q24IY3g3px6Do+11Yo9nXj
         r5/A==
X-Forwarded-Encrypted: i=1; AJvYcCWQmcfGdSWEe0nf04rRxJ7z251Af3jpKWld+smsUhKVhyVsR/A4R01+P1nl+LQlMpR6pdE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9wdByQKI7K0SfC3GdP0URuVsH3ZBtndtXd75DhR9OGRnY88Yj
	+z2I0ZgEMdVTaPMn9HN8fT4dD2q4Czla9xb+N+a1Pb+4IzoOTO/Rae88GTfbqBO9kjrU/82qOmo
	PAV89FDDdDI1yOsC4O9UoBQLrQSsz7U+3V1EZv1Ne4qpEFSb4WA==
X-Gm-Gg: ASbGncvePMJEBwfkkxntWqxlZobMaKZpRgk1kkvlkYmybAuBPw/ePfIkKhNeLtFoPsi
	6+e1aBUesDdFzFGomWYVyskd9Yry7Tuu2Rott/oyEaQKzVFTI/zgCcA/ze8XKoQIf/wMD2rKra5
	lRWftnvExsKWe/D0vfZA+GNBeQKDVbljJP1rtOfwrUSeAGGO2MfKazMw0+/uzlQ3OqLPwuUrX/s
	ffhkVabpvNeqyLahP654Dnr//1Ol31wGXYCTtTrqgYJG3UkHGHn08sY+go=
X-Received: by 2002:a05:6871:1c5:b0:2b7:f2dc:a4c2 with SMTP id 586e51a60fabf-2b8f8c0129emr2590470fac.18.1739480302172;
        Thu, 13 Feb 2025 12:58:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWzzqKiybCYxvoqt0ORZNtG9ikfVTTgFeeveX24Fss5WGPD09ZaJPAoqXeH/7rIazijBOQ7Q==
X-Received: by 2002:a05:6871:1c5:b0:2b7:f2dc:a4c2 with SMTP id 586e51a60fabf-2b8f8c0129emr2590455fac.18.1739480301793;
        Thu, 13 Feb 2025 12:58:21 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2b954820707sm1112555fac.10.2025.02.13.12.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:58:20 -0800 (PST)
Date: Thu, 13 Feb 2025 15:58:17 -0500
From: Peter Xu <peterx@redhat.com>
To: William Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, joao.m.martins@oracle.com,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 0/3] Poisoned memory recovery on reboot
Message-ID: <Z65c6W98c9hruUIE@x1.local>
References: <20250211212707.302391-1-william.roche@oracle.com>
 <Z6vQvr4dCCsBR2sX@x1.local>
 <6e8aedfc-f270-4fa8-a1d3-df0389e505cb@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e8aedfc-f270-4fa8-a1d3-df0389e505cb@oracle.com>

On Thu, Feb 13, 2025 at 08:35:09PM +0100, William Roche wrote:
> On 2/11/25 23:35, Peter Xu wrote:
> > On Tue, Feb 11, 2025 at 09:27:04PM +0000, “William Roche wrote:
> > > From: William Roche <william.roche@oracle.com>
> > > 
> > > Here is a very simplified version of my fix only dealing with the
> > > recovery of huge pages on VM reset.
> > >   ---
> > > This set of patches fixes an existing bug with hardware memory errors
> > > impacting hugetlbfs memory backed VMs and its recovery on VM reset.
> > > When using hugetlbfs large pages, any large page location being impacted
> > > by an HW memory error results in poisoning the entire page, suddenly
> > > making a large chunk of the VM memory unusable.
> > > 
> > > The main problem that currently exists in Qemu is the lack of backend
> > > file repair before resetting the VM memory, resulting in the impacted
> > > memory to be silently unusable even after a VM reboot.
> > > 
> > > In order to fix this issue, we take into account the page size of the
> > > impacted memory block when dealing with the associated poisoned page
> > > location.
> > > 
> > > Using the page size information we also try to regenerate the memory
> > > calling ram_block_discard_range() on VM reset when running
> > > qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
> > > file is regenerated with a hole punched in this file. A new page is
> > > loaded when the location is first touched.  In case of a discard
> > > failure we fall back to remapping the memory location.
> > > 
> > > But we currently don't reset the memory settings and the 'prealloc'
> > > attribute is ignored after the remap from the file backend.
> > 
> > queued patch 1-2, thanks.
> > 
> 
> Thank you very much Peter, and thanks to David too !
> 
> According to me, ARM needs more than only error injection messages.
> For example, the loop of errors that can appear during kdump when dealing
> with large pages is a real problem, hanging a VM.

Maybe it'll be better to post arm patches separately so that it can attract
more attention from arm developers specifically.

I see that PeterM is in the loop, besides you could also try to copy Eric
Auger <eric.auger@redhat.com>.  I have Eric copied.  I'm not sure whether
Eric or the team would be interested in this too at some point.

> 
> There is also the remap notification (to better deal with 'prealloc'
> attribute for example) that needs to be implemented now.

Right, this one should be easy, IMHO.  And I hope if prealloc is the only
concern then the impact is low, I mean prefaults for hugetlb pages is less
important comparing to small pages - fault one 1G page which used to be
poisoned may not even be detectable from guest as long as there're still
free 1G available.

> 
> And finally the kernel KVM enhancement needed on x86 to return a more
> accurate SIGBUS siginfo.si_addr_lsb value on large pages memory errors.
> Qemu could than take this information into account to provide more useful
> feedback about the 'failed' memory size.

I confess this isn't high priority for now.  Before hugetlb pages can be
split this isn't providing much help indeed, as QEMU knows whatever the
kernel knows.

It can be more important until someone allows hugetlb pages to split so
poison may only affect 4k out of 1G.  In that case it must report with 4k
of part of 1G.  We'll see how that would work out at last, we may need some
new mm interface to tell the userspace that "when I say 4k is poisoned,
it's really only that 4k..", or something like that.

> 
> I don't know yet when I'll have the possibility to come back to these
> problems, but at least we have the recovery of large pages mostly fixed with
> the 2 patches queued.

Yes, thanks for fixing it.

-- 
Peter Xu


