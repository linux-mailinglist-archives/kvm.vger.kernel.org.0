Return-Path: <kvm+bounces-27281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FA397E3E2
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 00:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFF211C20EE3
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 22:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9180A78C9C;
	Sun, 22 Sep 2024 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiX06BHX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896BEAC7;
	Sun, 22 Sep 2024 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727042519; cv=none; b=OFS0lPQ6jfXFWxKwieqF0Y0jDSO4LEeOs8kN40NJrfZlaHx6vEqfJiNJBsKs6/aGxwygPa1IJsWpYHfPozqXbAXglIcc88Fig5XtftJ5QVk035hw5VWgwBV1MwwZ/Kty5M6SnrB47thMtyC4NZfeH6g1UZkQF9c/ekLY+zCoWOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727042519; c=relaxed/simple;
	bh=fS4a1kXxnswN7aBUZhu6dvo/+bd36iWsLAtO9bouZ6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qw9bHtjSN6vzEyashjaoCC73VoqU1juRK1lS0latwU5GPos2q3uzdDdSkAGeM13ONe5xFfwpU6c17bpafZqY6WlLniIp80vUXQ+Pv8/S+EMk6QBfALK4vWVoY8u25/XQMuOILB8gud10xrgwtUeDleHPOj0nIM6dGjA508jR73w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LiX06BHX; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d885019558so2392661a91.2;
        Sun, 22 Sep 2024 15:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727042518; x=1727647318; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSCRJZUOB9g6O0lwt3GxN02pQdeoPp+qwkmsxF5882c=;
        b=LiX06BHXITKvFovflsO2hVwOiQUhbOS0uFJWbfLBu7SFBOpJ7OUGEXmswUeQGTm/Mh
         xmWV9cCQ+P+7xRUPw5du/3EWJZmgFSPX1vHG5AjIxztbCOzWz2WbUpLhpYdHToGyMY7n
         l09Mh04NdeOFG0fVabhzmwZJxnEMXf0+09eMAI8xe9Nzc5Xa1fCQcjz7nBJZ4Z0CsOO1
         0H77yIvT03YFgr7xnoJU/RS/6nh0tPiiCN5fRT3ONqK0Ix2q0Bnr1Rz6XqwvHX0qE/Ow
         WU/yaW05v3vul566VCRJ9iRebtubm62BdlLzgXpd93KOkCfEgZMYl8lRAZ/+orS7lLVF
         pm1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727042518; x=1727647318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSCRJZUOB9g6O0lwt3GxN02pQdeoPp+qwkmsxF5882c=;
        b=jwYzvGM8tTKRNZeedsnU9XwVgD+Axhwsf/LyDuV91lk6SR1/6Do6a9BfA4WG8md/n+
         Fb+6jwdSs4HpdBmWtIcY1s3krWcAiABvkFrwBxU6CPYzVU3m79t91VC+VQ0Z8wIWwbNX
         4bAVWZ4PvG5Oe9ng3143EA20lWNj5pPrx4DYbBlbMQPCoc4utl1ntaK3KfxEOr7ECx3U
         lbLnuAFTFdx9P1119+2yruBiTADTePkMZThWX0Y7JdNX8J9pk6nPcLFRUQ2wvateP2O7
         g1PZepskzkavpU++EulgFQq15dTVbQZcUvwPMoexLA8R46sOGr858CIsyu5jpB8SMR3b
         o/PA==
X-Forwarded-Encrypted: i=1; AJvYcCWb0aJxWFbWwDA0mqrmirZV1wXBUFFhh44qenNuemaSDzCoNjMWSqSeMbtjTLlluL1pO8NeLNSpvJujIO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9sgM4ENK0gcvquvLJdBOE7dJjhmqZpgI9U4ckDi57b/0gEZGW
	L94RI5wtezRtDSde3WrijCILlX+6IygMJXqsS/QEalIZ94eXfKOaUo7ss8YHQUPXpUZXzqTQdfI
	U0knhqUwp383uJgHZAH4m9hlRxbk=
X-Google-Smtp-Source: AGHT+IG3nE2V2crJIfpeakBwHpaz9jFPPsQaDlReuFCanqQtM/UhaShFxFrd2PrOeQmIs9Fdzd5tYEEAoCedGT+YkX4=
X-Received: by 2002:a17:90a:68c3:b0:2d8:8c82:10a with SMTP id
 98e67ed59e1d1-2dd80c465f4mr12957062a91.5.1727042517603; Sun, 22 Sep 2024
 15:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725945912.git.huibo.wang@amd.com> <fcddd32c625acef93ac1fd74b472d26d36626ecb.1725945912.git.huibo.wang@amd.com>
In-Reply-To: <fcddd32c625acef93ac1fd74b472d26d36626ecb.1725945912.git.huibo.wang@amd.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Mon, 23 Sep 2024 06:01:46 +0800
Message-ID: <CAJhGHyDB6A1NNNW84jxwL=LToPXqLDb1kZ_kd9N-M+aWCV-kkQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: SVM: Inject MCEs when restricted injection is active
To: Melody Wang <huibo.wang@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello

On Tue, Sep 10, 2024 at 2:06=E2=80=AFPM Melody Wang <huibo.wang@amd.com> wr=
ote:

> @@ -5153,7 +5160,7 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu=
)
>
>         /*
>          * KVM only injects a single event each time (prepare_hv_injectio=
n),
> -        * so when events.nmi is true, the vector will be zero
> +        * so when events.nmi is true, the mce and vector will be zero
>          */

This comment seems ambiguous, and in the following code,
events.nmi/mce/vector appears to be able to be true simultaneously,
rather than being mutually exclusive.


>         if (hvdb->events.vector)
>                 svm->vmcb->control.event_inj |=3D hvdb->events.vector |
> @@ -5162,6 +5169,9 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu=
)
>         if (hvdb->events.nmi)
>                 svm->vmcb->control.event_inj |=3D SVM_EVTINJ_TYPE_NMI;
>
> +       if (hvdb->events.mce)
> +               svm->vmcb->control.event_inj |=3D MC_VECTOR | SVM_EVTINJ_=
TYPE_EXEPT;

