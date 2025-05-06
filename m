Return-Path: <kvm+bounces-45582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9511AAC058
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC013A78BF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F77269B08;
	Tue,  6 May 2025 09:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5Z4txiE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548862135BC
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524793; cv=none; b=SXJ20+VUQLjgFSSEuxyd36XA+ThyURszBsEKxh456gy8eclZU3vtOqhmJefyGrpRHgXbwZyVVfxjRJNTOgqsO9pI6yGIb150v1ac/yAmm7mGYd2zS0hjchlthmGU/2ilyiPG1YuA+9pqdrUkhVEQ6rO9IlZI2Ja9MjC4Gj0zdGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524793; c=relaxed/simple;
	bh=tA6N3YnyAi4SY4a6Jf1gNb1Di0YDjYwF9O0IKocrk4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iSeIVC0qLNkKM128pbew+MATbm0//QOjdLHfVnYRPN606cmiYh7xZqAT1EJfTmex0+wVfzqIk2dHQTlu/4IQKmGpuS+J1Za7jNTDkjGE5WfZdJOQXc9MmRw1Y3j83jRH8bKwqpLeuYs/jt5HW919FJsMIHnfaRYRSSOOLChlhzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5Z4txiE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746524791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tA6N3YnyAi4SY4a6Jf1gNb1Di0YDjYwF9O0IKocrk4Y=;
	b=Q5Z4txiE6zU5A1wtsG9LwyaJI9hrpzNCXjlw0QmLvRdaIaA0lmHLUW6v0JvR6xGUnjkQOq
	VvvR9EbW2pKx/FBROOAEkpcXzH6Cx1PPCg/Lln452ifcO+0Rv+D7cv78hlPOac5yghEieC
	WLGJHsg/swCtoc3hXYd42ZUhlpO1fCY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-BpjJvRfrMQidF2LD43fAbw-1; Tue, 06 May 2025 05:46:30 -0400
X-MC-Unique: BpjJvRfrMQidF2LD43fAbw-1
X-Mimecast-MFC-AGG-ID: BpjJvRfrMQidF2LD43fAbw_1746524789
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-703b2fa08ddso84828947b3.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 02:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746524789; x=1747129589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tA6N3YnyAi4SY4a6Jf1gNb1Di0YDjYwF9O0IKocrk4Y=;
        b=J5XtsPewHER0ezlHMHeOn8sziRAHTDdc44+87Mr6dDV+HxhCd+16soNip2Obs33lxB
         Dj4wbSTMcNdnjx+KqUodYue4DPnTmHtHIXA+LPRG/yf88wN3qllLoVLRzyM7WzBqrQq9
         j5xj7ATv7gswxXEnvb+zr2OaQp+KqHHwkcHjUH0MH2zv03GfIXgeVPwuwWLqd56V1wJr
         qTZTjKY2JYQv+llsfw3889uUmcY/mAmn+w6ExNWNw835j0KTEfTHMcIGHeJERQzVOW85
         0TZuIdCI9Z8rkP+gWrBXFOfaKTdZWW4Qw8zzZMcDocPLTJNgYTTbk1JXMLK/782hUY89
         cNfg==
X-Forwarded-Encrypted: i=1; AJvYcCXwwNJQsKfo3lsTQs5LZv0tS6sbB9D/f4+KANifxhtnLv/FTY/+yksMMqRTIsgcV2FYVbY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0RwM0hpjkfBaLMnDZeXseFySigylfbAB4cyBAxIxLSqsWPK9G
	YzoqNw/h/7lvDkqNFqjKr6K8Xbeqqdn1xCjqOZN9ESEEyIHKL4cLT5l7ezJweUNRoTr3i7oxbNE
	ape4ptCG0H5qdmni9PgpUdaZMmxrhxN/TejWrxC8neL2IZMo1l0BuVeEXtRlkHAMtFQ65e26+sJ
	lfWz+4Yitz5AAseqJrVxlxNUQ4
X-Gm-Gg: ASbGncsZe+HGji5Ze9J8r4m4Os5aCXcIRPTosqOfmLBPD9smWQO0nzsM8Esl//OLS4i
	AI30ypHIQlG414uyFlbsklWQE9ysaDvIk0qGbglnVCuzW4Q3kbojTQ7QpGtrd41Yol3MbaWo=
X-Received: by 2002:a05:690c:881:b0:708:b7c4:89d9 with SMTP id 00721157ae682-708eaed228dmr161341807b3.11.1746524789549;
        Tue, 06 May 2025 02:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8SnKlOiGYxAIgFjpIz/3a6Amq4RJJRae2tHMUWHhFAEAWBZQzJ97jvAOQKqp6vtJokq7tr543XXcIaZE89NQ=
X-Received: by 2002:a05:690c:881:b0:708:b7c4:89d9 with SMTP id
 00721157ae682-708eaed228dmr161341627b3.11.1746524789214; Tue, 06 May 2025
 02:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co> <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
In-Reply-To: <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 6 May 2025 11:46:17 +0200
X-Gm-Features: ATxdqUGB2JgQGBx1SBATpWkN34LfUWNEz6bg2h7UGX2v3-s9HEuTp1ypMzGQ-9I
Message-ID: <CAGxU2F59O7QK2Q7TeaP6GU9wHrDMTpcO94TKz72UQndXfgNLVA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 May 2025 at 11:43, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Thu, May 01, 2025 at 10:05:24AM +0200, Michal Luczaj wrote:
> >There was an issue with SO_LINGER: instead of blocking until all queued
> >messages for the socket have been successfully sent (or the linger timeout
> >has been reached), close() would block until packets were handled by the
> >peer.
>
> This is a new behaviour that only new kernels will follow, so I think
> it is better to add a new test instead of extending a pre-existing test
> that we described as "SOCK_STREAM SO_LINGER null-ptr-deref".
>
> The old test should continue to check the null-ptr-deref also for old
> kernels, while the new test will check the new behaviour, so we can skip
> the new test while testing an old kernel.

I also saw that we don't have any test to verify that actually the
lingering is working, should we add it since we are touching it?

Thanks,
Stefano


