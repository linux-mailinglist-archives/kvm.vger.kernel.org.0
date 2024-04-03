Return-Path: <kvm+bounces-13498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EC2897ADB
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 165E61F27019
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA6815687B;
	Wed,  3 Apr 2024 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+3qWW03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91842BB02
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180205; cv=none; b=U3KhwPwTz1jRgv7WRS/Z+397g9y+Q8QYm41wIe/28Ft42xba0Ydvp9dOI5u9GrDIFcz37dsj0Nv5ZgZeQ8meRrBPSjGGZg4bRbD7otr2Kxovo3bzGKuSvGBTQTLZY1rXxciw7zIBEmHyztdBbJV06GSMMqfj/gddMbWQHC2VKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180205; c=relaxed/simple;
	bh=eW0vjqV7z+PAR1g4tFJb4YbSM8OnjwNtis/IuUJSfjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J7xoGG0UFwT5o5tvWjo/HhxhL+NeWGEOlhV5IzIqoWia0SwLPttnyobbuIvbbvHvN/4jmutiIw3NwsDsNCc5WYdMk3tZUsBnC9+m+06n0aO85oJXRVN9LBJos71n6WBZLQm1lP1RDhmo50g99k9kofgaYSyADfFgMUE0Wjr+cOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+3qWW03; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8dbe37d56so304021a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 14:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712180203; x=1712785003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dPltzAFf6VDIT1wIj8ilrUQtdD5DBvoWePx4BEmHj9U=;
        b=B+3qWW03vdA1vHywBGdk2grTe0T0ZqqUK4hCDVu4wQoqiiAN6/s2mZvAIEnEyD2A1B
         fZVDSq7vqk6c8o9sA8AeSKqSwm1CZN0NNKC6V+8wYvlKW8O/jQgVTNroS8vn1NDh19jK
         LIr+kV3lUNN5g56xRQTY+iLvAJGBF+2NCBWjKUNinBEB7xhgjEXpNCK27Z2VvhvQ4Ppv
         gRTKPfDAxWfWPwfEJ8w2dYzzDL08gtN36TIfTMhlCBTJXRChGOHCG8U0u6DdrbbNM6oy
         h1aJvj2EwXipas71HNwbWcO46Zz4iWhL35xPTy1NJpP+QaPhL8Gf1YGkzY0Vt1D3uhbX
         TGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712180203; x=1712785003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dPltzAFf6VDIT1wIj8ilrUQtdD5DBvoWePx4BEmHj9U=;
        b=a9JAhquO86MdDscMoosCTSQ9ThHFZ/0p9z3PsEzVjtkEZjOg3Teu3/qaIsQsePGXqd
         qQJFHoEaLzGZ2StBqQcvUAKwkwwwb+Uhiz451Emo6vjj7NtDhDVtK/UZfnigfAipT0wS
         beclKi00NNfuDvdbrrmkxtfA+CP01Bcg9/E1mCKqnBndauz1zWB2nvqZelDEhiUMLilK
         pfJICPXo/zHJIWPLXZo7E7lvlwp6HzBMd99slPIxA7oeuuPa5uzG2kfDT2AsNOXr3cyF
         fHMYeDRuiFSs3vlNYxuXaMw6YthlM6Wde+sBNXp0BigK9kepSjLZg64zpnPD1NLhgFnh
         tCfA==
X-Forwarded-Encrypted: i=1; AJvYcCULdJKrt8Nhq4B+t2VzncJNHQ9tXCN0nx//FK+w9S+m+Z6mqdjhmAF1dNTXCYlaoskDyHoEekCZQgbMBTClfY/WjVjT
X-Gm-Message-State: AOJu0YyGFRxsz9ihvQ3uh26XmhQ8U1WQnJGqaDU4amQTwZ5Pu5IYM4kM
	XLR0jBvSgQKgZ4m9gwiEwHmUULR7zZOH+zA3Ysf90RCp1V0xtVmuxCu/jIT88Q0OQ22PtYfzifB
	Mtg==
X-Google-Smtp-Source: AGHT+IExCGrJPdAW2GeOLG491SIcrLlhsuV3XsGg9Om6QoQqLDgMtfFqtvcSt+vrYfYHgj0J9CVY23pc2dY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:434d:0:b0:5d8:bb9d:4fd0 with SMTP id
 k13-20020a65434d000000b005d8bb9d4fd0mr2015pgq.4.1712180203127; Wed, 03 Apr
 2024 14:36:43 -0700 (PDT)
Date: Wed, 3 Apr 2024 14:36:41 -0700
In-Reply-To: <70d7a20a-72dc-4ded-a35f-684de44eb6e6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
 <ea85f773-b5ef-4cf6-b2bd-2c0e7973a090@intel.com> <ZfSjvwdJqFJhxjth@google.com>
 <8d79db2af4e0629ad5dea6d8276fc5cda86a890a.camel@intel.com> <70d7a20a-72dc-4ded-a35f-684de44eb6e6@intel.com>
Message-ID: <Zg3L6VttYZkb7N1M@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 20, 2024, Dave Hansen wrote:
> On 3/20/24 05:09, Huang, Kai wrote:
> > I can try to do if you guys believe this should be done, and should be done
> > earlier than later, but I am not sure _ANY_ optimization around SEAMCALL will
> > have meaningful performance improvement.
> 
> I don't think Sean had performance concerns.
> 
> I think he was having a justifiably violent reaction to how much more
> complicated the generated code is to do a SEAMCALL versus a good ol' KVM
> hypercall.

Yep.  The code essentially violates the principle of least surprise.  I genuinely
thought I was dumping the wrong function(s) when I first looked at the output.

