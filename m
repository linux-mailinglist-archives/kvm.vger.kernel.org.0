Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8DD651357
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 20:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiLSTfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 14:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiLSTfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 14:35:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4313612AFB;
        Mon, 19 Dec 2022 11:35:21 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJCApi001233;
        Mon, 19 Dec 2022 19:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1a9QoIKgSAlhaIt1YnO2DO2rb2crDXhJRDL9JtdvCKg=;
 b=kyUgf5GpXbINwXUtTQZzunKbNt6/WljgSi4jhmPXAKe5zmfK3fDG4KuvY4b9SikQhIYU
 3448N7KUo2a6pjTbPqvmxEUhIcx+CM6pK6CAu1i5q9s10Vnt6SjW/y24Tayk6xFnEGcX
 Qjzwt0Y5vcBNI8+FrdMkRmZTExdeG7IeMsCVMNeVjD8hINgDov/ZYM133OxcmKIwJYoy
 G+TOits5MIHpW+1wKFJqjc/DzRXieH5XNJzo0jtbZhQXnKEAJnsOb2zVFjEWeTqF7jf8
 Q6zxT7Y9wX6UyYBI9jtc8XDXKxNWTXKWJniF9/yV1odRkbEiJYTExZLKJzQDBlysI82D /Q== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjww98cgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:35:18 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJI34uh007487;
        Mon, 19 Dec 2022 19:31:37 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxfbek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:31:36 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJJVZ4340501532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:31:35 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A93558050;
        Mon, 19 Dec 2022 19:31:35 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85D558045;
        Mon, 19 Dec 2022 19:31:33 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 19:31:33 +0000 (GMT)
Message-ID: <7f898d8a9dcf73d70f2f99377549ae9ad3b98527.camel@linux.ibm.com>
Subject: Re: [PATCH v1 10/16] vfio/ccw: refactor the idaw counter
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
Date:   Mon, 19 Dec 2022 14:31:33 -0500
In-Reply-To: <a271f36b-0464-d14d-73ce-32603128ef05@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-11-farman@linux.ibm.com>
         <a271f36b-0464-d14d-73ce-32603128ef05@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NExO8nmskxUnAMbqLeqgUyPetvHIQ-8D
X-Proofpoint-GUID: NExO8nmskxUnAMbqLeqgUyPetvHIQ-8D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTE5IGF0IDE0OjE2IC0wNTAwLCBNYXR0aGV3IFJvc2F0byB3cm90ZToK
PiBPbiAxMS8yMS8yMiA0OjQwIFBNLCBFcmljIEZhcm1hbiB3cm90ZToKPiA+IFRoZSBydWxlcyBv
ZiBhbiBJREFXIGFyZSBmYWlybHkgc2ltcGxlOiBFYWNoIG9uZSBjYW4gbW92ZSBubwo+ID4gbW9y
ZSB0aGFuIGEgZGVmaW5lZCBhbW91bnQgb2YgZGF0YSwgbXVzdCBub3QgY3Jvc3MgdGhlCj4gPiBi
b3VuZGFyeSBkZWZpbmVkIGJ5IHRoYXQgbGVuZ3RoLCBhbmQgbXVzdCBiZSBhbGlnbmVkIHRvIHRo
YXQKPiA+IGxlbmd0aCBhcyB3ZWxsLiBUaGUgZmlyc3QgSURBVyBpbiBhIGxpc3QgaXMgc3BlY2lh
bCwgaW4gdGhhdAo+ID4gaXQgZG9lcyBub3QgbmVlZCB0byBhZGhlcmUgdG8gdGhhdCBhbGlnbm1l
bnQsIGJ1dCB0aGUgb3RoZXIKPiA+IHJ1bGVzIHN0aWxsIGFwcGx5LiBUaHVzLCBieSByZWFkaW5n
IHRoZSBmaXJzdCBJREFXIGluIGEgbGlzdCwKPiA+IHRoZSBudW1iZXIgb2YgSURBV3MgdGhhdCB3
aWxsIGNvbXByaXNlIGEgZGF0YSB0cmFuc2ZlciBvZiBhCj4gPiBwYXJ0aWN1bGFyIHNpemUgY2Fu
IGJlIGNhbGN1bGF0ZWQuCj4gPiAKPiA+IExldCdzIGZhY3RvciBvdXQgdGhlIHJlYWRpbmcgb2Yg
dGhhdCBmaXJzdCBJREFXIHdpdGggdGhlCj4gPiBsb2dpYyB0aGF0IGNhbGN1bGF0ZXMgdGhlIGxl
bmd0aCBvZiB0aGUgbGlzdCwgdG8gc2ltcGxpZnkKPiA+IHRoZSByZXN0IG9mIHRoZSByb3V0aW5l
IHRoYXQgaGFuZGxlcyB0aGUgaW5kaXZpZHVhbCBJREFXcy4KPiA+IAo+ID4gU2lnbmVkLW9mZi1i
eTogRXJpYyBGYXJtYW4gPGZhcm1hbkBsaW51eC5pYm0uY29tPgo+ID4gLS0tCj4gPiDCoGRyaXZl
cnMvczM5MC9jaW8vdmZpb19jY3dfY3AuYyB8IDM5ICsrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLQo+ID4gLS0tLQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgOSBk
ZWxldGlvbnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvczM5MC9jaW8vdmZpb19j
Y3dfY3AuYwo+ID4gYi9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2NwLmMKPiA+IGluZGV4IGEz
MGYyNjk2Mjc1MC4uMzRhMTMzZDk2MmQxIDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy9zMzkwL2Np
by92ZmlvX2Njd19jcC5jCj4gPiArKysgYi9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2NwLmMK
PiA+IEBAIC00OTYsMjMgKzQ5NiwyNSBAQCBzdGF0aWMgaW50IGNjd2NoYWluX2ZldGNoX3RpYyhz
dHJ1Y3QgY2N3MQo+ID4gKmNjdywKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVGQVVMVDsK
PiA+IMKgfQo+ID4gwqAKPiA+IC1zdGF0aWMgaW50IGNjd2NoYWluX2ZldGNoX2NjdyhzdHJ1Y3Qg
Y2N3MSAqY2N3LAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBwYWdlX2FycmF5ICpwYSwKPiA+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgY2hhbm5l
bF9wcm9ncmFtICpjcCkKPiA+ICsvKgo+ID4gKyAqIGNjd19jb3VudF9pZGF3cygpIC0gQ2FsY3Vs
YXRlIHRoZSBudW1iZXIgb2YgSURBV3MgbmVlZGVkIHRvCj4gPiB0cmFuc2Zlcgo+ID4gKyAqIGEg
c3BlY2lmaWVkIGFtb3VudCBvZiBkYXRhCj4gPiArICoKPiA+ICsgKiBAY2N3OiBUaGUgQ2hhbm5l
bCBDb21tYW5kIFdvcmQgYmVpbmcgdHJhbnNsYXRlZAo+ID4gKyAqIEBjcDogQ2hhbm5lbCBQcm9n
cmFtIGJlaW5nIHByb2Nlc3NlZAo+ID4gKyAqLwo+ID4gK3N0YXRpYyBpbnQgY2N3X2NvdW50X2lk
YXdzKHN0cnVjdCBjY3cxICpjY3csCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGNoYW5uZWxfcHJvZ3JhbSAqY3ApCj4gPiDCoHsK
PiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYgPQo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmY29udGFpbmVyX29mKGNwLCBzdHJ1Y3QgdmZpb19j
Y3dfcHJpdmF0ZSwgY3ApLQo+ID4gPnZkZXY7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgdTY0IGlvdmE7
Cj4gPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nICppZGF3czsKPiA+IMKgwqDCoMKgwqDC
oMKgwqBpbnQgcmV0Owo+ID4gwqDCoMKgwqDCoMKgwqDCoGludCBieXRlcyA9IDE7Cj4gPiAtwqDC
oMKgwqDCoMKgwqBpbnQgaWRhd19uciwgaWRhbF9sZW47Cj4gPiAtwqDCoMKgwqDCoMKgwqBpbnQg
aTsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGNjdy0+Y291bnQpCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ5dGVzID0gY2N3LT5jb3VudDsKPiA+IMKgCj4gPiAt
wqDCoMKgwqDCoMKgwqAvKiBDYWxjdWxhdGUgc2l6ZSBvZiBJREFMICovCj4gPiDCoMKgwqDCoMKg
wqDCoMKgaWYgKGNjd19pc19pZGFsKGNjdykpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyogUmVhZCBmaXJzdCBJREFXIHRvIHNlZSBpZiBpdCdzIDRLLWFsaWduZWQgb3IK
PiA+IG5vdC4gKi8KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogQWxsIHN1
YnNlcXVlbnQgSURBd3Mgd2lsbCBiZSA0Sy1hbGlnbmVkLiAqLwo+ID4gQEAgLTUyMiw3ICs1MjQs
MjYgQEAgc3RhdGljIGludCBjY3djaGFpbl9mZXRjaF9jY3coc3RydWN0IGNjdzEKPiA+ICpjY3cs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaW92YSA9IGNjdy0+Y2RhOwo+ID4gwqDCoMKgwqDCoMKgwqDCoH0KPiA+IC3CoMKg
wqDCoMKgwqDCoGlkYXdfbnIgPSBpZGFsX25yX3dvcmRzKCh2b2lkICopaW92YSwgYnl0ZXMpOwo+
ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIGlkYWxfbnJfd29yZHMoKHZvaWQgKilpb3Zh
LCBieXRlcyk7Cj4gPiArfQo+ID4gKwo+ID4gK3N0YXRpYyBpbnQgY2N3Y2hhaW5fZmV0Y2hfY2N3
KHN0cnVjdCBjY3cxICpjY3csCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHBhZ2VfYXJyYXkgKnBhLAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBjaGFubmVsX3Byb2dyYW0gKmNwKQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB2
ZmlvX2RldmljZSAqdmRldiA9Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgJmNv
bnRhaW5lcl9vZihjcCwgc3RydWN0IHZmaW9fY2N3X3ByaXZhdGUsIGNwKS0KPiA+ID52ZGV2Owo+
ID4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyAqaWRhd3M7Cj4gPiArwqDCoMKgwqDCoMKg
wqBpbnQgcmV0Owo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IGlkYXdfbnIsIGlkYWxfbGVuOwo+ID4g
K8KgwqDCoMKgwqDCoMKgaW50IGk7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqAvKiBDYWxjdWxh
dGUgc2l6ZSBvZiBJREFMICovCj4gPiArwqDCoMKgwqDCoMKgwqBpZGF3X25yID0gY2N3X2NvdW50
X2lkYXdzKGNjdywgY3ApOwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGlkYXdfbnIgPCAwKQo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBpZGF3X25yOwo+ID4gKwo+IAo+
IFdoYXQgYWJvdXQgaWYgd2UgZ2V0IGEgMCBiYWNrIGZyb20gY2N3X2NvdW50X2lkYXdzP8KgwqAg
VGhlIG5leHQgdGhpbmcKPiB3ZSdyZSBnb2luZyB0byBkbyAobm90IHNob3duIGhlcmUpIGlzIGtj
YWxsb2MoMCwgc2l6ZW9mKCppZGF3cykpLAo+IHdoaWNoIEkgdGhpbmsgbWVhbnMgeW91J2xsIGdl
dCBiYWNrIFpFUk9fU0laRV9QVFIsIG5vdCBhIG51bGwKPiBwb2ludGVyLgoKV2hpbGUgaXQncyB0
cnVlIHRoYXQgdGhlIGlkYWxfbnJfd29yZHMgcm91dGluZXMgY291bGQgcmV0dXJuIHplcm8sIEkK
ZG9uJ3Qgc2VlIGhvdyB0aGUgY2N3X2NvdW50X2lkYXdzIHJvdXRpbmUgd2hpY2ggY2FsbHMgaXQg
Y291bGQgZG8gdGhlCnNhbWUuIFdlIGFkZGVkIGEgY2hlY2sgZm9yIGEgemVybyBkYXRhIGNvdW50
IHdpdGggY29tbWl0IDQ1M2VhYzMxMjQ0NWUKKCJzMzkwL2NpbzogQWxsb3cgemVyby1sZW5ndGgg
Q0NXcyBpbiB2ZmlvLWNjdyIpLCBzdWNoIHRoYXQgYSBDQ1cgdGhhdApoYXMgbm8gbGVuZ3RoIHdp
bGwgY2F1c2UgdXMgdG8gYWxsb2NhdGUgLXNvbWV0aGluZy0gdGhhdCB3b3VsZCBiZSB2YWxpZApm
b3IgdGhlIGNoYW5uZWwgdG8gdXNlLCBldmVuIGlmIGl0J3Mgbm90IGdvaW5nIHRvIHB1dCBhbnl0
aGluZyBpbi9vdXQKb2YgaXQuCgo+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoGlkYWxfbGVuID0gaWRh
d19uciAqIHNpemVvZigqaWRhd3MpOwo+ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKiBBbGxv
Y2F0ZSBhbiBJREFMIGZyb20gaG9zdCBzdG9yYWdlICovCj4gPiBAQCAtNTU1LDcgKzU3Niw3IEBA
IHN0YXRpYyBpbnQgY2N3Y2hhaW5fZmV0Y2hfY2N3KHN0cnVjdCBjY3cxICpjY3csCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBpZGF3X25yOyBpKysp
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYS0+
cGFfaW92YVtpXSA9IGlkYXdzW2ldOwo+ID4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGEtPnBhX2lvdmFbMF0gPSBpb3ZhOwo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhLT5wYV9pb3ZhWzBdID0gY2N3LT5jZGE7
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDE7IGkgPCBwYS0+
cGFfbnI7IGkrKykKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHBhLT5wYV9pb3ZhW2ldID0gcGEtPnBhX2lvdmFbaSAtIDFdICsKPiA+IFBBR0VfU0la
RTsKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gCgo=

