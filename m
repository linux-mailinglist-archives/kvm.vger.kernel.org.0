Return-Path: <kvm+bounces-30427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3F49BA83A
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 22:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD20F1F21907
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 21:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAEC18BC27;
	Sun,  3 Nov 2024 21:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfiKyrlm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45915C14B
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730667985; cv=none; b=rC95CtOG5AWY9407mQzRrPEiCJ09XuoanuqJWyE4bOA0OII8/NPCFS3hZlC217IS8NeB3AbfWd8PdXyibubYENthfo5l/LZFU9mZN+gSb6ZNzjerBqSrOQSDR+NSWBulPDI71CouOccU1NHL0kqIdK5LasFuUIS8hd2ayFueQ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730667985; c=relaxed/simple;
	bh=oPAJCG7hrUdHVCnb3+m/VDmd4h0xWqow3WZ4/2qIEXs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UsSIZhQoSxVzE8RyhKNqUjX71P2ngStlZzRpIk+DWYS2vSsDyLB+uo973KaVODdjp2GSRagw/QG0tmi63U4fiJsV7CtE0tskMddqjCiSfXmpydP17FLKlC4XcHdS9n77/J8Jd5DpWYFPUYCTcvosACY6UsZIxN6FPRxAsT7HMfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfiKyrlm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730667982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHM6T5AqN1lYPPSm+/EM3PEyhUjuLX9FipGItCaU10I=;
	b=CfiKyrlmIVLgJJe5DIyHc4BUmt75+JGkCtH7EKwIbNqi03KOtfQAlU/5CEQ3LlIgDnykhx
	fyOxQG+VHgqQv51FueZ1sh3pD8yt2YN30IAgNWNXe/gVyOSEDC72sCj6BtPqvzXH8uZtqM
	sBL1a5G4aW/0TSe/QIMYIPAUEHpGBeQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14--N_IzldkNcadL9guRbWWDw-1; Sun, 03 Nov 2024 16:06:21 -0500
X-MC-Unique: -N_IzldkNcadL9guRbWWDw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6cbe4fc0aa7so66302776d6.0
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2024 13:06:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730667980; x=1731272780;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XHM6T5AqN1lYPPSm+/EM3PEyhUjuLX9FipGItCaU10I=;
        b=IUBXl7srIbEkT8UPJtRtWo3LJAbJhQ7CRkGF+fg/ziy6kI0tMamYU9otJ0r4ljUjRc
         Anm6mIyQhGD556C8UnfskEC9ECdyWjfhSchm9ZaEENpaxJC5MGo6TjBRxgH1nWuIoxFh
         XaQ26UOU1g+HDXEUso26AhHtGyk3ug0GA9gdcO2LhSBQ26Ee3+mYYCHido9rxErXFkMY
         /kRGg+evkEiLdZ+aBMcJm2rYomf3yhwYJyoV7MFF2WGewbUQHA2QoiMpFZMX6/ycplPG
         6znOhmeVLR/Sd2IL/rPk5r/OxSQc3dvBBMmCQK62U6pysNHYBKlw0qnj9ZuW1mzultpD
         aDPQ==
X-Gm-Message-State: AOJu0Yxde9giH159lyBtPt73HWOHowhp2cOjoXbG/mPQuq3x2XYx1khU
	ONDIOHX1ERuLR9RSiR4nW3p2BCrQGRFaKZjW+gMX4L8IVI/n1mijjnazrO0+5OhdRyCAC8jxQJf
	C/v6xqRbUDmRYucGEIy2W0FyT/bhCd1rTHrTywAatiEowSUGBtHqN6LMbF2PadMLSissEpmOY2c
	bz1zZv6Y/DLFmWDg82AjpY5A2dcYbjUpXPqA==
X-Received: by 2002:a05:6214:398a:b0:6cb:fff6:8f28 with SMTP id 6a1803df08f44-6d35c19b926mr170916686d6.40.1730667980159;
        Sun, 03 Nov 2024 13:06:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFA7pNkISiVmJw222/4eTPak+P8OI62sRXFUXOoLNDdXbU88KturC4Nj1I/PY6GCwx6pPvdOA==
X-Received: by 2002:a05:6214:398a:b0:6cb:fff6:8f28 with SMTP id 6a1803df08f44-6d35c19b926mr170916366d6.40.1730667979820;
        Sun, 03 Nov 2024 13:06:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d35415b2c8sm41381006d6.84.2024.11.03.13.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 13:06:19 -0800 (PST)
Message-ID: <3956ad6d2261105c479a68c55acc87bd94ab202d.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 03 Nov 2024 16:06:18 -0500
In-Reply-To: <20241002235658.215903-1-mlevitsk@redhat.com>
References: <20241002235658.215903-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-02 at 19:56 -0400, Maxim Levitsky wrote:
> While this is not likely, it is valid for the MSR_LBR_TOS
> to contain 0 value, after a test which issues a series of branches, if the
> number of branches recorded was divisible by the number of LBR msrs.
> 
> This unfortunately depends on the compiler, the number of LBR registers,
> and it is not even deterministic between different runs of the test,
> because interrupts, rescheduling, and various other events can affect total
> number of branches done.
> 
> Therefore drop the check, instead of trying to fix it.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/pmu_lbr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> index c6f010847..8ca8ed044 100644
> --- a/x86/pmu_lbr.c
> +++ b/x86/pmu_lbr.c
> @@ -98,7 +98,6 @@ int main(int ac, char **av)
>  	lbr_test();
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
>  	for (i = 0; i < max; ++i) {
>  		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
>  			break;

A very kind ping on this patch.

Best regards,
        Maxim Levitsky


