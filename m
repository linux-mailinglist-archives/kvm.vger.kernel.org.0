Return-Path: <kvm+bounces-30056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1089B6892
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 177371C21104
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B54A2141A3;
	Wed, 30 Oct 2024 15:57:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1924213EF6
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730303862; cv=none; b=hw2ZFlXpOBkbS/ZxkvWb/I/ZLyUcwehybcan1bLq3GIpMJvjTsoG2a0X3JgXztBPR6ua4LYNerqkugDAz797IWOyJv/yuU5Ex/iZjOZRu6mAZ3v7ow46uzeFxY06f57MSsvhAo/JW+j45xddFfaNasdkYyF7GysYS8NWfnqYqOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730303862; c=relaxed/simple;
	bh=eFWnCT+o91BVUbpimsSodXk0Nrk5IBdzM4qxJKmy8FQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PDoVKEPIT2kFNgr9N7ST4O1m26Mjo0FR8l6heGCqFUXXQnOZGs+CuzZymiOdREvujVNPsNCYBhE6+tpFJwGI/5gV+vCCC/zzgptrdMCfNTLm5MNp3syYZGfptnCPLSwRZJr5hHhtGX+T+OzLcOydgDkKlZwEIdMJA3IPtNE44Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XdsF12Bm4z20rBS;
	Wed, 30 Oct 2024 23:56:37 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (unknown [7.221.188.214])
	by mail.maildlp.com (Postfix) with ESMTPS id D65311A0188;
	Wed, 30 Oct 2024 23:57:36 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 30 Oct 2024 23:57:35 +0800
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 30 Oct 2024 16:57:33 +0100
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
Thread-Index: AQHaBoE27yp8pPeR+EGuD7wYVnICbbKhnzUAgAAF84CAAAMMAIAAEkFA
Date: Wed, 30 Oct 2024 15:57:33 +0000
Message-ID: <8401eb12c4a54826ba44e099a0ec67a9@huawei.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
	<CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
	<20241030153619.GG6956@nvidia.com>
 <9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
In-Reply-To: <9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
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

SGkgSm9hbywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FvIE1h
cnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0
b2JlciAzMCwgMjAyNCAzOjQ3IFBNDQo+IFRvOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEu
Y29tPjsgWmhhbmdmZWkgR2FvDQo+IDx6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZz4NCj4gQ2M6IGlv
bW11QGxpc3RzLmxpbnV4LmRldjsgS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+OyBT
aGFtZWVyYWxpDQo+IEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1
YXdlaS5jb20+OyBMdSBCYW9sdQ0KPiA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPjsgWWkgTGl1
IDx5aS5sLmxpdUBpbnRlbC5jb20+OyBZaSBZIFN1bg0KPiA8eWkueS5zdW5AaW50ZWwuY29tPjsg
Tmljb2xpbiBDaGVuIDxuaWNvbGluY0BudmlkaWEuY29tPjsgSm9lcmcgUm9lZGVsDQo+IDxqb3Jv
QDhieXRlcy5vcmc+OyBTdXJhdmVlIFN1dGhpa3VscGFuaXQNCj4gPHN1cmF2ZWUuc3V0aGlrdWxw
YW5pdEBhbWQuY29tPjsgV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz47IFJvYmluDQo+IE11
cnBoeSA8cm9iaW4ubXVycGh5QGFybS5jb20+OyBaaGVuemhvbmcgRHVhbg0KPiA8emhlbnpob25n
LmR1YW5AaW50ZWwuY29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4LndpbGxpYW1zb25AcmVk
aGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFNoYW1lZXIgS29sb3RodW0NCj4gPHNoYW1p
YWxpMjAwOEBnbWFpbC5jb20+OyBXYW5nemhvdSAoQikgPHdhbmd6aG91MUBoaXNpbGljb24uY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY2IDAwLzE4XSBJT01NVUZEIERpcnR5IFRyYWNraW5n
DQo+IA0KPiBPbiAzMC8xMC8yMDI0IDE1OjM2LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4g
T24gV2VkLCBPY3QgMzAsIDIwMjQgYXQgMTE6MTU6MDJQTSArMDgwMCwgWmhhbmdmZWkgR2FvIHdy
b3RlOg0KPiA+PiBody92ZmlvL21pZ3JhdGlvbi5jDQo+ID4+ICAgICBpZiAodmZpb192aW9tbXVf
cHJlc2V0KHZiYXNlZGV2KSkgew0KPiA+PiAgICAgICAgIGVycm9yX3NldGcoJmVyciwgIiVzOiBN
aWdyYXRpb24gaXMgY3VycmVudGx5IG5vdCBzdXBwb3J0ZWQgIg0KPiA+PiAgICAgICAgICAgICAg
ICAgICAgIndpdGggdklPTU1VIGVuYWJsZWQiLCB2YmFzZWRldi0+bmFtZSk7DQo+ID4+ICAgICAg
ICAgZ290byBhZGRfYmxvY2tlcjsNCj4gPj4gICAgIH0NCj4gPg0KPiA+IFRoZSB2aW9tbXUgZHJp
dmVyIGl0c2VsZiBkb2VzIG5vdCBzdXBwb3J0IGxpdmUgbWlncmF0aW9uLCBpdCB3b3VsZA0KPiA+
IG5lZWQgdG8gcHJlc2VydmUgYWxsIHRoZSBndWVzdCBjb25maWd1cmF0aW9uIGFuZCBicmluZyBp
dCBhbGwgYmFjay4gSXQNCj4gPiBkb2Vzbid0IGtub3cgaG93IHRvIGRvIHRoYXQgeWV0Lg0KPiAN
Cj4gSXQncyBtb3JlIG9mIHZmaW8gY29kZSwgbm90IHF1aXRlIHJlbGF0ZWQgdG8gYWN0dWFsbHkg
aHcgdklPTU1VLg0KPiANCj4gVGhlcmUncyBzb21lIHZmaW8gbWlncmF0aW9uICsgdklPTU1VIHN1
cHBvcnQgcGF0Y2hlcyBJIGhhdmUgdG8gZm9sbG93IHVwDQo+ICh2NSkNCg0KQXJlIHlvdSByZWZl
cnJpbmcgdGhpcyBzZXJpZXMgaGVyZT8NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3FlbXUtZGV2
ZWwvZDVkMzBmNTgtMzFmMC0xMTAzLTY5NTYtMzc3ZGUzNGE3OTBjQHJlZGhhdC5jb20vVC8NCg0K
SXMgdGhhdCBlbmFibGluZyBtaWdyYXRpb24gb25seSBpZiBHdWVzdCBkb2VzbuKAmXQgZG8gYW55
IERNQSB0cmFuc2xhdGlvbnM/IA0KDQo+IGJ1dCB1bmV4cGVjdGVkIHNldCBiYWNrcyB1bnJlbGF0
ZWQgdG8gd29yayBkZWxheSBzb21lIG9mIG15IHBsYW5zIGZvcg0KPiBxZW11IDkuMi4NCj4gSSBl
eHBlY3QgdG8gcmVzdW1lIGluIGZldyB3ZWVrcy4gSSBjYW4gcG9pbnQgeW91IHRvIGEgYnJhbmNo
IHdoaWxlIEkgZG9uJ3QNCj4gc3VibWl0IChwcm92aWRlZCBzb2Z0LWZyZWV6ZSBpcyBjb21pbmcp
DQoNCkFsc28sIEkgdGhpbmsgd2UgbmVlZCBhIG1lY2hhbmlzbSBmb3IgcGFnZSBmYXVsdCBoYW5k
bGluZyBpbiBjYXNlIEd1ZXN0IGhhbmRsZXMgDQp0aGUgc3RhZ2UgMSBwbHVzIGRpcnR5IHRyYWNr
aW5nIGZvciBzdGFnZSAxIGFzIHdlbGwuDQoNClRoYW5rcywNClNoYW1lZXINCg0KDQo=

