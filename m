Return-Path: <kvm+bounces-24644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27607958893
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A1E11C20CE6
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 14:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90720191F7A;
	Tue, 20 Aug 2024 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xWK5O1Zm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1619148A
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724162873; cv=none; b=gY1BP39Bk1IaG5ZQx9TISvKTwilxbnLPcp+246J7ZF0nKgjTMfsY/mtojtid3QDKRtkoYrayuE6qjAEOImwyyAI/yIY+jGJCemPO2eJkWvkHB1EZhtetkDco5ZB4GzuLGTSouCb+sWHcuDXCvq3bISvEvFxzjITrs39YZmgMcO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724162873; c=relaxed/simple;
	bh=Gg37DeNsbWmBYNiiahr2QIXw7FkL3ip8vd7XDsHTSUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gfCwn1SL3VL4v7VNnQCkdVYwCKlPxx8ocPWfks9SS6HgLJnNYNX5ZsorxGagV30BIT6Vtzwq1yuuxS9S4Bg7z1nM4S3M9LVbYCgh1XhBoIC1wJT1C0Pc3qZzLki+aNkZjgDh+32EuJDce+tFZbtke+1klOgqDNe8jFcTkX0njkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xWK5O1Zm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a1188b3bc2so4225788a12.2
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 07:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724162872; x=1724767672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1e6Yzii8DI/S05aUpd3Gkg6xtb8TfqZ0lxoJdgbmpvA=;
        b=xWK5O1ZmzI9BiruHGjdJ0B5ai/Nl4l/vPJo8+wes4p/pyAtyUSuR0P2Xl6cjvP89va
         kfw7H47SzuqTIw/e7QeQr4uOvIxHQe5AHMt1rPjhAcX/6NvYs+o7TUMVvb+Ia5vRaJti
         2bvl+gBs+GrdkNbMEdBiZ27ac6KNjzk6mwv2D3/NlBTsbX22evFleACnz6wFcsEDmlDA
         kj2mmTfu7Jykzgm+YsWG88KcEDHd7U/HFGOahe7XFFMlJSn0Tm5FNjyp5NldCeywAAtm
         zI7FmW2Mkbj7+kyAAG+U8BScYzCMPJxpiTdcfi5F6mK4vymaBvWpyGOnUIPG1msZ6J17
         cNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724162872; x=1724767672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1e6Yzii8DI/S05aUpd3Gkg6xtb8TfqZ0lxoJdgbmpvA=;
        b=uiYkGSMB9HPon+ly+ea8tPGzPTmDGBTSfYmDepTIUxRdv7yEv5/ggLm2x36lFn7Bx2
         CrRxivYpohgtuoxkionFNz6vv/CBjgSrEdB1x0sQBiwnvURK9o/IQZPP/YZ9zPswPBOL
         lbt39h+0vEliX/3fAIeoTlnEtBZLonpgTd+ql4DXOdiijgdmgZBw4qL1vKN7vX2aHmBd
         xGXuXfxrn2dQgdvIGxmC/X/MX9PV//JpdigrTHHjV95G5ycBhzWfIOiKg5Uxzuj4F2SS
         kEuk5MbauXSyLraGAF38chfPXbAoCf8p42TeT+H1vaLCiMGCUNWKf4L1XcyY9PYlHDL5
         +GQA==
X-Forwarded-Encrypted: i=1; AJvYcCVCCT+IZdKZWTtvd3I3f4qLLBJwcng6YyKfFAx5quLuVpQ56SZ4DaSyqTmtRoJknWIwAao=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyI0LEYw7340qt2+vWRWSBMUFYk2bZdMRXHPQsQbrw3G//r6tL
	rqfXMvfsrgAuPhdwc3/ANnM6Z/E0UQhZ/GCh4gMVPjH0sLq7lh9KcRJP9KjGxjniHP/+waueSXr
	knQ==
X-Google-Smtp-Source: AGHT+IFZYU+p7sT1518DxW95Pk6T7GD0f+E1CQ6EuDjbtBvJQFg0ZldT+rHEBuxB5igFhmr2Lae8Rlpxq1Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e844:0:b0:6f0:2ccc:812d with SMTP id
 41be03b00d2f7-7c97b33291dmr27349a12.9.1724162871512; Tue, 20 Aug 2024
 07:07:51 -0700 (PDT)
Date: Tue, 20 Aug 2024 07:07:49 -0700
In-Reply-To: <57141688d6c94c789aa416906cacf08f@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820053229.2858-1-david.hunter.linux@gmail.com> <57141688d6c94c789aa416906cacf08f@baidu.com>
Message-ID: <ZsSiQkQVSz0DarYC@google.com>
Subject: Re: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2?= =?utf-8?B?XSBbUEFUQ0ggNi4xLnldIEtWTTogeDg2OiBmaXI=?=
 =?utf-8?Q?e?= timer when it is migrated and expired, and in oneshot mode
From: Sean Christopherson <seanjc@google.com>
To: Li Rongqing <lirongqing@baidu.com>
Cc: David Hunter <david.hunter.linux@gmail.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"javier.carrasco.cruz@gmail.com" <javier.carrasco.cruz@gmail.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Li,Rongqing wrote:
> > 
> > From: Li RongQing <lirongqing@baidu.com>
> > 
> > [ Upstream Commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2]
> > 
> > when the vCPU was migrated, if its timer is expired, KVM _should_ fire the
> > timer ASAP, zeroing the deadline here will cause the timer to immediately fire
> > on the destination
> > 
> 
> This patch increased the reproduce ratio of lapic timer interrupt losing,

Yep, this caused a painful amount of fallout in our environment.

> which has been fixed by the following patch; so I think patch should not
> merge it into 6.1

David, can you prep a small series with both this patch and the fix below?

Thanks!

> commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2
> Author: Haitao Shan <hshan@google.com>
> Date:   Tue Sep 12 16:55:45 2023 -0700

