Return-Path: <kvm+bounces-12155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 574488800BC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB8D01F25115
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6694E657C3;
	Tue, 19 Mar 2024 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ll1FXJxR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5C7651BE
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710862242; cv=none; b=ifT+qmswepQeD8xkFQWgQ/pVXssbb5/IrI0rDQ2XLsKerxCtRF97foWon3BpdiTafuQtDQZ6zGY6hyqzbE3YO3uTUaVMzQqaY7IAd7BFumIRZ9/YuT6sj4gmB1EFFyMEUVgLppfFICWAuVbD9EUusH9Tw1qoftpv7ksgDwXmDmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710862242; c=relaxed/simple;
	bh=9/QpWaWBH0RcwX9cpGd6kDPy30VAQIzVGPz2eDbW5fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkcLQJpWfAhGICtMlXvJxXjJ8a1c+4wSDDEx5F13ZuA3ugyIPG5gkxcJOlmj44xT4y57pC53BtyxT54TG57m9dI+em6t+/SeWdd5HoylwRj7tvkg5fvIZy/BRnCUpd4rGFreAfR5OB/wpnSo82VwZVpQfFe7M5DW3NDiSS/YDLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ll1FXJxR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710862239;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=37GFYLI5MyQqq4540bATPhxNX5uMFiPaTnTj87Z/d5c=;
	b=Ll1FXJxRCbGjZwWw4xKatWhZSZGN6qU1zBpAq1uV5AAOLWYoU2K1dBPodxcEeqOEiRp9q3
	gAtNfqz8/RRnEH64g4tt901hQt/jyziIo9Y+voCWXGRbZ0eOLKbyycK6ZAYxDLbmzyaKFD
	00FFW/zHtQcHhV1dJrDRxdQeKFVHYak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-kU30rjpWMg214CtLgs35JA-1; Tue, 19 Mar 2024 11:30:35 -0400
X-MC-Unique: kU30rjpWMg214CtLgs35JA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 583D2101CC6F;
	Tue, 19 Mar 2024 15:30:34 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.88])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE9B740C6DAD;
	Tue, 19 Mar 2024 15:30:32 +0000 (UTC)
Date: Tue, 19 Mar 2024 15:30:09 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Eric Auger <eauger@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
	qemu-arm@nongnu.org, Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <ZfmvgXa9Xs2QA-U3@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240221063431.76992-1-shahuang@redhat.com>
 <CAFEAcA-dAghULy_LibG8XLq4yUT3wZLUKvjrRzWZ+4ZSKfYEmQ@mail.gmail.com>
 <c50ece12-0c20-4f37-a193-3d819937272b@redhat.com>
 <CAFEAcA-Yv05R7miBBRj4N1dkFUREHmTAi7ih8hffA3LXCmJkvQ@mail.gmail.com>
 <0f8380d9-bdca-47b2-93d9-ee8f6382e7f1@redhat.com>
 <CAFEAcA_dQGfBDiFCm7PUmvDrQtp1UK9HqkkV0-5x8fb-svYDYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFEAcA_dQGfBDiFCm7PUmvDrQtp1UK9HqkkV0-5x8fb-svYDYA@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Tue, Mar 19, 2024 at 03:00:40PM +0000, Peter Maydell wrote:
> On Tue, 19 Mar 2024 at 14:57, Eric Auger <eauger@redhat.com> wrote:
> >
> > Hi Peter,
> >
> > On 2/29/24 12:00, Peter Maydell wrote:
> > >
> > > It doesn't appear because the list of properties that we advertise
> > > via query-cpu-model-expansion is set in the cpu_model_advertised_features[]
> > > array in target/arm/arm-qmp-cmds.c, and this patch doesn't add
> > > 'kvm-pmu-filter' to it. But you have a good point about all the
> > > others being bool properties: I don't know enough about that
> > > mechanism to know if simply adding this to the list is right.
> > >
> > > This does raise a more general question: do we need to advertise
> > > the existence of this property to libvirt via QMP? Eric, Sebastian:
> > > do you know ?
> > sorry I missed this question. yes I think it is sensible to expose that
> > option to libvirt. There is no good default value to be set at qemu
> > level so to me it really depends on the upper stack to choose the
> > correct value (depending on the sensitiveness of the data that justified
> > the kernel uapi).
> 
> In that case we should definitely have a mechanism for libvirt
> to be able to say "does this QEMU (and this CPU) implement
> this property?". Unfortunately my QMP/libvirt expertise is
> too low to be able to suggest what that mechanism should be...

Libvirt uses 'qom-list' on '/machine/unattached/device[0]' to
identify CPU properties.

If 'kvm-pmu-filter' appears with that, then detection will be
fine.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


