Return-Path: <kvm+bounces-69733-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCamGDnPfGlbOwIAu9opvQ
	(envelope-from <kvm+bounces-69733-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:33:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A36C6BC0E7
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 655F2302D940
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45556333439;
	Fri, 30 Jan 2026 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JbWRFcMi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448083203B0
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769787172; cv=none; b=nLKjSFl/NWowdWi80O6rp6Jsqqh0z+NCyJchrD9E87VBVbieNSJt830hpi690UMQ9zL13NlLicCY/aeBitqoHjRCE/DDl38//M492MFxjJHz0lG19vffe4dCof+w0NTwYdVrr60h2euOKMvQ/05mFzypv/Q8FdHUGXMUVqSINUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769787172; c=relaxed/simple;
	bh=i8wscdSHr/yETmiNRCOhea7uOvB2cu7M4xeAbqKz3xI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RQGks5kpfXez5VGOO0zv4P7dCaegzwxplX3JCFrkMlQv0Xk/GZ07j4DyY1N1D8OclEmlIhNI+fEF6NZGl8zUZYHCvGUH0czrXlLSTFJsMuoNtFteYXpvUvcE7S4f+2ZvfYc/isHxwtasctw61Jc0ji/0NMHUjeHGTqcxnnGI6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JbWRFcMi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso6860540a12.2
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 07:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769787170; x=1770391970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQOWjbxwtcESWSfKrgjbMAEnNEFgcacz0OCrlLF7boI=;
        b=JbWRFcMiyKV7T6yNYUjjUo+JqyZvjX0UNyKAMgOoxbNcs1lDhLy35s+PbQ/lHmQm2o
         BFMvKjGZ2QE41iBsqI6dWN+ZFfak//lLQEUZBhgt0ASvUTOc+qFwajvFBhQvDYatakAt
         GtYh2GQq/XJPP/hMzAV7R3Pi809VmyviUWL7hSrHscKBjbrhxUqmXjES/xw7/ADIF7Xi
         7F6MVBb1ptye4UmXfvmYuKprTVC2xwfbShfJVhEYsxfKCo/nTTEehU82zL6B51qHmsLS
         Ou0o5SqhgENmifw7v9quGCKeypfPZOJTiwKjnycSdUlJFzddyTkwg6r/E8n5zWxofM7L
         m+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769787170; x=1770391970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQOWjbxwtcESWSfKrgjbMAEnNEFgcacz0OCrlLF7boI=;
        b=FF8OmSbMXVrkl8n2/d9N7V3YgWfWhoW+y//McLBoanmW8emXAYO82z/EP0h/+oq+0T
         bW7crn+20ZfnyMxPszqISdvUG1Ic6X9PBIa/1RiE3S1ADjAJ3VXaZ0/ul+Pg4MQP4dJb
         oOkddeHkgWRtiXwnTi0U1/diIkThA7jBv/NdTJABNe75pPj7m62OUvDsMydUVMfggR7L
         f/hZwu4/Kmly4baX6rrJo0dDO2Lo0NabTuTV9ByEEEbaKCehihDed7ymvev2iPy8Cgcj
         VSgGrcdkHEVIIRvFZYYA0PM3NVFn9snm4gUqChoSOlBPt+nzm3wWUFcpWABWraci7QHy
         3+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiUW5K3iNxgjF737HVwXeoe/W2D9O9oegsFEYkTGu1EPZyzwjLqRKvDVo0Dxx8gVzHGd8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH5HR0LVhAZktA6CtDpzcdVG+wAq0QPeo56E1H4sYfTB4yRt86
	IvmHEfc5dIE8sO1Xfv6FBUg7SGBLJemj9QDuwPTTqyDVmSoPsAW4P44yywyZTx/2n5MConzA5Sn
	yooEtNg==
X-Received: from pjbok5.prod.google.com ([2002:a17:90b:1d45:b0:34e:795d:fe31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6185:b0:350:3436:68de
 with SMTP id adf61e73a8af0-392e014ba69mr3010045637.53.1769787170466; Fri, 30
 Jan 2026 07:32:50 -0800 (PST)
Date: Fri, 30 Jan 2026 07:32:48 -0800
In-Reply-To: <aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com> <aWgyhmTJphGQqO0Y@google.com>
 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
 <aWpn8pZrPVyTcnYv@google.com> <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
 <aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com>
Message-ID: <aXzPIO2qZwuwaeLi@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69733-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,gmail.com,redhat.com,suse.com,linux.intel.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A36C6BC0E7
X-Rspamd-Action: no action

On Mon, Jan 19, 2026, Yan Zhao wrote:
> On Sat, Jan 17, 2026 at 12:58:02AM +0800, Edgecombe, Rick P wrote:
> > On Fri, 2026-01-16 at 08:31 -0800, Sean Christopherson wrote:
> IIUC, this concern should be gone as Dave has agreed to use "pfn" as the
> SEAMCALL parameter [1]?
> Then should we invoke "KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));" in KVM
> for every pfn of a huge mapping? Or should we keep the sanity check inside the
> SEAMCALL wrappers?

I don't have a strong preference.  But if it goes in KVM, definitely guard it with
KVM_MMU_WARN_ON().

> BTW, I have another question about the SEAMCALL wrapper implementation, as Kai
> also pointed out in [2]: since the SEAMCALL wrappers now serve as APIs available
> to callers besides KVM, should the SEAMCALL wrappers return TDX_OPERAND_INVALID
> or WARN_ON() (or WARN_ON_ONCE()) on sanity check failure?

Why not both?  But maybe TDX_SW_ERROR instead of TDX_OPERAND_INVALID?

If an API has a defined contract and/or set of expectations, and those expectations
aren't met by the caller, then a WARN is justified.  But the failure still needs
to be communicated to the caller.

> By returning TDX_OPERAND_INVALID, the caller can check the return code, adjust
> the input or trigger WARN_ON() by itself;
> By triggering WARN_ON() directly in the SEAMCALL wrapper, we need to document
> this requirement for the SEAMCALL wrappers and have the caller invoke the API
> correctly.

Document what exactly?  Most of this should be common sense.  E.g. we don't generally
document that pointers must be non-NULL, because that goes without saying 99.9%
of the time.

IMO, that holds true here as well.  E.g. trying to map memory into a TDX guest
that isn't convertible is obviously a bug, I don't see any value in formally
documenting that requirement.

> So, it looks that "WARN_ON() directly in the SEAMCALL wrapper" is the preferred
> approach, right?

> 
> [1] https://lore.kernel.org/all/d119c824-4770-41d2-a926-4ab5268ea3a6@intel.com/
> [2] https://lore.kernel.org/all/baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com

