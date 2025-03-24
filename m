Return-Path: <kvm+bounces-41804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A543A6DB68
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 14:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE30B7A841A
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 13:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA0025FA34;
	Mon, 24 Mar 2025 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EK7XM5t0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2DB25F780
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742822740; cv=none; b=pS85SvRMV+UbsuuVc4G91rtrSYY4Tb/Nu3/61Yh0xmcjsuf21ERrlZoTTHhi4SWMIVTC7wOw+mr6bh6sQF7rGEPF4Oj1Dr06V2ypKPinCU4J0SAqW1Bft9dOkYL8d6XU1eT+IbUz7U/Wdp9wzHfnkmFJ4anLi79XP62bR8EJAo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742822740; c=relaxed/simple;
	bh=x5phT9lqAc7BOyV83zbl+fapvdtdpQmNFRvX0EZowz4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qKpyGJEJ6n2/fr+0YmGXnOEwy5zOOrtHEKLf6Slm8Am/g1oNsZ0tZW2nOWVa/nFpyAcvxyCUIO8xtUVgGrqFSc8N2Y8OmmB3H9N9w+whT2YnwIoR+cO66vwAqYSIcEpa53DfkjA0rqWP7f3qDr4Fn27ngr1+r3IVn4EmoehqaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EK7XM5t0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742822736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jObrxvSe5yBcHaRQZf++AQlt3qx8dxj0+4QGQZz8DHc=;
	b=EK7XM5t0lNHSiabFdP6jFyoh92btiaQ0vR1S/ZY5mAe1OpoIQ00x4LwKXN9/SgpFcTjV87
	QdkxBkhTUzIeyLq6PjsBaF7pnRD+kPWimGy41Ocuqw9nhKcBF4vP3YK4B6zYT7g45g2lq4
	RrGE6dNwobKzhirC8/hauPJcUp/PBIU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-UZg75BnxM9iR1wazwIiCiw-1; Mon, 24 Mar 2025 09:25:35 -0400
X-MC-Unique: UZg75BnxM9iR1wazwIiCiw-1
X-Mimecast-MFC-AGG-ID: UZg75BnxM9iR1wazwIiCiw_1742822735
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5750ca8b2so732291485a.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 06:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742822735; x=1743427535;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jObrxvSe5yBcHaRQZf++AQlt3qx8dxj0+4QGQZz8DHc=;
        b=E8b/HeNJ4ZtVCUsdKmbpqYcqLYFu3DEhlXNCgo9hAlOPTEbfKM0MwDj4+swe2gQ9pm
         6184lnYJahyvpzwrowATiSLuqlPoZu+/ZbCERdNvsmzOBFBWbF3x82WBUVGNTYxFEhGd
         /oaM1EnjLz3mrhRgO38EMayTwyOpax88O72qHrvsaJu2hTLyGum5VKR6jaFrxiOwu6WG
         liF/LwdO/Xst0SiuMB5/b6RbvtHqv2nTZVZtehFZ9hRnsn51LT6BOLHl0quL8z2NXxLO
         ziraYcDgz2vaK67RJ81XJ3M/trTbHLU3eDPzfLh6i7/J8rBZC5KV3jOp5d6G3IfAFN/x
         Ajag==
X-Gm-Message-State: AOJu0Yy7TBAJwTIrhHLYAAvWef+d4eC2sxrhdhtw8/oxZUUuV6LyZM9t
	fPwp8ZJO5v3LkvpLKuZ5fch39S/Cl7v5teKmfmFQKl+kxRD/Lv8Cbyw4yxxQO6q9PuIRrYzGA45
	x85MIaXDrxZv5yYIW7XWGcc0mM5fEXi5w/EjCU/oMBMgRQTseJw==
X-Gm-Gg: ASbGncsd7c6sPySh/W1pUMYSUVX6m7ekX3Sa8z0xf4TBswrs2sTJTi4kaJl3PLedr3m
	qHIf3N06bKjG2FVmjip/nBl7lbSPIMSLgB2V/br0HgxuASpeWCHIduwP3508GVvAPsnD5MOeg/0
	lzxWpTiTClsLypMpwU988lSqLerckg7JT5uAr+FOkBZY4SgQC/qQ4jq8uFIMrAdlIDYKzkv7vV6
	kufPlCrsznLwQty0bqeZeMD+4cESkXfN9RL7reiqvZvWbf98EzDmeYpOpIDFmFqJvsvYFmZagat
	LnhCcdOC0jVTJgo=
X-Received: by 2002:a05:622a:230c:b0:477:db8:9e59 with SMTP id d75a77b69052e-4771dd5457emr219875311cf.5.1742822735266;
        Mon, 24 Mar 2025 06:25:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsSewdCqoUbpspiVPT+jO4xTgrBtRVkDMo9TNuVNaw3HXkJR+Rxm7725AHnX785LRaPw9IQw==
X-Received: by 2002:a05:622a:230c:b0:477:db8:9e59 with SMTP id d75a77b69052e-4771dd5457emr219874861cf.5.1742822734796;
        Mon, 24 Mar 2025 06:25:34 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d18f7f5sm47219411cf.35.2025.03.24.06.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 06:25:34 -0700 (PDT)
Message-ID: <a2602ef3365b909da597f0734393e520bb960840.camel@redhat.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: kvm@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, James Houghton
	 <jthoughton@google.com>
Date: Mon, 24 Mar 2025 09:25:33 -0400
In-Reply-To: <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
	 <Z9ruIETbibTgPvue@google.com>
	 <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2025-03-21 at 12:49 +0100, Paolo Bonzini wrote:
> On Wed, Mar 19, 2025 at 5:17 PM Sean Christopherson <seanjc@google.com> wrote:
> > Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> > object) to making a functional and confusing code change to fudge around a lockdep
> > false positive.
> 
> In that thread I had made another suggestion, which Yan also tried,
> which was to use subclasses:
> 
> - in the sched_out path, which cannot race with the others:
>   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
> 
> - in the irq and sched_in paths, which can race with each other:
>   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));

Hi,

I also have no objections to this. As it was said in the original
discussion, that can make lockdep miss a bug, but so can the Sean's solution.

I don't think there is a way to both fix the warning and not degrade the check in some way
but since the check disables lockdep, either of these two fixes is much better
that what we have now.

So what should I do to fix this? Can I assume that one of you post a patch
to fix this, or should I post a patch with one of these solutions?
(I want to close a ticket that I have :) )

Best regards,
	Maxim Levitsky


> 
> Paolo
> 



