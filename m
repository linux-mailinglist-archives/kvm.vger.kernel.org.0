Return-Path: <kvm+bounces-32416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA369D844B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D01B1650D2
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F203C1991C1;
	Mon, 25 Nov 2024 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KoTK6oUN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF2198A19
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732533754; cv=none; b=rWs9rNgjxrz/CuASG2cGWaOqGy9DEr/mSXAIhHZVfEXb9Ne2I2gvd8ofx7+orGWI4GHR9JM9BpeWT9g4CmFIu7fTQ87X3hJpzVT6FjiJs3UVr1FjtsMcvAF4pkL4FnZtPa6QJTLxOT7h7Ij8nsvKa1sBhOiApTRQeXXWa5i7on4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732533754; c=relaxed/simple;
	bh=uDjIS3T+skIVriAucuNnm/jHl5kw+SPTiNT5UC7q7ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UlaEvygEKldQ0eGIxlvPNa0cCiJhHVFpbjtHeEB1S/Cv/LNrxUhqLeFj2dpGO0J9l7i+44gLHhO8hJRJTNpFzz7e6SV09ofIyuSKcYa9SZBhKvy3zj6LiwAPR8vepqfhmF5qgq12+VN+IHO3dPVA8Xl4FCRAfQ/O4wxwuBHbVdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KoTK6oUN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732533751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDjIS3T+skIVriAucuNnm/jHl5kw+SPTiNT5UC7q7ls=;
	b=KoTK6oUNlyqTideoyZ6J/q/3F+lvbPC0SWScAMo3bdMyQOWge4VgJOd+bS0ji9VhK7EYn6
	767e/dktgGdl7/I1b5ZXcUUOSen636dV45sDZz2pVwVqqld0pxNo+fSZxyBJaxzFtMSpBW
	5B0ILXgeESDueQcgkccro8xfQgt4dZM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-UyMBLVJRN4Kgk9Y0coCqXg-1; Mon, 25 Nov 2024 06:22:29 -0500
X-MC-Unique: UyMBLVJRN4Kgk9Y0coCqXg-1
X-Mimecast-MFC-AGG-ID: UyMBLVJRN4Kgk9Y0coCqXg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-382341057e6so2162001f8f.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:22:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732533748; x=1733138548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDjIS3T+skIVriAucuNnm/jHl5kw+SPTiNT5UC7q7ls=;
        b=ifKrQmK0dygoFNMgtKlAaSPyKTuBfs57AqlXRYPQF0ZNPY3Y+fnMt1LClHfTWXPKsB
         Pw6IgNfShtgugGAvNCQ319XX5DIab1B52YP/ZgJ+GFLGLguz0HegP/QuSjj111J2z/w8
         5mPGPbEr4Ju2d5JHT3CnI9djgN22I2qn1R/zhrYgWmxl1Pj/j/5z52vo3jk/GzJ7FWDc
         WwFsYJETiIHel+gASAV2SYdWmYzefBAs9gcoaXY74wQYQqL9FjnNHu8ndqtvAy7KeLqn
         22O5qxhuscrRC5UyxdhxlIgiVYuroS4b0m3j1sAf932fF/0GpsLTQZY505txmRNt5AId
         zB8w==
X-Forwarded-Encrypted: i=1; AJvYcCVvg+YvLyaT3xujtxY/iCPIQU03xJ5Y1x/4+HHqLJJTd2iE1ByH4VTc2PFy6PvYaGt3oSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyozgZrukjw0mSJPtipbcnkELAMLSsLKnDhrdq3BQ46AeZVEFyH
	OwKcRZiQ3UTdTp2t/tHex+eOzL1W9ZJHHF6lm3ecv5nLLzd6LRFH9G7TZ4Frp62lnsitWYITGrD
	iUChMMc8ZxJVwvoioOwN87LpQ3WqQjKPOiIG9b6hm0Cg1+IvLOBK4/KIEF4bhin2q8OJvKyMraD
	BlWCKSStaEg24BwmuRTo7VqZWZ
X-Gm-Gg: ASbGncvQQ9JnuhwbDIgBkpUQX1pVIkFWsc92IukxWPdHi3jvwm+XfDzMgk4PeTBiH04
	izuD8GWyvK5OlmpHpoZj3czVwb4KCXtvr
X-Received: by 2002:a05:6000:400b:b0:37d:4870:dedf with SMTP id ffacd0b85a97d-38260b5b997mr10052618f8f.19.1732533748641;
        Mon, 25 Nov 2024 03:22:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8RMF1eE8qGQ7deFZ6zkFBxZhw1nuFFo714Pf/H26XOtCJdb7eIMHcJamY8E6V00bW/7r8sLJJrO61LvbDfOs=
X-Received: by 2002:a05:6000:400b:b0:37d:4870:dedf with SMTP id
 ffacd0b85a97d-38260b5b997mr10052602f8f.19.1732533748386; Mon, 25 Nov 2024
 03:22:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <rl5s5eykuzs4dgp23vpbagb4lntyl3uptwh54jzjjgfydynqvx@6xbbcjvb7zpn>
 <CABgObfbUzKswAjPuq_+KL9jyQegXgjSRQmc6uSm1cAXifNo_Xw@mail.gmail.com> <hbv5uf7b2auiwyjkekmtfpu26ht7ulvapnszx7rdgwoowqdcna@pwuuodkenwgr>
In-Reply-To: <hbv5uf7b2auiwyjkekmtfpu26ht7ulvapnszx7rdgwoowqdcna@pwuuodkenwgr>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 25 Nov 2024 12:22:15 +0100
Message-ID: <CABgObfYtpW0B4uEmjne8FAq0tSJ+v4bvcukAgM2auuQWTqaGFA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 10:01=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.c=
om> wrote:
> > > I think the bugs we saw are not so serious to warrant
> > > Fixes: c57c80467f90e ("kvm: Add helper function for creating VM worke=
r threads")
>
> I'm mainly posting this because there are some people surprised this
> didn't get to 6.12. Hence I wonder if Cc: stable would be helpful here.

Yes, the patch didn't make it to 6.12 because I wanted to get reviews
(which I did and resulted in changes), but it is in 6.13 and Cc:
stable is there.

Paolo


