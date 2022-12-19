Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5B65148C
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 22:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiLSVAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 16:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiLSVAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 16:00:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DBE6551;
        Mon, 19 Dec 2022 13:00:14 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKhhpR020979;
        Mon, 19 Dec 2022 21:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8XL1/KCqPFLJ5PiV0W9F6A3h6wzdRR7DU/nJQmNlFeo=;
 b=NWJ0LuZkuFsWH3bcvDcfkJrXi4RrdBBAZkCK6TVMWsEGGEvaf/wr7AlqzJmluXYq5mmd
 2ccUMavPRPfuj1np+kyHuRuQZsnBxjaQa2ve4FMO9avz+4+4jZd9/z3+FIJmV+WMoxjH
 eokRuMWSVLOWBioiQxGcuUqaHG2/yLgmocCmMzjid6hv+2hxBdaDNNYBmqcShPArsoWt
 DbM1VmZwWiGQMTNpIXZGNJ4scntcTqQKYZN+2l5oi//RiavvpGprA3ckPXcN+rCiQO7e
 vBTfe93WT0wZKO028kV2T2z+X6tzgq8QaBVdkIh70nXgUQEIFJRC5yjcAVL/bKFxf78p Qw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjy85ga4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 21:00:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKwDk8016851;
        Mon, 19 Dec 2022 21:00:12 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxfse6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 21:00:12 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJL0BZ513501042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 21:00:11 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0108B5805B;
        Mon, 19 Dec 2022 21:00:11 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D116058059;
        Mon, 19 Dec 2022 21:00:09 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 21:00:09 +0000 (GMT)
Message-ID: <44d2f997494d39a9a4f529e676faa082fbfbc577.camel@linux.ibm.com>
Subject: Re: [PATCH v1 13/16] vfio/ccw: allocate/populate the guest idal
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
Date:   Mon, 19 Dec 2022 16:00:09 -0500
In-Reply-To: <b6542dba-5645-f1f2-12a0-203e1187dd31@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-14-farman@linux.ibm.com>
         <b6542dba-5645-f1f2-12a0-203e1187dd31@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Og5-9Ie9lu6cHO_PTXMrDte7LqH24sPv
X-Proofpoint-GUID: Og5-9Ie9lu6cHO_PTXMrDte7LqH24sPv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190181
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTE5IGF0IDE1OjE0IC0wNTAwLCBNYXR0aGV3IFJvc2F0byB3cm90ZToK
PiBPbiAxMS8yMS8yMiA0OjQwIFBNLCBFcmljIEZhcm1hbiB3cm90ZToKPiA+IFRvZGF5LCB3ZSBh
bGxvY2F0ZSBtZW1vcnkgZm9yIGEgbGlzdCBvZiBJREFXcywgYW5kIGlmIHRoZSBDQ1cKPiA+IGJl
aW5nIHByb2Nlc3NlZCBjb250YWlucyBhbiBJREFMIHdlIHJlYWQgdGhhdCBkYXRhIGZyb20gdGhl
IGd1ZXN0Cj4gPiBpbnRvIHRoYXQgc3BhY2UuIFdlIHRoZW4gY29weSBlYWNoIElEQVcgaW50byB0
aGUgcGFfaW92YSBhcnJheSwKPiA+IG9yIGZhYnJpY2F0ZSB0aGF0IHBhX2lvdmEgYXJyYXkgd2l0
aCBhIGxpc3Qgb2YgYWRkcmVzc2VzIGJhc2VkCj4gPiBvbiBhIGRpcmVjdC1hZGRyZXNzZWQgQ0NX
Lgo+ID4gCj4gPiBDb21iaW5lIHRoZSByZWFkaW5nIG9mIHRoZSBndWVzdCBJREFMIHdpdGggdGhl
IGNyZWF0aW9uIG9mIGEKPiA+IHBzZXVkby1JREFMIGZvciBkaXJlY3QtYWRkcmVzc2VkIENDV3Ms
IHNvIHRoYXQgYm90aCBDQ1cgdHlwZXMKPiA+IGhhdmUgYSAiZ3Vlc3QiIElEQUwgdGhhdCBjYW4g
YmUgcG9wdWxhdGVkIHN0cmFpZ2h0IGludG8gdGhlCj4gPiBwYV9pb3ZhIGFycmF5Lgo+ID4gCj4g
PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+Cj4gPiAt
LS0KPiA+IMKgZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19jcC5jIHwgNzIgKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tCj4gPiAtLS0tCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA1MCBpbnNl
cnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
czM5MC9jaW8vdmZpb19jY3dfY3AuYwo+ID4gYi9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2Nw
LmMKPiA+IGluZGV4IDY4MzllNzE5NTE4Mi4uOTA2ODVjZWU4NWRiIDEwMDY0NAo+ID4gLS0tIGEv
ZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19jcC5jCj4gPiArKysgYi9kcml2ZXJzL3MzOTAvY2lv
L3ZmaW9fY2N3X2NwLmMKPiA+IEBAIC0xOTIsMTEgKzE5MiwxMiBAQCBzdGF0aWMgaW5saW5lIHZv
aWQKPiA+IHBhZ2VfYXJyYXlfaWRhbF9jcmVhdGVfd29yZHMoc3RydWN0IHBhZ2VfYXJyYXkgKnBh
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIGlkYXcuCj4gPiDCoMKgwqDCoMKgwqDCoMKgICovCj4g
PiDCoAo+ID4gLcKgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IHBhLT5wYV9ucjsgaSsrKQo+
ID4gK8KgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IHBhLT5wYV9ucjsgaSsrKSB7Cj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlkYXdzW2ldID0gcGFnZV90b19waHlzKHBh
LT5wYV9wYWdlW2ldKTsKPiA+IMKgCj4gPiAtwqDCoMKgwqDCoMKgwqAvKiBBZGp1c3QgdGhlIGZp
cnN0IElEQVcsIHNpbmNlIGl0IG1heSBub3Qgc3RhcnQgb24gYSBwYWdlCj4gPiBib3VuZGFyeSAq
Lwo+ID4gLcKgwqDCoMKgwqDCoMKgaWRhd3NbMF0gKz0gcGEtPnBhX2lvdmFbMF0gJiAoUEFHRV9T
SVpFIC0gMSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogSW5jb3Jwb3Jh
dGUgYW55IG9mZnNldCBmcm9tIGVhY2ggc3RhcnRpbmcKPiA+IGFkZHJlc3MgKi8KPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZGF3c1tpXSArPSBwYS0+cGFfaW92YVtpXSAmIChQ
QUdFX1NJWkUgLSAxKTsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+IMKgfQo+ID4gwqAKPiA+IMKg
c3RhdGljIHZvaWQgY29udmVydF9jY3cwX3RvX2NjdzEoc3RydWN0IGNjdzEgKnNvdXJjZSwgdW5z
aWduZWQKPiA+IGxvbmcgbGVuKQo+ID4gQEAgLTQ5Niw2ICs0OTcsNDQgQEAgc3RhdGljIGludCBj
Y3djaGFpbl9mZXRjaF90aWMoc3RydWN0IGNjdzEKPiA+ICpjY3csCj4gPiDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FRkFVTFQ7Cj4gPiDCoH0KPiA+IMKgCj4gPiArc3RhdGljIHVuc2lnbmVkIGxv
bmcgKmdldF9ndWVzdF9pZGFsKHN0cnVjdCBjY3cxICpjY3csCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
dHJ1Y3QgY2hhbm5lbF9wcm9ncmFtICpjcCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBpZGF3X25y
KQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiA9Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgJmNvbnRhaW5lcl9vZihjcCwgc3RydWN0
IHZmaW9fY2N3X3ByaXZhdGUsIGNwKS0KPiA+ID52ZGV2Owo+ID4gK8KgwqDCoMKgwqDCoMKgdW5z
aWduZWQgbG9uZyAqaWRhd3M7Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgaWRhbF9sZW4gPSBpZGF3
X25yICogc2l6ZW9mKCppZGF3cyk7Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgaWRhd19zaXplID0g
UEFHRV9TSVpFOwo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IGlkYXdfbWFzayA9IH4oaWRhd19zaXpl
IC0gMSk7Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgaSwgcmV0Owo+ID4gKwo+ID4gK8KgwqDCoMKg
wqDCoMKgaWRhd3MgPSBrY2FsbG9jKGlkYXdfbnIsIHNpemVvZigqaWRhd3MpLCBHRlBfRE1BIHwK
PiA+IEdGUF9LRVJORUwpOwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCFpZGF3cykKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiA+ICsKPiA+ICvCoMKgwqDC
oMKgwqDCoGlmIChjY3dfaXNfaWRhbChjY3cpKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyogQ29weSBJREFMIGZyb20gZ3Vlc3QgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXQgPSB2ZmlvX2RtYV9ydyh2ZGV2LCBjY3ctPmNkYSwgaWRhd3MsIGlk
YWxfbGVuLAo+ID4gZmFsc2UpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
IChyZXQpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKga2ZyZWUoaWRhd3MpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiAKPiBBcyBkaXNjdXNzZWQgb2ZmLWxpc3QsIGZvciBk
ZWJ1ZyBwdXJwb3NlcyBjb25zaWRlciB1c2luZyBzb21ldGhpbmcKPiBsaWtlIEVSUl9QVFIgb2Yg
dGhlIHZmaW9fZG1hX3J3IGVycm9yIHJldHVybiBoZXJlIHJhdGhlciB0aGFuIE5VTEwuIAoKWWVz
LCBnb29kIGlkZWEuCgo+IAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+
ICvCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgLyogRmFicmljYXRlIGFuIElEQUwgYmFzZWQgb2ZmIENDVyBkYXRhIGFkZHJlc3MgKi8KPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY3AtPm9yYi5jbWQuYzY0KSB7Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlkYXdzWzBd
ID0gY2N3LT5jZGE7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGZvciAoaSA9IDE7IGkgPCBpZGF3X25yOyBpKyspCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZGF3c1tpXSA9
IChpZGF3c1tpIC0gMV0gKwo+ID4gaWRhd19zaXplKSAmIGlkYXdfbWFzazsKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9IGVsc2Ugewo+IAo+IElmIGFueW9uZSBlbHNlIGlzIHJl
dmlld2luZyBhbmQgc3R1bWJsZXMgb24gdGhpcywgSSB3YXMgaW5pdGlhbGx5Cj4gd29uZGVyaW5n
IHdoeSB3ZSBiYWlsIGhlcmUgd2l0aCBubyBvYnZpb3VzIGV4cGxhbmF0aW9uIC0gd2FzIGdvaW5n
IHRvCj4gYXNrIGZvciBhIGNvbW1lbnQgaGVyZSBidXQgaXQgbG9va3MgbGlrZSB0aGlzIGVsc2Ug
Z2V0cyByZXBsYWNlZCBuZXh0Cj4gcGF0Y2ggd2l0aCBpbXBsZW1lbnRhdGlvbiBmb3IgZm9ybWF0
LTEuCgpBcyB5b3Ugbm90ZSwgdGhpcyBnb2VzIGF3YXkgaW4gdGhlIG5leHQgcGF0Y2ggc28gSSBk
aWRuJ3QgcHV0IGEgY29tbWVudAppbiBwbGFjZS4gQnV0IHdoaWxlIHB1dHRpbmcgaW4gdGhlIEVS
Ul9QVFIvUFRSX0VSUiBzdHVmZiwgSSBvcHRlZCB0bwpyZXR1cm4gRU9QTk9UU1VQUCBoZXJlIGlu
c3RlYWQgb2YgTlVMTCwgc28gd2UgZ2V0IGFuIGVycm9yIGVxdWFsIHRvIHRoZQpjdXJyZW50IGZl
bmNlIGluc3RlYWQgb2YgYW4gRU5PTUVNLiBTbyB0aGF0J2xsIGJlIGluIHYyLgoKVGhhbmtzLApF
cmljCgo+IAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBrZnJlZShpZGF3cyk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiBOVUxMOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oH0KPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBp
ZGF3czsKPiA+ICt9Cj4gPiArCj4gPiDCoC8qCj4gPiDCoCAqIGNjd19jb3VudF9pZGF3cygpIC0g
Q2FsY3VsYXRlIHRoZSBudW1iZXIgb2YgSURBV3MgbmVlZGVkIHRvCj4gPiB0cmFuc2Zlcgo+ID4g
wqAgKiBhIHNwZWNpZmllZCBhbW91bnQgb2YgZGF0YQo+ID4gQEAgLTU1NSw3ICs1OTQsNyBAQCBz
dGF0aWMgaW50IGNjd2NoYWluX2ZldGNoX2NjdyhzdHJ1Y3QgY2N3MSAqY2N3LAo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmY29udGFpbmVyX29mKGNwLCBzdHJ1Y3QgdmZpb19j
Y3dfcHJpdmF0ZSwgY3ApLQo+ID4gPnZkZXY7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQg
bG9uZyAqaWRhd3M7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiA+IC3CoMKgwqDCoMKg
wqDCoGludCBpZGF3X25yLCBpZGFsX2xlbjsKPiA+ICvCoMKgwqDCoMKgwqDCoGludCBpZGF3X25y
Owo+ID4gwqDCoMKgwqDCoMKgwqDCoGludCBpOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAv
KiBDYWxjdWxhdGUgc2l6ZSBvZiBJREFMICovCj4gPiBAQCAtNTYzLDEwICs2MDIsOCBAQCBzdGF0
aWMgaW50IGNjd2NoYWluX2ZldGNoX2NjdyhzdHJ1Y3QgY2N3MQo+ID4gKmNjdywKPiA+IMKgwqDC
oMKgwqDCoMKgwqBpZiAoaWRhd19uciA8IDApCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiBpZGF3X25yOwo+ID4gwqAKPiA+IC3CoMKgwqDCoMKgwqDCoGlkYWxfbGVu
ID0gaWRhd19uciAqIHNpemVvZigqaWRhd3MpOwo+ID4gLQo+ID4gwqDCoMKgwqDCoMKgwqDCoC8q
IEFsbG9jYXRlIGFuIElEQUwgZnJvbSBob3N0IHN0b3JhZ2UgKi8KPiA+IC3CoMKgwqDCoMKgwqDC
oGlkYXdzID0ga2NhbGxvYyhpZGF3X25yLCBzaXplb2YoKmlkYXdzKSwgR0ZQX0RNQSB8Cj4gPiBH
RlBfS0VSTkVMKTsKPiA+ICvCoMKgwqDCoMKgwqDCoGlkYXdzID0gZ2V0X2d1ZXN0X2lkYWwoY2N3
LCBjcCwgaWRhd19ucik7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFpZGF3cykgewo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSAtRU5PTUVNOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF9pbml0Owo+ID4gQEAgLTU4MiwyMiArNjE5
LDEzIEBAIHN0YXRpYyBpbnQgY2N3Y2hhaW5fZmV0Y2hfY2N3KHN0cnVjdCBjY3cxCj4gPiAqY2N3
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQgPCAwKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIG91dF9mcmVlX2lkYXdzOwo+ID4gwqAKPiA+IC3CoMKgwqDCoMKg
wqDCoGlmIChjY3dfaXNfaWRhbChjY3cpKSB7Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgLyogQ29weSBndWVzdCBJREFMIGludG8gaG9zdCBJREFMICovCj4gPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gdmZpb19kbWFfcncodmRldiwgY2N3LT5jZGEsIGlk
YXdzLCBpZGFsX2xlbiwKPiA+IGZhbHNlKTsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAocmV0KQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBnb3RvIG91dF91bnBpbjsKPiA+IC0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAvKgo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIENvcHkgZ3Vl
c3QgSURBV3MgaW50byBwYWdlX2FycmF5LCBpbiBjYXNlIHRoZQo+ID4gbWVtb3J5IHRoZXkKPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBvY2N1cHkgaXMgbm90IGNvbnRpZ3Vv
dXMuCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IGlkYXdfbnI7IGkrKykKPiA+ICvC
oMKgwqDCoMKgwqDCoC8qCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBDb3B5IGd1ZXN0IElEQVdzIGlu
dG8gcGFnZV9hcnJheSwgaW4gY2FzZSB0aGUgbWVtb3J5Cj4gPiB0aGV5Cj4gPiArwqDCoMKgwqDC
oMKgwqAgKiBvY2N1cHkgaXMgbm90IGNvbnRpZ3VvdXMuCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8K
PiA+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBpZGF3X25yOyBpKyspIHsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY3AtPm9yYi5jbWQuYzY0KQo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGEtPnBhX2lvdmFb
aV0gPSBpZGF3c1tpXTsKPiA+IC3CoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcGEtPnBhX2lvdmFbMF0gPSBjY3ctPmNkYTsKPiA+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmb3IgKGkgPSAxOyBpIDwgcGEtPnBhX25yOyBpKysp
Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhLT5w
YV9pb3ZhW2ldID0gcGEtPnBhX2lvdmFbaSAtIDFdICsKPiA+IFBBR0VfU0laRTsKPiA+IMKgwqDC
oMKgwqDCoMKgwqB9Cj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChjY3dfZG9lc19kYXRh
X3RyYW5zZmVyKGNjdykpIHsKPiAKCg==

