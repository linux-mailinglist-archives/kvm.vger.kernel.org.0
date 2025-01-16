Return-Path: <kvm+bounces-35637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0283EA13768
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D876C1889594
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 10:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C182E1DDC0B;
	Thu, 16 Jan 2025 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0p1KzHg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAD156C76
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 10:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737022030; cv=none; b=Zcd0L5k13sG70tCOFh8K7UHDMAVvrNAMqq6OCbCbr2exMzbsBDgKpvRVTklwYwww8gHU7+L5qnN5BXsy0L5PL6ijHefEjPfeSuutC7iyEfScPRRHcixDsJBaBAXNv1PECTSLixs7P4H1HlIY6We6w376bqcgQI9GzQtZlsNQmKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737022030; c=relaxed/simple;
	bh=WvHkPKfyGXd9AjxOMUhOE94KeSUE1pQLqETm57wxMv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvhbMZkWbCWFfoUaKSqfY48V8khHsMUlI2sIrYB1i/qYZgnn4PzXn5pqJoRdmGjD4wDNe8X6eb7xfQRrNW9KeuziVjuXowS66a3hfNqzGGeV6w4Kx2Ow9q+8uVCU3HeyJ82xIUed09yo9EU3RAQ2S9N90qeGpK8g8JTFeOzHcag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0p1KzHg; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4679b5c66d0so154721cf.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 02:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737022027; x=1737626827; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WvHkPKfyGXd9AjxOMUhOE94KeSUE1pQLqETm57wxMv4=;
        b=W0p1KzHgXcmf2U/G7Zm25r2g2ljRQssTM2mRc5YsdEeMYXsRj+yd8dlP1dFrshJpia
         L4hphCUkP2rj4b0JFiBsR4lis4yxARWoemISTsP0mXh/5J756G0fUirAssAw1Gl6swTV
         /u3tPeV0FYUWnH1ms0TcOJR/whpMaB+xqrpTDcn10ibAmHAJiZexXt6KrMcx7B8AEY3b
         34lZtS2BXXYysOJoCZtyV1u0XZw2nX9bCY//Ir5de5PPNJF1qu3/paw4MaoI2YXOE8Pd
         RgeJTWabAJkvfSewU3WffkM6g2LW1diL9H6zIhcYUM9H4/FMUh146NfaYuvBYXnZKc24
         fUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737022027; x=1737626827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WvHkPKfyGXd9AjxOMUhOE94KeSUE1pQLqETm57wxMv4=;
        b=o0775E1YfbtTGlF0tmL8CelNLmHBJo4YuMwUAzGGRcIMJXWImQi2U1OdzlyfQUVfxZ
         fT0ubHABihdSl4pHBjx4Mog4gCrLdfBgfel2hfhJhGgfyJjqU67uT+lS/Hajd4wdsyuG
         X+ygi4wVJfQIKvPuhrNu3edcGbFFUzs8gFs5kWnF3DsYVc/rqKOrn6JR41BFYkVbxw21
         xaKRfeppo97DvUSb2Uxmbhj4mbASfiN0q7PYQzXzoSrlOBMMpgjilTRThP8OTxqcX8lZ
         z4zmuyR6yL0YVK76eE/T92IJktxZqFq/TzSLK7qQSkW5qIJByTG7PUpqXSy9++fuSJIE
         RZfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYhhKnR4+WqsmbEU0/eCg12yd7wZSVW6ceqZeiGa+ujS1R8uz+r9znwUft7Ek9PLwyDoA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsreUHiIF3W/VgdGHK25XDxEOOlORoQnUstQL5Oe/UPidU6qUk
	UpWsGvN0Ao/qz1Aq45b3XEgZ+MmLx1y+CDy5b1RnsFc/hmLQlfVGn9NtlLNPq37zzTG2E6ZlMt4
	2oFttTWjG9fRFkfka4ZyLiFq8tu3ypkzL1cCB
X-Gm-Gg: ASbGncu5jPfKbS1Z59hkUbAyNvYRZksoKDETt+Qiqk0NZ8YtzjsQrPEIB4lFQLPNaL0
	9y1iCFU8nsGKyw4TLWlWHPYNkNJcne4hLYCCuB0F/ddpnUlIAX9lsI8dzf6fVXXZYHb4=
X-Google-Smtp-Source: AGHT+IFOMkwJSDq64zLXxSa6dw6mO+3SY/5E1TPwtyTlPAbmBc71F1ay07U9Ys+mXp6/C1CNJDS+iWjfJ88KfeUevR4=
X-Received: by 2002:a05:622a:199e:b0:466:8887:6751 with SMTP id
 d75a77b69052e-46e054eddf4mr2032541cf.23.1737022027218; Thu, 16 Jan 2025
 02:07:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com> <9c04640c-9739-4d5f-aba0-1c12c4c38497@linux.ibm.com>
In-Reply-To: <9c04640c-9739-4d5f-aba0-1c12c4c38497@linux.ibm.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Thu, 16 Jan 2025 11:06:56 +0100
X-Gm-Features: AbW1kvZgJ_xYEHdNMI59zCSV7pIlY_aZBMf_JVoAUx67vx0p-sB2zIfWs7-2Jzw
Message-ID: <CA+i-1C3ncij1HLKGOdTC2FtpBY2Gajp8_3E3UrvNBYhs9Hu0dQ@mail.gmail.com>
Subject: Re: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
To: Christian Borntraeger <borntraeger@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Heiko/Vasily/Alexander,

I don't see any obvious choice for a maintainer who would merge this.

On Thu, 9 Jan 2025 at 13:46, Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Given that Christian acked it, and it's pretty low-stakes and unlikely
to conflict, would you perhaps take it through the S390 tree?

Thanks,
Brendan

