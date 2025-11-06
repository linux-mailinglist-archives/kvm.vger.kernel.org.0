Return-Path: <kvm+bounces-62230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1F1C3CC3E
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 18:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 021794FBED1
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 17:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354B434DB5E;
	Thu,  6 Nov 2025 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4SOuIlMH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADBA2264D3
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762449060; cv=none; b=dlwOeJm7fLQKpHmGyhCgAxCLz8NssAPFFA5ZksJlshX9y4dsWyA5x6xcTp+45eLAtfEtRji32D/SwlPQr7bVgFHPN3BXHVmxLGGRAv8K5kMSFUdB2EaNZmhTigFHl0rZZV6EDeEufXm4COW7b92QWgdDd5Z+SHa7YnZUteDVWa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762449060; c=relaxed/simple;
	bh=NAbw2pgQJJbL/qkU6OyN28/zel6H0dRSE1JH7v5neMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQx7vCP614IeH2mcl7fY03WeaCcXVlnv3SQzkCmhJhSOSPDiihfNHh3BX/U2BnkhX81OSA7jQCQWfX5hfIRNAo/YfK3o64KgRBxMT7bVz/AClgZxD3aCP9uGfc6KX1/DCSozFGorgTehhZBb9tX+mnXaF3e6ahnxDOnlPU+JKjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4SOuIlMH; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7af6a6f20easo1225849b3a.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 09:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762449058; x=1763053858; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WdZEL1EHDSq3ZNiGpe0rhkC6wH1kK9qkAITFBJu/irM=;
        b=4SOuIlMHt3MiyfTYnXf4+fvNrTt7Te/aRhjeux08G2Daq+NPJPuwME3sPF2EoHSRU3
         Nl11RQnaMLtixhUj+x7Fc3ViUIMYRCimeRcEKmdgy0nFL5CH7h6lgINKK1zXU5HenwgJ
         rc/BD5KXdrM2eN0GhV5b53r7014HVpnOupQi0s464TAAhKAHxKW8NpLoUjhaQKeLg8H2
         lFWYK+ZuarVGHHO1AoWvljxY1z/N0Hde8FHjxj2EUTMOTw1PyN1xLddG8r0fNceBTexo
         fBGIkvaOGbCFEDkGywUf9JSvUpHG4c5tS7FmfDEjcDe/3Sv3Xz+vdWfORH4LFN4EsoTW
         9Cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762449058; x=1763053858;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdZEL1EHDSq3ZNiGpe0rhkC6wH1kK9qkAITFBJu/irM=;
        b=NMsQw9WIoEv/LTlD0SvlT+Rr4xsnZ3raJ+caTmSurkj/j9n5ZOyjxJpt2yyB5Gemnt
         uakDuqw/gvN3K3700QuN6vAfwgMrPwOf8H8maPjO/OXifhof/4V0SyoG1c2zCpkgSBy1
         mEf6rf4slBhA1NAhE7cm1IU2YwyA3HZzYVBarVi0x0njLpkbetmHWPG/uDXGxbbryMuz
         EqQHM3jLa2VKwb0KKulmWgTXYbNWsRajEI/gKPJJKPXAyyDExzzMVkT7Vs+0DS9qcK0Q
         gh3uwfccu+NWA0JvwK3jCRYJsMINJAg/+E+BsFwA8HKHDJI9XaVk00104O3oiQVPcrYR
         hbhw==
X-Forwarded-Encrypted: i=1; AJvYcCWVraLf64VGwj+StFBCeveY/Q/tJ3i6nsSWRmKpC9wD9g82dgf9kpxo2LvWt8A0D5CNpEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGF9OaoaZxKARC1F55P9DTUG2nN7IbHL41/hjeQvgg7AyjT6J9
	1U4HWD9hA4Y8Enms1AkCj1+MKq7C9QXQR+xIVlNdcf58+29JM1EiXFsdbtGHVVBDRg==
X-Gm-Gg: ASbGncvXKzlyktoLZSOzP8/9urEo1UmCTTV3d33njaG5xylutUDx62AW1vDmSAazsmQ
	+v8Ml9oklBQpcXNSFBC16+fqYa1lhTj7/i6RVzZwL8NbEXBX+aff6wVAeI4y8zvCrFBswoqFxMT
	izgIx1u5PSRXjkbOx1Ffj+hc6G4f53ZmYjkOzEJ681M6wL8eKjkDlueqAdwK0U6BLaPMAwESQRj
	fMHYRoXA78NCAo0lpZZMq8zZX6+enlzTyphZ2IeBFKgda3egodJye5Wc67lPfPZPbsyng+BGaJp
	+uLSegygQLAECmM1rP2Rjd5ae9KfX2RvDt8yhILlrY1RihpSfy+7YNNHXYuAvHkayRuTvMLsyPB
	h8TXRhCYob9a0HEA74FuyzVOJ/ZwEc5n9V0ylTt0XkN24EHt1cKaOspJz/FHoy2/yVfACSrTlNT
	BU8np4gWxQlrTEIu5Viwa05C0q/jPBhfTI7QhpUuHi8g==
X-Google-Smtp-Source: AGHT+IHPm82vc2DBF70vhD6PERm/XBQoRpWwg+wEs2NCF7+zKnTBYd2FPBt04x2iza2MprpBAgD/zQ==
X-Received: by 2002:a05:6a20:7492:b0:334:87c2:445 with SMTP id adf61e73a8af0-3522a16ee21mr377797637.36.1762449057848;
        Thu, 06 Nov 2025 09:10:57 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc179f14sm56176b3a.45.2025.11.06.09.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:10:57 -0800 (PST)
Date: Thu, 6 Nov 2025 17:10:53 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
Message-ID: <aQzWnS63x81EhTWy@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-2-rananta@google.com>
 <aQvoYE7LPQp1uNEA@google.com>
 <CAJHc60xjPktqw=RgxgpOSqJP0Ldq6skmxLQm4QhpiojPAMOA=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xjPktqw=RgxgpOSqJP0Ldq6skmxLQm4QhpiojPAMOA=A@mail.gmail.com>

On 2025-11-06 10:06 PM, Raghavendra Rao Ananta wrote:
> On Thu, Nov 6, 2025 at 5:44 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> >
> > > diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
> > > index 5d11c3a89a28e..2dc85c41ffb4b 100644
> > > --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> > > +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> > > @@ -18,7 +18,9 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
> > >
> > >  CFLAGS += -I$(VFIO_DIR)/lib/include
> > >
> > > +LDLIBS += -luuid
> >
> > I wonder if we really need this dependency. VFIO and IOMMUFD just expect
> > a 16 byte character array. That is easy enough to represent. The other
> > part we use is uuid_parse(), but I don't know if selftests need to do
> > that validation. We can let VFIO and IOMMUFD validate the UUID as they
> > see fit and return an error if they aren't happy with it. i.e. We do not
> > need to duplicate validation in the test.
> 
> Unfortunately, VFIO interface accepts UUID in multiple formats. For
> VFIO_DEVICE_FEATURE and VFIO_DEVICE_BIND_IOMMUFD it accepts a
> 'u8[16]', but for VFIO_GROUP_GET_DEVICE_FD, we must present it as a
> string. Is there an issue with the inclusion of an external library (I
> think I've seen others in tools/ use it).

Ack. In that case, depending on libuuid SGTM.

I mistakenly thought VFIO always took the UUID as a string and
uuid_parse() was just being used to sanity check the format. Thanks for
clarifying.

