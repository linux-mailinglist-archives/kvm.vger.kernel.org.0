Return-Path: <kvm+bounces-10085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6102E869055
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A293EB293A9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A55B133285;
	Tue, 27 Feb 2024 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1NbAnKP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E894313A893
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036496; cv=none; b=YgDTCisaNKBmZwfCXgBLX3xoiswPXQeWMvZdqC3bYd8zKNbYmkgAMQlmAKdzVM1nuI+K1Sd1rEoU1TIag0qGyjY1er1Lc8r4BkJjG042UcIaKFRvc32vTg0mCY3HvG+Njbo+S46ajzoyv5soBEb6P7ivPCn3dBeEblCxNA/crl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036496; c=relaxed/simple;
	bh=1S8zq3tvSstPyR8nLsYwnTGnmJiTmTAvWba5m7EsA7M=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=FQsRMq3pnvpE9i1Xh3bLp/iVuX20hfMfK2x8PUf2SFvAChxxjQzhr3/B2VF5H1yE2mOqBciWu3cVtJEJx0n/3eepyQT87LRocRSYSVmjYa1WBZM0EprY8oJzE12E1ZbfJXv3lee5NsIfbY+SO18N6jTRr3rqb2+xMDp5VYCcDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1NbAnKP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e4e7e2594cso2281646b3a.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 04:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709036494; x=1709641294; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkCS7sMvEqhguoKnYki94Kfyn8T2LKKQdJNAbymol/w=;
        b=j1NbAnKPKc9HTwtAHjI75RtbbxepDbOGlH3Coomqc2A7UDhAcCcXKaD54rJLXICluJ
         faiQ9G9ykwleIzRfVJZrZOKE31ikWmGsfRP18MctHhmx2sHg0kaeIE6OZn6VnMy7EgxP
         xBu1rYsqM8leZefZu2WMSj9KCCqjqSiLaiz91ET/jYizsG7nlWHEn9SApcWFMCXTf4Gq
         H+9xQ96JVAaalLt8XK+MwomB4yTMInzjxP1mDYVsbIHT22M216cQX2MPupbUkxI+rdv/
         Su9106cZP9hieernkNiz4brwX67xNN352lUA+6UjXMSpjEMfpc8R/qHp6NP/+Te2NF1B
         fQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709036494; x=1709641294;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lkCS7sMvEqhguoKnYki94Kfyn8T2LKKQdJNAbymol/w=;
        b=F9EkXR9IUXoeUD9LRvZ2U2wLblgnprCroHjcQ/2Mst9dWqruU2NmdwsVTJwWz5t/l1
         f+QDXJsS9/i0jfpLbTsLMZUd7rpPIXplTYzfg5nH9YWBBwbdGWO2qnAvgpJANQO/wS1f
         1ZWSZ/XAGHpkcTJ+S+EUVEOh/p+DEP+KoDS9mtV2P/lCk4bWGBhZ5NDsTqZZKYw4GEJx
         TLZ0GALetc+mSw8wZgxBUYt6TcprFoqThZXkq88oWzh0plJtr7erbZlNZVOXQWtZDfZ2
         Mrnts6mdxXPoqwU2KpRMYihCM8sqjDO91iJ9KSoQ4Gejwr329cITL/gpqJmAX1TmGO0h
         WsDA==
X-Forwarded-Encrypted: i=1; AJvYcCU+pt78VT/7CsjiD6mJba7o4eKfLB9JSeNVyACrQv5wwNYZQTMEW0XfkhGatQK5zRkSh3IVo0/upZHk4FK8RnP5fzxY
X-Gm-Message-State: AOJu0YzWfovi2w2zKMISasgH4EjA/f8h33+TK5xjqCcCtYdYkY/0yZKL
	oYE7tAANlLfwQVkzNOVxLCuvRSqPOc9LCoKETgw5+sbEp/3qV/7r
X-Google-Smtp-Source: AGHT+IFNmgiJ3feZhOOuXLA64DzfU1EGlypxneaw1HY6nxX8QiMCv181QV4xZtmHoYrV6OdGfye+2g==
X-Received: by 2002:a05:6a21:3482:b0:1a1:101c:7c70 with SMTP id yo2-20020a056a21348200b001a1101c7c70mr991048pzb.59.1709036490010;
        Tue, 27 Feb 2024 04:21:30 -0800 (PST)
Received: from localhost (110-175-163-154.tpgi.com.au. [110.175.163.154])
        by smtp.gmail.com with ESMTPSA id z25-20020a631919000000b005dc85821c80sm5567163pgl.12.2024.02.27.04.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 04:21:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Feb 2024 22:21:23 +1000
Message-Id: <CZFUVDPGK7OU.1CBJ2TIMJ719P@wheely>
Subject: Re: [PATCH v8 2/2] ppc: spapr: Enable 2nd DAWR on Power10 pSeries
 machine
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <danielhb413@gmail.com>,
 <qemu-ppc@nongnu.org>, <david@gibson.dropbear.id.au>,
 <harshpb@linux.ibm.com>, <clg@kaod.org>, <groug@kaod.org>
Cc: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
X-Mailer: aerc 0.15.2
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com> <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>
In-Reply-To: <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>

On Fri Feb 2, 2024 at 12:46 AM AEST, Shivaprasad G Bhat wrote:
> As per the PAPR, bit 0 of byte 64 in pa-features property
> indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2n=
d
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
> whether kvm supports 2nd DAWR or not. If it's supported, allow user to se=
t
> the pa-feature bit in guest DT using cap-dawr1 machine capability.
>
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/ppc/spapr.c         |    7 ++++++-
>  hw/ppc/spapr_caps.c    |   36 ++++++++++++++++++++++++++++++++++++
>  hw/ppc/spapr_hcall.c   |   25 ++++++++++++++++---------
>  include/hw/ppc/spapr.h |    6 +++++-
>  target/ppc/kvm.c       |   12 ++++++++++++
>  target/ppc/kvm_ppc.h   |   12 ++++++++++++
>  6 files changed, 87 insertions(+), 11 deletions(-)
>
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index e8dabc8614..91a97d72e7 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -262,7 +262,7 @@ static void spapr_dt_pa_features(SpaprMachineState *s=
papr,
>          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>          /* 54: DecFP, 56: DecI, 58: SHA */
>          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
> -        /* 60: NM atomic, 62: RNG */
> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
>          0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>      };
>      uint8_t *pa_features =3D NULL;
> @@ -303,6 +303,9 @@ static void spapr_dt_pa_features(SpaprMachineState *s=
papr,
>           * in pa-features. So hide it from them. */
>          pa_features[40 + 2] &=3D ~0x80; /* Radix MMU */
>      }
> +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
> +        pa_features[66] |=3D 0x80;
> +    }
> =20
>      _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_si=
ze)));
>  }
> @@ -2138,6 +2141,7 @@ static const VMStateDescription vmstate_spapr =3D {
>          &vmstate_spapr_cap_fwnmi,
>          &vmstate_spapr_fwnmi,
>          &vmstate_spapr_cap_rpt_invalidate,
> +        &vmstate_spapr_cap_dawr1,
>          NULL
>      }
>  };
> @@ -4717,6 +4721,7 @@ static void spapr_machine_class_init(ObjectClass *o=
c, void *data)
>      smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] =3D SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_FWNMI] =3D SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_RPT_INVALIDATE] =3D SPAPR_CAP_OFF;
> +    smc->default_caps.caps[SPAPR_CAP_DAWR1] =3D SPAPR_CAP_OFF;
> =20
>      /*
>       * This cap specifies whether the AIL 3 mode for
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index e889244e52..677f17cea6 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -655,6 +655,32 @@ static void cap_ail_mode_3_apply(SpaprMachineState *=
spapr,
>      }
>  }
> =20
> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> +                               Error **errp)
> +{
> +    ERRP_GUARD();
> +
> +    if (!val) {
> +        return; /* Disable by default */
> +    }
> +
> +    if (!ppc_type_check_compat(MACHINE(spapr)->cpu_type,
> +                               CPU_POWERPC_LOGICAL_3_10, 0,
> +                               spapr->max_compat_pvr)) {
> +        warn_report("DAWR1 supported only on POWER10 and later CPUs");
> +    }

Should this be an error?

Should the dawr1 cap be enabled by default for POWER10 machines?

> +
> +    if (kvm_enabled()) {
> +        if (!kvmppc_has_cap_dawr1()) {
> +            error_setg(errp, "DAWR1 not supported by KVM.");
> +            error_append_hint(errp, "Try appending -machine cap-dawr1=3D=
off");
> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> +            error_setg(errp, "Error enabling cap-dawr1 with KVM.");
> +            error_append_hint(errp, "Try appending -machine cap-dawr1=3D=
off");
> +        }
> +    }
> +}
> +
>  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =3D {
>      [SPAPR_CAP_HTM] =3D {
>          .name =3D "htm",
> @@ -781,6 +807,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =
=3D {
>          .type =3D "bool",
>          .apply =3D cap_ail_mode_3_apply,
>      },
> +    [SPAPR_CAP_DAWR1] =3D {
> +        .name =3D "dawr1",
> +        .description =3D "Allow 2nd Data Address Watchpoint Register (DA=
WR1)",
> +        .index =3D SPAPR_CAP_DAWR1,
> +        .get =3D spapr_cap_get_bool,
> +        .set =3D spapr_cap_set_bool,
> +        .type =3D "bool",
> +        .apply =3D cap_dawr1_apply,
> +    },
>  };
> =20
>  static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
> @@ -923,6 +958,7 @@ SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECRE=
MENTER);
>  SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
>  SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
>  SPAPR_CAP_MIG_STATE(rpt_invalidate, SPAPR_CAP_RPT_INVALIDATE);
> +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
> =20
>  void spapr_caps_init(SpaprMachineState *spapr)
>  {
> diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
> index fcefd1d1c7..34c1c77c95 100644
> --- a/hw/ppc/spapr_hcall.c
> +++ b/hw/ppc/spapr_hcall.c
> @@ -814,11 +814,12 @@ static target_ulong h_set_mode_resource_set_ciabr(P=
owerPCCPU *cpu,
>      return H_SUCCESS;
>  }
> =20
> -static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
> -                                                  SpaprMachineState *spa=
pr,
> -                                                  target_ulong mflags,
> -                                                  target_ulong value1,
> -                                                  target_ulong value2)
> +static target_ulong h_set_mode_resource_set_dawr(PowerPCCPU *cpu,
> +                                                     SpaprMachineState *=
spapr,
> +                                                     target_ulong mflags=
,
> +                                                     target_ulong resour=
ce,
> +                                                     target_ulong value1=
,
> +                                                     target_ulong value2=
)

Did the text alignment go wrong here?

Aside from those things,

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

