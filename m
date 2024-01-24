Return-Path: <kvm+bounces-6852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC09683AFF2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF6CC1C27AA8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F3585C7C;
	Wed, 24 Jan 2024 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYt2OUOW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0F285C54
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706117439; cv=none; b=BHEFspjCFnlYF2YNXswPf6WArQ0Qb2TUx7pPn2GC6kNoK016Srsd/LEKkCBA4E+GqtBrShNcx9BmIuVVCZclhberc7Ve/QppyyR6vGSgrgWyVNrrcpYTaSj9zeLq4VG5ANdBddSTFwIgY4MrPty//GyrEsnWmr5aByWU/8Mv1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706117439; c=relaxed/simple;
	bh=iH0MchTyiKSEd6BXJ2oEXudcHoxwgVYZCOiKge+w8Mk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fi80ulTAERYj++viS36+zcZDrI+UsXIyjXDOqzI3EjqcFblehLE5vWTUxxnZGQIQ8ded8y8UttvfSNSdDMX6OBQizjQe4hjzThCl9VP289T7Ya/pLu/L+eXqQn06geXUzu38KcTAzmE1q2RThvGiSrAwbZX88bvHviD5uSRYk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYt2OUOW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ffa2bb4810so48624367b3.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 09:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706117437; x=1706722237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4XBmMUxfyNNPeoo/A2vYJ+fv7wX+k30y8Lmqm0OE8QM=;
        b=oYt2OUOW6FA1ivx95OvEAr4D7Z4iZTw3ir34MJho2zhXUXT0CwMHwGJ5dS0n9PVHM6
         tuyMapWiXFE/mbW/ni18+5sn4emQtEwSkcyXuwVr6P8YxP1YglO0bBAT4f3HKJnrxHmt
         ggq4eBN/c8fPRze8r3w8VRiv5YyjaSwYgo4m4HU020V8HUQiS0/Osxrgf4IbqZ1rpFb2
         fYAeBoNBmQF8HMPmtbFOY8jR6JG9xojEVG5Bl6KG8RWH6K7f2AH51anj3VWahmDzGkuz
         XPNsed6VuPGl/Xktw9TySeCjprXLJ9uMTkILTMQc8pOT9uTWo/TjNR+YgzWlypggqFm+
         zHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706117437; x=1706722237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XBmMUxfyNNPeoo/A2vYJ+fv7wX+k30y8Lmqm0OE8QM=;
        b=VlloSWHdLnSp2EyJmz4D+jcPm0XAmQSUbNyFdvx49V+fpZbQpWZxaTOas8BQbMcKza
         zXoQDIFNJpbhR1GyOXhjXLZchAyAbWlpO777kkE7eASc++EtwdMtO7km/xoiwtLMthy/
         KIZv5wP9WfhtUl5b7E5tLbjfqCi9qIWvy6LbEQreFlWjX+WtTELauj/IQGbGEgJQa+jt
         CKjUCFHbqGuQ7kmrK9uFTf07VPzNK0axW7BKxNB5j9tKoqv1v7HYgrjCAAXekpGQV5Sa
         QMf/t6dEP5anTZhhi3/uIULkYYPZD8AGS1+biu014XH5n3HNYw+dRXsfvBdUhyT+8WNH
         qbCg==
X-Gm-Message-State: AOJu0Yy1VKOcW1dPSuTU/SH8JUQ6u8XPmtoLUPjedSCY8NWtYYvLwmnp
	sQa8fRi0JP1jt/Ylje+6voFIDdCp9X9LHJedUqJROIPvMIeSgnWhoQ7vppqOArefyYkWj6ZgmG0
	+Gg==
X-Google-Smtp-Source: AGHT+IGEWXyawuzyp81/wDfi3Iy9A571RkMiRToyJDanBsf/3shix6eGHoFXOR8E1W1QHA6QBXUB2ddk3kw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1786:b0:dc2:3a02:4fc8 with SMTP id
 ca6-20020a056902178600b00dc23a024fc8mr66666ybb.6.1706117436822; Wed, 24 Jan
 2024 09:30:36 -0800 (PST)
Date: Wed, 24 Jan 2024 09:30:35 -0800
In-Reply-To: <20240122193605.7riyd7q5rs2i4xez@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240117010644.1534332-1-seanjc@google.com> <20240122193605.7riyd7q5rs2i4xez@amd.com>
Message-ID: <ZbFJOyGb21UX6qXn@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.01.17 - TDP MMU for IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, pbonzini@redhat.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 22, 2024, Michael Roth wrote:
> On Tue, Jan 16, 2024 at 05:06:44PM -0800, Sean Christopherson wrote:
> > Tomorrow's PUCK topic is utilizing KVM's TDP MMU for IOMMU page tables.
> > 
> > FYI, I am currently without my normal internet (hooray tethering), and we're
> > supposed to get a healthy dose of freezing rain tonight, i.e. I might lose power
> > too.  I expect to be able to join even if that happens, but I apologize in
> > advance if I end up being a no-show.
> > 
> > https://lore.kernel.org/all/20231202091211.13376-1-yan.y.zhao@intel.com
> > 
> > Time:     6am PDT
> > Video:    https://meet.google.com/vdb-aeqo-knk
> > Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> > 
> > Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
> > Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link
> > 
> > Future Schedule:
> > January 24th - Memtypes for non-coherent DMA
> > January 31st - Available!
> 
> Hi Sean,
> 
> I'd like to propose the following topic for the next available slot:
> 
>   "Finalizing internal guest_memfd APIs needed for SNP (TDX?) upstreaming"
> 
> There's 2 existing interfaces, gmem_prepare, gmem_invalidate, that are
> needed by the current SNP patches, and there's some additional background
> about the design decisions here:
> 
>   https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/
> 
> There's also another gmem interface that you recently proposed for handling
> setting up the initial launch image of SNP guests here that seems like it
> would have a lot of potential overlap with how gmem_prepare is implemented:
> 
>   https://lore.kernel.org/lkml/ZZ67oJwzAsSvui5U@google.com/
> 
> I'd like to try to get some clarity on what these should look like in order
> to be considered acceptable for upstreaming of SNP, and potentially any
> considerations that need to be taken into account for other users like
> TDX/pKVM/etc.

I penciled this in for the 31st, let me know if that works for you.

