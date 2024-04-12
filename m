Return-Path: <kvm+bounces-14541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D12888A30A9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D383281E7A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BED5128360;
	Fri, 12 Apr 2024 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AUhnlzLK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB0C127E1C
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712932053; cv=none; b=fa0e0yA+1BsYH9FsnqFwGZ4Wh0tTJLsykADd6ZWLW6RjZpsgyimDEwAekZbXHz+SXKb39QZyivtHMbfSTZDv+GGxgd0VbRj/Aoy0fTRlmOMeRhc1HSr2RVHk1D3KA8T1JZWX46XYlstnzbVIg3g3MczWFdUsqd3ahGnFxthlJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712932053; c=relaxed/simple;
	bh=7ZpOjyhJVYHo6veueLDSfC6MEFzr8Ojbs3xFBxi2+W8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=afNjdXBSxJqxXEUYIiRGrNsPY/5HeMZB+Q8wo7+JzIpVRiZDh34Q/fHZyugBMQJ5kOJzmL6uDwycPM3XxxSe33tS3m63NQSWbPJIoJrd94KmH43J7BBXSmkyAsx3UcGMm9laEqKMGzP677JI+se+8gpIipE6NWvoF3nta8a/E2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AUhnlzLK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e41c665bb2so9314215ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 07:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712932052; x=1713536852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CTokiC2mOzeQb1t9UZXBIQTwfHhJ1xAuH+06DQhJnus=;
        b=AUhnlzLKqTZDu6/WL+d3R9yn9IsNJPxyUT8YB+Hmh0HHqPpg9NL6kQOPhRs0w8VyWk
         NKtU+BojmF/+nRDY7AtsXxxLIDqPj2cStfcqX7VZlOqCgnGQUaEQeCLoPTDUzvpxbGV9
         BNLou0SaOCdObdzUosPn28Y9CCZZKMg+01SO1b1JhvTmwaecBp6CQDnx1ve8DWyJuaUV
         qWLzjWiFNoRC/C1zxYLDQ3Fwjf+ync/AfXUv0gLoRPk4enxkiqxR/7Lf0N/FlNmd6xFE
         CqY2Qe7DtokvPjbWQD/CB1YJw02HOzXcAEcqnuScQTvoxob1c3xPOty4VYTu0tYcrqpc
         G9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712932052; x=1713536852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTokiC2mOzeQb1t9UZXBIQTwfHhJ1xAuH+06DQhJnus=;
        b=F0iiIPM10x9coBgvPOjaJ/fxZI9PFPP6oF19QDHXXCNlhzXRNN5bVQRIsKpi0YV6WZ
         sCLph0aDal2buaOyTGwuL3z2j5rMdTtNSxhB9u1VMNXYjWxubCwFpgNQS9vuCpwOh0kL
         85JfaWcqqCgMOddqH93RoyafMb6xyaIIBtr/urIXYCowZERgi4hLh0PJcJo4NgccfDTd
         XRa09eEXqz9Ny+BmTLStOIrcJhPQi51r//oxJller8IQulaTyg/eN53HgwuC3d99wlba
         1DraXcBptcWd5iDU3aCSdM3O804a+HA8ZI4vBo82n5h95enIP49162wjakh+ae8gdVEL
         ZRVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNnjCb82B8AH7+nru/LP8vMh83J3iWhwPMAC3RZ/r2Iu3oqcKq7JZNpABmeV+wIDJJrCyxlsh/IQslbyy++pv955o3
X-Gm-Message-State: AOJu0YxlJ0GUM28HOeDwADJzzJy8/prv2HLN2T3WvOKgxqB82wTCuQq6
	XnDacUD8kUyimOOCcQRWJS5WH7XuT3tsBTBDJvfWYRaZRQ4YEANOHcKfRZcjs/5ljv3wq8xHZCp
	DAQ==
X-Google-Smtp-Source: AGHT+IGLwF+HfzZtGn8zwa1qm1dvlv2UkAX6QqEas4f4AXsrP0etNn5dV5dMejYckrKUvPHWx3YS/a/UIOw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db08:b0:1e5:10e5:344 with SMTP id
 m8-20020a170902db0800b001e510e50344mr8380plx.3.1712932051773; Fri, 12 Apr
 2024 07:27:31 -0700 (PDT)
Date: Fri, 12 Apr 2024 07:27:30 -0700
In-Reply-To: <BN9PR11MB527609928EA2290709CDB3E78C042@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-6-jacob.jun.pan@linux.intel.com> <BN9PR11MB527609928EA2290709CDB3E78C042@BN9PR11MB5276.namprd11.prod.outlook.com>
Message-ID: <ZhlEh7-NoknHcNX7@google.com>
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for posted MSIs
From: Sean Christopherson <seanjc@google.com>
To: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	X86 Kernel <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, Peter Anvin <hpa@zytor.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul E Luse <paul.e.luse@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Ashok Raj <ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, "jim.harris@samsung.com" <jim.harris@samsung.com>, 
	"a.manzanares@samsung.com" <a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, 
	Guang Zeng <guang.zeng@intel.com>, 
	"robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Kevin Tian wrote:
> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> > 
> > +/*
> > + * Posted interrupt notification vector for all device MSIs delivered to
> > + * the host kernel.
> > + */
> > +#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
> >  #define NR_VECTORS			 256
> > 
> 
> Every interrupt is kind of a notification.

FWIW, I find value in having "notification" in the name to differentiate between
the IRQ that is notifying the CPU that there's a posted IRQ to be processed, and
the posted IRQ itself.

