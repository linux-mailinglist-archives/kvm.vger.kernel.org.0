Return-Path: <kvm+bounces-8135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB23984BDD7
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 198461C20B82
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B6014019;
	Tue,  6 Feb 2024 19:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8WsxCyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162E913FF0
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707246389; cv=none; b=JyN0axx56bg0+XIZVYkAtBRU/bPBui/j34b65wHOAB/h//rr5EsUTHXeTEJSrPOmaeLJ5Xu2X6p/4F2kSNieEccbK1byBO1kC3lEy4aD92/oyawxs+EDiOFzFjSYpBhd/T9oBKEYSWK5A9EpDxQX3zPKIHHdpaq1dCqLqUi9Les=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707246389; c=relaxed/simple;
	bh=NVBhGf7IAJvzcK96zlMqLlD6Q1bmxcEX6YsN5/C9Zo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISmsR9SuOE5X8mt+aa+822vaT5JNoU8x2WiQfCDhMJvfXIlrqARO8FgS7cZ9DMQ89vSfQZplEtUaLgmZX87V+hTG5BcQyEWcfesvbc2dVfYvs9xiB1vuK5OAQTr+uH0zlTXo+2ICr0kKEq01f9wMJF0RAI9decGDioFHEafNAt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8WsxCyb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6cd10fd4aso7941057276.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707246387; x=1707851187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ET+kbsoLBw87Oji7142Cmv1x/DRW/eRUa2vnzmQItZw=;
        b=V8WsxCyblBUcPhxPTUiTB9jAS3LXF1eHFv2nCHLfUrpHuWZFMj8QYsaG6kXouguLfJ
         k1uv09v13JF2gycMPa5v0QzKGx77Gxbi9JYfyW8EK67n8Ll63Ntx4wIEFsIkN3An24wd
         vCXjORZ2t6dV94oEH0Yl4XnWbtYHaVE6EJFf3U/8ytCPeS6I/DPCY+MocdsYeEfHPGVk
         qwy8txR/LjClCHVuM7HbLW1FdhCnm7Vj4iUP5P1jpmV8X7OMeqppXsxeMyG9Be0AW8Gg
         hM47U63YrHWWuucyFmXqZVNy/vG6trE2PpUWN2KU3E38qsDRoB0eFLH9qrgaXBCmDp2q
         tl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707246387; x=1707851187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ET+kbsoLBw87Oji7142Cmv1x/DRW/eRUa2vnzmQItZw=;
        b=PKqwNffNpqSZK+MqzdJR6ENYAAcv0jsP7eVx3V/85fIq8RRwocfkybTUrUtocxzpnB
         7K2LBqdVahutuqD4Zd63FSLwJG1oTjR8XjAUQ4JlqniimxsS98PC9SRC4gAF/vJLtUY6
         K3uNMj+GMqOiz/2CnnhgzNivz75OuhEdX73QHMKphmaWKUSCm6KE6vnyLmDNlz80omcI
         HCF24YE/nlPdOAaIvT0Fn8LuFxtJOqB/4DBTvPUhzDPJPGuPzbjvynuK2Wi45x5YwVWr
         K7P1Wlyw4/xUoDxHOIGyM24GO6clOb8H+JWSibuKrGO0iFnvf9oO2w27gmtlxPy2u81O
         Gryw==
X-Gm-Message-State: AOJu0YxN04Q+rRTYSE7famyiAkZg3otzitFOI/GV6n+1KJEDoN0902s1
	wJurZHA5/YJZF2r3koiSpmruTzZTv4+n+HZ/V6Q+ECxhFvyoDDJIONidoukjc0cFvW8EylF+0ee
	Guw==
X-Google-Smtp-Source: AGHT+IE2N8HG5PrPXY/RUX+Jy+fKWb5gSOhaTgl2c/j3TBvp8YGxniWjWSdnDKDKicaRv/Sr6MZacPf3hsQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:e0e:b0:dc6:dc0a:1ff0 with SMTP id
 df14-20020a0569020e0e00b00dc6dc0a1ff0mr95482ybb.12.1707246387070; Tue, 06 Feb
 2024 11:06:27 -0800 (PST)
Date: Tue, 6 Feb 2024 11:06:25 -0800
In-Reply-To: <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com> <20240110011533.503302-2-seanjc@google.com>
 <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
Message-ID: <ZcKDMeM024BrGw7x@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 20, 2024, Xu Yilun wrote:
> Overall LGTM, Reviewed-by: Xu Yilun <yilun.xu@intel.com>

A very random thing.  AFAICT, b4 doesn't appear to pickup tags that are "buried"
partway through a line.  You didn't do anything wrong (IMO, at least :-D), and
it was easy enough to apply manually, just an FYI for the future.

