Return-Path: <kvm+bounces-17203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B023E8C2935
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FB7A287177
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B3D18AE4;
	Fri, 10 May 2024 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3PyL4KM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2017C7F
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715361961; cv=none; b=hgO52E3eM08j4BC6P9I3CUR6sph9DLkUZchzbi6MmpprNXJI5K9/fjENAW0h03Tw0DNi50chwyfE8n1/teLx2k40OwIlWmpAAYemtM9d1uaeMPgnWjy5nOlTGMiGso+JkBqp1MRXVAKEKF/75M5Tjmk5uFFMFCvvRcEq14ON00E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715361961; c=relaxed/simple;
	bh=EsLzXB6Gs7ZQtkmepgwzqKCcyMI9oEm1j34c4xvtcr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FdoXJ9cM8pDID/vggEqyfno18o7qaghHrmSTq9XEtuXNNk9fKQgRu4n/hcx9o0IbnybhnxB2FMDsdL9b93HOv5pWLCYMZrJD5eZGkzaryWAR3LJo3txBwX4L/vI4CkAKplDO7xb3XrQ6xwdxv1TI51TnPqSalaMrUFGCYRAP4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3PyL4KM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715361958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0uH1Y67e/JYlAU3ZBz+NOGOD31UpxofQKkMvjjtZOo=;
	b=B3PyL4KMWG8JrfSUt9u0R13Z0rD/l7579LapQosR7gGZUYdtBL7DMRuuXPQqo5NuoUJhh/
	n6dfr+rg7ghPBGKlw81fUTqHH7kLMQFcZksRM1/Eg+6/CgsCvHvPsPB0nEpt1IMUyjiiDC
	HidG8cZ1Hwj8OdTqYc4MHSbSyFZaEwE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-D72UJ21ZM365ZA16NWTGPw-1; Fri, 10 May 2024 13:25:48 -0400
X-MC-Unique: D72UJ21ZM365ZA16NWTGPw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51fa975896eso1917391e87.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 10:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715361947; x=1715966747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0uH1Y67e/JYlAU3ZBz+NOGOD31UpxofQKkMvjjtZOo=;
        b=SoQzPMktqsP2QKwIlQltJriVVxgXUH1TQG70+aOYeYtE04LWCOfqK4yveXBvOC2g6G
         n6QAwV8NlLs35SBrcJP5e2UWWvASZgk0dP8Jhn48IAQ+GQGwwSvzr9df9fVTj0Pwy6kY
         /9I73BKuAaBiy+VzoQW9uTBS8eN8iL0pcCd5A3c/EMujnhZUXJimSpGzBSrD4Vnx06qi
         19VDdZgYOIfDE1HDx6Dtsng8k7vV2uIkg3JUFrAAEl2bU/8YBvndPZle/9kcgdt9Aafi
         rbDfLTuLOCq/x0gwW9cfyyweykC4APJbUzR7HmWStdDhUb3odUeko4VwHU+8QKjhyVnn
         /0KA==
X-Forwarded-Encrypted: i=1; AJvYcCUlyNtWnhcjlcCnE31q3A+WeVVCL3CFQbn5FHDluHB/Df6xN9ogqIKISZGRysJU1CX619ul7bwKQmXc+bnqA0cyj74h
X-Gm-Message-State: AOJu0YwUTRy4ClGDn/ifiJ8aWYmpHPy36/O7A32PkNPzoG4/LkC1RpUh
	0fyEt2g+L5emVzwyY8CjDh2uTxJN/Wo1uargciM1Dj7yI3gUw9RFvKTFMIIAJWBDFTL0nOVLrW2
	cgbN+KQKli93JRcEzbs7695zASNnHGnJ6AFD8hp4YFqreOZdipi3GOLHdz1nwL5Jl852uOpQVeO
	Av+Lq8aEY7ZhNnT4BmTJX8FGoJ
X-Received: by 2002:a19:a40f:0:b0:522:f6:9268 with SMTP id 2adb3069b0e04-5220fc7eed8mr1904828e87.31.1715361947339;
        Fri, 10 May 2024 10:25:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+3UgqTDnmRVAiNjyATZxMd/ldNZtXGyYEy7zEh+oH8PVqYii06B+EkIez4lJParuMv/x2eUO16iD1lvVu4gU=
X-Received: by 2002:a19:a40f:0:b0:522:f6:9268 with SMTP id 2adb3069b0e04-5220fc7eed8mr1904804e87.31.1715361946880;
 Fri, 10 May 2024 10:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <20240510015822.503071-2-michael.roth@amd.com>
 <Zj4oFffc7OQivyV-@google.com> <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
 <20240510163719.pnwdwarsbgmcop3h@amd.com> <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
In-Reply-To: <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 19:25:34 +0200
Message-ID: <CABgObfaJaDr38BsTYRrMQzYr-wK8cLW+TJr5ewsgBEcm8ghb3g@mail.gmail.com>
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024 at 6:59=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> Well, the merge window starts next sunday, doesn't it?  If there's an
> -rc8 I agree there's some leeway, but that is not too likely.
>
> >> Once we sort out the loose ends of patches 21-23, you could send
> >> it as a pull request.
> > Ok, as a pull request against kvm/next, or kvm/queue?
>
> Against kvm/next.

Ah no, only kvm/queue has the preparatory hooks - they make no sense
without something that uses them.  kvm/queue is ready now.

Also, please send the pull request "QEMU style", i.e. with patches
as replies.

If there's an -rc8, I'll probably pull it on Thursday morning.

Paolo


