Return-Path: <kvm+bounces-45876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DBB5AAFBC4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BA3F3B6B1C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E27822D78D;
	Thu,  8 May 2025 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4lQFjwB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58902AD20;
	Thu,  8 May 2025 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711741; cv=none; b=qrTpBpKcvWxq4pYLoTkBWcrXPpOY3vJC1nPHGA160mm6jm04GVG5ih2eJ6qeO138+p6VWmUSBy2hCQyr+P0yDJoB0fXRs76FhotP2ew+/kYpBRxNOEm7j0Z1GpvIhsl/iJ/YfcqhozsD762ocO7i1hf99x+u5HMsY8niNpmp7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711741; c=relaxed/simple;
	bh=153T2wtHJJxhKb4N8JyfLhbRn1FPHrxAGrBpSnTQ1Pg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=NoV6Eip88ldXR3/Rg/rw9Pr4SSqrZr6aeZwjAJ7TPmJ1civ2Mg/XmuuAnhmbkVBiYFsXjD7Wxo7fhKBvT0wH55d9r9WzmTY/1ylDoJdQMzT/C9VFBSHdS3N7FfTuwV4h3CopBCmXSmLIlgtNjthinu5QmsOoX7JK/QOYUQJzPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4lQFjwB; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6f535b11824so9917146d6.2;
        Thu, 08 May 2025 06:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746711738; x=1747316538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1kOzwqokdjdtpRm1HS1RudL4NN1LsmIuMPcFChDAi10=;
        b=K4lQFjwBXG8thZwraL8b+Y55Z0UfHR4hTATsuFtRbCCYTkbbU1wwfKYANyI4Oo3RlZ
         Ehf9UZfPR7CbPLvPFxJFUPjqq/nBdj4raID0en2KLFbFV6jxIoxunfPXgrhvEKWSf/Gn
         +DXP6plyx6GJxRHGEB2lQmkmCSmm0wsG+BjikziQVtZ+QAdwYioCfclZyRFA3AOt/c/2
         74Dryz+FFgE2esHXyYrxxq+Tx9rp2kvYlvuLh9eNe9Ec2aEgwTWOfe7XfZQIFbBSltFT
         LlMekM0l7lyJdC83nRghW/0eANT9f54BPNfUPQrofmKTyJo11dnkMdr8yAm3OpKx7ITj
         05Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711738; x=1747316538;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1kOzwqokdjdtpRm1HS1RudL4NN1LsmIuMPcFChDAi10=;
        b=hy2ygbw5K33BwdstMaY3nEPu7COU8in6CzpQbVkfX9cpVvI7dURn41Sw8YsE5cZdfS
         Rc3eMN0DRuuBsN394/iQI49REhiKutSPSdwVIYdJE1layVt+OrNMKNpK3NXSmEIpBW79
         ZFc6VxIhsRHTElS9ecQmY6sw1fdgRMInokOO1tIDXfF/5XzKTQExFGxd6It3DLMlTx5b
         PZb5furnQEEFpRefb87xgnbZ3TYgzflR9GO1dVvoNWBfObPDykR74igSYkaY4dKV5eL6
         NMiYunXn2LY9BNQOpsC73CPQzVoo68IgR25uYx8DIebCtw0rahUjLjtP+XC9zHmedU+7
         a6gA==
X-Forwarded-Encrypted: i=1; AJvYcCUAhwBt+66syOUdQo5n6GWM5hYvspP83/Cr5GHsR2o7vwk1MMQft/ucp3AKLA73+CiyscYb@vger.kernel.org, AJvYcCXAI2dCZ3tEV/dmGtQnNAhB5FlCmQ7Vx9f0HS8w9ChdA5o0ew5aftlkXMFZG042inHCISQ=@vger.kernel.org, AJvYcCXrARiGwdatrFtFDZDj0ioBj4xB5DN6d8qS0AfTSJ6qY39IyLKbjmby5lwdSLAvU4aVi/p2bHe4FTmOn8RU@vger.kernel.org, AJvYcCXvDPGkxCTF2rqervuGiaPuZCkGlGblltqN4PNGOUugoIq+gtjIifbkNROb3CaUMljHaP0s2rSQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzVgteS6sP/+3sKLh5pwbX85I+4KgZeLZi4byVFxSOny2i7SZYq
	3WZty3qOUpboz77kiW22557IsesQbA1rKB+lFC5NJbotTnDQOBFb
X-Gm-Gg: ASbGncvu7Gi+8G+qNxMTkf6bbBRe3DcR0A5H2UelIZSTWK1GOexSmWb+BOJL9pNl46J
	D2iD+7i6Rj77kyBNs+KIwGzJmcZLmKWK++yPpkhSYkpj+asWnmxz94Ykw0QwXxby/t0Kpfq7Vrz
	ubLFkB88UcmnpaASNfiOdJI4AlEdTKqgMlf7F+32UlcbebDjwmMp0qqvVNGINVWgoaRm8N2BrqN
	WmFS94BRE73T/1Bi8c6JpuU9cF0TKpA58ELYJ1YTTmSuLBxY7wAT6mxK7gmRsrMmJhs5iwBRXDi
	CNi8fbfWb/KkA08nXSJLRO/pXVe6ySO2aJD4IDRa/JqVSbrIvj5HVhhdehQYDcdFGgw/+Jduu3I
	flgmmJen7+pDmiluLJ4Qy
X-Google-Smtp-Source: AGHT+IEDWLW6skXKOvMqdSktE7GaftAPMmvo4fOx9NvYyBhUR9W13eB1A+ZbxTatn7NW27+k/I/Z2A==
X-Received: by 2002:ad4:5942:0:b0:6e4:7307:51c6 with SMTP id 6a1803df08f44-6f542a8148amr99323396d6.34.1746711738227;
        Thu, 08 May 2025 06:42:18 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6f542780ecfsm32927476d6.86.2025.05.08.06.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 06:42:17 -0700 (PDT)
Date: Thu, 08 May 2025 09:42:17 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jon Kohler <jon@nutanix.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 =?UTF-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, 
 Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <681cb4b95dde7_2583cf294d@willemb.c.googlers.com.notmuch>
In-Reply-To: <C9ADA542-813C-42C4-AF5D-92445EB70A6A@nutanix.com>
References: <20250507160206.3267692-1-jon@nutanix.com>
 <681b96fa747b0_1f6aad29448@willemb.c.googlers.com.notmuch>
 <C9ADA542-813C-42C4-AF5D-92445EB70A6A@nutanix.com>
Subject: Re: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jon Kohler wrote:
> =

> =

> > On May 7, 2025, at 1:23=E2=80=AFPM, Willem de Bruijn <willemdebruijn.=
kernel@gmail.com> wrote:
> > =

> > !-------------------------------------------------------------------|=

> >  CAUTION: External Email
> > =

> > |-------------------------------------------------------------------!=

> > =


Minor: can you fix email to avoid the above?

> > Jon Kohler wrote:
> >> Refactor variable names in vhost_net_build_xdp to align with XDP
> >> terminology, enhancing code clarity and consistency. Additionally,
> >> reorder variables to follow a reverse Christmas tree structure,
> >> improving code organization and readability.
> >> =

> >> This change introduces no functional modifications.
> >> =

> >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> > =

> > We generally don't do pure refactoring patches.
> > =

> > They add churn to code history for little gain (and some
> > overhead and risk).
> > =

> =

> Ok, I=E2=80=99ll club this together with the larger change I=E2=80=99m =
working on
> for multi-buffer support in vhost/net, ill send that as a series
> when it is ready for eyes

I forgot to add that it makes stable fixes harder to apply across
LTS, distro and other derived kernels.

So resist the urge the just make stylistic changes. Functional
improvements warrants the risk, churn and extra work.



