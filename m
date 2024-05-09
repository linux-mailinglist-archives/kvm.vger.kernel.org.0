Return-Path: <kvm+bounces-17095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 666A38C0B18
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E10D2863F2
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE7B1494C0;
	Thu,  9 May 2024 05:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsREM3FC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85B148FF9;
	Thu,  9 May 2024 05:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715233375; cv=none; b=FdK+5qupopeDaJECZR+Ojr62Q5BvaUkwvAS1s3rh6OyeMLql5A8Ii0mn291kz+Z9bh/92WYsB+RNeO4sVXBK/fE3H8v0wiL2R0FDgZV/aloPr9XMZfckzI6io/Q0rpPBGGg9KQ74Vd3vi3FXuIDhNZRsuAGtUwpjV8FRfnVlP2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715233375; c=relaxed/simple;
	bh=K6sEhlFSI+vssE8QH3XGgfU71DAVwiWBzjwkLw8plMQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=P4RnPx0DNCmEvnH8QcJ3X36XCQF9mWxr9DUUQ+Ic0NPAB6iMi3dsNezWlK+lolJN/5p/CZZ9EFeE51qmE3H/eEPtYDlc6+r8mnC+ZJz41rWAiOsECHjj2qvt+0Q2Hnpa2iGrYNBpCdHXc256XMKxeLENB1LuiQ86LZRI1kIOqEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YsREM3FC; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7e1803a4290so23246239f.2;
        Wed, 08 May 2024 22:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715233374; x=1715838174; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPVPOugjACikRDkDRBDlmRlOvI7PSTQC76vgEtwmocw=;
        b=YsREM3FCJYksmdcZDZw3vA/EFmtrcCt/jJISQDU8c2bJ5R6GGZp9xgZzosiKzt2oob
         oloQGyC5T8kYMxZexJd41V1KOPzJFdo2FB3ktV+qfFBpQ6UEyLZpEKiT/8c9E5FfWcOs
         0jmWLIMhQymgJmQ1GCIfBfN09yb0QmliucUSwLvMCmmIk2HAfXRLczBaS7SPWWoSjCrq
         kvW2dYtznsnQhnzT71swtSs0k2ChoSV6WkOrgY45eRl6lMuCkog9HLaeXpMuY7uGmU/b
         ovx+oOuKW9vQ3axyj8ZzxFz+fh8CYgHCve/ElSMRQVihlWmcJpGlPE3TG+xr9IxIxsmW
         TwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715233374; x=1715838174;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YPVPOugjACikRDkDRBDlmRlOvI7PSTQC76vgEtwmocw=;
        b=EBQKMWeJ9T+wteZMmTG0g8k194V4SxO2GeqpnXnqXzP2vdTKsg+7m7rI/W9oPOM95k
         rbcuLn0GbsV/WSFk8VTWaFX63y0q8mgU47onI9j94id+j9OTMOVBmHH/+Y178btfxDzj
         sGSMc1dc8HPxmCLQZpG7W0PNkj01Pn12IgZiohgYccUlFt1JZj1jruFlwWbGFxLs1grL
         rfxCuap5lzlDkszdu1LqYH5e5ccUXAJVEsvXvzbjXSkr+BzDAUGaO2mU/6sBIbBa/tPE
         XU3H3Cre/HwHWey4kUMP0CQ/UFCn+wUPz3EoZGsMzk+BqxFQmsb1QtT4oUyvaTVn3YpG
         2hmg==
X-Forwarded-Encrypted: i=1; AJvYcCWu8cLTKfyAP8nbyQcBN7Idpn93rtF2vHzkP8QwZjkYLA7IufGiC2qfiBJYmuA2I7b2xjOptl2AIseEjRZUZygQ6tAs+SKum+2dEfYHTmj5wH/7fpx6zLAbPfIHVoIknqZC
X-Gm-Message-State: AOJu0Yzr+91SmFCnz904kG9pv588N4acJwigO2KQlTErK04E5GDxPvES
	HFyz2r94G1HaTSPR01Znl+LEKCT3/5KJHz3/D3ya8AWcuA6fhgDUobiwLA==
X-Google-Smtp-Source: AGHT+IGaX1LBzAaXSqkJ7mPuBzhTnF/6aDKQom/GvTfcRaMg49BEJwfb5g2n1M+BUs7ywSg4q7wtsQ==
X-Received: by 2002:a05:6e02:160e:b0:36c:51c0:555e with SMTP id e9e14a558f8ab-36caecd6ea3mr54883395ab.5.1715233373672;
        Wed, 08 May 2024 22:42:53 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6340c99be0esm495803a12.45.2024.05.08.22.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 22:42:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 May 2024 15:42:46 +1000
Message-Id: <D14VHEQLAB3V.30DDBZFDKZVGY@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Vaibhav Jain" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v6] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Michael Ellerman" <mpe@ellerman.id.au>, "Gautam Menghani"
 <gautam@linux.ibm.com>, <christophe.leroy@csgroup.eu>,
 <naveen.n.rao@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240506145605.73794-1-gautam@linux.ibm.com>
 <87o79gmqek.fsf@mail.lhotse>
In-Reply-To: <87o79gmqek.fsf@mail.lhotse>

On Wed May 8, 2024 at 10:36 PM AEST, Michael Ellerman wrote:
> Gautam Menghani <gautam@linux.ibm.com> writes:
> > PAPR hypervisor has introduced three new counters in the VPA area of
> > LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> > for context switches from host to guest and vice versa, and 1 counter
> > for getting the total time spent inside the KVM guest. Add a tracepoint
> > that enables reading the counters for use by ftrace/perf. Note that thi=
s
> > tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
> ...
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.=
c
> > index 8e86eb577eb8..ed69ad58bd02 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -4108,6 +4108,54 @@ static void vcpu_vpa_increment_dispatch(struct k=
vm_vcpu *vcpu)
> >  	}
> >  }
> > =20
> > +static inline int kvmhv_get_l2_counters_status(void)
> > +{
> > +	return get_lppaca()->l2_counters_enable;
> > +}
>
> This is breaking the powernv build:

[...]

All the nested KVM code should really go under CONFIG_PSERIES.
Possibly even moved out to its own file.

For now maybe you could just ifdef these few functions and
replace with noop variants for !PSERIES.

Thanks,
Nick

