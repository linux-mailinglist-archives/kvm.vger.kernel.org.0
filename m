Return-Path: <kvm+bounces-55773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D4CB370A9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 18:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77E331BA2989
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DB436C093;
	Tue, 26 Aug 2025 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e8o1NA52"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96824369340
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756226300; cv=none; b=amjeSjNNfRQTHWYaEwlzy86e2ytPjbCrqI/ld4CHQCz6Qf7JeVyeAubXOE3eB5Jj/hxApP86ZKp4CgEEIPkXpgcoSPaj3biQWjtDbOruFUaIPMkbVcA5OxY+pfgQGPo+xmVkCmXp3CAS77uvClTdsXtcXO4Cmv0l1p+VbW4VQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756226300; c=relaxed/simple;
	bh=IZA6OL5p8O+5QNVz1cw/X3Wrim59+EoqxbFxaryX0Cc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m538P7cSNdji9YFDPqpJ7EsS06fInFSlRVWWPUAHiH32cXYnMF5K5XpUDdkjwneAwrGqFuV6Eeql3P5fwQr9t/mjPnFYH6YedyKSg023PrpisMeHGKwGGxBqSkz/plfbC1Idc94NkIIuE+PG5L7Fzax1olVt9uSXuxO0vGL6VyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e8o1NA52; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471737c5efso4340962a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 09:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756226297; x=1756831097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KArhLKucBXK1qma7WLAGLPHRkqsc2bT2vqsvNWf6PMM=;
        b=e8o1NA524f3NKL/ph8L3v/cRKbXvrP4LfgBiux/K/hKN4MHdDHYUAdHXx8nz1h7g/8
         thQeU7L5Q6itRTejj1d3uI7rxYy2VzOJPs/EIaZ/qHY822Nqcn4HGJTx1ccXYeVD+07q
         y+NvdwhgBtOIK2XRc1Cr2pNwYL5GPGcZHaDKiZ5ym7O+fU3Yzky660ErRCxNz9vHTgJP
         utnjihofGdYw1UNWCC4pYBAHemgSwbHTmEhlrGATocS1rrxmP5pUFQ2bHhFimNCk7tFn
         ZAh7vlFMWgXVB8nlHf+FjBMnT5m5nKcANLfvaEPokCu6RDlwg+BrHDjfRCfQmw5GRTpv
         gABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756226297; x=1756831097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KArhLKucBXK1qma7WLAGLPHRkqsc2bT2vqsvNWf6PMM=;
        b=vaUD4sw5WLOlDc1Qz9Jg9+OPyT34KRZ0fqhfvwXRX5CiuRqLPd4XwhlTqHXg40Jcdg
         NHb03G2eJEpITjjmM3yuoAuok+2fFiv9o9VRbr7wtvQlsAr8kiXDhieI00bsdjkBwVZo
         eBvfr6c06bGZF0AnaBGGuDPCCF8J1cyRHFwwBOVxZp0Ft1fYp+tAP46CvLqLbbmCXCHH
         AQEoM+Z5AWqqoeTmlKprCyNyAIodJrc1KiT5VP3uxbrwzVRAz5dxW5dB1IVtbtmIpGjq
         GCJYNYOvccOoGK+hhc6Uiwk4lTmWS04J5T2oATBaABJlAQWao9NHsd0G6ZQRIRIHtDbO
         0Ylw==
X-Forwarded-Encrypted: i=1; AJvYcCU7kqk83ODblcKFVI85PnOrAhju3vgTWv5ArxA+owxE780sS911tqbgX/Jm37XVoMgpiYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzULk7AYsZmj1iO4uQEoItqiXU+L3++gsjUaI6FgrhZqV0mirdK
	t3NSqrluSQgPlAPya8jtVv91g8I1HaYc2GhzMBC8/sv28t7BmdID2YFJg2MAL9HBOsYq7hU33HO
	QA/oKvg==
X-Google-Smtp-Source: AGHT+IHW22aqV9V9u5Zze8D3GfPgtdWWFsehZkrUkllA1TCvbFhmXlWXij1jXskDhKIIjelfwPENG1eV3eQ=
X-Received: from pgww6.prod.google.com ([2002:a05:6a02:2c86:b0:b4c:2bd1:3d27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b32a:b0:243:6e7b:9666
 with SMTP id adf61e73a8af0-2436e7ba22dmr9292868637.28.1756226296889; Tue, 26
 Aug 2025 09:38:16 -0700 (PDT)
Date: Tue, 26 Aug 2025 09:38:15 -0700
In-Reply-To: <aKv1VNFiOPJZBN/T@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-11-sagis@google.com>
 <aKv1VNFiOPJZBN/T@yzhao56-desk.sh.intel.com>
Message-ID: <aK3i910ghgsaIkir@google.com>
Subject: Re: [PATCH v9 10/19] KVM: selftests: Set up TDX boot code region
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sagi Shahar <sagis@google.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Yan Zhao wrote:
> > +	/*
> > +	 * Handcode "JMP rel8" at the RESET vector to jump back to the TD boot
> > +	 * code, as there are only 16 bytes at the RESET vector before RIP will
> > +	 * wrap back to zero.  Insert a trailing int3 so that the vCPU crashes
> > +	 * in case the JMP somehow falls through.  Note!  The target address is
> > +	 * relative to the end of the instruction!
> > +	 */
> > +	TEST_ASSERT(TD_BOOT_CODE_SIZE < 256,
> Looks TD_BOOT_CODE_SIZE needs to be <= 126, as the jump range is limited to -128
> to +127 for JMP rel8.

Gah, I managed to forget that relative targets obviously need to be signed values,
and I also forgot to account for the size of the JMP in the assert.  Go me.

Maybe express this as:

	TEST_ASSERT(TD_BOOT_CODE_SIZE + 2 < 128,
		    "TD boot code not addressable by 'JMP rel8'");
	
> > +		    "TD boot code not addressable by 'JMP rel8'");
> > +	hva[0] = 0xeb;
> > +	hva[1] = 256 - 2 - TD_BOOT_CODE_SIZE;

I think I lucked into getting this right though?

> > +	hva[2] = 0xcc;
> > +}
> > -- 
> > 2.51.0.rc1.193.gad69d77794-goog
> > 
> > 

