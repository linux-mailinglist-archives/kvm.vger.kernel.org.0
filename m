Return-Path: <kvm+bounces-42791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C742AA7D23F
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 04:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744283A858A
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 02:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292F22135A3;
	Mon,  7 Apr 2025 02:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3ljwfo7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B51199939
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 02:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743994474; cv=none; b=lWtmLOFn2BQWMbgt5GSGocELzZPWJ0MiPGXayMAMzAg/spYLfHErORUbXHOXjHKJngITzs2OYuwrCxZFhTo1UaPWkcfuQ17+qbqdo3ayvxDiv4bCQqEdcZDn41yP7EfqUrhzp1Eaaf4tdRGimuzooRFLJkdEqqLBYYFK+AJLjvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743994474; c=relaxed/simple;
	bh=78VYBtVNDDMVcqLfVurU2jzF/nks381crfP8S6661CI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NnrSJ5rrv5m8UyxRTLXREw5rbsPY8SPt/oEYJBwUi45/ZJMCUYk61R9B5ncywFa/tYbJ4o/NgbWHPyVZ0TeCKuDpvYGvgjYhmpGX4QwcByYe7jPa49WkvWBa1uBhL+YDHv1w1b1Udv+Z/nM9a4y6AhV3Th8VQFgeYiM4NSJMcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3ljwfo7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743994470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRYTVXsNSGpfzKQctOT6faNFmutksfxmob0Nbhsev3k=;
	b=P3ljwfo7LjuHp1h1RUFkopyEtytYnsgatc+6SyKMmyahnO1fQ9LUAFjGh+TwCpzsZSXfjl
	lZcwushdumSo0Wwy5t2JEXeMZz4fSvbjryfomEGCtv4nLyzCyTnvnjREKx4bxIoGy6eeLu
	lCKnU7remxPLFdf4XPFELEg1v2sBLVU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-4fR-XLdgMA26nNBbOp1w8g-1; Sun, 06 Apr 2025 22:54:29 -0400
X-MC-Unique: 4fR-XLdgMA26nNBbOp1w8g-1
X-Mimecast-MFC-AGG-ID: 4fR-XLdgMA26nNBbOp1w8g_1743994468
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff581215f7so3146461a91.3
        for <kvm@vger.kernel.org>; Sun, 06 Apr 2025 19:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743994468; x=1744599268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRYTVXsNSGpfzKQctOT6faNFmutksfxmob0Nbhsev3k=;
        b=I6Tal0/vWG+vebw+msc1zgRomhQ91oIBJAW7hx1DOMFVfLrKxMZCZUqJ8fgzzL45MH
         tFc6lpCnJcOicTPv4P281pishZ8Rx5euLvl7FVfDw7LJqBXHruBY+D0ksXEySHvzfQm0
         rUfJWpT8IgHsIBykPTgSfMzpUnt2B0TA14Jho28GDZTbdSc2lhtybSY+5WZ3pV1Iou7D
         CxQgctgrhPby94frEomkBiCchOxJZhh/FIxzz+krSt7zY0QhA6I+JBYcG3UtSSXuY8xi
         Shf4aW+PqWJgbjkD+3yRczvETVRIPW5UFQ96wu0UH9L2CXQNghuiG+nlZSxBTPgnP28o
         CxXA==
X-Forwarded-Encrypted: i=1; AJvYcCVsRPKCIuVCs+8ShLYux+aicDijj+RVPYKhEpFyrTeeimNcpqtkLVobGJyi+Ul7y2Kv/l4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsc1gyLI+xNhgRLU/NGRoIeTdVtq1BK5g4mad1cIaziNBWGuvT
	WSVgRJMkqdxoI1zBUz1SAJYAGsv/kjeEPD66y2RB0jztCZdE89oNepk11h8+J7TdvBob+T+yJct
	g3eDIYtwsBDVljHSfpzjakESG5J6jeh8z9QmeIGgRAnbvQl0hTzMkSJ2zExkdt4Rxxi76dvo31F
	HR6Qn8CvbjZpMAPYmkNOa8lsed
X-Gm-Gg: ASbGncuc/bIOZqDGgTE2GF9/h3BBxhq9mK40MsxsHnKnjlM8hTJCZ9SKv5J++jnrFaz
	ulbUCF84r3mtenZn2rpNY3gnMlUqpJzzpOZpROtM9Wf76Nf+uZfaNfwo6nZ++Sd7TeTA73g==
X-Received: by 2002:a17:90a:fc4d:b0:2fe:80cb:ac05 with SMTP id 98e67ed59e1d1-306a612a138mr15338041a91.9.1743994468414;
        Sun, 06 Apr 2025 19:54:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXA7LEkfeKj+UJM3EgBo9JimsT+EXs1f53vLTWxMaMpQ0p3dYoCeDfB1sKILY75A1/XhDlE0eb1/3ARXiXCQg=
X-Received: by 2002:a17:90a:fc4d:b0:2fe:80cb:ac05 with SMTP id
 98e67ed59e1d1-306a612a138mr15338003a91.9.1743994468043; Sun, 06 Apr 2025
 19:54:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250401043230.790419-1-jon@nutanix.com>
In-Reply-To: <20250401043230.790419-1-jon@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 7 Apr 2025 10:54:16 +0800
X-Gm-Features: ATxdqUFts7q2N1G290I9w5fzC7i8BKP_qVhbpym_CyiIkKmnXdbijEE_7p0Hj9Y
Message-ID: <CACGkMEty2SC--kiq64yfgWQ-q6Fg8b0+Le-dUGMaJgcOFhosRw@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: Defer TX queue re-enable until after sendmsg
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 1, 2025 at 12:04=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote:
>
> In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE and
> batches up to 64 messages before calling sock->sendmsg.
>
> Currently, when there are no more messages on the ring to dequeue,
> handle_tx_copy re-enables kicks on the ring *before* firing off the
> batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
> especially if it needs to wake up a thread (e.g., another vhost worker).
>
> If the guest submits additional messages immediately after the last ring
> check and disablement, it triggers an EPT_MISCONFIG vmexit to attempt to
> kick the vhost worker. This may happen while the worker is still
> processing the sendmsg, leading to wasteful exit(s).
>
> This is particularly problematic for single-threaded guest submission
> threads, as they must exit, wait for the exit to be processed
> (potentially involving a TTWU), and then resume.
>
> In scenarios like a constant stream of UDP messages, this results in a
> sawtooth pattern where the submitter frequently vmexits, and the
> vhost-net worker alternates between sleeping and waking.
>
> A common solution is to configure vhost-net busy polling via userspace
> (e.g., qemu poll-us). However, treating the sendmsg as the "busy"
> period by keeping kicks disabled during the final sendmsg and
> performing one additional ring check afterward provides a significant
> performance improvement without any excess busy poll cycles.
>
> If messages are found in the ring after the final sendmsg, requeue the
> TX handler. This ensures fairness for the RX handler and allows
> vhost_run_work_list to cond_resched() as needed.
>
> Test Case
>     TX VM: taskset -c 2 iperf3  -c rx-ip-here -t 60 -p 5200 -b 0 -u -i 5
>     RX VM: taskset -c 2 iperf3 -s -p 5200 -D
>     6.12.0, each worker backed by tun interface with IFF_NAPI setup.
>     Note: TCP side is largely unchanged as that was copy bound
>
> 6.12.0 unpatched
>     EPT_MISCONFIG/second: 5411
>     Datagrams/second: ~382k
>     Interval         Transfer     Bitrate         Lost/Total Datagrams
>     0.00-30.00  sec  15.5 GBytes  4.43 Gbits/sec  0/11481630 (0%)  sender
>
> 6.12.0 patched
>     EPT_MISCONFIG/second: 58 (~93x reduction)
>     Datagrams/second: ~650k  (~1.7x increase)
>     Interval         Transfer     Bitrate         Lost/Total Datagrams
>     0.00-30.00  sec  26.4 GBytes  7.55 Gbits/sec  0/19554720 (0%)  sender
>
> Signed-off-by: Jon Kohler <jon@nutanix.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


