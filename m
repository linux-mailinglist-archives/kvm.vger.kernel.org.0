Return-Path: <kvm+bounces-70510-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GJgHOfRFhmkVLgQAu9opvQ
	(envelope-from <kvm+bounces-70510-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:50:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FD5102E68
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4E4B301D95E
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE0B336ECA;
	Fri,  6 Feb 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CgsXjoJz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A0526ED59
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770407404; cv=none; b=dOFGz3u866brbDBgz/582gfKIkPyiv02/DxD60KKd2Q1pTj1ObrL3yaMt5ccC/onunwQJ5b+0/yuupvDNtsQ5OzpvmM66iG+9xCIfDNlibX9eCA7Vd675GDdnpf/QW8f0zZYtvS3nEHaAF1yJU3GK1zmS/dkthcGd8S4La89UFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770407404; c=relaxed/simple;
	bh=TsEFJkcKhYzvgcG5/7ppTLt6u4oGU7jCOQ+Ejqe0MDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AY1WKZLCJedp8jQckBDbodKN8kbsrEGrW+RShY75bRNtmvmK/jTopamyH/n7YwpCTs0uuUsHyO0Eb/3RV/3EEmlD8MY0bWbyLJX2pTPhQPWxlkwuGLFGWNrVaCPBTkggp7pAlTVuO3TcMb4s/CsnmpqFuDBgj5D4L7HB+I/iihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CgsXjoJz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f2481ab87so2269614b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 11:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770407404; x=1771012204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I1jJkQvNi67f2WiL1rB6LTa3epncK2iO2DDRLCaSJpk=;
        b=CgsXjoJzdtoSjjdXAD7DMhaOEe7SoLjp3nmJ6xlfFFmU2yoK9K1IH0yHilvsuQgC2d
         w6nU6RC3fGicS44KiT6/CxULGL21yHu8IkEtxp9S9nDtRh7Ro2RRkCSPU33z8BqhMi4C
         5pR3ozrOuXQileKtfVoNch5JGuXd90bBM5rMX60bsKfKTMeF94Iwh5oFR4QnitFCg37+
         dFm/rYupbizQpt2TmI7uzzaQ3866Kb+gY3srEzGSLaMogU79518veCFka4qFlZtpbqee
         jS6q/OQu+iwlYyu04kzMQpqWJJ6y529ipljGXJDx2/rE2meltloEa7p8Kl8k0gQtbzBa
         mWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770407404; x=1771012204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I1jJkQvNi67f2WiL1rB6LTa3epncK2iO2DDRLCaSJpk=;
        b=ICKbbGY01xdPKJw76CDC4yFDfjr3wlSCzRah+Mbj/l2j3KxY6I0eDHZ9JiQd5FvnpA
         aI52voSrIgCpdnzPRufhInNZIazqH9QzWHCgrL51P7uB6JMJKCpyaIl4r4xQGdEtQpTm
         MGMjRGssU/sWApc3OLT3rINQiLd3d7ZqaTnKNrthA4OV9ZA2yiv3XZrAvYmaGfiQOadz
         DmvonmLyWjJJi85XkVBzP9oHOryN+HlatoHFTbsQ/phgcLhO0uVHMMaMJA94EkSNIi6+
         MNRZBu4tbNLxZWB5/DMjLs1GQ1QqGnEtsGP+oH2YJTAO4VIJs1Z1mIza3hS2Mhi2+m9n
         Jimw==
X-Forwarded-Encrypted: i=1; AJvYcCX+9BRx4RlV5T14GUS0FSOI/5j8MYJa4/TuuIkwXPUW4nt5t9SEM42kzZm00Z1HllitFHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgT7kphkxc1xbS0P18LMa54vbY+WnZHT93a+obabHumreV3fEh
	zGvayXciOCr/ZI4832es8QG4lezXlB0n8zvgd9GFVJZWpEBushoJJo7fWJZENTVYh/ToWXzcqux
	DXSHIAg==
X-Received: from pfbdi5.prod.google.com ([2002:a05:6a00:4805:b0:823:efc:21ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3914:b0:823:9e5:855e
 with SMTP id d2e1a72fcca58-824413c8e09mr3610811b3a.0.1770407403686; Fri, 06
 Feb 2026 11:50:03 -0800 (PST)
Date: Fri, 6 Feb 2026 11:50:02 -0800
In-Reply-To: <u566x5dz5a7trddlb3s6kustfvewdredrfldbu7yxlnl54wicp@tvzanbhtbmbd>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com> <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
 <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
 <aYY9JOMDBPDY48lA@google.com> <u566x5dz5a7trddlb3s6kustfvewdredrfldbu7yxlnl54wicp@tvzanbhtbmbd>
Message-ID: <aYZF6sYhDIdi-pvh@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-70510-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 62FD5102E68
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> On Fri, Feb 06, 2026 at 11:12:36AM -0800, Sean Christopherson wrote:
> > Oh, and if we do plumb in @ctrl to __nested_vmcb_check_save(), I vote to
> > opportunistically drop the useless single-use wrappers (probably in a standalone
> > patch to plumb in @ctrl).  E.g. (completely untested)
> 
> They are dropped by
> https://lore.kernel.org/kvm/20260206190851.860662-9-yosry.ahmed@linux.dev/.

At least I'm consistent?  Hmm.  Jim, can you base your next version on v5 of
Yosry's series?  I think when I apply, I'll splice in this series between patches
20 and 21.  I could resolve the conflicts when applying, but since I'll probably
tag these for stable@ as well, I'd rather apply patches that are closer to what
was posted.

