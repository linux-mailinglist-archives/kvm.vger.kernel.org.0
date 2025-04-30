Return-Path: <kvm+bounces-44888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C762EAA48E4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73C1E5A2BCD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2152725A625;
	Wed, 30 Apr 2025 10:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uc4lrSah"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C582505BE
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 10:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009278; cv=none; b=ajp+8ecV3nWAJp7N3zHsHlggToivMriNWzLGaTqIzAfekRXg0/6uFflMabgTU9ryrgUf2urmvPNKkjN6V4UfLnCp3xckRRxXzaRwWbT82GeNMjsLiwpWpfH1hGx1ttd0Aju7TXWEr0ztBuyNSgOYYBTOfzScUX5ddsLZQSxy8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009278; c=relaxed/simple;
	bh=57iokHmYjdcAZayIvqdZd5fOEHDPDI/m5Ok9KeY3rFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=or7LySMws2hVQwmVE8eEmpw2GLwM6mqb7s8qihhF0xjDj04BNwJQftERPi5PWWL6TF1kLbXHMnr6vGE/VK1Wdl6CE2U+Zwplb93Vd7MSG1YlJai81RgZJU1cyn7uXuf8GK6m3blWUyOlSEU12dI1gfZ+K6c6qWAN5ECXU8RGv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uc4lrSah; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746009273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=57iokHmYjdcAZayIvqdZd5fOEHDPDI/m5Ok9KeY3rFc=;
	b=Uc4lrSahq1iSzNujDIxANcGQtBtzRqacvYLfUYaNpQxA4jiE78A+Fv1baXmm5h4KVAmdwH
	UuyUDomzlJ1sI/R0oer8u82OgFKUIkKh/pjbT2xMguMziZJGWAR8uHgceqB5W2A3wZJypq
	sCAan8oQ2qPXCR9RCvJl1pcFnBBFFpE=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-k97ck3_8Mb2U2zE9p6Xdug-1; Wed, 30 Apr 2025 06:34:31 -0400
X-MC-Unique: k97ck3_8Mb2U2zE9p6Xdug-1
X-Mimecast-MFC-AGG-ID: k97ck3_8Mb2U2zE9p6Xdug_1746009271
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e6df20900f5so9810093276.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 03:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746009271; x=1746614071;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57iokHmYjdcAZayIvqdZd5fOEHDPDI/m5Ok9KeY3rFc=;
        b=oDaRs4Wewfj2mtU5iLg90xHdyriPQG15Rcn9xIgHwf3rwRr8SrC3Dlly6Ff+xqcWxU
         EdZtYus6QzDl3ira+Fx4vHM4kEsJM1XIKNhyz3YsXymPaFAP6IyFjhp06/lJoUTR92ZK
         WrVbCJGt8KqAaKOQaxxf6mmv2tCPF2dhBYswr7eq1NbL/nL+GWqXn76aQqTyWqb7Dh1i
         Zw77ZRza3qg4Alg/Bmf3h2d/BHdqLsWJMJyjWMganlTkBgCINYU9e7T7pDlwW3nOkhVT
         SjzJVjxacVMpUheGcshHxORQFwP0Ik4huMj/XcRiYfvxAIJwbWTHMWney2TMEQr3Ds7M
         tfkA==
X-Forwarded-Encrypted: i=1; AJvYcCXxCPkrMCxpy2Ye+Tt9B6tylAWE7f3Fl0rpffuIKRH1+GKsaMKZfqOApeDFYKEudCO1HDA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8cEd6pIgfQxzUJ3CUA9rGvpAOsOACklmptKjmrP+qUVc7XghR
	SQHQYRgGY02F/IspoF2he4Qh8H6Y67FELbFJ+fNFdsj9rn9rHPZdzznSCM6pOPHsGFw/nVXzpiw
	JweYuUzqyEIi2pW19K2JmnOQyaSmUDJD3McugSfJq0DW1PcOQ0PU5LysiZ3gU60sHYuwG7BbzoB
	FvcV+d/OZCiPei+3IiBN5Hom4i
X-Gm-Gg: ASbGncvFhhqlv88UOU88Bbj4uC7tIl9e5WWkWr2oQd603eCP8bfJ0iDhyd50aUr+2eu
	5kd/+r1lJ95oNM/LrshgrkhR4L7L9Dq//pVsgRfoLwfwi16S7dcn1tyU6RRt8R0++4nIRPSM=
X-Received: by 2002:a05:6902:2e04:b0:e72:8aca:d06b with SMTP id 3f1490d57ef6-e73eb1e65bbmr3488711276.25.1746009271080;
        Wed, 30 Apr 2025 03:34:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2PrL/8Qtn9RsZP8gd5PYBcNrIX0CThPxJuTbKkfEk6rVR0kYHi6XEOL3ZZcMQ3Xfw0mqQVeC6RSWHmdB1B5w=
X-Received: by 2002:a05:6902:2e04:b0:e72:8aca:d06b with SMTP id
 3f1490d57ef6-e73eb1e65bbmr3488683276.25.1746009270736; Wed, 30 Apr 2025
 03:34:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-2-ddbe73b53457@rbox.co> <dlk4swnprv52exa3xs5omo76ir7e3x5u7bwlkkuecmrrn2cznm@smxggyqjhgke>
 <1b24198d-2e74-43b5-96be-bdf72274f712@rbox.co>
In-Reply-To: <1b24198d-2e74-43b5-96be-bdf72274f712@rbox.co>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 30 Apr 2025 12:34:19 +0200
X-Gm-Features: ATxdqUG9mjYJydPSVQyHlnDymiSRul3tknhI-VICJUQQ6q1CyA6LPz-wMS1FOD0
Message-ID: <CAGxU2F5_vZ8S7uoU4QF=J0jh11y976+AxFKf94dp01Fctq-ZwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] vsock/virtio: Reduce indentation in virtio_transport_wait_close()
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Apr 2025 at 12:30, Michal Luczaj <mhal@rbox.co> wrote:
>
> On 4/30/25 11:28, Stefano Garzarella wrote:
> > On Wed, Apr 30, 2025 at 11:10:28AM +0200, Michal Luczaj wrote:
> >> Flatten the function. Remove the nested block by inverting the condition:
> >> return early on !timeout.
> >
> > IIUC we are removing this function in the next commit, so we can skip
> > this patch IMO. I suggested this change, if we didn't move the code in
> > the core.
> Right, I remember your suggestion. Sorry, I'm still a bit uncertain as to
> what should and shouldn't be done in a single commit.

Sorry for the confusion :-)

The rule I usually follow is this (but may not be the perfect one):
- try to make the fewest changes in a commit, to simplify both
backports, but also for debug/revert/bisection/etc.
- when I move code around and edit it a bit, then it's okay to edit
style, comments, etc.

Thanks,
Stefano


