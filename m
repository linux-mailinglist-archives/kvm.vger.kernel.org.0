Return-Path: <kvm+bounces-13474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A471F89742A
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 431C91F27254
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F84A143869;
	Wed,  3 Apr 2024 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVC0aPuD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763941DFE4;
	Wed,  3 Apr 2024 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712158730; cv=none; b=uko7MrqCVDwnCKXgY3Y7Vd7AzbrRkBkd0IsK1qJFUPcJsGmeIbKy2ZWr/VVQlkwx5+atPCrWLMCharjHOxWG2Z3optN4QHuD/JgWKPcDBvUK2lHwStVsK0sWDYYKwsY6x/+tCdzv+71lYIbOILQBN7V3m7MxEp33hJe498rLeFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712158730; c=relaxed/simple;
	bh=mdDoDHzYyJDMK8GKn5MPsJuHSLiCQme+XqAogU50jZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP2juw8bYMvK/nmwsmfk/xOoYUy+ASzzmmk62pb/u8uqqtjfhP+uL2wZlv3kTlaqv8s1cIkB9dDvaAQfhhOfr2NsS3FJcysOi6vvJzb7YZYw+xig7ZGpLhjjOi32srhcuAuC94DvdAYCTa8l3z7ap9aOurYDQ+RmfZYjMTZwTh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVC0aPuD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7B0C433C7;
	Wed,  3 Apr 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712158729;
	bh=mdDoDHzYyJDMK8GKn5MPsJuHSLiCQme+XqAogU50jZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVC0aPuDSqNyB8Z4metqsDTdREXc4WgmTOG699M8UOrcJWOoE0/+6IxhUtXzRF/lt
	 QsqXN5xX76QdeBvHwU1S/rG41l44mI+uv4u5dfK8PmHEV78C2img8Cl/D9L5IlAFBi
	 nTsPc/zx8Fn8lBKwzpPxbJPrivzxF9qle7t4znB1ei7ojMRNfdot3Dx0LWDkOadlen
	 ff83cmtGc5WpD2FncE13eOZPsMcaZFE79F3mMsi/PoO9Dp9qRRLJO/9BwEoLGiwSay
	 Y9CREo314bSVUZ9DFmpEWwACDEEZh8C9h+rWhHnWa/aSGVEDY40WV5C8jIvATkETzf
	 K9j4eXjaAg3mg==
Date: Wed, 3 Apr 2024 16:38:37 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	David Stevens <stevensd@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jim Mattson <jmattson@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Anish Moorthy <amoorthy@google.com>,
	David Matlack <dmatlack@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>, Edgecombe@google.com,
	Rick P <rick.p.edgecombe@intel.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Wei Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Kirill Shutemov <kirill.shutemov@linux.intel.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Jinrong Liang <ljr.kernel@gmail.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Mingwei Zhang <mizhang@google.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
Message-ID: <20240403153837.GA17489@willie-the-truck>
References: <20240402190652.310373-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Sean,

On Tue, Apr 02, 2024 at 12:06:52PM -0700, Sean Christopherson wrote:
> We are planning on submitting a CFP to host a second annual KVM Microconference
> at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help make
> our submission as strong as possible, please respond if you will likely attend,
> and/or have a potential topic that you would like to include in the proposal.
> The tentative submission is below.
> 
> Note!  This is extremely time sensitive, as the deadline for submitting is
> April 4th (yeah, we completely missed the initial announcement).
> 
> Sorry for the super short notice. :-(

There'll definitely be a few of us attending from the pKVM side and we're
interesting in the usual stuff: Android, arm64, CoCo, guest_memfd, virtio,
etc.

The big topic for us right now is figuring out what our user ABI should
look like for upstream.

Will

