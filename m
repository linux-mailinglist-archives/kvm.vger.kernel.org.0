Return-Path: <kvm+bounces-11923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B5C87D2FC
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B26881C2137D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505034CB41;
	Fri, 15 Mar 2024 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtfBDkSI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F72048CCC
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524708; cv=none; b=qhoG4qCzPTQMdrjFFXkLZ1sTrQuE7s+fBImJnlnmEMkAJbB0GZIxQYclDKoJSqts7tXUhxXSbGwdcSqyiNZ8LeR6srtZaJDqtX7o6Bpjdlk/ps5M3Lxn7YOLJB/9Ntg84rCOA/P1yhCN2cQYYjx8rhJsMDCXDe95/QxACCvEVOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524708; c=relaxed/simple;
	bh=INk8cZa0+LsWyZ8N8Wj8NppnFI5IdXvc/S0CKFZ7Zx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KHLtmg+7EkbNRzFqCwL244rCM8SM1sZMHFcmB/cXv6WlMwVhypzQBZLDcIF3DjANe7Dxk8+xWPK69SWL/7DzFcAGjOsErJGesT44uAr2Hnoa0VMr30XCr0LZnlvbkTHb4hMeZs1CrXsTD5KFGnnpPNBsHYyIITiitep8SrQOnog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtfBDkSI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1826995a12.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710524706; x=1711129506; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fa79Oatca6zQP0uWiPqrWcQ+HA0jbKoi5WIlc5XFVOI=;
        b=jtfBDkSI1YprbJcST6or1vIBc40EPQl69MSaZZd+UwEcmBN1Tb0a9AfJsKwcygsmXQ
         pJsLEoAlE0vVCIgk4lLvbJmwNFujcDMtpKbpTtw/mLubZexGjkZaFNMx5g3OV0pX9srT
         e9JlNVp1CnTr+guzP5c/DuOWOpEJt4PPWZF89qh5l9GPs8P871iRvO6V8rkp0Fv3flug
         nKWsGcAl4GzE4g5YQGsIhx8Y12NOjylVFDU4auwN22epnAM2Dl1mjIUhr0AnWIKlumBg
         oeO5GWDYtE3eMAXI07zboZJnoMt0alrCgYYnuYqpVz4avswKTLYEsgkw4qnUCC/0RzE8
         nlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710524706; x=1711129506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fa79Oatca6zQP0uWiPqrWcQ+HA0jbKoi5WIlc5XFVOI=;
        b=oZ2j0mlfKCAs+Ay/w4BItUcQMVVeg0X+Abu1Yxedo7Jean+ej5TYNYGME4hbQueLvp
         vynE3a4yOYMj+bZHQ9FANaeqqw4VEgzYs3xHvrLMqnEXNTyUaaqVcM96eZU5g6jeJ1FD
         eYjHVHARISYU0cgHrzQ30LxLFV8VAYtozpz06/eqtY6ZXqRiyL3wqYmrNCayzdnvcwXb
         tWVPAI7JQ/bqxsRtqfbUga84/poYhSPTnl/zUBSRffc5XcsM2CAAGDimrs4DztjOacRr
         nbeFWkxIF6UpNtHbrroOR9mPPzfe2KSh048orwHBVrNg/sJpW25Fcee/FmWY1JqRBVTK
         15Cw==
X-Gm-Message-State: AOJu0YxkB+tV9vVlQ/XZardjINJxfu5YF54YNqgffl8IFTFIV3m3+k7l
	HkCBcCucryW9+QhTVlLiKLjAkxGG7QqHGvGxl1sEkLiuvvAiO1uZUbqpK1Sbfc9GUXErFQUDY0v
	iiw==
X-Google-Smtp-Source: AGHT+IGu2WNZTypfxINJC8/H54Ic0YBZ2JsCZRcH5IR1csm3Rm5dO3KPADbKayNfFkfN+yOjeH1XY0fCaXQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e903:0:b0:5dc:4a5f:a5ee with SMTP id
 i3-20020a63e903000000b005dc4a5fa5eemr18668pgh.1.1710524706415; Fri, 15 Mar
 2024 10:45:06 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:45:04 -0700
In-Reply-To: <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZfSJIDOJzGJ4lPjX@google.com>
Subject: Re: [PATCH v19 098/130] KVM: TDX: Add a place holder to handle TDX VM exit
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> +{
> +	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> +
> +	/* See the comment of tdh_sept_seamcall(). */
> +	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
> +		return 1;
> +
> +	/*
> +	 * TDH.VP.ENTRY checks TD EPOCH which contend with TDH.MEM.TRACK and
> +	 * vcpu TDH.VP.ENTER.
> +	 */
> +	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TD_EPOCH)))
> +		return 1;
> +
> +	if (unlikely(exit_reason.full == TDX_SEAMCALL_UD)) {
> +		kvm_spurious_fault();
> +		/*
> +		 * In the case of reboot or kexec, loop with TDH.VP.ENTER and
> +		 * TDX_SEAMCALL_UD to avoid unnecessarily activity.
> +		 */
> +		return 1;

No.  This is unnecessarily risky.  KVM_BUG_ON() and exit to userspace.  The
response to "SEAMCALL faulted" should never be, "well, let's try again!".

Also, what about #GP on SEAMCALL?  In general, the error handling here seems
lacking.

