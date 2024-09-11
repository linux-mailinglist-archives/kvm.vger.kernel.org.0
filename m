Return-Path: <kvm+bounces-26500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D13C89750DE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E439283233
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155B4188A06;
	Wed, 11 Sep 2024 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="h3P6VY4f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E11186617;
	Wed, 11 Sep 2024 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726054397; cv=none; b=e+peuCsniDfi9rpJNO0ybgIGfSC8R1KDeMfM3KLkO1NbjCv/nvqKz06tzyY/kKPZSMfK4Smxu3lXy7UF8bUDJLwFQwc9RRgojlPljiCDGBkGR4G2X3vCvgruE4+JGsFmDYTfDHL5TEt1ueAXpjH91WrUFcvXXNc/a3URT6ATfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726054397; c=relaxed/simple;
	bh=1+cazK5r20icjJcjvA5lxK9A8++aZTPBcRzHZht9EzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RM4AePho6lBu2FHVdWs/G78MbOSNzUvG3O5+mNArZSq3ZUG5gpTclL6XmRerijSt2AQngmeyiFf/jS2wFEAZH9nRjNMhDRH2+JrnLrn5o3W+Xx+6qsEQaNY8ktx9B/DkFgj6wFvsdZ7tU95dNw+ZoMZFxaIojl4OSopai+K0sEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=h3P6VY4f; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726054396; x=1757590396;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=1+cazK5r20icjJcjvA5lxK9A8++aZTPBcRzHZht9EzM=;
  b=h3P6VY4fHXpusKZywohzYSSYQy9BS4N/5vx5FbJsDg7VzTFzGkNt/xRW
   X1RoXKl9b34Rd6ltXhc3EQPnolgouBxKMgSPhJvtMAkwX0Yeh7v0WK9wU
   0wQ6AaOjIlnrbeSqITJuSIgI7g7LuuKnaCTXpcow4EdocqYmwXr6zkyBr
   U=;
X-IronPort-AV: E=Sophos;i="6.10,219,1719878400"; 
   d="scan'208";a="758821177"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 11:31:48 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:55361]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.162:2525] with esmtp (Farcaster)
 id 0ac9aa66-a400-4d40-aecd-781ffcb5e148; Wed, 11 Sep 2024 11:31:46 +0000 (UTC)
X-Farcaster-Flow-ID: 0ac9aa66-a400-4d40-aecd-781ffcb5e148
Received: from EX19D041EUB003.ant.amazon.com (10.252.61.118) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 11:31:42 +0000
Received: from [192.168.27.184] (10.1.212.24) by EX19D041EUB003.ant.amazon.com
 (10.252.61.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 11 Sep 2024
 11:31:40 +0000
Message-ID: <07b0b475-9f45-4476-a63d-291f940f9b4d@amazon.de>
Date: Wed, 11 Sep 2024 13:31:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Yang Weijiang <weijiang.yang@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240509075423.156858-1-weijiang.yang@intel.com>
From: Nikolas Wipper <nikwip@amazon.de>
Content-Language: en-US
In-Reply-To: <20240509075423.156858-1-weijiang.yang@intel.com>
X-ClientProxiedBy: EX19D044UWA004.ant.amazon.com (10.13.139.7) To
 EX19D041EUB003.ant.amazon.com (10.252.61.118)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1IE1heSAgOSwgMjAyNCBhdCAwOTo1NCBBTSBVVEMrMDIwMCwgWWFuZyBXZWlqaWFuZyB3
cm90ZToKPiBFbmFibGUgS1ZNX3tHLFN9RVRfT05FX1JFRyB1QVBJcyBzbyB0aGF0IHVzZXJzcGFj
ZSBjYW4gYWNjZXNzIEhXIE1TUiBvcgo+IEtWTSBzeW50aGV0aWMgTVNSIHRocm91Z2h0IGl0Lgo+
IAo+IEluIENFVCBLVk0gc2VyaWVzIFsqXSwgS1ZNICJzdGVhbHMiIGFuIE1TUiBmcm9tIFBWIE1T
UiBzcGFjZSBhbmQgYWNjZXNzCj4gaXQgdmlhIEtWTV97RyxTfUVUX01TUnMgdUFQSXMsIGJ1dCB0
aGUgYXBwcm9hY2ggcG9sbHV0ZXMgUFYgTVNSIHNwYWNlCj4gYW5kIGhpZGVzIHRoZSBkaWZmZXJl
bmNlIG9mIHN5bnRoZXRpYyBNU1JzIGFuZCBub3JtYWwgSFcgZGVmaW5lZCBNU1JzLgo+IAo+IE5v
dyBjYXJ2ZSBvdXQgYSBzZXBhcmF0ZSByb29tIGluIEtWTS1jdXN0b21pemVkIE1TUiBhZGRyZXNz
IHNwYWNlIGZvcgo+IHN5bnRoZXRpYyBNU1JzLiBUaGUgc3ludGhldGljIE1TUnMgYXJlIG5vdCBl
eHBvc2VkIHRvIHVzZXJzcGFjZSB2aWEKPiBLVk1fR0VUX01TUl9JTkRFWF9MSVNULCBpbnN0ZWFk
IHVzZXJzcGFjZSBjb21wbGllcyB3aXRoIEtWTSdzIHNldHVwIGFuZAo+IGNvbXBvc2VzIHRoZSB1
QVBJIHBhcmFtcy4gS1ZNIHN5bnRoZXRpYyBNU1IgaW5kaWNlcyBzdGFydCBmcm9tIDAgYW5kCj4g
aW5jcmVhc2UgbGluZWFybHkuIFVzZXJzcGFjZSBjYWxsZXIgc2hvdWxkIHRhZyBNU1IgdHlwZSBj
b3JyZWN0bHkgaW4KPiBvcmRlciB0byBhY2Nlc3MgaW50ZW5kZWQgSFcgb3Igc3ludGhldGljIE1T
Ui4KPiAKPiBbKl06Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjQwMjE5MDc0NzMz
LjEyMjA4MC0xOC13ZWlqaWFuZy55YW5nQGludGVsLmNvbS8KPiAKPiBTdWdnZXN0ZWQtYnk6IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFlh
bmcgV2VpamlhbmcgPHdlaWppYW5nLnlhbmdAaW50ZWwuY29tPgoKSGF2aW5nIHRoaXMgQVBJLCBh
bmQgc3BlY2lmaWNhbGx5IGhhdmluZyBhIGRlZmluaXRlIGt2bV9vbmVfcmVnIHN0cnVjdHVyZSAK
Zm9yIHg4NiByZWdpc3RlcnMsIHdvdWxkIGJlIGludGVyZXN0aW5nIGZvciByZWdpc3RlciBwaW5u
aW5nL2ludGVyY2VwdHMuCldpdGggb25lX3JlZyBmb3IgeDg2IHRoZSBBUEkgY291bGQgYmUgcGxh
dGZvcm0gYWdub3N0aWMgYW5kIHBvc3NpYmxlIGV2ZW4KcmVwbGFjZSBNU1IgZmlsdGVycyBmb3Ig
eDg2LiBJIGRvIGhhdmUgYSBjb3VwbGUgb2YgcXVlc3Rpb25zIGFib3V0IHRoZXNlCnBhdGNoZXMu
Cgo+IC0tLQo+ICBhcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oIHwgMTAgKysrKysrCj4g
IGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgfCA2MiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKPiAgMiBmaWxlcyBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspCj4gCj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggYi9hcmNoL3g4Ni9p
bmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4gaW5kZXggZWYxMWFhNGNhYjQyLi5jYTJhNDdhODVmYTEg
MTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+ICsrKyBiL2Fy
Y2gveDg2L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPiBAQCAtNDEwLDYgKzQxMCwxNiBAQCBzdHJ1
Y3Qga3ZtX3hjcnMgewo+ICAJX191NjQgcGFkZGluZ1sxNl07Cj4gIH07Cj4gIAo+ICsjZGVmaW5l
IEtWTV9YODZfUkVHX01TUgkJCSgxIDw8IDIpCj4gKyNkZWZpbmUgS1ZNX1g4Nl9SRUdfU1lOVEhF
VElDX01TUgkoMSA8PCAzKQoKV2h5IGlzIHRoaXMgYSBiaXRmaWVsZD8gQXMgb3Bwb3NlZCB0byBq
dXN0IGNvdW50aW5nIHVwPwoKI2RlZmluZSBLVk1fWDg2X1JFR19NU1IJCQkyCiNkZWZpbmUgS1ZN
X1g4Nl9SRUdfU1lOVEhFVElDX01TUgkzCgo+ICsKPiArc3RydWN0IGt2bV94ODZfcmVnX2lkIHsK
PiArCV9fdTMyIGluZGV4Owo+ICsJX191OCB0eXBlOwo+ICsJX191OCByc3ZkOwo+ICsJX191MTYg
cnN2ZDE2Owo+ICt9OwoKVGhpcyBzdHJ1Y3QgaXMgb3Bwb3NpdGUgdG8gd2hhdCBvdGhlciBhcmNo
aXRlY3R1cmVzIGRvLCB3aGVyZSB0aGV5IGhhdmUKYW4gYXJjaGl0ZWN0dXJlIElEIGluIHRoZSB1
cHBlciAzMiBiaXRzLCBhbmQgdGhlIGxvd2VyIDMyIGJpdHMgYWN0dWFsbHkKaWRlbnRpZnkgdGhl
IHJlZ2lzdGVyLiBUaGlzIHdvdWxkIHByb2JhYmx5IG1ha2Ugc2Vuc2UgZm9yIHg4NiB0b28sIHRv
CmF2b2lkIGNvbmZsaWN0cyB3aXRoIG90aGVyIElEcyAoSSB0aGluayBNSVBTIGNvcmUgcmVnaXN0
ZXJzIGNhbiBoYXZlIElEcwp3aXRoIHRoZSBsb3dlciAzMiBiaXRzIGFsbCB6ZXJvKSBzbyB0aGF0
IHRoZSBJRHMgYXJlIGFjdHVhbGx5IHVuaXF1ZSwKcmlnaHQ/CgpCZXN0LApOaWtvbGFzCgoKCkFt
YXpvbiBXZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vu
c3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFl
Z2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVu
YnVyZyB1bnRlciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1
OTcK


