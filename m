Return-Path: <kvm+bounces-70774-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEaiCoVui2lhUQAAu9opvQ
	(envelope-from <kvm+bounces-70774-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:44:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7861511E0D5
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F73D30480E8
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0E138A9AD;
	Tue, 10 Feb 2026 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJp0oHk4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178321DF755;
	Tue, 10 Feb 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770745462; cv=none; b=pRCHNsBrVx6scTB7Ij8lpQNDMwET6L56qEh6+oRTmw8v+4wqt+obHiiQ9UVyrc6MpJrwTu13RzJtxHfRpJw5slx8fgW3jw6Du1J0AzCcU4vdBS9mSneqawY2tCfAPIemyNebnFnBum8LsMghl4ayEsow9IpY+nWJBB7qriMqCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770745462; c=relaxed/simple;
	bh=GBfp7VAcsGihaIW8bLJChMlUnw0f/xZsxn42XWl3Brg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1U60lahi9m5wYBpq7UUS3SLQNWxQr++bAdAH11672VLdRDFV1PGhyrn/M63kf7fpyUOFfReH4pf3qoZNoDpaWhmhhA26S18AGCoO5F6w/OFTQyzRzHhTfFdBRTLwIlVtFD9T6yjb2RxvpMSzKBbCAbAES5S5tdoW+feT+9RoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJp0oHk4; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770745461; x=1802281461;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GBfp7VAcsGihaIW8bLJChMlUnw0f/xZsxn42XWl3Brg=;
  b=GJp0oHk4mWhCByrE5nmd2piN6xH9r5W7/COOJ69U+varwtR5FjxKrEmR
   mom1kNOzhfcrm2wLDtree2JrgnqEgr/SqEWWGWNLseal2AGxzO8gdip2L
   HIf7z9g4qvNwNQ/rjDT43HEKFhaMS6oGg2JEtafgPw8eJl63I18kikjlB
   Rit5LlkKXO7bfkqnVBpzNMJfrbiapTb99BS6qFLfg7ZacpYdHSBgHjc7w
   MEbG9YPF4tEgDUoiKXTLOS3GnFrNaKl9B4UmFQoOimBGRh7I8dhMm6MeQ
   OHYJKRFICGqLwH1Gf5Cr1sAE2ZENj94Db0SA/7DAuuVkkeJAFFFOeaXX7
   g==;
X-CSE-ConnectionGUID: lNAatpKbQGiUh9DTSCNVOQ==
X-CSE-MsgGUID: QjEyPdf3RmqE1VKNXTDI0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="82203613"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82203613"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 09:44:20 -0800
X-CSE-ConnectionGUID: CNwJLfqhQmSfL/wFmjKzww==
X-CSE-MsgGUID: xqCxx7TZQY6wgvCnr3+w1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="249628945"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.108.43]) ([10.125.108.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 09:44:19 -0800
Message-ID: <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
Date: Tue, 10 Feb 2026 09:44:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Kiryl Shutsemau <kas@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao
 <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-17-seanjc@google.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <20260129011517.3545883-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70774-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 7861511E0D5
X-Rspamd-Action: no action

On 1/28/26 17:14, Sean Christopherson wrote:
> +static void tdx_pamt_put(struct page *page)
> +{
> +	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return;
> +
> +	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		/*
> +		 * If the there are more than 1 references on the pamt page,
> +		 * don't remove it yet. Just decrement the refcount.
> +		 */
> +		if (atomic_read(pamt_refcount) > 1) {
> +			atomic_dec(pamt_refcount);
> +			return;
> +		}
> +
> +		/* Try to remove the pamt page and take the refcount 1->0. */
> +		tdx_status = tdh_phymem_pamt_remove(page, pamt_pa_array);
> +
> +		/*
> +		 * Don't free pamt_pa_array as it could hold garbage when
> +		 * tdh_phymem_pamt_remove() fails.  Don't panic/BUG_ON(), as
> +		 * there is no risk of data corruption, but do yell loudly as
> +		 * failure indicates a kernel bug, memory is being leaked, and
> +		 * the dangling PAMT entry may cause future operations to fail.
> +		 */
> +		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status)))
> +			return;
> +
> +		atomic_dec(pamt_refcount);
> +	}
> +
> +	/*
> +	 * pamt_pa_array is populated up to tdx_dpamt_entry_pages() by the TDX
> +	 * module with pages, or remains zero inited. free_pamt_array() can
> +	 * handle either case. Just pass it unconditionally.
> +	 */
> +	free_pamt_array(pamt_pa_array);
> +}

This looks funky.

Right now, this is:

	spin_lock(pamt_lock)
	atomic_inc/dec(fine-grained-refcount)
	tdcall_blah_blah()
	spin_unlock(pamt_lock)

Where it *always* acquires the global lock when DPAMT is supported.
Couldn't we optimize it so that it only acquires it when it has to keep
the refcount stable at zero?

Roughly:

	slow_path = atomic_dec_and_lock(fine-grained-refcount,
					pamt_lock)
	if (!slow_path)
		goto out;

	// fine-grained-refcount==0 and must stay that way with
	// pamt_lock held. Remove the DPAMT pages:
	tdh_phymem_pamt_remove(page, pamt_pa_array)
out:	
	spin_unlock(pamt_lock)

On the acquire side, you do:

	fast_path = atomic_inc_not_zero(fine-grained-refcount)
	if (fast_path)
		return;

	// slow path:
	spin_lock(pamt_lock)

	// Was the race lost with another 0=>1 increment?
	if (atomic_read(fine-grained-refcount) > 0)
		goto out_inc

	tdh_phymem_pamt_add(page, pamt_pa_array)
	// Inc after the TDCALL so another thread won't race ahead of us
	// and try to use a non-existent PAMT entry
out_inc:
	atomic_inc(fine-grained-refcount)
	spin_unlock(pamt_lock)

Then, at least only the 0=>1 and 1=>0 transitions need the global lock.
The fast paths only touch the refcount which isn't shared nearly as much
as the global lock.

BTW, this probably still needs to be spin_lock_irq(), not what I wrote
above, but that's not a big deal to add.

I've stared at this for a bit and don't see any holes. Does anyone else
see any?

