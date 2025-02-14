Return-Path: <kvm+bounces-38107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DBDA35372
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 02:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4922F1618AA
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5189670824;
	Fri, 14 Feb 2025 01:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X6uFpopB"
X-Original-To: kvm@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A1A1BC5C
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494941; cv=none; b=CEXwO4mCK+7s1VH+6N/TsqsX3Z5h91WYUZclPy3QQ8YdiHFXaojVa/jmACewDfiyMB2pImYTZA9/YGKiRZy8z++R08ss1AnlUwK+X1RfwoxUpB5r24vYUwXSeKfN1mLD1SmXK+x2b9Pn/5n8/roVK514zo457geyXnXR7O/6fvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494941; c=relaxed/simple;
	bh=68ny5SE+1cYQ7FRYTzslAWh5j/gqWYJIiL351L0rZxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=m75sESaJBUEKKGVMd1pg525ACQ4ApkEi4afBQcjprrG0vno2pQ7HiGh3+swfBrFpLGKu7dzDUhLT/hFGlcIgqYv9dMWf6/rb8L/RlwVumUsUnKZYw77FGKk7ECjUEBvcl9Y1XvY/ieyKJa2NYu0YkCddX2zKvUpGNmUygslkK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=X6uFpopB; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250214010217epoutp04b56f393bff512dde81e0475c7e4baaea~j7W3muo4T0277002770epoutp04i
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 01:02:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250214010217epoutp04b56f393bff512dde81e0475c7e4baaea~j7W3muo4T0277002770epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739494937;
	bh=68ny5SE+1cYQ7FRYTzslAWh5j/gqWYJIiL351L0rZxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6uFpopBQhmD/LuT5dVOODpCr6/oHFRME+d63KpbyICU83cQclF5Xe03Ail+fpWZi
	 j5f+BXX+2xitFjUPvqzs//y04cbvPi6EJSdcDyy9fBs/JZIm2H9dhrfJh/oSWbTUvn
	 Q73fOB0PqfS3aB9MKZyILZrdCxcj5fUNqTugkd/Y=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250214010216epcas5p150de24a13ad97f24919f75285e61bdc2~j7W26KKhV1961619616epcas5p1D;
	Fri, 14 Feb 2025 01:02:16 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4YvDKg1w0Pz4x9Pt; Fri, 14 Feb
	2025 01:02:15 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	33.15.29212.7169EA76; Fri, 14 Feb 2025 10:02:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250214010204epcas5p3e6bcf86ec8c473d776624df81b0e4a0a~j7WrwDqd92008620086epcas5p3r;
	Fri, 14 Feb 2025 01:02:04 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250214010204epsmtrp15a372fecdeddfcdbae6336ce416881a7~j7Wru9tw32657326573epsmtrp1T;
	Fri, 14 Feb 2025 01:02:04 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-39-67ae961764b7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.3A.23488.C069EA76; Fri, 14 Feb 2025 10:02:04 +0900 (KST)
Received: from asg29.. (unknown [109.105.129.29]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250214010202epsmtip2d109e0bd706689d7b14a3fe0fd8d9537~j7Wpde_4X1229412294epsmtip2L;
	Fri, 14 Feb 2025 01:02:02 +0000 (GMT)
From: Junnan Wu <junnan01.wu@samsung.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, junnan01.wu@samsung.com,
	kuba@kernel.org, kvm@vger.kernel.org, lei19.wang@samsung.com,
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
	pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: Re: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
Date: Fri, 14 Feb 2025 09:02:47 +0800
Message-Id: <20250214010247.4071303-1-junnan01.wu@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmhq74tHXpBo3n2CzmnG9hsXh67BG7
	xeO5K9ktHvWfYLNYdukzk8Xda+4WF7b1sVrMmVpo0bbjMqvF5V1z2CyuLOlht/j/6xWrxbEF
	YhbfTr9htFj69iyzxdkJH1gtzs/5z2zxetJ/Vouj21eyWlxrsrC4cARo6v5HM1kdxDy2rLzJ
	5LFgU6nHplWdbB47H1p6vNg8k9Hj/b6rbB59W1YxenzeJBfAEZVtk5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfzqYov7Qk
	VSEjv7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+Nj82yWgj62io9zbrM3ML5j
	6WLk5JAQMJF4O2kpWxcjF4eQwB5Gia75P5lBEkICnxglXh5Rhkh8Y5RoXfSbDaZj5bwWFojE
	XkaJE6+fQznPGCVu90xlBaliE9CUOLFnBViHiIC4xIV5S8B2MAvsZpZ4sLETLCEskCox6c1T
	sAYWAVWJC6u6GUFsXgE7idsHL0Ktk5fYf/As2E2cAoESF9b/YoeoEZQ4OfMJ2BPMQDXNW2cz
	gyyQEHjAIbHx5ApGiGYXiYVzVjBD2MISr45vYYewpSRe9rdB2dkSvUd/QS0rkeh+d4kVwraW
	OL+uHaiXA2iBpsT6XfoQYVmJqafWMUHs5ZPo/f2ECSLOK7FjHojNAWSrSryfUAMRlpZYuWkT
	O0TYQ2LxYWNIWC1hlFj+4BXTBEaFWUi+mYXkm1kIixcwMq9ilEotKM5NT002LTDUzUsth8dy
	cn7uJkZwctcK2MG4esNfvUOMTByMhxglOJiVRHglpq1JF+JNSaysSi3Kjy8qzUktPsRoCgzv
	icxSosn5wPySVxJvaGJpYGJmZmZiaWxmqCTO27yzJV1IID2xJDU7NbUgtQimj4mDU6qBaZmG
	4P+fqU3lkgqebze5zDojeCxRysxwMv8k929LP8dflLzR1xeZ+1Yq6t/mJO7VynJhxyR9dM56
	nd/gI/rxfLDIzrib7EclrffcL9aeNG2Bj1G1tecjm8W9XT8197cf+GZ6V+pIrfc2UQaluXuE
	a1tb9Q1uHdl+1t2yxiboZr/+sR+BvrqZbNebHxUElJ/Nzl9XU7uPaVqFmMFvewE/f3G9M2w3
	7q14yHDa+PzDz1uvZN2s8fr+99CvgIYr1pccWevqvzzRXOSUKr7DNCVh2skDGRxM3LPrvPZf
	yy56u3x90x9phy8LZ77ruZijafr30eGVJxpumrNHXnwQEyF4QCdKrnRt0M99/2+Kh7V7KLEU
	ZyQaajEXFScCABaJipd3BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvC7PtHXpBpOnylvMOd/CYvH02CN2
	i8dzV7JbPOo/wWax7NJnJou719wtLmzrY7WYM7XQom3HZVaLy7vmsFlcWdLDbvH/1ytWi2ML
	xCy+nX7DaLH07Vlmi7MTPrBanJ/zn9ni9aT/rBZHt69ktbjWZGFx4QjQ1P2PZrI6iHlsWXmT
	yWPBplKPTas62Tx2PrT0eLF5JqPH+31X2Tz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr42Pz
	bJaCPraKj3NuszcwvmPpYuTkkBAwkVg5rwXI5uIQEtjNKHFr+jJGiIS0RNfvNmYIW1hi5b/n
	7CC2kMATRonlk5JBbDYBTYkTe1awgdgiAuISF+YtYQMZxCxwmVni3M87YA3CAskSh6/tABvE
	IqAqcWFVN9gCXgE7idsHL7JBLJCX2H/wLFgNp0CgxIX1v6CWBUgcmNzMBlEvKHFy5hOwq5mB
	6pu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5yYYFhnmp5XrFibnFpXnpesn5uZsYwfGnpbGD
	8d23Jv1DjEwcjIcYJTiYlUR4JaatSRfiTUmsrEotyo8vKs1JLT7EKM3BoiTOu9IwIl1IID2x
	JDU7NbUgtQgmy8TBKdXAZGKtv3fbnnqzsKO7NfP181cWMtgzd67pVvuusOXGibszeYtEP/hW
	S7X9X7Q5NiW6wDR+5aezSe9u2N/weK1qfqpE5faDufeOMx2RZXNdYBJ492q/1aOq3xMnWRYc
	yl5j2n2yW+j3BBH5Xf9v/v08q+XPrv2Jmz7t32B2I0JV/GhOb7zhibO90782Jxh9+WxS3bd4
	64TqdJnsjNiWG4fXv1n01TNIVGyyQt4285MhcsL655/mHC46VmxetJ455NP5n0HVJqEfGVRS
	uctrK3t0jqdsaZu06n3iow7rzhc5xZ9ndd2+HxYUHLbFTHXd6eL8Gdfe51baXruZzr/2q0Ko
	wNqLZXoTtA7W3H1z7UF2oxJLcUaioRZzUXEiAKLpKf0uAwAA
X-CMS-MailID: 20250214010204epcas5p3e6bcf86ec8c473d776624df81b0e4a0a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250214010204epcas5p3e6bcf86ec8c473d776624df81b0e4a0a
References: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
	<CGME20250214010204epcas5p3e6bcf86ec8c473d776624df81b0e4a0a@epcas5p3.samsung.com>

On Thu, 13 Feb 2025 at 15:47, Stefano Garzarella <sgarzare@redhat.com> wrote:
>I forgot to mention that IMHO it's better to split this series.
>This first patch (this one) seems ready, without controversy, and it's
>a real fix, so for me v3 should be a version ready to be merged.
>
>While the other patch is more controversial and especially not a fix
>but more of a new feature, so I don't think it makes sense to continue
>to have these two patches in a single series.
>
>Thanks,
>Stefano

Well, I agree with you that these two patches should be splited.
And I will send v3 version of the first patch individually.

And according to our discussion, the second one can be ignored, until
we find a suitable way to deal the scenario I metionded.

Thanks,
Junnan

