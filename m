Return-Path: <kvm+bounces-27646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2079890BD
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 19:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E5671C213E5
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 17:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293BA1474D3;
	Sat, 28 Sep 2024 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rfrbyb6R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1CD1E531
	for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 17:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727543964; cv=none; b=QlY9/hia+kNfrXyWG5ht0h+/cdulbqkT5sn2FFM51NgyR0kw6ntIf+OxItcBCZlLY+VRI0bdmk/MEZiYVqrsTLFSJ2kw2QSR1HtVNlZqc9BNfW8Pgsl8OBDy1sfLaD3OlXSSRP3tOdar2FhfHnVAuF1dDuse2UA1ZGrWoCfIjb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727543964; c=relaxed/simple;
	bh=2TSB1CPY2sIhuCjx+9pYYSA8GwKR8/H0q6sqmvxWdoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PQZTgiN1SSOFldyhRchnMbh21SL4lvGs0L7zQ9XDGMCgyUtPQejdjj0mhN8IfuGaM0lz1KhiY0tyL00oPOj/adaq8+/RTOhlME0itsBuVRrLVO2DbtINtvQkkaVUSuwnNZ4NQ6gw1jAHXCOfpSqtbuH5dq2AdkEfitReE1jifxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rfrbyb6R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727543961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=82LCD7KxVzIhvra31h0O1CH7Wj+PV6MsNIzA9TzZVcg=;
	b=Rfrbyb6RPxkqe4GEKqQgD20bm7IUzeiQ4DhXFBDTN0mjGaG0pOsliUc9f3mIP4B0idVIaZ
	CAjjDg14SRxI1oMJj05tZM6GUKEODasAEsoqY/Jhxcx7sQeGlFjf6Yft/OMB98pMHWf7cJ
	dMvDrT5oWUHwR//8xZyCqT1LuRnxWmA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-QWUoZQfaMmmnCiRmMIVlWA-1; Sat, 28 Sep 2024 13:19:19 -0400
X-MC-Unique: QWUoZQfaMmmnCiRmMIVlWA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb22d396cso26008055e9.0
        for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 10:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727543958; x=1728148758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82LCD7KxVzIhvra31h0O1CH7Wj+PV6MsNIzA9TzZVcg=;
        b=WIBYmYuDJlVNMcvC4tJlsocVlBuyL4lgRia5SQH/A73WvOFXT99QK/kG4hYcomjceS
         KgHUgqvaOPlGaxIEZPuC7kWRtANotruY5ln/zxApyXqYeSSqbNtkCSjFCo6eTelTZpsi
         m2pI8m2ggPjQnz12LG/2rerWPXKMJRHFslT57T1+EDaUJqH2FUCegIHJWOQKWrXx1eCp
         7qtVUciPo0X6/ekvh7vkn3CFjLF0NnW3+IdwdpEDMVJSo3CJHdE+d8nJ+r/QJ/lASxhd
         cDZ4YdIqbBMrE2O+kMBXCdBCM0B1g/nA9OLlUQUp2hXhZ3ZB9D4oBkJMcpMSJYZeOXWA
         V31g==
X-Forwarded-Encrypted: i=1; AJvYcCVHP7Ok7akvs9nwViQf1kOd5IGweCp7qLFQDwMxJIDzSnQdhkomouw+YMFdewjEnGCAIQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcDgix/xTuRMTajCMp1B9768v/ec9vH+atrmLhmUbeqfDcQh1h
	JiRqOXg+5t6Pt6JIuy8F/70j3ZL5k8+eroXxyfpRN4BQNjpOcUrdVePBF5El9nsNaMf6SZLvGyg
	WODJG77UhzF8nAmiiLg7bE0lNeK9aagbVnnuMpi12v8187+EkwZM4rJa5HmdZ1xIC+8gzWCBmvZ
	QdZ16INFcAOgVgWACPdPq19DOt
X-Received: by 2002:a05:600c:1d19:b0:42c:acb0:ddb6 with SMTP id 5b1f17b1804b1-42f58430051mr49407455e9.9.1727543958557;
        Sat, 28 Sep 2024 10:19:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9HUcwpOxxBXh/4z2BJD08nMqibH2v6t8lXePAPcnSjNTnD4IXLSHYp9/jdSHhY8vNP5MargL/Up1r88fl8IE=
X-Received: by 2002:a05:600c:1d19:b0:42c:acb0:ddb6 with SMTP id
 5b1f17b1804b1-42f58430051mr49407345e9.9.1727543958186; Sat, 28 Sep 2024
 10:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928153302.92406-1-pbonzini@redhat.com> <CAHk-=wiT0xehDuhtcut3PFeYnQW2H6Hx9O+1vkkFJHLKWT57Fw@mail.gmail.com>
In-Reply-To: <CAHk-=wiT0xehDuhtcut3PFeYnQW2H6Hx9O+1vkkFJHLKWT57Fw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 28 Sep 2024 19:19:05 +0200
Message-ID: <CABgObfYCBOjDwFfi3-k1ddRLKQ691DP-pnKMBzDGE3Dt9YFwNQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 6:30=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, 28 Sept 2024 at 08:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > Apologize for the late pull request; all the traveling made things a
> > bit messy.  Also, we have a known regression here on ancient processors
> > and will fix it next week.
>
> Gaah. Don't leave it hanging like that. When somebody reports a
> problem, I need to know if it's this known one.
> I've pulled it, but you really need to add a pointer to "look, this is
> the known one, we have a fix in the works"

If that's what you mean, it was not reported by users (and it's very
unlikely that it will, unless they run selftests on pre-2008
processors or with non-standard module parameters). It's a NULL
pointer dereference on VM shutdown, caused by the selftests added by
commit b4ed2c67d275 ("KVM: selftests: Test slot move/delete with slot
zap quirk enabled/disabled").

It's also not reproducible yet outside selftests since the bug is in a
new API; which is also why we didn't revert with prejudice and didn't
go too much into detail above.

Paolo


