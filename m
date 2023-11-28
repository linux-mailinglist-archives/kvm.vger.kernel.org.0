Return-Path: <kvm+bounces-2573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D92A7FB2CC
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA6DC1C20AFE
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1275A13AEC;
	Tue, 28 Nov 2023 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWcrHE+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BD21A5
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701156856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eyjo55qLliRYjmYTzBCIbN4AdrhCtAA/uK2GJwWiVO0=;
	b=jWcrHE+iRKETIEQUfPOe03qPAhv1UULyRjYKw5Y279/VHgqCBCvfI71VTqAqbWY3n94JW5
	+G2HPIqVzlXtU7lHgNUEzNbLxXAmEI7s932nO6vJIn+7iB+nmBIlcyM+WjJx5JDlCoetIY
	jmoFUaufMSYrVrpgKXQRYvl32DcURqU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-40YgM6tkO9-lQqtvjc464g-1; Tue, 28 Nov 2023 02:34:14 -0500
X-MC-Unique: 40YgM6tkO9-lQqtvjc464g-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c98858decdso41063761fa.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:34:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701156853; x=1701761653;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eyjo55qLliRYjmYTzBCIbN4AdrhCtAA/uK2GJwWiVO0=;
        b=D6FX3yjdM//GeEH3s5W1rQXHtXZ/cIh+KeD2FzSIlso2W3RtDRU9XFL6ys7vNh+gpZ
         cVad67fE7K0/jBmmqgbePAKDTCIkivhl/fX/XnhH/fQEaIoUEAjrebmBbDlUbB/bmsT6
         lmVxPdCjuhb9NjIN/kznI79zUgXh2ZmFiZ2Rrn/OZa/R3WlYoM6eGumx7Mlav7PiUrHC
         SUmIaaAzKLdMyOHDsbgJjfUqcC0pjbXw4l38GeBpA2NbDXBDMm3Djcd2tiFFdx1FubOe
         xAJQifXMjUJUEcSYl1WQGi37dloBxSaXZirKGBnxSFaER8grcD+i5ms6ms7EvHHtk4mU
         J53A==
X-Gm-Message-State: AOJu0YxAXgJGf37yTgbDzMzQ6JX5D/k+7Wj5Es10n89PJETa1XCN1lJO
	7umtthZ75eZ+r80efn69zsp7BPLvOfKk9A7KuL/bKZnDuZ0EgDi7kD/eQLnFB+8024OUjt1ozSy
	GF97TXiyJBDsY
X-Received: by 2002:a05:651c:c85:b0:2c9:9376:1ae7 with SMTP id bz5-20020a05651c0c8500b002c993761ae7mr8406388ljb.28.1701156852838;
        Mon, 27 Nov 2023 23:34:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhKW22SAvKwvjE7CTORodsLpg9bL5WiFyycmYSgUDV6WJI08pAgC+6hurQK/6T/oEOp7zr0g==
X-Received: by 2002:a05:651c:c85:b0:2c9:9376:1ae7 with SMTP id bz5-20020a05651c0c8500b002c993761ae7mr8406365ljb.28.1701156852519;
        Mon, 27 Nov 2023 23:34:12 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b0040b4110f548sm9598049wmq.23.2023.11.27.23.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:34:12 -0800 (PST)
Message-ID: <5838ebdd46bcddd836bc87d0ec7d57fadbfb79f6.camel@redhat.com>
Subject: Re: [RFC 14/33] KVM: x86: Add VTL to the MMU role
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, Sean Christopherson
	 <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
 anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
 kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:34:10 +0200
In-Reply-To: <CWVCX8ZD8QQZ.2FVZ6DODV8A6T@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-15-nsaenz@amazon.com> <ZUvE2clQI-wOzRBd@google.com>
	 <CWVCX8ZD8QQZ.2FVZ6DODV8A6T@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2023-11-10 at 18:52 +0000, Nicolas Saenz Julienne wrote:
> On Wed Nov 8, 2023 at 5:26 PM UTC, Sean Christopherson wrote:
> > On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> > > With the upcoming introduction of per-VTL memory protections, make MMU
> > > roles VTL aware. This will avoid sharing PTEs between vCPUs that belong
> > > to different VTLs, and that have distinct memory access restrictions.
> > > 
> > > Four bits are allocated to store the VTL number in the MMU role, since
> > > the TLFS states there is a maximum of 16 levels.
> > 
> > How many does KVM actually allow/support?  Multiplying the number of possible
> > roots by 16x is a *major* change.
> 
> AFAIK in practice only VTL0/1 are used. Don't know if Microsoft will
> come up with more in the future. We could introduce a CAP that expses
> the number of supported VTLs to user-space, and leave it as a compile
> option.
> 

Actually hyperv spec says that currently only two VTLs are implemented in HyperV

https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/vsm

"Architecturally, up to 16 levels of VTLs are supported; however a hypervisor may choose to implement fewer than 16 VTL’s. Currently, only two VTLs are implemented."

We shouldn't completely hardcode two VTLs but I think that it is safe to make optimizations aiming at two VTLs,
and also have a compile time switch for the number of supported VTLs.

In terms of adding VTLs to MMU role, as long as it's only 2 VTLs, I don't think that this is a terrible idea.

This does bring a question: what we are going to do about SMM? Windows will need it due to secure boot,
so we can't just say that VSM is only supported without SMM.


However if we take the approach of having a VM per VTL, then all of this is free, except that every time userspace changes memslots,
it will have to do so for both VMs at the same time (and that might introduce races).

Also TLB flushes might be tricky to synchronize between these two VMs and so on.

Best regards,
	Maxim Levitsky




