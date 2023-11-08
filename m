Return-Path: <kvm+bounces-1196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC737E5625
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AA81B20EAC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2C417750;
	Wed,  8 Nov 2023 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="cNsGUBT4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAEF15AE0;
	Wed,  8 Nov 2023 12:22:11 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852E1BCC;
	Wed,  8 Nov 2023 04:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699446132; x=1730982132;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2w92xJO7yQtloooQVQG0sgNUimuLo8mk6LsFIZtZ3ZE=;
  b=cNsGUBT4Dv28mNlrqID5F9GS4VE3PcRuT18lIjiIMMB1rju9uB35JYZ2
   7ttDtbD51BDcB1pRDwmQyNEkVefHptja0hUd5K2puIo0kfiZBPKARuRn1
   TowcRM1IMwQJaI9adBwP/E8Al3DMEK3dTcFj/txH+Uf6E9t5o4YZvbZ17
   g=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164970657"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:22:00 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id B161B87A25;
	Wed,  8 Nov 2023 12:21:57 +0000 (UTC)
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:61631]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.60:2525] with esmtp (Farcaster)
 id 5bb84aa9-ab3c-40d4-8eb5-0b6fee687587; Wed, 8 Nov 2023 12:21:57 +0000 (UTC)
X-Farcaster-Flow-ID: 5bb84aa9-ab3c-40d4-8eb5-0b6fee687587
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:21:52 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:21:49 +0000
Message-ID: <2a8fddbb-d1d9-4639-a79d-0d32c06d309e@amazon.com>
Date: Wed, 8 Nov 2023 13:21:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 09/33] KVM: x86: hyper-v: Introduce per-VTL vcpu helpers
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-10-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-10-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE3LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IEludHJv
ZHVjZSB0d28gaGVscGVyIGZ1bmN0aW9ucy4gVGhlIGZpcnN0IG9uZSBxdWVyaWVzIGEgdkNQVSdz
IFZUTAo+IGxldmVsLCB0aGUgc2Vjb25kIG9uZSwgZ2l2ZW4gYSBzdHJ1Y3Qga3ZtX3ZjcHUgYW5k
IFZUTCBwYWlyLCByZXR1cm5zIHRoZQo+IGNvcnJlc3BvbmRpbmcgJ3NpYmxpbmcnIHN0cnVjdCBr
dm1fdmNwdSBhdCB0aGUgcmlnaHQgVlRMLgo+Cj4gV2Uga2VlcCB0cmFjayBvZiBlYWNoIFZUTCdz
IHN0YXRlIGJ5IGhhdmluZyBhIGRpc3RpbmN0IHN0cnVjdCBrdm1fdnBjdQo+IGZvciBlYWNoIGxl
dmVsLiBWVEwtdkNQVXMgdGhhdCBiZWxvbmcgdG8gdGhlIHNhbWUgZ3Vlc3QgQ1BVIHNoYXJlIHRo
ZQo+IHNhbWUgcGh5c2ljYWwgQVBJQyBpZCwgYnV0IGJlbG9uZyB0byBkaWZmZXJlbnQgQVBJQyBn
cm91cHMgd2hlcmUgdGhlCj4gYXBpYyBncm91cCByZXByZXNlbnRzIHRoZSB2Q1BVJ3MgVlRMLgo+
Cj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBTYWVueiBKdWxpZW5uZSA8bnNhZW56QGFtYXpvbi5j
b20+Cj4gLS0tCj4gICBhcmNoL3g4Ni9rdm0vaHlwZXJ2LmggfCAxOCArKysrKysrKysrKysrKysr
KysKPiAgIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspCj4KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL2h5cGVydi5oIGIvYXJjaC94ODYva3ZtL2h5cGVydi5oCj4gaW5kZXggMmJm
ZWQ2OWJhMGRiLi41NDMzMTA3ZTdjYzggMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYva3ZtL2h5cGVy
di5oCj4gKysrIGIvYXJjaC94ODYva3ZtL2h5cGVydi5oCj4gQEAgLTIzLDYgKzIzLDcgQEAKPiAg
IAo+ICAgI2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+Cj4gICAjaW5jbHVkZSAieDg2LmgiCj4g
KyNpbmNsdWRlICJsYXBpYy5oIgo+ICAgCj4gICAvKiAiSHYjMSIgc2lnbmF0dXJlICovCj4gICAj
ZGVmaW5lIEhZUEVSVl9DUFVJRF9TSUdOQVRVUkVfRUFYIDB4MzEyMzc2NDgKPiBAQCAtODMsNiAr
ODQsMjMgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qga3ZtX2h2X3N5bmRiZyAqdG9faHZfc3luZGJn
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgIAlyZXR1cm4gJnZjcHUtPmt2bS0+YXJjaC5oeXBl
cnYuaHZfc3luZGJnOwo+ICAgfQo+ICAgCj4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IGt2bV92Y3B1
ICprdm1faHZfZ2V0X3Z0bF92Y3B1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IHZ0bCkKPiAr
ewo+ICsJc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+ICsJdTMyIHRhcmdldF9pZCA9IGt2
bV9hcGljX2lkKHZjcHUpOwo+ICsKPiArCWt2bV9hcGljX2lkX3NldF9ncm91cChrdm0sIHZ0bCwg
JnRhcmdldF9pZCk7Cj4gKwlpZiAodmNwdS0+dmNwdV9pZCA9PSB0YXJnZXRfaWQpCj4gKwkJcmV0
dXJuIHZjcHU7Cj4gKwo+ICsJcmV0dXJuIGt2bV9nZXRfdmNwdV9ieV9pZChrdm0sIHRhcmdldF9p
ZCk7Cj4gK30KPiArCj4gK3N0YXRpYyBpbmxpbmUgdTgga3ZtX2h2X2dldF9hY3RpdmVfdnRsKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiArewo+ICsJcmV0dXJuIGt2bV9hcGljX2dyb3VwKHZjcHUp
OwoKClNob3VsZG4ndCB0aGlzIGNoZWNrIHdoZXRoZXIgVlRMIGlzIGFjdGl2ZT8gSWYgc29tZW9u
ZSB3YW50cyB0byB1c2UgQVBJQyAKZ3JvdXBzIGZvciBhIGRpZmZlcmVudCBwdXJwb3NlIGluIHRo
ZSBmdXR1cmUsIHRoZXknZCBzdWRkZW5seSBmaW5kIAp0aGVtc2VsdmVzIGluIFZUTCBjb2RlIHBh
dGhzIGluIG90aGVyIGNvZGUgKHN1Y2ggYXMgbWVtb3J5IHByb3RlY3Rpb25zKSwgbm8/CgpBbGV4
CgoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4g
MzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwg
Sm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcg
dW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


