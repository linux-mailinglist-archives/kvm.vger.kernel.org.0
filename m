Return-Path: <kvm+bounces-16774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0B08BD85A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 02:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 448A51F24087
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 00:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2AB79EA;
	Tue,  7 May 2024 00:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mSxZvyTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EABB137E
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 00:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715040158; cv=none; b=WPXE4CosVsb5Yu7Qs+wjnjVX6+VL2BrUTj2eTKUCvLXQBn/gGUho9MKTnmo0WqPmG1/nhXbGOUSeX+4T476A21uYHtJ28sJhNfj1Cc+D3FFgTknHlALuuQdYLy/wxaUGoJl1zbssmYlfF2j6UI24y713UVrFu4yRpB8d4oHs5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715040158; c=relaxed/simple;
	bh=15cJKyKLPqNYcDyzjosKUq+jCT37iGWoof5g6DeHJV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C/NgqKysKFb66ubiHI8GB3QP0VN05mveOFG9sTJqW1OIADf6V2a5hDgBc8cO51dJs1tLJeo/Tw62WcMXeAwWw+xdbaCLmJJ4gymoLBWlim6lkKjpfUZE+FuN6/FPj8gnH+BdfaPXUG6J6QD9EorlsTgCyf90xV0AKd9H3WSKiOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mSxZvyTW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61510f72bb3so57181397b3.0
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 17:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715040156; x=1715644956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15cJKyKLPqNYcDyzjosKUq+jCT37iGWoof5g6DeHJV0=;
        b=mSxZvyTWCnmud99xDHoglOe6iKkOATbkcjMqoSQDhCGjhqg3uXgTLYiYsLXdgV20H/
         W3/HPN2hRlVzy3JRyyEy19zAb4ffSpo6wlngLC3R5jfj3s08UJv6Tbh+d1eyHrhFJ1jc
         6lWBAlXCEDtETa8e/R7nOWjpmNgtFcI4xEugpNFs2PKzjDwtTi4oqIpQ2PoD40D2w06l
         hMl0OVixHayBGsYr3FPBUtYsbA0LeKi2AamXd2OpjYSUTYIrLlleQ2kFJyN+8HG6KXzQ
         wTEN+K+iGGtL2YENgP3Nl0oMMvFWsR15YJrZo8SL8+d5ZgQ/TWssD7xoJO1DRJBc9xoS
         06NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715040156; x=1715644956;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=15cJKyKLPqNYcDyzjosKUq+jCT37iGWoof5g6DeHJV0=;
        b=HzbK7k1ZmaT4Pou30IjXaopcX+ESXnDcR8/wRddjDE1nxgFvXYMrNV884g7H066FaI
         ddepr6NFbJfSWE2Ip9JYT1KCuFPAiPKdEPJioFuAk2ys1WWY8us/qFugbSOLK2cBK/Y6
         WFz5AKJzvSIH2PnMzcjh4Tlt5RKtXUNYr7T9pbH7lkwYUqHcgzQdv6vZI63PLT1IocQt
         xsBeIS2jHztoiQ605PINmlBhvQpsYv5WQho6N83+aYDqbL27gT4nHcPt8XNQEPDU8WKg
         ktz+NkvpG99RmAJR6HiiIzKh0BiZm1SPHY288hTved8zXNnxCizG37FtSmFdkwCdPZ+8
         l3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKCdEDkO3ykKLsuOMYFLsRPLNzFal0JnTzXv54aMFFLawmjvmea2XhJMTIMMefebpedYZtri06qJHNkpL+FHWjRyUg
X-Gm-Message-State: AOJu0YynjEZZ7WJEbgM1RXdH09vUkZr7qDmNbXkOpgTGmJpjq7vP8D8i
	WvCyAwDiBI6N5uVDd1T+STv0QS8ZVNURrMqXY3XfW/CRr56+JVqkjGx/cpSLiT6mLe32iBsHbDY
	fkQ==
X-Google-Smtp-Source: AGHT+IGjJcUJDgh9831J+SkO33eka+2xiVbPji/tAMba0xVEhcnjrxuFBNAWDai8EHDOzPEMqw2Ey2QSAlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100d:b0:ddd:7581:1380 with SMTP id
 w13-20020a056902100d00b00ddd75811380mr3834160ybt.11.1715040156526; Mon, 06
 May 2024 17:02:36 -0700 (PDT)
Date: Mon, 6 May 2024 17:02:34 -0700
In-Reply-To: <20240506.eBegohcheM0a@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com>
 <ZjV0vXZJJ2_2p8gz@google.com> <F301C3DE-2248-4E73-B694-07DC4FB6AE80@redhat.com>
 <20240506.eBegohcheM0a@digikod.net>
Message-ID: <Zjlvmkw8gvOgH-ss@google.com>
Subject: Re: 2024 HEKI discussion: LPC microconf / KVM Forum?
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morris <jamorris@linux.microsoft.com>, 
	kvm@vger.kernel.org, Thara Gopinath <tgopinath@linux.microsoft.com>, 
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 06, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> On Sat, May 04, 2024 at 03:10:33AM GMT, Paolo Bonzini wrote:
> >=20
> >=20
> > Il 4 maggio 2024 01:35:25 CEST, Sean Christopherson <seanjc@google.com>=
 ha scritto:
> > >The most contentious aspects of HEKI are the guest changes, not the KV=
M changes.
> > >The KVM uAPI and guest ABI will require some discussion, but I don't a=
nticipate
> > >those being truly hard problems to solve.
> >=20
> > I am not sure I agree... The problem with HEKI as of last November was =
that
> > it's not clear what it protects against. What's the attack and how it's
> > prevented.

Hmm, I'm probably getting my streams crossed and/or misremembering entirely=
.

