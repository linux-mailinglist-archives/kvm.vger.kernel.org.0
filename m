Return-Path: <kvm+bounces-22191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF6593B660
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 877C628301F
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C8716C426;
	Wed, 24 Jul 2024 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5s3h3EG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460C15FA6B
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844035; cv=none; b=SehuKAZhzeeDPmD9eALbuNyXfVSQ7MBkfvQbIkRbHiucC3bpuDdhMUItgEvyI1XSUoXvjUmG2QuIingHq8jWw2EFLeg0bfEMnWqOwmABmp/Z9n25XkK3JljxPZsGFRxDmgEHFfnyCmS9X+yoesaycTClU04F6gPuzTBSyscXVGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844035; c=relaxed/simple;
	bh=q38qcAv/ONlrpumLgbJFpYQGr+xWZGzJKvEtxU/z1YU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eYZTA24/79gjYpfGo2U6LCFfuDDmzM/KvAObWRfEz/d+7JtE5+C2fHZiYpKpf0Uk9B5XVtfEzYkrMU4F7B7mmzZnIcWiAzxERwzV/kakaIGSahhdX5AJ/Upxl+bp7ep/Gt9Uu+01/6XiMfcGrXFUHXXch70iNeIJYCS6fyzwps4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5s3h3EG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O95M/67R8fNQ8xm2ee1xfFbP6THrenJP8rJCaz7LLsg=;
	b=C5s3h3EGEzWBArez29KAg9lZxCiOMJXWQ91MygXINOTAqymBrRZwSfIQ3S03RwvCgev6Y4
	FXP3orMk7GOoCjr2Cvv8/d8Eqev7x80qtJklEStkts6AV0hU9SAG1pXlO55gPVcGPvWQAH
	pwVbQUswROP/wvCmpj6z20dJq/d6rG0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-HhxWYOkdPme-h4dkFxmqVg-1; Wed, 24 Jul 2024 14:00:29 -0400
X-MC-Unique: HhxWYOkdPme-h4dkFxmqVg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79efb1181ddso596085a.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:00:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844029; x=1722448829;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O95M/67R8fNQ8xm2ee1xfFbP6THrenJP8rJCaz7LLsg=;
        b=wR1povJ1pDC8PncfsCZ4qsa95yC+FA7tNY0Sj1q4vIzJMEiCk/Krwv2QALL+xBrpPx
         WdlNAMQ28n7SO1WVj2C+lmAweKht1igTk3FXBllfewpqcBhiBsQwnX8E70tqYzFQVpcQ
         wDu3w1kfdRuzOOxb6lRvi6rk9LWyrVJ5SVyZE4343WWPIF/2QVnQx80CK2kpQ27W8AUX
         N7AZPjhDfd9RNtzyduGRh5d0ksdKD0VDyHPLju8Kfzo7HJUhn1fRytEY6eKeDaU5ilDL
         1wb7OiCcBfKcA1CmW+bqFGgtqE5Orsy0SymJHODdpk2dwUTJdOLHwUPdXpuLF3uhVZo7
         QBVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiDou6pI3/ewajxDkwtVZ+s9/04oHHzBOtg2hU5lPSp6qgH/dOKg/FziegQir4nTJZUpex8JP3z/cVJWjNqNq/mz5c
X-Gm-Message-State: AOJu0YxGexjO1qXeYlKLcdA6i+4hJ9fu2xl40ZkqQNfx1+Asz6RP1gsW
	9+OuGFOEaynZyZ9SAsRnQbr6GJ91TEFV1oTAfgJZEB4UoRPU8PIiUBo/468RKkFPkHj3EbCFYwL
	E75tC0i1Vb0EVev+iFF+Du45OW7XY/sCzoaCP9roLbGJrQiM0gA==
X-Received: by 2002:a05:6214:5017:b0:6b5:434:cc86 with SMTP id 6a1803df08f44-6bb3c9d6247mr3804936d6.10.1721844028917;
        Wed, 24 Jul 2024 11:00:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/F/PikhU9IOI1XzK4uCXYQiLmxbB3S+04oyjY4qjFMZ5iW4ULQ5IXpljNoUNliAPOhZAYMw==
X-Received: by 2002:a05:6214:5017:b0:6b5:434:cc86 with SMTP id 6a1803df08f44-6bb3c9d6247mr3804726d6.10.1721844028539;
        Wed, 24 Jul 2024 11:00:28 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac6858fesm60839726d6.0.2024.07.24.11.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:00:27 -0700 (PDT)
Message-ID: <d8ad4c17b01dd3bd3cdceba6712907ed2c7a08e6.camel@redhat.com>
Subject: Re: [PATCH v2 39/49] KVM: x86: Extract code for generating
 per-entry emulated CPUID information
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 14:00:26 -0400
In-Reply-To: <ZoyAkkZjnGmwlVCS@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-40-seanjc@google.com>
	 <960ef7f670c264824fe43b87b8177a84640b8b5d.camel@redhat.com>
	 <ZoyAkkZjnGmwlVCS@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 17:13 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > PS: I spoke with Paolo about the meaning of KVM_GET_EMULATED_CPUID, because
> > it is not clear from the documentation what it does, or what it supposed to
> > do because qemu doesn't use this IOCTL.
> > 
> > So this ioctl is meant to return a static list of CPU features which *can* be
> > emulated by KVM, if the cpu doesn't support them, but there is a cost to it,
> > so they should not be enabled by default.
> > 
> > This means that if you run 'qemu -cpu host', these features (like rdpid) will
> > only be enabled if supported by the host cpu, however if you explicitly ask
> > qemu for such a feature, like 'qemu -cpu host,+rdpid', qemu should not warn
> > if the feature is not supported on host cpu but can be emulated (because kvm
> > can emulate the feature, which is stated by KVM_GET_EMULATED_CPUID ioctl).
> > 
> > Qemu currently doesn't support this but the support can be added.
> > 
> > So I think that the two ioctls should be redefined as such:
> > 
> > KVM_GET_SUPPORTED_CPUID - returns all CPU features that are supported by KVM,
> > supported by host hardware, or that KVM can efficiently emulate.
> > 
> > 
> > KVM_GET_EMULATED_CPUID - returns all CPU features that KVM *can* emulate if
> > the host cpu lacks support, but emulation is not efficient and thus these
> > features should be used with care when not supported by the host (e.g only
> > when the user explicitly asks for them).
> 
> Yep, that aligns with how I view the ioctls (I haven't read the documentaion,
> mainly because I have a terrible habit of never reading docs).
> 
> > I can post a patch to fix this or you can add something like that to your
> > patch series if you prefer.
> 
> Go ahead and post a patch, assuming it's just a documentation update.
> 
OK, will do.

Best regards,
	Maxim Levitsky


