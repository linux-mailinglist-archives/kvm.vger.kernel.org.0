Return-Path: <kvm+bounces-12492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A43886F19
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 15:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 222571F24066
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 14:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23214AEC7;
	Fri, 22 Mar 2024 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c7UkzjOM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436E4482C1
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711119227; cv=none; b=P/sDxH7avHtNjhyIaaSqY/4CXlRoQGT08cvaXRVjTuQhW4YP3dlPEiCWkqk5Fv8ZFNjR/iGuLr1777pmqqC7fn9DsEFPzIM7SYUJKKjhRBapF5EowV5/D3jZNwRTM4lY0HGI+erWf1AjlODhV8k0smqKIo+oCJqKodE8p+E8Dmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711119227; c=relaxed/simple;
	bh=xapOcc2M1o47R2kZ1HYDznORGl9bzO0v+KnmrUtQBl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOfPJmQ2DpVjxQ6B5pmR+7/sLF9hr4FY9Q1HpUBvjP+h57kavfufPOntTHlucYPDX7v6yRYa3yHodRVhuv5YQm1J+XKQJm//6A6yA8fWuJJ9Eg/YeffLgHpyXjLcY6XT5ehg1EzcAbrwfJqqSsJshwoCqsmRmxwn6kZyZ6nKpdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c7UkzjOM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711119225;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=NgRxGJCY4jyhkl9FMooV0KnBI1lLsjDWAntVYrklqTo=;
	b=c7UkzjOMFYpVA+5yr8to3ECibokI9+bi8feg8PF7EDcgLrggD5GhvRUBVnoewKTS6lOQQk
	kSASyPwtenydC2hs2mSHCPLuWDkvHxt9nCLeMky69QKibu+WOvjk2iVSTVfVnz2e862IOg
	l9ZQdHO2e3oprgUz3tveRYY7fuW5Kdc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-tZsNLacnPIOEgMYrRVRh7A-1; Fri, 22 Mar 2024 10:53:41 -0400
X-MC-Unique: tZsNLacnPIOEgMYrRVRh7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BB8C8007A7;
	Fri, 22 Mar 2024 14:53:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.46])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27A508173;
	Fri, 22 Mar 2024 14:53:40 +0000 (UTC)
Date: Fri, 22 Mar 2024 14:53:33 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <Zf2bbcpWYMWKZpNy@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240312074849.71475-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240312074849.71475-1-shahuang@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Tue, Mar 12, 2024 at 03:48:49AM -0400, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> Without the filter, all PMU events are exposed from host to guest by
> default. The usage of the new sub-option can be found from the updated
> document (docs/system/arm/cpu-features.rst).
> 
> Here is an example which shows how to use the PMU Event Filtering, when
> we launch a guest by use kvm, add such command line:
> 
>   # qemu-system-aarch64 \
>         -accel kvm \
>         -cpu host,kvm-pmu-filter="D:0x11-0x11"

I mistakenly sent some comments to the older v7 (despite this v8 already
existing) about the design of this syntax So for linking up the threads:

 https://lists.nongnu.org/archive/html/qemu-devel/2024-03/msg04703.html

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


