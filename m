Return-Path: <kvm+bounces-17863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3F58CB4AC
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 22:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 455B7281C09
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841C51494D4;
	Tue, 21 May 2024 20:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHLE3FVL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130A63FB8B
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 20:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716323138; cv=none; b=F26Jg+DjnLJK3RWEIfgVFeXVxU1kyZpfBK9T2lPKWMJTv+4FdMDYL1OFdGXhRqT/qu2/lggV4CCdCivZi5MBgICWPLzeRFv+Umg0nwuM0jaA/si8aBTGpPBluxEd6G/OK6LJ0MD1JqEaLEdhUv+UJ+taij9Hm2gTBpnYqT/DAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716323138; c=relaxed/simple;
	bh=TNbVzSZ4k9mDMCWPwnEnUO8KrwqMSnosmMil9nH2X8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F3KNlDG0sdLYYMywmCSd2SEugIQ/46Y/Bs7sbohYiimEfYYtkIdssjSbWdo6dAFbQTNgdXyZL3pXUCorT00Ju3W7HhBU/QwRkrjlJ3cquMMzmuFiJiPFM+QY12XWJpehhjMUSn6WDoigfRzrHNMheaKafc6fxaIN91Ji8xTxP48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHLE3FVL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716323136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLQerxE5R+lMZTgLtYljE+62W5PtbMN9LPsnxzlTokY=;
	b=PHLE3FVLxKxA0pBWfK5Bq1skq5iwtlKRiPnQeuqSaQd/cHZvXYMdQDmyU0IwWTjLqgaETm
	jyvoCCbheEydbeOLUld2wAJue1tWVonsUE8FaV6k2JsItwDKv07OmAHUKAtjoIkOhEN1SN
	RSrSg9ZZQcwzqqUBCn7begGcM6bc8Zo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-6VUCZqlJOjiYnVQvDwVXbQ-1; Tue, 21 May 2024 16:25:34 -0400
X-MC-Unique: 6VUCZqlJOjiYnVQvDwVXbQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34f7618a1f2so101654f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 13:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716323133; x=1716927933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLQerxE5R+lMZTgLtYljE+62W5PtbMN9LPsnxzlTokY=;
        b=CZ8VqqkMfbPx+CGjobnOXFLW5CHDm38ShF7HwqRWfyLD08JJ01xkiEVrn1+8uVZ7De
         E31VONPNSK5Oh3yhmoIVb/RrJiPU3nskVxmdClkN7nHTcb3pIdAw+Sez5F4QbInEmiel
         QN5NoyogUElBpI53rQeczkDIQGuBtNDyCd/cxue1hI2MXzQ4MH/GOehyi9Xi4dwpYcN1
         ePpeVNoPDSokKZluTNI8jPjE2chYVExB1S/OWva8UAVfnr/fc6IDTVIEd05EpTo4P7dP
         YQELxqHMqfKubXtLhlanJXQzYW9G2LDMSbdyq4iz0RbO2f/2zqY5CYGplmbNCiPyxcr6
         synA==
X-Gm-Message-State: AOJu0Yy9zcLANZWNqbSlCB8E3SV22G9ZknkIihLqcNBi5WHvuq8rHw+O
	yzFCneXgkM0ZWpbOGfQgaLrd1HGgqGEZh/TA+Te4xqslD8ZOIxYxnWTz+rOmyopqODrb/iBUsk9
	bZto+kJXzLULrx6Vg+iXdtBzSBhW1zssWrHXWKA47oX0GhrW9xv9n1taaXA1f2/NcrI1h8sqEft
	Qol7ZGQub3LAAbagGD3kNZb/CB
X-Received: by 2002:a5d:5510:0:b0:34d:ab1a:6384 with SMTP id ffacd0b85a97d-354d804f46emr119874f8f.13.1716323133056;
        Tue, 21 May 2024 13:25:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHB55ZmrkK7joPCTYgDCxER7qka48DTWgOfjPLcKVDrzhqdCM29sdaEnBuS0/mwQSDsQgyxkw4J2nGXaX3dtf8=
X-Received: by 2002:a5d:5510:0:b0:34d:ab1a:6384 with SMTP id
 ffacd0b85a97d-354d804f46emr119864f8f.13.1716323132726; Tue, 21 May 2024
 13:25:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-10-seanjc@google.com>
 <CABgObfYo3jR7b4ZkkuwKWbon-xAAn+Lvfux7ifQUXpDWJds1hg@mail.gmail.com> <ZkzldN0SwEhstwEB@google.com>
In-Reply-To: <ZkzldN0SwEhstwEB@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 May 2024 22:25:20 +0200
Message-ID: <CABgObfaE+M5QuTfAZ01OjeB87vGmjRgDUH=rnNX8FHzc7t1Oag@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: x86: Disable KVM_INTEL_PROVE_VE by default
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 8:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > -          This should never be enabled in a production environment.
> > +          Note that #VE trapping appears to be buggy on some CPUs.
>
> I see where you're coming from, but I don't think "trapping" is much bett=
er,
> e.g. it suggests there's something broken with the interception of #VEs. =
 Ah,
> the entire help text is weird.

Yeah, I didn't want to say #VE is broken altogether - interception is
where we saw issues, and #VE is used in production as far as I know
(not just by TDX; at least Xen and maybe Hyper-V use it for
anti-malware purposes?).

Maybe "Note: there appear to be bugs in some CPUs that will trigger
the WARN, in particular with eptad=3D0 and/or nested virtualization"
covers all bases.

Paolo

>
> This?
>
> config KVM_INTEL_PROVE_VE
>         bool "Verify guests do not receive unexpected EPT Violation #VEs"
>         depends on KVM_INTEL && EXPERT
>         help
>           Enable EPT Violation #VEs (when supported) for all VMs, to veri=
fy
>           that KVM's EPT management code will not incorrectly result in a=
 #VE
>           (KVM is supposed to supress #VEs by default).  Unexpected #VEs =
will
>           be intercepted by KVM and will trigger a WARN, but are otherwis=
e
>           transparent to the guest.
>
>           Note, EPT Violation #VE support appears to be buggy on some CPU=
s.
>
>           This should never be enabled in a production environment!
>
>           If unsure, say N.
>


