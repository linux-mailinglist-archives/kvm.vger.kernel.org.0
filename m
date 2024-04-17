Return-Path: <kvm+bounces-14918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 155C18A7A38
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 03:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DCE11C2146D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E29F4428;
	Wed, 17 Apr 2024 01:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmMEKnsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AB463A9;
	Wed, 17 Apr 2024 01:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713318053; cv=none; b=bb5J5Mx8G+L6mjwrxYHk5HGanjV4IGkDGyciUYCPVv0OwLDf/S/YrsC1JWKCdoiDzT5vmOzUFxHLlDrIIIM04UxQ7iCpfqp4T8fvxn65jPL4XIWA6lMLc+WrZ6ubw6uFvPFQURauxzKbb9nf8lSLv46Ybhh/IneMDD+qNOn4cbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713318053; c=relaxed/simple;
	bh=qd+oXhdytQdMGQjfxPuaaFQdJ9/xiGThuh+6RN0NtNo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=adLmtgUh4V0AqymCuK3y6uYoznhrLK18T2UUHnrhCWx3BcPoQDOJ9vJOxrvGbVR+naM+pDYRVQkSN5a9xwHhnn5phev7Et450FiUNkZAsJ/l5YjQ3A0p+KuQq9XdgfUSH/phaHTtcNb6ooofBusUwqKpiBuiO0Jg2YQbdDA/JiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmMEKnsB; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a614b0391dso3473765a91.1;
        Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713318051; x=1713922851; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6kw6dCQ+cydDghFyBvYaAs0p3Ma1QKkt6qhRC1Ap34=;
        b=fmMEKnsB4rbUTUAs93w1/FF9uu3HbInuwO9K6tQhYafnF18FEDNXguh6p4yZ24Kc7q
         4feeTdD9aecW4x3mdUmzSmEoa7ixdYUwv3uSK/Uwx9cwjK7mrtv4dAOFZIqowsW86HW8
         ypa+9wM0O9JXuG1ozU04rLKhtkjtTVsDr8x7/kTaTsNNTPz2FHHc4eOGHmCInPMwS2pR
         V/EQW9atcHDDWd/bfys2SxiyWyTAY3C6FUD8vOHXRqe7+IxOPHGgRJLQABHM5DlZ5NAs
         PzqOXuMqs5E9bAZ3IINaamc6RxOGQY8m7gt0ii8wlNKZSoWKpOThTwp3CZ2SrvTXMa3U
         MRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713318051; x=1713922851;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m6kw6dCQ+cydDghFyBvYaAs0p3Ma1QKkt6qhRC1Ap34=;
        b=bd7zp+eJMedMxYNCQf77PgPGDiec10l0phN6LcJNvTFmyar6lrQbvfQzuRuSlVzNuO
         UVs/fVSa80zTI2LM4sE7aHQHga8uiwWo1v9+y7iyZY1uu/84nqiQmDdWTTwNiFC+jrC0
         IWgxWdmeEewVy3t8/J0/A/baDSMcd9xsvCHnD4aOH4eduKjPaK6NcRtZ0S2wgUP62OLe
         OMf1iaLP6cvGN4A5ZEJJcS64zRGCaq17hUOVnHrqu+Gbg2qD0HvWdoB533zYsbcJ+BB6
         19fNaV/taub5F2f1fBicKmAvUUiwIMez+2T4wB++ZeKJxjmB1sfWh1oFmTeUOjswsh61
         ouGw==
X-Forwarded-Encrypted: i=1; AJvYcCUCmoW15yQnF0RMfoMV2SKKg9zbhH1h/HYLUt+5eni4z0S8C0uJsMC4SpDwSrGa/0MqLqiNYmnRXVAdXmzqebKjoMCd+F7M427p7441HcRtancz6ErBzdX/A9N5vkDerQ==
X-Gm-Message-State: AOJu0YxZES6vPn1gvVuo5Q3HleUM/okkcyH8vJa0xvAT8Q/PwSmMdU8e
	DfY1DgqVeib2HPrYi2D4kwMUtryhItmFScz77vDHkMUMgZs6ybf2
X-Google-Smtp-Source: AGHT+IEuN9i6b2kO7+yPYNxq5M/Sp0bpfJQ/y0HJK8y0kGe81d5INGjTCRH6pUQ3OUq2XgGUoTKysA==
X-Received: by 2002:a17:90a:d24d:b0:2a5:c3a7:39d9 with SMTP id o13-20020a17090ad24d00b002a5c3a739d9mr11513430pjw.45.1713318051302;
        Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
Received: from localhost (gla2734477.lnk.telstra.net. [110.145.172.154])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a428900b002a3a154b974sm250417pjg.55.2024.04.16.18.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Apr 2024 11:40:40 +1000
Message-Id: <D0M0K25RUX0G.1FCOQS1GR21N4@gmail.com>
Subject: Re: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>
 <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
 <3ed01604-3b9e-4131-9ec0-c354c6d65cc8@redhat.com>
In-Reply-To: <3ed01604-3b9e-4131-9ec0-c354c6d65cc8@redhat.com>

On Tue Apr 16, 2024 at 2:46 PM AEST, Thomas Huth wrote:
> On 16/04/2024 05.26, Nicholas Piggin wrote:
> > On Mon Apr 15, 2024 at 9:59 PM AEST, Thomas Huth wrote:
> >> On 06/04/2024 14.38, Nicholas Piggin wrote:
> >>> Tree here
> >>>
> >>> https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck
> >>>
> >>> Again on top of the "v8 migration, powerpc improvements" series. I
> >>> don't plan to rebase the other way around since it's a lot of work.
> >>> So this is still in RFC until the other big series gets merged.
> >>>
> >>> Thanks to Andrew for a lot of review. A submitted the likely s390x
> >>> bugs separately ahead of this series, and also disabled one of the
> >>> tests and dropped its fix patch as-per review comments. Hence 3 fewer
> >>> patches. Other than that, since last post:
> >>>
> >>> * Tidied commit messages and added some of Andrew's comments.
> >>> * Removed the "SC2034 unused variable" blanket disable, and just
> >>>     suppressed the config.mak and a couple of other warnings.
> >>> * Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
> >>>     the fix for it.
> >>> * Change warning suppression comments as per Andrew's review, also
> >>>     mention in the new unittests doc about the "check =3D" option not
> >>>     allowing whitespace etc in the name since we don't cope with that=
.
> >>>
> >>> Thanks,
> >>> Nick
> >>>
> >>> Nicholas Piggin (14):
> >>>     Add initial shellcheck checking
> >>>     shellcheck: Fix SC2223
> >>>     shellcheck: Fix SC2295
> >>>     shellcheck: Fix SC2094
> >>>     shellcheck: Fix SC2006
> >>>     shellcheck: Fix SC2155
> >>>     shellcheck: Fix SC2143
> >>>     shellcheck: Fix SC2013
> >>>     shellcheck: Fix SC2145
> >>>     shellcheck: Fix SC2124
> >>>     shellcheck: Fix SC2294
> >>>     shellcheck: Fix SC2178
> >>>     shellcheck: Fix SC2048
> >>>     shellcheck: Suppress various messages
> >>
> >> I went ahead and pushed a bunch of your patches to the k-u-t master br=
anch
> >> now. However, there were also some patches which did not apply cleanly=
 to
> >> master anymore, so please rebase the remaining patches and then send t=
hem again.
> >=20
> > Hey Thomas,
> >=20
> > Yeah the sc patches were based on top of the big series, so some
> > collisions expected. I'll look at rebasing.
>
> Ah, ok, we can also try to get in the big series first ... I just lack=20

They should have come first, but I'd written the multi migration code
before Andrew suggested adding sc, and it looked like hard work to
rebase the other way. I'll try again.

> enough spare time for reviewing currently, so it might take a while :-/

Understandable. You've done heaps of reviewing already so I really
appreciate it.

Thanks,
Nick

