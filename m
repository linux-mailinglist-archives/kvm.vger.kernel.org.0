Return-Path: <kvm+bounces-67910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B1DD16B20
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E2D33025FA5
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 05:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5E22F6907;
	Tue, 13 Jan 2026 05:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HeUMqJhh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HaaVvh83"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF54E26A0A7
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 05:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768281997; cv=none; b=c68nPbYokUKmDLDQLhL8gR5wYAq4aFiqt9K0m3WsY/Xbgt3H67JmmG+QeyvqzuNtCRyvddhVZItCZunTDOgVMmmam3Ngtp4zXqvnD4S0PQvXiUo4MwY9f+jIwoTVyhs89q2LU/h2B0q58bEvYUaEQtbthSCFGHRqsNoZZo2p/us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768281997; c=relaxed/simple;
	bh=nA+L26/6LkOwG+JZOZ+63LW0QMeCFXmogTPiX5FbJ9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbxV47xz1m9jaIOKoaWvr3Bj8djZRivwbtvALueHura44icWtP1ZLfSP105LpMu+NMmjff4S6cduzD03dI1E53VmzGzHks2sfutbSEcoFZsXO/aQhxeoraNRuybnzMsLDFf5Oh3X9oFKf99N6AbNozrftYhnQO0Rg/zJV033PcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HeUMqJhh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HaaVvh83; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768281994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nuMd1+Qvf4CuzA6yTM0NQ+oas0hdgFEL7bO1wUuMPGQ=;
	b=HeUMqJhh2gxmahKVpkjrQI3R8e25YcHoJnvV2pbAof964ys9kFJ4bPArKMr0Hu8JczQPdM
	wcnMWYAB/gBADjfXj6G9kaSTPXBMqySzj5o+/LKGZzGLITZHE10iJMhocAujiWYc//NkL3
	jKWzwldCNDgu4U9RgYiQOfiGwx5QDy4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-FQ0DMxRbN9OFLmAQCsRvLg-1; Tue, 13 Jan 2026 00:26:32 -0500
X-MC-Unique: FQ0DMxRbN9OFLmAQCsRvLg-1
X-Mimecast-MFC-AGG-ID: FQ0DMxRbN9OFLmAQCsRvLg_1768281992
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4f4a92bf359so205453381cf.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 21:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768281991; x=1768886791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuMd1+Qvf4CuzA6yTM0NQ+oas0hdgFEL7bO1wUuMPGQ=;
        b=HaaVvh83+bRIIM+JLnR15YK6G6nl8+zPfOV/VtyMAfR+jIc61AGBU9bQkenQ77zTxP
         CjOHC1PdwRjGr3vEAmciBBOXyd3G1UgVIHC4ne8hMRYBWQsz4QMJxP71/+2dJfxGAlG9
         mKQB67KpqrBcs9IEhXEgVS8qB9kDL6gvG7Plgsyoq6vSnfN4vSrtbMCUhq17i37k0pl6
         bsLcq9nkyxzyqm1w4OQn9vyQdzkwsR6bXOcBttgebOsSJPZG/aLtD33YVYgusaHBp9ZB
         y/PJ2z2WOnc6IccdIckF+VMMNOvOYAVuX08H5v03qNJGwYxr6ydHnXD6C1tSi/mU/32z
         yl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768281991; x=1768886791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nuMd1+Qvf4CuzA6yTM0NQ+oas0hdgFEL7bO1wUuMPGQ=;
        b=fBoF4eg8fbAevtkaDhl50SdRJc1WlL5s+kY97bRJ01QlpRFrGODznjzC0Wercxgsvi
         v3hZnhSsqLF+k+Sbi2U7JoDWakCYurQ15mu6brk2nUadrTkwsHYuApu2W4MV71h++cse
         fJWfJJ1EEwS6ClP2/22+B/FcLh0O78grwlLBd4jCkgdVfaE+L1LSObFm976iBSXERAH6
         3led1/UsXKVHangGP9TFIpbhjqYVdaqEkcySuXp8rXDeVqn3EvHhN3uSTfamZtwIJwYS
         fPvIepRKbXulIc5q0yJeCeCWQZRg4fcmJNqSb8C7v5wSYOH8sf2GncF5yiX9AZwmZWlm
         sA4w==
X-Forwarded-Encrypted: i=1; AJvYcCWOjr7j60T+bC28SoKTj+DPLim8ZYVTVTijbN2AVR8On1EJho4mff/1KIGBi89yavQNlfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp2qdpS6k6ddkS3MeCEUCfm2kn3aJZPUChViGLF77cqWbMFS3C
	ihzLkGdFTyTXlWxKNvJOKg+/HthgzBdWnTWriggLpM9rJxfZVLXNCikIe5R7FVF+KovPm8i0zY7
	jXE4K8Mtx8Sb1dYh0qq5SegeUDjhJ8+YljPgR9HkdGexYtnYZLsHthiWgSd7BUYmhwDH+OdkFck
	lnu9ut0J89g2vcUipLVaapJbNDu9Bd2JHiEcqR
X-Gm-Gg: AY/fxX512rXEwtsdu3yro75Z/NQ8w78MANCMohmzooDRFTFv7ytDx30BOsClzqPzPTo
	CR2yAnbTgXx2yQSgeEE3vw4QMffqkfLbOYRjVRObFFInFyfCyg1pxZ5GmC4K3S0ebCfiwvBklmk
	lE2S0HufMLWnN3aISHdH2PWsyjbo4kA0DSAQt5cslZRtftFRN2PAQL/M7usZmGdQ22EmqJ2GVX2
	MMEGgr7p4oYDtbcVEi97QieIzg=
X-Received: by 2002:a05:622a:47:b0:4ed:a6b0:5c39 with SMTP id d75a77b69052e-4ffb4a2f43cmr308309301cf.63.1768281991561;
        Mon, 12 Jan 2026 21:26:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNuVSZSl8dUOM2nyM7pReP2sPPAkQhyBICCc9jz0MxZebzPnjCR/0308U8sEb0Cmz8WfprTpfMUOfg46P5lkI=
X-Received: by 2002:a05:622a:47:b0:4ed:a6b0:5c39 with SMTP id
 d75a77b69052e-4ffb4a2f43cmr308309181cf.63.1768281991253; Mon, 12 Jan 2026
 21:26:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-26-anisinha@redhat.com>
 <CABgObfbA_SODCgRFkX61nt+tdGK7txurUXo3yLbSuMfnjyyG8w@mail.gmail.com>
In-Reply-To: <CABgObfbA_SODCgRFkX61nt+tdGK7txurUXo3yLbSuMfnjyyG8w@mail.gmail.com>
From: Ani Sinha <anisinha@redhat.com>
Date: Tue, 13 Jan 2026 10:56:20 +0530
X-Gm-Features: AZwV_Qg2j1yT1Oaxd3FB2IH_8KYLvJ50-TUlBJKvN-QzZtwwgCxpfZURqTVmOIg
Message-ID: <CAK3XEhM2Mc7orgjb827v836e5Yh8w_TFJB_nQd_+zsOUa2dB2g@mail.gmail.com>
Subject: Re: [PATCH v2 25/32] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 10:50=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> w=
rote:
> >
> > On confidential guests KVM virtual machine file descriptor changes as a
> > part of the guest reset process. Xen capabilities needs to be re-initia=
lized in
> > KVM against the new file descriptor.
> >
> > This patch is untested on confidential guests and exists only for compl=
eteness.
>
> This sentence should be changed since now your code can be tests on
> non-confidential guests (or removed altogether).  Same for patch
> 23/32.

I can drop all the xen changes altogether for now, if no one objects.


