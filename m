Return-Path: <kvm+bounces-43091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A591A84704
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 16:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6658719E1761
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 14:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E175728D823;
	Thu, 10 Apr 2025 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="izl1nAj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A601221CC6A
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 14:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744296730; cv=none; b=pF+zRUfodXG5YV52FEUb6A5FM0gz4WgWueDLP/lEfRlrn23tgCoRYPYUc3Pez9bxD24bZVq7EpUN7XXVOkVKiJYRYa6bPEtYtbSQ24sX93L/i06+SzynTIhEEHtytbFIRDvGQ4v7+5AFu981GCl/WabcWUdTaxNJmG3aooRPEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744296730; c=relaxed/simple;
	bh=ZIicm+KVsGD+UXLKJQ6xU43zvhsJHugkh0vLpA6ilxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nPa32BZaodGJvyL7yylLITGGWbNe87uteB/g9zMEU2R9x5HQASt7IBMqPwDiVn9u3MBWGFklieqUHqpzWVjUeSy5bOTOtN8Z91uU/NClWvlm0MIIAbCMnD41ixbzxrK+Y0u7s3BpnfCPhP4Z9vw7MmVcHoCqX0MjLa5LZXM4D6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=izl1nAj3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so1039358a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 07:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744296728; x=1744901528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z2Z/UC7GMxO7YogACXn6KcfTpVXYjk8lDSafrd3aGw=;
        b=izl1nAj3UVTkithmtbXKWdZ3RPoDf6Cu2DSf5BRMbhaGXsQGkJt8XoSuU3F+6bP4Bf
         8wKrWXUFRTx90ueNEW+ZZAU0UxU1P34dio7x/Gc80M6t6zdbPdT2DFE4XJRz7GGmFtgt
         /UdSJxIsEVis0kvs2ZYnlKLHeSJl7PQ2hYJtDgda6xLip96ccKMglzQmoV/FdQM6WGE0
         NecIFr2TC5yQaUaKN4TzyRTFDeB3WvR0pN8XxKdHikr0/Il7jt6JtuNQ0J8ymnLwOG2w
         MudSavFIC8ba4t6X7Z35VKt3G2dsiCteELzBCktXpC9xi61GhECom2/wqVnFAoLhcTRm
         EU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744296728; x=1744901528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z2Z/UC7GMxO7YogACXn6KcfTpVXYjk8lDSafrd3aGw=;
        b=M4usS/vpc7eUMWYotqa4HxT+E+4E6MlqjMcyQ5mhklEGEErX+JtQ1qk1Rj5JcGXrt9
         j+93s6LDbYYY6nuLToiJ4DcfkVxLUrQM5NNl3KpKd3XFaaY6n91RfSoVr2Lj8QnOkmxA
         0kTHUon6sDDABi0tpjv2MaekLcLI6K3Ricbsjsa4Dxs5qr4mgiSZ+LG+XmMQb3/lxegL
         ALtXY1r7QeJxjw8yIqv7atN6P5k4nD7nRgaPHsBj8w8fs5/mfC982tv7Ypw3cg46cdIW
         ZKhPyylFyftKKG7cjGgy/8fnG26RSOFhDIEl8OsQqH2iBVYFJYi+Yr/idCoYk85lUhGt
         HShw==
X-Forwarded-Encrypted: i=1; AJvYcCWo3K3TkC9c/dNt5qzRspJeushTDMV+81ylLljm0hdk6FNIxQjpQAsnVO7h+fQudFBr3E0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Vj3Z9sR1YBmC7snmWRv5EaMijvMqYfxmGS2p+MtskjA35rZC
	v+GxQRAPXpY1EVHk0qXxMLbzdLdzrXuZ2HRdBM/TvJhJ/dIdPKxx6VBUsHgHxfAE7by2OhXgX+a
	MPQ==
X-Google-Smtp-Source: AGHT+IGZay7VOQfADYHvwp0kpNoQEUaWaWhAXxEPULjNq/g/UaMADWvkJQ5d2IT2MEsdoUp5QTqBbaB3uao=
X-Received: from pjvf15.prod.google.com ([2002:a17:90a:da8f:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5844:b0:2ee:db8a:2a01
 with SMTP id 98e67ed59e1d1-307e9b43a9dmr3689922a91.30.1744296727781; Thu, 10
 Apr 2025 07:52:07 -0700 (PDT)
Date: Thu, 10 Apr 2025 07:52:05 -0700
In-Reply-To: <BN9PR11MB52769DDEE406798D028BC17D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com> <20250404211449.1443336-8-seanjc@google.com>
 <BN9PR11MB52769DDEE406798D028BC17D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Message-ID: <Z_fbFcT3gxNK_dWr@google.com>
Subject: Re: [PATCH 7/7] irqbypass: Use xarray to track producers and consumers
From: Sean Christopherson <seanjc@google.com>
To: Kevin Tian <kevin.tian@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Kevin Tian wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > Sent: Saturday, April 5, 2025 5:15 AM
> > 
> > Track IRQ bypass produsers and consumers using an xarray to avoid the
> > O(2n)
> > insertion time associated with walking a list to check for duplicate
> > entries, and to search for an partner.
> > 
> > At low (tens or few hundreds) total producer/consumer counts, using a list
> > is faster due to the need to allocate backing storage for xarray.  But as
> > count creeps into the thousands, xarray wins easily, and can provide
> > several orders of magnitude better latency at high counts.  E.g. hundreds
> > of nanoseconds vs. hundreds of milliseconds.
> 
> add a link to the original data collected by Like.
> 
> > 
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Like Xu <like.xu.linux@gmail.com>
> > Reported-by: Yong He <alexyonghe@tencent.com>
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
> > Link: https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com

I linked Like's submission here, which has his numbers.  Would it be helpful to
explictly call this out in the meat of the changelog?

