Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBDE4E2EE8
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351721AbiCURQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiCURQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:16:53 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F9D3CFC6;
        Mon, 21 Mar 2022 10:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1647882926; x=1679418926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=mMM9NAx5eo2hK5QQll1zqCg6yT1+1KOsTu0MhDOKwCY=;
  b=d3SEkDswPF9ZEl4UZ9li2xf+ajXfk0ZFRxnlVJhCNL/Ai89ESV8tBCJr
   RpG4IDC4KuRYkEWp4Xf4tZtETCluMCX0y6NBjb8uX4g5Ll4IHFk3bT1F2
   MP/NIMTKU3t9YpKT2RRPtIwxfu9svccNcUDlURu3Xuhq4tEMR2Ufh7ULR
   w=;
X-Amazon-filename: 0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch
X-IronPort-AV: E=Sophos;i="5.90,199,1643673600"; 
   d="scan'208,223";a="186510121"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 21 Mar 2022 17:15:16 +0000
Received: from EX13D32EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id B4935E00E7;
        Mon, 21 Mar 2022 17:15:15 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D32EUB001.ant.amazon.com (10.43.166.125) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 21 Mar 2022 17:15:14 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.033;
 Mon, 21 Mar 2022 17:15:14 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Topic: [PATCH v2 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Index: AQHYPUc6LvcJQy+oDUqe5JacL/SQ1A==
Date:   Mon, 21 Mar 2022 17:15:14 +0000
Message-ID: <1647882914508.15309@amazon.com>
References: <1647881191688.60603@amazon.com>
In-Reply-To: <1647881191688.60603@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.240]
Content-Type: multipart/mixed; boundary="_002_164788291450815309amazoncom_"
MIME-Version: 1.0
X-Spam-Status: No, score=-13.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164788291450815309amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

v2: Updated a comment and added a new one.=0A=
________________________________________=0A=
From: Kaya, Metin=0A=
Sent: 21 March 2022 16:46=0A=
To: Paolo Bonzini; kvm@vger.kernel.org=0A=
Cc: Woodhouse, David; Durrant, Paul; Boris Ostrovsky; linux-kernel@vger.ker=
nel.org; x86@kernel.org=0A=
Subject: [PATCH 1/1] KVM: x86/xen: add support for 32-bit guests in SCHEDOP=
_poll=0A=

--_002_164788291450815309amazoncom_
Content-Type: text/x-patch;
	name="0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch"
Content-Description: 0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch
Content-Disposition: attachment;
	filename="0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch";
	size=2919; creation-date="Mon, 21 Mar 2022 17:14:19 GMT";
	modification-date="Mon, 21 Mar 2022 17:14:19 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmMTlhODgzMmUyZTU2Zjg0M2ZkYzYyNzQwZGIxMzgxZDUwOTQ2YmUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBNb24sIDIxIE1hciAyMDIyIDExOjA1OjMyICswMDAwClN1YmplY3Q6IFtQQVRDSF0gS1ZNOiB4
ODYveGVuOiBhZGQgc3VwcG9ydCBmb3IgMzItYml0IGd1ZXN0cyBpbiBTQ0hFRE9QX3BvbGwKClRo
aXMgcGF0Y2ggaW50cm9kdWNlcyBjb21wYXQgdmVyc2lvbiBvZiBzdHJ1Y3Qgc2NoZWRfcG9sbCBm
b3IKU0NIRURPUF9wb2xsIHN1Yi1vcGVyYXRpb24gb2Ygc2NoZWRfb3AgaHlwZXJjYWxsLCByZWFk
cyBjb3JyZWN0IGFtb3VudApvZiBkYXRhICgxNiBieXRlcyBpbiAzMi1iaXQgY2FzZSwgMjQgYnl0
ZXMgb3RoZXJ3aXNlKSBieSB1c2luZyBuZXcKY29tcGF0X3NjaGVkX3BvbGwgc3RydWN0LCBjb3Bp
ZXMgaXQgdG8gc2NoZWRfcG9sbCBwcm9wZXJseSwgYW5kIGxldHMKcmVzdCBvZiB0aGUgY29kZSBy
dW4gYXMgaXMuCgpTaWduZWQtb2ZmLWJ5OiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29t
PgpSZXZpZXdlZC1ieTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4KUmV2aWV3
ZWQtYnk6IFBhdWwgRHVycmFudCA8cGR1cnJhbnRAYW1hem9uLmNvLnVrPgotLS0KIGFyY2gveDg2
L2t2bS94ZW4uYyB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KIGFyY2gveDg2
L2t2bS94ZW4uaCB8ICA3ICsrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veGVuLmMgYi9hcmNo
L3g4Ni9rdm0veGVuLmMKaW5kZXggN2QwMTk4M2QxMDg3Li4yZDBhNWQyY2E2ZjEgMTAwNjQ0Ci0t
LSBhL2FyY2gveDg2L2t2bS94ZW4uYworKysgYi9hcmNoL3g4Ni9rdm0veGVuLmMKQEAgLTk5OCwy
MCArOTk4LDQzIEBAIHN0YXRpYyBib29sIGt2bV94ZW5fc2NoZWRvcF9wb2xsKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgYm9vbCBsb25nbW9kZSwKIAlldnRjaG5fcG9ydF90IHBvcnQsICpwb3J0czsK
IAlncGFfdCBncGE7CiAKLQlpZiAoIWxvbmdtb2RlIHx8ICFsYXBpY19pbl9rZXJuZWwodmNwdSkg
fHwKKwlpZiAoIWxhcGljX2luX2tlcm5lbCh2Y3B1KSB8fAogCSAgICAhKHZjcHUtPmt2bS0+YXJj
aC54ZW5faHZtX2NvbmZpZy5mbGFncyAmIEtWTV9YRU5fSFZNX0NPTkZJR19FVlRDSE5fU0VORCkp
CiAJCXJldHVybiBmYWxzZTsKIAogCWlkeCA9IHNyY3VfcmVhZF9sb2NrKCZ2Y3B1LT5rdm0tPnNy
Y3UpOwogCWdwYSA9IGt2bV9tbXVfZ3ZhX3RvX2dwYV9zeXN0ZW0odmNwdSwgcGFyYW0sIE5VTEwp
OwogCXNyY3VfcmVhZF91bmxvY2soJnZjcHUtPmt2bS0+c3JjdSwgaWR4KTsKLQotCWlmICghZ3Bh
IHx8IGt2bV92Y3B1X3JlYWRfZ3Vlc3QodmNwdSwgZ3BhLCAmc2NoZWRfcG9sbCwKLQkJCQkJc2l6
ZW9mKHNjaGVkX3BvbGwpKSkgeworCWlmICghZ3BhKSB7CiAJCSpyID0gLUVGQVVMVDsKIAkJcmV0
dXJuIHRydWU7CiAJfQogCisJaWYgKElTX0VOQUJMRUQoQ09ORklHXzY0QklUKSAmJiBsb25nbW9k
ZSkgeworCQlpZiAoa3ZtX3ZjcHVfcmVhZF9ndWVzdCh2Y3B1LCBncGEsICZzY2hlZF9wb2xsLAor
CQkJCQlzaXplb2Yoc2NoZWRfcG9sbCkpKSB7CisJCQkqciA9IC1FRkFVTFQ7CisJCQlyZXR1cm4g
dHJ1ZTsKKwkJfQorCX0gZWxzZSB7CisJCXN0cnVjdCBjb21wYXRfc2NoZWRfcG9sbCBzcDsKKwor
CQkvKgorCQkgKiBTYW5pdHkgY2hlY2sgdGhhdCBfX3BhY2tlZCB0cmljayB3b3JrcyBmaW5lIGFu
ZCBzaXplIG9mCisJCSAqIGNvbXBhdF9zY2hlZF9wb2xsIGlzIDE2IGJ5dGVzIGp1c3QgbGlrZSBp
biB0aGUgcmVhbCBYZW4KKwkJICogMzItYml0IGNhc2UuCisJCSAqLworCQlCVUlMRF9CVUdfT04o
c2l6ZW9mKHN0cnVjdCBjb21wYXRfc2NoZWRfcG9sbCkgIT0gMTYpOworCisJCWlmIChrdm1fdmNw
dV9yZWFkX2d1ZXN0KHZjcHUsIGdwYSwgJnNwLCBzaXplb2Yoc3ApKSkgeworCQkJKnIgPSAtRUZB
VUxUOworCQkJcmV0dXJuIHRydWU7CisJCX0KKwkJc2NoZWRfcG9sbC5wb3J0cyA9IChldnRjaG5f
cG9ydF90ICopKHVuc2lnbmVkIGxvbmcpKHNwLnBvcnRzKTsKKwkJc2NoZWRfcG9sbC5ucl9wb3J0
cyA9IHNwLm5yX3BvcnRzOworCQlzY2hlZF9wb2xsLnRpbWVvdXQgPSBzcC50aW1lb3V0OworCX0K
KwogCWlmICh1bmxpa2VseShzY2hlZF9wb2xsLm5yX3BvcnRzID4gMSkpIHsKIAkJLyogWGVuICh1
bm9mZmljaWFsbHkpIGxpbWl0cyBudW1iZXIgb2YgcG9sbGVycyB0byAxMjggKi8KIAkJaWYgKHNj
aGVkX3BvbGwubnJfcG9ydHMgPiAxMjgpIHsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ZW4u
aCBiL2FyY2gveDg2L2t2bS94ZW4uaAppbmRleCBlZTVjNGFlMDc1NWMuLjhiMzZkMzQ2ZmM5YyAx
MDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL3hlbi5oCisrKyBiL2FyY2gveDg2L2t2bS94ZW4uaApA
QCAtMTk2LDYgKzE5NiwxMyBAQCBzdHJ1Y3QgY29tcGF0X3NoYXJlZF9pbmZvIHsKIAlzdHJ1Y3Qg
Y29tcGF0X2FyY2hfc2hhcmVkX2luZm8gYXJjaDsKIH07CiAKK3N0cnVjdCBjb21wYXRfc2NoZWRf
cG9sbCB7CisJLyogVGhpcyBpcyBhY3R1YWxseSBhIGd1ZXN0IHZpcnR1YWwgYWRkcmVzcyB3aGlj
aCBwb2ludHMgdG8gcG9ydHMuICovCisJdWludDMyX3QgcG9ydHM7CisJdW5zaWduZWQgaW50IG5y
X3BvcnRzOworCXVpbnQ2NF90IHRpbWVvdXQ7Cit9IF9fcGFja2VkOworCiAjZGVmaW5lIENPTVBB
VF9FVlRDSE5fMkxfTlJfQ0hBTk5FTFMgKDggKgkJCQlcCiAJCQkJICAgICAgc2l6ZW9mX2ZpZWxk
KHN0cnVjdCBjb21wYXRfc2hhcmVkX2luZm8sIFwKIAkJCQkJCSAgIGV2dGNobl9wZW5kaW5nKSkK
LS0gCjIuMzIuMAoK

--_002_164788291450815309amazoncom_--
