Return-Path: <kvm+bounces-11112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD1A873232
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC7981F21B05
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E372760ECA;
	Wed,  6 Mar 2024 09:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VzZJueTL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214385F49A;
	Wed,  6 Mar 2024 09:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709715955; cv=none; b=CBX7Qw5+go/yIf0nFp2P77z+1+TsGLW34E+dP+ZBaYtpZZxCr5v5tkkSeHWZKJaIRRvLxpzNYSelhQsW7Qcbae27kypJxo3gbrhvw7uG5qtrvXwZVCBoHbawdn/KiHyg71VGHRyvJ6JyjugFpqQ0KyCLyYbJFsqgBX+3ovVF94k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709715955; c=relaxed/simple;
	bh=aYnahezun73pjCUX2IVGuMCgrwsCOEkGUjelhjR0KAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jq5tR0zo+BzBihtUphkHqSUwrM73XrJnl9mhN4xdtYlZJFbTwHMuwgrFNtSbHL0hs8AJPzs1cBcjMQVcUqhs4qyAHsLHmulptbi9UAoggOY0ClHpdwz2+gL4Bpp4sQn76u0w2ExVbXMObPoTn9rfFgKwusKgbJxOt9eMcBwkSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VzZJueTL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709715953; x=1741251953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aYnahezun73pjCUX2IVGuMCgrwsCOEkGUjelhjR0KAE=;
  b=VzZJueTLnWKMq1zszGjBRrTpi8fE+7IdOwOveDPoPebjAz5beQMlKy6L
   Lgbz21VknVoH/UZnkpd3RSLV8g3BRKZDbCFV0UcXHYfM1x6vpMTvcLHIl
   h3BhIo2Y4e4OR4lznBFb9/3nKC4usUDPttPL2NDblKTGSppQGhHJ6pBvH
   cPtsFD2pzBvubsgj0g4jKp9Q59HdzUNO6XqvPdlexTPhclO56QtvZqZpn
   pWiwsLCKe2PRD6/2dup6CJawNTRkZvdqS2Ep5x2jQbtSTmxoCgbr463by
   N7ccq0Pj04fapyl6sW7CbFYda9apddPCpj65DH7WZpb3WaGP8q4B9L157
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="26783873"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="26783873"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 01:05:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="9665672"
Received: from sunyi-station.sh.intel.com (HELO ysun46-mobl.sh.intel.com) ([10.239.159.10])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 01:05:49 -0800
Date: Wed, 6 Mar 2024 17:05:45 +0800
From: Yi Sun <yi.sun@linux.intel.com>
To: isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>,
	yi.sun@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v19 005/130] x86/virt/tdx: Export global metadata read
 infrastructure
Message-ID: <Zegx6R4W3lVd+5tx@ysun46-mobl.sh.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>

On 26.02.2024 00:25, isaku.yamahata@intel.com wrote:
>From: Kai Huang <kai.huang@intel.com>
>
>KVM will need to read a bunch of non-TDMR related metadata to create and
>run TDX guests.  Export the metadata read infrastructure for KVM to use.
>
>Specifically, export two helpers:
>
>1) The helper which reads multiple metadata fields to a buffer of a
>   structure based on the "field ID -> structure member" mapping table.
>
>2) The low level helper which just reads a given field ID.
>
>The two helpers cover cases when the user wants to cache a bunch of
>metadata fields to a certain structure and when the user just wants to
>query a specific metadata field on demand.  They are enough for KVM to
>use (and also should be enough for other potential users).
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/include/asm/tdx.h  | 22 ++++++++++++++++++++++
> arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++-----------------
> 2 files changed, 30 insertions(+), 17 deletions(-)
>
>diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
>index eba178996d84..709b9483f9e4 100644
>--- a/arch/x86/include/asm/tdx.h
>+++ b/arch/x86/include/asm/tdx.h
>@@ -116,6 +116,28 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
> int tdx_cpu_enable(void);
> int tdx_enable(void);
> const char *tdx_dump_mce_info(struct mce *m);
>+
>+struct tdx_metadata_field_mapping {
>+	u64 field_id;
>+	int offset;
>+	int size;
>+};
>+
>+#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
>+	{ .field_id = MD_FIELD_ID_##_field_id,		\
>+	  .offset   = offsetof(_struct, _member),	\
>+	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
>+
>+/*
>+ * Read multiple global metadata fields to a buffer of a structure
>+ * based on the "field ID -> structure member" mapping table.
>+ */
>+int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
>+			  int nr_fields, void *stbuf);
>+
>+/* Read a single global metadata field */
>+int tdx_sys_metadata_field_read(u64 field_id, u64 *data);
>+
> #else
> static inline void tdx_init(void) { }
> static inline int tdx_cpu_enable(void) { return -ENODEV; }
>diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>index a19adc898df6..dc21310776ab 100644
>--- a/arch/x86/virt/vmx/tdx/tdx.c
>+++ b/arch/x86/virt/vmx/tdx/tdx.c
>@@ -251,7 +251,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
> 	return ret;
> }
>
>-static int read_sys_metadata_field(u64 field_id, u64 *data)
>+int tdx_sys_metadata_field_read(u64 field_id, u64 *data)
> {
> 	struct tdx_module_args args = {};
> 	int ret;
>@@ -270,6 +270,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>
> 	return 0;
> }
>+EXPORT_SYMBOL_GPL(tdx_sys_metadata_field_read);
>
> /* Return the metadata field element size in bytes */
> static int get_metadata_field_bytes(u64 field_id)
>@@ -295,7 +296,7 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
> 	if (WARN_ON_ONCE(get_metadata_field_bytes(field_id) != bytes))
> 		return -EINVAL;
>
>-	ret = read_sys_metadata_field(field_id, &tmp);
>+	ret = tdx_sys_metadata_field_read(field_id, &tmp);
> 	if (ret)
> 		return ret;
>
>@@ -304,19 +305,8 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
> 	return 0;
> }
>
>-struct field_mapping {
>-	u64 field_id;
>-	int offset;
>-	int size;
>-};
>-
>-#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
>-	{ .field_id = MD_FIELD_ID_##_field_id,		\
>-	  .offset   = offsetof(_struct, _member),	\
>-	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
>-
>-static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
>-			     void *stbuf)
>+int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
>+			  int nr_fields, void *stbuf)
> {
> 	int i, ret;
>
>@@ -331,6 +321,7 @@ static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
>
> 	return 0;
> }
>+EXPORT_SYMBOL_GPL(tdx_sys_metadata_read);
Hi Kai,

The two helpers can potentially be used by TD guests, as you mentioned.
It's a good idea to declare it in the header asm/tdx.h.

However, the function cannot be compiled if its definition remains in the
vmx/tdx/tdx.c file while disabling the CONFIG_TDX_HOST.

It would be better to move the definition to a shared location,
allowing the host and guest to share the same code.

Thanks
   --Sun, Yi


