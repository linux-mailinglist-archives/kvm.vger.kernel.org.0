Return-Path: <kvm+bounces-58894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7994ABA4B9D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61F481C22887
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515901D86DC;
	Fri, 26 Sep 2025 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoWTEHTR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027D9307AE9
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758905796; cv=none; b=iT84WRBsXMDmY6J2VRWKZdfewh2QAeipL3p0IAYrnGIvrbCCvyx2kI1AFG5CrA4vMEqVUFwFyGVsJE1rVzZHYPvPONUDWbBbv0HuyRBBK46/eUguFsCSlGJimNwSwtMdnTylfR+rbzPzajh1LhXAiJKIJOpbfcvkXWyjt3CoOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758905796; c=relaxed/simple;
	bh=pXbsgR7Ss1aZW3LlfLUf8FaVnZ9Gf2yLcMLB47EnsOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAmTHBbiSP0LLomAc4TZKBeLWBlRBmvoUuSln1bkLLy85C5og6NnuDxjjkqULadXux80VOF6Art3mQdgpQCd5myrD/trG2RjEhVY5MDxlqtzH3XjEhK4GY78N9/9OaNhF/62rNOaSB5w8wI4JYBvf7Rp2f1mrVupB099Il9zDOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CoWTEHTR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758905793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXbsgR7Ss1aZW3LlfLUf8FaVnZ9Gf2yLcMLB47EnsOc=;
	b=CoWTEHTRcUr2vMLRYOgll24MCESPKgM8YVcuHG9vO4n8ybwBQdad2WOyTL1s8zgs8CEJB7
	dDdb8fbUXISwP1V3+6VltuYIkqZQ65Wt0bKsQgfBk0F02MOky+7aGE+o+goREUyQFaGMq/
	uAugh4RoT+k0yyiIakXVFC+fwU3Os3I=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-0n9MP7lXOqWF9UEooiqmJw-1; Fri, 26 Sep 2025 12:56:32 -0400
X-MC-Unique: 0n9MP7lXOqWF9UEooiqmJw-1
X-Mimecast-MFC-AGG-ID: 0n9MP7lXOqWF9UEooiqmJw_1758905791
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so2276781a91.2
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758905791; x=1759510591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXbsgR7Ss1aZW3LlfLUf8FaVnZ9Gf2yLcMLB47EnsOc=;
        b=fvDwWUhnM+Rec3XWtDgrlXRvpKw2tT839nRD7tFfmE8xkgf0kGvEGXEeURfyJIt5En
         rZ44t4ahxMgasBlkXFsW13rfHopdUVmvS6PXknCrKdt3N9vOjbysv+LPVcdOBP6wuvn/
         V77NQPTQLdYYaanTLHdQvxHkgzOJQLulZayQMoNyIegJBIysQ5z9+gh9ed31vBZ8e5ZT
         LfW6IgvBj4TGITsz3TwCc2epY48SBGl5t8njnZog1buijeh7/olqnfD7T61bvl2fU9Bq
         KzvQt06X4SyG/CzkL+SGCFcfjlKPJpwXNB3xCBXRPY2NiG9zo8unZYD9/RGqgB+zWzBH
         Tjsg==
X-Forwarded-Encrypted: i=1; AJvYcCXyHbTpGXZss8OP7wowY5HUVPLnXB9edCsiz65c0SRrSs20prp3yGq47MkNehFFEiYzIlc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy96+fcW4ui/EkSl9rwbJroOmH6BrMhbO4Of6u7T3ysolESJVFW
	B3W7jgugsBdnPa/gvvYnP/Xw/le+emh5CHEOWulTQtLQMKKRsl0ZUuuqWob2Zl/ehnkEGKwF5S2
	M/wqrIfFuVu6jYFeByVL6Brg/+XWSPBCNSKt7W8KTxRlSHUD07BTNiiyEgd16NfMLjD4OGZXKt9
	rhb2uAfinX6IF+M5a06GsXleC/9rEB
X-Gm-Gg: ASbGnctbAQxjFVSy3pc+A0PfB1pGmhuF5wg7mH+KqKJCrYnrlAUY/cBaG2ee//izDpt
	5SB/RgecMkvsI3y+ieWlR3YY7QJAgHX6wgHFaVgCAinGg87IyflEiQpXSS7h6mlPmRHqs0d2LU4
	XQwi7k13xQ6wXwwxKh
X-Received: by 2002:a17:90b:1c8e:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-3342a2e3a0amr9010772a91.26.1758905790914;
        Fri, 26 Sep 2025 09:56:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHe/T2nb02ygPzWQlJc91OzCWfWy7tzKbeCqK0AzZtfTw4rJhgRJgzOCPPd+wuatdh/bS3alm4U9h9urtacQQ4=
X-Received: by 2002:a17:90b:1c8e:b0:330:6d2f:1b5d with SMTP id
 98e67ed59e1d1-3342a2e3a0amr9010727a91.26.1758905790446; Fri, 26 Sep 2025
 09:56:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com> <wcts7brlugr337mcdfbrz5vkhvjikcaql3pdzgke5ahuuut37v@mgcqyo2umu7w>
In-Reply-To: <wcts7brlugr337mcdfbrz5vkhvjikcaql3pdzgke5ahuuut37v@mgcqyo2umu7w>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri, 26 Sep 2025 18:56:19 +0200
X-Gm-Features: AS18NWDruDib3lxkmBnMwisbhI6jtN_YtNKGNRjNW1-ckH59RRm0Bu1PSqLse0I
Message-ID: <CAGxU2F6pZ7Bp53M3fTpSGDQYnrfxrttQc5bDmQLQX0cseW2A_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6 0/9] vsock: add namespace support to vhost-vsock
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Sept 2025 at 15:53, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Bobby,
>
> On Tue, Sep 16, 2025 at 04:43:44PM -0700, Bobby Eshleman wrote:
> >This series adds namespace support to vhost-vsock and loopback. It does
> >not add namespaces to any of the other guest transports (virtio-vsock,
> >hyperv, or vmci).
>
> Thanks for this new series and the patience!
> I've been a bit messed up after KVM Forum between personal stuff and
> other things. I'm starting to review and test today, so between this
> afternoon and Monday I hope to send you all my comments.

Okay, I reviewed most of them (I'll do the selftest patches on Monday)
and I think we are near :-)

Just a general suggestion, please spend more time on commit description.
All of them should explain better the reasoning behind. This it will
simplify the review, but also future debug.

Thanks and have a nice weekend!
Stefano


