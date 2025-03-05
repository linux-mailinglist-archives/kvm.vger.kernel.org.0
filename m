Return-Path: <kvm+bounces-40167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE21A503E9
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 16:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4B2B3AEDC7
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE8E250C0B;
	Wed,  5 Mar 2025 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIvVpIET"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6611F5826;
	Wed,  5 Mar 2025 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741190080; cv=none; b=T6CyYGT1ZQy9e5j+fV5PgdyEAeq8iSzoEN+/Lmhsbtf/s0B8CKZXrrNYhRGKZam7fjCHNHesYEnda0JKb+mqJ/8dNsYHQ8v4ob8113cN3PkNOTltl47cz2JHLEiurnQymfir7ULYwPiOha/pQdJpn5JK06DFchdBFwW1NyjcSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741190080; c=relaxed/simple;
	bh=ruhS78A+AtEtKl22culYdzmPSc1jjG/Tbxd9IG/FgJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBu0zl3K5X8VHpHjMJDTxyn9Adt6AfmXtWMNf5ZO0NKVLQrVl+LqsA2rupqK/pz+NbqNYra5SW2XG4fPRS0ynujU9X+OU0oYujB4yn59CUCHJSpjsavtlv+wZcvAdFmQhsx6ADUoXT7BEqnpn6FkJDHkzgfhsBogAoNIJsMfHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIvVpIET; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22403cbb47fso9644125ad.0;
        Wed, 05 Mar 2025 07:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741190078; x=1741794878; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+vIc0DMsQO6eS51lnk/KHT+RqFvDL3u0FZpOodk49SU=;
        b=DIvVpIETOg0tDGBa86hGjoc4lYTlUjjBO67yZRuDF4rbhF75s3xLeLqzzve63eQEP9
         0bXEKwErCy8ggFEa1Ud0LvA6t9S5SvFtSqUEGTrjILrojIKqmDCe0BSbpZBXfKGZrZkv
         UKDcQIKZzCtqOw0PqQ77op9nEcV8CS7N2JcnBktArjsqd7HqdZzvbz/r9Isb0t+fxgPD
         o1EGYo9OX1wQ7cXfpw2AU0rg29G9j2wyJP2XMUJBiTmmk77BbVyKfDMLTy3Jv/cGd9N4
         4btnh27xTW8cB7lFthvX89D7VdrldxXyT9eKhBs17vq/qwWFdSX9Gfi3a3KoGegIHgwJ
         IjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741190078; x=1741794878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vIc0DMsQO6eS51lnk/KHT+RqFvDL3u0FZpOodk49SU=;
        b=lzwC8fG0xZdAHAhsbkbeVNjpUE9e92J65zsKZbTK1xVPbr36B2eD9q6CTi3/gnRojq
         KYs+8cmybb6vHGG2d0KvW9Dh6dHOXYNwk7GDHIzV2g37kgfNnAMCAKClYSz5DhkOYW7E
         5FlyOmgt5soCZZ6d9Aax4x+Oe1eRc5NyFnhAqw8+svT7wNqWaU+cFHJB4mZP0h8PpZSu
         6+6TcZcZYI+3/3+5fCR+ihh3E31iH96Rlcy0neUHbRsm839vE8p40Ai5+O37PGIPsGDJ
         lqLZc9egO1tkXClKtgfUtKy2V7OYM2BHC4w6PXW655ILZ0dXVui+ySaDovPWd6yf/VcE
         F4Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUIS1tqKVaawdcgagSY6/7XERpKZsUtRkLwKGWFQOiG8VXLMyvF+Jxo7ENsxGEp1M6Gde+GsDfBwaQNFo1w@vger.kernel.org, AJvYcCUoM7K2Q1LhPuOO4w9AtXYaANHRvV8E5v35NHg8JN/0M/d2qGJXyuV5w65lOxUXoYu+uUSlfj09@vger.kernel.org, AJvYcCVTRM1EjDLiSTDluD6Slty8J62pq5Y4Dm8x5xRdGf6lgiebMje/22gYet7Ez8ygLv+44ms=@vger.kernel.org, AJvYcCX3AU/X+XwzbOyP6ba3xF6lLsGn/Tkfe5oJqh3P+b1VYi4XTTcE0PRqDm1GrWhq24l+o7p67WsGkMiFJVQM@vger.kernel.org
X-Gm-Message-State: AOJu0YxjZ693eUleTyYRr1EujH/XVOQvkDHVquQsxOkfFrtlxAC5LFZU
	qD1R2XPzHCRUCguIi3+zgoYUPXmVUUdi8/bVd6+VP0+5etB5roka
X-Gm-Gg: ASbGncsOhHuGrxQCyhlJgKzI06fDhL62UMFCwjxciJZspR9bn0Nxf1FP283dxB8MkwU
	I75fkotIqemeFYWZNfjgC9Xwh2bzD48nYTNQw5Z7p8b47nfbk/fWR/BN0fXrB3BJLpJw5K+hg+3
	ySa9HGH55Oe6+44gex62cl35RWLbBvk9yF/nkn4ZemURBBAp4D49wYa7s8vU8n7OjbNJsXz2LuS
	qfF6LRE8IS/kQuWoOiM/pnM+ELrfD3JDRgeNaNRp7EM1pEBj8y5wK1wk+6HemxwBT+WRyKKI80+
	vYcrrHtlh31EM9ATU4/IWpFbHvwU9ig/HRtkHfacCcP7CSauT+vB7XrVi5TIHiNTHQ==
X-Google-Smtp-Source: AGHT+IGxwYNgRJxj/Y20mv0OZbh6G4d3argbKiFxAPkI+V5vuufD3HZdLhPGHXdzRe1CMg/k0x2Reg==
X-Received: by 2002:a05:6a21:78a8:b0:1ee:e58d:aa67 with SMTP id adf61e73a8af0-1f34945f651mr7240995637.8.1741190077952;
        Wed, 05 Mar 2025 07:54:37 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af15490ae3csm9391147a12.78.2025.03.05.07.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 07:54:37 -0800 (PST)
Date: Wed, 5 Mar 2025 07:54:35 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <Z8hzu3+VQKKjlkRN@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20250305022900-mutt-send-email-mst@kernel.org>
 <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>

On Wed, Mar 05, 2025 at 10:23:08AM +0100, Stefano Garzarella wrote:
> On Wed, 5 Mar 2025 at 08:32, Michael S. Tsirkin <mst@redhat.com> wrote:
> >

[...]

> >
> >
> > I'm not sure I understand the usecase. Can you explain a bit more,
> > please?
> 
> It's been five years, but I'm trying!
> We are tracking this RFE here [1].
> 
> I also add Jakub in the thread with who I discussed last year a possible 
> restart of this effort, he could add more use cases.
> 
> The problem with vsock, host-side, currently is that if you launch a VM 
> with a virtio-vsock device (using vhost) inside a container (e.g., 
> Kata), so inside a network namespace, it is reachable from any other 
> container, whereas they would like some isolation. Also the CID is 
> shared among all, while they would like to reuse the same CID in 
> different namespaces.
> 
> This has been partially solved with vhost-user-vsock, but it is 
> inconvenient to use sometimes because of the hybrid-vsock problem 
> (host-side vsock is remapped to AF_UNIX).
> 
> Something from the cover letter of the series [2]:
> 
>   As we partially discussed in the multi-transport proposal, it could
>   be nice to support network namespace in vsock to reach the following
>   goals:
>   - isolate host applications from guest applications using the same ports
>     with CID_ANY
>   - assign the same CID of VMs running in different network namespaces
>   - partition VMs between VMMs or at finer granularity
> 
> Thanks,
> Stefano
> 

Do you know of any use cases for guest-side vsock netns?

Our use case is also host-side. vsock is used to communicate with a
host-side shim/proxy/debug console. Each vmm and these components share
a namespace and are isolated from other vmm + components. The VM
connects back to the host via vsock after startup and communicates its
port of choice out-of-band (fw_cfg).  The main problem is in security:
untrusted VM programs can potentially connect with and exploit the
host-side vsock services meant for other VMs. If vsock respected
namespaces, then these host-side services would be unreachable by other
VMs and protected.  Namespaces would also allow the vsock port to be
static across VMs, and avoid the need for the out-of-band mechanism for
communicating the port.

Jakub can jump in to add anything, but I think this is the same use case
/ user he was probably referring to.

Best,
Bobby

