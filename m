Return-Path: <kvm+bounces-18219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E45F8D20C3
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE9AC1C23306
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D50171E43;
	Tue, 28 May 2024 15:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mr3Axsoc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDDB17083D
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716911391; cv=none; b=jhz0o/fw9zEbFhwS1euIF9FY8r71XWNlGCkKVYhutLKRnDq0xsnaS7OU+CxIazigtZYfzpcALeG/jXqf30+zneqcXBNC1S/iFtuRnRjv7dZ1YP26ezq70oTmCwLvTShOjvPFDXC78X0WEYgjnC194KFkhKROJMH0miD2sO342ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716911391; c=relaxed/simple;
	bh=c4hNFaaUxcqmTZpAMo2fGJsEC6Pif7b1WYuVmqit/UI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iNDC1RzzFkBsfHbKL9W1bAkDQgbR8DlIIPwqtG6ANdYsQs3Ajhk0PpBnhdzrqbR0l8/DUUi5svufXFuy7sU+pqA91diis/QhXy8Fysp19nGA4eEWM0aqDA3EJ73oxW16UqifxlxsHN7HN3ebe/O+j8xEmSquQC8t8npwGDRo+dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mr3Axsoc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716911388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4hNFaaUxcqmTZpAMo2fGJsEC6Pif7b1WYuVmqit/UI=;
	b=Mr3AxsocP/SyJyAu1dICvLg1fsdypORSJYr5i0WnT0Rw9BOpG4nx/SFe5aNaHxYRp3nqHT
	bWWNJOKozeuXLHHgxaDu7kDlKzFRDxNiN8LPG0JXNghvGVWTb4e51GOo4JKilcXAGj4Ksk
	VDVQyU4+DJXtN5He7bbh51R6xH2ZmJ8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-naRXETQKMO-53ZQ_c-scjQ-1; Tue, 28 May 2024 11:49:45 -0400
X-MC-Unique: naRXETQKMO-53ZQ_c-scjQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35858762c31so931382f8f.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 08:49:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716911384; x=1717516184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c4hNFaaUxcqmTZpAMo2fGJsEC6Pif7b1WYuVmqit/UI=;
        b=VJM+3uhuUjNjxqplBX/gfWEe1WPjspk4S1fqtxOUtQvbhao3NcZX3rJS/j6qBFkXWK
         KuglzUY/mDF/Nr50OqL2sbzSP8rlSGsooeD+aYNnmL86L/oKRMxeqhVT+9xGU50U0GrL
         +e2fCUY0Lz4uSp9+afpXry/UuGE+k1BIGqcCE94IQhQ0uerRBpXR21KJGpbwT4vbv2WC
         7Mj2DPOuNgE/teJo3RurkkmwfocXEcv2VBowtt00oVi0PH4L5l9EABx62EjvFfi3xUC4
         3+lYNOn3QL4nyFVoD9L3HAxFzkBPFdBJC0UWhR90KUDcNa6qoXg6Lp3pHPL2WiSxkuDp
         4zIg==
X-Forwarded-Encrypted: i=1; AJvYcCXuLQvaFz2dsmQ0JvPhk3R3dkmotYGx9WJ4sPJNnNOK72RURSUnhO8D2fNtjKze16iNIyZ4BuRP5DLjDfhFnu+MiHp4
X-Gm-Message-State: AOJu0YwMU73ytK9O9GXhJVI7+mCZpRY52mACy/xJHXE+tkSQQOyUvUQK
	XC9NAKms0tpBC5VugfBufmEL6k/e1YiyywGHqdlCOHocfH0sdSRm8PnIY/Yn0T9dxaVUZ75cl5l
	5wDMTb/JiZp1d3A/vJbmjNLcXoJYDIwnOfMUsYv7ALsR/Xb6VYFQkmZaXsmcCYsykoMbqvEcS+c
	01NlfhnO4LOKI2tqAlzpDAG+fm
X-Received: by 2002:adf:f1ca:0:b0:351:dd2d:f691 with SMTP id ffacd0b85a97d-35506d37f73mr11742420f8f.7.1716911384292;
        Tue, 28 May 2024 08:49:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHC6uavvPg89C5v1Y+wUvxKmHotTQ1vuBM058XRtM3p7GiYb/OQ33hLG2GVUL5ot4l7CgfZAW4f3N3gghhlS1E=
X-Received: by 2002:adf:f1ca:0:b0:351:dd2d:f691 with SMTP id
 ffacd0b85a97d-35506d37f73mr11742391f8f.7.1716911383859; Tue, 28 May 2024
 08:49:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de> <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com> <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com> <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
In-Reply-To: <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 17:49:32 +0200
Message-ID: <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:41=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
> >I think it's either that or implementing virtio-vsock in userspace
> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999979=
@redhat.com/,
> >search for "To connect host<->guest").
>
> For in this case AF_VSOCK can't be used in the host, right?
> So it's similar to vhost-user-vsock.

Not sure if I understand but in this case QEMU knows which CIDs are
forwarded to the host (either listen on vsock and connect to the host,
or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
involved.

Paolo


