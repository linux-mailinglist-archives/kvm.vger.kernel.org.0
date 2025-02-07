Return-Path: <kvm+bounces-37589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07396A2C438
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 403D83AACC5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DADC1F6664;
	Fri,  7 Feb 2025 13:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKIVZl/D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A790D1F4169
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936671; cv=none; b=s/W8bSlPEyHK/F+Yqp63W85OtBHMLVGpfHbMJdAkTgPWAKjXILJll3bjsa7aJn1k1cTDgFzjIgRD9/pMAbyYvxWXMIrBIJo0e4z8m09VUsJKpXxgCCwv9o3YVAXdLbheGxGnrpZfkzVe/4dvKoMaT+YKvTt2K9UrdvBF81ssr20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936671; c=relaxed/simple;
	bh=AvB+TO610GIxTrxZQbtMCYMq/kPdbhY8cbsgLrA/yCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcKAhUpk/C21DxeBPD/px1zcxszOlfBnNvri9bEycWTsF13jHiRSj8/nmc41gymvzbJzEljL7uUauTsj9DnRUfVO/+DzMWfchSVqNtQa3J9iIFtKN1igVDjLl2d9+tqqYnFDMZSIfRni+sXHVb1iMlPT+y3j4QDkxwWREx7fB14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKIVZl/D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738936668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PsHyj/fLCDE0yHLr24iqw8kb0+9c5dcfAfqIhww3Y3I=;
	b=iKIVZl/DFcCfND1nGZJx9JNR2Y+Kk3eh1b7BcypJoFhp9i3DGwYhBhq/bdmZ2Yp8jQsy3/
	hMl6pjk872BAYGYjN+RsSIIoGQ2UfkwJSYM3LKBKLOhzpufkdvRrq+v3UJwhDVZGyZsnrr
	N1HRSNHGAZhBnbA06yrkCo9Tabyev2c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-ZcpKl4zROqeulNswUiWXQQ-1; Fri, 07 Feb 2025 08:57:46 -0500
X-MC-Unique: ZcpKl4zROqeulNswUiWXQQ-1
X-Mimecast-MFC-AGG-ID: ZcpKl4zROqeulNswUiWXQQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38dcb65c717so164634f8f.2
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 05:57:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738936666; x=1739541466;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsHyj/fLCDE0yHLr24iqw8kb0+9c5dcfAfqIhww3Y3I=;
        b=NfVP6YeqcGg5OPW78362tWF/xcFgTskmxyda0kIISiTs0XIS182plefCOfJADSLlYP
         NvEEB7kOXqgSbL1PC0Htx79TbS2JRL2PoMOT3GDtM0IK9ED/u3V2FDMPLPVhdtntwLlY
         W7baZHNrV6P0ODIGKnIqB5UjG0sqHJ5h0QVoiB3iW95gF8qiFom5xmEcpHNDIKbFXkzW
         Ckwry5tXsQ26lKO8vo3XF5KHPKo+fYUB5FA8cyf2P6LwamdoUGtI+OJWVeoPvnpcRcc7
         QliA7hm+D8/KQsrA7Koy/I7lbVu20T917VbvJ1LO9cmpkjOamWxQEYhub8HZcElb0OTi
         tgXA==
X-Forwarded-Encrypted: i=1; AJvYcCXMOTRQzmYHwL1v76AYwfxBf94cCwR9gOa9uz3MJdTaXHIkQSHg/3YNqv5iixBarDQhhvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvSpsMH4Zeqds4JgWM81aW6ipolrsm1y2tveMf4KduxqAsV2O+
	m3zgEBr1YM72IGczFIHtJa4EPld7A8hGm1KOsQM1HpNUb3mDfhxJCS/bVUXVodvxCa5U4C/ws1/
	w5dQFn2CiOvZyXlTslibEir2ygY2tgB8qBmbg/YcrboH7BkI7ZQ==
X-Gm-Gg: ASbGncvLkYfL46QKMIitHZ/ucbP/9gqfuR0xde+seZr+vnmO0RdumQ4IUddv6Ug9982
	o/IGFjTB34bqpAlyLNQt+tjx6VZ0c4hUUwgfcCy7YDfudAcZsa2kyqhddYfPGz6aGS4Hto7gNts
	71DG9kX0Yt0PEHKsWkRsSf80UhK/ezwvf1F9zzizs3riRHGNCuKuYoAmZTGECok5Kxhc7ZjhSYV
	zPy/5DO5XolZhrHGFf3ZK67djjOczqYp2jM1+CRDm7c7/WUGJfezARfCdOJbRPfSiXNFPVegto=
X-Received: by 2002:a05:6000:2a7:b0:38d:b448:65c4 with SMTP id ffacd0b85a97d-38dc959fec4mr2253430f8f.55.1738936665665;
        Fri, 07 Feb 2025 05:57:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHT1cPs98RF50Y1TuNvTB5/VxMgLbQiTzpp0lh8VKUOC6YGKJKhGf3sDx2eX0CHsInQ6Tqsnw==
X-Received: by 2002:a05:6000:2a7:b0:38d:b448:65c4 with SMTP id ffacd0b85a97d-38dc959fec4mr2253409f8f.55.1738936665222;
        Fri, 07 Feb 2025 05:57:45 -0800 (PST)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcd21fe18sm1380953f8f.91.2025.02.07.05.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 05:57:44 -0800 (PST)
Date: Fri, 7 Feb 2025 14:57:42 +0100
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Bennee <alex.bennee@linaro.org>,
	Akihiko Odaki <akihiko.odaki@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>, Bibo Mao <maobibo@loongson.cn>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>, felisous@amazon.com,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <Z6YRVrkEW87Jh6bV@fedora>
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <Z6SCGN+rW2tJYATh@fedora>
 <CAJSP0QXHG8Vj1EomaRRTfQWykR=9mWQ3SDWn0pCG-b_8rJuKcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QXHG8Vj1EomaRRTfQWykR=9mWQ3SDWn0pCG-b_8rJuKcg@mail.gmail.com>

On Thu, Feb 06, 2025 at 10:02:43AM -0500, Stefan Hajnoczi wrote:
> On Thu, Feb 6, 2025 at 4:34 AM Matias Ezequiel Vara Larsen
> <mvaralar@redhat.com> wrote:
> > === Adding Kani proofs for Virtqueues in Rust-vmm ===
> >
> > '''Summary:''' Verify conformance of the virtqueue implementation in
> > rust-vmm to the VirtIO specification.
> >
> > In the rust-vmm project, devices rely on the virtqueue implementation
> > provided by the `vm-virtio` crate. This implementation is based on the
> > VirtIO specification, which defines the behavior and requirements for
> > virtqueues. To ensure that the implementation meets these
> > specifications, we have been relying on unit tests that check the output
> > of the code given specific inputs.
> >
> > However, writing unit tests can be incomplete, as it's challenging to
> > cover all possible scenarios and edge cases. During this internship, we
> > propose a more comprehensive approach: using Kani proofs to verify that
> > the virtqueue implementation conforms to the VirtIO specification.
> >
> > Kani allows us to write exhaustive checks for all possible values, going
> > beyond what unit tests can achieve. By writing Kani proofs, we can
> > confirm that our implementation meets the requirements of the VirtIO
> > specification. If a proof passes, it provides strong evidence that the
> > virtqueue implementation is correct and conformant.
> >
> > During the internship, we propose the following tasks:
> > - Get familiar with Kani proofs written for Firecraker
> > - Finish current PR that adds a proof for the notification suppression
> >   mechanism (see [2])
> > - Port add_used() proof (see [5])
> > - Port verify_prepare_kick() proof (see [6])
> 
> add_used(), verify_prepare_kick(), and notification suppression are
> explicitly named. Firecracker's queue.rs has proofs for a number of
> other proofs as well. Would it be possible to work on them if there is
> time remaining, or is there a reason why only the proofs you mentioned
> can be ported?
> 

I though that those three proofs were the more interesting. I think we
can cover all the proofs in queue.rs during the internship.

Matias


