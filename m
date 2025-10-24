Return-Path: <kvm+bounces-60959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF3DC047E0
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 17ACA4EA571
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FFC26ED4D;
	Fri, 24 Oct 2025 06:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ9avc45"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1638A1E51FA
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287014; cv=none; b=K45DgqfUuDleQCYs6l+3YceEwvSEnHZ6xm1obV5JuMRi71mjug4byr24AD3YEkAiDMVSVVQni585vjsbCOXZ1CoT8dv1QoePG9qogwEvcSY0AXMFfO8VksOSy2s+XGu8ZGVLxpFZgXvpkZ0BBBOnMR+rv+xYJ4QxtrOchNdj+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287014; c=relaxed/simple;
	bh=p11nCIC6goMTm1soTTgUoxKguA1No2wggQIaWG6My0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fi/rqpRQdmx0alLm5uwwWLkn4h4CYaLBDShLkObMNFt7b2GODXT8Hyc3mUmKPJD6eYikXJnyNy3uTVRE5hyUH4lznqCeDtkSBlH4TKCsLL6VmpUU/02vTjRC9fDL5IQVbZB1OYaSf/4i1UP0KrHQuW3VRFURgAK0CwADNhsSE2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ9avc45; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F914C4CEF1;
	Fri, 24 Oct 2025 06:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761287013;
	bh=p11nCIC6goMTm1soTTgUoxKguA1No2wggQIaWG6My0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZ9avc45NC2ciI3BYy8JMVBZigBBt5HhZA65tTk2fjcRSLplwJzUxbbXGtO0Yw1o3
	 YyUwW7lnpF0KNRuPe6qmI+D2J6h2IaQnS8okED+4EbIzmyxhkGoU/D5egxHAX0aZ7D
	 WAGkCwT41ysebo8ZwWgXhvBAPmJDEfuWKk4p+HJNNFFwNqSndD/Vf43k/wGthdOEB8
	 m4vJB7ByIVzyhKBOLCemMm7vUSR3cZWS7TkQqkoLg4yWl284XjlmNw9uch0TcB2Cxs
	 bNaKjL9Ocxcbr/GhyZKx1mWFneb01eTBbE3Qs7Oh1ZlxMAJ0paOfYFnGVvCLayWvOi
	 0a+ioYQWGgQbg==
Date: Fri, 24 Oct 2025 11:51:59 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RESEND v4 0/7] KVM: SVM: Add support for 4k vCPUs with x2AVIC
Message-ID: <acx376ilgnzmoaqfh3mjge2lt7joods7ix5ft37iykyslrlnos@c24idinddicc>
References: <cover.1757009416.git.naveen@kernel.org>
 <176097555536.435958.1932451484992225591.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176097555536.435958.1932451484992225591.b4-ty@google.com>

On Mon, Oct 20, 2025 at 09:33:09AM -0700, Sean Christopherson wrote:
> On Fri, 05 Sep 2025 00:03:00 +0530, Naveen N Rao (AMD) wrote:
> 
> P.S. I haven't forgotten about the IRQ window fixes, they just require more
> brain power, so I'm waiting until I'm fully charged :-)

Sure, thanks for the heads up!

FWIW, the patches still apply fine atop kvm-x86/next, so I will wait for 
your review.


Regards,
Naveen


