Return-Path: <kvm+bounces-72780-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2i+DAO0CqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72780-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:13:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A9320AB3E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13D86305B29A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A08277818;
	Thu,  5 Mar 2026 04:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJva8Rof"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BE229CE9
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 04:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684003; cv=none; b=lbdoQYIa92K+lgq2Dm/qLF/3HV/vpmzedl1sMK0Xs+w74HtJg85tv7qv/ZGQzNJhvjmu8p6eTF5apTcBIQqek7yMWgVq/W0sRe2h3GWDGll6Cy+mhur/UJWMQsVcutOkH0GSkNnLn+zyN5NWa5iXmiCpR1CcLAU7Oi6oQ8z3824=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684003; c=relaxed/simple;
	bh=AkqKdpJFlu9VvgneMwXHF/K6ZvvF1MnE/U9EvQP4AUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a6Qv60szjcdECBqVNLk3qaX8E9vrT4xSuM9Ob+PXtg76YFbZIN1rVs8TGudy23zIfTA472rhEqJwISzqdlPTokfqWfAUaBYreUfMhOBwPSORNACzb6o2jRd1csZZmmX57BxA+tPG9fouPyWed4sHQ632tzHT41TX7AiWOeBUmeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJva8Rof; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae3f446ccfso44965215ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 20:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772684001; x=1773288801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r7aMNOVuHCTQUpbeRrQMBlsIPyGfseKCHq+MThP/6yU=;
        b=mJva8RofXgB2Io4nudkUhkyilCB+Xc8jzJh2AMPR0IR17c9F4taHVTUojTFEfx1ieQ
         PJZvOnWLlLgmr/HAQWooj37SWmaKwgc3WfhJxCzftqj6i1WNVg52wZnnMPTAvgqP94da
         uBv29/aXSRQR690IeennNahyZzMRAJbUx0uNsxQCeYfcrfJIQat1cWQp/TIvcNnnMKnI
         /fqtKYZaoqiQU/yPK4W4nJwP+qg4rc23GQYhe6OdPMev6cX+jqZHCclXjNurZE7NAS1N
         eArpsTNRnlgfaMUBBYMeLv1KgyjszY9iSfAU1XVDqsePuZ+eol5izaFtuKozD8dark2o
         6DWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772684001; x=1773288801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7aMNOVuHCTQUpbeRrQMBlsIPyGfseKCHq+MThP/6yU=;
        b=HvKVmXIShIUEqYG9ZKs2KM8W4tuP5b7a6ZDNXxO2CUNNQHbM2qpa1c3MMtYmG7dEse
         M0cGY9sYby3rn+ld3eGY1youpjXirKzioZBw+VfmO59xBUhU+kUMPqNUTgP3vIyYqU25
         iPQQmHEYkyXDxsbmn3ZDNp2U5tlenkl06UeVN8Lrw9MJakKbq8RavRXuDAZaqWT67plz
         0PlrrnCfP+/L2e4UqjkeaNm/iBpDk1Tuh95m0uTsoPfURUHNlTVEPX6bGJiUTRdCYP8B
         dpPc7KvWoPf0wzzoguKy7rq7vm/kEprsTeFF1Z6cvEsn0ddLq42DjE3OmtllIooNNUwM
         s6fw==
X-Forwarded-Encrypted: i=1; AJvYcCU3nG24beWdHv2dzIlqALScfhWSo/trWvG2eOg3S6rCJYKtMNmvw8v2Wmjr8Lox0unUvPo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6YtxW0L5/CRg5RZWZfqwo4IGMqTqKFR6jJ/pyKLrRxJg37+0X
	3hF9B9DSwDLEmkox8AcvClI2VYn6GVvJ4ThpGe3MnF1BTml46p+FtsypI5xKdDOYd8LF11PuErJ
	WvmAZMw==
X-Received: from plxl5.prod.google.com ([2002:a17:902:db45:b0:2ae:5132:8641])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f70c:b0:2ae:5848:bade
 with SMTP id d9443c01a7336-2ae6a9cdad7mr35198935ad.12.1772684001321; Wed, 04
 Mar 2026 20:13:21 -0800 (PST)
Date: Wed, 4 Mar 2026 20:13:14 -0800
In-Reply-To: <20260112235408.168200-7-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-7-chang.seok.bae@intel.com>
Message-ID: <aakC2g-8f76OqUjp@google.com>
Subject: Re: [PATCH v2 06/16] KVM: VMX: Refactor GPR index retrieval from exit qualification
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 47A9320AB3E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72780-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2bb3ac8c5b8b..8d3e0aff2e13 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -411,6 +411,11 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
>  	return vt->exit_qualification;
>  }
>  
> +static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)

s/gpr/reg

> +{
> +	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
> +}
> +
>  static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vt *vt = to_vt(vcpu);
> -- 
> 2.51.0
> 

