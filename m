Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA9C621D84
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiKHUR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKHURz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:17:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6335D6A5;
        Tue,  8 Nov 2022 12:17:54 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8Jf7FI020200;
        Tue, 8 Nov 2022 20:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZcA3R9lm//Dleryv2H5/m4crcsiFJFFz/rsMi5fuvX0=;
 b=mZNoogkn1heS0/nMJVyjQDWpnoJSsszbEh6rRj7xKOslttRtB9ENIypWFSqRQVW277fH
 ghMTK6OiW3U/x5H1X05iJGgmDQX2sPW8pLy7t/V/3rWO5EE1T2nGm+EIi8clB4nHENk0
 +OKcrT0daXD/b2a7Fz7v0CRMi0AsT07aMQbKRfCkYTYT3ssOidUV0oETUKKXqb4A4YE3
 QA0twyRx2S1gA9z7ONkzz3P8vhSCTfI9yFWslmn03nTc61aE/HQV1p8zGCLZT1Ulmzx3
 1JzecXGZEEInhqYlDO8CsSHPumIVv2GEj3yEtKC7VEzwZvEAIYwLnMjQF7+quTFQECz+ 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kquudbxt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:17:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8Jvk8A017291;
        Tue, 8 Nov 2022 20:17:49 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kquudbxs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:17:49 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8K6VrG015441;
        Tue, 8 Nov 2022 20:17:47 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 3kngs40u98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:17:47 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8KHmOA15860264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 20:17:48 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50C635805A;
        Tue,  8 Nov 2022 20:17:46 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E659E5805C;
        Tue,  8 Nov 2022 20:17:44 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 20:17:44 +0000 (GMT)
Message-ID: <fde410078ce5116fc8a05efade92dd3a5eeb70d1.camel@linux.ibm.com>
Subject: Re: S390 testing for IOMMUFD
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Date:   Tue, 08 Nov 2022 15:17:44 -0500
In-Reply-To: <Y2q2a+uPUDlLuHXh@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
         <Y2msLjrbvG5XPeNm@nvidia.com>
         <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
         <Y2pffsdWwnfjrTbv@nvidia.com>
         <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
         <Y2ppq9oeKZzk5F6h@nvidia.com>
         <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
         <f2f8b63c-ecc7-7413-7134-089d30ba8e7d@linux.ibm.com>
         <Y2q2a+uPUDlLuHXh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AaJVq4o0RMqy32I7A4iadnU43k0c8qMi
X-Proofpoint-GUID: 8IFzMxxK_K9uW4dutz_9xLW1bhk7OBvR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=968
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTA4IGF0IDE2OjA0IC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
Cj4gT24gVHVlLCBOb3YgMDgsIDIwMjIgYXQgMDI6MTg6MTJQTSAtMDUwMCwgTWF0dGhldyBSb3Nh
dG8gd3JvdGU6Cj4gCj4gPiBVcGRhdGUgb24gd2h5IC1hcCBpcyBmYWlsaW5nIC0tIEkgc2VlIHZm
aW9fcGluX3BhZ2VzIHJlcXVlc3RzIGZyb20KPiA+IHZmaW9fYXBfaXJxX2VuYWJsZSB0aGF0IGFy
ZSBmYWlsaW5nIG9uIC1FSU5WQUwgLS0gaW5wdXQgaXMgbm90Cj4gPiBwYWdlLWFsaWduZWQsIGp1
c3QgbGlrZSB3aGF0IHZmaW8tY2N3IHdhcyBoaXR0aW5nLgo+ID4gCj4gPiBJIGp1c3QgdHJpZWQg
YSBxdWljayBoYWNrIHRvIGZvcmNlIHRoZXNlIHRvIHBhZ2UtYWxpZ25lZCByZXF1ZXN0cwo+ID4g
YW5kIHdpdGggdGhhdCB0aGUgdmZpby1hcCB0ZXN0cyBJJ20gcnVubmluZyBzdGFydCBwYXNzaW5n
IGFnYWluLsKgCj4gPiBTbwo+ID4gSSB0aGluayBhIHByb3BlciBmaXggaW4gdGhlIGlvbW11ZmQg
Y29kZSBmb3IgdGhpcyB3aWxsIGFsc28gZml4Cj4gPiB2ZmlvLWFwICh3ZSB3aWxsIHRlc3Qgb2Yg
Y291cnNlKQo+IAo+IFJpZ2h0LCBzbyBteSBmaXJzdCBmaXggaXNuJ3QgdGhlIHJpZ2h0IHRoaW5n
LiBUaGUgQVBJcyBhcmUgbWlzbWF0Y2hlZAo+IHRvbyBtdWNoLiBUaGUgbGVuZ3RoIGdldHMgYWxs
IG1lc3NlZCB1cCBpbiB0aGUgcHJvY2Vzcy4KPiAKPiBTbyBob3cgYWJvdXQgdGhpcz8gKGRyb3Ag
dGhlIHByaW9yIGF0dGVtcHQpCgpUaGF0IHNlZW1zIHRvIGdldCB0aGUgc25pZmYgdGVzdHMgZm9y
IGJvdGggLWNjdyBhbmQgLWFwIHdvcmtpbmcuIEknbGwKa2VlcCBwbGF5aW5nIHdpdGggaXQgZm9y
IC1jY3c7IFRvbnkgYW5kIEphc29uIGNhbiBkbyBtb3JlIHZhbGlkYXRpb24gb24KdGhlIC1hcCBz
aWRlLgoKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jIGIvZHJpdmVy
cy92ZmlvL3ZmaW9fbWFpbi5jCj4gaW5kZXggZDgzNWE3N2FhZjI2ZDkuLmI1OTBjYTNjMTg2Mzk2
IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYwo+ICsrKyBiL2RyaXZlcnMv
dmZpby92ZmlvX21haW4uYwo+IEBAIC0xOTA2LDggKzE5MDYsMTMgQEAgaW50IHZmaW9fcGluX3Bh
Z2VzKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlLAo+IGRtYV9hZGRyX3QgaW92YSwKPiDCoAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGlvdmEgPiBVTE9OR19NQVgpCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1F
SU5WQUw7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIFZGSU8gaWdub3JlcyB0aGUgc3ViIHBhZ2Ugb2Zmc2V0LCBu
cGFnZXMgaXMgZnJvbQo+IHRoZSBzdGFydCBvZgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKiBhIFBBR0VfU0laRSBjaHVuayBvZiBJT1ZBLgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKi8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IGlv
bW11ZmRfYWNjZXNzX3Bpbl9wYWdlcygKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGRldmljZS0+aW9tbXVmZF9hY2Nlc3MsIGlvdmEsIG5wYWdlICoKPiBQ
QUdFX1NJWkUsIHBhZ2VzLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZGV2aWNlLT5pb21tdWZkX2FjY2VzcywgQUxJR05fRE9XTihpb3ZhLAo+IFBBR0Vf
U0laRSksCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBu
cGFnZSAqIFBBR0VfU0laRSwgcGFnZXMsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKHByb3QgJiBJT01NVV9XUklURSkgPwo+IElPTU1VRkRfQUNDRVNT
X1JXX1dSSVRFIDogMCk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0
KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biByZXQ7Cj4gQEAgLTE5MzcsNyArMTk0Miw4IEBAIHZvaWQgdmZpb191bnBpbl9wYWdlcyhzdHJ1
Y3QgdmZpb19kZXZpY2UKPiAqZGV2aWNlLCBkbWFfYWRkcl90IGlvdmEsIGludCBucGFnZSkKPiDC
oMKgwqDCoMKgwqDCoMKgaWYgKGRldmljZS0+aW9tbXVmZF9hY2Nlc3MpIHsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChXQVJOX09OKGlvdmEgPiBVTE9OR19NQVgpKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsKPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW9tbXVmZF9hY2Nlc3NfdW5waW5fcGFnZXMo
ZGV2aWNlLT5pb21tdWZkX2FjY2VzcywKPiBpb3ZhLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpb21tdWZkX2FjY2Vzc191bnBpbl9wYWdlcyhkZXZpY2UtPmlvbW11ZmRfYWNjZXNz
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFMSUdOX0RPV04oaW92YSwKPiBQQUdFX1NJ
WkUpLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBucGFnZSAqIFBBR0VfU0laRSk7Cj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm47Cj4gwqDCoMKgwqDCoMKgwqDC
oH0KPiAKPiBUaGFua3MsCj4gSmFzb24KCg==

