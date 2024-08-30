Return-Path: <kvm+bounces-25524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F20B966356
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43CD1C204DA
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D49419ABB4;
	Fri, 30 Aug 2024 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+54MZ/s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4AC1758F
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725025638; cv=none; b=oUEBzBlIWaYS2/V1ms6Zakiz3F6NvuHiaiwKH+Q2uQF1NtKC9wEa5b6dVToaQsuYJlGA4HINNXqWRUQCKnL035998mbSUwe27D3JUnNT5PcErlklbPYLMYuv+OmLDS/pupRC4gPQqKa0xciTNvVYK25kHZD69y1YjI21gjLaR1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725025638; c=relaxed/simple;
	bh=OTpeEh2C+pBjQpLMmSeYbGjDRsZ/FIDacZjxriqKcCU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XZ85jqdjDDuuKXxzMBpC9NWCuPX41AFbjv8ZEZ2LAV9u2MrfgNfSHI/fYLJ7hiCOyF1FGaTnIctOmd0YwluNLh37N3aJyjQH1sgHeMtb2rdKTSWEov566H0uuaCToVu50MsHlQx+iNPRyPkX3b1otO5czahRrA5fIUzA5bpVsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+54MZ/s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725025636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGA3KUuJjgRSpXeQ3xka2KCdJ1cKZa0/v3QiIokE+Z4=;
	b=L+54MZ/sbsdzRTBx8iVlW2UUaAHpjto8nr53ma2p7j/thyFR7Usv50mZa5sVpRjJa1nJsw
	hyTMJCqbpB3p5V3D9BZ5w5w0pyo6n998TY6DWX4rGdgaabh8i68qAPF3HA7y2B8FSEMk9S
	h2Es8f810SqzGV8IPtCcwaRXSI7ZjRc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-9n2VIhjrNzaF8fcwVdEvpg-1; Fri, 30 Aug 2024 09:47:14 -0400
X-MC-Unique: 9n2VIhjrNzaF8fcwVdEvpg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-371881b6de3so1250957f8f.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 06:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725025633; x=1725630433;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGA3KUuJjgRSpXeQ3xka2KCdJ1cKZa0/v3QiIokE+Z4=;
        b=T7cziulloomxeyHhQ52rSoQYrEs8fjGHxTw/nMAxyCjHFefRQNfYgK7jHTDfYd7auo
         28jjH+xIEExI5ydcVKcDDhmd4HjZ2f6Hedgtp2haToFGcviPJk+50FwjKZgxyi1Khxn+
         1skG5OgapUXuY9lE0K5ouYZ2u9ItDslGCrrHiaZ1EtlM5q9+1SQlxQEq8c0n2yA6mpVj
         TUcfL0aLo9wrWUGWLO4tIYGjIPtcLvjVKNl9HBDBGtGss9SxAkZMMHWSE/kSRrN6hiRk
         Sn6eKqVISnytTmJJoAUDmdv1TPu+vdzJJZgYh4/gBOnXeaJA5BrsyLfil4QWubwqaauJ
         5RWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3/tu5ezdHDZTN7Mwb1VoV+xqg6GYeVvt0w8cGFmzhqMhhAzqqc28+fNRrs264nqee9Xc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfUTgf2aIAn6Sn1ik6FIeAyenRGwLaXUjd4kT6xtHRu3Ct6MeM
	zpeFrmo01emJ2VIRCJhflu2FL2tI5gf3Gtf8W/I1/j+olhE9D8ucjqDmrSdcu5aoku0juHHZWmB
	SSmzgzDv26XEy1dblsgQn4qReUAppOucGIX5vy51umvEL4H92vA==
X-Received: by 2002:adf:b356:0:b0:368:6561:daba with SMTP id ffacd0b85a97d-374a95a0047mr1711073f8f.31.1725025633507;
        Fri, 30 Aug 2024 06:47:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXFfCyeKQTszCb1/6emJitppLXl0Ycds2dYm+zjh0Z/QfOM72vXtp88r7gHPjkSfi/i5eFdw==
X-Received: by 2002:adf:b356:0:b0:368:6561:daba with SMTP id ffacd0b85a97d-374a95a0047mr1711044f8f.31.1725025632994;
        Fri, 30 Aug 2024 06:47:12 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374b9859486sm703874f8f.111.2024.08.30.06.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 06:47:12 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian
 <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, Yiwei Zhang
 <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
In-Reply-To: <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com> <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
Date: Fri, 30 Aug 2024 15:47:11 +0200
Message-ID: <871q26unq8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gerd Hoffmann <kraxel@redhat.com> writes:

>> Necroposting!
>> 
>> Turns out that this change broke "bochs-display" driver in QEMU even
>> when the guest is modern (don't ask me 'who the hell uses bochs for
>> modern guests', it was basically a configuration error :-). E.g:
>
> qemu stdvga (the default display device) is affected too.
>

So far, I was only able to verify that the issue has nothing to do with
OVMF and multi-vcpu, it reproduces very well with

$ qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s
-cpu host -smp 1 -m 16384 -drive file=/var/lib/libvirt/images/c10s-bios.qcow2,if=none,id=drive-ide0-0-0
-device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
-vnc :0 -device VGA -monitor stdio --no-reboot

Comparing traces of working and broken cases, I couldn't find anything
suspicious but I may had missed something of course. For now, it seems
like a userspace misbehavior resulting in a segfault.

-- 
Vitaly


