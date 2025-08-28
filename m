Return-Path: <kvm+bounces-56144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D560B3A6C1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 18:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDA443AB43C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 16:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015D332C316;
	Thu, 28 Aug 2025 16:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsoqgrGZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AFA322DBF
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399478; cv=none; b=ZwQWvF8gqByYqRvTsg6eHuM7ipqO1gqXHTQah0GlvddeYA2E0QNVJKp0astZ25CXvx1rqeaUujzycpZDoKuxqbEwnvGeB3fs11ojweXqFrduKuC4I1FY6TX3qXuFFeci/KFQZER24U6kYPro/SD/mc0SmfNsMFdPPIyntOhWjak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399478; c=relaxed/simple;
	bh=16g9F5woniiXrhsLLuxG1053++5xXv7LjCWoyLqXmvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTT7DJ78Tz5kYlTIy4vpktG4Qb2oZxJMHi0FvG4I7xQrzUqZJgb/ZvpNn1eHhnclPq8OU2EMN/VWxeJbmq7FKlhrdnS0Y1wXDmjCWOkSWzue3f6LEIWuqDjeqOpUPqLZCwqvtwBg8N1NVgcrX9afuEXTX+8tRzJ1p5y4sTJKIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OsoqgrGZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756399475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16g9F5woniiXrhsLLuxG1053++5xXv7LjCWoyLqXmvA=;
	b=OsoqgrGZwaNCtFRa338uIQspNjNXuEGVsFP9ks/yxrQHh/5MjCuRreSGSeeNNiVAZ1vQnI
	rDVRRbMvks6VHehP1DtVHSEi+XHqmLnRqaIK8xVVwfDDisu4My8t1dCkOXXc/ms6QmvytL
	G/82M7brFNASpVxff/t/9FiT67RBMKg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-EFG2u_AgME-9DtT0qnVxsg-1; Thu, 28 Aug 2025 12:44:32 -0400
X-MC-Unique: EFG2u_AgME-9DtT0qnVxsg-1
X-Mimecast-MFC-AGG-ID: EFG2u_AgME-9DtT0qnVxsg_1756399471
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so7118615e9.2
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 09:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756399470; x=1757004270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16g9F5woniiXrhsLLuxG1053++5xXv7LjCWoyLqXmvA=;
        b=UB1TlSs0TqFXmTGWj8xJjYNoEB/aslAUWv9fPVYyCrFASrHifE0bHwQY+q+hx5mVAA
         4nK13Hj5AA2EtLlSTiF6QsLX+O2Crm4nOihKjw9kP8cdnhHNLgKo7AGZHewMSKnQvVCC
         x5YU99/3Oa36Lx/ipB6H1TnhgxJa7tZQDrTPYgGvet18EltbAxN0FPNPkLPQWNROb/pU
         6LgLIuGqs2kPS4xhO4E92HZyYDcVFf8SCs7ByE2A3Im1l6AFCXkKaE+rqlTIl3amDf4I
         9GQXPown/S7brOag5p6iNs/gPV2ugUQm2h4V9Cq+mfhQ/RCkqg7XpyanzONR8CHPr3MD
         UAfg==
X-Forwarded-Encrypted: i=1; AJvYcCUr/Rv8R1FIpKMGwCG4BWKDrwN3i8jwHMhi+PH0k84rt+m5GSa6rJM8ujCV9cb/QV2wg64=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjSysrQ5W65uHHOaGCBBLi7tEiFL50r6tNpUK//S+wpnis5Xdg
	ooEo39rMht95wM4yN0oOpgngOHcNcmWR2Zqpo561zl58/hDF8Hcukgn97fQGpZjog4d9X3HsGlP
	QoywuxW9SeS7RsPDIVSrJ/ZmNjXCwReTmfV6s0qoXwa3ciXVTJm5No9uLNTJZxjLMkSHm2bxc5U
	Sl/wqXFO9xvnVT6Ni2mbMNlG9SyHXf
X-Gm-Gg: ASbGncuyJ/MR8O91sTewdbHAjQXQzyC1ddR+vVnkCEshZGpcYSq1gAvRRFYkbwg4yh8
	ndNBLcBkhYsA7paWhAbWoSYeII52kCuoVcNNl3XVC1+sHcgeZimV7K403ODW/kBeJ5L5fIGiQT4
	Vp9Q/FB/L3Xcdz/xI8dclTGPrT0LJYEgdWF/ANkq463DlKLJAc7pGlYhqZ78vXQHPfABPCS5uDr
	lLxCAHEKllSek2vduvY4LVQ
X-Received: by 2002:a05:600c:4715:b0:456:302:6dc3 with SMTP id 5b1f17b1804b1-45b517d4c47mr197984325e9.26.1756399470544;
        Thu, 28 Aug 2025 09:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOQ697WbVXyU99n0waspLzqYpTQQBImj5MyrGfz7lwIURmhpghnGB5Sbe7cWt+MuicJOIRjj3b26keLzpmBNo=
X-Received: by 2002:a05:600c:4715:b0:456:302:6dc3 with SMTP id
 5b1f17b1804b1-45b517d4c47mr197983995e9.26.1756399470139; Thu, 28 Aug 2025
 09:44:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827152754.12481-1-lifei.shirley@bytedance.com>
 <aK8r11trXDjBnRON@google.com> <CABgObfYqVTK3uB00pAyZAdX=Vx1Xx_M0MOwUzm+D1C04mrVfig@mail.gmail.com>
 <f904b674-98ba-4e13-a64c-fd30b6ac4a2e@bytedance.com>
In-Reply-To: <f904b674-98ba-4e13-a64c-fd30b6ac4a2e@bytedance.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Aug 2025 18:44:18 +0200
X-Gm-Features: Ac12FXxy8RFR1sySn2cIpHgzn1YV9jdcFkuTVaa1o9x9iu2acXvfPgiJQStuG6A
Message-ID: <CABgObfb4ocYcaZixoPD_VZL5Z_SieTGJW3GBCFB-_LuOH5Ut2g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] KVM: x86: Latch INITs only in specific CPU
 states in KVM_SET_VCPU_EVENTS
To: Fei Li <lifei.shirley@bytedance.com>
Cc: Sean Christopherson <seanjc@google.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, liran.alon@oracle.com, hpa@zytor.com, 
	wanpeng.li@hotmail.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 5:13=E2=80=AFPM Fei Li <lifei.shirley@bytedance.com=
> wrote:
> Actually this is a bug triggered by one monitor tool in our production
> environment. This monitor executes 'info registers -a' hmp at a fixed
> frequency, even during VM startup process, which makes some AP stay in
> KVM_MP_STATE_UNINITIALIZED forever. But this race only occurs with
> extremely low probability, about 1~2 VM hangs per week.
>
> Considering other emulators, like cloud-hypervisor and firecracker maybe
> also have similar potential race issues, I think KVM had better do some
> handling. But anyway, I will check Qemu code to avoid such race. Thanks
> for both of your comments. =F0=9F=99=82

If you can check whether other emulators invoke KVM_SET_VCPU_EVENTS in
similar cases, that of course would help understanding the situation
better.

In QEMU, it is possible to delay KVM_GET_VCPU_EVENTS until after all
vCPUs have halted.

Paolo


