Return-Path: <kvm+bounces-67413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 341E7D0461C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 584D13020584
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FFB29BDA0;
	Thu,  8 Jan 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYJwDhzr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmWeMjhn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E224167F
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889609; cv=none; b=RRGPQAUy6UAvdNW+agh280aSCLjzlYxxy0uHW1dmj7aJqrcby8l0FESl58hl0VqSGttRwuCbtc6QQnT1Har4f7UtC+Pz9+6lTqboP1pg3EsjSZAjhUCgjbhCCWMSydYhzrAO5KUK6y55r0hF0BA2V/MUzIw2FwG9r2by6YJXkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889609; c=relaxed/simple;
	bh=TcDnE5qvaDc3YSS7vXonKFmEf+Fri5utJK1HO3xaxFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OCwR2TjaltT7QA0cDmu67QNFZ5S91h2ul51e4oPgyWC47V/z4GZiZ/Xfr+Nc41VUQ35o6tPu/GZlBxIDwU+D1N8tJXtsj6KItIHWEeNsYQr7C+pDtNPkIbUHvVEQLE8mvxBUx9Bvt4F7WTmGxKX6ps3/uot2OzK2Zo7xsc4fWRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EYJwDhzr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmWeMjhn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767889607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KcISVsCJgyrXQOFSAZiH/0oamlEfajFIB58IcXKXFQo=;
	b=EYJwDhzrlX/mcrm8Dqa93jsNK+MDIA84Pi7wgmuHUiGjlsn5BhW88psuBfCOcrdEniXS4H
	uIHyWw/vdyB/cEa4+aeDjryrsz/AdhpLgovpsPJOiiq4KY46Uqf73Zn5jdaN8Cu9s95wJ/
	YGYZq4bO5TPOdCUUp6m4xs5DVYznoTc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-kcQ-XQSxPyyI93B6rCGcWQ-1; Thu, 08 Jan 2026 11:26:45 -0500
X-MC-Unique: kcQ-XQSxPyyI93B6rCGcWQ-1
X-Mimecast-MFC-AGG-ID: kcQ-XQSxPyyI93B6rCGcWQ_1767889605
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4325b182e3cso1631595f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 08:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767889604; x=1768494404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcISVsCJgyrXQOFSAZiH/0oamlEfajFIB58IcXKXFQo=;
        b=PmWeMjhnjyTBU01NHVxEyUs7TY1305x5LstSlY1z9qeEhEYXblRA1R+aDONe0tjqA3
         ca4ECDWT3k5OYiQIubtIoPcjBUaH053BKDGjaV6te+D8gERn7M07wXy6iqY1Bl0KBsuQ
         Z5y62IrX1+RwyBo+ruEUNBztTdVNd8DuFVyKVYej2JILISlGw4dbualomUgA5Fd/3XoO
         5H4mFyq2RVvAgNi1EYj2+0mRTWe+QIj1vNKsVNghJQcHai4revLVXkYWNEfcXJAptYO6
         WwyPCBdToKWY2b0znbMv/kSVRGptc4xemIHtnWsFVfkvYgAjJhgM89PiGG1NKze4k67X
         ohEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767889604; x=1768494404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KcISVsCJgyrXQOFSAZiH/0oamlEfajFIB58IcXKXFQo=;
        b=di7NLhPGpRxVTuTqdu1oR9dNnuQLSJojvPlFbRPduMb0GVi+q1VPprW4Z+FO1bxwv3
         EyCrnkkQiGKdzjwu82/c9JL9ksV2lw9rh2sFsroMhdNoBiKZfHkOD47FKZE+imFmRUhc
         iFqTeZ0cEsXFZukeGlobhoeoaa1b6KruLfhK9kgbJK/7IqnJFVSWTZ/3uQ8zHjoyoADq
         m1JVkT12bJjcqO6k8J8d0Cp9QanCWLfGszdCOgfUP65qLSSH6L0zSgYrMKTdq4c+3/BG
         HI95mWhMkJfa3HeDjCIAYvCU9etP1eQ5RA9Tft8NJnf27TYmWj8LggxnsK/xzFH8Tjm4
         pljw==
X-Forwarded-Encrypted: i=1; AJvYcCVH9yuYjwREvgDhRp/UpFSrrgERFmXgYvrkhgKvtA+8q/8uNBAm9nzPO9le3vqKe0pxdxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTYiqIeHJqpBPvHKK9YMBqWhSEMYOUM/qBZDRxSUK+HGNUxO4s
	wFwBvrReFxfs+62srBUGq7sKjJOxwdzeUQS6JYqXLlyKGaMXat4ldR1UhoLyKGS20C25gEscL1z
	0WgQqivZm3zEFFs1Ch8dBj40C458woWbsD8SKACk3JllQMETjsL4m4L0voDMmwg2cVqaySElpM1
	8xU1kldyOkeTao+sjStcsuy+EUOEIn
X-Gm-Gg: AY/fxX6vyYBe/xBAURN/mLG2ylHLM1ByBA7+xLFd1GX+mHvuwgDXiOyq8cgMlebUSvg
	qGieBf/iNFCGiqUxf1jyi8FROXuMZv/xVPjf9UMSUjYEnj954Dnkk3K5yUGw0D6Wd2PQw6xQ96D
	TE0lyUlQismi2OjSoSn+7pYdkPAkna2fZ8jC8mS+eiyf0TZvA01iSiToaxqoLEv0LNbMkCbC6CL
	Swg1UYGy9XWYdBXkYh1YsnOoC58KvqqAzwY4+QXJIs1FeQr55c7YzizK4B/5wsxsLOj
X-Received: by 2002:a05:6000:2882:b0:42b:55a1:214c with SMTP id ffacd0b85a97d-432c37c1462mr7264861f8f.55.1767889604576;
        Thu, 08 Jan 2026 08:26:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuEIeET8h3W6uEZxJBwbbw9fxFbSf3TPfGzC3PFihaqUtx/tV5O/OFOh8GEgcfVZ0sjWATbOyzNazfJK/JcCI=
X-Received: by 2002:a05:6000:2882:b0:42b:55a1:214c with SMTP id
 ffacd0b85a97d-432c37c1462mr7264842f8f.55.1767889604137; Thu, 08 Jan 2026
 08:26:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
 <959b98b1-fbc4-4515-bc7c-8c146c6c8529@linux.intel.com>
In-Reply-To: <959b98b1-fbc4-4515-bc7c-8c146c6c8529@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Jan 2026 17:26:32 +0100
X-Gm-Features: AQt7F2pBdzRwiZhc6SZz6ZRtf4UB-NlFDQw5YKdy9WxEii3ry597CDwoHXRvJj4
Message-ID: <CABgObfbtdSnzRCsiDHgjnT5OTROMOEgWZL+AMOSFj2+hXOsATw@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 4:08=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
> > +     /*
> > +      * KVM's guest ABI is that setting XFD[i]=3D1 *can* immediately r=
evert
> > +      * the save state to initialized.  Likewise, KVM_GET_XSAVE does t=
he
>
> Nit:
> To me "initialized" has the implication that it's active.
> I prefer the description "initial state" or "initial configuration" used =
in
> SDM here.
> I am not a native English speaker though, please ignore it if it's just m=
y
> feeling.

Sure, why not:

   KVM's guest ABI is that setting XFD[i]=3D1 *can* immediately revert the
   save state to its initial configuration.  Likewise, KVM_GET_XSAVE does
   the same as XSAVE and returns XSTATE_BV[i]=3D0 whenever XFD[i]=3D1.

> > +     /*
> > +      * Do not reject non-initialized disabled features for backwards
> > +      * compatibility, but clear XSTATE_BV[i] whenever XFD[i]=3D1.
> > +      * Otherwise, XRSTOR would cause a #NM.
> > +      */

Same here:

   For backwards compatibility, do not expect disabled features to be in
   their initial state.  XSTATE_BV[i] must still be cleared whenever
   XFD[i]=3D1, or XRSTOR would cause a #NM.

Thanks!

Paolo


