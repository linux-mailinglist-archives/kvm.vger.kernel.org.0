Return-Path: <kvm+bounces-57707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1488B5933F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58C461BC3E8F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A803019DF;
	Tue, 16 Sep 2025 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kT60D2Yk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC4F1BD9CE
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 10:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758017953; cv=none; b=qo+RO4SBS6mWrnXZGkl2pNS1agIcYm50q6Kd5lv7RpeEyItYzzYvga3t2Y4IG7whPw4Cy4J/QOfQfXSN1FyA0Xc/X37poUVgUqeGgkCtdSOzyQFOZFRB1NoICCeBGLCKqqCiYSDZw5CdVInAIemQtH3ZorLLLv4pw1+OLDmWGr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758017953; c=relaxed/simple;
	bh=ecG/XfZ4nG+rD0llyC8iGvL/naEdiJ2i/qhY5hivxI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYASav0uSm8RZasbHwy9PGcRQPfQM6GCUCVq5Uu/Vp+Y8DXEQExmo6bMGpqGrYvcj35BkUez9CdbMV/wYYaXl4S+0ENZflbBm1fb+wleXU/pZbK/JrBckX4o/aITm1+kzi9LzCaeSpoZmCJFVhyAnz4rkS+6adtrOnFiK/bVxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kT60D2Yk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A90C4CEEB;
	Tue, 16 Sep 2025 10:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758017952;
	bh=ecG/XfZ4nG+rD0llyC8iGvL/naEdiJ2i/qhY5hivxI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kT60D2Yk7W9fzW+uomIKlGmB5RfuM2uzuiSSHw4GuuTEWUixd96VUxg08YukECJHL
	 LVbj3/AsmmZf9+PqYSXpwy3sKULPpKLziXiyTa0IFceF7Tiy8Ke9FDNaD2kJiMqwfX
	 OxhFxp/6FdB4Ma098rCgPHWT40R6d10YpCk5ViBgn5Xxd2qXIYLgJPfCnVPH/91aU3
	 iWEp2CBJQJuatvbmKvS/9ALDwneW5+XbSkHqH3JJJMQkrPTp6ybZCBAA93/BGV8YI5
	 PUE6XBLpzW8SL8TyQPcvjs+4253DL5vRy/V2kfjVvRhGEiuIYP6CeL9nVONvzYzNcl
	 fqIxNk45BG6ig==
Date: Tue, 16 Sep 2025 15:47:17 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
Message-ID: <cl32d425vsfezgagzl2kj7zhid62kziyzz3ioo55xlovh2dtem@yescly3ch75p>
References: <cover.1756993734.git.naveen@kernel.org>
 <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
 <aMiecWn8kZFXjNZ9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMiecWn8kZFXjNZ9@google.com>

On Mon, Sep 15, 2025 at 04:17:05PM -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > +	/* Enable AVIC by default from Zen 4 */
> > +	if (default_avic)
> > +		avic = boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4);
> 
> Got distracted and forgot to respond the actual code.  This needs a comment,
> because intuitively I expected Zen4 to be inclusive of Zen5 and beyond, i.e. the
> model check confused me.  But the kernel's ZenX flags are one-off things.
> 
> I also think we should enabled AVIC by default if and only if x2AVIC is supported,
> because Zen4+ should all have x2AVIC, and I don't want to incorrectly suggest that
> AVIC is fully enabled when in fact the only aspect of AVIC that would be utilized
> is KVM's use of the doorbell to deliver interrupts.

Agreed - that's a good point.

- Naveen


