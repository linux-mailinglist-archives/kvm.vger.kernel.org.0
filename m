Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB959EC32
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 21:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiHWTYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 15:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiHWTYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 15:24:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B1F23E6;
        Tue, 23 Aug 2022 11:07:15 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHiEES031317;
        Tue, 23 Aug 2022 18:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EwaVm2NJTofcuHHxHngme5VdfjnMH6pW4w0FFrj3vWA=;
 b=cir8IFZlB4LkjQQv3qFnwLCGcczUzjbF2X33UxZpdtK9JcWi2902jD94Bb9GvRW+D+JU
 6ShEsZuAPr8Dy7qAqms83co/3yivwCT2hIxexwTibqU7EeMe0eBApaF9hgoJe7D31ief
 vhMXPR7Al8ziD3L/N6YVGD/fbW1qKvTgZvQ+Zot25fu0+oSQWNiMFbsxWHQoQkXVzLlQ
 RuwPGf/DetnvM1G7OX/a5y648zwjBF/RluzFOR2E/Zlt2bZjn5OcvqUk7QJHjczFktPj
 hhx3en+Jb3I35vtMGNgw5rpbQaBnLy4OXOnnl+QN2fS+pT1OH/lR5XP30TgmugblwL4p +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53j00s5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NHwjVd007540;
        Tue, 23 Aug 2022 18:07:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53j00s40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NHprkY013833;
        Tue, 23 Aug 2022 18:07:05 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3j2q89sk9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:07:05 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NI746L15139366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 18:07:04 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E3C47805E;
        Tue, 23 Aug 2022 18:07:04 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC0127805C;
        Tue, 23 Aug 2022 18:07:02 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.161.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 18:07:02 +0000 (GMT)
Message-ID: <83cce81d95cf85468f9ac2aabda495b0cf20e1ca.camel@linux.ibm.com>
Subject: Re: [PATCH 05/14] vfio/mdev: simplify mdev_type handling
From:   Eric Farman <farman@linux.ibm.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>, Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Date:   Tue, 23 Aug 2022 14:07:02 -0400
In-Reply-To: <DM4PR11MB5502308793A102A470A91CF888709@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20220822062208.152745-1-hch@lst.de>
         <20220822062208.152745-6-hch@lst.de>
         <DM4PR11MB5502308793A102A470A91CF888709@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M5XMVOltWIDwECGQjHdj2uKvZL0KXFGk
X-Proofpoint-ORIG-GUID: KbQSwOwmJD6CID-BtJfSJ7KGXjMQBxN1
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTIzIGF0IDA1OjUzICswMDAwLCBaZW5nLCBYaW4gd3JvdGU6Cj4gT24g
TW9uZGF5LCBBdWd1c3QgMjIsIDIwMjIgMjoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+Cj4gd3JvdGU6Cj4gCj4gPiDCoC8qCj4gPiDCoCAqIFVzZWQgaW4gbWRldl90eXBlX2F0
dHJpYnV0ZSBzeXNmcyBmdW5jdGlvbnMgdG8gcmV0dXJuIHRoZQo+ID4gcGFyZW50IHN0cnVjdAo+
ID4gwqAgKiBkZXZpY2UKPiA+IEBAIC04NSw2ICs2NSw4IEBAIHN0YXRpYyBpbnQgbWRldl9kZXZp
Y2VfcmVtb3ZlX2NiKHN0cnVjdCBkZXZpY2UKPiA+ICpkZXYsCj4gPiB2b2lkICpkYXRhKQo+ID4g
wqAgKiBAcGFyZW50OiBwYXJlbnQgc3RydWN0dXJlIHJlZ2lzdGVyZWQKPiA+IMKgICogQGRldjog
ZGV2aWNlIHN0cnVjdHVyZSByZXByZXNlbnRpbmcgcGFyZW50IGRldmljZS4KPiA+IMKgICogQG1k
ZXZfZHJpdmVyOiBEZXZpY2UgZHJpdmVyIHRvIGJpbmQgdG8gdGhlIG5ld2x5IGNyZWF0ZWQgbWRl
dgo+ID4gKyAqIEB0eXBlczogQXJyYXkgb2Ygc3VwcG9ydGVkIG1kZXYgdHlwZXMKPiA+ICsgKiBA
bnJfdHlwZXM6IE51bWJlciBvZiBlbnRyaWVzIGluIEB0eXBlcwo+ID4gwqAgKgo+ID4gwqAgKiBS
ZWdpc3RlcnMgdGhlIEBwYXJlbnQgc3R1Y3R1cmUgYXMgYSBwYXJlbnQgZm9yIG1kZXYgdHlwZXMg
YW5kCj4gPiB0aHVzIG1kZXYKPiA+IMKgICogZGV2aWNlcy7CoCBUaGUgY2FsbGVyIG5lZWRzIHRv
IGhvbGQgYSByZWZlcmVuY2Ugb24gQGRldiB0aGF0Cj4gPiBtdXN0IG5vdCBiZQo+ID4gQEAgLTkz
LDIwICs3NSwxOSBAQCBzdGF0aWMgaW50IG1kZXZfZGV2aWNlX3JlbW92ZV9jYihzdHJ1Y3QgZGV2
aWNlCj4gPiAqZGV2LCB2b2lkICpkYXRhKQo+ID4gwqAgKiBSZXR1cm5zIGEgbmVnYXRpdmUgdmFs
dWUgb24gZXJyb3IsIG90aGVyd2lzZSAwLgo+ID4gwqAgKi8KPiA+IMKgaW50IG1kZXZfcmVnaXN0
ZXJfcGFyZW50KHN0cnVjdCBtZGV2X3BhcmVudCAqcGFyZW50LCBzdHJ1Y3QgZGV2aWNlCj4gPiAq
ZGV2LAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBtZGV2X2RyaXZl
ciAqbWRldl9kcml2ZXIpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0
IG1kZXZfZHJpdmVyICptZGV2X2RyaXZlciwgc3RydWN0IG1kZXZfdHlwZQo+ID4gKip0eXBlcywK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgbnJfdHlwZXMp
Cj4gPiDCoHsKPiA+IMKgwqDCoMKgwqDCoMKgwqBjaGFyICplbnZfc3RyaW5nID0gIk1ERVZfU1RB
VEU9cmVnaXN0ZXJlZCI7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgY2hhciAqZW52cFtdID0geyBlbnZf
c3RyaW5nLCBOVUxMIH07Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiA+IAo+ID4gLcKg
wqDCoMKgwqDCoMKgLyogY2hlY2sgZm9yIG1hbmRhdG9yeSBvcHMgKi8KPiA+IC3CoMKgwqDCoMKg
wqDCoGlmICghbWRldl9kcml2ZXItPnN1cHBvcnRlZF90eXBlX2dyb3VwcykKPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiA+IC0KPiA+IMKgwqDCoMKg
wqDCoMKgwqBtZW1zZXQocGFyZW50LCAwLCBzaXplb2YoKnBhcmVudCkpOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoGluaXRfcndzZW0oJnBhcmVudC0+dW5yZWdfc2VtKTsKPiA+IMKgwqDCoMKgwqDCoMKg
wqBwYXJlbnQtPmRldiA9IGRldjsKPiA+IMKgwqDCoMKgwqDCoMKgwqBwYXJlbnQtPm1kZXZfZHJp
dmVyID0gbWRldl9kcml2ZXI7Cj4gPiArwqDCoMKgwqDCoMKgwqBwYXJlbnQtPnR5cGVzID0gdHlw
ZXM7Cj4gCj4gVGhpcyB3b3VsZCBwb3RlbnRpYWxseSBpbnRyb2R1Y2UgYSBidWcuIFR5cGVzIGlz
IHBhc3NlZCBmcm9tIHRoZQo+IHBhcmVudCBhbmQgbWVtb3J5IHJlc2VydmVkIGZvciBpdCBpcwo+
IG1hbmFnZWQgYnkgdGhlIHBhcmVudCBkcml2ZXIsIHdoaWxlIGlmIHlvdSBhcmUgZG9pbmcgc28s
IGl0IHdpbGwgYmUKPiBmcmVlZCB3aGVuIHR5cGVzLT5rb2JqIGlzIHJlbGVhc2VkIGluIAo+IG1k
ZXYgbW9kdWxlLCBpLmUuIGluIG1kZXZfdHlwZV9yZWxlYXNlLCB0eXBlcyB3aWxsIGJlIGZyZWVk
IGFzIGEKPiBjaHVuayBvZiBtZW1vcnkgaW4gaGVhcC4gCj4gVGhpcyB3aWxsIGxlYWQgdG8gdW5w
cmVkaWN0YWJsZSBiZWhhdmlvciBhbmQgcmVxdWlyZSBhIGZpeCzCoCBlaXRoZXIKPiBpbiBoZXJl
IG9yIGluIG1kZXZfdHlwZV9yZWxlYXNlLgoKSSBjYW4gY29uZmlybSB0aGF0IHRoaXMgaXMgc3Rp
bGwgYnJva2VuLgoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci82NTc0NmFlYTE5M2Q0YTgxNGY4
OTVlY2E0YjAwYjcyY2YyOWFjOGY5LmNhbWVsQGxpbnV4LmlibS5jb20vCgpUaGFua3MsCkVyaWMK
Cj4gCj4gVGhhbmtzLAo+IFhpbgo+IAo+ID4gK8KgwqDCoMKgwqDCoMKgcGFyZW50LT5ucl90eXBl
cyA9IG5yX3R5cGVzOwo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFtZGV2X2J1c19jb21w
YXRfY2xhc3MpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWRldl9idXNf
Y29tcGF0X2NsYXNzID0KPiA+IGNsYXNzX2NvbXBhdF9yZWdpc3RlcigibWRldl9idXMiKTsKPiA+
ICtzdGF0aWMgaW50IG1kZXZfdHlwZV9hZGQoc3RydWN0IG1kZXZfcGFyZW50ICpwYXJlbnQsIHN0
cnVjdAo+ID4gbWRldl90eXBlCj4gPiAqdHlwZSkKPiA+IMKgewo+ID4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IG1kZXZfdHlwZSAqdHlwZTsKPiA+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBhdHRyaWJ1
dGVfZ3JvdXAgKmdyb3VwID0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJl
bnQtPm1kZXZfZHJpdmVyLQo+ID4gPiBzdXBwb3J0ZWRfdHlwZV9ncm91cHNbdHlwZV9ncm91cF9p
ZF07Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiA+IAo+ID4gLcKgwqDCoMKgwqDCoMKg
aWYgKCFncm91cC0+bmFtZSkgewo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBy
X2VycigiJXM6IFR5cGUgbmFtZSBlbXB0eSFcbiIsIF9fZnVuY19fKTsKPiA+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsKPiA+IC3CoMKgwqDC
oMKgwqDCoH0KPiA+IC0KPiA+IC3CoMKgwqDCoMKgwqDCoHR5cGUgPSBremFsbG9jKHNpemVvZigq
dHlwZSksIEdGUF9LRVJORUwpOwo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKCF0eXBlKQo+ID4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBFUlJfUFRSKC1FTk9NRU0pOwo+ID4g
LQo+ID4gwqDCoMKgwqDCoMKgwqDCoHR5cGUtPmtvYmoua3NldCA9IHBhcmVudC0+bWRldl90eXBl
c19rc2V0Owo+ID4gwqDCoMKgwqDCoMKgwqDCoHR5cGUtPnBhcmVudCA9IHBhcmVudDsKPiA+IMKg
wqDCoMKgwqDCoMKgwqAvKiBQYWlycyB3aXRoIHRoZSBwdXQgaW4gbWRldl90eXBlX3JlbGVhc2Uo
KSAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoGdldF9kZXZpY2UocGFyZW50LT5kZXYpOwo+ID4gLcKg
wqDCoMKgwqDCoMKgdHlwZS0+dHlwZV9ncm91cF9pZCA9IHR5cGVfZ3JvdXBfaWQ7Cj4gPiAKPiA+
IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBrb2JqZWN0X2luaXRfYW5kX2FkZCgmdHlwZS0+a29iaiwg
Jm1kZXZfdHlwZV9rdHlwZSwKPiA+IE5VTEwsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiJXMtJXMiLAo+ID4g
ZGV2X2RyaXZlcl9zdHJpbmcocGFyZW50LT5kZXYpLAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBncm91cC0+bmFt
ZSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHR5cGUtPnN5c2ZzX25hbWUpOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oGlmIChyZXQpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga29iamVjdF9w
dXQoJnR5cGUtPmtvYmopOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biBFUlJfUFRSKHJldCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IHJldDsKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXQg
PSBzeXNmc19jcmVhdGVfZmlsZSgmdHlwZS0+a29iaiwKPiA+ICZtZGV2X3R5cGVfYXR0cl9jcmVh
dGUuYXR0cik7Cgo=
