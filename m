Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF314375981
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbhEFRhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:37:04 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:55432 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbhEFRhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620322565; x=1651858565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=piYi3X/u0US2AvKzdQus+p/NR5JaaHFQWVKD3MHLA3Q=;
  b=GouZOHMZen/Mdlg/m/23XXYDZ4XU5clyUzhZIKH5skKhSe+ZO9rzUszB
   jyVOgeU7UK5roT0kRnkXDVxfme3aAqmdkBBwQdneHiZPmpZWPwukGYRMU
   7zCfLIsuSfjB8y0e3QVZF7AuW7x1RgoKD5eqGkBY3StFSNYIvNbRIF4Hn
   U=;
X-IronPort-AV: E=Sophos;i="5.82,278,1613433600"; 
   d="scan'208";a="133689731"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 May 2021 17:35:55 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id D1A72A1FAA;
        Thu,  6 May 2021 17:35:50 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 6 May 2021 17:35:48 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 6 May 2021 17:35:48 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.015;
 Thu, 6 May 2021 17:35:47 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "haozhong.zhang@intel.com" <haozhong.zhang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "dplotnikov@virtuozzo.com" <dplotnikov@virtuozzo.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
Thread-Topic: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
Thread-Index: AQHXQp4/TUbPu4/cb0yPcPKj6A7fvA==
Date:   Thu, 6 May 2021 17:35:47 +0000
Message-ID: <8ebf2b17f339bf21b69bba41575e62f98ec87105.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-5-ilstam@mailbox.org>
         <50f86951-1cea-b7aa-7236-f28edd5eca8d@redhat.com>
In-Reply-To: <50f86951-1cea-b7aa-7236-f28edd5eca8d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.148]
Content-Type: text/plain; charset="utf-8"
Content-ID: <128AA1FBDD84214BA3DC2679F135CCDA@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTA2IGF0IDEzOjMyICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwNi8wNS8yMSAxMjozMiwgaWxzdGFtQG1haWxib3gub3JnIHdyb3RlOg0KPiA+ICsgICAg
IGlmICh2bWNzMTItPmNwdV9iYXNlZF92bV9leGVjX2NvbnRyb2wgJg0KPiA+IENQVV9CQVNFRF9V
U0VfVFNDX09GRlNFVFRJTkcpIHsNCj4gPiArICAgICAgICAgICAgIGlmICh2bWNzMTItPnNlY29u
ZGFyeV92bV9leGVjX2NvbnRyb2wgJg0KPiA+IFNFQ09OREFSWV9FWEVDX1RTQ19TQ0FMSU5HKSB7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHZjcHUtPmFyY2gudHNjX29mZnNldCA9DQo+ID4g
a3ZtX2NvbXB1dGVfMDJfdHNjX29mZnNldCgNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHZjcHUtPmFyY2gubDFfdHNjX29mZnNldCwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHZtY3MxMi0+dHNjX211bHRpcGxpZXIsDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2bWNzMTItPnRzY19vZmZzZXQpOw0K
PiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19y
YXRpbyA9DQo+ID4gbXVsX3U2NF91NjRfc2hyKA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19yYXRpbywNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZtY3MxMi0+dHNjX211bHRpcGxpZXIsDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBrdm1fdHNjX3NjYWxpbmdf
cmF0aW9fZnJhY19iaXQNCj4gPiBzKTsNCj4gPiArICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIHZjcHUtPmFyY2gudHNjX29mZnNldCArPSB2bWNzMTItPnRz
Y19vZmZzZXQ7DQo+ID4gKyAgICAgICAgICAgICB9DQo+IA0KPiBUaGUgY29tcHV0YXRpb24gb2Yg
dmNwdS0+YXJjaC50c2Nfb2Zmc2V0IGlzIChub3QgY29pbmNpZGVudGlhbGx5KSB0aGUNCj4gc2Ft
ZSB0aGF0IGFwcGVhcnMgaW4gcGF0Y2ggNg0KPiANCj4gKyAgICAgICAgICAgKHZtY3MxMi0+Y3B1
X2Jhc2VkX3ZtX2V4ZWNfY29udHJvbCAmDQo+IENQVV9CQVNFRF9VU0VfVFNDX09GRlNFVFRJTkcp
KSB7DQo+ICsgICAgICAgICAgICAgICBpZiAodm1jczEyLT5zZWNvbmRhcnlfdm1fZXhlY19jb250
cm9sICYNCj4gU0VDT05EQVJZX0VYRUNfVFNDX1NDQUxJTkcpIHsNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgY3VyX29mZnNldCA9IGt2bV9jb21wdXRlXzAyX3RzY19vZmZzZXQoDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsMV9vZmZzZXQsDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2bWNzMTItPnRzY19tdWx0aXBsaWVyLA0K
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm1jczEyLT50c2Nfb2Zm
c2V0KTsNCj4gKyAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIGN1cl9vZmZzZXQgPSBsMV9vZmZzZXQgKyB2bWNzMTItPnRzY19vZmZzZXQ7DQo+IA0KPiBT
byBJIHRoaW5rIHlvdSBzaG91bGQganVzdCBwYXNzIHZtY3MxMiBhbmQgdGhlIEwxIG9mZnNldCB0
bw0KPiBrdm1fY29tcHV0ZV8wMl90c2Nfb2Zmc2V0LCBhbmQgbGV0IGl0IGhhbmRsZSBib3RoIGNh
c2VzIChhbmQgcG9zc2libHkNCj4gZXZlbiBzZXQgdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19yYXRp
byBpbiB0aGUgc2FtZSBmdW5jdGlvbikuDQo+IA0KPiBQYW9sbw0KPiANCg0KVGhhdCB3YXMgbXkg
dGhpbmtpbmcgaW5pdGlhbGx5IHRvby4gSG93ZXZlciwga3ZtX2NvbXB1dGVfMDJfdHNjX29mZnNl
dA0KaXMgZGVmaW5lZCBpbiB4ODYuYyB3aGljaCBpcyB2bXgtYWdub3N0aWMgYW5kIGhlbmNlICdz
dHJ1Y3Qgdm1jczEyJyBpcw0Kbm90IGRlZmluZWQgdGhlcmUuIA0KDQpUaGUgd2F5IGl0IGlzIG5v
dywgdGhhdCBmdW5jdGlvbiBjYW4gYmUgcmUtdXNlZCBieSBzdm0gY29kZSBpbiBjYXNlIHdlDQph
ZGQgYW1kIHN1cHBvcnQgbGF0ZXIuDQoNCkkgY291bGQgdHJ5IHRvIGRlZmluZSBhIHdyYXBwZXIg
aW4gdm14LmMgaW5zdGVhZCwgdGhhdCBjYWxscw0Ka3ZtX2NvbXB1dGVfMDJfdHNjX29mZnNldCBh
bmQgbW92ZSBhbGwgdGhlIGNvZGUgdGhlcmUuIEhvd2V2ZXIsIEkgdGhpbmsNCnRoaXMgcmVxdWly
ZXMgbWFueSBtb3JlIGNoYW5nZXMgdG8gdGhlIHZteCBhbmQgc3ZtIHdyaXRlX2wxX3RzY19vZmZz
ZXQNCmZ1bmN0aW9ucyBhbmQgdG8gdGhlaXIgY2FsbGVyLiBJIGFtIGxvb2tpbmcgYXQgaXQgbm93
LiANCg0KSWxpYXMNCg==
