Return-Path: <kvm+bounces-57924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC70B81421
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C493B2C86
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E432FE56E;
	Wed, 17 Sep 2025 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FnG0Xrk2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8812FC89C
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131783; cv=none; b=b7Jsk832SVws6DhygEm3lIwB2fDS2761pIXpC16LHDIUAFq/HTgithXmC1KkGyLo80j3G7OWBjqohBQsILezV5+I7g+PUF3+RqI6/zkEuQReQ6wOgph0GfX3ingSmRyTDGqDpsbLdHOlOnKaj+WHt9PhOoemTOWUUnhvdq3uGOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131783; c=relaxed/simple;
	bh=oPkyEQThPJkZXDMJMqwLN+MXKminswUTWH1q3gWVLhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwHbsu9cnn+TcOFUO3egpGSLsGvsN5bH8O6Q5cVTzqoyRkefuvj1rJfSYZoT9i9S4qTYtT0g9HNXjM6PDzjkgFsx5IOxuaEdwRbpUse01Jp1QPtR9Jd/WTvTxfbNsJZwMuEfMNdBK8adkpCV/JKlBfZSjIIzL77g7f9QCW+lIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FnG0Xrk2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758131781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o97Jkb44CguUDtzud8LMwc46TxzGlvMRMvZas4PSbL0=;
	b=FnG0Xrk2hBJ8boJw6aSxBg+bnDF8kaXAHnwuAEaOrqOsw/10iQWoZ9PRjoC0z8wI5CrEcA
	mkGt4H2udZLBJ4OWnld9pNbDPYbfop6Fe8Lg6UOqzyGqn/D8X5QaSHEVOxsQpBmmRUSjiv
	pCukYQN6m9Y+7UIVJwTWmKmXUFnLSoU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-hGYr8YJgP324wxrwlFdLjQ-1; Wed, 17 Sep 2025 13:56:20 -0400
X-MC-Unique: hGYr8YJgP324wxrwlFdLjQ-1
X-Mimecast-MFC-AGG-ID: hGYr8YJgP324wxrwlFdLjQ_1758131777
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ea35489002so21547f8f.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758131777; x=1758736577;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o97Jkb44CguUDtzud8LMwc46TxzGlvMRMvZas4PSbL0=;
        b=ucZBLxdMuL8xWyb/OqM1rifhlFloiFlQLbQxwN7cbNa84BlnFlZWvnjfJgpUvyO6Jj
         cIRLgkSiDhyXSYiv0gXmCwNPaFlUiP/E+2yO1FnGySAW8+kE2giy2byCZVeZJ2qWnUNN
         taT/dk8X3T08FZ0w02FR5NVcwOtWk8bel773Qh6PAbmyOBjr2avZko4iWP6f2ZZewt9J
         L1GhKoC6FOyE9xSltRMpiEWHfNisBwVRGM9ZeSqblfKjoPEVPJ9M93AFmjLJ0X0t2D7H
         wDHeXc4LrNHAuDA5a31BHx2hbHUlokXd1fC3zgL+peThhJGSN+ewQeVQHQK6xZ+wUhPE
         4xIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGlQkN3MaUtu5JzcgIkw8GLXUv2TJgAIO6K5TYgpandtymz0nI6szeSqCyogSEHeb/700=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5kVo+C+wZ6NQUVDOh2XNf2GuhODARBBZjcEee9Ww8TWu6klmc
	gDXIn7UMYZHaQ0ZGaVMRRLnXvC9UQW5/djF6o9lBMOc1jejptugOb/Gb0gNs86aIIrnjVqDtkla
	/yCmp1IrXEtSGgSLVdggc7cuI23r/XICWLhMKC9CAICsBsiZqDgFaKQ==
X-Gm-Gg: ASbGncv2WISwzLnh3q64sngFTW82S6hVjZZEpnEytRtd++G8IadYsZW3/CzrgCXksXs
	BNvpSZwxnIhOGP1EmcJw+l4Q88623Qy4PRN4oIYpZxqbcVV7ugKHd8fb6q8/my2H/CExCXIpeJq
	JxoFdZaQOmUnhsCO243K36KfpZkSuEiQ+8BbmIoe4y5ZtXg0NoEkFsZ/sMhw3+uNLfqKeVgqgdu
	2KnY16JN4j2yXMYxRGc2s0uX/EzcOT0ngIClnCP5eeQtgwZ63dBB7Cr6rmFZdGXc7TChRvsdoFe
	z7n8STIEAVjhINfROOutntRUpa/hqTyJE6k+xR9pFsL89z3Pwbe1ArMcjnmWDHao4z1FwdL53sY
	uDDEDHQ4TTjxrxmkax4hhx+LYQUw3CPaE/4tAt1/rqrU=
X-Received: by 2002:a05:6000:2512:b0:3ea:d9a7:43e4 with SMTP id ffacd0b85a97d-3ecdfa3f455mr2881662f8f.53.1758131777414;
        Wed, 17 Sep 2025 10:56:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtBAYP2GIwzz3bV6tNJV/6G8FSBl5qdvliPlMhUc/LxJ9XtvD0KciFkSa9CHP0G+pZLVonIQ==
X-Received: by 2002:a05:6000:2512:b0:3ea:d9a7:43e4 with SMTP id ffacd0b85a97d-3ecdfa3f455mr2881644f8f.53.1758131777016;
        Wed, 17 Sep 2025 10:56:17 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.56.250])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1d35sm253196f8f.55.2025.09.17.10.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 10:56:16 -0700 (PDT)
Message-ID: <6e598aec-f55c-467a-abef-6d183bb9cfca@redhat.com>
Date: Wed, 17 Sep 2025 19:56:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.17, round #3
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <aMHepH8Md9gSu2ix@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aMHepH8Md9gSu2ix@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/25 22:25, Oliver Upton wrote:
> Hi Paolo,
> 
> This is most likely the final set of KVM/arm64 fixes for 6.17.
> 
> Of note, I reverted a couple of fixes we took in 6.17 for RCU stalls when
> destroying a stage-2 page table. There appears to be some nasty refcounting /
> UAF issues lurking in those patches and the band-aid we tried to apply didn't
> hold.

Thanks for pointing this out, I will put a note about reverts in my own tag.

Paolo


