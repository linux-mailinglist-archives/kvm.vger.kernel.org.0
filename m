Return-Path: <kvm+bounces-27852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7EFE98F232
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D90DE1C2141F
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855BC1A0708;
	Thu,  3 Oct 2024 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQ4B3gQn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3410197A65
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968309; cv=none; b=mjN5uc0jrNjbmuE7NnF8JbXNo7ECkiIqwYXWIf6sDJ9eoyD7F3j6rNVEWA8vpw3hxt8Fx38IdmZg4EQe/LGSpjCg8dRt9fkp16W/lGtlbGVK3BepYYzLG4Ie/NDcgb2A2SAHBqYBDC9wGIQybkGqr1wex4GSzrs215YmwLL4XLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968309; c=relaxed/simple;
	bh=DwqW1KOpkfD/+bz72WDwficYgWCzrBwN/O28xV8y9SU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mBcwSGzeZxZ7ule4dghilqa70SZUGyCKtIBZg09Zg4+lOI2u+VDZOau30qCCfnzuifE2e6WrMnZ7uS842hJuGoxSzFm56DRscF5JziMjwnjg4e6yaqGCRpctJNwgXXf0JkMOr0z2GnAxeKH7dobW5hD41tZyJR/txvEFvmZICIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GQ4B3gQn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727968306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iiNs2nZPpiw6i0Fusuim5CwJCpocFoBnHvV6df3hq4k=;
	b=GQ4B3gQnc2i/9xdeKxFqhyzZegtkG+voPKoBOkwaHJZUwVDRnKtGnmqvFrpSdYYd5cbXOJ
	71tyr02tGMuWgUTNvj3ijDctVAfmDRvSC5TWZ/uAUnZD9XffjN6O4ti7DQKVZtnOmxDyNj
	LozFOw2YFyA42KrInDG2Fcl/0WTgfqM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-CEkr3crjMCuKRl7_ciIPkw-1; Thu, 03 Oct 2024 11:11:43 -0400
X-MC-Unique: CEkr3crjMCuKRl7_ciIPkw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-45826823bb0so16913021cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 08:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727968302; x=1728573102;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iiNs2nZPpiw6i0Fusuim5CwJCpocFoBnHvV6df3hq4k=;
        b=eANjNdnEqtrPxTuIlF5QqL+1QA+NmPvEDvfmmtRQixitDiytx5T4DqD+LY29TxomMY
         D+hLQOHBTEPbLQOfobeREz17dOW75lxTRhM134ViSSvb2fZYNPwatzCyKlJFlI6SyiIr
         EXENBH1+1Y1wFaaASzrCPu5JYTdLRlCh9rWwMmhkq/IkVjSlR/W/KhV1Hg7tym8zhJdU
         rrcqCv7JXod36y0lyzewEOefNvCOkHHbxj7JA58oAVTAUlJeYWowkqxCab32qiWOkAcL
         jlbRIGmKuH+01H/yLsVYxL8BuNLgkemaq9AM4v6Cc5Uilnkg3NdxkiJTms2NO+x87SR6
         FHLg==
X-Forwarded-Encrypted: i=1; AJvYcCXZvE3AKDMwT1SjcVv0YVR7fHBY+xxKk5+lrMYXBvWHPxD07YXGYMc1DOEIFYD5vony5j4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC/HvQR/ecFI0siMSKmZ6+MnOQdpyVXdDUgSIm5R3uFu1U9kiJ
	rbnMMFPh3uHLlbkVHDu3psRJEktbaRPuQnPBl1+jxiuiidfgPWDNwGKl2K3ik5lZ98mOsI3DB04
	NMvyzV9kHGbsWYM2XeCLXGxfJR973gA5KIjrJutHQ7HZQcIlf6g==
X-Received: by 2002:a05:622a:5291:b0:45d:82ef:28bd with SMTP id d75a77b69052e-45d82ef29b5mr91761781cf.8.1727968302454;
        Thu, 03 Oct 2024 08:11:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/UT45mkIMT+x+5daKgCcSleGAnY9SBjieSY6A5r7B8R0VTYzsRXhUI06yMZG8OYYxbusyzg==
X-Received: by 2002:a05:622a:5291:b0:45d:82ef:28bd with SMTP id d75a77b69052e-45d82ef29b5mr91761501cf.8.1727968302098;
        Thu, 03 Oct 2024 08:11:42 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45d92ed4f3esm6287301cf.66.2024.10.03.08.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 08:11:41 -0700 (PDT)
Message-ID: <bafbbf65502f23fd9df4564a2288c6c22d732b2c.camel@redhat.com>
Subject: Re: [Bug 219009] New: Random host reboots on Ryzen 7000/8000 using
 nested VMs (vls suspected)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: bugzilla-daemon@kernel.org, kvm@vger.kernel.org
Cc: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>, Tom Lendacky
	 <thomas.lendacky@amd.com>, Sean Christopherson <seanjc@google.com>
Date: Thu, 03 Oct 2024 11:11:40 -0400
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2024-07-06 at 11:20 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219009
> 
>             Bug ID: 219009
>            Summary: Random host reboots on Ryzen 7000/8000 using nested
>                     VMs (vls suspected)
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: zaltys@natrix.lt
>         Regression: No
> 
> Running nested VMs on AMD Ryzen 7000/8000 (ZEN4) CPUs results in random host's
> reboots.
> 
> There is no kernel panic, no log entries, no relevant output to serial console.
> It is as if platform is simply hard reset. It seems time to reproduce it varies
> from system to system and can be dependent on workload and even specific CPU
> model.
> 
> I can reproduce it with kernel 6.9.7 and qemu 9.0 on Ryzen 7950X3D under one
> hour by using KVM -> Windows 10/11 with Hyper-V services on or KVM -> Windows
> 10/11 with 3 VBox VMs (also Win11) running. Others people had it repeatedly
> reproduced on Ryzen 7700,7600 and 8700GE, including KVM -> KVM -> Linux.[1] I
> also have seen Hetzner (company offering Ryzen based dedicated servers)
> customers complaining about similiar random reboots.
> 
> I tried looking up errata for Ryzen 7000/8000, but could not find one
> published, so I decided to check errata for EPYC 9004 [2], which is also Zen4
> arch as Ryzen 7000/8000. It has nesting related bug #1495 (on page 49), which
> mentions using Virtualized VMLOAD/VMSAVE can result in MCE and/or system reset. 
> 
> Based on that errata mentioned above, I reconfigured my system with
> kvm_amd.vls=0 and for me random reboots with nested virtualization stopped.
> Same was reported by several people from [1].
> 
> Somebody from AMD must be asked to confirm if it is really Ryzen 7000/8000
> hardware bug, and if there is a better fix than disabling VLS as it has
> performance hit. If disabling it is the only fix, then kvm_amd.vls=0 must be
> default for Ryzen 7000/8000.
> 
> [1]
> https://www.reddit.com/r/Proxmox/comments/1cym3pl/nested_virtualization_crashing_ryzen_7000_series/
> [2]
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf
> 

Hi!

Can someone from AMD take a look at this bug:

From the bug report it appears that recent Zen4 CPUs have errata in their virtual VMLOAD/VMSAVE implemenatation,
which causes random host reboots (#MC?) when nesting is used, which is IMHO a quite serious issue.


Thanks,
Best regards,
       Maxim Levitsky


