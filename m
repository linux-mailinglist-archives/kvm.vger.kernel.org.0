Return-Path: <kvm+bounces-27854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5388898F4E2
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 19:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85C431C22416
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C581A727D;
	Thu,  3 Oct 2024 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELEXFZpU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394222747B
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727975449; cv=none; b=REEFD0MTy2itM2iPxvzdlybDlkAkBerhdytSaJ3nU/x/+YlGpj0hgroyqY2lh0F8beMvQJL46maCVIHmrg1cPQ7RwfLsrcn0ClxTqkUupmfyt0KFtFt9rtnfFHCiM/ppWTQZq9RX9gaPLLAenfHldYx8qxpGbwbenD5pUDV3V8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727975449; c=relaxed/simple;
	bh=XzGlfYIDxR9uvKWSETj6tttg4Bymter2k+0bkHGAxB4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RvUneR5ZKGrh5QKZjuJ626/MrZ4OLReRqcYS+kNhxBbQkhM5HxL6kvDFUV8I4i+KyTKF/ybxczTX/HOAu52sMXJMNtzjAEJWAPb82YubyEj4+wI7xc6G5+SEWIcg+3YoFjsO4akU5AM4pEA7RnbmuXIZntaRN7G8PTyj+BeguSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELEXFZpU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727975447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cIJjXjCMhmxYKahqYEMcvGUOTAQLsY0tC5+CJ48kR/E=;
	b=ELEXFZpUO4MiMmC4pW3Q59OQv3YbnSxjHJbk475uTCKTeKpyVrgm1hvelklRgqXyrml8t+
	sQR0lOY4HbgqC5CDaOXvDOwoiyMIOG7dx9el8Hot2VoYbHbLdKkTTW4/dOrhI9XC2SzyQZ
	qieQKd5wIj5SpTFnMG7pb7v6i4HLZJ0=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-ar5kJCXwMPCQyE-AuX0GVQ-1; Thu, 03 Oct 2024 13:10:45 -0400
X-MC-Unique: ar5kJCXwMPCQyE-AuX0GVQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5e1c6328c4fso693115eaf.2
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 10:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727975445; x=1728580245;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cIJjXjCMhmxYKahqYEMcvGUOTAQLsY0tC5+CJ48kR/E=;
        b=wAhlA0ntMG16m2+oQp+Tc4dpCJ6YIOoU9rDGzXxMp0AmHz19d8RCwuXELz45ipzxsP
         47CUreOL1L2FuNzIAPNDBNDeESslMnVmLQy29Xh9NA7gZP6rhHjF7Jx5/QdonA5wtSHS
         QRCa2lrlVlDL8orbbN72xuwiH8leRuOfuCjZV32zvzpzTFF6bjHBQzHQMXv7YiUZhavW
         0ozAAWW7P8Icol9DrYdDpPdtnDPMbKX92DKqNu7ekE4i8qLJ6On4S/dVRmyeTdrE4ab9
         8wytA4m1ABC5uE3Xm6x3lz9AfyZHzoem7FyCuUBXAj8QOlBU2PHXWFY6Mbn79qm80MF+
         VQ0A==
X-Forwarded-Encrypted: i=1; AJvYcCVuah9In17JZquSISelLZL5/Ze11S/19vTmxM0VN5StHW63tvmMD0rjQfDHHDZiueGy3WE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7DMFfS33Xdpyp83C7BNIHfRGf3ubGF2jvaA/YKsJxp8FAvi52
	2yeK4iwDHEvEMWgD9OvQdQs4mIdmMFzjthM7bFFT73SYwK5XS3Vx7hZ8pTikpxzQj34aAz0HoGG
	0lnApsXadi9msIN0SU6HdyWDqkKw3NnOsMCl4cRwwCq0yQTr1cpMxxJ+nuA==
X-Received: by 2002:a05:6358:892:b0:1b1:a811:9e9c with SMTP id e5c5f4694b2df-1c0cee88e71mr374402455d.18.1727975445042;
        Thu, 03 Oct 2024 10:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW9CcKCsX7b+tjQTeta63P89V1d9DurjqCcaHRd3zZOdTWXD85MYCtgU47ELERRAtsdTokYA==
X-Received: by 2002:a05:6358:892:b0:1b1:a811:9e9c with SMTP id e5c5f4694b2df-1c0cee88e71mr374399355d.18.1727975444725;
        Thu, 03 Oct 2024 10:10:44 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cb938211f0sm7996866d6.142.2024.10.03.10.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 10:10:44 -0700 (PDT)
Message-ID: <7e4f5d7da402efdc517b3fcebcc683a4f32d8ac1.camel@redhat.com>
Subject: Re: Live migrating L1 VMs with nested L2 VMs on AMD
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Chinmaya Mahesh <cmahesh@janestreet.com>, kvm@vger.kernel.org
Date: Thu, 03 Oct 2024 13:10:43 -0400
In-Reply-To: <CAEjex8LjEsxS=PX+-6C_CLqiHbt0YRVjQLStQHoP1BHoaqABGA@mail.gmail.com>
References: 
	<CAEjex8LjEsxS=PX+-6C_CLqiHbt0YRVjQLStQHoP1BHoaqABGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-10-03 at 10:22 -0400, Chinmaya Mahesh wrote:
> Hello,
> I was reading the KVM documentation that mentions live-migrating an L1
> guest with a running L2 guest on AMD systems results in undefined
> behavior: https://www.kernel.org/doc/html/latest/virt/kvm/x86/running-nested-guests.html#live-migration-with-nested-kvm.
> However, we noticed that this documentation hasn't been updated in a
> while (last edit of that section was May 6 2020 according to the
> blame), and notably there have been some AMD nested migration
> improvements in June 2020:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=039aeb9deb9291f3b19c375a8bc6fa7f768996cc.
> 
> We did some stress testing of live migrating systems with nested VMs
> on AMD and noticed that they seem to be running fine with no crashes
> so far. Do we know if the docs are stale on this? If we have tested
> this and it seems to work fine, are we taking on a lot of risk by live
> migrating VMs with L2 vms running inside of them on AMD? Are there
> specific workloads that are known to result in undefined behavior more
> frequently?
> 
> We have tested 2 scenarios: KVM running in KVM, and Hyper-V in KVM,
> both on AMD EPYC CPUs. Both seem to do fine with repeated live
> migrations although we are yet to try this long-term.
> 
> Thanks!
> 

Hi,

While nested migration, and nested virtualization as a whole, is not supported by RedHat AFAIK,

I few years ago did an extensive round of testing and bugfixing in the area
of AMD nested virtualization and especially nested migration on my Zen2 machine - 
this way my way of studying KVM internals, and having some fun.

So I happy to hear that it works, and yes the documentation must be updated,
I'll send a patch for that soon.

Best regards,
        Maxim Levitsky


