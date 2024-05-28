Return-Path: <kvm+bounces-18224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A11FE8D21C5
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 18:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C586D1C22356
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 16:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1800D172BDA;
	Tue, 28 May 2024 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsD4YR7O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D723317106A
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716914323; cv=none; b=HxURw6j/1KaQyMywFV4YBqKGkC568Gqc3xsdd/nxEgycHCpFPyXwjubIkY6ehA8Co9golLBXGLdo2zEWyDfXQ15/rS3id5UO3qC1BwarRh1xy9l4A/0I60bQunJQgFh2fkANYGaDVKGpEWl6xtN7VyecufGLahPT8D4mXHQKIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716914323; c=relaxed/simple;
	bh=vLN2BaDwrlAwuwEYjaJlHgtpy0dmxixTxudu2ogMhPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q+ygIE+5xAjP+LDmTR41ttpeoWlh9wQPHkam9a08iyIAgQZbr2mmB5fNfo1uBm+CA4SwCiZu8pZyCl9N2zWa6J4gEt7LF7Mf+wV4QKrSvQkdIzW4AZh8n2nCdUWYcyRTePLvEz5CL1EI/G0sJJ0WI6RYzPVQKYPVvPoyymZNylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gsD4YR7O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716914320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vLN2BaDwrlAwuwEYjaJlHgtpy0dmxixTxudu2ogMhPg=;
	b=gsD4YR7OAfvPQGDTlLqbzG8fRAWh7agwQ061ZKdo3RGeZvC7L09f9knaWq5jh/GbMPy5s6
	WygNHe4Pj3RMelY8TimC6G2Mfp1ieY/C/fzK4d7U4tDdsyWHaI6ystlozt/qUdPYRretoQ
	d38+9f1WJRtgrLYDY57NKSq8qTdTvKk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-pNLsJ5moNlaK9LHG91vTdg-1; Tue, 28 May 2024 12:38:38 -0400
X-MC-Unique: pNLsJ5moNlaK9LHG91vTdg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-357766bb14fso633935f8f.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 09:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716914317; x=1717519117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLN2BaDwrlAwuwEYjaJlHgtpy0dmxixTxudu2ogMhPg=;
        b=ZLjDA9zsb5yMbuuhUGRxH6cO5F8KepAWN2AjFfNz8E/nYfdH6xvmrXt2x1PbqqzKw6
         ba0RDCtgc9dsPgQGK+H/mmjiKDmcR86VwHguWfbVlVA42yS1cU+mhu1ZMT/EAmzchGqL
         9+gNUF++uSUhJm/1N2BCUbQyOpXdEIxQrdT2+wCIeL4TwwnE+wpI9BBh+sJQKqIW8e+h
         lboW/C0UQnjlz9CG5kxQpgYMzs6xxd6I8p9X8EjbwKyLb7Q4GeMsno+P6tqQuALmPzLD
         NXpUaed1c2YU4dbayC29v6phmlShyvEfaFzfLpnPWAIDWHQcOsMH55vQ0yetxTMRm4j2
         hbjw==
X-Forwarded-Encrypted: i=1; AJvYcCWLmLTUnDq57Er/RPQ9iM1wAL41wjWjaAWDEMG6OvaEyY/L7kEGJi0LHp+eEpY0iW4GSWkygBabUdhnY2lchOA9j7bY
X-Gm-Message-State: AOJu0YwQgOIu2elGKmaDsiYPHY2z7yvRGWCdvhnduAdOSNsYW7g4hZzg
	3HAdF0oJpqbwC5lwZLU8s3LU6eZrXc82jjQYEqZmLM/lHEjSDdqwJIJAp0XP8UarBJdL3b64AzG
	sFCMstKL0/C3WYvPOjMJKiK3F6sGrTmo0Yl1KYqj5LQYD01B3g/LjqqyyATXdELlOiQglXZC80N
	wQtk58f70KNbYo5ZaobzN6p6F5
X-Received: by 2002:a5d:4485:0:b0:357:7ae3:2de4 with SMTP id ffacd0b85a97d-3577ae3329dmr6214037f8f.26.1716914317206;
        Tue, 28 May 2024 09:38:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk5arn3m/7l032st6t5757/0oqsN6ZwCY+wuS7zQHVrYlAnd9RQ4SAOuKxztBIeXVlao5+naAjeWSM6dN+80M=
X-Received: by 2002:a5d:4485:0:b0:357:7ae3:2de4 with SMTP id
 ffacd0b85a97d-3577ae3329dmr6214023f8f.26.1716914316802; Tue, 28 May 2024
 09:38:36 -0700 (PDT)
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
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com> <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
In-Reply-To: <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 18:38:24 +0200
Message-ID: <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:53=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Tue, May 28, 2024 at 05:49:32PM GMT, Paolo Bonzini wrote:
> >On Tue, May 28, 2024 at 5:41=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> >> >I think it's either that or implementing virtio-vsock in userspace
> >> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999=
979@redhat.com/,
> >> >search for "To connect host<->guest").
> >>
> >> For in this case AF_VSOCK can't be used in the host, right?
> >> So it's similar to vhost-user-vsock.
> >
> >Not sure if I understand but in this case QEMU knows which CIDs are
> >forwarded to the host (either listen on vsock and connect to the host,
> >or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
> >involved.
>
> I meant that the application in the host that wants to connect to the
> guest cannot use AF_VSOCK in the host, but must use the one where QEMU
> is listening (e.g. AF_INET, AF_UNIX), right?
>
> I think one of Alex's requirements was that the application in the host
> continue to use AF_VSOCK as in their environment.

Can the host use VMADDR_CID_LOCAL for host-to-host communication? If
so, the proposed "-object vsock-forward" syntax can connect to it and
it should work as long as the application on the host does not assume
that it is on CID 3.

Paolo


