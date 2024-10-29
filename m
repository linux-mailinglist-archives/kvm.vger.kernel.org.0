Return-Path: <kvm+bounces-29945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E32639B4B22
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20AF51C22689
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 13:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A6820650E;
	Tue, 29 Oct 2024 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLP7+qMF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFB920110B
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730209530; cv=none; b=l+BICP69nUB+WN20lKhkiJb7pBz8439t5DjFgXryEbiXhD7z1rDOiyxR/Cy3Tu5nc8zaXmCYdkvsROsC3WJMkYI25iCILXge3irYc2a+4l+6ye4x+EVxClG0x7r0Kh86exWU/IlmopsuDlpMz9BKnckhTchmbHwqOXSsciNSVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730209530; c=relaxed/simple;
	bh=rs0GY66OkD5KdorTMLFQxyHUnobGBq77b2NXknl0J4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MILmkkGUTtEJp/Dpj74GxDYM5HsxS3YLOEN19Zl0I2q5HJHWbclTtSnUPX3ZDLzg7F+KHteZX05MlNWsg7rUgxJXwx+TS8s42UZe7WqwdgFOpz9bs52H9c6KhmhSegMHdBwsekpDWTdDtzXuk/z2maQIn1jM4zOQfSqJhIa5S6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLP7+qMF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730209526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtkDk4obOcGU3ViQFPgP0Y9MdKhVxxTkytXXF2dG21g=;
	b=hLP7+qMF5zwQdjIILM2w9e0VEnAMtRLXblzx0wzN9ScSeCFsFeEsXDqWczG0J1do9nH3uW
	BuQF3KTeKVZK82NqmioAglMg4w2+944212A5v4Z3e+qQ2C16f+zwlCJK4BRGkGuX4K24PQ
	oTa4uAXX3nj5UQ75oPetJcNHwlJsoE0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-571-H-3KNJE6M9GS_qyNuAZn9A-1; Tue,
 29 Oct 2024 09:45:20 -0400
X-MC-Unique: H-3KNJE6M9GS_qyNuAZn9A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBE661954B1F;
	Tue, 29 Oct 2024 13:45:18 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BE9F19560A3;
	Tue, 29 Oct 2024 13:45:18 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 9A8F0400DF400; Tue, 29 Oct 2024 10:44:59 -0300 (-03)
Date: Tue, 29 Oct 2024 10:44:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com, rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Message-ID: <ZyDm25/oSBfuUpqj@tpad>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com>
 <ZxvGPZDQmqmoT0Sj@tpad>
 <81e6604b-fa84-4b74-b9e6-2a37e8076fd7@intel.com>
 <Zx+/Dl0F73GUrzI2@tpad>
 <714ab7a2-69fa-b08d-deae-6eb91ecba95b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714ab7a2-69fa-b08d-deae-6eb91ecba95b@amd.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Oct 29, 2024 at 09:34:58AM +0530, Nikunj A. Dadhania wrote:
> Hello Marcelo
> 
> On 10/28/2024 10:12 PM, Marcelo Tosatti wrote:
> > On Sun, Oct 27, 2024 at 10:06:17PM +0800, Xiaoyao Li wrote:
> >> On 10/26/2024 12:24 AM, Marcelo Tosatti wrote:
> >>> On Mon, Oct 14, 2024 at 08:17:19PM +0530, Nikunj A. Dadhania wrote:
> >>>> Hi Isaku,
> >>>>
> >>>> On 10/12/2024 1:25 PM, Isaku Yamahata wrote:
> >>>>> Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> >>>>> supported.
> >>>>
> >>>> I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and
> >>>> GUEST_TSC_SCALE are only available to the guest.
> >>>
> >>> Nikunj,
> >>>
> >>> FYI:
> >>>
> >>> SEV-SNP processors (at least the one below) do not seem affected by this problem.
> >>
> >> Did you apply Secure TSC patches of (guest kernel, KVM and QEMU) manualy?
> >> because none of them are merged. 
> > 
> > Yes. cyclictest latency, on a system configured with tuned
> > realtime-virtual-host/realtime-virtual-guest tuned profiles,
> > goes from 30us to 50us.
> 
> Would you be ok if I include your Tested-by in the next version of my Secure TSC patches?
> 
> https://lore.kernel.org/lkml/20241028053431.3439593-1-nikunj@amd.com/

Please don't, haven't tested specifically the patches above.

> >> Otherwise, I think SNP guest is still using
> >> KVM emulated TSC.
> > 
> > Not in the case the test was made.
> > 
> 
> Regards,
> Nikunj
> 
> 


