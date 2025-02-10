Return-Path: <kvm+bounces-37763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C35A2FEA4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 00:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBE527A2277
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E97525A321;
	Mon, 10 Feb 2025 23:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KuRa2UgS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8961F1C3C10
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739231584; cv=none; b=YKIXuzR+Ma+PCYW1+P1ms9FP3yhCIAXId2xIRLvk/DW7hUb34wOit7p1H+uCg3I96lLn5pCya8gHAk7CiFcl9/Qdy5/pq1Z/RVL8a7MV6TPUzv/GanYlP5AQm5SFeMUhG7Ur5dKAum9i/cA7mOA+M0adbTpw6kGmZimRrLzBkrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739231584; c=relaxed/simple;
	bh=wNE5B9eXHB/bYEdSpLcv8dqqcXrPyBqu/E3BTd03jYs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dKbfrh0N8DNnuLtkEOAB8w30mLYITO0F0P56EKRxpyVk6E0iCtRwDraGeOZAkuB39JCTitlZDa8UDOEvPn+ku1KBUD30tbwDh4jh4MWhTS3G0aTKEjnlAcBYKOBwQ+BHcMfoXUCKY72sXlS4sEWF/WPITCYH9Lf4LwM76KmdNns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KuRa2UgS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739231581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9n9MHUuomJDgMTr67ZouKycRR+Nts+RHOLWpDNWTuDE=;
	b=KuRa2UgSxDni+pglcmWn2BoJAUkdJSYYUl686JwCwxwl3aBt2RrE9f2Bn6UQYfUhXN7jbF
	FzxjfiSpFl9L6bxNcc0Kb5KRtGg76hOvMRp8bV2JcIVASBHFDZr+r890gys0wKbfXVP1f6
	fcTvJjOx7syzM84zWW64GoiDT81bYaI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-3bXRsGFEMfKF36xcQ_MtQg-1; Mon, 10 Feb 2025 18:53:00 -0500
X-MC-Unique: 3bXRsGFEMfKF36xcQ_MtQg-1
X-Mimecast-MFC-AGG-ID: 3bXRsGFEMfKF36xcQ_MtQg
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e44c52e40aso102735946d6.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 15:53:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739231580; x=1739836380;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9n9MHUuomJDgMTr67ZouKycRR+Nts+RHOLWpDNWTuDE=;
        b=E8ZL99iiJ99l6cJo8ryAIWzSP+OIF+jHXRYkWDs71vK5pL3RTFbWHWuVyJtKpFLC90
         5EwY0c5ZOSOJfjZhiJDke1370Mpoe2lIdUTtL0hWgqqJZr5+Qi0mbKtRKceDtn9QnjrA
         5x0gyyBB7TmHZWiMpRDBToOfKJaOLJ1h/ILfuv7Li+vbAseocZhsb8crsF67UAUXfrlD
         79rOWUlVNNGfG5RqXQCqltetCEWGF3+QR7D8jnJx4NrUu1lqJY/cvHBC4J0tfYbwOPqv
         NztO4eFLWQD8Um3TCPZgAjA2ienj1M9DvFuvfHVWuBz86x//xCI8jR7Km58WvUvvHo4h
         T1JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFqFxtKxBJhti9lQAfNKsVSfc75fEk2c/brXcTQme3X9iyLRvxVXL6eH1ylU72tktPAfE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7vZY2KxYypmiu5ll9J3BjbH1S9v8FbSdvWg7pp0qV9W3iX7YD
	hLU/Ygvxl8ox6XNCga/OHn6KAlsPEMVy+Ilz1pwMbCpLnzdJ0Zqt5FiUgdef050KuQH2OInfl4I
	9d+CQdTMbcD5DXBp8r40l3V6EWPflsaxaFwCMA9oEfLFFGNBGD+Gs4IrkOw==
X-Gm-Gg: ASbGncvC7RbKzVhPPMvdpcGEpfQuwRyEKbuAGtIkVG/T8vaX6vzUb0yu52HqsafRU/G
	pFzxcfH+pT8HrDBV2xLytu7W9hyeQyuMgmbspCTEiO9dnbbltPhsu7fdkHd+u/yGkfrUAh12R51
	hdZdxkc+zw3n+HDvA15YMSqcVUmpWYBPPKV52YIah6EozTP35idTGAHenu+s6VevKMzEKwwLQua
	wOGrL5e08hTgD+lXPEoknfLmxUmIZX49BD6FKh2FNxHDL/jFix0pKlT4o59gDeCxevZC2RK+vGt
	nLaR
X-Received: by 2002:ad4:5f48:0:b0:6d4:1ea3:981d with SMTP id 6a1803df08f44-6e44577a219mr188090386d6.43.1739231579795;
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTZs5MDqcyEc7mfn8O43N7j152nBww16Om22OeV9BNEnRQ5CHfvHC/RIVx9CYDICeE4ROxPQ==
X-Received: by 2002:ad4:5f48:0:b0:6d4:1ea3:981d with SMTP id 6a1803df08f44-6e44577a219mr188090196d6.43.1739231579424;
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e43bad5a7bsm52714786d6.119.2025.02.10.15.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
Message-ID: <2673d55d596afff0b8241ccc806e437e2cf9d3e3.camel@redhat.com>
Subject: Re: Question about lock_all_vcpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Date: Mon, 10 Feb 2025 18:52:58 -0500
In-Reply-To: <864j11u70x.wl-maz@kernel.org>
References: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
	 <864j11u70x.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-02-10 at 15:57 +0000, Marc Zyngier wrote:
> On Thu, 06 Feb 2025 20:08:10 +0000,
> Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > Hi!
> > 
> > KVM on ARM has this function, and it seems to be only used in a couple of places, mostly for
> > initialization.
> > 
> > We recently noticed a CI failure roughly like that:
> 
> Did you only recently noticed because you only recently started
> testing with lockdep? As far as I remember this has been there
> forever.

Hi,

I also think that this is something old, I guess our CI started to
test aarch64 kernels with debug lags enabled or something like that.

> 
> > [  328.171264] BUG: MAX_LOCK_DEPTH too low!
> > [  328.175227] turning off the locking correctness validator.
> > [  328.180726] Please attach the output of /proc/lock_stat to the bug report
> > [  328.187531] depth: 48  max: 48!
> > [  328.190678] 48 locks held by qemu-kvm/11664:
> > [  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
> > [  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > 
> > 
> > ..
> > ..
> > ..
> > ..
> > 
> > 
> > As far as I see currently MAX_LOCK_DEPTH is 48 and the number of
> > vCPUs can easily be hundreds.
> 
> 512 exactly. Both of which are pretty arbitrary limits.
> 
> > Do you think that it's possible? or know if there were any efforts
> > to get rid of lock_all_vcpus to avoid this problem? If not possible,
> > maybe we can exclude the lock_all_vcpus from the lockdep validator?
> 
> I'd be very wary of excluding any form of locking from being checked
> by lockdep, and I'd rather we bump MAX_LOCK_DEPTH up if KVM is enabled
> on arm64. it's not like anyone is going to run that in production
> anyway. task_struct may not be happy about that though.
> 
> The alternative is a full stop_machine(), and I don't think that will
> fly either.
> 
> > AFAIK, on x86 most of the similar cases where lock_all_vcpus could
> > be used are handled by assuming and enforcing that userspace will
> > call these functions prior to first vCPU is created an/or run, thus
> > the need for such locking doesn't exist.
> 
> This assertion doesn't hold on arm64, as this ordering requirement
> doesn't exist. We already have a bunch of established VMMs doing
> things in random orders (QEMU being the #1 offender), and the sad
> reality of the Linux ABI means this needs to be supported forever.

Understood.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
> 	M.
> 



