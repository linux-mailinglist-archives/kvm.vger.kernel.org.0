Return-Path: <kvm+bounces-5422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3020A821DAD
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 15:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44C341C22309
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 14:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DD612E5D;
	Tue,  2 Jan 2024 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fpZGWbVe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C1712E5E;
	Tue,  2 Jan 2024 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7F57A40E0197;
	Tue,  2 Jan 2024 14:31:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jqDK2FPNrzIb; Tue,  2 Jan 2024 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704205882; bh=3RAVNM7LYaoLfzaXssXlRtBXH/zpslXjygklhi3m5ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fpZGWbVemrzkfBr14FKIUKe0YrNibM1g2Dp/r7Dh4PSJHoN72qdY75JFcRFMgJUk+
	 ThO/GAn6S8t6qiGapDNjq6+V6LApHghQYnY9/f1DDpwdXeLpEJ9QgMgTiZdnEXFfoE
	 sgxyTakmuxY8nKEEzwOd+p9yNiSyAXaaEMXaffexrsvXvznhr7/W8zMTlzXoRs02nQ
	 296fp6dbsk43cr/3+DE5z++eC2RyY73USRx86Q6WP/h/sotEtQsXlvvZRvnyUa54V6
	 TeM8/cnRVqJAwDGJYO/4C4+csL/SL41YnfgBRppkAY6vyJEbytCYrG7owiG5J/xFUR
	 hhurvQeiaKXshQh7FfNc2pQWNloWf74yU0gKhKfkqX8TT69ry0h55L3fQ2UnkgVTXd
	 u4U6uO4VpI/RNRe2dq/0HWOPmrYh+8gvIoLUxnvK1bqQviukgWChzQ4WPR0btY8VbU
	 ZoEfUJFQpmOiHncXWwLnODEhgXW78QnS9AMAZTQTIHVE8GCwf4v7ENvyIKNh4AuCP/
	 6EQgytnms6kPduZTCsilXmNUrsRZRnSGHAAGr/YZJzb8MCRlg4buKKn5WiZzgVClo2
	 C8p9xxRsPrPd4TlEcaq3U6BVr7fFW5Fm5csDJoUApsMZ3Ftle4f7AiJjn8TcXgCxrc
	 A7gKpmmmtennf/PjkFjHHGls=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 757F440E0193;
	Tue,  2 Jan 2024 14:31:10 +0000 (UTC)
Date: Tue, 2 Jan 2024 15:31:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Fix SEV check in sev_map_percpu_data()
Message-ID: <20240102143104.GCZZQeKLNY1NJ78uVR@fat_crate.local>
References: <20240102133747.27053-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240102133747.27053-1-kirill.shutemov@linux.intel.com>

On Tue, Jan 02, 2024 at 04:37:47PM +0300, Kirill A. Shutemov wrote:
> The function sev_map_percpu_data() checks if it is running on an SEV
> platform by checking the CC_ATTR_GUEST_MEM_ENCRYPT attribute. However,
> this attribute is also defined for TDX.
> 
> To avoid false positives, add a cc_vendor check.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with cc_platform_has()")
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

