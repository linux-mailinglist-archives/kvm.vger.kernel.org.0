Return-Path: <kvm+bounces-17776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A008CA174
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD12828245E
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 17:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22365137C54;
	Mon, 20 May 2024 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A4RFvwV1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F437137C3B
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716226527; cv=none; b=h2mdJgHzKO6FJgV5Qbm0RhyaXTHuK0JdXb7dq2XQS6hLj+lYOR49kCZT14/lbVI1WnjKhpbjcDxAtIwS1zYTeH35/ONnRcBQp56ZRWZzdGTx0GHhW7N4m+vnu+TqjAiGfp1rKnc/H4ocrEdwY5fcLqzq0SwozMRAJvOXtpZs2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716226527; c=relaxed/simple;
	bh=+Tf6AAgN6OqFWz2TdMAtSycAZVzTLTZBPFUHsMMEnjI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UnCNw8Fri2jgHV4doPOlQirIUERQ3Vs7PYYtqwew0RIgmJZjpvq9ZUCfGzTDX+FH9iBla7bCw3MlgdBNcczdmYtaSe8O06WdQRTvrLsfU9Ll6F154+74tjgoUmz6VkRluneQrKBsGe9cHTV8V4VPb/h3LrKNmJKvcf13CXBznyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A4RFvwV1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ed3b77d45aso136875145ad.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716226525; x=1716831325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KaUIcbCxnT+V1tXho+s6VK2LQCpbrcFbVlZAjQNTw9w=;
        b=A4RFvwV11ah0NUHZkhQzSuK0Huh1Kaoup5Vx7rYkt6wzr5iJiUUEoYKhpKCqgpVF3i
         OVk0SVoT3Or2WHHZx/oUsscTB3iGIt43RRxZ8WELvdfdDKv60yHkCh/kWTOTQAXyz2Q1
         59n2ci8qjslUU5NHX1IcEiN4c8s+UjjVGQjoWdIm8tsMxXqqcIOan/LMTPmT7Um2FT1v
         BiTkdxo2/NOkPOLkCBNNvNKtdJNI6BGVZi/jFoNx7yrwYvlv+8f2s3pj2qlBBeQRfyGr
         LnlQE2J8HquqbVG8QX4M7OoJng2W9YyXlbRYogeBNNHUsp87NJKqp2V2XfFHIfQmn0Wp
         kCwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716226525; x=1716831325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KaUIcbCxnT+V1tXho+s6VK2LQCpbrcFbVlZAjQNTw9w=;
        b=MS1+CHheKlEI68h96qL3hb8vHoTELItr2w4MySGyandrLqK2ALNC7L4goRmR+eiUUL
         yxWU0ZQS3FDds9v6I3csrp+xQm4APDM+62tCKQPGxQToqg+sZma9StE9JWGF8Am7xChy
         epYqVJbpNq9RERzxc54MW8qL2ROcUo5EqkUVOc8Vd35HF7x95yo2ytdZdwPJMVGb8agu
         uxvHUCToemthLVyrLb9Oz7J7ehU2BpXjPk/ugTlgR9YVi0DmvjhjgX18NqtQYHxd/H6+
         sBFERmcLvKPKZHOBO5YOrE+iC2OHsioGHTCQ/2wiyQa1r0iN8SfwlABXnuCh6HJSFNMP
         8JrA==
X-Forwarded-Encrypted: i=1; AJvYcCVU+UUwIuNwaUW9B11J7PTr+VhOAtHdL/IoREKRzbxjz/p1eKRW7iKEMxPDFMKJFBc/tQ4+w6hzpgxRcNtL/X/+PPKe
X-Gm-Message-State: AOJu0YwxoIAruhsQi9eusDFKoGS8ofVbnId/G00unpZUH3Mt95g/IgsV
	0rtrjzDc07zUHth/fm4SC5ncWVR53EivS8LXeZuuGUMTkQQSKrXUQq3/UTlW6AIVN7TaZ2tX3PI
	qUw==
X-Google-Smtp-Source: AGHT+IF1taDRJctSSVr2IasIIziXIfKJNIigxZpYaoBlxwyY2AZlY80I/q2z0jdfLZJ5lT9JqTpQH1/QQSk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e749:b0:1f3:95f:ba6d with SMTP id
 d9443c01a7336-1f3095fc09fmr1015685ad.5.1716226525207; Mon, 20 May 2024
 10:35:25 -0700 (PDT)
Date: Mon, 20 May 2024 10:35:23 -0700
In-Reply-To: <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-14-michael.roth@amd.com> <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
Message-ID: <ZkuJ27DKOCkqogHn@google.com>
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"tobin@ibm.com" <tobin@ibm.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"alpergun@google.com" <alpergun@google.com>, Tony Luck <tony.luck@intel.com>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"ak@linux.intel.com" <ak@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"pgonda@google.com" <pgonda@google.com>, 
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>, "slp@redhat.com" <slp@redhat.com>, 
	"rientjes@google.com" <rientjes@google.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>, Jorg Rodel <jroedel@suse.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kirill@shutemov.name" <kirill@shutemov.name>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, Kai Huang wrote:
> On Wed, 2024-05-01 at 03:52 -0500, Michael Roth wrote:
> > This will handle the RMP table updates needed to put a page into a
> > private state before mapping it into an SEV-SNP guest.
> > 
> > 
> 
> [...]
> 
> > +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)

...

> +Rick, Isaku,
> 
> I am wondering whether this can be done in the KVM page fault handler?

No, because the state of a pfn in the RMP is tied to the guest_memfd inode, not
to the file descriptor, i.e. not to an individual VM.  And the NPT page tables
are treated as ephemeral for SNP.

