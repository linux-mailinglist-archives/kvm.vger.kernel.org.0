Return-Path: <kvm+bounces-27901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D243F98FF62
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79CC11F231FE
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 09:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018FD146D6F;
	Fri,  4 Oct 2024 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtfI6LvU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2813D899
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728033021; cv=none; b=nIti2oGpcbP04gAoD+tTsxxFDXgouWdZcv5boIzUz3jm/ATsKvDITzyrIDD+t5ubTT5cwucKkWnwgTsj7f2HVUq6PG2Rz6CM0vUIVYJnwLBMmWyui/Fx8mTsJzbLWgb4WGkQ38i2nSdBxJfb3O+0WdhNliH1dt6+taKUy9vqwK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728033021; c=relaxed/simple;
	bh=QTYuQh0P26vRKNsQewIzdoWVB1PnsOxVnuBkST55Nmk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SjJ5g5snaACVVcte/9ZATJdXpIIiRzZjkxEdweQGNCvREMgaNoR3gLSNhJf57knFKhMgT2LXUJDHrOLnme+gxpn2+UldOu7kEPL7Wf+6JD8ozewqO3fpM4xNRf50KUcAu+kNKcbEa2f1kR8kAdzsdsN1IDyNyxo7LcPr7VAESfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtfI6LvU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728033018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XWaxtFyxCVqdKiE9UC3u3v1VjOYPBu3LjrsGcjWBoPY=;
	b=WtfI6LvUluHMSoUrs42wJvkyJO2T7Z7xynQshFnksxqDi7L97GOu8BhOpspDuLNKtULw6m
	bxzEXeQ0RhCeASgoLdg/9PwIWM2O3z7DFbSexD2iBXC7z/HpPOdned5siwcvsaZEFK0YnT
	0lv+dyzo4q3PmP1RDGacamp5Phajq2k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-C5dYa8UZP32Vg5dvSouaQw-1; Fri, 04 Oct 2024 05:10:17 -0400
X-MC-Unique: C5dYa8UZP32Vg5dvSouaQw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb22d396cso14270905e9.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 02:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728033016; x=1728637816;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWaxtFyxCVqdKiE9UC3u3v1VjOYPBu3LjrsGcjWBoPY=;
        b=VeqbFW9GOxgw082jtFENlLVwH5gvqsYk3Uc5ZBWsz1bLJ/wm5kVyQz9b0r2a+ybwpD
         Pd45Ko7LRuqq2qLSHC5tqrjT0Peq7ib0//hkhZGg8I2uS8Ovjg3CduFF+kgYe7YPbjiK
         7ZxoGcPzjwi7BXxsCf13pMjhqv8swZE8LhBaRN378FOVASR+DjYJJKUlq5glxHsOSNHW
         HKNdVCbhDWGMPwWA4eav41hdW50HS+6LIwqqjmtz6ksBJbG8GHRHblHKoVhcdeEF9GeS
         VSuY+688sH9gKF4mBimOq98HH0Z4ihL2ikwXRYjBLP0iyWhnLrzy1eczKnUUtlfuMtH3
         c9mg==
X-Gm-Message-State: AOJu0YwlH786DSusDioEuPYzRs5xSSRINKnotvB3EnCwqgg0b4JAG8+b
	X+w05rPt7OX0qQUsSwGhT3g8P+W+ZmG+Kw07s4vLDgjox1Wl6Uq518d8XXD4MXOHEwdww1z+VMH
	Laqw5nVWIVBqkP+3fSvTWGXuiFBn+h0Qv+xPp9gdWCX0l/EYhiA==
X-Received: by 2002:a05:600c:35c3:b0:428:f0c2:ef4a with SMTP id 5b1f17b1804b1-42f85aa817emr14424225e9.13.1728033016314;
        Fri, 04 Oct 2024 02:10:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTm157t6QcMf8gjoAtCEnaqJykgnp6tIfLsplWcv2x4DJAc1A+hAkLVGTelF1r+AOWTAiLCA==
X-Received: by 2002:a05:600c:35c3:b0:428:f0c2:ef4a with SMTP id 5b1f17b1804b1-42f85aa817emr14423975e9.13.1728033015874;
        Fri, 04 Oct 2024 02:10:15 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b1d640sm10512925e9.25.2024.10.04.02.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:10:15 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] KVM: selftests: Drop manual XCR0 configuration
 from state test
In-Reply-To: <20241003234337.273364-10-seanjc@google.com>
References: <20241003234337.273364-1-seanjc@google.com>
 <20241003234337.273364-10-seanjc@google.com>
Date: Fri, 04 Oct 2024 11:10:14 +0200
Message-ID: <87frpci689.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Now that CR4.OSXSAVE and XCR0 are setup by default, drop the manual
> enabling from the state test, which is fully redundant with the default
> behavior.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/state_test.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 1c756db329e5..141b7fc0c965 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -145,11 +145,6 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
>  
>  		memset(buffer, 0xcc, sizeof(buffer));
>  
> -		set_cr4(get_cr4() | X86_CR4_OSXSAVE);
> -		GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
> -
> -		xsetbv(0, xgetbv(0) | supported_xcr0);
> -
>  		/*
>  		 * Modify state for all supported xfeatures to take them out of
>  		 * their "init" state, i.e. to make them show up in XSTATE_BV.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


