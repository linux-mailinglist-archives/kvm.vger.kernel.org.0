Return-Path: <kvm+bounces-70625-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEK9MpcbimnJHAAAu9opvQ
	(envelope-from <kvm+bounces-70625-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:38:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0FF1131D5
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A21603008305
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A50385EF0;
	Mon,  9 Feb 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRUMEA4d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ir0aOA+D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D871C7012
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770658708; cv=pass; b=BarsMUvnM/PH9QrmJKtDyvhW2frOzVJrT4M8xiI+Jnt+fmyEaZqfaKwbqrIMXYBnnX1BsgexSp7MFIRUHHL9wF8OizE04KkeKNFbyzhwo1ryj85NhYW38bl3k/ESagGCd+ckLjr5GGjkqj/qfj33O145i/6s52YxBRP77fEF7gE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770658708; c=relaxed/simple;
	bh=WFMC2xQWYcctEB4PCdx5VuaEyAk623Yi85b65pZ52Mc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pn9mMHr7Q/NneEzUEB50K1N6LTU8HWIzxLLcUWMkYBXn5JEYxy/pJWdHA17rpxfPgCFjSCNKWs1JSABgjNCgD9k2ph0VIicJdrGDzI5yoNoIzFqc7J9HG2yEV5inu37ERB0MMeaFYkuPQMAnIUZFYBARVWc2wdUR6n2pmqx748g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SRUMEA4d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ir0aOA+D; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770658707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3v8TIEBaPzDBlwBPb6dGwZRmXzW2MxBup0WEE987/E=;
	b=SRUMEA4dwEd+SYFZ2YT7DK/i2sF/EJizD8Oo8UFFPhoS2lY30yE04UWfGqu9DAA4dbMLiM
	yS++XlSBT6NFAq9YjSoWBvKfa9Adj6nCWdqa1npYllCoF96xA+4TF4plNlMdjXphqc5ihZ
	KlZhBXLvP0FQZQbCLTUfVd9ltuHKdp8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-1f5At7V4NoSPzIOVo0KhQw-1; Mon, 09 Feb 2026 12:38:25 -0500
X-MC-Unique: 1f5At7V4NoSPzIOVo0KhQw-1
X-Mimecast-MFC-AGG-ID: 1f5At7V4NoSPzIOVo0KhQw_1770658704
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4377274682fso571306f8f.3
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:38:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770658704; cv=none;
        d=google.com; s=arc-20240605;
        b=blCuwSyZRauHXsclQqVEJoZRdS8tbt6U3cA/58oOuRIpeaA9MhF/RGS+BwX0FacFRt
         wn8YxcRkcSQ7p+oRZ0F/qy31rpKWi4ojBlIb/XN4yQ51pH5KaK3irvDxKKdi1xUZCnWW
         9tmp1qbQCp6V2WESaCQjkYpZig+rJ/Z+vS2xthUVPtbx6R+/pBwaYVTjrOISzonToCg+
         ts/jHTFHpqRvZY79UVaAlHQHDIucncQkiz7U4vrP+5R2FEJBv2V4glnetwJXj+4qeYe6
         U6pokko9PGNITgO/qFg2yYQUsgWaNMZ8M5KT9/AR+RL5X0dXfD7oIXgqAvFGZ6Stj6VA
         RQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q3v8TIEBaPzDBlwBPb6dGwZRmXzW2MxBup0WEE987/E=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=kXeK8h9tXinbXUkHNJ96AG0eaIkhC7IrbH7uE4eQbtmtKkPaSQJXu8nJ4gJKHhBK4b
         GqLzXSeYfGT4navLr45Drh3HE1ASVg2JiaWYqHRbj1z3NM5iPeluZLrUv6JoMxORs9mS
         NqVMNdoiFvF22PqPkACHBz36FmK4LWT1sQ1AEOlqYB3gHqBOSLTLUvdUGTNTR1whMvQK
         IHWh6n1wgoauN7pILxCNnFJ2BASEbdzJeEXCsZJbpsaYEPBztWKGRvOcVwg3nk1VlfKs
         OHZJN+jH4hrLAQjnVY8ay92wwwoN4/celyKWrEh39A4N67aJAiSnF3m5RSbZRHSoOu0g
         XkWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770658704; x=1771263504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3v8TIEBaPzDBlwBPb6dGwZRmXzW2MxBup0WEE987/E=;
        b=Ir0aOA+D4NPAPF1wUs2Pzjjs2qkuQklyrK58YdpuudXpPxbycIt2ncWwhJWq28HMzl
         vV7ya+nhq96SvicwnpvFHv94ueWM6JBH8k9Xk/80LwfeiaPSSfGv7bqMNYh7erKfIgCC
         JkK3EQUlViGq4WxgXdcsxDpEqA0hUrgnGfLdGnoCtN8Y4D89ecHiUM4ujWbZacFyOf8Z
         20YZCHAoO3BKEcJ4feFTjeDRgj5b9Oh72IR5jthUw/cD1f5AQ93o70br+pyrQ5bGygh9
         QyFz3C9uOFQOsMv25cPDbfXhXbPyb8IUujWatY7laPYKluBKa6jwaMxtEBqSzdHWl57o
         Xwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770658704; x=1771263504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q3v8TIEBaPzDBlwBPb6dGwZRmXzW2MxBup0WEE987/E=;
        b=vvwYxIcZF25mvYA1z4Avm4RAP2Me85o8sfyygwkZRKudtM4Li28ZbJBGozZq5OUx/l
         i2fabUi0o8NMYNBr9+t2qjVby/ucO/9Ee6G6XT/z8ePFOvOJLLMfjxIAil1sgiGPNXdA
         FnVjrvG9OkFQycCC9838s7Hn4Q7MhnbhJhYe46UQrSWw/CLNstRim9Y4nGQQr3taZyW1
         Pdcsk0akcDuUSgmRumnvzQHQfq5O5dPQBzRewKzkdPAHCIeKPo8yQKXYUeoHWpqI9f9f
         EalXDvW1FpeAMyOnOpcqJiBI08pio4FTBDn7sbJeTpzoj6OHsWyDYGf0ixoGnqTKU63X
         cVtw==
X-Gm-Message-State: AOJu0YzY/LYNNc8FcP8B/Yu9SXD0EFzY4DxVfmS307H1x12c3KqtL6Pg
	gvUrtFzEjFUrsXC8e7AgUS6EbP8ikGcJ0CHAoly67pZ1ACXBfkUsW24yUyBabZ8XPUVUAKbWVIt
	8xqQxxX1LSnbUgn0F68VQMN5ZCCcR9XRI5uUVe74rQ11S9znTI3OM5DjKGG38P19pdWEls5YuVn
	mvWWrZrr74zI0QCMW9jELtZ+kdYCjm
X-Gm-Gg: AZuq6aLKMS2AHTa+UbTl1GgUnE7u8+EXHwyLVcEBEwm13fYB6ZkUBBe199SSG31MKnQ
	TF9YQS9+il3oYCOcZM+lWzmaikmOCuoZFQlkSPMYtGXobuRGH3YpF3cpDHZ/NiNat25lXCBd+/v
	byIWYo17KAbUqEN/OKPouWg3Hxr5P1NhJt8ULbbpQ/3MzM2jajYKME5Wx2b1Y+hn2m9f/a9DEsW
	+zr0/U+YJ7MBDrtCDJQwZR3atVNi4Vrn0cnjm32b4K/K9q7YFC7mU/IGPo2GYS5uFUc+w==
X-Received: by 2002:a05:6000:2382:b0:437:678a:5921 with SMTP id ffacd0b85a97d-437678a5b00mr7890035f8f.1.1770658704382;
        Mon, 09 Feb 2026 09:38:24 -0800 (PST)
X-Received: by 2002:a05:6000:2382:b0:437:678a:5921 with SMTP id
 ffacd0b85a97d-437678a5b00mr7890002f8f.1.1770658704014; Mon, 09 Feb 2026
 09:38:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
In-Reply-To: <20260207041011.913471-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:38:11 +0100
X-Gm-Features: AZwV_Qgk-LVhwEvzL50X_rAAcDgwgQbtjkYUiHm-eALOwLeRolvVkKi91WeOAXA
Message-ID: <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70625-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 6A0FF1131D5
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>  - Document that vcpu->mutex is take outside of kvm->slots_lock, which is=
 all
>    kinds of unintuitive, but is unfortunately the existing behavior for
>    multiple architectures, and in a weird way actually makes sense.

I disagree that it is "arguably wrong" how you put it in the commit
message. vcpu->mutex is really a "don't worry about multiple ioctls at
the same time" mutex that tries to stay out of the way.  It only
becomes unintuitive in special cases like
tdx_acquire_vm_state_locks().

By itself this would not be a reason to resend, but while at it you
could mention that vcpu->mutex is taken outside kvm->slots_arch_lock?

Paolo

> ----------------------------------------------------------------
> Sean Christopherson (2):
>       KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
>       Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm=
->slots_lock
>
>  Documentation/virt/kvm/locking.rst |  2 +
>  arch/arm64/kvm/guest.c             |  4 +-
>  arch/loongarch/kvm/vcpu.c          |  2 +-
>  arch/loongarch/kvm/vm.c            |  2 +-
>  arch/mips/kvm/mips.c               |  4 +-
>  arch/powerpc/kvm/book3s.c          |  4 +-
>  arch/powerpc/kvm/booke.c           |  4 +-
>  arch/riscv/kvm/vcpu.c              |  2 +-
>  arch/riscv/kvm/vm.c                |  2 +-
>  arch/s390/kvm/kvm-s390.c           |  4 +-
>  arch/x86/kvm/x86.c                 |  4 +-
>  include/linux/kvm_host.h           | 83 ++++++++++++++++----------------=
------
>  include/uapi/linux/kvm.h           |  8 ++++
>  virt/kvm/binary_stats.c            |  2 +-
>  virt/kvm/kvm_main.c                | 20 ++++-----
>  15 files changed, 72 insertions(+), 75 deletions(-)
>


