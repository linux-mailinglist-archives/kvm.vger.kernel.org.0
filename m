Return-Path: <kvm+bounces-72277-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAI/Hz30omlD8QQAu9opvQ
	(envelope-from <kvm+bounces-72277-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 14:57:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 44CB61C3623
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 14:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA752301C55F
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 13:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3C7372B4E;
	Sat, 28 Feb 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9fmpxR7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ssnDYfWe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976183093C7
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772287023; cv=pass; b=rRMUNJ/tzT30MbsNkk0Pd0bjhHiWJB9cG5ARzYmLBr66NJtnLT4yGZqjQOcqRVFrCpA5JonKywK7wB5j220c0Ou5soD3gyeUW+Lh4koMZ2ltiEz3cyP28YxRAlV3A1upZVVnEfJL/DNOC6kICJpFqTzW3SGsyXKUdpYQTTy1WaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772287023; c=relaxed/simple;
	bh=folcasxC8R85n2b8wnCDU1NJVS3iOEobjI0icOIulEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mIx2WB7+kLuZ2dQiSLh/z/NBuXpZjIZfWf1eNar0+hyf/ydr5DjVwgqv19j9xoQetOFiu/m11NTut3VhO1cESGrETesAbFrrn0asvGFI94i/j/1Grlnw40Bi/VgYErM9sybISEv04DTZMo8RHs7v20mi40WOXXbtELJrPHHcJyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9fmpxR7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ssnDYfWe; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772287019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lPeE6tJ7LvztkqM9H/hBuFs1UkdrH4QjKz/WrRBZT6k=;
	b=M9fmpxR7HhIRw8B3jvZ8D9lyvJKfZx5nx4h8ue9abcI9yaQhQs1zWQsgCtR7ma5dNl9HXp
	GUDye5hFO9QI1YgQVc3elxXMRrTQj2fi9FQkPsQ6gMmekHfga2FHdS+fe8mW+xwkSrhAde
	tV0peDc0rtrhrGjB9m1UN+wBXRwY5/4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-1VJ6sKqXMcWRoKvWbq-ISA-1; Sat, 28 Feb 2026 08:56:58 -0500
X-MC-Unique: 1VJ6sKqXMcWRoKvWbq-ISA-1
X-Mimecast-MFC-AGG-ID: 1VJ6sKqXMcWRoKvWbq-ISA_1772287017
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so34028805e9.3
        for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 05:56:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772287015; cv=none;
        d=google.com; s=arc-20240605;
        b=h4UBSWKN08WGZtZNk4Yj1gox1DiMXycSLVpWPOmVW+k3z7iqZV49GoonAn+fw1Wb53
         u7VUxGejf+qOqklsd9sTn7Dz2Z42R0fXxzIi3F3xIatAGdpotn+NvzMrYDuZ9dS0kG+x
         OJRily4hUa19g+zajWJw7IrdwaLGgCisI4GYQ5YiIJbF1d1SsfaOb6CQbCldIvmd6uwq
         j+2bwx/e0HEIjgqPj+8a/iyvIYbGZZzEi3N6KqD1BWfqpLHfxcva9EDH8zAiFE0xUX1Y
         bKdqBmmvnQCJ7tKC5Bpu0NXfmsmDl7i7ph0mwFKVTjkilbu6HnZ5TxR/pv1pobJ7jv3i
         JMpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lPeE6tJ7LvztkqM9H/hBuFs1UkdrH4QjKz/WrRBZT6k=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=UUu+ljoBzjWaBWeMV1YPFouK9FtB+64MHo1XaGPNl2Ymij0u9X3dGliWj1Ce21lAQ0
         PRjZyQW3Lh+O65ztS4YlC/w7uNGdQwiv6Y/tRo7kN8ovYcL8/BtsVRvVmnjr43l6NRrF
         mAN1tazs0Ts14onKIOh0CARZTSwy3XDYDkG5cfh7qjULRWxYi9DiY+5bqJj7jjx7MUuD
         sddMBE1pDzDJ7KzalMfH/jKkwul1rVwWc44X8j3KVugbJ42qn9W/6wtmJSy4RoGlYqmz
         tJDigFAC4yhibbftdccTo/MLYhbMh94sAXoAisULfynFeIJiyv/517wSr2QPs6gbhBfR
         fjgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772287015; x=1772891815; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPeE6tJ7LvztkqM9H/hBuFs1UkdrH4QjKz/WrRBZT6k=;
        b=ssnDYfWeQ51hHa3Zg2j+Y4CVrWm6J9dPl282gLT37FxJfFJip3+lDPNYWCOwSrLtay
         vL9ZJdS8rv+bT3xAYnWSqMvm5ASk2NnDk8vW69mE5LgoTSc3dykUX3dD37jnDwga7su2
         PQKGb1M3e1boWTw0pSBNmp541saFeZ3taXtwJ2OfZ72e7Nk3NU/gtilewG/EfYZNMRW+
         HcrdAP9MOU/upM0iYryB/Vs9Lx+yM1JvmpUinvj8/5QYS9Z+tAP/f4+hZZHFTDfDIr5z
         8PSO8IaUZK5QN1CvOnyIeGD2nT1DFQ4qM6odiPe4xnsGXav1ASkOQ/Jo1Zn79WynSLWt
         vGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772287015; x=1772891815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lPeE6tJ7LvztkqM9H/hBuFs1UkdrH4QjKz/WrRBZT6k=;
        b=WjXwLC6j1wP6yyZJI7kI03wpvMMr4kTS43TkCm/X7BZEkTINUJit8qtP8isYcAbSIx
         /vMKQ6L4Div49g7qyyXVKoJceXTxnq6X82k2z70OxLDD80rF2SS4cGo3RuqdiYyZ0hPV
         8mrV7ddgP412bXScJI9D6V8NWN6I2HeOF1O45o7Z+yVLaXWRZ7r0zT3w6NDk34XmFGoa
         OoSjeP76hNpQSUpkbu8++MqKf5rnEEAbn+1T4lgPY+eoGRNSr/RRwi7AJe4jmJgqtIFy
         TfvGxDjkc0BjBwZk696O9pdie6RDJVJb86+whjc2tY2pNC1EN6wE0esw7XDTcpkPiLB9
         TNYA==
X-Gm-Message-State: AOJu0Yy/xU1Ha6+jE+YYrf7ckMATnVLunF42oOR1yL6LOQNqFLsGb9+i
	ifjh4zjB8YSkHAhQlTjHoGTYdFPSHnC9SYqNFmZF3yrxBIkACdcTNAKRF8NqrLX1HaWwNc5lUxq
	bzXfPjbzJyQSSKC+jzeK/HuHPUVVCoJf5Jp1eH/BbpnmebKYNRXmGreEYGVj0jC9WIme4L2XNXW
	jZXw5NLrT4TDcZOXeomuV6mMFbLIckkpLIBBnRU8A=
X-Gm-Gg: ATEYQzyMrhR0rKMph06RaBzl0HRRDT6lGw+ddHTLv7kgBujX6hkCa5ua6CptFgZXQa/
	KbCEbfkVGhg4LZEONWR65xtRRgYP8JqT9zvgIMZFQz7VUOkpxjdYR+CCS0bVmDq3cScPGxqXGtQ
	wSk9hFg+H8M1IvkkeXGBILlIUrNm8wUlrMUiNP4cUawPLNH4f/r6nOszWHBtLJcLj5nXh9691G5
	3Zx0G1cgEla6ibgKY36Y1wz6vQGmzv4fc3Q6GQyWwzn8ySTFdvUw7Q3+JVxwsgzM98FBp4anrEz
	o+rkgHA=
X-Received: by 2002:a05:600c:8711:b0:47e:e20e:bbb2 with SMTP id 5b1f17b1804b1-483c9b970a5mr96104655e9.7.1772287015623;
        Sat, 28 Feb 2026 05:56:55 -0800 (PST)
X-Received: by 2002:a05:600c:8711:b0:47e:e20e:bbb2 with SMTP id
 5b1f17b1804b1-483c9b970a5mr96104395e9.7.1772287015182; Sat, 28 Feb 2026
 05:56:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
 <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
 <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com>
 <aYp86UFynnoBLy3m@google.com> <aaInA0WGEM3fVCNs@google.com>
In-Reply-To: <aaInA0WGEM3fVCNs@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 28 Feb 2026 14:56:42 +0100
X-Gm-Features: AaiRm52HcKDpbS6MO9vZNRRsa_AijihXRFwIw89yTT0EnVi90z05uyRBgaOXTs4
Message-ID: <CABgObfaV27kPyGH1dDa-f1XaiqP_uM1cCFmSfnrakFD68u0hPg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-72277-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 44CB61C3623
X-Rspamd-Action: no action

On Sat, Feb 28, 2026 at 12:21=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> Finally got around to prepping a v2, and I realized that vcpu->mutex isn'=
t held
> when kvm_alloc_apic_access_page() is called, and thus isn't (currently) t=
aken
> outside kvm->slots_arch_lock.

It is, via kvm_mmu_new_pgd (kvm_mmu_reload -> kvm_mmu_load ->
mmu_alloc_shadow_roots -> mmu_first_shadow_root_alloc).  In fact
commit b10a038e added slots_arch_lock exactly to have something that
could be taken within the SRCU critical section, and thus within
vcpu->mutex :)

(slots_arch_lock is also taken inside slots_lock, and therefore it
must be taken inside vcpu->mutex transitively; but more to the point
it exists specifically to be taken during KVM_RUN).

> But update the changelog to not claim that the behavior is "arguablyh wro=
ng".

That too, yes.

Paolo


