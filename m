Return-Path: <kvm+bounces-3145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5F6801074
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AED7A281C21
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B16495E4;
	Fri,  1 Dec 2023 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="euADoSzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B557EF1
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 08:46:09 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c6065d5e1bso753748a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 08:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701449169; x=1702053969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=trs7IYTBAladXDE5IaepbZIO/2tonStqNHjIpFvn3vs=;
        b=euADoSzLorY/O7MB9yfNpJpPfxoNMGBO3gjrEsVfcNQz9tRw6XmQ/1zpmS71Losjt3
         CJHRuy/XC9ljcvoz5vNCUkuoG+AtKf1oV5AHeIvQLIZZ+0dAB6WherAiuFBBpdNzt/76
         LPk/xT3A4NA96rQDeslproDTJJqCTFVb7Iff8vkHNQpSjG3ZwvQdT5JDBY2mIQ0LHjMY
         uR+A5pAqsJUB7fkNUvycOfyAdpxKVJCrhgAHKpF1r4kiy9VdEX46e+Vct1InogC1s8aZ
         Yxx4FSwb74EB8UyIL6zLDr9eixEFdsyzCeTa2jKyUUnpVgclXx+yKtPNstLsqYXcg3gy
         gGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701449169; x=1702053969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=trs7IYTBAladXDE5IaepbZIO/2tonStqNHjIpFvn3vs=;
        b=OL7YcQxsgGmBWHGqvCuVsJ9ZL65JvdWsHeq2muR7AR2XHbwEGFAuq+hzDsWpgV2/Yk
         8il0kpIik5CuwVWKRAwLmAtw/OyQmbEtVq3dQLsHOQSOvLRipnhq3j6upHp+C8g9zk3E
         LHLYm4wnH6fcXuWlUaJx9pmjhhIgSPOFai7+SQ0TH1iiCZPV5mjtQkoaPeqX+wf08+9W
         rCAbnL81kPDiuOC1h/uuj4DEW/57OuPspoUIv8cRB27VI/uZKMJQ0UG+ipU5ErvSW01P
         oIosn6FJPuduqVCTS0nMuPsw39e0I7zYg4Has//jVLpxSbWmBp9UnZ51TASbheGl0BQy
         li8w==
X-Gm-Message-State: AOJu0Ywpy7Fb28ZnvELvpkCO62Lwoem+QChuh9Rf0Wy4pwEMUo06aQTE
	b7Z51V1qxZAtlJ6KBOP7ElVMJPzP+yw=
X-Google-Smtp-Source: AGHT+IHP6cpnWG2mRsa2jQK18nXdBIOg5lQS/IldF/fWR8ov2oZkzKlOr+NQV16UJWxtTBgPXNo0z0l997Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:620b:0:b0:5bd:3c9d:42aa with SMTP id
 d11-20020a65620b000000b005bd3c9d42aamr3892944pgv.7.1701449169223; Fri, 01 Dec
 2023 08:46:09 -0800 (PST)
Date: Fri, 1 Dec 2023 08:46:07 -0800
In-Reply-To: <20231201104536.947-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231201104536.947-1-paul@xen.org>
Message-ID: <ZWoNzzYiZtloNQiv@google.com>
Subject: Re: [PATCH 0/2] KVM: xen: update shared_info when long_mode is set
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 01, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> This series is based on my v9 of my "update shared_info and vcpu_info
> handling" series [1] and fixes an issue that was latent before the
> "allow shared_info to be mapped by fixed HVA" patch of that series allowed
> a VMM to set up shared_info before the VM booted and then leave it alone.

Uh, what?   If this is fixing an existing bug then it really shouldn't take a
dependency on a rather large and non-trivial series.  If the bug can only manifest
as a result of said series, then the fix absolutely belongs in that series.

This change from patch 1 in particular:

 -static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)
 +static int kvm_xen_shared_info_init(struct kvm *kvm)

practically screams for inclusion in that series which does:

 -static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 +static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)

Why not get the code right the first time instead of fixing it up in a completely
different series?

