Return-Path: <kvm+bounces-24554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A73B9576F1
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 23:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26215283AA4
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 21:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D86D1DC48F;
	Mon, 19 Aug 2024 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ykPThEUD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C847158A1F
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724104665; cv=none; b=Cl5FWwv8g7O542WeJjD9JIPkMCwcRiaK63zpaesLRRxHz9idroYoCEnWWDrr9Rijg/xlX1Gi2qBHrjHpxgtS73v5u/hHATeHBWFlOZsX+07dAB05kJjvlMkfocuOPKth3p5ZmXfPZY96hjv4J6Tfz8sbD1b0nlAaFvDrxBrBZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724104665; c=relaxed/simple;
	bh=11AWEfeX8gkNsffN6s/jopBvYp//bAcM4ZD0b3umqus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKx1bgSipiqKujarTQU94C/wpSxHy5Nz+AoHTapgOsg+7d9xD2xnnOGYq/zwOpP/EHAvniDkE2dFirU4ZgH6PqKXrRuldugM9IGna6IsW+GCRiyjRpq9piS0e7ArpQLDGfxMaUqh3unCYc1d8TJfo2RceSOz5xOijPoP1MIFDoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ykPThEUD; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7126c9cb6deso2918155b3a.0
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 14:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724104663; x=1724709463; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jPe01YcT8Gb8uoOTu47oxOa1X4IlqTXEEaghEJldB3I=;
        b=ykPThEUDdujpeop19zSKPE51YO6aI92nhtYNDBoqRpGM/nLpK5BMDDZ2D0HvXjwIHP
         3LYTWPOcBdLe5f6M0mmi4P/ykXBwlZzksqaLuJTPKrj+BtSlsVE3GiMXNzUjQEyycyE7
         jz7P+xan/g6LZuxr1Smo8vQO11619a7gZcPWBNoW1XNTjXyjqLvI0SoWj2nhMAdbOAFy
         f2t2zWlCnxyztOJPEjg4+gRGRzabAyuUqz5aEYMiDLS8AT6QhM5cs7PDeM76kwn7xGXq
         idMEa0xGbaR3zP645khsoDwklXmrfhGimtYUU8tXOzym83Gf4NmxpodWa2lJNxhOIEDM
         Gppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724104663; x=1724709463;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jPe01YcT8Gb8uoOTu47oxOa1X4IlqTXEEaghEJldB3I=;
        b=POlGuJOhqomIZbtB244t9WJvH0USR+i3cqeVZ24w/ntlvcO0ih9RTeD0futPFdmCq4
         J9LrrRtSaqhhLaaTUZFFXm4AcbjG9xdzLloP8Us79A2DXJN5JX0aCWdyZIQGHkfca5ky
         O9XKGrQscHvu7LhXAIKOL9aWNZOtgzUyBKW+YKIYpVPk30Lq6qjzr+4djcpc0zljcy5/
         zepPKOfQXLma4ZFb9Nq400G/L7ghgKq1FbAL8BG+BchKFVmBmKBjAYHVXyEqLeivIm2F
         vkAFJSqVs+MkmdzKpP0DP4QFchh26Yj5rlt09WzM1OpXADWMI0HNtty/algBxiJfl/es
         y+rw==
X-Forwarded-Encrypted: i=1; AJvYcCVeyLpXEmjCeFyhzcxkaZHUpIubXtnO5xC88qk+9VUAZ4+in/YWOLtugMwBRcwaGiBKSW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+muc2QPEicvp+YF73TKfZ3fPFvbLSMOa1P7t4kMtcy/97uRjo
	iTZeJu3B/tMgwY6fjGyjMGKQV/iob+kFurWqWRGhhfSJXg+rBYPuQE1ApZ3kLA==
X-Google-Smtp-Source: AGHT+IGkVnv3j3x/OZV8oCttMMGrwCrhUjxZczJ0g0gJTVKT3XRuoNTXPGo1tEKRTpwDQeRZh5PHVw==
X-Received: by 2002:a05:6a00:14d2:b0:705:9a28:aa04 with SMTP id d2e1a72fcca58-713c4ed2c6fmr11932026b3a.23.1724104662882;
        Mon, 19 Aug 2024 14:57:42 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aef3c47sm7005835b3a.102.2024.08.19.14.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 14:57:42 -0700 (PDT)
Date: Mon, 19 Aug 2024 14:57:38 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into
 TDP and non-TDP flow
Message-ID: <20240819215738.GA2317872.vipinsh@google.com>
References: <20240812171341.1763297-1-vipinsh@google.com>
 <20240812171341.1763297-2-vipinsh@google.com>
 <Zr_gx1Xi1TAyYkqb@google.com>
 <20240819172023.GA2210585.vipinsh@google.com>
 <CALzav=cFPduBR4pmgnVrgY6q+wufTn_nS-4QDF4yw8uGQkV41Q@mail.gmail.com>
 <ZsOPepvYXoWVv-_D@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsOPepvYXoWVv-_D@google.com>

On 2024-08-19 11:31:22, Sean Christopherson wrote:
> On Mon, Aug 19, 2024, David Matlack wrote:
> > On Mon, Aug 19, 2024 at 10:20 AM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > On 2024-08-16 16:29:11, Sean Christopherson wrote:
> > > > Why not just use separate lists?
> > >
> > > Before this patch, NX huge page recovery calculates "to_zap" and then it
> > > zaps first "to_zap" pages from the common list. This series is trying to
> > > maintain that invarient.
> 
> I wouldn't try to maintain any specific behavior in the existing code, AFAIK it's
> 100% arbitrary and wasn't written with any meaningful sophistication.  E.g. FIFO
> is little more than blindly zapping pages and hoping for the best.
> 
> > > If we use two separate lists then we have to decide how many pages
> > > should be zapped from TDP MMU and shadow MMU list. Few options I can
> > > think of:
> > >
> > > 1. Zap "to_zap" pages from both TDP MMU and shadow MMU list separately.
> > >    Effectively, this might double the work for recovery thread.
> > > 2. Try zapping "to_zap" page from one list and if there are not enough
> > >    pages to zap then zap from the other list. This can cause starvation.
> > > 3. Do half of "to_zap" from one list and another half from the other
> > >    list. This can lead to situations where only half work is being done
> > >    by the recovery worker thread.
> > >
> > > Option (1) above seems more reasonable to me.
> > 
> > I vote each should zap 1/nx_huge_pages_recovery_ratio of their
> > respective list. i.e. Calculate to_zap separately for each list.
> 
> Yeah, I don't have a better idea since this is effectively a quick and dirty
> solution to reduce guest jitter.  We can at least add a counter so that the zap
> is proportional to the number of pages on each list, e.g. this, and then do the
> necessary math in the recovery paths.
> 

Okay, I will work on v2 which creates two separate lists for NX huge
pages. Use specific counter for TDP MMU and zap based on that.

