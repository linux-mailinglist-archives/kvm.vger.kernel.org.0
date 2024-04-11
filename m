Return-Path: <kvm+bounces-14267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BBE08A187D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A7FA1C2282F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A441427E;
	Thu, 11 Apr 2024 15:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZS8lFb0v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD9F4EE
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848848; cv=none; b=sn53pGhKra6vyFtaWMw74/vrhU+ZuiOrLO6ml5lbBsuVw5oSn19w9gh8UCbbHdsT1/xvPiv1fJCZu+o4WZqwnkDSguT1zadHr8Kq/6ukw368YTpFMmQ9NH6QvSVM6ocrjFskpM//soTEF9HfR+w79bEbzE5lwX+in7Rb6UJE7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848848; c=relaxed/simple;
	bh=cDz8pnbcG444PRXZoL4njjtQAAWj0msxdEt/Rbw6BsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CbVcR7QbR8tr4NbJfr+ESrf2FADq210Hz93uqH8Yekz1RUNxWzu9fapatVa8nZZRFLPLH9xz/6xl5XDFLFEghmGy2Kn3aZLe3entpqDGAGfxpAZfFh/S1O0G5BZBMLxdPQ9zXHTGPaLWxSbS5wrDeMiS+A1JjKzxOZvM9tKI+q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZS8lFb0v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712848846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDz8pnbcG444PRXZoL4njjtQAAWj0msxdEt/Rbw6BsY=;
	b=ZS8lFb0vbVXfmBJhBueci88XRGM01oPBwKa3H1uThjwc1ix2J3e2WLzL6IBrauqguOmyBW
	fza0E/97lM2dMs1qajtW+Q+PPGIgvpx6u4ejrAimqzTNANR/9zRHDiswz2GH/Rft88gy/g
	bVuDsg7dpZG6Qp6ZM0dwWNh9HeBGemY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-4zHGSyrkMWyqeQIGftCeIg-1; Thu, 11 Apr 2024 11:20:44 -0400
X-MC-Unique: 4zHGSyrkMWyqeQIGftCeIg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d88271f485so38790281fa.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 08:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712848843; x=1713453643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDz8pnbcG444PRXZoL4njjtQAAWj0msxdEt/Rbw6BsY=;
        b=BIR2B6zTJoqVDpCwxGfhSKCN68aMJwcEx/EJf7DB84BgNi0MPLX1m0040k4ZTlstQt
         DWvrdfsck+gMp1/zTYBQOC0QstChOc+OmzB4uTMvCHmcUmvF5M/fFiG69xhSpiR0x24U
         6KhtsnhAvfffJmqeblNlvupWTMvi1GFTQPcYBdahJIxhCk2yI6ILYsqHQSuQI4cr7j+x
         IGnK9P0etq0q/moLQkB0Om2lT1cQ3yUiFyRAbS5mFkaWQJSISGsyiSnSvjt0wCJERmhw
         7OiUYw+krh4Zq4eho8vMJOAt/5xcA/wyYh/AafHI02XkQhcveVYBPDrRnhaeECTmUlzw
         y7TA==
X-Forwarded-Encrypted: i=1; AJvYcCU3ZB/joczXgJuLfiWJ+QuVk7lIbdLdVGAc0cZGDJxz99F+mdrN5x+INrZXybIQnt/KIphPJ4UDmkBX6CJiu4r017WI
X-Gm-Message-State: AOJu0YzI2UNdYrT7r6RwZWHMwRlSyVjdrL//CXdG/XgWHbtQgxFb4iCL
	oBsG0nnDjNc4f9N5AlFDPSWBj3kW8G49ZIv5KouQjaAyZZmaE9LC90L4T30UUUTU/4B8vNvfYFi
	5LgSCSBtwm+CKn1zgNazt+dzotJ9QAL5B8W/bdOepbR9MX2j8oRC9lW0zD0cbpnL4A+L1aw6ST2
	1qWbRfkBWXwy6lboT8DCGZD3YN
X-Received: by 2002:a05:651c:1543:b0:2d8:d972:67e0 with SMTP id y3-20020a05651c154300b002d8d97267e0mr3849915ljp.10.1712848843344;
        Thu, 11 Apr 2024 08:20:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEp5gn7fMbM+AUICCU9wu3izHUOUcfRTZ1FRcmIlrycF4sFSaJgzJf9ZaIPI28JrUasNUyPBF9hQy5wbdku1NY=
X-Received: by 2002:a05:651c:1543:b0:2d8:d972:67e0 with SMTP id
 y3-20020a05651c154300b002d8d97267e0mr3849889ljp.10.1712848842851; Thu, 11 Apr
 2024 08:20:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com> <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com> <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com> <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
 <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
In-Reply-To: <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 17:20:30 +0200
Message-ID: <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com, 
	pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de, konrad.wilk@oracle.com, 
	peterz@infradead.org, gregkh@linuxfoundation.org, seanjc@google.com, 
	dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org, 
	longman@redhat.com, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 5:13=E2=80=AFPM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
> I think that Andrew's concern is that if there is no eIBRS on the host th=
en
> we do not set X86_BUG_BHI on the host because we know the kernel which is
> running and this kernel has some mitigations (other than the explicit BHI
> mitigations) and these mitigations are enough to prevent BHI. But still
> the cpu is affected by BHI.

Hmm, then I'm confused. It's what I wrote before: "The (Linux or
otherwise) guest will make its own determinations as to whether BHI
mitigations are necessary. If the guest uses eIBRS, it will run with
mitigations" but you said machines without eIBRS are fine.

If instead they are only fine _with Linux_, then yeah we cannot set
BHI_NO in general. What we can do is define a new bit that is in the
KVM leaves. The new bit is effectively !eIBRS, except that it is
defined in such a way that, in a mixed migration pool, both eIBRS and
the new bit will be 0.

Paolo


