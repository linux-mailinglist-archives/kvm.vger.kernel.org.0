Return-Path: <kvm+bounces-30733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1459BCC3A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207AA283D47
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDC41D47C8;
	Tue,  5 Nov 2024 11:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPg1pZzg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5CE1D3593
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807716; cv=none; b=JCOLUZo8bGeVsicudpdYSnQ/WOdDjH/V7voExzhk+VBJpNFspsdv7d5/xu03CFSBT4KS7yqJUzgsGZ439jEFkhKjdXJrzf45QWI/t/CGlU/mtV9XxlMq/a5NZclAr2JnTJdf8rZLU64SVB10bkJOPgqdA6Pa4huIXMMUBZ2TVDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807716; c=relaxed/simple;
	bh=8YaXvTzJ7JklhVt7flNR6pmyzP2d1LQ9wcZBn6iSBKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvleE3RuOC+L8f7SLK6CArHn1SzHnFN040mBhvnHePma7z3sWiMbDjdzHkr7zyTauTTFkgOmGJFlhhlER577hi4iwZZuoUpjicRUJvc4PIX8Ox8OfE421xL+hot6mb7tbLMJja+EF5yT4SGueGI+3ZkfvTkCIN0sA5k97Gu2G3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPg1pZzg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730807713;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbGyVdIM0bilx3FdtiaVh2tHO0JsOM+LxjXtPCL7FKo=;
	b=aPg1pZzgL5mQMu8k6WdEXPlNrRNFkS3fp5c1m2YK5xyavVG3pGajE7fsyeOQu3xTzuopqd
	kFi4XVoDWoY2ghtT58ysWl8LDQY5pOuuNLVLO/ScqW7h3U775fMq5jdCukT9LGBcmSWsNC
	6g9H5nN+9MiuFGvj3KxJK+fOQhwDc0U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-75U2yIvnMamJ_vNCKkpwRQ-1; Tue,
 05 Nov 2024 06:55:10 -0500
X-MC-Unique: 75U2yIvnMamJ_vNCKkpwRQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94FA2195608F;
	Tue,  5 Nov 2024 11:55:07 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36011300018D;
	Tue,  5 Nov 2024 11:54:59 +0000 (UTC)
Date: Tue, 5 Nov 2024 11:54:56 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 13/60] i386/tdx: Validate TD attributes
Message-ID: <ZyoHkCyknQZTeISs@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-14-xiaoyao.li@intel.com>
 <Zyn1Jhxr8ip0lIcs@redhat.com>
 <7fbf9071-493a-4929-afaa-d0a669346f17@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fbf9071-493a-4929-afaa-d0a669346f17@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 05, 2024 at 07:53:57PM +0800, Xiaoyao Li wrote:
> On 11/5/2024 6:36 PM, Daniel P. Berrangé wrote:
> > On Tue, Nov 05, 2024 at 01:23:21AM -0500, Xiaoyao Li wrote:
> > > Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
> > > fixed-1 bits must be set.
> > > 
> > > Besides, sanity check the attribute bits that have not been supported by
> > > QEMU yet. e.g., debug bit, it will be allowed in the future when debug
> > > TD support lands in QEMU.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> > > 
> > > ---
> > > Changes in v3:
> > > - using error_setg() for error report; (Daniel)
> > > ---
> > >   target/i386/kvm/tdx.c | 28 ++++++++++++++++++++++++++--
> > >   1 file changed, 26 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> > > index 6cf81f788fe0..5a9ce2ada89d 100644
> > > --- a/target/i386/kvm/tdx.c
> > > +++ b/target/i386/kvm/tdx.c
> > > @@ -20,6 +20,7 @@
> > >   #include "kvm_i386.h"
> > >   #include "tdx.h"
> > > +#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
> > >   #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
> > >   #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
> > >   #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
> > > @@ -141,13 +142,33 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
> > >       return KVM_X86_TDX_VM;
> > >   }
> > > -static void setup_td_guest_attributes(X86CPU *x86cpu)
> > > +static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
> > > +{
> > > +    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
> > > +            error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
> > > +                       "(supported: 0x%llx)",
> > > +                       tdx->attributes, tdx_caps->supported_attrs);
> > > +            return -1;
> > 
> > Minor whitespace accident, with indentation too deep.
> 
> Good catch!
> 
> btw, how did you catch it? any tool like checkpatch.pl or just by your eyes?

Nah, I just notice the mis-alignment when reading the patches.

> 
> > > +    }
> > > +
> > > +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
> > > +        error_setg(errp, "Current QEMU doesn't support attributes.debug[bit 0] "
> > > +                         "for TDX VM");
> > > +        return -1;
> > > +    }
> > > +
> > > +    return 0;
> > > +}

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


