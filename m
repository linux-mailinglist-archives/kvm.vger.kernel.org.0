Return-Path: <kvm+bounces-20112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4399910A34
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 712F828102A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCFE1B010F;
	Thu, 20 Jun 2024 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6eXDzbG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471821BF53
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898126; cv=none; b=D7iy4fcud7Sh/6gQQ6016/QKUzipzGSVxYeAnvTlF08pRYr4IHkYVzYQA121I6E7eQW1svxpHx+nohb+8zOURoOq+KDcw14wFV+wZCDdXs2rpYg+5dhoupm+P1fru1+WrdQ+MTNdfB5q7MqY3waGmB0r6hOxCX4H3zxTngEDuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898126; c=relaxed/simple;
	bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OYVG11ypStVr3ImDP50WDp8lEw88QokqNpPvXWLyRjQI44XIpMzf7NchX5bq0q2evIwhK8o3IypJD4RsDm1xWib50LQUV0eSmy7enVIIfXMtowB+pE1eTH1NO/HMDYA8StH9SyyY6zRcNIEZqodAgriK8vInQqXarA+AjAHjq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N6eXDzbG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
	b=N6eXDzbGMsk23HN2ajgNV7Ln1VJ4pJD2WEQ0A7u5HzV4AE+9o4LI/DqPyj34wYF/jFJuls
	ekC76YlApLxJe0+PVZr32YJt6ms2AbqCLSkUJ0upHY9FnKzABPt/SvyxlHSjagk2R18cK/
	Ob1uEmw7dhAxp+Kdnt6EHpRkeVk0Qds=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-Y8N0FgsPMhOONOuMDAo4sQ-1; Thu, 20 Jun 2024 11:42:02 -0400
X-MC-Unique: Y8N0FgsPMhOONOuMDAo4sQ-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5badb0511b3so922063eaf.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898122; x=1719502922;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
        b=Y0KGJd55SSQ77vW3g83oesYNCc5mwEyTDfQdd+7D9sfq0znU/ys2pO777b/wRCrwgK
         y6w9SPBdNU4DugSiPsQZNy1+KNqDDOqsRiG2wdFgjy2Nm0b94KKN3HoN7bZxb9fEpabx
         WReqCkEoEdaf+55dc+hnYctYBaRcViMaC50AeMsRAg+Ux0X+X4fi+z6Za8mXJVJfQWNC
         REnXTUOC/OAUFKb7LKUxhU/U05yr9d9MEQJbmYOxmIP8MlDvJuPT5pyaVs4UJfRwdZGu
         51ytfPoVrVsjneiaHnBUqdBFh7XY8bVOCOkixoP9OETqhX6NARq/s+Bs6qwLitwZN1/1
         RPBg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ4lda7jvOstKgZFqNFLVqOTKxqjPYIGvsPYLO/YDeieE4HZPWwk/xtKe5jvaZ9dX7jlH1A9qFvczF/4n0qdpMRNMh
X-Gm-Message-State: AOJu0YxgqClOi32w8nMplsMyWxYm3qXZq3RujsGjShXsVG6D/sztZuUm
	fwXw/JNesj/VZAZMh/Qidpr9Qxh4nicxf8u7Cgw/ddS5NpNGXh0TOaGqkX3L3loQ5w9ENz3B7kN
	BZfONk9mg214l8JudEPoR1Vj6/Ncew1g068NNRFoBWK2M2W4Lig==
X-Received: by 2002:a05:6870:8a29:b0:255:2cc6:db59 with SMTP id 586e51a60fabf-25c949a4384mr5206984fac.22.1718898122113;
        Thu, 20 Jun 2024 08:42:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECy6MpJCSL34r6nqz7WxiddHs20IWVB6NF5jm95VxIJO0blWdQ6yaWxoYzVB9pkyUlpr0yUA==
X-Received: by 2002:a05:6870:8a29:b0:255:2cc6:db59 with SMTP id 586e51a60fabf-25c949a4384mr5206973fac.22.1718898121823;
        Thu, 20 Jun 2024 08:42:01 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79a4f164806sm435245285a.93.2024.06.20.08.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:42:01 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:41:57 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 02/10] KVM: arm64: Make idregs debugfs iterator search
 sysreg table directly
In-Reply-To: <20240619174036.483943-3-oliver.upton@linux.dev>
Message-ID: <ea451852-b6e2-4304-4ae8-bc51bb4030b7@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> CTR_EL0 complicates the existing scheme for iterating feature ID
> registers, as it is not in the contiguous range that we presently
> support. Just search the sysreg table for the Nth feature ID register in
> anticipation of this. Yes, the debugfs interface has quadratic time
> completixy now. Boo hoo.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


