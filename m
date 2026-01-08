Return-Path: <kvm+bounces-67346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4EED00E52
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF2F53025140
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCE9286419;
	Thu,  8 Jan 2026 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5SR+E4q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="O1JdmZxF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BAA227B94
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767843662; cv=none; b=N4Te4+W0PJ5lL4bwv4bPrZjQwbFTdQ8pHLc7sv2Teo41gCdbaVK1If10gwwcaTez+VTo/MMc7CW6YsKnHa+QfQwEwlVsrNhY3fEKxI1vdM63d5fCc979SIaBmgVytaPxNFPa4L0oRPp/SDRuj0q74PzLIIuZzkQ3sB9bkm0rFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767843662; c=relaxed/simple;
	bh=VkCSubSt5xnjldSC7X3KoWYDh+xOvzCSf5/mkTI/WA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhQ87tlheM1BlBu0g7Xt2XaCCF4JI50xLWCrkPBPmelbRXLcHLDCS5tWulo6doPiazFXu7Pwpx6BAVKOOOQCOnssIX0T5mqZd8Ztp8iT+phNRjfB+k+JLC6c5CahsWhqW3PQ55gbYOhyPuRaqBGH7ort/rmVIaj0YUR4yIOwlAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5SR+E4q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=O1JdmZxF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767843659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VkCSubSt5xnjldSC7X3KoWYDh+xOvzCSf5/mkTI/WA8=;
	b=b5SR+E4qoIqNlInac/aFtFgkKJdvZNj1CB+pPGaDW4w8GwhDhgG5OMF5A+F7+BuHu3frPT
	FzIBChne2YhmZeznPnpZw4WQ4AvsDpLcXRUFYFwb9APaNznciNQNMNZ12JSrFU3tTt4ywM
	VJl/e6/oSCpzokmJVLdHnrP81DH3IlE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-364kw8nmO3q_kcpdzM39sQ-1; Wed, 07 Jan 2026 22:40:58 -0500
X-MC-Unique: 364kw8nmO3q_kcpdzM39sQ-1
X-Mimecast-MFC-AGG-ID: 364kw8nmO3q_kcpdzM39sQ_1767843657
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c3501d784so3100773a91.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 19:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767843657; x=1768448457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkCSubSt5xnjldSC7X3KoWYDh+xOvzCSf5/mkTI/WA8=;
        b=O1JdmZxFjfPWZC7Sfnct3aXbX93cFKVvFIlJssZ8OPiiMevYNJ114HTSuKsY2qQPwb
         Ft2TogvqzgiEfMR6nfzkYKcm19aDmA3eFiH0h4GmJk61HAmk2w7N5fLB9W0cv1OENIAd
         oke1B6DRLS4PHnLzUbSgicmJ6EghpiTrk/hrE+iVlyuj6h3+OmT87gWmvtqSN6JATKuJ
         6zRifLasX0rYwVttWVRYfOzXRLNbjaIS1EwPN8U1OBUBQNYox1PSNcWwKbITfu30y7NM
         zAswt8PqskjfwnIoPvXDn+7TL8JV6WTxGX4Emslh9II4dumhcqFf4inG0mLxgmQ17CyD
         dxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843657; x=1768448457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VkCSubSt5xnjldSC7X3KoWYDh+xOvzCSf5/mkTI/WA8=;
        b=p9WvtpBQh4MPzYmAHH5GLh6f735OAV6I2hGrVzl0VZEjLc9h8unGsvtSHa9j53jcwO
         ebXkHwIeFqf/coZUowo4VshpKaL5+80HL6dZ/U+KucZgakr11Yu1/WmYd7Ngx329oqLB
         wnbx4F9eyrcyfOKdVKXiOMX0R2Vy+8iqmu+aSOwIowu7bnW0n0zxejVmS7gZpAguXc6A
         nc//EZvuZDGwV5b3MKR+0llhpMLV/FVCkPJrjYWhavImMX+4tBMBWQAbjkl9Dlelf4zT
         BsPN0rP2HBytaT23aJwaMKKUPtSaY57caqqenk1ZJlYPj4offvdGczBgRDOAq/+8do+I
         IllA==
X-Forwarded-Encrypted: i=1; AJvYcCVQS8RM6XybiSjM8j2KJvByh6F8l83DjIzORAFZwJwGuV66L7IhbkM7uRY7R+kgNCJtzK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWMO3bCow9rIHS4Pjq0zlFyreYDrl3amWyQlwvu3wOdWappao+
	wT5P89mZP/7ZF5AwQcobqLfOQJQ/eA1MoZKjQ0W15oKH0wo2mf5mURGlQDlZxAlzWvc0FraKSIM
	E0O/gPoUhToXu0JfT/NySzCH3jH9yNzYi/nWvCZWpeHwfMrCtlarNYeth6bcCEGvbYYJelNiC1K
	/jnPBbUTpmFRpd8EoD+d01o3BhhID/
X-Gm-Gg: AY/fxX5aUoklP5yX5ZKRH68HN5dhQSq6g1pJFrqyZYA7h/gOlQO9dTToqaHV0rI9Q13
	QCAgNA3aDO91OjKZFkfzimaOrUnD4LciAkBt74WEIiSCgWlVr3UYQJ5+3HHzOF/K68RTXkfjjGe
	hL+xAgFksOTgZEPBYc2lGXfPM8aVq0y51ogiQnYn87i+35SbxXAv+mTRD4+n1evns=
X-Received: by 2002:a17:90a:ec8b:b0:34a:a1dd:1f2a with SMTP id 98e67ed59e1d1-34f68c020c8mr4599019a91.20.1767843657577;
        Wed, 07 Jan 2026 19:40:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRT/gHviVKg3BmAeVmqnf6QovlGyDQiLOP3X7YJzYa/y5gFMdrkkTDAfiNZ+bZ74TXfET7NZIrA4LL/VqNrJg=
X-Received: by 2002:a17:90a:ec8b:b0:34a:a1dd:1f2a with SMTP id
 98e67ed59e1d1-34f68c020c8mr4598982a91.20.1767843657139; Wed, 07 Jan 2026
 19:40:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de> <20260107210448.37851-6-simon.schippers@tu-dortmund.de>
In-Reply-To: <20260107210448.37851-6-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jan 2026 11:40:43 +0800
X-Gm-Features: AQt7F2oQUWxfwmKfkPMH58sXdUHRR1BABNg8c-gOhAXPWs9rnLQwCP9cTooUbiA
Message-ID: <CACGkMEs-V7g6fP418K3SmD-oayT0mGOnzPt-ynkNAjiSVfHppw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 5/9] tun/tap: add unconsume function for
 returning entries to ptr_ring
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> Add {tun,tap}_ring_unconsume() wrappers to allow external modules
> (e.g. vhost-net) to return previously consumed entries back to the
> ptr_ring.

It would be better to explain why we need such a return.

> The functions delegate to ptr_ring_unconsume() and take a
> destroy callback for entries that cannot be returned to the ring.
>

Thanks


