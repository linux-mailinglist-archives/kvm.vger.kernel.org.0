Return-Path: <kvm+bounces-41336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF0DA664C2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A03173AFB48
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9936A1537C6;
	Tue, 18 Mar 2025 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9lal3n3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3067C81749
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 01:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742260391; cv=none; b=VN8TT5rGJKCp/+1xpi8li3gc9g8R9HQ+1Rmiq/w+QPd9IE4uE1tW6JKqT4Am9MkDzcBVD4BEIRS9ppvEWq7iv9Hf6d5XhI8tV1M+KL7JxnA+3QUJ1BaGn5fbP4Wmx9JQhrX7sE851rimIRXV8uADvcYI1Iw+Xm18JsaEAy3YGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742260391; c=relaxed/simple;
	bh=vVnJRAcF4XjPI6SSdN6jevcltS6LnQAekeugzFVLO8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Og6jHGjExb1yCta/AoKKxYVpp+ZePPkqharlQuw3NGPzesz5s1qxMU74zPHmvMveCj0irXsmnHVnvLHMO3UONNSW0eLjBhuKkGmQtCFZYHF1A8n0/Vb4B+TIbb5fCuiRfg/mqDoqwlIIb+LiYGn7sQ3FeIzfqcATc66S34/F2mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9lal3n3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742260389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1M6tJ0kGDf/4rh9VaynueL0NEwnUCgZxe75UeVU/TOY=;
	b=F9lal3n3YRjYtsypX/khzA15xIyOj5+aoCjVetRibj4QThOlv3gavheiV43/u+APoSHl+1
	Cba4WI3pecZt3CvZGg36BRd2iHTw21QPrqS1KY9BoE8KizdzO+9hLG6hv16LWb5ShEgKan
	mxqWQQvdxngamlfiM+QZ9KcswhFJ3Kg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-NUNIIDZxNuCNNZ902W1nuw-1; Mon, 17 Mar 2025 21:13:07 -0400
X-MC-Unique: NUNIIDZxNuCNNZ902W1nuw-1
X-Mimecast-MFC-AGG-ID: NUNIIDZxNuCNNZ902W1nuw_1742260386
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2241e7e3addso74084305ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742260386; x=1742865186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1M6tJ0kGDf/4rh9VaynueL0NEwnUCgZxe75UeVU/TOY=;
        b=pYJWirE2MzLbPlxRDU9C2Ovyyp0P9C64dNxjVt3CVcK5+eQkk2uDw+KPWAz16PZvwD
         N3tBWg0IQ7WNyg5VrnOVBs4Eg5eb9tt/NoiP+0lbQjdLEkjagIRkP55mCfVLfaneTjO0
         gZik0qScHJfoAvWx8yh11WZ3hlrs60rfXiEHVcANgpEr0cJlSjDpq7RukWqILOwjrabb
         9v/aObz0cHvDMLPAtMRuljswBiebMb/F7o33NGV+FM2sqhE7JlOWtQpJkiLdcfKVHBpc
         8Zpu7t0dSyBLzwZn+4VgqkpUjAdf/lh4321VJIVEs7CiySipI/HSBEOfhudQIfY49RIN
         Fl4A==
X-Forwarded-Encrypted: i=1; AJvYcCVAv+/nPi7ld4z2YMxvTsD9+yaHOeGNA6VancWSuhKQ8+3jw8FvWBCOYK13bc64Q3Kk1CE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKfHQ9ulQgLK4kwAVGiWRlb7nakloRxYJcZnagxw+Eos9wYOQu
	EPrV+cRumfVFatyCMy9sv92PVcU/YWJ9UcGhQzEAELLlWX80Ip0oevYY0zzp7rC7tvazn6k2sYN
	V1PmoqngBYSjyFDYOsRukM/k6LYvRYU10j70eElNd7Imq6vh+juMlecgxXORNLC5uzvYdzkkids
	TZRg/tFuctNt4lvDhybYCqCZYf
X-Gm-Gg: ASbGncvGUc0ZhKQvQPWGNFS7cBpMgBZbNkWkg8peyLoJt6ACTZk5+w26R+QDoLmuzzo
	FKNae1T52umk2Jzfk2Gf5zCj04+CU6P6m/vu9lYUu73uVJVmRik+fTQ/eiyJhBxRQ536JMg==
X-Received: by 2002:a17:902:c949:b0:223:4537:65b1 with SMTP id d9443c01a7336-225e0af0420mr180659655ad.36.1742260386006;
        Mon, 17 Mar 2025 18:13:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIVPHDIs5M9plAOorlau4YdurAALCKn+kxBp22IbRBmqOdZKYB31BAjG6ty8opgO8ulSCd62gsOH3FMiNLFLU=
X-Received: by 2002:a17:902:c949:b0:223:4537:65b1 with SMTP id
 d9443c01a7336-225e0af0420mr180659405ad.36.1742260385637; Mon, 17 Mar 2025
 18:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317235546.4546-1-dongli.zhang@oracle.com> <20250317235546.4546-5-dongli.zhang@oracle.com>
In-Reply-To: <20250317235546.4546-5-dongli.zhang@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 18 Mar 2025 09:12:53 +0800
X-Gm-Features: AQ5f1JpW64jPZ95eCFPlRfsQ1ehFyqhUrVvJdzZsIx4MNfGhOKRdnRftHbIpkhg
Message-ID: <CACGkMEtOsQg68O+Nqo9ycLSq7sN4AMZ92ZvLLMEF7xYDCA5Ycw@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] vhost: modify vhost_log_write() for broader users
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com, 
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com, 
	joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 7:51=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
> Currently, the only user of vhost_log_write() is vhost-net. The 'len'
> argument prevents logging of pages that are not tainted by the RX path.
>
> Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
> vhost_log_write(). So far vhost-net RX path may only partially use pages
> shared by the last vring descriptor. Unlike vhost-net, vhost-scsi always
> logs all pages shared via vring descriptors. To accommodate this, a new
> argument 'partial' is introduced. This argument works alongside 'len' to
> indicate whether the driver should log all pages of a vring descriptor, o=
r
> only pages that are tainted by the driver.
>
> In addition, removes BUG().
>
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/vhost/net.c   |  2 +-
>  drivers/vhost/vhost.c | 28 +++++++++++++++++-----------
>  drivers/vhost/vhost.h |  2 +-
>  3 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index b9b9e9d40951..0e5d82bfde76 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1219,7 +1219,7 @@ static void handle_rx(struct vhost_net *net)
>                 if (nvq->done_idx > VHOST_NET_BATCH)
>                         vhost_net_signal_used(nvq);
>                 if (unlikely(vq_log))
> -                       vhost_log_write(vq, vq_log, log, vhost_len,
> +                       vhost_log_write(vq, vq_log, log, vhost_len, true,
>                                         vq->iov, in);
>                 total_len +=3D vhost_len;
>         } while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)=
));
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 9ac25d08f473..db3b30aba940 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2304,8 +2304,14 @@ static int log_used(struct vhost_virtqueue *vq, u6=
4 used_offset, u64 len)
>         return 0;
>  }
>
> -int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
> -                   unsigned int log_num, u64 len, struct iovec *iov, int=
 count)
> +/*
> + * 'len' is used only when 'partial' is true, to indicate whether the
> + * entire length of each descriptor is logged.
> + */

While at it, let's document all the parameters here.

> +int vhost_log_write(struct vhost_virtqueue *vq,
> +                   struct vhost_log *log, unsigned int log_num,
> +                   u64 len, bool partial,
> +                   struct iovec *iov, int count)
>  {
>         int i, r;
>
> @@ -2323,19 +2329,19 @@ int vhost_log_write(struct vhost_virtqueue *vq, s=
truct vhost_log *log,
>         }
>
>         for (i =3D 0; i < log_num; ++i) {
> -               u64 l =3D min(log[i].len, len);
> +               u64 l =3D partial ? min(log[i].len, len) : log[i].len;
> +
>                 r =3D log_write(vq->log_base, log[i].addr, l);
>                 if (r < 0)
>                         return r;
> -               len -=3D l;
> -               if (!len) {
> -                       if (vq->log_ctx)
> -                               eventfd_signal(vq->log_ctx);
> -                       return 0;
> -               }
> +
> +               if (partial)
> +                       len -=3D l;

I wonder if it's simpler to just tweak the caller to call with the
correct len (or probably U64_MAX) in this case?

>         }
> -       /* Length written exceeds what we have stored. This is a bug. */
> -       BUG();
> +
> +       if (vq->log_ctx)
> +               eventfd_signal(vq->log_ctx);
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(vhost_log_write);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index bb75a292d50c..5de5941988fe 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -224,7 +224,7 @@ bool vhost_vq_avail_empty(struct vhost_dev *, struct =
vhost_virtqueue *);
>  bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>
>  int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
> -                   unsigned int log_num, u64 len,
> +                   unsigned int log_num, u64 len, bool partial,
>                     struct iovec *iov, int count);
>  int vq_meta_prefetch(struct vhost_virtqueue *vq);
>
> --
> 2.39.3
>

Thanks


