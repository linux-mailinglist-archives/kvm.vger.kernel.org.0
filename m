Return-Path: <kvm+bounces-57180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6678AB51169
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 10:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 952F11C82103
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 08:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A7130F544;
	Wed, 10 Sep 2025 08:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsv8WrFj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9B02DD5F6
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 08:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493269; cv=none; b=u6/ZQvs36t5C2MOr2K5kEGE0JB8zNhcQ5dWJShorMriLKsE1O0cz8sy2c4OerQi5BWVgTuwS7G3yE2VDZ3fM3ZQzXTPMDNQg/OwV6GGDb548ZoTRBjPjq8cSUwXrZaGr/iH/F90Pi86FEQ1pppUgubo8jkpaiJLqTquFst22A6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493269; c=relaxed/simple;
	bh=uNe1ei6a9Sb1+j34arhysm88BnViKlUeFkNkrxOClGI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BaX7EyRRxGwodd3gbXBEx7+CefeLKcZRIsfftMK+RtmG7uTiWY90SFwB+P57c/tuPfZFs3nDknBDObsqNzklqqJpwhE9btnmmIiUQxNWwonb4EO9Q4e/cCJfizbPvvpCMSI3Uf9Hh7qCpxQ9GYmT3Y0a9rRjUh1i8Tkyy8doGkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsv8WrFj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757493266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Amy5eP+TPpCVu2gnynuIcytRxwDWLIJGmgKp9e+fkkw=;
	b=dsv8WrFjx4LdKmEP3g5C0CDDTusgewbMPoTZHDDk28ChIQ4tVmkHLSKSt2oa5eMyWtqwX3
	g7bDLxEftOO/ReO+nsbnzBi+OWTw6d3qIYbDOeTyuq1bqolKb/UMoC2wylTm4FtHzmB1E3
	3TTd1M7DuJWfkCdn/B7Zhckq6iGL9d8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-fPEcdHMWOViXl57xXIxGwQ-1; Wed, 10 Sep 2025 04:34:10 -0400
X-MC-Unique: fPEcdHMWOViXl57xXIxGwQ-1
X-Mimecast-MFC-AGG-ID: fPEcdHMWOViXl57xXIxGwQ_1757493249
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e4a8e6df10so2176995f8f.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 01:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493249; x=1758098049;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Amy5eP+TPpCVu2gnynuIcytRxwDWLIJGmgKp9e+fkkw=;
        b=s8prfEObF7YucmESscCwtS3qtozJJiotltvV3Rfl1rYx/Nq4ZyRtTycZIp4uX4yAHt
         kLdHLxA0/LsYbA8TMlmznrvDgkulZSHZjX8TttaI5FHwF7udWJ/gO1tT2JwIveRgmmY5
         rT+01ad3BobFHXnlZHGfM/89L/AEE3mbFBzzBhKJUyy9vnskBQNmL8yjhPVKfdw4Y5np
         AwZ0xxzO4dO+EhgujgTc9JuFjeNeTfw1Melz+WwWwdM44d/o1+nLshZzANvTNv32kI1j
         4/6eRKektKg9s2IfJ9uIz4UUmWXmeN3WJbEFl/tRo5prdMS5EBY6sGOcVyeMifEOnVOl
         Cs7A==
X-Forwarded-Encrypted: i=1; AJvYcCVcsysN22D194XoQosmk3dVjF2EdQGCn/L7BKJnLFU4cky1beKoXO5E/1HB34WCpnbIM5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvwjLkqkOn6n/oVBOIGa1ndpAasDM7x11IQhZWYm/3r3HNXsAX
	tKr0uP/oZME41Ld8BWM4NQ+Dr6b700hnPq6lP/XPz8W19T+p95b18W0Kppi9VN29YqUiuRkFih9
	ID5hl4pyH0URGJZEGGQkCHU9eyD4K6sbimDgsRzVVz3tTQPAagMtuCQ==
X-Gm-Gg: ASbGncv4O1al0+Uvcf/bZUhphj8FyeKqDq+fg+SXfhyxNNpjgTfdbXWBUVWgfE5dIOf
	S3Zy6uPwSPoLSqSewGnjnW7sxYhYEvjFHYkw0h2lfaXA4rs811grQ3swPyt7QeeQtd6lTYCulu9
	2UW/Dd9FkC/UwoCPWLt+rG384BebZ0R8Fiki/nKg8SUQQoow0S76SNSr4lypCG3O8X7lMji7h2N
	a5p9N7Z2wOsXSVkmy+UhM32lMqMBEfOPqWg36rtW0RhP5ye/3jq4wEt2puKbFffX1cGnE20UIYy
	4MEZ49IZ0kzlZD5MNsz+ZKmZhx64vxruQoY=
X-Received: by 2002:a05:6000:2405:b0:3de:daf2:edca with SMTP id ffacd0b85a97d-3e641e3b009mr11927990f8f.21.1757493248831;
        Wed, 10 Sep 2025 01:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEESRtO3VhGKSJcJh71t22NBy80LBauADrI4j1BdKqoBklXHwQ8jjnI6nP/m8EGktQBpwx0Kw==
X-Received: by 2002:a05:6000:2405:b0:3de:daf2:edca with SMTP id ffacd0b85a97d-3e641e3b009mr11927965f8f.21.1757493248419;
        Wed, 10 Sep 2025 01:34:08 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bf85esm6098839f8f.1.2025.09.10.01.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 01:34:07 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shaju
 Abraham <shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
In-Reply-To: <376ABCC7-CF9A-4E29-9CC7-0E3BEE082119@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
 <87a535fh5g.fsf@redhat.com>
 <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
 <87wm69dvbu.fsf@redhat.com>
 <376ABCC7-CF9A-4E29-9CC7-0E3BEE082119@nutanix.com>
Date: Wed, 10 Sep 2025 10:34:07 +0200
Message-ID: <87ms72g0zk.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 8 Sep 2025, at 5:12=E2=80=AFPM, Vitaly Kuznetsov <vkuznets@redhat.com=
> wrote:
>>=20

...

>> Also, I've just recalled I fixed (well, 'workarounded') an issue similar
>> to yours a while ago in QEMU:
>>=20
>> commit 958a01dab8e02fc49f4fd619fad8c82a1108afdb
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Tue Apr 2 10:02:15 2019 +0200
>>=20
>>    ioapic: allow buggy guests mishandling level-triggered interrupts to =
make progress
>>=20
>> maybe something has changed and it doesn't work anymore?
>
> This is really interesting, we are facing a very similar issue, but the i=
nterrupt storm only occurs when using split-irqchip.=20
> Using kernel-irqchip, we do not even see consecutive level triggered inte=
rrupts of the same vector. From the logs it is=20
> clear that somehow with kernel-irqchip, L1 passes the interrupt to L2 to =
service, but with split-irqchip, L1 EOI=E2=80=99s without=20
> servicing the interrupt. As it is working properly on kernel-irqchip, we =
can=E2=80=99t really point it as an Hyper-V issue. AFAIK,=20
> kernel-irqchip setting should be transparent to the guest, can you think =
of anything that can change this?

The problem I've fixed back then was also only visible with split
irqchip. The reason was:

"""
in-kernel IOAPIC implementation has commit 184564efae4d ("kvm: ioapic: cond=
itionally delay
irq delivery duringeoi broadcast")
"""

so even though the guest cannot really distinguish between in-kernel and
split irqchips, the small differences in implementation can make a big
difference in the observed behavior. In case we re-assert improperly
handled level-triggered interrupt too fast, the guest is not able to
make much progress but if we let it execute for even the tiniest
fraction of time, then the forward progress happens.=20

I don't exactly know what happens in this particular case but I'd
suggest you try to atrificially delay re-asserting level triggered
interrupts and see what happens.

--=20
Vitaly


