Return-Path: <kvm+bounces-7319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4008400DB
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 10:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D014E282044
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EA854F8C;
	Mon, 29 Jan 2024 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOzGMpKS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CE54F82
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706519042; cv=none; b=fNCM489L4rpEVUXvt4b2NeO39zjqtJv9PFKIUIXM5dXrUGGMIz/YZMdal/8jY35M1SW0Vgjsdr2m0iT3qlmBEL3pMGlKZkMP7XWunVefwF23hAU1ihVmfVqNNLHe1zPfPE5xkcKy7DKi6/zLAK4gu3TyQ6xOO8SCx4LNRYle3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706519042; c=relaxed/simple;
	bh=aaqzDJagx7VtoO97qs85Dq0uoWjJTuO/qVeqF8e7ssc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YLrseKezvOZprDVVW0X0GTQv48G7Uzyo6BlJWKi5yhZKigvwVnmvjyOAC5z+QMkhdjVmEKVjv4wI0rErZOMS0YFUXQ1WGHJtTvJ0U50a6mz3grIpVc3ZJwmFVfsK87gcSksg834InOcxJF/Fwzo7hKjZWnmPHUvGo30Tlm1ar3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eOzGMpKS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706519040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8LxNQVXsu9usio1d9bkE2ficZHEFLd5sQcdQVhw5rlw=;
	b=eOzGMpKSeLiLd7FwtDIT8zen2fAOkOU/o9d545NgQoFtYn+/k9JeW1ajrP0OllwHEyCc2z
	d21ymKSUTV9xCx3iHeyxB/6o7DYymDO9ZVMAA6hIW/CEznCOIwqkA/AFOtUs0amd1GGfVp
	x5gzEeMBt3iBzeeAAASKkBAgYBymsYo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-XsA0oNWiNLi0QFvZH5PfIg-1; Mon, 29 Jan 2024 04:03:59 -0500
X-MC-Unique: XsA0oNWiNLi0QFvZH5PfIg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ae6433d55so673323f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 01:03:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706519038; x=1707123838;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LxNQVXsu9usio1d9bkE2ficZHEFLd5sQcdQVhw5rlw=;
        b=bY/l6UHu3XEkg6F0KETFGoXHw/hKPcID4A151uadPpRUsmDk6Z0trIWBBYsTYJm2pG
         wq4tBhTbU6YmsYJ84cbx76v0w8LC3HvM1FUzjoD3kNGAtqzD5RdMeVZ37ZJXAPWRlh6H
         XbsDHKNXdPl9oRfO+mFDDTCWhIKYJwOzrVKMRaU30kUDYfIu7t94RFBt8sSrX9vxN/T6
         9c9ekvlpzqzpi8QmNhmsHiAj47WUJOQwaswHhPsKb2ldYjZB2u64pXlUWEW+j7yAEFGe
         1Y1DoPlrHMlCfyTEpovTfCGYyXjSsCZNzATQbL/9WEKyk34VAVR28dpNoZrRR4YdCdS2
         /FzA==
X-Gm-Message-State: AOJu0YyQBAdfHHzaJ/32zgCDRvDWXiEbllVBJ7p5/0+GUZNRRIVSy20f
	X2u8U8Elbc2Ys7LXegMEKTrht3ssfpFBHmYb8MtRGuRgixBQNCAyAFB/BfGN4bsNYvof91+idYB
	WpWrxqsxr4AkmPoTCUlYZcpUJ9Ak4EXKypW5Fwp3tbvcP2PzHJw==
X-Received: by 2002:adf:e909:0:b0:33a:ded1:b01 with SMTP id f9-20020adfe909000000b0033aded10b01mr3642086wrm.28.1706519038013;
        Mon, 29 Jan 2024 01:03:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVKnXjePT8qznNPLmkBfNjFF0aIxtCnpc7cma66ujpkb6g0ZWX63QCwUZYiXc7/8xFmdApqg==
X-Received: by 2002:adf:e909:0:b0:33a:ded1:b01 with SMTP id f9-20020adfe909000000b0033aded10b01mr3642074wrm.28.1706519037728;
        Mon, 29 Jan 2024 01:03:57 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id bn7-20020a056000060700b0033946c0f9e7sm7564062wrb.17.2024.01.29.01.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 01:03:57 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: selftests: Fix clocksource requirements in tests
In-Reply-To: <20240109141121.1619463-1-vkuznets@redhat.com>
References: <20240109141121.1619463-1-vkuznets@redhat.com>
Date: Mon, 29 Jan 2024 10:03:56 +0100
Message-ID: <87a5oo8q9v.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> It was discovered that 'hyperv_clock' fails miserably when the system is
> using an unsupported (by KVM) clocksource, e.g. 'kvm-clock'. The root cause
> of the failure is that 'hyperv_clock' doesn't actually check which clocksource
> is currently in use. Other tests (kvm_clock_test, vmx_nested_tsc_scaling_test)
> have the required check but each test does it on its own.
>
> Generalize clocksource checking infrastructure, make all three clocksource
> dependent tests run with 'tsc' and 'hyperv_clocksource_tsc_page', and skip
> gracefully when run in an unsupported configuration.
>
> The last patch of the series is a loosely related minor nitpick for KVM
> code itself.
>
> Vitaly Kuznetsov (5):
>   KVM: selftests: Generalize check_clocksource() from kvm_clock_test
>   KVM: selftests: Use generic sys_clocksource_is_tsc() in
>     vmx_nested_tsc_scaling_test
>   KVM: selftests: Run clocksource dependent tests with
>     hyperv_clocksource_tsc_page too
>   KVM: selftests: Make hyperv_clock require TSC based system clocksource
>   KVM: x86: Make gtod_is_based_on_tsc() return 'bool'

Ping)

-- 
Vitaly


