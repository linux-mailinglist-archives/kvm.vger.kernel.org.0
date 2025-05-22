Return-Path: <kvm+bounces-47375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B41AC0D68
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB39FA229B9
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D001A28C2CF;
	Thu, 22 May 2025 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VGBJS/rP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6936128C2B4;
	Thu, 22 May 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922264; cv=none; b=N+opHCecgwV4L9Yf3j0lKkqgNE8rowYISoS7yDQI3XUhK5+AFOV9a2ZHO37iktBPke+EuzOk7XgXZjRySLOeqh+TIkQOFQ8xQHbHQh6ufagpIAknAw/HSzh16yyLrrUXZ282tOKJVwMe9VnvBQpXu9grY1VYiPvn8ne1Ys9hx3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922264; c=relaxed/simple;
	bh=QDsvT4Br3Ytep0nbIiWloWpBZUwzfyUEFrDj0b6mIYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhEpX1C3c1gbasRjbT1lpUJXhEYg/KVXtPI5Di9xZxok1swdXg8AB6FnCwUldl1JAQhmkrPEWzqdYaSQokoaf07W8xYGKY178r0Xab2AcacXhYEf1jIbFc4EFPP+XA2e6frVtuRBVfkpxk3uJ4zgt+oLHBivBm+f2e3zD/GT5tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VGBJS/rP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M4EwpF002960;
	Thu, 22 May 2025 13:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0bn2w97g0TtAtHIsIN9and4Wt7b7gt
	d+pdghLBQ6Vj4=; b=VGBJS/rPB/M9GF9+/v/QcwPwHomHT2m/+E1Be+0rgD9V8s
	OXU3qDZY7lVxYBP40cZ3mAasrV0iQJwpj/yiIn3kzVs0CZ9RNX1RvugqoxyYVrxZ
	NcWlDkzoDKub04q0iqPP/Q2k6y73hvDot5cl2F2mblnQEo0HYhW/X9rsDHkhWMVe
	bEIvVuFvQMZBC+zA4z6WTRsCsziAaz98dWrHIyQT1i26K4YC+RdMOh9oRAM8+39v
	6SOxcQYYbO2co6rtBR0+VVTic78U2j3BMA/jT1fFSkF/8l6uj95Q33kdShOOHxwq
	PR1fjJTOZf40qM3paKwwuNVcp241v144kbNuQ3tA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh74g9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:57:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9kCLH020713;
	Thu, 22 May 2025 13:57:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkq1qs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:57:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDvYPV38404424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:57:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D17020043;
	Thu, 22 May 2025 13:57:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C47220040;
	Thu, 22 May 2025 13:57:34 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 13:57:34 +0000 (GMT)
Date: Thu, 22 May 2025 15:57:33 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 2/4] KVM: s390: remove unneeded srcu lock
Message-ID: <20250522135733.311722-B-seiden@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-3-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzOCBTYWx0ZWRfXzYFptVQuL8qh bBwEDhh5pzrTlofGKLoLWoHAtnJOqedwz4uW3I2Hx+Yv1cgmEpToSRvA2+10EuWHPTdUMl/v21r 4oPtt2p1a0tOhLmdOzcbcKsehZsfDlGIu5tYhyG1LHwG3lI0eHKNPU1j1P/nbMdXHETp0eaKTEH
 trRl5I/PBHXLyWMYXxmFmDlihdN+KiIUipi/y5DJMlzMAF3hTPEZpXolf1OOv3qIfCKTIdq2BTz v/L0Gqnp9KSCoiTNaFfaW4q4QOu6y05FBUoOmH7EP+aLe08VLyHRrZd31tN1WXB0leYjHqhFQXN QsfjNJBQGDSmy627dN2UOF0L8YlqvAmkhfwYQZ8kTS1/JtSONzZ/yORVV+ogdAYQn8dz1zy/TSL
 7Gr65LGaVHPtnV6ZAmhOLaYCtJhhJeRw0gtBNpcHPFPWf80vI+Xi3zZ4KLu/CclrBP2hu1mU
X-Proofpoint-GUID: SUmfjF6-_7MOx3aNm6g_ssSa4LQ2mZaf
X-Proofpoint-ORIG-GUID: SUmfjF6-_7MOx3aNm6g_ssSa4LQ2mZaf
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f2d52 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=N-PgjwyHdwUcJUqC-LoA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=100 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=-999
 spamscore=100 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220138

On Thu, May 22, 2025 at 03:22:57PM +0200, Claudio Imbrenda wrote:
> All paths leading to handle_essa() already hold the kvm->srcu.
> Remove unneeded srcu locking from handle_essa().
> Add lockdep assertion to make sure we will always be holding kvm->srcu
> when entering handle_essa().
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


