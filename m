Return-Path: <kvm+bounces-39291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2EFA462C6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC00D17DE29
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A073E2222C5;
	Wed, 26 Feb 2025 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vsBRbu3N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039022171E
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740580040; cv=none; b=gBi35E5WLxZjuIDSgABUDCDxhss8hzah61+jnLWJ2XI0rPIO++1EDG9t/KgKyjEHyGHG8IsQdBFV3wFI8jsFtamUHIcoZDNZGuI4jCkmnMm6B0Zpk1s+Sej0hlUUDTgfdI0sbOstIUTkiP3FWOhoZ9xbz9eQJ+FwOLPpPvbPzlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740580040; c=relaxed/simple;
	bh=EVDB5ihtgZeieRnrugyEXIDrswGJIhn4/GuR5gLfv2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SdNa+LojHw4cmJEKeHyFPdrsxyElGXJ0zADzzgSkwXnqYQAiwm+tbQOB+Ohto6yfLYkra++MHDqxmUZ3gylLhh7FPgaf4QmpuwWav0iPnQ2PFNhiRari+/mTeUCWDrlf913c19bvOLcsIk78Y5fvm0RMHu2ocGXZe6pglqL6Kx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vsBRbu3N; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso22185522a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 06:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740580038; x=1741184838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eaRjEj+S+iNUpexzYhTHe/q7bOyFL6g0TekFIq/1o1g=;
        b=vsBRbu3NfyDpphupjR0N4xxLTp3fhZPqv+PJDiaye9ZW6K/g6VYMwJ/8g4xROQ0DWR
         cELYC294mAn4x9yHSPfnWv3YsSQp0pX0cXHUnbIoHQ7A7TS0tUD/aMi3Hydvk+P5iT0F
         pUOkWJwT4TqQCA2gR+xAYAINOHAaaZ9FXiC1ds4IwtpLr2lZjg3EaZLXU9zmt0Mz0PWu
         hOYlCqEU+pUv1DDY4PqJEBD2nQto6cLyqAfn+swnYkYBf7ZHj3veN/eSal0KdhI4MET7
         LcJm2R491GtG5DeM+2/RFQH7yRtbSpJ7Sdn/eF07ef6RfGD+Xf/m0hk/IldbdwBZvV+W
         LzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740580038; x=1741184838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eaRjEj+S+iNUpexzYhTHe/q7bOyFL6g0TekFIq/1o1g=;
        b=KnbihjAEESfdVsFxJ6CwxbdD2IKKtkC5+5mY7hR16p92vnuEFofy/lQlwURFuTHTYO
         gbF1h4rUqDu2EHFcqqKujDeW0Buw+ehEW29FJK0+GWymgFwlf+qjsHdd0qAbQ2Xdnewq
         24x7N92DXunS9slTn0Qp6O9wxe03SFM2ma5eLyfMmg+I3woIs1kHtVKdkvkzOsbaam0s
         6NHKGKfPg93zvWHiqd0aC/VwxJ5G98AYZ0D8ZZK1SqGRXQlo9oXcj46PRiTMY8qNQWVt
         80p1VoSLsnwSYhv1vvGDfktntKY1icG8F8u4Akm+D6c9pNQgmM3wW41H8FNAQNBWC7l2
         kPTw==
X-Forwarded-Encrypted: i=1; AJvYcCWtUxFeQJUQCf9sTtwK2lRqd1CXZCH3ps8wedVP7na8QMhc2b7k+Q2guMwzBJ93bNi5FZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBUqkK394LCHPPvbP9htoW0OGoV3GttTW08J71cJG/lnbl22XO
	2v1cQICFNRvtb+5GE6bdLnjWspbbOhT6J5CBeXfSQ00tCJXUB1Fa9zwRelq1hdQvqoABKnE8Yzx
	7kg==
X-Google-Smtp-Source: AGHT+IFswkBOj+OW+b1B+n/Joz6AyKOkyChMtV3kE6V2sRCzgJx4EB1M/qGFGRbf1byqZAHdlEsQn9PZhSg=
X-Received: from pjb8.prod.google.com ([2002:a17:90b:2f08:b0:2ea:5613:4d5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540c:b0:2ea:83a0:47a5
 with SMTP id 98e67ed59e1d1-2fe68acd777mr11441995a91.4.1740580038672; Wed, 26
 Feb 2025 06:27:18 -0800 (PST)
Date: Wed, 26 Feb 2025 06:27:11 -0800
In-Reply-To: <Z7yc8-QXXVPzr2K8@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219151505.3538323-1-michael.roth@amd.com>
 <20250219151505.3538323-2-michael.roth@amd.com> <Z7yc8-QXXVPzr2K8@suse.de>
Message-ID: <Z78kv-hhU6AWyufz@google.com>
Subject: Re: [PATCH v5 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
From: Sean Christopherson <seanjc@google.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	ashish.kalra@amd.com, liam.merwick@oracle.com, pankaj.gupta@amd.com, 
	dionnaglaze@google.com, huibo.wang@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Joerg Roedel wrote:
> Hi Michael,
> 
> On Wed, Feb 19, 2025 at 09:15:05AM -0600, Michael Roth wrote:
> > +  - If some other error occurred, userspace must set `ret` to ``EIO``.
> > +    (This is to reserve special meaning for unused error codes in the
> > +    future.)
> 
> [...]
> 
> > +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	struct vmcb_control_area *control = &svm->vmcb->control;
> > +
> > +	if (vcpu->run->snp_req_certs.ret) {
> > +		if (vcpu->run->snp_req_certs.ret == ENOSPC) {
> > +			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
> > +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
> > +		} else if (vcpu->run->snp_req_certs.ret == EAGAIN) {
> > +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
> > +		} else {
> > +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
> > +		}
> 
> According to the documentation above, there should be a block checking
> for EIO which injects SNP_GUEST_VMM_ERR_GENERIC and the else block
> should return with EINVAL to user-space, no?

Yeah.  It feels a bit ridiculous, but it would be quite unfortunate to go through
the extra effort of decoupling KVM's error handling from the GHCB error code, only
for it to all fall apart due to not enforcing the "return" value.

