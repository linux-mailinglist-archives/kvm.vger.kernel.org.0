Return-Path: <kvm+bounces-16474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7ECB8BA678
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1193A1C21E16
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA422139583;
	Fri,  3 May 2024 05:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZpBwv0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31F1139574;
	Fri,  3 May 2024 05:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714712557; cv=none; b=ofLAVVItcQ1bO9smIcrYJ9G7ZYq8wtQkOtN/iWJnr1x5p4y5yPK24HZMEOx+1xTiGriX0cZsGjfWmr3VCOSuwJeDFfUUWnhA8NTxWaSY1AuNcjJ+qTQzj6J8gX7AmzIE9FSgWadD5QF8jIXcsoBmKNXSeFzlPaIJA5a6hDF7l3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714712557; c=relaxed/simple;
	bh=cBnukY5BlVrNn1vJZEl4M/AF9tgtsErHvbbW5hT/4YE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=YM1wtMOrfZo/Uig9eLLOw8hqqmH+Yb/Z6Tl6RIB8kZXm+VAoJyPOipOmWBeDNlio3Kd9NvkjxjF1Rr0rGEt3E1qMRnR+WU+RSfi8MbbusWyMD+v5kqJfSi7QL9vTXAIywdXmluJnkOwH3NfdWA0qgYI86PGNbZQTrlDT5hkUOj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZpBwv0G; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ec486198b6so32050455ad.1;
        Thu, 02 May 2024 22:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714712555; x=1715317355; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSj/KgnGwyOGI4p8uMj4rCvUcJ//GtBOBEMmF6tDu80=;
        b=kZpBwv0GldRzEHmw26/GgR+HMWVJcZfbiyUmPHoEMpOhBO7ndr8orc7sfnJOdNAt5I
         6wdoD5y7VLFg0Y4GbyFTNkrn6XeO7qHKYXTo/dSMy2+3x8UROx56H7mgm9iV2yXERQNZ
         elc24dMHNwSZpCfv8bTeX4Ex98wB2ygq+evUk2uUyxsNiei5NP06irepvNdO7R6BT8yv
         w17s2krjWonyz9hHYuWnCWv2IpWmC1cUlO8BqKkOVmisGSOVslkWFcYVObvTh1dMo4F7
         YgRJLBt+UGAffZKolT6M9p5RCnJQKOLxc3+AFKj3fhheqb7tptDvwSCdqKRnexo/YIS6
         8zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714712555; x=1715317355;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rSj/KgnGwyOGI4p8uMj4rCvUcJ//GtBOBEMmF6tDu80=;
        b=D+tjV5pcX10CQq8I2jshZELsvh2JAT22QEjCQ+2QaJV1xthmrWOdENwRDYXt0Ie9Or
         Pda8Wl6JgAStLGhFH8TaN2CfsUEqMKPhMu9HqNN2xXcEPyfArxiIzrCCakuTasoyVLq7
         ke62DYbdPH+xcIZStd2MPxOPZQ83fo3uclw5EqMcZwMrAfnowHVGZyxoQngffDfdj1qO
         y9Jy7rlX7hZcaRaeN2CpDDj9lee25aEk7MUxEbbxDj58MBJMYDqDNuv3CcMFSKIwldF/
         Q6y5D7iBLoGxAcDk1ZO123MnhBOxXtsxSiCNjsq/SVKvQZ6YU9SGwKagh2vrhJhdGCFf
         EVcA==
X-Forwarded-Encrypted: i=1; AJvYcCW+2FwEZ0cueQH1hKo2j+OK0Pgtwg5rMDrsYDIjSBZ8bP4ORdWCdPxv3UKNjCJMyZhnEvzs0hnZyqL5VCjX9+Rl0/2wgOyaFIFqvDVAazUv1s/Jy60FK3lMMA2/FdzcTw==
X-Gm-Message-State: AOJu0YyfwQsUJclB/WqlB+maJEV7C+onE1mbE+2JW92gGMWdlmRUFrSa
	hJlV62D1iXQ0QPLP3R57as7Mxu63bV/QQHOIOr/VyZb3/JtVnCw+
X-Google-Smtp-Source: AGHT+IFil96wxl7AFEXpq/OhBznWcb6U94Zimx6qI1nJZL3/eDpQObCrL1s7ZXi943oAIQ3oBq6JcQ==
X-Received: by 2002:a17:902:efd1:b0:1ec:76a6:ea9 with SMTP id ja17-20020a170902efd100b001ec76a60ea9mr1638628plb.26.1714712555147;
        Thu, 02 May 2024 22:02:35 -0700 (PDT)
Received: from localhost ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001e9685ad053sm2287720plr.248.2024.05.02.22.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 22:02:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 May 2024 15:02:23 +1000
Message-Id: <D0ZQV7VH839A.3RQVN9RKAGH2N@gmail.com>
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
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240501112938.931452-1-npiggin@gmail.com>
 <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
 <20240502-d231f770256b3ed812eb4246@orel>
 <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>
In-Reply-To: <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>

On Thu May 2, 2024 at 7:34 PM AEST, Thomas Huth wrote:
> On 02/05/2024 10.56, Andrew Jones wrote:
> > On Thu, May 02, 2024 at 10:23:22AM GMT, Thomas Huth wrote:
> >> On 01/05/2024 13.29, Nicholas Piggin wrote:
> >>> This is based on upstream directly now, not ahead of the powerpc
> >>> series.
> >>
> >> Thanks! ... maybe you could also rebase the powerpc series on this now=
? (I
> >> haven't forgotten about it, just did not find enough spare time for mo=
re
> >> reviewing yet)
> >>
> >>> Since v2:
> >>> - Rebased to upstream with some patches merged.
> >>> - Just a few comment typos and small issues (e.g., quoting
> >>>     `make shellcheck` in docs) that people picked up from the
> >>>     last round.
> >>
> >> When I now run "make shellcheck", I'm still getting an error:
> >>
> >> In config.mak line 16:
> >> AR=3Dar
> >> ^-- SC2209 (warning): Use var=3D$(command) to assign output (or quote =
to
> >> assign string).
> >=20
> > I didn't see this one when testing. I have shellcheck version 0.9.0.
>
> I'm also using 0.9.0 (from Fedora). Maybe we've got a different default c=
onfig?

I have 0.10.0 from Debian with no changes to config defaults and no
warning.

> Anyway, I'm in favor of turning this warning of in the config file, it do=
es=20
> not seem to be really helpful in my eyes. What do you think?

Maybe it would be useful. I don't mind quoting strings usually, although
for this kind of pattern it's a bit pointless and config.mak is also
Makefile so that has its own issues. Maybe just disable it for this
file?

Thanks,
Nick

