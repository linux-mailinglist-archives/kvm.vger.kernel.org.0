Return-Path: <kvm+bounces-32010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F449D10D2
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E8A8B26676
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C12C19AD90;
	Mon, 18 Nov 2024 12:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYawFjZ2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D866199FAC
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 12:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933765; cv=none; b=f4yrMy4JIYFQJDpXOtO2ZxRnDfVSJUV1lXWhBA7ZlU7IO+YYdiLZLrb3Q2MBQ0PJPok0c+nfaWB36qxaimnuhnKgE6BX9f/xxV+mEHXL8UA9CSlyhFfT7UNcyAgiM626v7YPmjqBSQFhZklmFEtFfOzSx27O19a1/e5QoME5TdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933765; c=relaxed/simple;
	bh=FCpTZ+OXty+6I/LwhoSAfoMCBQPfYWa97QmGJQZD/Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WpSlnRuRqmPeo0a2cHmKYCiElIq+Pet0leucpU4bKoT/7IQpLJKArHOJvWhdojRdI8m9ZpvwG1rJPYCHbAO1Rv1O8mC/bAJXQvLMFA6UzVXhSP5pE3CouGH82DwfCcds22jzgHtrTy77v8QBeCJCEJPmj/GmDC5dO+CMZvCvFGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYawFjZ2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731933762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7Sl+0ry/66y5Ln6cucWmrZ7ZUf6a8KZ/clf2OlUzn8=;
	b=IYawFjZ20nZt0S5Ddm0CE5sdrL58EKOPoM2NuebnKQdrUNWL5ueCFiMSFo7hXaq6oivQQr
	INnRSHwWt/tNRJPrgnlU+Twd7n2oknRyxVtKVPvfrQRxPdu8c4CrWCfh1WfSPT6pncvGf1
	6zVo1EZJDqIgKYMuEEW+xxo1PTg9f9I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-nMzGDO53NiORKLQgHGfVpA-1; Mon, 18 Nov 2024 07:42:41 -0500
X-MC-Unique: nMzGDO53NiORKLQgHGfVpA-1
X-Mimecast-MFC-AGG-ID: nMzGDO53NiORKLQgHGfVpA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3823d2f712fso823027f8f.2
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 04:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731933759; x=1732538559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7Sl+0ry/66y5Ln6cucWmrZ7ZUf6a8KZ/clf2OlUzn8=;
        b=XwjOJmmWOkWLyHCGqI2L3mgn/1ZzVR5Gi3O4pAEo8o899xDPt6miY4j5bgX77K9h8N
         coNg+SCaRJMLvJJSXicvtWXVtqGmHAEQ6xpI6gGpUnjwWnJjOdk6in6kTsONDuq+mmG6
         u/U/jDceSo6U12WdM8JaAXfg8Vx9dPxONDSp7FPA7N6Z2dJpo+0BTYH/6Shn9b9lyKKi
         wOjY6C+i8HwRtAA+wT1LqrljT5IydvHfyNaHotuRWDYrmjyJwqz7SggtRm8hA7ZLfDsG
         7HjK9zVXBZmcjQuJ+lZzMh+GvL+zLgM5cjpE336t/92gE3OZUc0oWfQBt/mr6n50Ymtm
         LPcw==
X-Forwarded-Encrypted: i=1; AJvYcCUuT5Eum1VnORvCz+QQKLIWC9i6WQeAK7DKQAgrWnnKwwLrf/RlDnoJhPGq8fTcWucVHEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+G7DHt0ZtA+2fMfm7E8b0QWw1B8LZLry3HOinp5yCVkkKzKFh
	eap7EMDh/Odkd99pupMbqBTmshSlN1H06/n02y9ubXNHk4Y45jh1t94xSYqKsxn9VbUgrEyK8gX
	LJV5+t6xdklkA0Pf8jww2WCnyH4B2K+H3oQMsVx+SbRJBoN79kNgAz9f8O1zXZ07IJW6n8gRQKa
	wX3CHCfsVQm3vaw4JOnf/f8iytd59UXOLR
X-Received: by 2002:a5d:5888:0:b0:382:4a69:ae11 with SMTP id ffacd0b85a97d-3824a69b1aamr1300429f8f.42.1731933759340;
        Mon, 18 Nov 2024 04:42:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1eUySvRKvHgaDBZuHDcttwQpLs5scn4ecD2wAoOE+UAhHhEQ3Kutp85qvyoc832LHDNr+gBR8RNIX+d3RGu0=
X-Received: by 2002:a5d:5888:0:b0:382:4a69:ae11 with SMTP id
 ffacd0b85a97d-3824a69b1aamr1300414f8f.42.1731933759009; Mon, 18 Nov 2024
 04:42:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <rl5s5eykuzs4dgp23vpbagb4lntyl3uptwh54jzjjgfydynqvx@6xbbcjvb7zpn>
In-Reply-To: <rl5s5eykuzs4dgp23vpbagb4lntyl3uptwh54jzjjgfydynqvx@6xbbcjvb7zpn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 18 Nov 2024 13:42:27 +0100
Message-ID: <CABgObfbUzKswAjPuq_+KL9jyQegXgjSRQmc6uSm1cAXifNo_Xw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 5:59=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Fri, Nov 08, 2024 at 08:07:37AM GMT, Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> > Since the worker kthread is tied to a user process, it's better if
> > it behaves similarly to user tasks as much as possible, including
> > being able to send SIGSTOP and SIGCONT.
>
> Do you mean s/send/receive/?

I mean being able to send it to the threads with an effect.

> Consequently, it's OK if a (possibly unprivileged) user stops this
> thread forever (they only harm themselves, not the rest of the system),
> correct?

Yes, they will run with fewer huge pages and worse TLB performance.

Paolo

> > In fact, vhost_task is all that kvm_vm_create_worker_thread() wanted
> > to be and more: not only it inherits the userspace process's cgroups,
> > it has other niceties like being parented properly in the process
> > tree.  Use it instead of the homegrown alternative.
>
> It is nice indeed.
> I think the bugs we saw are not so serious to warrant
> Fixes: c57c80467f90e ("kvm: Add helper function for creating VM worker th=
reads")
> .
> (But I'm posting it here so that I can find the reference later.)


