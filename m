Return-Path: <kvm+bounces-6716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8D68385DC
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 03:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBCA929177D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743E2810;
	Tue, 23 Jan 2024 02:58:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEEFA40
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.101.248.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705978699; cv=none; b=qTFBjeIIBnC1hvbJjFU6zkHKHZLd/LktnDVMk65i8a3tdL129A88YXGRp3UMsQxKGRTt0Mclyr8Y17EnrOGPfTXgLKALPJQ+HScRYBL8Vx/+YebNdSLxrMMsurfGO2v4m7TW1N+Fn1/8T8l+2zQYIU9BKWagaTc7xhFWVzAFSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705978699; c=relaxed/simple;
	bh=UbKo0RDP0BdW+kVCExz0Qyy+Nk8Cdu5yi9Sw3PTpp3k=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=CnjgijkIZfdGqMQfJPEBdqbrPs4Q+C8D/1g60Mah1i6sGoTvY3TYso8ZlA1rtbnDDUx4hJPXEBGFqqdUYdnnSayeSk0PHQFV3oAsEx9Wh1rXifUc/qM0KHyRgIAF823N+tjCHDQn0F9jPk+BqR14erJhrL3kpZ1Gun3BKpfXJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn; spf=pass smtp.mailfrom=bosc.ac.cn; arc=none smtp.client-ip=46.101.248.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bosc.ac.cn
Received: from qinshaoqing$bosc.ac.cn ( [123.114.53.210] ) by
 ajax-webmail-mail (Coremail) ; Tue, 23 Jan 2024 10:57:59 +0800 (GMT+08:00)
Date: Tue, 23 Jan 2024 10:57:59 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?56em5bCR6Z2S?= <qinshaoqing@bosc.ac.cn>
To: Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>, 
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Patel <apatel@ventanamicro.com>, 
	=?UTF-8?B?546L54S2?= <wangran@bosc.ac.cn>, 
	=?UTF-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: [kvmtool PATCH 1/1] riscv: Add zacas extension
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT5 build
 20230627(00751abc) Copyright (c) 2002-2024 www.mailtech.cn
 mispb-76b96e3b-3ecc-44d5-9200-de81e6d4c242-
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <3095a39b.95.18d3440cf62.Coremail.qinshaoqing@bosc.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwBH4EY3K69l5G+sAA--.1001W
X-CM-SenderInfo: ptlq2xpdrtx03j6e02nfoduhdfq/1tbiAQAGAWWukV4CHgABsf
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

QWRkIHBhcnNpbmcgZm9yIFphY2FzIElTQSBleHRlbnNpb24gd2hpY2ggd2FzIHJhdGlmaWVkIHJl
Y2VudGx5IGluIHRoZQpyaXNjdi16YWNhcyBtYW51YWwuCgpTaWduZWQtb2ZmLWJ5OiBTaGFvcWlu
ZyBRaW4gPHFpbnNoYW9xaW5nQGJvc2MuYWMuY24+Ci0tLQogcmlzY3YvZmR0LmMgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAxICsKIHJpc2N2L2luY2x1ZGUvYXNtL2t2bS5oICAgICAgICAgICAg
IHwgMSArCiByaXNjdi9pbmNsdWRlL2t2bS9rdm0tY29uZmlnLWFyY2guaCB8IDMgKysrCiAzIGZp
bGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3Jpc2N2L2ZkdC5jIGIv
cmlzY3YvZmR0LmMKaW5kZXggOWFmNzFiNS4uMWI0ZjcwMSAxMDA2NDQKLS0tIGEvcmlzY3YvZmR0
LmMKKysrIGIvcmlzY3YvZmR0LmMKQEAgLTIyLDYgKzIyLDcgQEAgc3RydWN0IGlzYV9leHRfaW5m
byBpc2FfaW5mb19hcnJbXSA9IHsKIAl7InN2bmFwb3QiLCBLVk1fUklTQ1ZfSVNBX0VYVF9TVk5B
UE9UfSwKIAl7InN2cGJtdCIsIEtWTV9SSVNDVl9JU0FfRVhUX1NWUEJNVH0sCiAJeyJ6YmIiLCBL
Vk1fUklTQ1ZfSVNBX0VYVF9aQkJ9LAorCXsiemFjYXMiLCBLVk1fUklTQ1ZfSVNBX0VYVF9aQUNB
U30sCiAJeyJ6aWNib20iLCBLVk1fUklTQ1ZfSVNBX0VYVF9aSUNCT019LAogCXsiemljYm96Iiwg
S1ZNX1JJU0NWX0lTQV9FWFRfWklDQk9afSwKIAl7InppaGludHBhdXNlIiwgS1ZNX1JJU0NWX0lT
QV9FWFRfWklISU5UUEFVU0V9LApkaWZmIC0tZ2l0IGEvcmlzY3YvaW5jbHVkZS9hc20va3ZtLmgg
Yi9yaXNjdi9pbmNsdWRlL2FzbS9rdm0uaAppbmRleCA5OTJjNWU0Li4wYzY1ZmYwIDEwMDY0NAot
LS0gYS9yaXNjdi9pbmNsdWRlL2FzbS9rdm0uaAorKysgYi9yaXNjdi9pbmNsdWRlL2FzbS9rdm0u
aApAQCAtMTIyLDYgKzEyMiw3IEBAIGVudW0gS1ZNX1JJU0NWX0lTQV9FWFRfSUQgewogCUtWTV9S
SVNDVl9JU0FfRVhUX1pJQ0JPTSwKIAlLVk1fUklTQ1ZfSVNBX0VYVF9aSUNCT1osCiAJS1ZNX1JJ
U0NWX0lTQV9FWFRfWkJCLAorCUtWTV9SSVNDVl9JU0FfRVhUX1pBQ0FTLAogCUtWTV9SSVNDVl9J
U0FfRVhUX1NTQUlBLAogCUtWTV9SSVNDVl9JU0FfRVhUX1YsCiAJS1ZNX1JJU0NWX0lTQV9FWFRf
U1ZOQVBPVCwKZGlmZiAtLWdpdCBhL3Jpc2N2L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5o
IGIvcmlzY3YvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgKaW5kZXggODYzYmFlYS4uNzg0
MGY5MSAxMDA2NDQKLS0tIGEvcmlzY3YvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgKKysr
IGIvcmlzY3YvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgKQEAgLTQzLDYgKzQzLDkgQEAg
c3RydWN0IGt2bV9jb25maWdfYXJjaCB7CiAJT1BUX0JPT0xFQU4oJ1wwJywgImRpc2FibGUtemJi
IiwJCQkJXAogCQkgICAgJihjZmcpLT5leHRfZGlzYWJsZWRbS1ZNX1JJU0NWX0lTQV9FWFRfWkJC
XSwJXAogCQkgICAgIkRpc2FibGUgWmJiIEV4dGVuc2lvbiIpLAkJCQlcCisJT1BUX0JPT0xFQU4o
J1wwJywgImRpc2FibGUtemFjYXMiLAkJCQlcCisJCSAgICAmKGNmZyktPmV4dF9kaXNhYmxlZFtL
Vk1fUklTQ1ZfSVNBX0VYVF9aQUNBU10sCVwKKwkJICAgICJEaXNhYmxlIFphY2FzIEV4dGVuc2lv
biIpLAkJCQlcCiAJT1BUX0JPT0xFQU4oJ1wwJywgImRpc2FibGUtemljYm9tIiwJCQkJXAogCQkg
ICAgJihjZmcpLT5leHRfZGlzYWJsZWRbS1ZNX1JJU0NWX0lTQV9FWFRfWklDQk9NXSwJXAogCQkg
ICAgIkRpc2FibGUgWmljYm9tIEV4dGVuc2lvbiIpLAkJCVwKLS0gCjIuNDMuMAoK

