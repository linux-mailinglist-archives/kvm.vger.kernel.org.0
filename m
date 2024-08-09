Return-Path: <kvm+bounces-23774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7B594D6FA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A34E51F23232
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899716729D;
	Fri,  9 Aug 2024 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFhY4uBj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FB15921B
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230277; cv=none; b=r9+X6lsEQ8d0EXABxqy/7sYCSiFnioK7zE9caWivGcxr+jMC8Sy2cPuWn8jRTtGZsBy3CItiyDvrHFUw4JlI0bziHfcE1iziUkQotAyDndxrjf9Wwg4pzPkqhUprS/edbE5DPpmhosQM0uOFQCTF/UoKmjxWvXeLvcrTW6fYkyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230277; c=relaxed/simple;
	bh=SBsyicGTG9gfAjD0K++NNapLlsd6aU+7cGu4LmewABI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RglsImruFH31ML/1qFVDpgFbCHFopQ5b/mP+uaYmnWSfgv1McjZKJqeBxKeR0K2hXrpH/BHeDJkdHuEPS+e1wb3AKul6B5yaH00BFTVLVd8IQ32uIGpHBCERa+3Fz82v4AfgONEsDIFIWqAzEZcaIuwX9XSRiSKpFtw2ixII4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFhY4uBj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cfe9270d82so3026246a91.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230276; x=1723835076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1OP2TrkQAg4l9VmYgH+ppUrAs3PZd5BTHpl5JP294L8=;
        b=CFhY4uBjLHNhZcHYRHzsb0OKRfXdxFvToX0xcnKc0h0k10Y5bDULBkxyTeVv2hfNbD
         uPu+A0zytU3hQIdhVENJvLIHTygKzjRRNo6PdxQBy0coNqD0vIB89pNssdfAqT4/8BSO
         EvBsv38o6WG7fSE5CWn1UK6zGNtsnpfQc9kXL0uXNd2cqY/ousHFYgeLgrVCu9VL9WmX
         yBxz+/O4FAtxVKNsu5tqH+aiPlf9f6IpwloBx0XAi303d++yf6Pj3kxFn/H8RYWfSR2Z
         3/282atP5Em3Wjj+nzcH6O4Qv3gAhNeW674C0t81DmX5lP+fZzmRnEYFEN3SzCONPDaz
         +HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230276; x=1723835076;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1OP2TrkQAg4l9VmYgH+ppUrAs3PZd5BTHpl5JP294L8=;
        b=fPLXfwxi6XUlAQVa825jCFcilRwFKBx5IDxxu2nFTPlegOpPyuV55i4wydDr/F3pGG
         Ec4uITwoMUo5iHHKva4fEgti1VauT5/5L0MMMTroxA0XKaRah9U72C1CcjIPJss9Tryt
         d0dCuQXCNiObFWn6kY82lA9SreRnFrc0qySNSaq8OjhGfmeJJwPrOmK6QO/vSDlzTP/t
         GIdvtnVeq3QOCGf165V1YTxe9k1esB70NE+UVrCenFq1NP5k2HuBSB7lb6f6/kMFiExz
         xuA5gFwcaWo2JgxPX5g7Lo9+wovEfMdNqvZOp0gIqj+SPPqwGYLH7ky8XW8SiJQyHeQn
         8Nrw==
X-Forwarded-Encrypted: i=1; AJvYcCUUQkO3MZhO5hNixDFKysylBFuJHsc9DM2t5j357BrALNRRLL0lkKJMfjdO9X1s2YSliM7WW8MAnZPYtq94ZbIAczWX
X-Gm-Message-State: AOJu0YwiVlArQiuQRTPVJW15Drn73o470scl6j3t7zdwiCpbNAD+lTsx
	SIjWFZ2aLYn09A5bp5FtUzISh2qrwjkLts5cKMN2SgWIrE2W8WNVZQdE2xHUF1EudNx+VHyvqQW
	DWQ==
X-Google-Smtp-Source: AGHT+IHhyrWGwABBPnK3P+PXk3XqbI8YZLVeMIPiph5Olb+oYKw7B2dpfLQyExK13fUsFXUwAeZdgkDC2W8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:60b:b0:2cd:57fc:1db6 with SMTP id
 98e67ed59e1d1-2d1e7c5e18dmr25038a91.0.1723230275593; Fri, 09 Aug 2024
 12:04:35 -0700 (PDT)
Date: Fri, 9 Aug 2024 12:04:33 -0700
In-Reply-To: <DS0PR11MB6373A1908092810E99F387F7DCBA2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801224349.25325-1-seanjc@google.com> <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
 <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com> <DS0PR11MB6373A1908092810E99F387F7DCBA2@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZrZoQZEfTffvVT75@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: James Houghton <jthoughton@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, 
	Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2024, Wei W Wang wrote:
> On Friday, August 9, 2024 3:05 AM, James Houghton wrote:
> > On Thu, Aug 8, 2024 at 5:15=E2=80=AFAM Wang, Wei W <wei.w.wang@intel.co=
m> wrote:
> There also seems to be a race condition between KVM userfault and userfau=
ltfd.
> For example, guest access to a guest-shared page triggers KVM userfault t=
o
> userspace while vhost (or KVM) could access to the same page during the w=
indow
> that KVM userfault is handling the page, then there will be two simultane=
ous faults
> on the same page.
> I'm thinking how would this case be handled? (leaving it to userspace to =
detect and
> handle such cases would be an complex)

Userspace is going to have to handle racing "faults" no matter what, e.g. i=
f
multiple vCPUs hit the same fault and exit at the same time.  I don't think=
 it'll
be too complex to detect spurious/fixed faults and retry.

