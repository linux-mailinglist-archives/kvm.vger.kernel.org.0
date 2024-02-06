Return-Path: <kvm+bounces-8099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE1B84B6C9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 14:44:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CC961C247E9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 13:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAED132C03;
	Tue,  6 Feb 2024 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VsfDT9/x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BB01DFFB;
	Tue,  6 Feb 2024 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707226949; cv=none; b=YajzwbXXULvCv+phVFfb8DcDkDj/2abvVGhQt5llrie0IOSPq6GHFKLQgnKlDou2hyjgYf+bBz5an4XTaaYity70gwNKaWT+L4DFxmVMPjyqLCvR/4GqXyIh5E/IaixMa6A3X+g33OYHeydcR6zsvHm0dFTrQMC1LQ7mopIRwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707226949; c=relaxed/simple;
	bh=B2hITyyjnN//oH/Zcx/TChQbL+Ml4ca/P1n3Pocrvxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kiooRODDFjvJgEzRMDEmwlPYxCcSlMiKlu0s677lLNmFsqSX0vz/l2qIc+CRXSU6Yds9BsVytNS76p77vY0s0WM17iX00ZiWnyG4rUGK7Ap2rrVlkyb2q02pJekp7mdU9MUu8FsOi54ZYD0JfSUKQUkok1X57lRz0AITz8/xM74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VsfDT9/x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 416CvuwV000727;
	Tue, 6 Feb 2024 13:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B2hITyyjnN//oH/Zcx/TChQbL+Ml4ca/P1n3Pocrvxg=;
 b=VsfDT9/xwz/WuSFp9ek+9WNrAZV55VPXY0/6eMSUkIQfDylucyJxHQ+63FDDGwo5mzdH
 ivvx/jrIjTqEUyfEXDmGXO7RZFFJmiPJRZ5s8bdNR4oBbFtuvYXWVjldzLq8ODSQalCK
 klw5ZZg/F19AwPykEHw2Rhicvoj4TsnG/dQez9W9AveC8LIcXCdjT1IbJGOMeZiTUdjN
 AYjXTgWDLDjQDiSep7lmN5X1yrxavDuCKi+4KIYx3f6vNSxNclIZ1za6rOBof3G5c6pr
 aSBoN6IvfAPCf7RgC6orWox6BucUbnA9qb9LEi78BDxmOSOXp4iqc6wSnUDtm7DS/tAW 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3n7ws9u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 13:42:25 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 416DHpkS017889;
	Tue, 6 Feb 2024 13:42:25 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3n7ws9u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 13:42:25 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 416B0rVT016195;
	Tue, 6 Feb 2024 13:42:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w22h1xtdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 13:42:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 416DgLj012911180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Feb 2024 13:42:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8245F2004B;
	Tue,  6 Feb 2024 13:42:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBA2320040;
	Tue,  6 Feb 2024 13:42:20 +0000 (GMT)
Received: from [9.171.91.233] (unknown [9.171.91.233])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Feb 2024 13:42:20 +0000 (GMT)
Message-ID: <a289a445-7665-4013-adfe-dd95ac3558c0@linux.ibm.com>
Date: Tue, 6 Feb 2024 14:42:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 1/7] lib: s390x: Add ap library
Content-Language: en-US
To: Anthony Krowiak <akrowiak@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        jjherne@linux.ibm.com, Harald Freudenberger <freude@linux.ibm.com>
References: <20240202145913.34831-1-frankja@linux.ibm.com>
 <20240202145913.34831-2-frankja@linux.ibm.com>
 <b1bb6df4-dea3-414d-9f53-dfd76571fbb7@linux.ibm.com>
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <b1bb6df4-dea3-414d-9f53-dfd76571fbb7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qs_WAHvWPlbEDkdp85t-5z5_345Jqcy1
X-Proofpoint-GUID: 4OCauFc3vhVzZ6aZF8ZNMfrZGzGZuiJG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_06,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060096

T24gMi81LzI0IDE5OjE1LCBBbnRob255IEtyb3dpYWsgd3JvdGU6DQo+IEkgbWFkZSBhIGZl
dyBjb21tZW50cyBhbmQgc3VnZ2VzdGlvbnMuIEkgYW0gbm90IHZlcnkgd2VsbC12ZXJzZWQg
aW4gdGhlDQo+IGlubGluZSBhc3NlbWJseSBjb2RlLCBzbyBJJ2xsIGxlYXZlIHRoYXQgdXAg
dG8gc29tZW9uZSB3aG8gaXMgbW9yZQ0KPiBrbm93bGVkZ2VhYmxlLiBJIGNvcGllZCBASGFy
YWxkIHNpbmNlIEkgYmVsaWV2ZSBpdCB3YXMgaGltIHdobyB3cm90ZSBpdC4NCj4gDQo+IE9u
IDIvMi8yNCA5OjU5IEFNLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gQWRkIGZ1bmN0aW9u
cyBhbmQgZGVmaW5pdGlvbnMgbmVlZGVkIHRvIHRlc3QgdGhlIEFkanVuY3QNCj4+IFByb2Nl
c3NvciAoQVApIGNyeXB0byBpbnRlcmZhY2UuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSmFu
b3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51eC5pYm0uY29tPg0KDQpbLi4uXQ0KDQo+PiArLyog
V2lsbCBsYXRlciBiZSBleHRlbmRlZCB0byBhIHByb3BlciBzZXR1cCBmdW5jdGlvbiAqLw0K
Pj4gK2Jvb2wgYXBfc2V0dXAodm9pZCkNCj4+ICt7DQo+PiArCS8qDQo+PiArCSAqIEJhc2Ug
QVAgc3VwcG9ydCBoYXMgbm8gU1RGTEUgb3IgU0NMUCBmZWF0dXJlIGJpdCBidXQgdGhlDQo+
PiArCSAqIFBRQVAgUUNJIHN1cHBvcnQgaXMgaW5kaWNhdGVkIHZpYSBzdGZsZSBiaXQgMTIu
IEFzIHRoaXMNCj4+ICsJICogbGlicmFyeSByZWxpZXMgb24gUUNJIHdlIGJhaWwgb3V0IGlm
IGl0J3Mgbm90IGF2YWlsYWJsZS4NCj4+ICsJICovDQo+PiArCWlmICghdGVzdF9mYWNpbGl0
eSgxMikpDQo+PiArCQlyZXR1cm4gZmFsc2U7DQo+IA0KPiANCj4gVGhlIFNURkxFLjEyIGNh
biBiZSB0dXJuZWQgb2ZmIHdoZW4gc3RhcnRpbmcgdGhlIGd1ZXN0LCBzbyB0aGlzIG1heSBu
b3QNCj4gYmUgYSB2YWxpZCB0ZXN0Lg0KPiANCj4gV2UgdXNlIHRoZSBhcF9pbnN0cnVjdGlv
bnNfYXZhaWxhYmxlIGZ1bmN0aW9uIChpbiBhcC5oKSB3aGljaCBleGVjdXRlcw0KPiB0aGUg
VEFQUSBjb21tYW5kIHRvIHZlcmlmeSB3aGV0aGVyIHRoZSBBUCBpbnN0cnVjdGlvbnMgYXJl
IGluc3RhbGxlZCBvcg0KPiBub3QuIE1heWJlIHlvdSBjYW4gZG8gc29tZXRoaW5nIHNpbWls
YXIgaGVyZToNCg0KVGhpcyBsaWJyYXJ5IHJlbGllcyBvbiBRQ0ksIGhlbmNlIHdlIG9ubHkg
Y2hlY2sgZm9yIHN0ZmxlLg0KSSBzZWUgbm8gc2Vuc2UgaW4gbWFudWFsbHkgcHJvYmluZyB0
aGUgd2hvbGUgQVBRTiBzcGFjZS4NCg0KDQpJZiBzdGZsZSAxMiBpcyBpbmRpY2F0ZWQgSSdk
IGV4cGVjdCBBUCBpbnN0cnVjdGlvbnMgdG8gbm90IGdlbmVyYXRlIA0KZXhjZXB0aW9ucyBv
ciBkbyB0aGV5IGluIGEgc2FuZSBDUFUgbW9kZWw/DQoNCg0KPj4gKw0KPj4gKwlyZXR1cm4g
dHJ1ZTsNCj4+ICt9DQo+PiBkaWZmIC0tZ2l0IGEvbGliL3MzOTB4L2FwLmggYi9saWIvczM5
MHgvYXAuaA0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwLi5i
ODA2NTEzZg0KPj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvbGliL3MzOTB4L2FwLmgNCj4+
IEBAIC0wLDAgKzEsODggQEANCj4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMC1vbmx5ICovDQo+PiArLyoNCj4+ICsgKiBBUCBkZWZpbml0aW9ucw0KPj4gKyAqDQo+
PiArICogU29tZSBwYXJ0cyB0YWtlbiBmcm9tIHRoZSBMaW51eCBBUCBkcml2ZXIuDQo+PiAr
ICoNCj4+ICsgKiBDb3B5cmlnaHQgSUJNIENvcnAuIDIwMjQNCj4+ICsgKiBBdXRob3I6IEph
bm9zY2ggRnJhbmsgPGZyYW5ramFAbGludXguaWJtLmNvbT4NCj4+ICsgKgkgICBUb255IEty
b3dpYWsgPGFrcm93aWFAbGludXguaWJtLmNvbT4NCj4+ICsgKgkgICBNYXJ0aW4gU2Nod2lk
ZWZza3kgPHNjaHdpZGVmc2t5QGRlLmlibS5jb20+DQo+PiArICoJICAgSGFyYWxkIEZyZXVk
ZW5iZXJnZXIgPGZyZXVkZUBkZS5pYm0uY29tPg0KPj4gKyAqLw0KPj4gKw0KPj4gKyNpZm5k
ZWYgX1MzOTBYX0FQX0hfDQo+PiArI2RlZmluZSBfUzM5MFhfQVBfSF8NCj4+ICsNCj4+ICtl
bnVtIFBRQVBfRkMgew0KPj4gKwlQUUFQX1RFU1RfQVBRLA0KPj4gKwlQUUFQX1JFU0VUX0FQ
USwNCj4+ICsJUFFBUF9aRVJPSVpFX0FQUSwNCj4+ICsJUFFBUF9RVUVVRV9JTlRfQ09OVFJM
LA0KPj4gKwlQUUFQX1FVRVJZX0FQX0NPTkZfSU5GTywNCj4+ICsJUFFBUF9RVUVSWV9BUF9D
T01QX1RZUEUsDQo+PiArCVBRQVBfQkVTVF9BUCwNCj4gDQo+IA0KPiBNYXliZSB1c2UgYWJi
cmV2aWF0aW9ucyBsaWtlIHlvdXIgZnVuY3Rpb24gbmFtZXMgYWJvdmU/DQo+IA0KPiAJUFFB
UF9UQVBRLA0KPiAJUFFBUF9SQVBRLA0KPiAJUFFBUF9aQVBRLA0KPiAJUFFBUF9BUUlDLA0K
PiAJUFFBUF9RQ0ksDQo+IAlQUUFQX1FBQ1QsDQo+IAlQUUFQX1FCQVANCj4gDQoNCkhtbW1t
bW1tKFRNKQ0KTXkgZ3Vlc3MgaXMgdGhhdCBJIHRyaWVkIG1ha2luZyB0aGVzZSBjb25zdGFu
dHMgcmVhZGFibGUgd2l0aG91dCANCmNvbnN1bHRpbmcgYXJjaGl0ZWN0dXJlIGRvY3VtZW50
cy4gQnV0IGFub3RoZXIgb3B0aW9uIGlzIHVzaW5nIHRoZSANCmNvbnN0YW50cyB0aGF0IHlv
dSBzdWdnZXN0ZWQgYW5kIGFkZGluZyBjb21tZW50cyB3aXRoIGEgbG9uZyB2ZXJzaW9uLg0K
DQpXaWxsIGRvDQoNClsuLi5dDQoNCj4+ICtzdHJ1Y3QgcHFhcF9yMCB7DQo+PiArCXVpbnQz
Ml90IHBhZDA7DQo+PiArCXVpbnQ4X3QgZmM7DQo+PiArCXVpbnQ4X3QgdCA6IDE7CQkvKiBU
ZXN0IGZhY2lsaXRpZXMgKFRBUFEpKi8NCj4+ICsJdWludDhfdCBwYWQxIDogNzsNCj4+ICsJ
dWludDhfdCBhcDsNCj4gDQo+IA0KPiBUaGlzIGlzIHRoZSBBUElEIHBhcnQgb2YgYW4gQVBR
Tiwgc28gaG93IGFib3V0IHJlbmFtaW5nIHRvICdhcGlkJw0KPiANCj4gDQo+PiArCXVpbnQ4
X3QgcW47DQo+IA0KPiANCj4gVGhpcyBpcyB0aGUgQVBRScKgIHBhcnQgb2YgYW4gQVBRTiwg
c28gaG93IGFib3V0IHJlbmFtaW5nIHRvICdhcHFpJw0KDQpIbW0gTGludXggdXNlcyBxaWQN
CkknbGwgY2hhbmdlIGl0IHRvIHRoZSBMaW51eCBuYW1pbmcgY29udmVudGlvbiwgbWlnaHQg
dGFrZSBtZSBhIHdoaWxlIHRob3VnaA0KDQo+IA0KPiANCj4+ICt9IF9fYXR0cmlidXRlX18o
KHBhY2tlZCkpICBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgpKSk7DQo+PiArDQo+PiArc3Ry
dWN0IHBxYXBfcjIgew0KPj4gKwl1aW50OF90IHMgOiAxOwkJLyogU3BlY2lhbCBDb21tYW5k
IGZhY2lsaXR5ICovDQo+PiArCXVpbnQ4X3QgbSA6IDE7CQkvKiBBUDRLTSAqLw0KPj4gKwl1
aW50OF90IGMgOiAxOwkJLyogQVA0S0MgKi8NCj4+ICsJdWludDhfdCBjb3AgOiAxOwkvKiBB
UCBpcyBpbiBjb3Byb2Nlc3NvciBtb2RlICovDQo+PiArCXVpbnQ4X3QgYWNjIDogMTsJLyog
QVAgaXMgaW4gYWNjZWxlcmF0b3IgbW9kZSAqLw0KPj4gKwl1aW50OF90IHhjcCA6IDE7CS8q
IEFQIGlzIGluIFhDUC1tb2RlICovDQo+PiArCXVpbnQ4X3QgbiA6IDE7CQkvKiBBUCBleHRl
bmRlZCBhZGRyZXNzaW5nIGZhY2lsaXR5ICovDQo+PiArCXVpbnQ4X3QgcGFkXzAgOiAxOw0K
Pj4gKwl1aW50OF90IHBhZF8xWzNdOw0KPiANCj4gDQo+IElzIHRoZXJlIGEgcmVhc29uIHdo
eSB0aGUgJ0NsYXNzaWZpY2F0aW9uJ8KgIGZpZWxkIGlzIGxlZnQgb3V0Pw0KPiANCg0KSXQn
cyBub3QgdXNlZCBpbiB0aGlzIGxpYnJhcnkgYW5kIHRoZXJlZm9yZSBJIGNob3NlIHRvIG5v
dCBuYW1lIGl0IHRvIA0KbWFrZSBzdHJ1Y3RzIGEgYml0IG1vcmUgcmVhZGFibGUuDQoNCj4g
DQo+PiArCXVpbnQ4X3QgYXQ7DQo+PiArCXVpbnQ4X3QgbmQ7DQo+PiArCXVpbnQ4X3QgcGFk
XzY7DQo+PiArCXVpbnQ4X3QgcGFkXzcgOiA0Ow0KPj4gKwl1aW50OF90IHFkIDogNDsNCj4+
ICt9IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpICBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgp
KSk7DQo+PiArX1N0YXRpY19hc3NlcnQoc2l6ZW9mKHN0cnVjdCBwcWFwX3IyKSA9PSBzaXpl
b2YodWludDY0X3QpLCAicHFhcF9yMiBzaXplIik7DQo+PiArDQo+PiArYm9vbCBhcF9zZXR1
cCh2b2lkKTsNCj4+ICtpbnQgYXBfcHFhcF90YXBxKHVpbnQ4X3QgYXAsIHVpbnQ4X3QgcW4s
IHN0cnVjdCBhcF9xdWV1ZV9zdGF0dXMgKmFwcXN3LA0KPj4gKwkJIHN0cnVjdCBwcWFwX3Iy
ICpyMik7DQo+PiAraW50IGFwX3BxYXBfcWNpKHN0cnVjdCBhcF9jb25maWdfaW5mbyAqaW5m
byk7DQo+PiArI2VuZGlmDQo+PiBkaWZmIC0tZ2l0IGEvczM5MHgvTWFrZWZpbGUgYi9zMzkw
eC9NYWtlZmlsZQ0KPj4gaW5kZXggN2ZjZTlmOWQuLjRmNmM2MjdkIDEwMDY0NA0KPj4gLS0t
IGEvczM5MHgvTWFrZWZpbGUNCj4+ICsrKyBiL3MzOTB4L01ha2VmaWxlDQo+PiBAQCAtMTEw
LDYgKzExMCw3IEBAIGNmbGF0b2JqcyArPSBsaWIvczM5MHgvbWFsbG9jX2lvLm8NCj4+ICAg
IGNmbGF0b2JqcyArPSBsaWIvczM5MHgvdXYubw0KPj4gICAgY2ZsYXRvYmpzICs9IGxpYi9z
MzkweC9zaWUubw0KPj4gICAgY2ZsYXRvYmpzICs9IGxpYi9zMzkweC9mYXVsdC5vDQo+PiAr
Y2ZsYXRvYmpzICs9IGxpYi9zMzkweC9hcC5vDQo+PiAgICANCj4+ICAgIE9CSkRJUlMgKz0g
bGliL3MzOTB4DQo+PiAgICANCg0K

