Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB242C411
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhJMO5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35330 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhJMO5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:30 -0400
Message-ID: <20211013142847.120153383@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AwjCE+xbKu/H5GJ4tKzEriYfUyjYPMqyOA9GgccpEN8=;
        b=vGvtj7QOjQxo5JpHwUyhU4pbIugKHK/XCLwe/n5ttBjM4l7SyJ4xlA65Ko1ZUzEv2awVaX
        fNM0l8D7Pfpu7M/+rAZzAwjoP98CGmA8edZe/wLJ1cQt9zEc8GA2zPPDDH5L9H+ir4sMKL
        kC9MvJymn4TCJ8KcQeSVHxSCKL42hC/0fnKsZhUo/gtD0S/xXZOJl3M9r1HXDlTD7W8XqI
        zs2Yqv4QIoOQCCDWRQ3Ogl3oRsl+It6yiREA+syBHDb51KOm9hJW9XxKWbcPo3ww1yUXFo
        Ms+p95wPzHa57Xelx1Z8LErhG0XrzhmX3VNRj3tGHohqEySn0ygZxRju1AeGJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AwjCE+xbKu/H5GJ4tKzEriYfUyjYPMqyOA9GgccpEN8=;
        b=dfJTIxlxXgOfDJZqaymmk0A+YhfOFQsw2pQpmINKe4CUs0Q9Q/7deoSNvAk5KK2VeWXnf+
        dV+spq7ZDAV7gzDQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 00/21] x86/fpu: Move register state into a container struct (part 2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Wed, 13 Oct 2021 16:55:25 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBpcyB0aGUgc2Vjb25kIHBhcnQgb2YgdGhlIGVmZm9ydCB0byBzdXBwb3J0IEFNWC4gVGhl
IGZpcnN0IHBhcnQgY2FuIGJlCmZvdW5kIGhlcmU6CgogICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMTEwMTEyMTU4MTMuNTU4NjgxMzczQGxpbnV0cm9uaXguZGUKCldpdGggQU1YIHRo
ZSBGUFUgcmVnaXN0ZXIgc3RhdGUgYnVmZmVyIHdoaWNoIGlzIHBhcnQgb2YKdGFza19zdHJ1Y3Q6
OnRocmVhZDo6ZnB1IGlzIG5vdCBnb2luZyB0byBiZSBleHRlbmRlZCB1bmNvbmRpdGlvbmFsbHkg
Zm9yCmFsbCB0YXNrcyBvbiBhbiBBTVggZW5hYmxlZCBzeXN0ZW0gYXMgdGhhdCB3b3VsZCB3YXN0
ZSBtaW5pbXVtIDhLIHBlciB0YXNrLgoKQU1YIHByb3ZpZGVzIGEgbWVjaGFuaXNtIHRvIHRyYXAg
b24gZmlyc3QgdXNlLiBUaGF0IHRyYXAgd2lsbCBiZSB1dGlsaXplZAp0byBhbGxvY2F0ZSBhIGxh
cmdlciByZWdpc3RlciBzdGF0ZSBidWZmZXIgd2hlbiB0aGUgdGFzayAocHJvY2VzcykgaGFzCnBl
cm1pc3Npb25zIHRvIHVzZSBpdC4gVGhlIGRlZmF1bHQgYnVmZmVyIHRhc2tfc3RydWN0IHdpbGwg
b25seSBjYXJyeQpzdGF0ZXMgdXAgdG8gQVZYNTEyLgoKVGhlIG9yaWdpbmFsIGFwcHJvYWNoIHdh
cyB0byBqdXN0IGFsbG9jYXRlIG5ldyByZWdpc3RlciBidWZmZXIsIGJ1dCB0aGF0J3MKbm90IHRo
ZSByaWdodCBhYnN0cmFjdGlvbi4KClRoZSBjdXJyZW50IHNlcmllcyBjcmVhdGVzIGEgY29udGFp
bmVyIHdoaWNoIGNhcnJpZXMgaW5mb3JtYXRpb24gYWJvdXQgdGhlCmZwc3RhdGUgYnVmZmVyLCBp
LmUuIGZlYXR1cmUgYml0cyAodXNlciBhbmQga2VybmVsKSBhbmQgc2l6ZXMgKHVzZXIgYW5kCmtl
cm5lbCkuCgpUaGF0IGFsbG93cyBhbGwgcmVsZXZhbnQgY29kZSBwYXRoZXMgdG8gcmV0cmlldmUg
dGhlIHJlcXVpcmVkIGluZm9ybWF0aW9uCmZyb20gZnBzdGF0ZSB3aGljaCBhdm9pZHMgY29uZGl0
aW9uYWxzIGFuZCBsZXRzIHRoZSBjb2RlIGp1c3QgdXNlIHRoaXMKaW5zdGVhZCBvZiByZWFkaW5n
IGl0IGZyb20gdGhlIHZhcmlvdXMgZ2xvYmFsIHZhcmlhYmxlcyB3aGljaCBwcm92aWRlIHRoaXMK
aW5mb3JtYXRpb24gdG9kYXkuCgpUaGUgc2VyaWVzIGlzIGZpcnN0IGludHJvZHVjaW5nIHRoZSBu
ZXcgc3RydWN0dXJlIGFuZCB0aGVuIGNvbnZlcnRpbmcgYWxsCnVzYWdlIHNpdGVzIG92ZXIgdG8g
aXQuIEFmdGVyIHRoYXQgaXQgYWRkcyBmZWF0dXJlIGFuZCBzaXplIGluZm9ybWF0aW9uIGFuZApj
b252ZXJ0cyB0aGUgYWZmZWN0ZWQgY29kZSBvdmVyIHRvIHVzZSB0aGF0LgoKVGhpcyBzZXJpZXMg
aXMgYmFzZWQgb246CgogICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdGdseC9kZXZlbC5naXQgeDg2L2ZwdS0xCgphbmQgYWxzbyBhdmFpbGFibGUgZnJvbSBn
aXQ6CgogICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGds
eC9kZXZlbC5naXQgeDg2L2ZwdS0yCgpUaGUgZnVsbCBzZXJpZXMgd2l0aCBwYXJ0IDMgYW5kIDQg
b24gdG9wIGlzIGF2YWlsYWJsZSBoZXJlOgoKICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RnbHgvZGV2ZWwuZ2l0IHg4Ni9mcHUKClRoYW5rcywKCgl0Z2x4
Ci0tLQogaW5jbHVkZS9hc20vZnB1L2FwaS5oICAgIHwgICAgNSArCiBpbmNsdWRlL2FzbS9mcHUv
c2lnbmFsLmggfCAgICAyIAogaW5jbHVkZS9hc20vZnB1L3R5cGVzLmggIHwgICA0MiArKysrKysr
KysrKy0tLQogaW5jbHVkZS9hc20vZnB1L3hzdGF0ZS5oIHwgICAxMyAtLS0tCiBpbmNsdWRlL2Fz
bS9wcm9jZXNzb3IuaCAgfCAgICA5ICstLQogaW5jbHVkZS9hc20vdHJhY2UvZnB1LmggIHwgICAg
NCAtCiBrZXJuZWwvZnB1L2NvbnRleHQuaCAgICAgfCAgICAyIAoga2VybmVsL2ZwdS9jb3JlLmMg
ICAgICAgIHwgIDE0MCArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0tLQoga2VybmVsL2ZwdS9pbml0LmMgICAgICAgIHwgICAxNiArKysrLQoga2VybmVsL2ZwdS9p
bnRlcm5hbC5oICAgIHwgICAgNyArLQoga2VybmVsL2ZwdS9yZWdzZXQuYyAgICAgIHwgICAyOCAr
KysrLS0tLS0KIGtlcm5lbC9mcHUvc2lnbmFsLmMgICAgICB8ICAgNzAgKysrKysrKysrKysrKy0t
LS0tLS0tLS0KIGtlcm5lbC9mcHUveHN0YXRlLmMgICAgICB8ICAgNTYgKysrKysrKysrKysrLS0t
LS0tCiBrZXJuZWwvZnB1L3hzdGF0ZS5oICAgICAgfCAgIDI0ICsrKysrKy0tCiBrZXJuZWwvcHJv
Y2Vzcy5jICAgICAgICAgfCAgICAyIAoga3ZtL3g4Ni5jICAgICAgICAgICAgICAgIHwgICAxOCAr
Ky0tLS0KIG1hdGgtZW11L2ZwdV9hdXguYyAgICAgICB8ICAgIDIgCiBtYXRoLWVtdS9mcHVfZW50
cnkuYyAgICAgfCAgICA0IC0KIG1hdGgtZW11L2ZwdV9zeXN0ZW0uaCAgICB8ICAgIDIgCiAxOSBm
aWxlcyBjaGFuZ2VkLCAyNjYgaW5zZXJ0aW9ucygrKSwgMTgwIGRlbGV0aW9ucygtKQoK
