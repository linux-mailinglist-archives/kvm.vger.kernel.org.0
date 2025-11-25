Return-Path: <kvm+bounces-64489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70EC7C84843
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C227A3AA11A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5457430FF25;
	Tue, 25 Nov 2025 10:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZAff9P1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EERGZCai"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91540287256
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764067077; cv=none; b=WbQ4mTtCI0SaKagvlpXSTazSxzX2nzq5E+Cseu4NM85atEA3oQ+Tdv3IrJGqVtcPWmgKtjV7sU3F3iHb4VfuBuJoOWnxvqhcRHcZwqdz2z7vQkNk4IwvoVdO3J4CBBrOpP1ft9cpr1mwkGwzA+3AU+k6C4Cqz4dreNGRRQHeEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764067077; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPKkKerVbG/1Ji2dbhxkeJzuKiYfqepMPuneCdl0auH386jxVE3Vb2L78NN+hJNLkBqjwCDqURAthWNOA2cT6+7Rp/d+V1YdqxPVtoQCYygByEsF7Ak+r7ZyeMM3DodjQkLZyYEoVCKbyRoFrzZLAb7bGVlgpYW/mkSvHR5ZF70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QZAff9P1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EERGZCai; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764067074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=QZAff9P1HO1Fy0E6hk01iv7aG8ai7jrF+bpwQDrpQZT6b9PUIReT4WoaCRrWcAPnnxTCGx
	vB0ei4qBK8jWNrmh2JzCoGpSQlbKOer+MtINkEYoWETeOWt+LQg0donU7o+Pw7Z1EUjBMn
	B6CSyNY3m2/j6VznBdFjrgbEiIilYiY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-wtB_9ydWMkuJpatzxINRcg-1; Tue, 25 Nov 2025 05:37:51 -0500
X-MC-Unique: wtB_9ydWMkuJpatzxINRcg-1
X-Mimecast-MFC-AGG-ID: wtB_9ydWMkuJpatzxINRcg_1764067071
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso3630035e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764067070; x=1764671870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=EERGZCai46/m63XLfYwWZhFUJYyk+BIWM7G6R0Juk7Y6PS8v3i/Q/Y67U5A7QkI7gd
         PjCf1VKYO5/D87DkqjvFnN7HkbJU4wf+PFueNwR4pFTH1Dj0YdC0XDp3l/e/50xJ2goL
         ESXsJ34KM3NeyO1uqlDqaJBpwjIZ3aaVlfVGeUb9/CJE3BDmqb4Jddk9+x8cXhBuWacr
         LfdrykOD8PFP01ow88iTEbEO2BMvwAqdKaBpi/e6Lff12cd+mX64P0czeB8fpBmhK+hd
         whnv3y61juLegE83Pf6S0q17HsPUBei5BQ5OEK3hXl/KO8mgBUoh7K2zLaEt8800qYnk
         5zjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764067070; x=1764671870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=F3w1aPaXMduQvNgQ0L5yLD+n5yPXaAGSLlcxkD1uF2+zpREcl1lL5M5Uggr52oaUk4
         qCysBic8hsDco69MjM8Tei2nVSOfHfIoQuGWCGNHl7+JClqgh20TIdOGsdMXaPJVn53h
         OouGIOr15WAciyFnC/W2xuHD22yu44k6O1Eqn1ow3iQmBR2kb9qf9WM+8M9sFaP9sTOF
         m5/UC08F8ADikAgfDDDMlpWE1PfCqV1TUA7491198wBag9zbm7XoWmo3eBPJVHEZFf1m
         SMqJ//hK35EK0kztIyTN1UoU/Z8QnFuvHHis+Xyca9Cv2BrxmSkwn4SFQwv8r8VDTNvC
         D55w==
X-Forwarded-Encrypted: i=1; AJvYcCX38Xw/MMZvdBYz63QNdqIkhwD8pzc/HTdS7RapewcF6twjYBr3u4tZPAQgdx2k6qbHNlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6I93X71YyvpghC/lu2K8NJASoy7Sd/2pl11wAwUiAAfb5ZCvY
	xG371wyFYcgIB0HMykC05GxAwikPNYZ/ABPXbJjvTZtf6uJIuHILwm1Pujrs65Xwequf9gaCDU1
	mN2eVJq5khm80622nDoe7tdozhI+4FU3U7z/ctPZj+jFzplFxpgSsXw==
X-Gm-Gg: ASbGncsQnBU0FxzqRUVSA2lkX0QUVl+NtjvMhyEzGsvHSLbheuoxksMZP7ZPvbSZwDJ
	s4ONQPk0JAmQhYf/RE42GUG6vTMxfCyfFstLMc7M0dGDpVAzKUbaKYyNlsMgBuihZtiKXp8uRY4
	/egS+cAHZ+OT6YT9yNDRArKLN4i1keh3Xec/8qVIW2IAsMuvH8hfIiFluvFXhcr5i3zx5NI1as+
	2VXrQDD5KdvkwlF1FQWDSS7Ah1/Dz6KD5fvECbj0vg7/f2gDG8c2pkMFokvyWbIJtri+Wm4Oo05
	yWVcbtsa+ncRcmGTIGA7uYUiVNZ6dEni6mHtHiwsQ5PftLy76RK+vTLMXAFuB4QFeYCXso9EsNz
	2d0LG3mP4Oh72RjcvTI/1tvf7MA6HRfe1nrHhKv1ZbQLHk8JynVu2vvwkdSiiCfCwpFpFRAU/71
	38ZeyGbgJBpuxv2NI=
X-Received: by 2002:a05:600c:1516:b0:477:14ba:28da with SMTP id 5b1f17b1804b1-477b9ea8f78mr119762145e9.5.1764067070599;
        Tue, 25 Nov 2025 02:37:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHULk984gW1pt9XBGwHyAZGYSiRX6fCnEwc35u/qID0TOVrBa5kMUwpLLIYtidkFhlGsKF7bA==
X-Received: by 2002:a05:600c:1516:b0:477:14ba:28da with SMTP id 5b1f17b1804b1-477b9ea8f78mr119762025e9.5.1764067070250;
        Tue, 25 Nov 2025 02:37:50 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3aef57sm232315995e9.11.2025.11.25.02.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 02:37:49 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	eesposit@redhat.com
Subject: Re: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
Date: Tue, 25 Nov 2025 11:37:46 +0100
Message-ID: <20251125103746.856877-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251125090146.2370735-1-armbru@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


