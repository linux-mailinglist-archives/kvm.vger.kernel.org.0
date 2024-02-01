Return-Path: <kvm+bounces-7769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EF18462BC
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 22:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945F628B240
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 21:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640113F8C2;
	Thu,  1 Feb 2024 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GgqqI8/0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACFC12FB1B;
	Thu,  1 Feb 2024 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706823746; cv=none; b=YTNEOz+n1n0ljXCNHQ1zMdu5IPA4vb1h69MoHAEeqdhoI/ND/a/IY5Q2y/q/AALKKsN5ieK3aMFGe4S2Vfob3cRDTsEHwqzhFZimDV0lYkutE4hdgK7lFRHKvz10tmT4hARV8Ei2kwnbPQCNXTajiAyaoyssuGD+pDwVWo+OnJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706823746; c=relaxed/simple;
	bh=nN9YDWe6TKaNCrt8BD7k4DNnEmY12vw+Jb2a131tNmI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=CDTL+kF87IFP9+nPLxVVQYbdlicCErYmw579DKFxaizhj2rvaHOmHAn47RYzE+FojibM1L+wZj85sY1Ga2uaZnZAgZU5iaNdO+4qyrZ4eUZYbgVW/Pp1sBLRv9/s8oIqYo63HydgBjmbS4X5rgAxBa/4ZmtkHoI5c9AKB3mkNxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GgqqI8/0; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706823744; x=1738359744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=nN9YDWe6TKaNCrt8BD7k4DNnEmY12vw+Jb2a131tNmI=;
  b=GgqqI8/0snRRkT8Kr+JDWcib7YDbk8NyXx6UVoCJpqWwAbbSt1C+gOIV
   OC5OBoYudAzT/0hJEnfQ66RBeIjQV1XKsrln2EETra2IOyrQvFHZSDhH3
   oL6TpobIcjA/xsRGS74X/BseFkM/hRMC4kKkZDhvABk2kc1bIOtkOThkN
   cC+qovCqduDkO/jun5AHiATvXpevM0bgZnJVmfFDqtVHTLnaUHAox6nBW
   WjNSioxKIux/sEK5uV5+pqEkVbbcoNK4iNJTWKTDyCkEqqfftUOperk1C
   Gi8jgBVRJGKIthZ1t7wZCCErb1AavIE0jybfRqbxLC3s/BAlE0pM6wKBs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="435166721"
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="435166721"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 13:42:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="199838"
Received: from arbartma-mobl.amr.corp.intel.com (HELO [10.212.155.10]) ([10.212.155.10])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 13:42:16 -0800
Content-Type: multipart/mixed; boundary="------------nVmn2Eub8azicNF5kfaahIr5"
Message-ID: <897a31a7-7ec3-41b7-867b-0229c0addf5f@intel.com>
Date: Thu, 1 Feb 2024 13:42:15 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
 x86@kernel.org, stable@vger.kernel.org
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
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
In-Reply-To: <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>

This is a multi-part message in MIME format.
--------------nVmn2Eub8azicNF5kfaahIr5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/1/24 10:29, Dave Hansen wrote:
> Could we instead do something more like the (completely untested)
> attached patch?

... actually attaching it here
--------------nVmn2Eub8azicNF5kfaahIr5
Content-Type: text/x-patch; charset=UTF-8; name="enc_phys_bits.patch"
Content-Disposition: attachment; filename="enc_phys_bits.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgKaW5kZXggMjY2MjBkNzY0MmE5Li40MTVhZTQ0
M2VmNzkgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCisr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCkBAIC0xMTksNiArMTE5LDcg
QEAgc3RydWN0IGNwdWluZm9feDg2IHsKICNlbmRpZgogCV9fdTgJCQl4ODZfdmlydF9iaXRz
OwogCV9fdTgJCQl4ODZfcGh5c19iaXRzOworCV9fdTgJCQllbmNfcGh5c19iaXRzOwogCS8q
IENQVUlEIHJldHVybmVkIGNvcmUgaWQgYml0czogKi8KIAlfX3U4CQkJeDg2X2NvcmVpZF9i
aXRzOwogCS8qIE1heCBleHRlbmRlZCBDUFVJRCBmdW5jdGlvbiBzdXBwb3J0ZWQ6ICovCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jIGIvYXJjaC94ODYva2VybmVs
L2NwdS9hbWQuYwppbmRleCBmM2FiY2EzMzQxOTkuLjQwZmM0NGRmYTdhNCAxMDA2NDQKLS0t
IGEvYXJjaC94ODYva2VybmVsL2NwdS9hbWQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2FtZC5jCkBAIC02MTgsMTEgKzYxOCwxMyBAQCBzdGF0aWMgdm9pZCBlYXJseV9kZXRlY3Rf
bWVtX2VuY3J5cHQoc3RydWN0IGNwdWluZm9feDg2ICpjKQogCQkJZ290byBjbGVhcl9hbGw7
CiAKIAkJLyoKLQkJICogQWx3YXlzIGFkanVzdCBwaHlzaWNhbCBhZGRyZXNzIGJpdHMuIEV2
ZW4gdGhvdWdoIHRoaXMKLQkJICogd2lsbCBiZSBhIHZhbHVlIGFib3ZlIDMyLWJpdHMgdGhp
cyBpcyBzdGlsbCBkb25lIGZvcgotCQkgKiBDT05GSUdfWDg2XzMyIHNvIHRoYXQgYWNjdXJh
dGUgdmFsdWVzIGFyZSByZXBvcnRlZC4KKwkJICogUmVjb3JkIHRoZSBudW1iZXIgb2YgcGh5
c2ljYWwgYWRkcmVzcyBiaXRzIHRoYXQKKwkJICogaGF2ZSBiZWVuIHJlcHVycG9zZWQgZm9y
IG1lbW9yeSBlbmNyeXB0aW9uLiAgRG8KKwkJICogdGhpcyBldmVuIG9uIENPTkZJR19YODZf
MzIgY29uZmlncyB0aGF0IGRvIGNhbgorCQkgKiBub3Qgc3VwcG9ydCBtZW1vcnkgZW5jcnlw
dGlvbiBzbyBpdCBpcyBzdGlsbAorCQkgKiByZXBvcnRlZCBhY2N1cmF0ZWx5LgogCQkgKi8K
LQkJYy0+eDg2X3BoeXNfYml0cyAtPSAoY3B1aWRfZWJ4KDB4ODAwMDAwMWYpID4+IDYpICYg
MHgzZjsKKwkJYy0+ZW5jX3BoeXNfYml0cyA9IChjcHVpZF9lYngoMHg4MDAwMDAxZikgPj4g
NikgJiAweDNmOwogCiAJCWlmIChJU19FTkFCTEVEKENPTkZJR19YODZfMzIpKQogCQkJZ290
byBjbGVhcl9hbGw7CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5j
IGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYwppbmRleCAwYjk3YmNkZTcwYzYuLmI5
OThhZTdmYmJmYiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYwor
KysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jCkBAIC0xMDk4LDYgKzEwOTgsMTAg
QEAgdm9pZCBnZXRfY3B1X2FkZHJlc3Nfc2l6ZXMoc3RydWN0IGNwdWluZm9feDg2ICpjKQog
CXUzMiBlYXgsIGVieCwgZWN4LCBlZHg7CiAJYm9vbCB2cF9iaXRzX2Zyb21fY3B1aWQgPSB0
cnVlOwogCisJV0FSTl9PTihjLT54ODZfY2xmbHVzaF9zaXplIHx8CisJCWMtPng4Nl9waHlz
X2JpdHMgICAgfHwKKwkJYy0+eDg2X3ZpcnRfYml0cyk7CisKIAlpZiAoIWNwdV9oYXMoYywg
WDg2X0ZFQVRVUkVfQ1BVSUQpIHx8CiAJICAgIChjLT5leHRlbmRlZF9jcHVpZF9sZXZlbCA8
IDB4ODAwMDAwMDgpKQogCQl2cF9iaXRzX2Zyb21fY3B1aWQgPSBmYWxzZTsKQEAgLTExMjIs
NiArMTEyNiw4IEBAIHZvaWQgZ2V0X2NwdV9hZGRyZXNzX3NpemVzKHN0cnVjdCBjcHVpbmZv
X3g4NiAqYykKIAkJCQljLT54ODZfcGh5c19iaXRzID0gMzY7CiAJCX0KIAl9CisJYy0+eDg2
X3BoeXNfYml0cyAtPSBjLT5lbmNfcGh5c19iaXRzOworCiAJYy0+eDg2X2NhY2hlX2JpdHMg
PSBjLT54ODZfcGh5c19iaXRzOwogCWMtPng4Nl9jYWNoZV9hbGlnbm1lbnQgPSBjLT54ODZf
Y2xmbHVzaF9zaXplOwogfQo=

--------------nVmn2Eub8azicNF5kfaahIr5--

