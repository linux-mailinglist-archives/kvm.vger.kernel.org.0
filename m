Return-Path: <kvm+bounces-21650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A0393182B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 18:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F33B2282DEB
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 16:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096541CA9E;
	Mon, 15 Jul 2024 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwpMhYzZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52FE1CAB8
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721059749; cv=none; b=biRtMaJCk5TPOV+iU6Nl/wwMGJXn2KhO88hbEUlP0kRs+sZ6xKd7lDVkJC+wISX5ucNhE6jaZeRsFUwbZob8nev77vWY8onSqr/mR9S74R010mp18qYM4y+vhhHg12x2J3DXTyQinuNH/rMyoeZ/Rk/VPy+7xPVzBxnNHohqI8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721059749; c=relaxed/simple;
	bh=pns6oBjdeKTxUi/oyky+qxEK+jXJ62xk1tKqw+8NpnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNjxRWb5NVQeA3zc2zVs6PtmHtLO9oYSHBqGlwsixaesmRxTMxN6Qhm5yRyvIoBvEFgYjN74c5qBpDpno93Bh09MPF7KGVwVOoowFMiDDFywbo0y5maMkh/gPVQ2UMjLzpPrAJHoR+NeofkjOUetBESfoAImNStim4nOxb08e8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwpMhYzZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721059746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Abk3xY8p1XoS3Otzd65O+1Rdw5yUxySHu+Mh0abIVgI=;
	b=WwpMhYzZUh0IIxU0/L1gyTNBxDb77SDV7HHVRf7CZxtL8aifIZULLgKYA/hnETV3HS+F4T
	UhgZJwX9PublxmBoI9UrWj89xwoNPlkkgJeaarMgyNRDZHhSseAcSUPSh7DDgpE/uDDd0K
	5LvnkYhjJEFqGQeAvbtDvQc+LXL3QME=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-B9i-hjPXMqCaz1KBPVFicA-1; Mon, 15 Jul 2024 12:09:05 -0400
X-MC-Unique: B9i-hjPXMqCaz1KBPVFicA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-367f1dc92e3so2771898f8f.0
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 09:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721059744; x=1721664544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Abk3xY8p1XoS3Otzd65O+1Rdw5yUxySHu+Mh0abIVgI=;
        b=oEPmZrw5PnX6loQhLy6FJxGoKeMXo/SBqqcQCvMtWZMTjltYvSPp6pRShiic15ih0W
         g30LSXZ5C0tx0ByAm2fck9vlWCJx4h+HKsrdkqBgCmhY50671gvapM84x6j90ppykTek
         iETtlNqog8tcKLb8EgOaFKi2r/7TLvsu695KtXmy/WvJPEmty4Dlp/SRnvrCpvjtRpW9
         4DcwE2fBQ0TQintEciHKYYKlhoAzg9TyNna+VI6Y2nATQqPlksDUj2tBHBAnd5LIIZpJ
         HhR6UjjrXQvtK/p3GMHcDOHqJrVlUaQ3rJ2nQby5HcOXN5iNHmnalstbM8nhxkeyAvLj
         IysA==
X-Forwarded-Encrypted: i=1; AJvYcCWqeaRDwjRuDjdK8OY1s8AUJRDpBftIt0e3oX1e9oz+pDaKzwURxfnD2xw99D3ChURwJKKyxcj/MWHYqQyvl9GD3Qv4
X-Gm-Message-State: AOJu0Yycd/8XnjL1x/13OD9aHzLpi33vne8FgPwNZs6JIqRx9d9knU6u
	863aekEQmKDy84aL9NVH6q1H+8sZPUczDVwaDheow85K47Q80OT0iYoD9sqRcYmD5Ip3wEdQ5yl
	ii/uYZ9DfWbL2l9wrq4UpartE2ro51g5/SyniQht+MI10h7KhQFMMG5uOOU1HdXdpmp6aiQI7Jc
	3Aw6k2/MjW+9vhxiC31Yd4L86O
X-Received: by 2002:adf:fd05:0:b0:35f:122e:bd8c with SMTP id ffacd0b85a97d-36824088d3dmr156182f8f.17.1721059743874;
        Mon, 15 Jul 2024 09:09:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEog5YOTIjhOUFctCGyLRn+0RvpSTee0pbP4aam/coKAqEKJDiarFwJ23vF333z/XezLnfn1KfwXp0w7OUlVPw=
X-Received: by 2002:adf:fd05:0:b0:35f:122e:bd8c with SMTP id
 ffacd0b85a97d-36824088d3dmr156168f8f.17.1721059743518; Mon, 15 Jul 2024
 09:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240711222755.57476-1-pbonzini@redhat.com> <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com> <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
In-Reply-To: <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 15 Jul 2024 18:08:51 +0200
Message-ID: <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
To: Michael Roth <michael.roth@amd.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 14, 2024 at 7:33=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
> > I guess this series is trying to help userspace not mess up the order o=
f things
> > for SEV, where as TDX's design was to let userspace hold the pieces fro=
m the
> > beginning. As in, needing to match up the KVM_PRE_FAULT_MEMORY and
> > KVM_TDX_INIT_MEM_REGION calls, mysteriously return errors in later IOCT=
Ls if
> > something was missed, etc.
>
> If SNP were to try to call KVM_PRE_FAULT_MEMORY before SNP_LAUNCH_UPDATE
> (rough equivalent to KVM_TDX_INIT_MEM_REGION), I think the same issue
> would arise, and in that case the uptodate flag you prototyped would
> wouldn't be enough to address it because SNP_LAUNCH_UPDATE would end up
> failing because the gmem_prepare hook previously triggered by
> KVM_PRE_FAULT_MEMORY would have put the corresponding RMP entries into
> an unexpected state (guest-owned/private).

Indeed, and I'd love for that to be the case for both TDX and SNP.

> So for SNP, KVM_PRE_FAULT_MEMORY/SNP_LAUNCH_UPDATE are mutually
> exclusive on what GPA ranges they can prep before finalizing launch state=
.

Not a problem; is KVM_PRE_FAULT_MEMORY before finalization the same as
zeroing memory?

> I realize that is awkward for TDX, where the KVM_PRE_FAULT_MEMORY is
> required to create the sEPT mapping before encrypting, but maybe it
> would be possible for TDX to just do that implicitly within
> KVM_TDX_INIT_MEM_REGION?

Yes, and it's what the TDX API used to be like a while ago.
Locking-wise, Rick confirmed offlist that there's no problem in
calling kvm_arch_vcpu_pre_fault_memory() from tdx_gmem_post_populate()
(my fault that it went offlist - email from the phone is hard...).

To be clear, I have no problem at all reusing the prefaulting code,
that's better than TDX having to do its own thing.  But forcing
userspace to do two passes is not great (it's already not great that
it has to be TDX_INIT_MEM_REGION has to be a VCPU operation, but
that's unfortunately unavoidable ).

Paolo


