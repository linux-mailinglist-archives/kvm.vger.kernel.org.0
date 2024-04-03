Return-Path: <kvm+bounces-13470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7274289735B
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 132421F21A2D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C400E14A083;
	Wed,  3 Apr 2024 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G648maVc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C17F149C4B
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712156647; cv=none; b=WmjsB029bztv9WOorDRNkXrbXWUHrlHDscLtfogIjG/GrvmtzOSrcSeyY4QzhA3CuMTwPUUz+SvywM36xJMz42X8K/bETX7XxZqp3OzMMts68q3g2ZQX13z/8cfVspnJwUkPwZCM0bZ/B8gdyJkkQQQ3ejs3NELrNs5Z3DrFGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712156647; c=relaxed/simple;
	bh=+5o5zP59wSQFL2zykRGCByfv1vZWjUga5Qtwrzw0JwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=txTBSc8LwEcZKXUDapsMqKavEKcq9vYxFzycm5FS9Jcz9tySDOBnQ5qd7q4b99jLvyFFyjhxVMoP7H2AjxrNIx2hgnpUXowDgu+50GDtmgY7N+xjzP3M/ingIZR8XuzMEP9hw0Smu71ZydvdW3Bq0KyIOSzU/N1esb94FyMncwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G648maVc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e28ec091aeso9058905ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 08:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712156645; x=1712761445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2CFD4RCP3K0RMlQFKNQ4bqH2ptR6QIZ6/qTQHfdpY2E=;
        b=G648maVcCuqMdJjD3BhjFGk04BFV7JMTXMkesad7JagzXoXw7W+37RLbCVSmwa/93Z
         BJvyQnMqq1Yzespxyzcd8n2Nc7/JM8cXdWi8fHX2xgCAynmY8U+mHYv6wWdWYofmLEqO
         9++ERlJoNpebu6/xmq+pTT6YCzRr8F5wjoikS/9XZ3JAbwFNbCbNcYjgYg9hXMsr2Vwt
         RsTRFj+m4X+n2nJxVhgK9lN21Gr+RmbHUdLL3/W5wNg2dW1kfoUATI7PJ9gY0fQOCvQr
         QtOgsZAr4mIT7CgwGqk//ma3fMzLIRM9HpmntQM0whBQ77maJ6j793IkB8+ihJreHnzR
         o+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712156645; x=1712761445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CFD4RCP3K0RMlQFKNQ4bqH2ptR6QIZ6/qTQHfdpY2E=;
        b=Vo3FFC+XOujXyAJHlO+ip43qZ+Ekq8twDotexKZWYLabmFTCBgmXStWzBus7S7h8Ck
         P2H8gVwnrpV2gwnmdDiBxBSLrS4o93T8bCEj0/wcMpsYjbcYwt7FN0r+2HMQvQFVP/7y
         BvRdX0TPkmdijltRYPb81lN1V3ul3MIARf2Y5H9T39sJV9ysAGbXJV7FB0pb1X6G7BjF
         OUljpAkMUhj6wa101xbt0p67wteiZTmUZUjXWnbEIzwvBDE65KEHbJiu+dPQ97Fg3KbO
         n6y/zdMu1LL+BA+9eW1013cd5ifNhVUy3FLY9zFKfSQoIcTavu9bohkqUeEDAxzIEJGc
         onEw==
X-Gm-Message-State: AOJu0YyuUuizEQnrua5jzwA7r/LFBln9N6Jkm6njRDtgc9LeUwyAYp/R
	b3PAPom1JbeY7XPJmFIsXXHbTPwG09JiIZmDVnyo2OsKxQmrHm5g+fmgSoIZAmexD0oUyY9wuzr
	8Wg==
X-Google-Smtp-Source: AGHT+IE6RHhmhd3B7NJ7YHHIKT47IulRyjSKoQOpHeeWB720Gu1Xoo4SkNnFXiYkV2UKj33jzFI3TGqSD70=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db11:b0:1e0:d205:2da2 with SMTP id
 m17-20020a170902db1100b001e0d2052da2mr597057plx.3.1712156644742; Wed, 03 Apr
 2024 08:04:04 -0700 (PDT)
Date: Wed, 3 Apr 2024 08:04:03 -0700
In-Reply-To: <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <Zg1v4wSgPWiY1Tok@google.com>
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural definitions
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> +union tdx_vcpu_state_details {
> +	struct {
> +		u64 vmxip	: 1;
> +		u64 reserved	: 63;
> +	};
> +	u64 full;
> +};

No unions please.  KVM uses unions in a few places where they are the lesser of
all evils, but in general, unions are frowned upon.  Bitfields in particular are
strongly discourage, as they are a nightmare to read/review and tend to generate
bad code.

E.g. for this one, something like (names aren't great)

static inline bool tdx_has_pending_virtual_interrupt(struct kvm_vcpu *vcpu)
{
	return <get "non arch field"> & TDX_VCPU_STATE_VMXIP;
}

> +union tdx_sept_entry {
> +	struct {
> +		u64 r		:  1;
> +		u64 w		:  1;
> +		u64 x		:  1;
> +		u64 mt		:  3;
> +		u64 ipat	:  1;
> +		u64 leaf	:  1;
> +		u64 a		:  1;
> +		u64 d		:  1;
> +		u64 xu		:  1;
> +		u64 ignored0	:  1;
> +		u64 pfn		: 40;
> +		u64 reserved	:  5;
> +		u64 vgp		:  1;
> +		u64 pwa		:  1;
> +		u64 ignored1	:  1;
> +		u64 sss		:  1;
> +		u64 spp		:  1;
> +		u64 ignored2	:  1;
> +		u64 sve		:  1;

Yeah, NAK to these unions.  They are crappy duplicates of existing definitions,
e.g. it took me a few seconds to realize SVE is SUPPRESS_VE, which is far too
long.

> +	};
> +	u64 raw;
> +};
> +enum tdx_sept_entry_state {
> +	TDX_SEPT_FREE = 0,
> +	TDX_SEPT_BLOCKED = 1,
> +	TDX_SEPT_PENDING = 2,
> +	TDX_SEPT_PENDING_BLOCKED = 3,
> +	TDX_SEPT_PRESENT = 4,
> +};
> +
> +union tdx_sept_level_state {
> +	struct {
> +		u64 level	:  3;
> +		u64 reserved0	:  5;
> +		u64 state	:  8;
> +		u64 reserved1	: 48;
> +	};
> +	u64 raw;
> +};

Similar thing here.  Depending on what happens with the SEAMCALL argument mess,
the code can look somethign like:

static u8 tdx_get_sept_level(struct tdx_module_args *out)
{
	return out->rdx & TDX_SEPT_LEVEL_MASK;
}

static u8 tdx_get_sept_state(struct tdx_module_args *out)
{
	return (out->rdx & TDX_SEPT_STATE_MASK) >> TDX_SEPT_STATE_SHIFT;
}

> +union tdx_md_field_id {
> +	struct {
> +		u64 field                       : 24;
> +		u64 reserved0                   : 8;
> +		u64 element_size_code           : 2;
> +		u64 last_element_in_field       : 4;
> +		u64 reserved1                   : 3;
> +		u64 inc_size                    : 1;
> +		u64 write_mask_valid            : 1;
> +		u64 context                     : 3;
> +		u64 reserved2                   : 1;
> +		u64 class                       : 6;
> +		u64 reserved3                   : 1;
> +		u64 non_arch                    : 1;
> +	};
> +	u64 raw;
> +};
> +
> +#define TDX_MD_ELEMENT_SIZE_CODE(_field_id)			\
> +	({ union tdx_md_field_id _fid = { .raw = (_field_id)};  \
> +		_fid.element_size_code; })

Yeah, no thanks.  MASK + SHIFT will do just fine.

