Return-Path: <kvm+bounces-46274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60700AB4751
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 00:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8D43189E38A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 22:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA1E299A8B;
	Mon, 12 May 2025 22:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pd7ap0zv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D14186A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747089247; cv=none; b=WdDyim/Y6TjekRfP4g3sceb0ixgt3aW89sIpSRlXBm6QSj8RR6sN+JcKWsxq2NkOcdVnHWBo/dob+C9O2fj9RgqWM1lJvpOylaRaWP4zCjWobRgdrcrUTsi6Mf5HQfv2T3jo0UGSRpVntn4OL687E8oqQiVQeCURt4nOwyYcN6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747089247; c=relaxed/simple;
	bh=A7GYuU5S8XhF1VDVZzU9l/kxFV62Z1n6qxJiHG7VNb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QhoM6qp9ENXmSjYuWBP+8+ulIE+/qqXGIdqcBBiYnGNNiw4zcuaHJrsDwKXT191e3rWTZIQb2ix0B8a96VLUBWElccGJfYrzi/Yas+Oxq+n1QggdmDewaCT+Gp6NIvsFAEdmiuKb3ooU+nWugi/LGEVS6FqT8PBhkxfqHJ64pt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pd7ap0zv; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-708ac7dfc19so43746717b3.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 15:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747089245; x=1747694045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8NvmZ4t3qL9Eye01seggkdjFmX2M4YFQw5Fn8XZFvI=;
        b=Pd7ap0zv89W2zj3j+5qRFM8THTtmFoJpOF70syXx9PnCWnC7SB6idcnKkp6L3jv1iF
         jvfVo/kekoas2uVMOBvkdWnAQ2a7FCDC2YODb0JX5DAuTz8+pPy7tN7PH63SNhemAuqg
         r8kC24WHSqysImnm0IIrr1E4kRNveoz5y5GPnKqbeJBGNMwCPm0yjJNJNh/K5kMMq8nT
         hPK651Ld2RDKsw+Z5/3I2Bg8EyuNP2Gl1eEKYCujmsBD5R7MgHZ3TabMcOsGUg0n9o/e
         miUSZz6V9JTFJbtrSXvEjconl4n0+vXenAtE4NGPs9Lc/24CeSrnwxMqEkm7Kr4kZlB2
         4JdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747089245; x=1747694045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8NvmZ4t3qL9Eye01seggkdjFmX2M4YFQw5Fn8XZFvI=;
        b=xM68Nt5qE8j7Wp/FobfaOR5teqJqRb3D2GmrSYy8Ibo+2QQkRsK6IJl0a5kvqIF3Ft
         5MscABFXa/n9zTdr4jWaxY4AMc0nynIEenmuhYHg0z8kTmUax0UaLYXdQhtxC4wy8KGj
         Kkt7TpSOoL8w254TXWFmhobdmDhcY802bm6ldOMK/Qe59xSD7AVllXPGu9orNrpBgk51
         KvvKO2UVzt9ez8pUy8c76KlSdwJHZacYoUxIcO0K+cU0MofQoGrMo8J0udy54zrhYL6T
         tpFdwfCh9eL5WWxFFC2OmL5A34RicT7bSYo96rltTmOMPpl7dkiB+HzHfHiqW1zp5Nfl
         xcCA==
X-Forwarded-Encrypted: i=1; AJvYcCXAQ7120cQjhzQUPSsw3QWSwLvCacw31RezFTjDnKayR9pwJkHqynfqe/RVWNa8a5ihqLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlhEi0DVx1wRJQ57UTyjpkGluMNGejA/EZJ2CZd7OOwNme6tI7
	vViK7w7mR2fKCY8ra3c3pA7z13OWB4apmJBcCJEO027yhcy2Yf8XzrumJdhePzgdwSIca7/ZBnE
	eJ7cLmMnD2KKnw7kD0/ovH37K93Qo2tZwEGkr
X-Gm-Gg: ASbGncuanJ9siUZm+Rlttk4Mc9XDEDY3qCPvdTijlosnPqJ2opsEvaCVp5A5B3G9z4g
	+PLz79bSnLuUmpC8SMdT+qc4xjyJS+nOHdruUgohYsx36IBUeT/SB7O6K1q3plvdo1QhR7JjAyt
	bRZNJ6vd1C9sqI1cutx60XRFRtql+szXG7pBiGXW2yGVTncjUDiV7PSXZmZX83Js0=
X-Google-Smtp-Source: AGHT+IHeFZuz1GT0pyYV9KRgJiE7kVcoZ8mYUC97W8Uis3XkL8RZr56UHHc0eEJMA4/5nNTsncrykr7QBqACs6gvE0Y=
X-Received: by 2002:a05:690c:4881:b0:708:c18d:e6ac with SMTP id
 00721157ae682-70a3fa373e6mr212777607b3.18.1747089245033; Mon, 12 May 2025
 15:34:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com> <20250508141012.1411952-6-seanjc@google.com>
In-Reply-To: <20250508141012.1411952-6-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 12 May 2025 15:33:29 -0700
X-Gm-Features: AX0GCFshITqfMDo56zZ68RKI2JYQJwtS2D7bd8OPkNI7R9wgfKIsD_-OmUB-WOs
Message-ID: <CADrL8HWwJqt+XL88_SYGta=AbOm=n6Zpt2jwHowkCbBkA+DOmg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 7:12=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Use "mask" instead of a dedicated boolean to track whether or not there
> is at least one to-be-reset entry for the current slot+offset.  In the
> body of the loop, mask is zero only on the first iteration, i.e. !mask is
> equivalent to first_round.
>
> Opportunstically combine the adjacent "if (mask)" statements into a singl=
e
> if-statement.
>
> No function change intended.

nit: "Opportunistically" and "functional" :)

>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks, Sean! This logic is much easier to read now.

Feel free to add to the entire series if you'd like:

Reviewed-by: James Houghton <jthoughton@google.com>

