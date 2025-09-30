Return-Path: <kvm+bounces-59201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6911BAE2E7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEFDB7A691E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0BE30EF7E;
	Tue, 30 Sep 2025 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iQA+30qK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D84530E0EC
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253312; cv=none; b=LkjNkanx9Goht5DVytToEK2TXpgqFu76yK6k1r4PAAShqUhW49isna2PHOOeCtpXxVYveLsl2FFpPSW18M57aH6i46ugyGTvzyP9ykwb/b47Lxg2WWLmh787vv37ULbJ0+r5vxcltxp62/Ky0FaoSGlqp4A5a+4vRsBraDeS40o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253312; c=relaxed/simple;
	bh=8jRlKeUeTgvCAG6vBd65KFHhND1wW3s5Gpg+/40hbrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bnsAlL5Eyxoxu9Tn8WBYHNY+fS2/mXc7FUHPCduF+4c71tADkN+2ytu7kIgQpHcP+B/nZ2/RNdFAMgVta1n0m+CGi/UL0v/pRfANI0z7u+Ba5wl6g6CMOiHr1mqBwyHxWy5hP42AGtS2QnzeXi+55vrAnkFrwIaaHVbQxp0Ctu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iQA+30qK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759253309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4NXR1mC7DgJ5rOj2YuD5QZX6IPdu9t+7rJzFPa0CR/Q=;
	b=iQA+30qKXn4ganiKTv77zt3/RwKUv7+owYhw+tpOn79rH9xWB2Fr/wwSiCDjj8onE1UlAk
	Fy6J+ZOJZ9fZ/87MKIrip5S+/OPi+OPnxGMwmK2MEgAVrNRzjjeIp7Ow4CPsflruwX82ld
	iUoUXzWSYpSuP0hCmremZG2+FtY7YnA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-4FmYL6TUOyWAb7A_kGBXsg-1; Tue, 30 Sep 2025 13:28:25 -0400
X-MC-Unique: 4FmYL6TUOyWAb7A_kGBXsg-1
X-Mimecast-MFC-AGG-ID: 4FmYL6TUOyWAb7A_kGBXsg_1759253304
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e4d34ff05so15165175e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253304; x=1759858104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NXR1mC7DgJ5rOj2YuD5QZX6IPdu9t+7rJzFPa0CR/Q=;
        b=SKbo6f8ExHamSDTqyWaFlSEnz67yEZOj7ZeSYkU4LQiMBE5X8Pm/v/fz8H9CVHOb5T
         s96CSYZ7+xwJAK+c0HCBuxPHyxWE+vkHlHu9YQJKOnRrlg36yJ0q//liTwf4xd3s9hGg
         G2Znv6rRCZ6mXDvtYHIEIOWV7e2aLXAMA6rwwLb+YpOhITqT5Gf5HQTkQ+vR0yzPN4rm
         AgEocNSKJHEHH0v4oT3y1P9oIu56PG5wQaJI8V7cE8x3MnKSlZkDO6zktTIhmkzflg71
         CGBTS4IkEj7yAVisNEHS7KM2uY27Lnb5YC4bFfhTGfFfrwZTXn/GJpEZYAmwf5uIuDLM
         gbzQ==
X-Gm-Message-State: AOJu0YxAYl6yupHU8pt7yH3rbkT9qbDl8wLv7fKyL6t6ObrpWa4YluRU
	TJGB5on2nHfUUUkpYVYEx7h0y9aBg/e0aPE46RKevgwDV8OS1l9M9p2AIM/i+DG1LJbeDPWOiuQ
	Lph5KY9N4ZC+2xc/0a2oX3cyFSrPD9yXvW014tHujilQeeMtmcDnlPepdapfKSUwexdUezTRXjI
	0XfP9TKdHEpTUfjqRf3CQTraTKFuBv
X-Gm-Gg: ASbGnctd43zwd17jMC+cMwzVp7Q3jsyJsgB3xcRUGQfKUaeKGVcD2B5yTCWyRjfYL3o
	WyetLCoiu8T6KftJagrcHjOlPk/jR1rJ4LcnN9tiFHyxEilYMGzsNCeLZGyU6iSJsKhZ802leqJ
	53NTghEXwkc80menonWIjtzrhWFyy1kmzFYcjLCw0InE+94q/RpAXhIJ3H1g/nboEL1erUSqVv8
	iOO5x8Oy30IqpK5y5CFS24cxhJsPGCO
X-Received: by 2002:a05:600c:3507:b0:458:a7fa:211d with SMTP id 5b1f17b1804b1-46e612875f5mr5819075e9.29.1759253304109;
        Tue, 30 Sep 2025 10:28:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQ6pJtzlzv4iBRvds7S19SLjIxjS/LhQX/L/cdPjj/fECk6uNJJci/M8sfWS6rimLaQg8fqfWU2rFk0keWEB4=
X-Received: by 2002:a05:600c:3507:b0:458:a7fa:211d with SMTP id
 5b1f17b1804b1-46e612875f5mr5818895e9.29.1759253303703; Tue, 30 Sep 2025
 10:28:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-3-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:28:12 +0200
X-Gm-Features: AS18NWAjAd0J2HQV6oJt-Vre9Wcakmj7QodFjkMsDMAIdm-NKd4rKP2XywcNkls
Message-ID: <CABgObfZJ21hXnpdR=Q_SkApFRcWfVOQK3fsZP-evRzOZ2yL5Og@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: One lone common change for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Tag says it all...
>
> The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0=
b9:
>
>   Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.18
>
> for you to fetch changes up to cf6a8401b6a12c3bdd54c7414af28625ec6450da:
>
>   KVM: remove redundant __GFP_NOWARN (2025-08-19 11:51:13 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM common changes for 6.18
>
> Remove a redundant __GFP_NOWARN from kvm_setup_async_pf() as __GFP_NOWARN=
 is
> now included in GFP_NOWAIT.
>
> ----------------------------------------------------------------
> Qianfeng Rong (1):
>       KVM: remove redundant __GFP_NOWARN
>
>  virt/kvm/async_pf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>


