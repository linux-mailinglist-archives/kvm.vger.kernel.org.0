Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07F14F3B17
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344903AbiDELuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343826AbiDEKjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 06:39:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A4F65;
        Tue,  5 Apr 2022 03:24:34 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2359JMC7026479;
        Tue, 5 Apr 2022 10:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=93ChZV+J3hQLHU9EUFcEtv1THmIGng3r6S5e7Pekzfc=;
 b=OrJ3IvbS3PhSV2sm3aK2sMd46Uz2nYKU5kL9hDWKjYCr2eRoh1PQ6bFXpRpMHDldDrxk
 HSeo6YnlSHm/KcBiialkDrRs/q0ux54RiUIVzkxDiuTS1HuUXaxWipeY5Ob+BfWjPX54
 JmdNDPQVKMvNXChBBNOmdi06BYAhUKvmTk5l8S9I9r/HVLB0jG/xvF+3pgqgnIBcvySG
 RJ2VCTL63UoGJ5o2wt+tNWOtOlU4rM2RPza9oRwqngosH/ptp5bGmbvFpTm5krHJtrQw
 20ImxY9NbblgSxROBd/+U8u+9g/TYZVAh5sRA9jLtvN4jDWeKv0YLsuaU2KX7nPMObab wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8k1e14ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 10:24:33 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235ALfVx010554;
        Tue, 5 Apr 2022 10:24:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8k1e14uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 10:24:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235AD7IG025557;
        Tue, 5 Apr 2022 10:24:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f6drhnfrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 10:24:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235AORVG34996590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 10:24:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B46CA4053;
        Tue,  5 Apr 2022 10:24:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4C18A404D;
        Tue,  5 Apr 2022 10:24:26 +0000 (GMT)
Received: from [9.145.34.46] (unknown [9.145.34.46])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 10:24:26 +0000 (GMT)
Message-ID: <c724e899-7f5c-4142-5553-3129670cb092@linux.ibm.com>
Date:   Tue, 5 Apr 2022 12:24:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH 2/8] s390x: diag308: Only test subcode 2
 under QEMU
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-3-frankja@linux.ibm.com>
 <16c254ac-c3ed-6174-5eef-5f309e7a7585@redhat.com>
 <68646d2c-0793-e395-4719-d1526983de6b@linux.ibm.com>
 <9f0a91ce-3a2f-4149-7237-c5f963c0cba0@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <9f0a91ce-3a2f-4149-7237-c5f963c0cba0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WGJ9q6Aom4MJlMYvanehwKkKhWK3_lW_
X-Proofpoint-GUID: pux9fTEtJYeOVXRTigNoR2ere2ubmveg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_10,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050060
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNC81LzIyIDExOjUwLCBUaG9tYXMgSHV0aCB3cm90ZToNCj4gT24gMDUvMDQvMjAyMiAx
MS4zMywgSmFub3NjaCBGcmFuayB3cm90ZToNCj4+IE9uIDQvNS8yMiAxMToxOCwgVGhvbWFz
IEh1dGggd3JvdGU6DQo+Pj4gT24gMDUvMDQvMjAyMiAwOS41MiwgSmFub3NjaCBGcmFuayB3
cm90ZToNCj4+Pj4gT3RoZXIgaHlwZXJ2aXNvcnMgbWlnaHQgaW1wbGVtZW50IGl0IGFuZCB0
aGVyZWZvcmUgbm90IHNlbmQgYQ0KPj4+PiBzcGVjaWZpY2F0aW9uIGV4Y2VwdGlvbi4NCj4+
Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogSmFub3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51eC5p
Ym0uY29tPg0KPj4+PiAtLS0NCj4+Pj4gIMKgwqAgczM5MHgvZGlhZzMwOC5jIHwgMTUgKysr
KysrKysrKysrKystDQo+Pj4+ICDCoMKgIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9zMzkweC9kaWFn
MzA4LmMgYi9zMzkweC9kaWFnMzA4LmMNCj4+Pj4gaW5kZXggYzlkNmM0OTkuLjk2MTRmOWE5
IDEwMDY0NA0KPj4+PiAtLS0gYS9zMzkweC9kaWFnMzA4LmMNCj4+Pj4gKysrIGIvczM5MHgv
ZGlhZzMwOC5jDQo+Pj4+IEBAIC04LDYgKzgsNyBAQA0KPj4+PiAgwqDCoCAjaW5jbHVkZSA8
bGliY2ZsYXQuaD4NCj4+Pj4gIMKgwqAgI2luY2x1ZGUgPGFzbS9hc20tb2Zmc2V0cy5oPg0K
Pj4+PiAgwqDCoCAjaW5jbHVkZSA8YXNtL2ludGVycnVwdC5oPg0KPj4+PiArI2luY2x1ZGUg
PGhhcmR3YXJlLmg+DQo+Pj4+ICDCoMKgIC8qIFRoZSBkaWFnbm9zZSBjYWxscyBzaG91bGQg
YmUgYmxvY2tlZCBpbiBwcm9ibGVtIHN0YXRlICovDQo+Pj4+ICDCoMKgIHN0YXRpYyB2b2lk
IHRlc3RfcHJpdih2b2lkKQ0KPj4+PiBAQCAtNzUsNyArNzYsNyBAQCBzdGF0aWMgdm9pZCB0
ZXN0X3N1YmNvZGU2KHZvaWQpDQo+Pj4+ICDCoMKgIC8qIFVuc3VwcG9ydGVkIHN1YmNvZGVz
IHNob3VsZCBnZW5lcmF0ZSBhIHNwZWNpZmljYXRpb24gZXhjZXB0aW9uICovDQo+Pj4+ICDC
oMKgIHN0YXRpYyB2b2lkIHRlc3RfdW5zdXBwb3J0ZWRfc3ViY29kZSh2b2lkKQ0KPj4+PiAg
wqDCoCB7DQo+Pj4+IC3CoMKgwqAgaW50IHN1YmNvZGVzW10gPSB7IDIsIDB4MTAxLCAweGZm
ZmYsIDB4MTAwMDEsIC0xIH07DQo+Pj4+ICvCoMKgwqAgaW50IHN1YmNvZGVzW10gPSB7IDB4
MTAxLCAweGZmZmYsIDB4MTAwMDEsIC0xIH07DQo+Pj4+ICDCoMKgwqDCoMKgwqAgaW50IGlk
eDsNCj4+Pj4gIMKgwqDCoMKgwqDCoCBmb3IgKGlkeCA9IDA7IGlkeCA8IEFSUkFZX1NJWkUo
c3ViY29kZXMpOyBpZHgrKykgew0KPj4+PiBAQCAtODUsNiArODYsMTggQEAgc3RhdGljIHZv
aWQgdGVzdF91bnN1cHBvcnRlZF9zdWJjb2RlKHZvaWQpDQo+Pj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjaGVja19wZ21faW50X2NvZGUoUEdNX0lOVF9DT0RFX1NQRUNJRklDQVRJT04p
Ow0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVwb3J0X3ByZWZpeF9wb3AoKTsNCj4+
Pj4gIMKgwqDCoMKgwqDCoCB9DQo+Pj4+ICsNCj4+Pj4gK8KgwqDCoCAvKg0KPj4+PiArwqDC
oMKgwqAgKiBTdWJjb2RlIDIgaXMgbm90IGF2YWlsYWJsZSB1bmRlciBRRU1VIGJ1dCBtaWdo
dCBiZSBvbiBvdGhlcg0KPj4+PiArwqDCoMKgwqAgKiBoeXBlcnZpc29ycy4NCj4+Pj4gK8Kg
wqDCoMKgICovDQo+Pj4+ICvCoMKgwqAgaWYgKGRldGVjdF9ob3N0KCkgIT0gSE9TVF9JU19U
Q0cgJiYgZGV0ZWN0X2hvc3QoKSAhPSBIT1NUX0lTX0tWTSkgew0KPj4+DQo+Pj4gU2hvdWxk
bid0IHRoaXMgYmUgcmF0aGVyIHRoZSBvdGhlciB3YXkgcm91bmQgaW5zdGVhZD8NCj4+Pg0K
Pj4+ICDCoMKgwqDCoGlmIChkZXRlY3RfaG9zdCgpID09IEhPU1RfSVNfVENHIHx8IGRldGVj
dF9ob3N0KCkgPT0gSE9TVF9JU19LVk0pDQo+Pj4NCj4+PiA/DQo+Pg0KPj4gVGhlIGNzcyBp
ZiBjaGVja3MgaWYgd2UgYXJlIHVuZGVyIFFFTVUsIHRoaXMgb25lIGNoZWNrcyBpZiB3ZSdy
ZSBub3QgdW5kZXINCj4+IFFFTVUuDQo+IA0KPiBidXQgLi4uDQo+IA0KPj4+DQo+Pj4+ICvC
oMKgwqDCoMKgwqDCoCBleHBlY3RfcGdtX2ludCgpOw0KPj4+PiArwqDCoMKgwqDCoMKgwqAg
YXNtIHZvbGF0aWxlICgiZGlhZyAlMCwlMSwweDMwOCIgOjogImQiKDApLCAiZCIoMikpOw0K
Pj4+PiArwqDCoMKgwqDCoMKgwqAgY2hlY2tfcGdtX2ludF9jb2RlKFBHTV9JTlRfQ09ERV9T
UEVDSUZJQ0FUSU9OKTsNCj4gDQo+IC4uLiBkb24ndCB3ZSB3YW50IHRvIGNoZWNrIGhlcmUg
d2hldGhlciB0aGUgZGlhZyBjYXVzZXMgYSBzcGVjIGV4Y2VwdGlvbiBpZg0KPiB3ZSBhcmUg
KnVuZGVyKiBRRU1VIGhlcmU/DQo+IC9tZSBmZWVscyBjb25mdXNlZCBub3cuDQoNClNlZW1z
IGxpa2UgaXQncyBtZSB3aG8ncyBjb25mdXNlZCB0b2RheQ0KQW55d2F5LCBJJ2xsIGNsZWFu
IHRoYXQgdXAuDQoNCj4gDQo+ICAgIFRob21hcw0KPiANCg0K
