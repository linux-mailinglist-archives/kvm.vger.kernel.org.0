Return-Path: <kvm+bounces-11340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB15F875BA6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 924CA1F221A1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 00:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9162122619;
	Fri,  8 Mar 2024 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eHeD94aq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF42219EB
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709859417; cv=none; b=fljjpqDueGIFiblOeCvRKK1r1NewkBd4nYJQfCTJtKIdYSLewH/FvnbDDjllVTD71C5rEdSff2gUSv9X/7Lx+mEp8MaqrqvvEYRLxYfgVTQKV1KUE/K9fDmGvrVP0bJFcFyGwplJK2XcbY1s/E4RJjE/YuV3a2ctA8hmx7R63Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709859417; c=relaxed/simple;
	bh=X73gZ6oo5HIXF3CAaAbkTGjsN3KT8Yzd6Bfe5mNNhhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KM6/cNLG++nVgdbLNOxabeLZR79LYvVusfkmFa+fVZEqu//T10liOOC3yfcQNK00EYhtxQIrasheXHfBV0TyNvRJtEc3iSKjgPUBiowV25eOUx6FDp9EXogWLBbmJz5ivvPvm35FsjI+3Uv1rU6+9ggLIQ2cy4lJ7NiCqPQ+qsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eHeD94aq; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so1253801a12.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 16:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709859416; x=1710464216; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Qnw8MPyfIgI73N12VWT1J4+tWNjVVYbLsggYSkFPpk=;
        b=eHeD94aqNe6vUeiHH1b3yYIRlqdMKi+5TSF+WSXfJYSZF4yCtEthZ4Wih4130Bb7tU
         e6ocq4OxmAlPoZDvhh7kRIJHThzvTnalZ04urF7Rs5rQrjanEnI/9NwtDiLpyMSKJlIX
         hSKt8Bin86K0l1LdtAyhmyeDxZfA2H/DYNLUtUnaArDBJGII2hoOnFkNVIGI0WGXXlzr
         rxW6mPUYtArWn5zVi4G6to4T/JisKJ/0lgxjTtVJxqHWG+DTk01Mulms9ZAyGdkvll/D
         4bP5PI7L5t0Hnz0WlSfb57XCh30QlqHZmaoz6bgWVDyuAqFKZMD98dCSh8FVUkjqRBzd
         p4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709859416; x=1710464216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Qnw8MPyfIgI73N12VWT1J4+tWNjVVYbLsggYSkFPpk=;
        b=XVxrk660KBDL/JkA4Mff1uPmDoaEsbocGP5H0AmoSMkqk89E9hsj0Y2R2zc/3SJ1aK
         8q1zvV06KClJVeXtOZx+oM3X9u2OigcNmyCdInaDjxfHkHhqneVxwJHGqHFAUlQDyC9X
         osRPCJYmTo9i/Q9D7JYq70eKS4kQp1yg29EagZQsonH24whX9jUOUNhr2Co7JwSTTApO
         wCSVxtu/iwTS1XdNzYj08GC70uP5PAJ1E46+++ymxD7HlaIGiyV5Z8Gy1J2fn5fIuYkO
         5xWH6ezOx8swOKW9OBTsLY+gQ0oHIXpg4YcJAIFabR9ING4r8faZ1ujlot51UrJZqHdl
         lX+A==
X-Forwarded-Encrypted: i=1; AJvYcCWxadbnuamt2HsG9PJlgozYICWdVdk4L/tm3vtrNnXzxnicly8oGGvBEQUMKrKDy0dK5LGq00/Skzt8WzMJz7V018dL
X-Gm-Message-State: AOJu0YzyJiYJ57MjgKzoDP9KtGhS8RGd/kIfX3apyI9gizryyOayMufM
	AXucaU01658LsveFz+Xsc7OXPCFvPC3/J0/+hedAVlp3wg+q6UV+iM2HpzoYuQ==
X-Google-Smtp-Source: AGHT+IGtwunrZnTGb94BNoP8JTZvXZLajFFapqzRzyl0v4q1i7LMavPjyb5P0TC1W8D1hvUj5Vy+tQ==
X-Received: by 2002:a05:6a20:6a06:b0:1a1:7529:1942 with SMTP id p6-20020a056a206a0600b001a175291942mr4080776pzk.24.1709859415535;
        Thu, 07 Mar 2024 16:56:55 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id p28-20020aa79e9c000000b006e65d676d3dsm1816625pfq.18.2024.03.07.16.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 16:56:54 -0800 (PST)
Date: Thu, 7 Mar 2024 16:56:51 -0800
From: David Matlack <dmatlack@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <ZepiU1x7i-ksI28A@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>

On 2024-03-08 01:20 PM, Huang, Kai wrote:
> > > > +:Parameters: struct kvm_memory_mapping(in/out)
> > > > +:Returns: 0 on success, <0 on error
> > > > +
> > > > +KVM_MAP_MEMORY populates guest memory without running vcpu.
> > > > +
> > > > +::
> > > > +
> > > > +  struct kvm_memory_mapping {
> > > > +	__u64 base_gfn;
> > > > +	__u64 nr_pages;
> > > > +	__u64 flags;
> > > > +	__u64 source;
> > > > +  };
> > > > +
> > > > +  /* For kvm_memory_mapping:: flags */
> > > > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > > > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > > > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> > > 
> > > I am not sure what's the good of having "FLAG_USER"?
> > > 
> > > This ioctl is called from userspace, thus I think we can just treat this always
> > > as user-fault?
> > 
> > The point is how to emulate kvm page fault as if vcpu caused the kvm page
> > fault.  Not we call the ioctl as user context.
> 
> Sorry I don't quite follow.  What's wrong if KVM just append the #PF USER
> error bit before it calls into the fault handler?
> 
> My question is, since this is ABI, you have to tell how userspace is
> supposed to use this.  Maybe I am missing something, but I don't see how
> USER should be used here.

If we restrict this API to the TDP MMU then KVM_MEMORY_MAPPING_FLAG_USER
is meaningless, PFERR_USER_MASK is only relevant for shadow paging.

KVM_MEMORY_MAPPING_FLAG_WRITE seems useful to allow memslots to be
populated with writes (which avoids just faulting in the zero-page for
anon or tmpfs backed memslots), while also allowing populating read-only
memslots.

I don't really see a use-case for KVM_MEMORY_MAPPING_FLAG_EXEC.

