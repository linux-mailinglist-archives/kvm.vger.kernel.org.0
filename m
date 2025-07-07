Return-Path: <kvm+bounces-51698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3993AFBBBC
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 21:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 525BB4A1CCA
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9536C1F4192;
	Mon,  7 Jul 2025 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcfEd+TF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0FB2E36F4
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 19:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751916730; cv=none; b=TwHVJdmrhV32yD9ZmZEEW//tRZ5+deSqiJ94ykfXEXzwOdqMfQ6ZCmFKNxbWDxqmBBJpWjiACrhSf4oa91qOTGV8Or8+m+oKd1xiWhLv+iKPkiIPt+hF8p5+rf/7eV4TNTvU4ZG5c6TLo9U0f/Rmwtfp0WNrSwMfi499IBRj7y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751916730; c=relaxed/simple;
	bh=ZtDp31Urbc+kzzpIMHlH78fL70+CFgj20P8XsxGoKVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gypYrtmgvEd0cobH1MsOGZvtEHa/1jdoAmNaN54i7bg8rL/g82LdN70GxAYWrQ8g0iRFEPR8L0/qV3gttrbZwmmR3v99laD3cMwBg2GCYRqWlX+ptzvBuhreJ6mbyHyQM84IjOJhiJCRfCHc6oAdPt+Lh10mTXFVfwa8WZ2I0Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcfEd+TF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751916728;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=302NR68NX9S2axfZIw64TZ/EOfxkkD+1zcmr5j8M1gQ=;
	b=BcfEd+TF3AmMKRgGaHDCQYls71+kS2vGxSCF1SAM+JnRzXnmZGnINxFSC18ealgng+xYDQ
	YPYFh8sPkHm8HiHcBDGqJMk+6QaiTWIBwJVxtQZLR4N7N10TleQnIFj2SJRdtJ8nJ6cW26
	CAHYntL3xT6jJ6DEEoh1FhjkfHo8to0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-ccWgqQwzMl2zJ26PclLY6g-1; Mon,
 07 Jul 2025 15:32:03 -0400
X-MC-Unique: ccWgqQwzMl2zJ26PclLY6g-1
X-Mimecast-MFC-AGG-ID: ccWgqQwzMl2zJ26PclLY6g_1751916722
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 879B718089B4;
	Mon,  7 Jul 2025 19:32:01 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1790B180045B;
	Mon,  7 Jul 2025 19:31:57 +0000 (UTC)
Date: Mon, 7 Jul 2025 20:31:55 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Zhao Liu <zhao1.liu@intel.com>, qemu-devel@nongnu.org,
	pbonzini@redhat.com, qemu-stable@nongnu.org,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGwgq2cz_xcYCf4o@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com>
 <e19644ed-3e32-42f7-8d46-70f744ffe33b@intel.com>
 <aGQ-EGmkVkHOZcnn@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGQ-EGmkVkHOZcnn@char.us.oracle.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Jul 01, 2025 at 03:59:12PM -0400, Konrad Rzeszutek Wilk wrote:
> ..snip..
> > OK, back to the original question "what should the code do?"
> > 
> > My answer is, it can behave with any of below option:
> > 
> > - Be vendor agnostic and stick to x86 architecture. If CPUID enumerates a
> > feature, then the feature is available architecturally.
> 
> Exactly. That is what we believe Windows does.
> 
> 
> By this logic KVM is at fault for exposing this irregardless of the
> platform (when using -cpu host). And Sean (the KVM maintainer) agrees it is
> a bug. But he does not want it in the kernel due to guest ABI and hence
> the ask is to put this in QEMU.

If QEMU unconditionally disables this on AMD, and a future AMD CPU
does implement it, then QEMU is now broken because it won't be fully
exposing valid features impl by the host CPU and supported by KVM.

IOW, if we're going to have QEMU workaround the KVM mistake, then
the code change needs to be more refined.

QEMU needs to first check whether the host CPU implements
ARCH_CAPABILITIES and conditionally disable it in the guest CPU
based on that host CPU check. Of course that would re-expose the
Windows guest bug, but that ceases to be KVM/QEMU's problem at
that point, as we'd be following a genuine physical CPU impl.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


