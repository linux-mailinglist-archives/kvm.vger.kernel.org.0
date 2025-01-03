Return-Path: <kvm+bounces-34551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 412CDA01011
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 23:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1708F3A4027
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 22:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0FE1BEF93;
	Fri,  3 Jan 2025 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IiUV1yrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FC317FE
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 22:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735941884; cv=none; b=WE40iNTZ6Y2E3J9KZcnrUGp3zkDNIxdBoKsemQEbun0zQRaT7Gt160DIaOliZMfJ+ffwKY+/hezVyO28fS8tKQzykucZdQoxk5DDbPxu8jiiByG2FLyq+Qu2kdMXRAVNI7SExTswAqEiqidwHJr1wER8HC1JOhF9cGN5wtZcdxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735941884; c=relaxed/simple;
	bh=6YJodd1OKXKdx/0JInIVF8GlkZfZQsuiWnBBsTyk0WY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9LP5EvH+fdsC/7hZABrE+E6ZpG/hGCn0SyIOwmZtK59VXJ7IBFlmvLmJR8JwGMTrYlkuSQjQZytsVi4Qa/Vr++uGuJCElcBmrKT27JZIWBsW72Fm/AJjcYzGXzWCaniD1NDJZUONpSkWY2w+XRUAR15OqU0puI6pJBNtUJcBsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IiUV1yrX; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53e3a2264e1so1362e87.0
        for <kvm@vger.kernel.org>; Fri, 03 Jan 2025 14:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1735941881; x=1736546681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0wsCyUo6mPW+Opy3vJJiHGGeBqbpzffjhrgktoWXp0=;
        b=IiUV1yrXYpW7JpDm0TiRDn7GwLnC1BPj28Qe83sZlpQMnz6npXtvKBIDz1G4GwXlHJ
         pkfy+Wgfq7FiWqnfu81cviogM7Jo03j9K5wFcfPZrwXjXgb+oNM7m640O9zqmU+J/vfv
         Se/CYcaGjnxI8Jv5Ckhjgf+03EXNFwUXAuIb6zpI+hwgniT6RRi5Nn0kB1PV/U300Z/x
         9qAt4/FqdyRvCFNVsNu/zEyKmiYZGvQTcQJ1TotpZEcEyw51KAubzqeMWed6swupB0Cj
         A5wjOwtnJvYFZSFczsv3JFJGGTN89TejD4py6UJxh76wcQZU3Uk8Ag7C1uABovW8+p49
         smHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735941881; x=1736546681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0wsCyUo6mPW+Opy3vJJiHGGeBqbpzffjhrgktoWXp0=;
        b=WPpwoUHSeAsyUjoXnd12ck074kySpBsQeEP8ThAtDenB2hYsSbq9hI2i1ZM+BjBlzx
         0DuHcpjiPh6dgZPCxQnr7PmtwxvFATd/FnV+EgJ6wiyOwdXUJIE+cch/JsQ/F1UA5sPj
         XoDfX7K4EwaMecB7YAskoWXrszb+R2ihKJxG4wtim465k6wMZY5NjxQdcH6aa667NSMV
         BUQfMHjzYa46IoB4b8ewcpJq7slX/T2X5B09lF4EMfSCInysl2HG2masxOuKXF21omMS
         XkMZJL+UVYJRnpV5ZujCmc0XJCrECyILLlDkHHkm/KmCJ/o/NzGfYkTIlJ9rxodMwDiB
         Q7rA==
X-Forwarded-Encrypted: i=1; AJvYcCWeCrIgjGa9You2k/8ABtIGklAIpBLCTlgWMs+UPPGK1vjsci33HQzj8xzpF+KiE/jmetg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+2uQgfEG3zgNA3VXpyQmMkBOL7wYaI2RvdmmJGizmnFPE+Q3z
	ruIfVeLSaAn1DHeUdZ4NV6q1HWZNQaDUeIp+Dittc8izic03/+iZUjPtNUT9kf+ddSjb++z9DuD
	lIRlWdfrbt/oU4jKNrYkWJbuzVf1aRvz3K1pe
X-Gm-Gg: ASbGnct5ir9Q/znFvA6Nj7ltRcWdTZHjIKYGndn68TxDoUwccpPLssw/AO3xYQU5Mez
	yqSUqKGqevToIkiy5VzCVi+W/0315Cmm9zjvPehu6Pl2T4Ma956rBk2f7JrFd50kL
X-Google-Smtp-Source: AGHT+IFr9EmSp3XosWtBBQgN3FDDwZvvfaUihn7i+4L59z+lQIXak+pactSWimUfqnEniD7tRBtdPNq6AHZY575aqV4=
X-Received: by 2002:a05:6512:ad6:b0:53d:d6eb:b0ee with SMTP id
 2adb3069b0e04-54270be2302mr2145e87.7.1735941880882; Fri, 03 Jan 2025 14:04:40
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com> <20241209010734.3543481-14-binbin.wu@linux.intel.com>
In-Reply-To: <20241209010734.3543481-14-binbin.wu@linux.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 3 Jan 2025 14:04:29 -0800
X-Gm-Features: AbW1kvZADky68fGqPS7CbOHXxb1HKj1U_D1OgedvYSJ2yfL926MG8mRhzI93U60
Message-ID: <CAGtprH98GkZuFgJ6ZFTFUv2Bqzow9yw7WCd7TAyKPUe=2iqfbg@mail.gmail.com>
Subject: Re: [PATCH 13/16] KVM: TDX: Add methods to ignore virtual apic
 related operation
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 8, 2024 at 5:12=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> ...
> +}
> +
>  static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>  {
>         struct pi_desc *pi =3D vcpu_to_pi_desc(vcpu);
> @@ -236,6 +245,22 @@ static void vt_apicv_pre_state_restore(struct kvm_vc=
pu *vcpu)
>         memset(pi->pir, 0, sizeof(pi->pir));

Should this be a nop for TDX VMs? pre_state_restore could cause
pending PIRs to get cleared as KVM doesn't have ability to sync them
to vIRR in absence of access to the VAPIC page.

>  }
>
> +static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> +{
> +       if (is_td_vcpu(vcpu))
> +               return;
> +
> +       return vmx_hwapic_irr_update(vcpu, max_irr);
> +}
> +

