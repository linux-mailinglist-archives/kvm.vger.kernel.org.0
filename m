Return-Path: <kvm+bounces-70263-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCFxKd2Ug2mppgMAu9opvQ
	(envelope-from <kvm+bounces-70263-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:50:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C598EBC1B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0B693013EC7
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849C4427A07;
	Wed,  4 Feb 2026 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SoNPyj9c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8184346AFC
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 18:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230998; cv=none; b=f3qEbmcBkk0HMkmTbYWMOaFH6jt4eJo2dRQhIKf+3R8lOtm9rT/UCrKzZj+g9IzYO9ZXEoL9f2XPnVMJo8L6Or0QQYZU/NbDSy5DIVGCdgsrgq3LuTHsZEGgsTEPeqau9vW7g8tTPkcxb3ccDIZkQKDqNR1XXBRsokqbzg7KBeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230998; c=relaxed/simple;
	bh=TwOsXCTjezYJTUVOzpfiEkknx4xdSPRMx2aKx1LMyeM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ADAB+pO+YioWXsXfnHb2ZIbqjInbzDXI5IlcaMMrlNpnYUwfz+IzY/ybVXEs64yXBVErQCzRKgduoSDLmUmO3KB09G40BfcgzDHhq1M3ExdtBPoVx9VIcoL6XdcdEsauLe9egDk+o0Ez+mxlOSqV+jgZzHBKMcLZIxWI57OF5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SoNPyj9c; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c54bbe46so637915ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 10:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770230998; x=1770835798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFI0xPSSnz1uN79nkqpmH9nvzfptC/fb96+o4r5jF44=;
        b=SoNPyj9cYcOL5xL1FTbrR8YkhKQ0R2jgC1M3MhLlnsf/gc7J/dW41u+6+fUJRHXC4H
         T9I/i/cuUFnaZHn2p/fCCK15RN2EDBYqGSOcwbYa5eaB505gNhpzi+pum5BKB72Nq+2I
         trtyIlAqFzU/K+qICVfgrd6WpIkBDTX6DyL6y7dWFcBoetgZGPb9tCkVF2hXkYrzol0a
         FYi0XsD5qjULavtU5IWUIeVGL5YDE02fDvYqcRDbjYj2rcamnCsCs4s7zktpTzbHv6QM
         kO+birtgprW0M2EA4T+mnvZNr3WZJfGYCo7LGBUJna9uxTHbBJF1q+4n+9oJmzW0t3on
         MHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770230998; x=1770835798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFI0xPSSnz1uN79nkqpmH9nvzfptC/fb96+o4r5jF44=;
        b=NEJWmWkBPgryOb9Jb2mA88LAuyTSVD/CciiSL8VVAzlWFckfExbDJtY/mli6XMUpk1
         61maXJVyLZxuS4OUzIPi+px0b/2iYYLGBMDUYksU8SpsNW7Rjs32QuOBuqNZluS6vlb0
         qqWUgHpwcT9X1wvdfot52z+MmycwJqmMw7kr/MXhuKVmM2+GbE0ww/h9iA+MHAKTZR7q
         LUUTWop5duzWx1IXXO6M2WG3bWN59p/TRJEfWpanHAI+40eBOlO8VKkIOWvxnYWxn1xp
         Q8xYZHQAWiTLfNP/mHTfX6Wj0h2oTl6LeREZy6SMY/t+YtbPQgGXh9/2E5N1aqAhF1wr
         V8MQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4+S9V3UJTCHVf7iw67TODYwc1oYyhcPG1Nhw+jSE0BkG8uo7Of9n5JdYSR5F1zeQa05E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjMXY0J3IeNocVlqH586fW1lABMjILp9Q7fY1raumcSLobY1EM
	oS5MRtsLwadszz+KV2mO4F4DfO3iZ0qUbm5f59jr0us/N9g8DE7M2s7gamBelqwsb2zJy+h0HZN
	ezH6W8Q==
X-Received: from pleg22.prod.google.com ([2002:a17:902:e396:b0:2a7:6416:3f7b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:196d:b0:2a9:2942:e16c
 with SMTP id d9443c01a7336-2a933cdd172mr28785765ad.9.1770230997981; Wed, 04
 Feb 2026 10:49:57 -0800 (PST)
Date: Wed, 4 Feb 2026 10:49:56 -0800
In-Reply-To: <20260130020735.2517101-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260130020735.2517101-1-yosry.ahmed@linux.dev> <20260130020735.2517101-2-yosry.ahmed@linux.dev>
Message-ID: <aYOU1NLFmk1roKY5@google.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Refactor EFER.SVME switching logic out of svm_set_efer()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70263-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 1C598EBC1B
X-Rspamd-Action: no action

On Fri, Jan 30, 2026, Yosry Ahmed wrote:
> Move the logic of switching EFER.SVME in the guest outside of
> svm_set_efer(). This makes it possible to easily check the skip
> conditions separately (and add more) and reduce indentation level.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 72 ++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6b..4575a6a7d6c4e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -200,11 +200,49 @@ static int get_npt_level(void)
>  #endif
>  }
>  
> +static int svm_set_efer_svme(struct kvm_vcpu *vcpu, u64 old_efer, u64 new_efer)

Code looks good, but I think we need a better name.  This helper doesn't actually
write vcpu->arch.efer, and the name can also be misconstrued as "set EFER.SVME=1".

How about svm_post_set_efer(), to align with kvm_post_set_cr{0,3,4}()?  It's not
perfect, but I can't come up with something that's more accurate without being
stupidly verbose.

