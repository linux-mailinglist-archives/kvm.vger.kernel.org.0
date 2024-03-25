Return-Path: <kvm+bounces-12571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F2388A2E3
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 499BF1F3C8A8
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBE113AA57;
	Mon, 25 Mar 2024 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bS1LiNmt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141315FA63
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356916; cv=none; b=FgljNTq6fTxnCbvNhhqKh8sUz18DrGzxFG/0oqP8Ch8VHm5FC7+gS1HID+7wzD0r/Nq6DGPOCMzwyrerI/Ji1L38kO57XnlQC9r1TF8rNQAv2YpO4RIhssoOHh6aFLtfZpu0pTkZUse1a5nYdRIfVtnhRJVTupc9BG+sGE84HsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356916; c=relaxed/simple;
	bh=osrAtMuTzdIzg624O7r9rvUZqjZc8GdcdXHRBMyHyLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5FTobTQcuOBNN9g7RdLT/Gr6AlUVXVCkzqkykE7FBLDR9googqv/fQsYC6IvHUndA8b1AvqueD61NFJm10psBDc+oMb5uGplhTkgGdmDMJCLEFnuUgHug8LWS99n6jrXZnTIDCGwhgSX+OFNz2TDPgf+UvE30KsXJM71Bux4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bS1LiNmt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711356914;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=NzcgNkYTAZFq8h8Dt8F6evBpJr85CKu5FqXaOBLyeEg=;
	b=bS1LiNmtNPm33kfQsQC819ys2r+SkpxJ3gOBjd1frMFCiH2a4TOUQurC6K24S/EcQ2kNWh
	j+fyzHWnycNdxXlxNRgvVxS697w+xFEJXmHStEYsuky3cgUln742aQuOouOUXyfxSC6A6W
	a/8kmgp7Es2icaAj7PHaCE0YbuSDghc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564--PeoPhtRNtmBTkNW7yapaw-1; Mon,
 25 Mar 2024 04:55:09 -0400
X-MC-Unique: -PeoPhtRNtmBTkNW7yapaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81EFB3C0E202;
	Mon, 25 Mar 2024 08:55:09 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.114])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B0742022EA7;
	Mon, 25 Mar 2024 08:55:08 +0000 (UTC)
Date: Mon, 25 Mar 2024 08:55:02 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <ZgE71v8uGDNihQ5H@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240312074849.71475-1-shahuang@redhat.com>
 <Zf2bbcpWYMWKZpNy@redhat.com>
 <1881554f-9183-4e01-8cda-0934f7829abf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1881554f-9183-4e01-8cda-0934f7829abf@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Mar 25, 2024 at 01:35:58PM +0800, Shaoqin Huang wrote:
> Hi Daniel,
> 
> Thanks for your reviewing. I see your comments in the v7.
> 
> I have some doubts about what you said about the QAPI. Do you want me to
> convert the current design into the QAPI parsing like the
> IOThreadVirtQueueMapping? And we need to add new json definition in the
> qapi/ directory?

Yes, you would define a type in the qapi dir similar to how is
done for IOThreadVirtQueueMapping, and then you can use that
in the property setter method.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


