Return-Path: <kvm+bounces-27311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1F997EF33
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 18:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7162B2141D
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 16:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF1019E99E;
	Mon, 23 Sep 2024 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjqVKbQp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A66D1993BB
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727108647; cv=none; b=MtL6B3b7OiESAZRfyl+cLI+QTlsXlDOwRSKg2t7bMtm8rFOK/raSYl6oXhG/64YoUlHCoY5/WNPttwC0ve+OaXJOpXCIlaaVsIdESGHqevEPikbPJXrEHuHsGFcpH91S74cynaZBhsxNo8VZPsWKKDtcs2Arv0FNGYh0anGRCkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727108647; c=relaxed/simple;
	bh=pH27xsWg8G6SeVBeYa7PVys3VaHWxE1d41xvTvXeHKo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nmzc0j2pU0seUlYnIjRrShQSslJCcJXmAiywoRzM3bQSWWcn8tjaNnA5TGP0zdHF38JAG+K/oqgcTNOk0qdKWIJpOfJrrUAZjzN5bLe8lUITlppU8HEoz3G6hMRLyKKTRDU8+jej04CqJBIyZNKiQf5X+zbVXQOtVL4ABZC0/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjqVKbQp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727108645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhibzVfiT6YYguU9Zn+WLSPcbkXuFS0jVV+8r0H5PLk=;
	b=KjqVKbQpjGleLYSm3gA5ZX8SMM684ezx13E7NPJAmj1lAkccDTfku7FZB2zCw/qabMkoWP
	Cf9q2NcJbldf/d4i3AbO+5g0oFjYjhI5FcDQJtgD9qVgrXVSG1rdX7tB2/9T/fpaXzElxR
	sgcVbDyuYaGLVq/0gkbOCGkOyu6zQQs=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-rhJOuEecP1OoJXCGkFQJIw-1; Mon, 23 Sep 2024 12:24:03 -0400
X-MC-Unique: rhJOuEecP1OoJXCGkFQJIw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-7163489149fso5437449a12.3
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 09:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727108643; x=1727713443;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xhibzVfiT6YYguU9Zn+WLSPcbkXuFS0jVV+8r0H5PLk=;
        b=XFvIXpGUXoweQYzrH051PzvmU+CtqDF9m/e2GUUICLbNxMkx9vpSgCE7h5wdBwCDnt
         THdCz3DSCP1MuaxaMhW+U44ou+KAlLVyaS/fWTlREg/2MD7I4wDioDF3MndAzz1JGGq3
         cYnqHQolhnfDrKQNwjAf4GhXraCq5gN8Jfi1AJ1s/aRz0/fnHnwndWH0wlobAzI794hm
         Gl6bUMWuKkgkqtlW9QPl+bh4+Kfzqd3P48WLMJZojrS1D+w8kqzC1eqKojZfeGkXgHvf
         Au290O1/v+7wQKgimJhL9x8UX9IH5fFqX3iJWDod7qKFYgfkangQVAchfC76b9QqjpaX
         h3cA==
X-Gm-Message-State: AOJu0Yyuq5WvlS+2QPxjB37MWdEw2Q/TNqRLBd66o9jV98UPKKJXWz0y
	eThm0NhisB6X7gAZRHU21hDiNlO1c1TPwij3yQusUV3VNqQ9B8EXKapWJ3EiXOAjSiFKaUHb1WN
	wVq6r7qS01Unyjw0DA3+VbeecGnZRAFwBtKJDUVOOXhe7AZTVHw==
X-Received: by 2002:ac8:7f93:0:b0:453:140c:ac60 with SMTP id d75a77b69052e-45b20573d99mr163550501cf.50.1727108631832;
        Mon, 23 Sep 2024 09:23:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGah0EW43b/NHrbQUHUF4y0RDzvpRR/zN6gzuhBBTaJwGY/I9BmVKauh4Q+cH5LrDtlepgfjA==
X-Received: by 2002:ac8:7f93:0:b0:453:140c:ac60 with SMTP id d75a77b69052e-45b20573d99mr163550181cf.50.1727108631502;
        Mon, 23 Sep 2024 09:23:51 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45b178751casm48368671cf.22.2024.09.23.09.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 09:23:50 -0700 (PDT)
Message-ID: <f36ab05ce7ff3c0823f31cdba85c091ed7211b8e.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, 
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Ingo Molnar
 <mingo@redhat.com>,  "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner
 <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>,  Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 23 Sep 2024 12:23:48 -0400
In-Reply-To: <ZvE06wB0JGWXGxpK@google.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
	 <ZRsYNnYEEaY1gMo5@google.com>
	 <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
	 <e5218efaceec20920166bd907416d6f88905558d.camel@redhat.com>
	 <ZvE06wB0JGWXGxpK@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-09-23 at 02:29 -0700, Sean Christopherson wrote:
> On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> > On Wed, 2023-10-04 at 16:14 +0300, Maxim Levitsky wrote:
> > > У пн, 2023-10-02 у 12:21 -0700, Sean Christopherson пише:
> > > > On Mon, Oct 02, 2023, Maxim Levitsky wrote:
> > > > > Hi!
> > > > > 
> > > > > This patch allows AVIC's ICR emulation to be optional and thus allows
> > > > > to workaround AVIC's errata #1235 by disabling this portion of the feature.
> > > > > 
> > > > > This is v3 of my patch series 'AVIC bugfixes and workarounds' including
> > > > > review feedback.
> > > > 
> > > > Please respond to my idea[*] instead of sending more patches. 
> > > 
> > > Hi,
> > > 
> > > For the v2 of the patch I was already on the fence if to do it this way or to refactor
> > > the code, and back when I posted it, I decided still to avoid the refactoring.
> > > 
> > > However, your idea of rewriting this patch, while it does change less lines of code,
> > > is even less obvious and consequently required you to write even longer comment to 
> > > justify it which is not a good sign.
> > > 
> > > In particular I don't want someone to find out later, and in the hard way that sometimes
> > > real physid table is accessed, and sometimes a fake copy of it is.
> > > 
> > > So I decided to fix the root cause by not reading the physid table back,
> > > which made the code cleaner, and even with the workaround the code 
> > > IMHO is still simpler than it was before.
> > > 
> > > About the added 'vcpu->loaded' variable, I added it also because it is something that is 
> > > long overdue to be added, I remember that in IPIv code there was also a need for this, 
> > > and probalby more places in KVM can be refactored to take advantage of it,
> > > instead of various hacks.
> > > 
> > > I did adopt your idea of using 'enable_ipiv', although I am still not 100% sure that this
> > > is more readable than 'avic_zen2_workaround'.
> > 
> > Hi!
> > 
> > Sean, can you take another look at this patch series?
> 
> Ya, it might take a week or two, but it's on my todo list.
> 
Thanks in advance!
Best regards,
       Maxim Levitsky


