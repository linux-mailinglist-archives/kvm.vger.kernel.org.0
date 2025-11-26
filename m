Return-Path: <kvm+bounces-64624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6473EC88BC5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02FD44E86CA
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838BF31AF22;
	Wed, 26 Nov 2025 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RSKBMnfw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oHn/nagz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFBE31AF12
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146956; cv=none; b=MyR4eeS0EtGtau2exvFHkLRyvYebJkU02SGnAAOq6+DfQSwIOYwHMLLCPlbPJJDSukkIdw68DHR666ZYpAHOxlLbO9zhLFd6nJn1aPjweaXMgb7E7jlowtueQk8LgkVDfyv/ch7HzTRZzBMBTf2FcT0Z8kuXpFkO7OaqiPEhW8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146956; c=relaxed/simple;
	bh=/LRKbn8b92gEosXjA/J2j2aw4PnYRaf09StElOxPWNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WDhT165LuGQ3LhA1ML3FLDko99lbLTAY8PiLJr0fQkitoB6eE/yCgrdAWdTLvFjVqTS/uczlD38gWdhcY1ADOsKCZV4wRs3uwu1fDRtQEiQ37RQ0mLDYgf4WEXVYU5uEIdBfplVhyb+3tiJN0tMf582HEWdQ8NbadT2yyoF3ijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RSKBMnfw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oHn/nagz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764146953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LRKbn8b92gEosXjA/J2j2aw4PnYRaf09StElOxPWNo=;
	b=RSKBMnfwSk87dn4AxxnwOwWr6wvuxFfAJ1sJcVoMG9C4ipb3O7mqPuS80xYJhKsdD83VSn
	uPLyXArjnjKLSWZbun4+8fL/5V2oAeih6qUlGKM13YAaWqNYFaUCQMXqi19qN5Dor9WLR0
	lLCvu71/l3//rlNS0/A5xancnnWOq98=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-3ZDWc0TyNcG9zQ0DBBAG2Q-1; Wed, 26 Nov 2025 03:49:12 -0500
X-MC-Unique: 3ZDWc0TyNcG9zQ0DBBAG2Q-1
X-Mimecast-MFC-AGG-ID: 3ZDWc0TyNcG9zQ0DBBAG2Q_1764146951
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47106720618so79693905e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764146951; x=1764751751; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LRKbn8b92gEosXjA/J2j2aw4PnYRaf09StElOxPWNo=;
        b=oHn/nagzY/PHNF7D74ZwrHfPYrpiPbYOIS/G6lW4HUt9MXPIdVly3Tlj6XBLgBhKxH
         2yDr2cnn3Zos4IcApKuJ030skTQhB73m7mDLySW0lp2S2Jgzr2ptC9LzKlckAr8WCP9e
         mUzD/f5JcpXBOCCZ8reU4vLJ0vdWnA/1Yju+wTXtBvkTaBQnagGZ0kl/jVX8fns87VKg
         YzDRQdS6HVmN0cc7WrKlHkXa/QNAIWhkvsk56e7swYfBx2b0CBtcuXnhH1OOE9Ky33z/
         PZXuCNm450FPNvwbloK+C3S/eFi02wQ/VuJ7oN23tkeFTFv0UHVsDc68COvJ3lgfdzie
         gh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764146951; x=1764751751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/LRKbn8b92gEosXjA/J2j2aw4PnYRaf09StElOxPWNo=;
        b=ku84Boxl9QpR6BClLb5sqwSXPkUOHOOymxO9UVX/VSfsjOc6vFx/mzl8BfehZbGuZO
         ieIWyM9a15mEet3h2ZXXrsMdYkWyQdBsDpYI8KwpAYvUTG86ck3uuYI5RZkP2BUiQq77
         VbSDiFgxv9NsScy60bg5PowPOBKmopCjItyvJFHToMnl4f7ie78BDwB2PhJY/RWFUIZt
         K6+zLOG6GJ2pUYBhHIdvc+vDaqI/OGbeuHNkby2O5lwnf/lfj6te4WOCm/hYpoHqdmXi
         UCGo7kKp8mwQDPEV1SIhptu5D61wZ2G26DC0h56RyBFPi/CaNHdCPsKo5KsZzF0Df7L0
         JtQA==
X-Gm-Message-State: AOJu0YxifcQy70ba6uvGkaMIfFSV+f/xGYQR6326vgCFOH3IPCvbtTWe
	EAefg11cnDc71OE0e64T55kYTMdpv4D9R51lmFVwN2clYcJX81P1fCeEfTVkSlsyg3xWGYAQBG6
	w2iQHOSkzzJrbGSFGDgtjbPRUWX1DHjFaldxZK1VUB80KE6Stp1xhPw3m2IgKZ7UstnZtBYAh3C
	hCzLYAdLsHyde7l6T/HaT7jv3wxjip
X-Gm-Gg: ASbGncuvJHvmFQgoUYywluHGFdZs9hhSuHLu+l8Hrm7sxzIdrBLqiX7wkn9FLE+sUVn
	C+ZQSf3FzLJq9fArSwORMEPobQ9yO+S5CgGSU5rqWskuVs9J6LNZl+RJ1hW7su/3JrU9YuW8YvL
	NdBwQYK7olLU9Z2wqNgzW+ScORwci6ddkA6LJVFoy+co+rxIc5cyu+OpBGjF1e68puR4ddy03b9
	xB11OGQwyaEhrVjYldRTLc0+eeNPaBh/WG5wQx0ktXhzlLphzZmwUTzILMRPd33/wkCC8E=
X-Received: by 2002:a05:600c:524d:b0:477:c71:1fc1 with SMTP id 5b1f17b1804b1-477c01d44b4mr173781165e9.19.1764146950721;
        Wed, 26 Nov 2025 00:49:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5GYGrpWEVohW73ikI9RJ9WNj8vvKsay80YpbPz+nF4ZXJrCBuYyIEEC9aDvVbSl9DhswjdQXHVVuMbuW3d3E=
X-Received: by 2002:a05:600c:524d:b0:477:c71:1fc1 with SMTP id
 5b1f17b1804b1-477c01d44b4mr173780955e9.19.1764146950345; Wed, 26 Nov 2025
 00:49:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-7-seanjc@google.com>
In-Reply-To: <20251126014455.788131-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:48:57 +0100
X-Gm-Features: AWmQ_blBc8-RAtEdoUHFVaUnhQq3JFLz6MhVMlQB2YuAfFrnrD__WxnCzjTyyQw
Message-ID: <CABgObfbU8kXE3xKzYg3HETFw+FURXj3MjXmDnhoL=qA+OLO-CQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> A handful of lowish priority nSVM fixes, AVIC support for 4k vCPUs, and n=
ew
> uAPI to advertise SNP policy bits to userspace.
>
> Side topic, this pull request is finally proof that I don't just merge my=
 own
> stuff :-D

What do you mean? Is there anything you want me to review?

Paolo


