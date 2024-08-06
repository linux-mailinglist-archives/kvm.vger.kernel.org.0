Return-Path: <kvm+bounces-23317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FA1948A5D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 275D91F25973
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DD816BE15;
	Tue,  6 Aug 2024 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoqiKYIh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B8F15D1;
	Tue,  6 Aug 2024 07:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722930353; cv=none; b=Bn2YqzUAqiPdenM/IHInzGJ6Pwrp8dRYziXBfV6nls/ZNz+FpAjFLpEaYQJQ0DTp0ggB9gHyhXDnW2fWoYO32qHqOSHedXu30EeDeNmOS0j+gKCCElzMyNEo2HZG2qOHo/TXyHvfw9jPM0VB4H5um2nLT7Mjp1nJB3It6CS10FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722930353; c=relaxed/simple;
	bh=yGiNiFGi7Vaq87quk92S2Swz/r+ypNNm0Lc2mBcEMyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iE2qppr8aorUEYEeysCJS+0JcoK88PwWCWMyjd+QRDsTLgb5ZqyJXlsV4TYXnAoRa6YfXyaRxEimeLU3pmGduri/qKRdSVGtmx2Ov9LDRyt3gcwJJESb6iB9D4leDaN/Jrc38DTpgrkldplAowE2yEm5tk2dXznkpHcX4NSemn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoqiKYIh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FF0C4AF10;
	Tue,  6 Aug 2024 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722930352;
	bh=yGiNiFGi7Vaq87quk92S2Swz/r+ypNNm0Lc2mBcEMyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZoqiKYIhd1x3S00BKm1jiixbglE+w3LLz2tvXP77Rkj8333Egus2iPcZQzW3Nxkff
	 Sggs9TGr3PRPiJ/Q00/E2SLqTKeOdmQHI5iXtr2jHGq6TyuadZn96v3Jr0sWg1HUxz
	 SkrOcDNd2H3PyPV15aKvPvsJxRzosJbynkkHioCGA7HNREIySmto014GL/YmMd5LY7
	 rWWzPjuEk2BSx0+zde5bOvlWfMCBHWPU+BZwxXsfkH4tQFk1wrNhRJNi6zTTis2RlB
	 l23xM6R5XpDMg18RaggLaASzCGQoChMTPTYo8Lh7GC1nU3iV8ddUvXra7LIMCtMG9P
	 T+jvR9xJVUlbA==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5ab2baf13d9so589905a12.2;
        Tue, 06 Aug 2024 00:45:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVAFhGDtwuenDqWnJsIpMCwTDHr1Krz4GlEMRAZwFBUYU1Vm4EFpThFIyvUYHpHrPdlZDqykPD3Hk3wJ45yvAs4VATGwIvmDPIyjYVBZR+REXQzbjIo5X/EQ766XCUAJbm9
X-Gm-Message-State: AOJu0YziEtju36bhOZEY83xcmhZZ1Tm1AEZtfY+seQ4xxr7If2hfOsAB
	RWdlbiWLktZcNR4ZZ1sPL2DIBCvbs0zBpjq+OW3qw6EbFsDT21PyDQ6HkD9Yk8FE9e7F0WqMTXw
	xI3fOVOA9cXGjxP7kemZmMgze/Qs=
X-Google-Smtp-Source: AGHT+IGFW4nB0Godlt8tjYNw+BdB5pIE9dNG90d0hv4ZSDmWnDVURzXoI/38bpiLY+5Dp1IAu21Iurff6ztAAI5Px9U=
X-Received: by 2002:aa7:c599:0:b0:5a2:a0d9:c1a2 with SMTP id
 4fb4d7f45d1cf-5b7f56fd9cdmr9973224a12.26.1722930351191; Tue, 06 Aug 2024
 00:45:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn> <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
 <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn> <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
 <9bad6e47-dac5-82d2-1828-57df3ec840f8@loongson.cn> <DB945E243D91EB2F+df447e7b-ddd6-459d-9951-d92fcfceb92c@uniontech.com>
In-Reply-To: <DB945E243D91EB2F+df447e7b-ddd6-459d-9951-d92fcfceb92c@uniontech.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 6 Aug 2024 15:45:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H61-x2s-22q5+WqrQ_RnmwWgY2E8cqSozLPrdxv1MX+1g@mail.gmail.com>
Message-ID: <CAAhV-H61-x2s-22q5+WqrQ_RnmwWgY2E8cqSozLPrdxv1MX+1g@mail.gmail.com>
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for kvm_hypercall
To: WangYuli <wangyuli@uniontech.com>
Cc: maobibo <maobibo@loongson.cn>, Dandan Zhang <zhangdandan@uniontech.com>, 
	zhaotianrui@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Wentao Guan <guanwentao@uniontech.com>, baimingcong@uniontech.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 11:03=E2=80=AFAM WangYuli <wangyuli@uniontech.com> =
wrote:
>
> Hi Bibo and Huacai,
>
>
> Ah... tell me you two aren't arguing, right?
>
>
> Both of you are working towards the same goal=E2=80=94making the upstream
>
> code for the Loongarch architecture as clean and elegant as possible.
>
> If it's just a disagreement about how to handle this small patch,
>
> there's no need to make things complicated.
>
>
> As a partner of yours and a community developer passionate about
>
> Loongson CPU, I'd much rather see you two working together
>
> harmoniously than complaining about each other's work. I have full
>
> confidence in Bibo's judgment on the direction of KVM for Loongarch,
>
> and I also believe that Huacai, as the Loongarch maintainer, has always
>
> been fulfilling his responsibilities.
>
>
> You are both excellent Linux developers. That's all.
Bibo has made lots of contributions on LoongArch/KVM, and he is more
professional than me. I hope we can collaborate well in the future.
For this patch itself, I've applied to loongarch-fixes, thanks.

Huacai

>
>
> To be specific about the controversy caused by this particular commit,
>
> I think the root cause is that the KVM documentation for Loongarch
>
> hasn't been upstreamed. In my opinion, the documentation seems
>
> ready to be upstreamed. If you're all busy with more important work,
>
> I can take the time to submit them and provide a Chinese translation.
>
>
> If this is feasible, it would be better to merge this commit after that.
>
>
> Best wishes,
>
>
> --
>
> WangYuli
>
>

