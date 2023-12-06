Return-Path: <kvm+bounces-3733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E965807621
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C01EC1F2126B
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234734B5B3;
	Wed,  6 Dec 2023 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NLCGxKZu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782AA10D5
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:10:12 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B6GrTY9020141;
	Wed, 6 Dec 2023 17:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WrVWeOs1SDLSlPg+mXu3GOG4ERP2Y2Qw3pmaeifr4BE=;
 b=NLCGxKZuJ6rhJjs19SUksfLJKd7mCo5ZbuPopCG3wuUc5tEib5aZt4IJp1SE2OlxHbKd
 GVLcwk92/hIpHGchWGP5M/weE1jcXYvpPbF4zIzYJm3/skcuJ9UDHBZ8buwbZP4700Ur
 tdjELrMLAsEB6C4ctIv7vvJzK6PInG0N4pgNk83wLb6sQJCZuFYwEEIC8/0+ZvI43hPf
 mXlSIOdRa53B6428gjeAzIC/IpczJZgs8vrnzn9qrYb4EYUFe+Npenw/vbGaMmKztmh9
 uzweOZYCsNSAvFQf7CD9SpqbXcaz3F2X4Kc/6LOjSc7HpzgUXwDQMM1NOVHHiZN06m0q XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3utvv9gn9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:09:48 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B6H8ZK6027218;
	Wed, 6 Dec 2023 17:09:47 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3utvv9gn8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:09:47 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B6G899X004735;
	Wed, 6 Dec 2023 17:09:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utav4dt61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:09:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B6H9gE913763138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Dec 2023 17:09:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADD8220040;
	Wed,  6 Dec 2023 17:09:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 691E42004F;
	Wed,  6 Dec 2023 17:09:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Dec 2023 17:09:42 +0000 (GMT)
Date: Wed, 6 Dec 2023 18:09:41 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        oliver.upton@linux.dev, anup@brainfault.org, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com
Subject: Re: [PATCH 4/5] KVM: selftests: s390x: Remove redundant newlines
Message-ID: <20231206180941.54a8bbb0@p-imbrenda>
In-Reply-To: <20231206170241.82801-11-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
	<20231206170241.82801-11-ajones@ventanamicro.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3oRjVqV5xror_yWEbiUxzWGarB_48dzc
X-Proofpoint-GUID: BdFVxEdgmJrMOXRBiNWjx2nx55KINKxp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_15,2023-12-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 mlxlogscore=495 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060140

On Wed,  6 Dec 2023 18:02:46 +0100
Andrew Jones <ajones@ventanamicro.com> wrote:

> TEST_* functions append their own newline. Remove newlines from
> TEST_* callsites to avoid extra newlines in output.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

[...]

