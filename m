Return-Path: <kvm+bounces-43220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2505FA87D4D
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 12:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCAC93B6F30
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 10:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7957F2676D2;
	Mon, 14 Apr 2025 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OtevI2R7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BCD2620FA
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 10:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744625779; cv=none; b=nevhn12M0LjVVwC+ZhvJeFqA5fYtuFU0MXp4G5VMZlzJmT+qXCMTvSXRjqkBuL1u+TLvUx6kXRHS7FxrRTBZfSEXvb9I1kBCLu4cJ1/wVVAC2arJY8Rsx1S+sKQxdTpiY68yMlGY92gF+GD83cmfjUvzgzAlg7/iqi9DWhJuoZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744625779; c=relaxed/simple;
	bh=xSIJ0vFFb2+XHasdF5PAsBtux4dzXFv+jYFSL30pvgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gCYrP3a1K+lHn5lEvXsbv8WnFrdAwTdE8vonSSoycsDhna0fa+mj5JlycCgjtkjCp8eA4G8r896j5Zxm9yZVdOSrzgKXRdZeIk4md2bq0yYlM0loeNix3/TiLvWXIpmWS7UStDsDAfmx/0+OKFyOgKETHBkmvQ+frnON3bAX/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OtevI2R7; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4774611d40bso561401cf.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 03:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744625777; x=1745230577; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m1CFhU+Us34qKNcUetLtx8bVGJXglYvmORKZst7qknM=;
        b=OtevI2R7itWmdlsrUxGnakazuHZw5UzMq+22CMPxh1eoI5dUrcx3gSZA4j34QGjRIe
         IsNsg1LUcPHopKs96MfNqJ8EuLBDZijLjrmRNNibmsJ88XWkhN9USmRb1l9TBChlvxqp
         35zQxh947RlNHJp/SS3b2KzWKYslpuD8kC2AW3AzeXF2bCseu0hU9zlho3pEMEnOuy17
         xtZJxvSPCAzQV3wtjhaUlQjmyJm6bZXTprRyMzgUfGmw1b6jdKpAzXN3Vc2UgFF4XgcR
         8Qfqtt6ZW362T/PAyBtKeQM81jqptwcrdZST/RRORess3bdGRsN0ANqnxj8VpjvYyFey
         UzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744625777; x=1745230577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m1CFhU+Us34qKNcUetLtx8bVGJXglYvmORKZst7qknM=;
        b=B0NwPg/1CmUUkD05MrehJdaZJ02QB48KkVEbWh2EPW8ccEY6jUZwdyoqjVyrOl90C+
         BDxdW/3VcVCls/C/7XAUi8GkpQXafoE2ch4V4S8fy8gfdIjmrEuune+XFdkRZ9lin+7v
         5fges+n3lrHrodtar+K6+n4+mVzTl9vH+Vymg/q2v9EoxaxUJYzkv7PRyDN5KaDkZq3u
         5rMD5lyxAz/wjLfWbF75j+A8WgSWQquQWfLL+4VDV/rMdiP5ITzYh9EoZfLXXMQBTQpW
         FQFT+KF4peqRUKidbfTzOlSMUbUzRaCtznpb4FQuqecj7XVSxVslzcGOGWhWdC8MWtDH
         mKbg==
X-Gm-Message-State: AOJu0YxiWLPUvOFHYAQ/4jZyI6a5QrVjQx9X1dScDCuEGcaNYbt/oEmH
	deMftWR1XzOTrDOHI57/XeWnRX8jdNUTJ2Aw4TZ+F5KEcdXl2HFOha+RUJGBbr0d3dCqo3OUwMS
	YfxzpHWvWhVZwdMPuBqea3qJ5pPuWq+Ri+vZs
X-Gm-Gg: ASbGnct58TYk4yUISPXxFBCRfyLUaRKzrxw8yV2180pWQxasbBwZNKuUOqBdD0u9QgQ
	FMvYtSDHvE13/JXAs280sml/S/R4ifTvOXq0MSW00UHX3WI5JZVpwL+nKrXXstUHtt54YRzEQZh
	d9PWYborYpOPO+M4O+UYErVA==
X-Google-Smtp-Source: AGHT+IE7N7CQyu6cJnoqxB5sCy6LSjPZ11zuPXGLhynUeIQf8hFCrB+6p/8yJNraIeugxZleuOsQPHl+eTNzV+QZxtk=
X-Received: by 2002:a05:622a:181f:b0:477:871c:5e80 with SMTP id
 d75a77b69052e-479824864a1mr6442931cf.5.1744625776707; Mon, 14 Apr 2025
 03:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-4-tabba@google.com>
 <e3c26b84-5388-43f8-87ed-bee034f327b8@redhat.com>
In-Reply-To: <e3c26b84-5388-43f8-87ed-bee034f327b8@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Apr 2025 11:15:40 +0100
X-Gm-Features: ATxdqUFTBJlpnwSmrV77Tym0H8Hp9RCIeXMAAODOU2G7ZtkMx-Y5jKinNbiiJow
Message-ID: <CA+EHjTzpboCX7xseY5R1r0GHnea=mkMPi7h=vQp6ZCs7aKaXWQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Apr 2025 at 11:06, David Hildenbrand <david@redhat.com> wrote:
>
>
> > +     /*
> > +      * Shared folios would not be marked as "guestmem" so far, and we only
> > +      * expect shared folios at this point.
> > +      */
> > +     if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
>
> With that dropped for now
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

