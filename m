Return-Path: <kvm+bounces-19234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAD4902462
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41C411C20E9A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 173C0130AFC;
	Mon, 10 Jun 2024 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1UXYZgOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442438FA8
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718030730; cv=none; b=EHF3bj90CRzBrEKHFcwZJs8e4iYbZo8f+OaPGpUnxEqRawPJSzhtHn9Ty3kZQrV0sydAwBSBodx0fwxbFJZOJ0+Prk8dns8TDyjI+OLHumV6ZgkLh5+PcbLRMzNwftbMgwo0IGn7wQoFFaOU4OlfUISUwVsmjY19PiiFA3GpBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718030730; c=relaxed/simple;
	bh=zEV4hRPa0VisXlSFGCDQxZpseDwnqKy1zCauCMHUIqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QPrtvzuVRsKyfQFt8mdLw37xTnxOl7nWric7VCCaFhjBxan6ZoEv7ute+Lt9Jn8qVa3ymUrDc3TmxgaHWL5g6Zb3pYaEpOEGU6hQx+gLQ0yE+hncUz2Js2hsFZzzdA5LJ5z8OCHc/pzBl4WWmj4KRkkTRPWlUUzDcZDMsRZ5MJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1UXYZgOg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70428cb18c3so10512b3a.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 07:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718030728; x=1718635528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AxX572g9fq1hp8pzJA8MiUyiwis0L08+XjPHETBqvV0=;
        b=1UXYZgOg0Ei876ifHam7sACPUIiJwknrKjw+VIlIqcHSQsWttt8DaIuYtGnySYGAcY
         s4QEYpsCuG47Sbhg9XH3u+phZoS91Bu90mspV6t/hx5wr5UrweW67+kg6uMRNFak5rHL
         626gwsJVSolg5eEkGHZ6JkDoyc8h6XZPQTznwlf8hyzLzxBZA+I3ZdIRp9gzSdLr3gT3
         I7X+c+263LxAe/IHI4gN5yZ02OpF0ciW7zdvPR6APV3/0WGRsh108gH9SlETtuxGqKbM
         7G20yN+tXHplT82fZYTvdytX3nc2oGKwIiOX3sSjTxHdSw9wdWtixZTB1GEPBmHTZsJJ
         xOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718030728; x=1718635528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxX572g9fq1hp8pzJA8MiUyiwis0L08+XjPHETBqvV0=;
        b=sRDWFNiiAIK8syC2amk7cDBVQisvW6PQUnkjL+lu2xTOIJ9J29jN1Rf3AVahHUOGdq
         ZkC/E79trHEbFnc82KddqcUtp+Y+jOQy6WxklbrUinvw1iwz/V++klnhFEDpC40RxFps
         B2o9RXjxb/Pi4CaWR+jNoKuhlBgb2e4YGLb8/PbfM1fNHK8X0WtSB6bUmvCtFpcWeOXs
         UW6+IVepW/f5tnfmlQ3J4hElMTSEkMmncclIu/u/sRI5n9Fhl04TZMKtjHMBzZ+eSVX0
         izeLqH05iOL5fPFBe6Kbu/Zs9PJt1Vodu2A7OuMzum1hKgR5wnX0pqrZYGdX52ErTF3o
         eMmQ==
X-Gm-Message-State: AOJu0YwAVwfX11LvUpGFmKODWxw/ZcnpkWGZfH5tDzEDreTuzN3XJ/QY
	8gq+aveYNNv+oGXnTVtwC47ubQ8/880MSS/+hjrsor8UhNZebEH9Iq3xLxTZwjaw1VCMPk/MYvA
	Www==
X-Google-Smtp-Source: AGHT+IFc+sttX2d0C1ytlDc6iPCgiRszclD3UtAGzJd/5nvPEjXfdvPQ6G7vbSyTPmVN+zUoKvLjgnfhBgw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9297:b0:704:231a:c3fd with SMTP id
 d2e1a72fcca58-704231ac784mr55088b3a.1.1718030728154; Mon, 10 Jun 2024
 07:45:28 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:45:26 -0700
In-Reply-To: <bug-218949-28872-vNF0xS1i0R@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218949-28872@https.bugzilla.kernel.org/> <bug-218949-28872-vNF0xS1i0R@https.bugzilla.kernel.org/>
Message-ID: <ZmcOCPprnmn1vYyn@google.com>
Subject: Re: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 10, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218949
> 
> --- Comment #2 from Gino Badouri (badouri.g@gmail.com) ---
> Alright, it's not a regression in the kernel but caused by a bios update (I
> guess).
> I get the same on my previous kernel 6.9.0-rc1.

The WARNs are not remotely the same.  The below issue in svm_vcpu_enter_exit()
was resolved in v6.9 final[1].

The lockdep warnings in track_pfn_remap() and remap_pfn_range_notrack() is a
known issue in vfio_pci_mmap_fault(), with an in-progress fix[2] that is destined
for 6.10.

[1] https://lore.kernel.org/all/1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr
[2] https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com

> Both my 6.9.0-rc1 6.10.0-rc2 kernels are vanilla builds from kernel.org
> (unpatched).
> 
> After updating the bios/firmware of my mainboard Asus ROG Zenith II Extreme
> from 1802 to 2102, it always seems to spawn the error:
> 
> [ 1150.380137] ------------[ cut here ]------------
> [ 1150.380141] Unpatched return thunk in use. This should not happen!
> [ 1150.380144] WARNING: CPU: 3 PID: 4849 at arch/x86/kernel/cpu/bugs.c:2935
> __warn_thunk+0x40/0x50

...

> [ 1150.380266] CPU: 3 PID: 4849 Comm: CPU 0/KVM Not tainted 6.9.0-rc1 #1
> [ 1150.380269] Hardware name: ASUS System Product Name/ROG ZENITH II EXTREME,
> BIOS 2102 02/16/2024
> [ 1150.380271] RIP: 0010:__warn_thunk+0x40/0x50

...

> [ 1150.380298] Call Trace:
> [ 1150.380300]  <TASK>
> [ 1150.380344]  warn_thunk_thunk+0x16/0x30
> [ 1150.380351]  svm_vcpu_enter_exit+0x71/0xc0 [kvm_amd]
> [ 1150.380364]  svm_vcpu_run+0x1e7/0x850 [kvm_amd]
> [ 1150.380377]  kvm_arch_vcpu_ioctl_run+0xca3/0x16d0 [kvm]
> [ 1150.380458]  kvm_vcpu_ioctl+0x295/0x800 [kvm]

