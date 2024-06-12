Return-Path: <kvm+bounces-19530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2972C905F77
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C46E5283804
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6968D12D776;
	Wed, 12 Jun 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jirNIJYY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822894084E
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718236534; cv=none; b=cYfZpCKzP4TfiKa+0ZINZW/44yuRhqwrybdoVM6yk1kJ/6k2xhG35K4wrEOpSGauKxoCY+1KYUxIRQ20Yib7+eFULCEo8FmNutuwiIGw8wSSKaZOmdBJiZQ29W3X3xYGcxIbL0zL5Ieh15yZGF/io/3L3eRWInvnHFO6uS1YP0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718236534; c=relaxed/simple;
	bh=UExzSWlT64SRTujuwraGmriH1bXzmArZy7Cn25txElQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K6G+rSuCc2St0EbCcXADil/l1mtAPBtWNtzW4dgvO8qI+k5IhmEGtmSZXSfzfNWnc6PJy2k9JimHeKosTlVzFyKIh6AeAQVn05BT59V40EBl8hh4SYqZDvIoTaq8ptE+kc11lXfgp0bMhgoFWT509E6OjwUwOhrw6K67pW0calc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jirNIJYY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-705cade7accso206830b3a.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 16:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718236532; x=1718841332; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LbtqKKQm97BowZds9B5adCnW1KnZQCMsmfiIrci+y0c=;
        b=jirNIJYYKuHlN88ExgvTAXbzBT5huFy4GJFP0i7P5OP3701PKraGKtdsuHi9tq17uf
         rP4p+tjbRQFk2Pg7HYiyJoX34ie/ja4NbmDtp3jLVx1kAWhpgr0A080Ag86uERFnlpKd
         qNvnLn31puwbxsPh+KrOKJzAjMWAlNk5X2tdrmXlR9qNgtQL/kW7BBVHH/GGo1y+/wrh
         xwcPD0v+o1fijW9uK5iv3DQowwruNhsD5VP8JXpwv/azfaDoBREB3I6APEnpRhl8yKDJ
         pFaOL+Ta1zAArMnSzNup/eDXuynXsJ7li2kB9fNk7+o2ErtdnZHqqY/m/yMzjGAgn4hw
         /oVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718236532; x=1718841332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbtqKKQm97BowZds9B5adCnW1KnZQCMsmfiIrci+y0c=;
        b=ZozqSSLTbVcC4Rmv9aPXicmFaRCPB0wR2xUq9LbfctOkiMlMhgzlP0HPNWMxv8CFtX
         oSlfiONWthT+IdnsZUXALz/w0q0iqBnLkiHppifITRdJ/ia0EHT42/zG+36b3+uhXSj/
         fJ4F5InRFXU5XslmwBM0wBi/wqGiJA2oLCR13+JvmSju481ssSNNH1tjvrISXlI68oKP
         S2+ABhqtDZnvgSHRSg8kfUk0zFSvxmn4YC4G83Hi9aKAxxy5a9aVxOrD1Nr0TAWhYfSc
         2r1bjELPRKoP/2MCaGrvScnXMncZ20unZZdc1kS6DDymqsZUrrGaOZm9cmJb5BDDAhzu
         HJlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL57g7nckfBsYSvQehx8hmSu/7PcP4H+w/f+6QJFs49y3kTt+tJQAP+xTHJLQJL5Meizf+Xs/wBYmNJfspYBuaUMGk
X-Gm-Message-State: AOJu0YxAHuvqO/meNjerXs8gpDi/z8pO7/VG6Of1/dGfbXc3NzO9eY2u
	JlqVoMHYe80KGwU5xZvkLsY6pisihzvlVckEO+Q7Qk5TR6i16pLP722a/TAzchvSasHzTO6jfRU
	n4A==
X-Google-Smtp-Source: AGHT+IGuecHJt0nHiXhJJYQkDb8/xV2VtUD4kUhO0uw0vw6n+UwkxLnb8lI0ADIZLteFZY80tW1W5/H7pvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d0f:b0:704:1a73:d008 with SMTP id
 d2e1a72fcca58-705bcddfb7emr13011b3a.1.1718236531660; Wed, 12 Jun 2024
 16:55:31 -0700 (PDT)
Date: Wed, 12 Jun 2024 16:55:30 -0700
In-Reply-To: <ZjC1QpnyQA0gHoo4@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-16-xin3.li@intel.com>
 <ZjC1QpnyQA0gHoo4@chao-email>
Message-ID: <Zmo1cqTgJwfDL0kW@google.com>
Subject: Re: [PATCH v2 15/25] KVM: VMX: Dump FRED context in dump_vmcs()
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xin Li <xin3.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	Ravi V Shankar <ravi.v.shankar@intel.com>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 30, 2024, Chao Gao wrote:
> On Thu, Feb 08, 2024 at 01:26:35AM +0800, Xin Li wrote:
> >@@ -6449,6 +6451,19 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
> >        vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
> >        vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
> >        vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
> >+#ifdef CONFIG_X86_64
> >+       if (kvm_is_fred_enabled(vcpu)) {
> 
> FRED MSRs are accessible even if CR4.FRED isn't set and #ifdef is ugly, I think
> you can simply do:
> 
> 	if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED)
> 
> just like below handling for EFER/PAT etc.

+1

