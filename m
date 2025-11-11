Return-Path: <kvm+bounces-62660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5921DC49D4C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F11B41886DAF
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327BEDDC3;
	Tue, 11 Nov 2025 00:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLz2AIKL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D59E17D6
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762819800; cv=none; b=r1l9O8T/yERrQun008Uiggah8FJdb4HHhbgP3Sm5b4psOpD5IDNoQpALz6MRUx8FYz7oH82LZ7Pku5h+18dCEWpdONHUwrtWmM0g97Ar4QVOTcepfJBKp/FinMw3zn9Y6zIGJnbcK3MS7kIK1uWhPGnP5Uej6jttyDV58q2r3rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762819800; c=relaxed/simple;
	bh=gZ5/m077XwBZLhAmwLVAiJZP3Ep+Vx20A7NkuQEHPPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rs/Ctq1wyLz8c7LeS4wUiJ8gvTcHuax8GtC9vD3i7qUz7k7kN82EdkdCdWBtmgiv37uRTCKwt6AhYq+lcWLIBVVLRp9HVGj2jYYLDVZxkZIhKuzgqd2gZEy6MsSUMZjvRIcgsR5tywKVLnnJgbdnUlqZe5224kAT4ULRglq8jNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLz2AIKL; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-594285c6509so4005574e87.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 16:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762819797; x=1763424597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFEHCNfHv1D8JoCl4Nsmjn6JwQRfPNbQJk+sIWcQCWU=;
        b=gLz2AIKL6xMj9C1Sa7+YRItNJbgrocb9By4S/yhj3r8aSr39URnhLjz/08r0cdz41D
         LQ62useSgBJ2OYLXR42XyTKLVcjKWQf1XMfMQGwUDAQl/PsFEF34+Se3aFt10vWE+bBl
         tjoNxZp9EwzAVeTEmnr8sa950CnhThpknF5i0BB8oTyNOg95POPpqG4jRnCw9qGkjnLj
         MlUMRqHJQGxqUpPJ97iL3E7MQChRtbe1cIRyncJog+MKxle0oBDiWVfT6Nfq0AHjOsmZ
         VsQz0J38lV1uYVQawzJtyd6V0SMKovkJcM+IDt/BJJrlrtN81ogFiKBNiucB/lcvtQW0
         FSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762819797; x=1763424597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pFEHCNfHv1D8JoCl4Nsmjn6JwQRfPNbQJk+sIWcQCWU=;
        b=t6Fg6HdgRVCDJP3m5FxOYUzWbTnnXqL8czmV4usNS79vq6/Hv7GKfbeDvWF0YkUve0
         5LoAI2v1RVv31Btff0akFJE2YgrLfW/H7JKx/HZ7aUkeJJJ1fqpSP2f9v6+Na7yfEWFr
         NVO05o/6+XaZINDJoV1Id57T6e+Gsp47al+skRzp+KArZb2G3Z4i4i6Gdd2/Ikc1Z4Sk
         V4w/vg80xmvMyw+FzrzTM1jCVSm1IikN3PsWOK3lh+jNhSRk98lycXnGDsJgy/IlBYSX
         j6E1rj1Bcv7UzJbjDqdWTgvzyG7QN94qkTFV8DEOkSuHKuKOMHcHrXAhuIEgGKhO4nTX
         w6qg==
X-Forwarded-Encrypted: i=1; AJvYcCWRJ9mgqU+pmUwbIaz5O8C6YxMafaHLJd2CU9N2Y+02MNLz102jVWGDdWjpsyj94YJkyn8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywponm/0EPSuWxfxVHtHMYm3iB6YdfU+Z9Ge1RiRjsnOr27fKDH
	FswJJjpUlnGSs0gxsGaRs2+9iSew7a1t2y/CtGNaJOzAGw/cFsn+ozVAQ2waE7mMYFsAoKhmFcb
	W9p44LWAJ/1gwdrSS2f+/s0BAM1O3cnNJnVk3yxfY
X-Gm-Gg: ASbGncvAvJrVxSGEUWCMhBw4MLTiqERqCMAvSfyMkWcxS8QFs2RpJWlGaBNkdGt3FW/
	X+DaDRnMLp3SoQzcPzjNRBgtj5/M2JQ1+WkNwjOvvD1KqO4VgmP3OyeTmdRzbjagP7iguYwkzOb
	T7bRo3L9RmWN9mgQn3tPfBAygcWw84TlwsqsXzjA/pG/5KZxlGSIknTAoVm5XseO4crlIwWqar1
	oj3oNF9GuUISR3GzqNccL92oac+lgv5fbqLT7YnVF8yvzOmILJxk4gqE4B9Gq6Kek4T4W8=
X-Google-Smtp-Source: AGHT+IHo2L5BMywZB4ygtkbG7ou934mmvSM1iJnq4YXV+tyl1PbwOxo9qYD3jNo2QlU6HODLtb4dq1vYUatSp3CdWDk=
X-Received: by 2002:a05:6512:3d87:b0:594:3020:f88a with SMTP id
 2adb3069b0e04-5945f146154mr2982019e87.3.1762819796505; Mon, 10 Nov 2025
 16:09:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110-iova-ranges-v1-0-4d441cf5bf6d@fb.com> <20251110-iova-ranges-v1-2-4d441cf5bf6d@fb.com>
In-Reply-To: <20251110-iova-ranges-v1-2-4d441cf5bf6d@fb.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 10 Nov 2025 16:09:28 -0800
X-Gm-Features: AWmQ_bl8_Cdy60TogV-QJ49WsEn_RX2LsLOaqoNdfUT7B2UZ4an-cWntLVlYT40
Message-ID: <CALzav=f5PSLJifD6_0iqLW+Uh+zQ9f_N4zVtq4ikon1gg_h3TA@mail.gmail.com>
Subject: Re: [PATCH 2/4] vfio: selftests: fix map limit tests to use last
 available iova
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 1:11=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote:
> +       if (region->iova !=3D (~(iova_t)0 & ~(region->size - 1)))
> +               SKIP(return, "IOMMU address space insufficient for overfl=
ow test");
> +

If, instead, this was:

  region->iova =3D ~(iova_t)0 & ~(region->size - 1);

then I think this test could be run on all platforms. The kernel
checks for overflow before it checks for valid iova ranges.

