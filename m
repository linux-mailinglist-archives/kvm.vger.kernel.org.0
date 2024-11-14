Return-Path: <kvm+bounces-31842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B52E89C85A9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61DC1B2ADE8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE441DFD89;
	Thu, 14 Nov 2024 09:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GsiOO7if"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E21DCB2D
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731575122; cv=none; b=kFjpZz/4dwardrGsihkhxhiDHa8UWTG5WYq7GV/9rMf1fq7GK1MkIjjMpLyNVtbiN0m6zP/bCEJVf7Fg80M1mwvYK+lZFXOrS9vnRPaws3pJqk02YcbS9Ey8QVwpfJl5L8DdMB2lsAfPQsz5EMFRTCzWZ9AKHEThwXaY7Le2c4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731575122; c=relaxed/simple;
	bh=kF95GC+iUY1Dm9Qv60S9X5a5C7Gjugcat/GIm+/tUc4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P4XKh9/wyonWUIYkQYAlCEJ4G5n/To6uKogyGcYGF7orY3MYu1ADJqlfB7WELIXGRxZBhKg8deI8BIZfwBtDsT7leVxWmhIkpU5C2YmSBnjY2h90CoYM77FTuUDfvYb48t+7cf/Thjs5BDmYGmon5Zqx7B9UroEZ98mSKdLgzs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GsiOO7if; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731575119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kF95GC+iUY1Dm9Qv60S9X5a5C7Gjugcat/GIm+/tUc4=;
	b=GsiOO7ifx1YCaMFAgQm31YEU0WUwTtW6TGcA8d6VFV+DBqip5wofcMl/rKT8i31+xi47fa
	fLAO0thBoPn4PGJZQ8cDOl52EIPRCXiyaZT23uPDHflLaZ2AaG80SWtC9bTJExmIUPSfDH
	c38pj3dgyzwT9jZPmDT2CjnqI+CR3y4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-P-kQw7WjPhaYyZcgmvOkBg-1; Thu, 14 Nov 2024 04:05:17 -0500
X-MC-Unique: P-kQw7WjPhaYyZcgmvOkBg-1
X-Mimecast-MFC-AGG-ID: P-kQw7WjPhaYyZcgmvOkBg
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-539e7dc83ecso218841e87.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 01:05:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731575115; x=1732179915;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kF95GC+iUY1Dm9Qv60S9X5a5C7Gjugcat/GIm+/tUc4=;
        b=hbkD8iApF6XGoUUeJ5xPixMP9MKo1k1HeBMSFsScIZ3yJp64eD93d6SkorRdPMv4qP
         hAIpxsv/Xt6H1dclsNPTwgmSsPkmkldOsgvNAw/Z1jOZCgw2PNOFKNwq+jwDvZjprMNH
         VR9XhZxjshpBufLEVroh7vm/QiOGPCbol77xIx8nCM60k2mzXi4VBOlPIL992nwhDMYh
         q1HjpDJxf8QLXwo0zVhiL2m4kZ/VY948pRfduHQ7uasGrBTUDwfSi7OKfZ7r/LBqVuJM
         j9EGMyLBZ2mQQo9stxhfLjkp+JhWMNxI0IzhPQ99unccw3nq9g6EVwFv/o5Xj5bFfgKv
         KSGw==
X-Forwarded-Encrypted: i=1; AJvYcCV+/Hf8Z8Bqg3Mo/fj3tRcrG4Sc1/Pp1rYowhk0ivdj4C5kvF1WUbmKy8mCgH10aKg1oCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq9172bEhZnZ5dcmmfIq4myqVGv4TtPWT6PXK1kqmOPanimT0b
	6O8Wr3caSRin8QFK55ylkk3qPSqvnmOrdlnxx5HBxE1sk/4qxVyE4iL4vUnbtfodaEu8fwNp3OI
	hoz7ciiABjnqHKL9VDaqmKUplRld21wxZMWcwqcqp0hsIVoql2g==
X-Received: by 2002:a05:6512:1191:b0:539:f67b:b849 with SMTP id 2adb3069b0e04-53d862f33b4mr10003036e87.49.1731575115342;
        Thu, 14 Nov 2024 01:05:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHN0Hy6qiNEuUsypmH2/i/ZX6h1LZFagvmv3lYpze64dRxm0m4HLn6U0lfPme4RmJ7ieJ/jJA==
X-Received: by 2002:a05:6512:1191:b0:539:f67b:b849 with SMTP id 2adb3069b0e04-53d862f33b4mr10002974e87.49.1731575114801;
        Thu, 14 Nov 2024 01:05:14 -0800 (PST)
Received: from ?IPv6:2001:16b8:3dc0:7e00:9ea7:2841:8d4a:6aac? ([2001:16b8:3dc0:7e00:9ea7:2841:8d4a:6aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dab788e1sm13078295e9.15.2024.11.14.01.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 01:05:14 -0800 (PST)
Message-ID: <49bb6fc9ebff3cae844da0465ceadeef8d3217c7.camel@redhat.com>
Subject: Re: [PATCH v2 11/11] Remove devres from pci_intx()
From: Philipp Stanner <pstanner@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Damien Le Moal
 <dlemoal@kernel.org>,  Niklas Cassel <cassel@kernel.org>, Basavaraj Natikar
 <basavaraj.natikar@amd.com>, Jiri Kosina <jikos@kernel.org>,  Benjamin
 Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov <oakad@yahoo.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
 <manishc@marvell.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rasesh Mody
 <rmody@marvell.com>,  GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko
 <imitsyanko@quantenna.com>,  Sergey Matyukevich <geomatsi@gmail.com>, Kalle
 Valo <kvalo@kernel.org>, Sanjay R Mehta <sanju.mehta@amd.com>, Shyam Sundar
 S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave Jiang
 <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas
 <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>, Ricky Wu
 <ricky_wu@realtek.com>,  Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao
 <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>, Mostafa Saleh
 <smostafa@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kunwu Chan
 <chentao@kylinos.cn>, Ankit Agrawal <ankita@nvidia.com>, Christian Brauner
 <brauner@kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, Eric
 Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-input@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org,  kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Date: Thu, 14 Nov 2024 10:05:12 +0100
In-Reply-To: <87msi3ksru.ffs@tglx>
References: <20241113124158.22863-2-pstanner@redhat.com>
	 <20241113124158.22863-13-pstanner@redhat.com> <87msi3ksru.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTEzIGF0IDE3OjIyICswMTAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
Cj4gT24gV2VkLCBOb3YgMTMgMjAyNCBhdCAxMzo0MSwgUGhpbGlwcCBTdGFubmVyIHdyb3RlOgo+
ID4gcGNpX2ludHgoKSBpcyBhIGh5YnJpZCBmdW5jdGlvbiB3aGljaCBjYW4gc29tZXRpbWVzIGJl
IG1hbmFnZWQKPiA+IHRocm91Z2gKPiA+IGRldnJlcy4gVGhpcyBoeWJyaWQgbmF0dXJlIGlzIHVu
ZGVzaXJhYmxlLgo+ID4gCj4gPiBTaW5jZSBhbGwgdXNlcnMgb2YgcGNpX2ludHgoKSBoYXZlIGJ5
IG5vdyBiZWVuIHBvcnRlZCBlaXRoZXIgdG8KPiA+IGFsd2F5cy1tYW5hZ2VkIHBjaW1faW50eCgp
IG9yIG5ldmVyLW1hbmFnZWQgcGNpX2ludHhfdW5tYW5hZ2VkKCksCj4gPiB0aGUKPiA+IGRldnJl
cyBmdW5jdGlvbmFsaXR5IGNhbiBiZSByZW1vdmVkIGZyb20gcGNpX2ludHgoKS4KPiA+IAo+ID4g
Q29uc2VxdWVudGx5LCBwY2lfaW50eF91bm1hbmFnZWQoKSBpcyBub3cgcmVkdW5kYW50LCBiZWNh
dXNlCj4gPiBwY2lfaW50eCgpCj4gPiBpdHNlbGYgaXMgbm93IHVubWFuYWdlZC4KPiA+IAo+ID4g
UmVtb3ZlIHRoZSBkZXZyZXMgZnVuY3Rpb25hbGl0eSBmcm9tIHBjaV9pbnR4KCkuIEhhdmUgYWxs
IHVzZXJzIG9mCj4gPiBwY2lfaW50eF91bm1hbmFnZWQoKSBjYWxsIHBjaV9pbnR4KCkuIFJlbW92
ZSBwY2lfaW50eF91bm1hbmFnZWQoKS4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogUGhpbGlwcCBT
dGFubmVyIDxwc3Rhbm5lckByZWRoYXQuY29tPgo+ID4gLS0tCj4gPiDCoGRyaXZlcnMvbWlzYy9j
YXJkcmVhZGVyL3J0c3hfcGNyLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gPiDC
oGRyaXZlcnMvbWlzYy90aWZtXzd4eDEuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB8wqAgNiArLS0KPiA+IMKgLi4uL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngy
eC9ibngyeF9tYWluLmPCoCB8wqAgMiArLQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9j
YWRlL2JuYS9ibmFkLmPCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiA+IMKgZHJpdmVycy9udGIvaHcv
YW1kL250Yl9od19hbWQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKy0KPiA+
IMKgZHJpdmVycy9udGIvaHcvaW50ZWwvbnRiX2h3X2dlbjEuY8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDIgKy0KPiA+IMKgZHJpdmVycy9wY2kvZGV2cmVzLmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArLQo+ID4gwqBkcml2ZXJzL3Bj
aS9tc2kvYXBpLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDIgKy0KPiA+IMKgZHJpdmVycy9wY2kvbXNpL21zaS5jwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gPiDCoGRyaXZlcnMvcGNp
L3BjaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfCA0MyArLS0tLS0tLS0tLS0tLS0KPiA+IC0tLS0KPiA+IMKgZHJpdmVycy92ZmlvL3Bj
aS92ZmlvX3BjaV9jb3JlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+ID4g
wqBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2ludHJzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfCAxMCArKy0tLQo+ID4gwqBkcml2ZXJzL3hlbi94ZW4tcGNpYmFjay9jb25mX3NwYWNlX2hl
YWRlci5jwqDCoCB8wqAgMiArLQo+ID4gwqBpbmNsdWRlL2xpbnV4L3BjaS5owqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMSAtCj4gPiDCoDE0
IGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDYyIGRlbGV0aW9ucygtKQo+IAo+IE5v
dyBJJ20gdXR0ZXJseSBjb25mdXNlZC4gVGhpcyB1bmRvZXMgdGhlIHBjaV9pbnR4X3VubWFuYWdl
ZCgpIGNodXJuCj4gd2hpY2ggeW91IGNhcmVmdWxseSBzcGxpdCBpbnRvIHNldmVyYWwgcGF0Y2hl
cyBmaXJzdC4KCkhhdmUgeW91IHJlYWQgdGhlIGVtYWlsIEkgaGF2ZSBsaW5rZWQ/CgpUaGVyZSBp
cyBhbHNvIHRoZSBjb3Zlci1sZXR0ZXIgKGRvZXMgYW55b25lIGluIHRoZSBjb21tdW5pdHkgZXZl
ciByZWFkCnRob3NlPykgd2hpY2ggZXhwbGljaXRseSBzdGF0ZXM6CgoiUGF0Y2ggIlJlbW92ZSBk
ZXZyZXMgZnJvbSBwY2lfaW50eCgpIiBvYnZpb3VzbHkgcmV2ZXJ0cyB0aGUgcHJldmlvdXMKcGF0
Y2hlcyB0aGF0IG1hZGUgZHJpdmVycyB1c2UgcGNpX2ludHhfdW5tYW5hZ2VkKCkuIEJ1dCB0aGlz
IHdheSBpdCdzCmVhc2llciB0byByZXZpZXcgYW5kIGFwcHJvdmUuIEl0IGFsc28gbWFrZXMgc3Vy
ZSB0aGF0IGVhY2ggY2hlY2tlZCBvdXQKY29tbWl0IHNob3VsZCBwcm92aWRlIGNvcnJlY3QgYmVo
YXZpb3IsIG5vdCBqdXN0IHRoZSBlbnRpcmUgc2VyaWVzIGFzIGEKd2hvbGUuIgpQLgoKCgo+IAo+
IFNvIHRoZSBuZXQgY2hhbmdlIGlzIHRoYXQ6Cj4gCj4gwqDCoCAxKSBwY2lfaW50eCgpIGlzIG5v
dyBhbHdheXMgdW5tYW5hZ2VkCj4gCj4gwqDCoCAyKSBhIGNvdXBsZSBvZiBkcml2ZXJzIHVzZSBw
Y2ltX2ludHgoKSBub3cgaW5zdGVhZCBvZiBwY2lfaW50eCgpCj4gCj4gVGhlIG9idmlvdXMgb3Jk
ZXJpbmcgaXM6Cj4gCj4gwqDCoCAxKSBDb252ZXJ0IHRoZSBkcml2ZXJzIHdoaWNoIG5lZWQgdGhl
IG1hbmFnZWQgdmVyc2lvbiB0byB1c2UKPiDCoMKgwqDCoMKgIHBjaW1faW50eCgpCj4gCj4gwqDC
oCAyKSBSZW1vdmUgdGhlIG1hbmFnZWQgd2FybmluZyBpbiBwY2lfaW50eCgpIGFuZCBjbGVhbiB1
cCB0aGUKPiBjb21tZW50Cj4gCj4gwqDCoCAzKSBSZW1vdmUgX19wY2ltX2ludHgoKSBhbmQgaW52
b2tlIHBjaV9pbnR4KCkgaW4gdGhlIGRldnJlcyBjb2RlLgo+IAo+IE5vPwo+IAo+IFRoYW5rcywK
PiAKPiDCoMKgwqDCoMKgwqDCoCB0Z2x4Cj4gCgoK


