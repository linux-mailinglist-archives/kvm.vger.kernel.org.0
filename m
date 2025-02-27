Return-Path: <kvm+bounces-39613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EA5A4860C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05446188EA5F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728BB1ACECF;
	Thu, 27 Feb 2025 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dq5/+hY6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05711B4151
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675473; cv=none; b=JbFSxMuMKrEM0soPm/QRirhenDFeNIsHvZBbcsTsGD4dgeVGrSIbyFg09ESqe2LF7pWUSZ2ed2k/AkoTHqEk1SzcPWaosZfQEpWNKETrqLXTF4bV3YRA3+xiiAgoYBSCI9guw5K0WTCn714qyEf/BW7p2dBhz490X+d0Q3bMliQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675473; c=relaxed/simple;
	bh=5Cgz+tVOMD5ENHSy6XjdaYNEPAFKL0wzWZl6dcQkrCE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HzCKZFxnbPAtzTXSd58kk7Gx6s/I/wRzbqBMbes1ZGiPbgmEv3r/oaBdp40U+dcMW5Y4ANkvx/3JYoZSwjuXyZyCSLygkYlrAFsVMD+s/cMNnqw/BZyBtclCh0o4rmepX5kehFE1btrQh4U4qpfZXhrB6TOy+VJEikYuK+nrJAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dq5/+hY6; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab7430e27b2so189962366b.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740675470; x=1741280270; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5Cgz+tVOMD5ENHSy6XjdaYNEPAFKL0wzWZl6dcQkrCE=;
        b=dq5/+hY65EVKQnsIDok43kbDTfcu5heKX2GNGUwBPwiL+NfsdbQn36FftQLoMMVL7u
         dJ7ZG29qxbe6A5bAyz+XYppYNhAjIjA5jscpBgmEnavLIIBmLh3vsME+YAW0E3/+mIcx
         o6Nos5kTH/s3YriFSEV2bugEqdoucs5jM0PrymjnQyiQEbj3QF12zcMkUQuFxKAIcSUv
         voBJC49sMEFNht3m8NAJytkvmeaDuQc0K7p/rhh056G+nzLaDhVRCYdttFnlT09mw75X
         SYlrYCE/Itk8RApvMZ8wRYwyJuRHETV3kRK1YleY+ufWX6NKKNwCXsGuJsZRW+tIkNUd
         iEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740675470; x=1741280270;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Cgz+tVOMD5ENHSy6XjdaYNEPAFKL0wzWZl6dcQkrCE=;
        b=RXCNrwNCB4eXM0ua1PjJ59k8n74aDA0cq6ro+qjU0nLo7vQbDQLsBKwF/J3VKSr9ur
         ubT8qM2Z2f1KAup36Bpg8FKrLn5k8laLhXk04Gg1AGReADKgcu16ho9MdC+phIZd4Tv0
         2PX8FEQIcDWxUECtvTyCyIGzfHpcoDu0rq8mriFyg1kv+fVQvNOxofdPDQWjyltPQBgw
         /JqSEhyb6yLAOdZ/MM+JOvYRtp5d0S5rfLH28BuEh/NqOPMDGQhFMwvDPmbwgO8gEc+d
         IahMbgIh46OTIv+ncAyI/7KYhBnADEO5QtrsxcTzW/Kx2TQ8FyaZnaOQm9fP5GQpo3U7
         AzPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZc4NuLSVB+KiQsh33NREM7EgTPtzsohMcGBFLXm911ua9Fko/lHXKA0P6lZnQZXCgfgc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2zRfUpVKLNBsRh2L8yAdBaHJZGVOKFzMbG8nBIj0fVjiQxFn4
	ACLXSyldR74M06MD+ApO4VUUbMVdwXxPChzDlg4zvSTSrn7B2Vla
X-Gm-Gg: ASbGnctCpDlElmCljv5hE++dusElmZkKN/r8eUPo1ZxPtF/ZDuRVwt+4rAS6GZ4ByPG
	ndeh+x1ItlIykyDRKbhwjZPo6jEzxu+UzgE3KNOOKpcaAVEvBG/Gk/fP2RNdMfP7vH3F+tLsjF0
	cQce43wt6peSTy1Mgnp7kVESHV1B998H1+py2CdQYvzhi5k7cskvr6JvhE+AVcF6RurDCNagIDi
	Q3aBLIkN6Gkopi/ziyJfNG0xnBaVOMnA2C/06SA1SSPJ+dWQQFRYcJrnWp4Ex+R7CNMynnNw5AU
	jjNtf4LTguKr3U9wyiXk+Pk18wZT1mrvi2//52W+lNxNVdz1DM4iRelJc43LzDYHngyx43IWD2C
	s2v3UR1s=
X-Google-Smtp-Source: AGHT+IFoqcFF1a1SnBwVN073YQUKGQCPLBWt6b56ydwnsLYg1jhB/EScnrejzAsoRpPuws6rq3GYDQ==
X-Received: by 2002:a17:907:7212:b0:ab7:e278:2955 with SMTP id a640c23a62f3a-abf265c839amr16233666b.38.1740675469853;
        Thu, 27 Feb 2025 08:57:49 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:d6d5:ac54:57ce:812a? ([2001:b07:5d29:f42d:d6d5:ac54:57ce:812a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0b99c7sm149940866b.33.2025.02.27.08.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 08:57:49 -0800 (PST)
Message-ID: <40b8bf9854d4a83b55ae8e83f093462b5852a35f.camel@gmail.com>
Subject: Re: [PATCH v7 38/52] i386/apic: Skip kvm_apic_put() for TDX
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Daniel P." =?ISO-8859-1?Q?Berrang=E9?=
	 <berrange@redhat.com>, Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
	 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Marcelo Tosatti
 <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>,  qemu-devel@nongnu.org, kvm@vger.kernel.org
Date: Thu, 27 Feb 2025 17:57:47 +0100
In-Reply-To: <20250124132048.3229049-39-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-39-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
> KVM neithers allow writing to MSR_IA32_APICBASE for TDs, nor allow
> for
> KVM_SET_LAPIC[*].
>=20
> Note, KVM_GET_LAPIC is also disallowed for TDX. It is called in the
> path
>=20
> =C2=A0 do_kvm_cpu_synchronize_state()
> =C2=A0 -> kvm_arch_get_registers()
> =C2=A0=C2=A0=C2=A0=C2=A0 -> kvm_get_apic()
>=20
> and it's already disllowed for confidential guest through
> guest_state_protected.
>=20
> [*] https://lore.kernel.org/all/Z3w4Ku4Jq0CrtXne@google.com/
>=20
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> =C2=A0hw/i386/kvm/apic.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
> index 757510600098..a1850524a67f 100644
> --- a/hw/i386/kvm/apic.c
> +++ b/hw/i386/kvm/apic.c
> @@ -17,6 +17,7 @@
> =C2=A0#include "system/hw_accel.h"
> =C2=A0#include "system/kvm.h"
> =C2=A0#include "kvm/kvm_i386.h"
> +#include "kvm/tdx.h"
> =C2=A0
> =C2=A0static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int r=
eg_id, uint32_t val)
> @@ -141,6 +142,10 @@ static void kvm_apic_put(CPUState *cs,
> run_on_cpu_data data)
> =C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_lapic_state kapic;
> =C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0 if(is_tdx_vm()) {

Missing space between if and (.
scripts/checkpatch.pl would have caught this.

