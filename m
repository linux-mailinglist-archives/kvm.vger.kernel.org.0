Return-Path: <kvm+bounces-188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A80F7DCC9F
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 13:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7C7128184C
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 12:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816FB1DA43;
	Tue, 31 Oct 2023 12:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YOoPwm/7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250EF1DA30
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 12:11:50 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7AD91;
	Tue, 31 Oct 2023 05:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=sZetSc9ylL0PFKinnKdf5Qp86cIZ0XZYbOJg2L3F9dQ=; b=YOoPwm/7a0smkyJZ84ssJSe7M9
	POIIOh6/RB1RMcbQCv55V/lObwCkwnadOv9NVu/bTzzng5IaVkoniS6x79H8jxT9NJmyWv6RKuw90
	p5JhcUzgz5DavQnPHSIKIIXOeIGQM/8jTykdIYHc5+pWJ/KnVMydHBTVsqQNgoFa1wGv2am8tebxt
	KpZg0Vp9yW5wagh4GmaQ+HcatrV/mnT1iCxTg9k2519D/+LsxIsiUqn4riQkJg9SKw4xXdDoMeOOK
	iHiak9vkEUywgIy0sYzZCGf4amfsAWpjwof+xNdiFpeJ3LQ7iUkO/fBo+Oj1s3i5CYSU3jDkp8Y5P
	HKMf6b9w==;
Received: from [46.18.216.58] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qxnau-004oSs-1P;
	Tue, 31 Oct 2023 12:11:40 +0000
Date: Tue, 31 Oct 2023 12:11:39 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: paul@xen.org, Paul Durrant <xadimgnik@gmail.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86/xen: improve accuracy of Xen timers
User-Agent: K-9 Mail for Android
In-Reply-To: <6c9671b4-d997-42ac-9821-06accb97357f@xen.org>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org> <1a679274-bbff-4549-a1ea-c7ea9f1707cc@xen.org> <F80266DD-D7EF-4A26-B9F8-BC33EC65F444@infradead.org> <6c9671b4-d997-42ac-9821-06accb97357f@xen.org>
Message-ID: <1DCDC3DB-81E8-426C-AF4B-AA7CA2C1271E@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html



On 31 October 2023 12:06:17 GMT, Paul Durrant <xadimgnik@gmail=2Ecom> wrot=
e:
>On 31/10/2023 11:42, David Woodhouse wrote:
>> Secondly, it's also wrong thing to do in the general case=2E Let's say =
KVM does its thing and snaps the kvmclock backwards in time on a KVM_REQ_CL=
OCK_UPDATE=2E=2E=2E do we really want to reinterpret existing timers agains=
t the new kvmclock? They were best left alone, I think=2E
>
>Do we not want to do exactly that? If the master clock is changed, why wo=
uld we not want to re-interpret the guest's idea of time? That update will =
be visible to the guest when it re-reads the PV clock source=2E

Well no, because the guest set that timer *before* we yanked the clock fro=
m under it, and probably wants it interpreted in the time scale which was i=
n force at the time it was set=2E

But more to the point, KVM shouldn't be doing that! We need to *fix* the k=
vmclock brokenness, not design further band-aids around it=2E

As I said, this patch stands even *after* we fix kvmclock, because it hand=
les the timer delta calculation from an single TSC read=2E

But overengineering a timer reset on KVM_REQ_CLOCK_UPDATE would not=2E

