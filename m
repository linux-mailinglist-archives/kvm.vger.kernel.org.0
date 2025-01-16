Return-Path: <kvm+bounces-35696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CB8A1446E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52923162B3E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4AA22BAC5;
	Thu, 16 Jan 2025 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AFrQ5oaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5471DA628
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737065779; cv=none; b=qZnKjApmWIg2pOqNtMc8LoyodvDiWLQn2kOz6mrt+Zlzo1GsvC1rIcKQ/alGLbzxmPQHPanIo867DG7FGnZwZIQZS0xiuQaB5MWbBmvu/5zsauaUCKUsssFyaS42U36uZZWrYr2bvnYfhgYoiqcFf2ncrm2BqAGWrePMovCkEcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737065779; c=relaxed/simple;
	bh=Z0ddV2nDeH1UNqlW0vz2htYefbtJD3MtZnrUV8fkTRs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZcuzgctNt/XsTOmD3anPQRJKEyDDdHfa6fEqWo+6h8ciPCtfpdcPFvdsnvoz0MNSbJGQf+vis+Tz36XcYHZSIRtX+Tv7BnaUqFJ19XxhIs+wKlUB+el7PdPLSTnDnbB+fmrYAOZNc/9aPDhg/8ClZgNr/moUZB7ytEJy9peSWHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AFrQ5oaL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f5538a2356so2780975a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737065777; x=1737670577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+7NcQN2GRHERXJVYagMBxlSawy5BYRQeFxBS4jvGU=;
        b=AFrQ5oaLtpsoHHRzu8lF/OnWWx2kVmiXE+W4l/0kIdND6aLBRZH13pCw5tEQ4/LBPc
         1X50fB48weJRmmLu+fwaeVjdxsa4CTgjGF4chaso8nFAv8BU7ST4J2jjHqMNLDrSneFa
         MiBRGXGpnUwxVM9jUJtBOdDuvOtCPSn8Ek4mAM0zIXKlDAMsKEslY5cWn+tYk8ub9K23
         fJoF5DM4DG185DmJ4s5dxKrQUz4vtIZlPb+oJId8xwpD/nRU9gJF3J7lS3/7qkN7lbJy
         OFWnxO3oWWgTJjLpO8Ykd9AwefKVCgPnOPn9DnDfNOqHkIXSUKdHzMLDVUPzF5rAM7iz
         WDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737065777; x=1737670577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+7NcQN2GRHERXJVYagMBxlSawy5BYRQeFxBS4jvGU=;
        b=nBgEWtbRD8p9QczhfpPZRN+86g/2M0Px5lzlxvuqDBVKZsSZx51nKQ0fRfyZcr2sf9
         uTUtyqno/BY0iLWdlPi+OWlCsHFiogGSd2MgiuV2KUwOVhDrkLVSXe85QJb5KsrFzSuy
         yAmqHB6UMIw1dDmVORTkFwi5KRIHqqPMJlejIf+Doga9nBSFPFY1PUOjSvxmIlnPix2C
         huEn3//2wwZLVAFeFsNaNe2fRHrY5Q/yQ8i0DUqtlGvnEGvHKUqKEA043QC74ldt6mvb
         s6bTtA/2LTAVPM4lTCSZRVMOnY/yO8iy07aRY1XEz6rsBhjfjhGKoUULlCzEidiAWPVu
         8hfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfsEbBaBwel07A2kr6HPxqwX/psnEkXGWDvyhWJD6hRKov0t3IqudBLjRWTsINiCffm30=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTaCx+rCkll38nS1HUKIJm1yLZ+l55pVXDuq71pmTzjcTVdW0J
	YBgOuh/R7jIVgPNwKHueHcFbcsMPv0/F9nx+zEB3I/+N9qjdbe40QkcDiinUiGeDU3GUEDQ3xZm
	uoA==
X-Google-Smtp-Source: AGHT+IFQWdmM2razhLJbL5aP2luCP61s/wuhDj08lqTNDx6qC+0wGyJoLk/MjnPxGPcgL9u/wZA2pdBixos=
X-Received: from pjbsn6.prod.google.com ([2002:a17:90b:2e86:b0:2ea:4139:e72d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c7:b0:2ef:2d9f:8e55
 with SMTP id 98e67ed59e1d1-2f782ca1fffmr397272a91.17.1737065777241; Thu, 16
 Jan 2025 14:16:17 -0800 (PST)
Date: Thu, 16 Jan 2025 14:16:15 -0800
In-Reply-To: <Z4lsxgFSdiqpNtdG@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n>
Message-ID: <Z4mFL8wfHjvz6F1Y@google.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 16, 2025, Peter Xu wrote:
> On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > > replacing it. And as of right now anyway, KVM Userfault *does* provide
> > > a complete post-copy system for gmem.
> > > 
> > > When gmem pages can be mapped into userspace, for post-copy to remain
> > > functional, userspace-mapped gmem will need userfaultfd integration.
> > > Keep in mind that even after this integration happens, userfaultfd
> > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > won't be resolved via the userspace page tables.
> > 
> > Do you know in context of CoCo, whether a private page can be accessed at
> > all outside of KVM?
> > 
> > I think I'm pretty sure now a private page can never be mapped to
> > userspace.  However, can another module like vhost-kernel access it during
> > postcopy?  My impression of that is still a yes, but then how about
> > vhost-user?
> > 
> > Here, the "vhost-kernel" part represents a question on whether private
> > pages can be accessed at all outside KVM.  While "vhost-user" part
> > represents a question on whether, if the previous vhost-kernel question
> > answers as "yes it can", such access attempt can happen in another
> > process/task (hence, not only does it lack KVM context, but also not
> > sharing the same task context).
> 
> Right after I sent it, I just recalled whenever a device needs to access
> the page, it needs to be converted to shared pages first..

FWIW, once Trusted I/O comes along, "trusted" devices will be able to access guest
private memory.  The basic gist is that the IOMMU will enforce access to private
memory, e.g. on AMD the IOMMU will check the RMP[*], and I believe the plan for
TDX is to have the IOMMU share the Secure-EPT tables that are used by the CPU.

[*] https://www.amd.com/content/dam/amd/en/documents/developer/sev-tio-whitepaper.pdf

> So I suppose the questions were not valid at all!  It is not about the
> context but that the pages will be shared always whenever a device in
> whatever form will access it..
> 
> Fundamentally I'm thinking about whether userfaultfd must support (fd,
> offset) tuple.  Now I suppose it's not, because vCPUs accessing
> private/shared will all exit to userspace, while all non-vCPU / devices can
> access shared pages only.
> 
> In that case, looks like userfaultfd can support CoCo on device emulations
> by sticking with virtual-address traps like before, at least from that
> specific POV.
> 
> -- 
> Peter Xu
> 

