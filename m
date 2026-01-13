Return-Path: <kvm+bounces-67923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42986D17CA1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 10:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 325C6301056A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 09:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DEB34575A;
	Tue, 13 Jan 2026 09:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HecYZxIQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GbGB30hh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023F9341079
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296991; cv=none; b=UJZWV4VKrVm5vmApbIwVtz7IsAmefq7uPnxVZnh7dsiykIHXOtEeA1bQrQVW5iIcfehPV2bA9Old8zvVwFUTXe14rourN+nLzOBe28/8SKHygIil3CXhhF3YXQ1lVZWvbNggmGaDEpQdR8W8T6k4GQHj8R/lleNUGUDQCVajR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296991; c=relaxed/simple;
	bh=LUNG+ln+1Yxh43YagXbgYh3TjS0L/EKjm9H5/PjiDX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=luV9RnKzbnK3HfxH5t9zySYbsi8SORznhJZDklCvL3F4M2suqWQXZiPIf1LqDFJeskSfDMRltgOTM6tccU6EoVjp05Fb6/XJnoeSmqS3E361RWJ9KTgV7/bdrXajzRiKU7NrX4ZPwz/nOMaO9tK09kJI++CZoxhWNIWdB61U/ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HecYZxIQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GbGB30hh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768296989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JIlCi5Wns02VUYB8sRaXmo5RZqGB5lGXWR590JeS2pc=;
	b=HecYZxIQZJ733lpIqK3OwcpQ8ErWVf25EaOcg7WvJuMSvs6hhXLUOxIGoG6DLOONdSMJS/
	4qLzch36/2TZ91S7K6T/QNkC93mm1/DGW2OU2sOgy0qeLflSCWrRYXaEiu2/NriUrcNo6c
	M29ecW819QuoLPQSzM/cN6pskKgzoyM=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-Ugj2Ae9YPXeSQp6dlMcgbw-1; Tue, 13 Jan 2026 04:36:27 -0500
X-MC-Unique: Ugj2Ae9YPXeSQp6dlMcgbw-1
X-Mimecast-MFC-AGG-ID: Ugj2Ae9YPXeSQp6dlMcgbw_1768296987
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-644790187b7so10141587d50.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 01:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768296987; x=1768901787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIlCi5Wns02VUYB8sRaXmo5RZqGB5lGXWR590JeS2pc=;
        b=GbGB30hhFasOz2v9sLR5VDPOuIf+0K07mucjMl//70xThgm3LIEvPLsXI8HJGi3h8i
         PHgQhhsYv6WlNS44dB/RFHfD+XZOMhnueZqAVmfjp9PyNDESKJDa0zmO4ZyCwjuvIMiB
         QN8aNpAPWO4Gu63PZ5JVqmRXaJcJwoTJa0LiFgEMSkW3rlxIo3pi0F/mRKLmtgKbhRIv
         Wn7P7o3WgDjTyYlKl9KB3xDa1KfRAWH4H+SYWEwlCxhOCiEW3vMbDhV85GQAPxiDXgT8
         qOPGK/jyddDYgL42Wd05iFeUmgcO/BfCzdKz4BJJLU9DNSZTT9aOnOOUsXztjoEl/Eih
         qSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768296987; x=1768901787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JIlCi5Wns02VUYB8sRaXmo5RZqGB5lGXWR590JeS2pc=;
        b=q7zHRa+JtdE0En88pO8r5XBD0g281ki06xHg08FszjnuFS5sTBGCGOcVv4h4t7JS3N
         Lxce9HRxo0R/HWSlO3GPbakVGGtgZVbDW6IuK/BWqv4/ZWOsYQNN0JdG8hlJPfPbvSvZ
         UbcHhw3t1P4eZA/35qVXeUGbmBHSmvV/VnuVLOnvRmtPG7StwC4B2FkzQK+neNU/uw+5
         fzHzl8RNmHb1Ob2uhp9EOicPo1zTANQRTwgymcuPApr2iXPx1wAHYFApjEi3TxPmoymP
         TmbElF41X7Iyyhem+OawOFZqKc+3KRNHYprp0liTueEb0UGhK+/PjxyS2y/dFS29krp5
         I/Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXibezZSksv1PSqgO/GsBcnjHm16VE5ALKwjHhtNDL7DjoFzXZ28ocU3AR8L/mCqh4UZxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlEAXgSOiyT5mUWxVLFOK6cjcklegUk+LG0J7xPRKSIVBpU6Ly
	dUjyAzEVLKzRuBqAmWXPcuA+i3n1t1Cw2rKxNBVx9YeWVQlBC+S3+AJ6ZNmFPZMOpW6eHk3Fovs
	dbFdonYjP/M39KL0cRaeaXjlpwtRG60OQSG7ajslgWn7s6RsT1IXyRqQtXEaz0sHRRNW5/zIRHs
	N5jxHjfGLDJQoUVC4bpdx+t7mw2OdNLlb8j0Po2h0=
X-Gm-Gg: AY/fxX54sAoIeDQ5iUIn2WtUhEatouzKa8yIseDXj4/WWSttdGe5Cym4Ew/Ls7jYHGi
	CuhH1UHxMW/4E+yMl9eUOgWVkQRk+rFhMK6Xq874xkSo0YXMLqUWhlQgkrt9CJirsodQCyauSwK
	EWDqErZ83fwPMCFXUEOfDcyqqMGml7aHHZHNBLrbaYQwS/SGuBfhYoMvPZCHq00EskzxdP6fulC
	3nUAIaGpgGAFWNVVc9dO8z/rw==
X-Received: by 2002:a05:690e:188f:b0:646:7835:47cd with SMTP id 956f58d0204a3-64716c904f8mr16820134d50.77.1768296987039;
        Tue, 13 Jan 2026 01:36:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKjYTRIqA/phaKuVKUtZuPI7hGff6zqpsw0A6oZq+VqXpu+OcAcCus47MZj7rTghYHbuc8TNLwmZijL3ukze8=
X-Received: by 2002:a05:690e:188f:b0:646:7835:47cd with SMTP id
 956f58d0204a3-64716c904f8mr16820115d50.77.1768296986637; Tue, 13 Jan 2026
 01:36:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109143413.293593-1-osteffen@redhat.com> <20260109143413.293593-4-osteffen@redhat.com>
 <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
 <aWTBdSDO9KKpXLt4@sirius.home.kraxel.org> <aWTDQZT4L3mX3Rfd@leonardi-redhat> <aWTEO9LIPNbf9YMe@sirius.home.kraxel.org>
In-Reply-To: <aWTEO9LIPNbf9YMe@sirius.home.kraxel.org>
From: Oliver Steffen <osteffen@redhat.com>
Date: Tue, 13 Jan 2026 10:36:15 +0100
X-Gm-Features: AZwV_Qj3Fdd29A1amIgaXnbBfqyli1-2DYaAiVGZ95HNZgcsp_1ge8w8uG5-S9U
Message-ID: <CA+bRGFr=JPDW5KgcXVp4mdu19cC27R_CkpZDHKzZoJ1xM04XnQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 10:57=E2=80=AFAM Gerd Hoffmann <kraxel@redhat.com> =
wrote:
>
>   Hi,
>
> > > > IMHO this should be sent a separate patch
> > >
> > > Huh?  It /is/ a separate patch ...
> >
> > Sorry, I meant outside of this series.
>
> Not needed, separate patch is good enough, even though sending a
> separate 'fixes' series might make sense in some cases (split an
> already long patch series, or during freeze where only fixes are
> allowed before the next release).

Since there are more identical cases of missing NULL checks here,
I'd take this patch out of this series and handle all instances together
in a new patch/series.

Thanks
- Olvier

>
> take care,
>   Gerd
>


