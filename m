Return-Path: <kvm+bounces-11969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0420C87DF03
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 18:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA738281A1C
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 17:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BE01CD39;
	Sun, 17 Mar 2024 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TfNi8ZSn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D4E1B949
	for <kvm@vger.kernel.org>; Sun, 17 Mar 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710694815; cv=none; b=qBmdBoDPleNr1kpcN3emtj2PbBCuHlUmzFkKudBjs+2lae7pXpqW9bL/xBLwG8F6ZbwgVNavapKQT/5jPdyQqNEhV9vfFyJU6KBfvqmtOdKM7375KT0u7Rq9DfVZqZ6/w4TYrZJATSjuQ8+/f2nxnBUX7TKJ0Pxmo2ZMmQZrdyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710694815; c=relaxed/simple;
	bh=3TgBLFLhLrJr7bHKgcq49l3nFM4c30byd11T+B1q0/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hGHwzRRLRXYJqPjv5XbDTAv+J8/sgc/1DZ/6OYlS+peVcBav6bR5Y0e1baelIM2Ql2HxQ1h6XywMCp8zRCWUYDdz1sqZcCwag1Gu4/rzn+pgACfylU95Zals1lQrB/zmCaHEN3vLUKO/zNP9TgK6ovoayRdHxjdaaalqdyZN1nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TfNi8ZSn; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-34175878e3cso39466f8f.0
        for <kvm@vger.kernel.org>; Sun, 17 Mar 2024 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710694812; x=1711299612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOgmWfKRYvptbphd8sDMoASXBWOyJdysOGK8hMTbEs4=;
        b=TfNi8ZSnGV5b6yeymc3yn/hPJv6UYNNlfbdPWARyZki3zN/QRiSihfMxXJDLYjHyk7
         rGksw9tlxrx6vT2fCq5UG6CuKfIqxb7IEk4/GH6A7+aiASZu5G2tfudniAdxqUMIL+Z7
         QqCoHjiVP7AfPEWBcrwJVlEjQB7er9TYe5lA/QWofpIqwyVLzL70vqtoupmDg3I4Rt8U
         kgEofKlwpC/9gvLxbZ+fzZmVS3KsaqqJ3e7EwK4VARs1WgJWLt5egEqnA9W/FYS7kRWC
         NtNI5pDigR4EGx7x4YOTMIwnu/kZZVXAEWNMeNE8tMiVXY1D53VBIXgGFan/VAFBTkBI
         zeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710694812; x=1711299612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOgmWfKRYvptbphd8sDMoASXBWOyJdysOGK8hMTbEs4=;
        b=u6GVO8knnw7rRb2fIuxUs0ocVn8sxnivddGAnBjESSfNV6o/ea5FYTPO6r6jCrIOmE
         BAw69DlaSsMghGrlPcqTPevDl7j47MHyaM3KGvm6ooYM4umsv4hCb0qSvZz22mBhxkeM
         qfSiNj8j9JF6kgnymSgKnpcYXCQSFbmXJOp5723ZGnPHZbmG/r1v3CvqPUnbq/9J8ONK
         rN49Z1YHfknx10k80WGzmq62P7PlE+/eiFQF5xwOyaOajusRvt98F7tZFjonFXjJx0zn
         PJLlnoe2lJpBiSdSv3uFme/fGUPg0DYOdC7qgvYaHqVGO+nrHOxRctzd1eGvLujb5Ftq
         Qsug==
X-Forwarded-Encrypted: i=1; AJvYcCV659sYNki3uNV4YT2eWeIOZ1i4nM3jGSQguGfad+vSP3W4UVpng4qYgZLKGFRCfguh2qlhapkhCgULraCaGaToa41F
X-Gm-Message-State: AOJu0YxaUrUmDi9ohfHnBArwzerH/DmwJexvKzMPihyCPr4oNkuUjFfh
	lNF8uFcruvANnoFfmPMR304yDWhscId/Nv7TYtjHz4bNHP+Ct3y0Jocj6pITmelbMWW26JJf7G5
	XzG1V1vwss3oAYQ8r6VE5XPisL8UFI9WYi88h
X-Google-Smtp-Source: AGHT+IHLvMP7XlmaXCMSVkkZHqIP3Wqdg0uUPIJAlb2fYWXUmzKFVCwrJlAxAymWJxq7y00gRpC9OX7PRPM8dH9AmnE=
X-Received: by 2002:a05:6000:d01:b0:33d:c33e:fbd2 with SMTP id
 dt1-20020a0560000d0100b0033dc33efbd2mr5522736wrb.31.1710694811659; Sun, 17
 Mar 2024 10:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com> <20240315230541.1635322-5-dmatlack@google.com>
In-Reply-To: <20240315230541.1635322-5-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Sun, 17 Mar 2024 09:59:42 -0700
Message-ID: <CALzav=cwycWoR3b7KOGEiQ=gvvQszOS4xUu0yhXMnGkwu6HH5g@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 4:05=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> Extend vmx_dirty_log_test to include accesses made by L2 when EPT is
> disabled.
>
> This commit adds explicit coverage of a bug caught by syzkaller, where
> the TDP MMU would clear D-bits instead of write-protecting SPTEs being
> used to map an L2, which only happens when L1 does not enable EPT,
> causing writes made by L2 to not be reflected in the dirty log when PML
> is enabled:
>
>   $ ./vmx_dirty_log_test
>   Nested EPT: disabled
>   =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>     x86_64/vmx_dirty_log_test.c:151: test_bit(0, bmap)
>     pid=3D72052 tid=3D72052 errno=3D4 - Interrupted system call
>     (stack trace empty)
>     Page 0 incorrectly reported clean
>
> Opportunistically replace the volatile casts with {READ,WRITE}_ONCE().
>
> Link: https://lore.kernel.org/kvm/000000000000c6526f06137f18cc@google.com=
/
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 60 ++++++++++++++-----
>  1 file changed, 46 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/to=
ols/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> index e4ad5fef52ff..609a767c4655 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
>
> -       *(volatile uint64_t *)NESTED_TEST_MEM2 =3D 1;
> +       READ_ONCE(*b);

This should be WRITE_ONCE(*b, 1). I forgot to reformat the patch after
I fixed this bug locally.

