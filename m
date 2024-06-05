Return-Path: <kvm+bounces-18835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5A48FC103
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 02:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24A5EB213E7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 00:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5C94C8B;
	Wed,  5 Jun 2024 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFlV2hgn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CE2163
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 00:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717548992; cv=none; b=pQ1ZpUvT3S/K6TBpjLPXrI/hBSjGis67bAq4Ft2UHxAdfPBNsBRJR2w8gZULw0g9CuC4wAgkcFUDwdTaydcwXqNekzspoxPnrFW+icdolnI53t7c5B4zryLdY3i3m+64uFl6qL5KehXWC4zvvEqF/k/RqpgDMP7DOCLCURMFQnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717548992; c=relaxed/simple;
	bh=9huCQo5OeMQ2GXZXH/PcOAOacIsXohZlshI/DLAZU3Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=JVjJ7rR9ZvV6LIxkVmiEVsEgDgpq0ZRLOb6Tdn+IcBCsgdfovnFmJk94hlzSeq48e4i1VZabBOP/ThcJLO7JfxNVvZHPU2hZTe/SgFBXdlMxT7+nK1qei6BTGX62o5Diq8x0c8mRPIe788pI3PjljMSo1PfL2eBLoN4WXDvOK4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFlV2hgn; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f4a0050b9aso42321445ad.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 17:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717548990; x=1718153790; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9huCQo5OeMQ2GXZXH/PcOAOacIsXohZlshI/DLAZU3Y=;
        b=UFlV2hgn39jh4IO22bSZFqUwgeK6xc0Oc9jTCquM/ZWkS6AHOtbIpK+mtMCf0VQ6aQ
         GqLy0B91h1TSC/GaSlJvZ5g6MU87AoVGr+QwVz3lBt8jevzXrjs9cf2SJ58vbgGrFTFd
         yyUN9GvXhzYyH56MGyrrk4S44RFqcC7qSbIhCo+MMowv7b2WU3OAtwigvE39byttkyJY
         dy6irirWKi9l3vjZoxsxqMuTr0h4uAiV5/tlZDBEq65en9HjEFfSU0pUlvaqtR+hJd/T
         rVyvGMBQhVI8IYuqo9sOfBdMTWL7yWLL3k8xkII2PT9IaMVimfNIys80LkEPRUgnMSPL
         hWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717548990; x=1718153790;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9huCQo5OeMQ2GXZXH/PcOAOacIsXohZlshI/DLAZU3Y=;
        b=iH3Zgb6uAQ1cXVxm7DdnajrjTd/xNRkrbiLB5q7Dpny+RJTux6U+FiUjbl00fsiZ4J
         DoR6Z2AciiykxmMDkNURIxiGKkz+CmDTe78WlJkxNsqtM+8x59EHRpKGnmj17v/i1h9t
         SQjJVAPDQClQL8RL+FOLHk/IqdI6GYtnfdLy1+Y9o2plj/N/QWJniBHC5JZyqz1VQpVg
         G7yhcQOMSjWtTIEgsHgPeGYUbcp5qp8T2Ch1l3NPwsCgcR+gh4XdpQBTxTpk5RgtvcYj
         6+YhulisH0+QwaoqM8ZLQRCMZwocxy3lhC9uI2TLM/XU2t0ZFGnZ6lRCIN4ArYgbr2jt
         9C8g==
X-Forwarded-Encrypted: i=1; AJvYcCW81PxZUrJBmtYpy/my74V5toWY9MhthXcvBj0VDfn+OM+H6g5nbeO4+b33b2RLrO7Ho9LEZZYpXInwAL84m1hCUcBO
X-Gm-Message-State: AOJu0YxLV9lX4qsj+4p+CL7f3Dwb07QhYFmalAMF7gajjP3RCt5dVF5r
	Fm6ysyx2CH1BGN6GFtF1upgG8MrjAVrHYKKVh4zY8XfDL/QggV+8
X-Google-Smtp-Source: AGHT+IFSpl4wPVJEy5u2D9rGJENCBEPO6VfjcqsxcBNhC3faz21X18sVaWwxbYFiyPgX03MuKJvycg==
X-Received: by 2002:a17:903:182:b0:1f6:6c52:7231 with SMTP id d9443c01a7336-1f6a5a0de72mr14897915ad.20.1717548989834;
        Tue, 04 Jun 2024 17:56:29 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6324115ccsm90454085ad.268.2024.06.04.17.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 17:56:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 10:56:24 +1000
Message-Id: <D1ROAUX2AA16.3V8OOJDK62KEL@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 19/31] powerpc: Avoid using larx/stcx.
 in spinlocks when only one CPU is running
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-20-npiggin@gmail.com>
 <d167cb31-11d4-4a0f-8b4e-056fc2afaaf0@redhat.com>
In-Reply-To: <d167cb31-11d4-4a0f-8b4e-056fc2afaaf0@redhat.com>

On Tue Jun 4, 2024 at 3:27 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > The test harness uses spinlocks if they are implemented with larx/stcx.
> > it can prevent some test scenarios such as testing migration of a
> > reservation.
>
> I'm having a hard time to understand that patch description. Maybe you co=
uld=20
> rephrase it / elaborate what's the exact problem here?

Yeah that's wrong, "harness uses spinlocks *which are* implemented with
larx/stcx."

The problem IIRC was only testing migration of reservations, so I should
be explicit about that in the changelog.

You could leave this out for now.

Thanks,
Nick

