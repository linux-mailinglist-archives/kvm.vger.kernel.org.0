Return-Path: <kvm+bounces-3875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B34A1808CEE
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 17:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 619051F21093
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D49B46B90;
	Thu,  7 Dec 2023 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bLUXT+Gi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D5012D;
	Thu,  7 Dec 2023 08:11:39 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7FIhX0020821;
	Thu, 7 Dec 2023 16:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CxiimwSFUUP56ZsxPQCQTBb5gkeBOCCcGkKW+gmXXAg=;
 b=bLUXT+GiTznK6GsVKPIKhtLkuxTaEAJnrKOfOhFzM1LZ1l36iR4HearP8B6wyOPLqby6
 IfABm3q6LDh5Rute1rf5ngEj6WWABGsjXAhz7PwxU+/zg9thGJTurrSyciRY0E1L+h04
 KiUHHmtXljX76wGMOBKQ+TYrTen5h1O5rvd47vJx6SttdYD6MkyaFXcEudSSUY9Oop8L
 JF6IYUnPvU4rD7bORCbQPgkd51OuK1X9fhL+ib32EHdcc8w3mvRTs+mAOZlaiQs0PhgO
 qvSFqWWwnHLQlwb8rqKeVmF+yKtfA4aPSw+ASQMy/HOr/Ul+OOXOuqL24wVZh1rVs/t/ Iw== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uugjv1n4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 16:11:37 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7ERC0Z028465;
	Thu, 7 Dec 2023 16:11:37 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utavjv63x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 16:11:36 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B7GBZsW5243556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Dec 2023 16:11:36 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD25D58043;
	Thu,  7 Dec 2023 16:11:35 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 150FC58060;
	Thu,  7 Dec 2023 16:11:35 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.87.80])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Dec 2023 16:11:34 +0000 (GMT)
Message-ID: <bbc29010083e36591ec1029d6f50516182cd7eaa.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
From: Eric Farman <farman@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason
 Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Thu, 07 Dec 2023 11:11:34 -0500
In-Reply-To: <a62458b8-753d-43ad-b231-a359c9406c92@linux.ibm.com>
References: <20231201181657.1614645-1-farman@linux.ibm.com>
	 <a62458b8-753d-43ad-b231-a359c9406c92@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bO6_cMrYcY4fqQ-C4bm6Nhsrwr2pMytZ
X-Proofpoint-ORIG-GUID: bO6_cMrYcY4fqQ-C4bm6Nhsrwr2pMytZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_13,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312070133

T24gVGh1LCAyMDIzLTEyLTA3IGF0IDEwOjM5IC0wNTAwLCBBbnRob255IEtyb3dpYWsgd3JvdGU6
Cj4gCj4gT24gMTIvMS8yMyAxOjE2IFBNLCBFcmljIEZhcm1hbiB3cm90ZToKPiA+IFRoZSB2YXJp
b3VzIGVycm9ycyB0aGF0IGFyZSBwb3NzaWJsZSB3aGVuIHByb2Nlc3NpbmcgYSBQUUFQCj4gPiBp
bnN0cnVjdGlvbiAodGhlIGFic2VuY2Ugb2YgYSBkcml2ZXIgaG9vaywgYW4gZXJyb3IgRlJPTSB0
aGF0Cj4gPiBob29rKSwgYWxsIGNvcnJlY3RseSBzZXQgdGhlIFBTVyBjb25kaXRpb24gY29kZSB0
byAzLiBCdXQgaWYKPiA+IHRoYXQgcHJvY2Vzc2luZyB3b3JrcyBzdWNjZXNzZnVsbHksIENDMCBu
ZWVkcyB0byBiZSBzZXQgdG8KPiA+IGNvbnZleSB0aGF0IGV2ZXJ5dGhpbmcgd2FzIGZpbmUuCj4g
PiAKPiA+IEZpeCB0aGUgY2hlY2sgc28gdGhhdCB0aGUgZ3Vlc3QgY2FuIGV4YW1pbmUgdGhlIGNv
bmRpdGlvbiBjb2RlCj4gPiB0byBkZXRlcm1pbmUgd2hldGhlciBHUFIxIGhhcyBtZWFuaW5nZnVs
IGRhdGEuCj4gPiAKPiA+IEZpeGVzOiBlNTI4MmRlOTMxMDUgKCJzMzkwOiBhcDoga3ZtOiBhZGQg
UFFBUCBpbnRlcmNlcHRpb24gZm9yCj4gPiBBUUlDIikKPiA+IFNpZ25lZC1vZmYtYnk6IEVyaWMg
RmFybWFuIDxmYXJtYW5AbGludXguaWJtLmNvbT4KPiA+IC0tLQo+ID4gwqAgYXJjaC9zMzkwL2t2
bS9wcml2LmMgfCA4ICsrKysrKy0tCj4gPiDCoCAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9zMzkwL2t2bS9w
cml2LmMgYi9hcmNoL3MzOTAva3ZtL3ByaXYuYwo+ID4gaW5kZXggNjIxYTE3ZmQxYTFiLi5mODc1
YTQwNGEwYTAgMTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL3MzOTAva3ZtL3ByaXYuYwo+ID4gKysrIGIv
YXJjaC9zMzkwL2t2bS9wcml2LmMKPiA+IEBAIC02NzYsOCArNjc2LDEyIEBAIHN0YXRpYyBpbnQg
aGFuZGxlX3BxYXAoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlm
ICh2Y3B1LT5rdm0tPmFyY2guY3J5cHRvLnBxYXBfaG9vaykgewo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBwcWFwX2hvb2sgPSAqdmNwdS0+a3ZtLT5hcmNoLmNyeXB0by5wcWFw
X2hvb2s7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IHBxYXBfaG9v
ayh2Y3B1KTsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIXJldCAmJiB2
Y3B1LT5ydW4tPnMucmVncy5ncHJzWzFdICYgMHgwMGZmMDAwMCkKPiA+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga3ZtX3MzOTBfc2V0X3Bzd19jYyh2Y3B1
LCAzKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIXJldCkgewo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodmNwdS0+
cnVuLT5zLnJlZ3MuZ3Byc1sxXSAmIDB4MDBmZjAwMDApCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fczM5MF9zZXRf
cHN3X2NjKHZjcHUsIDMpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBlbHNlCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fczM5MF9zZXRfcHN3X2NjKHZjcHUsIDApOwo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiAKPiAKPiBUaGUgY2MgaXMgbm90
IHNldCBpZiBwcWFwX2hvb2sgcmV0dXJucyBhIG5vbi16ZXJvIHJjOyBob3dldmVyLCB0aGlzIAo+
IHBvaW50IG1heSBiZSBtb290IGdpdmVuIHRoZSBvbmx5IG5vbi16ZXJvIHJjIGlzIC1FT1BOT1RT
VVBQLiBJJ20gYQo+IGJpdCAKPiBmb2dneSBvbiB3aGF0IGhhcHBlbnMgd2hlbiBub24temVybyBy
ZXR1cm4gY29kZXMgYXJlIHBhc3NlZCB1cCB0aGUKPiBzdGFjay4KClJpZ2h0LCBhIG5vbi16ZXJv
IFJDIHdpbGwgZ2V0IHJlZmxlY3RlZCB0byB0aGUgaW50ZXJjZXB0aW9uIGhhbmRsZXJzLAp3aGVy
ZSBFT1BOT1RTVVBQIGluc3RydWN0cyBjb250cm9sIHRvIGJlIGdpdmVuIHRvIHVzZXJzcGFjZS4g
U28gbm90CnNldHRpbmcgYSBjb25kaXRpb24gY29kZSBpcyBjb3JyZWN0IGhlcmUsIGFzIHVzZXJz
cGFjZSB3aWxsIGJlIGV4cGVjdGVkCnRvIGRvIHRoYXQuCgo+IAo+IAo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB1cF9yZWFkKCZ2Y3B1LT5rdm0tPmFyY2guY3J5cHRvLnBxYXBf
aG9va19yd3NlbSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBy
ZXQ7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQoK


