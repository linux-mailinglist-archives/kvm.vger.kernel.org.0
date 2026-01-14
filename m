Return-Path: <kvm+bounces-68012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C29CED1DB61
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E4BA301D9C8
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA2D37F101;
	Wed, 14 Jan 2026 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hyes/xiv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC831A08BC;
	Wed, 14 Jan 2026 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768384244; cv=none; b=RGsU5TBJP51JLoBmvtO1DCOP5g12dmvGpqJHhZcXHFoXEJZtI66gC6+hkVdyDUPQOsVCpeQT4B7nod9OiFYbgtZ37W551jhRjSqjxu5K79tO3mWdIYK/l0hdo7/mUAcBdv9nofAAatqVATJXY3QKZWwKe1dG/oeSdkzmsafeTlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768384244; c=relaxed/simple;
	bh=AKq6fmSH/uk9hmprzE9sH2DV1H6lpXWuL4PLr5uruVY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSY0Xl1AriattPSJwVp1BMIN8WcI0dmN0xfsTG6XFnE3WGkpdUUDWeonbTy5ukzSua2jlPzyFrW50vbBcRa25SBRvI+RahHcYFHGR20chjW6hzQwtVRXUgqx6TGlmnM4WToH3ZK3YccANW+dMUaPDWgeBZKQg5oUuC7e1O64RZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hyes/xiv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60E3Q0J6032216;
	Wed, 14 Jan 2026 09:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=92FYX3
	h4Mpo6R7LDAc+UsQ9sk/HSj0ypKG7zUIrUvLU=; b=Hyes/xivQfHBGO59CPHfgJ
	DIsPVr4d3MXLcmVL3DnwRxwERxb1HL7ONQXusB8wumEOLP9DMNzMjdQNisEOSzeB
	ynvWRS/+Itw9ToaILqvG7TPpvTfo5CTEkFHlPYJeq2QCU8jgbNm5uWQVfw9OB3iP
	BuTfU139aUcefKvJ4b772LBWCaoKx8QjdyWAuNEJXYxv7+/N/HFxA5Yg2FqYVzLu
	OZxZprbksT7dVXhk3O8lLTcyNsC67ylXJw5ieNabrjwX13e/B0AcY8ifdVla2Wit
	g7dJrKxQqshYpETNNx4LfeJOwJmSnMZss9m0xCUSU+TYcQyhcwExjEpeX++GQSKA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6e8dft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:50:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60E6SMV6002505;
	Wed, 14 Jan 2026 09:50:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm13ssgkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:50:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60E9oZZn51577178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:50:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5274820043;
	Wed, 14 Jan 2026 09:50:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CB0920040;
	Wed, 14 Jan 2026 09:50:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 09:50:35 +0000 (GMT)
Date: Wed, 14 Jan 2026 10:50:33 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger 
 <borntraeger@linux.ibm.com>,
        David Hildenbrand  <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
Message-ID: <20260114105033.23d3c699@p-imbrenda>
In-Reply-To: <f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
	<8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
	<f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MeTCOU4mqlL8xflEo6YzjpvJGJgq72Xw
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=696766f0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=nFgxaL2sVcJjB0vxDwoA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3OSBTYWx0ZWRfX3jylQwItDDhN
 8GbsYp7q//96kYp7FDRoTqVahwwjt7tYDBEvG/1uU0YWXmElLhyUP/13dM2J5i6L/9yZCtveXWJ
 RPP42m6KDCr1p54DxOisGBGyZLWVKWTMxe9hP19gCI+gdF8wAlXILMN1jDrDMMPrfnWsZzPBad3
 NnC7KSsjK52l0aouT6ChRoju5cnbl9sQGnjuTHiiP6dhrLODW3x4Q+jzCsboDWLuemTbwkbXuTQ
 daNb1BtqfbHg1f6NBCr4kLrZ21YEiV9e+IzBIXamKqV8Ca7tVl45+1WNwkL3Wwq8kFUDZJBfkmW
 ElnNMK8CFpfkrWJCWazXY3s/JKRhWL+n3aBGxoBRz+9z3qmbu2nf5uUDs953Q/Nb3iBJbAair2t
 DyOMMiJgokbmMeUa0j6AuXbOkEkKR/n7FcjVgZFbXReyGdbmTReyAGL36XUrBaBN56CNcOhA/C4
 +xKHts9dPKD6uhgtB+Q==
X-Proofpoint-ORIG-GUID: MeTCOU4mqlL8xflEo6YzjpvJGJgq72Xw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1011 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601140079

On Mon, 05 Jan 2026 10:46:53 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
> > On 12/17/25 04:01, Eric Farman wrote:  
> > > SIE may exit because of pending host work, such as handling an interrupt,
> > > in which case VSIE rewinds the guest PSW such that it is transparently
> > > resumed (see Fixes tag). There is still one scenario where those conditions

can you add a few words to (very briefly) explain what the scenario is?

> > > are not present, but that the VSIE processor returns with effectively rc=0,
> > > resulting in additional (and unnecessary) guest work to be performed.
> > > 
> > > For this case, rewind the guest PSW as we do in the other non-error exits.
> > > 
> > > Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host intercepts")
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>  
> > 
> > This is purely cosmetic to have all instances look the same, right?  
> 
> Nope, I can take this path with particularly high I/O loads on the system, which ends up
> (incorrectly) sending the intercept to the guest.

this is a good candidate for the explanation I mentioned above :)


(the patch itself looks fine)

