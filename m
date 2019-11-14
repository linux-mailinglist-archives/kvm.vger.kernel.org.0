Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9DFC9DF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKNPZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:25:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfKNPZ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573745127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKYCmTxFGEQzkrZiaOpvhYM9V1nG/QF6MJIc5vMkLeI=;
        b=LLUf7tbAaaaioFBZh6VF6Wof4YmVD6TjUqOGyAqojNYNQ/JN42Xgnoysvro4gRuu50si8H
        EOYouIzxdVBtCSnUNVi4vDQ2xHSL0mhbR7fxtCDtqHLUjNidXCQhYS9dNTztBEQuZKtePI
        PyAbVhH/vbMkzOMr6wlT613sZar+O8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-vNWIDD47P8GHiiRCelpfhQ-1; Thu, 14 Nov 2019 10:25:23 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4998107ACC6;
        Thu, 14 Nov 2019 15:25:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 991B85D9E2;
        Thu, 14 Nov 2019 15:25:22 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CD6A182B00E;
        Thu, 14 Nov 2019 15:25:22 +0000 (UTC)
From:   David Hildenbrand <dhildenb@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
Date:   Thu, 14 Nov 2019 10:25:22 -0500 (EST)
Message-Id: <7C13E9AB-F26B-439B-A170-F187BC1E1136@redhat.com>
References: <6c84ade5-8a42-9c73-abff-47e019fc11bd@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com
In-Reply-To: <6c84ade5-8a42-9c73-abff-47e019fc11bd@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Thread-Topic: s390x: saving regs for interrupts
Thread-Index: 2ipOXvAHQqaDJRwVmNe/3QfngCvL3Q==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: vNWIDD47P8GHiiRCelpfhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gQW0gMTQuMTEuMjAxOSB1bSAxNjoyMSBzY2hyaWViIFBpZXJyZSBNb3JlbCA8cG1vcmVs
QGxpbnV4LmlibS5jb20+Og0KPiANCj4g77u/DQo+PiBPbiAyMDE5LTExLTE0IDEzOjExLCBEYXZp
ZCBIaWxkZW5icmFuZCB3cm90ZToNCj4+PiBPbiAxNC4xMS4xOSAxMjo1NywgUGllcnJlIE1vcmVs
IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDIwMTktMTEtMTQgMTE6MjgsIERhdmlkIEhpbGRlbmJyYW5k
IHdyb3RlOg0KPj4+PiANCj4+Pj4+IEFtIDE0LjExLjIwMTkgdW0gMTE6MTEgc2NocmllYiBQaWVy
cmUgTW9yZWwgPHBtb3JlbEBsaW51eC5pYm0uY29tPjoNCj4+Pj4+IA0KPj4+Pj4g77u/DQo+Pj4+
Pj4gT24gMjAxOS0xMS0xMyAxNzoxMiwgSmFub3NjaCBGcmFuayB3cm90ZToNCj4+Pj4+Pj4gT24g
MTEvMTMvMTkgMToyMyBQTSwgUGllcnJlIE1vcmVsIHdyb3RlOg0KPj4+Pj4+PiBJZiB3ZSB1c2Ug
bXVsdGlwbGUgc291cmNlIG9mIGludGVycnVwdHMsIGZvciBleGVtcGxlLCB1c2luZyBTQ0xQIGNv
bnNvbGUNCj4+Pj4+Pj4gdG8gcHJpbnQgaW5mb3JtYXRpb24gd2hpbGUgdXNpbmcgSS9PIGludGVy
cnVwdHMgb3IgZHVyaW5nIGV4Y2VwdGlvbnMsIHdlDQo+Pj4+Pj4+IG5lZWQgdG8gaGF2ZSBhIHJl
LWVudHJhbnQgcmVnaXN0ZXIgc2F2aW5nIGludGVycnVwdGlvbiBoYW5kbGluZy4NCj4+Pj4+Pj4g
DQo+Pj4+Pj4+IEluc3RlYWQgb2Ygc2F2aW5nIGF0IGEgc3RhdGljIHBsYWNlLCBsZXQncyBzYXZl
IHRoZSBiYXNlIHJlZ2lzdGVycyBvbg0KPj4+Pj4+PiB0aGUgc3RhY2suDQo+Pj4+Pj4+IA0KPj4+
Pj4+PiBOb3RlIHRoYXQgd2Uga2VlcCB0aGUgc3RhdGljIHJlZ2lzdGVyIHNhdmluZyB0aGF0IHdl
IG5lZWQgZm9yIHRoZSBSRVNFVA0KPj4+Pj4+PiB0ZXN0cy4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFdl
IGFsc28gY2FyZSB0byBnaXZlIHRoZSBoYW5kbGVycyBhIHBvaW50ZXIgdG8gdGhlIHNhdmUgcmVn
aXN0ZXJzIGluDQo+Pj4+Pj4+IGNhc2UgdGhlIGhhbmRsZXIgbmVlZHMgaXQgKGZpeHVwX3BnbV9p
bnQgbmVlZHMgdGhlIG9sZCBwc3cgYWRkcmVzcykuDQo+Pj4+Pj4gU28geW91J3JlIHN0aWxsIGln
bm9yaW5nIHRoZSBGUFJzLi4uDQo+Pj4+Pj4gSSBkaXNhc3NlbWJsZWQgYSB0ZXN0IGFuZCBsb29r
ZWQgYXQgYWxsIHN0ZHMgYW5kIGl0IGxvb2tzIGxpa2UgcHJpbnRmDQo+Pj4+Pj4gYW5kIHJlbGF0
ZWQgZnVuY3Rpb25zIHVzZSB0aGVtLiBXb3VsZG4ndCB3ZSBvdmVyd3JpdGUgdGVzdCBGUFJzIGlm
DQo+Pj4+Pj4gcHJpbnRpbmcgaW4gYSBoYW5kbGVyPw0KPj4+Pj4gSWYgcHJpbnRmIHVzZXMgdGhl
IEZQUnMgaW4gbXkgb3BpbmlvbiB3ZSBzaG91bGQgbW9kaWZ5IHRoZSBjb21waWxhdGlvbiBvcHRp
b25zIGZvciB0aGUgbGlicmFyeS4NCj4+Pj4+IA0KPj4+Pj4gV2hhdCBpcyB0aGUgcmVhc29uIGZv
ciBwcmludGYgYW5kIHJlbGF0ZWQgZnVuY3Rpb25zIHRvIHVzZSBmbG9hdGluZyBwb2ludD8NCj4+
Pj4+IA0KPj4+PiBSZWdpc3RlciBzcGlsbGluZy4gVGhpcyBjYW4gYW5kIHdpbGwgYmUgZG9uZS4N
Cj4+PiANCj4+PiANCj4+PiBIdW0sIGNhbiB5b3UgcGxlYXNlIGNsYXJpZnk/DQo+Pj4gDQo+Pj4g
QUZBSUsgcmVnaXN0ZXIgc3BpbGxpbmcgaXMgZm9yIGEgY29tcGlsZXIsIHRvIHVzZSBtZW1vcnkg
aWYgaXQgaGFzIG5vdA0KPj4+IGVub3VnaCByZWdpc3RlcnMuDQo+PiANCj4+IE5vdCBzdHJpY3Rs
eSBtZW1vcnkuIElmIHRoZSBjb21waWxlciBuZWVkcyBtb3JlIEdQUlMsIGl0IGNhbiBzYXZlL3Jl
c3RvcmUgR1BSUyB0byBGUFJTLg0KPj4gDQo+PiBBbnkgZnVuY3Rpb24gdGhlIGNvbXBpbGVyIGdl
bmVyYXRlcyBpcyBmcmVlIHRvIHVzZSB0aGUgRlBSUy4uDQo+PiANCj4+PiANCj4+PiBTbyB5b3Vy
IGFuc3dlciBpcyBmb3IgdGhlIG15IGZpcnN0IHNlbnRlbmNlLCBtZWFuaW5nIHllcyByZWdpc3Rl
cg0KPj4+IHNwaWxsaW5nIHdpbGwgYmUgZG9uZQ0KPj4+IG9yDQo+Pj4gZG8geW91IG1lYW4gcmVn
aXN0ZXIgc3BpbGxpbmcgaXMgdGhlIHJlYXNvbiB3aHkgdGhlIGNvbXBpbGVyIHVzZSBGUFJzDQo+
Pj4gYW5kIGl0IG11c3QgYmUgZG9uZSBzbz8NCj4+IA0KPj4gQ29uZnVzZWQgYnkgYm90aCBvcHRp
b25zIDpEIFRoZSBjb21waWxlciBtaWdodCBnZW5lcmF0ZSBjb2RlIHRoYXQgdXNlcyB0aGUgRlBS
UyBhbHRob3VnaCBubyBmbG9hdGluZyBwb2ludCBpbnN0cnVjdGlvbnMgYXJlIGluIHVzZS4gVGhh
dCdzIHdoeSB3ZSBoYXZlIHRvIGVuYWJsZSB0aGUgQUZQIGNvbnRyb2wgYW5kIHByb3Blcmx5IHRh
a2UgY2FyZSBvZiBGUFJTIGJlaW5nIHVzZWQuDQo+PiANCj4+IA0KPiBUaGUgY29tcGlsZXIgaGFz
IHRoZSAtbXNvZnQtZmxvYXQgc3dpdGNoIHRvIGF2b2lkIHVzaW5nIHRoZSBmbG9hdGluZyBwb2lu
dCBpbnN0cnVjdGlvbnMgYW5kIHJlZ2lzdGVycywgc28gaXQgaXMgb3VyIGRlY2lzaW9uLg0KDQpO
bywgbm90IHJlZ2lzdGVycyBBRkFJSy4NCg0KPiANCj4gU2F2aW5nIHRoZSBGUCByZWdpc3RlcnMg
b24gZXhjZXB0aW9ucyBpcyBub3QgdmVyeSBlZmZpY2llbnQsIHdlIGxvb3NlIHRpbWUgb24gZWFj
aCBpbnRlcnJ1cHQsIG5vdCBzdXJlIHRoYXQgd2Ugd2luIGl0IGJhY2sgYnkgdXNpbmcgRlByZWdz
IHRvIGFzIFJlZ3MgYmFja3VwLg0KDQpXaG8gb24gZWFydGggY2FyZXMgYWJvdXQgcGVyZm9ybWFu
Y2UgaGVyZT8NCg0KPiANCj4gVXN1YWxseSBhIHN5c3RlbSBhdCBsb3cgbGV2ZWwgdXNlcyBzb21l
IGVudGVyX2ZwdSwgbGVhdmVfZnB1IHJvdXRpbmUgdG8gZW50ZXIgY3JpdGljYWwgc2VjdGlvbnMg
dXNpbmcgRlBVIGluc3RlYWQgb2YgbG9zaW5nIHRpbWUgb24gZWFjaCBpbnRlcnJ1cHRpb25zLg0K
PiANCj4gV2UgY2FuIHRoaW5rIGFib3V0IHRoaXMsIGluIGJldHdlZW4gSSBkbyBhcyB5b3UgcmVj
b21hbmQgYW5kIHNhdmUgdGhlIEZQcmVncyB0b28uDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IA0K
PiBQaWVycmUNCj4gDQo+IA0KPiAtLSANCj4gUGllcnJlIE1vcmVsDQo+IElCTSBMYWIgQm9lYmxp
bmdlbg0KPiANCg==

