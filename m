Return-Path: <kvm+bounces-61147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6B1C0CBEB
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FBE0189CE23
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA51D2F39B5;
	Mon, 27 Oct 2025 09:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtIw1jRf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A396226463A
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761558456; cv=none; b=RXrnmd+6S2w7aiizbzqqOek18ZEIsHS8Qh6RhgQK0jPCte2AFwKc5HqOm0sjJlEX08ihmIJ15ZDCNRhhX0twsreF8oOkQCK9eNIyUMfMe462IMA/Ewhva92T6OGmkMlcOMgilD7B3rjrmB8DLDmZrKSihh7foq4+cboVsiqJgGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761558456; c=relaxed/simple;
	bh=INtutBeGtSZcey+6l6//I7VSxH7KBfMtFX4UxJfmMhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbHhJMvCWAJL312mDeh47QhBX/umXZdaC7TptkbOEtBjDW43hVniFkOe4s6CVMhtIoe40m48HX8qx8tGg3cNuc5LV6OyIHXuqT0ND2FsXpYPlUqT15gTdSurhQZp4CRd0T+LTuMg0uy+Y0+LUakL5VoWtMixf/6nbip1SMaxrMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtIw1jRf; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761558454; x=1793094454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=INtutBeGtSZcey+6l6//I7VSxH7KBfMtFX4UxJfmMhA=;
  b=PtIw1jRf57JCES+mPVaI4W3oYuLxCkRJJZRRYLD4RmYRU1fHO6BYH76N
   OhQaSmmkKV/0ZWginm0EEtkr0BxogAc132smISZE/ND2crmy8byEl/F/m
   lr/opYUSuiKgJ6u35/C3xRUq+HJoqV4LUnQZEFYSfL2iiq32wXExUTFc7
   BDcPRqREwbW84MzJWqO5YpqgJDXjUls9b11TmEXDBuUIUW80fI1EHdbnT
   32EQmflBovGc8Dkp9vvKXq1O1phQgqGpDwTmsYDltfOCd8KhUzOvbnqN7
   TkslTiTAW+5Y5c603m4Ht75c6soz3VJO0CQM5wnliuzW/OUBDYBcbQK3x
   A==;
X-CSE-ConnectionGUID: Ix7SBn9NThmNDMIKt8MCLw==
X-CSE-MsgGUID: M7ctyq8QRg6D8vMUB6RiaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74235060"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74235060"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:47:33 -0700
X-CSE-ConnectionGUID: m0k8MP5VRSqS1ezfWvIK5w==
X-CSE-MsgGUID: dQXCqHEvT/GQG+pXwdsPOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184619291"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 27 Oct 2025 02:47:30 -0700
Date: Mon, 27 Oct 2025 18:09:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 05/20] i386/cpu: Make ExtSaveArea store an array of
 dependencies
Message-ID: <aP9E5M5d8ZoMhFCO@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-6-zhao1.liu@intel.com>
 <2d9f489e-dfa5-4bd1-bc7f-62223f81c167@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9f489e-dfa5-4bd1-bc7f-62223f81c167@intel.com>

> > @@ -7137,10 +7161,13 @@ static const char *x86_cpu_feature_name(FeatureWord w, int bitnr)
> >       if (w == FEAT_XSAVE_XCR0_LO || w == FEAT_XSAVE_XCR0_HI) {
> >           int comp = (w == FEAT_XSAVE_XCR0_HI) ? bitnr + 32 : bitnr;
> > -        if (comp < ARRAY_SIZE(x86_ext_save_areas) &&
> > -            x86_ext_save_areas[comp].bits) {
> > -            w = x86_ext_save_areas[comp].feature;
> > -            bitnr = ctz32(x86_ext_save_areas[comp].bits);
> > +        if (comp < ARRAY_SIZE(x86_ext_save_areas)) {
> > +            /* Present the first feature as the default. */
> > +            const FeatureMask *fm = &x86_ext_save_areas[comp].features[0];
> 
> It doesn't look right to me.
> 
> E.g., when users are requesting IBT, thus CET_U and CET_S, they might get
> "shstk" not avaiable.

This was intentional. This patch only introduces a new dependency array
without attempting to change the existing state. The series is already
quite large, so I didn't include all the cleanup within it.



