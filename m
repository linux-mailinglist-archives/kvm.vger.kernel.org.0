Return-Path: <kvm+bounces-53460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D94DFB121E3
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 18:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC971545B5B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DEE2EF649;
	Fri, 25 Jul 2025 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tXaNOfpR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16B32EE615
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753460581; cv=none; b=tjgjZxcC6PJmHkgtReb7XQaUgk00CUs1zoOfEpdr6xpUqBSMVnJ12bOK4xMAOpRQkrPTwQ2F23avZuH0y+bJGvsXpAwjQeNkjbRda+KC+G9G/gx3PY7uC/OWqoNeiu7OzvDDSmbAWZEUzCDGk0XevXYz8bQeApk9Ahg4pQb30WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753460581; c=relaxed/simple;
	bh=WgMMn6ZE+UO+Db+AMvscSv4rxcyxcz2YSvR/V9F6PT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c1rL55BFdYyhHXGNjpTpSHBnK89L0ySjpvgMfoqWKUfdOG3A5DjM5Bc/33voe8os2i11y86sNgpZncpQzggXGY12OqwV4gg/QZfWbYRXmhxch80eFvV5U7JK1GTOesyRD7QAIWGudv2WUyRft3P8bH1dmDQZAIT+Ddyn/HQsGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tXaNOfpR; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab86a29c98so359371cf.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753460578; x=1754065378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u74rPH//c6SnB7FAtWzTEu0clYtboYSpeyULU9wz9Nc=;
        b=tXaNOfpR9sWnUoUjbkXSln7zcUFDRoi6napO683fjHQjt9bx9ZVAb2O13Dkv37VyMm
         gdNhpTQ7XQeOVsm/pG5wUgo3J8TuisceHl7BIwrzeWDKb9yEsPoAGjiD9u1foffyOw0h
         1pe25RqtyfNy68FjfUm5/vDW/uEIklqkUQLdz+xIGpiv/9cusEsE4J5BhVksGx3iE/t8
         IUGCa1aAFTDtuFH+ij1eH1N82Um9/fkCdmopOWAuAT+N/RzAwwiFdpwSFoLeF8C2ToIi
         Oz0St4OIuDxzhla93b9WajOTdd58yFQ6BjAtnnzPDsJdb8P9otlqUH1qAoxpeO58k7k9
         CZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460578; x=1754065378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u74rPH//c6SnB7FAtWzTEu0clYtboYSpeyULU9wz9Nc=;
        b=RRkb+Ty8zw3Dq3EaER/hhXD8UVcLNzAjtxrH9CIdOS2QZLvudD3tI9QNALXcBi6J/M
         zWZkKvLvot33IXIkjj8tKgiFrpnj8qS6ARdtxtu/kglvNc5lk2P4T0WAs+WF2ic9Hzri
         Ucwl/NHeb8mG9FQj89OB+OOriQ2b0DOQabWRwUFWih/rIFnMIOTzdSeMLHs8FRQjA4pH
         milMxgDTGDPDZTKg1iW1H0vgjSPT9p3Ma4VoLLyCNaYV/SUneFH0UDggUfXjCzsMZod0
         H7RoZ4FJP+KDZV8DcF/hjhtif/DXXDtrs8DrQFJuwKgWZ/rswojbcbYjJ+hNoqhNJIXR
         s5mg==
X-Forwarded-Encrypted: i=1; AJvYcCV+lmKh6zMKT8vUYpWIFLdeCi4lIuyn4Yard/xZ92xFwPN12vVVjSupkfJTw8JnZDhvkek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0ckXUPqooi4dpXHpBywcJ2t0CxQtfdAYvQOjY5juA91uMX+/p
	i4nZi2vDlgrbKreNtf+YJgRr742ohuniMe5hBcha5EGIRmFIQ/IerGkXZynPRiOjQP2uJ0WlXxJ
	teopBovEHapBFNUfl2cRcYPhrTc+uz81MzY4BJNWt
X-Gm-Gg: ASbGncuNaHjZpE1mj+thWMvEtPbR77+Ym56HYFRyb8iu/sHvnflPHoYKemhkVf/VUym
	KpAHW0EHpaq3ll38hDDMODjJN7RhV9fPDBfj6FraZ6Ta/e7QOXM8LSAFB8qppFkoNkuoa8+BeMT
	gWu6O1yu2dy0+ZwuQFMeHTRD3CHHJQfqOhqn5iGRb1Xk+QS8CrjA6HWxziJVzbJ7FU5Xq3wXWcW
	0l0XM4=
X-Google-Smtp-Source: AGHT+IGD5SL618OivdHgf3YPz/VJY7lvtmasgb/RxMGs4CnSxgWUrrNPAHtyRyqEw8bJFf0csvVrx4dlWjbdmBruZJs=
X-Received: by 2002:a05:622a:1a9a:b0:4ab:4021:b919 with SMTP id
 d75a77b69052e-4ae89f706d1mr4756631cf.26.1753460578147; Fri, 25 Jul 2025
 09:22:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
 <aIObyUg77Um6VB45@google.com>
In-Reply-To: <aIObyUg77Um6VB45@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 25 Jul 2025 09:22:46 -0700
X-Gm-Features: Ac12FXwiy_BB8KHm3Sk8akfrBLEAKIqgsoVUrcDSZxShyAtLyS64CyISJLMjXEY
Message-ID: <CAJHc60y2-NvkyaUEsy4hKnGTwQy1HJSa_Mp08xfyeQkvTKWn2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 7:59=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Heh, without full conext, the shortlog reads like "destroy stage-2 page t=
ables
> from time to time".  Something like this would be more appropriate:
>
>   KVM: arm64: Reschedule as needed when destroying stage-2 page-tables

This definitely sounds better :)

