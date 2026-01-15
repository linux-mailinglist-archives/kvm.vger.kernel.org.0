Return-Path: <kvm+bounces-68185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9FFD24D01
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 14:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4C014304F2CE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A8B3A0E81;
	Thu, 15 Jan 2026 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoYIA2iR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNbHsiCc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1698339A7F8
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768484991; cv=none; b=SrDtDqfWONj1BG7kFQtkGUOnpvFBR2vkm86BCecBL3yIBrze6vWSzZ10uIVJ/e/zcw3qUETjG89kWQH7AvrqdJ+/mNgxQFUSTaYcLDz5K5NYTpsV4RCEtwIAE+UxDONOqYO9k9m0dCKDTPX3bEPBWvS3INsvQ97P63kRbw69VhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768484991; c=relaxed/simple;
	bh=J3zShuN81mrW0f63trbjn9jzjhUZVrppKHiXYKl9pmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WhRB+T6KvrXdeOg99xSfRIQycf6aPHjgENg1PpJY8gEw0n0flU+b04YGCt8LITPb47B/e8xjEnQ41fuxhdXtWHZol9e5ppXs7YZvGqCbsuVUfwqzJkYckl0OuEkUum/3c1d/mdDcp6aTZG90qnuqpEmlTiOaSn8z4zdkp5fu/rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoYIA2iR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNbHsiCc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768484989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQaNUfiPxxVmHD5Lm+6wEQl3CjBlE7Gpgngn/GNSGMQ=;
	b=UoYIA2iRMfrfwir0WjcFrxkGrnz85pmaQ0k2a7Kvq7dJomIoRsX6tIK5b/coJgZObujHSZ
	dmFMClKuo10NA/cWPeBGFRhExX2rc03UFf4pTZeDxPfJxVIcqA3icHxV45J5jXB6n6mBDY
	Sc3WVb0ltmrL/7Dn4Hct9aJLYjfLPdo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-yGlcfLp0MpaR_lbOR2vGiA-1; Thu, 15 Jan 2026 08:49:47 -0500
X-MC-Unique: yGlcfLp0MpaR_lbOR2vGiA-1
X-Mimecast-MFC-AGG-ID: yGlcfLp0MpaR_lbOR2vGiA_1768484987
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43284f60a8aso763841f8f.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 05:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768484987; x=1769089787; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQaNUfiPxxVmHD5Lm+6wEQl3CjBlE7Gpgngn/GNSGMQ=;
        b=GNbHsiCcmjiPsxrB5ULjrJT1Oeg03VlCtGNe21zgsjk1F5T+EzNM2RE5pTjJLc9IkO
         UTM2e4g9bRc6RuHMNIpBFWwlm5meln45w2cWO1N9CJa5Ddib0cmN0URXlMpgQLH2I/ZF
         742mTnleuEERdUU9W0jj9V2DHGX1lu6exoJycjDc78zOrYMWuh9o56gMrnfaz6cfbrsx
         IJrCSterGTHxMioegbxsbDgkuirdHAZci/OG13ORpmMpWhkhju3Pitn64bC7VGsHU0vz
         cOs9FqueDKo/4u9g4GXlMvWKDAiTRddAEiwJhND71GTPTEYCIDgOUD0djVgmcXU+K+0z
         Fhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768484987; x=1769089787;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQaNUfiPxxVmHD5Lm+6wEQl3CjBlE7Gpgngn/GNSGMQ=;
        b=kYA+PFnrYThLzRNb65XMqmLuTydjvgkFmNCj4STZz3LiJOTGJwZ9rhYKfs89TplC4Z
         MqUj3yn7rO6SW564J/aG1HNGzEGyf9otl+1bFEHg56t7DbFSTzIscYdheGjkO7Ar5KHh
         DxeWEQEYUtvs+0WwuJPWBgsCeKqRzLkjY8wxNT0FEXKfGvh0wRKbg3DCPfIw3BtTPNc4
         S6vDL7ftDI6rrQJokhYe8I4arw4Ycpe3q63OkGs3dHnZwfVbluw8KRCEpgY5iy//Xwte
         jZVSjz5rFAXKYhdULlutXbkQWAA8tyaaIVT2ct5Nc2XkSrLeusnqAQ7olfrBNUItQlJ+
         sCMg==
X-Forwarded-Encrypted: i=1; AJvYcCVeFph0KOOnv09Lw9UBKalR8M1hlpF3BvMy0UdfL2NPvhrpJe3Xa0jDjbNSpN37VzmDsCk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6eUtBiH4+QA/XBWeYfcFNTt+edf3BOgnqO8+HKWs6mOHHeCky
	/NOCWRbZRsllS0r6Sv7ryiFEtCYOQVf8mA941yb8H67PxkaZURVERVfLVmpLHyKNqFe8ZmZn+ui
	ro/eHHfkMpHAsSGlqsTfylnC4Ujle9/cyOrjwsh4E/SVTTrfhlfi8cJ7ZJUY2EPhcucWOKW86g8
	3dTntwTCTc7LbyaWJv1X7FLTbW1+hC
X-Gm-Gg: AY/fxX7TUe7iAvtFwGr71fYmXCwgRj/JrHQV2aN3jNn5zIozVPewZtjnEoUIFcys1NX
	klpoaZOtfScskZejp/qNI+x3oRuzzHoQJG1T5/ijLUIOgfozz+n5K4n0JHV2UwWXNEb69uyh20P
	vOVmfBGtqIbkNGJr5gtgiIokv2LGbVNVLRwEE4Ukwwnex0NkYVV51oW9BBzdWkID8w2AAAZ/kvN
	egeK9h0ZtgvGUGXIbJz5ziqkms23EzZG5sXaP90kEIcTisY3B2MNNYF/wI5VzhITZVgaA==
X-Received: by 2002:a5d:5f83:0:b0:430:f718:2388 with SMTP id ffacd0b85a97d-4342d59c4ffmr6952007f8f.8.1768484986661;
        Thu, 15 Jan 2026 05:49:46 -0800 (PST)
X-Received: by 2002:a5d:5f83:0:b0:430:f718:2388 with SMTP id
 ffacd0b85a97d-4342d59c4ffmr6951988f8f.8.1768484986333; Thu, 15 Jan 2026
 05:49:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
In-Reply-To: <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 Jan 2026 14:49:34 +0100
X-Gm-Features: AZwV_QhCofXmdc457eKiuyG8-L86En2nIIwZiMdaKiFOHt8D3NJfNNRzpqcIrN8
Message-ID: <CABgObfYk-PxxGOj3az26=tt-p7_qu=eFhgdjKFqva7Stui9HYA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
To: Borislav Petkov <bp@alien8.de>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il gio 15 gen 2026, 13:22 Borislav Petkov <bp@alien8.de> ha scritto:
>
> On Thu, Jan 01, 2026 at 10:05:12AM +0100, Paolo Bonzini wrote:
> > Fix a possible host panic, due to an unexpected #NM, when a KVM guest
> > is using AMX features.
> >
> > The guest's XFD value, which is stored in fpstate->xfd, is used for both
> > guest execution and host XSAVE operations.
>
> This already sounds weird. Why?

Because the state of disabled components is undefined anyway. There's
no point in making all host XSAVEs more expensive, even when the TMM
registers aren't in use by the guest (which is going to be most of the
time, likely).

> Why don't we carry separate XFD copies - guest and host - which we use for the
> guest and the host, respectively?

That was exactly what I did in v1, but it's more code and less efficient too.

Paolo

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
>


