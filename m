Return-Path: <kvm+bounces-35641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15765A1388D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D9E57A1D25
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06891DE2C1;
	Thu, 16 Jan 2025 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDqBXAx5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18431DD525
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 11:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737025638; cv=none; b=d+kdsuGTq7mHzlDUUIClmBeLdjBxgjQfxzTvB5u8xN9pmaP8L0MAPS6fE+jcyTg9n534cjtVuMxJIhKrxoaK4OY1VtCbsTjOfw14BOroCshWbXHnRU834Bt87IjN0qDniz3YruX2AxDAehXu+uUfCuv71W/Wlstk3rgJEAicJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737025638; c=relaxed/simple;
	bh=KfypC5NUxN3/6N89gvaWdVpfTcIzJon+x3xnL9ESWRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwQw/VAPjpu8H+DXTrjbXK5VR5pqszZgj3XA8/aRfh1+V4VSQXonrEDFKED8efjREh0Uha2tVNc74u6OwYSrt7B1Imjp+Fl2WAttf3OFZ1w5M/tSeJhU3cuSc0hTcGjWB98zaCZoAv9hAgMDKXnc4wS0yAR+s9F36zFtKSYlc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eDqBXAx5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737025635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KfypC5NUxN3/6N89gvaWdVpfTcIzJon+x3xnL9ESWRA=;
	b=eDqBXAx5vi9PqB6f4iPGg4wpiUb4ygYuyXddygE54bMlSfiDfEyd1b+UUi94NbWF/XO/N5
	JAbG8RWYxmerQLMDIXeQe2LPjl/sjnQNxDOXqQz45nfXf1W2RHkK9fTMhColvNbJBpZmzR
	8ASCY/CT9qwxnHD/CCge0jqxE3dP35E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-l4Q9xA0mP8-BBt5N6GwE-w-1; Thu, 16 Jan 2025 06:07:14 -0500
X-MC-Unique: l4Q9xA0mP8-BBt5N6GwE-w-1
X-Mimecast-MFC-AGG-ID: l4Q9xA0mP8-BBt5N6GwE-w
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43621907030so5756415e9.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 03:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737025633; x=1737630433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KfypC5NUxN3/6N89gvaWdVpfTcIzJon+x3xnL9ESWRA=;
        b=lwFdIT8rGUl7OQJuY/m2o0fWW9ey8/Hm29mLegWoIJnLIT95jKku7ZOgLZrWyOvEdb
         453h6WNo+maCwMULvn+u9vCI1R6r1QML9EviYDrfd+nHOXaxBXtU6YHe81I7aO1SCz80
         lUPXMhGy5m3e7sx0odJFWWM3vIF+R0ACLn9UbFPJ/YYchy6YwIqOLL3Wv5DyNFShMxlz
         ++6JS6DAvbZgISHuZIaal2zlBA1bGuhfNL7qcV1x2hjq4YQd9APlSpRKtLpvFfeOFFaO
         Lr/oql5xrB53481K6xvPAozv4FAGUj1ZT+5NqNzMUEf+qRX5jJgBtoBNqIHuRbJikj7t
         4j+A==
X-Forwarded-Encrypted: i=1; AJvYcCV9M4ZXGK+rtWIT0sBknHelc2lFKszXPj9WV+ZHYTBgmd0NH3JJf4R916sgz3k5roUPPWU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1tsx3duBRsE6H535QzKB5TxsMTL25hNq2qL37veu8Nno7G15C
	38uDJ49FkfjFM0ADaQm2lOiMEHHBMfksfUOun77jB2+nbvhuW+eK5ozMkp0CCfSY7TPliXTgSCw
	lJ93DR7Jiki9rd15z88sfSm4IJQ4qv2tvjuTXXH1Y/8gQB3uzXuFHBpWNwudiuQyZLkBFXyRRk5
	K24IPOOClrEvdY07lI0sKxkyRn
X-Gm-Gg: ASbGnctIpxlAHrHKRZoenW7Eqy8Zl7AiZ0ZS91957hSd3Lx9yd+WzfJVgX6YgjDXIR+
	5uv9yZZLZC8XZk6WQbwiNWKyrgqTvX9giNcTQUtI=
X-Received: by 2002:a05:600c:198c:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-436e26f2a30mr262722425e9.28.1737025633131;
        Thu, 16 Jan 2025 03:07:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2fY6D04/alyYZqVSn9POmpQ5o0TqjSIqlGJw6B8Q/yYAjEUC3pvtN8VWdDBUYL2IyZpdLT7lyfwidJFbqWos=
X-Received: by 2002:a05:600c:198c:b0:430:57e8:3c7e with SMTP id
 5b1f17b1804b1-436e26f2a30mr262722105e9.28.1737025632862; Thu, 16 Jan 2025
 03:07:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250113020925.18789-1-yan.y.zhao@intel.com> <cd099216-5fc7-4a79-8d35-b87c356e122b@redhat.com>
 <Z4hYOviOCaOcpxsw@yzhao56-desk.sh.intel.com>
In-Reply-To: <Z4hYOviOCaOcpxsw@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 16 Jan 2025 12:07:00 +0100
X-Gm-Features: AbW1kvaZoZ19ord-di_YT2GIo3oH_SCT93mkfY4CYRi-rVLLY8geJgyCAvg9lv8
Message-ID: <CABgObfYpyUT=HubreEO1=HzSdsCwnJs6QTj6weibJ4wqYZ_W3g@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 1:53=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
> For the first, hmm, a bad thing is that though
> tdh_mem_sept_add()/tdh_mem_page_aug()/tdh_mem_sept_add() all need to hand=
le
> TDX_OPERAND_BUSY, the one for tdh_mem_page_aug() has already been squashe=
d
> into the MMU part 2.
>
> If you like, maybe I can extract the one for tdh_mem_page_aug() and merge=
 it
> with 1+5.

That works for me, but if it's easier for you to merge the fixups in
the respective base patches that's okay too.

Paolo


