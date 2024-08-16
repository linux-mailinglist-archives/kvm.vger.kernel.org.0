Return-Path: <kvm+bounces-24461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AABFF9553F2
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F00BBB22735
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302661482FE;
	Fri, 16 Aug 2024 23:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="BbYaKHkF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7365CB661;
	Fri, 16 Aug 2024 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723852383; cv=none; b=rpVyET6+0/vS0IswduA7Alw4S3k/FB11TSo4zOKf7Cwhjh6Grh0Vg0cifrXyqPfXRZbVniZ2Uc7gKCTyjF4MT7Lsq+CHRclpAmhlDZC/kR75dr0tJeHynXwDGnzhE/ft/QdNXQbkKvIBIN0BIYZI1PN7l76uYJRcIZ5m2k14FR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723852383; c=relaxed/simple;
	bh=DMO57vi9AiJjXnsgH5AIT5Qez88LtNPRhneBZN7cIZ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLZX8TEoAHCKUR1WtPUQrKLQ3ezWif6ZSwwk6IyUekugJZDFxsT1eZ3Ry3ExF2+Vqc3AGuVoNnVB5TVGs4BCKkAUtxsogml8ei57qWuHPvKasf0ZEIEztvhoc5ceXcPiYB3dD9cg+47rH0y6IbOVSJndWOWWUhRz8XFeLidC4Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=BbYaKHkF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLbupb003157;
	Fri, 16 Aug 2024 23:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+JXtY3+Fg/Wm0qnAcs1ijp3a
	tNHmKpNMITHGUXLSaa4=; b=BbYaKHkFmQ2/B1FGTdE06tTqPjMRo3i2YJFQoG6F
	cuz1EydEBnnUN86NVgY08eDD+VOV2lv+2opRktK1gZ18DYA/08SlibgfMBFGOmc8
	ASUma4kF9TYkJ4U1tsjFCZTGWmHOGtjLJT4IWcpoPs+5E78YrSvAx53eY6ukxJ7c
	yqXuI6fchBgLWJDYtOdjI0nHlNV1Y1eptkk4MpooloMCUx5jI94GaZHUltCyJfID
	IfxgZqgPHMX3WBvFY8YpJzU3Vpq31Dlxc+f3Olc0bKGbpQgZT4pCYKPMbRAYjCYF
	S9fE0zPJtH1ownlsu/m5Zj1QEs1UcwujJRCFH4oRbQ1AeQ==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4123cuj22g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Aug 2024 23:52:48 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47GNql0s025394
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Aug 2024 23:52:47 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Fri, 16 Aug 2024 16:52:47 -0700
Date: Fri, 16 Aug 2024 16:52:46 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: David Hildenbrand <david@redhat.com>
CC: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
Message-ID: <20240816164546141-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com>
 <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
 <diqzjzggmkf7.fsf@ackerleytng-ctop.c.googlers.com>
 <94c5d735-821c-40ba-ae85-1881c6f4445d@redhat.com>
 <diqz4j7km8yu.fsf@ackerleytng-ctop.c.googlers.com>
 <93a010dd-d938-4c49-8643-047c7c1b33b9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <93a010dd-d938-4c49-8643-047c7c1b33b9@redhat.com>
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: mtiFw9e4dNNfIlhdJ9ghNLDPswiUrfD6
X-Proofpoint-ORIG-GUID: mtiFw9e4dNNfIlhdJ9ghNLDPswiUrfD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_17,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408160171

On Sat, Aug 17, 2024 at 12:03:50AM +0200, David Hildenbrand wrote:
> On 16.08.24 23:52, Ackerley Tng wrote:
> > David Hildenbrand <david@redhat.com> writes:
> > 
> > > On 16.08.24 19:45, Ackerley Tng wrote:
> > > > 
> > > > <snip>
> > > > 
> > > > IIUC folio_lock() isn't a prerequisite for taking a refcount on the
> > > > folio.
> > > 
> > > Right, to do folio_lock() you only have to guarantee that the folio
> > > cannot get freed concurrently. So you piggyback on another reference
> > > (you hold indirectly).
> > > 
> > > > 
> > > > Even if we are able to figure out a "safe" refcount, and check that the
> > > > current refcount == "safe" refcount before removing from direct map,
> > > > what's stopping some other part of the kernel from taking a refcount
> > > > just after the check happens and causing trouble with the folio's
> > > > removal from direct map?
> > > 
> > > Once the page was unmapped from user space, and there were no additional
> > > references (e.g., GUP, whatever), any new references can only be
> > > (should, unless BUG :) ) temporary speculative references that should
> > > not try accessing page content, and that should back off if the folio is
> > > not deemed interesting or cannot be locked. (e.g., page
> > > migration/compaction/offlining).
> > 
> > I thought about it again - I think the vmsplice() cases are taken care
> > of once we check that the folios are not mapped into userspace, since
> > vmsplice() reads from a mapping.
> > 
> > splice() reads from the fd directly, but that's taken care since
> > guest_memfd doesn't have a .splice_read() handler.
> > 
> > Reading /proc/pid/mem also requires the pages to first be mapped, IIUC,
> > otherwise the pages won't show up, so checking that there are no more
> > mappings to userspace takes care of this.
> 
> You have a misconception.
> 
> You can map pages to user space, GUP them, and then unmap them from user
> space. A GUP reference can outlive your user space mappings, easily.
> 
> So once there is a raised refcount, it could as well just be from vmsplice,
> or a pending reference from /proc/pid/mem, O_DIRECT, ...
> 
> > 
> > > 
> > > Of course, there are some corner cases (kgdb, hibernation, /proc/kcore),
> > > but most of these can be dealt with in one way or the other (make these
> > > back off and not read/write page content, similar to how we handled it
> > > for secretmem).
> > 
> > Does that really leave us with these corner cases? And so perhaps we
> > could get away with just taking the folio_lock() to keep away the
> > speculative references? So something like
> > 
> >    1. Check that the folio is not mapped and not pinned.
> 
> To do that, you have to lookup the folio first. That currently requires a
> refcount increment, even if only temporarily. Maybe we could avoid that, if
> we can guarantee that we are the only one modifying the pageache here, and
> we sync against that ourselves.
> 
> >    2. folio_lock() all the folios about to be removed from direct map
> >    -- With the lock, all other accesses should be speculative --
> >    3. Check that the refcount == "safe" refcount
> >        3a. Unlock and return to userspace with -EAGAIN
> >    4. Remove from direct map
> >    5. folio_unlock() all those folios
> > 
> > Perhaps a very naive question: can the "safe" refcount be statically
> > determined by walking through the code and counting where refcount is
> > expected to be incremented?
> 
> 
> Depends on how we design it. But if you hand out "safe" references to KVM
> etc, you'd have to track that -- and how often -- somehow. At which point we
> are at "increment/decrement" safe reference to track that for you.
>

Just a status update: I've gotten the "safe" reference counter
implementation working for Gunyah now. It feels a bit flimsy because
we're juggling 3 reference counters*, but it seems like the right thing
to do after all the discussions here. It's passing all the Gunyah unit
tests I have which have so far been pretty good at finding issues.

I need to clean up the patches now and I'm aiming to have it out for RFC
next week.

* folio refcount, "accessible" refcount, and "safe" refcount

Thanks,
Elliot


