Return-Path: <kvm+bounces-66229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD56CCB175
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:11:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 844903037E5D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543373093DF;
	Thu, 18 Dec 2025 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SeLcTrk6"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEE42F49F6;
	Thu, 18 Dec 2025 09:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049101; cv=none; b=Cou8zHZxOZucNpUq11Sce7mLgC1pzCr3UNVFaeCcItP8mfnKT97z5dVCE9B5sjD3euSvVMwhGmEpcQplox/km5ECoGLTvz4gFm4OBPy7yChjp2fRPRyqNCOy6ZR6VsET6WnO3QsUaTYXRMVUHtqLVQ1x5ncXoLTUKk4BKqZI35A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049101; c=relaxed/simple;
	bh=el3QTMQee7J/evcQ1hBQ4BAcF05giAOqBxx4nVqlsGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GPXz1XgQ6G146qznFJEEnHYO722UsmOJwT/Xq40hWhwA0fTtVoIndPTBaYODF38n78zWE9YLTtp5abUCiEIfWr09wi3iKWT4V9FWm+McsiiyMAFYQ/zE3XH+IjyXpkLIePHtQiiCFscPoVsIip44VN14e8fklS3cXKshM4nANEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SeLcTrk6; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=el3QTMQee7J/evcQ1hBQ4BAcF05giAOqBxx4nVqlsGM=;
	b=SeLcTrk6J3U3Xr8aU/+XpS8BAPa7EPbxdjTwuuUKZJpBnzl7VAG4UYOAKnXohH
	jx5DvSivd7JaSejejLFLgAB8vRFuxm4C6678sWINe16wu+wN6MZZb9VcPJNXnk4N
	t+T/0Utkcqui7HZmhU244dK8BZAEL7Hql2EpjRyXlXKrY=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wC3U84cxUNpI7dcBA--.210S2;
	Thu, 18 Dec 2025 17:10:55 +0800 (CST)
From: Xiong Weimin <15927021679@163.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Thomas Monjalon <thomas@monjalon.net>,
	David Marchand <david.marchand@redhat.com>,
	Luca Boccassi <bluca@debian.org>,
	Kevin Traynor <ktraynor@redhat.com>,
	Christian Ehrhardt <christian.ehrhardt@canonical.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Xueming Li <xuemingl@nvidia.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	Chenbo Xia <chenbox@nvidia.com>,
	Bruce Richardson <bruce.richardson@intel.com>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Implement initial driver for virtio-RDMA device(kernel)
Date: Thu, 18 Dec 2025 17:09:40 +0800
Message-ID: <20251218091050.55047-1-15927021679@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-CM-TRANSID:_____wC3U84cxUNpI7dcBA--.210S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr4rKrWDGF1DAF4UGw4rKrg_yoW5tFy8pr
	W2gF9rCrZ8Gr43G3yUW345uF42gFZ3A3y3Crn8G348K3Z5Xr9YvF1q9F15Way7GrZxAF18
	XFy8Jr92ka4UAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07js_-9UUUUU=
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC9B+jLGlDxR+pCwAA32

SGkgYWxsLAoKVGhpcyB0ZXN0aW5nIGluc3RydWN0aW9ucyBhaW1zIHRvIGludHJvZHVjZSBhbiBl
bXVsYXRpbmcgYSBzb2Z0IFJPQ0UgCmRldmljZSB3aXRoIG5vcm1hbCBOSUMobm8gUkRNQSksIHdl
IGhhdmUgZmluaXNoZWQgYSB2aG9zdC11c2VyIFJETUEKZGV2aWNlIGRlbW8sIHdoaWNoIGNhbiB3
b3JrIHdpdGggUkRNQSBmZWF0dXJlcyBzdWNoIGFzIENNLCBRUCB0eXBlIG9mIApVQy9VRCBhbmQg
c28gb24uCgpUaGVyZSBhcmUgdGVzdGluZyBpbnN0cnVjdGlvbnMgb2YgdGhlIGRlbW86CgoxLlRl
c3QgRW52aXJvbm1lbnQgQ29uZmlndXJhdGlvbgpIYXJkd2FyZSBFbnZpcm9ubWVudApTZXJ2ZXJz
OiAxIGlkZW50aWNhbGx5IGNvbmZpZ3VyZWQgc2VydmVycwoKQ1BVOiBIVUFXRUkgS3VucGVuZyA5
MjAgKDk2IGNvcmVzKQoKTWVtb3J5OiAzVCBERFI0CgpOSUM6IFRBUCAocGFpcmVkIHZpcnRpby1u
ZXQgZGV2aWNlIGZvciBSRE1BKQoKU29mdHdhcmUgRW52aXJvbm1lbnQKU2VydmVyIEhvc3QgT1M6
IDYuNC4wLTEwLjEuMC4yMC5vZTIzMDkuYWFyY2g2NAoKS2VybmVsOiBsaW51eC02LjE2LjggKHdp
dGgga2VybmVsLXZyZG1hIG1vZHVsZSkKClFFTVU6IDkuMC4yIChjb21waWxlZCB3aXRoIHZob3N0
LXVzZXItcmRtYSB2aXJ0dWFsIGRldmljZSBzdXBwb3J0KQoKRFBESzogMjQuMDcuMC1yYzIKCkRl
cGVuZGVuY2llczoKCglyZG1hLWNvcmUKCQoJcmRtYV9yeGUKCglsaWJpYnZlcmJzLWRldgoJCjIu
IFRlc3QgUHJvY2VkdXJlcwphLiBTdGFydGluZyBEUERLIHdpdGggdmhvc3QtdXNlci1yZG1hIGZp
cnN0OiAKMSkuIENvbmZpZ3VyZSBIdWdlcGFnZXMKICAgZWNobyAyMDQ4IHwgc3VkbyB0ZWUgL3N5
cy9rZXJuZWwvbW0vaHVnZXBhZ2VzL2h1Z2VwYWdlcy0yMDQ4a0IvbnJfaHVnZXBhZ2VzCjIpLiBh
cHAgc3RhcnQgIAogIC9EUERLRElSL2J1aWxkL2V4YW1wbGVzL2RwZGstdmhvc3RfdXNlcl9yZG1h
IC1sIDEtNCAtbiA0IC0tdmRldiAibmV0X3RhcDAiIC0tIC0tc29ja2V0LWZpbGUgL3RtcC92aG9z
dC1yZG1hMAoKYi4gQm9vdGluZyBndWVzdCBrZXJuZWwgd2l0aCBxZW11LCBjb21tYW5kIGxpbmU6
IAouLi4KLW5ldGRldiB0YXAsaWQ9aG9zdG5ldDEsaWZuYW1lPXRhcDEsc2NyaXB0PW5vLGRvd25z
Y3JpcHQ9bm8gCi1kZXZpY2UgdmlydGlvLW5ldC1wY2ksbmV0ZGV2PWhvc3RuZXQxLGlkPW5ldDEs
bWFjPTUyOjU0OjAwOjE0OjcyOjMwLGJ1cz1wY2kuMyxhZGRyPTB4MC4wLG11bHRpZnVuY3Rpb249
b24gCi1jaGFyZGV2IHNvY2tldCxwYXRoPS90bXAvdmhvc3QtcmRtYTAsaWQ9dnVyZG1hIAotZGV2
aWNlIHZob3N0LXVzZXItcmRtYS1wY2ksYnVzPXBjaS4zLGFkZHI9MHgwLjEscGFnZS1wZXItdnE9
b24sZGlzYWJsZS1sZWdhY3k9b24sY2hhcmRldj12dXJkbWEKLi4uCgpjLiBHdWVzdCBLZXJuZWwg
TW9kdWxlIExvYWRpbmcgYW5kIFZhbGlkYXRpb24KIyBMb2FkIHZob3N0X3JkbWEga2VybmVsIG1v
ZHVsZQpzdWRvIG1vZHByb2JlIHZyZG1hCgojIFZlcmlmeSBtb2R1bGUgbG9hZGluZwpsc21vZCB8
IGdyZXAgdnJkbWEKCiMgQ2hlY2sga2VybmVsIGxvZ3MKZG1lc2cgfCBncmVwIHZob3N0X3JkbWEK
CiMgRXhwZWN0ZWQgb3V0cHV0OgpbICAgIDQuOTM1NDczXSB2cmRtYV9pbml0X2RldmljZTogSW5p
dGlhbGl6aW5nIHZSRE1BIGRldmljZSB3aXRoIG1heF9jcT02NCwgbWF4X3FwPTY0ClsgICAgNC45
NDk4ODhdIFt2cmRtYV9pbml0X2RldmljZV06IFN1Y2Nlc3NmdWxseSBpbml0aWFsaXplZCwgbGFz
dCBxcF92cSBpbmRleD0xOTIKWyAgICA0Ljk0OTkwN10gW3ZyZG1hX2luaXRfbmV0ZGV2XTogRm91
bmQgcGFpcmVkIG5ldF9kZXZpY2UgJ2VucDNzMGYwJyAob24gMDAwMDowMzowMC4wKQpbICAgIDQu
OTQ5OTI0XSBCb3VuZCB2UkRNQSBkZXZpY2UgdG8gbmV0X2RldmljZSAnZW5wM3MwZjAnClsgICAg
NS4wMjYwMzJdIHZyZG1hIHZpcnRpbzI6IHZyZG1hX2FsbG9jX3BkOiBhbGxvY2F0ZWQgUEQgMQpb
ICAgIDUuMDI4MDA2XSBTdWNjZXNzZnVsbHkgcmVnaXN0ZXJlZCB2UkRNQSBkZXZpY2UgYXMgJ3Zy
ZG1hMCcKWyAgICA1LjAyODAyMF0gW3ZyZG1hX3Byb2JlXTogU3VjY2Vzc2Z1bGx5IHByb2JlZCBW
aXJ0SU8gUkRNQSBkZXZpY2UgKGluZGV4PTIpClsgICAgNS4wMjgxMDRdIFZpcnRJTyBSRE1BIGRy
aXZlciBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHkKCmQuIEluc2lkZSBWTSwgb25lIHJkbWEgZGV2
aWNlIGZzIG5vZGUgd2lsbCBiZSBnZW5lcmF0ZWQgaW4gL2Rldi9pbmZpbmliYW5kOiAKW3Jvb3RA
bG9jYWxob3N0IH5dIyBsbCAtaCAvZGV2L2luZmluaWJhbmQvCnRvdGFsIDAKZHJ3eHIteHIteC4g
MiByb290IHJvb3QgICAgICAgNjAgRGVjIDE3IDExOjI0IGJ5LWliZGV2CmRyd3hyLXhyLXguIDIg
cm9vdCByb290ICAgICAgIDYwIERlYyAxNyAxMToyNCBieS1wYXRoCmNydy1ydy1ydy0uIDEgcm9v
dCByb290ICAxMCwgMjU5IERlYyAxNyAxMToyNCByZG1hX2NtCmNydy1ydy1ydy0uIDEgcm9vdCBy
b290IDIzMSwgMTkyIERlYyAxNyAxMToyNCB1dmVyYnMwCgplLiBUaGUgZm9sbG93aW5nIGFyZSB0
byBiZSBkb25lIGluIHRoZSBmdXR1cmUgdmVyc2lvbjogCjEpLiBTUlEgc3VwcG9ydAoyKS4gRFBE
SyBzdXBwb3J0IGZvciBwaHlzaWNhbCBSRE1BIE5JQyBmb3IgaGFuZGxpbmcgdGhlIGRhdGFwYXRo
IGJldHdlZW4gZnJvbnQgYW5kIGJhY2tlbmQKMykuIFJlc2V0IG9mIFZpcnRRdWV1ZQo0KS4gSW5j
cmVhc2Ugc2l6ZSBvZiBWaXJ0UXVldWUgZm9yIFBDSSB0cmFuc3BvcnQKNSkuIFBlcmZvcm1hbmNl
IFRlc3RpbmcKCmYuIFRlc3QgUmVzdWx0cwoxKS4gRnVuY3Rpb25hbCBUZXN0IFJlc3VsdHM6Cktl
cm5lbCBtb2R1bGUgbG9hZGluZwlQQVNTCU1vZHVsZSBsb2FkZWQgd2l0aG91dCBlcnJvcnMKRFBE
SyBzdGFydHVwCSAgICAgICAgUEFTUwl2aG9zdC11c2VyLXJkbWEgYmFja2VuZCBpbml0aWFsaXpl
ZApRRU1VIFZNIGxhdW5jaAkgICAgICAgIFBBU1MJVk0gYm9vdGVkIHVzaW5nIFJETUEgZGV2aWNl
Ck5ldHdvcmsgY29ubmVjdGl2aXR5CVBBU1MJSG9zdC1WTSBjb21tdW5pY2F0aW9uIGVzdGFibGlz
aGVkClJETUEgZGV2aWNlIGRldGVjdGlvbglQQVNTCVZpcnR1YWwgUkRNQSBkZXZpY2UgcmVjb2du
aXplZAoKZi5UZXN0IENvbmNsdXNpb24KMSkuIEZ1bGwgZnVuY3Rpb25hbCBjb21wbGlhbmNlIHdp
dGggc3BlY2lmaWNhdGlvbnMKMikuIFN0YWJsZSBvcGVyYXRpb24gdW5kZXIgZXh0ZW5kZWQgc3Ry
ZXNzIGNvbmRpdGlvbnMKClJlY29tbWVuZGF0aW9uczoKMSkuIE9wdGltaXplIG1lbW9yeSBjb3B5
IHBhdGhzIGZvciBoaWdoZXIgdGhyb3VnaHB1dAoyKS4gRW5oYW5jZSBlcnJvciBoYW5kbGluZyBh
bmQgcmVjb3ZlcnkgbWVjaGFuaXNtcyAKCg==


