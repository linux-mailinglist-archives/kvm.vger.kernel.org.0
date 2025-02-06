Return-Path: <kvm+bounces-37534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EB8A2B2FB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 21:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8B5116AEC2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9163D1CBA02;
	Thu,  6 Feb 2025 20:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aU8vrraf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BAE1CDFD4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872496; cv=none; b=kRs4dKbdWjHfqG3xQuNViG34vGIoSUtMsBwQ38n+W5gihvm709glGo4J2rEDDY3W6d0NwliXBU992tD6yKvCTL5Ah0KXeL2BzpJ9ffq7jR+k2isV68E35VwWdC039XUkeN2QyO1kG1QgoFjq0XlB6gMoveXrZejX8Z4vif78HFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872496; c=relaxed/simple;
	bh=+dkpAnbdjh0dgrGIHhIPBxApKDschrnxYPtbm5oWAqc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=rv2ThYsXjjG4IHGHjZTNiLmHa3MZCzg+oTebaN/0Rmm3VzPc+NMLU0HjUvClI5jtZ3nfMPNpSEXtIrevhIeJbP5bHEbi/xaYDOcd6xl9R4XWg8Jt7/rdmIA1XQ88LEM3sqYaHFI/KO8BB6w4otECPuo6w+kovK5LFVWb/8jFbVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aU8vrraf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738872494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lMTAS8pZ+dV5XxQmV6jHa6Bjt73X5ogir1Fm2eB6TvE=;
	b=aU8vrrafKNz90Yoo2sZi4Jty+klTp0FfsoIN/93Y0P9HF1M4YeTWpjHENnipAcElKVjD0w
	FGtk7Zs2RIHvswBkS9EHwk9s+JG6y0a9AimT1x19GCFSeSnHb5Y4EFwIuR4SATZV/azjQQ
	98a9JMtb99wLINYBDAO6Kw8vV6yEonI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-kd3zfbADNQK2f72beJ7oyw-1; Thu, 06 Feb 2025 15:08:12 -0500
X-MC-Unique: kd3zfbADNQK2f72beJ7oyw-1
X-Mimecast-MFC-AGG-ID: kd3zfbADNQK2f72beJ7oyw
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e442b79dd1so8697546d6.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 12:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738872492; x=1739477292;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMTAS8pZ+dV5XxQmV6jHa6Bjt73X5ogir1Fm2eB6TvE=;
        b=LQ5wFtxMdDWKigB3PCEta/wWacadeR9GDGhrbON4oa4MkHbgnGP/zkwjmJiGnAQwAI
         TlX4Rqw3OpnDsz32m38XLgJpisEtyQllQcI8iy91/tgE/8bqsBa5+gTOcEfDTlSOOPDr
         RdcPkx3hPJ8i29xVzxvEHQGENeuKdLNFeEp5pdT+S7N2H6SgsVxylpEbDzYbblgvz8lY
         lBX6nKVq6v+svkNafWuY9qidGeVv5yQDPNYbL/UTFfuO9BQFBJ7qN00y2sC7NUvgdF90
         L506JSvUvGBuDNPYtfMvY8aBgIghFtRgLcsI0w2elue18nWiequ9YYQB8/VSE7i81kiH
         8Fbw==
X-Gm-Message-State: AOJu0YyrZDCya76ss4WtdCe2EhXj9KNOOmwhzQsGvSvau4VM4+UAVQ9G
	z8GDV9S6ihfgKj7eeWnhJm7nthB4l+wUHRLlBoFtESuD83GixjEnhCKZqhlzHNjr/EmnR4Uhw+r
	vu5nTnT1197Y2kzB/WY6Etg5XS4A93K8K4s1GJJe8NbfkaW7Tk8Ug9OlK+Q==
X-Gm-Gg: ASbGncs00XqWTAwqFd78aVD7yezakLLkrzq/KQkr4QkmsBzxJFFe1GzTvTYELWwwq6B
	2O7CxRxknpJ8qL9qt7X3bnKmTRXp2VEkLO83urQvt2zdKMxwcJIpvvS+IjEz1wtH61bUkF6qGjS
	4HkDMIsUtC2hHnPdIpGVF0jIkWRTCjwfSbtGUa1CVIqhoasIwjYUAVKs95llUvemIMTwqD8iVw7
	Mv0zid0Qkj0v/8AMAgvl7fiprU89JwOH7w813J3H+43JJw5mlesAW2ykWJgNpu3LVbdSnA//FBq
	emca
X-Received: by 2002:a05:6214:2125:b0:6df:97a3:5e5a with SMTP id 6a1803df08f44-6e4456fb68fmr6117046d6.28.1738872492195;
        Thu, 06 Feb 2025 12:08:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvLPFk7n13OymwYmVhEWVp5kTrPK6FDD6vm5LNZc8OL50WsLHUamKJWZR2KL1P8HbqyyuOeQ==
X-Received: by 2002:a05:6214:2125:b0:6df:97a3:5e5a with SMTP id 6a1803df08f44-6e4456fb68fmr6116726d6.28.1738872491822;
        Thu, 06 Feb 2025 12:08:11 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e44628d1fbsm327646d6.112.2025.02.06.12.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 12:08:11 -0800 (PST)
Message-ID: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
Subject: Question about lock_all_vcpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Date: Thu, 06 Feb 2025 15:08:10 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi!

KVM on ARM has this function, and it seems to be only used in a couple of places, mostly for
initialization.

We recently noticed a CI failure roughly like that:

[  328.171264] BUG: MAX_LOCK_DEPTH too low!
[  328.175227] turning off the locking correctness validator.
[  328.180726] Please attach the output of /proc/lock_stat to the bug report
[  328.187531] depth: 48  max: 48!
[  328.190678] 48 locks held by qemu-kvm/11664:
[  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
[  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0


..
..
..
..


As far as I see currently MAX_LOCK_DEPTH is 48 and the number of vCPUs can easily be hundreds.

Do you think that it's possible? or know if there were any efforts to get rid of lock_all_vcpus to avoid
this problem? If not possible, maybe we can exclude the lock_all_vcpus from the lockdep validator?

AFAIK, on x86 most of the similar cases where lock_all_vcpus could be used are handled by 
assuming and enforcing that userspace will call these functions prior to first vCPU is created an/or run, 
thus the need for such locking doesn't exist.

Recently x86 got a lot of cleanups to enforce this, like for example enforce that userspace won't change
CPUID after a vCPU has run.

Best regards,
	Maxim Levitsky


