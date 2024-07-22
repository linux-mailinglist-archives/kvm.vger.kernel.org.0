Return-Path: <kvm+bounces-22034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A530938A64
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 09:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4911C20F48
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 07:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB884161313;
	Mon, 22 Jul 2024 07:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfxt5D3F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6B15FCE7
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 07:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721634562; cv=none; b=dtzrLrSUE9xJbaxQ6eCmiBE7/shFh8K4ZJpqTZ0ciUnGHNieri7oaKEdUyOeIY0xR42XVYPL6jGPvPFCtq8Ldeh57XHFPBG463CcvPWoftoT+aLB3BkBfb16RoYGPHVTzCgMIB/9SqcBT/Vl55oD1uLJ7zAoUgxblD/nzJ1uMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721634562; c=relaxed/simple;
	bh=NjHe65oFBbZJUV5wfMpG3y7Dk7n966elOS/nNom0IwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGmYOEp/zg6n+y6prSS/8Ga6j+ZcCEhSyhSc7TNxRqg1QDXS5K+3ZVZk05F1nHu/GbAV563yHGlemK6K0tiP01vmflrREV+uS7wqvVrQNTxRP6yjfUJ2iIpToxhO2MziKA6Dy9KuYl006Elhy76wCpbg8WS0Obm8alm+FKJOIfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vfxt5D3F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721634559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDLhW/EvsV4foDiw7atelQzE6sEnxMcaTf6f1U6EU8Q=;
	b=Vfxt5D3Fyf1b969e54eBLoU66+q/I15YAqX/MDjBkfCx99wFGgKc5eZ5cgE5qqNGdhXjGb
	Hp/yCudJmjnz63P6L0QM4Uym75ExBt7yYq6H7riHZ5b9Lj5BmD4JIBBWQ07tralGkUF798
	TbXdl5RCny2mI+aZGrwbzbC9a/ufP9I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-3XMtLyZIMM-k7h7poCCGVA-1; Mon, 22 Jul 2024 03:49:17 -0400
X-MC-Unique: 3XMtLyZIMM-k7h7poCCGVA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3685a5a765fso2325699f8f.1
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 00:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721634556; x=1722239356;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nDLhW/EvsV4foDiw7atelQzE6sEnxMcaTf6f1U6EU8Q=;
        b=CT2vNlY/71etfuOXW7cPAayk8sh8fOg10bARTLw21OPTr7WyK87NvUQuNVh4cBZFjy
         C4AUie8TkK9i0mHtysOPp7hW5w6F0ozyI1MEptX14Dwfcit6R1bfplSzBr0WUtpiPxP5
         I5loWnvMqO2I2w0gqPIECxn2UonVhqktRNvm40Jzbd6Shmz0193rNT31SGiUWL8mVRaV
         IebtukyYYthgblL9ghWgwvk0t0IjAgeDGD0ZvWwxxb9LsB+B7BsNPd7xvEgFao9p+OwE
         FKnEFIyfMUDyRYzijdWL/PInqE8j6192LDzbBiniSSLr1JkclKvOZB9HYONX8Tpb10JF
         9Kfg==
X-Forwarded-Encrypted: i=1; AJvYcCUR/7jIgojDNZeVorDaA2ys51rbu04XewxQoOKLwKLL+pNmksgm6IqULuqdWy1FSiBT67Ztg/xcS/tn+oanBiJ5wWNe
X-Gm-Message-State: AOJu0YyIgyzKvehoD59hAHwgwdG1eTE4c2TiAPRW8NDZ61eRn9gtrtvC
	d9MIhJsXDNOWuAeO1Ybp1qIVf+827vM61soKSH5kKHC+J2dNn+w/uHHr+mJt7GYN8WC7d+0nUcv
	ljHFS9rM6ntPqnxlGl4RubIEKZ9Pss0CuJxByNEnByESbi+ZJ6A==
X-Received: by 2002:a5d:6592:0:b0:368:334d:aad4 with SMTP id ffacd0b85a97d-369bbbb3200mr3493403f8f.4.1721634556288;
        Mon, 22 Jul 2024 00:49:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQpkb+l1/5zh9gSQJ8TazoT1/1nNlG0GIr0WTsIP23uDq0RjdA30Tjl5jp4P4w6UNcmOh2ww==
X-Received: by 2002:a5d:6592:0:b0:368:334d:aad4 with SMTP id ffacd0b85a97d-369bbbb3200mr3493366f8f.4.1721634555570;
        Mon, 22 Jul 2024 00:49:15 -0700 (PDT)
Received: from redhat.com (mob-5-90-115-88.net.vodafone.it. [5.90.115.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368787ced56sm7758092f8f.80.2024.07.22.00.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 00:49:14 -0700 (PDT)
Date: Mon, 22 Jul 2024 03:49:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 0/8] Introduce SMP Cache Topology
Message-ID: <20240722034820-mutt-send-email-mst@kernel.org>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <Zp4LUSXlwXqI880x@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zp4LUSXlwXqI880x@intel.com>

On Mon, Jul 22, 2024 at 03:33:37PM +0800, Zhao Liu wrote:
> Hi Daniel and Markus,
> 
> A gentle ping. Would you kindly have a look at this version of the API
> design? If it could meet your satisfaction, I’ll continue iterating.
> 
> Thanks,
> Zhao


I'm not really a QMP guy, you want Markus.

-- 
MST


