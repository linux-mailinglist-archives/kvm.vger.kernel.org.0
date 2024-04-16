Return-Path: <kvm+bounces-14713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F4C8A61A3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28D9D1F23DFC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AE81799B;
	Tue, 16 Apr 2024 03:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMxyj5z1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4522309
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 03:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713237742; cv=none; b=NZKJIJrqq31fUZbJmlc9OHKN4ijE7xM2ZKY9rb46Y4Mr2AwxJgWQt/3FQdFvp3I/GbrOvyuXHM+o2wd6n8AMKS1+ru7KmWu+ttqaE+683ML4PYH//Xv+pn/hnuGSs44THsnmHBAg8aOMRfBjmb/h23VlcPxeZK8aPpenIYe1GCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713237742; c=relaxed/simple;
	bh=zPDkCJtJBmc0pGQ1FEjVRsLWYnihxnRUSyviA7MN8JY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=aXvJ9nx5oEjI4t2Ry3wCe8vRAYI7iD/RnpocL8d9JU1bb8Wnc19WHhkhMFQW4A3U55FQRawRs3AjG86rWw15f6fFR/ioHePGe1kn2RuOBQHLeticDt32f1IdpjIxJvMU+AFSC3XCIpKWhQTJgjkn6LkZV08/EQMWKbOGozXt6eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMxyj5z1; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ecec796323so4114576b3a.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 20:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713237741; x=1713842541; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcJnQ5RsvalqfgaHq+X5NHOJAW/7cMGQBQEcGjm6AK4=;
        b=aMxyj5z1smwqqmlnXyhUyLjBNSp35Y/7H65XLu3Qj4+KkqTtFgFdr0DkSCnTnH8eTj
         bpJ+tdTqQ5qgSqJah0VXgGCNUsh4lBLiRbtSUxYjhsdVsbwnTrlmTZFSJBLz+luB7RnO
         d/MbSyG7x0w5ma4RFvqqRBHGNMITPnFRwp7O+9gPc2k6D5b8kAs7bvxoLSy2p5W6LhbP
         iWTqcuiCYteZCoLPwCpEMa5pbhaRjSSjxFoB+asFVBc+EV/uEuh5QQqvHNW2EUBdCshp
         dLBobmMdr79IFslcoQxU81QVp0gsinKJcyutZ2GVTR0LnZysYDJzBb1Iptjlt5l6DKSc
         tXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713237741; x=1713842541;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CcJnQ5RsvalqfgaHq+X5NHOJAW/7cMGQBQEcGjm6AK4=;
        b=N3Ev54j1BMNV9KGbbPcYSStuluYAi/hXqSA4SatBCncwm0nznYExmIhdpPx75tg5Jz
         p5NtTlQyiCdTV5JLzRPRThLUNTFa/rav8WujgJawWaEuLnHBHhqM3RByUaqj4538pBZy
         05BRyOktTab4eawDDLyySY0U/r5k+sqeR+/sn4mT4xVNJGaNO6a5UO+NKszv1DT3tSQv
         ch0NoRQZmXN4f+/7ecit7m+Gj6sL8V9wijtqnkyUFRcAxyxO3g4cuaiYS7bjM/MIEYlN
         edthlpd/Q0o/Eo/gP0nhrcazfPSpZF669kpPqO/goi9lZ/Sqw7eOXG5fmr76n8L4ZGCS
         6fcA==
X-Forwarded-Encrypted: i=1; AJvYcCW2/W1y+P0hz6pS8k1hFZ+ew42ZXG2kAfOMbT12VhDTiXdj2Hr+D6V8qGeE3ilJJWP41PuQQ+cROkv4pGLoC570szBi
X-Gm-Message-State: AOJu0YxdROmmKkIGEGsmPfdEHahnrTrH8+osXXJnT99ezBHub2nLhA7y
	JaK/26F9UCOLIBun0c5Fo+kq30WnHsicxRbFVqJBHplupWkJxoj/
X-Google-Smtp-Source: AGHT+IFYO16i2vd9ZZV1B0gCYxpWsSZN8AFwZWkx60Y7+LZAzVdjZLxv7JOOvdX6TqkjTvTzzX2sAw==
X-Received: by 2002:a05:6a00:1312:b0:6ea:dfbf:13d4 with SMTP id j18-20020a056a00131200b006eadfbf13d4mr15542362pfu.18.1713237740753;
        Mon, 15 Apr 2024 20:22:20 -0700 (PDT)
Received: from localhost ([1.146.57.129])
        by smtp.gmail.com with ESMTPSA id fv4-20020a056a00618400b006e685994cdesm7903637pfb.63.2024.04.15.20.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 20:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 13:22:15 +1000
Message-Id: <D0L83A745KF8.1KXG6GEDFXSZD@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v8 03/35] migration: Add a migrate_skip
 command
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nico Boehr" <nrb@linux.ibm.com>, "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-4-npiggin@gmail.com>
 <171259197029.48513.5232971921641010684@t14-nrb>
In-Reply-To: <171259197029.48513.5232971921641010684@t14-nrb>

On Tue Apr 9, 2024 at 1:59 AM AEST, Nico Boehr wrote:
> Quoting Nicholas Piggin (2024-04-05 10:35:04)
> [...]
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 39419d4e2..4a1aab48d 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> [...]
> > @@ -179,8 +189,11 @@ run_migration ()
> >                 # Wait for test exit or further migration messages.
> >                 if ! seen_migrate_msg ${src_out} ;  then
> >                         sleep 0.1
> > -               else
> > +               elif grep -q "Now migrate the VM" < ${src_out} ; then
> >                         do_migration || return $?
> > +               elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM m=
igration" < ${src_out} ; then
> > +                       echo > ${src_infifo} # Resume src and carry on.
> > +                       break;
>
> If I understand the code correctly, this simply makes the test PASS when
> migration is skipped, am I wrong?

This just gets the harness past the wait-for-migration phase, it
otherwise should not change behaviour.

> If so, can we set ret=3D77 here so we get a nice SKIP?

The harness _should_ still scan the status value printed by the
test case when it exits. Is it not working as expected? We
certainly should be able to make it SKIP.

Thanks,
Nick

