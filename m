Return-Path: <kvm+bounces-25192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E359616A2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 409251F24BDE
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9401D2F7F;
	Tue, 27 Aug 2024 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAWbSply"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C0F1D2F55
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782599; cv=none; b=dWXomUjd27Ln4sG/nIcKTMaRDDDBZiX1OCtqKKhnZBimEnRApq2FZiLy+pXitUaFHc+6P0mzfJBrujtGM1mBmLNxAqFLpk8XQxqJo6um90GthZlW9Cy+xmDhXSDdmlmuBNX/2BXgxkpASeTiX9io4oZzlmJ8kJeT76uQZCJ1t1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782599; c=relaxed/simple;
	bh=X8QcjerdXUVJM0M6K25kjjudFG+vmIr5pWvEHt8N2WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mev1sXXpEeyQhKT37jKc1olW5AYm91tiQ/43g7+12krYQ3DMpQ9YjrfCnAvxyizm4yD22ANeZcZEEd2qqURpOxTLYfaUQWc+LRZagmlk3jw/qfbg59jFGdPMPUk4Bsuxs49vbDjO9FxwbKBumtSuKOfi1OPRvTl0Fw2xzWbm0HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HAWbSply; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724782596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHSBO7ll3rbZOfjXr1T8jodqp3tHRdp2gSRkpPRf9Tg=;
	b=HAWbSplyNrpeIEgf2zP07+t0ix/WDNJlPtOuvgEa5ulDYPiMkT1eTdxCi6eJ8Skp+mpxKa
	ZevXnnUNa5Ejd+701HRM26ylOY466mffgmBTGiXrHQHpVUoYgPnfzb0JrrNih3dw8NY/dZ
	uEUBX7qi0zOw0LdiR8BBLAFN+0/Kqf0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-WKnZzpyOPx2J8Yp1QpHCFQ-1; Tue, 27 Aug 2024 14:16:35 -0400
X-MC-Unique: WKnZzpyOPx2J8Yp1QpHCFQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a86690270dcso555058466b.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 11:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724782594; x=1725387394;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EHSBO7ll3rbZOfjXr1T8jodqp3tHRdp2gSRkpPRf9Tg=;
        b=pc89YB6a0MC5iXEr4imO1hMA1dnYHnFD8Y5EQUFXGHyHj9FO79nVtRbZVyU+gNrU35
         C35ekZN6fR3fOK8oCTTuqpyVPYPAMfPxUHnmt0VR08F72Q1vT2M/lBJ44iPGqlY3qLS3
         nzVgYuiIuUbtXz1+pa/9J2w+99YjKv630TudSPXV0hSjo2LeCK/1WvLuNhmbVmwZagad
         hyC72HSz2dSdAdNHWhuCVVI6CLoNLjdhIE+dSG9JgLTQOQ78XNjUX1WxaR2VjTG/brzW
         MByoMbk6bdjce+TZ/CkA3BruOVMoVSnLB+vUr1eYyV6yNCL5pR2cPyOqA9Ifx4+bOydt
         MLwg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ1LNkMBTWZy92FpoRRS7AT0z/ZnZFYKW4Tmkcf+RPH7uB3ac267GgsfVRi+egBginO/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSA0AnCS7hNF6o0HyGHiWraW66LYhEQOYzNv91p/J15Ga2XF7C
	d0/V0MCK/KhnLUGUm+1sP4P364tAZ3RrsrbDR8Q6jnsYdqkRBqZm2S5JVLOsFC/TRKunNysA1i/
	wSlsNAfTHvIB1mYmSsqu3AuI1Wmn0wGis4nRSKIdyfKcP0Fto9g==
X-Received: by 2002:a17:906:7315:b0:a86:99e9:ffa1 with SMTP id a640c23a62f3a-a86e3d3e9camr241758466b.64.1724782593697;
        Tue, 27 Aug 2024 11:16:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnDe3VluilgSG0vcrrqRKifn4o56qtamsjzIVVNpfdjfRpMszxTYEqVcY4D+Wi8k/eikH1ig==
X-Received: by 2002:a17:906:7315:b0:a86:99e9:ffa1 with SMTP id a640c23a62f3a-a86e3d3e9camr241756666b.64.1724782592949;
        Tue, 27 Aug 2024 11:16:32 -0700 (PDT)
Received: from redhat.com ([2.55.185.222])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e588b39asm138757166b.159.2024.08.27.11.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 11:16:32 -0700 (PDT)
Date: Tue, 27 Aug 2024 14:16:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Carlos Bilbao <cbilbao@digitalocean.com>
Cc: virtualization@lists.linux-foundation.org, jasowang@redhat.com,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] vDPA: Trying to make sense of config data
Message-ID: <20240827141529-mutt-send-email-mst@kernel.org>
References: <4f4572c8-1d8c-4ec6-96a1-fb74848475af@digitalocean.com>
 <e7ba91a7-2ba6-4532-a59a-03c2023309c6@digitalocean.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7ba91a7-2ba6-4532-a59a-03c2023309c6@digitalocean.com>

On Fri, Aug 23, 2024 at 09:51:24AM -0500, Carlos Bilbao wrote:
> Hello again, 
> 
> Answering my own question:
> 
> https://elixir.bootlin.com/linux/v6.10.2/source/include/uapi/linux/virtio_net.h#L92
> 
> Thanks, Carlos

Right. kernel.org would be the official source for that header.
Or if you want it in english, that would be the virtio spec.

-- 
MST


