Return-Path: <kvm+bounces-59216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F6BBAE47A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 580007AA871
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEF330CD88;
	Tue, 30 Sep 2025 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPyAfx64"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB48A1D63D8
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255845; cv=none; b=Z5GFK9WeuKfzZvzfn/qIEqTThgJW2gLvKna7ylWn6vsS+TsuXn8wXLAKYd7ydUUotQjssaez9PvILe86iM/sGaq66c/VrlDc48MkgK6WbAJux81xSo5x+FdRY+ATrC5vIFCZZakY07hEybKs8rm2GCZ93D65PSVFhtZbyYeCxv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255845; c=relaxed/simple;
	bh=gks9rE748iFgDpsAFxxJcMCatjgsFNBnvh91FnPmnK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftqgVpEne3ebD6jTGt60+eD/TweSnkuDDHwqzQSeJCVA2hbL8yiMnjrweo0/7FrtCg4Eh5/hJvKkbxDEuYXEdWCtWXPoC8rRO4QIDETCbmYywxn2mv5jM5iH5Hbg5AikxjOuZjTx6t2fO6TxGNxACUtXsT7TDHmm33HjQPCfe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPyAfx64; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759255842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nw6Z2dvH8M3CUzmbUufot6Bsmkaiw4nKeZg0Erl+RtA=;
	b=HPyAfx6427Zq7u53SMO/B/6WiDt723DMTMgHP9jeBgmTG2Q8tX1p4ZPJ1XOQVzYB9APRij
	nhL75TvnnH4t3sKJScOokhsVI2y89WPkcuv4PJ+PlW82AlW0q6CPCrrTM2MxdWaeIQKfcS
	qbdxYi6vCwcPk4Rc9yqnw0mbHbxWAho=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-ayixplk3MvmHuoJjCiktkQ-1; Tue, 30 Sep 2025 14:10:41 -0400
X-MC-Unique: ayixplk3MvmHuoJjCiktkQ-1
X-Mimecast-MFC-AGG-ID: ayixplk3MvmHuoJjCiktkQ_1759255840
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e303235e8so46103455e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 11:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759255840; x=1759860640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nw6Z2dvH8M3CUzmbUufot6Bsmkaiw4nKeZg0Erl+RtA=;
        b=lkIEFaRJh1tkwfToVkfnWx4LMYiJSj+b8v9/HP8/mWWTOwCZKXBkicTYOn5jS59Eo6
         TIo128lpFCU2nu1PZA2ZM5g4F6tKtdO0Kk+olNjlrnlyzP3+f/REqbmXT4W03/Tny8y0
         SXZUIDHQjqCHkdZKDO6LuBiHdzMri4mJHUOPsClaEDWHkWHbXtAPhVLIRt3X3aBFxsHd
         7oSPa74Zd/kX2ejRU4QZVNP2TOhGtu9WBzZJY4GHA5QhgXsU/hhe99enZNkKcuXiBKOs
         BfutynqJlT+C7WJ/ngDIUK2RSEEt+rCSVPvkmTFaLQmuO/0cj7sp3ipz39EB8Y7cuUHT
         3+RA==
X-Gm-Message-State: AOJu0YxxmAvMaude7aSsmyGEHxQz1mo/oW1V4iKXDcxa+KvmJoqnYHe1
	n5GZSRzpLg7DaDv/s4g9b2ujpThiJBvMCQoJP5REmJKXRhsnCbYTXYKaI46LTXdYyqNdj7238ba
	r0kbvQD7M2cqfTIYNgnyHZMLDj9C7I7iKWsb5qEl0Dpxh+UbgWZorBHLm7s6ABw8dAwPpCMYuNK
	zf5qvhVYD02S7rJEPbfN88dQXMdIoF
X-Gm-Gg: ASbGnctf8KqqW3C5PMIB8uviO1umxBsCiIDa/kK9xc1tqyPM5miUSjSNDc3ENmxnNFi
	CpK6ZYLLQM4q7aT5gvHDnRbg+t40tuoBfqXWLZ/9k5aLApP4cE9kFZp0D7DjTlvsOBSJpvtSPUE
	g4bzkz/OVDbM+kCYHAXs1WwqbaIIvKOYeQaRebpT76pLB5zjRs6uWBKS7fhfn9bSFw+yKZj7DJr
	c+8yryaL9iISht/FbJaUeeZVXOoYeOS
X-Received: by 2002:a05:6000:26cc:b0:3ea:ad2c:c166 with SMTP id ffacd0b85a97d-42557809261mr477643f8f.49.1759255839991;
        Tue, 30 Sep 2025 11:10:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBCG2kxTA80bOiFWd587Y1SVn/cGwf2yGHcuXWo5P7wNBcb6wa40dWh1o866qphPlRt3lLg8JAwzqZtui+3cA=
X-Received: by 2002:a05:6000:26cc:b0:3ea:ad2c:c166 with SMTP id
 ffacd0b85a97d-42557809261mr477628f8f.49.1759255839647; Tue, 30 Sep 2025
 11:10:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 20:10:27 +0200
X-Gm-Features: AS18NWDYgoDBpwI0tWh7HqFmhsfEhAU0pt8W-xzFoHlkOlaFY1ZBZoNnnKuMWas
Message-ID: <CABgObfY6iEKbo9tLAGdsKhK3vYsFW3MB_6X4ay8GAmQv-oRBGQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Sorry this is coming in late, it's been a long week.
>
> Similar to 6.17, a few anomolies in the form of external and cross-branch
> dependencies, but thankfully only one conflict that I know of (details in
> CET pull request).  Oh, and one "big" anomoly: there's a pull request for
> guest-side x86/kvm changes (but it's small, hence the quotes).
>
> I tried my best to document anything unusual in the individual pull reque=
sts,
> so hopefully nothing is too surprising.

Quite big with CET and the FRED preparations, but no surprises indeed.

Because of the conflict, I'll delay the bulk of these to a separate
pull request, probably on Friday.

I have already included (and tested on top of 6.17) the selftests,
guest and generic pull request. Everything else in kvm/next. As I
mentioned in the reply to the individual PR, I ended up cherry-picking
the module patches. There were a couple preparatory patches that I
guess could have been in misc, but certainly nothing worth another
round trip to the west coast...

Thanks again for your help with kvm-x86.

Paolo


