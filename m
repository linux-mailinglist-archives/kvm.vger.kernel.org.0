Return-Path: <kvm+bounces-23081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7E49461CB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59CF51C20F59
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0088F13632E;
	Fri,  2 Aug 2024 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAAxmcLj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BF816BE11
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 16:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722616258; cv=none; b=WTAzdjDZ1RbUNP1lRslJqPkEjQcPsC2yvnE2LfdtS+8syHFGg2RW/cqB9UKisjjxPobzciC+wKAs+rqEzZ/MyRbSEduZ4y1GPEc0QbZlRCkGUsjXA8QXZxWJ1Idb25U8TKNZPZmZqvUDiGMo8l2T+nooU8gaqO829hT9iGhekIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722616258; c=relaxed/simple;
	bh=aXQN0ogjL67g7KjkHjUypVIENWtH3wW2EzMgkgwJxRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHKeeHAjsHzTDAzj7BzDA89Lz5yr8MibYrXkWaLnvnwhT9mF/u2+vYsclmgV/HXOsPTkL4S5U+hPRYHZIErdtRgut+iNVXcpAhfyXkm8NGWUWVAklM9X2NsnFDvxbvccdZaFJskQLHO57FsRMEBJW6nFz3hVVZuZSk5c1Frtu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAAxmcLj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722616255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6m06RkjGkxPJM65V/V+1h9jWB5bDFy1DlMvt28wHMlU=;
	b=XAAxmcLj7C5Z8KpnSIu0G7pDI509GKRfSSz3hYruYFKC+n93sTPg0izr7obRia+pvKCG1u
	JBZgfgtp9EC30KiSbGKxZxZ/rh9aohgQaieXfaUqQAHwBB7H1hF1Y28ls+uXaQKhKBxGDs
	650Bf++46R+O4OiXIcf8tXrHylup4Pc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-ppdfPvAYNXuDlCqdXT5NJg-1; Fri, 02 Aug 2024 12:30:51 -0400
X-MC-Unique: ppdfPvAYNXuDlCqdXT5NJg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-36bb24c86d9so1039905f8f.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 09:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722616250; x=1723221050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6m06RkjGkxPJM65V/V+1h9jWB5bDFy1DlMvt28wHMlU=;
        b=wk0ITTq7739v2BVBoDK2gKIvZXeBLkh6WD4QVWyFWs4Tomb0wLRV3/YwqkGbaC1GV1
         PO9+KbVSO5rqK3XdQ6vpnKbqNTbKV9DfKXK6TR2ffNOreJazuGSyIaXCHZRChVEO3nPD
         n1Pv2liZsrmm3wBphpkeBpNm7XR10G/FllR73vJaa8cg2sfRf8fHIxuGzqW2OYbwtJKr
         4odwIUXqRVorJH7lqKiBqJbU6zlvf91QfUdse4Iq7Gsn/JPTML5yIW8XCfcOMOy9u2H2
         u07YdCt8/vJFaLJH/TK25dnTaFe5GQA3jqf72CevIHoDzHukxtb4OGMiGmi7FVqiTxON
         ceug==
X-Forwarded-Encrypted: i=1; AJvYcCXk38tcjM0NF+K0PcRYGSYaH29n12xggZIR0cME+rLQopw3i2/KMa84HegAEGVtbqirYBGnbSKOAVFzeaRB3DTGQj3G
X-Gm-Message-State: AOJu0YxtCc4IFV2Qdg4garziCHWU1mgTb0MRd5iKEGAX/erWfcX1epTf
	6+jvdSjVZLJu3694KWFY4FXQK83CDavymHT0hIehZYKr0c6tAWlvuTPLu08yCSz0u5g3w1u75rb
	NvJ7POA3iRlPb8huS/fU94UqArouIrtmquUwMl00ixAwvWDHD9iy08UrrEfm5lLKoQKNkd0l2/U
	NTiYE+9rn74+PHCoeDk+8tQns+
X-Received: by 2002:adf:e852:0:b0:367:99d8:70 with SMTP id ffacd0b85a97d-36bbc18308amr2537981f8f.61.1722616250121;
        Fri, 02 Aug 2024 09:30:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGstwkR60ibEcw8CeHcDOIV3+NDKED6h/oyKd5Ygh4Ao3Y1Vhk8VrDPd0uSFakXvoOcz/+u/W/yEx8hy6i2+mg=
X-Received: by 2002:adf:e852:0:b0:367:99d8:70 with SMTP id ffacd0b85a97d-36bbc18308amr2537958f8f.61.1722616249614;
 Fri, 02 Aug 2024 09:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3ZhXmbDFrWneA9aA8ALYy+SgMpyopd_9MPzYgWksMLBQ@mail.gmail.com>
In-Reply-To: <CAAhSdy3ZhXmbDFrWneA9aA8ALYy+SgMpyopd_9MPzYgWksMLBQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 2 Aug 2024 18:30:38 +0200
Message-ID: <CABgObfaakho9SPTjkSo0uDZ_UyOv08Mxc2ym_88gGgQTAA5OQg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.11 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 1:42=E2=80=AFPM Anup Patel <anup@brainfault.org> wro=
te:
>
> Hi Paolo,
>
> We have one compilation fix for get-reg-list selftests
> in the 6.11 kernel.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f01=
7b:
>
>   Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.11-1
>
> for you to fetch changes up to dd4a799bcc13992dd8be9708e5c585f55226b567:
>
>   KVM: riscv: selftests: Fix compile error (2024-07-29 10:10:56 +0530)

Pulled, thanks.

Paolo


