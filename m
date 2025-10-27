Return-Path: <kvm+bounces-61228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6ADC119B5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A910519C59C3
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1B1322C7F;
	Mon, 27 Oct 2025 22:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eeXom3uw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964712D7DC3
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 22:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761602619; cv=none; b=NpzfjMIXb/nPDuQ3rKrZnNYBIlTs2QoHr7UgvA4UulCd8Ng8SNG3jJROZJvrsvrO05RE6QvGMl2jADMG09IweBOCpKsCJx5Zba4aeLBJ3RC22fe/NSFJV/EuFI2oyRncSBrrgmSO9pcBIHBwNBRLi1A/Eegw9oe8xAYmVrnZfqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761602619; c=relaxed/simple;
	bh=o2yvo08Ip4ydQArcoPeQZZ9iA6ySykeNGAN58HBmLGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hkE+Z7ihDwdPiF1F4THd3DzlNAxZ5+UWgCKDeCF7imSTvB82CciF+ggU+mNxYi4lvE8W4CI4etoKtVTbFyyD9tdGrgQG08Vo3IraBmqFjTuUbuXwSBiTq9JQ/9vcuosMmScBBfbJEUbJSYhOrWU0g/U43ZfNHGxuOcSzbeKp1Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eeXom3uw; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so1828a12.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 15:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761602616; x=1762207416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2yvo08Ip4ydQArcoPeQZZ9iA6ySykeNGAN58HBmLGI=;
        b=eeXom3uwT4g+9P/RhdrWTyKuQqPL14o6Hn0xHj0OX8dE3hSqjc0mcRVpOIRTRaM7es
         aRmVPWQHXgUAproPolF7ok25yMyA/1SMR8Gnj1vPDPeUWWr7myJ7vugSW9ZsW9LxY0/I
         ehvHAWqb07lxGTsUBtDWRsMJk4zLRZzoECnMwjNHvHnI96ob4D06JjR6Nkf2iDRDB1eT
         w2gfRp/Ztm3PIbm1w+Hc2xMp2OzTOnWfvLyFdjGy+LrJMmPSN2hrZpOzLiGqG3HQAcHv
         BYh9tSuPuU+NeEIKJXPMydPLphOtTsWgww+skVviZXL359zQtS5qDScob1PWcN/xiAHe
         Nx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761602616; x=1762207416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2yvo08Ip4ydQArcoPeQZZ9iA6ySykeNGAN58HBmLGI=;
        b=SClyq5LmwtGYaqwwBVqS6xRZQqqNtbxonC1B6OyXGFHpu59yclZGwYIF+dIF2x4tDU
         xoUruEFx4tuP96tTeUvWAKWUMDE7ehfQ2duiwBHh/Mcsfd/3aFbxBo/ah+Pq7JWw9ZdZ
         4Hihjr7s57PMCh5yCDQz/kyDZJEG+yRTUhcBpeocI129RlWk1BNe8y5oQdZOsD+hX446
         yr9ay77k8EJUj9tzqPm+H1ZCm2NvHlL8ZmlC05wYaZVcg/NRISGscgykhjbIucbTHeO8
         0NWoNvGqRr5/W5ZAcRyjcFIuq0x6+YaYIXPJC70uhvsAodBr2qISUEy21un/RXNtDiAI
         Z+5g==
X-Forwarded-Encrypted: i=1; AJvYcCWfux3Zy+mq83aSfsutjB9rpd0DlURbOAfzSTPq6A9KxJeWVxHKU9sChyOLTClFALBv3Yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Lz+E3QDEeDWa0Wh+4Wpd1jO8BECWWn0/2tocr1f4J0AsAZrP
	j/gy9bn/4r1SIzEFs3iMHTDImKKr+XaScj0cnCFEkVHdlOh8kw6vr0DkpeoM1CqpZ9g1no0w7tt
	iecmGW9FVybN6YLdDXBY3yrmjeMqojuRl2H+WXBJi
X-Gm-Gg: ASbGnctVu1h7lFdg0g3O4PS1NBYaa2hrMtc3B8rP66LHu6IAxGOdePVuH7W3TGXmyKQ
	oBaLKXWOnWEz9b3p2KgDcBeDZcD3EU4IjXUxioRe5XlryFg3mJ1lv3seX2i6/2c6ww7baUeQmTw
	UqFyAkqG8o/IRzpJu6Fnyk3P+ZVwipF3zJxh2OKxh2Xq9J4wIHyX3qv9aBPKCI6HP6LEbSHnmE8
	IBJRvspOMQcOhlYG6PnVD2bmy4TQQCEt6Fas4ZLIaKk7RgPJ8jUbQ3mplo+tGioYAFr0kY=
X-Google-Smtp-Source: AGHT+IEmQpmkPe9yoXOjQqwkeSYWcEwxmIwno18/dHKODLPNMJTY4Qfi6Uf3STcl/iHL8V6tAR93s5hrkHsVZz2OBcw=
X-Received: by 2002:aa7:c495:0:b0:63e:11ae:ff2e with SMTP id
 4fb4d7f45d1cf-63fdc443d68mr12253a12.3.1761602615812; Mon, 27 Oct 2025
 15:03:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com> <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk> <20251022012021.sbymuvzzvx4qeztf@desk>
In-Reply-To: <20251022012021.sbymuvzzvx4qeztf@desk>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 27 Oct 2025 15:03:23 -0700
X-Gm-Features: AWmQ_blpuvtqRlYpWMPesPOu7B07-0aNn7e54b89gCEZ2S--g3Rb0i2EBbNBq0M
Message-ID: <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 6:20=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> ...
> Thinking more on this, the software sequence is only invoked when the
> system doesn't have the L1D flushing feature added by a microcode update.
> In such a case system is not expected to have a flushing VERW either, whi=
ch
> was introduced after L1TF. Also, the admin needs to have a very good reas=
on
> for not updating the microcode for 5+ years :-)

KVM started reporting MD_CLEAR to userspace in Linux v5.2, but it
didn't report L1D_FLUSH to userspace until Linux v6.4, so there are
plenty of virtual CPUs with a flushing VERW that don't have the L1D
flushing feature.

