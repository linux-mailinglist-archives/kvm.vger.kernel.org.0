Return-Path: <kvm+bounces-31614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 737A89C5720
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 12:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CA331F223A2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 11:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630EE1CD213;
	Tue, 12 Nov 2024 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NW0Cnhro"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E7F1BCA11;
	Tue, 12 Nov 2024 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731412736; cv=none; b=Qbo6G8k8npuF2xUOrDVU3Do+0cMtvGbQKF6OlBiovuSk7vzDY894PqDHGvVukeMT1GtlOA6GCBswk5L4Lg/24ilRRGBSyY5AuKovfG6BJoI9xvNNoSy4ZeZr9QpSm5cmyjTDCt0qjJlv8xuYuA+StGj6JRnJ3IcpW4HLiMJ8QpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731412736; c=relaxed/simple;
	bh=TUNmIAPn6+pKk5nzKQZ1OjgyCLxgxK7kaAVkQhXghrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHCDUQlNftbl/GL43xtYnfDSKYlmra4qSAF6j9K32//FRfl1SaBEg8bCtwE6hkJ6KGZqGsHywR07PVWToWCjza0oKrE/YWffO5/Lb4N6gkpLGKcc8Pbx3v3u9yDABdJZtbjnm4iy0hWnYQ9qHR07FQMJB+KOA62WeshA7Ula7MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NW0Cnhro; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3B28440E0219;
	Tue, 12 Nov 2024 11:58:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id K0mb3qn6eQ2E; Tue, 12 Nov 2024 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731412724; bh=pUkUnh5KepZX+fycGuZ0Jah4PiIPhoLoA1x5Uf4hXQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NW0CnhroUylwEPqyeQXOXk8N75MoxkYs5HX51aINwz3/N/Sc7QvF6fhvnOXKzoZRf
	 xHSLAW//IkLuS48CV8o11VTS6McVekMZAMwpamDs4YVLPhQDNmf64ZEaxxus0GGAh1
	 qSm0zujyK+5Aa3NjLrR3izo2/Fax5WjEvrBPKKyOJlpU30V3d45abZlL1dz5IgzPRx
	 GXYmy23QGxIHNOEK1PhwMAAO87iixqGjQNabWLH+NZbhIaRq+QqJpHr/7VqLypeI2m
	 ScUs8D9oodqzw53BS8LofG4633bSXF0nx64RDWGHc8Ia/zrNSdtEYHGYo8tFxRfGdh
	 4FspwmabVVWm0tBOtytantZjshy+wSmwCh5zk9kS0vs3PHtgq0xZk6hPsVqUN8TGMe
	 Ehd0UMrKfLP0EW6Kvj5FMTGqr49PWzuOI+XzN4N4RnPJ9CSv9Kx0lE5HavG8Oet23k
	 40HNeBNrEPuBeq0ifurBg2yRkYUwIjnx1YzxQ6dFQr47sTeKYNVE08/QY6aZWncPwu
	 LSFoR6is7HANMt4McbKCzKnrpbjq0T2OSV79cnZD4yOSD8iw7LludXMY0cYHfsbLr2
	 oLGPqeuAjK/Vnit3Shi4DXwmAxSwAC2+k9HHEtponuRrHhnTgrI+L79/9oN18K7WEk
	 B77eLJ7GBNfM7YBGD/6uFgVc=
Received: from zn.tnic (p200300ea973a31e1329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31e1:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 42A8D40E019C;
	Tue, 12 Nov 2024 11:58:19 +0000 (UTC)
Date: Tue, 12 Nov 2024 12:58:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241112014644.3p2a6te3sbh5x55c@jpoimboe>

On Mon, Nov 11, 2024 at 05:46:44PM -0800, Josh Poimboeuf wrote:
> Subject: [PATCH] x86/bugs: Update insanely long comment about RSB attacks

Why don't you stick this insanely long comment in
Documentation/admin-guide/hw-vuln/ while at it?

Its place is hardly in the code. You can point to it from the code tho...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

