Return-Path: <kvm+bounces-70565-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGjYEKo8iWmu4wQAu9opvQ
	(envelope-from <kvm+bounces-70565-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 02:47:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCA310AE8E
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 02:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 869223004D86
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 01:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8636928AAEB;
	Mon,  9 Feb 2026 01:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IeHdeQCM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZqr6xTR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB1A27A10F
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770601631; cv=pass; b=KIuThHXCsOBpsGMoo64MQ3cLYT5RP6e5z1QskO9fBmPYPC+ENaq3fjQ9SxExqtdCbRI4vfjTKL/m0K138ZhGlU3IxhtMFe6PDsYeU2fEhKY8AYZcXusGdffHeqPFdSZzui8UXGzpCfryXtZq75Jcu31tJFaeyeSi3modGkNiDao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770601631; c=relaxed/simple;
	bh=A1rH8Kup5JYGSVFNThtF+pJpdOaDs/TC/8Q/WXtpf3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ica2stxVdSlW37EDXKfXaK0XUSV2QEK9VpArNNcgz1vbDs2fMaT+gcz+utKOh04RySfq9ZybA+9Lt2XtttKrR0Swxxu6ljYB02q+LTUNsDUnAK/sKqixEpgomf7eIIOKpCXcMyg2yQd+s2nPS/wMFw0yNtSN1j2FBbso6CN/5Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IeHdeQCM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZqr6xTR; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770601630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VxKFt0XoIdgZui4JIVRnYlH952Cq7jQJGTItF6gwkQ=;
	b=IeHdeQCMMyO1y2Y22ws2wFqQpL+FJuADFj5/SF34+0PdjB1ifiMvUkU2WhViD+jbGaFYbE
	rGf3eK6AO8sX9m9gBGNhB+aGtILF/d7ZQjphEaQKGS52CuFbXMwd6nxdc2zsWqn8N9eTef
	NKm5E1RfDD6Vzejq56osEBx9LQcnoDI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-Dh5xGoXuO2yd7rWB6a2Z7Q-1; Sun, 08 Feb 2026 20:47:09 -0500
X-MC-Unique: Dh5xGoXuO2yd7rWB6a2Z7Q-1
X-Mimecast-MFC-AGG-ID: Dh5xGoXuO2yd7rWB6a2Z7Q_1770601628
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c551e6fe4b4so2729369a12.3
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 17:47:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770601628; cv=none;
        d=google.com; s=arc-20240605;
        b=l1LhAIxe/VuNcbNG3AUfC8hB81wCXTNdnnr6vIbLDe5LPPRKDlmCqe4+1MpuZ3B5hM
         LN5vHFIZ6gbLThWWWr8rJWZItmQF9raqzkcmuWy0XfZN/f/p4/Ke4YBqUo8nqd4gYo8+
         GDnpz9G2dOOlvL/Cg8jqkSHxPDwnWC1QNg4mLrFJUSz3IFCvqMMHsSLrsY9Zc3F90uV9
         YZz5KZhIfVSQnUewon0QtT31GcJnnQJddVQnsY8x28bYRbwqciMQgu89FwPxyZO1AhVS
         r1a4h75uD0FZr3lDqVpYlFQnqx9OhFL6kMJQcdavjonDSf2PIDFdIIGGy7zofaAqm1aE
         wdzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2VxKFt0XoIdgZui4JIVRnYlH952Cq7jQJGTItF6gwkQ=;
        fh=z0vZxVJj3nUUmHXyoPLdFJK0k6LbUe1Kmk0UEa3Rv6A=;
        b=Pbdb5mChDTB6aa4DkhadAnIP22Qr9MqAK0smCVrhCb/KpK+GvurgF+E9krw4Ib4d8F
         7b1Qoqh0e9et+g2XnTQiPgAcF54C+0lIxwxxpA3szOXYbF5kLv+cDFZEAwyzZX2xxVJg
         H43EA4ViQhsFxzigWbFZlw6zHvxvYESkSMF5P5ZygORSNEIszkuQrB/yzXXUd/vPfKiG
         aNp0rj7PXMTSP3RL8xCqJfUNHoe3WpZVnoo3KMJ+JHkvLLyHriLD0FcVUk6pUvUCV7so
         hbbEByewkBwpoid3ZUvoml7dBtgP5A4PPPypS1piB96ASMRTGjJXZruwe7tVf27r6Dhf
         kRRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770601628; x=1771206428; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VxKFt0XoIdgZui4JIVRnYlH952Cq7jQJGTItF6gwkQ=;
        b=iZqr6xTR4J3Fhy6TXq92pOSxYUyE+nroOaLEgOALumK/zXY/DWtnH7G79Lzm0G1IcU
         yG6otCLQI7Ik2W54mQDi0e9Ex6adw/SywP9aGQZD9IxpBW2A+4EGpEkGnXWdM90D0thC
         bxosRZymYzusmVzhO4Kfqkx9AGmGdo3FT1Cc75t1xVBukePxwDKTkOPiW2+YNk9qcgi3
         Hk9i312tsT7bKBV/kmffbZ+ri2gM2U271hpHHJvYsMDvlZsEph0v77Fh7cy6QfPMIzyn
         gzWOZUDJB6kpEvZrJGfgHUOAisEv0D+jGNWKDmB/ZKdXEYO0u/aJZL8sZI5tfoJIOikX
         WfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770601628; x=1771206428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2VxKFt0XoIdgZui4JIVRnYlH952Cq7jQJGTItF6gwkQ=;
        b=W56c7Ke9WPUOW2/KvkeP6K/FiSOEj+sa5FMY9hrFBnBz9LfwnNy6k/Bbw+xVD8L4am
         8SEjB0O2Arfj+Ir5PuqetySH6JNTrOqgg8Ow2ph0S7XPy20vG6j27gPecc/Xs67+DJIL
         twhvx36fs2aSz9EuOn7AbHPo8s7JRkhHFWcOe/sBwQL9om70PJ27iY5rEdnmwFe8xuoE
         NtsgC3cfaA9kMLrkYySbKGo0wS1Xc8Hb6jgWAzzD9rCaTqH4Xz1hwr9Ul+AtVaoUiwqx
         UOnVVzPz/cqoMyz2B+effx6zkXBUHjGzTYCUxNk/94wGmKIxBxbZ8PtGMfkaqnzPg1hI
         EfOA==
X-Forwarded-Encrypted: i=1; AJvYcCW7ftNZrA/zDQdJZfrqHP3IlYmk32tGsPGLfllYrpcKAf2VqDFxsyOPy6sbQjg3vZ6qdV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcQTesD41QLSInbepkdrTa8tE//O5FjyJKzrpKV83O+bqjOP90
	+pilD9CpiOEWJM6WtTMjN/5M51fu3h7hvhW3dHbvVFA0ndptygg2NFSrThHM5N6uHJuibYvBdg7
	/O/9U+EqFhAFWzB8S+WZsZMBJnUcrvo8LRbpIJeqrRp68IzZAmWrPCIqh+B6/4KqMRtjG651NA9
	L0Mb2+nwGcK6ITmrSRAHk+OTwsm+JdpiO/9Kn2n6I=
X-Gm-Gg: AZuq6aL62nmZQiDAlneP7fuke+FBe3yqsMxzCNHy+5ZDWTpcpHKVIHYeKBgrUT+AYir
	9tOTAt+peINhsEcAgpOnwZyjWUsnKtnpeki3IKxsUVstBvfcXbQxSBhX30fCO2Aj+inT+1sS2+a
	Yqt5KAJq9dA55cuS9+U18FU2ZoWbo/6z+ugTq78jRTDaF8Kp7uf0oXATwGjoZ431R9lCo=
X-Received: by 2002:a05:6a21:4c81:b0:38e:54b8:60a1 with SMTP id adf61e73a8af0-393acf88668mr8796250637.4.1770601627823;
        Sun, 08 Feb 2026 17:47:07 -0800 (PST)
X-Received: by 2002:a05:6a21:4c81:b0:38e:54b8:60a1 with SMTP id
 adf61e73a8af0-393acf88668mr8796229637.4.1770601627369; Sun, 08 Feb 2026
 17:47:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260208143441.2177372-1-lulu@redhat.com>
In-Reply-To: <20260208143441.2177372-1-lulu@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 9 Feb 2026 09:46:56 +0800
X-Gm-Features: AZwV_Qi0i5ksGpVC-CJBln-eBH2tT-cjvtJdZLINPKQb7OLTsikREB_yl6vrqE0
Message-ID: <CACGkMEu+gE_K=Tdx8c8GSY4snGpSuU3MgevTq_Mh2wShmaH+2g@mail.gmail.com>
Subject: Re: [RFC 0/3] vhost-net: netfilter support for RX path
To: Cindy Lu <lulu@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70565-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jasowang@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.995];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6BCA310AE8E
X-Rspamd-Action: no action

On Sun, Feb 8, 2026 at 10:34=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> This series adds a minimal vhost-net filter support for RX.
> It introduces a UAPI for VHOST_NET_SET_FILTER and a simple
> SOCK_SEQPACKET message header. The kernel side keeps a filter
> socket reference and routes RX packets to userspace when
> it was enabled.

I wonder if a packet socket is sufficient or is this for macvtap as well?

Thanks

>
> Tested
> - vhost=3Don  and vhost=3Doff
>
> Cindy Lu (3):
>   uapi: vhost: add vhost-net netfilter offload API
>   vhost/net: add netfilter socket support
>   vhost/net: add RX netfilter offload path
>
>  drivers/vhost/net.c        | 338 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vhost.h |  20 +++
>  2 files changed, 358 insertions(+)
>
> --
> 2.52.0
>


