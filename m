Return-Path: <kvm+bounces-44870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E63F1AA467C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE87E1BC4D34
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F832206B7;
	Wed, 30 Apr 2025 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4kYwgVh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC9D6AD3
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004217; cv=none; b=Rl+daMsE47Dtrx0xRLFhAWJnLyVSKnXr5cNeFI1skrWy7SxbZ91IA1rZgGgQARTkDugffSddPHBomj0HOzjxMgZ0yigvm5apgQD4WHqmRv6u61/TCP6Ij4pBwyQF6/q5/6tLAQNBDN2+5MB2vUIZbpMytN+ZF+Uth/1mtRc+Abw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004217; c=relaxed/simple;
	bh=igMUEO2jdAMJa66FnKgZHk74FDW367SkId7b0Aj61PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6Pclmv2Qb0sXgfLZMXdp4BsL6CbxToEfN/U8bX5iR35Sq/LMWFL+6VoPJOuWoOPYGwHdF765gXukim3tD0suq3sekFmvP+SyP2B3NpyKoIfkJMj5ZPiILGznqdLQ1Be3I+HiRaSSAq3HQSbIoxFWxbE1d7dTg+dR1kIP+iQssc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4kYwgVh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746004213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBM8h9GXkd4oRheqBQptKlBrFr1ALhS3777dATJTzNQ=;
	b=N4kYwgVh1m05hL0ewz737lPHK6imuCEIm49pHySaVIeQXcoG6Frf6JT7ZSmGvX8qIuKLfk
	k6DmFKUPQt+dbBvi4pQ1RWnE6AfiaLWPnbyZOeSy1L/nGIqnJQAzGsTH9ApjKp1JAcLqEV
	AbwL16RpBIaxjVnQ24NIlCCargOxa18=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-AnHU6RpiPjyoe4aAXEfEEg-1; Wed, 30 Apr 2025 05:10:12 -0400
X-MC-Unique: AnHU6RpiPjyoe4aAXEfEEg-1
X-Mimecast-MFC-AGG-ID: AnHU6RpiPjyoe4aAXEfEEg_1746004211
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5f628f5f9e3so5730355a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 02:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746004209; x=1746609009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBM8h9GXkd4oRheqBQptKlBrFr1ALhS3777dATJTzNQ=;
        b=ZN2KoQogkO1vitjFRYgM912B64pjrnTyAVuwO+3uq9RQ7TfWTQ7t+S6lspZ1hCJ4hv
         Oyctvs3FYVV99QFV6pZpR0NXjMU6mYGalXm7C2vP7BmhMQEvf7MddsFxaVJR3HcGyGQJ
         JYZU1G+Gt4+vPPqCAEF+ePZ5G98jH1UhsC8QOjrKTDK88xvgf81UjI/Hm2dUzH+mrEvr
         Ym5BDntsAeXP9EZed6FXQQdtMqJduuRfMv3cm1Vh8TTCPD4dtxJKdayydgl6rTYaAiKE
         7VDdm6BC6UaCESACnEV32C+b+pf+aLLxfkspHngEeruw+gQrdQyjomUcsqgRJOfGSsFC
         lnGw==
X-Forwarded-Encrypted: i=1; AJvYcCX10nDT84nr1cOgNmmhgOyq16pZvURN/ccvFlDxB51C98//4kZ0aMuz9Fv6YZ00PRgMoFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKii2WRtNcb2UEaM2DVubsClxxsOGjpW+On0gGzLcXRyakrwAT
	h0iUmswb6e7ofvWDMeo+zrtjg+XXIAqX84G6bV7pZsYBja6PXKTOH+eEatFMtu8CKbYTUxn+4sq
	w03f8NwyycnVUDO7L8i/tffUJbCWBlQ9A1rfzqkwnt7vHcGcK2w==
X-Gm-Gg: ASbGncsiqduLVzioVupWM2F1avTsGzB94Ws5QCFuR8NIINkDzXqrW/ABrUfUGd+UqP5
	LbvK5LE5nQetXM8NcC4EhWW0jE0wVjpmHrwiadd5unUJnfVxr6xIQU+0rtTS+CylHVxCLlcdJOc
	Ey4UODfLsCTAE/7zmoQspHrweeB7vX0+5mhiuZGH2PDPQWOn/zkI4TMgNVJbeE5eV4omnGf2rgN
	wNEdNZ68oqm5GbuCLwOi2dLeP7UfXeNRzLnaFPx02J59uicSBpLUp4ZmhTavn2k3MZWOy5US+8Z
	yqcQU8dWmIRXEgOXHQ==
X-Received: by 2002:a17:907:7b82:b0:aca:aeb4:9bd6 with SMTP id a640c23a62f3a-acedc574a4cmr220066166b.10.1746004209561;
        Wed, 30 Apr 2025 02:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBMPamEhDPbDLqOXiGcIZesC1dmK+7e+0MqQ1tv9XUC/crH+ZQmawf9DLNdOJwg2QfTaPusw==
X-Received: by 2002:a17:907:7b82:b0:aca:aeb4:9bd6 with SMTP id a640c23a62f3a-acedc574a4cmr220063766b.10.1746004208996;
        Wed, 30 Apr 2025 02:10:08 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.220.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acebe7a4ee8sm313299266b.74.2025.04.30.02.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 02:10:08 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:10:01 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Michael S . Tsirkin" <mst@redhat.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.6 13/21] vhost_task: fix vhost_task_create()
 documentation
Message-ID: <n2c3bjkh4jbzm2psd4wfrxzf5wdzv2qihcnds5apfgfyrojhyd@l6p47teppn62>
References: <20250429235233.537828-1-sashal@kernel.org>
 <20250429235233.537828-13-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250429235233.537828-13-sashal@kernel.org>

On Tue, Apr 29, 2025 at 07:52:25PM -0400, Sasha Levin wrote:
>From: Stefano Garzarella <sgarzare@redhat.com>
>
>[ Upstream commit fec0abf52609c20279243699d08b660c142ce0aa ]
>
>Commit cb380909ae3b ("vhost: return task creation error instead of NULL")
>changed the return value of vhost_task_create(), but did not update the
>documentation.
>
>Reflect the change in the documentation: on an error, vhost_task_create()
>returns an ERR_PTR() and no longer NULL.
>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>Message-Id: <20250327124435.142831-1-sgarzare@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> kernel/vhost_task.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

It looks like 6.6 doesn't contain commit cb380909ae3b ("vhost: return 
task creation error instead of NULL") so I think we should not backport 
this.

BTW, this is just a fix for a comment, so not a big issue if we backport 
or not.

Thanks,
Stefano

>
>diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
>index 8800f5acc0071..0e4455742190c 100644
>--- a/kernel/vhost_task.c
>+++ b/kernel/vhost_task.c
>@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
>  * @arg: data to be passed to fn and handled_kill
>  * @name: the thread's name
>  *
>- * This returns a specialized task for use by the vhost layer or NULL on
>+ * This returns a specialized task for use by the vhost layer or ERR_PTR() on
>  * failure. The returned task is inactive, and the caller must fire it up
>  * through vhost_task_start().
>  */
>-- 
>2.39.5
>


