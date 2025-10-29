Return-Path: <kvm+bounces-61414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E33C1D0C3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFCC7425C84
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 19:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8DB35A138;
	Wed, 29 Oct 2025 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkzgc3gg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339D22D3237;
	Wed, 29 Oct 2025 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761767312; cv=none; b=Bf+jQVXt0BXaA+8+hBdgslgzhHAQQNlAXMyMZS2Tbyxe6l1w36nfayvHa7bKk8JhX1hXPPsAtClzPjd6OpKugP2bV3X25lryFFCemdHqjWOEZiJ+VqwGHLi1aJWWz6giNkI7hI3LwYW9/9EUcPypSDrhKecpiDBYsOLTp0ApOww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761767312; c=relaxed/simple;
	bh=alZzkBHUVozgAVjPhliZcTW01eB8/PN7l5DU985+Wvw=;
	h=Subject:To:Cc:From:Date:Message-Id; b=EtaQDAseYHRYnl0SHBifxMO1JcVTO5HWyFi6Z5ZBzp+H7c3qaGh5UCKduyrw2MbIR5Z4VrvnIo2OzXsB22C6CpsQU6Q2RRU3Nm+sRMSg3XcAFq/HG2GDSVqriwfVnR+oGP1i8V4wi623+qgh/LQd8NJOGzYeOZphUorpkeVtVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fkzgc3gg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761767310; x=1793303310;
  h=subject:to:cc:from:date:message-id;
  bh=alZzkBHUVozgAVjPhliZcTW01eB8/PN7l5DU985+Wvw=;
  b=fkzgc3ggeFiAzOrdNvhK9urMD9NZhaexNNS3I5r0JaAme4T5knEjxp0w
   ESPBNo7FLrWHc75suDyH2z8Vj2fzWU8bl32djmBcUTfaUq43d5rV/vOa5
   l4UBydexC9Tx0Mi5Itm9jdeSBE5SgsThnyWGQ6DZLiDXQCYZ8hQSmy3eg
   eYuWEy2kyg7vq0nhw50S1vgbmnvFxBrzbzZUWu+/expNMIiMznw2zOhEg
   jolpxzAhYGUHlOfMUDSmUp2HSZfEyId/9xI0eUZEtCq1u2Mk3ee+hZFIt
   zWKhniXHkBH7t6TNwDscH1yAxBdp20Gk+tbppTRaToxiblQyKAf2g/Rmt
   g==;
X-CSE-ConnectionGUID: xqa3MwxDQwChoixjZzybUw==
X-CSE-MsgGUID: wEjdrYEMSwu63ToSyHgAOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67736367"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67736367"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:48:30 -0700
X-CSE-ConnectionGUID: YQ6ymWNORA+g6lwk3xGWgg==
X-CSE-MsgGUID: pS7NYWB8Q3+Jr+Sq0RED2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="216416458"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by orviesa002.jf.intel.com with ESMTP; 29 Oct 2025 12:48:29 -0700
Subject: [PATCH 0/2] x86/virt/tdx: Minor sparse fixups
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Oct 2025 12:48:29 -0700
Message-Id: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Sean recently suggested relying on sparse to add type safety in TDX code,
hoping that the robots would notice and complain. Well, that plan is not
working out so great. TDX is not even sparse clean today and nobody seems
to have noticed or cared.

I can see how folks might ignore the 0 vs. NULL complaints. But the
misplaced __user is actually bad enough it should be fixed no matter
what.

Might as well fix it all up.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

