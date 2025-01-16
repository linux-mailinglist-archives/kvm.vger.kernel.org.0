Return-Path: <kvm+bounces-35691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA592A1434A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B46716A7EF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5198A23F269;
	Thu, 16 Jan 2025 20:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABcboBLb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B0622C9F7
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 20:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737059537; cv=none; b=Op8orwJ/dVxwL8/vU3rUM+3loYYKsxzS0o+ixGgLt1TT3RH1c5Vq+vfB+q3IBRZQtOFdTSWRITehSn7GWOTAPg6paEpU9/65v/vcaZ9YTyJ6ZcvACA9JtqJvE0Z/8HrOHI6BBdsT09t8rXDdkt9a8l+POhFhkVOrzEj2X6DgiTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737059537; c=relaxed/simple;
	bh=Gp2dMCkhOZWquwQcvnyVZRJDHqMIikWYXh/aHRG4fJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvULEbOw3n04hvK0vqkG2j0R5ty1ub2xBNgMxXAH168TLJ++bbflVgZs/DtSGN/hkIojbkGnGYQzioI/BDb4mPQQyVV78HBIwuvPPNZ/DjDlTD6LcFUU7cGiz77HQ5hdTQRZW/wRGe2msdZaqsx/d0Cpj99FBkwnThxrM3odJ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABcboBLb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737059534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cBjXp+Q0kBMQo93pn9/JG/mDdpOMWtXcKEJJB7g0DX0=;
	b=ABcboBLbXspaBdHa60KRlbROCiAmMg0WeHLc5O78iv+xM3G284e953YOyGR9bKJ7cjMaYf
	ZYkQoagGCcFIsa3c4pZhS6F9IqVEiS+XOya8N7+vgHjz/GiWftBI/ZXSw6j9WQ1yhdpeGW
	DorEfLE8qyzxMVFbH08b7AqGNGgVO6Y=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-BAXTSCIBNaehm_LOGchvhQ-1; Thu, 16 Jan 2025 15:32:13 -0500
X-MC-Unique: BAXTSCIBNaehm_LOGchvhQ-1
X-Mimecast-MFC-AGG-ID: BAXTSCIBNaehm_LOGchvhQ
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2163d9a730aso30667875ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 12:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737059532; x=1737664332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBjXp+Q0kBMQo93pn9/JG/mDdpOMWtXcKEJJB7g0DX0=;
        b=eO+z8EcnN04dcaehtE6lJ2/sZ+TLJUz27LdycKw64wI7OHxxMdsvJ1S7RbuX6Kzaqb
         KOem8pwnwAwVHDcsCZAfFu/q6HUoLrGJ1jhFXaRpX9k5rTWBOzLXuPM2V6/L/YPKkbnM
         1SCqTLw4F5PYt14fNqazhfmROakVy5JBmOls7RF8pQZVORYByGDQvVwOryoZs+p00uR4
         +cnHV6mAtkqak+QFQBP94kmz52GjUOaZrkq7h6I9EDr25LyxHn/ySB6r6ms73wvbJD5O
         +qb55DsziMY7bozNOCh8FbaYRB4ID/flGfN4JQ0U58xZh6XIFgIdGVzk8bJ4qJVZ9PoC
         upHA==
X-Forwarded-Encrypted: i=1; AJvYcCXxrtG1rjqYsSeDjTiIyA+KadBkxxEetTY5KecW3EEHiC6c4uSgpxl52qQPOqgDgb6VKR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUOwplMtbrZn5tlJLMxRFffs4JegkGJPfVaQPnF+9RC0U0PydG
	Z7/WisliNdOxfP0vHZ0wEQZyF4gPUtIvq+193X0xxRDF9rppHYVmCcgoXHbVEwPkvjfZmEYEg1j
	BZtFfPdYtwLlCxTpIPq3CGmFhsEpbXusRpw+gRZdi72AeEBNW5w==
X-Gm-Gg: ASbGncuajhUxjbtp0wUASO94Qd82fGwCudUQK0S9W6yDn+co0wumcrCVdb72D4w/NHO
	wj5753nhQVI4nNf9a5kJhaE5NFVDLt5wyhV8Gt2ghSdnbxM/A+hmHmCiat5isX3rSaOLiadDOHy
	//w5r0mojabiykrmMiXv8GtIyHcCVpH74Ku0NYw5I4n1mw64E7xSWTFla2BwUkJx1ei6s+958zn
	gFUVSha9AhQgnwEGx6vqHqe7YS7kEATstgdyq34ZNm40WDkgCvCbiAhWbfQQy2GZ6Xd2UHiDhtW
	DQQMOwJA05NMg6YD9w==
X-Received: by 2002:a17:903:238e:b0:216:311e:b1c4 with SMTP id d9443c01a7336-21bf029e049mr110709345ad.4.1737059532479;
        Thu, 16 Jan 2025 12:32:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKxzy3YKG0/4peNFIGTyI8M6fxHbUDzV/T0Dy6Fv99Nr5xuebiMcqfPD2o4c5t4sCUc/gI8A==
X-Received: by 2002:a17:903:238e:b0:216:311e:b1c4 with SMTP id d9443c01a7336-21bf029e049mr110708925ad.4.1737059532113;
        Thu, 16 Jan 2025 12:32:12 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdd30e9adsm444712a12.62.2025.01.16.12.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:32:11 -0800 (PST)
Date: Thu, 16 Jan 2025 15:32:06 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>,
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
Message-ID: <Z4lsxgFSdiqpNtdG@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n>
 <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4lp5QzdOX0oYGOk@x1n>

On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> James,
> 
> Sorry for a late reply.
> 
> I still do have one or two pure questions, but nothing directly relevant to
> your series.
> 
> On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> > So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> > worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> > indicated that this direction was indeed wrong. I have another way to
> > make this work in mind. :)
> 
> Do you still want to share it, more or less? :)
> 
> > 
> > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > replacing it. And as of right now anyway, KVM Userfault *does* provide
> > a complete post-copy system for gmem.
> > 
> > When gmem pages can be mapped into userspace, for post-copy to remain
> > functional, userspace-mapped gmem will need userfaultfd integration.
> > Keep in mind that even after this integration happens, userfaultfd
> > alone will *not* be a complete post-copy solution, as vCPU faults
> > won't be resolved via the userspace page tables.
> 
> Do you know in context of CoCo, whether a private page can be accessed at
> all outside of KVM?
> 
> I think I'm pretty sure now a private page can never be mapped to
> userspace.  However, can another module like vhost-kernel access it during
> postcopy?  My impression of that is still a yes, but then how about
> vhost-user?
> 
> Here, the "vhost-kernel" part represents a question on whether private
> pages can be accessed at all outside KVM.  While "vhost-user" part
> represents a question on whether, if the previous vhost-kernel question
> answers as "yes it can", such access attempt can happen in another
> process/task (hence, not only does it lack KVM context, but also not
> sharing the same task context).

Right after I sent it, I just recalled whenever a device needs to access
the page, it needs to be converted to shared pages first..

So I suppose the questions were not valid at all!  It is not about the
context but that the pages will be shared always whenever a device in
whatever form will access it..

Fundamentally I'm thinking about whether userfaultfd must support (fd,
offset) tuple.  Now I suppose it's not, because vCPUs accessing
private/shared will all exit to userspace, while all non-vCPU / devices can
access shared pages only.

In that case, looks like userfaultfd can support CoCo on device emulations
by sticking with virtual-address traps like before, at least from that
specific POV.

-- 
Peter Xu


