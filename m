Return-Path: <kvm+bounces-44893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3018AA499E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1511E3B4641
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F252192E3;
	Wed, 30 Apr 2025 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zqc+iTeL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526A18641
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746011784; cv=none; b=De9wPTuwIh2Pez5zL5IWu/ZbiqjG/Mdyzt6DQcsXHycnG7/jpVSOFbzpvE3irUtToJ6QQHBi1mv2ZrXgiEWow4yg3/1ftZlexhU4liLr4oP1kQVO+jmYRD7px6NF7FPTZY2vJoKoTtC2YNSaVUWgYmqoG6NOjwr3/v3jkbnlYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746011784; c=relaxed/simple;
	bh=UiZDN4ieHNK2NFU4zb9jQfoCyosFsYzflROR2QiB/L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVfTWN71bavYzr591kc0VhOGI1qdxTa83sJN36uloRPveUzq80P9J6quVpKf5EgAzjQC/kLDkJ7cO4f1/86bk6uFNHkFUQZB6lxwGBYC3rrOZitNoQoCAPPrHCeLOlDCVzvGos67SQD438s/XfKpp8GP/bGizzCxWwsYAYBqiQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zqc+iTeL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UA4Dx2006425;
	Wed, 30 Apr 2025 11:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UiZDN4ieHNK2NFU4zb9jQfoCyosFsY
	zflROR2QiB/L8=; b=Zqc+iTeLE5Y1KdxxY0xZA2lBALBW6vabKXPCEzfY4JY/sw
	eWqi771YaVvvY+OuxoK0H3OAhrlfNfysk+L9j1RM+hRzfPeXd7A61k4p57fM/mIe
	Goiv9KTlOt/TpNSYxRlcjvhkJlu6E3T/n+PnVMxNMqkPOMNTQJmh5w+vvGhdnjV5
	+4YN288NzHHhAih+1izvhejUuUn9vzII7W11ICAhqSomrf9Pac5sdrEaFR/hm2sf
	wlsNLlcqDC6VFIi9XfxUJ0BsUZ60vZg/j+C5fFDVBFO9yAkCPqQn+sKLWvBEjizF
	cYLK8duWoWP2U39NBXBbV6k2Ud6GcQuZXqe4UKKQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46bhsjr9tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 11:15:32 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53UB0f8B025696;
	Wed, 30 Apr 2025 11:15:32 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46bhsjr9tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 11:15:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53U9Rwfm024607;
	Wed, 30 Apr 2025 11:15:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 469c1m7b0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 11:15:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53UBFRvw31130198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 11:15:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9824A20043;
	Wed, 30 Apr 2025 11:15:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2F0020040;
	Wed, 30 Apr 2025 11:15:25 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.124.221.86])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Apr 2025 11:15:25 +0000 (GMT)
Date: Wed, 30 Apr 2025 16:45:23 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: npiggin@gmail.com, danielhb413@gmail.com, harshpb@linux.ibm.com,
        pbonzini@redhat.com
Cc: qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        vaibhav@linux.ibm.com
Subject: Re: [PATCH v2] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
Message-ID: <3yhi7haaddnluzc5oy23nynywjeazkkngx47hwoymce6lmcitp@chtjm727vuz4>
References: <20250417111907.258723-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417111907.258723-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=dcuA3WXe c=1 sm=1 tr=0 ts=68120654 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=pPNRN5iWhjdFy-iXWNUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: q49GvDOeZJPz3AGM5bALBlxmbci7SeQD
X-Proofpoint-ORIG-GUID: bRY-NMR0W81ELbhCsaXgLzU-rE2gsMAv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDA3NSBTYWx0ZWRfX4AOrvpznDcyQ EavVYP9WyoA9/TfcLN3RwqIZfIQohrmanJfQFEDXOPHQ6uXsEkO//Y3VNmHmHutmZR/wrt7YRT1 2U7jqWlTXKIiMcOake+F44NxJduoXDNvmkjWF5gyxaFYUoMOY0nqgsnhnG9BciLNTaCwkpC0NFJ
 sb42mNkKyie0GlJOlRVJtLHBwITIWDGsAzQToEnE/I/i/V+7UihOKs/MVniVKCCwTmvPc1iNxjS EW8psXKxRGVxvk3Udh8yoDSf1+sMuPrKuWdV7+/WkewSVWeHz0aQGifVbYDR7ga5FkQ2FKOyeSQ rbXgmYeVKChdROyr61Q5kRXeF3xcMn71aga2/vbLGx2hWuSPNa3McmDqxVLkJmMu6qzm6Onm4NU
 YyXmBo3CeW8vu2V59lS+INI5T9cROvXAgowuTG4KV9dzUymfgX0DovGyX5K3rRwmjl5To3kH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=556 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504300075

Hello,

Please let me know if any changes are needed in this patch.

Thanks,
Gautam

