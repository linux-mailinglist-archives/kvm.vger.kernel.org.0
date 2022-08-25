Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C755A0A63
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 09:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbiHYHh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 03:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHYHh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 03:37:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EB69C223;
        Thu, 25 Aug 2022 00:37:24 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P7Qh9s006179;
        Thu, 25 Aug 2022 07:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=J9yJDf2TuIBTMSobttjU0nm9KoYtVkg9vxp++8zIvzY=;
 b=ezQprO9OcPdRH5ya69vPuohdF0UpAeo2BImvkk/ySiCr6a/lnW5lHl6tarIedf16LBqb
 UADOPNC156UAGKrAQPoCBD2I7YHzK8epGLUlwtN8KXmaWpryUB+NIBIFWzwIO3Mr7bOz
 LJWk1v92uW3pv8US6QEko7FZAx6TglRV5ZmIAhhsO+LO2FAEXXQDBvw6WzesMAot/M1i
 2pvg5Ik3lYxEm58eKHGzC8jZju98gwr7HxP8fxO+3RL+3mefdAhrfmfwEth/opA6yyTK
 Kp1Ko/jXUg4ELAd6/2WzJQYKvqyzEcVLy5naqhSnjDsbB3+/uNx4fsINjyaqsJ/uNwYt Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64pu8akm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:37:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27P7QpFi006393;
        Thu, 25 Aug 2022 07:37:23 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64pu8aj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:37:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27P7a7Su000372;
        Thu, 25 Aug 2022 07:37:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3j2pvjcfe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 07:37:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27P7bIWr37618116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 07:37:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22912AE053;
        Thu, 25 Aug 2022 07:37:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5B23AE051;
        Thu, 25 Aug 2022 07:37:17 +0000 (GMT)
Received: from [9.145.144.57] (unknown [9.145.144.57])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 07:37:17 +0000 (GMT)
Message-ID: <d5b7dea2-3a43-a018-1474-1bb47ca9a6ff@linux.ibm.com>
Date:   Thu, 25 Aug 2022 09:37:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220705111707.3772070-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Add strict mode to specification
 exception interpretation test
In-Reply-To: <20220705111707.3772070-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1yCI0TnGoTx1M2OS2zNQjaYkuagTheYz
X-Proofpoint-GUID: xgqASa8EVM6D2i3vQP9lts58C4U6VtTA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNy81LzIyIDEzOjE3LCBKYW5pcyBTY2hvZXR0ZXJsLUdsYXVzY2ggd3JvdGU6DQo+IFdo
aWxlIHNwZWNpZmljYXRpb24gZXhjZXB0aW9uIGludGVycHJldGF0aW9uIGlzIG5vdCByZXF1
aXJlZCB0byBvY2N1ciwNCj4gaXQgY2FuIGJlIHVzZWZ1bCBmb3IgYXV0b21hdGljIHJlZ3Jl
c3Npb24gdGVzdGluZyB0byBmYWlsIHRoZSB0ZXN0IGlmIGl0DQo+IGRvZXMgbm90IG9jY3Vy
Lg0KPiBBZGQgYSBgLS1zdHJpY3RgIGFyZ3VtZW50IHRvIGVuYWJsZSB0aGlzLg0KPiBgLS1z
dHJpY3RgIHRha2VzIGEgbGlzdCBvZiBtYWNoaW5lIHR5cGVzIChhcyByZXBvcnRlZCBieSBT
VElEUCkNCj4gZm9yIHdoaWNoIHRvIGVuYWJsZSBzdHJpY3QgbW9kZSwgZm9yIGV4YW1wbGUN
Cj4gYC0tc3RyaWN0IDM5MzEsODU2Miw4NTYxLDM5MDcsMzkwNiwyOTY1LDI5NjRgDQo+IHdp
bGwgZW5hYmxlIGl0IGZvciBtb2RlbHMgejE2IC0gejEzLg0KPiBBbHRlcm5hdGl2ZWx5LCBz
dHJpY3QgbW9kZSBjYW4gYmUgZW5hYmxlZCBmb3IgYWxsIGJ1dCB0aGUgbGlzdGVkIG1hY2hp
bmUNCj4gdHlwZXMgYnkgcHJlZml4aW5nIHRoZSBsaXN0IHdpdGggYSBgIWAsIGZvciBleGFt
cGxlDQo+IGAtLXN0cmljdCAhMTA5MCwxMDkxLDIwNjQsMjA2NiwyMDg0LDIwODYsMjA5NCwy
MDk2LDIwOTcsMjA5OCwyODE3LDI4MTgsMjgyNywyODI4YA0KPiB3aWxsIGVuYWJsZSBpdCBm
b3Igei9BcmNoaXRlY3R1cmUgbW9kZWxzIGV4Y2VwdCB0aG9zZSBvbGRlciB0aGFuIHoxMy4N
Cj4gYC0tc3RyaWN0ICFgIHdpbGwgZW5hYmxlIGl0IGFsd2F5cy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEphbmlzIFNjaG9ldHRlcmwtR2xhdXNjaCA8c2NnbEBsaW51eC5pYm0uY29tPg0K
DQpHQ0MgMTEuMi4wIGlzbid0IGhhcHB5DQoNCnMzOTB4L3NwZWNfZXgtc2llLmM6IEluIGZ1
bmN0aW9uIOKAmHRlc3Rfc3BlY19leF9zaWXigJk6DQpzMzkweC9zcGVjX2V4LXNpZS5jOjcw
OjE3OiBlcnJvcjogZm9ybWF0IG5vdCBhIHN0cmluZyBsaXRlcmFsIGFuZCBubyANCmZvcm1h
dCBhcmd1bWVudHMgWy1XZXJyb3I9Zm9ybWF0LXNlY3VyaXR5XQ0KICAgIDcwIHwgICAgICAg
ICAgICAgICAgIHJlcG9ydCh2bS5zYmxrLT5ncHN3LmFkZHIgPT0gMHhkZWFkYmVlZSwgbXNn
KTsNCiAgICAgICB8ICAgICAgICAgICAgICAgICBefn5+fn4NCnMzOTB4L3NwZWNfZXgtc2ll
LmM6NzI6MTc6IGVycm9yOiBmb3JtYXQgbm90IGEgc3RyaW5nIGxpdGVyYWwgYW5kIG5vIA0K
Zm9ybWF0IGFyZ3VtZW50cyBbLVdlcnJvcj1mb3JtYXQtc2VjdXJpdHldDQogICAgNzIgfCAg
ICAgICAgICAgICAgICAgcmVwb3J0X2luZm8obXNnKTsNCiAgICAgICB8ICAgICAgICAgICAg
ICAgICBefn5+fn5+fn5+fg0KY2MxOiBhbGwgd2FybmluZ3MgYmVpbmcgdHJlYXRlZCBhcyBl
cnJvcnMNCm1ha2U6ICoqKiBbPGJ1aWx0aW4+OiBzMzkweC9zcGVjX2V4LXNpZS5vXSBFcnJv
ciAxDQoNCg0KT3RoZXIgdGhhbiB0aGF0IHRoZSBjb2RlIGxvb2tzIG9rIHRvIG1lLg0KSSBo
YXZlIHRvIHBhZ2UgaW4gdGhlIGRpc2N1c3Npb24gYWdhaW4gdG8ga25vdyBob3cgdGhpcyBm
aXRzIGludG8gdGhlIA0KcGljdHVyZS4gRWl0aGVyIHRoYXQgb3IgVGhvbWFzIHRlbGxzIG1l
IGl0J3MgZXhhY3RseSB3aGF0IGhlIHdhbnRzIGFuZCANCkknbGwgYWRkIGl0IHRvIG15IHF1
ZXVlIG9uY2UgdGhlIGNvbXBpbGUgcHJvYmxlbSBoYXMgYmVlbiBmaXhlZCBvbmUgd2F5IA0K
b3IgYW5vdGhlci4NCg0KDQo+IC0tLQ0KPiB2MiAtPiB2Mw0KPiAgICogcmViYXNlIG9uIG1h
c3Rlcg0KPiAgICogZ2xvYmFsIHN0cmljdCBib29sDQo+ICAgKiBmaXggc3R5bGUgaXNzdWUN
Cj4gDQo+IFJhbmdlLWRpZmYgYWdhaW5zdCB2MjoNCj4gMTogIGU5YzM2OTcwICEgMTogIGM3
MDc0ODFjIHMzOTB4OiBBZGQgc3RyaWN0IG1vZGUgdG8gc3BlY2lmaWNhdGlvbiBleGNlcHRp
b24gaW50ZXJwcmV0YXRpb24gdGVzdA0KPiAgICAgIEBAIENvbW1pdCBtZXNzYWdlDQo+ICAg
ICAgICAgICBBZGQgYSBgLS1zdHJpY3RgIGFyZ3VtZW50IHRvIGVuYWJsZSB0aGlzLg0KPiAg
ICAgICAgICAgYC0tc3RyaWN0YCB0YWtlcyBhIGxpc3Qgb2YgbWFjaGluZSB0eXBlcyAoYXMg
cmVwb3J0ZWQgYnkgU1RJRFApDQo+ICAgICAgICAgICBmb3Igd2hpY2ggdG8gZW5hYmxlIHN0
cmljdCBtb2RlLCBmb3IgZXhhbXBsZQ0KPiAgICAgIC0gICAgYC0tc3RyaWN0IDg1NjIsODU2
MSwzOTA3LDM5MDYsMjk2NSwyOTY0YA0KPiAgICAgIC0gICAgd2lsbCBlbmFibGUgaXQgZm9y
IG1vZGVscyB6MTUgLSB6MTMuDQo+ICAgICAgKyAgICBgLS1zdHJpY3QgMzkzMSw4NTYyLDg1
NjEsMzkwNywzOTA2LDI5NjUsMjk2NGANCj4gICAgICArICAgIHdpbGwgZW5hYmxlIGl0IGZv
ciBtb2RlbHMgejE2IC0gejEzLg0KPiAgICAgICAgICAgQWx0ZXJuYXRpdmVseSwgc3RyaWN0
IG1vZGUgY2FuIGJlIGVuYWJsZWQgZm9yIGFsbCBidXQgdGhlIGxpc3RlZCBtYWNoaW5lDQo+
ICAgICAgICAgICB0eXBlcyBieSBwcmVmaXhpbmcgdGhlIGxpc3Qgd2l0aCBhIGAhYCwgZm9y
IGV4YW1wbGUNCj4gICAgICAgICAgIGAtLXN0cmljdCAhMTA5MCwxMDkxLDIwNjQsMjA2Niwy
MDg0LDIwODYsMjA5NCwyMDk2LDIwOTcsMjA5OCwyODE3LDI4MTgsMjgyNywyODI4YA0KPiAg
ICAgIEBAIHMzOTB4L3NwZWNfZXgtc2llLmMNCj4gICAgICAgICNpbmNsdWRlIDxzY2xwLmg+
DQo+ICAgICAgICAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4NCj4gICAgICAgICNpbmNsdWRlIDxh
c20vYXJjaF9kZWYuaD4NCj4gICAgICArICNpbmNsdWRlIDxhbGxvY19wYWdlLmg+DQo+ICAg
ICAgKyAjaW5jbHVkZSA8c2llLmg+DQo+ICAgICAgKyAjaW5jbHVkZSA8c25pcHBldC5oPg0K
PiAgICAgICsrI2luY2x1ZGUgPGhhcmR3YXJlLmg+DQo+ICAgICAgKw0KPiAgICAgICsgc3Rh
dGljIHN0cnVjdCB2bSB2bTsNCj4gICAgICArIGV4dGVybiBjb25zdCBjaGFyIFNOSVBQRVRf
TkFNRV9TVEFSVChjLCBzcGVjX2V4KVtdOw0KPiAgICAgICsgZXh0ZXJuIGNvbnN0IGNoYXIg
U05JUFBFVF9OQU1FX0VORChjLCBzcGVjX2V4KVtdOw0KPiAgICAgICsrc3RhdGljIGJvb2wg
c3RyaWN0Ow0KPiAgICAgICsNCj4gICAgICArIHN0YXRpYyB2b2lkIHNldHVwX2d1ZXN0KHZv
aWQpDQo+ICAgICAgKyB7DQo+ICAgICAgIEBAIHMzOTB4L3NwZWNfZXgtc2llLmM6IHN0YXRp
YyB2b2lkIHJlc2V0X2d1ZXN0KHZvaWQpDQo+ICAgICAgLSAJdm0uc2Jsay0+aWNwdGNvZGUg
PSAwOw0KPiAgICAgIC0gfQ0KPiAgICAgICAgDQo+ICAgICAgLS1zdGF0aWMgdm9pZCB0ZXN0
X3NwZWNfZXhfc2llKHZvaWQpDQo+ICAgICAgLStzdGF0aWMgdm9pZCB0ZXN0X3NwZWNfZXhf
c2llKGJvb2wgc3RyaWN0KQ0KPiAgICAgICsgc3RhdGljIHZvaWQgdGVzdF9zcGVjX2V4X3Np
ZSh2b2lkKQ0KPiAgICAgICAgew0KPiAgICAgICArCWNvbnN0IGNoYXIgKm1zZzsNCj4gICAg
ICAgKw0KPiAgICAgIEBAIHMzOTB4L3NwZWNfZXgtc2llLmM6IHN0YXRpYyB2b2lkIHRlc3Rf
c3BlY19leF9zaWUodm9pZCkNCj4gICAgICAgKwlpZiAobGlzdFswXSA9PSAnIScpIHsNCj4g
ICAgICAgKwkJcmV0ID0gdHJ1ZTsNCj4gICAgICAgKwkJbGlzdCsrOw0KPiAgICAgIC0rCX0g
ZWxzZQ0KPiAgICAgICsrCX0gZWxzZSB7DQo+ICAgICAgICsJCXJldCA9IGZhbHNlOw0KPiAg
ICAgICsrCX0NCj4gICAgICAgKwl3aGlsZSAodHJ1ZSkgew0KPiAgICAgICArCQlsb25nIGlu
cHV0ID0gMDsNCj4gICAgICAgKw0KPiAgICAgIEBAIHMzOTB4L3NwZWNfZXgtc2llLmM6IHN0
YXRpYyB2b2lkIHRlc3Rfc3BlY19leF9zaWUodm9pZCkNCj4gICAgICAgKw0KPiAgICAgICAg
aW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPiAgICAgICAgew0KPiAgICAgICsr
CXN0cmljdCA9IHBhcnNlX3N0cmljdChhcmdjIC0gMSwgYXJndiArIDEpOw0KPiAgICAgICAg
CWlmICghc2NscF9mYWNpbGl0aWVzLmhhc19zaWVmMikgew0KPiAgICAgIC1AQCBzMzkweC9z
cGVjX2V4LXNpZS5jOiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+ICAgICAg
KyAJCXJlcG9ydF9za2lwKCJTSUVGMiBmYWNpbGl0eSB1bmF2YWlsYWJsZSIpOw0KPiAgICAg
ICAgCQlnb3RvIG91dDsNCj4gICAgICAtIAl9DQo+ICAgICAgLQ0KPiAgICAgIC0tCXRlc3Rf
c3BlY19leF9zaWUoKTsNCj4gICAgICAtKwl0ZXN0X3NwZWNfZXhfc2llKHBhcnNlX3N0cmlj
dChhcmdjIC0gMSwgYXJndiArIDEpKTsNCj4gICAgICAtIG91dDoNCj4gICAgICAtIAlyZXR1
cm4gcmVwb3J0X3N1bW1hcnkoKTsNCj4gICAgICAtIH0NCj4gDQo+ICAgczM5MHgvc3BlY19l
eC1zaWUuYyB8IDUzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA1MSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3MzOTB4L3NwZWNfZXgtc2llLmMgYi9zMzkweC9z
cGVjX2V4LXNpZS5jDQo+IGluZGV4IGQ4ZTI1ZTc1Li5lNWYzOTQ1MSAxMDA2NDQNCj4gLS0t
IGEvczM5MHgvc3BlY19leC1zaWUuYw0KPiArKysgYi9zMzkweC9zcGVjX2V4LXNpZS5jDQo+
IEBAIC03LDE2ICs3LDE5IEBADQo+ICAgICogc3BlY2lmaWNhdGlvbiBleGNlcHRpb24gaW50
ZXJwcmV0YXRpb24gaXMgb2ZmL29uLg0KPiAgICAqLw0KPiAgICNpbmNsdWRlIDxsaWJjZmxh
dC5oPg0KPiArI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPiAgICNpbmNsdWRlIDxzY2xwLmg+DQo+
ICAgI2luY2x1ZGUgPGFzbS9wYWdlLmg+DQo+ICAgI2luY2x1ZGUgPGFzbS9hcmNoX2RlZi5o
Pg0KPiAgICNpbmNsdWRlIDxhbGxvY19wYWdlLmg+DQo+ICAgI2luY2x1ZGUgPHNpZS5oPg0K
PiAgICNpbmNsdWRlIDxzbmlwcGV0Lmg+DQo+ICsjaW5jbHVkZSA8aGFyZHdhcmUuaD4NCj4g
ICANCj4gICBzdGF0aWMgc3RydWN0IHZtIHZtOw0KPiAgIGV4dGVybiBjb25zdCBjaGFyIFNO
SVBQRVRfTkFNRV9TVEFSVChjLCBzcGVjX2V4KVtdOw0KPiAgIGV4dGVybiBjb25zdCBjaGFy
IFNOSVBQRVRfTkFNRV9FTkQoYywgc3BlY19leClbXTsNCj4gK3N0YXRpYyBib29sIHN0cmlj
dDsNCj4gICANCj4gICBzdGF0aWMgdm9pZCBzZXR1cF9ndWVzdCh2b2lkKQ0KPiAgIHsNCj4g
QEAgLTM3LDYgKzQwLDggQEAgc3RhdGljIHZvaWQgcmVzZXRfZ3Vlc3Qodm9pZCkNCj4gICAN
Cj4gICBzdGF0aWMgdm9pZCB0ZXN0X3NwZWNfZXhfc2llKHZvaWQpDQo+ICAgew0KPiArCWNv
bnN0IGNoYXIgKm1zZzsNCj4gKw0KPiAgIAlzZXR1cF9ndWVzdCgpOw0KPiAgIA0KPiAgIAly
ZXBvcnRfcHJlZml4X3B1c2goIlNJRSBzcGVjIGV4IGludGVycHJldGF0aW9uIik7DQo+IEBA
IC02MCwxNiArNjUsNjAgQEAgc3RhdGljIHZvaWQgdGVzdF9zcGVjX2V4X3NpZSh2b2lkKQ0K
PiAgIAlyZXBvcnQodm0uc2Jsay0+aWNwdGNvZGUgPT0gSUNQVF9QUk9HSQ0KPiAgIAkgICAg
ICAgJiYgdm0uc2Jsay0+aXByY2MgPT0gUEdNX0lOVF9DT0RFX1NQRUNJRklDQVRJT04sDQo+
ICAgCSAgICAgICAiUmVjZWl2ZWQgc3BlY2lmaWNhdGlvbiBleGNlcHRpb24gaW50ZXJjZXB0
Iik7DQo+IC0JaWYgKHZtLnNibGstPmdwc3cuYWRkciA9PSAweGRlYWRiZWVlKQ0KPiAtCQly
ZXBvcnRfaW5mbygiSW50ZXJwcmV0ZWQgaW5pdGlhbCBleGNlcHRpb24sIGludGVyY2VwdGVk
IGludmFsaWQgcHJvZ3JhbSBuZXcgUFNXIGV4Y2VwdGlvbiIpOw0KPiArCW1zZyA9ICJJbnRl
cnByZXRlZCBpbml0aWFsIGV4Y2VwdGlvbiwgaW50ZXJjZXB0ZWQgaW52YWxpZCBwcm9ncmFt
IG5ldyBQU1cgZXhjZXB0aW9uIjsNCj4gKwlpZiAoc3RyaWN0KQ0KPiArCQlyZXBvcnQodm0u
c2Jsay0+Z3Bzdy5hZGRyID09IDB4ZGVhZGJlZWUsIG1zZyk7DQo+ICsJZWxzZSBpZiAodm0u
c2Jsay0+Z3Bzdy5hZGRyID09IDB4ZGVhZGJlZWUpDQo+ICsJCXJlcG9ydF9pbmZvKG1zZyk7
DQo+ICAgCWVsc2UNCj4gICAJCXJlcG9ydF9pbmZvKCJEaWQgbm90IGludGVycHJldCBpbml0
aWFsIGV4Y2VwdGlvbiIpOw0KPiAgIAlyZXBvcnRfcHJlZml4X3BvcCgpOw0KPiAgIAlyZXBv
cnRfcHJlZml4X3BvcCgpOw0KPiAgIH0NCj4gICANCj4gK3N0YXRpYyBib29sIHBhcnNlX3N0
cmljdChpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+ICt7DQo+ICsJdWludDE2X3QgbWFjaGlu
ZV9pZDsNCj4gKwljaGFyICpsaXN0Ow0KPiArCWJvb2wgcmV0Ow0KPiArDQo+ICsJaWYgKGFy
Z2MgPCAxKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsJaWYgKHN0cmNtcCgiLS1zdHJpY3Qi
LCBhcmd2WzBdKSkNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArDQo+ICsJbWFjaGluZV9pZCA9
IGdldF9tYWNoaW5lX2lkKCk7DQo+ICsJaWYgKGFyZ2MgPCAyKSB7DQo+ICsJCXByaW50Zigi
Tm8gYXJndW1lbnQgdG8gLS1zdHJpY3QsIGlnbm9yaW5nXG4iKTsNCj4gKwkJcmV0dXJuIGZh
bHNlOw0KPiArCX0NCj4gKwlsaXN0ID0gYXJndlsxXTsNCj4gKwlpZiAobGlzdFswXSA9PSAn
IScpIHsNCj4gKwkJcmV0ID0gdHJ1ZTsNCj4gKwkJbGlzdCsrOw0KPiArCX0gZWxzZSB7DQo+
ICsJCXJldCA9IGZhbHNlOw0KPiArCX0NCj4gKwl3aGlsZSAodHJ1ZSkgew0KPiArCQlsb25n
IGlucHV0ID0gMDsNCj4gKw0KPiArCQlpZiAoc3RybGVuKGxpc3QpID09IDApDQo+ICsJCQly
ZXR1cm4gcmV0Ow0KPiArCQlpbnB1dCA9IHN0cnRvbChsaXN0LCAmbGlzdCwgMTYpOw0KPiAr
CQlpZiAoKmxpc3QgPT0gJywnKQ0KPiArCQkJbGlzdCsrOw0KPiArCQllbHNlIGlmICgqbGlz
dCAhPSAnXDAnKQ0KPiArCQkJYnJlYWs7DQo+ICsJCWlmIChpbnB1dCA9PSBtYWNoaW5lX2lk
KQ0KPiArCQkJcmV0dXJuICFyZXQ7DQo+ICsJfQ0KPiArCXByaW50ZigiSW52YWxpZCAtLXN0
cmljdCBhcmd1bWVudCBcIiVzXCIsIGlnbm9yaW5nXG4iLCBsaXN0KTsNCj4gKwlyZXR1cm4g
cmV0Ow0KPiArfQ0KPiArDQo+ICAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0K
PiAgIHsNCj4gKwlzdHJpY3QgPSBwYXJzZV9zdHJpY3QoYXJnYyAtIDEsIGFyZ3YgKyAxKTsN
Cj4gICAJaWYgKCFzY2xwX2ZhY2lsaXRpZXMuaGFzX3NpZWYyKSB7DQo+ICAgCQlyZXBvcnRf
c2tpcCgiU0lFRjIgZmFjaWxpdHkgdW5hdmFpbGFibGUiKTsNCj4gICAJCWdvdG8gb3V0Ow0K
PiANCj4gYmFzZS1jb21taXQ6IGNhODVkZGEyNjcxZTg4ZDM0YWNmYmNhNmRlNDhhOWFiMzJi
MTgxMGQNCg0K
