Return-Path: <kvm+bounces-51244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C7BAF0862
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 04:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42897424590
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCB11A0731;
	Wed,  2 Jul 2025 02:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYeoi0lR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01F0219FC;
	Wed,  2 Jul 2025 02:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751422533; cv=none; b=q6T5peGw8HaLyzN89eBWpqm1konsd7oRO2uO1uKT5kSdGaw8bOpUgRg13HbL0UC/6yt4iB0s3g7P2wkHmeCJsApZSHuHDuHSb/luWfO791UvAzZFqSpdwaT3mG9lVgg1MjuzpD+jOHjN7wl6aF2t0o2OveNM13KF164MGJLp54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751422533; c=relaxed/simple;
	bh=mf227kKncoURIdLp1KReMZcMntXVrdskgCzq2WR7B3Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LgslTRGhABJBIKRFyTcjMdI5Ive2XZwg81oYeeKwXNO8MT8zE4gjshlYaQOl/W1p+OkZGm/F6aYFJVyyssUx7icWrIeZ9UM5GtjTp5P+eSUFYrDZT34wjGqPcnTa6OjSsMmEkPXr0fWpIOyypayX1iOPGr4vofzRQfMjKHEHyr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JYeoi0lR; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-236470b2dceso33197565ad.0;
        Tue, 01 Jul 2025 19:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751422531; x=1752027331; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g31GsV5you24XaAPrCY89ZjlDVNyI0JUrwAbjHIC07c=;
        b=JYeoi0lR79XNfDsYssMZML3oXb6B1V0mZ7fFS2c7xA0zmc8tgT/gFh3esfHofje5n7
         /roWrvJKx0hbGOYn6E/KjwcVbTmaH47mg4E+J/eyrxb4DpCaaZjnRHP4QvhZ+gJ5ImCU
         EHp6ct8oj0xmlAIcvY98FCYmvuaiCka0upNMtxB5Ei8Esjw2XMqnbx9k9EKstztIP1G+
         sXyW42RmgclA+FwY15CauK4+BnPyGIWmlIxqtizv66H/ogbouYZgA+/pFfI+zUuVZzFJ
         b5DLk9i6mpuHmSEXNLb+ui4hNMkvNA+OyEXLZNbEh5QOLU51pP0PHm+C4Y3UyZkME4lc
         RHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751422531; x=1752027331;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g31GsV5you24XaAPrCY89ZjlDVNyI0JUrwAbjHIC07c=;
        b=qDJCrsfucVukS09uVeYi5Kpf/xdeC7hc877BZWmfGJ6SEkbfRm7/+40q4FPSkU/HvJ
         9c/ZLx/vCwMUKOvNBCKQ+pRMmbiKpCciUxo0hvJ0knyvc3sSOkY1sEZBf+gyKcg1zWNM
         8iu4G1hQ/RYXOblQcq7f7rd5CTmsrWiE9E2I3PC81rG5STCDgqJFeZ28QvVPGQYq/AeO
         Ch1WgpspO77J2Lwx+OJiqg+oxlRk3dhSq5Gmv73+fvVQCti6LEbm7ia7WiGEJr3ZlbKB
         P2TNLWyjPVQLMzNjtbPqFZhBOSAzTtZh1TwSqniLsh6TW7ZrvGKZDMCblcWfZVMNIW5k
         wI7w==
X-Forwarded-Encrypted: i=1; AJvYcCUCkPRJ6XmUPUjehd+dP9cDFVTXzQWbHmz0OA3daC4nAPa0i4qEPU8GsTsOFCk4hpWdSRhT8b3g@vger.kernel.org, AJvYcCURzDy9ubZevjKscK7kt2Sn89SEnIhfobryVrqXbhxbrDj56IHKqi/INZxY0Hal9K07EBHjh5FzdC338dKQ@vger.kernel.org, AJvYcCWX5MAhEGT+ifP57iy+A37ME28OYxrG3DHhLIZ/HZvGs2wTqAM6gpsSR3H+5GJN7pgZPjA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywqq0UXW1zHJ495scJGi04pVMlI73O+hwthWtlr5D3pnNGIE3N
	ChcP9I4iG+VH3rjS196YPgUa+QiWYUVT6oVxjv0lvL1qJn+7sLMjI7ovl24jUHm0ONHo/XRc
X-Gm-Gg: ASbGnctB2L0MxRCdqZjHYxdLj6VHsTeJao9WeS2PuLdqep6UkpvSyUvbK6x0daTn21v
	uqz6IbDHuNiFFssrlYumk6fGtxk7zZWS1pHrhNMdKgk5m1Nzjww6o8Fpa1PSL+Q+i9beZBfKLT4
	TLnHlBOEdkRe8cgwK/fZG+3Ne0rv3aUVzXb0yo8OkvCaFcTp4/CzXnmYUtzy4o8Yyx8AOuRjeyY
	s2C7G9ePHVJQ+6820i4h8WloZvQCe31cmKzUeSgcmB3s5oDDKPM/+k4bGuPE6o/XpmytlVLZl7v
	pSKN8C2f8wfuVfczXb5dyh8aCmgQkWIDcqvEAWO42SwsDcGJEaiz/ZMMG0fyzS5OKevpETk=
X-Google-Smtp-Source: AGHT+IFU7cSFIO4KkQO2gT16lJGhF5dZmQEW6QhVLm1Oe+2lHVb75yDHEuhj6lpjbfnNle+xNLPuDA==
X-Received: by 2002:a17:903:2341:b0:234:9375:e081 with SMTP id d9443c01a7336-23c6e5c8868mr13451135ad.42.1751422530838;
        Tue, 01 Jul 2025 19:15:30 -0700 (PDT)
Received: from smtpclient.apple ([23.132.124.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31da818sm10336762a12.61.2025.07.01.19.15.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Jul 2025 19:15:30 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RESEND PATCH net-next v4 0/4] vsock: Introduce SIOCINQ ioctl
 support
From: Xuewei Niu <niuxuewei97@gmail.com>
In-Reply-To: <20250701180927.2cafbb5c@kernel.org>
Date: Wed, 2 Jul 2025 10:15:14 +0800
Cc: sgarzare@redhat.com,
 mst@redhat.com,
 pabeni@redhat.com,
 jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com,
 davem@davemloft.net,
 netdev@vger.kernel.org,
 stefanha@redhat.com,
 leonardi@redhat.com,
 decui@microsoft.com,
 virtualization@lists.linux.dev,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 fupan.lfp@antgroup.com,
 Xuewei Niu <niuxuewei.nxw@antgroup.com>
Content-Transfer-Encoding: 7bit
Message-Id: <E6A8AF53-7AB0-46C1-AE41-FAB5F443911C@gmail.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
 <20250701180927.2cafbb5c@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)


> On Jul 2, 2025, at 09:09, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Mon, 30 Jun 2025 15:57:23 +0800 Xuewei Niu wrote:
>> Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
>> bytes.
>> 
>> Similar with SIOCOUTQ ioctl, the information is transport-dependent.
> 
> This series does not apply cleanly on current net-next.
> Please rebase & repost.
> Please note that we request that repost do not happen more often than
> 24 hours apart:
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

I'll rebase, and send out v5 in a few days, in order to have more comments.

Thanks,
Xuewei

> -- 
> pw-bot: cr


