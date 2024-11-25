Return-Path: <kvm+bounces-32438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AC29D8707
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86C21B3207E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430D51AB52F;
	Mon, 25 Nov 2024 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JO2trHqw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950018872F;
	Mon, 25 Nov 2024 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732542032; cv=none; b=tqlnFjzxh4DJl1A72U9ZwhwJHTEbWPEWe0txUrjVO+M0gA9BCPGnjzF08G3c9QIw4+MSpFW8d0m6MscDZo8vaM05Cyy6RgYXBv69gV9tYeuJVk0vcZn5tHSc2r5xrA+dgO39lTARb5f2/3GWvxqz8oQ6M0rxAk8AqrluAulLNYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732542032; c=relaxed/simple;
	bh=Ywqwd6YALEXzhnE6FFAoiYljnJijnT7S0iUZ8xoHAdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJvVC2/JVsV+cXqb5NS60bYdpSuTWGuv5kS3dvlckkdaWycJdf6TChR+yCXVasEqS3RlQe8eDR+fOOXjXkyVkKz1TsaxFjg8MUBnVJsI7EDp0igFri4jqDiweffBXjk+mv75Ag1tW7Um2Ia+eLiA7dnBGrqkcJhFRhgXnOEvtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JO2trHqw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APBDorY005357;
	Mon, 25 Nov 2024 13:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=aqJI7R1FRzjvbqvVNF3SYg37bbVlYS
	EUty2FMF7VzE0=; b=JO2trHqwcT5S9TZe4GyPxVHa+tgReBDNkywE4YvwO4PcyF
	lKgIY2io7tGNIn5dCf5wKxWFFf4GENngmp23OCdCBpg9FilS4vImYpjXSfFoI242
	WJJAnwve/X83Fz5mUFJpOALT1+nt8CRzJpDEpqanz1vp9efUs4clt1XG/O5y0TuX
	cSIc5+VkGTpl1lMlQcZwZ0pd4VuBYAJhkWUjjWe2uh+pdjEqUSNgTiY3IOGKuze2
	hIjsnzRfOHcROv3imxQU1Ananjyyh2olX37FAT5m76qCghF4TRNu256GaC3trT3D
	MfZ7naapSpQyXLHOzztUK5CZ2MM44zcBoXBhH4Jw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4338a78d3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:40:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP5oAEW026337;
	Mon, 25 Nov 2024 13:40:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 433v30tehq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:40:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APDeN2Q54788492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 13:40:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3FE020043;
	Mon, 25 Nov 2024 13:40:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9056820040;
	Mon, 25 Nov 2024 13:40:23 +0000 (GMT)
Received: from osiris (unknown [9.179.25.253])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 25 Nov 2024 13:40:23 +0000 (GMT)
Date: Mon, 25 Nov 2024 14:40:22 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241125134022.14417-E-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
 <20241125115039.1809353-4-hca@linux.ibm.com>
 <20241125132042.44918953@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125132042.44918953@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZAMo7C4kmPJKVx8m5_WxSnGl_7IhNwW1
X-Proofpoint-ORIG-GUID: ZAMo7C4kmPJKVx8m5_WxSnGl_7IhNwW1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=549 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250115

On Mon, Nov 25, 2024 at 01:20:42PM +0100, Claudio Imbrenda wrote:
> On Mon, 25 Nov 2024 12:50:39 +0100
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> > kvm_s390_update_topology_change_report() modifies a single bit within
> > sca_utility using cmpxchg(). Given that the size of the sca_utility union
> > is two bytes this generates very inefficient code. Change the size to four
> > bytes, so better code can be generated.
> > 
> > Even though the size of sca_utility doesn't reflect architecture anymore
> > this seems to be the easiest and most pragmatic approach to avoid
> > inefficient code.
> 
> wouldn't an atomic bit_op be better in that case?

I had that, but decided against it, since the generated code isn't shorter.
And it would require and unsigned long type within the union, or a cast,
which I also both disliked.

