Return-Path: <kvm+bounces-71835-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGBbMfT/nmlAYgQAu9opvQ
	(envelope-from <kvm+bounces-71835-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:58:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA3B198731
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 46F2E30774FC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F80A3C1970;
	Wed, 25 Feb 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTofPcRH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01DA34E769
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772027725; cv=none; b=Ac18p8ceUvDLiYs6IjORXAkZsi+b2U6hFq8z3EqLsCmYCaA+lysKDYSBHEFK/9mKaN+0Tb7ltseOrpXVMPuycayzrFqJjHLM+j99HXiFdP0gDEgAYyZDF2E5RQzcVL4n1RT7zouxzn/hVOhlqlemLfWu2og5duQDcWuUTxl8/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772027725; c=relaxed/simple;
	bh=j8QD+YOKTudOlbEWjrHGAEdh2xgoRTUdHV6Nf6Pmn5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NBkffFVIwFIKqNgAwRdwRzNQ3oIWphWDFGmgTCyGMZwLR3iBT2hm5GFZIpCeqPy7K4Xen0SQEI4ptoxXwMszKmsucCkJ2kGSL5UgOQ7v4E5ybavDUB/K3YOQeyGaarOl78HbwS9eHY/LKWtExdZLOVXhV5SBdkodKPSUGy/7lb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FTofPcRH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3545b891dd1so38131027a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772027724; x=1772632524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hj5kWs8x13Nc52H5YwkoGAX7bER0Qj5o5LwtSPL8HY8=;
        b=FTofPcRHGNC0n5AajSeMDVCPi+M7lme/LMHQ9qxJKDjkTeIVY54OdL8mAPjeOTuJ0u
         oinrIp04gmmeC7eS0NoOr0f7QY/GdTsgtkTCEMeiXs5TKbw9yfkDvRA172p/VLHDZJPM
         XFW7wrKtya+IHR2e5JWQ/HqOAPnFWEOh4sAjHFQDWio2NvL6MnCFCuEOS7KmCxs/LTdR
         X6djsO/xv0QCOhotJON13RfLgDtteqyYoW/OlMaTgQjnfPO8rJ4YGjo+2gOAOcSuBeK/
         +r5z1jQvKfhGPuFkW9lX5SQ1V4L/HXdstoqE+Qam1J8ZwpdEit57ILmuit15lYDmV9hP
         LXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772027724; x=1772632524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hj5kWs8x13Nc52H5YwkoGAX7bER0Qj5o5LwtSPL8HY8=;
        b=Vuogz2OePMj9AMro83lK0I+Xb9we3w2tKjyk3/+Oj0cKOs96oBiizYf5FiHI2OytgR
         8YSNbwvgXk4xUAUq8lxFkMdZUEdSotWDPUuovuown8RL7IsEwTD9oZ2JcXxa3OTnvZOs
         Al+v0kEjMIfZ2B6l69mOsMHjaQZ4SWUDppU82Q0+qilXUntHTLIOgUA/nLBU+VFiqsmz
         xNgut2H3HBlNPjHOHECyAAjgXBBRQ9tFBVIkEF9bXH6GteiGI4y8+y8Y9U9gp6wR/lqi
         0oisvhgDZkcob4gShKqTl+msoLw/Nq98Xll2YYFcM5KwubjhWfZFSo7DEBUTGy5veCb3
         jB7A==
X-Forwarded-Encrypted: i=1; AJvYcCWMTDd+MpG37293uC4Dfj947OEWafqvsXTQxufR1QBYZFXtaxr69lm9CQ+U+KKDKxxZDFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ7pbhra6L5pSmwcSDDjKpScDVntEQL86ey8oO3CudADZQYbOI
	nxZj9ic0/3ZVU5i/7Pt6xTYmJgYjkrjyIyfwbkmID/pc8k2ETu56LcrRTHGYXKmX7kqOhrhCW0G
	6bdAZlw==
X-Received: from pjbee5.prod.google.com ([2002:a17:90a:fc45:b0:34f:96fa:45e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3147:b0:354:a065:ec3b
 with SMTP id 98e67ed59e1d1-358ae8d5edbmr14072256a91.27.1772027724097; Wed, 25
 Feb 2026 05:55:24 -0800 (PST)
Date: Wed, 25 Feb 2026 05:55:22 -0800
In-Reply-To: <20260225075211.3353194-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225075211.3353194-1-aik@amd.com>
Message-ID: <aZ7-tTpobKiCFT5L@google.com>
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev, linux-coco@lists.linux.dev, 
	Dan Williams <dan.j.williams@intel.com>, Santosh Shukla <santosh.shukla@amd.com>, 
	"Pratik R . Sampat" <prsampat@amd.com>, Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71835-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7DA3B198731
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Alexey Kardashevskiy wrote:
> For the new guest_memfd type, no additional reference is taken as
> pinning is guaranteed by the KVM guest_memfd library.
> 
> There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
> the assumption is that:
> 1) page stage change events will be handled by VMM which is going
> to call IOMMUFD to remap pages;
> 2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
> handle it.

The VMM is outside of the kernel's effective TCB.  Assuming the VMM will always
do the right thing is a non-starter.

