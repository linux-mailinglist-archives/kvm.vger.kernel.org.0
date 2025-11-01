Return-Path: <kvm+bounces-61745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B463CC275B4
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 02:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9451440809E
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 01:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B99246BDE;
	Sat,  1 Nov 2025 01:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k2J48Xdb"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692F224F3;
	Sat,  1 Nov 2025 01:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761961782; cv=none; b=OBcGlBpgxpHfyxRkILCbKVenRLPqbiXy4k083GEuO86tpYPsUnKNKI9bMo+YyTcPZ2GPHBKSUVexsNlZ20sRTTfPxbrMwPCzMb/0aWoSrYPwRAa5HAkIj7zrvXyG/1Nc/9Khge6q9DVDIADKWqEhQjbCcN0/UDoqLwIWKduTQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761961782; c=relaxed/simple;
	bh=1umXQ+sr7e8xhECRIAB5IuGNc+ig83KK+yW23N5oFF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEPgSGm8H/UFeDVY8NtDWc1rUn/ikX6PhyVLMfmVIgsBgbS8ieEnpGGvH1Vd4SCBQnRMPb4UbTGdHLpcRXQkxZO3kUzVqjiEgnuQ9iKIZuVfQj2eekkNKYB/UzTSwcT7g0D2N9UAsurDFAaXj/IsVgSNbPlQVKEKiWbxuD3JRxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k2J48Xdb; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761961775; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=zMMeimAOcwT4ORBowSdPmXpB3X+GfVnlMkO4izFCVQQ=;
	b=k2J48Xdbvhc2dUfUQji514459RwZ0YnA1ooFVxv/l/noMdu+tQp4CopboPn+CcYixEpn2fRs+Z8GQZQqyrMzEWidp8eVVnUEI679R9yVWVqcTEpagFXD4RaqW3xvb5SIMahfenXQlKubEHym33htckr4XmTUc5pe3AeNvt8ZDr8=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WrQJ4el_1761961774 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Nov 2025 09:49:34 +0800
Date: Sat, 1 Nov 2025 09:49:34 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
Message-ID: <yywvcb5eujvkqwnip46x7c53bkqe6b6rqg3u4etzkjmgcqfpgk@ajulxuswpvcp>
References: <20251030185004.3372256-1-seanjc@google.com>
 <bophxumzbp2yuovzhvt62jeb5e6vwc2mirvcl6uyztse5mqvjt@xmbhgmqnpn5d>
 <aQTrcgT9MMY_69wh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQTrcgT9MMY_69wh@google.com>

On Fri, Oct 31, 2025 at 10:01:38AM +0800, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Yao Yuan wrote:
> > On Thu, Oct 30, 2025 at 11:50:03AM +0800, Sean Christopherson wrote:
> > I like the dedup, and this brings above for tdx which not
> > before. Just one small thing: Will it be better if keep the
> > "vmx"/"svm" hint as before and plus the "tdx" hint yet ?
>
> It'd be nice to have, but I honestly don't think it's worth going out of our
> way to capture that information.  If someone can't disambiguate "kvm" to mean
> "vmx/tdx" vs. "svm" based on the host, they've got bigger problems.
>
> And as for "vmx" vs. "tdx", I really hope that's not meaningful information for
> users, e.g. the printks are ratelimited, and users should really be gleaning
> information from the VMM instance, not from dmesg.

thanks for your reply, Good point on printks are ratelimited!

Reviewed-by: yaoyuan@linux.alibaba.com

