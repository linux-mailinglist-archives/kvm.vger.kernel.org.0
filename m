Return-Path: <kvm+bounces-26729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08355976C93
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C5221C23B6A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164741B9837;
	Thu, 12 Sep 2024 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oYCgF2ML"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4131ACDF9;
	Thu, 12 Sep 2024 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152473; cv=none; b=As98ZbLhb6MDeDZxvT5WybV5IwCf94YFmEuzQRPHj3dlzgD4J7JGswP7u1Yl1/J1XI5XUNk8Luljo4BHCtVFCL4g1EXW52QWAoMkF1VKbbslQRWpr5C6/55/z+Kv7Y1EvjxLSw8Ou5Cy6ikbVwI9mc/o7kEe7wa4d1jfK9VEDIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152473; c=relaxed/simple;
	bh=hF0NkNn49+OsaoQazj7IegXHjTIB2Pa5AXOr8r+MNVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JqEMY3jGU/RQppUGIPbo4ptHaoLOIZVNz6eF7haj8JWtDygdsuEPw6cUNe3fzdogyOFwLnhc+1Sr0AuC5yLoZPWs8kPqbHoPEESgHPdcHUEy2gtzQoiQBNp+XiHoZR1bzZF226ckoLGwARPID0DCZkfmmEd8PsRruv2Js8wtBkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oYCgF2ML; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CAeWSL003716;
	Thu, 12 Sep 2024 14:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:reply-to:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=F6pkaOwZmgo+j9NNrUOeESLmhPs
	ZpIo3xbmAno/mK4A=; b=oYCgF2MLEpHN9rujApoD/EsBAr64V6xHJMbg7sZkAbg
	efK84FlHSg/x72tXsG7LHaZ35b7wyPxu0NONBwQ2RbVKxb0xxW6LuPQHk2YrRJb2
	uvvcvOF8mKT5JCGJ0HGKv5N7ixJ48ygX3vyTzJYNQli3OWzuDhzvFv6Aa5ed9Lf1
	grpg+l38z3Y2LaM+96jUje8wxj69pbR9kDw9qfGlr38WWjj9NBHQb+y6GQVuGt51
	ofTuGyKexml8gdEWvpYfw3x7KOnHVz5FrG7RNg3P6CWAd1w+Rnt5mexI4EBC854M
	FAsZJyDLIEDD0ihFYdqVmH5QP27uEoU5GgenH5hcK/Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8kv4j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 14:47:35 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48CElYB5021115;
	Thu, 12 Sep 2024 14:47:34 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8kv4j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 14:47:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48CEWkOO003122;
	Thu, 12 Sep 2024 14:47:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h15u8reg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 14:47:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48CElVaB39715206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:47:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C45DB20043;
	Thu, 12 Sep 2024 14:47:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34E3B20040;
	Thu, 12 Sep 2024 14:47:28 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.126.150.29])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 12 Sep 2024 14:47:28 +0000 (GMT)
Date: Thu, 12 Sep 2024 20:17:27 +0530
From: Srikar Dronamraju <srikar@linux.ibm.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com,
        vineethrp@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ssouhlal@freebsd.org,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] sched: Don't try to catch up excess steal time.
Message-ID: <20240912144727.GC1578937@linux.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.ibm.com>
References: <20240911111522.1110074-1-suleiman@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240911111522.1110074-1-suleiman@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _c9EMgB-lfyaLtrmTipheoTLDt3QQ4DC
X-Proofpoint-ORIG-GUID: 3CXo64PLHzm_BUK7QFX-xfpEjxNike9J
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_04,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1011 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=602 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409120106

* Suleiman Souhlal <suleiman@google.com> [2024-09-11 20:15:22]:

> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future things using
> clock_task, as they end up getting additional steal time that did not
> actually happen.
> 
> For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> time reported while it ran. clock_task rightly doesn't advance. Then, a
> different taks runs on the same rq for 10ms without any time stolen in
> the host.
> Because of the current catch up mechanism, clock_sched inaccurately ends
> up advancing by only 5ms instead of 10ms even though there wasn't any
> actual time stolen. The second task is getting charged for less time
> than it ran, even though it didn't deserve it.
> This can result in tasks getting more run time than they should actually
> get.
> 
> So, we instead don't make future updates pay back past excess stolen time.
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
> v2:
> - Slightly changed to simply moving one line up instead of adding
>   new variable.
> 
> v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com
> ---

After moving the line up, this looks good to me.

Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

