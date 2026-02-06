Return-Path: <kvm+bounces-70458-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Jg9Ci4Shmk1JgQAu9opvQ
	(envelope-from <kvm+bounces-70458-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:09:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8F41000D8
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBC8C3015865
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 16:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29A53033DD;
	Fri,  6 Feb 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3zGS4LG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192EC307494
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770394149; cv=none; b=j9PIMWPGs91sLY0Dx0ujwiWVMi6X1GeW9EiO7RE1grdiOpJ/VFVYUh0G8BPP4i5qtIZJXE5HoIHBi5w/pGBw+V3EoZR4gv8uMYz1S3P/sDdxOIBFKAQn4MshbrdX+vtiOw44ZuWaXe5Uco8KTfQQ/dtoAzSo+c+SZsYUNjQ9a8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770394149; c=relaxed/simple;
	bh=GseGPSvDv+zf/F49UP6691uiDwDrrNtW3q4/gn+iXJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YQYMvGXqPsgY04k+z6CgZ7bRQUbxoVhWAfpy/99ffEuTy7v7GnRP7nwxBGlkKazGei6GwhvoRwajrhUXHiiPm0RJVfpbwRb0wxmXNs7r193wszfSI27C+97QDHKVjbLXozMqDL2O4/1pUI0mcHVUR7zHXRRfhEyw2t6txBxe3zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3zGS4LG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c636238ec57so1470589a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 08:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770394148; x=1770998948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WKadh95vzrgW3GhMS/EMpq8htzR/DIQBwQ8Oq5fFW0=;
        b=c3zGS4LGyVqlXRVQNJhDC4dO2qgF280ajKyx67XH0Zy8npLcj+6cOGnVLkVgICtuIa
         hpzi8c4FaAH26MmhhG9/UGVq8VjFxatIP1vLTERIVPOUQm5jWfn5bISyM0FMZnavsfgW
         v2HjV1KECNB8MrG2e1TIGaqi3etAVjoorRwjtqc34hF6oSVgcpKLBaSt7jROnwGNp0W9
         JREIenAsnDPuxKjZ8HC2EQSwHjSbnWM5kQ5t3bxz22jgYV9oMAIuztnLEu0WuiTmumDR
         KOzQQLiUfVk9NjdbVYXgAOpZQzgnkbPcUdvSOjg7V4kZxbYYvFFM0O+FabKGQzHnTE4T
         yZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770394148; x=1770998948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7WKadh95vzrgW3GhMS/EMpq8htzR/DIQBwQ8Oq5fFW0=;
        b=ZIcO9SA6NAJR3Ua4yAEbs8+zKkEd5OmrJCCfL0holOBwpwYTBZb+lJqHMe3d/a2xDR
         PkkAeiPFyU9TiIJGuLn32sBuJVKAAG5lhqE00aNWxEbPxcj4LnqQiBW51d7EivirK20G
         fBIZPrLy7PnKfxvxkPPnnIk0J2Db6h1yVBRvccPjKVeakpcSz3jq1rp4ILzp15GvkJQj
         1gzWmLYQWMVDuckuzdZW2OgQtl25ozZzviwneFiBQMAhlToyPTuG1BJI4wP6ZfYO/F5l
         wgoKAQT+4DlPk0Y64559iczTLOK9CiyQBURH73kE0v+qCMr5ZEMUer6ZcgvQf0LdV5X1
         oyyg==
X-Forwarded-Encrypted: i=1; AJvYcCVOVajaC0hTng1BinMo8UJLCV/BDivB7JCegXtAyMuH7LFk+G/taNRAo2EcO1J62ya1MpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuLjPrtoaSeKzBhAyynoyXEQPKIXoSNkz6sdPSY0nihHBSShxj
	XFAWZT4EqoXlMRMnZsL/dkZRcDWgu3iwSDhHVPNawPRoLSovxml2Azt6cFrhX/sbQj6Me8q0DlW
	fT091ag==
X-Received: from pgax34.prod.google.com ([2002:a05:6a02:2e62:b0:c65:c5fc:1707])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa9:b0:366:14ac:e20a
 with SMTP id adf61e73a8af0-393af2a3f9amr3224489637.72.1770394148215; Fri, 06
 Feb 2026 08:09:08 -0800 (PST)
Date: Fri, 6 Feb 2026 08:09:06 -0800
In-Reply-To: <aYW9UaK7tePxDuyh@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-38-seanjc@google.com>
 <aYW9UaK7tePxDuyh@yzhao56-desk.sh.intel.com>
Message-ID: <aYYSIndbqLdFkaM-@google.com>
Subject: Re: [RFC PATCH v5 37/45] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70458-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD8F41000D8
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:15:09PM -0800, Sean Christopherson wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Enhance tdp_mmu_alloc_sp_for_split() to allocate a page table page for the
> > external page table for splitting the mirror page table.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > [sean: use kvm_x86_ops.alloc_external_sp()]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 3b0da898824a..4f5b80f0ca03 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1447,7 +1447,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> >  	return spte_set;
> >  }
> >  
> > -static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
> > +static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
> >  {
> >  	struct kvm_mmu_page *sp;
> >  
> > @@ -1461,6 +1461,15 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
> >  		return NULL;
> >  	}
> >  
> > +	if (is_mirror_sptep(iter->sptep)) {
> tdp_mmu_alloc_sp_for_split() is invoked in tdp_mmu_split_huge_pages_root() after
> rcu_read_unlock() is called.
> 
> So, it's incorrect to invoke is_mirror_sptep() which internally contains
> rcu_dereference(), resulting in "WARNING: suspicious RCU usage".

Ah, now I see why the previous code pass in a bool.  I don't love passing a bool,
but passing @iter is outright dangerous, so I guess this?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a32192c35099..4d92c0d19d7c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1448,7 +1448,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 }
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
-                                                      struct tdp_iter *iter)
+                                                      bool is_mirror_sp)
 {
        struct kvm_mmu_page *sp;
 
@@ -1460,7 +1460,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
        if (!sp->spt)
                goto err_spt;
 
-       if (is_mirror_sptep(iter->sptep)) {
+       if (is_mirror_sp) {
                sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
                if (!sp->external_spt)
                        goto err_external_spt;
@@ -1525,6 +1525,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                                         gfn_t start, gfn_t end,
                                         int target_level, bool shared)
 {
+       const bool is_mirror_root = is_mirror_sp(root);
        struct kvm_mmu_page *sp = NULL;
        struct tdp_iter iter;
 
@@ -1557,7 +1558,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                        else
                                write_unlock(&kvm->mmu_lock);
 
-                       sp = tdp_mmu_alloc_sp_for_split(kvm, &iter);
+                       sp = tdp_mmu_alloc_sp_for_split(kvm, is_mirror_root);
 
                        if (shared)
                                read_lock(&kvm->mmu_lock);

