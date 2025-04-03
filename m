Return-Path: <kvm+bounces-42534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2B2A799E7
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 04:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB7F4188F11F
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB96416F0FE;
	Thu,  3 Apr 2025 02:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtsO8qBS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117FD53C;
	Thu,  3 Apr 2025 02:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743646356; cv=none; b=FVdGkflC6SYhdinjOxSV3BGLD+uURlNvNOMh6D+wkizdxiKcAvOq6MzVhsuD2G99+rNW30bKV8wSr287LTjtZ+s7dpg9SCXL3IfqjwWx0Y/0IYBfkTnKP9NpBd1WGwLMl5E60/o8xW/S8gPOyG2r/f72BLiAxAKc1dw+MM+WoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743646356; c=relaxed/simple;
	bh=l16JiU5Qi1DyC6yHUMRNW3rvykHizycMqj2EsgnSnZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuHi47WqzkgIgIoGZSB6Kimpcxes6h4QOeGO4QW2il6dkl1gvwo73RmHfF+fcgqvi3O4p8Levz0Jro6vlYYfzVhinSiav90Y4G7RWPXC4UAtFMM3xVYnrRMWHZN3vtBBEl87YrzBc2A63nxYme/5VD3dnR8b6WQhUni3IqL231E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtsO8qBS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3787BC4CEDD;
	Thu,  3 Apr 2025 02:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743646356;
	bh=l16JiU5Qi1DyC6yHUMRNW3rvykHizycMqj2EsgnSnZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jtsO8qBSgqz7FuooZx2Ey42nayWea9A/KwWMs3XaxJ9nxqWioHSSnHRNzIXhHqc3H
	 9bTPLS2ALSsPmXZhyV+mN7totGag4bqMKT7okAxZWlrSjtpACjaqz609p9ZRuYzJY3
	 4iVOcZ4A+G8HEtxx4b3BulE8s+SebA/kQc3eDujEI9sWoeyldWR3Cgs0571hfz6yNr
	 Q3SytHBKxlZaxOsflqWKbJ2Iyby+nb7vOYhHm3I5D86OyeurLgbhT2ApmjMoUvS3/Y
	 n+A/BkoC+XGu4OuTIle894XyHFZ+qWGAhDIX8LfZzKnJCPE9TOWG4YKaGTPyxytxnS
	 qQl+vxE+60Bow==
Date: Wed, 2 Apr 2025 19:12:32 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, bp@alien8.de, tglx@linutronix.de, 
	peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, 
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com, 
	sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com, 
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
Message-ID: <5fnlcvhbmgtfxa7ivg6lks3vcnvcrrufl7xe2p2ifzhzkb65qo@2vgpex7e3g6b>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
 <1e34033b-3e3a-bd23-af5a-866e68d5a98a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e34033b-3e3a-bd23-af5a-866e68d5a98a@amd.com>

On Wed, Apr 02, 2025 at 03:41:25PM -0500, Tom Lendacky wrote:
> On 4/2/25 13:19, Josh Poimboeuf wrote:
> > __write_ibpb() does IBPB, which (among other things) flushes branch type
> > predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
> > has been disabled, branch type flushing isn't needed, in which case the
> > lighter-weight SBPB can be used.
> 
> Maybe add something here that indicates the x86_pred_cmd variable tracks
> this optimization so switch to using that variable vs the hardcoded IBPB?

Indeed, adding a second paragraph to clarify that:

  x86/bugs: Use SBPB in write_ibpb() if applicable

  write_ibpb() does IBPB, which (among other things) flushes branch type
  predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
  has been disabled, branch type flushing isn't needed, in which case the
  lighter-weight SBPB can be used.

  The 'x86_pred_cmd' variable already keeps track of whether IBPB or SBPB
  should be used.  Use that instead of hardcoding IBPB.

-- 
Josh

