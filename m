Return-Path: <kvm+bounces-14714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A3F8A61B1
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2037D1F22A69
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256731803D;
	Tue, 16 Apr 2024 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjQEDMVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092611C92;
	Tue, 16 Apr 2024 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713238000; cv=none; b=tCr4DHNWhVpFoa4AW8VBGbL3cK0PGjpvz3zKtI91Hg/omAAKCiny8POV3GxFGZkvxyuBarxkmMI2Qa/2Uogl1jYbP+gIzKTK04QRdkLbQ3L4z+bcEnGyGB2RQurFspVHPpTY6noKMw2cwJMJuKesnJFwM8VU1J9wq25v7CYiTb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713238000; c=relaxed/simple;
	bh=mSo87wrI4SUul6dOUELPanCj87ouMVYaGJuolIWl2OY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=mijXqbVVjh7QB45fJQKf4KCjD7cHKTRJav5RnLOi9KOWWWotiXnzsm48GTBlvBDU2151XXQ/M7qoWa3aUfhS3ibgcrWAOQk7IOMoFg+ziuuJs14YR73LSQRtBQ5V+2CroeTGk46Ksn41exPtZEa9Kid9G1BZWWGPFFqlxd+X5LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjQEDMVm; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso3036956a12.3;
        Mon, 15 Apr 2024 20:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713237998; x=1713842798; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1fKVH44Qpf52nV3xcVtDJdI4iDiW1jMW0xvMeM9U7A=;
        b=AjQEDMVmg0b8HwRpV0JWcQJ+s2JUXJe04LvgriC3wXxOjU6A+C9JRe26zcZdA2CN0s
         mikfjc2UiTSjHf2b8HOB/9U35ueX4oBCU0+6ZWaTjCMmgIlzrKCdo72TY9gIdZ9PmEUQ
         /hppsPyZNxmzG6AD5vnDIe5QrH72mtgBZNV8yw2H0q7cOIff5ATyVdrjTITg7Y+ePayL
         Rw8COEuNLb9UyxgmjCpvRbm/jDLc4LVGXOGeF7OiZGnFmyOxt/kuFWW3r1V9DYBIdaQF
         hHqfCZG1bAOVraV0rnPsBcoM72LBdS6vIYewzkQ1+TQBHDoNNqGZ2eJ6EY9/Zh+IY5mx
         T1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713237998; x=1713842798;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V1fKVH44Qpf52nV3xcVtDJdI4iDiW1jMW0xvMeM9U7A=;
        b=udF70XU9TlBaX4rhlKFvBPTB5qcy4Wun/Tu/Ka1oUDrVDjAgXRM4k7bGhCFUwzdjtd
         UMdxtMNnIJpQn/NW3O7zqg77SO0iE7RKHH8JW9ZGvlyjGBNEHms5Jy1cECbi5EsKOVpB
         q45xQYR30LRJmIZLVDHabnm2R79DkW9Lf7MBqvQzDEoDJU7TBrDhabjy5hOdsvRarbGK
         WPK4ts+e2hGcly0Sh+G0oaz9vx4wROBuiV8lqP7IhycRsdpbHyt4gToLsk0SVUeSCuTC
         L+29lWwIowI1tLOmy8kHcFFHJ0gOKS+/asOJ3GP4IwDEpHIYc+iMQaCm3Szlt7rt+cuw
         rlgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMbyUNYuD/qOJvVoohAZwowLWDar37c0YEoSXLsafGM+vH8fmNQcDyIgCxzRbZoA+rWzmPez80Kom523aB1YQbL0uU4LJ4Gdub0qrpuUqc/RvWsHWyGNzQPv+QuQmFOA==
X-Gm-Message-State: AOJu0YygK4SjUcy9t832QnIt8zEktBHubKa3oT0RjZoP3aVeQzrZMgAi
	dMi2MiBZF2Hn6183MT28vjZscZa6FgzbpPziWH0CFi43H9wAOeLY
X-Google-Smtp-Source: AGHT+IG5x5Eh/Udr2OWTDSmF61V8WPyGJpOzKZ0mm5b1COfHDZpLuwTMMl+u7FXvmjLfRKTR71F77A==
X-Received: by 2002:a05:6a20:718a:b0:1a7:51e1:258c with SMTP id s10-20020a056a20718a00b001a751e1258cmr12219760pzb.61.1713237998278;
        Mon, 15 Apr 2024 20:26:38 -0700 (PDT)
Received: from localhost ([1.146.57.129])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b001e4753f7715sm7263967plk.12.2024.04.15.20.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 20:26:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 13:26:28 +1000
Message-Id: <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
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
Subject: Re: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>
In-Reply-To: <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>

On Mon Apr 15, 2024 at 9:59 PM AEST, Thomas Huth wrote:
> On 06/04/2024 14.38, Nicholas Piggin wrote:
> > Tree here
> >=20
> > https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck
> >=20
> > Again on top of the "v8 migration, powerpc improvements" series. I
> > don't plan to rebase the other way around since it's a lot of work.
> > So this is still in RFC until the other big series gets merged.
> >=20
> > Thanks to Andrew for a lot of review. A submitted the likely s390x
> > bugs separately ahead of this series, and also disabled one of the
> > tests and dropped its fix patch as-per review comments. Hence 3 fewer
> > patches. Other than that, since last post:
> >=20
> > * Tidied commit messages and added some of Andrew's comments.
> > * Removed the "SC2034 unused variable" blanket disable, and just
> >    suppressed the config.mak and a couple of other warnings.
> > * Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
> >    the fix for it.
> > * Change warning suppression comments as per Andrew's review, also
> >    mention in the new unittests doc about the "check =3D" option not
> >    allowing whitespace etc in the name since we don't cope with that.
> >=20
> > Thanks,
> > Nick
> >=20
> > Nicholas Piggin (14):
> >    Add initial shellcheck checking
> >    shellcheck: Fix SC2223
> >    shellcheck: Fix SC2295
> >    shellcheck: Fix SC2094
> >    shellcheck: Fix SC2006
> >    shellcheck: Fix SC2155
> >    shellcheck: Fix SC2143
> >    shellcheck: Fix SC2013
> >    shellcheck: Fix SC2145
> >    shellcheck: Fix SC2124
> >    shellcheck: Fix SC2294
> >    shellcheck: Fix SC2178
> >    shellcheck: Fix SC2048
> >    shellcheck: Suppress various messages
>
> I went ahead and pushed a bunch of your patches to the k-u-t master branc=
h=20
> now. However, there were also some patches which did not apply cleanly to=
=20
> master anymore, so please rebase the remaining patches and then send them=
 again.

Hey Thomas,

Yeah the sc patches were based on top of the big series, so some
collisions expected. I'll look at rebasing.

Thanks,
Nick

