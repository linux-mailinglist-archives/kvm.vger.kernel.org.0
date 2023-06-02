Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC9071FB5E
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 09:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjFBHuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 03:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjFBHuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 03:50:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EB5E7;
        Fri,  2 Jun 2023 00:50:17 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3527noKM011575;
        Fri, 2 Jun 2023 07:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CU64DAJIjgCwupYA81L/b6oXDzWWTJR9yStFG1QIVn4=;
 b=e1vC/ctOd/mW9cYtGKtNWCxv5Qk6ZQVSL4z6PaTEx9aw251OGugE3SaZvdJJU5Q+Vm0m
 llc4qwdTjy8Ld5pPlb3GSJlu3KUuRnTQrAlY9IbRosRjiiGW35w2vh+Lxi8MBF1DJypy
 dsw/hS6OT+s1ZDDHdo0XiuL8Xiiz6w7oSaiiQYoDG15Si5HZI9vyZxTOtidPbvT36Yi2
 RnpgTiW87z1RJBPkFR5T5p6ixPSthDHQjwp4r8P1PIs+EcxNUrXp5mVdN4OER9A8b2Qj
 FDbZmB3OKFcDM0K64cEXLDp4xgM7C6A6OTxTaUyeNi+uChGSXpHBgMp4N7llmYJ7nPYB Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyccf008g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 07:50:16 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3527oGTv012902;
        Fri, 2 Jun 2023 07:50:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyccf0088-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 07:50:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3525htol023377;
        Fri, 2 Jun 2023 07:50:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g52ear-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 07:50:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3527o8K728967392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 07:50:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE7D820040;
        Fri,  2 Jun 2023 07:50:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53BB02004B;
        Fri,  2 Jun 2023 07:50:08 +0000 (GMT)
Received: from [9.171.82.186] (unknown [9.171.82.186])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 07:50:08 +0000 (GMT)
Message-ID: <15f284ad-4b51-f634-8acf-2f4fc27c9734@linux.ibm.com>
Date:   Fri, 2 Jun 2023 09:50:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
 <5d8f2ecc-0858-4708-a6cd-bf9692218935@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <5d8f2ecc-0858-4708-a6cd-bf9692218935@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u5K84brqj31mR6ekLd5t3_zhophT849h
X-Proofpoint-ORIG-GUID: WaHNLUs0lcuyUl9OxxAWC12zVc35RdGo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020057
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNi8xLzIzIDE5OjQxLCBQaWVycmUgTW9yZWwgd3JvdGU6DQo+IA0KPiBPbiA2LzEvMjMg
MTE6MzgsIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiA1LzE5LzIzIDEzOjIyLCBQaWVy
cmUgTW9yZWwgd3JvdGU6DQo+Pj4gU1RTSSB3aXRoIGZ1bmN0aW9uIGNvZGUgMTUgaXMgdXNl
ZCB0byBzdG9yZSB0aGUgQ1BVIGNvbmZpZ3VyYXRpb24NCj4+PiB0b3BvbG9neS4NCj4+Pg0K
Pj4+IFdlIHJldHJpZXZlIHRoZSBtYXhpbXVtIG5lc3RlZCBsZXZlbCB3aXRoIFNDTFAgYW5k
IHVzZSB0aGUNCj4+PiB0b3BvbG9neSB0cmVlIHByb3ZpZGVkIGJ5IHRoZSBkcmF3ZXJzLCBi
b29rcywgc29ja2V0cywgY29yZXMNCj4+PiBhcmd1bWVudHMuDQo+Pj4NCj4+PiBXZSBjaGVj
ayA6DQo+Pj4gLSBpZiB0aGUgdG9wb2xvZ3kgc3RvcmVkIGlzIGNvaGVyZW50IGJldHdlZW4g
dGhlIFFFTVUgLXNtcA0KPj4+ICDCoMKgIHBhcmFtZXRlcnMgYW5kIGtlcm5lbCBwYXJhbWV0
ZXJzLg0KPj4+IC0gdGhlIG51bWJlciBvZiBDUFVzDQo+Pj4gLSB0aGUgbWF4aW11bSBudW1i
ZXIgb2YgQ1BVcw0KPj4+IC0gdGhlIG51bWJlciBvZiBjb250YWluZXJzIG9mIGVhY2ggbGV2
ZWxzIGZvciBldmVyeSBTVFNJKDE1LjEueCkNCj4+PiAgwqDCoCBpbnN0cnVjdGlvbiBhbGxv
d2VkIGJ5IHRoZSBtYWNoaW5lLg0KPj4NCj4+PiAgwqAgW3RvcG9sb2d5XQ0KPj4+ICDCoCBm
aWxlID0gdG9wb2xvZ3kuZWxmDQo+Pj4gKyMgMyBDUFVzIG9uIHNvY2tldCAwIHdpdGggZGlm
ZmVyZW50IENQVSBUTEUgKHN0YW5kYXJkLCBkZWRpY2F0ZWQsDQo+Pj4gb3JpZ2luKQ0KPj4+
ICsjIDEgQ1BVIG9uIHNvY2tldCAyDQo+Pj4gK2V4dHJhX3BhcmFtcyA9IC1zbXANCj4+PiAx
LGRyYXdlcnM9Myxib29rcz0zLHNvY2tldHM9NCxjb3Jlcz00LG1heGNwdXM9MTQ0IC1jcHUg
ejE0LGN0b3A9b24NCj4+PiAtZGV2aWNlIHoxNC1zMzkweC1jcHUsY29yZS1pZD0xLGVudGl0
bGVtZW50PWxvdyAtZGV2aWNlDQo+Pj4gejE0LXMzOTB4LWNwdSxjb3JlLWlkPTIsZGVkaWNh
dGVkPW9uIC1kZXZpY2UgejE0LXMzOTB4LWNwdSxjb3JlLWlkPTEwDQo+Pj4gLWRldmljZSB6
MTQtczM5MHgtY3B1LGNvcmUtaWQ9MjAgLWRldmljZQ0KPj4+IHoxNC1zMzkweC1jcHUsY29y
ZS1pZD0xMzAsc29ja2V0LWlkPTAsYm9vay1pZD0wLGRyYXdlci1pZD0wIC1hcHBlbmQNCj4+
PiAnLWRyYXdlcnMgMyAtYm9va3MgMyAtc29ja2V0cyA0IC1jb3JlcyA0Jw0KPj4+ICsNCj4+
PiArW3RvcG9sb2d5LTJdDQo+Pj4gK2ZpbGUgPSB0b3BvbG9neS5lbGYNCj4+PiArZXh0cmFf
cGFyYW1zID0gLXNtcA0KPj4+IDEsZHJhd2Vycz0yLGJvb2tzPTIsc29ja2V0cz0yLGNvcmVz
PTMwLG1heGNwdXM9MjQwwqAgLWFwcGVuZCAnLWRyYXdlcnMNCj4+PiAyIC1ib29rcyAyIC1z
b2NrZXRzIDIgLWNvcmVzIDMwJyAtY3B1IHoxNCxjdG9wPW9uIC1kZXZpY2UNCj4+PiB6MTQt
czM5MHgtY3B1LGRyYXdlci1pZD0xLGJvb2staWQ9MCxzb2NrZXQtaWQ9MCxjb3JlLWlkPTIs
ZW50aXRsZW1lbnQ9bG93DQo+Pj4gLWRldmljZQ0KPj4+IHoxNC1zMzkweC1jcHUsZHJhd2Vy
LWlkPTEsYm9vay1pZD0wLHNvY2tldC1pZD0wLGNvcmUtaWQ9MyxlbnRpdGxlbWVudD1tZWRp
dW0NCj4+PiAtZGV2aWNlDQo+Pj4gejE0LXMzOTB4LWNwdSxkcmF3ZXItaWQ9MSxib29rLWlk
PTAsc29ja2V0LWlkPTAsY29yZS1pZD00LGVudGl0bGVtZW50PWhpZ2gNCj4+PiAtZGV2aWNl
DQo+Pj4gejE0LXMzOTB4LWNwdSxkcmF3ZXItaWQ9MSxib29rLWlkPTAsc29ja2V0LWlkPTAs
Y29yZS1pZD01LGVudGl0bGVtZW50PWhpZ2gsZGVkaWNhdGVkPW9uDQo+Pj4gLWRldmljZQ0K
Pj4+IHoxNC1zMzkweC1jcHUsZHJhd2VyLWlkPTEsYm9vay1pZD0wLHNvY2tldC1pZD0wLGNv
cmUtaWQ9NjUsZW50aXRsZW1lbnQ9bG93DQo+Pj4gLWRldmljZQ0KPj4+IHoxNC1zMzkweC1j
cHUsZHJhd2VyLWlkPTEsYm9vay1pZD0wLHNvY2tldC1pZD0wLGNvcmUtaWQ9NjYsZW50aXRs
ZW1lbnQ9bWVkaXVtDQo+Pj4gLWRldmljZQ0KPj4+IHoxNC1zMzkweC1jcHUsZHJhd2VyLWlk
PTEsYm9vay1pZD0wLHNvY2tldC1pZD0wLGNvcmUtaWQ9NjcsZW50aXRsZW1lbnQ9aGlnaA0K
Pj4+IC1kZXZpY2UNCj4+PiB6MTQtczM5MHgtY3B1LGRyYXdlci1pZD0xLGJvb2staWQ9MCxz
b2NrZXQtaWQ9MCxjb3JlLWlkPTY4LGVudGl0bGVtZW50PWhpZ2gsZGVkaWNhdGVkPW9uDQo+
Pg0KPj4gUGFyZG9uIG15IGlnbm9yYW5jZSBidXQgSSBzZWUgejE0IGluIHRoZXJlLCB3aWxs
IHRoaXMgd29yayBpZiB3ZSBydW4NCj4+IG9uIGEgejEzPw0KPiANCj4gSSB0aGluayBpdCB3
aWxsLCB3ZSBkbyBub3QgdXNlIGFueXRoaW5nIHNwZWNpZmljIHRvIHRoZSBDUFUgYnV0IHRo
ZQ0KPiBDb25maWd1cmF0aW9uIHRvcG9sb2d5IGZhY2lsaXR5IHdoaWNoIHN0YXJ0IHdpdGgg
ejEwRUMNCj4gYW5kIEFGQUlVIFFFTVUgd2lsbCBhY2NlcHQgYSBwcm9jZXNzb3IgbmV3ZXIg
dGhhbiB0aGUgb25lIG9mIHRoZSBob3N0LA0KPiBhdCBsZWFzdCBpdCBkb2VzIG9uIG15IExQ
QVIgKFZNIHoxNmIgPiBob3N0IHoxNmEpDQo+IA0KPiBCdXQgd2UgY2FuIHVzZSB6MTMgYXMg
YmFzaXMsIHdoaWNoIGFsc28gY292ZXJzIHRoZSBjYXNlIHdoZXJlIEkgZm9yZ290DQo+IHNv
bWV0aGluZy4NCg0KSSBkb24ndCByZWFsbHkgY2FyZSB3aGF0IHdlIHVzZSBhcyBhIGJhc2Uu
DQpCdXQgd2Ugc2hvdWxkIGF2b2lkIGEgIkZBSUwiIGlmIHRoZSB0ZXN0cyBhcmUgcnVuIG9u
IGEgbWFjaGluZSB0aGF0J3MgDQpvbGRlciB0aGFuIHdoYXQncyBzcGVjaWZpZWQgaGVyZS4N
Cg0KPiANCj4gDQo+Pg0KPj4gQWxzbywgd2lsbCB0aGlzIHdvcmsvZmFpbCBncmFjZWZ1bGx5
IGlmIHRoZSB0ZXN0IGlzIHJ1biB3aXRoIGEgcXVlbXUNCj4+IHRoYXQgZG9lc24ndCBrbm93
IGFib3V0IHRvcG9sb2d5IG9yIHdpbGwgaXQgY3Jhc2g/DQo+IA0KPiBJdCB3aWxsIGNyYXNo
LCBRRU1VIHdpbGwgcmVmdXNlIHRoZSBkcmF3ZXJzIGFuZCBib29rIHBhcmFtZXRlcnMgaWYg
dGhlDQo+IFFFTVUgcGF0Y2ggZm9yIHRvcG9sb2d5IGhhcyBub3QgYmVlbiBhcHBsaWVkLg0K
PiANCj4gU28sIEkgc2hvdWxkIGZpcnN0IHByb3Bvc2UgYSBzaW1wbGUgdW5pdHRlc3RzLmNm
ZyB3b3JraW5nIHdpdGggYm90aCwNCj4gd2hpY2ggd2lsbCBTS0lQIHdpdGggIlRvcG9sb2d5
IGZhY2lsaXR5IG5vdCBwcmVzZW50IiB3aXRob3V0IHRoZSBwYXRjaC4NCj4gDQo+IFdoZW4g
dGhlIHBhdGNoIGlzIGJlY29taW5nIHVzZWQgd2UgY2FuIGFkZCBtb3JlIHRlc3RpbmdzLg0K
PiANCg0KQXMgc3RhdGVkIGFib3ZlLCB0aGUgdGVzdCBzaG91bGRuJ3QgZmFpbCBpZiB0aGUg
UUVNVSBjb2RlIGlzIG1pc3NpbmcuDQpJZiB0aGVyZSdzIG5vIGNvbnZlbmllbnQgd2F5IHRv
IGRvIGZlYXR1cmUgY2hlY2tpbmcgZm9yIHRoaXMsIHRoZW4gd2UgDQpjYW4gcHV0IHRob3Nl
IHRlc3RzIGludG8gYSBzcGVjaWFsIGdyb3VwIGFuZCBtYWtlIHN1cmUgdGhhdCB0aGlzIGdy
b3VwIA0KaXMgcnVuIGluIHRoZSBDSSBvbmNlIHRoZSBRRU1VIGNvZGUgaXMgdXBzdHJlYW0u
DQo=
