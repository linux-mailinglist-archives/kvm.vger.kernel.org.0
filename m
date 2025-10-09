Return-Path: <kvm+bounces-59714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5E8BC920C
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA0624FA6D7
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077232E6CD3;
	Thu,  9 Oct 2025 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ln7bmxsH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D96A2E5B0D
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 12:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014383; cv=none; b=HAI3zISEPpHbgHX02u2Oit+OHytQBba9RjZMofdqJUDv+EBorN9vK6B76gg2DLhT8Z/Xq3K5F/19bWOBjQx5ASwPmRUoH2Vpi9cYAYONfCn2qU/JLIfpgXuRbWgaoLFZWKMQtUd+uzQQsssUw8Pc7x6ELXFMee1we2N31VRa9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014383; c=relaxed/simple;
	bh=X8mJTyar/juDqkVpENiOV+AphX1e6sbRKy+cvFNi8Iw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mgF3a0PD6XR7KZADGC+Ucm36ETEUa+zHRk8U6mhEIWNr3Iics+4Hd6Q0272k+HC8Y+0XRhh25dJBe0KBNhGwXIeIIUJAzgafalCnFxLp13bqMTOlITIO48lKUm8ZfYZn5b7et4Tn+xaDIilhjRjmrEIbNCANv53mNPIbPciSNQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ln7bmxsH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760014380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+waPU4EoP1XKdkvMFZASVqNI18Mpmp7i8qiR8k7lEjg=;
	b=Ln7bmxsHrrmN9XxwIktjh2zDb3vI8jeh+OYY4HZ2u2VC1kolyPp+guUhKe3G7rOugnEMSL
	r3y0+gBMrZDWbs2GN/QNOcGqzGrX8BIgtu7CeWVcnoAwYWnMsy1MSr2R6qw3naoca+Y3pU
	ChSUoV9BeIiJJFpv5xwAXOCw+AYR7GI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-odhYKX9YOMO7IgBzHHrEAA-1; Thu, 09 Oct 2025 08:52:59 -0400
X-MC-Unique: odhYKX9YOMO7IgBzHHrEAA-1
X-Mimecast-MFC-AGG-ID: odhYKX9YOMO7IgBzHHrEAA_1760014378
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f384f10762so739469f8f.3
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 05:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760014378; x=1760619178;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+waPU4EoP1XKdkvMFZASVqNI18Mpmp7i8qiR8k7lEjg=;
        b=GOohE6rLMRh1Mt4IU8XICXQojDEQjXNudA3FL8uZSR1eO6Mei7TEdEQrehUi/jI2v5
         4CWMDe5yfNChANukwDIXQIFwRMVnUSIo65qK8d7fYAc78/2igPZ8tpFI6bjnxG86RNNa
         J+rI41SA/6X+ztmwfmZNforlmpSE7mjnBSgl7JVbGMGZ+30IV9vtcE4Q5HuXt7wdGRQQ
         YUJg3ASJOJtQJoLThRjRPTwyB4tGJUcqZD2+iVb6bkYpSbeVIN37SMOYC23kP0NK4c/h
         Z+KuhiNnLgQTA4Pg7eF/gqmc/FIPHu0eh6C+J3RwjuTlWA1beDc4rmsmWJhFbraMabn2
         voAg==
X-Forwarded-Encrypted: i=1; AJvYcCW/zWuA2n+prXK8nghoX0XJ7H4XiDu+k99jDvMy7VCeVjSWNVkFrcQd8UIZ8bjDFNQSI60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye/IW+YoN4Va7gIf3aJEc3J31pFz1IJbP4uspOCkKVExJkbzDB
	pHyN9MGFUt8gpfhbIRkeQakV3H3ZAZSiat+EbmXWPPP9rYt3NErWbLtFr2qGLfpYoTMQppgCMyO
	S3UHL0zL9UFAo5AgB4I6/vEyCXjqy22U+Uiuzt+6pB3LvOXDO1a+6Rw==
X-Gm-Gg: ASbGncv8vr9XnKg1n32Oyph0zumeO/yREBVegkcqoH+AJtjSdwEgwhDhB5fdH1ULsFN
	/6W08fw40jKQkYDeE1WL1XSHR1hG2FM3TxQzsaij4GV36TXm4FXqlArkjpWY7LAKmMXVS7t9mlc
	MP9fp7TGMaxJbTiHai9D9exwlirfW486N983QqphDB1bgnYsdCVAEsYcbxelpKuWRTpcvJy93Hk
	rI4LARmOeXJHvj+OUTmkatJH4eD2Nn9g+tyZ8QNx/PSiUEoP5GFpNo5WPFSxTo4m2A6F1CXuccp
	09sB7fQPtfUmpZIvpr/XGbpKaQeEn4LInz7ijk193A==
X-Received: by 2002:a05:6000:2c06:b0:40f:5eb7:f23e with SMTP id ffacd0b85a97d-42666ab2b15mr4101216f8f.1.1760014377899;
        Thu, 09 Oct 2025 05:52:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6sYUNnJKtLYymNGyZnaS/EKYVGpmsOe8naPHzyYPhk9811ZTFpkCfmibAqOb5QeKoOkS8AA==
X-Received: by 2002:a05:6000:2c06:b0:40f:5eb7:f23e with SMTP id ffacd0b85a97d-42666ab2b15mr4101201f8f.1.1760014377497;
        Thu, 09 Oct 2025 05:52:57 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e97f0sm34348382f8f.27.2025.10.09.05.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:52:57 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Jinpu Wang <jinpu.wang@ionos.com>, Sean Christopherson <seanjc@google.com>
Cc: fanwenyi0529@gmail.com, kvm@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 linux-kernel@vger.kernel.org
Subject: Re: Hang on reboot in multi-core FreeBSD guest on Linux KVM host
 with Intel Sierra Forest CPU
In-Reply-To: <CAMGffEmin4HAwoQUjkkoq+_z0sherZcCnkXgMu4PahnM8UmO+A@mail.gmail.com>
References: <539FC243.2070906@redhat.com>
 <20140617060500.GA20764@minantech.com>
 <FFEF5F78-D9E6-4333-BC1A-78076C132CBF@jnielsen.net>
 <6850B127-F16B-465F-BDDB-BA3F99B9E446@jnielsen.net>
 <jpgioafjtxb.fsf@redhat.com>
 <74412BDB-EF6F-4C20-84C8-C6EF3A25885C@jnielsen.net>
 <558AD1B0.5060200@redhat.com>
 <FAFB2BA9-E924-4E70-A84A-E5F2D97BC2F0@jnielsen.net>
 <CACzj_yVTyescyWBRuA3MMCC0Ymg7TKF-+sCW1N+Xwfffvw_Wsg@mail.gmail.com>
 <CAMGffE=P5HJkJxh2mj3c_oh6busFKYb0TGuhAc36toc5_uD72w@mail.gmail.com>
 <aOaJbHPBXHwxlC1S@google.com>
 <CAMGffEn1i-qTVRD+9PWDfNUMvbBCp9dV2f=Cgu=VLtoHs-6JTA@mail.gmail.com>
 <CAMGffEmt2ZEL3uxRd+mWkKB=K8Q3seo9Kp-T06rZahxsX4Wm4Q@mail.gmail.com>
 <CAMGffEmin4HAwoQUjkkoq+_z0sherZcCnkXgMu4PahnM8UmO+A@mail.gmail.com>
Date: Thu, 09 Oct 2025 14:52:56 +0200
Message-ID: <87bjmg8cev.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jinpu Wang <jinpu.wang@ionos.com> writes:

> On Thu, Oct 9, 2025 at 1:21=E2=80=AFPM Jinpu Wang <jinpu.wang@ionos.com> =
wrote:
>>
>> On Thu, Oct 9, 2025 at 5:44=E2=80=AFAM Jinpu Wang <jinpu.wang@ionos.com>=
 wrote:
>> >
>> > Hi Sean,
>> >
>> > On Wed, Oct 8, 2025 at 5:55=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>> > >
>> > > Trimmed Cc: to drop people from the original thread.  In the future,=
 just start
>> > > a new bug report.  Piggybacking a 10 year old bug just because the s=
ymptoms are
>> > > similar does more harm than good.  Whatever the old thread was chasi=
ng was already
>> > > fixed, _10 years_ ago; they were just trying to identy exactly what =
commit fixed
>> > > the problem.  I.e. whatever they were chasing _can't_ be the same ro=
ot cause,
>> > > because even if it's literally the same code bug, it would require a=
 code change
>> > > and thus a regression between v4.0 and v6.1.
>> > Thx for the reply,  it makes sense. I will remember this next time.
>> > >
>> > > On Wed, Oct 08, 2025, Jinpu Wang wrote:
>> > > > On Wed, Oct 8, 2025 at 2:44=E2=80=AFPM Jack Wang <jinpu.wang@ionos=
.com> wrote:
>> > > > > Sorry for bump this old thread, we hit same issue on Intel Sierr=
a Forest
>> > > > > machines with LTS kernel 6.1/6.12, maybe KVM comunity could help=
 fix it.
>> > >
>> > > Are there any host kernels that _do_ work?  E.g. have you tried a bl=
eeding edge
>> > > host kernel?
>> > I will try linus/master today.
>> > >
>> > > > > ### **[BUG] Hang on FreeBSD Guest Reboot under KVM on Intel Sier=
raForest (Xeon 6710E)**
>> > > > >
>> > > > > **Summary:**
>> > > > > Multi-cores FreeBSD guests hang during reboot under KVM on syste=
ms with
>> > > > > Intel(R) Xeon(R) 6710E (SierraForest). The issue is fully reprod=
ucible with
>> > > > > APICv enabled and disappears when disabling APICv (`enable_apicv=
=3DN`). The
>> > > > > same configuration works correctly on Ice Lake (Xeon Gold 6338).
>> > >
>> > > Does Sierra Forest have IPI virtualization?  If so, you could try ru=
nning with
>> > > APICv enabled, but enable_ipiv=3Dfalse to specifically disable IPI v=
irtualization.
>> > Yes, it does:
>> > $  grep . /sys/module/kvm_intel/parameters/*
>> > /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr:N
>> > /sys/module/kvm_intel/parameters/dump_invalid_vmcs:N
>> > /sys/module/kvm_intel/parameters/emulate_invalid_guest_state:Y
>> > /sys/module/kvm_intel/parameters/enable_apicv:Y
>> > /sys/module/kvm_intel/parameters/enable_ipiv:Y
>> > /sys/module/kvm_intel/parameters/enable_shadow_vmcs:Y
>> > /sys/module/kvm_intel/parameters/ept:Y
>> > /sys/module/kvm_intel/parameters/eptad:Y
>> > /sys/module/kvm_intel/parameters/error_on_inconsistent_vmcs_config:Y
>> > /sys/module/kvm_intel/parameters/fasteoi:Y
>> > /sys/module/kvm_intel/parameters/flexpriority:Y
>> > /sys/module/kvm_intel/parameters/nested:Y
>> > /sys/module/kvm_intel/parameters/nested_early_check:N
>> > /sys/module/kvm_intel/parameters/ple_gap:128
>> > /sys/module/kvm_intel/parameters/ple_window:4096
>> > /sys/module/kvm_intel/parameters/ple_window_grow:2
>> > /sys/module/kvm_intel/parameters/ple_window_max:4294967295
>> > /sys/module/kvm_intel/parameters/ple_window_shrink:0
>> > /sys/module/kvm_intel/parameters/pml:Y
>> > /sys/module/kvm_intel/parameters/preemption_timer:Y
>> > /sys/module/kvm_intel/parameters/sgx:N
>> > /sys/module/kvm_intel/parameters/unrestricted_guest:Y
>> > /sys/module/kvm_intel/parameters/vmentry_l1d_flush:not required
>> > /sys/module/kvm_intel/parameters/vnmi:Y
>> > /sys/module/kvm_intel/parameters/vpid:Y
>> >
>> > I tried to disable ipiv, but it doesn't help. freebsd hang on reboot.
>> > sudo modprobe -r kvm_intel
>> > sudo modprobe  kvm_intel enable_ipiv=3DN
>> > /sys/module/kvm_intel/parameters/enable_ipiv:N
>> >
>> > Thx!
>> +cc Vitaly
>> Sorry, I missed one detail, we are use hyper-V enlightment features:
>> "+hv-relaxed,+hv-vapic,+hv-time,+hv-runtime,hv-spinlocks=3D0x1fff,+hv-vp=
index,+hv-synic,+hv-stimer,+hv-tlbflush,hv-ipi."
>>
>> did a lot tests with different features, and looks the hang is related
>> to  +hv-synic,+hv-stimer.  hv-synic seems the key which causes boot
>> hang of Freebsd 14.
>>
>> But the problem seems fixed with FreeBSD 15?  I guess it's this fix:
> https://reviews.freebsd.org/D43508
>
>>
>> Seems it's a bug from freebsd side, rather than on kvm side to me, but
>> I'm puzzled by disable apicv helps?

In theory, FreeBSD should work well even if KVM is misdetected as
genuine Hyper-V. Apparently, our emulation is not 1:1 and there are
subtle differences which cause the hang. I did not look at FreeBSD code
at all but my wild guess is that SynIC/stimer are not disabled properly
upon reboot and this causes the problem. If we somehow manage to find
how genuine Hyper-V's behavior is different, it would make sense to
update KVM/QEMU to match.

--=20
Vitaly


