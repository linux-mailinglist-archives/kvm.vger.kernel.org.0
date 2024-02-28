Return-Path: <kvm+bounces-10285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7E286B488
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27492285106
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409FC6EF0E;
	Wed, 28 Feb 2024 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/u0lT7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F16EF15
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136987; cv=none; b=SyL7bW/Wk57/HneEDrcnv7J8GHp+59BQIHRmqDIotH6eLxM8MxCOFP7mH8bEVlqGij4A+hL87vKNTVZXpLWdmQBg5lUH+lLw90ob2vMWEP2IGpQzw6uIwsGS/IJWrSBJrfy3BpyRHpRBzidMajzXD7waMeC9aTuEPvAOkrxZg4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136987; c=relaxed/simple;
	bh=rOYGkzPVxZK7M9p/OIZkBdeQFYn9J83LXlkmH1I6WCU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GhkxIfwkgeZY5ITuA2atwtlBWAbufVBulxnbR2GELu6qJ5x+PVoPe3zlzVLC/7dxHnPzWCFfnDRQkqr2/DV3v54iXd5a25xxiRbIM6RiRyuDpfxZ1l8qw9jqp1Zjc6bkeCsOZ3yNImyQrsny9AiEhBKGY2AR8hCQG75LQW/AUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/u0lT7h; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so10834456276.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 08:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709136985; x=1709741785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMVVTD9yYHeQoP11M+2Mm848afum+RQNa4X561sKWio=;
        b=y/u0lT7hr23Z5YUaQwE197qnc8DlVH19rWBIPNSzmEsp88FrVM9d9ZAbzPVfmf7Zsp
         1BOn/cr1o3NOH52S0w3juMlMR/QDpgExSCdG3Z7dtuA+bn0maXaPkAglWVhx5KNOKR/l
         CGrPWGizAU2+YWJmO37yVFceYHAmkB15FjPnjRlI6gqHZK4Xk6aulQyNX/LOORaU7hDh
         4DfEhLfWJgYGTH8dRcufpu+ZdFBoTedfLobSC1CqafOrMO0wGLvNKfp/PZjVvM1opzzM
         5KKWAlRlnh6Sk1hWY++C6s1VhsiuXKXA/14G6O0FStiDSE0wVj93S1M8KlmpkZ3ZPpGW
         NDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709136985; x=1709741785;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hMVVTD9yYHeQoP11M+2Mm848afum+RQNa4X561sKWio=;
        b=UdiwWYfNJiHQfx6yCU7XwuffyvpVabDQtsb+3o5Nr6V2pdXm22PfrPsX7sQpCdYyh8
         xjeDMVEcOegAC1SODZi6zhPZlnls4Yir2uoDXPAWp0uNoM4U/jGoh8R0lBBpbpDWSDup
         IhMBNGmf5k6gPRLIgiU53ryZYfQQdbxAkgy8YQeHNCeXyO+woDgSiQ63IXf8QSv53dqZ
         HwnKRNVO9llU3BQ4+CaaZvANAcUFvj4JRsYxivPnNTVztK+Rj1YdAEaxZPTAGn5aB6BA
         +KvA/6FxJIepp52UTavqscve/GEFzBx5Oe2Hqyr8riYj8jzMXbLW/cGeiIpoNDwzTxB6
         41Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVIy/1wPIew36AULWw/GRGMsDWtd+cAv7ZxKy2HCpO4WYMX3DJWBxRg32zuZooIHHfIQzrbZqTq4p/xNsl0gyun32kS
X-Gm-Message-State: AOJu0YzqYEBCKyhoOBCR6VnHsdOtTr27MTgXlu0e/HvF0RzurqR3ZoLS
	a531kEthGz3zc77mjHsxOd+nW2ysSrAHOzAVsRt/bTdjWPgHWZVpqY5aY0HU6juwY99wFae0raa
	15A==
X-Google-Smtp-Source: AGHT+IHFbTJwSAhSpC3uUF8JQz3n16YUo7A4H885wDOtHYFEEJx/XZrsVfm5grmswMD0hb70zzrUqYxuU98=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1896:b0:dcc:6065:2b3d with SMTP id
 cj22-20020a056902189600b00dcc60652b3dmr813062ybb.8.1709136984844; Wed, 28 Feb
 2024 08:16:24 -0800 (PST)
Date: Wed, 28 Feb 2024 08:16:23 -0800
In-Reply-To: <12f0b643-e2e8-8a9a-b264-5c7c460f1a24@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-4-seanjc@google.com>
 <12f0b643-e2e8-8a9a-b264-5c7c460f1a24@oracle.com>
Message-ID: <Zd9cV8bnFuJbXx5Y@google.com>
Subject: Re: [PATCH 03/16] KVM: x86: Define more SEV+ page fault error
 bits/flags for #NPF
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024, Dongli Zhang wrote:
>=20
>=20
> On 2/27/24 18:41, Sean Christopherson wrote:
> > Define more #NPF error code flags that are relevant to SEV+ (mostly SNP=
)
> > guests, as specified by the APM:
> >=20
> >  * Bit 34 (ENC):   Set to 1 if the guest=E2=80=99s effective C-bit was =
1, 0 otherwise.
> >  * Bit 35 (SIZEM): Set to 1 if the fault was caused by a size mismatch =
between
> >                    PVALIDATE or RMPADJUST and the RMP, 0 otherwise.
> >  * Bit 36 (VMPL):  Set to 1 if the fault was caused by a VMPL permissio=
n
> >                    check failure, 0 otherwise.
> >  * Bit 37 (SSS):   Set to VMPL permission mask SSS (bit 4) value if Vmp=
lSSS is
> >                    enabled.
>=20
> The above bits 34-37 do not match with the bits 31,34-36 in the patch.

Doh, good catch.  I copy+pasted this from the APM, but the RMP bit is defin=
ed
slightly earlier in the APM, and I missed SSS.  I'll fixup the changelog to=
 talk
about RMO, and I think I'll add SSS in v2; at the very least, having the #d=
efine
will make it clear which bits are used.

Thanks!

