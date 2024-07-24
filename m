Return-Path: <kvm+bounces-22186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE7893B637
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AE86282EE9
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C408D16848C;
	Wed, 24 Jul 2024 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKWzpB/4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B5415958A
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843709; cv=none; b=AS49XGWeGdyBM5bi0ZzkRWxPn8EHdXS64kq0tVpy5q8ehCkuHvG91Mpu9+z0XM5RMXukNfV04yTHn/wQyHh3D43vz3u7p6fZajwToRNhzIEv+NbSdRWNFwb9uIx8FPDITK33h3CXLkrU/RuRjUZ3ctzxwMQqrnq8iLSv5Zrgrow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843709; c=relaxed/simple;
	bh=pAggti4CxDh8aaKGOiWwcGNCnca4OscjeY43dDFw0qY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RF7YrLZMXt62C7TdNI5nh9EO7T+BfZXLZRo2KGcEyFgCubgx4UlVmmacP3a/QYjXcFQex15305NCnpduvhqGNAYMtavcgxDmEeYXKj9P4flg++SWYPvFyTrIwgW8Xu34CLA+ExFIPPi+t/3TBLNzYgKGLKFpsSKQfNvRDUx7Ht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKWzpB/4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721843706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCSjvQojnSBcvZOuO5x0oYLCUoJsIiQ0BK/dbIXil2Y=;
	b=CKWzpB/45r7iCrUdKZR8gBS0SGr8nOafTdEi2YP84czOSWq/7sOPvclIiYhrFImZdtYuOC
	4pnv/qOI1e60GW0ylbk1HwACVwpWl6QYiRWZ3keUx6xAbpPok1OO6D3bqRp9yYNmLiSvtm
	mDYh/euDgvSOOhnlfli7P+M2oAszz0A=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-VHtrT3E5ODCxCE71vO8BHw-1; Wed, 24 Jul 2024 13:55:04 -0400
X-MC-Unique: VHtrT3E5ODCxCE71vO8BHw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44fdd39f503so419131cf.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843704; x=1722448504;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCSjvQojnSBcvZOuO5x0oYLCUoJsIiQ0BK/dbIXil2Y=;
        b=WHJhkakwo+SDwXaZ/tiEwal/Rd9zM7kGw1CvEe+3IxpdgInx0265r+c/a9/lWrUlcf
         wWnPaKKNhTS3sww0IZMpALc0etIK8V5sVeekAjfXFKf3omXJb8bXUQfatrt3DtpsdzKU
         IogA5/OsiLpiA452MovFnl99kqtL13QeYsKRUEZjaqBF7kiFd+RzBA2saNcK47HK4fWO
         cvxWJ/56TKKP4S84Agy8409/q99EFhWgv/k8O698uCwfmnp4qfsW4wp2LqBzO8e+7QLN
         +OBMJT0B/aMcvjX0liU8+nPkjIaU5PyY2BE+ntZ8ZsKwTPw8Q9J9P3WsQ73VRS1P3kQa
         haBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWymFUAvEh/Nsv04BHgat+ncanUU1LdctFnaD5XIgsQAAtw9u0/e4yqLbtAmpFfaeRHx0n5X9HdUG4jaJsNjn2SC9LH
X-Gm-Message-State: AOJu0YwKkerk2MAOfx4UspP51rT6eq/c7Tge3NZPAMXwqU7Kho2ku4jY
	WzCxZI7+mSA6X0oy6sF2ig49xVoJXhePjTcQ0BPAuBIpgBW2vz1RF9D4UxF0r7yTTpls9Q0gfsH
	ZeDe/u+3TLc9YIZlam0DFXxvlVTFk2egreDqAKVR09ZB67HkXY0PnuyxEsQ==
X-Received: by 2002:ac8:7d54:0:b0:44f:e591:a676 with SMTP id d75a77b69052e-44fe591a9d9mr517411cf.23.1721843703930;
        Wed, 24 Jul 2024 10:55:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGchekRilGVZO6s0wOLP4Iqdh0ZaYupUIyDfjrBA2nOsm/NoGM+WLs8pdDpP8/i2GrA3JpCRQ==
X-Received: by 2002:ac8:7d54:0:b0:44f:e591:a676 with SMTP id d75a77b69052e-44fe591a9d9mr517071cf.23.1721843703569;
        Wed, 24 Jul 2024 10:55:03 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f9cdc18f4sm55661491cf.86.2024.07.24.10.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:55:03 -0700 (PDT)
Message-ID: <669b2a0fb4f028f3903bd4468f819f3e7f9758cb.camel@redhat.com>
Subject: Re: [PATCH v2 25/49] KVM: x86: Harden CPU capabilities processing
 against out-of-scope features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:55:02 -0400
In-Reply-To: <Zo19SWre5eJm8XTu@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-26-seanjc@google.com>
	 <7c072dac426f77953158b0c804d81c664c00d1e3.camel@redhat.com>
	 <Zo19SWre5eJm8XTu@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 11:11 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > +/*
> > > + * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
> > > + * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
> > > + */
> > > +#define kvm_cpu_cap_init(leaf, mask)					\
> > > +do {									\
> > > +	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> > > +	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> > 
> > Why not to #define the kvm_cpu_cap_init_in_progress as well instead of a variable?
> 
> Macros can't #define new macros.  A macro could be used, but it would require the
> caller to #define and #undef the macro, e.g.

Oh, I somehow forgot about this, of course this is how C processor works.


> 	#define kvm_cpu_cap_init_in_progress CPUID_1_ECX
> 	kvm_cpu_cap_init(CPUID_1_ECX, ...)
> 	#undef kvm_cpu_cap_init_in_progress
> 
Yes, this is much uglier.

> but, stating the obvious, that's ugly and is less robust than automatically
> "defining" the in-progress leaf in kvm_cpu_cap_init().
> 

Best regards,
	Maxim Levitsky



