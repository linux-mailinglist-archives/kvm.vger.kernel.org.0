Return-Path: <kvm+bounces-69220-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGZBKRaFeGmqqgEAu9opvQ
	(envelope-from <kvm+bounces-69220-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:27:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C493591B1D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 25E74300468A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 09:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025052DB7A9;
	Tue, 27 Jan 2026 09:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCqz1RWT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ta+TX/WF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3042D59E8
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 09:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506065; cv=none; b=Luyw0qU9OUPCTbJ4k+BwKdQqMuSEYhYay2vU/qQLAs+SvYae28s2ls5Sq6ugmzQitNHVcvGHbrlS+Gz3G1Emu3/zKnKO5Jx5T5rstX2irWxOz+nlKNQWknlnGPUVqbL0l3LmXUnpw2h16RMB3z+5FSw8txYN7muSZpH4qhhIE4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506065; c=relaxed/simple;
	bh=tLsY/tyc7yc8TndHHQBV6iZzg25eTDZlZKoX4qBHov8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xc8bBFu95mztl5KreLP1rjsfcMtO2er9tVKfIYQpWRK9GG7c5KWxnggCtc9bwxoSPpdZ34Naib13mOxpHBNXpzb8O3WP1dUCuKEKOSau62PxdIbw8+rXyOSULZO7L/XQNaOI0w/iCm4IVYQ3Xn6MDNi8KCDm3gPwX5VxiXvAf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCqz1RWT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ta+TX/WF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769506062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G5bG6PKsqEtorcKsG2IjxGd9y3gQfMI+PkhENIjujEs=;
	b=NCqz1RWT99L+SGIcXPKpC+E9IGG4q3eeTq01xEW25eRb+4e0UmN9SOcetyU57YsrW5qwVz
	PikjGyQJiQuh5skan8g2eBmzs9PNALozZeTkaYYuxjAcbstdy+pm5Ry3jnGSHSUI2FJWjz
	wCpbBouIZVpNV9nSSV9rzGhaK9eUno0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-UtMU0JghN66y2IjwPzP07A-1; Tue, 27 Jan 2026 04:27:39 -0500
X-MC-Unique: UtMU0JghN66y2IjwPzP07A-1
X-Mimecast-MFC-AGG-ID: UtMU0JghN66y2IjwPzP07A_1769506059
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47edf8ba319so51184285e9.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 01:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769506058; x=1770110858; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G5bG6PKsqEtorcKsG2IjxGd9y3gQfMI+PkhENIjujEs=;
        b=ta+TX/WF1vcbWVuXv2dFsH1WSCSfCSZ3nbh8Zoft1oz7o+nqG4cx4NueksJ1hONv9C
         Cfmth6/d9PVREpnDk00KTOP7ebawUbo6bJAA5TjQ2VWxSw5C6K6JXNe110Q2zInFkTbT
         vp4gRJVm4tGDP5l7Jg82hxigj5zRq84kVaSZWveCnnYG289x3DMyoFWSwMaFj30iYQFx
         xK0A1FdFKfu0XVik53xuUhJ8ZPbaYia8ZtHReX+g0jIan8YwR73vLCKFjHTv4yhaf5Vf
         J4wA2z4azHJnRWgKU+XNz+Y2QproOJYOcTgCXI+DJu71wFoMKzt2+w4V/EPz8FQxQ89c
         REpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506058; x=1770110858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5bG6PKsqEtorcKsG2IjxGd9y3gQfMI+PkhENIjujEs=;
        b=V4K7zbmnk5k1i8gL6PwEUoOp2H8EANLcZpLhLj8B7aT9sOmnwPY+a0/Ny63ySWnzWJ
         JAI9zqG7HZNDDnhEPX2hcsdsdspD+UWy/Snb7pqnOgwvSY9G635gCw57c2HtxUsjLd/Y
         f1j65aUTqj744aGNmQO6nbO9lCfPtGiHnwHyhWYyXzoY5aZbLWTWyo79gU9q2vv07ieX
         heg5UCuPNd4oWXTlmbUdtkj/q3ct2N7C6XuOQT0SCrFl4SJUSRjNExoGXnctTpssEUdK
         EDHYKuyl7LM86gxb0qJ9nTDlgDuOa4tA1JZ5xR33arokz4sXwp722cr6p0oJf1aWiJvo
         LUVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi9IhO82M2J8r0DXr7+nk7dMWRjqYxHdt6FiyNMeBK2ghFFi5u0y00SEqkN6HaRcE6dpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvgQlrvPQfnSKjkR0+1UxuNCbB9Mvj+n8yN+K/Y9gpUiieCs39
	NtDOFeeFIyeu78U/3wrNoQuvFwk+IcA8mW5L4YEPUzOdyCjV1BEQr+2/PH1aJbwTAwaId3cHbiA
	kPwqx+GINdH1/ILFY8NPxQ3QsLutqC4MockVSeuALEDn5OrWJxs9bbA==
X-Gm-Gg: AZuq6aKyJy8QxKAIc8Hi6M0EJisbUFxaJIjoSAVheRkY1C0N+BnNCxdvCvbx1bLfRyG
	UepiXigy2lehmsKarpGcdcrjGxaMmsWUqdRSzThoFHu2mR7/iSzGzLHnQEsxv2QLPKD5yXeS/2t
	pO0LTWQmq7L2r4AeMip+HRMt+J5YWjRH6F247XuXbFK13o0JSVPNE/CCHPcTFXtv4SMNo/JvrzX
	FP9uY3gYWRm1iQqmS4lDdJ2usJ14T0CkmrLeIi1aH9PGXlfIODXgEGnlgSbY6EED2nMnUXzl+rs
	867F0E1pc+tJFr50Tngu6o5THhBBGde7aYRNFj7zbf6k1V6d9/vgpzqqpxyw/9OF+hBzzeseJgZ
	JbT0=
X-Received: by 2002:a05:600c:8b24:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-48069c20e88mr15110045e9.10.1769506058541;
        Tue, 27 Jan 2026 01:27:38 -0800 (PST)
X-Received: by 2002:a05:600c:8b24:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-48069c20e88mr15109675e9.10.1769506058129;
        Tue, 27 Jan 2026 01:27:38 -0800 (PST)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066be7623sm47204815e9.2.2026.01.27.01.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:27:37 -0800 (PST)
Date: Tue, 27 Jan 2026 10:27:35 +0100
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Francesco Valla <francesco@valla.it>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aXiFBwcLg4PQ/4m7@fedora>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69220-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk,valla.it];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mvaralar@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C493591B1D
X-Rspamd-Action: no action

On Mon, Jan 05, 2026 at 04:47:22PM -0500, Stefan Hajnoczi wrote:
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code internship
> program again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email by
> January 30th.
> 

Hello,

We came up with the following idea.

Thanks.

=== virtio-rtc vhost-user device ===

'''Summary:''' Implement virtio-rtc device as a vhost-device-user

Implement virtio-rtc device using the vhost-user-device framework.

The goal of this project is to implement a virtio-rtc device as a
vhost-user-device. At the moment, there is no open implementation of a
virtio-rtc device, even though a virtio-rtc driver exists and appears to
be tested against a closed device implementation. This project aims to
fill that gap by providing a fully open and spec-aligned device.

The virtio-rtc device provides access to real-time clocks, such as UTC
or TAI, or physical time elapsed since a given epoch. The driver can
read the time using simple or more accurate methods and may optionally
set an alarm.

The work starts with understanding the virtio-rtc device as described in
the virtio specification, as well as studying the existing virtio-rtc
driver. In parallel, an existing vhost-user-device implementation can be
used as a reference to design and write the new device. The device will
be implemented in Rust and must follow the virtio specification closely.

The project also includes debugging interoperability issues, identifying
possible mismatches between the driver and the specification, and
submitting the final implementation to the vhost-device project.

High-level tasks:
- Study the virtio-rtc specification and understand the existing
  virtio-rtc driver. Also, it may help study the QEMU implementation of
  the rtc clock.
- Design and implement the virtio-rtc device as a vhost-user-device in
  Rust. Existing vhost-user-devices may help to get inspiration. This
  step also requires adding the glue code in QEMU to support this
  device.
- Build and test the virtio-rtc driver.
- Test, debug, and submit the new device to the vhost-device project.

'''Links:'''
* Linux Driver Series:
  https://lore.kernel.org/all/20250509160734.1772-1-quic_philber@quicinc.com/
* vhost-device repo: https://github.com/rust-vmm/vhost-device
* VirtIO 1.4 specification:
  https://github.com/oasis-tcs/virtio-spec/tree/virtio-1.4/device-types/rtc

'''Details:'''
* Skill level: intermediate
* Language: C/Rust
* Mentors: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
  Francesco Valla <francesco@valla.it> and Stefano Garzarella
  <garzare@redhat.com>


