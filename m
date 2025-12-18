Return-Path: <kvm+bounces-66284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC815CCDBC8
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 22:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE1023027A61
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 21:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DA11E7C34;
	Thu, 18 Dec 2025 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kuPkucn2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6A4A35
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766094761; cv=none; b=DfaEnzZZEncCjCR5t2COjRv9OdLgXZ4UeyOGgJ4EWIlEQtR7OfTW0iDPaqGiovMJQK2C+dw88D2uxMri0dbK8tXD0yp7KyDXuH7ugEbPuQap7MSm2CZLpOgm38sblRSXAESR4SgMdCoisLaqCzxmU+Tj/7Ql+vZ+H12y9I7mexI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766094761; c=relaxed/simple;
	bh=mGtlij2/iYm1d5MX385M+xU+wnJkJBWO9HbGKDrEkE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHHCwAj1J2trq1xZxW0T4P6o6+yPJSpQTWSko7kcbLAZsRNKZEkCkFxjWQgVayYF5wjyJ6c8C+2ynotA0VKTxeN7dtzJciNo6Ostuavqn26UANmFcrZJ/JgZDXDUD/RCrc/FLJFvIuQswMo/qjtbroENpGeDBMR4WD3KWuYRl10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kuPkucn2; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0a95200e8so10456195ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766094760; x=1766699560; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AjRqsNftQptD2ov1Zp7v1ca2w9sKYnv/JOVqJhe7zzg=;
        b=kuPkucn2m4UFhkOfClmPdH7og5DjKB+oBhL+RLvLKVIR+Z2fpdHeCbJ+WXCgZNe8GA
         vJH4WjRleF0shvaBNOn5CXrp9HNWFheLYOV3nFevnCWF/X9ZQ9C9bLLDLj2y7g3UHcsU
         4L3pQdcHpDMAl1tz9YTzQTJBqAV2fsMvf2qzHxtV+HkZx8QKgQ/XbBGYVQ1JArub7Oiw
         5AEUkpz7p2QvCcSpU0eqi1ao0lvlpAkHh9aTZEfrJ7ptgQtpLi5bY62FUoPVQRirXihK
         GLFXtukS9NE31BCd1XjX0eeVYetn+lBw3Og/BWishhnstWTUcNAmmmrcy4Aq5SGwLEnh
         gHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766094760; x=1766699560;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjRqsNftQptD2ov1Zp7v1ca2w9sKYnv/JOVqJhe7zzg=;
        b=DrewlNuu6ZFd7GEgrvQPo/QwErOBJaOjP3ASAZ5ogTI4i1ldl1rzH0wJUjICD7H9Tx
         Nh6a11dHDYK3bFhLYGvl5UAsM77Mn5HIEX6WyOsEuorUIEppOqKNXw0s2K9zgq2/72rL
         QJ57Un+K8iWQmDf+3TYwYJsvxRhlWPHamNHmf9C9ujnMDwg9c3Hbh085JL3EXKpFmEkQ
         dFZrkXfE+K0bfAVi0x0vb9jksKa8nmv+rE5XBndKPOZM05Wudeivh0ko4AaXg9gmqXn4
         B7CwOmleP8Cv0wg5+mXS9l2Jhidig4URWZKlTw3NpcNjrHPP9gZA8yGD9M4CEXSSvxnu
         Aqzg==
X-Forwarded-Encrypted: i=1; AJvYcCX1Ugoub/LWiGQoEuYfwGHg3Z/aj0gPmwzWpM6GpqiAp1lz44+KV/i+SNXuDUk8HxWhqdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNBwJm8nNmgG/p1BFo0AImuA8v21PT0fc7uTPj6AtnQdkckmJc
	6Icunxc8DGWKnRMtB7k+05KkxZk08wGs+2TB6Z9rayThQINAEgsgfyP4TvtyDkCM5w==
X-Gm-Gg: AY/fxX7ShCtmW9eSY3OPEiX9A4+F/5qzYVLwuB019RuedDAhbqNeJnJ7l090o3aWDup
	UsndXvlCSlaI9WlqWT0qGbGVRyi4KY8NpUL1YWjmhIcIEL5lfWE03313C4ELpzNK6jHuSUD0LwL
	RyEs6wBO0YR7ZHwgYJxNJRw7mQUyREt5ODEGT9gK5mSxPxLlougz19jmxtr5qSu8IA3HNUXvbLV
	cmXJhIX5oKX5zbN0dwv4tK5l6EcL9a8xEeq+5JaNhHVmMxb7CnXwIjtigC92CjLW0Icb+EdDesh
	DMI3qg4zUByOwQXN1frm7zPDvUyvXlftvdOuV5wq7B2zj1t8Ht5F7VU6AmoU7/kO2aNxUewEz7a
	WADmMaCjmTLN5uq+JwGU14Bqh4Wn1ZZhKR3m2kDLGdDh312/UVgJGpw2ZhVlTCcqPkbyIQRtw3r
	6fUPHp8cD60QBGOBwQQ0Wb3SLtAqkRr4WkmqaGiwb+A+VpEQo9tw==
X-Google-Smtp-Source: AGHT+IHd75Y3nY2mwEx4VMJQDvHFm2oL1rtkoLgF2d2IhG1E+whdfxRsteBYNCDCOvQtcanbdIptzA==
X-Received: by 2002:a17:902:d2c5:b0:2a1:4c31:333 with SMTP id d9443c01a7336-2a2f2222cf4mr6941545ad.19.1766094759576;
        Thu, 18 Dec 2025 13:52:39 -0800 (PST)
Received: from google.com (161.206.82.34.bc.googleusercontent.com. [34.82.206.161])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4d2bbsm2447475ad.55.2025.12.18.13.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 13:52:38 -0800 (PST)
Date: Thu, 18 Dec 2025 21:52:33 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] vfio: selftests: Introduce a sysfs lib
Message-ID: <aUR3oSrKQnvpsf9A@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-3-rananta@google.com>
 <CAJHc60x0bKioh1cgE_KXWjxnDYC3H06RJ_0ZCsgd0q6SbaS3jA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60x0bKioh1cgE_KXWjxnDYC3H06RJ_0ZCsgd0q6SbaS3jA@mail.gmail.com>

On 2025-12-12 10:27 AM, Raghavendra Rao Ananta wrote:
> On Wed, Dec 10, 2025 at 10:14 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> > +
> > +static int sysfs_get_device_val(const char *bdf, const char *file)
> > +{
> > +       sysfs_get_val("devices", bdf, file);
> This should be 'return sysfs_get_val("devices", bdf, file);' . I'll
> fix it in v3.

Can you add a patch to add -Wall and -Werror to
tools/testing/selftests/vfio/Makefile in the next version? That would
have caught both this bug and the unused ret variable in the other
patch.

