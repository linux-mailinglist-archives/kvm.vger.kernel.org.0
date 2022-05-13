Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019F0526288
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 15:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380522AbiEMNDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 09:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbiEMNDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 09:03:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFEC45AF6;
        Fri, 13 May 2022 06:03:18 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DD3Bpe028572;
        Fri, 13 May 2022 13:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xZDQ9X6w33ICFI97+81tkcewi1BWYgVFDHwGGGIZCQc=;
 b=OKKSfJ5DK2QxHk9TBz3zIHbMrhRLXgOQUuSZL8uj2FOHLZegIoVaKZyYBDjxPIErP8ms
 /00mG7x3m1iM2k9t7z7THRShmNezoBnD3P5r/ro1JASgx/LC7/phN4B45MdTrQryXv/G
 8EZxfCaKj+LSGgCsNjPO7QKAPDAn/Zh9rCecuBEjikn/wid7gUw6xo+Mf16t6MH6SEmZ
 7eTKHve71K5o2q3FjJ9wG4KFVGFINxVx2sqZhOe2T+a4YEz9QcRr/wNNXw/Me1fcSVCY
 0gBHGxR45MvkUxpGkoFMP7DRuJLQwXabj2CZXpfnQl8e4a7eA1l5tTQtp2Zsplvj6K0x xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbgvf4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:03:17 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DCe9qe029545;
        Fri, 13 May 2022 13:03:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbgver9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:03:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DCvvkS028737;
        Fri, 13 May 2022 13:02:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g0ma1j4rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:02:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DD256w35258694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 13:02:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB7BA4C040;
        Fri, 13 May 2022 13:02:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BDA24C04E;
        Fri, 13 May 2022 13:02:28 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.152.224.44])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 13:02:28 +0000 (GMT)
Message-ID: <d046932759b2917fb75b3f60efe9707a32ef509d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Fri, 13 May 2022 15:02:28 +0200
In-Reply-To: <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
         <20220512140107.1432019-3-nrb@linux.ibm.com>
         <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VPrsUESkJCEB2V5P51YxAOzO25-attfw
X-Proofpoint-ORIG-GUID: K1JCMNjkvNIyQLa6Y4S4Tz1evTt-FK90
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTA1LTEzIGF0IDEzOjA0ICswMjAwLCBKYW5pcyBTY2hvZXR0ZXJsLUdsYXVz
Y2ggd3JvdGU6ClsuLi5dCj4gPiBkaWZmIC0tZ2l0IGEvczM5MHgvbWlncmF0aW9uLXNrZXkuYyBi
L3MzOTB4L21pZ3JhdGlvbi1za2V5LmMKPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0Cj4gPiBpbmRl
eCAwMDAwMDAwMDAwMDAuLjZmMzA1M2Q4YWI0MAo+ID4gLS0tIC9kZXYvbnVsbAo+ID4gKysrIGIv
czM5MHgvbWlncmF0aW9uLXNrZXkuYwpbLi4uXQo+ID4gK3N0YXRpYyB2b2lkIHRlc3RfbWlncmF0
aW9uKHZvaWQpCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IGksIGtleV90b19zZXQ7Cj4g
PiArwqDCoMKgwqDCoMKgwqB1aW50OF90ICpwYWdlOwo+ID4gK8KgwqDCoMKgwqDCoMKgdW5pb24g
c2tleSBleHBlY3RlZF9rZXksIGFjdHVhbF9rZXksIG1pc21hdGNoaW5nX2tleTsKPiAKPiBJIHdv
dWxkIHRlbmQgdG8gc2NvcGUgdGhvc2UgdG8gdGhlIGJvZGllcyBvZiB0aGUgcmVzcGVjdGl2ZSBs
b29wLAo+IGJ1dCBJIGRvbid0IGtub3cgaWYgdGhhdCdzIGluIGFjY29yZGFuY2Ugd2l0aCB0aGUg
Y29kaW5nIHN0eWxlLgoKU2VlbXMgdG8gbWUgdGhlIG1vcmUgY29tbW9uIHRoaW5nIGlzIHRvIGRl
Y2xhcmUgdmFyaWFibGVzIG91dHNpZGUuIEJ1dCBzdXJlIGNhbiBjaGFuZ2UgdGhhdCwgd2hhdCBk
byB0aGUgbWFpbnRhaW5lcnMgc2F5PwoKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9
IDA7IGkgPCBOVU1fUEFHRVM7IGkrKykgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoC8qCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogU3RvcmFnZSBrZXlz
IGFyZSA3IGJpdCwgbG93ZXN0IGJpdCBpcyBhbHdheXMKPiA+IHJldHVybmVkIGFzIHplcm8KPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBieSBpc2tlCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKga2V5X3RvX3NldCA9IGkgKiAyOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHNldF9zdG9yYWdlX2tleShwYWdlYnVmICsgaSwga2V5X3RvX3NldCwgMSk7Cj4gCj4gV2h5IG5v
dCBqdXN0IHBhZ2VidWZbaV0/CgpXb3JrcyBhcyB3ZWxsIGFuZCBsb29rcyBuaWNlciwgY2hhbmdl
ZCwgdGhhbmtzLgoKWy4uLl0KPiA+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBOVU1f
UEFHRVM7IGkrKykgewpbLi4uXQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGV4
cGVjdF9wZ21faW50KCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXNtIHZv
bGF0aWxlICgKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgLyogc2V0IGFjY2VzcyBrZXkgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgInNwa2EgMCglW21pc21hdGNoaW5nX2tleV0pXG4iCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIHRyeSB0byB3cml0
ZSBwYWdlICovCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCJtdmkgMCglW3BhZ2VdKSwgNDJcbiIKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogcmVzZXQgYWNjZXNzIGtleSAqLwo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAic3BrYSAwXG4iCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDoKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOiBbbWlzbWF0Y2hpbmdfa2V5
XQo+ID4gImEiKG1pc21hdGNoaW5nX2tleS52YWwpLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBbcGFnZV0gImEiKHBhZ2UpCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDogIm1lbW9yeSIKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqApOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGNoZWNrX3BnbV9pbnRfY29kZV94ZmFpbChob3N0X2lzX3RjZygpLAo+ID4gUEdN
X0lOVF9DT0RFX1BST1RFQ1RJT04pOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJlcG9ydF94ZmFpbChob3N0X2lzX3RjZygpLCAqcGFnZSA9PSAweGZmLCAibm8KPiA+IHN0b3Jl
IG9jY3VyZWQiKTsKPiAKPiBXaGF0IGFyZSB5b3UgdGVzdGluZyB3aXRoIHRoaXMgYml0PyBJZiBz
dG9yYWdlIGtleXMgYXJlIHJlYWxseQo+IGVmZmVjdGl2ZSBhZnRlciB0aGUgbWlncmF0aW9uPwoK
WWVzLgoKPiBJJ20gd29uZGVyaW5nIGlmIHVzaW5nIHRwcm90IHdvdWxkIG5vdCBiZSBiZXR0ZXIs
IGl0IHNob3VsZCBzaW1wbGlmeQo+IHRoZSBjb2RlIGEgbG90LgoKSG1tLCBnb29kIHBvaW50LiBJ
ZiBJIGFtIG5vdCBtaXN0YWtlbiwgdHByb3QgaXMgaW50ZXJjZXB0ZWQsIGFtIEk/IFRoZW4gaXQg
bWlnaHQgbWFrZSBzZW5zZSB0byBhY3R1YWxseSBkbyBib3RoLCB3b24ndCBpdD8KCj4gUGx1cyB5
b3UnZCBlYXNpbHkgdGVzdCBmb3IgZmV0Y2ggcHJvdGVjdGlvbiwgdG9vLgo+ID4gKwo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlcG9ydF9wcmVmaXhfcG9wKCk7Cj4gPiArwqDC
oMKgwqDCoMKgwqB9Cj4gPiArfQo+ID4gKwo+ID4gK2ludCBtYWluKHZvaWQpCj4gPiArewo+ID4g
K8KgwqDCoMKgwqDCoMKgcmVwb3J0X3ByZWZpeF9wdXNoKCJtaWdyYXRpb24tc2tleSIpOwo+ID4g
K8KgwqDCoMKgwqDCoMKgaWYgKHRlc3RfZmFjaWxpdHkoMTY5KSkgewo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJlcG9ydF9za2lwKCJzdG9yYWdlIGtleSByZW1vdmFsIGZhY2ls
aXR5IGlzCj4gPiBhY3RpdmUiKTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAvKgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIElmIHdlIGp1c3Qg
ZXhpdCBhbmQgZG9uJ3QgYXNrIG1pZ3JhdGVfY21kIHRvCj4gPiBtaWdyYXRlIHVzLCBpdAo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHdpbGwganVzdCBoYW5nIGZvcmV2ZXIu
IEhlbmNlLCBhbHNvIGFzayBmb3IKPiA+IG1pZ3JhdGlvbiB3aGVuIHdlCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICogc2tpcCB0aGlzIHRlc3QgYWxsdG9nZXRoZXIuCj4gCj4g
cy9hbGx0b2dldGhlci9hbHRvZ2V0aGVyLwoKVGhhbmtzIGZpeGVkLgoK

