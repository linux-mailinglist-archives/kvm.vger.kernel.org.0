Return-Path: <kvm+bounces-32971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B80BC9E3079
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C314281FCA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AD25227;
	Wed,  4 Dec 2024 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C5FGDZgo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8311FA4
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733273407; cv=none; b=FGgtos/4Bfnr60R8Wd2eyqWkOqmvBkQExSXuDSvMAXgnsv3GhgABMX+AohMjYyOH38H30xN+QwT2CocViP4RsJcHM8wQrOeWfkIF6DpGmhLQUhY96X1I7LItXOHF+Acia7Vm+Kqws537N+r0I7iyvOEpZNSAj2BRDQjOgZozj2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733273407; c=relaxed/simple;
	bh=KMybNKJa6HXPkJyY3evuV9cRNIrcl39P7pBoeOSIbE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WkCBUrT+877h3Ti7y1IvNMsboZ/mCBPiea0aMYpXGSbxMBFbpuLbHKlsbZor3PbH5+ILJcgW7V4ABeCpbw4QOhyDT5SoIBF2nMU0v2oYA+EpmCz/8QJ8EYZe+Hb7B6o0zLDiG7fIPFalu4KoDI6LBuVZsn/Gz638enoyn0xXUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C5FGDZgo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee5f6fa3feso6176019a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 16:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733273405; x=1733878205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/4oU1vpIu322T3uD3MqvxDC01OZZ/wF6FgrljBVKQg=;
        b=C5FGDZgohOGHHAx9SyFOlFYhjs80esmPHXtsmbn0UMGr29fRvlSyXfFjY2J3AHPHFH
         CASqqYrAFkS1hbk1HK5uc8wOE4P3iMIcax9TwLJClEMAEF9EJrLpvUuXF0a8lWsnryaN
         yt+uYmjCAsmP7bTOT7gX3t7zw7z1mrMXqJk/dfYF+tdr5oM2eHBn+o/MfwwDbwqFB/av
         Y0WGt9vHgnZjcuB6r3hp4s4NjLm0ZrE7sTuJ8w6emfzmaPbANORdC5CfMw3I0q6KTY4Y
         7Q8UwcnxMbgZZShj/MoJDK/JkZ0GhUbyStXqmSojtmFSUv0qRItwd60P/94bK1/JY8tF
         XFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733273405; x=1733878205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/4oU1vpIu322T3uD3MqvxDC01OZZ/wF6FgrljBVKQg=;
        b=im65zywMehFGHJ236JuSE45PzTx1dSUoCHA++im+Q+X/PxVZHRQI33OQkrH3eSchwE
         JqJIck4NDNVFpdWiULvgZnr9uJ5JGKaa2cOMNmC3VEGXugQHQx73a2ujxoUNVHA4C176
         6SwJQUZE4EtZKcribLjLS6lLylgMOW0a4mbUFkyI09SBAw3WsVEopsKQBMTvf5fcZIFH
         M/EGDtOSS/0zlwqlg7hsp7dK1yGDJt82Xk0eVqijj3WlXTLW6OvZV4nJl6KbIxpYfsrQ
         wyQGCU83H5rIo6bKxMaaXijX+YmhGHJXoCiEpdL7pNIxOZFLu36Akn4dihU6u6x2eTsm
         tK6w==
X-Forwarded-Encrypted: i=1; AJvYcCVd7g7HnrOeh3kQ1BbKFiNCidZMUr26VwQ/zEtfLjrsB8FYYOoTTftcKGsU8pKRAuDvS5U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxeg3kJXz97PScsr7xnMt7Xz6eYP903OB9Q3iI1pGn0MEo+N9dB
	YExxGwLaZGp3DjV13OJf4QXiOHMGa2u9lT3AjWc3oWqfrZdYpEpAk33Gcc5HmJQdi7Jrs75MFGp
	w5g==
X-Google-Smtp-Source: AGHT+IGetD+k1LiPtdGDtPCALjWPT0cRMYF9pgZzkeaWbjBEos1LRP8RMAbDbrQ+niFK+QYtksQM6BeyJH4=
X-Received: from pjbsb8.prod.google.com ([2002:a17:90b:50c8:b0:2ea:6b84:3849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e81:b0:2ee:b26c:10a0
 with SMTP id 98e67ed59e1d1-2ef0125b0e3mr6902810a91.24.1733273405136; Tue, 03
 Dec 2024 16:50:05 -0800 (PST)
Date: Tue, 3 Dec 2024 16:50:03 -0800
In-Reply-To: <c09a99e8-913f-4a86-ba0b-c64d5cdcfb2e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202214032.350109-1-huibo.wang@amd.com> <Z05MrWbtZQXOY2qk@google.com>
 <c09a99e8-913f-4a86-ba0b-c64d5cdcfb2e@amd.com>
Message-ID: <Z0-nO-iyICRy_m5S@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Convert plain error code numbers to defines
From: Sean Christopherson <seanjc@google.com>
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, KVM <kvm@vger.kernel.org>, 
	Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 03, 2024, Melody (Huibo) Wang wrote:
> Hi Sean,
> 
> On 12/2/2024 4:11 PM, Sean Christopherson wrote:
> 
> > 
> > E.g. something like this?  Definitely feel free to suggest better names.
> > 
> > static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
> > 					       u64 response, u64 data)
> > {
> > 	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
> > 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
> > }
> > 
> If I make this function more generic where the exit info is set for both KVM
> and the guest, then maybe I can write something like this:

I like the idea, but I actually think it's better to keep the guest and host code
separate in the case, because the guest code should actually set a triple, e.g.

static __always_inline void sev_es_vmgexit_set_exit_info(struct ghcb *ghcb,
							 u64 exit_code,
							 u64 exit_info_1,
							 u64 exit_info_2)
{
	ghcb_set_sw_exit_code(ghcb, exit_code);
	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
}

I'm not totally opposed to sharing code, but I think it will be counter-productive
in this specific case.  E.g. the guest version needs to be __always_inline so that
it can be used in noinstr code.

> void ghcb_set_exit_info(struct ghcb *ghcb,
>                       u64 info1, u64 info2)
> {
> 	ghcb_set_sw_exit_info_1(ghcb, info1);
> 	ghcb_set_sw_exit_info_2(ghcb, info2);
> 
> }
> This way we can address every possible case that sets the exit info - not only KVM. 
> 
> And I am not sure about the wrappers for each specific case because we will
> have too many, too specific small functions, but if you want them I can add
> them.

I count three.  We have far, far more wrappers VMX's is_exception_n(), and IMO
those wrappers make the code significantly more readable.

