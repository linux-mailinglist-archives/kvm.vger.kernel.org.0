Return-Path: <kvm+bounces-36673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3164A1DBA6
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D177164BB8
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D4818B495;
	Mon, 27 Jan 2025 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L4JMoSmf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C817BA1
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738000622; cv=none; b=WRJMFA12ZuWK0asu2PnsCliDhiTjIQmuLmiJ/65zGkiQogWv3TQSi1xBSxwgx7gRc+Q8DOkz0ONnX665Odk40eup87QWZKHluLmgFKSIm5AkbaS/23snftEttpLNCtHTn5GKo9xtc98USzR+BqeDMEbNYaruEQtHnTXDeO06+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738000622; c=relaxed/simple;
	bh=GjJWtudj7urj9gtoXG5rgL8H6XpZi5B2AahaP9pJFLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FOrJAMTmeLWTv8v4sVbNObNy5S7OGKZsZFyhTWcPmaQr6IcOk1S6ek/CgQkiIu+x3KvKAJUp73VD3Isp2xW4rLsdxlAjmjCE7XzJWrXLKFUDgmM8XLYioKlUsQM0KGNQ4sVN7Y5MtUL/Bg2U/NmNBmrfRgG1DfLMxPEfKUXznD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L4JMoSmf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738000619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3mx//7sRhuBVI9zi7biepjwiQsBU276jF+THS8OpTY=;
	b=L4JMoSmfaWKzwUnPghxdKyFHpEhFt00ZNUbD6uTzgP8hlI+VY+oqzr7JJXHCYpbsnV5/bt
	LFMZswP+NL92EDjwnJfI+zBOt6omZpQtfKxHOYUjyzbRPNF3CbtJxxdZndILKzZg1cRTx3
	jtqyg2S0q8Vc3YHnY5jLrZnuCvaXvsg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-CLmB1qvbMPGy1I9TPAxJ4g-1; Mon, 27 Jan 2025 12:56:58 -0500
X-MC-Unique: CLmB1qvbMPGy1I9TPAxJ4g-1
X-Mimecast-MFC-AGG-ID: CLmB1qvbMPGy1I9TPAxJ4g
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38c24cd6823so2509099f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:56:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738000617; x=1738605417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3mx//7sRhuBVI9zi7biepjwiQsBU276jF+THS8OpTY=;
        b=vv/6oKHKmu1gzuqTsKjwJHoKb2w85QxeUpkn55O1I38hYuf2xZKhWKp7cIqusB559L
         0Y2+23SLKTU7y2USN1uhrHpGjz65SK/lUtpuWGlLFyMLL+WbpUtlzKkXe92m3cY63IqY
         dFWE1MxfGXPBv1o8CeTF8/59M7CrqHUttQRy61gFb2uUhE1+rJ7cf6rR64Yd0lLtIsFg
         JQUcG1lS3LDcHKOKQGYWh+4F/RbIs2sZEbSP8VsPFLnpxJdCKw2TckbXQEgLAFqqKAKD
         K9EQSwAj1p3J7LBT6dTKcvPxLxeGP8nrgae0Yv45HZ+9BAMYGC2ZkHHhsBZK2hZfdrJy
         ckXw==
X-Forwarded-Encrypted: i=1; AJvYcCV+yelT7dLhogsY6PSpJQLLM5ZnTfc5m+1LWer5erXO95Pt1g6lIn3FPHl+ioQvIYqHNCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/n1QeMvRZTDMpXAUcwJ5UpIA+gE+KTFMlAVDnHE9mnynK4X0i
	hgBl/PpsnmIqpjV8J3euO0rgXz987v/UiuD0AHUhui9fQfTvGD75weAT8Wn/UAtLMhJFJMQA9is
	NRn0XjSeubJfpxPeJ68b0jpKnlNxy0RFRU7VE8DCjw0XSbVQZK60U/pCgPqaBKq4N9OZ7MODlOa
	IPCBLL299OrKShfIXK8AeBcctK
X-Gm-Gg: ASbGncst/WY2vHx0R9zDDQR4WxXwSqRI9HRYjM7q3uPXaWruHvN7zmg9ttVt6n543DD
	VSs2BVqdXdePKPKqyg7WY7fVdwTd054YGz5eXcWzreEr7AAzgG+HXpyKyOpVE4w==
X-Received: by 2002:a5d:6d09:0:b0:386:37f8:451c with SMTP id ffacd0b85a97d-38c49a04f5dmr234792f8f.1.1738000617191;
        Mon, 27 Jan 2025 09:56:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLfWQ2zX9F7JSM7/WmU50ENY8lafjIf3RI5BXO2gRzRW0rQeii3gtzUUv9mzucjUJE0PyioSY+r4a9P25y9Lw=
X-Received: by 2002:a5d:6d09:0:b0:386:37f8:451c with SMTP id
 ffacd0b85a97d-38c49a04f5dmr234778f8f.1.1738000616909; Mon, 27 Jan 2025
 09:56:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com> <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
 <Z5Qz3OGxuRH_vj_G@google.com> <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
In-Reply-To: <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Jan 2025 18:56:45 +0100
X-Gm-Features: AWEUYZljlZn6cO-aIciDOlHcREhx2FirtSnkrgpb8vQRarMquYltbzBit-Py4n4
Message-ID: <CABgObfb-Q-fgruhEHutdmD00UYtD7mJBsOYhW5Tf4y-Txhr2jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 6:27=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> On Sat, Jan 25, 2025 at 1:44=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > I like the special casing, it makes the oddballs stand out, which in tu=
rn (hopefully)
> > makes developers pause and take note.  I.e. the SRCU walkers are all no=
rmal readers,
> > the set_nx_huge_pages() "never" path is a write in disguise, and
> > kvm_hyperv_tsc_notifier() is a very special snowflake.
>
> Likewise, kvm_hyperv_tsc_notifier()'s requirement does deserve a comment,
> but its specialness is self-inflicted pain due to using (S)RCU even when
> it's not the most appropriate synchronization mechanism.

... in fact, you could have a KVM_CREATE_VCPU and KVM_RUN after this
point:

        mutex_lock(&kvm_lock);
        list_for_each_entry(kvm, &vm_list, vm_list)
                kvm_make_mclock_inprogress_request(kvm);

because kvm_lock is not enough to ensure that all vCPUs got the
KVM_REQ_MCLOCK_INPROGRESS memo.  So kvm_hyperv_tsc_notifier()'s
complications go beyond kvm_lock and the choice to use SRCU or not.

Paolo


