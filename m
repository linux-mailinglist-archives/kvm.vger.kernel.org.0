Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526DD75821D
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjGRQbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjGRQbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:31:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04356E77
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:31:21 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IGLEkM002012;
        Tue, 18 Jul 2023 16:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=viCJs7dIgQEH5vfIlayD9iQph1ly3ILoOWjMw3Xq/vc=;
 b=PaVDjpXwsvM/yCw/svVnSH35NvZAVP27y10QiGr03Q1i08NUcmu/Kx6ihkwZH3XE7gaa
 9BslbYdWA9CbyJcanUaGNx/38S9rTld8YPLG8W1+ConaTqWU0D8GMIykXAbJEAFXUgEe
 UnDNLMzAlhE+6+YPh8wJgIXlMN8ilzf3XklMeSHcq4XwQ0jKwM9OINTK3eAPQeXPePcB
 eUNnQkDF34/8VZaRcvvWRQc4WDeoP7Ne9wBG7OavinDCuHzW0ijL4/fYpZCIUx7B5IW/
 XQArndpgU5lBYQUPwW4hWOttDdDzj1kHGSbvnEnvCf6C/N6n81XHNX1ynK9rtHdGgbON EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwx6b879m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 16:31:08 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36IGMKMZ004759;
        Tue, 18 Jul 2023 16:31:08 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwx6b8794-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 16:31:08 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36IEIGbN029098;
        Tue, 18 Jul 2023 16:31:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv6smdhhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 16:31:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36IGV3vL61800766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 16:31:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B29A20040;
        Tue, 18 Jul 2023 16:31:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F48020043;
        Tue, 18 Jul 2023 16:31:02 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.14.18])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jul 2023 16:31:01 +0000 (GMT)
Message-ID: <9c8847ad9d8e07c2e41f9c20716ba3ed6dd6b3dc.camel@linux.ibm.com>
Subject: Re: [PATCH v21 01/20] s390x/cpu topology: add s390 specifics to CPU
 topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 18 Jul 2023 18:31:01 +0200
In-Reply-To: <20230630091752.67190-2-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oQxSeuEKqCgjdqdGVTq6oP4Gb2ndvhHY
X-Proofpoint-ORIG-GUID: w8rvYo7t5ppFyk_6ZHXbjVJxYhcqUiwW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_12,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307180148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ClJldmlld2VkLWJ5OiBOaW5hIFNjaG9ldHRlcmwtR2xhdXNjaCA8bnNnQGxpbnV4LmlibS5jb20+
CgpTb21lIG5vdGVzIGJlbG93LgoKVGhlIHMzOTB4LyBwcmVmaXggaW4gdGhlIHRpdGxlIG1pZ2h0
IHN1Z2dlc3QgdGhhdCB0aGlzIHBhdGNoCmlzIHMzOTAgc3BlY2lmaWMsIGJ1dCBpdCB0b3VjaGVz
IGNvbW1vbiBmaWxlcy4KCk9uIEZyaSwgMjAyMy0wNi0zMCBhdCAxMToxNyArMDIwMCwgUGllcnJl
IE1vcmVsIHdyb3RlOgo+IFMzOTAgYWRkcyB0d28gbmV3IFNNUCBsZXZlbHMsIGRyYXdlcnMgYW5k
IGJvb2tzIHRvIHRoZSBDUFUKPiB0b3BvbG9neS4KPiBUaGUgUzM5MCBDUFUgaGF2ZSBzcGVjaWZp
YyB0b3BvbG9neSBmZWF0dXJlcyBsaWtlIGRlZGljYXRpb24KClMzOTAgQ1BVcyBoYXZlIHNwZWNp
ZmljIHRvcG9sb2d5IGZlYXR1cmVzIGxpa2UgZGVkaWNhdGlvbiBhbmQKZW50aXRsZW1lbnQuIFRo
ZXNlIGluZGljYXRlIHRvIHRoZSBndWVzdCBpbmZvcm1hdGlvbiBvbiBob3N0CnZDUFUgc2NoZWR1
bGluZyBhbmQgaGVscCB0aGUgZ3Vlc3QgbWFrZSBiZXR0ZXIgc2NoZWR1bGluZyBkZWNpc2lvbnMu
Cgo+IGFuZCBlbnRpdGxlbWVudCB0byBnaXZlIHRvIHRoZSBndWVzdCBpbmRpY2F0aW9ucyBvbiB0
aGUgaG9zdAo+IHZDUFVzIHNjaGVkdWxpbmcgYW5kIGhlbHAgdGhlIGd1ZXN0IHRha2UgdGhlIGJl
c3QgZGVjaXNpb25zCj4gb24gdGhlIHNjaGVkdWxpbmcgb2YgdGhyZWFkcyBvbiB0aGUgdkNQVXMu
Cj4gCj4gTGV0IHVzIHByb3ZpZGUgdGhlIFNNUCBwcm9wZXJ0aWVzIHdpdGggYm9va3MgYW5kIGRy
YXdlcnMgbGV2ZWxzCj4gYW5kIFMzOTAgQ1BVIHdpdGggZGVkaWNhdGlvbiBhbmQgZW50aXRsZW1l
bnQsCj4gCj4gU2lnbmVkLW9mZi1ieTogUGllcnJlIE1vcmVsIDxwbW9yZWxAbGludXguaWJtLmNv
bT4KPiAtLS0KPiDCoHFhcGkvbWFjaGluZS1jb21tb24uanNvbsKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfCAyMiArKysrKysrKysrKysrCj4gwqBxYXBpL21hY2hpbmUuanNvbsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIxICsrKysrKysrKystLS0KPiDCoGluY2x1ZGUvaHcv
Ym9hcmRzLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDEwICsrKysrLQo+IMKg
aW5jbHVkZS9ody9xZGV2LXByb3BlcnRpZXMtc3lzdGVtLmggfMKgIDQgKysrCj4gwqB0YXJnZXQv
czM5MHgvY3B1LmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA2ICsrKysK
PiDCoGh3L2NvcmUvbWFjaGluZS1zbXAuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA0
OCArKysrKysrKysrKysrKysrKysrKysrKystLS0KPiAtLQo+IMKgaHcvY29yZS9tYWNoaW5lLmPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKysrCj4gwqBody9jb3Jl
L3FkZXYtcHJvcGVydGllcy1zeXN0ZW0uY8KgwqDCoCB8IDEzICsrKysrKysrCj4gwqBody9zMzkw
eC9zMzkwLXZpcnRpby1jY3cuY8KgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArKwo+IMKgc29mdG1t
dS92bC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
NiArKysrCj4gwqB0YXJnZXQvczM5MHgvY3B1LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoCA3ICsrKysrCj4gwqBxYXBpL21lc29uLmJ1aWxkwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDEgKwo+IMKgcWVtdS1vcHRpb25zLmh4wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNyArKystLQo+IMKgMTMgZmlsZXMg
Y2hhbmdlZCwgMTM3IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQo+IMKgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHFhcGkvbWFjaGluZS1jb21tb24uanNvbgo+IAo+IGRpZmYgLS1naXQgYS9xYXBp
L21hY2hpbmUtY29tbW9uLmpzb24gYi9xYXBpL21hY2hpbmUtY29tbW9uLmpzb24KPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NAo+IGluZGV4IDAwMDAwMDAwMDAuLmJjMGQ3NjgyOWMKPiAtLS0gL2Rldi9u
dWxsCj4gKysrIGIvcWFwaS9tYWNoaW5lLWNvbW1vbi5qc29uCj4gQEAgLTAsMCArMSwyMiBAQAo+
ICsjIC0qLSBNb2RlOiBQeXRob24gLSotCj4gKyMgdmltOiBmaWxldHlwZT1weXRob24KPiArIwo+
ICsjIFRoaXMgd29yayBpcyBsaWNlbnNlZCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHUEws
IHZlcnNpb24gMiBvcgo+IGxhdGVyLgo+ICsjIFNlZSB0aGUgQ09QWUlORyBmaWxlIGluIHRoZSB0
b3AtbGV2ZWwgZGlyZWN0b3J5Lgo+ICsKPiArIyMKPiArIyA9IE1hY2hpbmVzIFMzOTAgZGF0YSB0
eXBlcwoKQ29tbW9uIGRlZmluaXRpb25zIGZvciBtYWNoaW5lLmpzb24gYW5kIG1hY2hpbmUtdGFy
Z2V0Lmpzb24KCgpbLi4uXQo=

