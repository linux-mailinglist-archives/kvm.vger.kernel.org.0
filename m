Return-Path: <kvm+bounces-33338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A09E59EA09D
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 21:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62BFF18865E7
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 20:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D15419C553;
	Mon,  9 Dec 2024 20:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j5DOA4e8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CED0199949
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777667; cv=none; b=mjmoinouNFho0XtmnEIlf2Ngtrbt9ET5m0gUSVq7BfEfMRyBprYdvpF+Mx8ijSPyrUO+ykajQaTkFX2zWWNc4RxXgo7mJ2ACPd3Re7w5VG3yXzhVhuMBYaeC7Q11w53yb4HRj0Y6d1oSMyA/2LBWc6zmWmsmK46ShXx7/XVXjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777667; c=relaxed/simple;
	bh=c10brrxuzg6wg3KudfR7ay5/liXufv4L0mFBI3jOdUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UWMJozmKB+ajNxm/wjgMU4D2a3z3E0D3XBfJtS4VD4PDWp4CEcgauVtn6jFL0w7sh2UdmF7dgmsJD/IfgC39Mk2qZC5Ib2Wz/nVzrM/6aZ71fUf2iKkU+y6/hQuuNimXGEteak68uR3KY4/Tb+xResTpqPgckwGGMT6Jk6mwLiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j5DOA4e8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-215ce620278so41069215ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 12:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733777665; x=1734382465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUtf5/eTNdk+7XVgcYaZXMh2nWeqG1Qcvae0c0hqdJk=;
        b=j5DOA4e8bAbWRqK25I68cShFL5TK/VAMk+IDG4SvFUgBfdwosX0lA6CfXXTAO5+Auq
         xaq35Cxk0pKZVhZQWHOucj/beIxkXFmXFr+cLxqzYKW9NUdC/a7f0YzaNtT4r4Bze+zz
         3T/FtCAY+/HkS/ZKa7/kw5eig9ldngbggzInSF6aagqCtTd9eNNoxdKA33jC2mw7JwT2
         l2iuu+ERdSImwjjCk7bRcwqQfeUH0jX7mfuTSOVbr8utI2QgJXLSBTtqCATC8Q2vQ9LV
         Dm+SMTUNjNrOzdQ/6FzUQlNLFJeUfqs0KDYvS9GlFvQlS9U6zq8ZXG+NJw0SzlK0fOh6
         EboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733777665; x=1734382465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cUtf5/eTNdk+7XVgcYaZXMh2nWeqG1Qcvae0c0hqdJk=;
        b=eeVx4PjkkbuR2JHTERPxQmbQ/R9ksZ5blCfQg3lRL0YLoIoyk4wiZczVBlEP63DL6g
         rPEqZpMxV1o6m/6tIgA8mAZwvdVy50wX6j/BLrIhIXltHG+XIXVnAFOQkGnnCI2a6u5/
         kg1iZ4ghF/3Vd2cvP3wv7b4dSX2LNwx4yirNn7crpiQEZwxySFROY3j4pUK9yYK2+IM6
         71gnnnepCvud8SJke+wB3J4mYe3pD6wi/tfZoZ7wXAmPlEJpTINlXPMWbT5gLJ+yWxI4
         aC1Hs11hqY6LhvBsgXcBJ1AVyyHU4fDdoM0XLf6pX31YPXt3J79j4ot6xMXSnpi7PxRs
         /3yg==
X-Forwarded-Encrypted: i=1; AJvYcCUbdyItScyJ+rjUaEHBYrW6iqG7y4IhONTsZLQei6Di8m+NUCQH3Hu587HaUhgreJG5Vpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeVMwXaLLU9sk/FmzXUNJxbjdLRcWtQoRfVBIJBXb7naUG6MWx
	kH0kNrM14Cvi5T+Vn7bWG6vsn8t6TF5H2lyvhQu9tdcQHktJLroV38/T3Ccvy9Ag8BzJgIURAk+
	Rdw==
X-Google-Smtp-Source: AGHT+IEgwWsSdCP86oDj3I6Mk9CKakDYnZWtR3qpDkbrahSuYqYHViSyFLWRs89IfZfnLn4VxGFWpB5oCU4=
X-Received: from pldt4.prod.google.com ([2002:a17:903:40c4:b0:216:271b:1b41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:94c:b0:216:51fb:bb28
 with SMTP id d9443c01a7336-21651fbbd41mr70943585ad.51.1733777665529; Mon, 09
 Dec 2024 12:54:25 -0800 (PST)
Date: Mon, 9 Dec 2024 12:54:24 -0800
In-Reply-To: <20241209204414.psmh3yyllnwbrc4y@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241205220604.GA2054199@thelio-3990X> <Z1MkNofJjt7Oq0G6@google.com>
 <20241209204414.psmh3yyllnwbrc4y@jpoimboe>
Message-ID: <Z1dZAD4_kgmm-B-_@google.com>
Subject: Re: Hitting AUTOIBRS WARN_ON_ONCE() in init_amd() booting 32-bit
 kernel under KVM
From: Sean Christopherson <seanjc@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	Kim Phillips <kim.phillips@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 09, 2024, Josh Poimboeuf wrote:
> On Fri, Dec 06, 2024 at 08:20:06AM -0800, Sean Christopherson wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Fri, 6 Dec 2024 08:14:45 -0800
> > Subject: [PATCH] x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if
> >  the WRMSR fails
> > 
> > When ensuring EFER.AUTOIBRS is set, WARN only on a negative return code
> > from msr_set_bit(), as '1' is used to indicate the WRMSR was successful
> > ('0' indicates the MSR bit was already set).
> > 
> > Fixes: 8cc68c9c9e92 ("x86/CPU/AMD: Make sure EFER[AIBRSE] is set")
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Closes: https://lore.kernel.org/all/20241205220604.GA2054199@thelio-3990X
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> LGTM, but please post as a proper patch in its own thread so the -tip
> maintainers are more likely to see it.

In Boris I trust :-)

Already in Linus' tree, commit 492077668fb4 ("x86/CPU/AMD: WARN when setting
EFER.AUTOIBRS if and only if the WRMSR fails").

