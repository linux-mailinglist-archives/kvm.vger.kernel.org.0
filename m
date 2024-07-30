Return-Path: <kvm+bounces-22711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F65942261
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 23:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82D0B1C22878
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD95B18FC75;
	Tue, 30 Jul 2024 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IB5pgjF8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D24418E02A
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 21:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722376481; cv=none; b=U00kvrbS+1864qMOly64Oxj4dkb4uulhgORpu8d2fP4Uw83cZoM90zLUOp6Danlv4gCyxyJWDgWqyPH2cGlkWGTP9XrHCBb6njPn+rNO/WJIawpdLsAyz91Y4FgDHJHoId7zW4YZCsMy9+UHwJJJD3PzCUvkibL3TyRQXvkvV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722376481; c=relaxed/simple;
	bh=xFNqKNUZC3QPbCH+2C+qGCkgqdGmxd4GGQWFBPEVmcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfM9toGuEDeAMpfU2jeHzhTyNH2lJtDBt1JNpfLmXVYbrYpx3FuEpnYWCaT4maUcJuNUHq+q1wvpj7aMhjvTo+Cwy2iLg+rDf5eW90ABuP9mviEYipfL/2kBcgp8Qc3gAwNv8pFYuwjkn1NEo923kN/k3QaImyUhuCnP9MLb3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IB5pgjF8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722376479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XiTAbji70C9FYBLGjSmfVHzEQNNemDMhCb/cI468cQs=;
	b=IB5pgjF8qrXd+y9toOmjyn+tHNf+65YeNYozfWElwd7Xw9nuni0Eywb+uJ/cXYlvD6aido
	ZbpjPv3kndEl6DvkJRYpGo8ChBakHHhVSa7cvIVVBbrWu46mDMgXsrPVZAdxhiaEU6+/34
	VbMybLLlRLRPcgtPTRqOD7E1G4RBf+A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-YB4MaoU-NWKCSIF5fEI7uA-1; Tue, 30 Jul 2024 17:54:38 -0400
X-MC-Unique: YB4MaoU-NWKCSIF5fEI7uA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5a37b858388so5197734a12.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 14:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722376477; x=1722981277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiTAbji70C9FYBLGjSmfVHzEQNNemDMhCb/cI468cQs=;
        b=RzwG5Kc/jR/bFt2N4ijC0dfBpKokild53wJGOsXmC4fPx+iADy2WwIXuDsfF8fLj+t
         c7gXvN3G8E4qIHaS2TAmrYwqnNssSEhr7j5Cnytvzh/myGo993acv6qWc1YExYCYVm64
         JJ0lmZpuKlLIUInJJXTdOxpa6sYgC+IGq/E4jQWvCwveVvB6Cq0SDp3Zs/bOgaoD5sTJ
         KaidSnnky5mgyQjRFDXT7E2W9VMZRmxtdPpMwHMuqsjr7qcLKh4GQvKOPcN9ZXbqDdMV
         kNbPVm3sNV69roXwnqZp7l2iF2rNpC693IZ8QvHbMDazDAuV4me+VXmPihp+5RkkSEFj
         9ZEw==
X-Forwarded-Encrypted: i=1; AJvYcCWY5GHo4EFSJamrjW2cwSXB41Kgmjg90tgFujuBR78HCLi5SU/HLoktvyY9xzF8W1etA8qI2dq7QAABiSmrYDSjVKT/
X-Gm-Message-State: AOJu0Yxg18/j6L4LULbDTW/Xu/bxmi9V2IXpIww3/MSuVAvCkHgD9Qo9
	25+ctCtggKZafFF0NIQxZd8HL9dHDlERQmrIzgZw89y7SY05FpU9aEBRu/6akHY1GccDtUCrSrg
	ZG2qhffTsBXRdMqGIsfzBcVpwViqTHM5P2ieuWP4jrZLbhP5Dig==
X-Received: by 2002:a50:9fc8:0:b0:5a4:6dec:cd41 with SMTP id 4fb4d7f45d1cf-5b021d2231cmr7849779a12.28.1722376476797;
        Tue, 30 Jul 2024 14:54:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBAMnTW+0ZR0faIaLVv8dqaI6j7fVqABVL6hy1VheVczujzgMg8WoKj65x/wzQERyVgM9dXw==
X-Received: by 2002:a50:9fc8:0:b0:5a4:6dec:cd41 with SMTP id 4fb4d7f45d1cf-5b021d2231cmr7849761a12.28.1722376476162;
        Tue, 30 Jul 2024 14:54:36 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:440:d5c3:625c:d5f0:e5f4:6579])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5afa605d81bsm6216832a12.74.2024.07.30.14.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 14:54:35 -0700 (PDT)
Date: Tue, 30 Jul 2024 17:54:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and
 virtio-vsock
Message-ID: <20240730175120-mutt-send-email-mst@kernel.org>
References: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
 <20240730084707.72ff802c@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730084707.72ff802c@kernel.org>

On Tue, Jul 30, 2024 at 08:47:07AM -0700, Jakub Kicinski wrote:
> On Sun, 28 Jul 2024 21:33:25 +0300 Arseniy Krasnov wrote:
> > I'm working on AF_VSOCK and virtio-vsock.
> 
> If you want to review the code perhaps you can use lore+lei
> and filter on the paths?
> 
> Adding people to MAINTAINERS is somewhat fraught.

Arseniy's not a newbie in vsock, but yes, I'd like to first
see some reviews before we make this formal ;)


