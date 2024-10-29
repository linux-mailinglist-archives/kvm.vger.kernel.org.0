Return-Path: <kvm+bounces-29966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B04829B5016
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21741C2285B
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F1F1D8E10;
	Tue, 29 Oct 2024 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TvQrpHPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAE17D355
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221583; cv=none; b=SJCQ5ODG0SnWSsVeFyt0xep1oIsBaUObQZ6Tg4aHZptJuk2Gno7CiuJtR+PwJz7XVZljZWsY+QXggTHyeHEWQQKh/zHCkXhKRN4Os79oHEucgn1acrBWdTQrSbpnMDv0ju1poS685hsoFqjX3ZbsrGBMlniqN2fpikJ0pEZ04Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221583; c=relaxed/simple;
	bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JHuA56Hf4qX4ghK0MDVfDmmBJ9zOzAHHZRogxksPsUTrelVqqL1KxVbIiv78q3FwoMkBJaysHvPNx8GLaUg6NiRjEw4M6XWEq1Qb8jAkGz2k9Di5rVw/E9a/iYZbw4P1rzzzTbA6pQ/lLbDu16vyeogLn9UfUH45NNlOOpSS39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TvQrpHPW; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460969c49f2so14231cf.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 10:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730221581; x=1730826381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
        b=TvQrpHPW48i2cLaPlDkNbBUsNhaYyMrxXKXWevivPFK2jnFePvrHgn7ZvsunOtYP+4
         ctR98C6cQs2yw3Em1oh56wUtUCQHhYoH30c/CJqqkeq8kuOw3iMvdREV4Vu1U/1L9VM2
         BN846jc+J5iWKBbCRlTIYrY/F5dHpbPUEyFpa6cVxsnKTm8m9+aDET3Pd4DkVeMU0GNj
         sSXcTxg4ERVCy1V8qHPbAS6Bt7uN0mmcHrK72L36Y7NmaNU7LfF9WkvK0NDK6+XHtwhK
         f2uVpISbqtmP6hx9ZPX5Zg/5yF/c2WIrT0R6uF3r17FgJJ918rnCRSVdHFf7hwMVWIgM
         +DCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730221581; x=1730826381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
        b=gfYUD51+mzCPOJrIuPXq/g/dL8qpWR2/ZMLwl5Ho+oxVbUSy/qzBaxoUZ37Koz+yxu
         cYJtInkDsWjZNwIQtoj6FNGTFQ3UwqCT7wvRldSkq5OlTSUmuQp3X73ZZcBMYANW9IXS
         BSZRaObAkMEMTa1VpBBidqRy6S3rSh5yLw1PSr5AlyoHvEo3HofFl3eOgOyo/nvmz6jY
         2vREWjYlgsaFHa9IBcVpiyoSznK+4Aiz3GtR9YjHBk3uQ3LVIiMLFk9+BaHopJizCsvk
         8Kuj3UlyZOTa9Llik0I5F3PX3iizfc/Dlv+2PK/BqkSfN2EXZJvT5BBqfhA5cv069Ijp
         w62g==
X-Forwarded-Encrypted: i=1; AJvYcCXZWjpJ6TEYtpYNBdPSRGMGTnYNBARw1QVw2+nbGqXqDoW1D8IkKKjL6t5heRUJgjZCBdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW7UJGVplJ7MMHZSWO4EA0V0xBY7xnxD8mkvzveWk613zxvbZi
	PNe6KbuS/tbs6dh1LVjmBq22RBJ7gBy7SmSy4p21TFXjq0hBJFA0z9eCSqDs8JMpAT5Zc8BArra
	n2YIYBJjwmB6iIRKmn0j46+M20ZGvZeEB3ue3HHA/wzsxTU12byz1StA=
X-Gm-Gg: ASbGncsg7oOn/BIlxlK6BVXSr00lsal200XWA9Y8+18CSOLaXamh6v9BMSYx8ljc3GM
	M4R/ypbgwrk6mrkrH8wg+vLZIu3IOVfzWk5JMUqMYupw6/KC/Jx6RnA9KT/yxUQGO
X-Google-Smtp-Source: AGHT+IERQ2wd6YprqS4eYvnnD7z6rw6ImUej3A/vL1S07gFistJ64iydzViz9z7fnItMS60psPXdYpEjxesagiZuwK8=
X-Received: by 2002:ac8:5dc8:0:b0:461:43d4:fcb5 with SMTP id
 d75a77b69052e-46164eaa58fmr4706231cf.2.1730221580720; Tue, 29 Oct 2024
 10:06:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
In-Reply-To: <868qu63mdo.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Oct 2024 10:06:09 -0700
Message-ID: <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 28 Oct 2024 23:45:33 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> Did you have a chance to check whether this had any negative impact on
> actual workloads? Since the entry/exit code is a bit of a hot spot,
> I'd like to make sure we're not penalising the common case (I only
> wrote this patch while waiting in an airport, and didn't test it at
> all).
>
I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
test the change and noticed no failures.
Any specific test you want to try out?

> Any such data about it would be very welcome in the commit message.
>
Sure, I'll include it if we have a v3.

Thank you.
Raghavendra

