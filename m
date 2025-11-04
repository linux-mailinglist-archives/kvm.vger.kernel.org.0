Return-Path: <kvm+bounces-62006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DD933C32790
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7D06F4EAA37
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CE633DED2;
	Tue,  4 Nov 2025 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQhZ1VZc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48252333427
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278958; cv=none; b=MPrnh403eDceSBfj4271Qkie4fTqdIoX31QF201Kdj2Ot1ImWSfD54uK8Q+rpuco1HLq2wiIb9XBaRLXqPx0Q8NJZA59DtjeIjZpE+82vJueukMVXqa5zyIXuLV7jQgCQ9OwDLxnE8mguUnd0NYhPgxUtM6p3IHGE1bVuM5MtqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278958; c=relaxed/simple;
	bh=BUYcGl9NZGpuOAWhoQj8GR5JI856Kts3SQBxJmzRUIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZJAARmXmuPQo9ayT5ay9Ofad7I1W0fA0Thd5A7XXlsDRNK643eJ2Aynxoh4G1EmtVodk8pufEImFO+o8Njdo+u2hVsiclwebNQthwVH5jkl3S2+Tu0UXyNRhu74MLry52jqB77YGgSSz39rqSnGL08jQLBhznAjobEVtk4ThcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQhZ1VZc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295395cedafso64842065ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278957; x=1762883757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HabTony5q8jGMwRLhhSbUAct1TYC0rmzBuxU6atPXUo=;
        b=rQhZ1VZcL7U9hHL60TUJBY7VrgCzXgEEHoitcd/tFmHvnrQkjDxScZiG/YWOEKb8O5
         oZ8HKf9Sv5QawXrk6fdgyErKhRHXJmhHAFU3HD5OThSiGatzcbrjZcMW24bniCIxg479
         YfoUw2w26AYarBt2DUEPHKH53y4inem1CnTvgSFuLenuCz2halMDPgNsj/xMCSUx/iGl
         Sg3K9fuMnAy7iLYbJn3paa+fTRtnm1+MGkCRKDsXkSDO4UTASl4xPEkTuOwq7F5GSUvE
         acCngVLu+oqj5bdja3brrFXXCVl7Gw/CRW7Be1h7T+0o8laXNEfmlYiVkOSLTo5OT16a
         pUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278957; x=1762883757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HabTony5q8jGMwRLhhSbUAct1TYC0rmzBuxU6atPXUo=;
        b=XDgFKngaq2KKTh/5zCBXm2dYf6dMFMDc70YaFt0sJgW359zo3agG2eD2ccLN9XQlUx
         fLjakDwLrc2seVRw6ZggKQoxrqZ/NJkDU/GU9N59qHX+sA4Z/+wh7bdnO5NhZLPAtqj7
         QF0QulZaRPqLZDYhjsB87EQFswHikXJYHCJ3lMbuhgelbp7XILtAmEmCvFgfNosJR975
         yYcBioXbLU43Tt4RIXy8PMTf6oZCcKUmHYzEIZ6flsxkjb3dks/7xawcz5FbkuJVFtQi
         MxyZOroz6B1sSaHu3aKfHSYAyAh/3FewaMuH+d32rOXUVMjp6QCKxeeCBdq5xACmE3XK
         xEjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEZeSWkzMgFrLnX5XtkowUGD7QI/HbBe8G7f446FXUE2dkHAFoBLxal1PM4AmKxq912iE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwseXsPuBP47wQB6MIcFOJJ+n8qHLgENnu+AZdMIN0I2Oigj0vM
	ssmDqyhritsT7VaIn473aEqAWXTs+afqwRhz7hndObdK8dmgBrLTh+2red6zBhcPu+GW0Vy5V1y
	jTHk8sA==
X-Google-Smtp-Source: AGHT+IGCC3k5DOGjKU381UnrWK5meBDp0CQEAkWKfU/p8BnI8t61V9nT/piCEqlmbyG4yA03Pg0rxUssPWM=
X-Received: from plbkf3.prod.google.com ([2002:a17:903:5c3:b0:295:fb8:7fb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f550:b0:295:68df:da34
 with SMTP id d9443c01a7336-2962ae56047mr5899775ad.53.1762278956590; Tue, 04
 Nov 2025 09:55:56 -0800 (PST)
Date: Tue, 4 Nov 2025 09:55:54 -0800
In-Reply-To: <aQnH3EmN97cAKDEO@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com> <20251030191528.3380553-2-seanjc@google.com>
 <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com> <aQmmBadeFp/7CDmH@yzhao56-desk.sh.intel.com>
 <969d1b3a-2a82-4ff1-85c5-705c102f0f8b@intel.com> <aQnH3EmN97cAKDEO@yzhao56-desk.sh.intel.com>
Message-ID: <aQo-KhJ9nb0MMAy4@google.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 04, 2025, Yan Zhao wrote:
> On Tue, Nov 04, 2025 at 04:40:44PM +0800, Xiaoyao Li wrote:
> > On 11/4/2025 3:06 PM, Yan Zhao wrote:
> > > Another nit:
> > > Remove the tdx_user_return_msr_update_cache() in the comment of __tdx_bringup().
> > > 
> > > Or could we just invoke tdx_user_return_msr_update_cache() in
> > > tdx_prepare_switch_to_guest()?
> > 
> > No. It lacks the WRMSR operation to update the hardware value, which is the
> > key of this patch.
> As [1], I don't think the WRMSR operation to update the hardware value is
> necessary. The value will be updated to guest value soon any way if
> tdh_vp_enter() succeeds, or the hardware value remains to be the host value or
> the default value.

As explained in the original thread:  

 : > If the MSR's do not get clobbered, does it matter whether or not they get
 : > restored.
 : 
 : It matters because KVM needs to know the actual value in hardware.  If KVM thinks
 : an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
 : value into hardware when returning to userspace and/or when running a different
 : vCPU.

I.e. updating the cache effectively corrupts state if the TDX-Module doesn't
clobber MSRs as expected, i.e. if the current value is preserved in hardware.

> But I think invoking tdx_user_return_msr_update_cache() in
> tdx_prepare_switch_to_guest() is better than in
> tdx_prepare_switch_to_host().
> 
> [1] https://lore.kernel.org/kvm/aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com/
>  

