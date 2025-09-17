Return-Path: <kvm+bounces-57956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A28D0B82381
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 01:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D8B11BC02CC
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD89301484;
	Wed, 17 Sep 2025 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VmfspLlD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A71010E9
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 23:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758150134; cv=none; b=vCS2ui+FHO9ScXLQFnp1bo3HoyQRxWXCR9L8wWOaHOlTV6o/TojB1jUygKe+QL/MPRwJmjRk9AOzXRpewk3FXKWrLHbOd0Uy3ZR19pKIomEwyPeCdCG+2FxOpGCbtzHo7cGyIC0JH29GvvBMNvFqKzSmTBl37MiH8MMyBDPVW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758150134; c=relaxed/simple;
	bh=z9jj/dh0S6W2eXpDU5Up7mrUC508ERUUksMpIvjvSDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J5UC5K0BivzDtpeDQOKbuvLqP8pfU/HxShMXzjLcEbrl+kSxhhAcQRlHW1JujJfaeg7SxQDoR5OPvDnnU7tE/5GQ7Md+GfCtgP0EEiboibypQFIleXyLGoJY9FfQwAoiemezTysTRti6I5r7yUh5Y/Hk6lxWseKd0qvnNmcEfKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VmfspLlD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329dca88b5aso1524210a91.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 16:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758150132; x=1758754932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXvv08vlixvMjyF5WhKNg9FBBdv11ZBTjvJpc8LmO1w=;
        b=VmfspLlD3G1KH3N9KJ1jNlFurUd1C85SDebTmy2poYgXVKg/LXnR+YaB/xWOd1O6MQ
         MduFC9Wkk8gUEglRIMJWgbjV14iSBkoKeA0AvdLfnVkyGj/snS+XuYSJavgsANKYecxz
         0RpelMdK3AlF44K1Izkujvd5Pu2tVK2WN+z+CSBrNFbsHSLizVsO6T2phYksjY3ggKiO
         NI8IpKLXYKYBsxbeu1FRPlgc2Q/Nhtvlc3y/oSIj0ulpKx52t3zHDt2GRshz5zguoTXe
         fY1ZlUjpRh8cYXGtR40DNUGaiO+nF+hPzsbJXbDU+voaFtdpOkTXEsc1U48oDYpmO6AS
         oZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758150132; x=1758754932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uXvv08vlixvMjyF5WhKNg9FBBdv11ZBTjvJpc8LmO1w=;
        b=WzPSSd36GfgRbux4VCL5lgbknmQ6vU3nGZKjdhJdtrlt6HB2sKIrrvOVShA4hoVTB3
         ZZ59X27RfNBxB+Bq71MZArC4qOJ7Q35eL1FbUofW76oIFmkgXXqDnOpXsgG36uMISrwm
         eCeN8pFirg3ei3qOqj8LaLao1Og7fzkzQ2veOEuPne8LSKmTxOZqcXB13yt1i05dHEPG
         Hb49eH/rVcdK5Cs+0dcCK7rTRf7REzG8mpnIJiBLPIfDWOV9510GtsA+0JDtK4WCAtZT
         C3tZkVnBsj404V4/7C7SV8QRO4YP/QQyEmoSXi7ULgVys78MYM4VGmZskP/1XnM5jOdQ
         YMNg==
X-Forwarded-Encrypted: i=1; AJvYcCXzLwE20TZy5zD/YeOVNpBiyktx5B/wfvVJgBABQvA4yY5omljOLaRiJOnotZJ5kYkX1dc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx43iExhPtj1SVyrhgPeGzuzDF3iytO0Axj5M5ndCyd86s27kN6
	S0MY4ZePXbK2VgTjQ330lairQsf8dravBzZWcdbVN+vvUquvNsYWDR42L7Zn03NGVprVO04Ft8d
	IGRzvQQ==
X-Google-Smtp-Source: AGHT+IEmHTqPKDw85gYpQLyZoWz4mHqPlxsjsZ3kfl9YZfHWLosdKTXZ1EF54fp4ZzNMDipJWOGGvUoBfQY=
X-Received: from pjkk4.prod.google.com ([2002:a17:90b:57e4:b0:327:e021:e61d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a84:b0:32e:3592:581a
 with SMTP id 98e67ed59e1d1-3305c6e438emr1476768a91.17.1758150132332; Wed, 17
 Sep 2025 16:02:12 -0700 (PDT)
Date: Wed, 17 Sep 2025 16:02:11 -0700
In-Reply-To: <e0ce7a92-f8e4-406c-a7dd-c59c8d541d0b@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909182828.1542362-1-xin@zytor.com> <20250909182828.1542362-6-xin@zytor.com>
 <aMmk0lUJ8gs7OBw-@google.com> <e0ce7a92-f8e4-406c-a7dd-c59c8d541d0b@zytor.com>
Message-ID: <aMs986QHpDqk-MSR@google.com>
Subject: Re: [RFC PATCH v1 5/5] KVM: Remove kvm_rebooting and its references
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-pm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, pavel@kernel.org, brgerst@gmail.com, 
	david.kaplan@amd.com, peterz@infradead.org, andrew.cooper3@citrix.com, 
	kprateek.nayak@amd.com, arjan@linux.intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, dan.j.williams@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 17, 2025, Xin Li wrote:
> On 9/16/2025 10:56 AM, Sean Christopherson wrote:
> > On Tue, Sep 09, 2025, Xin Li (Intel) wrote:
> > > Drop kvm_rebooting and all related uses.  Virtualization is now disabled
> > > immediately before a CPU shuts down, eliminating any chance of executing
> > > virtualization instructions during reboot.
> > 
> > Wrong.  KVM clears EFER.SVME in reponse to kvm_shutdown(), and thus can trip
> > #UDs on e.g. VMRUN.
> > 
> 
> This patch assumes that AMD SVM enable/disable has been moved to the CPU

Ah, that wasn't exactly obvious.

> startup and shutdown routines.  Accordingly, kvm_shutdown() no longer clears
> EFER.SVME, and the patch demonstrates the resulting simplification from
> removing kvm_rebooting.  However, as noted in the cover letter, no actual
> modifications were made to AMD SVM.

Heh, yeah, that's what's wrong.

