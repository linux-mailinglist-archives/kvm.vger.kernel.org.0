Return-Path: <kvm+bounces-25531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EEB96644B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0207A28292A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68581B2EC3;
	Fri, 30 Aug 2024 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UePCUnYy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621BE1B2514
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725028636; cv=none; b=VwvwWWM3LleN3iWITs6lOLOTwjSY2ofHZXfvxMzGKXNfpv5UDta9ZSNJRvnTjIZ6tF7VdPp/DtFZnN8484Xp3/GNlJ89RuVZri8VusVo0uG8rLEPsaFcKTTCsa0CZWJQnPNJEtVSBWp2YOZ3oBuXrm5L+2skQtxB+WnsufJYg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725028636; c=relaxed/simple;
	bh=V3LYwBVfusskf5TId8gLHE1yuDhwHuX77AKmxh+YuxY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OETSDJqZ5KfznyrEffNnTgwrNLwlxWaKknqu3f97fKOCtTGJWAkP2IKbyZWvhPaqCC6rM0l8cs1+I52HUZog8csD/GBwVi/AOahGVBonV1wMle/6uzb1ZIFVPKQJE2Gkx14Xr/tzhKz/EIxMRz3/k51u9rxfYDeT/mSHI3FTxww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UePCUnYy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725028634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMp7uWH/N7bIuo3ya5a5ES0R5pph2PC7v2bOFZblKs=;
	b=UePCUnYyXk+PFcNmjuZjGe7zVNvMLNmcSJeQRjtgPCjazAWSSbjS4pMuP7Ta0SIU36tm4D
	MCfNgBWS94mbHNzde6uSIidMAhJcXmwWDb1MCB6UO4XfnnIFx9FuRJ315Mm5kMxxgLiIjW
	QGHVf/44rWLrW24XkBd8N0ja05O0tmY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-jMw3cxmzOluPufTdjGRmdA-1; Fri, 30 Aug 2024 10:37:13 -0400
X-MC-Unique: jMw3cxmzOluPufTdjGRmdA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-371a2dcd8c2so1086242f8f.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 07:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725028632; x=1725633432;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oXMp7uWH/N7bIuo3ya5a5ES0R5pph2PC7v2bOFZblKs=;
        b=tX0LLDlgLzuN6XaftIAOKqOyfWlunyaHuUtFj4cMk4TfixUuAU2IwzCnJEv2Ta+FQM
         JtrFltZ2hyK8VfGZpgjfLsP17zz4SsvDGFe8wl83H31NYr5LQDQhhd/3zfOj/pWMW/sg
         zxByb47/7C6GM4x8UcXYk5i/mxP1QVuhUigEJU7sTJ9mpSJkTWfeVRDtUupX6dlpuzdk
         Rdd0UDYTzCs++3Jm3qiijLS7xhesatqs6cr2P8WqL7wlgdF7EVbyvRrL1eEJ2calf/U+
         idaC0pYHPiXl3zTr2l0O2BZXlKf8vlT7Umk0huqBYwshlUzJGuE7gvQdnpxvovcJdyVZ
         OhnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgkXrav3NTTTi3w7mRooJi5Wt5XeQkZYW9ulgWyey1LQbz0jHeTLLDmETewX+EcT/zUgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzZO2+XkgZdUXXG6qXoCiY3KggJLSRlm/5da/VjAZ8+Di4t6Lh
	GDPZiyZevuxcrlOfm+HtaHEt3cO+2KZwDlyW+ICWm8rn2kMzhAqEA9eNnTxlVBlsJwuD7Xjul2Z
	oY8/39ZKZrc6yRtvswVVtz/2Nt7iYd2EZporkFp/9xGvJAq/B5A==
X-Received: by 2002:adf:e105:0:b0:371:8a3a:680a with SMTP id ffacd0b85a97d-3749b56145amr4121125f8f.32.1725028631778;
        Fri, 30 Aug 2024 07:37:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFYgXNQ2yY6fOL1KrOlEnGq7ndk/i4ruj17NaJHBuCgglUICGU9LPO8teX4/pN12Jf+eJJPg==
X-Received: by 2002:adf:e105:0:b0:371:8a3a:680a with SMTP id ffacd0b85a97d-3749b56145amr4121106f8f.32.1725028631239;
        Fri, 30 Aug 2024 07:37:11 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ef81146sm4175385f8f.82.2024.08.30.07.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 07:37:10 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, Yiwei
 Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul
 E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
In-Reply-To: <87seumt89u.fsf@redhat.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com> <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com> <ZtHOr-kCqvCdUc_A@google.com>
 <87seumt89u.fsf@redhat.com>
Date: Fri, 30 Aug 2024 16:37:10 +0200
Message-ID: <87plpqt6uh.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Fri, Aug 30, 2024, Vitaly Kuznetsov wrote:
>>> Gerd Hoffmann <kraxel@redhat.com> writes:
>>> 
>>> >> Necroposting!
>>> >> 
>>> >> Turns out that this change broke "bochs-display" driver in QEMU even
>>> >> when the guest is modern (don't ask me 'who the hell uses bochs for
>>> >> modern guests', it was basically a configuration error :-). E.g:
>>> >
>>> > qemu stdvga (the default display device) is affected too.
>>> >
>>> 
>>> So far, I was only able to verify that the issue has nothing to do with
>>> OVMF and multi-vcpu, it reproduces very well with
>>> 
>>> $ qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s
>>> -cpu host -smp 1 -m 16384 -drive file=/var/lib/libvirt/images/c10s-bios.qcow2,if=none,id=drive-ide0-0-0
>>> -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
>>> -vnc :0 -device VGA -monitor stdio --no-reboot
>>> 
>>> Comparing traces of working and broken cases, I couldn't find anything
>>> suspicious but I may had missed something of course. For now, it seems
>>> like a userspace misbehavior resulting in a segfault.
>>
>> Guest userspace?
>>
>
> Yes? :-) As Gerd described, video memory is "mapped into userspace so
> the wayland / X11 display server can software-render into the buffer"
> and it seems that wayland gets something unexpected in this memory and
> crashes. 

Also, I don't know if it helps or not, but out of two hunks in
377b2f359d1f, it is the vmx_get_mt_mask() one which brings the
issue. I.e. the following is enough to fix things:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..733a0c45d1a6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7659,13 +7659,11 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
        /*
         * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
-        * device attached and the CPU doesn't support self-snoop.  Letting the
-        * guest control memory types on Intel CPUs without self-snoop may
-        * result in unexpected behavior, and so KVM's (historical) ABI is to
-        * trust the guest to behave only as a last resort.
+        * device attached.  Letting the guest control memory types on Intel
+        * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
+        * the guest to behave only as a last resort.
         */
-       if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
-           !kvm_arch_has_noncoherent_dma(vcpu->kvm))
+       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
        return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);


-- 
Vitaly


