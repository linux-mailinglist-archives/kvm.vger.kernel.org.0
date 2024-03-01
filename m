Return-Path: <kvm+bounces-10674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2BF86E898
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32E4F28D137
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6797D39FD5;
	Fri,  1 Mar 2024 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcCepP+9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B731224D0;
	Fri,  1 Mar 2024 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709318449; cv=none; b=MUgmfJ83cBwlOr1gZPRsjDdlFEpBtZWzH9fiHJjxVpQqJI0/smv7MhNQdY5B3mSnWwC44PkNV8nDr3wlS2PlUPK50f+rq6bKvSZgqbgyCbhLNYEoAnNN5mcA3eepkbj1E542rJiqspyS1lCEHibafxGgxb8I+aR3a0WGImLd8dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709318449; c=relaxed/simple;
	bh=GhGyYeMcg+ZkjHYxc/VcT9ZUA/XQeHgcdI1Kai7omcM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=gGW+3e+VQo/OPH7XMDcDjgVlTk6KhKVh3PqhXocY5ftQBCYKNvcS10Hs0j7knuuShZvdVi8htCqPm9hhzibq5ss+1JCTvPzn4jEQI2iWmPXfIB5AvTsYgLVNoTw+2Me5cymi7eoXNZH/u8IXQTYmm4orvVvNXsS0yJbK6trEN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GcCepP+9; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6905b62ed2aso2585936d6.1;
        Fri, 01 Mar 2024 10:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709318447; x=1709923247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+DSHj2O6nyP38vAO2Q5xeXvc8PasKQXCBn1/ZiY0e0=;
        b=GcCepP+9w+t03flxOi1THh5uHotgWTDkL6tyh3feBLm88DDbn6PBqm+480sRyT9M1R
         //AeXkaWpiHCWAOHVREC6hbyiSf58fVnxwAJXNcuQIi4EQbbhf+VWamlCtgrH/gu2HAi
         61Bc1E8qm0k4HX9TYWPSJdmLIKCAzKlfg1lfa+/ne2J5BukDH+9BktyQc0noT1Q54xSu
         MDtYV0n0T0PFe/iKysrMvw7vDIjdDbaksYQ4T8xAeQtcEeekIZJpITjsUknI9NQ2x9T9
         PTRt8Nk6a4DfvNiXhB5ftWV+VMo3N/FjNkATfoYE5MpQyu2327CHdpAVFv4+sV+oXlUB
         vk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709318447; x=1709923247;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D+DSHj2O6nyP38vAO2Q5xeXvc8PasKQXCBn1/ZiY0e0=;
        b=xLiv0aqxV1ht9d84ONZWxqkOPSgaXoWEZOD06O9n2ocGz/dNl/JtQB0MTXHKiRDSzU
         gqJGdvzckHFGwFv00gdF0+F/glbcitFgUVNRrSPegvxhF/YuV5pHLWEoGlQSQ9+IBzLK
         ThKjtDsqQ1FI6J/WxTe4goGN6yC7XHPz/YYXxLQyKKYhyrQgCkro2svXiPDIgrI6lj90
         3oYp5+ZfkwMUt7ALJ0OhfF86OPaSTjhCYKsB4C6wKiPijZucF8OpMMjX5uFj1oMg2Ows
         QSWzJAJvhPFIJV9Wjuc52XYVGq3W4XmRx5UIrxs0QR9PWxreRCMhf6DvcCkyIRRCi64D
         rGuA==
X-Forwarded-Encrypted: i=1; AJvYcCUIPnU2bWbggIcD4fqSZXr3Av4KRKsgEy9PHqBKKz1XJZMxTJxutFA7mtl9Z8S5TaYDcLElV8ecAk9G+HVXaU407YW6dTutlIKUL7SgH/jM/datYdxq5qPGGdeRZ42Dv04w5rMuPaL/BrkabGJOg0ZzZVt4/ETHUl3k6cQcTvGzsiEiUcbDDxtm6vqfpeeX
X-Gm-Message-State: AOJu0Yy3ojvGTID5VqY8XU/J4LG9kpNrRC4dHmfkZLMwllJ9mx+INVSV
	G0IRH48NR9apP91dVMfDMyGdjAAxnXu9m0i1EsBV6gP1vHsXuiBl
X-Google-Smtp-Source: AGHT+IEHn5c+uVkAgjlwPDH96t0yuU+j7oeVXqnt5aR1eMRI0HHontd/eYJbeRcpsU+nl4/66M8uhg==
X-Received: by 2002:a0c:ed30:0:b0:68f:4d2d:3f38 with SMTP id u16-20020a0ced30000000b0068f4d2d3f38mr2632279qvq.46.1709318447133;
        Fri, 01 Mar 2024 10:40:47 -0800 (PST)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id qp11-20020a056214598b00b0068fef74fdb3sm2137813qvb.59.2024.03.01.10.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 10:40:46 -0800 (PST)
Date: Fri, 01 Mar 2024 13:40:46 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Yunjian Wang <wangyunjian@huawei.com>
Cc: mst@redhat.com, 
 willemdebruijn.kernel@gmail.com, 
 jasowang@redhat.com, 
 kuba@kernel.org, 
 bjorn@kernel.org, 
 magnus.karlsson@intel.com, 
 jonathan.lemon@gmail.com, 
 davem@davemloft.net, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 xudingke@huawei.com, 
 liwei395@huawei.com
Message-ID: <65e2212e66769_158220294f@willemb.c.googlers.com.notmuch>
In-Reply-To: <ZeHiBm/frFvioIIt@boxer>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <ZeHiBm/frFvioIIt@boxer>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Maciej Fijalkowski wrote:
> On Wed, Feb 28, 2024 at 07:05:56PM +0800, Yunjian Wang wrote:
> > This patch set allows TUN to support the AF_XDP Tx zero-copy feature,
> > which can significantly reduce CPU utilization for XDP programs.
> 
> Why no Rx ZC support though? What will happen if I try rxdrop xdpsock
> against tun with this patch? You clearly allow for that.

This is AF_XDP receive zerocopy, right?

The naming is always confusing with tun, but even though from a tun
PoV this happens on ndo_start_xmit, it is the AF_XDP equivalent to
tun_put_user.

So the implementation is more like other device's Rx ZC.

I would have preferred that name, but I think Jason asked for this
and given tun's weird status, there is something bo said for either.

