Return-Path: <kvm+bounces-72633-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MSRN4WBp2liiAAAu9opvQ
	(envelope-from <kvm+bounces-72633-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:49:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC281F900B
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D39F630A4A7C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DA21A6821;
	Wed,  4 Mar 2026 00:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXaNmIVD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D61347DD
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772585331; cv=none; b=o1pUg3r0YbZ7XICVfOc+knPtBTvIlgNL4orxjr9SxdvDBBYI5oeRNhd+/MIgAJ8ozgamdzLc27IYhcpinH83XcawK2e9sPINWhb3nOJgsT4wzcb13faESeE00qNhCGBkRVT2h6qqfsbkkTZ4GQ6QIyjep73km6/H/UOglKDGk9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772585331; c=relaxed/simple;
	bh=srNCTgIzwqrp/TQebCwJ10Pl9GUqhQRWYVtu5EDbofc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BAKFeM5l0zEdsyJfHzRRH81p8b9qB4hhdzhBKJkxp4hLpexWPX8jM4HgyJ9xPEDi2QvBwrWq+LFiFPuoitiXHhdzAJc04ir3ADlwzYY0ZOy2JV4HMd32mrz5aksp4GJlxKI6o2bazFucZs7GoFtCHAe57smC8lUzso9PVFllVsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXaNmIVD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3810C2BCAF
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772585330;
	bh=srNCTgIzwqrp/TQebCwJ10Pl9GUqhQRWYVtu5EDbofc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZXaNmIVD3E7aiOiGOqNFKUSOuE0skRVD9JgqpDduL5bwZDx88zHGugr471I+GrfBs
	 6k1SGBjPAthLeJeOhR07WuyA1/gH54Wdtqnm4o8XQUHSkBHaqwBOak76L8PAdBMDkE
	 h+zv5cgLmR4JoP9hhu7XsI9VpW7+8Fi3mh8IIx6ztFVnX3+XJ+pjcu2XZvmhCWFMcr
	 Kjq69+j/v0YTtz+Vrs+1vQFFJfWWHQ+PYqs1Q3V+moptGFRWDSOBFMj47YNjGe9cjG
	 kSmt5SX72hO2dbV1sDhK99SSE3kUNg8IeI+gLL7qPh65KuXcgPliahY6zcoboJTvNv
	 ZlmCLVGv1cSpA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b93718302beso616608966b.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:48:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU9A5lfvYvgFSSp9Zj4FsKp9s2t9hTEXvrZBGZZAYbG/OUhdSIB0FOQOYS36yWDxGl7gbg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvc8PtwVTYh7XhcPKL1Zd0nXEROk3YFGoTWD9aIlmIQv4QvpYN
	B0N1pQ6o4mYOYuJB9PhrsmbEQh02/XdOVuIjo0kpQsYA7EXPWTaw3+1zukeU2yp7VHfHcUecNvQ
	c8x8KquPfHBxQqsZYJM+s37/9Er958DI=
X-Received: by 2002:a17:906:ee86:b0:b83:e7e:3732 with SMTP id
 a640c23a62f3a-b93f13f100cmr4213966b.30.1772585329458; Tue, 03 Mar 2026
 16:48:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-4-yosry@kernel.org>
 <aacOPmIS7HUtzJA6@google.com> <CAO9r8zMDQkHAMKVewDgvH6_WAHo5eL4=Xwf7h=87JPOJPYQAFQ@mail.gmail.com>
 <aaeAYv2i7wjGahY4@google.com>
In-Reply-To: <aaeAYv2i7wjGahY4@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Mar 2026 16:48:37 -0800
X-Gmail-Original-Message-ID: <CAO9r8zN8f1o7nRv7DKMt2d4p6ztR6jETGeX1XbMze=fUcYpZrQ@mail.gmail.com>
X-Gm-Features: AaiRm510OOg5AYMSGYnGxcomlla2uxiUYaXv3s-lTkb0zvsn67wqnt6OxrmhX20
Message-ID: <CAO9r8zN8f1o7nRv7DKMt2d4p6ztR6jETGeX1XbMze=fUcYpZrQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/26] KVM: SVM: Add missing save/restore handling of
 LBR MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4DC281F900B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72633-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

> > There's so much repeated code here.
>
> Ya :-(
>
> > We can use gotos to share code, but I am not sure if that's a strict
> > improvement. We can also use a helper, perhaps?
>
>
> Where's your sense of adventure?
>
>         case MSR_IA32_LASTBRANCHFROMIP:
>         case MSR_IA32_LASTBRANCHTOIP:
>         case MSR_IA32_LASTINTFROMIP:
>         case MSR_IA32_LASTINTTOIP:
>                 if (!lbrv)
>                         return KVM_MSR_RET_UNSUPPORTED;
>                 if (!msr->host_initiated)
>                         return 1;
>                 *(&svm->vmcb->save.br_from + (ecx - MSR_IA32_LASTBRANCHFROMIP)) = data;
>                 vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
>                 break;
>
> Jokes aside, maybe this, to dedup get() at the same time?

Looks good to me!

