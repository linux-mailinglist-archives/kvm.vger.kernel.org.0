Return-Path: <kvm+bounces-54653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 478D0B25FDA
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 10:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 862343B0D43
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6932F659C;
	Thu, 14 Aug 2025 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3jwF+uI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730892F39C0;
	Thu, 14 Aug 2025 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755161702; cv=none; b=iSEfEdVH7OSXaS+ANq7UM/t0m6Q6VLe/5o91My67Fx9wiD8ikkyLW8KDHv8LIdKyV2JoK3DRTUWcbtAmkRMqhP6e4l+mHrXpOVy5vhxlgrQ3fKSAAT4AxknXqww1m+Bvq38zo+xuVWjBUG2kNgZIzQBUIuOTLkBwUj/H42Oax48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755161702; c=relaxed/simple;
	bh=gtU4hfYzSADCA3++kU8k/ZyXSI3yHRR2nz19obU9kY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHjSwZsrF77dxK6FJcc/VGXd5vy5K9IWBoDVeCFdJqIpg2RVRR9P855+sQSVXwiJK7Fuja9bG00GZ+cgZaiirH9cqzjHrED+hhAyu98hWr+UCMO/k2CalYEL/6yuKeNraXI48j2pIdFBA4fGpeMTHWv/JLC6fV/w7vmpnlGb+qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3jwF+uI; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-61bd4d9fe61so374551eaf.2;
        Thu, 14 Aug 2025 01:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755161699; x=1755766499; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gtU4hfYzSADCA3++kU8k/ZyXSI3yHRR2nz19obU9kY8=;
        b=e3jwF+uICpVxLo0COmog2h4dfrey1A/vxKOo3wpWSEMSaR82Y360zOdfViBllSvU2X
         CnyXCZezk71EzECKiA0bALgUHM6csydNApSJgewZV7ETnivxLJWl236VN81fNPTbn4jy
         Gw8ZtU6zPJQb8jdukpyFNxd21fZUO54AtWom/ghGl17Y5HPjnu5R/f2cCOKUxf0YE2o3
         aWInUDwCJrGsnJh29EqVK7Q7Xe0atmNv26aBgcYABc4/wsmKwWshZvZYJZcipIRsvR5G
         VFAFLgUbwZMaLh2GbX8r5LAkrF4zpGbj3ggcVlOkZ5q3qgnz+3Oj73N/EqrvCebLCD1v
         /oLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755161699; x=1755766499;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gtU4hfYzSADCA3++kU8k/ZyXSI3yHRR2nz19obU9kY8=;
        b=LaEZi5ORrdeO+L80b5JteevXZiPZ8WmVcVSgqzmnNj8RzhJu+lEreHpHvllepkehxQ
         B006VjiwUybkk8699A1u19URFCUOEKZ4p+ofk0bMR3ZF8v1YCdTjCwh5FY9GRngWuvh3
         e3lK3SwXQlTTowzUQblU9xc8u5tKNEQwnprLVlDrTgrF/8meKzIOMhbWPuBXPqFfLNC/
         jXKz0eA5U30tHFJQZJtnI6OGn8Pj2RvbAHyR8T3DoPNKHyrkTaAGY6cV80JidYTq2wKa
         VhuycVBSA1cR0jNul7Q7eOLAi48Ur25xkzWFTF935sfHBB5xHm+aCLtWcYPUL8NV73/h
         Losw==
X-Forwarded-Encrypted: i=1; AJvYcCUyO7yXL/MXj8iVLz1J36E7Q1yY5qZT3jSa2MsL65yL2shMKQweRqdBfRP5fhP4G+ShMBA=@vger.kernel.org, AJvYcCVZHlIWfiU3PGiX+y20HY3d1M3ttugEYVaK8Y9zl5hPfLeH/9GFl3R0GUWYylGhIV0ESyqKmbpLsLbEx7nC@vger.kernel.org
X-Gm-Message-State: AOJu0YyqOVC13E/Ah0BS6HG9Z7ciNdIv3bvYuzEYEgDfaZIWPoU86qST
	AdxHw0mrs6j+1IP+PNQUc8fM/MEVlq+27LGChZ3LI/VanmGYZl/MEDMYUJjpc4hriFfeabOMJCo
	QxztNU0kwC9o5luNyG0e/kpd4rl4CKBV4o07ag1pmfQ==
X-Gm-Gg: ASbGnct/CnKTvKwnxmkmFR0TL4AEAiBpujZqMuvGcrXHJDufgxp64pWEE5AVd1mEstr
	jf+OTUFKH1hf5occJF/uYh/EGdkXre038aD1HLdJQ8zTdu9ZN8uUtpmnY92DEPA8+43fvLukRiQ
	ciurtXWAV42Aw7ZPTttZFrpugwZRfEhb2XLcTL+0ifcg/qpRuEE0owE/ZxoBVUfydqMwOHfTq3c
	yCLfrbJrkZsLcwWzA==
X-Google-Smtp-Source: AGHT+IGyNzkNgqhbzJ27tAKmmi1KI2U9GeGA2LaHL+JwsXgk/1tS/3gqYWVRoP/f+O/A03N0XWMZcfkO8v000BUg1Fk=
X-Received: by 2002:a05:6820:2295:b0:61b:93f1:662f with SMTP id
 006d021491bc7-61bd5ba4269mr1301185eaf.3.1755161699377; Thu, 14 Aug 2025
 01:54:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com> <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
 <aJobIRQ7Z4Ou1hz0@google.com> <CAAdeq_KK_eChRpPUOrw3XaKXJj+abg63rYfNc4A+dTdKKN1M6A@mail.gmail.com>
 <d3e44057beb8db40d90e838265df7f4a2752361a.camel@infradead.org>
 <CAAdeq_LmqKymD8J9tgEG5AXCXsJTQ1Z1XQan5nD-1qqUXv976w@mail.gmail.com>
 <e35732dfe5531e4a933cbca37f0d0b7bbaedf515.camel@infradead.org>
 <CAAdeq_LbUkhN-tnO2zbKP9vJNznFRj+28Xxoy3Wb-utmfaW_eQ@mail.gmail.com> <f009b0c5dea8e50a7fa03056b177bcedcfd21132.camel@infradead.org>
In-Reply-To: <f009b0c5dea8e50a7fa03056b177bcedcfd21132.camel@infradead.org>
From: hugo lee <cs.hugolee@gmail.com>
Date: Thu, 14 Aug 2025 16:54:48 +0800
X-Gm-Features: Ac12FXyTwb6Y8hZWBTcTDClMAPIoIb86P0PovYxlG7bfsJ_rcqsHHhAZbSN_pBs
Message-ID: <CAAdeq_JQO2x=x07BwmDcTCU-WfKLW6kFk38881vbyUTehP+7gw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 13, 2025 David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Wed, 2025-08-13 at 17:30 +0800, hugo lee wrote:
> >
> > Sorry for the misleading, what I was going to say is
> > do only cpu_synchroniza_state() in this new userspace exit reason
> > and do nothing on the PIT.
> > So QEMU will ignore the PIT as the guests do.
> >
> > The resample is great and needed, but the synchronization
> > makes more sense to me on this question.
>
> So if the guest doesn't actually quiesce the PIT, QEMU will *still*
> keep waking up to waggle the PIT output pin, it's just that QEMU won't
> bother telling the kernel about it?

Yes, just as guests wish.
This could eliminate the most performance loss.

But I guess resample is more acceptable.

