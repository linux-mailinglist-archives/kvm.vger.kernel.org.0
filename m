Return-Path: <kvm+bounces-37636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 955FCA2CEB3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 22:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AEB97A45B5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 21:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBCB1ADFE4;
	Fri,  7 Feb 2025 21:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l5qEclpU"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C322195FE5
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738962384; cv=none; b=LwZSRRcRKh0NS7CGObg3GrTtF7q1vKSfB5Fqx2yGMvfXyie60b4X+nwfSO6u+TuFU1nMLXuiO9nSYAtpCzok+ssipwHUK3L8t2idJS9ZVLDOQACFh+YNYDZzEf9ay+bxf1cvd5ijdB4oFcyg6YaY2WNo7H/EP6bwq2ZtApTT0kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738962384; c=relaxed/simple;
	bh=nPlHYF3oWmoqvKtn6s9aUg8miIl94JqKo5WwlEdjngk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=qdfK/s15gJWy/udD6ej/a6o1IbqFaGsHmhyXqKLGoG0y6otNW4ZsV97ARm0ElzUen3Zh3GmigS7kcWWyX217PolvcFm60L0uYkoXjHrQIfnQFe1lMwaSQ5esuuC4JvhLH/k/D2iHU5uLdCGQEKH0Eu2vdqCsEs7S7A921A5JgvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l5qEclpU; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=LZO3COT8kUUb9a66R4TRMCeBBKOc0btjWfEndw9H1KY=; b=l5qEclpUeZ40bJSc747L1wcntK
	+EwqoEUUFCXt/4AzXtSJfM4VZYHcRU5N0CtxoJeWdTYWUAr0+DwUB2h+91ptSCiWSFHK6DCXul3av
	MnYBayP/s4n9U6CYUZcS4+W7fvHk2TI53BBM+sjuxlAOyt1hg0Z+gCTnYyarIEh3IpUtYUvJiqeGs
	/zIPOANuqOOR9GbxEYt9rlnt0U04f4XHgCgAJBy2zk+JlIx4nXgmrgbNKMPYKvstb2WCTT9qAQmkU
	u7KR7bl0F0OtkY/mje1VLvJxphkvCCvxzTiaou3N8iH2+qrBeWhNA5E44jQ4GPBmtvvJJ30yItHHf
	TaJo8auA==;
Received: from [2001:8b0:10b:5:4b09:6838:d292:2864] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgVY9-0000000HJY6-1q3T;
	Fri, 07 Feb 2025 21:06:09 +0000
Date: Fri, 07 Feb 2025 21:06:10 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
CC: qemu-devel@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org, kvm@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_i386/xen=3A_Move_KVM=5FXEN=5F?=
 =?US-ASCII?Q?HVM=5FCONFIG_ioctl_to_kvm=5Fxen=5Finit=5Fvcpu=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Z6YoxFOaMdNiD_uv@google.com>
References: <20250207143724.30792-1-dwmw2@infradead.org> <Z6YoxFOaMdNiD_uv@google.com>
Message-ID: <A51B44C4-5D78-4D8A-A6EB-DA937377F6CE@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 7 February 2025 15:37:40 GMT, Sean Christopherson <seanjc@google=2Ecom> =
wrote:
>On Fri, Feb 07, 2025, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> At the time kvm_xen_init() is called, hyperv_enabled() doesn't yet work=
, so
>> the correct MSR index to use for the hypercall page isn't known=2E
>>=20
>> Rather than setting it to the default and then shifting it later for th=
e
>> Hyper-V case with a confusing second call to kvm_init_xen(), just do it
>> once in kvm_xen_init_vcpu()=2E
>
>Is it possible the funky double-init is deliberate, to ensure that Xen is
>configured in KVM during VM setup?  I looked through KVM and didn't see a=
ny
>obvious dependencies, but that doesn't mean a whole lot=2E

I am fairly sure there are no such dependencies=2E It was just this way be=
cause shifting the MSR to accommodate Hyper-V (and making kvm_xen_init() id=
empotent in order to do so) was an afterthought=2E In retrospect, I should =
have done it this way from the start=2E It's cleaner=2E And you don't requi=
re as much caffeine to understand it :)

