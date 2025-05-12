Return-Path: <kvm+bounces-46154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FB3AB32BB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B122E188E92D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECC7257443;
	Mon, 12 May 2025 09:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CTnU96ja"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C6617BB6
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 09:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747040846; cv=none; b=IbayBcwWLIcVTG9SwiJCbPp1fKx5qSELl8FtUf6EgNkvYXEboenSC8Kif7uSjsWKNNP1BMfbCbPO8e+VK4Mbfy1n37EyDSwJfETEhgRDxURjxqAo1SIxCtzNsTvrfsY+mdZLbV2YpGYVRye/lIZbjx4JY1OYIlvXSeRKgMOxTck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747040846; c=relaxed/simple;
	bh=TOcAHwmbXWBt8hhO/LpUSu7leJ3168e2PtCljpq4C6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkEaT74Ba+wig7Dqu2n8gyT7zhzIvfqqUXfldNCO6kfpT6a0zbbTr3Gn+nKm/O21E3ylCZRGcDpIhNpyX3HmQf5CEnnNUzW0hhyYBClWOkvYrGVDnCz4HtNqhO59gVvaWZJ6X42XDYWpLEW2d6WZm/ouCOmoLHbxDKHxIBwQNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CTnU96ja; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747040843;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=5odr4a2Xq+180JEfvS0fVAKnaUgen9zbM0bNb4Nha9w=;
	b=CTnU96jamCzbWxO8SyuyxiWYFDUfs8KzUPw86tSwpptp44zaj+4drC3SlwsZ2xtwAceRN1
	zXnezDxrEbuw9pDMqgF7vyf7OVN9IJDDX74QlpAsvW8Hdj7pDwtMU+44JkAJuhvay+L5Sc
	0AJhqdqWLLv86mZh2GFQWLy6dX/YNug=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-W3OS7mmcMvm-XVakSNQqgA-1; Mon,
 12 May 2025 05:07:19 -0400
X-MC-Unique: W3OS7mmcMvm-XVakSNQqgA-1
X-Mimecast-MFC-AGG-ID: W3OS7mmcMvm-XVakSNQqgA_1747040836
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C99FC1955DEA;
	Mon, 12 May 2025 09:07:15 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.162])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D175119560A3;
	Mon, 12 May 2025 09:07:01 +0000 (UTC)
Date: Mon, 12 May 2025 10:06:58 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties (was: Re: [PATCH v4 12/27]
 target/i386/cpu: Remove CPUX86State::enable_cpuid_0xb field)
Message-ID: <aCG6MuDLrQpoTqpg@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
 <aB2vjuT07EuO6JSQ@intel.com>
 <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:
> On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote:
> > Thanks for your clarifications, Zhao! But I think this shows again the
> > problem that we have hit a couple of times in the past already: Properties
> > are currently used for both, config knobs for the users and internal
> > switches for configuration of the machine. We lack a proper way to say "this
> > property is usable for the user" and "this property is meant for internal
> > configuration only".
> >
> > I wonder whether we could maybe come up with a naming scheme to better
> > distinguish the two sets, e.g. by using a prefix similar to the "x-" prefix
> > for experimental properties? We could e.g. say that all properties starting
> > with a "q-" are meant for QEMU-internal configuration only or something
> > similar (and maybe even hide those from the default help output when running
> > "-device xyz,help" ?)? Anybody any opinions or better ideas on this?
> 
> I think a q-prefix is potentially a bit clunky unless we also have
> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
> and have it auto-add the prefix, and to have the C APIs for
> setting properties search for both "foo" and "q-foo" so you
> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).

I think it is also not obvious enough that a 'q-' prefix means private.

Perhaps borrow from the C world and declare that a leading underscore
indicates a private property. People are more likely to understand and
remember that, than 'q-'.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


