Return-Path: <kvm+bounces-49233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B5AAD69E4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45CE017974A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAC721421D;
	Thu, 12 Jun 2025 08:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZIR8TklK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1AE18C322
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749715460; cv=none; b=Ba1cIBB11BrPMjpzEQkp5YM9XpRwHtxVnCJzPctc6PaCuS2O1B2tEOcw4Fcy0OhkZfeDzeOFiEnwfDTfhC/9DnLKLiQP4XYpepkSIBYzCKCyUslOQ5OUzbXdeGfPw5xTsyP7tFLjB7Zm6yWV2+zGxZvnS9Rf4CiDdEAm+8j27ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749715460; c=relaxed/simple;
	bh=dZMHVNBbyE0k8GdpEWwXqBscTuEFNGdf3G5hSUKiNHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cY0vXRNHpTNQjnvqlGni0C4EhoAuonsWZa7l70yy35lZ3UY3eL5u+Ll17Y/Np+//ldh4eshvrHby/PcXO6/1BBbzQDvkQpJHt6D3QjZXn7hr8uJ1mmlttWWjw9Gz8mXzxaQC3SqavNHnIllGlBhTTqI95Xv29EhI3Zg0ThouPLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZIR8TklK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749715456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dZMHVNBbyE0k8GdpEWwXqBscTuEFNGdf3G5hSUKiNHU=;
	b=ZIR8TklK9uWUu24gcrscd9x9+/28NtO4U2UMq0CfGnBPApw7+8oApSeCGF1JmhdFoFU8TV
	rJB/SinKUSjoGIbYvd5Zs+6retDd5oVGiO+jeGp8H88L8W2vuuwsFHfPUTobfwHQ0861Sp
	bDBVYMXRVVHhshUricYV8fBxBdUNUzU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-j-wzygJJMzy-BbtS2jAVrg-1; Thu, 12 Jun 2025 04:04:14 -0400
X-MC-Unique: j-wzygJJMzy-BbtS2jAVrg-1
X-Mimecast-MFC-AGG-ID: j-wzygJJMzy-BbtS2jAVrg_1749715454
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-70e2b627b47so8437997b3.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 01:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749715454; x=1750320254;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZMHVNBbyE0k8GdpEWwXqBscTuEFNGdf3G5hSUKiNHU=;
        b=bQaMJJ2YlFdrII17bWJyLWtX+Ybc65JJ4tsbzwlFl9n2jIq4s5ZL7dj7Pm3TA1Xye/
         mrSFnS6BP1heOAnT2VjgwCRp8r8GyYO9D+sxX7XYTmlvfBnOazwOi3+lnLOodLmxkrX3
         tZH+ORJImuwvIqo+IZ/ieIGEP6ky0UdVWIZ0K6zGwxeHrdBfPHqhNB1Nyaj5lAEREBl1
         Ms7vkC1GQckCGCU8h23utyfnngvsuAqAhMEqongJosorKjO1jpnlJ+nzTmAIMwPw+RtM
         eZi0vQSKH6S91UQm9tloLvaxH6kdi9sbggL9IKyjvERVNkepZSHHMdeKxm5vpq8VerLL
         fd7g==
X-Forwarded-Encrypted: i=1; AJvYcCWkLMeaMUGzhlIlpeX6SBmAKyQidpkGIBZ4Yuf/71/7n26SZfBojhagXVY5TDV2Xbu20Ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzqP4dOp7b4pLeypMKTF1tcd97+Xez+BlsckBgyDiBypb5xepW
	1aHMSauAC6hI8/Al7Ii0JS3s5cjaMct3KIVyvObdQNiucmzCUGIH97jsv7ehipQcdxzrDvpOQsu
	8Gin872ksFHsjGA67HIUwtZobYFRVFfYG5eKeoho8ehFgsePlhlJQPdLefDE5rQKqKs2C0o7/hI
	j6lynIkaUDsyxBZ8yDudqT0vQT7gOk
X-Gm-Gg: ASbGncs6j4OjyzaxuaKrj7981fMPidEQ9dDuEUoENw+bm2wH5vwGZXBnhDFcmwjOuQg
	KC6l2MGryXj+qq8MkwWbyhJR+yP13g6aXzRX1/EwQJCEfYpSZrMqq5yQYEwgLczv7te8Ino5zws
	yXu7Evp9RP0FI9o+M4nsZbUux0zKT/Xo3VzPA=
X-Received: by 2002:a05:690c:39d:b0:6fb:ae6b:a340 with SMTP id 00721157ae682-71140af6833mr89683187b3.30.1749715453793;
        Thu, 12 Jun 2025 01:04:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKpH0zV8WAQdWv1lhM5ZZcw077V1kJarsSUj2zqX5HwhgGv6teM4sCUgx4Nym37iltxkdXS6Iqa2//rPnys9A=
X-Received: by 2002:a05:690c:39d:b0:6fb:ae6b:a340 with SMTP id
 00721157ae682-71140af6833mr89682727b3.30.1749715453466; Thu, 12 Jun 2025
 01:04:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612023334-mutt-send-email-mst@kernel.org> <20250612064957.978503-1-niuxuewei.nxw@antgroup.com>
In-Reply-To: <20250612064957.978503-1-niuxuewei.nxw@antgroup.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 12 Jun 2025 10:04:00 +0200
X-Gm-Features: AX0GCFuxXcX7tZ1g-iY8JvPcecHdu0pQdDpj1BwVsu9-6iJkGFvAwtpFRMmd4Tk
Message-ID: <CAGxU2F6c7=M-jbBRXkU-iUfzNbUYAr9QApDvRVOAU6Q0zDsFGQ@mail.gmail.com>
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, Oxffffaa@gmail.com, avkrasnov@salutedevices.com, 
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 08:50, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>
> > On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> > > No comments since last month.
> > >
> > > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> > > patch. Could I get more eyes on this one?
> > >
> > > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> > >
> > > Thanks,
> > > Xuewei
> >
> > it's been in net for two weeks now, no?
>
> Umm sorry, I didn't check the date carefully, because there are several
> ongoing patches. Next time I'll check it carefully. Sorry again.
>
> It looks like no one is paying attention to this patch. I am requesting
> someone interested in vsock to review this. I'd appreciate that!

Which patch do you mean?

Thanks,
Stefano


