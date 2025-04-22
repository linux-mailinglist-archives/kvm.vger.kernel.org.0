Return-Path: <kvm+bounces-43817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A59A9661D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D7E13A97E9
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55E31FE45B;
	Tue, 22 Apr 2025 10:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CDIW9KDD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE961F0E25;
	Tue, 22 Apr 2025 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745318360; cv=none; b=kHPWBXw8z0FEGRHJ7OewZMB7/gl/EhMgSM+x5eUPsiIil1mq+T2WI8nCMnaAnFHSQRe/Iuey+jPkweLvoaq14HZy+p88EplQUPAqeqm36pI7jjA17egHSvVbLISmSgR7/V+BEBBCODhsUNW7zGCZZTwwG4mHsoX+qWEUHBY8BH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745318360; c=relaxed/simple;
	bh=1UhuVXbaFKWeb0fLck1sKPYvB8kOMrkWfLcpd3zvslg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MNzZ4KHinE3mHFW90o/SpUjVt5tjqu8oEjuinnCOZdjBm/viEEcuCgMJ9TmqIwB5vbi7cPYweicpicIt0Y9PuPnduqacA7gW95HEyrn9/AzE0KpLFowiQUkf8WfDAslQe74SNayzl6VXmVwonpxeC+jKJq5mmJeewvRPOPrD0b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CDIW9KDD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53MA48Qa026975;
	Tue, 22 Apr 2025 10:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gyq1bl
	E4aR+H2rjw+Fhd/npSY+K486Hoqx5ngCD0bJg=; b=CDIW9KDD6/7poyhicvVNlb
	GHh5Xf79ZHX+Vxa46Hnjimg19hyG8eOGwysQm7r5lJKaYjsWuci4RqYA09nbIfWu
	qk27I6T+cadNWvbQplF7PEcoyUJCsDAE5YIUSVOISPHkYm1iHTjIBRWhgNxOqwtT
	ttYUOBQ0/PazRKYVnAY8tt7pRPbApHYxjheXP7E0skKPDHEAGffBuI4iW5/P8+Kx
	wZKaRx91aHutUN9ZRiteUTsqUfqNo22oRo0SBK+ibaGiRzBF4itsM+/oWjyAGuol
	bNQdz91nWvnhcYK+5gS+vP+rSMoqJk00griNuVDu7vHKPf7q/zWin0AC3EbeHxew
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46691hg5e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 10:39:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53M70aSp002971;
	Tue, 22 Apr 2025 10:39:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 464q5njems-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 10:39:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53MAd33N56689012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 10:39:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7958620043;
	Tue, 22 Apr 2025 10:39:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D729720040;
	Tue, 22 Apr 2025 10:39:02 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.111.13.221])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 22 Apr 2025 10:39:02 +0000 (GMT)
Date: Tue, 22 Apr 2025 12:39:01 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Amit Shah <amit@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin"
 <mst@redhat.com>,
        stable@vger.kernel.org,
        Maximilian Immanuel Brandtner
 <maxbr@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio_console: fix missing byte order handling for
 cols and rows
Message-ID: <20250422123901.6beac282.pasic@linux.ibm.com>
In-Reply-To: <4913ceb31b31feeec906636a1a64d46ea6c6e94e.camel@kernel.org>
References: <20250322002954.3129282-1-pasic@linux.ibm.com>
	<4913ceb31b31feeec906636a1a64d46ea6c6e94e.camel@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=V7h90fni c=1 sm=1 tr=0 ts=680771cd cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=dmy1mdVUWN8X3jJ85t8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: sBQu-cGwpG_srjCr-t1H4EvT8qdOYFVh
X-Proofpoint-GUID: sBQu-cGwpG_srjCr-t1H4EvT8qdOYFVh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_05,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504220079

On Wed, 16 Apr 2025 15:49:40 +0200
Amit Shah <amit@kernel.org> wrote:

> On Sat, 2025-03-22 at 01:29 +0100, Halil Pasic wrote:
> > As per virtio spec the fields cols and rows are specified as little
> > endian. Although there is no legacy interface requirement that would
> > state that cols and rows need to be handled as native endian when
> > legacy
> > interface is used, unlike for the fields of the adjacent struct
> > virtio_console_control, I decided to err on the side of caution based
> > on some non-conclusive virtio spec repo archaeology and opt for using
> > virtio16_to_cpu() much like for virtio_console_control.event.
> > Strictly
> > by the letter of the spec virtio_le_to_cpu() would have been
> > sufficient.
> > But when the legacy interface is not used, it boils down to the same.
> > 
> > And when using the legacy interface, the device formatting these as
> > little endian when the guest is big endian would surprise me more
> > than
> > it using guest native byte order (which would make it compatible with
> > the current implementation). Nevertheless somebody trying to
> > implement
> > the spec following it to the letter could end up forcing little
> > endian
> > byte order when the legacy interface is in use. So IMHO this
> > ultimately
> > needs a judgement call by the maintainers.  
> 
> The patch looks fine to me, but can you reword this message to say what
> you chose and why (and not have the bit about judgment call by
> maintainers in there)?  If it sounds right, it'll be acked and merged.
> If not, we'll work to ensure it's all good -- so the judgment calls
> happen on the list, rather than mentioning this way in the commit.
> 

Sorry for the late response! I was vacationing last week.

Would you be so kind to propose a more fortunate wording? My intention
was actually to say what did I choose (I choose virtio16_to_cpu() over
virtio_le_to_cpu()) and why (if we go strictly by the words of the spec
virtio_le_to_cpu() would be right and  virtio16_to_cpu() would be wrong,
but  assumed that we forgot to put the right words into the spec it is
the other way around; and MST confirmed that indeed those words need
to be added to the spec).

The part on the judgment call is because, for me there is no way to
tell if those words are missing from the spec because of intention or
because of omission.

Regards,
Halil

