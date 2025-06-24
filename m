Return-Path: <kvm+bounces-50584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0AEAE7259
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D495817C4B5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D8725B678;
	Tue, 24 Jun 2025 22:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VBn9UhOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827B32571B4
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750804487; cv=none; b=uNZHk6Zby+LTQOaDiF8TOM1uDrwJoMhM64VYk/xz/9TZDVDT1nnwxxu/DY6zr7yN90x/MVRNrZiAShCWRaz2Qgg5lmD6CklfQli2/1IZfCMFi9aKQbh8quZ038vO4tmZVCRO708vF7rd/Hgbwf8OKAlVnr++yeDRBH+OUEPWNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750804487; c=relaxed/simple;
	bh=mqOQ7YDav2hYhJQvVJTdR3Y18paK1zzfINIZQc/Tksc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tocv3DQW5QgHkrctyWeGuWEEC2NyeLO6/WqEZq1MY42hrWu7rxmVeAF7G9xd6lkqBUCDcXzHVHqhf6lY9g14y8xJ+s/YelBdzUwt1ngIk5wv4aejqtZoxH1sZXHG1dRVGoPWgQ36W5QW6xteLptEOCfbwCWqRsVKXqh+OC7HbcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VBn9UhOy; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso2407a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750804484; x=1751409284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=biMr0EfPKFoYywDXUPvbYBfkKcArAnlyW/BCbuWbl+M=;
        b=VBn9UhOykxXNSsdW8Bj7PbVkHlTUm4XXbndNhXweQDJRtvpdv76dcQNgM4O/Y+RRU7
         25aOUJT84A2L3+o0y84GLpuz1S4D/8anq+JfLziwNw9hky4uoDevKAtHwNRXhl11QFOz
         98w01FORVued0CHPL/XCX4QnZp8B5cP8oMlA63X2ZvQ+B8MWsnEoB/3WZc4iDkr6vnmw
         Fuor6bpZit9DjtVGgtkWD4xTFgrIzMlTK2LjQFd/EypuBuJZtUzgqS0GohYcG03xGp6g
         hdpnYysbwI8UjPIIZENu8LJx7hcHXIzyetEgle2VqtVbcF0kEzwQwG6SykvP8O76J7q5
         Go6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750804484; x=1751409284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=biMr0EfPKFoYywDXUPvbYBfkKcArAnlyW/BCbuWbl+M=;
        b=m7UJIb18YzYtGJeRzDr4xG9xjv/9NWnxgRzj2qLLod/fvNiFmgeivvwz3Qm2DL5Esf
         1Y4PIW3ZwyDqXSFNeZ05F8nb6w//raXIeRl/NN5TGR1U/KuKPHVvzbM5FivuylP5sMwq
         pDrF/7p/de3gxJMmLDZP1dJw758sf8Mp1ekJ8JIxe3XfT9Gs1CK47cqDPUc7UI0Q8lkI
         T1Cd06wZxpRXRs5a5u4/CWkeIHGp2hMoEQscmpl18hYmVsmh2EMeuKhj/d1X2FVbMHWA
         Jha6s4H+aIEQVtk+BR8D6SiR8Dgi9EvLSMsw3n/u+qZFx/NhrOm7vvS+RtNiXSB7vck/
         NJwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2hqyLCSLWFU9gsJCl31rlNOx0Np1lov8ZW70n6kY35xT6Eq7eDxvQlXxf4rxAcEYEUJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9P+YDyayFG9W+52q3r2ea3wG7QXsETTC0LhIlUPy2FRdc8yZH
	bQMRkR8+xtZmjSt2nKw9mGR89ocwtLtJeYCJwMhJehJuI03il+a60nN1LlDbTGRygRjM6WAPV4l
	0NovjECSA66xltFUkj7XTJITcSsCsVWKlzS6fJ3Bg
X-Gm-Gg: ASbGncsjQmwgKw4kVbNyCR5yfK0x7gak6mxb3W8klFai0elLr3AMQVhd1v/MmeFo9JE
	1W9atgcUwtw1ofchIT8OKFAQ5+OMpKedRUkQCWRbSdklMzb1tL3+jHfLCw5DcteoLiNXVl6v1hV
	mUy4N3SelTcsnU4r0ZejljJGmE8D95aUzyZ9uWMX+eJKw=
X-Google-Smtp-Source: AGHT+IGyVlom+ZmT7GXmz0HeL4UsVQU3NyBoFLDHBTl/atp+JIdz2fxGFnYGVwpASG9nZ4LRyNma1LwRWwKsDs1mnsE=
X-Received: by 2002:a05:6402:27c7:b0:607:d206:7657 with SMTP id
 4fb4d7f45d1cf-60c4f9ad7demr4740a12.2.1750804483639; Tue, 24 Jun 2025 15:34:43
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-2-jmattson@google.com>
 <aFsX1anrZGWFsbF-@google.com>
In-Reply-To: <aFsX1anrZGWFsbF-@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 24 Jun 2025 15:34:29 -0700
X-Gm-Features: Ac12FXzCwsN8NPivZZHPiGwh0dl954eI-7CnHozxpVShx7dUnu5f7IkszxcCLmo
Message-ID: <CALMp9eTyvost6ULK7QwCroN0xaO7mmxCqWcywsKMr0OaAJwsmw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] KVM: x86: Replace growing set of *_in_guest bools
 with a u64
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 2:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Can't this simply be?  The set of capabilities to disable has already bee=
n vetted,
> so I don't see any reason to manually process each flag.

I love it! Thank you.

