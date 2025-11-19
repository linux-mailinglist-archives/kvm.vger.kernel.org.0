Return-Path: <kvm+bounces-63741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DD4C7095F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B9EAE4E6182
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 18:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F8A3126B1;
	Wed, 19 Nov 2025 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeNa9Fsh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C13101CE
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763575494; cv=none; b=IFceSQUARknRlXIXlOe+lFYiQTD56I76Y4NfbHaeIN4JFGLsRoGvinmFJso8nOQ09mB9/aFXBUjhhNmOhLbzeYpVnNfHOtWj05LbwOTihIuYoYwdrrp/IyyyuyngkdtUY0DtdNgNIrg/vPHBEU9E+ht/FU6YLIhAADd/CkXgQP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763575494; c=relaxed/simple;
	bh=p++dL9aqK6+Oixw6io0gok46vj+nss39/lBb2QPDZZM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DJjcuyaU4RlMnZoY2ZBsqdoD8E3+FIV86ZAIIMq+GrDDCAweC9H1/dF3nwZEZ7R/vmr1pSEvOEApKV/Bz+jEMSmIFBQVHboruZcMGvhbPScI9D1R/cgzm3RVxA+EfzyHTsLJPObr9E9P7MMg86LTAmRRMJwC5+5vkKzigL4Bddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aeNa9Fsh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763575487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR2XmDKXscrOb2moacExky8fG2D5P/G8oQXBtIz0jGk=;
	b=aeNa9Fsh5x6ZC1fhm+OVNVi24Gp0Gx4GBAELG4r8rwf6zPAIC19KqCmdnfSa5JrarW42W1
	Paq+KD3E/pkRZD2XAtXbVXnZ8BMtJ0Wiol0dk4e6/SZEKr2Z4pRYgC+6ftEp6iTGgj01ER
	9aYqPjiJuW91lc8aIbJSGsAHpUz8VeE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-eBrk9HEGPpGehBs0P-G-uA-1; Wed,
 19 Nov 2025 13:04:43 -0500
X-MC-Unique: eBrk9HEGPpGehBs0P-G-uA-1
X-Mimecast-MFC-AGG-ID: eBrk9HEGPpGehBs0P-G-uA_1763575482
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47CE318AB400;
	Wed, 19 Nov 2025 18:04:42 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.45.224.162])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 597C6180094C;
	Wed, 19 Nov 2025 18:04:39 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  "Chang S . Bae" <chang.seok.bae@intel.com>,  Zide
 Chen <zide.chen@intel.com>,  Xudong Hao <xudong.hao@intel.com>,  Peter
 Fang <peter.fang@intel.com>
Subject: Re: [PATCH 4/5] i386/cpu: Support APX CPUIDs
In-Reply-To: <aR1zIb4GHh9FrK31@intel.com> (Zhao Liu's message of "Wed, 19 Nov
	2025 15:34:57 +0800")
References: <20251118065817.835017-1-zhao1.liu@intel.com>
	<20251118065817.835017-5-zhao1.liu@intel.com>
	<CABgObfZfGrx3TvT7iR=JGDvMcLzkEDndj7jb5ZVV3G3rK54Feg@mail.gmail.com>
	<aR1zIb4GHh9FrK31@intel.com>
Date: Wed, 19 Nov 2025 19:04:36 +0100
Message-ID: <lhuh5upzyob.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

* Zhao Liu:

>> Please just make the new leaf have constant values based on just
>> APX_F. We'll add the optional NCI/NDD/NF support if needed, i.e.
>> never. :)
>
> Maybe not never?
>
>> > Note, APX_NCI_NDD_NF is documented as always enabled for Intel
>> > processors since APX spec (revision v7.0). Now any Intel processor
>> > that enumerates support for APX_F (CPUID.(EAX=3D0x7, ECX=3D1).EDX[21])
>> > will also enumerate support for APX_NCI_NDD_NF.
>
> This sentence (from APX spec rev.7) emphasizes the =E2=80=9CIntel=E2=80=
=9D vendor,
> and its primary goal was to address and explain compatibility concern
> for pre-enabling work based on APX spec v6. Prior to v7, APX included
> NCI_NDD_NF by default, but this feature has now been separated from
> basic APX and requires explicit checking CPUID bit.
>
> x86 ecosystem advisory group has aligned on APX so it may be possible
> for other x86 vendors to implement APX without NCI_NDD_NF and this still
> match with the APX spec.

Well yes, but I doubt that the ecosystem will produce binaries
specialized for APX *without* NDD.  It's fine to enumerate it
separately, but that doesn't have any immediate consequences.  GCC makes
it rather hard to build for APX without NDD, for example.  At least more
difficult than building for AVX-512F without AVX-512VL.

I just don't think software vendors are enthusiastic about having to
create and support not one, but two builds for APX.  If NDD is optional
in practice, it will not be possible to use it except for run-time
generated code and perhaps very targeted optimizations because that
single extra APX will just not use NDD.

I feel like there has been a misunderstanding somewhere.

(sorry for off-topic)

Thanks,
Florian


