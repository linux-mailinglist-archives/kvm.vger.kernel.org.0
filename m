Return-Path: <kvm+bounces-66240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E1684CCB269
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B806305A653
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7044E331205;
	Thu, 18 Dec 2025 09:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MD8f1rwn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tpY/TEPt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F874330662
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049292; cv=none; b=iGfCpyEMldZ4Sowhg5y93QVCXgd6vJZXOSBI9agLgWZOMkr+unQ64ZgY/xwp6RrZi3lTn5Qf42Pf8rMGsXBEcWA18J4tkaKrKQeauErs1BTgbLMgKQ25oC7e0CarzF05P5L6eBEin2cjxFy+C9FKOmjZ6xinUVB5uUAprxytXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049292; c=relaxed/simple;
	bh=OBug7yiFsFF6n1aW8KPArHWd9Qc43lse5OYmR0uVPM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgshzLvgK1aETRNAO/hN8Ui7/TCGW43XFLbReq7Lnxx4wrv664KPh4OciLRotsVHeXUXpTuumHIZLPWWEutu4oZ0/bwjNT3Sd4pjAnHsaLW44R8mOinNqv2FZ2d8uQXWPTXVHTDgtjNTUF7ZK5V2+nD3Qwn3Xx0xfkI556gzOGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MD8f1rwn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tpY/TEPt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766049286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dXqEGFcpHGxpgB5BTy87mhAk/a/akgsWpH/Fvq9SeUA=;
	b=MD8f1rwnDkJIuP4whzt+G3CZ15UcXo4ayzwnkPap86FmmgSEwP9IfSBSz+Dq2rNad1H08z
	lHpKAqPXVkLwQjXi0CGK/8OgfFw3oyZ62NouPIjc7niUduwbpioKH2RSkFJAtMtc2OIZoK
	ZPACNTOfstmTPmve5DLyih3AZFDZokc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-Kh1REsCVN6SBcToV5j2NRA-1; Thu, 18 Dec 2025 04:14:44 -0500
X-MC-Unique: Kh1REsCVN6SBcToV5j2NRA-1
X-Mimecast-MFC-AGG-ID: Kh1REsCVN6SBcToV5j2NRA_1766049283
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b79f6dcde96so58318066b.2
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 01:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766049283; x=1766654083; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dXqEGFcpHGxpgB5BTy87mhAk/a/akgsWpH/Fvq9SeUA=;
        b=tpY/TEPtqAv/5RiLuV0f53nCo2k5PqBQOI/nFtBPs+ujVEebSql/W3iNA8gYTnrV1O
         KUdS+7oYY/sI6z0xPvzzILXyfMvIbeRIrot7ecIQmUhjehSZvY2Xls3hn0hPCGBXdHHo
         eX8lgsF7/dQabgp2L8ilKUf6bStiiDFZdMRnAHrDk8mZZOxlbKHMcM2n4/5UEGW52LPM
         EEk25Sx2qbmvJixWjkzsO2f7Qxysohg+XYs3IMGh1h5SCrPB+ajrdXu4DjZoYvQzQD34
         P4zUSCZi8PFyDWZdgZYTxKxL7lrm5GHd5e8cERgOJM1ASyLSLcggFI78BK4DQ8MXwN+w
         qOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766049283; x=1766654083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXqEGFcpHGxpgB5BTy87mhAk/a/akgsWpH/Fvq9SeUA=;
        b=X8KjCt8BDm69Vv01fK9IbtoUg0WrLlTsi+vXi552JZL10eIFVqNejodsMod0J/F6q5
         hvWyzcSMxY5+6R+yQBxJNozZ69c7VgQmP2FTN0aIsrO9LU4CiN8V13k5zHc/wRUod3fw
         qidZJ7dw6/GfZKb8IJK8P5Qq5SrnBwcCYv21lT5yzX98uwAWPBvVjwlD3y2I5P7C82zC
         ZjDr31qTjd94pCJg6ImK8EYU92o2lsex1U7W4zJK3+bQWD95FSHsbJ+E9KKPaktS/LBY
         6KBoMws+BLexX9V+dd+XXT7Be4DEWD0qyZvRP4hQTsSZDSIdQoBSMraVEPH0WT2xFhgG
         Ne4w==
X-Forwarded-Encrypted: i=1; AJvYcCUi2awP3Ptm655HvL/uy+sYTdrluq0EhbqVmMV1QIzIJDxF43CizIBC8dsqnyp3cSJz3T0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3/MOcb29Jv++OdnHusWSLnKH7S3IGS73ALEP1FX0ZOyEIpHp
	zLugyNGK2uizUq6zATwOYMmkeO5woIREA94JsaRgEhyUTzK21tPWbLAt+yO3gDPoi0ripCz2R3Q
	uLySXTCeW2B6RI+oJqbLz8gcQVx0GZXQRQT2WZbCqGDHkj2mIM/cnKQ==
X-Gm-Gg: AY/fxX6U3jpWq4yXNzIYtomcKqWQFQimjxHJrGlKrHEtr7GM6E0v6vAyW0yyj0KWGRw
	PAEOfQl6thyJz/5yzjwc6kDfqr75Eq93MfNHOxepUQUwQcZPJscbWUVcEDsaAmmTzNwU7+YDQfj
	K6lWQcfyBTgYXyMpVwrO1UI5siUrRRfZ8M2HUJACVs6p8h3W9LzRdxbAsf4SUH/IZxoXv+UcUpC
	fAzctiJQ/brKIsdh4MZ9O/Uk3MS9ahT86X3P8aenr2dAsICtLQ3fV5r7yuQ+yHwYq1SwLnxQJ5Q
	rZyL5ixCdKvkX1RQXB/p/9pzpb318J/46LHHumu/QRmIZ1jBRS1lBsvVeCzBTSIw81FV7L6tDSO
	lGaC50eWvJYjBeNM=
X-Received: by 2002:a17:907:3f1a:b0:b73:7d96:5c97 with SMTP id a640c23a62f3a-b7d23c19b99mr2120356766b.34.1766049283478;
        Thu, 18 Dec 2025 01:14:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCcnT3/k3O13h2XJKclpGQV7xCUe86HYVyLKx9bzOqHgpuxUTtkhw6t1OXOATKEcDYxaHB4A==
X-Received: by 2002:a17:907:3f1a:b0:b73:7d96:5c97 with SMTP id a640c23a62f3a-b7d23c19b99mr2120353666b.34.1766049282887;
        Thu, 18 Dec 2025 01:14:42 -0800 (PST)
Received: from sgarzare-redhat ([193.207.200.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b802351fa2esm170144466b.71.2025.12.18.01.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 01:14:42 -0800 (PST)
Date: Thu, 18 Dec 2025 10:14:20 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v4 3/4] vsock/test: fix seqpacket message bounds test
Message-ID: <dt6tg3ehtz55kej2d27youm2naqjnaieczop7pzodry4lp75yi@nv5ujnxxj5oj>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
 <20251217181206.3681159-4-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251217181206.3681159-4-mlbnkm1@gmail.com>

On Wed, Dec 17, 2025 at 07:12:05PM +0100, Melbin K Mathew wrote:

I honestly don't understand why you changed the author of this patch.
Why not just including the one I sent to you here:
https://lore.kernel.org/netdev/CAGxU2F6TMP7tOo=DONL9CJUW921NXyx9T65y_Ai5pbzh1LAQaA@mail.gmail.com/

If there is any issue, I can send it separately.

Stefano

>The test requires the sender (client) to send all messages before waking
>up the receiver (server).
>
>Since virtio-vsock had a bug and did not respect the size of the TX
>buffer, this test worked, but now that we have fixed the bug, it hangs
>because the sender fills the TX buffer before waking up the receiver.
>
>Set the buffer size in the sender (client) as well, as we already do for
>the receiver (server).
>
>Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>---
> tools/testing/vsock/vsock_test.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 9e1250790f33..0e8e173dfbdc 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -351,6 +351,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>
> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> {
>+	unsigned long long sock_buf_size;
> 	unsigned long curr_hash;
> 	size_t max_msg_size;
> 	int page_size;
>@@ -363,6 +364,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>+	sock_buf_size = SOCK_BUF_SIZE;
>+
>+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>+				sock_buf_size,
>+				"setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>+
>+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+				sock_buf_size,
>+				"setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>+
> 	/* Wait, until receiver sets buffer size. */
> 	control_expectln("SRVREADY");
>
>-- 
>2.34.1
>


