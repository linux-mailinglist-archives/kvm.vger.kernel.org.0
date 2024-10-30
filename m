Return-Path: <kvm+bounces-30076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A27B39B6C45
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCEB01C2149B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E541CCEC3;
	Wed, 30 Oct 2024 18:41:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D21BD9E2
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730313694; cv=none; b=eiSu1O28H1qJ2+C/2lSNtAiHQHqNT2xLX0dUS00KoZFqjiaB7/4qGwjf5t8ecTHZMlRHxkoVgB6TqJ6wM8UXyOQwR+wu45TaUrhqV6ifFjNvpImY4sVbFx/T4LRMatCMCU8X4x5piJuc1FdXIOGOKoZ6aLeEXLoFvn0V/ft5EOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730313694; c=relaxed/simple;
	bh=blu1yH6Q9PmkJh61KDuPWDeZCU2aXR2x9rkNvTsX3Eo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WjcBaNb0X3YD1lvpLibCSbBPJObZeyG5Hj4lJtF00sqBah0lGncJlZV/m7AMnHWYkS8Tb7aRoTexRKqbeJ3+9++MLkfns601gd1YiTU7TucRyTi73n6EJWCMy0cdgH23wdIU3rF+XKahwZ8/T3l9rV0/+AcQjrudA42IkgdV+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XdwrG4Pf3zdkNq;
	Thu, 31 Oct 2024 02:38:54 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D8611800A7;
	Thu, 31 Oct 2024 02:41:28 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 kwepemd500012.china.huawei.com (7.221.188.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 31 Oct 2024 02:41:27 +0800
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 30 Oct 2024 19:41:25 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Joao Martins <joao.m.martins@oracle.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Kevin Tian
	<kevin.tian@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Yi Liu
	<yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen
	<nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Shameer Kolothum <shamiali2008@gmail.com>, "Wangzhou
 (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Thread-Index: AQHaBoE27yp8pPeR+EGuD7wYVnICbbKhnzUAgAAF84CAAAMMAIAAEkFAgAABLQCAACqr8A==
Date: Wed, 30 Oct 2024 18:41:25 +0000
Message-ID: <63d5a152dc1143e69d062dd854d4dd7b@huawei.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
	<CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
	<20241030153619.GG6956@nvidia.com>
	<9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
	<8401eb12c4a54826ba44e099a0ec67a9@huawei.com>
 <59d76989-3d7f-449d-8339-2edd31270b08@oracle.com>
In-Reply-To: <59d76989-3d7f-449d-8339-2edd31270b08@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9hbyBNYXJ0aW5zIDxq
b2FvLm0ubWFydGluc0BvcmFjbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMzAs
IDIwMjQgNDo1NyBQTQ0KPiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaQ0KPiA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsgSmFzb24gR3VudGhvcnBlDQo+IDxqZ2dA
bnZpZGlhLmNvbT47IFpoYW5nZmVpIEdhbyA8emhhbmdmZWkuZ2FvQGxpbmFyby5vcmc+DQo+IENj
OiBpb21tdUBsaXN0cy5saW51eC5kZXY7IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29t
PjsgTHUgQmFvbHUNCj4gPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT47IFlpIExpdSA8eWkubC5s
aXVAaW50ZWwuY29tPjsgWWkgWSBTdW4NCj4gPHlpLnkuc3VuQGludGVsLmNvbT47IE5pY29saW4g
Q2hlbiA8bmljb2xpbmNAbnZpZGlhLmNvbT47IEpvZXJnIFJvZWRlbA0KPiA8am9yb0A4Ynl0ZXMu
b3JnPjsgU3VyYXZlZSBTdXRoaWt1bHBhbml0DQo+IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1k
LmNvbT47IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBSb2Jpbg0KPiBNdXJwaHkgPHJv
YmluLm11cnBoeUBhcm0uY29tPjsgWmhlbnpob25nIER1YW4NCj4gPHpoZW56aG9uZy5kdWFuQGlu
dGVsLmNvbT47IEFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+
OyBrdm1Admdlci5rZXJuZWwub3JnOyBTaGFtZWVyIEtvbG90aHVtDQo+IDxzaGFtaWFsaTIwMDhA
Z21haWwuY29tPjsgV2FuZ3pob3UgKEIpIDx3YW5nemhvdTFAaGlzaWxpY29uLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCB2NiAwMC8xOF0gSU9NTVVGRCBEaXJ0eSBUcmFja2luZw0KPiANCj4g
T24gMzAvMTAvMjAyNCAxNTo1NywgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSB3cm90ZToNCj4g
Pj4gT24gMzAvMTAvMjAyNCAxNTozNiwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+Pj4gT24g
V2VkLCBPY3QgMzAsIDIwMjQgYXQgMTE6MTU6MDJQTSArMDgwMCwgWmhhbmdmZWkgR2FvIHdyb3Rl
Og0KPiA+Pj4+IGh3L3ZmaW8vbWlncmF0aW9uLmMNCj4gPj4+PiAgICAgaWYgKHZmaW9fdmlvbW11
X3ByZXNldCh2YmFzZWRldikpIHsNCj4gPj4+PiAgICAgICAgIGVycm9yX3NldGcoJmVyciwgIiVz
OiBNaWdyYXRpb24gaXMgY3VycmVudGx5IG5vdCBzdXBwb3J0ZWQgIg0KPiA+Pj4+ICAgICAgICAg
ICAgICAgICAgICAid2l0aCB2SU9NTVUgZW5hYmxlZCIsIHZiYXNlZGV2LT5uYW1lKTsNCj4gPj4+
PiAgICAgICAgIGdvdG8gYWRkX2Jsb2NrZXI7DQo+ID4+Pj4gICAgIH0NCj4gPj4+DQo+ID4+PiBU
aGUgdmlvbW11IGRyaXZlciBpdHNlbGYgZG9lcyBub3Qgc3VwcG9ydCBsaXZlIG1pZ3JhdGlvbiwg
aXQgd291bGQNCj4gPj4+IG5lZWQgdG8gcHJlc2VydmUgYWxsIHRoZSBndWVzdCBjb25maWd1cmF0
aW9uIGFuZCBicmluZyBpdCBhbGwgYmFjay4gSXQNCj4gPj4+IGRvZXNuJ3Qga25vdyBob3cgdG8g
ZG8gdGhhdCB5ZXQuDQo+ID4+DQo+ID4+IEl0J3MgbW9yZSBvZiB2ZmlvIGNvZGUsIG5vdCBxdWl0
ZSByZWxhdGVkIHRvIGFjdHVhbGx5IGh3IHZJT01NVS4NCj4gPj4NCj4gPj4gVGhlcmUncyBzb21l
IHZmaW8gbWlncmF0aW9uICsgdklPTU1VIHN1cHBvcnQgcGF0Y2hlcyBJIGhhdmUgdG8gZm9sbG93
DQo+IHVwDQo+ID4+ICh2NSkNCj4gPg0KPiA+IEFyZSB5b3UgcmVmZXJyaW5nIHRoaXMgc2VyaWVz
IGhlcmU/DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC9kNWQzMGY1OC0z
MWYwLTExMDMtNjk1Ni0NCj4gMzc3ZGUzNGE3OTBjQHJlZGhhdC5jb20vVC8NCj4gPg0KPiA+IElz
IHRoYXQgZW5hYmxpbmcgbWlncmF0aW9uIG9ubHkgaWYgR3Vlc3QgZG9lc27igJl0IGRvIGFueSBE
TUEgdHJhbnNsYXRpb25zPw0KPiA+DQo+IE5vLCBpdCBkb2VzIGl0IHdoZW4gZ3Vlc3QgaXMgdXNp
bmcgdGhlIHN3IHZJT01NVSB0b28uIHRvIGJlIGNsZWFyOiB0aGlzIGhhcw0KPiBub3RoaW5nIHRv
IGRvIHdpdGggbmVzdGVkIElPTU1VIG9yIGlmIHRoZSBndWVzdCBpcyBkb2luZyAoZW11bGF0ZWQp
IGRpcnR5DQo+IHRyYWNraW5nLg0KDQpPay4gVGhhbmtzIGZvciBleHBsYWluaW5nLiBTbyBqdXN0
IHRvIGNsYXJpZnksIHRoaXMgd29ya3MgZm9yIEludGVsIHZ0LWQgd2l0aA0KIiBjYWNoaW5nLW1v
ZGU9b24iLiBpZSwgbm8gcmVhbCAyIHN0YWdlIHNldHVwIGlzIHJlcXVpcmVkICBsaWtlIGluIEFS
TQ0KIFNNTVV2My4NCg0KPiBXaGVuIHRoZSBndWVzdCBkb2Vzbid0IGRvIERNQSB0cmFuc2xhdGlv
biBpcyB0aGlzIHBhdGNoOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZl
bC8yMDIzMDkwODEyMDUyMS41MDkwMy0xLQ0KPiBqb2FvLm0ubWFydGluc0BvcmFjbGUuY29tLw0K
DQpPay4NCg0KPiANCj4gPj4gYnV0IHVuZXhwZWN0ZWQgc2V0IGJhY2tzIHVucmVsYXRlZCB0byB3
b3JrIGRlbGF5IHNvbWUgb2YgbXkgcGxhbnMgZm9yDQo+ID4+IHFlbXUgOS4yLg0KPiA+PiBJIGV4
cGVjdCB0byByZXN1bWUgaW4gZmV3IHdlZWtzLiBJIGNhbiBwb2ludCB5b3UgdG8gYSBicmFuY2gg
d2hpbGUgSSBkb24ndA0KPiA+PiBzdWJtaXQgKHByb3ZpZGVkIHNvZnQtZnJlZXplIGlzIGNvbWlu
ZykNCj4gPg0KPiA+IEFsc28sIEkgdGhpbmsgd2UgbmVlZCBhIG1lY2hhbmlzbSBmb3IgcGFnZSBm
YXVsdCBoYW5kbGluZyBpbiBjYXNlIEd1ZXN0DQo+IGhhbmRsZXMNCj4gPiB0aGUgc3RhZ2UgMSBw
bHVzIGRpcnR5IHRyYWNraW5nIGZvciBzdGFnZSAxIGFzIHdlbGwuDQo+ID4NCj4gDQo+IEkgaGF2
ZSBlbXVsYXRpb24gZm9yIHg4NiBpb21tdXMgdG8gZGlydHkgdHJhY2tpbmcsIGJ1dCB0aGF0IGlz
IHVucmVsYXRlZCB0bw0KPiBMMA0KPiBsaXZlIG1pZ3JhdGlvbiAtLSBJdCdzIG1vcmUgZm9yIHRl
c3RpbmcgaW4gdGhlIGxhY2sgb2YgcmVjZW50IGhhcmR3YXJlLiBFdmVuDQo+IGVtdWxhdGVkIHBh
Z2UgZmF1bHQgaGFuZGxpbmcgZG9lc24ndCBhZmZlY3QgdGhpcyB1bmxlc3MgeW91IGhhdmUgdG8g
cmUtDQo+IG1hcC9tYXANCj4gbmV3IElPVkEsIHdoaWNoIHdvdWxkIGFsc28gYmUgY292ZXJlZCBp
biB0aGlzIHNlcmllcyBJIHRoaW5rLg0KPiANCj4gVW5sZXNzIHlvdSBhcmUgdGFsa2luZyBhYm91
dCBwaHlzaWNhbCBJT1BGIHRoYXQgcWVtdSBtYXkgdGVybWluYXRlLA0KPiB0aG91Z2ggd2UNCj4g
ZG9uJ3QgaGF2ZSBzdWNoIHN1cHBvcnQgaW4gUWVtdSBhdG0uDQoNClllYWggSSB3YXMgcmVmZXJy
aW5nIHRvIEFSTSBTTU1VdjMgY2FzZXMsIHdoZXJlIHdlIG5lZWQgbmVzdGVkLXNtbXV2Mw0Kc3Vw
cG9ydCBmb3IgdmZpby1wY2kgYXNzaWdubWVudC4gQW5vdGhlciB1c2VjYXNlIHdlIGhhdmUgaXMg
c3VwcG9ydCBTVkEgaW4NCkd1ZXN0LCAgd2l0aCBoYXJkd2FyZSBjYXBhYmxlICBvZiBwaHlzaWNh
bCBJT1BGLg0KDQpJIHdpbGwgdGFrZSBhIGxvb2sgYXQgeW91ciBzZXJpZXMgYWJvdmUgYW5kIHdp
bGwgc2VlIHdoYXQgZWxzZSBpcyByZXF1aXJlZA0KdG8gc3VwcG9ydCBBUk0uIFBsZWFzZSBDQyBp
ZiB5b3UgcGxhbiB0byByZXNwaW4gb3IgaGF2ZSBhIGxhdGVzdCBicmFuY2guDQpUaGFua3MgZm9y
IHlvdXIgZWZmb3J0cy4NCg0KU2hhbWVlcg0KIA0KDQo=

