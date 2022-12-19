Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E7651529
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 22:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiLSV5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 16:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiLSV5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 16:57:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0F611A3E;
        Mon, 19 Dec 2022 13:57:37 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJLegXT007879;
        Mon, 19 Dec 2022 21:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uo0o5cRrd99tXnRzsrcLelDjyeHLvsP4Q5z7NRrGoCI=;
 b=ANLlY2E+QODxAd/xaIPWxNTHRQDKrdTD3//83jgqnmcdk0HnLj2fi7DxyE7zmt8w9UZV
 tm6BIyela6bBP2sAu7cu2a1gva3wTaqizESzKp9uWcZ4pyzt9OXhxmeK6nj7q8m6HNwe
 ceSiaMSncZKCYVujU66Z6xpPfmIvntiN1q7DR/0KSvWPNQYXrCJqVx/kD87Q5kaxsprT
 fffwgitu4/Hl0k0HhjiW9S+NSPBQtcTiwVUTUHk85QmpcKRd5Sx+cOtCQ86KrQrqrOjh
 UX9jnftMfgo7qsm8xWzxJUZpcFBK/aFr059jHmxlB4bfL3zhJh7rPqfYI3INwVZlj+iB IQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjynm91t2-26
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 21:57:37 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJpQwL032663;
        Mon, 19 Dec 2022 21:04:44 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3mh6yykpj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 21:04:44 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJL4hUn31064638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 21:04:43 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C25A5804C;
        Mon, 19 Dec 2022 21:04:43 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80A1E58065;
        Mon, 19 Dec 2022 21:04:42 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 21:04:42 +0000 (GMT)
Message-ID: <32e781d00d2d1296fb4d36dd4f55a7ba873f62fe.camel@linux.ibm.com>
Subject: Re: [PATCH v1 14/16] vfio/ccw: handle a guest Format-1 IDAL
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:04:42 -0500
In-Reply-To: <4bebf8f9-5d19-b86b-b16c-ed3ea384c214@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-15-farman@linux.ibm.com>
         <4bebf8f9-5d19-b86b-b16c-ed3ea384c214@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GmGypcpJI4G_TJzWHMB1OjfrYP1PHsqD
X-Proofpoint-GUID: GmGypcpJI4G_TJzWHMB1OjfrYP1PHsqD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190189
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTE5IGF0IDE1OjI5IC0wNTAwLCBNYXR0aGV3IFJvc2F0byB3cm90ZToK
PiBPbiAxMS8yMS8yMiA0OjQwIFBNLCBFcmljIEZhcm1hbiB3cm90ZToKPiA+IFRoZXJlIGFyZSB0
d28gc2NlbmFyaW9zIHRoYXQgbmVlZCB0byBiZSBhZGRyZXNzZWQgaGVyZS4KPiA+IAo+ID4gRmly
c3QsIGFuIE9SQiB0aGF0IGRvZXMgTk9UIGhhdmUgdGhlIEZvcm1hdC0yIElEQUwgYml0IHNldCBj
b3VsZAo+ID4gaGF2ZSBib3RoIGEgZGlyZWN0LWFkZHJlc3NlZCBDQ1cgYW5kIGFuIGluZGlyZWN0
LWRhdGEtYWRkcmVzcyBDQ1cKPiA+IGNoYWluZWQgdG9nZXRoZXIuIFRoaXMgbWVhbnMgdGhhdCB0
aGUgSURBIENDVyB3aWxsIGNvbnRhaW4gYQo+ID4gRm9ybWF0LTEgSURBTCwgYW5kIGNhbiBiZSBl
YXNpbHkgY29udmVydGVkIHRvIGEgMksgRm9ybWF0LTIgSURBTC4KPiA+IEJ1dCBpdCBhbHNvIG1l
YW5zIHRoYXQgdGhlIGRpcmVjdC1hZGRyZXNzZWQgQ0NXIG5lZWRzIHRvIGJlCj4gPiBjb252ZXJ0
ZWQgdG8gdGhlIHNhbWUgMksgRm9ybWF0LTIgSURBTCBmb3IgY29uc2lzdGVuY3kgd2l0aCB0aGUK
PiA+IE9SQiBzZXR0aW5ncy4KPiA+IAo+ID4gU2Vjb25kbHksIGEgRm9ybWF0LTEgSURBTCBpcyBj
b21wcmlzZWQgb2YgMzEtYml0IGFkZHJlc3Nlcy4KPiA+IFRodXMsIHdlIG5lZWQgdG8gY2FzdCB0
aGlzIElEQUwgdG8gYSBwb2ludGVyIG9mIGludHMgd2hpbGUKPiA+IHBvcHVsYXRpbmcgdGhlIGxp
c3Qgb2YgYWRkcmVzc2VzIHRoYXQgYXJlIHNlbnQgdG8gdmZpby4KPiA+IAo+ID4gU2luY2UgdGhl
IHJlc3VsdCBvZiBib3RoIG9mIHRoZXNlIGlzIHRoZSB1c2Ugb2YgdGhlIDJLIElEQUwKPiA+IHZh
cmlhbnRzLCBhbmQgdGhlIG91dHB1dCBvZiB2ZmlvLWNjdyBpcyBhbHdheXMgYSBGb3JtYXQtMiBJ
REFMCj4gPiAoaW4gb3JkZXIgdG8gdXNlIDY0LWJpdCBhZGRyZXNzZXMpLCBtYWtlIHN1cmUgdGhh
dCB0aGUgY29ycmVjdAo+ID4gY29udHJvbCBiaXQgZ2V0cyBzZXQgaW4gdGhlIE9SQiB3aGVuIHRo
ZXNlIHNjZW5hcmlvcyBvY2N1ci4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogRXJpYyBGYXJtYW4g
PGZhcm1hbkBsaW51eC5pYm0uY29tPgo+ID4gLS0tCj4gPiDCoGRyaXZlcnMvczM5MC9jaW8vdmZp
b19jY3dfY3AuYyB8IDE5ICsrKysrKysrKysrKysrKystLS0KPiA+IMKgMSBmaWxlIGNoYW5nZWQs
IDE2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2NwLmMKPiA+IGIvZHJpdmVycy9zMzkwL2Npby92Zmlv
X2Njd19jcC5jCj4gPiBpbmRleCA5MDY4NWNlZTg1ZGIuLjk1MjdmM2Q4ZGE3NyAxMDA2NDQKPiA+
IC0tLSBhL2RyaXZlcnMvczM5MC9jaW8vdmZpb19jY3dfY3AuYwo+ID4gKysrIGIvZHJpdmVycy9z
MzkwL2Npby92ZmlvX2Njd19jcC5jCj4gPiBAQCAtMjIyLDYgKzIyMiw4IEBAIHN0YXRpYyB2b2lk
IGNvbnZlcnRfY2N3MF90b19jY3cxKHN0cnVjdCBjY3cxCj4gPiAqc291cmNlLCB1bnNpZ25lZCBs
b25nIGxlbikKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoH0KPiA+IMKgCj4gPiArI2RlZmlu
ZSBpZGFsX2lzXzJrKF9jcCkgKCFfY3AtPm9yYi5jbWQuYzY0IHx8IF9jcC0+b3JiLmNtZC5pMmsp
Cj4gPiArCj4gPiDCoC8qCj4gPiDCoCAqIEhlbHBlcnMgdG8gb3BlcmF0ZSBjY3djaGFpbi4KPiA+
IMKgICovCj4gPiBAQCAtNTA0LDggKzUwNiw5IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nICpnZXRf
Z3Vlc3RfaWRhbChzdHJ1Y3QKPiA+IGNjdzEgKmNjdywKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgdmZpb19kZXZpY2UgKnZkZXYgPQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAmY29udGFpbmVyX29mKGNwLCBzdHJ1Y3QgdmZpb19jY3dfcHJpdmF0ZSwgY3ApLQo+ID4gPnZk
ZXY7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyAqaWRhd3M7Cj4gPiArwqDCoMKg
wqDCoMKgwqB1bnNpZ25lZCBpbnQgKmlkYXdzX2YxOwo+IAo+IEkgd29uZGVyIGlmIHdlIHNob3Vs
ZCBiZSB1c2luZyBleHBsaWNpdCB1NjQvdTMyIGhlcmUgc2luY2Ugd2UgYXJlCj4gZGVhbGluZyB3
aXRoIGhhcmR3YXJlLWFyY2hpdGVjdGVkIGRhdGEgc2l6ZXMgYW5kIHNwZWNpZmljYWxseSB3YW50
IHRvCj4gaW5kZXggYnkgMzItIG9yIDY0LWJpdHMuwqAgSG9uZXN0bHksIHRoZXJlJ3MgcHJvYmFi
bHkgYSBudW1iZXIgb2YKPiBvdGhlciBzcG90cyBpbiB2ZmlvLWNjdyB3aGVyZSB0aGF0IG1pZ2h0
IG1ha2Ugc2Vuc2Ugc28gaXQgd291bGQgYWxzbwo+IGJlIE9LIHRvIGxvb2sgaW50byB0aGF0IGFz
IGEgZm9sbG93LW9uLgoKVGhpcyBpcyBhIGZhaXIgcG9pbnQuIEkgaGF2ZSBzb21lIGZvbGxvdy1v
biB3b3JrIHRvIHRoaXMgc2VyaWVzIGZvcgphZnRlciB0aGUgaG9saWRheXMsIHNvIEknbSBnb2lu
ZyB0byBwdXQgdGhpcyBzdWdnZXN0aW9uIG9uIHRoYXQgdG9kbwpsaXN0LgoKPiAKPiBPdGhlcndp
c2UsIExHVE0KPiAKPiBSZXZpZXdlZC1ieTogTWF0dGhldyBSb3NhdG8gPG1qcm9zYXRvQGxpbnV4
LmlibS5jb20+Cj4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IGlkYWxfbGVuID0gaWRhd19uciAq
IHNpemVvZigqaWRhd3MpOwo+ID4gLcKgwqDCoMKgwqDCoMKgaW50IGlkYXdfc2l6ZSA9IFBBR0Vf
U0laRTsKPiA+ICvCoMKgwqDCoMKgwqDCoGludCBpZGF3X3NpemUgPSBpZGFsX2lzXzJrKGNwKSA/
IFBBR0VfU0laRSAvIDIgOiBQQUdFX1NJWkU7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IGlkYXdf
bWFzayA9IH4oaWRhd19zaXplIC0gMSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IGksIHJldDsK
PiA+IMKgCj4gPiBAQCAtNTI3LDggKzUzMCwxMCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyAqZ2V0
X2d1ZXN0X2lkYWwoc3RydWN0Cj4gPiBjY3cxICpjY3csCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmb3IgKGkgPSAxOyBpIDwgaWRhd19ucjsgaSsr
KQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGlkYXdzW2ldID0gKGlkYXdzW2kgLSAxXSArCj4gPiBpZGF3X3NpemUpICYg
aWRhd19tYXNrOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9IGVsc2Ugewo+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrZnJlZShp
ZGF3cyk7Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldHVybiBOVUxMOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZGF3c19mMSA9ICh1bnNpZ25lZCBpbnQgKilpZGF3czsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWRhd3NfZjFbMF0gPSBjY3ctPmNk
YTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZm9y
IChpID0gMTsgaSA8IGlkYXdfbnI7IGkrKykKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlkYXdzX2YxW2ldID0gKGlkYXdz
X2YxW2kgLSAxXSArCj4gPiBpZGF3X3NpemUpICYgaWRhd19tYXNrOwo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gwqAKPiA+IEBA
IC01OTMsNiArNTk4LDcgQEAgc3RhdGljIGludCBjY3djaGFpbl9mZXRjaF9jY3coc3RydWN0IGNj
dzEgKmNjdywKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYgPQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmY29udGFpbmVyX29mKGNwLCBzdHJ1
Y3QgdmZpb19jY3dfcHJpdmF0ZSwgY3ApLQo+ID4gPnZkZXY7Cj4gPiDCoMKgwqDCoMKgwqDCoMKg
dW5zaWduZWQgbG9uZyAqaWRhd3M7Cj4gPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgKmlk
YXdzX2YxOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gPiDCoMKgwqDCoMKgwqDCoMKg
aW50IGlkYXdfbnI7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IGk7Cj4gPiBAQCAtNjIzLDkgKzYy
OSwxMiBAQCBzdGF0aWMgaW50IGNjd2NoYWluX2ZldGNoX2NjdyhzdHJ1Y3QgY2N3MQo+ID4gKmNj
dywKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBDb3B5IGd1ZXN0IElEQVdzIGludG8gcGFnZV9hcnJh
eSwgaW4gY2FzZSB0aGUgbWVtb3J5Cj4gPiB0aGV5Cj4gPiDCoMKgwqDCoMKgwqDCoMKgICogb2Nj
dXB5IGlzIG5vdCBjb250aWd1b3VzLgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDC
oMKgwqDCoMKgaWRhd3NfZjEgPSAodW5zaWduZWQgaW50ICopaWRhd3M7Cj4gPiDCoMKgwqDCoMKg
wqDCoMKgZm9yIChpID0gMDsgaSA8IGlkYXdfbnI7IGkrKykgewo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoY3AtPm9yYi5jbWQuYzY0KQo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGEtPnBhX2lvdmFbaV0gPSBpZGF3c1tp
XTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlbHNlCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhLT5wYV9pb3ZhW2ldID0gaWRh
d3NfZjFbaV07Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKg
wqBpZiAoY2N3X2RvZXNfZGF0YV90cmFuc2ZlcihjY3cpKSB7Cj4gPiBAQCAtODQ2LDcgKzg1NSwx
MSBAQCB1bmlvbiBvcmIgKmNwX2dldF9vcmIoc3RydWN0IGNoYW5uZWxfcHJvZ3JhbQo+ID4gKmNw
LCBzdHJ1Y3Qgc3ViY2hhbm5lbCAqc2NoKQo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+
ID4gwqDCoMKgwqDCoMKgwqDCoCAqIEV2ZXJ5dGhpbmcgYnVpbHQgYnkgdmZpby1jY3cgaXMgYSBG
b3JtYXQtMiBJREFMLgo+ID4gK8KgwqDCoMKgwqDCoMKgICogSWYgdGhlIGlucHV0IHdhcyBhIEZv
cm1hdC0xIElEQUwsIGluZGljYXRlIHRoYXQKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIDJLIEZvcm1h
dC0yIElEQVdzIHdlcmUgY3JlYXRlZCBoZXJlLgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4g
K8KgwqDCoMKgwqDCoMKgaWYgKCFvcmItPmNtZC5jNjQpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgb3JiLT5jbWQuaTJrID0gMTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBvcmItPmNt
ZC5jNjQgPSAxOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAob3JiLT5jbWQubHBtID09
IDApCj4gCgo=

