Return-Path: <kvm+bounces-46315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8DAAB4FE4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74AC97AF6C2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6499237717;
	Tue, 13 May 2025 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MtzlO7cx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D101DDA18
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128798; cv=none; b=NZ4kS+MjLppEx8an3dMwOR/6i/D5yTWe7/x1aRqXKmh6ePaszamRdw3wkdSah2AQQKeB4PJ4i39DsqspXcXB/VFPcXmaCmeSh9PZXpkW1tvQ6StClJ6cbEjrrsep6dtKleaN88FmMjmqHa/M95ZPwCiJborRURahlKH7jISC1L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128798; c=relaxed/simple;
	bh=kYCafdnnhoHb78BLur38mghelPeeuES2wDf7yRCgoNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzmYTCiTzsjgAd+lSgnxk/6xBYn8T6KHPUBG5ae99aay70EjRQoc1ecfy9Uc5RTjrznF8tX4dJaBSZUtTobfa94rQPrlFZy16GKP1tJ/6X/dDnMMP9XVJgTZeOHVwOcajnGCoj0cuEUR4pjSWW19Rnj0TtJnImAiXEeeIL3pLYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MtzlO7cx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747128796;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=FSlig199wVoNbDgW3dvwZUsFQR5bFCcLzhfmn5TmBRM=;
	b=MtzlO7cx/FGWDWlQNnOjzbi3hnmy6IyrSO9+Ugr1YC3tHwIHYVPLtVCwR8WKMn96IV8szy
	UmVb2YNCm/GE2z5CzBG2+rjzIGT6KcrpcBz4QRzVEndlALRUVnoR9BWcwIuiKQfC/1f7S0
	C5WdRgRz8sTr3AlFoHHunhBRV7OklSU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-926khPqKNyaih3aDkOWbew-1; Tue,
 13 May 2025 05:33:13 -0400
X-MC-Unique: 926khPqKNyaih3aDkOWbew-1
X-Mimecast-MFC-AGG-ID: 926khPqKNyaih3aDkOWbew_1747128790
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF84E18004A7;
	Tue, 13 May 2025 09:33:08 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.110])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D703730001A1;
	Tue, 13 May 2025 09:32:50 +0000 (UTC)
Date: Tue, 13 May 2025 10:32:44 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: Markus Armbruster <armbru@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
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
Subject: Re: How to mark internal properties
Message-ID: <aCMRvH0rWpWlgSNs@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
 <aB2vjuT07EuO6JSQ@intel.com>
 <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
 <aCG6MuDLrQpoTqpg@redhat.com>
 <87jz6mqeu5.fsf@pond.sub.org>
 <eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com>
 <87ecwshqj4.fsf@pond.sub.org>
 <60cd3ba8-2ab1-74ac-54ea-5e3b309788a1@eik.bme.hu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <60cd3ba8-2ab1-74ac-54ea-5e3b309788a1@eik.bme.hu>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, May 13, 2025 at 11:26:31AM +0200, BALATON Zoltan wrote:
> On Tue, 13 May 2025, Markus Armbruster wrote:
> > Mark Cave-Ayland <mark.caveayland@nutanix.com> writes:
> > > On a related note this also brings us back to the discussion as to
> > > the relationship between qdev and QOM: at one point I was under the
> > > impression that qdev properties were simply QOM properties that were
> > > exposed externally, i.e on the commmand line for use with -device.
> > > 
> > > Can you provide an update on what the current thinking is in this
> > > area, in particular re: scoping of qdev vs QOM properties?
> > 
> > qdev is a leaky layer above QOM.
> > 
> > qdev properties are also QOM properties.
> > 
> > All device properties are exposed externally.
> 
> That was clear but the question was if QOM properties (that are not qdev
> properties) exist and if so are they also exposed? If not exposed it may be
> used for internal properties (where simpler solutions aren't convenient) but
> maybe qdev also adds easier definition of properties that's why they used
> instead of QOM properties?

NB, not everything we expose is a QDev. We directly expose QOM
via "-object" if they implement the 'UserCreatable' interface.
If we want internal properties, that should likely be wired in
to the QOM level directly.

Conceptually you could even say that everything QEMU creates should
live under -object, and no other args ought to need to exist. We have
decades of evolved code making that impractical though.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


