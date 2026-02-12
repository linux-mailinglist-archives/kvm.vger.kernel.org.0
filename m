Return-Path: <kvm+bounces-71004-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C3tD3YYjmlF/QAAu9opvQ
	(envelope-from <kvm+bounces-71004-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:14:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A503E13031F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFFD5302D582
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E97D274B44;
	Thu, 12 Feb 2026 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sZYQzb/c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A743126FA50
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770920050; cv=none; b=POK9AssJdJqoCPYXUJaS/UMGkXUTXIaHVfg65ztOZNDBVdY4EogeOSxyWxEJVNopuJOtE5tTrx6ClWl42beRd3JclypeiGsDiCRh0wWMHJ4DeJPlJ9Yw0gkScxAAVw5EaHfMJzuqJwaPWKOllyCohrnDTp5DJVDFdbP+x+i+LJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770920050; c=relaxed/simple;
	bh=p3D+1fyw54DSjvEXexOhGpduACheKFJGeLIf3VuSRNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UCzvfrpEF2vxaFH6Gghyfj9QLS58eQrtbxUlWOJC16eyS0VMaxswNV2We7k4YzuGwiN4i4fkCKLOh+463NuUBYdAk9AfvY9IpQevOQpQ+4y9RiWZsiu+sVihxlwHWxiTNSKWCAl69EksGLIcqGKWn0hDvLt6L1LCmw6Q4gQpBOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sZYQzb/c; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3545b891dd1so512594a91.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770920049; x=1771524849; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V3+cTICnHkot+sIoHqjaaAOCONP2u3fpl0bvZ8vKDTY=;
        b=sZYQzb/c0vtlj+Fbi5leXahfaO0U+Fn5NuzNXgiik2mJ7TUGoHHjOR8eQSkaqz37iL
         xU4WK0GcSUbnkTjOysi0V3iLcR4/VmvdKNfMIYEiKpBSIiqQL+8v/PIzOuDdpibCbdmw
         fwq26hKiFiNHKPYAekt1OmH41EGb1oBW1OUfT2gB4RX/5fyW3ACSGaoydZJPhoJBiq1m
         eixvhiUEsPJWRUL2+HBwxdbZ6oqFq1DEoPCWyQ6mkuofq87AHGFwuJ6I54aH92IpXolR
         qNw7VidD34+hTzgeMK1Fm706m5Yy+FSaIZMEHJ6Tu/a7VeYIVJ7j2UKdhMan1g51UL1X
         ADVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770920049; x=1771524849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3+cTICnHkot+sIoHqjaaAOCONP2u3fpl0bvZ8vKDTY=;
        b=Cj+b7/j4J+uOKW1loejghLl8Ll7SDgyy16FtSH7lHrMCpP8FSs5gQeMz00t2MDjCPW
         kGiRmdufj0ZlJ1x4gjTVPedCyX3/ecr6NYqxMppENQeOjW4ZN0GdBhOC4698o/O/3QZ2
         2zAdjGAmtEGPcnOTeIEpsomXQcydh2PwjmS6koXwZA2KWSg+NXwbl3UZByjNb1xEpZUk
         0PmTpiB6SpM8ItZDJ7bg9PcIXaHI/TKLV0tI/XuZd9HzUzMxcV+0ciWbKphcHaHp16Sl
         4s733zGo6p7/VMKUUUsZi9WwpVv52Iuuuo/SHrk46UQsEwcAPH2FqDHxsgrgV0Vd1Okr
         Y0CA==
X-Forwarded-Encrypted: i=1; AJvYcCU37dVmFURJ+fhFdixhJM84gpMlKk4tZHV5/wh5W6Hnj6lLPK7AbMws7HkeZqEHMaSx+o4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKoy/RLivN4pkJ9Hm8hI87TExq7/opgPItemMOHIM2sw/+T+Zf
	PeSrdETd/RfKogxerYtkeA5ZBHlZSPLIWRxjeD/WR+vqzhQKS9grfbiHXPqAGs0k1hlv7raUeUG
	fhwBHeg==
X-Received: from pjbsv15.prod.google.com ([2002:a17:90b:538f:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33cc:b0:340:776d:f4ca
 with SMTP id 98e67ed59e1d1-3568f403e39mr3361724a91.26.1770920048905; Thu, 12
 Feb 2026 10:14:08 -0800 (PST)
Date: Thu, 12 Feb 2026 10:14:07 -0800
In-Reply-To: <rncblgei6isym2hsbw2jwgfpxwmpp5xbvfgoeut3fmvkbzzucj@eat3nisvyyoo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com> <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
 <aYI4d0zPw3K5BedW@google.com> <rncblgei6isym2hsbw2jwgfpxwmpp5xbvfgoeut3fmvkbzzucj@eat3nisvyyoo>
Message-ID: <aY4Yb3I3k1LOgn4O@google.com>
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71004-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: A503E13031F
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Yosry Ahmed wrote:
>  
> > So, with all of that in mind, I believe the best we can do is fully defer delivery
> > of the exception until it's actually injected, and then apply the quirk to the
> > relevant GET APIs.
> > @@ -5747,6 +5759,8 @@ static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> >  	    vcpu->arch.guest_state_protected)
> >  		return -EINVAL;
> >  
> > +	kvm_handle_exception_payload_quirk(vcpu);
> > +
> >  	memset(dbgregs, 0, sizeof(*dbgregs));
> >  
> >  	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
> > @@ -12123,6 +12137,8 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
> >  	if (vcpu->arch.guest_state_protected)
> >  		goto skip_protected_regs;
> >  
> > +	kvm_handle_exception_payload_quirk(vcpu);
> > +
> 
> Hmm looking at this again, I realized it also affects the code path from
> store_regs(), I think we don't want to prematurely deliver exception
> payloads in that path.

Hrm, I actually think delivering the payload in store_regs() is the least awful
option.  E.g. a VMM that saves sregs on exit to userspace could elide KVM_GET_SREGS
when doing a save/restore.

In practice, it's all moot, because AFAICT nothing uses KVM_SYNC_X86_SREGS.

> So maybe it's best to move this to
> kvm_arch_vcpu_ioctl_get_sregs() and kvm_arch_vcpu_ioctl()?
> 
> The other option is to plumb a boolean that is only set to true in the
> ioctl code path.
> 
> >  	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
> >  	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
> >  	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
> > 
> > base-commit: 55671237401edd1ec59276b852b9361cc170915b
> > --

