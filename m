Return-Path: <kvm+bounces-42552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0299DA79DB8
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 10:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 396B31885945
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8434241CBA;
	Thu,  3 Apr 2025 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dH/IU/l6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A91241690
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743667876; cv=none; b=EA1am2jazzevB6mRx+E3ig7Zt/dlMCMdNJZ2+RmC28FoC+e6MX319awHzARCn+T+m4auegbyjk1yNJxywo944QOWPlWbMPBym7Rmo7hS1SpkKlqaCjiOLI69Q9mxbTdXcuQAoGAIy04zp24Ne5CqzkCxyzFfc0eBc95zNeJVu8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743667876; c=relaxed/simple;
	bh=uyrGjRv7/+0Xv1bEzKbXi/RI8SZ6nTHb7ndxTpnD1TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crnvJyPxvoSwZmzS3upC+38v/ASqwm4faH3Sqg5y9U3SHx/CNz/eNfIIkVbSXRgyQndNhtaqREEOT3g69tQUic/qwaRAoqAgxofgAdr4/tMvm/CwcYPCZpEUXSes4/Y5cR/FyzhSkpgg2ReK7KbDXs9qo7g7k7CtEg+6jVt3DV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dH/IU/l6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743667874;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aw5MDRBHqeo6dcp58yChqmXZDDdCUU9CrG94rPdi9i4=;
	b=dH/IU/l6tPJNwAFJ073LLXGncQypblzGlpuIm90gJxXFyzBt75BxFtuj9pYyW/gKJn2xvQ
	7kjZjggzf2jhvFnY5BOD0DuGnY8iN+d4TaGAFpyEtH4KlqBS1d//9K+TOTLJBTAuSzo0Wm
	yq36KfB72cs46x9Ub1DveixT4lPcTME=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-f5YhcdsaMBGO9gkLDIruJw-1; Thu,
 03 Apr 2025 04:11:10 -0400
X-MC-Unique: f5YhcdsaMBGO9gkLDIruJw-1
X-Mimecast-MFC-AGG-ID: f5YhcdsaMBGO9gkLDIruJw_1743667869
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4DAB195605E;
	Thu,  3 Apr 2025 08:11:08 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.42])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8653A1954B01;
	Thu,  3 Apr 2025 08:10:59 +0000 (UTC)
Date: Thu, 3 Apr 2025 09:10:55 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <Z-5Ces2kGrB67aPw@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
 <Zv7dtghi20DZ9ozz@redhat.com>
 <0e15f14b-cd63-4ec4-8232-a5c0a96ba31d@intel.com>
 <Z-1cm6cEwNGs9NEu@redhat.com>
 <a3a8ed8d-9994-42c9-ba3b-ef59d6977ce6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3a8ed8d-9994-42c9-ba3b-ef59d6977ce6@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Apr 03, 2025 at 03:28:43PM +0800, Xiaoyao Li wrote:
> On 4/2/2025 11:49 PM, Daniel P. Berrangé wrote:
> > On Wed, Apr 02, 2025 at 11:26:11PM +0800, Xiaoyao Li wrote:
> > > 
> > > I guess the raw mode was introduced due to the design was changed to let
> > > guest kernel to forward to TD report to host QGS via TDVMCALL instead of
> > > guest application communicates with host QGS via vsock, and Linux TD guest
> > > driver doesn't integrate any QGS protocol but just forward the raw TD report
> > > data to KVM.
> > > 
> > > > IMHO, QEMU should be made to pack & unpack the TDX report from
> > > > the guest into the GET_QUOTE_REQ / GET_QUOTE_RESP messages, and
> > > > this "raw" mode should be removed to QGS as it is inherantly
> > > > dangerous to have this magic protocol overloading.
> > > 
> > > There is no enforcement that the input data of TDVMCALL.GetQuote is the raw
> > > data of TD report. It is just the current Linux tdx-guest driver of tsm
> > > implementation send the raw data. For other TDX OS, or third-party driver,
> > > they might encapsulate the raw TD report data with QGS message header. For
> > > such cases, if QEMU adds another layer of package, it leads to the wrong
> > > result.
> > 
> > If I look at the GHCI spec
> > 
> >    https://cdrdv2-public.intel.com/726790/TDX%20Guest-Hypervisor%20Communication%20Interface_1.0_344426_006%20-%2020230311.pdf
> > 
> > In "3.3 TDG.VP.VMCALL<GetQuote>", it indicates the parameter is a
> > "TDREPORT_STRUCT". IOW, it doesn't look valid to allow the guest to
> > send arbitrary other data as QGS protocol messages.
> 
> In table 3-7, the description of R12 is
> 
>   Shared GPA as input - the memory contains a TDREPORT_STRUCT.
>   The same buffer is used as output - the memory contains a TD Quote.
> 
> table 3-10, describes the detailed format of the shared GPA:
> 
> starting from offset 24 bytes, it is the "Data"
> 
>   On input, the data filled by TD with input length. The data should
>   include TDREPORT_STRUCT. TD should zeroize the remaining buffer to
>   avoid information leak if size of shared GPA (R13) > Input Length.
> 
> It uses the word "contains" and "include", but without "only". So it is not
> clear to me.
> 
> I will work with internal attestation folks to make it clearer that who (TD
> guest or host VMM) is responsible to encapsulate the raw TDERPORT_STRCUT
> with QGS MSG protocol, and update the spec accordingly.

To be clear, my strong preference is that the spec be updated to only
permit the raw TDREPORT_STRUCT.

IMHO allowing arbitrary QGS MSGs would be a significant host security
weakness, as it exposes a huge amount of the QGS codebase to direct
attack from the guest. QEMU needs to be able to block that attack
vector. Without that, the benefit/value of shuffling of TDREPORTs via
the GetQuote hypercall is largely eliminated, and might as well have
just exposed QGS over VSOCK.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


