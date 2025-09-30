Return-Path: <kvm+bounces-59221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F52FBAE6B3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 21:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41D59192572B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1612853EA;
	Tue, 30 Sep 2025 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtWKC3aW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7721A421
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 19:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259812; cv=none; b=avcQF/5KkHFadAz1Dxlzw1QItwZv7KgZEqRnVb8mde5pP1bpuLJDhwmv6zqJT7LIu+7HfmU9+j4lP0IBS0u9d0enwTksVEG8rlOPQnRPJb62F2xq5gOkuFuOK6PCqTQTWcr4xLxoHdkWPc0WYmngjW5noHBB4TlHKRiCVQh3AIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259812; c=relaxed/simple;
	bh=9Ju7l26lyQ25LtJnf0uogw+JuQhfeHi5Rb2Twfkgq2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IeFRwu3AolBjtc5XCfvbzgB3qfL1NYWcRz8bg6XklJymNYG2WmgtF+i4gLgZdnYz2VYNrGJc7j2fzW3rJGdQpyybo2qTHgODh4l3GxXa8lMDZWgVEPkYaM/9LQDZvGcwZEAu9HzqDUnUlqT2/TcQyxYJlqn3cy86ugrYGy/vww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtWKC3aW; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2eb787f2so5202033b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 12:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759259810; x=1759864610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WEFiCkd++mamNyS+6QnAlgEtBqhn057fis8J9wtWgE=;
        b=gtWKC3aWi9hD7WSuaHMH79jqstYSV6girdHL6+MYAO8gM9ZdVvcuYV3nfrQWVxS909
         XU0IDBsNWoDR73mkH5iMxBbX7clcLF2besPiBLZ1T0FTqBqrhfL2eBqynB3YPH5cZPZ5
         tdu4UKyu/ovUQvzessN6OcdiajU6+9pf73SgTp1gM2V9kZWqMaJdr/Ro4uPr0OUC94tV
         hUwoJf9m7E81os+WqJhy9kNAJ1BRLdnfdV/WpVrS10yX+PW9kDGA/1DQgcfKIorL9NpN
         vhXpekg9ihfuYSKw/PwnLiNJlmfkNaQrUvMCDserz8LyYJ7h36F5cuwqh+wMTsv4DI1Q
         mTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759259810; x=1759864610;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/WEFiCkd++mamNyS+6QnAlgEtBqhn057fis8J9wtWgE=;
        b=c2KVehPcXLGdYZ7NZf2qyIAqjlmM0fXlJtdkESYq8tLeXCvJBksjvPA8TsSDcoP5WO
         vC7HWviSvUhWA7DdcCK2ALEG9Rh9kZ4sAunvk0i3CjkTBrCVxj72LXYh0uhWoOBlOCA4
         j0QHKd1iLD0nm7FQKmOGXL3CEi4qdDvsbZhNZdVdhRQmoYN32XXkKSCy5PsjMp1Pg4M3
         ljvFil5n3yitcc8QsAVDh93WN9fjVoVz3oITuYTa1Sp4FLsitVs/qzk/nJm0TUXMyI/y
         2cViRZfVDq0zmB3MtbqWUtLc4dd1MfdhXHp/XVnrBscFHwbCTBZQkO7aYqApgo/Gt94M
         C/FA==
X-Gm-Message-State: AOJu0YxLpbSLaQkrQw+Dk/JBtzi10WwrObnDLmsRKxTxhBFK/Au5bxqj
	oL7cSKZE1vCS0HyYtESa07X2w1+tzTMbo+Pc8YN6oXm4PvdJVZWTVPbDuWP2OT3l5g93Qc9kjyy
	jXOKwRA==
X-Google-Smtp-Source: AGHT+IEXPFUjRtt5ew9DeYIED+Hsm39PUrHsJKuZ6bbCzorROt/9O7Cpo7mA9gj01oyY1i4vD1ekMSlcsp8=
X-Received: from pfod16.prod.google.com ([2002:aa7:8690:0:b0:787:5063:2f2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1587:b0:2b1:c9dc:6db1
 with SMTP id adf61e73a8af0-321d7e97db9mr1061649637.12.1759259809734; Tue, 30
 Sep 2025 12:16:49 -0700 (PDT)
Date: Tue, 30 Sep 2025 12:16:48 -0700
In-Reply-To: <CABgObfY6iEKbo9tLAGdsKhK3vYsFW3MB_6X4ay8GAmQv-oRBGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <CABgObfY6iEKbo9tLAGdsKhK3vYsFW3MB_6X4ay8GAmQv-oRBGQ@mail.gmail.com>
Message-ID: <aNwsoK82jW97xy9Y@google.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025, Paolo Bonzini wrote:
> On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Sorry this is coming in late, it's been a long week.
> >
> > Similar to 6.17, a few anomolies in the form of external and cross-bran=
ch
> > dependencies, but thankfully only one conflict that I know of (details =
in
> > CET pull request).  Oh, and one "big" anomoly: there's a pull request f=
or
> > guest-side x86/kvm changes (but it's small, hence the quotes).
> >
> > I tried my best to document anything unusual in the individual pull req=
uests,
> > so hopefully nothing is too surprising.
>=20
> Quite big with CET and the FRED preparations, but no surprises indeed.
>=20
> Because of the conflict, I'll delay the bulk of these to a separate
> pull request, probably on Friday.
>=20
> I have already included (and tested on top of 6.17) the selftests,
> guest and generic pull request. Everything else in kvm/next. As I
> mentioned in the reply to the individual PR, I ended up cherry-picking
> the module patches.

Roger that.  I updated kvm-x86/next to kvm/next, so we shouldn't get yelled=
 at
for having duplicate commits.

> There were a couple preparatory patches that I guess could have been in m=
isc,

Oh, yeah, that's super obvious in hindsight.

Thanks!

