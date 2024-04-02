Return-Path: <kvm+bounces-13401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D50895EDC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 23:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 267171C241A7
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 21:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBCF15E7F3;
	Tue,  2 Apr 2024 21:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eB1lDBSe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDE15E5C1
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 21:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712094136; cv=none; b=DJKeBJyLlX3SaRPNcMT9PfecyvODj0H1xANPYgtMfxd+F9YuccdyprcWMDTp2oxGRzv+MWvdJiiaaQCLbOQ/k5HZVpHczy3+4Lw3YL73/8V01zN/PRrMHrwz7TcrWXapTBGWi6R3+2yZCub0kJvWEVU5H8Q01WwE4bJVE7IU450=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712094136; c=relaxed/simple;
	bh=2g/vs+nPyemqAPzIisechJw08Vi0ogoOnwyid5shijU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/2pwZlO6HZFu+FbYFohKCAqRK5LKl5pLrosu2V2z/HlpgwLFB3nHxNdQX7I5nN9x0fJjBkfBotvjydSUU7La0kQ/NMm44Jz81j5fllUpO/FScy3SjheXNhZ+7BopGNb4tZSKmRdAS8QanwseQzboJvhSDv1qShFokn60adrzTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eB1lDBSe; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-614245201b6so82581347b3.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 14:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712094134; x=1712698934; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fwziIr1L9R6/fqNLKR2OlkM0SoO/VH14UfpluEni6E=;
        b=eB1lDBSe74cbOtAZC/SFadcKdjI9izXcgshmrnz94F15zWnkIRQS0MfZ2xdCvVgEyx
         pzr6XMC/1GCYJf6fCKqHzX6L+/KspPq5OJxDI5RTr0ENfzcbQczFiudk4WzBaPARcZ9T
         A7BCm5/wknvgorsdpUkliY6Txcdy1IRc0pHC7yGuxNRyzegaF3ypHHpJpfpbt4rwi/m7
         cgOhKl4gelIcSHFHyYJOP3Cw8MbrDJE5/+WN4HY+UL0hOUHNmRV4vnNwEpc14liPbPcT
         snB5tEQxTm8klzovZ2DFjmbvSZI6LPmyiejRoYXUPy/eL49/JwsbZHf8AXm41ALVaWbb
         pt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712094134; x=1712698934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fwziIr1L9R6/fqNLKR2OlkM0SoO/VH14UfpluEni6E=;
        b=POEIZHwmS2yg0iM1htApBXQ5hdnrZDNBiCruTpDUKzapE/d/fdEP8tywlZYcIsH8Hc
         jTvjuIIR3g5bVWCR6GbvU43luOeU1sG4WEZxhgpUJ0VEeOmOO8XONIIOVBei8txuezxy
         9ib37OPCPAgyS7+AoO8Y397K9NIWKHze6vrwIgm6cw0eyeToeMC1NtInj2UYRfGpxH2t
         KpGQp6paNmpijFs3gxpxtdl6Tuh003qbmVTdVjI92hJatjfBwUO+NxdLWUgOrDTAl980
         ahW89O8vDGg7hjuvhtkW649j7FgheGy0isOkjLRRkWBCeus9/uvYLUVhS1zGWX2YrboT
         DQYw==
X-Gm-Message-State: AOJu0YxBF2dceRTJvd6B5HIYvaZB1HN8TCpdqighJKNNVQNh2ETigiYC
	M3L8VXHAiE5hGBMjnOt+MilUpRIK72wghnYVj+uNkjIbe4Ojo/ScWdsTOPSEJ09YHfPBFHuHeLf
	FPQ==
X-Google-Smtp-Source: AGHT+IFBjiQ2L4DIQS5fUv63HRZxFEEzzi0CS3Mc49jsvFyZ4zOHkm7TwGVNWLku6kb8MW8u+7HAAaPHfnU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1884:b0:dc6:cafd:dce5 with SMTP id
 cj4-20020a056902188400b00dc6cafddce5mr4165340ybb.12.1712094134277; Tue, 02
 Apr 2024 14:42:14 -0700 (PDT)
Date: Tue, 2 Apr 2024 14:42:12 -0700
In-Reply-To: <DS0PR11MB6373543451F0505C220F2C8ADC382@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313003211.1900117-1-seanjc@google.com> <DS0PR11MB6373543451F0505C220F2C8ADC382@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <Zgx7tA9c8RYv3hVa@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Skidmore <davidskidmore@google.com>, 
	Steve Rutherford <srutherford@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Mar 31, 2024, Wei W Wang wrote:
> On Wednesday, March 13, 2024 8:32 AM, Sean Christopherson wrote:
> > To: Sean Christopherson <seanjc@google.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
> > 
> > No topic for tomorrow, but I'll be online.
> > 
> > Note, the US just did its Daylight Savings thing, so the local time might be
> > different for you this week.
> > 
> > Note #2, PUCK is canceled for the next two weeks as I'll be offline.
> > 
> > Future Schedule:
> > March    20th - CANCELED
> > March    27th - CANCELED
> 
> Would there be a slot available on April 3rd?
> I'd like to have a discussion about KVM uAPIs for TDX and SNP Live Migration.
> 
> CC the ones who would be interested in joining the discussion.
> (Hope more folks working on the SNP migration part could join)

What exactly do you want to discuss and/or achieve?  We can have a handwavy
discussion about TDX's needs for live migration, but there's basically zero chance
you'll get concrete feedback on exact uAPIs at this stage (we haven't even nailed
down the core TDX and SNP uAPI).  Doubly so without first giving people *something*
to look at.  Even a very rough RFC would go a long way toward showing/describing
the problem you need/want to solve.

