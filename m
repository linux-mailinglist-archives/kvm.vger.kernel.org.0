Return-Path: <kvm+bounces-18220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A13548D20D8
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37D15B21C21
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C59D17166D;
	Tue, 28 May 2024 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ab4xEWnz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B00A17166A
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716911628; cv=none; b=HTxHP4/1azkA69+tqRmQIUrec6nYS3Jb4f80fgP+xgIyU3wfTf52DFOnRX9loLytqRugrYw5L4F/PlAeFcqy6r6yHN9AePyF17OWYifk237rkwrvY86zo5Befq1HxTplzotQGu6j28MCu1kiXjJI+i8jX798fd9JOwiRp74ItfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716911628; c=relaxed/simple;
	bh=y7YuDtQgxRfSbBa7toShtRIm2E6Bv+dnsZdEb3xdJ0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TUlfKaGFLwio6bXwDWG0TuJrenIBYvubgLagBg1Es9kAM3OuvSyaz5Lxle9XZ9YjmRNgLgmAsYNlQOEeIssb1nBXdzEkAmcLIMCVctRWNfSGKHXwVkDve7B8+IEZrwlotCrL7KM/as/bVd1tjNKnr1duTc0rtK6IUrmUSS8vcF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ab4xEWnz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716911626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qccAi5B1VCjUOrYtnT1efzRA281Zhfs1D8aQKp+YfOw=;
	b=Ab4xEWnzuHdMGF64WwHO7S26eadoRLpsSGrqEIanTipK7gBkseafTbN0l2W2qgvPLQXLCf
	HIzedg9/Z8z2PhMFM14Vw1L3xm/ioYksbQAVcH+iVBClWE2ULspNOq7DAwT33/R3faiVoZ
	m/kcWryWhaQuSmzG7mmdgkn3FhI6alQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-OMC88hGpPvC7n1kBK1a_Ew-1; Tue, 28 May 2024 11:53:44 -0400
X-MC-Unique: OMC88hGpPvC7n1kBK1a_Ew-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4211211e18cso5763755e9.3
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 08:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716911622; x=1717516422;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qccAi5B1VCjUOrYtnT1efzRA281Zhfs1D8aQKp+YfOw=;
        b=etVMRgBz/10DEe5At7JfFkiBaVkPjaKO7AU5/MAVGzM8Ncm2tfPYimJpoAB4D0wlZ2
         03xL5cxI2WTEe4Z6+FQQOxZiY/li/a53GyTg9R/KgqXZ5i8zkm0NqkDGSD3w6VdhET4W
         3wpb+FbXsAl62ex9snNCIyAYOzvqIYPiqb0lrnJRsvsLqWDVduTtFH/46rKBQfVn1Dq8
         frut7yX+4qLd609vRmySYgmB48GJdCOOCpolBb+oXwfHzExZLTr9nnMTO3T9vtBQbqkq
         wllPwXw6+Y+JRJdwgVsfgMMnPhXY3QAtZmHMt7P6pdvUNgE8Lu/zpsKE+sfCn63KhQOS
         Uo4w==
X-Forwarded-Encrypted: i=1; AJvYcCW2Lc2mS/M35HEHafbmVU3se2p5O9Nnk6jK9RniPE8SzvokmeTuzshLMurSeYZuqgrvKTN48exYVXkDi/tovgOD4ac9
X-Gm-Message-State: AOJu0YxlVN9hgi8HzzK0thNBTpwvxwW1CBiNQun3Jf7FLZoo2jYSJWn3
	51FObxL3KV4DzaoqVLwBaTL7c5p+dbGlpRwt5cg+VMYNwlZHl5SLe8xg8koSc1WFJOTPC+XFdg+
	IIemreYd9cqC2gAjfoPE2IJ1ozhwLULxRf3mXui7fwVbBkuEDPA==
X-Received: by 2002:a7b:c055:0:b0:41b:f788:8ca6 with SMTP id 5b1f17b1804b1-421089d3a7emr107474755e9.8.1716911622393;
        Tue, 28 May 2024 08:53:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD2OMInNWq6yQaRzZXCjnFU9/PXI/Wa4TGh9Ezt3bZ+WCEaHgbotbyfhcZckLkeDqOCUPskw==
X-Received: by 2002:a7b:c055:0:b0:41b:f788:8ca6 with SMTP id 5b1f17b1804b1-421089d3a7emr107474455e9.8.1716911621934;
        Tue, 28 May 2024 08:53:41 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4210896f442sm146076325e9.11.2024.05.28.08.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 08:53:41 -0700 (PDT)
Date: Tue, 28 May 2024 17:53:37 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
 <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>

On Tue, May 28, 2024 at 05:49:32PM GMT, Paolo Bonzini wrote:
>On Tue, May 28, 2024 at 5:41 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >I think it's either that or implementing virtio-vsock in userspace
>> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999979@redhat.com/,
>> >search for "To connect host<->guest").
>>
>> For in this case AF_VSOCK can't be used in the host, right?
>> So it's similar to vhost-user-vsock.
>
>Not sure if I understand but in this case QEMU knows which CIDs are
>forwarded to the host (either listen on vsock and connect to the host,
>or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
>involved.
>

I meant that the application in the host that wants to connect to the 
guest cannot use AF_VSOCK in the host, but must use the one where QEMU 
is listening (e.g. AF_INET, AF_UNIX), right?

I think one of Alex's requirements was that the application in the host 
continue to use AF_VSOCK as in their environment.

Stefano


