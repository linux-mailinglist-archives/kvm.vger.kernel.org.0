Return-Path: <kvm+bounces-10039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B834868BE9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D57FD1F21CCC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C829B1369AD;
	Tue, 27 Feb 2024 09:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNYe5P0R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D07130E48
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709025154; cv=none; b=qlfRdQxZtK3FEhSE8MT4eom94FQoPqPIGUF5tNk+KjZpODLW5Vyfa+EeKd1JA5XWubEqOmj343OkEMeUM/iqfQbvyk5w691vloOS0DggiRULNLM/Rq4aYJ4Wd7l3FDg/oa/lBP8GbjzXtUuZUBpgfLEp4xbpVzE4vK3PPMW18vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709025154; c=relaxed/simple;
	bh=Zf/ONOLrZyforMFmdbgWSo9YHz8Lv21YnYvGjjwCP0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eE1kkweaJBqgRjqUEMe3HHqeAN/pQMcwGujOrIL0K2TgOZx7NCkynZt4nO1B2BaUjDoqDbBK/10oHpLGFLM2x4klBvQxOVuG/gPbeK59qrNuIRIERTIj2lxa8hdB+Wo/c8I2eqJQLIFbpNrhOk06lNQdM1RzvwKydV6oKqax2m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNYe5P0R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709025151;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=v+RdFPWoEi4G0dpITK5HWGkYzQ6cUrxSrSkxlO/IF04=;
	b=PNYe5P0RoYdrjNqIefUh5aRr0tRQdJkfg8hqCULk8AKEjbqaGMWDXU5ceIy7AvK8lVSeOl
	Y4GOZ36HcaKMk+IXi6h/yuhi5H1UzWXMYbDfqkSuU2noQIiLy7v9pfPZo7TURzXbjmLw6O
	pEA8KXHIU33rbYGJe+981Esr/7Yv3DA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-TdEwwMHjOVWUMPyxAOmaHA-1; Tue, 27 Feb 2024 04:12:28 -0500
X-MC-Unique: TdEwwMHjOVWUMPyxAOmaHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 567DA106D1AC;
	Tue, 27 Feb 2024 09:12:27 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0941BC185C0;
	Tue, 27 Feb 2024 09:12:22 +0000 (UTC)
Date: Tue, 27 Feb 2024 09:12:20 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <Zd2ndJghXbmMHzBn@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <20240226153947.00006fd6@Huawei.com>
 <Zd2pWVH4/eo3HM8j@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zd2pWVH4/eo3HM8j@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Feb 27, 2024 at 05:20:25PM +0800, Zhao Liu wrote:
> Hi Jonathan,
> 
> > Hi Zhao Liu
> > 
> > I like the scheme.  Strikes a good balance between complexity of description
> > and systems that actually exist. Sure there are systems with more cache
> > levels etc but they are rare and support can be easily added later
> > if people want to model them.
> 
> Thanks for your support!
> 
> [snip]
> 
> > > +static int smp_cache_string_to_topology(MachineState *ms,
> > 
> > Not a good name for a function that does rather more than that.
> 
> What about "smp_cache_get_valid_topology()"?
> 
> > 
> > > +                                        char *topo_str,
> > > +                                        CPUTopoLevel *topo,
> > > +                                        Error **errp)
> > > +{
> > > +    *topo = string_to_cpu_topo(topo_str);
> > > +
> > > +    if (*topo == CPU_TOPO_LEVEL_MAX || *topo == CPU_TOPO_LEVEL_INVALID) {
> > > +        error_setg(errp, "Invalid cache topology level: %s. The cache "
> > > +                   "topology should match the CPU topology level", topo_str);
> > > +        return -1;
> > > +    }
> > > +
> > > +    if (!machine_check_topo_support(ms, *topo)) {
> > > +        error_setg(errp, "Invalid cache topology level: %s. The topology "
> > > +                   "level is not supported by this machine", topo_str);
> > > +        return -1;
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +static void machine_parse_smp_cache_config(MachineState *ms,
> > > +                                           const SMPConfiguration *config,
> > > +                                           Error **errp)
> > > +{
> > > +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> > > +
> > > +    if (config->l1d_cache) {
> > > +        if (!mc->smp_props.l1_separated_cache_supported) {
> > > +            error_setg(errp, "L1 D-cache topology not "
> > > +                       "supported by this machine");
> > > +            return;
> > > +        }
> > > +
> > > +        if (smp_cache_string_to_topology(ms, config->l1d_cache,
> > > +            &ms->smp_cache.l1d, errp)) {
> > 
> > Indent is to wrong opening bracket.
> > Same for other cases.
> 
> Could you please educate me about the correct style here?
> I'm unsure if it should be indented by 4 spaces.

It needs to look like this:

        if (smp_cache_string_to_topology(ms, config->l1d_cache,
                                         &ms->smp_cache.l1d, errp)) {

so func parameters are aligned to the function calls' opening bracket,
not the 'if' statement's opening bracket.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


