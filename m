Return-Path: <kvm+bounces-46065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 079C7AB15E1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F034F189549F
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 13:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461FB293731;
	Fri,  9 May 2025 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hc8nLPs+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CBA2918DC;
	Fri,  9 May 2025 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746798605; cv=none; b=q3RrYqPq2MQbWruy7gmOhFy9ejnWTlRVdwOadrd0C6K+HHOPZu04MKEErCwvZKPryjCyvKAHx7ktfdx0SLvje/uuBKEh08fi8Rw5VpuwCIMjLdqTNvQz3VN/F7SP8RNx8GRvf0CQRdb6VEIDHmUFK4quzJeFhrd1ZrzLawEG08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746798605; c=relaxed/simple;
	bh=qL35tfjqtvRbZWZeDNm4gyYoQKOGEeBiDKDQQJ0f6xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaPH//KGtmw/pJE3nBKw8R0S0XZRtj+cIbsUQj3/73FX0aslEGMokCJ7BVPHCufMfwBXcbBNEXGpWCBo57dWwnwO5/lPGakjnZ6J6WVKcUa8Olj6mtP8f6dSV/4d+ZCMfioGk7V/4zbCtw4FJBI8egrCqh72UfV5it2zHRMJ6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hc8nLPs+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 549DYmZw031546;
	Fri, 9 May 2025 13:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qL35tfjqtvRbZWZeDNm4gyYoQKOGEe
	BiDKDQQJ0f6xM=; b=Hc8nLPs+GogWCY8kTHyiFY0gIrg0TzimptS2a6fDT6zcwR
	Ohdi4qF3WkLRiVni2zrKvQAsZvGtjESE421Gl3ef74BUhq8ufOHx5ENWgcdztvBK
	6dsRagf/J4hItu87AgWYZlXna5zVHNXTe6q/jEzOtB5p44DcCrt5E4VGeZ1yZknv
	+zDt/pFeUArs+TtfIDFQh2m7cctqd7k5UYUmgHXvmWJNy/Lfiw2c1SuXszLJyU3L
	PgwCfvPxjdKozvlHPcI/7+JMTGMxpch7gD6GzDqmnLcInh3c3wJxfIgl2A8bpPsa
	ytKUM0VB8cPum0ce6Q9krW7tjRTkySv5wZrxc5DQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46h4rwc0gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 13:49:47 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 549DhFHQ030863;
	Fri, 9 May 2025 13:49:46 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46h4rwc0gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 13:49:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 549DIKC8014097;
	Fri, 9 May 2025 13:49:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dypm3b49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 13:49:45 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 549DnfBA55378284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 May 2025 13:49:41 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBEAC200F6;
	Fri,  9 May 2025 13:49:41 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE822200F8;
	Fri,  9 May 2025 13:49:38 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.39.24.79])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  9 May 2025 13:49:38 +0000 (GMT)
Date: Fri, 9 May 2025 19:19:36 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix IRQ map warnings with XICS on
 pSeries KVM Guest
Message-ID: <m2a54sgts6stdrdiduzhkiqsp3wlfmlueelxivjsy5qpd3f3oz@3lgtuy5bl4x2>
References: <20250425185641.1611857-1-amachhiw@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425185641.1611857-1-amachhiw@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=QIxoRhLL c=1 sm=1 tr=0 ts=681e07fb cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=v01Bmm9WW5sV4C35fbgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: HaN2FDaQ0WR_SGqBR-G2bMzjMEx0FPeF
X-Proofpoint-ORIG-GUID: 0neBe9qo4vhcaef3bA8JcpV8S5vxVVwP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDEyOCBTYWx0ZWRfX+ZwY+iQm1GHY paAeBzeUc7BYyHlO61eGEeVHBhPzZnvdEYKQCFlIO2ee0Ir+SJ2Y6p1BSFxukZhlC117CrAasR/ 088CaR/oeWz0vzgPkjM2rDlxkiHtFRvekaaDNeDg8AJsTQhIBxhj+AE3EIvcuQZOrtZZGZ1ahsu
 enZ4Ad0sFzTQJDRoGH5xAPdw3LjZrMjF6U8f4cl5YjZToZADVvHbm3oc4LgIPJrIt2Q8cWWozdN ZEPdEaUJDyfqqhgpuhOf2on3ai+EzMfeEtaOPkpWOThz4dnJsczs0N96pfz365ziBe5Z9a6gPkP KaxZKY3bi9qyzGtAjRYQXjTr1rOJq4iWZ8nLcvIUYvwQY9bVoSYO3bDA/gLRxn92Px5SuhhZk4X
 a+ILzqMnlb/5ibD9RkZvGujtcIG/h9YDcDyfdh1oJ2oSrElr3ay+Xpoauc+UJ9kDvSKFdbBV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_05,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=568 spamscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090128

I tested this on both KOP and PowerNV, LGTM

Tested-by: Gautam Menghani <gautam@linux.ibm.com>

