Return-Path: <kvm+bounces-63555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D42C6A4D7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id DE6212ADBE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E025436405C;
	Tue, 18 Nov 2025 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vgrc2oxG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF3357A2A;
	Tue, 18 Nov 2025 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763479707; cv=none; b=oOZW8rpG7bYQdGYAE/sRZS4SufVS6cz8Bu7PizdNM2Vpe5y80Qlkqt0mBoAMYCC5ZwcxXB61odES+n2fC8wNUUK1Wc561kI1A8aOSXM0ueAgLiy+WrLQow4QVxeNlqBusvfUJWi53sXRj8FXSV/N7W3ZDdDlfBIxWhYbEXZu/aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763479707; c=relaxed/simple;
	bh=dlmFQc3BXWPzOO7K7MFPLWSo9EZcCAmnaDO2Db1Xn+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEnjvTcpvid5ogHn0I50D2ZUc2rjvAsEhu2frIIPVEq9EbfAp0TR36bGgx9Fco0rJ9++20aAMPsGZiRbj6sqFH+vbuuagBufGuK/cyHtNizMfThFp8Q2p1p21S4HR36u8lKXOff92fZyJPyXuoEcg0UThMMV/lv6Fwpf2gIF+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vgrc2oxG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI6iBK6002633;
	Tue, 18 Nov 2025 15:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8ohlG5m4VJL7uwiYeTKpMq3+W74GME
	ZZFHmDEK3bsLw=; b=Vgrc2oxGVAGleCyC+zyLTl7s2wFNx89qGUIXViM8rRM00F
	iPI9TIqJydGI9MbORb0K9PZUW4Opo0NkBQbHTSoy65yRNci26sG2RJnIAm6jDzZ4
	JAubvPp6acWZ/VOZh5Kms59ojgaUZbdvCYjj/WdtwPT4yGaj/TMOF/Bk0Src95KZ
	1iOmekxTIwXivnwBLKm8djpw4r7POAzAMi85zJFbHIcBsEQX+VjqBido1CQurlV/
	PIkqPgXO3nU7ltSwJh5zEmi7VVKOgoNMC7/rSPiuTYG0SlUus06qfv6raqyImtOS
	Skx1JiiV6/nUgFf6WLY2Vu/EINT7VKHhDeqa88Pg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk1bj6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:28:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIBpbYX005118;
	Tue, 18 Nov 2025 15:28:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bk3req-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:28:21 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIFSHRC53412146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 15:28:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 659E320043;
	Tue, 18 Nov 2025 15:28:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDD1220040;
	Tue, 18 Nov 2025 15:28:16 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Nov 2025 15:28:16 +0000 (GMT)
Date: Tue, 18 Nov 2025 16:28:15 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 00/23] KVM: s390: gmap rewrite, the real deal
Message-ID: <20251118152815.9674D33-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=691c9096 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Kl6ix_ddhmwOMEz-dRMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: idbAXaip6qEb1IiIW-iclLQymLPOAgzU
X-Proofpoint-ORIG-GUID: idbAXaip6qEb1IiIW-iclLQymLPOAgzU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX/wkNy21JYIcI
 dKkG5zoenFuFm76MIyQB02GqPqX4AbS75nyAyKYjV5CWE7hNsx9TcieWdICWCYv2PwTfM9IR2z9
 QyEIg/7TG4rapRRPiH+WQaEk2uqbaDjSS3WTcKRwBbiMOnMa+ypcFQJW3+FAEA7SG5nVG1rE4vr
 CHTcziBquabWTAJe7thudl9gyxZpVc+ECwlwwqo3JliMYG9XfOHdzbwN9940XKxJsifeHAq9EyE
 2bgH6GRkHA/oUvPQeJNL4sCzNgLwY+4yIWheTmGQRG6X09wrJQ4OPU3dMRQmmG6q7hwmLqNnoFW
 mr601/ycNZ2Q9KDiSlpnKj0q0pmaMxk/Qm4MgkEODwQmz6M84GypSE/3E/0AiH4abRy+4IMtSE5
 aYULY03YHO8xXrT0yfSZRbr8Iv17Vg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Thu, Nov 06, 2025 at 05:10:54PM +0100, Claudio Imbrenda wrote:
> This series is the last big series of the gmap rewrite. It introduces
> the new code and actually uses it. The old code is then removed.
> 
> The insertions/deletions balance is negative both for this series, and
> for the whole rewrite, also considering all the preparatory patches.
> 
> KVM on s390 will now use the mmu_notifier, like most other
> architectures. The gmap address space is now completely separate from
> userspace; no level of the page tables is shared between guest mapping
> and userspace.
> 
> One of the biggest advantages is that the page size of userspace is
> completely independent of the page size used by the guest. Userspace
> can mix normal pages, THPs, hugetlbfs, and more.
> 
> Patches 1 to 6 are mostly preparations; introducing some new bits and
> functions, and moving code around.
> 
> Patch 7 to 16 is the meat of the new gmap code; page table management
> functions and gmap management. This is the code that will be used to
> manage guest memory.
> 
> Patch 18 is unfortunately big; the existing code is converted to use
> the new gmap and all references to the old gmap are removed. This needs
> to be done all at once, unfortunately, hence the size of the patch.
> 
> Patch 19 and 20 remove all the now unused code.
> 
> Patch 21 and 22 allow for 1M pages to be used to back guests, and add
> some more functions that are useful for testing.
> 
> Patch 23 fixes storage key manipulation functions, which would
> otherwise be broken by the new code.

I would guess patch 23 also needs to go into the already huge patch which
switches everything to the new gmap code, since otherwise bisect will not work
for anything that is storage key related.

Anyway, I can imagine some addon cleanups, but that can wait after this series
is upstream.

At least from a "core s390 code view", without considering kvm this looks good
to me. There is at least one known bug hiding in this huge rewrite - but just
wanted to let you know that my concerns with the previous version have been
addressed.

