Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D9159EC34
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiHWTYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 15:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiHWTYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 15:24:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC30462AA3;
        Tue, 23 Aug 2022 11:07:26 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHovJG022370;
        Tue, 23 Aug 2022 18:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DqHJa0JLDsCNjice0GhHujd3tZhBg6TouDqEsH4XWHc=;
 b=SH7Dij43VAhxnw8x5uW4KxsIsQdbuuuyWBKZ1sejnWMM4Z/uGlKlSx1BS76HSUBY/Zqx
 wKDyxbwLH8TZHA7Ol/8cCAtwhN2tYixUzEYcAEdQw5TxJOPc+9TvFbXa49SmUYtIdJmA
 HDtltimhAZErthcQbSVpNjovIiWI9ukDg2fDl35lq3x5dYPQIwJimF37GeoLIi88zbH7
 q+BHrsNALd+jdp0Ljnuqnh7XBP9EoBal2QQZrUEHu+i4Garxylay0zp1x+HlYTD6Wua/
 lishv4dyOlEoZ5bed8c6HODyzKyuxRelDMoDtQSriNUqC46NJ2J8C1hAnQ4TknRBjyIl Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53nf8g0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NHpQjl024009;
        Tue, 23 Aug 2022 18:07:17 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53nf8g05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:17 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NHove8006478;
        Tue, 23 Aug 2022 18:07:16 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3j2q8a1mjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:16 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NI7FgM46006578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 18:07:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2EA5AC05B;
        Tue, 23 Aug 2022 18:07:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BD9DAC059;
        Tue, 23 Aug 2022 18:07:15 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.161.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 18:07:14 +0000 (GMT)
Message-ID: <9d3c715ee2d521dbd25d2f9691a88636304ead32.camel@linux.ibm.com>
Subject: Re: [PATCH 14/14] vfio/mdev: add mdev available instance checking
 to the core
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Date:   Tue, 23 Aug 2022 14:07:14 -0400
In-Reply-To: <20220822062208.152745-15-hch@lst.de>
References: <20220822062208.152745-1-hch@lst.de>
         <20220822062208.152745-15-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pECMpVzkAjUlbyfQrKH-mP9lCgtXdwqm
X-Proofpoint-GUID: cLPEAf22fnWboPSMYM1YjcZyim1virdg
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTIyIGF0IDA4OjIyICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBNYW55IG9mIHRoZSBtZGV2IGRyaXZlcnMgdXNlIGEgc2ltcGxlIGNvdW50ZXIgZm9yIGtl
ZXBpbmcgdHJhY2sgb2YKPiB0aGUKPiBhdmFpbGFibGUgaW5zdGFuY2VzLiBNb3ZlIHRoaXMgY29k
ZSB0byB0aGUgY29yZSBjb2RlIGFuZCBzdG9yZSB0aGUKPiBjb3VudGVyCj4gaW4gdGhlIG1kZXZf
cGFyZW50LiBJbXBsZW1lbnQgaXQgdXNpbmcgY29ycmVjdCBsb2NraW5nLCBmaXhpbmcgbWRweS4K
PiAKPiBEcml2ZXJzIGp1c3QgcHJvdmlkZSB0aGUgdmFsdWUgaW4gdGhlIG1kZXZfZHJpdmVyIGF0
IHJlZ2lzdHJhdGlvbgo+IHRpbWUKPiBhbmQgdGhlIGNvcmUgY29kZSB0YWtlcyBjYXJlIG9mIG1h
aW50YWluaW5nIGl0IGFuZCBleHBvc2luZyB0aGUgdmFsdWUKPiBpbgo+IHN5c2ZzLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+Cj4gW2hjaDogY291
bnQgaW5zdGFuY2VzIHBlci1wYXJlbnQgaW5zdGVhZCBvZiBwZXItdHlwZSwgdXNlIGFuIGF0b21p
Y190Cj4gwqB0byBhdm9pZCB0YWtpbmcgbWRldl9saXN0X2xvY2sgaW4gdGhlIHNob3cgbWV0aG9k
XQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFJldmll
d2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4KPiBSZXZpZXdlZC1ieTog
S2lydGkgV2Fua2hlZGUgPGt3YW5raGVkZUBudmlkaWEuY29tPgoKLi4uc25pcC4uLgoKPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3JlLmMKPiBiL2RyaXZlcnMvdmZpby9t
ZGV2L21kZXZfY29yZS5jCj4gaW5kZXggOTNmOGNhZjJlNWY3Ny4uMmQwMzAyOTk1ZDdiNyAxMDA2
NDQKPiAtLS0gYS9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMv
dmZpby9tZGV2L21kZXZfY29yZS5jCj4gQEAgLTcwLDYgKzcwLDcgQEAgaW50IG1kZXZfcmVnaXN0
ZXJfcGFyZW50KHN0cnVjdCBtZGV2X3BhcmVudAo+ICpwYXJlbnQsIHN0cnVjdCBkZXZpY2UgKmRl
diwKPiDCoMKgwqDCoMKgwqDCoMKgcGFyZW50LT5tZGV2X2RyaXZlciA9IG1kZXZfZHJpdmVyOwo+
IMKgwqDCoMKgwqDCoMKgwqBwYXJlbnQtPnR5cGVzID0gdHlwZXM7Cj4gwqDCoMKgwqDCoMKgwqDC
oHBhcmVudC0+bnJfdHlwZXMgPSBucl90eXBlczsKPiArwqDCoMKgwqDCoMKgwqBhdG9taWNfc2V0
KCZwYXJlbnQtPmF2YWlsYWJsZV9pbnN0YW5jZXMsIG1kZXZfZHJpdmVyLQo+ID5tYXhfaW5zdGFu
Y2VzKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIW1kZXZfYnVzX2NvbXBhdF9jbGFzcykg
ewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWRldl9idXNfY29tcGF0X2NsYXNz
ID0KPiBjbGFzc19jb21wYXRfcmVnaXN0ZXIoIm1kZXZfYnVzIik7Cj4gQEAgLTExNSwxNCArMTE2
LDE3IEBAIEVYUE9SVF9TWU1CT0wobWRldl91bnJlZ2lzdGVyX3BhcmVudCk7Cj4gwqBzdGF0aWMg
dm9pZCBtZGV2X2RldmljZV9yZWxlYXNlKHN0cnVjdCBkZXZpY2UgKmRldikKPiDCoHsKPiDCoMKg
wqDCoMKgwqDCoMKgc3RydWN0IG1kZXZfZGV2aWNlICptZGV2ID0gdG9fbWRldl9kZXZpY2UoZGV2
KTsKPiAtCj4gLcKgwqDCoMKgwqDCoMKgLyogUGFpcnMgd2l0aCB0aGUgZ2V0IGluIG1kZXZfZGV2
aWNlX2NyZWF0ZSgpICovCj4gLcKgwqDCoMKgwqDCoMKga29iamVjdF9wdXQoJm1kZXYtPnR5cGUt
PmtvYmopOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBtZGV2X3BhcmVudCAqcGFyZW50ID0gbWRl
di0+dHlwZS0+cGFyZW50Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoG11dGV4X2xvY2soJm1kZXZf
bGlzdF9sb2NrKTsKPiDCoMKgwqDCoMKgwqDCoMKgbGlzdF9kZWwoJm1kZXYtPm5leHQpOwo+ICvC
oMKgwqDCoMKgwqDCoGlmICghcGFyZW50LT5tZGV2X2RyaXZlci0+Z2V0X2F2YWlsYWJsZSkKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXRvbWljX2luYygmcGFyZW50LT5hdmFpbGFi
bGVfaW5zdGFuY2VzKTsKPiDCoMKgwqDCoMKgwqDCoMKgbXV0ZXhfdW5sb2NrKCZtZGV2X2xpc3Rf
bG9jayk7Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqAvKiBQYWlycyB3aXRoIHRoZSBnZXQgaW4gbWRl
dl9kZXZpY2VfY3JlYXRlKCkgKi8KPiArwqDCoMKgwqDCoMKgwqBrb2JqZWN0X3B1dCgmbWRldi0+
dHlwZS0+a29iaik7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBkZXZfZGJnKCZtZGV2LT5kZXYsICJN
REVWOiBkZXN0cm95aW5nXG4iKTsKPiDCoMKgwqDCoMKgwqDCoMKga2ZyZWUobWRldik7Cj4gwqB9
Cj4gQEAgLTE0NCw2ICsxNDgsMTMgQEAgaW50IG1kZXZfZGV2aWNlX2NyZWF0ZShzdHJ1Y3QgbWRl
dl90eXBlICp0eXBlLAo+IGNvbnN0IGd1aWRfdCAqdXVpZCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gK8KgwqDCoMKgwqDCoMKg
aWYgKCFkcnYtPmdldF9hdmFpbGFibGUpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJnBhcmVudC0KPiA+YXZhaWxhYmxlX2luc3RhbmNl
cykpIHsKClRoaXMgaXMgc3RpbGwgYnJva2VuLgoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8y
MDIyMDcxOTE0NDgwOC5HQTIxNDMxQGxzdC5kZS8KClRoYW5rcywKRXJpYwoKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG11dGV4X3VubG9jaygmbWRldl9s
aXN0X2xvY2spOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FVVNFUlM7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiAr
wqDCoMKgwqDCoMKgwqB9Cj4gKwoK
