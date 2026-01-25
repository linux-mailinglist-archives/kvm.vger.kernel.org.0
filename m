Return-Path: <kvm+bounces-69063-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ksFxG7MCdmkYKgEAu9opvQ
	(envelope-from <kvm+bounces-69063-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:46:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD3D80683
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BC5C30087AF
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 11:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDAB2773D3;
	Sun, 25 Jan 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDGOHWai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8C73EBF1E
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769341611; cv=pass; b=dJvI8GCkMDbFGTI5LXvRtjpCeDEmvRM24eRFzBJT5bqMXIL3NDiY7WSan3DywtyjagK0IUED0fqe2i31v1y8HDn6F2KxQP9ImQJ4Dkswuh0+NpVLdk2OW19CzrZ8nslTBRaR2L8zxugm4t8sfE/FBXA9Lbkfk51qdHjD4EiTeYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769341611; c=relaxed/simple;
	bh=i684QgbRLKrvAS6fB3nmE7y3MTHYtwcXflRXQihZJoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOKoE6knr2pdfTrhCMwn62ecbXsVXF1z8wyadB0FUEpg+i4Z+wcFXoa2/yoUfn0FwrOpbA/Nquzq6k4L87KjLdpn5Zcn0s4HyITLrWwTmQ6gKw7PB9wsgMsR0R531cHrDte+Q/fQMTlY61k9rH/5Sef26pqWiTUFXwLZkfauuc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDGOHWai; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-662cb4bef90so939762eaf.0
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 03:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769341609; cv=none;
        d=google.com; s=arc-20240605;
        b=g9pV6cX1VSY5alaY1NnCzRM5gWP5/za07sulosnb60JGgPlLeee62ikbMW3Mc/cDJ6
         nktIa0vYMdlYBLk+yA7rWU/ufvzLEFEALfPuYhrNaaKMAEmMm5KKGku7aiDw5aRukDJZ
         8EjhwG68dhjUMYSXe6hADnFA7qWcRzkrgnZiTEWfYevg99GeRCJqFFQsMcVRw7wem5J2
         e2nFRQ8DcF2T9NgmO4o7ZHYwhgr1PMTi2D4dpSr91tMQ5z6laVayMyeJ6XfTP8ICpwBi
         w8WfWe7nS2bwo4rmKcZg3RHFpXzIcjoYpuQBkKFZUWXTkGUmLR7So1fWyuTRt3YcgOKz
         95QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i684QgbRLKrvAS6fB3nmE7y3MTHYtwcXflRXQihZJoo=;
        fh=hmgbh7eGEWaTHO8rF2/D9X1dJD6Wr/aBokPYTw0+6IY=;
        b=DelNljtKgUZ5ZbyLqHf3JHMqbpyDnChascL/PowOyBKmH0Fzpoi2sYgkEXttMMtgVh
         JQpwDSeXD0VJjiYtKdOiX/SWoYqtPDtWkQE3ZPxyUwGpw4WsRM06RYxrH884NIzpjTPp
         S7AH1YFdVUesEWo0k95fN6nGcyyX6+JxP7b+9ukv3+cPzYUfeMLCgjfwuDjB8SJ/8XHQ
         YKjjRX1MpEoiXoDHRfZho1NWalFFMQ+P8LovQ4DqeD88yS8NFh6pgT9eKfcC3HSy63Ww
         wM7QH1gKlj9Ubf/oefsE1HK4fCRLptuW0ZslUJdTrnoJ0y6I+tQG0dIN+sGuJbR4Qt8w
         vglw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769341609; x=1769946409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i684QgbRLKrvAS6fB3nmE7y3MTHYtwcXflRXQihZJoo=;
        b=dDGOHWaiDggL0/l6AsRO5W2ripSYFXkDtTqjoN8flkCmCEw47vUSDGDJtBCJraF/cy
         9AldPejZB0nmOfba0nIYOteNGkr0LblqXpnePrBXWlizzXK8y3J3RviB7QDGIYOYL/uc
         jwwC0Un1EOUQW3tB5ZF7nufmpVILa8OkSZFhF6tYNuhWlcP0rbJpGB+YO2ihoi/0mk4z
         kZ8CASiE5aAQ9gNOqcXP10ectHbsh0VO7iS5OnOeHr17LtWe91mTZBr1jRbuHKjTx4Hz
         04nDf3V0FAeYSyXIzLxMvDl4CI3hADqBkrDINKE5CgpOXsOkxpgp83InqK0BIJDA8K0L
         zmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769341609; x=1769946409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i684QgbRLKrvAS6fB3nmE7y3MTHYtwcXflRXQihZJoo=;
        b=hhguoL0/IcEBbj7unvTyWcyhTm5J6HyfJlOEqvsEdRaEOgWuyLZG9NaTZwufZRBi+E
         Pr5rdqHVj4UrpS0hqbSoLgUI9fII3gmY+nwh+2SdITYrjnG6VYqVVapkyeDbtMmlROxL
         YNSrAOvoBEccr1HIdekoNLumG9I1fqDvvlUQtxq1HavjuKI/rpFS/3zg/saTCXRh7yc8
         NDuq438MFKPodjzSZvKhXnCrP4ZOLHumrdgqUHvlqkVcOIIPifT1Z8tuVZZm3qEeOERI
         Oumz5eUutFkUmt5IL8nzCAqUJIBdcurzgPSvMw8oJ9mFuas/jQV13Wm4L+OPtoRO4sL2
         rvCg==
X-Forwarded-Encrypted: i=1; AJvYcCXsnOx8LT3BybKY9BSzM6IDOAoGOx2P21p5GvnjJVELItDCgRst9xdr9m2/OqkOyKxo5e0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM8MkzhwohC60bUIMtPC0knpwmHqwhhCWo4UBkqXMGeaaeUX4B
	3muFRd5YhHBU+/vvGR06/q3gmjSJrZPz09aRQ4rohKnpGOtJfgUzmlrSluw4QLg1nVv73qO2nSN
	bKFoSomSbvOxI/YSe2k4kDqUKQ8436VZ8km6NX5PLx//y
X-Gm-Gg: AZuq6aIeJkA9bUi3314Lk99RSuerGYsKlgmRiklw6Fu1HWzc7yy5JJET/aQrLLERI+O
	MvIGi3IPp2kf0yKKAXoztGcmgQrUe7VfO5f/aSv1Y37g/NUX6A0cSi+bqOG0PU5xhimXFBevbJX
	A++5faCLUNO++1hhrJ6NSiEeGbIEC4jop5ifrkEJMTfBao38JRqHHkGyTKS0Zvf530EnZX0YieY
	j2onat4vwJdl/tl64ZDJ4A0NV8aw4W0TYs8ChGDEdGdUy/Qr8V9dvQcoDcUQDSSeLDisff4eeAi
	vVJuZh4/x9iWtC6y8ggwx4yZrQ==
X-Received: by 2002:a05:6820:1988:b0:65d:318:df67 with SMTP id
 006d021491bc7-662e046e017mr686789eaf.70.1769341609053; Sun, 25 Jan 2026
 03:46:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125085157.2462296-1-xujiakai2025@iscas.ac.cn> <9a818ca6-04fc-434c-b8eb-8380d5bb2293@web.de>
In-Reply-To: <9a818ca6-04fc-434c-b8eb-8380d5bb2293@web.de>
From: eanut 6 <jiakaipeanut@gmail.com>
Date: Sun, 25 Jan 2026 19:46:37 +0800
X-Gm-Features: AZwV_QhKu0HRlNcM2V84WhnJ8IQnK6kIoZewHlHU5YMVATY5DBBDBSwIJvzFh5E
Message-ID: <CAFb8wJu2fbz92oYiY6+KYk7wQVPe-YoQPo9sYNPo6bCW2SWw-A@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	LKML <linux-kernel@vger.kernel.org>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[web.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-69063-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,bootlin.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CDD3D80683
X-Rspamd-Action: no action

Thanks, will address in v3.

Best regards,
Jiakai

Markus Elfring <Markus.Elfring@web.de> =E4=BA=8E2026=E5=B9=B41=E6=9C=8825=
=E6=97=A5=E5=91=A8=E6=97=A5 19:30=E5=86=99=E9=81=93=EF=BC=9A
>
> =E2=80=A6
> > The fix adds a check to return -ENODEV if imsic_state is NULL, which
> > is consistent with other error handling in the function and prevents
> > the null pointer dereference.
>
> How do you think about to move the assignment for the local variable =E2=
=80=9Cisel=E2=80=9D
> behind this check by another update step?
> https://elixir.bootlin.com/linux/v6.19-rc5/source/arch/riscv/kvm/aia_imsi=
c.c#L982-L999
>
>
> > v2: add Fixes tag and drop external link as suggested.
>
> Please move a patch version description behind the marker line.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst?h=3Dv6.19-rc6#n785
>
>
> Would it be helpful to append parentheses to a function name also in the =
summary phrase?
>
> Regards,
> Markus

