Return-Path: <kvm+bounces-13535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB9B898654
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B2C31C213E0
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 11:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B09184D12;
	Thu,  4 Apr 2024 11:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="imXQUNzc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173A47350E
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712231182; cv=none; b=HYaCmvYIivqF3E3Rf0/zyUUUh1+bv5T3bSbG096XsWh8Mu9qjQEsv1Ydd4hVJ0Yf9dvok7mhMmhdHWujYOik+FAVWmtQvj67YCfDMR7iBJF6BgGQbMN4ydjhlKeePQI+CETV8lmkFj2HUmau93CIIHBsUpiq2CyZrzCzI1zhgz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712231182; c=relaxed/simple;
	bh=VnjSFH3iLfjXOB26l2DmGIorjHrUwNNABt8C5zuouVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFJZwd+zaoGzd4vmkT6gkT+nBBmkOpG3mZlYzVodMREGaPL50QDtnogQtzERh9nsl4g9ONpIAgMuPCIyTNRy2q1P5+yNva12vD8mDUXuU8KoyKxAMUUx3ej6zZE2fM4LIOiPLNK2FgF2b6x//SR5htLNfjXOH1+tSVTWpACwS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=imXQUNzc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712231180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os6s6yWf+KEySppA6UtqmMO50Okp6hSrMyagRzZf4EU=;
	b=imXQUNzcWUb0Nhh1PAPCYqStTV1hHsnngk0JKEJ0Pz+cy71DOaOyiOiOR2mSqIQ73wiRcJ
	4rkAa0dnGJMQMMrymv7pMgSLJCmOkExefRIMN8fyWqSKO/09h0njQAOlTnrrqYFYCk1P+U
	9naBG14CuClBiiXJL0jjKvIZTd/XhwY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-vfWGG11vMnSU0AW5omQQyA-1; Thu, 04 Apr 2024 07:46:18 -0400
X-MC-Unique: vfWGG11vMnSU0AW5omQQyA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4156184fe60so4422715e9.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 04:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712231177; x=1712835977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=os6s6yWf+KEySppA6UtqmMO50Okp6hSrMyagRzZf4EU=;
        b=KDPfYERcbNMpDMmLtZZOBw7jaobjgwOT3kdHu2Hy7iAQ2NIObEn06f0YWRvTjwRkQp
         /KeXXIU69O/o5MdMh/1zgNALrka9ZVRyner5rGZdRW34P6Juwt6VW0AJgPSQynrIkUIL
         Mrpxo3AbwnsWqW0+cIH2q8sEf8ml7CaDRGlRyDTUJ8Li3+3/wai+gsj0ClvA9IAzaXMo
         BIk6HSYl2kPAzr6WhHp6CYk1ubKLJTJw00utNjwGZj/yBlkcInzR8a5xJNsmJg00vjt5
         gqRL5VpQVUvOilIndfnlgke5KlhNmqo4/lGIG5JSB5UNeoORdNGQS7ydeYOdoKnWIZB+
         Pgig==
X-Forwarded-Encrypted: i=1; AJvYcCVwer5BzJJuJyV49jEbXQQHRDz8shdGY7eDSbkCSDev9G5Pw+P66XvKWg9M1In/tD/0RtSdR1YOQWJ6g/FrX61JQWgl
X-Gm-Message-State: AOJu0YzqXYEKrCo2PbyQFERvvUzyNfQeKspfUrZ92Es4MYi7M8lAsyr+
	iP7Nq/g/wA1UZOz7Vzr/3z7500BN8YwDEVHEmxwTWwsxpQE0XuWAhYXD8Sexy+LPr1RyQZHhldo
	sdaiAariAVU4JfGBfNCJefRKEYc9jV7FpPqvzrW73HSIpCc5vZLni0X2U63YMAJZjt3R9sTEpjm
	O4z462E5Kp+Uw/Bsp5EgYH7r6Q
X-Received: by 2002:a05:600c:3b18:b0:416:23d8:e88d with SMTP id m24-20020a05600c3b1800b0041623d8e88dmr1516456wms.26.1712231177631;
        Thu, 04 Apr 2024 04:46:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFSGC2Xe5+h41NT6Q/UZflxkyEyGkJ8Z1k8bGJSLWOaE2vJxyPqfMC3aZQbF61P/IiWV6l7IdDRNFCc18PrB0=
X-Received: by 2002:a05:600c:3b18:b0:416:23d8:e88d with SMTP id
 m24-20020a05600c3b1800b0041623d8e88dmr1516437wms.26.1712231177219; Thu, 04
 Apr 2024 04:46:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318233352.2728327-1-pbonzini@redhat.com> <20240318233352.2728327-6-pbonzini@redhat.com>
 <20240325235918.GR2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240325235918.GR2357401@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Apr 2024 13:46:05 +0200
Message-ID: <CABgObfZzkNiP3q8p=KpvvFnh8m6qcHX4=tATaJc7cvVv2QWpJQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/15] KVM: SEV: publish supported VMSA features
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	seanjc@google.com, isaku.yamahata@linux.intel.com, rick.p.edgecombe@intel.com, 
	xiaoyao.li@intel.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2024 at 1:04=E2=80=AFAM Isaku Yamahata <isaku.yamahata@inte=
l.com> wrote:
>
> On Mon, Mar 18, 2024 at 07:33:42PM -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> > Compute the set of features to be stored in the VMSA when KVM is
> > initialized; move it from there into kvm_sev_info when SEV is initializ=
ed,
> > and then into the initial VMSA.
> >
> > The new variable can then be used to return the set of supported featur=
es
> > to userspace, via the KVM_GET_DEVICE_ATTR ioctl.
>
> Hi. The current TDX KVM introduces KVM_TDX_CAPABILITIES and struct
> kvm_tdx_capabilities for feature enumeration.  I'm wondering if TDX shoul=
d also
> use/switch to KVM_GET_DEVICE_ATTR with its own group.  What do you think?
> Something like
>
> #define KVM_DEVICE_ATTR_GROUP_SEV       1
> #define KVM_X86_SEV_VMSA_FEATURES       1
> #define KVM_X86_SEV_xxx                 ...
>
> #define KVM_DEVICE_ATTR_GROUP_TDX       2
> #define KVM_X86_TDX_xxx                 ...

Yes, that's a very good idea. I've added the group argument in v5.

Paolo


