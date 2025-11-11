Return-Path: <kvm+bounces-62733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A21C4C78F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1E9D64F20A2
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BC92DF14A;
	Tue, 11 Nov 2025 08:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DOiDDL38"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1962635950;
	Tue, 11 Nov 2025 08:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762851101; cv=none; b=SV+UHw5ADPUZDUelvQRniXQ4ZNj5Im4vDkzSaHfinaSvwsMcKe80LXbV13Qrny7F7SlHLMPYEu8qYFo1ZE2cJJjg1RFij6xrxJ27TkzwmbWdScZJ5yflqDvOgK4++dfGV+NImj7mim5tzrvMeqdVMpibF3CBwN7WYrVAiiTozHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762851101; c=relaxed/simple;
	bh=LiVn3Ndd0jxrn6xC6K5BkUKzg9RS7s5lr77FIH6Swps=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=IDr6PoDjF4+c2Vu7kjmNxYhRdzl4m8bQAv8geaumsYxBd8KUi1a9oaC6Lfx6wEC1+dXWSK/uH/GacQO2DlI+gSlb8uttnJGYHIEEoPGoIHQVKBDUW2z4oCYRGA6ime/OJiN/zsQDxQvm7aetj5m54bfd+oopZ6ZDOuLr61bGa5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DOiDDL38; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB0jdi1007844;
	Tue, 11 Nov 2025 08:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Wtv9oo
	AnN87OwZE0ZaMz4c14kpwTXKaWitu6AH6KBt0=; b=DOiDDL38f7P8MkWPLCVDrz
	br2CGXutvwVfc6HUWshHq3GDCzeVQSJEog8m0ORqpUZWzlhXAJ9auqsZDRy+Ui7/
	/4GkMM5W3wLCq4bblFsc2oQe4OufJyhEjuTWASyNdl2N9er232TE8uuHrHY/zCR8
	QN0hTymrvY0uHFgsQpI62W8dBhTt1Srn/xx6AqjV9imaKXY3zhO/hFFBM8P//+ew
	S6g2N3asIE5HXRWgfDPBBhMX4TXUmpVetnx2Kaa4upvhSTJQ/ziyFjentdn+yJey
	PyjhM2eAgspo52Sx1Iw8it7p0J35VsO3WxiZT3HattJRKTJasr1i9bJw3WmuCDAg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjt0q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:51:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5Z4sA014755;
	Tue, 11 Nov 2025 08:51:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpk1vek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:51:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AB8pXQo43188644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 08:51:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F40C20043;
	Tue, 11 Nov 2025 08:51:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23AC120040;
	Tue, 11 Nov 2025 08:51:33 +0000 (GMT)
Received: from darkmoore (unknown [9.111.46.253])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 08:51:33 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 09:51:27 +0100
Message-Id: <DE5QK1RDMQR7.3OEIS68GLQHK5@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
To: "Eric Farman" <farman@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand"
 <david@redhat.com>
Subject: Re: [PATCH] KVM: s390: vsie: Check alignment of BSCA header
X-Mailer: aerc 0.20.1
References: <20251107024927.1414253-1-farman@linux.ibm.com>
In-Reply-To: <20251107024927.1414253-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JB8A79t6pUHCCi9WD82agodH9WB5ARVn
X-Proofpoint-ORIG-GUID: JB8A79t6pUHCCi9WD82agodH9WB5ARVn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX1eLOm5g3dA2J
 7df/RCud62EdoKyQf++H/9Z/qoNjT+2OrdxKpllCjTkiQ6JC7QOP5vJshv9jM4tntW+HvTfhOBG
 D7q+hMauh5uHff179Xo9PjLWiWC8HF4fPTenqL2IVbP52Vl6KO9qX/foqotGcW1xoEoX16pCTlM
 wYT6cGYpL4z0Ym1+pG0CgdR5HogY3Q7LKIl/K/Ylruf3lK/QPcrJD774DItZCQEHlKmUClYTKFK
 4JeAfA3Rrj2IrWnO3rq3oqrnR/UnfAPY4gymOPlhQSEz3jLV1jl6o9ZTL7EPtVU5dED0GNHCLch
 7qSr7zxqxIDessA5CYpvhpH69IrdjmkKn8JZTnOfChEzAZ/Fzf3IwyZ63YY8m09we3t7H8Dhruk
 vf5w/ebPegALFyJ8xAU87308CWxpEA==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=6912f919 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7MZT6QB0ziOajrLXSLgA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099

On Fri Nov 7, 2025 at 3:49 AM CET, Eric Farman wrote:
> The VSIE code currently checks that the BSCA struct fits within
> a page, and returns a validity exception 0x003b if it doesn't.
> The BSCA is pinned in memory rather than shadowed (see block
> comment at end of kvm_s390_cpu_feat_init()), so enforcing the
> CPU entries to be on the same pinned page makes sense.
>
> Except those entries aren't going to be used below the guest,
> and according to the definition of that validity exception only
> the header of the BSCA (everything but the CPU entries) needs to
> be within a page. Adjust the alignment check to account for that.
>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  arch/s390/kvm/vsie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 347268f89f2f..d23ab5120888 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -782,7 +782,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct v=
sie_page *vsie_page)
>  		else if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
>  			rc =3D set_validity_icpt(scb_s, 0x0011U);
>  		else if ((gpa & PAGE_MASK) !=3D
> -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
> +			 ((gpa + offsetof(struct bsca_block, cpu[0]) - 1) & PAGE_MASK))

Did you test if this works with an esca, where the header is bigger than th=
is?
Previously the esca header was covered by the whole bsca struct.

>  			rc =3D set_validity_icpt(scb_s, 0x003bU);
>  		if (!rc) {
>  			rc =3D pin_guest_page(vcpu->kvm, gpa, &hpa);


