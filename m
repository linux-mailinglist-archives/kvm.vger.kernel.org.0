Return-Path: <kvm+bounces-64611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A1287C883BE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4AB383518A1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4473161B1;
	Wed, 26 Nov 2025 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+kVw9Do";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxu7N0Ok"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D0246BB6
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764137767; cv=none; b=kya2lfZ80VOXsGDR82YQngfr+DZXjOjZBjFG+60Cgu6H2E75MWAvtJQiEiEsVrJk/Aas5u/kDeomDGROrKJaQezIesfaCi7sOy8KodOaQ6hxMIBTBm5HtaoVZx7FEeuxKvCFgOpCvGCPWsweeUi+hIa/UrOpaLuHmRyRHIi0Vug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764137767; c=relaxed/simple;
	bh=Hhkb/uQKRbBMevmupgfqk1Z+Assp9GjwVgOnkjW+mvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdDOsM4zeFEI7AZbsKoYUpuwibgUWlKCkLzFxMYfatwFI3va6aUVtyVcWiUDRgDeItA4TPd9utio++rc3ZVMCfz3Rey9I5bmlwFE4VA4TdHvIyyR7VZ0oA8ochoODng/1xYi9jwV6r77NvoexaIVGf9D8/Gu8ocR1Mmr0JcaqI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+kVw9Do; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxu7N0Ok; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764137764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0dJimzQGQg955aU+NR/OTglx/NF3Eo4HFgMmqUmEC2k=;
	b=N+kVw9DoqMGdqeTEpagL1C13oqaT1yO5bfGDYxdoX6/BoLrxpiFXMtgfr2kM9U2riXsVC8
	Xlr0dE1eExiInR5ReXRrT02ELtHah5fTg2+yNMYNbkLT/Jqh8WO0PIA+id9W6ASr+z9Dq/
	i1/lgvr/t/XVyia4MCIYJah3b0c87+M=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-qd41bfflM56CclBEHg43Gw-1; Wed, 26 Nov 2025 01:16:01 -0500
X-MC-Unique: qd41bfflM56CclBEHg43Gw-1
X-Mimecast-MFC-AGG-ID: qd41bfflM56CclBEHg43Gw_1764137761
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297e5a18652so70956875ad.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764137760; x=1764742560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dJimzQGQg955aU+NR/OTglx/NF3Eo4HFgMmqUmEC2k=;
        b=hxu7N0OkOLOLLEqUIuHZ6gn11h9PpZ6ykpbCjql2pfTsOvknElykfYc/Z4dwwcrKKP
         /ZDAQBfnOZg8KmQGm+q3v41MY6oEiuQ6qtMNfS+DaA1w3ESGFrFWjVwADutMeW0wg4Os
         VjHLAuxf59pFQ1LDe9fO0Tj6ffHepYPwKez1AB+8eDNSP8IvKAxBWkbEhwAUZiU4Gye2
         BAUvDWtHXTx4OyOobVx4o4ElsYvPs/lkhBoTmYevBnKRqJSXckyzgT/gslRZG61VjmKx
         znJT+Tg7gnpxTuCzMudMa1Vrb+6fpiPvNQ62BPkRsMqktLS1swnNyTlBjyzqsbqT8bUB
         HBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764137760; x=1764742560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0dJimzQGQg955aU+NR/OTglx/NF3Eo4HFgMmqUmEC2k=;
        b=Ijz8tVuZfkbU9aBPIIqonafY6WTdjVO3685mVI8DW7zVmS1w9FJpwhVnE+Ay4Mg9tw
         wP9WAAh3rrTB67sj27vKoX6VMgp7tcOajDSv41+7xI+gr7rAJWbpDkw+7ItS0yVvE68g
         2b9wIhkKU6YLwVzaoM73XLeaG9f7AhY8nKu6dTr8ForlczhI2yaOnKTlFMmEa3NLEJbf
         R9GCk799cYBVp7AyKXVp0vFyAhF4MhQR2fVivhTSdM9FafXnJSYePycOPKyD9Z2oRNsu
         U8w8bpcMSVpypx4evh2ccEuFH8XsRSRrg08Ydet5WZ3lxjEzdZwdk+aWC7wxycqx6dwU
         wvCA==
X-Forwarded-Encrypted: i=1; AJvYcCUSzaaZITnYKe/ApRQsjurOAalcAjojVo/1PTAn0GZ/IU/8skjw3jOxWeiQ4jNt0MrR6wY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsk/GpJQmOApDhx47Bjtctw0JCKS79ZhQXNc8YV1u70L7WsVuC
	jma122D+1OoLockLo7l67VAiDGBnfY9WuLZqeUvmtL1BnEvBOt1DgKgbpO3zY4fBclwdjJBj7bJ
	HJoOgU9dnKcawMMpWqBh8EP5s4gFX8yN1bVKpLvREBh72W2OJg6yvNUBXAZ6yKm5k2lsZ1gX47n
	BseGLBF6nh5gHcAYw5HFks4sKu/6q1
X-Gm-Gg: ASbGncssFLhsl/46MZUo7CtCHNEqK52g4bvkGaNUVKwOYPMh15m/J5hyDFcySZK/4FB
	p9PEPnTPZYN+9N1mYrUJ9xrzyQdTTIx9tfzn7Dr3ce/BsgnQD+66pSdJuoPG9wIQTI6W5h9/lPf
	AXYuJKn+Un1DZQhmiS6wwaRVyF/UxYcd2FQ2xjCbpHRrhFeoa23VlKF9PxJ4bqNXbnXrg=
X-Received: by 2002:a17:903:2c0d:b0:29b:5c65:4521 with SMTP id d9443c01a7336-29b6c6cf2f4mr185578235ad.60.1764137760465;
        Tue, 25 Nov 2025 22:16:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHp5XvNsnFpgsWRW2tQ1zh6WcpwYde25ZVuL9wuN9oXE1mfzdcNCQGyR/EOxkG1uaOEL4o3pHnX4XP18UW3zR0=
X-Received: by 2002:a17:903:2c0d:b0:29b:5c65:4521 with SMTP id
 d9443c01a7336-29b6c6cf2f4mr185578095ad.60.1764137760068; Tue, 25 Nov 2025
 22:16:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125180034.1167847-1-jon@nutanix.com>
In-Reply-To: <20251125180034.1167847-1-jon@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Nov 2025 14:15:45 +0800
X-Gm-Features: AWmQ_bnZI9fzMXfYky4r-2TXzDDyUyIJGaC0lgl7E9RYBzJFA-iONio19mXg7uE
Message-ID: <CACGkMEv22mEkVoEdN0iPdgeycOEn8TaXcg-y5PGHTjw9YvTKpw@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 1:18=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote:
>
> In non-busypoll handle_rx paths, if peek_head_len returns 0, the RX
> loop breaks, the RX wait queue is re-enabled, and vhost_net_signal_used
> is called to flush done_idx and notify the guest if needed.
>
> However, signaling the guest can take non-trivial time. During this
> window, additional RX payloads may arrive on rx_ring without further
> kicks. These new payloads will sit unprocessed until another kick
> arrives, increasing latency. In high-rate UDP RX workloads, this was
> observed to occur over 20k times per second.
>
> To minimize this window and improve opportunities to process packets
> promptly, immediately call peek_head_len after signaling. If new packets
> are found, treat it as a busy poll interrupt and requeue handle_rx,
> improving fairness to TX handlers and other pending CPU work. This also
> helps suppress unnecessary thread wakeups, reducing waker CPU demand.
>
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  drivers/vhost/net.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 35ded4330431..04cb5f1dc6e4 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1015,6 +1015,27 @@ static int vhost_net_rx_peek_head_len(struct vhost=
_net *net, struct sock *sk,
>         struct vhost_virtqueue *tvq =3D &tnvq->vq;
>         int len =3D peek_head_len(rnvq, sk);
>
> +       if (!len && rnvq->done_idx) {
> +               /* When idle, flush signal first, which can take some
> +                * time for ring management and guest notification.
> +                * Afterwards, check one last time for work, as the ring
> +                * may have received new work during the notification
> +                * window.
> +                */
> +               vhost_net_signal_used(rnvq, *count);
> +               *count =3D 0;
> +               if (peek_head_len(rnvq, sk)) {
> +                       /* More work came in during the notification
> +                        * window. To be fair to the TX handler and other
> +                        * potentially pending work items, pretend like
> +                        * this was a busy poll interruption so that
> +                        * the RX handler will be rescheduled and try
> +                        * again.
> +                        */
> +                       *busyloop_intr =3D true;
> +               }
> +       }

I'm not sure I will get here.

Once vhost_net_rx_peek_head_len() returns 0, we exit the loop to:

if (unlikely(busyloop_intr))
                vhost_poll_queue(&vq->poll);
        else if (!sock_len)
                vhost_net_enable_vq(net, vq);
out:
        vhost_net_signal_used(nvq, count);

Are you suggesting signalling before enabling vq actually?

Thanks

> +
>         if (!len && rvq->busyloop_timeout) {
>                 /* Flush batched heads first */
>                 vhost_net_signal_used(rnvq, *count);
> --
> 2.43.0
>


