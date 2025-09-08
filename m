Return-Path: <kvm+bounces-56972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F721B48C67
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FEB23A74F0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 11:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C092EFD9E;
	Mon,  8 Sep 2025 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWO/sbEj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4521D5150
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757331757; cv=none; b=JGT//rR6xqTKs8EG8RHVEXs//mE7yqp9yhXdnUt4HW6+cFq6EF/c+QTHv5SQLMfqQhALArui2e7V528wgzGmwlCQOhCpg9EGeVyBvPQcpiNQG2B2B62abjJci8jtLpDHfZr747qqlh3wCUMEYRMKoZ46LUZdZF+CKPg6/OD62kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757331757; c=relaxed/simple;
	bh=HhSJYCCfbK3ztTJo75ERHVNJWoBVLjkd+Z+wB75j1Ns=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WEiWdwBeF5t0ihlILH9u6QFmn2Yfk4lzAO3YP0kaT2AhxBgn5NMq/9LuD2jOiDIKtz60/t+pVHFJUZwJ/KRUZL3wz3wNhjXTbf7sbusxxE0qFU13OixXLM5cKBMeLAvZklftJ5v+vbF20RJvC+nY4omu7f0eiuoN9juWlLYsPOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWO/sbEj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757331754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ui+E3yAQjYMbX0VewGqiiUymsURsQ5gb2Eg1Kh6Fyxc=;
	b=cWO/sbEjmBNbx9pV5BgP+Jt6aCYwJQukepSX4X9RO/4/lvh/HUIHXeYscLBKKfm4pdreCk
	/n3a8y2Q0EgFmXtfsz3tO6YfDyk9joDtWXWLogaT3B1ccd7C8GiPZWmAzmVU1LJbzBY2M6
	StE9+7bpAQasnB1X/qu5owQxYKJvzG0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-lOSp1RapNW6JCfx2Y6beZA-1; Mon, 08 Sep 2025 07:42:32 -0400
X-MC-Unique: lOSp1RapNW6JCfx2Y6beZA-1
X-Mimecast-MFC-AGG-ID: lOSp1RapNW6JCfx2Y6beZA_1757331752
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3db89e4f443so2643135f8f.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 04:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757331752; x=1757936552;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ui+E3yAQjYMbX0VewGqiiUymsURsQ5gb2Eg1Kh6Fyxc=;
        b=Pr7H5NV6PAGrJBvWzwJu+TG9Qo996WncqSXgJLDDONqVsPnSAdcM2fh6io1krReCa8
         lHxrNU7pR4bTtUh+PKUbDnd2oaApRNKxj6nYWjx7UErGPlgDzF/hTXmHrPmUq2DU/456
         nCOWZphMS9aOKJupUH68oEbao89QzKqkAdBC1bLXfUyqcuiz6yahYV8PIB3tuBNmwsaz
         NFcfKuc3DFVYM7Vs9vISohGW0fVLu812CZFnLpLv1oBG7aDUUaRu/BNg63vNXnyRczmX
         gmrvkn0SI7edERezOwhH9ztqdxfTOiasz0/8RsSGhboWtNepz4qzQWTPjmJg+L4VWqd0
         zhpg==
X-Forwarded-Encrypted: i=1; AJvYcCVLwRPgmlrcj+CiC7CeJnZEUSGjlzZPsRjudMvRP4+WOEIbNSpMNfnu9OYLO12Naz4v5eU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd/J/jEbg0sYCkv80vUWvkW5dd4Hlv5GNTAo1l/UwxY02UxUvM
	jTuR1gZLno3GX7aidqd0sC4AC0rPXBKV3he2Mg3lPt9qxId4W5S6gibOCXMuIm432EEvMz6Ll9v
	6IUUgjh0P1VaqGLvWzUkbdkbBk3W82VL2X/pd1mCgs084zvRGrr79fQ==
X-Gm-Gg: ASbGncvq0EkN+zFAchJS2adgmihDhCD6l6nmo3xXOwMy8c/ZF1LAYwAcAttEXqgM3j6
	Cn7fUcjhno5f4kZuLOjvWlRToZMgzb4stfJDKmjzZ7/5glY2pzOq6iygFS7lAfml+6qaizAWuyp
	ezmFyEJlHZh4wV820P/cBgueMBHlnieNGLN5dnuvDDaJ6kMKIRaqJNgfG/mZBFYZ/eLI5TD4s08
	If51ckJIxzF2WxZN49lLMTbtg63jaUyps1WYymAa8KmSpt5XXZPoDhGGGF/lo5ATXiB2EA9I6F3
	y11gh6lbIPZ8PFecqYvAhZSo2sOcCYu0rtA=
X-Received: by 2002:a05:6000:2306:b0:3e7:441e:ca1a with SMTP id ffacd0b85a97d-3e7441ecd94mr3850944f8f.34.1757331751643;
        Mon, 08 Sep 2025 04:42:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFNduNNMS2QypUGoHefwq2OBmU/qLWwtZfbpj/N0PFIGWheTE/CPUM6x/z4wzHmYCkGM6cZg==
X-Received: by 2002:a05:6000:2306:b0:3e7:441e:ca1a with SMTP id ffacd0b85a97d-3e7441ecd94mr3850915f8f.34.1757331751243;
        Mon, 08 Sep 2025 04:42:31 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e705508e22sm8404675f8f.49.2025.09.08.04.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 04:42:30 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shaju
 Abraham <shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
In-Reply-To: <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
 <87a535fh5g.fsf@redhat.com>
 <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
Date: Mon, 08 Sep 2025 14:42:29 +0300
Message-ID: <87wm69dvbu.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Khushit Shah <khushit.shah@nutanix.com> writes:

> Thanks you for the comments Vitaly!
>
>> On 8 Sep 2025, at 2:35 PM, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> Is there a specific reason to not enable any Hyper-V enlightenments for
>> your guest? For nested cases, features like Enightended VMCS
>> ('hv-evmcs'), 'hv-vapic', 'hv-apicv', ... can change Windows's behavior
>> a lot. I'd even suggest you start with 'hv-passthrough' to see if the
>> slowness goes away and if yes, then try to find the required set of
>> options you can use in your setup.
>
>
> Actually in production we use an extensive set of cpu features exposed to the guest, still the issue persists, 
> With the following hv-* options also the issue is present:
>        hypervisor=on,hv-time=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x2000,hv-vpindex=on,hv-runtime=on,hv-synic=on, 
>        hv-stimer=on,hv-tlbflush=on,hv-ipi=on,hv-evmcs=on
>

Try adding 'hv-apicv' (AKA 'hv-avic') to the list too (not to be
confused with 'hv-vapic').

>> 
>> On 8 Sep 2025, at 2:35 PM, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> Single CPU Windows guests are always very slow, doubly so when running nested.
>
> The bug was reproducible even with more cpus like (4,8), we use 1 to reduce noise in captured logs.
>
> I should also mention by slow boot we mean extremely slow (>3h).

Oh, this is next level) Do you know if the issue reproduces with newer
Windows, e.g. 2025?

Also, I've just recalled I fixed (well, 'workarounded') an issue similar
to yours a while ago in QEMU:

commit 958a01dab8e02fc49f4fd619fad8c82a1108afdb
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue Apr 2 10:02:15 2019 +0200

    ioapic: allow buggy guests mishandling level-triggered interrupts to make progress

maybe something has changed and it doesn't work anymore?

-- 
Vitaly


