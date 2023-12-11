Return-Path: <kvm+bounces-4114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B826F80DDD4
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 23:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93E01C21692
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB54855788;
	Mon, 11 Dec 2023 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9bh6KhW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B04C4
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 14:05:25 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3333074512bso3205287f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 14:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702332324; x=1702937124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CewCZS++K993yArn047kWOfAWJ8KS6NVdgbOGuCqfMw=;
        b=H9bh6KhWf4JvD8k5kk2ll9sb7zlj2r6lt+Xd9HWdOx6M64jDQOr1pAxRYBX1LhzamS
         D3muVTDXIfxeBWREOYaM9FgQ2JGVi24iM6ahayWNFaKvUtcY+RNygaxNYDQoUFQwYvb3
         MElWtTYDBnQ59bPZYwCrXHz305FQiUZSzT8gqGsYpHUkq0/0AuKFrINEEgsyiJLucT8C
         d/eC8nULquAiUAUI6o61UilLBR7oJRDQkV/3bQWbCoVPFbsefluSSPXoss2SQwys8AJI
         45cmgU9INI1lnM903hyKVU1qm2RcKlTP717uob06YZ9gNNAAix18jnxuwFGB7P9RF8AV
         bLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702332324; x=1702937124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CewCZS++K993yArn047kWOfAWJ8KS6NVdgbOGuCqfMw=;
        b=sb2m80p5qnnxZDVOXEAslL4xJB+f5p4DSof6750BRUcwkQ4onuwoZ2LcefLjE872yO
         WJbiakVpQUp7M9GrZl8J6VF7djgkqV4P5SDMD4Oy3tObqUR2UK9jrBohB3zFMZtwErSm
         28rDO0R8dSQIWQvjC4OfgX8b+GOqTi1EaC8wwh+6UbbQ40qkwJhNgJ8g9F2jm1BDL9Do
         AIocRQSKXhFAO16XUJQGga/7gljd3kFoGjcfvx0VHHMK2yqH/KaAEvvPSlmDJkkJcQWR
         DnXRiH7H++3MQgG04no+6DvzakLvZnZnUjd9wO/wMr9IvcON6Sz8eqTe2mDqiiD60kxG
         0ZZg==
X-Gm-Message-State: AOJu0YyFPm9+4t1pt0jKMua+WwHpP40JPpIo6CV1PpXMTQiFwDotREnY
	86JHH1uiSaG4UZfWvz2oAA78P9jTjRC2huQ9hthHhA==
X-Google-Smtp-Source: AGHT+IHTBy4qpx3GgmVqWbgG2qfkMSzY8ANUxr0Vy0UPQnNNwBTZz5TB4HG4r0Vv1TWNF7es+UfLYD8zT9FX32mydUE=
X-Received: by 2002:a5d:6b86:0:b0:333:51b:d7b8 with SMTP id
 n6-20020a5d6b86000000b00333051bd7b8mr3372180wrx.10.1702332324076; Mon, 11 Dec
 2023 14:05:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=c=C3q9SwB340-mSJeT7FN55omeVZv4+LZiWwoaeA0Ufg@mail.gmail.com>
In-Reply-To: <CALzav=c=C3q9SwB340-mSJeT7FN55omeVZv4+LZiWwoaeA0Ufg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 11 Dec 2023 14:04:55 -0800
Message-ID: <CALzav=dmFvUav_4WRYbkPXODOb-z+NqPKwcdE6O2S1uSFXkPWA@mail.gmail.com>
Subject: Re: 12/13 PUCK: Post-copy support for guest_memfd
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>
Cc: James Houghton <jthoughton@google.com>, "cc: Peter Xu" <peterx@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 11:47=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> Hi everyone,
>
> I'd like to schedule a PUCK to continue the discussion on post-copy
> support for guest_memfd [1]. If you're Cc'd on this email it's because
> you were Cc'd on that thread.
>
> Requested Attendees: Paolo, Peter Xu, James, Sean, Oliver
> Proposed Date: 12/13 (next week)
>
> I can present some material on the problem (post-copy support for
> guest_memfd) and the possible solutions discussed in the email thread
> (KVM-based demand paging, file-based demand paging). Then I'm hoping
> we can discuss what direction we want to go in, and what information
> we'd need to make a call either way.
>
> Please let me know if you can attend. This isn't super time critical
> so I'm fine with rescheduling, e.g. to after the holidays, if
> necessary.

I've only heard back from Peter so far (he can't make it this
Wednesday) and this week is pretty busy due to Google-internal stuff
so let's table this PUCK until after the holidays.

