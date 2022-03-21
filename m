Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565C14E2E76
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 17:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351394AbiCUQsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 12:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351385AbiCUQsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 12:48:22 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7E51697AE;
        Mon, 21 Mar 2022 09:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1647881216; x=1679417216;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=11MtvQeckV9uTaf9kXjew1AzhoHaTDnjRXrFiqHtAhA=;
  b=GsLz068INP7SZizwqCIBwLZ9ZcHj3khI+u4m7NIuX08V4llusTZmH6Ko
   amQEBJsGq2KOB8Jfsc6fKNxpP2yWrwwRI3XQJlVKH343iFyzS9GQBCnFv
   tSemVtzumRs6H5sRz+PbO/xeNHBvec1Q6cw0iG1VuvV3WrafFkNmHOU4+
   Q=;
X-Amazon-filename: 0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch
X-IronPort-AV: E=Sophos;i="5.90,199,1643673600"; 
   d="scan'208,223";a="72785739"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 Mar 2022 16:46:33 +0000
Received: from EX13D32EUB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com (Postfix) with ESMTPS id 3E18041D51;
        Mon, 21 Mar 2022 16:46:33 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D32EUB002.ant.amazon.com (10.43.166.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 21 Mar 2022 16:46:32 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.033;
 Mon, 21 Mar 2022 16:46:31 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Topic: [PATCH 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Index: AQHYPUKXQJvuOGfU2UCQzahjrnQ1Og==
Date:   Mon, 21 Mar 2022 16:46:31 +0000
Message-ID: <1647881191688.60603@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.153]
Content-Type: multipart/mixed; boundary="_002_164788119168860603amazoncom_"
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

--_002_164788119168860603amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


--_002_164788119168860603amazoncom_
Content-Type: text/x-patch;
	name="0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch"
Content-Description: 0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch
Content-Disposition: attachment;
	filename="0001-KVM-x86-xen-add-support-for-32-bit-guests-in-SCHEDOP.patch";
	size=2871; creation-date="Mon, 21 Mar 2022 16:46:18 GMT";
	modification-date="Mon, 21 Mar 2022 16:46:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0OTExMzk1OTU1MDUyNWJlNDBjMjNlOGJmYzRhZGRmNjllZGVjYTQ3IE1vbiBTZXAgMTcg
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
L2t2bS94ZW4uYyB8IDMwICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQogYXJjaC94ODYv
a3ZtL3hlbi5oIHwgIDcgKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ZW4uYyBiL2FyY2gv
eDg2L2t2bS94ZW4uYwppbmRleCA3ZDAxOTgzZDEwODcuLmMwMjE2M2JmMWE5NyAxMDA2NDQKLS0t
IGEvYXJjaC94ODYva3ZtL3hlbi5jCisrKyBiL2FyY2gveDg2L2t2bS94ZW4uYwpAQCAtOTk4LDIw
ICs5OTgsNDIgQEAgc3RhdGljIGJvb2wga3ZtX3hlbl9zY2hlZG9wX3BvbGwoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCBib29sIGxvbmdtb2RlLAogCWV2dGNobl9wb3J0X3QgcG9ydCwgKnBvcnRzOwog
CWdwYV90IGdwYTsKIAotCWlmICghbG9uZ21vZGUgfHwgIWxhcGljX2luX2tlcm5lbCh2Y3B1KSB8
fAorCWlmICghbGFwaWNfaW5fa2VybmVsKHZjcHUpIHx8CiAJICAgICEodmNwdS0+a3ZtLT5hcmNo
Lnhlbl9odm1fY29uZmlnLmZsYWdzICYgS1ZNX1hFTl9IVk1fQ09ORklHX0VWVENITl9TRU5EKSkK
IAkJcmV0dXJuIGZhbHNlOwogCiAJaWR4ID0gc3JjdV9yZWFkX2xvY2soJnZjcHUtPmt2bS0+c3Jj
dSk7CiAJZ3BhID0ga3ZtX21tdV9ndmFfdG9fZ3BhX3N5c3RlbSh2Y3B1LCBwYXJhbSwgTlVMTCk7
CiAJc3JjdV9yZWFkX3VubG9jaygmdmNwdS0+a3ZtLT5zcmN1LCBpZHgpOwotCi0JaWYgKCFncGEg
fHwga3ZtX3ZjcHVfcmVhZF9ndWVzdCh2Y3B1LCBncGEsICZzY2hlZF9wb2xsLAotCQkJCQlzaXpl
b2Yoc2NoZWRfcG9sbCkpKSB7CisJaWYgKCFncGEpIHsKIAkJKnIgPSAtRUZBVUxUOwogCQlyZXR1
cm4gdHJ1ZTsKIAl9CiAKKwlpZiAoSVNfRU5BQkxFRChDT05GSUdfNjRCSVQpICYmIGxvbmdtb2Rl
KSB7CisJCWlmIChrdm1fdmNwdV9yZWFkX2d1ZXN0KHZjcHUsIGdwYSwgJnNjaGVkX3BvbGwsCisJ
CQkJCXNpemVvZihzY2hlZF9wb2xsKSkpIHsKKwkJCSpyID0gLUVGQVVMVDsKKwkJCXJldHVybiB0
cnVlOworCQl9CisJfSBlbHNlIHsKKwkJc3RydWN0IGNvbXBhdF9zY2hlZF9wb2xsIHNwOworCisJ
CS8qCisJCSAqIFdlIGFzc3VtZSBzaXplIG9mIGNvbXBhdF9zY2hlZF9wb2xsIGlzIDE2IGJ5dGVz
IGluIDMyLWJpdAorCQkgKiBlbnZpcm9ubWVudC4gTGV0J3MgYmUgaG9uZXN0LgorCQkgKi8KKwkJ
QlVJTERfQlVHX09OKHNpemVvZihzdHJ1Y3QgY29tcGF0X3NjaGVkX3BvbGwpICE9IDE2KTsKKwor
CQlpZiAoa3ZtX3ZjcHVfcmVhZF9ndWVzdCh2Y3B1LCBncGEsICZzcCwgc2l6ZW9mKHNwKSkpIHsK
KwkJCSpyID0gLUVGQVVMVDsKKwkJCXJldHVybiB0cnVlOworCQl9CisJCXNjaGVkX3BvbGwucG9y
dHMgPSAoZXZ0Y2huX3BvcnRfdCAqKSh1bnNpZ25lZCBsb25nKShzcC5wb3J0cyk7CisJCXNjaGVk
X3BvbGwubnJfcG9ydHMgPSBzcC5ucl9wb3J0czsKKwkJc2NoZWRfcG9sbC50aW1lb3V0ID0gc3Au
dGltZW91dDsKKwl9CisKIAlpZiAodW5saWtlbHkoc2NoZWRfcG9sbC5ucl9wb3J0cyA+IDEpKSB7
CiAJCS8qIFhlbiAodW5vZmZpY2lhbGx5KSBsaW1pdHMgbnVtYmVyIG9mIHBvbGxlcnMgdG8gMTI4
ICovCiAJCWlmIChzY2hlZF9wb2xsLm5yX3BvcnRzID4gMTI4KSB7CmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0veGVuLmggYi9hcmNoL3g4Ni9rdm0veGVuLmgKaW5kZXggZWU1YzRhZTA3NTVjLi5i
NWIyMDhjZDhjOWYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS94ZW4uaAorKysgYi9hcmNoL3g4
Ni9rdm0veGVuLmgKQEAgLTE5Niw2ICsxOTYsMTMgQEAgc3RydWN0IGNvbXBhdF9zaGFyZWRfaW5m
byB7CiAJc3RydWN0IGNvbXBhdF9hcmNoX3NoYXJlZF9pbmZvIGFyY2g7CiB9OwogCitzdHJ1Y3Qg
Y29tcGF0X3NjaGVkX3BvbGwgeworCS8qIFRoaXMgaXMgYWN0dWFsbHkgYSBwb2ludGVyIHdoaWNo
IGhhcyB0byBiZSA0IGJ5dGVzIGluIHNpemUuICovCisJdWludDMyX3QgcG9ydHM7CisJdW5zaWdu
ZWQgaW50IG5yX3BvcnRzOworCXVpbnQ2NF90IHRpbWVvdXQ7Cit9IF9fcGFja2VkOworCiAjZGVm
aW5lIENPTVBBVF9FVlRDSE5fMkxfTlJfQ0hBTk5FTFMgKDggKgkJCQlcCiAJCQkJICAgICAgc2l6
ZW9mX2ZpZWxkKHN0cnVjdCBjb21wYXRfc2hhcmVkX2luZm8sIFwKIAkJCQkJCSAgIGV2dGNobl9w
ZW5kaW5nKSkKLS0gCjIuMzIuMAoK

--_002_164788119168860603amazoncom_--
