Return-Path: <kvm+bounces-69795-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFFxEbMZgGkI2wIAu9opvQ
	(envelope-from <kvm+bounces-69795-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 04:27:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E50CDC80C1
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 04:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DEAE301B711
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 03:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8277123C8A0;
	Mon,  2 Feb 2026 03:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VCqaFVxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98865D8F0;
	Mon,  2 Feb 2026 03:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770002793; cv=none; b=PIUyFMbhGh6KH26I8XcMC9JLnjKzdPyReigBwxlmZw3N8iOdqfHe+O4VWA9fYrPIN8NegEgJw+6RLIMpJQQBgDfaHuQRq3NTfstfBwlGGv+VBGVIUgpQRNHQyZ/S+4JcFwsACNUeMpk1LyEN7yYle7Dovq0OrVZbn9RE9UMc/vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770002793; c=relaxed/simple;
	bh=LFhG+m37SaXl/4/Xbwsrthhg5xqeUvM+vlX7PPObbLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dr1V0yF5dJpbVLdsJw+kq3CZR/rnX7TRQuuYqeAeSSpWQ2ooxvWVCXKwTK+9EPIbQiN7ikmaJ047aBNFnBwcPUbV3HoSZeBCljhFwH/WAYWXvcdlu5TtXJzBO99QrmFWowXlW5W4lf3Ijq0scaFhg0AG8ABD8frWMbD5bcEfdg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VCqaFVxZ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770002792; x=1801538792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LFhG+m37SaXl/4/Xbwsrthhg5xqeUvM+vlX7PPObbLA=;
  b=VCqaFVxZ4yAHJ97YL4OgCTRGMRxqn5/1fXfxqpIOfapWXKpilTnGfqht
   WUs/OO3ukNvY9wNGAAVlIYx9WlJJqaPPDZUJx96mSdrmKJ5vETykYwyoD
   qrhf0maIsCf1JaFftfeY1kfzx231jOSj87Ol1dRH5q+UGiYfAlmwD9Aoy
   zledPdZrCi/qznb6YuBKy/HNPAhLFhClvIVVMbD0LIDN5kIOdMU+MsBTj
   CgV++UjggdC/jyc8W+nUgSm32VM8QWtyygOZPIU+314sYvUlrWeHGssm9
   v7Lmq0ZKo0w3NYAx23mUmn87pnMF00nEhHHseu8bn8clpJ9yCDcI7+kXA
   Q==;
X-CSE-ConnectionGUID: RLfdp/IpTOaqY56RbSBUXw==
X-CSE-MsgGUID: FSPiJLN5RG2yIG3f49gmQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81473027"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="81473027"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 19:26:32 -0800
X-CSE-ConnectionGUID: Z02yaL8gSIijW/zJYy+rUw==
X-CSE-MsgGUID: 5yetVW55QKuqhBbxYbNZOg==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 01 Feb 2026 19:26:26 -0800
Date: Mon, 2 Feb 2026 11:08:02 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aYAVEmKRNfLboxeU@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-14-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-14-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69795-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E50CDC80C1
X-Rspamd-Action: no action

> +static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
> +{
> +	const struct tdx_blob *blob = (const void *)data;
> +	int module_size, sig_size;
> +	const void *sig, *module;

You need to firstly check if size is big enough for the header before
offset into it.

	if (size < sizeof(struct tdx_blob))
		return XXX;

