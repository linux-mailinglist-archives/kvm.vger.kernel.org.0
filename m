Return-Path: <kvm+bounces-16697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7358BC9BB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D107B1F22A2A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6AB1419A1;
	Mon,  6 May 2024 08:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JsQlMstm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7235A788;
	Mon,  6 May 2024 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984769; cv=none; b=cOn+BSSxBImUAwFhJhRRb/+p0PB4o2QFbEc7y04Qiodpi2GYaPdvyyKAA0IyQZRl8zYWUc3W8z+QY04sGUWT7nLRpiKMkZuOzlxJh+SfOx2OO4aIukq/9p3I9rsZPy/LrC993l+ziTPar/FPWlJikgEdgkrBvH9fEEzdSi0Hke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984769; c=relaxed/simple;
	bh=pb1Rc+9NPLnwGIT7gD6BTBq7ZC0pDavC8Tc5xj3YZ3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3vV+XAmBOZhWWMbV+Mf1HIY2hFEA9lwK7rBPI7GbG0CgP5GHCEQpCPHJbfz3DPyo85ZWwSKQgO+vypm7vInF0Z1F+jmdl/zhCyE2RYn5WQT6ZUxd1/VcmHuiEFg+qPvwCciBcG+egKhPr2lchpwJHVZI2kg06AXuQ0l2HvaWJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JsQlMstm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4468O8CS024779;
	Mon, 6 May 2024 08:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=6rw9r746ueif5tDySgJaQPVSe6/wIjUvI1xxkCK72XI=;
 b=JsQlMstmS+HEeLJ6Z+ZRqHTDHaZhs8vuN7DY6OXbvR/WOC/NG3K/74l4iRsg8Fus1jJR
 HvR9msAi4/v2YR7HKPs32TRYmtW5ut82sQax5m4xvm2y9IAxyf/ExJlx0RlT/2i1lvbd
 g6jGxTHzMc9FgXQJ2Q5dToULOsejsUmXaGO9dJv9hfoqMcej+uEIv+zgQjQ3h4i19sCI
 h1om+y1MtJNhVQ50ftCg5hOL2O98JZzXKnvfAwpRkFxjT5zh1LQh3DHjbKVyclF9JjvM
 n+HgOJWb5WX6kvTaJPIvJvp3T6vOkpyzStn6emPL8r2V6GMQnH47A6LiyOvUO9fOs6oH 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxug6g1sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 08:38:39 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4468cdoJ014374;
	Mon, 6 May 2024 08:38:39 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxug6g1sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 08:38:39 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4467YEt4005549;
	Mon, 6 May 2024 08:38:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx5ygwhha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 08:38:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4468cWqb33817258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 08:38:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A85E20065;
	Mon,  6 May 2024 08:38:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDDE42004D;
	Mon,  6 May 2024 08:38:31 +0000 (GMT)
Received: from osiris (unknown [9.171.46.190])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  6 May 2024 08:38:31 +0000 (GMT)
Date: Mon, 6 May 2024 10:38:30 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
Message-ID: <20240506083830.28332-B-hca@linux.ibm.com>
References: <20240412142120.220087-1-david@redhat.com>
 <f53a87ed-c3fe-4a60-8723-3eea25189553@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f53a87ed-c3fe-4a60-8723-3eea25189553@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pTLHBXGc69PVC33eUA14E-gUyGICY0ip
X-Proofpoint-GUID: YK__QwvpgYTeAcFYR5FbguaUC6-_DEUS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_04,2024-05-03_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=676 clxscore=1015 adultscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060057

On Tue, Apr 30, 2024 at 08:49:31PM +0200, David Hildenbrand wrote:
> On 12.04.24 16:21, David Hildenbrand wrote:
> > This is v2 of [1] with changed subject:
> >   "[PATCH v1 0/5] s390: page_mapcount(), page_has_private() and PG_arch_1"
> > 
> > Rebased on s390x/features which contains the page_mapcount() and
> > page_has_private() cleanups, and some PG_arch_1 cleanups from Willy. To
> > compensate, I added some more cleanups ;)
> > 
> > One "easy" fix upfront. Another issue I spotted is documented in [1].
> > 
> > Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> > from core-mm and s390x, so only the folio variant will remain.
> 
> Ping.

Claudio, Janosch, this series requires your review.

