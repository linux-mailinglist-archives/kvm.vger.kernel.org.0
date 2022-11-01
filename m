Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273C0614C3A
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiKAOGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiKAOGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:06:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D0A1A3B9;
        Tue,  1 Nov 2022 07:06:32 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1DsTbF002180;
        Tue, 1 Nov 2022 14:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=l16TtlhzB0Pcdi0ERi9GHqw9z75F7QJ6/wkkLykF1XM=;
 b=ng31r5Fu5tu2x0uCZqUJCHFp2RtvIACjBlF+cHG97I7rHk1Sjnh1zL1RhIsvICdhJrVy
 ssIL29OY2fmS9xMQdXr7WRz8PG+6yJoJ5hkaNLiRZLmjTTNPdVoDwugw/lVbJooZMnpa
 EPxc/aZ8SGnbemTZ/oaVpgkTbfm1XEuq2qMRRWEuhrwYeJZA35988YdJSPTvbSBFSIvC
 j1uvnCCRtZPLut6VBGByqOR0gGMl3BjpEU7AoKZvc8yKw6cFQs67AUi3dPoNhMHnFf6S
 FXHnu3nAx3SoZhJjsot3lbKq5cb5M5Frf9SudRZXe44xtwGZFa39oVvGABEAloUX9Eqz Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjwjj64hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 14:06:01 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A1DVaqv012245;
        Tue, 1 Nov 2022 14:06:00 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjwjj64gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 14:06:00 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A1DoDJo028785;
        Tue, 1 Nov 2022 14:05:59 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 3kgut9mfph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 14:05:59 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A1E5v5N4915906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Nov 2022 14:05:57 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A81B58065;
        Tue,  1 Nov 2022 14:05:58 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A93958043;
        Tue,  1 Nov 2022 14:05:55 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Nov 2022 14:05:54 +0000 (GMT)
Message-ID: <079b2810baecce3eff38cc7961271b287823e800.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/7] vfio/ccw: move private to mdev lifecycle
From:   Eric Farman <farman@linux.ibm.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Tue, 01 Nov 2022 10:05:54 -0400
In-Reply-To: <BN9PR11MB527698B0A9E039268916AA018C369@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221019162135.798901-1-farman@linux.ibm.com>
         <20221019162135.798901-5-farman@linux.ibm.com>
         <BN9PR11MB527698B0A9E039268916AA018C369@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NYVMrctPKlGfItI3yDVl_9l2p63-4PZ0
X-Proofpoint-GUID: cbuwLFw51-qcHmaGvehXbCCd2yVkJUsd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_07,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211010106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTAxIGF0IDA5OjA4ICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToKPiA+
IEZyb206IEVyaWMgRmFybWFuIDxmYXJtYW5AbGludXguaWJtLmNvbT4KPiA+IFNlbnQ6IFRodXJz
ZGF5LCBPY3RvYmVyIDIwLCAyMDIyIDEyOjIyIEFNCj4gPiAKPiA+IEBAIC0xMDEsMTUgKzEwMSwy
MCBAQCBzdGF0aWMgaW50IHZmaW9fY2N3X21kZXZfcHJvYmUoc3RydWN0Cj4gPiBtZGV2X2Rldmlj
ZSAqbWRldikKPiA+IMKgewo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBzdWJjaGFubmVsICpz
Y2ggPSB0b19zdWJjaGFubmVsKG1kZXYtPmRldi5wYXJlbnQpOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCB2ZmlvX2Njd19wYXJlbnQgKnBhcmVudCA9IGRldl9nZXRfZHJ2ZGF0YSgmc2NoLQo+
ID4gPmRldik7Cj4gPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdmZpb19jY3dfcHJpdmF0ZSAqcHJp
dmF0ZSA9IGRldl9nZXRfZHJ2ZGF0YSgmcGFyZW50LQo+ID4gPmRldik7Cj4gPiArwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgdmZpb19jY3dfcHJpdmF0ZSAqcHJpdmF0ZTsKPiA+IMKgwqDCoMKgwqDCoMKg
wqBpbnQgcmV0Owo+ID4gCj4gPiAtwqDCoMKgwqDCoMKgwqBpZiAocHJpdmF0ZS0+c3RhdGUgPT0g
VkZJT19DQ1dfU1RBVEVfTk9UX09QRVIpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FTk9ERVY7Cj4gCj4gTm90IGZhbWlsaWFyIHdpdGggY2N3IGJ1dCBqdXN0IHdh
bnQgdG8gZG91YmxlIGNvbmZpcm0gdGhpcyByZW1vdmFsCj4gaXMgaW50ZW50aW9uYWwgdy9vIHNp
ZGUtZWZmZWN0PwoKUmlnaHQsIGl0J3MgaW50ZW50aW9uYWwgYW5kIGZpbmUuIFRoZSBjb25jZXJu
IHByZXZpb3VzbHkgd2FzIHJlLXByb2JpbmcKdGhlIG1kZXYgd2hlbiBhIGRldmljZSBoYWQgZ29u
ZSBpbnRvIGEgbm9uLXJlY292ZXJhYmxlIHN0YXRlIGFuZCB0aGUKcHJpdmF0ZSBkYXRhIHdhcyBs
ZWZ0IGhhbmdpbmcgYXJvdW5kLiBXaXRoIHRoZSBwcml2YXRlIG5vdyBiZWluZwpjbGVhbmVkIHVw
IGluIG1kZXZfcmVtb3ZlIGluc3RlYWQgb2YgdGhlIHN1YmNoYW5uZWwgc2lkZSwgdGhhdCdzIG5v
CmxvbmdlciBhbiBpc3N1ZS4KCj4gCj4gPiArwqDCoMKgwqDCoMKgwqBwcml2YXRlID0gdmZpb19j
Y3dfYWxsb2NfcHJpdmF0ZShzY2gpOwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCFwcml2YXRlKQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PTUVNOwo+ID4gCj4g
PiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gdmZpb19pbml0X2RldmljZSgmcHJpdmF0ZS0+dmRldiwg
Jm1kZXYtPmRldiwKPiA+ICZ2ZmlvX2Njd19kZXZfb3BzKTsKPiA+IC3CoMKgwqDCoMKgwqDCoGlm
IChyZXQpCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmV0KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKga2ZyZWUocHJpdmF0ZSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiArCj4gPiArwqDC
oMKgwqDCoMKgwqBkZXZfc2V0X2RydmRhdGEoJnBhcmVudC0+ZGV2LCBwcml2YXRlKTsKPiA+IAo+
ID4gwqDCoMKgwqDCoMKgwqDCoFZGSU9fQ0NXX01TR19FVkVOVCgyLCAic2NoICV4LiV4LiUwNHg6
IGNyZWF0ZVxuIiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc2NoLT5zY2hpZC5jc3NpZCwKPiA+IEBAIC0xMjMsNiArMTI4LDcgQEAgc3Rh
dGljIGludCB2ZmlvX2Njd19tZGV2X3Byb2JlKHN0cnVjdAo+ID4gbWRldl9kZXZpY2UKPiA+ICpt
ZGV2KQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+ID4gCj4gPiDCoGVycl9wdXRfdmRl
djoKPiA+ICvCoMKgwqDCoMKgwqDCoGRldl9zZXRfZHJ2ZGF0YSgmcGFyZW50LT5kZXYsIE5VTEwp
Owo+IAo+IE5vIG5lZWQgdG8gc2V0IGRydmRhdGEgdG8gTlVMTCwgaWl1YwoKRmFpci4K

