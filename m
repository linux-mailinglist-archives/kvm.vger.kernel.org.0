Return-Path: <kvm+bounces-18100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDA38CDF95
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 04:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 697F9B22075
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB10374CC;
	Fri, 24 May 2024 02:51:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BA223D2
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 02:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=20.232.28.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716519060; cv=none; b=Eqd1LMp3mohnGKPxB2cP6aJa8CfuUl3BSfyg/s+cZO4/lTVEYFMfMz2mSkfMM/A7smmkBuJssymtvhmLcM69QKVCi67KpN5WzsRFbbKG3AKMvKX1iZ/OpRTaDy1J1JBUWA88aCIVz056d+Kr9iLcQjbySyKgZNXULmjCwRhNqbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716519060; c=relaxed/simple;
	bh=A5iXz2vUWK2W2A33JdvI5h65h1CEhplvkIcLcejjoi0=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=hzI+nLJIsRF+H9oGnWMpoaev5FhllHL1uq/8lSvbKinS6fKBDn4eDSX9p72C9NJzI+gO4r4+SgvkvAD3VAqKwLgS1RW0YMdJiQAgBmrj8QXNqMLzPyzG+wZRdsAGqzMzZ1zciIZjDbYKkyXbIWW62FvTR2bCbYGUkD9G/rXTfA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn; spf=pass smtp.mailfrom=bosc.ac.cn; arc=none smtp.client-ip=20.232.28.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bosc.ac.cn
Received: from qinshaoqing$bosc.ac.cn ( [123.114.53.210] ) by
 ajax-webmail-mail (Coremail) ; Fri, 24 May 2024 10:50:42 +0800 (GMT+08:00)
Date: Fri, 24 May 2024 10:50:42 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shaoqing Qin" <qinshaoqing@bosc.ac.cn>
To: Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>, 
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Patel <apatel@ventanamicro.com>, 
	=?UTF-8?B?546L54S2?= <wangran@bosc.ac.cn>, 
	=?UTF-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: [v2][kvmtool PATCH 1/1] riscv: Add zacas extension
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT5 build
 20230627(00751abc) Copyright (c) 2002-2024 www.mailtech.cn
 mispb-4edfefde-e422-4ddc-8a36-c3f99eb8cd32-icoremail.net
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <228d4ce6.49.18fa881fced.Coremail.qinshaoqing@bosc.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwC3v9uCAFBmSJ63AA--.2348W
X-CM-SenderInfo: ptlq2xpdrtx03j6e02nfoduhdfq/1tbiAQAIAWZPVcAChgAAsw
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

QWRkIHBhcnNpbmcgZm9yIFphY2FzIElTQSBleHRlbnNpb24gd2hpY2ggd2FzIHJhdGlmaWVkIHJl
Y2VudGx5IGluIHRoZQpyaXNjdi16YWNhcyBtYW51YWwuClRoZSB0ZXN0cyBhcmUgYmFzZWQgb24g
dGhlIDYuOSB2ZXJzaW9uIG9mIHRoZSBrZXJuZWwKClNpZ25lZC1vZmYtYnk6IFNoYW9xaW5nIFFp
biA8cWluc2hhb3FpbmdAYm9zYy5hYy5jbj4KLS0tCkNoYW5nZWQgZnJvbSB2MToKMS4gbW9kaWZ5
IFpBQ0FTIGVudW0gbnVtYmVyLgoyLiBtb2RpZnkgdGhlIGNvZGUgbG9jYXRpb24sanVzdCBmb3Ig
Zm9ybWF0dGluZy4KLS0tCiByaXNjdi9mZHQuYyAgICAgICAgICAgICAgICAgICAgICAgICB8IDEg
KwogcmlzY3YvaW5jbHVkZS9hc20va3ZtLmggICAgICAgICAgICAgfCAxICsKIHJpc2N2L2luY2x1
ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oIHwgMyArKysKIDMgZmlsZXMgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvcmlzY3YvZmR0LmMgYi9yaXNjdi9mZHQuYwppbmRleCBj
YzgwNzBkLi42ZGZjMjViIDEwMDY0NAotLS0gYS9yaXNjdi9mZHQuYworKysgYi9yaXNjdi9mZHQu
YwpAQCAtMjIsNiArMjIsNyBAQCBzdHJ1Y3QgaXNhX2V4dF9pbmZvIGlzYV9pbmZvX2FycltdID0g
ewogCXsic3ZpbnZhbCIsIEtWTV9SSVNDVl9JU0FfRVhUX1NWSU5WQUx9LAogCXsic3ZuYXBvdCIs
IEtWTV9SSVNDVl9JU0FfRVhUX1NWTkFQT1R9LAogCXsic3ZwYm10IiwgS1ZNX1JJU0NWX0lTQV9F
WFRfU1ZQQk1UfSwKKwl7InphY2FzIiwgS1ZNX1JJU0NWX0lTQV9FWFRfWkFDQVN9LAogCXsiemJh
IiwgS1ZNX1JJU0NWX0lTQV9FWFRfWkJBfSwKIAl7InpiYiIsIEtWTV9SSVNDVl9JU0FfRVhUX1pC
Qn0sCiAJeyJ6YmMiLCBLVk1fUklTQ1ZfSVNBX0VYVF9aQkN9LApkaWZmIC0tZ2l0IGEvcmlzY3Yv
aW5jbHVkZS9hc20va3ZtLmggYi9yaXNjdi9pbmNsdWRlL2FzbS9rdm0uaAppbmRleCA3NDk5ZTg4
Li42YjJjYmU3IDEwMDY0NAotLS0gYS9yaXNjdi9pbmNsdWRlL2FzbS9rdm0uaAorKysgYi9yaXNj
di9pbmNsdWRlL2FzbS9rdm0uaApAQCAtMTM1LDYgKzEzNSw3IEBAIGVudW0gS1ZNX1JJU0NWX0lT
QV9FWFRfSUQgewogCUtWTV9SSVNDVl9JU0FfRVhUX1pCUywKIAlLVk1fUklTQ1ZfSVNBX0VYVF9a
SUNOVFIsCiAJS1ZNX1JJU0NWX0lTQV9FWFRfWklDU1IsCisJS1ZNX1JJU0NWX0lTQV9FWFRfWkFD
QVMsCiAJS1ZNX1JJU0NWX0lTQV9FWFRfWklGRU5DRUksCiAJS1ZNX1JJU0NWX0lTQV9FWFRfWklI
UE0sCiAJS1ZNX1JJU0NWX0lTQV9FWFRfU01TVEFURUVOLApkaWZmIC0tZ2l0IGEvcmlzY3YvaW5j
bHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmggYi9yaXNjdi9pbmNsdWRlL2t2bS9rdm0tY29uZmln
LWFyY2guaAppbmRleCBlNTYyZDcxLi5lNTM0M2E2IDEwMDY0NAotLS0gYS9yaXNjdi9pbmNsdWRl
L2t2bS9rdm0tY29uZmlnLWFyY2guaAorKysgYi9yaXNjdi9pbmNsdWRlL2t2bS9rdm0tY29uZmln
LWFyY2guaApAQCAtNDMsNiArNDMsOSBAQCBzdHJ1Y3Qga3ZtX2NvbmZpZ19hcmNoIHsKIAlPUFRf
Qk9PTEVBTignXDAnLCAiZGlzYWJsZS1zdnBibXQiLAkJCQlcCiAJCSAgICAmKGNmZyktPmV4dF9k
aXNhYmxlZFtLVk1fUklTQ1ZfSVNBX0VYVF9TVlBCTVRdLAlcCiAJCSAgICAiRGlzYWJsZSBTdnBi
bXQgRXh0ZW5zaW9uIiksCQkJXAorCU9QVF9CT09MRUFOKCdcMCcsICJkaXNhYmxlLXphY2FzIiwJ
CQkJXAorCQkgICAgJihjZmcpLT5leHRfZGlzYWJsZWRbS1ZNX1JJU0NWX0lTQV9FWFRfWkFDQVNd
LAlcCisJCSAgICAiRGlzYWJsZSBaYWNhcyBFeHRlbnNpb24iKSwJCQlcCiAJT1BUX0JPT0xFQU4o
J1wwJywgImRpc2FibGUtemJhIiwJCQkJXAogCQkgICAgJihjZmcpLT5leHRfZGlzYWJsZWRbS1ZN
X1JJU0NWX0lTQV9FWFRfWkJBXSwJXAogCQkgICAgIkRpc2FibGUgWmJhIEV4dGVuc2lvbiIpLAkJ
CQlcCi0tIAoyLjQzLjA=

